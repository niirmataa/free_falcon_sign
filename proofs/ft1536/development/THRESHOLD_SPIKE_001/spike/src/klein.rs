//! U1 — Klein MPC: prymitywy Bernoulli i konstrukcja bit-po-bicie.
//!
//! **Długa partia U1.** To **nie** jest gotowy Klein 73-bit z 2026/1300
//! ani sampler FT1536. Budujemy klocek po klocku:
//! 1. `bernoulli_half` — losowy bit {0,1} w udziałach,
//! 2. `bernoulli_exp` — accept z prawdopodobieństwem exp(-z) (Q73),
//! 3. `klein_step` — bit próbki z warunkowego Bernoulliego,
//! 4. `klein_sample_bits` — pełna próbka bit-po-bicie (U1 docelowo).
//!
//! Koszt: porównanie Q73 przez `cmp::accept_bit_from_u_shares_probed`
//! (255 Beaver/bit, I1) lub jawny oracle w fazie pomiarowej.

use crate::cmp::accept_bit_from_u_shares_probed;
use crate::rejection::{exp_neg_q73, GAUSS_Q73_ONE};
use crate::{validate_xs, Result, Share, SpikeError};

/// Losowy bit w udziałach (kryptograficzny RNG → Shamir 0/1).
pub fn bernoulli_half(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
) -> Result<Vec<Share>> {
    validate_xs(xs, k)?;
    let b = (rng.next_u32() & 1) as u8;
    crate::shamir_share(rng, b, xs, k)
}

/// Bernoulli(1/2^k) — bit=1 z prawdopodobieństwem 2^{-k} (k≥1).
pub fn bernoulli_pow2(
    rng: &mut impl rand::RngCore,
    k_exp: u32,
    xs: &[u8],
    k: u8,
) -> Result<Vec<Share>> {
    if k_exp == 0 || k_exp > 32 {
        return Err(SpikeError::WrongThreshold);
    }
    validate_xs(xs, k)?;
    let b = if (rng.next_u32() >> (32 - k_exp)) == 0 {
        1u8
    } else {
        0u8
    };
    crate::shamir_share(rng, b, xs, k)
}

/// Accept-bit z prawdopodobieństwem exp(-z) (z w Q32), jawny oracle:
/// `u < exp_neg_q73(z_q32)`, u ~ U{0..2^73-1}. Zwraca udział bitu 0/1.
///
/// Tor na udziałach (bez dealera accept) = `bernoulli_exp_shares_mpc`
/// (kolejny krok U1). Ten tor: **jawny u i waga**, wynik shared.
pub fn bernoulli_exp_clear_then_share(
    rng: &mut impl rand::RngCore,
    z_q32: u128,
    xs: &[u8],
    k: u8,
) -> Result<Vec<Share>> {
    validate_xs(xs, k)?;
    let w = exp_neg_q73(z_q32);
    let u = crate::rejection::uniform_q73_pub(rng);
    let bit = if u < w { 1u8 } else { 0u8 };
    crate::shamir_share(rng, bit, xs, k)
}

/// Waga Q73 → publiczny próg dla accept_bit (skala 0..=200 jak I2).
/// `w_q73` w [0, 2^73] → `w_pub` w [0, 200] (zaokrąglenie w dół).
pub fn q73_weight_to_pub_threshold(w_q73: u128) -> u32 {
    if w_q73 == 0 {
        return 0;
    }
    // w_pub = floor(w_q73 * 200 / 2^73)
    let scaled = w_q73 / (GAUSS_Q73_ONE / 200);
    scaled.min(200) as u32
}

/// Accept-bit na udziałach przez `cmp` (bez reconstruct u):
/// jawny `u_val` (10=accept, 250=reject jak M3) + **stały** separator
/// `w_pub=200` (M3/J2). Zmienna próg cmp gubi accept gdy thr≤10
/// (U1-RF-2). Waga Q73 decyduje o jawnej etykiecie u, nie o progu cmp.
pub fn bernoulli_q73_via_cmp(
    rng: &mut impl rand::RngCore,
    z_q32: u128,
    xs: &[u8],
    k: u8,
) -> Result<Vec<Share>> {
    validate_xs(xs, k)?;
    let w = exp_neg_q73(z_q32);
    let u_val = if w == 0 {
        250u8
    } else {
        let u = crate::rejection::uniform_q73_pub(rng);
        if u < w {
            10u8
        } else {
            250u8
        }
    };
    let us = crate::shamir_share(rng, u_val, xs, k)?;
    let us_u8: Vec<u8> = us.iter().map(|s| s.share).collect();
    // stały separator 200 jak M3 — 10 < 200 = accept, 250 > 200 = reject
    let a = accept_bit_from_u_shares_probed(rng, xs, k, &us_u8, 200)?;
    Ok(xs
        .iter()
        .zip(a)
        .map(|(&x, share)| Share { x, share })
        .collect())
}

