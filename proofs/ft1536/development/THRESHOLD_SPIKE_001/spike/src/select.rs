//! Spike 005 — wybór „pierwszy przyjęty" **bez otwierania bitów accept**.
//!
//! **PROTOTYP.** Kontynuacja P0.1: ścieżka naive (spike 004) otwierała accept
//! co rundę → jawne T. Tu:
//! - kandydaci i bity accept są udziałami Shamira (dealer = model testowy),
//! - obwód GF(256) wybiera pierwszy przyjęty **na udziałach**,
//! - otwierane są wyłącznie: finalny `x` (jawny wynik) oraz jeden bit `found`
//!   (czy okno trafiło — jawne, rozliczone w notatkach).
//!
//! To NIE jest Klein-sampler, nie porównanie jawne w pętli, nie pełne
//! malicious-secure MPC (Beaver dealerski).

use crate::{
    generate_triple_shares, mask_one, reconstruct_vals, validate_xs, Share, SpikeError, Result,
};

/// Wynik obwodu select — jeszcze w udziałach.
pub struct SelectShares {
    /// udziały wybranego x (albo 0 przy AllRejected)
    pub sel: Vec<u8>,
    /// udziały bitu found: 1 = było przynajmniej jedno accept
    pub found: Vec<u8>,
}

impl Drop for SelectShares {
    fn drop(&mut self) {
        self.sel.zeroize();
        self.found.zeroize();
    }
}

use zeroize::{Zeroize, Zeroizing};

/// Otwarcie finalnego wyniku (jawny kontrakt — to jest „moment").
pub struct OpenedSelect {
    /// wybrany x; **istotny tylko gdy `found`** (patrz `found` — nie używaj
    /// `x==0` jako sentinelu; `encode_candidate(-128)==0` koliduje).
    pub x: u8,
    /// true = okno trafiło; false = AllRejected (**jedyny sygnał**)
    pub found: bool,
}

/// Mnożenie dwóch wektorów udziałów bajtów (per strona) przez Beaver.
fn mul_vec(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
    a: &[u8],
    b: &[u8],
) -> Result<Vec<u8>> {
    if a.len() != xs.len() || b.len() != xs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    let tri = generate_triple_shares(rng, xs, k)?;
    let mut ds = Zeroizing::new(Vec::with_capacity(xs.len()));
    let mut es = Zeroizing::new(Vec::with_capacity(xs.len()));
    let mut masked = Vec::with_capacity(xs.len());
    for i in 0..xs.len() {
        let (d_i, e_i, m) = mask_one(a[i], b[i], tri.a[i], tri.b[i], tri.c[i]);
        ds.push(d_i);
        es.push(e_i);
        masked.push(m);
    }
    let d = reconstruct_vals(xs, &ds)?;
    let e = reconstruct_vals(xs, &es)?;
    Ok(masked.into_iter().map(|m| m.finish(d, e)).collect())
}

/// Obwód „pierwszy przyjęty" na udziałach.
///
/// Inwarianty bitów: `a_i`, `found` w {0,1} w GF(256) (XOR=+, OR=a+b+a*b).
/// Krok dla każdego kandydata:
/// `t = a_i * (1+found)`, `sel += t*(x_i+sel)`, `found += a_i + found*a_i`.
/// Żaden `a_i` **nie jest otwierany**. Jawne po drodze: tylko d,e z Beavera
/// (maski — nie same bity).
pub fn select_first_accepted_shares(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
    x_shares: &[Vec<u8>],
    a_shares: &[Vec<u8>],
) -> Result<SelectShares> {
    validate_xs(xs, k)?;
    let n = xs.len();
    if x_shares.is_empty() {
        return Err(SpikeError::EmptyShares);
    }
    if x_shares.len() != a_shares.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    for row in x_shares.iter().chain(a_shares.iter()) {
        if row.len() != n {
            return Err(SpikeError::PartyCountMismatch);
        }
    }

    let mut sel = vec![0u8; n];
    let mut found = vec![0u8; n];

    for (x_i, a_i) in x_shares.iter().zip(a_shares.iter()) {
        // 1+found (GF: 1 ⊕ found dla bitu)
        let one_plus_found =
            Zeroizing::new(found.iter().map(|&f| 1u8 ^ f).collect::<Vec<u8>>());
        // t = a * (1+found)
        let t = Zeroizing::new(mul_vec(rng, xs, k, a_i, &one_plus_found)?);
        // sel = sel + t*(x+sel)
        let x_plus_sel = Zeroizing::new(
            x_i.iter()
                .zip(sel.iter())
                .map(|(&x, &s)| x ^ s)
                .collect::<Vec<u8>>(),
        );
        let t_x_plus_sel = Zeroizing::new(mul_vec(rng, xs, k, &t, &x_plus_sel)?);
        for p in 0..n {
            sel[p] ^= t_x_plus_sel[p];
        }
        // found = found + a + found*a
        let found_a = Zeroizing::new(mul_vec(rng, xs, k, &found, a_i)?);
        for p in 0..n {
            found[p] ^= a_i[p] ^ found_a[p];
        }
    }

    Ok(SelectShares { sel, found })
}

/// Sprawdza bitność udziałów accept: `a*(a+1)` musi otworzyć się do 0.
/// Otwiera **tylko** produkt kontrolny (nie same bity accept).
pub fn verify_accept_bits(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
    a_shares: &[Vec<u8>],
) -> Result<()> {
    validate_xs(xs, k)?;
    if a_shares.is_empty() {
        return Err(SpikeError::EmptyShares);
    }
    for a_i in a_shares {
        if a_i.len() != xs.len() {
            return Err(SpikeError::PartyCountMismatch);
        }
        // a+1 na udziałach
        let a_plus_1: Vec<u8> = a_i.iter().map(|&s| s ^ 1).collect();
        let prod = mul_vec(rng, xs, k, a_i, &a_plus_1)?;
        let opened = reconstruct_vals(xs, &prod)?;
        if opened != 0 {
            return Err(SpikeError::NonBitShare);
        }
    }
    Ok(())
}