/// Otwarcie bitu („moment") — k=2, xs=[1,2,3] w testach.
pub fn open_bit(shares: &[Share], xs: &[u8], k: u8) -> Result<u8> {
    if shares.len() != xs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    let refs: Vec<&Share> = shares.iter().collect();
    crate::reconstruct(&refs)?;
    let _ = k;
    // reconstruct interpoluje z wszystkich udziałów — OK dla spójnych
    let mut acc = 0u8;
    for (i, s) in shares.iter().enumerate() {
        let lam = crate::mul::lagrange_at_zero(xs, i)?;
        acc ^= crate::gf_mul(lam, s.share);
    }
    Ok(acc)
}

// ─── U1-B: konstrukcja bit-po-bicie (Klein step) ─────────────────────────

/// Upraszczony krok Kleina (model pomiarowy, **nie** pełny 73-bit):
/// bit `i` próbki x ∈ {-w..w} wybierany przez Bernoulli z prawdopodobieństwem
/// warunkowym zależnym od wag Q73 lewej/prawej połówki przedziału.
///
/// **Oracle jasny** (wagi Q73 + u) → bit w udziałach. Pełny Klein na
/// udziałach (accept-bit bez otwierania u) = kolejny krok U1.
pub struct KleinState {
    /// Lewa krawędź przedziału (włącznie).
    pub lo: i32,
    /// Prawa krawędź (włącznie).
    pub hi: i32,
    /// Waga Q73 lewej połówki (suma) — utrzymywana w kroku.
    pub w_lo: u128,
    /// Waga Q73 prawej połówki.
    pub w_hi: u128,
}

/// Inicjalizacja: przedział {-w..=w}, wagi połówek z `gauss_weight_q73`.
pub fn klein_state_init(w: i32, sigma_q73: u128) -> KleinState {
    let mut w_lo = 0u128;
    let mut w_hi = 0u128;
    let mid = 0; // |x| vs 0: lewa = x<0, prawa = x>=0
    for x in -w..=w {
        let wt = crate::rejection::gauss_weight_q73(x, sigma_q73);
        if x < mid {
            w_lo = w_lo.saturating_add(wt);
        } else {
            w_hi = w_hi.saturating_add(wt);
        }
    }
    KleinState {
        lo: -w,
        hi: w,
        w_lo,
        w_hi,
    }
}

/// P(right)=w_hi/total w Q32 bez overflow (U1-RF-3).
/// Dla w_hi ≥ 2^96 redukujemy obie strony przez >>40 zanim <<32.
fn prob_right_q32(w_hi: u128, total: u128) -> Result<u128> {
    if total == 0 {
        return Err(SpikeError::WrongThreshold);
    }
    if w_hi >= total {
        return Ok(1u128 << 32);
    }
    let shift = if w_hi > (u128::MAX >> 32) { 40u32 } else { 0u32 };
    let w = w_hi >> shift;
    let t = total >> shift;
    if t == 0 {
        return Ok(1u128 << 32);
    }
    Ok(((w << 32) / t).min(1u128 << 32))
}

/// Losuje bit z P(right)=w_hi/total (oracle u).
fn cmp_prob_right(rng: &mut impl rand::RngCore, w_hi: u128, total: u128) -> Result<bool> {
    let p_q32 = prob_right_q32(w_hi, total)?;
    let u = crate::rejection::uniform_q73_pub(rng);
    let u_q32 = u >> 41;
    Ok(u_q32 < p_q32)
}

/// Jeden krok: zwraca bit (0=lewa, 1=prawa) + zaktualizowany stan.
/// P(bit=1) = w_hi / (w_lo + w_hi).
pub fn klein_step(
    rng: &mut impl rand::RngCore,
    st: &mut KleinState,
    xs: &[u8],
    k: u8,
) -> Result<Vec<Share>> {
    let total = st.w_lo.saturating_add(st.w_hi);
    if total == 0 {
        return Err(SpikeError::WrongThreshold);
    }
    let take_right = cmp_prob_right(rng, st.w_hi, total)?;
    let bit = if take_right { 1u8 } else { 0u8 };
    // zawężenie przedziału (model połówkowy — nie pełny Klein 73-bit)
    if st.hi > st.lo {
        let mid = (st.lo + st.hi) / 2;
        if bit == 1 {
            st.lo = mid + 1;
            st.w_lo = st.w_hi / 2;
            st.w_hi = st.w_hi - st.w_lo;
        } else {
            st.hi = mid;
            st.w_hi = st.w_lo / 2;
            st.w_lo = st.w_lo - st.w_hi;
        }
    }
    crate::shamir_share(rng, bit, xs, k)
}

/// Próbka bit-po-bicie: `n_bits` kroków → bity w udziałach + finalny x (oracle).
pub fn klein_sample_bits(
    rng: &mut impl rand::RngCore,
    w: i32,
    sigma_q73: u128,
    n_bits: u32,
    xs: &[u8],
    k: u8,
) -> Result<(Vec<Vec<Share>>, i32)> {
    if w < 1 {
        return Err(SpikeError::WrongThreshold);
    }
    let mut st = klein_state_init(w, sigma_q73);
    let mut bits = Vec::with_capacity(n_bits as usize);
    let mut x = st.lo;
    for _ in 0..n_bits {
        let b = klein_step(rng, &mut st, xs, k)?;
        // oracle: aktualizuj x na podstawie otwartego bitu (moment testowy)
        let bit = open_bit(&b, xs, k)?;
        let mid = (st.lo + st.hi) / 2;
        // po klein_step stan już zawężony; x = midpoint finalny
        let _ = (bit, mid);
        x = (st.lo + st.hi) / 2;
        bits.push(b);
    }
    Ok((bits, x))
}

// ─── U1-C: warunkowe Bernoulli + accept bez otwierania u ────────────────

/// Suma wag Q73 na przedziale [a, b].
pub fn q73_range_weight(a: i32, b: i32, sigma_q73: u128) -> u128 {
    let mut s = 0u128;
    for x in a..=b {
        s = s.saturating_add(crate::rejection::gauss_weight_q73(x, sigma_q73));
    }
    s
}

/// Warunkowe Bernoulli: P(lewa | przedział) = w_lo / (w_lo + w_hi).
/// Zwraca udział bitu (0=lewa, 1=prawa) — oracle u, wynik shared.
pub fn klein_cond_bernoulli(
    rng: &mut impl rand::RngCore,
    w_lo: u128,
    w_hi: u128,
    xs: &[u8],
    k: u8,
) -> Result<Vec<Share>> {
    let total = w_lo.saturating_add(w_hi);
    if total == 0 {
        return Err(SpikeError::WrongThreshold);
    }
    let take_right = cmp_prob_right(rng, w_hi, total)?;
    let bit = if take_right { 1u8 } else { 0u8 };
    crate::shamir_share(rng, bit, xs, k)
}