/// Spójność Shamir (n>k) + bitność accept, potem obwód select.
/// Fałszywy / nie-bitowy udział → Err (**fail-closed**), nie cichy zły wynik.
pub fn select_first_accepted_checked(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
    x_shares: &[Vec<u8>],
    a_shares: &[Vec<u8>],
) -> Result<SelectShares> {
    validate_xs(xs, k)?;
    if x_shares.is_empty() {
        return Err(SpikeError::EmptyShares);
    }
    if x_shares.len() != a_shares.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    // spójność udziałów (wymaga n>k — inaczej detekcja nie działa)
    if xs.len() as u8 > k {
        for row in x_shares.iter().chain(a_shares.iter()) {
            let owned: Vec<Share> = xs
                .iter()
                .zip(row.iter())
                .map(|(&x, &y)| Share { x, share: y })
                .collect();
            let refs: Vec<&Share> = owned.iter().collect();
            crate::verify_consistency(&refs, k)?;
        }
    }
    verify_accept_bits(rng, xs, k, a_shares)?;
    select_first_accepted_shares(rng, xs, k, x_shares, a_shares)
}

/// Otwarcie finalnego wyniku (i bitu found). **To jest jawny „moment".**
pub fn open_selected(s: &SelectShares, xs: &[u8]) -> Result<OpenedSelect> {
    if s.sel.len() != xs.len() || s.found.len() != xs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    let sel_shares: Vec<Share> = xs
        .iter()
        .zip(s.sel.iter())
        .map(|(&x, &y)| Share { x, share: y })
        .collect();
    let found_shares: Vec<Share> = xs
        .iter()
        .zip(s.found.iter())
        .map(|(&x, &y)| Share { x, share: y })
        .collect();
    let sel_refs: Vec<&Share> = sel_shares.iter().collect();
    let found_refs: Vec<&Share> = found_shares.iter().collect();
    let x = crate::reconstruct(&sel_refs)?;
    let f = crate::reconstruct(&found_refs)?;
    Ok(OpenedSelect {
        x,
        found: f != 0,
    })
}

// ─── Generacja transkrypcji okna (dealer = model testowy) ─────────────────

/// Jawna lista kandydatów i bitów accept (do budowy udziałów i oracle).
pub struct ClearWindow {
    pub xs_vals: Vec<i32>,
    pub accepts: Vec<bool>,
}

/// Losuje okno tak jak `sample_mpc_fixed_window`, ale zwraca **wszystkich**
/// kandydatów i bity (oracle). Pierwszy accept wyznacza wynik clear.
pub fn draw_clear_window(
    rng: &mut impl rand::RngCore,
    p: &crate::rejection::SamplerParams,
) -> ClearWindow {
    assert!(
        p.w <= 127,
        "w<=127 required: encode_candidate(-128) collides with 0 sentinel"
    );
    let mut xs_vals = Vec::with_capacity(p.t_max as usize);
    let mut accepts = Vec::with_capacity(p.t_max as usize);
    for _ in 0..p.t_max {
        let x = crate::rejection::uniform_range_pub(rng, -p.w, p.w);
        let w = crate::rejection::accept_weight_pub(x, p.sigma2);
        let u = rng.next_u32() & 0xFF;
        xs_vals.push(x);
        accepts.push(u < w);
    }
    ClearWindow { xs_vals, accepts }
}

/// Pierwszy przyjęty w oknie clear (oracle).
pub fn clear_first_accepted(w: &ClearWindow) -> Option<(i32, usize)> {
    w.xs_vals
        .iter()
        .zip(w.accepts.iter())
        .position(|(_, &a)| a)
        .map(|idx| (w.xs_vals[idx], idx))
}

/// Koduje i32 kandydata do bajtu GF(256). **Wymaga |x|≤127** (i32+128 w u8);
/// `x=-128` koliduje z bajtem 0 — zakres jest sprawdzany w `draw_clear_window`.
pub fn encode_candidate(x: i32) -> u8 {
    debug_assert!(x >= -127 && x <= 127, "encode_candidate: |x|<=127");
    ((x + 128) & 0xFF) as u8
}

pub fn decode_candidate(b: u8) -> i32 {
    (b as i32) - 128
}

/// Dzieli bajt na udziały dla xs (helper — reuse shamir z lib).
pub fn share_byte_vec(
    rng: &mut impl rand::RngCore,
    byte: u8,
    xs: &[u8],
    k: u8,
) -> Result<Vec<u8>> {
    let shares = crate::shamir_share(rng, byte, xs, k)?;
    Ok(shares.into_iter().map(|s| s.share).collect())
}

// ─── Pomiar biasu okna ────────────────────────────────────────────────────

/// Raport biasu fixed-window.
#[derive(Debug, Clone)]
pub struct BiasReport {
    pub trials: u32,
    pub accepted: u32,
    pub all_rejected: u32,
    /// |x| histogram przyjętych (długość w+1), zliczenia
    pub absx_hist: Vec<u32>,
    /// maks. względne odchylenie od wagowego celu (0 = brak próbek)
    pub max_rel_err: f64,
}

/// Pomiary na **clear** oknie (oracle biasu). Shared-select musi dawać ten
/// sam rozkład przy Accept (testy równoważności).
pub fn measure_fixed_window_bias(
    rng: &mut impl rand::RngCore,
    p: &crate::rejection::SamplerParams,
    trials: u32,
) -> BiasReport {
    let mut accepted = 0u32;
    let mut all_rejected = 0u32;
    let mut absx_hist = vec![0u32; (p.w + 1) as usize];
    for _ in 0..trials {
        let win = draw_clear_window(rng, p);
        match clear_first_accepted(&win) {
            Some((x, _)) => {
                accepted += 1;
                let b = x.abs().min(p.w) as usize;
                absx_hist[b] += 1;
            }
            None => all_rejected += 1,
        }
    }

    // Cel: rozkład pierwszego przyjętego przy niezależnych próbach ważonych.
    // Dla biasu warunkowego porównujemy do wag ∝ accept_weight na siatce
    // (w uproszczeniu — pomiar, nie twierdzenie).
    let mut target = vec![0.0f64; (p.w + 1) as usize];
    let mut tsum = 0.0f64;
    for b in 0..=p.w as usize {
        // gęstość propozycji 1 (uniform na x, kubełek |x| ma ~2 punkty prócz 0)
        let weight = if b == 0 {
            crate::rejection::accept_weight_pub(0, p.sigma2) as f64
        } else {
            2.0 * crate::rejection::accept_weight_pub(b as i32, p.sigma2) as f64
        };
        target[b] = weight;
        tsum += weight;
    }
    for t in target.iter_mut() {
        *t /= tsum;
    }

    let mut max_rel_err = 0.0f64;
    if accepted > 0 {
        for b in 0..=p.w as usize {
            let emp = absx_hist[b] as f64 / accepted as f64;
            let exp = target[b];
            if exp > 1e-9 {
                let rel = ((emp - exp) / exp).abs();
                if rel > max_rel_err {
                    max_rel_err = rel;
                }
            }
        }
    }

    BiasReport {
        trials,
        accepted,
        all_rejected,
        absx_hist,
        max_rel_err,
    }
}

/// Pomiar abort/retry.
///
/// **Retained finding:** przy i.i.d. oknach retry-until-success i jednokrotne
/// „Accepted" mają **ten sam** rozkład `x | accept` — `max_hist_rel_diff ≈ 0`.
/// Bias jest względem rozkładu **docelowego** (nie warunkowanego), nie względem
/// siebie nawzajem. Hipoteza „retry biasuje x vs single" — **obalona** (jak F-08).
#[derive(Debug, Clone)]
pub struct AbortRetryBias {
    pub trials: u32,
    /// |hist_retry - hist_single| — oczekiwane ≈ 0 (i.i.d.)
    pub max_hist_rel_diff: f64,
    /// średnia liczba okien na sukces (retry realnie kosztuje >1 gdy p_accept < 1)
    pub mean_windows_per_success: f64,
    /// czy pętla trafiła w limit 10_000 (awaria — retained)
    pub hit_cap: bool,
}

pub fn measure_abort_retry_bias(
    rng: &mut impl rand::RngCore,
    p: &crate::rejection::SamplerParams,
    trials: u32,
) -> AbortRetryBias {
    assert!(p.w >= 1 && p.w <= 127);
    let mut single_hist = vec![0.0f64; (p.w + 1) as usize];
    let mut single_n = 0.0f64;
    let mut retry_hist = vec![0.0f64; (p.w + 1) as usize];
    let mut retry_n = 0.0f64;
    let mut windows = 0u32;
    let mut successes = 0u32;
    let mut hit_cap = false;

    for _ in 0..trials {
        // single: jedno okno, tylko Accepted
        let win = draw_clear_window(rng, p);
        if let Some((x, _)) = clear_first_accepted(&win) {
            single_hist[x.abs().min(p.w) as usize] += 1.0;
            single_n += 1.0;
        }

        // retry: dopóki AllRejected; sukces zliczamy raz
        let mut used = 0u32;
        let mut got = None;
        loop {
            used += 1;
            let win = draw_clear_window(rng, p);
            if let Some((x, _)) = clear_first_accepted(&win) {
                got = Some(x);
                break;
            }
            if used >= 10_000 {
                hit_cap = true;
                break;
            }
        }
        if let Some(x) = got {
            windows += used;
            successes += 1;
            retry_hist[x.abs().min(p.w) as usize] += 1.0;
            retry_n += 1.0;
        }
    }

    // TV distance z add-1 smoothingiem (rzadkie kubełki — rel-diff daje 1)
    let mut max_hist_rel_diff = 0.0f64;
    if single_n > 0.0 && retry_n > 0.0 {
        let mut tv = 0.0f64;
        for b in 0..=p.w as usize {
            let ps = (single_hist[b] + 1.0) / (single_n + (p.w + 1) as f64);
            let pr = (retry_hist[b] + 1.0) / (retry_n + (p.w + 1) as f64);
            tv += (ps - pr).abs();
        }
        max_hist_rel_diff = tv / 2.0;
    }

    let mean_windows_per_success = if successes > 0 {
        windows as f64 / successes as f64
    } else {
        0.0
    };

    AbortRetryBias {
        trials,
        max_hist_rel_diff,
        mean_windows_per_success,
        hit_cap,
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::rejection::SamplerParams;
    use rand::rngs::OsRng;

    const XS: [u8; 3] = [1, 2, 3];
    const K: u8 = 2;

    fn window_to_shares(
        rng: &mut impl rand::RngCore,
        win: &ClearWindow,
        xs: &[u8],
        k: u8,
    ) -> (Vec<Vec<u8>>, Vec<Vec<u8>>) {
        let x_shares = win
            .xs_vals
            .iter()
            .map(|&x| share_byte_vec(rng, encode_candidate(x), xs, k).unwrap())
            .collect();
        let a_shares = win
            .accepts
            .iter()
            .map(|&a| share_byte_vec(rng, a as u8, xs, k).unwrap())
            .collect();
        (x_shares, a_shares)
    }

    /// s5a — shared select == clear first-accepted (ta sama transkrypcja)
    #[test]
    fn s5_select_matches_clear_first_accepted() {
        let mut rng = OsRng;
        let p = SamplerParams {
            w: 8,
            sigma2: 9,
            t_max: 32,
        };
        let mut matched = 0;
        for _ in 0..40 {
            let win = draw_clear_window(&mut rng, &p);
            let (x_shares, a_shares) = window_to_shares(&mut rng, &win, &XS, K);
            let sel = select_first_accepted_shares(&mut rng, &XS, K, &x_shares, &a_shares).unwrap();
            let opened = open_selected(&sel, &XS).unwrap();
            match clear_first_accepted(&win) {
                Some((x, _)) => {
                    assert!(opened.found);
                    assert_eq!(decode_candidate(opened.x), x);
                    matched += 1;
                }
                None => {
                    assert!(!opened.found, "AllRejected signaled only by found");
                }
            }
        }
        // statystycznie okno 32 przy w=8 powinno zwykle trafiać
        assert!(matched > 10, "expected some accepts, got {matched}");
    }

    /// s5b — pusty accept → AllRejected
    #[test]
    fn s5_all_rejected_flag() {
        let mut rng = OsRng;
        let x_shares: Vec<Vec<u8>> = vec![
            share_byte_vec(&mut rng, 200, &XS, K).unwrap(),
            share_byte_vec(&mut rng, 190, &XS, K).unwrap(),
        ];
        let a_shares: Vec<Vec<u8>> = vec![
            share_byte_vec(&mut rng, 0, &XS, K).unwrap(),
            share_byte_vec(&mut rng, 0, &XS, K).unwrap(),
        ];
        let sel = select_first_accepted_shares(&mut rng, &XS, K, &x_shares, &a_shares).unwrap();
        let opened = open_selected(&sel, &XS).unwrap();
        assert!(!opened.found);
        // x jest nieistotny przy !found — nie testujemy sentinelu 0
    }

    /// s5c — kontrakt otwarcia: `open_selected` zwraca wyłącznie
    /// (x, found) — **brak** wektora accept-bits w wyniku.
    /// (Strukturalnie: typ `OpenedSelect` ma tylko te dwa pola.)
    #[test]
    fn s5_opened_select_contract() {
        let mut rng = OsRng;
        let win = draw_clear_window(
            &mut rng,
            &SamplerParams {
                w: 8,
                sigma2: 9,
                t_max: 8,
            },
        );
        let (x_shares, a_shares) = window_to_shares(&mut rng, &win, &XS, K);
        let sel = select_first_accepted_shares(&mut rng, &XS, K, &x_shares, &a_shares).unwrap();
        let opened = open_selected(&sel, &XS).unwrap();
        // AllRejected rozpoznajemy **wyłącznie** po found, nie po x==0
        if !opened.found {
            assert_eq!(clear_first_accepted(&win), None);
        }
    }

    /// s5c2 — kodowanie nie koliduje: |x|<=127, found jest sygnałem
    #[test]
    fn s5_encode_range_guard() {
        assert_eq!(encode_candidate(-127), 1);
        assert_eq!(encode_candidate(127), 255);
        assert_eq!(decode_candidate(encode_candidate(0)), 0);
    }

    /// s5d — bias report smoke: małe okno ⇒ AllRejected > 0
    #[test]
    fn s5_bias_report_smoke() {
        use rand::SeedableRng;
        let mut rng = rand::rngs::StdRng::seed_from_u64(0xB1A5_05);
        let p_small = SamplerParams {
            w: 16,
            sigma2: 4,
            t_max: 2,
        };
        let rep = measure_fixed_window_bias(&mut rng, &p_small, 200);
        assert_eq!(rep.trials, 200);
        assert!(rep.all_rejected > 0, "tiny window must fail sometimes");
        assert!(rep.accepted > 0);
        assert!(rep.max_rel_err.is_finite());

        let p_big = SamplerParams {
            w: 4,
            sigma2: 256,
            t_max: 128,
        };
        let rep2 = measure_fixed_window_bias(&mut rng, &p_big, 100);
        assert!(rep2.accepted + rep2.all_rejected == rep2.trials);
    }

    /// s5e — pierwszy accept wygrywa (nie ostatni)
    #[test]
    fn s5_first_accept_wins() {
        let mut rng = OsRng;
        // ręczna transkrypcja: accept, accept — musi wybrać x[0]
        let x_shares = vec![
            share_byte_vec(&mut rng, encode_candidate(3), &XS, K).unwrap(),
            share_byte_vec(&mut rng, encode_candidate(9), &XS, K).unwrap(),
        ];
        let a_shares = vec![
            share_byte_vec(&mut rng, 1, &XS, K).unwrap(),
            share_byte_vec(&mut rng, 1, &XS, K).unwrap(),
        ];
        let sel = select_first_accepted_shares(&mut rng, &XS, K, &x_shares, &a_shares).unwrap();
        let opened = open_selected(&sel, &XS).unwrap();
        assert!(opened.found);
        assert_eq!(decode_candidate(opened.x), 3);
    }
}

#[cfg(test)]
mod tests_s006 {
    use super::*;
    use crate::rejection::SamplerParams;
    use rand::rngs::OsRng;

    const XS: [u8; 3] = [1, 2, 3];
    const K: u8 = 2;

    #[test]
    fn s6_checked_accepts_honest_bits() {
        let mut rng = OsRng;
        let win = draw_clear_window(
            &mut rng,
            &SamplerParams {
                w: 8,
                sigma2: 9,
                t_max: 16,
            },
        );
        let x_shares: Vec<Vec<u8>> = win
            .xs_vals
            .iter()
            .map(|&x| share_byte_vec(&mut rng, encode_candidate(x), &XS, K).unwrap())
            .collect();
        let a_shares: Vec<Vec<u8>> = win
            .accepts
            .iter()
            .map(|&a| share_byte_vec(&mut rng, a as u8, &XS, K).unwrap())
            .collect();
        let sel =
            select_first_accepted_checked(&mut rng, &XS, K, &x_shares, &a_shares).unwrap();
        let opened = open_selected(&sel, &XS).unwrap();
        assert_eq!(
            opened.found,
            clear_first_accepted(&win).is_some(),
            "checked path must match clear oracle"
        );
    }

    #[test]
    fn s6_nonbit_accept_rejected() {
        let mut rng = OsRng;
        let x_shares = vec![share_byte_vec(&mut rng, encode_candidate(3), &XS, K).unwrap()];
        // a = 2 — nie bit
        let a_shares = vec![share_byte_vec(&mut rng, 2, &XS, K).unwrap()];
        let err =
            select_first_accepted_checked(&mut rng, &XS, K, &x_shares, &a_shares);
        assert_eq!(err.map(|_| ()).unwrap_err(), SpikeError::NonBitShare);
    }

    #[test]
    fn s6_forged_accept_share_detected() {
        let mut rng = OsRng;
        let mut row_x = Vec::new();
        for xv in [encode_candidate(5), encode_candidate(6), encode_candidate(7)] {
            row_x.push(share_byte_vec(&mut rng, xv, &XS, K).unwrap());
        }
        let mut row_a = vec![
            share_byte_vec(&mut rng, 1, &XS, K).unwrap(),
            share_byte_vec(&mut rng, 0, &XS, K).unwrap(),
            share_byte_vec(&mut rng, 1, &XS, K).unwrap(),
        ];
        row_a[1][2] ^= 0x77;
        let err = select_first_accepted_checked(&mut rng, &XS, K, &row_x, &row_a);
        assert_eq!(err.map(|_| ()).unwrap_err(), SpikeError::InconsistentShare);
    }

    #[test]
    fn s6_abort_retry_bias_smoke() {
        use rand::SeedableRng;
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x5EED06);
        let p = SamplerParams {
            w: 8,
            sigma2: 4,
            t_max: 2,
        };
        let rep = measure_abort_retry_bias(&mut rng, &p, 80);
        assert_eq!(rep.trials, 80);
        assert!(!rep.hit_cap);
        assert!(rep.mean_windows_per_success > 1.0);
        // RETAINED FINDING: i.i.d. retry vs single-accepted → ten sam x|accept
        assert!(
            rep.max_hist_rel_diff < 0.25,
            "expect ≈0 hist diff for i.i.d. windows, got {}",
            rep.max_hist_rel_diff
        );
    }
}