/// Klein-C: bit-by-bit z **warunkowymi** wagami Q73 (nie połówki).
/// Każdorazowo przelicza sumy wag podprzedziałów [lo, mid] i [mid+1, hi].
/// Otwarcie bitów tylko w oracle testowym (`open_bit`).
pub fn klein_sample_cond_bits(
    rng: &mut impl rand::RngCore,
    w: i32,
    sigma_q73: u128,
    n_bits: u32,
    xs: &[u8],
    k: u8,
) -> Result<(Vec<Vec<Share>>, i32)> {
    if w < 1 {
        return Err(SpikeError::WrongThreshold);
    }
    if sigma_q73 == 0 {
        return Err(SpikeError::WrongThreshold);
    }
    let mut lo = -w;
    let mut hi = w;
    let mut bits = Vec::with_capacity(n_bits as usize);
    for _ in 0..n_bits {
        if lo >= hi {
            break;
        }
        let mid = lo + (hi - lo) / 2;
        let w_lo = q73_range_weight(lo, mid, sigma_q73);
        let w_hi = q73_range_weight(mid + 1, hi, sigma_q73);
        let b = klein_cond_bernoulli(rng, w_lo, w_hi, xs, k)?;
        let bit = open_bit(&b, xs, k)?; // moment testowy
        if bit == 1 {
            lo = mid + 1;
        } else {
            hi = mid;
        }
        bits.push(b);
    }
    // Doprowadź do pojedynczego x (lo==hi) — inaczej midpoint jest bias
    while lo < hi {
        let mid = lo + (hi - lo) / 2;
        let w_lo = q73_range_weight(lo, mid, sigma_q73);
        let w_hi = q73_range_weight(mid + 1, hi, sigma_q73);
        let b = klein_cond_bernoulli(rng, w_lo, w_hi, xs, k)?;
        let bit = open_bit(&b, xs, k)?;
        if bit == 1 {
            lo = mid + 1;
        } else {
            hi = mid;
        }
    }
    Ok((bits, lo))
}

/// Accept-bit na udziałach **bez otwierania u** dla całego okna
/// (jak M3, ale z wagami Q73): jawny oracle wag + `cmp` na udziałach u.
/// Zwraca wektor accept-bits (udziały).
pub fn accept_window_q73_no_open_u(
    rng: &mut impl rand::RngCore,
    candidates: &[i32],
    sigma_q73: u128,
    xs: &[u8],
    k: u8,
) -> Result<Vec<Vec<Share>>> {
    validate_xs(xs, k)?;
    let mut out = Vec::with_capacity(candidates.len());
    for &x in candidates {
        let w = crate::rejection::gauss_weight_q73(x, sigma_q73);
        let thr = q73_weight_to_pub_threshold(w);
        let u_val = if thr == 0 {
            250u8
        } else {
            let u = crate::rejection::uniform_q73_pub(rng);
            if u < w {
                10u8
            } else {
                250u8
            }
        };
        let us = crate::shamir_share(rng, u_val, xs, k)?;
        let us_u8: Vec<u8> = us.iter().map(|s| s.share).collect();
        // stały separator 200 (U1-RF-2) — thr nie jest progiem cmp
        let _ = thr;
        let a = crate::cmp::accept_bit_from_u_shares_probed(rng, xs, k, &us_u8, 200)?;
        out.push(
            xs.iter()
                .zip(a)
                .map(|(&x, share)| Share { x, share })
                .collect(),
        );
    }
    Ok(out)
}

/// TV empiria |x| z `klein_sample_cond_bits` vs analityczna Gaussa.
/// Statystyka f64 (A6). `n` próbek, `n_bits` bitów na próbkę.
pub fn measure_klein_cond_vs_analytical(
    rng: &mut impl rand::RngCore,
    w: i32,
    sigma_q73: u128,
    sigma_real: f64,
    n_bits: u32,
    n: u32,
    xs: &[u8],
    k: u8,
) -> Result<crate::rejection::TargetBias> {
    use crate::rejection::target_gaussian_analytical_absx_pmf;
    if w < 1 || sigma_q73 == 0 {
        return Err(SpikeError::WrongThreshold);
    }
    let mut hist = vec![0.0f64; (w + 1) as usize];
    let mut got = 0u32;
    for _ in 0..n {
        let (_bits, x) = klein_sample_cond_bits(rng, w, sigma_q73, n_bits, xs, k)?;
        let a = x.abs().min(w) as usize;
        hist[a] += 1.0;
        got += 1;
    }
    let target = target_gaussian_analytical_absx_pmf(w, sigma_real);
    let mut tv = 0.0f64;
    let mut max_rel_err = 0.0f64;
    if got > 0 {
        for b in 0..=w as usize {
            let emp = hist[b] / got as f64;
            let exp = target[b];
            tv += (emp - exp).abs();
            if exp > 1e-9 {
                let rel = ((emp - exp) / exp).abs();
                if rel > max_rel_err {
                    max_rel_err = rel;
                }
            }
        }
    }
    Ok(crate::rejection::TargetBias {
        samples: got,
        tv_distance: tv / 2.0,
        max_rel_err,
    })
}

#[cfg(test)]
mod tests_u1_bernoulli {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    const XS: [u8; 3] = [1, 2, 3];
    const K: u8 = 2;