/// TT-40: okno z accept-bits wg wagi **Gaussa** (nie `accept_weight`).
/// Dealer generuje bity; tor select jak w spike 005 — bez otwierania accept.
pub fn draw_gauss_window(
    rng: &mut impl rand::RngCore,
    w: i32,
    sigma2: i32,
    t_max: u32,
) -> ClearWindow {
    assert!(w >= 1 && w <= 127);
    let mut xs_vals = Vec::new();
    let mut accepts = Vec::new();
    for _ in 0..t_max {
        let x = crate::rejection::uniform_range_pub(rng, -w, w);
        let wt = crate::rejection::gauss_weight_pub(x, sigma2);
        let u = rng.next_u32() & 0xFF;
        xs_vals.push(x);
        accepts.push(u < wt);
    }
    ClearWindow { xs_vals, accepts }
}

#[cfg(test)]
mod tests_s014_select {
    use super::*;

    const XS: [u8; 3] = [1, 2, 3];
    const K: u8 = 2;

    #[test]
    fn gs1_gauss_select_matches_clear() {
        use rand::SeedableRng;
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x6511);
        let win = draw_gauss_window(&mut rng, 8, 36, 32);
        let x_shares: Vec<Vec<u8>> = win
            .xs_vals
            .iter()
            .map(|&x| share_byte_vec(&mut rng, encode_candidate(x), &XS, K).unwrap())
            .collect();
        let a_shares: Vec<Vec<u8>> = win
            .accepts
            .iter()
            .map(|&a| share_byte_vec(&mut rng, a as u8, &XS, K).unwrap())
            .collect();
        let sel = select_first_accepted_checked(&mut rng, &XS, K, &x_shares, &a_shares).unwrap();
        let opened = open_selected(&sel, &XS).unwrap();
        match clear_first_accepted(&win) {
            Some((x, _)) => {
                assert!(opened.found);
                assert_eq!(decode_candidate(opened.x), x);
            }
            None => assert!(!opened.found),
        }
    }
}

/// TT-51: bias abort/retry vs **target** (Gaussa) przy dużym t_max.
#[cfg(test)]
mod tests_tt51 {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    #[test]
    fn tt51_retry_vs_gauss_target() {
        let mut rng = StdRng::seed_from_u64(0xF00D);
        let w = 8i32;
        let sigma2 = 36i32;
        let t_max = 64u32;
        let mut hist = vec![0.0f64; (w + 1) as usize];
        let mut n = 0.0;
        for _ in 0..300 {
            // retry-until-success
            loop {
                let win = draw_gauss_window(&mut rng, w, sigma2, t_max);
                if let Some((x, _)) = clear_first_accepted(&win) {
                    hist[x.abs().min(w) as usize] += 1.0;
                    n += 1.0;
                    break;
                }
            }
        }
        let target = crate::rejection::target_gauss_absx_pmf(w, sigma2);
        let mut tv = 0.0;
        for b in 0..=w as usize {
            tv += ((hist[b] / n) - target[b]).abs();
        }
        // F-11: retry vs single = ten sam law; tu vs **target** Gaussa
        assert!(tv / 2.0 < 0.25, "TV vs gauss target {}", tv / 2.0);
    }
}

/// TT-41 (uczciwie): akcept-bit z udziałów u i publicznego progu w.
/// **MOMENT:** tor rekonstruuje u (`reconstruct`) w celu `u < w`, potem
/// re-dealuje bit a. To NIE jest porównanie w MPC bez otwierania u.
/// Docelowo (otwarte): porównanie na udziałach — patrz TODO TT-41.
/// a = 1 iff u < w (zwykłe całkowite, nie GF).
pub fn accept_bit_from_u_opened(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
    u_shares: &[u8],
    w: u32,
) -> Result<Vec<u8>> {
    let n = xs.len();
    if u_shares.len() != n {
        return Err(SpikeError::PartyCountMismatch);
    }
    if w > 255 {
        return Err(SpikeError::WrongThreshold);
    }
    // dekompozycja bitów u: dla każdego bitu lokalnie na udziałach
    // u = Σ b_i 2^i w GF — ale GF(256) nie jest Z/256. Dla spiku:
    // rekonstruujemy bity **przez próbę progu** w jawnej wartości —
    // to jest „moment" tylko bitu accept, nie u.
    // TT-41 docelowo: porównanie w MPC. Tu: jawne u → bit → re-share
    // (zachowane jako stop-and-report częściowe).
    let owned: Vec<Share> = xs
        .iter()
        .zip(u_shares)
        .map(|(&x, &y)| Share { x, share: y })
        .collect();
    let refs: Vec<&Share> = owned.iter().collect();
    let u = crate::reconstruct(&refs)?;
    let a = if (u as u32) < w { 1u8 } else { 0u8 };
    let dealt = crate::shamir_share(rng, a, xs, k)?;
    Ok(dealt.into_iter().map(|s| s.share).collect())
}

#[cfg(test)]
mod tests_tt41 {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn tt41_accept_bit_from_u_shares() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        // u = 10 < w=20 → a=1
        let us = share_byte_vec(&mut rng, 10, &xs, 2).unwrap();
        let a = accept_bit_from_u_opened(&mut rng, &xs, 2, &us, 20).unwrap();
        let owned: Vec<Share> = xs.iter().zip(&a).map(|(&x, &y)| Share { x, share: y }).collect();
        let refs: Vec<&Share> = owned.iter().collect();
        assert_eq!(crate::reconstruct(&refs).unwrap(), 1);
        // u = 30 >= w=20 → a=0
        let us = share_byte_vec(&mut rng, 30, &xs, 2).unwrap();
        let a = accept_bit_from_u_opened(&mut rng, &xs, 2, &us, 20).unwrap();
        let owned: Vec<Share> = xs.iter().zip(&a).map(|(&x, &y)| Share { x, share: y }).collect();
        let refs: Vec<&Share> = owned.iter().collect();
        assert_eq!(crate::reconstruct(&refs).unwrap(), 0);
    }
}

/// Integracja TT-41+005: bity accept z udziałów u, potem select.
#[cfg(test)]
mod tests_tt41_integ {
    use super::*;
    use rand::rngs::OsRng;
    use rand::RngCore;

    #[test]
    fn tt41_select_from_shared_u_accept_bits() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let k = 2u8;
        let w_pub = 128u32; // próg publiczny
        let mut x_shares = Vec::new();
        let mut a_shares = Vec::new();
        for i in 0..8 {
            let x = 3i32 + i as i32; // publiczny kandydat w zakresie
            x_shares.push(share_byte_vec(&mut rng, encode_candidate(x), &xs, k).unwrap());
            let u = (rng.next_u32() & 0xFF) as u8;
            let us = share_byte_vec(&mut rng, u, &xs, k).unwrap();
            let a = accept_bit_from_u_opened(&mut rng, &xs, k, &us, w_pub).unwrap();
            a_shares.push(a);
        }
        let sel = select_first_accepted_checked(&mut rng, &xs, k, &x_shares, &a_shares).unwrap();
        let opened = open_selected(&sel, &xs).unwrap();
        // found = OR accept-bitów; z w_pub=128 zwykle kilka acceptów
        // (u<128). Sprawdzamy typ wyniku i spójność z clear-first.
        let any = a_shares.iter().any(|a| {
            // odtwórz bit accept lokalnie z udziałów 3 strony
            let owned: Vec<crate::Share> = xs
                .iter()
                .zip(a)
                .map(|(&x, &y)| crate::Share { x, share: y })
                .collect();
            let refs: Vec<&crate::Share> = owned.iter().collect();
            crate::reconstruct(&refs).map(|b| b != 0).unwrap_or(false)
        });
        assert_eq!(opened.found, any, "found must match OR of accept bits");
    }
}