    #[test]
    fn u1_bernoulli_half_is_bit() {
        let mut rng = StdRng::seed_from_u64(0x51_0001);
        let mut ones = 0;
        for _ in 0..20 {
            let sh = bernoulli_half(&mut rng, &XS, K).unwrap();
            let b = open_bit(&sh, &XS, K).unwrap();
            assert!(b == 0 || b == 1);
            ones += b as u32;
        }
        // oba bity muszą wystąpić przy 20 rzutach (prawie pewne)
        assert!(ones > 0 && ones < 20, "ones={ones}");
    }

    #[test]
    fn u1_bernoulli_exp_z0_is_one() {
        // exp(0)=1 → accept zawsze
        let mut rng = StdRng::seed_from_u64(0x51_0002);
        for _ in 0..8 {
            let sh = bernoulli_exp_clear_then_share(&mut rng, 0, &XS, K).unwrap();
            assert_eq!(open_bit(&sh, &XS, K).unwrap(), 1);
        }
    }

    #[test]
    fn u1_bernoulli_exp_large_z_is_zero() {
        // exp(-50)=0 w Q73 → accept nigdy
        let mut rng = StdRng::seed_from_u64(0x51_0003);
        let z = 50u128 << 32;
        for _ in 0..8 {
            let sh = bernoulli_exp_clear_then_share(&mut rng, z, &XS, K).unwrap();
            assert_eq!(open_bit(&sh, &XS, K).unwrap(), 0);
        }
    }

    #[test]
    fn u1_q73_weight_to_threshold() {
        assert_eq!(q73_weight_to_pub_threshold(0), 0);
        assert_eq!(q73_weight_to_pub_threshold(GAUSS_Q73_ONE), 200);
        // połowa → 100
        let half = q73_weight_to_pub_threshold(GAUSS_Q73_ONE / 2);
        assert!((99..=100).contains(&half), "half={half}");
    }

    #[test]
    fn u1_bernoulli_via_cmp_produces_bit_shares() {
        let mut rng = StdRng::seed_from_u64(0x51_0004);
        let sh = bernoulli_q73_via_cmp(&mut rng, 1u128 << 31, &XS, K).unwrap();
        assert_eq!(sh.len(), 3);
        let b = open_bit(&sh, &XS, K).unwrap();
        assert!(b == 0 || b == 1);
    }

    #[test]
    fn u1_exp_freq_matches_q73() {
        // Statystyka: przy z=ln(2)≈0.693 accept ~50% (oracle clear-then-share)
        let mut rng = StdRng::seed_from_u64(0x51_0005);
        let z = (0.693147f64 * (1u128 << 32) as f64) as u128;
        let mut ones = 0u32;
        let n = 200;
        for _ in 0..n {
            let sh = bernoulli_exp_clear_then_share(&mut rng, z, &XS, K).unwrap();
            ones += open_bit(&sh, &XS, K).unwrap() as u32;
        }
        let f = ones as f64 / n as f64;
        assert!((0.35..0.65).contains(&f), "freq={f}");
    }

    #[test]
    fn u1_klein_state_init_weights() {
        let sigma = 2 * GAUSS_Q73_ONE;
        let st = klein_state_init(8, sigma);
        assert_eq!(st.lo, -8);
        assert_eq!(st.hi, 8);
        assert!(st.w_lo > 0 && st.w_hi > 0);
    }

    #[test]
    fn u1_klein_step_bit_shares() {
        let mut rng = StdRng::seed_from_u64(0x51_0006);
        let sigma = 2 * GAUSS_Q73_ONE;
        let mut st = klein_state_init(4, sigma);
        let b = klein_step(&mut rng, &mut st, &XS, K).unwrap();
        let bit = open_bit(&b, &XS, K).unwrap();
        assert!(bit == 0 || bit == 1);
    }

    #[test]
    fn u1_klein_sample_bits_len() {
        let mut rng = StdRng::seed_from_u64(0x51_0007);
        let sigma = GAUSS_Q73_ONE;
        let (bits, _x) = klein_sample_bits(&mut rng, 4, sigma, 6, &XS, K).unwrap();
        assert_eq!(bits.len(), 6);
        for b in &bits {
            assert_eq!(b.len(), 3);
        }
    }

    // ─── U1-C ─────────────────────────────────────────────────────────

    #[test]
    fn u1c_q73_range_weight_symmetric() {
        let sigma = 2 * GAUSS_Q73_ONE;
        let a = q73_range_weight(-4, -1, sigma);
        let b = q73_range_weight(1, 4, sigma);
        // |x| symetria — ±1..4 równe
        assert_eq!(a, b, "symetria wag");
        assert!(q73_range_weight(0, 0, sigma) > 0);
    }

    #[test]
    fn u1c_cond_bernoulli_bit() {
        let mut rng = StdRng::seed_from_u64(0x51_C001);
        for _ in 0..10 {
            let sh = klein_cond_bernoulli(&mut rng, 3 * GAUSS_Q73_ONE, GAUSS_Q73_ONE, &XS, K)
                .unwrap();
            let b = open_bit(&sh, &XS, K).unwrap();
            assert!(b == 0 || b == 1);
        }
    }

    #[test]
    fn u1c_cond_sample_bits_len() {
        let mut rng = StdRng::seed_from_u64(0x51_C002);
        let sigma = 2 * GAUSS_Q73_ONE;
        let (bits, x) = klein_sample_cond_bits(&mut rng, 8, sigma, 5, &XS, K).unwrap();
        // może skończyć wcześniej gdy lo==hi (zawężenie do punktu)
        assert!(bits.len() >= 1 && bits.len() <= 5, "len={}", bits.len());
        assert!((-8..=8).contains(&x), "x={x}");
    }

    #[test]
    fn u1c_accept_window_no_open_u() {
        let mut rng = StdRng::seed_from_u64(0x51_C003);
        let sigma = 2 * GAUSS_Q73_ONE;
        let cands = vec![-2, -1, 0, 1, 2];
        let acc = accept_window_q73_no_open_u(&mut rng, &cands, sigma, &XS, K).unwrap();
        assert_eq!(acc.len(), 5);
        for a in &acc {
            assert_eq!(a.len(), 3);
            let b = open_bit(a, &XS, K).unwrap();
            assert!(b == 0 || b == 1);
        }
    }

    #[test]
    fn u1c_cond_vs_analytical_tv() {
        let mut rng = StdRng::seed_from_u64(0x51_C004);
        let sigma = 2 * GAUSS_Q73_ONE;
        // n_bits=6 (w=8 → 4 bity wystarczają na zawężenie), n=80 próbek
        let b = measure_klein_cond_vs_analytical(&mut rng, 8, sigma, 2.0, 6, 80, &XS, K).unwrap();
        assert_eq!(b.samples, 80);
        // model połówkowy/kaflowy — TV luźne (nie deklarować Klein-exact)
        assert!(b.tv_distance < 0.45, "TV={}", b.tv_distance);
    }

    #[test]
    fn u1c_fail_closed() {
        let mut rng = StdRng::seed_from_u64(0x51_C005);
        assert!(klein_cond_bernoulli(&mut rng, 0, 0, &XS, K).is_err());
        assert!(klein_sample_cond_bits(&mut rng, 0, GAUSS_Q73_ONE, 3, &XS, K).is_err());
        assert!(klein_sample_cond_bits(&mut rng, 4, 0, 3, &XS, K).is_err());
    }

    #[test]
    fn u1c_mut_overflow_cmp_detected() {
        // Realna mutacja U1-RF-1: gdyby wciąż był saturating w cond,
        // próbkowanie skupiałoby się w 1 punkcie (distinct_x≈1).
        // Po naprawie: wiele punktów + TV vs analityka zielone.
        let mut rng = StdRng::seed_from_u64(0x51_C006);
        let sigma = 2 * GAUSS_Q73_ONE;
        let mut xs_set = std::collections::HashSet::new();
        for _ in 0..30 {
            let (_b, x) = klein_sample_cond_bits(&mut rng, 8, sigma, 8, &XS, K).unwrap();
            xs_set.insert(x);
        }
        assert!(
            xs_set.len() > 3,
            "rozklad skupiony w {} punktach — bias (U1-RF-1)?",
            xs_set.len()
        );
    }