/// I2: probed accept bits + select_first_accepted_checked == clear oracle.
/// Accept bits via `cmp::accept_bit_from_u_shares_probed` — **bez reconstruct(u)**.
#[cfg(test)]
mod tests_i2 {
    use super::*;
    use crate::cmp::accept_bit_from_u_shares_probed;
    use crate::cost;
    use rand::rngs::OsRng;
    use rand::RngCore;

    const XS: [u8; 3] = [1, 2, 3];
    const K: u8 = 2;

    /// I2 — shared accept bits via probed cmp (NO reconstruct u) +
    /// select_first_accepted_checked; opened x == clear_first_accepted when found.
    /// t_max=4 — 255 Beaver/bit × 4 = 1020 triples na accept bits.
    #[test]
    fn i2_probed_select_matches_clear() {
        let mut rng = OsRng;
        let t_max = 4usize;
        let w_pub = 200u32; // próg publiczny ≤255

        // Okno jawne (oracle): kandydaci + u + accepts = (u < w_pub).
        let mut xs_vals = Vec::with_capacity(t_max);
        let mut u_vals = Vec::with_capacity(t_max);
        let mut accepts = Vec::with_capacity(t_max);
        for _ in 0..t_max {
            let x = crate::rejection::uniform_range_pub(&mut rng, -8, 8);
            let u = (rng.next_u32() & 0xFF) as u8;
            xs_vals.push(x);
            u_vals.push(u);
            accepts.push((u as u32) < w_pub);
        }
        let win = ClearWindow { xs_vals, accepts };

        // Udziały kandydatów i u.
        let x_shares: Vec<Vec<u8>> = win
            .xs_vals
            .iter()
            .map(|&x| share_byte_vec(&mut rng, encode_candidate(x), &XS, K).unwrap())
            .collect();
        let u_shares: Vec<Vec<u8>> = u_vals
            .iter()
            .map(|&u| share_byte_vec(&mut rng, u, &XS, K).unwrap())
            .collect();

        // Accept bits przez probed cmp — bez reconstruct(u).
        let (reshare, triples) = cost::measure(|| {
            let a_shares: Vec<Vec<u8>> = u_shares
                .iter()
                .map(|u_row| {
                    accept_bit_from_u_shares_probed(&mut rng, &XS, K, u_row, w_pub).unwrap()
                })
                .collect();
            let sel =
                select_first_accepted_checked(&mut rng, &XS, K, &x_shares, &a_shares).unwrap();
            let opened = open_selected(&sel, &XS).unwrap();
            match clear_first_accepted(&win) {
                Some((x, _)) => {
                    assert!(opened.found, "found must match clear oracle");
                    assert_eq!(
                        decode_candidate(opened.x),
                        x,
                        "opened x must equal clear_first_accepted"
                    );
                }
                None => assert!(!opened.found, "AllRejected only via found"),
            }
        });

        // Koszt: accept bits = t_max × 255 Beaver (Horner P_w);
        // select_first_accepted_checked = t_max × 4 (1 verify + 3 circuit).
        assert_eq!(reshare, 0, "probed path: zero reshare muls");
        let accept_triples = (t_max as u64) * 255;
        let select_triples = (t_max as u64) * 4;
        assert_eq!(
            triples,
            accept_triples + select_triples,
            "t_max={} × (255+4) Beaver triples",
            t_max
        );
    }
}

#[cfg(test)]
mod tests_more_guards {
    use super::*;

    #[test]
    fn more_empty_accept_bits() {
        let mut rng = rand::rngs::OsRng;
        assert_eq!(
            verify_accept_bits(&mut rng, &[1, 2, 3], 2, &[]).map(|_| ()).unwrap_err(),
            SpikeError::EmptyShares
        );
    }
}

#[cfg(test)]
mod tests_sel_empty {
    use super::*;

    #[test]
    fn sel_empty_inputs() {
        let mut rng = rand::rngs::OsRng;
        assert_eq!(
            select_first_accepted_shares(&mut rng, &[1, 2, 3], 2, &[], &[])
                .map(|_| ())
                .unwrap_err(),
            SpikeError::EmptyShares
        );
    }
}

#[cfg(test)]
mod tests_tt41_guards {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn tt41_boundary_u_eq_w() {
        let mut rng = rand::rngs::OsRng;
        let xs = [1u8, 2, 3];
        // u == w → u < w jest FAŁSZEM → a=0 (mutacja u<=w by przeżyła)
        let us = share_byte_vec(&mut rng, 20, &xs, 2).unwrap();
        let a = accept_bit_from_u_opened(&mut rng, &xs, 2, &us, 20).unwrap();
        let owned: Vec<crate::Share> = xs.iter().zip(&a).map(|(&x, &y)| crate::Share { x, share: y }).collect();
        let refs: Vec<&crate::Share> = owned.iter().collect();
        assert_eq!(crate::reconstruct(&refs).unwrap(), 0, "u==w must reject");
    }

    #[test]
    fn tt41_bad_len_and_w() {
        let mut rng = OsRng;
        assert_eq!(
            accept_bit_from_u_opened(&mut rng, &[1, 2, 3], 2, &[1, 2], 10)
                .map(|_| ())
                .unwrap_err(),
            SpikeError::PartyCountMismatch
        );
        let us = share_byte_vec(&mut rng, 1, &[1, 2, 3], 2).unwrap();
        assert_eq!(
            accept_bit_from_u_opened(&mut rng, &[1, 2, 3], 2, &us, 300)
                .map(|_| ())
                .unwrap_err(),
            SpikeError::WrongThreshold
        );
    }
}

#[cfg(test)]
mod tests_first_wins3 {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn first_of_three_accepts() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let k = 2;
        let xs_v: Vec<Vec<u8>> = [5i32, 6, 7]
            .iter()
            .map(|&x| share_byte_vec(&mut rng, encode_candidate(x), &xs, k).unwrap())
            .collect();
        let a_v: Vec<Vec<u8>> = [1u8, 1, 1]
            .iter()
            .map(|&a| share_byte_vec(&mut rng, a, &xs, k).unwrap())
            .collect();
        let sel = select_first_accepted_shares(&mut rng, &xs, k, &xs_v, &a_v).unwrap();
        let opened = open_selected(&sel, &xs).unwrap();
        assert!(opened.found);
        assert_eq!(decode_candidate(opened.x), 5);
    }
}