    #[test]
    fn u1d_klein_step_freq_matches_w() {
        // Rozkład klein_step: P(right)≈w_hi/total (naprawa U1-RF-1 w step)
        let mut rng = StdRng::seed_from_u64(0x51_D002);
        let sigma = 2 * GAUSS_Q73_ONE;
        let st = klein_state_init(8, sigma);
        let total = st.w_lo + st.w_hi;
        let p_right = st.w_hi as f64 / total as f64;
        let mut rights = 0u32;
        let n = 300;
        for _ in 0..n {
            let mut st2 = klein_state_init(8, sigma);
            let b = klein_step(&mut rng, &mut st2, &XS, K).unwrap();
            rights += open_bit(&b, &XS, K).unwrap() as u32;
        }
        let f = rights as f64 / n as f64;
        assert!(
            (p_right - 0.12..p_right + 0.12).contains(&f),
            "freq_right={f} expected≈{p_right}"
        );
    }

    #[test]
    fn u1d_accept_thr_leq_10() {
        // U1-RF-2: accept 10/250 z progiem cmp ≤10 gubi accept.
        // Po fixie: stały separator 200 — działa też dla małych wag.
        let mut rng = StdRng::seed_from_u64(0x51_D003);
        // z bardzo duże → w≈0 → nigdy accept; z=0 → w=2^73 → zawsze accept
        for _ in 0..6 {
            let a = bernoulli_q73_via_cmp(&mut rng, 0, &XS, K).unwrap();
            assert_eq!(open_bit(&a, &XS, K).unwrap(), 1, "z=0 → accept");
            let big = bernoulli_q73_via_cmp(&mut rng, 50u128 << 32, &XS, K).unwrap();
            assert_eq!(open_bit(&big, &XS, K).unwrap(), 0, "z=50 → reject");
        }
    }

    #[test]
    fn u1d_bernoulli_pow2() {
        let mut rng = StdRng::seed_from_u64(0x51_D004);
        let mut ones = 0u32;
        let n = 200;
        for _ in 0..n {
            let b = bernoulli_pow2(&mut rng, 2, &XS, K).unwrap(); // p=1/4
            ones += open_bit(&b, &XS, K).unwrap() as u32;
        }
        let f = ones as f64 / n as f64;
        assert!((0.10..0.45).contains(&f), "freq(1/4)={f}");
        assert!(bernoulli_pow2(&mut rng, 0, &XS, K).is_err());
    }

    #[test]
    fn u1d_large_weight_cmp_prob() {
        // U1-RF-3: w_hi ≥ 2^96 nie może cicho zerować p_q32
        let huge = 1u128 << 100; // > 2^96
        let total = huge + 1;
        let mut rights = 0;
        for i in 0..20 {
            let mut rng = StdRng::seed_from_u64(0x51_D005 + i as u64);
            if cmp_prob_right(&mut rng, huge, total).unwrap() {
                rights += 1;
            }
        }
        assert!(rights >= 15, "rights={rights} przy p≈1 (wrap p_q32?)");
    }

    #[test]
    fn u1d_pins_range_weight_frozen() {
        // Piny Q73: W(0)=2^73, suma [-2..2] przy σ=1 — stałe regresji
        assert_eq!(q73_range_weight(0, 0, GAUSS_Q73_ONE), GAUSS_Q73_ONE);
        let s = q73_range_weight(-2, 2, GAUSS_Q73_ONE);
        // Zamrożony pin (pierwszy przebieg) — zmiana exp_neg_q73 = FAIL
        assert_eq!(
            s, 23458184420803307425338u128,
            "q73_range_weight(-2..2, σ=1) FNV/wartość pin"
        );
    }

    #[test]
    fn u1d_cost_accept_window_counts_cmp() {
        // Koszt: 5 kandydatów × accept_bit = 5 × 255 Beaver (I1)
        crate::cost::reset();
        let mut rng = StdRng::seed_from_u64(0x51_D001);
        let sigma = 2 * GAUSS_Q73_ONE;
        let cands: Vec<i32> = (-2..=2).collect();
        let _ = accept_window_q73_no_open_u(&mut rng, &cands, sigma, &XS, K).unwrap();
        let triples = crate::cost::triple_count();
        // accept_bit_from_u_shares_probed generuje trójki — ≥ 5 (luźno)
        assert!(triples >= 5, "triples={triples}");
    }
}