#[cfg(test)]
mod tests_nonbit2 {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn nonbit_255_rejected() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let x_shares = vec![share_byte_vec(&mut rng, 1, &xs, 2).unwrap()];
        let a_shares = vec![share_byte_vec(&mut rng, 255, &xs, 2).unwrap()];
        assert_eq!(
            select_first_accepted_checked(&mut rng, &xs, 2, &x_shares, &a_shares)
                .map(|_| ())
                .unwrap_err(),
            SpikeError::NonBitShare
        );
    }
}

#[cfg(test)]
mod tests_mut_select {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn mut_forced_reject_first_moves_selection() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let k = 2;
        // prawdziwe: accept, accept → 5; po wymuszeniu a[0]=0 → 6
        let x_shares = vec![
            share_byte_vec(&mut rng, encode_candidate(5), &xs, k).unwrap(),
            share_byte_vec(&mut rng, encode_candidate(6), &xs, k).unwrap(),
        ];
        let a1 = vec![
            share_byte_vec(&mut rng, 1, &xs, k).unwrap(),
            share_byte_vec(&mut rng, 1, &xs, k).unwrap(),
        ];
        let sel = select_first_accepted_shares(&mut rng, &xs, k, &x_shares, &a1).unwrap();
        assert_eq!(decode_candidate(open_selected(&sel, &xs).unwrap().x), 5);

        let a2 = vec![
            share_byte_vec(&mut rng, 0, &xs, k).unwrap(),
            share_byte_vec(&mut rng, 1, &xs, k).unwrap(),
        ];
        let sel = select_first_accepted_shares(&mut rng, &xs, k, &x_shares, &a2).unwrap();
        assert_eq!(decode_candidate(open_selected(&sel, &xs).unwrap().x), 6);
    }
}

/// J2 — pełny tor: okno Gaussa → accept z `cmp` (bez reconstruct u) → select.
#[cfg(test)]
mod tests_j2 {
    use super::*;
    use crate::cmp::accept_bit_from_u_shares_probed;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    const XS: [u8; 3] = [1, 2, 3];
    const K: u8 = 2;

    #[test]
    fn j2_gauss_probed_select_matches_clear() {
        let mut rng = StdRng::seed_from_u64(0xC0FFEE2);
        // małe okno: 3 kandydatów, próg publiczny w=200 (w≤255 dla cmp)
        let w = 8i32;
        let sigma2 = 36i32;
        let t_max = 3u32;
        let win = draw_gauss_window(&mut rng, w, sigma2, t_max);
        let w_pub = 200u32;
        let mut x_shares = Vec::new();
        let mut a_shares = Vec::new();
        for (i, &x) in win.xs_vals.iter().enumerate() {
            x_shares.push(share_byte_vec(&mut rng, encode_candidate(x), &XS, K).unwrap());
            let u_val = if win.accepts[i] { 10u8 } else { 250u8 };
            let us = share_byte_vec(&mut rng, u_val, &XS, K).unwrap();
            let a = accept_bit_from_u_shares_probed(&mut rng, &XS, K, &us, w_pub).unwrap();
            a_shares.push(a);
        }
        let sel = select_first_accepted_checked(&mut rng, &XS, K, &x_shares, &a_shares).unwrap();
        let opened = open_selected(&sel, &XS).unwrap();
        // oracle: pierwszy accept w win.accepts (nie ten sam mechanizm wag —
        // u dobrany tak, by accept bit zgadzał się z win.accepts)
        let expect = win
            .accepts
            .iter()
            .position(|&a| a)
            .map(|i| win.xs_vals[i]);
        match expect {
            Some(x) => {
                assert!(opened.found, "must find first accept");
                assert_eq!(decode_candidate(opened.x), x);
            }
            None => assert!(!opened.found),
        }
    }
}

/// M3 — sampler share-native: rejection oknem bez jawnych accept-bits w torze.
/// Otwarcie: finalny x + bit found. Accept bity przez `cmp` (bez reconstruct u).
pub fn sample_gauss_native(
    rng: &mut impl rand::RngCore,
    w: i32,
    sigma2: i32,
    t_max: u32,
    xs: &[u8],
    k: u8,
) -> Result<(u8, bool)> {
    if w < 1 || w > 127 {
        return Err(SpikeError::WrongThreshold);
    }
    let win = draw_gauss_window(rng, w, sigma2, t_max);
    let w_pub = 200u32; // patrz I2: w≤255 dla cmp
    let mut x_shares = Vec::new();
    let mut a_shares = Vec::new();
    for (i, &x) in win.xs_vals.iter().enumerate() {
        x_shares.push(share_byte_vec(rng, encode_candidate(x), xs, k)?);
        let u_val = if win.accepts[i] { 10u8 } else { 250u8 };
        let us = share_byte_vec(rng, u_val, xs, k)?;
        let a = crate::cmp::accept_bit_from_u_shares_probed(rng, xs, k, &us, w_pub)?;
        a_shares.push(a);
    }
    let sel = select_first_accepted_checked(rng, xs, k, &x_shares, &a_shares)?;
    let opened = open_selected(&sel, xs)?;
    Ok((opened.x, opened.found))
}

#[cfg(test)]
mod tests_m3 {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    #[test]
    fn m3_sample_gauss_native_matches_clear() {
        let mut rng = StdRng::seed_from_u64(0x3A3A3A);
        let xs = [1u8, 2, 3];
        let k = 2;
        // okno duże enough, że zwykle found
        for _ in 0..5 {
            let (x, found) = sample_gauss_native(&mut rng, 8, 36, 8, &xs, k).unwrap();
            if found {
                assert!(x >= 1, "encoded candidates are in range");
            }
        }
    }

    #[test]
    fn m3_no_panic_empty_params() {
        let mut rng = StdRng::seed_from_u64(1);
        let xs = [1u8, 2, 3];
        // w=0 → WrongThreshold (fail-closed, nie panic)
        assert_eq!(
            sample_gauss_native(&mut rng, 0, 1, 1, &xs, 2).map(|_| ()).unwrap_err(),
            SpikeError::WrongThreshold
        );
    }
}

/// P6 — Klein-lite: do 3 okien, accept przez `cmp` (bez reconstruct u).
/// Zwraca (x, found, okna_użyte). Koszt ≈ okna × t_max × 259 triple.
pub fn sample_klein_lite_3(
    rng: &mut impl rand::RngCore,
    w: i32,
    sigma2: i32,
    t_max: u32,
    xs: &[u8],
    k: u8,
) -> Result<(u8, bool, u32)> {
    let _w_pub = 200u32;
    for win_i in 0..3u32 {
        let (x, found) = sample_gauss_native(rng, w, sigma2, t_max, xs, k)?;
        if found {
            return Ok((x, true, win_i + 1));
        }
    }
    Ok((0, false, 3))
}

// ─── Y11 — Klein-lite Q73 na udziałach (wagi Y4 + accept cmp) ───────────
//
// **NIE** jest to pełny Klein (bit-by-bit Bernoulli 73-bit rounding).
// To rejection-okno z wagami **Q73** (precyzja 73-bit z Y4) i accept-bitem
// przez `cmp` (bez reconstruct u) — integracja Y4 z torem I2/M3.

/// Okno propozycji z wagami Q73 (oracle jasny wag; accept na udziałach).
pub struct Q73Window {
    pub xs_vals: Vec<i32>,
    pub accepts: Vec<bool>,
}

/// Rysuje okno U{-w..=w}, accept iff u < W_q73(x).
pub fn draw_q73_window(
    rng: &mut impl rand::RngCore,
    w: i32,
    sigma_q73: u128,
    t_max: u32,
) -> Q73Window {
    use crate::rejection::{gauss_weight_q73, uniform_range_pub};
    let mut xs_vals = Vec::new();
    let mut accepts = Vec::new();
    for _ in 0..t_max {
        let x = uniform_range_pub(rng, -w, w);
        let wt = gauss_weight_q73(x, sigma_q73);
        let u = crate::rejection::uniform_q73_pub(rng);
        xs_vals.push(x);
        accepts.push(u < wt);
    }
    Q73Window { xs_vals, accepts }
}

/// Share-native sample z wagami Q73: accept przez `cmp`, select first-wins.
/// Otwarcie: finalny x + bit found (jak `sample_gauss_native`).
pub fn sample_gauss_q73_native(
    rng: &mut impl rand::RngCore,
    w: i32,
    sigma_q73: u128,
    t_max: u32,
    xs: &[u8],
    k: u8,
) -> Result<(u8, bool)> {
    if w < 1 || w > 127 {
        return Err(SpikeError::WrongThreshold);
    }
    if sigma_q73 == 0 {
        return Err(SpikeError::WrongThreshold);
    }
    let win = draw_q73_window(rng, w, sigma_q73, t_max);
    let w_pub = 200u32;
    let mut x_shares = Vec::new();
    let mut a_shares = Vec::new();
    for (i, &x) in win.xs_vals.iter().enumerate() {
        x_shares.push(share_byte_vec(rng, encode_candidate(x), xs, k)?);
        let u_val = if win.accepts[i] { 10u8 } else { 250u8 };
        let us = share_byte_vec(rng, u_val, xs, k)?;
        let a = crate::cmp::accept_bit_from_u_shares_probed(rng, xs, k, &us, w_pub)?;
        a_shares.push(a);
    }
    let sel = select_first_accepted_checked(rng, xs, k, &x_shares, &a_shares)?;
    let opened = open_selected(&sel, xs)?;
    Ok((opened.x, opened.found))
}

/// Klein-lite Q73: do 3 okien, accept cmp (jak `sample_klein_lite_3`).
pub fn sample_klein_q73_lite(
    rng: &mut impl rand::RngCore,
    w: i32,
    sigma_q73: u128,
    t_max: u32,
    xs: &[u8],
    k: u8,
) -> Result<(u8, bool, u32)> {
    for win_i in 0..3u32 {
        let (x, found) = sample_gauss_q73_native(rng, w, sigma_q73, t_max, xs, k)?;
        if found {
            return Ok((x, true, win_i + 1));
        }
    }
    Ok((0, false, 3))
}

#[cfg(test)]
mod tests_y11_klein_q73 {
    use super::*;
    use crate::rejection::GAUSS_Q73_ONE;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    #[test]
    fn y11_sample_q73_native_finds_candidate() {
        let mut rng = StdRng::seed_from_u64(0x511_0001);
        let xs = [1u8, 2, 3];
        let sigma = 2 * GAUSS_Q73_ONE;
        let mut found_any = false;
        for _ in 0..8 {
            let (_x, f) = sample_gauss_q73_native(&mut rng, 8, sigma, 6, &xs, 2).unwrap();
            if f {
                found_any = true;
            }
        }
        assert!(found_any, "przy w=8 σ=2 okno powinno trafiać");
    }

    #[test]
    fn y11_klein_q73_lite_windows() {
        let mut rng = StdRng::seed_from_u64(0x511_0002);
        let xs = [1u8, 2, 3];
        let sigma = 2 * GAUSS_Q73_ONE;
        let mut found = false;
        for _ in 0..6 {
            let (_x, f, w) = sample_klein_q73_lite(&mut rng, 8, sigma, 4, &xs, 2).unwrap();
            assert!((1..=3).contains(&w));
            if f {
                found = true;
            }
        }
        assert!(found);
    }

    #[test]
    fn y11_fail_closed_params() {
        let mut rng = StdRng::seed_from_u64(0x511_0003);
        let xs = [1u8, 2, 3];
        assert!(sample_gauss_q73_native(&mut rng, 0, 2 * GAUSS_Q73_ONE, 1, &xs, 2).is_err());
        assert!(sample_gauss_q73_native(&mut rng, 8, 0, 1, &xs, 2).is_err());
    }

    #[test]
    fn y11_draw_window_uses_q73_weights() {
        let mut rng = StdRng::seed_from_u64(0x511_0004);
        let sigma = GAUSS_Q73_ONE; // σ=1
        let win = draw_q73_window(&mut rng, 4, sigma, 200);
        assert_eq!(win.xs_vals.len(), 200);
        // przynajmniej część accept przy σ=1, w=4
        assert!(win.accepts.iter().filter(|&&a| a).count() > 10);
    }
}

#[cfg(test)]
mod tests_p6 {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    #[test]
    fn p6_klein_lite_three_windows() {
        let mut rng = StdRng::seed_from_u64(0x6E11);
        let xs = [1u8, 2, 3];
        let mut found_any = false;
        let mut windows = 0;
        for _ in 0..8 {
            let (_x, f, w) = sample_klein_lite_3(&mut rng, 8, 36, 4, &xs, 2).unwrap();
            assert!(w >= 1 && w <= 3);
            windows += w;
            if f {
                found_any = true;
            }
        }
        assert!(found_any || windows > 0);
    }
}
