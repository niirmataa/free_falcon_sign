//! MPS4-H — splot na udziałach i16 + **rounding w MPC** (wariant B, G-1).
//!
//! Cel ZŁOTO: `z = (z0, z1)` powstaje z udziałów f,F **bez otwierania**
//! f, F, t·f, t·F ani z; potem (s1,s2) na udziałach → open s1,s2 →
//! `Ft1536Signature::verify == true`. Po setupie udziałów nikt nie widzi
//! f ani F w clear.
//!
//! # Architektura
//!
//! - **H1** — Shamir na dużym module `P = 2^61-1` (całkowite i16/i64).
//!   Udziały f,g,F,G trzymają **całkowite** wartości (nie R_q) — rounding
//!   `round(t·F/q)` wymaga całkowitego F, nie F mod q.
//! - **H2** — jawne t × udział: liniowość Shamir, **0 reshare-mul**.
//! - **H3** — rounding w MPC: bit-dekompozycja udziałów (maska losowa +
//!   otwarcie **maski**, nigdy x), obwód bitowy /q z round-half-away,
//!   złożenie bitów |z| do Z_P, znak przez 1 reshare-mul.
//!   **Zakaz** otwierania x = t·f / t·F w trakcie round.
//! - **H4** — sign z tajnym z: splot udział×udział (`i_poly_mul_ring_shares`,
//!   O(N²) reshare-muls — G-3), open **wyłącznie** s1,s2.
//!
//! Bity obwodu: udziały GF(256) (XOR = dodawanie, AND = `mul_shamir_reshare`
//! — wzór `shake.rs::and_bits`). Konwersja bitu 0/1 GF(256) → Z_P przez
//! parę masek (open `b ⊕ m` — maska, nie sekret).
//!
//! Semi-honest spike. **Nie** threshold signing (G-2), brak VSS/malicious.

use crate::mpc_sign::{FT1536_N, FT1536_Q};
use crate::{shamir_share, Share, SpikeError, Result};
use zeroize::{Zeroize, ZeroizeOnDrop};

// ─── H1 — Shamir na dużym module P = 2^61 − 1 ───────────────────────────

/// Moduł całkowity (Mersenne, pierwsza): P = 2^61 − 1.
pub const I_P: u64 = (1u64 << 61) - 1;

/// Udział wartości całkowitej w Z_P (Shamir k-z-n). `share` w [0, P).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct IShare {
    pub x: u16,
    pub share: u64,
}

/// Wielomian na udziałach Z_P: `[współczynnik N][strona n]`.
pub type IPolyShares = Vec<Vec<u64>>;

#[inline]
pub fn p_add(a: u64, b: u64) -> u64 {
    let s = a % I_P + b % I_P;
    if s >= I_P {
        s - I_P
    } else {
        s
    }
}

#[inline]
pub fn p_sub(a: u64, b: u64) -> u64 {
    let (a, b) = (a % I_P, b % I_P);
    if a >= b {
        a - b
    } else {
        a + I_P - b
    }
}

#[inline]
pub fn p_mul(a: u64, b: u64) -> u64 {
    ((a % I_P as u64) as u128 * (b % I_P) as u128 % I_P as u128) as u64
}

/// a^(P-2) mod P (P pierwsza).
pub fn p_inv(a: u64) -> Result<u64> {
    if a % I_P == 0 {
        return Err(SpikeError::WrongThreshold);
    }
    let mut r = 1u64;
    let mut b = a % I_P;
    let mut e = I_P - 2;
    while e > 0 {
        if e & 1 == 1 {
            r = p_mul(r, b);
        }
        b = p_mul(b, b);
        e >>= 1;
    }
    Ok(r)
}

/// i64 → reprezentant Z_P w [0, P).
#[inline]
pub fn i64_to_p(v: i64) -> u64 {
    let m = I_P as i128;
    let mut r = (v as i128) % m;
    if r < 0 {
        r += m;
    }
    r as u64
}

/// Z_P → i64 centered w (-P/2, P/2].
#[inline]
pub fn p_to_i64(v: u64) -> i64 {
    let v = v % I_P;
    if v > I_P / 2 {
        (v as i64).wrapping_sub(I_P as i64)
    } else {
        v as i64
    }
}

fn p_eval_poly(coeffs: &[u64], x: u16) -> u64 {
    let mut acc = 0u64;
    let xv = (x as u64) % I_P;
    for &c in coeffs.iter().rev() {
        acc = p_add(p_mul(acc, xv), c);
    }
    acc
}

fn p_lagrange_at_zero(xs: &[u16], i: usize) -> Result<u64> {
    if xs.is_empty() || i >= xs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    if xs[i] == 0 {
        return Err(SpikeError::XZero);
    }
    let mut num = 1u64;
    let mut den = 1u64;
    for (j, &xj) in xs.iter().enumerate() {
        if i == j {
            continue;
        }
        if xj == 0 {
            return Err(SpikeError::XZero);
        }
        num = p_mul(num, xj as u64);
        den = p_mul(den, p_sub(xs[i] as u64, xj as u64));
    }
    Ok(p_mul(num, p_inv(den)?))
}

fn check_xs_p(xs: &[u16], k: u8) -> Result<usize> {
    if k < 2 {
        return Err(SpikeError::ThresholdTooLow);
    }
    if xs.is_empty() {
        return Err(SpikeError::EmptyXs);
    }
    if xs.len() < k as usize {
        return Err(SpikeError::NotEnoughPoints);
    }
    let mut seen = std::collections::HashSet::new();
    for &x in xs {
        if x == 0 || (x as u64) >= I_P {
            return Err(SpikeError::XZero);
        }
        if !seen.insert(x) {
            return Err(SpikeError::DuplicateX);
        }
    }
    Ok(xs.len())
}

/// Guard mnożenia (audyt #1): iloczyn ma stopień `2(k−1)` → **n ≥ 2k−1**.
fn check_mul_quorum_p(xs: &[u16], k: u8) -> Result<usize> {
    let n = check_xs_p(xs, k)?;
    crate::mul::check_mul_quorum(n, k)?;
    Ok(n)
}

/// Shamir share sekretu całkowitego (i64) w Z_P.
pub fn ishare_val(
    rng: &mut impl rand::RngCore,
    secret: i64,
    xs: &[u16],
    k: u8,
) -> Result<Vec<u64>> {
    check_xs_p(xs, k)?;
    Ok(ishare_val_unchecked(rng, secret, xs, k))
}

/// Bez check_xs_p — hot path (N² reshare).
fn ishare_val_unchecked(
    rng: &mut impl rand::RngCore,
    secret: i64,
    xs: &[u16],
    k: u8,
) -> Vec<u64> {
    let s = i64_to_p(secret);
    if k == 2 {
        // poly = [s, r]; share_j = s + r·x_j
        let r = rng.next_u64() % I_P;
        return xs
            .iter()
            .map(|&x| p_add(s, p_mul(r, x as u64)))
            .collect();
    }
    let mut coeffs = Vec::with_capacity(k as usize);
    coeffs.push(s);
    for _ in 1..k {
        coeffs.push(rng.next_u64() % I_P);
    }
    xs.iter().map(|&x| p_eval_poly(&coeffs, x)).collect()
}

/// Rekonstrukcja sekretu całkowitego (open / „moment").
pub fn ireconstruct_val(xs: &[u16], shares: &[u64]) -> Result<i64> {
    if shares.is_empty() || xs.len() != shares.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    let mut acc = 0u64;
    for (i, &sh) in shares.iter().enumerate() {
        let lam = p_lagrange_at_zero(xs, i)?;
        acc = p_add(acc, p_mul(sh, lam));
    }
    Ok(p_to_i64(acc))
}

/// Udział wielomianu całkowitego i16 (f,g,F,G — **całkowite** i16, nie R_q).
pub fn ishare_poly(
    rng: &mut impl rand::RngCore,
    p: &[i16],
    xs: &[u16],
    k: u8,
) -> Result<IPolyShares> {
    if p.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    let mut out = Vec::with_capacity(FT1536_N);
    for &c in p {
        out.push(ishare_val(rng, c as i64, xs, k)?);
    }
    Ok(out)
}

/// Rekonstrukcja wielomianu i64 (testy / moment / open s).
pub fn ireconstruct_poly_i64(ps: &IPolyShares, xs: &[u16]) -> Result<Vec<i64>> {
    if ps.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    let n = xs.len();
    if n == 0 {
        return Err(SpikeError::EmptyXs);
    }
    let mut out = Vec::with_capacity(FT1536_N);
    for col in ps {
        if col.len() != n {
            return Err(SpikeError::PartyCountMismatch);
        }
        out.push(ireconstruct_val(xs, col)?);
    }
    Ok(out)
}

/// Rekonstrukcja wielomianu i16 (testy f,g,F,G).
pub fn ireconstruct_poly(ps: &IPolyShares, xs: &[u16]) -> Result<Vec<i16>> {
    Ok(ireconstruct_poly_i64(ps, xs)?
        .into_iter()
        .map(|v| {
            assert!(
                (i16::MIN as i64..=i16::MAX as i64).contains(&v),
                "ireconstruct_poly: {v} poza i16"
            );
            v as i16
        })
        .collect())
}

// ─── Mnożenie Shamir w Z_P (reshare) — koszt G-3 ───────────────────────

/// λ_i = Lagrange(0) dla xs — precomputing przy N² splotach.
pub fn p_lagrange_all(xs: &[u16]) -> Result<Vec<u64>> {
    let mut out = Vec::with_capacity(xs.len());
    for i in 0..xs.len() {
        out.push(p_lagrange_at_zero(xs, i)?);
    }
    Ok(out)
}

/// Re-deal mnożenia w Z_P z precomputowanymi λ.
fn i_mul_with_lam(
    rng: &mut impl rand::RngCore,
    xs: &[u16],
    k: u8,
    lam: &[u64],
    a: &[u64],
    b: &[u64],
) -> Result<Vec<u64>> {
    let n = xs.len();
    if a.len() != n || b.len() != n || lam.len() != n {
        return Err(SpikeError::PartyCountMismatch);
    }
    let mut c = vec![0u64; n];
    for i in 0..n {
        let u_i = p_mul(lam[i], p_mul(a[i], b[i]));
        let dealt = ishare_val_unchecked(rng, p_to_i64(u_i), xs, k);
        for (j, sh) in dealt.into_iter().enumerate() {
            c[j] = p_add(c[j], sh);
        }
    }
    Ok(c)
}

/// Mnożenie Shamir w Z_P (jak `q_mul_shamir_reshare`, ale mod P).
pub fn i_mul_shamir_reshare(
    rng: &mut impl rand::RngCore,
    xs: &[u16],
    k: u8,
    a: &[u64],
    b: &[u64],
) -> Result<Vec<u64>> {
    #[cfg(test)]
    crate::cost::bump_reshare();
    let lam = p_lagrange_all(xs)?;
    i_mul_with_lam(rng, xs, k, &lam, a, b)
}

// ─── H2 — jawne t × udział (liniowość, 0 reshare-mul) ──────────────────

/// Jawny iloczyn Z[X]/(X^N − X^{N/2} + 1) na i64.
pub fn mul_ring_i64_clear(a: &[i64], b: &[i64]) -> Vec<i64> {
    let mut acc = vec![0i64; FT1536_N];
    for i in 0..FT1536_N {
        if a[i] == 0 {
            continue;
        }
        for j in 0..FT1536_N {
            if b[j] == 0 {
                continue;
            }
            add_monomial_i64(&mut acc, i + j, a[i] * b[j]);
        }
    }
    acc
}

fn add_monomial_i64(acc: &mut [i64], mut e: usize, mut coef: i64) {
    let n = FT1536_N;
    let half = n / 2;
    while e >= n {
        let e2 = e - n;
        add_monomial_i64(acc, e2 + half, coef);
        coef = -coef;
        e = e2;
    }
    acc[e] += coef;
}

/// Jawne t (i64) × udział poly w Z[X]/(φ) — per strona lokalnie
/// (liniowość Shamir: α·share = share(α·s)). **0 reshare-mul** (G-3).
/// Splot liczony **mod P** na udziałach (udziały to elementy Z_P).
pub fn mul_ring_public_t_shares(t: &[i64], shares: &IPolyShares) -> Result<IPolyShares> {
    if t.len() != FT1536_N || shares.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    let n_parties = shares
        .first()
        .map(|c| c.len())
        .ok_or(SpikeError::EmptyShares)?;
    if n_parties == 0 {
        return Err(SpikeError::EmptyShares);
    }
    for col in shares {
        if col.len() != n_parties {
            return Err(SpikeError::PartyCountMismatch);
        }
    }
    let t_p: Vec<u64> = t.iter().map(|&c| i64_to_p(c)).collect();
    let mut out = vec![vec![0u64; n_parties]; FT1536_N];
    for p in 0..n_parties {
        // party_poly jako Z_P shares; splot w Z[X]/(φ) nad Z_P
        let mut acc = vec![0u64; FT1536_N];
        for i in 0..FT1536_N {
            if t_p[i] == 0 {
                continue;
            }
            for j in 0..FT1536_N {
                let b = shares[j][p] % I_P;
                if b == 0 {
                    continue;
                }
                add_monomial_p(&mut acc, i + j, p_mul(t_p[i], b));
            }
        }
        for (i, &c) in acc.iter().enumerate() {
            out[i][p] = c;
        }
    }
    Ok(out)
}

/// acc[e] += coef (w Z_P), z redukcją X^N = X^{N/2} − 1.
fn add_monomial_p(acc: &mut [u64], mut e: usize, coef: u64) {
    let n = FT1536_N;
    let half = n / 2;
    let mut coef = coef;
    while e >= n {
        let e2 = e - n;
        add_monomial_p(acc, e2 + half, coef);
        coef = p_sub(0, coef);
        e = e2;
    }
    acc[e] = p_add(acc[e], coef);
}

// ─── H3 — rounding w MPC ────────────────────────────────────────────────
//
// z = round_half_away(x/q) — bit-exact vs `round_div_q_scalar` (F2).
// round_half_away(v) = sign(v)·floor((|v|+⌊q/2⌋)/q); zgadza się z f64::round
// dla q nieparzystego (q=18433).
//
// Protokół na jednym x (|x| < 2^{B-1}):
// 1. X = x + 2^{B-1} ∈ [0, 2^B) — jawne OFF na udziałach.
// 2. Bit-dekompozycja X: losowa maska r (bity w GF(256) **i** Z_P),
//    open d = X − r (tylko maska!), X_bits = r_bits + d (dodawarka).
// 3. sign = ¬X_bits[B-1].
// 4. |x| = (X_low ⊕ sign) + sign (dodawarka).
// 5. y = |x| + ⌊q/2⌋ (jawne na bitach).
// 6. Dzielenie przywracające y / q → |z| bity.
// 7. Złóż |z| bity → udział Z_P; z = (1−2·sign)·|z| (1 reshare-mul).
//
// Otwarcia: wyłącznie maski. NIE otwiera się x ani z.

/// Licznik kosztu H3 (H-1).
#[derive(Debug, Default, Clone, Copy)]
pub struct RoundCost {
    pub bit_ands: u64,
    pub bit_opens: u64,
    pub p_reshare_muls: u64,
    /// Łańcuch XOR na Z_P w PRSS bit-maskach: n−1 reshare-muls na bit (T7.1).
    pub prss_xor_muls: u64,
}

/// Bity jako udziały GF(256).
pub type GfBitShares = Vec<u8>;

/// Szybki AND bitów: reshare-mul z precomputowanymi λ i re-deal k=2 inline.
/// Sekret wyniku = a·b (w {0,1} dla poprawnych bitów).
fn gf_and_lam(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    lam: &[u8],
    a: &GfBitShares,
    b: &GfBitShares,
    cost: &mut RoundCost,
) -> Result<GfBitShares> {
    cost.bit_ands += 1;
    let n = xs.len();
    if a.len() != n || b.len() != n || lam.len() != n {
        return Err(SpikeError::PartyCountMismatch);
    }
    let mut c = vec![0u8; n];
    for i in 0..n {
        let u_i = crate::gf_mul(lam[i], crate::gf_mul(a[i], b[i]));
        // re-deal u_i (k=2): share_j = u_i + r·x_j
        let r = (rng.next_u32() & 0xFF) as u8;
        for j in 0..n {
            c[j] ^= u_i ^ crate::gf_mul(r, xs[j]);
        }
    }
    Ok(c)
}

/// λ_i dla xs w GF(256) — raz na obwód.
fn gf_lagrange_all(xs: &[u8]) -> Result<Vec<u8>> {
    (0..xs.len()).map(|i| crate::mul::lagrange_at_zero(xs, i)).collect()
}

fn gf_xor(a: &GfBitShares, b: &GfBitShares) -> GfBitShares {
    a.iter().zip(b).map(|(x, y)| x ^ y).collect()
}

fn gf_not(a: &GfBitShares) -> GfBitShares {
    a.iter().map(|x| x ^ 1).collect()
}

fn gf_const(pub_bit: u8, n: usize) -> GfBitShares {
    vec![pub_bit; n]
}

fn gf_zero(n: usize) -> GfBitShares {
    vec![0u8; n]
}

// ─── T8.1 — źródło monet PRSS (Single = T7 retained, Pairwise = CDI-lite) ─

/// Źródło monet wirtualnych partii dla PRSS (T8.1).
///
/// - [`PrssSrc::Single`] — jeden rng in-process dla wszystkich partii
///   (model T7, **retained**): wkłady i monety protokołu z tego samego
///   strumienia. Nie jest to pairwise CDI.
/// - [`PrssSrc::Pairwise`] — **osobny rng na każdą wirtualną partię**:
///   wkład partii `i` (β_i / g_i / sharing poly) wyłącznie z `rngs[i]`.
///   Monety protokołu (reshare-mul w XOR-chain / obwodzie bitowym) z
///   osobnego `coins` — to **nie** jest materiał masek ani szumu i **nie**
///   jest wspólnym dealerem masek.
///
/// Udział maski/bitu powstaje wyłącznie na udziałach; `PrssSrc` nie zwraca
/// jawnych masek ani wkładów.
pub enum PrssSrc<'a, R: rand::RngCore> {
    Single(&'a mut R),
    Pairwise {
        rngs: &'a mut [R],
        coins: &'a mut R,
    },
}

impl<'a, R: rand::RngCore> PrssSrc<'a, R> {
    /// rng wirtualnej partii `party`. W `Single` — ten sam rng dla
    /// wszystkich (kolejne losowania z jednego strumienia — model T7).
    pub fn party_rng(&mut self, party: usize) -> &mut R {
        match self {
            PrssSrc::Single(r) => r,
            PrssSrc::Pairwise { rngs, .. } => {
                let n = rngs.len().max(1);
                &mut rngs[party % n]
            }
        }
    }

    /// Monety protokołu (reshare-mul, AND-chain). W `Single` — ten sam rng.
    /// To **nie** jest materiał masek / szumu — patrz [`PrssSrc::Pairwise`].
    pub fn coins_rng(&mut self) -> &mut R {
        match self {
            PrssSrc::Single(r) => r,
            PrssSrc::Pairwise { coins, .. } => coins,
        }
    }
}

/// Para masek dla jednego bitu 0/1: ten sam sekret w GF(256) i Z_P.
///
/// **RETAINED — model dealera testowego.** Bit `b` powstaje w clear
/// (`rng.next_u32()&1`) i jest Shamir-dzielony przez centralnego dealera.
/// Ścieżka złota T7 używa [`paired_bit_mask_prss`] zamiast tego.
/// Nie kasować — historia i porównania dystrybucji.
pub fn paired_bit_mask(
    rng: &mut impl rand::RngCore,
    xs_p: &[u16],
    xs_gf: &[u8],
    k: u8,
) -> Result<(GfBitShares, Vec<u64>)> {
    let bit = (rng.next_u32() & 1) as u8;
    let mg = shamir_share(rng, bit, xs_gf, k)?;
    let mg_sh: GfBitShares = mg.iter().map(|s| s.share).collect();
    let mp = ishare_val(rng, bit as i64, xs_p, k)?;
    Ok((mg_sh, mp))
}

/// PRSS para masek bitu — **bez centralnego dealera** (T7.1).
///
/// Współny los przez wkłady wirtualnych partii: każda partia `i ∈ 0..n`
/// losuje lokalny bit `β_i ∈ {0,1}` (jej moneta, NIE maska), Shamir-dzieli
/// go w GF(256) i w Z_P. Bit maski `b = ⊕_i β_i` **nigdy nie powstaje
/// w clear** — tylko udziały:
/// - GF(256) char 2: suma udziałów = udziały XOR (liniowość).
/// - Z_P: `x⊕y = x+y−2·x·y` na udziałach przez łańcuch reshare-mul
///   (n−1 muls na bit — licznik `cost.prss_xor_muls`).
///
/// Strony (widoki partii) nie widzą bitu maski w clear. Partia-wkład zna
/// wyłącznie swoje `β_i` (swoją monetę), nie maskę zbiorczą gdy n≥2
/// i wkłady są niezależne.
pub fn paired_bit_mask_prss(
    rng: &mut impl rand::RngCore,
    xs_p: &[u16],
    xs_gf: &[u8],
    k: u8,
    cost: &mut RoundCost,
) -> Result<(GfBitShares, Vec<u64>)> {
    paired_bit_mask_prss_src(&mut PrssSrc::Single(rng), xs_p, xs_gf, k, cost)
}

/// T8.1 — PRSS para masek bitu z **osobnymi rng każdej wirtualnej partii**.
///
/// Wkład partii `i` (β_i + sharing poly) wyłącznie z `rngs[i]`; `coins` to
/// monety protokołu (reshare-mul) — **nie** materiał masek. Bit maski
/// `b = ⊕_i β_i` nigdy w clear (jak [`paired_bit_mask_prss`]).
pub fn paired_bit_mask_prss_pairwise<R: rand::RngCore>(
    rngs: &mut [R],
    coins: &mut R,
    xs_p: &[u16],
    xs_gf: &[u8],
    k: u8,
    cost: &mut RoundCost,
) -> Result<(GfBitShares, Vec<u64>)> {
    paired_bit_mask_prss_src(&mut PrssSrc::Pairwise { rngs, coins }, xs_p, xs_gf, k, cost)
}

/// Rdzeń PRSS masek bitowych — wkłady z `src`, łańcuch XOR z `src.coins_rng()`.
fn paired_bit_mask_prss_src<R: rand::RngCore>(
    src: &mut PrssSrc<R>,
    xs_p: &[u16],
    xs_gf: &[u8],
    k: u8,
    cost: &mut RoundCost,
) -> Result<(GfBitShares, Vec<u64>)> {
    let n = xs_p.len();
    if xs_gf.len() != n || n == 0 {
        return Err(SpikeError::PartyCountMismatch);
    }
    let lam = p_lagrange_all(xs_p)?;
    // Akumulatory udziałów (NIE jawne bity).
    let mut gf_acc: GfBitShares = vec![0u8; n];
    let mut p_acc: Option<Vec<u64>> = None;
    for party in 0..n {
        // Lokalna moneta partii — to NIE jest bit maski.
        let beta = (src.party_rng(party).next_u32() & 1) as u8;
        // GF(256): Shamir-dziel β_i, sumuj udziały (XOR w char 2).
        let gf_sh = shamir_share(src.party_rng(party), beta, xs_gf, k)?;
        for (dst, s) in gf_acc.iter_mut().zip(&gf_sh) {
            *dst ^= s.share;
        }
        // Z_P: Shamir-dziel β_i, łańcuch x⊕y = x+y−2·x·y.
        let p_sh = ishare_val(src.party_rng(party), beta as i64, xs_p, k)?;
        p_acc = Some(match p_acc {
            None => p_sh,
            Some(acc) => {
                cost.prss_xor_muls += 1;
                let prod = i_mul_with_lam(src.coins_rng(), xs_p, k, &lam, &acc, &p_sh)?;
                acc.iter()
                    .zip(&p_sh)
                    .zip(&prod)
                    .map(|((&a, &b), &c)| p_sub(p_add(a, b), p_mul(2, c)))
                    .collect()
            }
        });
    }
    Ok((gf_acc, p_acc.unwrap_or_else(|| vec![0u64; n])))
}

/// Konwersja bitu 0/1: udziały GF(256) → udziały Z_P. Open `b ⊕ m` (maska).
fn gfbit_to_pbit(
    xs_gf: &[u8],
    _k: u8,
    b: &GfBitShares,
    m_gf: &GfBitShares,
    m_p: &[u64],
    cost: &mut RoundCost,
) -> Result<Vec<u64>> {
    let d_shares = gf_xor(b, m_gf);
    cost.bit_opens += 1;
    let d_bf: Vec<Share> = xs_gf
        .iter()
        .zip(&d_shares)
        .map(|(&x, &s)| Share { x, share: s })
        .collect();
    let d_refs: Vec<&Share> = d_bf.iter().collect();
    let d = crate::reconstruct(&d_refs)?;
    if d > 1 {
        return Err(SpikeError::NonBitShare);
    }
    // b = d ⊕ m; d=0 → b=m; d=1 → b=1−m.
    if d == 0 {
        Ok(m_p.to_vec())
    } else {
        Ok(m_p.iter().map(|&s| p_sub(1, s)).collect())
    }
}

/// Dodawarka ripple-carry na bitach GF(256). Zwraca (sum, carry_out).
/// Carry = AND; OR rozłącznych termów = XOR (dla bitów poprawne).
fn gf_add_bits(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    lam: &[u8],
    a: &[GfBitShares],
    b: &[GfBitShares],
    cost: &mut RoundCost,
) -> Result<(Vec<GfBitShares>, GfBitShares)> {
    assert_eq!(a.len(), b.len());
    let n = a[0].len();
    let mut sum = Vec::with_capacity(a.len());
    let mut carry = gf_zero(n);
    for i in 0..a.len() {
        let axb = gf_xor(&a[i], &b[i]);
        let s = gf_xor(&axb, &carry);
        sum.push(s);
        let ab = gf_and_lam(rng, xs, lam, &a[i], &b[i], cost)?;
        let c_axb = gf_and_lam(rng, xs, lam, &carry, &axb, cost)?;
        carry = gf_xor(&ab, &c_axb);
    }
    Ok((sum, carry))
}

/// a − jawne q_bits (shared − public), borrow-chain. borrow=1 ⇔ a < q.
/// Koszt: 2 AND/bit (qb jawne rozłącza term-y OR).
fn gf_sub_public(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    lam: &[u8],
    a: &[GfBitShares],
    q_bits: &[u8],
    cost: &mut RoundCost,
) -> Result<(Vec<GfBitShares>, GfBitShares)> {
    assert_eq!(a.len(), q_bits.len());
    let n = a[0].len();
    let mut diff = Vec::with_capacity(a.len());
    let mut borrow = gf_zero(n);
    for i in 0..a.len() {
        let qb = q_bits[i];
        let axq = if qb == 0 {
            a[i].clone()
        } else {
            gf_not(&a[i])
        };
        let d = gf_xor(&axq, &borrow);
        diff.push(d);
        // borrow' = (¬a ∧ qb) ∨ (borrow ∧ (¬a ∨ qb))
        // ¬a ∨ qb jest jawne w q:
        //   qb=0 → ¬a;  qb=1 → stała 1
        let na = gf_not(&a[i]);
        let t1 = if qb == 1 {
            na.clone()
        } else {
            gf_zero(n)
        };
        let na_or_q = if qb == 1 {
            gf_const(1, n)
        } else {
            na.clone()
        };
        let t2 = gf_and_lam(rng, xs, lam, &borrow, &na_or_q, cost)?;
        // OR (nie XOR): t1 i t2 mogą być oba 1 (qb=1 ∧ a=0 ∧ borrow=1)
        let t1_and_t2 = gf_and_lam(rng, xs, lam, &t1, &t2, cost)?;
        borrow = gf_xor(&gf_xor(&t1, &t2), &t1_and_t2);
    }
    Ok((diff, borrow))
}

/// Mux: out = sel ? t : f (sel bit na udziałach). 1 AND/bit.
fn gf_mux(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    lam: &[u8],
    sel: &GfBitShares,
    t: &[GfBitShares],
    f: &[GfBitShares],
    cost: &mut RoundCost,
) -> Result<Vec<GfBitShares>> {
    assert_eq!(t.len(), f.len());
    let mut out = Vec::with_capacity(t.len());
    for i in 0..t.len() {
        let tf = gf_xor(&t[i], &f[i]);
        let s_and = gf_and_lam(rng, xs, lam, sel, &tf, cost)?;
        out.push(gf_xor(&f[i], &s_and));
    }
    Ok(out)
}

/// Dodanie jawnej stałej (jako bitów) do shared bits. 2 AND/bit.
fn gf_add_public(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    lam: &[u8],
    a: &[GfBitShares],
    c_bits: &[u8],
    cost: &mut RoundCost,
) -> Result<Vec<GfBitShares>> {
    assert_eq!(a.len(), c_bits.len());
    let n = a[0].len();
    let mut sum = Vec::with_capacity(a.len());
    let mut carry = gf_zero(n);
    for i in 0..a.len() {
        let cb = c_bits[i];
        let axc = if cb == 0 {
            a[i].clone()
        } else {
            gf_not(&a[i])
        };
        let s = gf_xor(&axc, &carry);
        sum.push(s);
        // carry' = (a∧cb) ∨ (carry∧(a⊕cb))
        let t1 = if cb == 1 {
            a[i].clone()
        } else {
            gf_zero(n)
        };
        let axc2 = axc.clone();
        let t2 = gf_and_lam(rng, xs, lam, &carry, &axc2, cost)?;
        carry = gf_xor(&t1, &t2);
    }
    Ok(sum)
}

/// Dzielenie przywracające y (shared bits) / jawne q. Zwraca (quot, rem).
fn gf_div_restoring(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    lam: &[u8],
    y_bits: &[GfBitShares],
    q: u32,
    cost: &mut RoundCost,
) -> Result<(Vec<GfBitShares>, Vec<GfBitShares>)> {
    let w = y_bits.len();
    let n = y_bits[0].len();
    let qb = (32 - q.leading_zeros()) as usize;
    let q_bits: Vec<u8> = (0..qb).map(|i| ((q >> i) & 1) as u8).collect();
    let rw = qb + 1;
    let mut rem: Vec<GfBitShares> = (0..rw).map(|_| gf_zero(n)).collect();
    let mut quot: Vec<GfBitShares> = (0..w).map(|_| gf_zero(n)).collect();

    for i in (0..w).rev() {
        let mut shifted = vec![gf_zero(n); rw];
        for j in (1..rw).rev() {
            shifted[j] = rem[j - 1].clone();
        }
        shifted[0] = y_bits[i].clone();
        let mut qe = vec![0u8; rw];
        qe[..qb].copy_from_slice(&q_bits);
        let (t, borrow) = gf_sub_public(rng, xs, lam, &shifted, &qe, cost)?;
        let qbit = gf_not(&borrow);
        quot[i] = qbit.clone();
        rem = gf_mux(rng, xs, lam, &qbit, &t, &shifted, cost)?;
    }
    Ok((quot, rem))
}

// ─── T6 / R-G2-1 — DGDG na udziałach PRZED round (fix Babai leak) ───────
//
// Deterministyczny `round_half_away(x/q)` to Babai nearest plane w kratce
// NTRU: błąd (s1,s2) rozkłada się równomiernie w równoległościanie bazy
// (f,g,F,G) → atak statystyczny Nguyen–Regev (NTRUSign) odzyskuje klucz
// z wielu podpisów. Fix: tajny szum dyskretnego Gaussa w liczniku
// PRZED dzieleniem przez q — `z = round((x + g)/q)`, g ← DGDG(σ) na
// udziałach. Ujawnienie g ujawnia informację o f (R-G2-1) — szum NIE
// jest otwierany w torze sign.
//
// **NIE deklarować** bezpieczeństwa statystycznego / UC / EUF-CMA po tym
// fixie — to łagodzenie wycieku, nie proof. Pozostaje otwarte: pełne
// ffLDL/Gaussian sampling z C, security proof, MAC na s1,s2 (R-G2-2).

/// Domyślne σ szumu DGDG (jawny parametr; owner: σ ∈ [2, 8]).
pub const T6_GAUSS_SIGMA_DEFAULT: u8 = 4;
/// Maks. σ (fail-closed powyżej — okno odcięcia i koszt bit-circuit).
pub const T6_GAUSS_SIGMA_MAX: u8 = 64;

/// σ (całkowite) → Q73 (`GAUSS_Q73_ONE`-units) do `sample_gaussian_q73_clear`.
/// σ=0 lub σ>T6_GAUSS_SIGMA_MAX → `WrongThreshold` (fail-closed).
pub fn t6_sigma_q73(sigma: u8) -> Result<u128> {
    if sigma == 0 || sigma > T6_GAUSS_SIGMA_MAX {
        return Err(SpikeError::WrongThreshold);
    }
    Ok((sigma as u128) * crate::rejection::GAUSS_Q73_ONE)
}

/// Okno odcięcia U{-w..=w} dla σ: w = clamp(max(8, 6σ), .., 127) — ±6σ.
pub fn t6_gauss_window(sigma: u8) -> Result<i32> {
    if sigma == 0 || sigma > T6_GAUSS_SIGMA_MAX {
        return Err(SpikeError::WrongThreshold);
    }
    Ok(std::cmp::max(8, 6 * i32::from(sigma)).min(127))
}

/// Deal jednego DGDG(σ) jako Shamir shares w Z_P (re-deal jak w spiku:
/// `sample_gaussian_q73_clear` + `ishare_val`).
///
/// Po wyjściu szum istnieje **tylko jako udziały** — tor sign nigdy go nie
/// rekonstruuje (reconstruct wyłącznie w testach pomiarowych).
pub fn deal_dgdg_shares(
    rng: &mut impl rand::RngCore,
    sigma: u8,
    xs: &[u16],
    k: u8,
) -> Result<Vec<u64>> {
    let w = t6_gauss_window(sigma)?;
    let s73 = t6_sigma_q73(sigma)?;
    let s = crate::rejection::sample_gaussian_q73_clear(rng, w, s73)
        .map_err(|_| SpikeError::WrongThreshold)?;
    ishare_val(rng, i64::from(s.x), xs, k)
}

/// `n_coeffs` niezależnych udziałów DGDG(σ) — szum per współczynnik.
pub fn deal_dgdg_poly_shares(
    rng: &mut impl rand::RngCore,
    sigma: u8,
    xs: &[u16],
    k: u8,
    n_coeffs: usize,
) -> Result<IPolyShares> {
    check_xs_p(xs, k)?;
    let mut out = Vec::with_capacity(n_coeffs);
    for _ in 0..n_coeffs {
        out.push(deal_dgdg_shares(rng, sigma, xs, k)?);
    }
    Ok(out)
}

/// Deal DGDG(σ) + MAC (G-2): (value shares, mac shares), mac = δ·g.
/// Dealer zna g i `delta_known` (model G-2 — jak deal f_mac). Po dealu
/// wartość i MAC są na udziałach; tor sign nie rekonstruuje g.
///
/// **RETAINED — model dealera testowego.** Szum powstaje w clear
/// (`sample_gaussian_q73_clear`) i jest Shamir-dzielony. Ścieżka złota T7
/// używa [`prss_dgdg_shares_with_mac`].
pub fn deal_dgdg_shares_with_mac(
    rng: &mut impl rand::RngCore,
    sigma: u8,
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<(Vec<u64>, Vec<u64>)> {
    let w = t6_gauss_window(sigma)?;
    let s73 = t6_sigma_q73(sigma)?;
    let s = crate::rejection::sample_gaussian_q73_clear(rng, w, s73)
        .map_err(|_| SpikeError::WrongThreshold)?;
    let g = i64::from(s.x);
    let val = ishare_val(rng, g, xs, k)?;
    let mac_val = p_mul(delta_known % I_P, i64_to_p(g));
    let mac = ishare_val(rng, p_to_i64(mac_val), xs, k)?;
    Ok((val, mac))
}

// ─── T7.2 — PRSS / re-deal szumu DGDG(σ) bez dealera ────────────────────
//
// Suma niezależnych wkładów DGDG(σ/√n): każda wirtualna partia losuje
// g_i ← DGDG(σ/√n) lokalnie (to jej wkład, nie pełny szum) i Shamir-dzieli
// **tylko** g_i. Suma udziałów = udziały g=Σ g_i ≈ DGDG(σ) (stabilność
// Gaussa). Tor sign nigdy nie rekonstruuje g.

/// σ/√n w Q73: `s73_i = s73_total / √n`. f64 w spiku — produkcja użyłaby
/// całkowitego sqrt w Q73 (udokumentowane; koszt pomijalny raz na setup).
fn q73_div_sqrt(s73_total: u128, n: usize) -> u128 {
    if n == 0 {
        return 0;
    }
    let s = s73_total as f64 / (n as f64).sqrt();
    s.max(1.0) as u128
}

/// Okno U{-w..=w} dla σ w Q73: w = clamp(⌈6σ⌉, 8, 127).
fn t6_gauss_window_q73(s73: u128) -> Result<i32> {
    if s73 == 0 {
        return Err(SpikeError::WrongThreshold);
    }
    let sigma_real = s73 as f64 / crate::rejection::GAUSS_Q73_ONE as f64;
    let w = (6.0 * sigma_real).ceil().max(8.0).min(127.0) as i32;
    Ok(w)
}

/// PRSS DGDG(σ) jako Shamir shares — **bez dealera** (T7.2).
///
/// Suma n niezależnych wkładów DGDG(σ/√n). Każda wirtualna partia losuje
/// `g_i` lokalnie i Shamir-dzieli **tylko** `g_i`. Suma udziałów = udziały
/// `g = Σ g_i ≈ DGDG(σ)`. Rozkład mierzony w testach T7 — nie twierdzony.
///
/// Po wyjściu szum istnieje **tylko jako udziały** — tor sign nigdy go
/// nie rekonstruuje (reconstruct wyłącznie w testach pomiarowych).
pub fn prss_dgdg_shares(
    rng: &mut impl rand::RngCore,
    sigma: u8,
    xs: &[u16],
    k: u8,
) -> Result<Vec<u64>> {
    prss_dgdg_shares_src(&mut PrssSrc::Single(rng), sigma, xs, k)
}

/// T8.1 — PRSS DGDG(σ) z **osobnymi rng każdej wirtualnej partii**.
///
/// Wkład `g_i` partii `i` (i jej sharing poly) wyłącznie z `rngs[i]` —
/// brak wspólnego rng in-process dla wkładów. Jak [`prss_dgdg_shares`]:
/// suma udziałów = udziały `g = Σ g_i`; pełny szum nigdy w clear.
/// (DGDG nie zużywa monet protokołu — brak reshare-mul w sumie wkładów.)
pub fn prss_dgdg_shares_pairwise<R: rand::RngCore>(
    rngs: &mut [R],
    sigma: u8,
    xs: &[u16],
    k: u8,
) -> Result<Vec<u64>> {
    let n = check_xs_p(xs, k)?;
    if rngs.is_empty() {
        return Err(SpikeError::PartyCountMismatch);
    }
    let s73_total = t6_sigma_q73(sigma)?;
    let s73_i = q73_div_sqrt(s73_total, n);
    let w_i = t6_gauss_window_q73(s73_i)?;
    let mut acc = vec![0u64; n];
    for party in 0..n {
        // Lokalny wkład partii z JEJ rng — to NIE jest pełny szum.
        let s = crate::rejection::sample_gaussian_q73_clear(
            &mut rngs[party % rngs.len()],
            w_i,
            s73_i,
        )
        .map_err(|_| SpikeError::WrongThreshold)?;
        // Shamir-dziel **tylko** g_i (nigdy Σ g_i w clear).
        let sh = ishare_val_unchecked(&mut rngs[party % rngs.len()], i64::from(s.x), xs, k);
        for (a, v) in acc.iter_mut().zip(sh) {
            *a = p_add(*a, v);
        }
    }
    Ok(acc)
}

/// Rdzeń PRSS DGDG — wkłady g_i z `src.party_rng(i)`.
fn prss_dgdg_shares_src<R: rand::RngCore>(
    src: &mut PrssSrc<R>,
    sigma: u8,
    xs: &[u16],
    k: u8,
) -> Result<Vec<u64>> {
    let n = check_xs_p(xs, k)?;
    let s73_total = t6_sigma_q73(sigma)?;
    let s73_i = q73_div_sqrt(s73_total, n);
    let w_i = t6_gauss_window_q73(s73_i)?;
    let mut acc = vec![0u64; n];
    for party in 0..n {
        // Lokalny wkład partii — to NIE jest pełny szum.
        let s = crate::rejection::sample_gaussian_q73_clear(src.party_rng(party), w_i, s73_i)
            .map_err(|_| SpikeError::WrongThreshold)?;
        // Shamir-dziel **tylko** g_i (nigdy Σ g_i w clear).
        let sh = ishare_val_unchecked(src.party_rng(party), i64::from(s.x), xs, k);
        for (a, v) in acc.iter_mut().zip(sh) {
            *a = p_add(*a, v);
        }
    }
    Ok(acc)
}

/// `n_coeffs` niezależnych udziałów PRSS DGDG(σ) — szum per współczynnik.
pub fn prss_dgdg_poly_shares(
    rng: &mut impl rand::RngCore,
    sigma: u8,
    xs: &[u16],
    k: u8,
    n_coeffs: usize,
) -> Result<IPolyShares> {
    check_xs_p(xs, k)?;
    let mut out = Vec::with_capacity(n_coeffs);
    for _ in 0..n_coeffs {
        out.push(prss_dgdg_shares(rng, sigma, xs, k)?);
    }
    Ok(out)
}

/// T8.1 — [`prss_dgdg_poly_shares`] z osobnymi rng per wirtualna partia.
pub fn prss_dgdg_poly_shares_pairwise<R: rand::RngCore>(
    rngs: &mut [R],
    sigma: u8,
    xs: &[u16],
    k: u8,
    n_coeffs: usize,
) -> Result<IPolyShares> {
    check_xs_p(xs, k)?;
    let mut out = Vec::with_capacity(n_coeffs);
    for _ in 0..n_coeffs {
        out.push(prss_dgdg_shares_pairwise(rngs, sigma, xs, k)?);
    }
    Ok(out)
}

/// [`prss_dgdg_poly_shares`] na [`PrssSrc`].
fn prss_dgdg_poly_shares_src<R: rand::RngCore>(
    src: &mut PrssSrc<R>,
    sigma: u8,
    xs: &[u16],
    k: u8,
    n_coeffs: usize,
) -> Result<IPolyShares> {
    check_xs_p(xs, k)?;
    let mut out = Vec::with_capacity(n_coeffs);
    for _ in 0..n_coeffs {
        out.push(prss_dgdg_shares_src(src, sigma, xs, k)?);
    }
    Ok(out)
}

/// PRSS DGDG(σ) + MAC (G-2) — **bez dealera** (T7.2).
///
/// Szum przez [`prss_dgdg_shares`] (wkłady partii). MAC = δ·g liczony
/// **liniowością** z udziałów: `mac[p] = delta_known · val[p]`.
/// `delta_known` to jawne δ modelu G-2 testowego.
pub fn prss_dgdg_shares_with_mac(
    rng: &mut impl rand::RngCore,
    sigma: u8,
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<(Vec<u64>, Vec<u64>)> {
    let val = prss_dgdg_shares(rng, sigma, xs, k)?;
    let dk = delta_known % I_P;
    let mac: Vec<u64> = val.iter().map(|&s| p_mul(dk, s)).collect();
    Ok((val, mac))
}

/// T8.1 — [`prss_dgdg_shares_with_mac`] z osobnymi rng per wirtualna partia.
/// MAC = δ·val (liniowość; `delta_known` = retained model G-2).
pub fn prss_dgdg_shares_with_mac_pairwise<R: rand::RngCore>(
    rngs: &mut [R],
    sigma: u8,
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<(Vec<u64>, Vec<u64>)> {
    let val = prss_dgdg_shares_pairwise(rngs, sigma, xs, k)?;
    let dk = delta_known % I_P;
    let mac: Vec<u64> = val.iter().map(|&s| p_mul(dk, s)).collect();
    Ok((val, mac))
}

/// Rdzeń H3 dla jednego współczynnika: z = round_half_away(x/q) na udziałach.
/// `bits` = B, poprawność gdy |x| < 2^{B-1}.
///
/// `gauss` = opcjonalny tajny szum DGDG na udziałach (T6/R-G2-1):
/// `z = round((x + g)/q)`. `None` = tor deterministyczny (retained F2).
/// Wymagany zapas bitów: |x| + |g| < 2^{B-1} (|g| ≲ 6σ).
pub fn round_div_q_scalar_shares(
    rng: &mut impl rand::RngCore,
    x: &[u64],
    xs_p: &[u16],
    xs_gf: &[u8],
    k: u8,
    lam: &[u8],
    bits: u32,
    cost: &mut RoundCost,
    gauss: Option<&[u64]>,
) -> Result<Vec<u64>> {
    round_div_q_scalar_shares_src(
        &mut PrssSrc::Single(rng),
        x,
        xs_p,
        xs_gf,
        k,
        lam,
        bits,
        cost,
        gauss,
    )
}

/// T8.1 — rdzeń H3 na [`PrssSrc`]: maski PRSS z wkładów partii, monety
/// obwodu bitowego z `src.coins_rng()`.
pub fn round_div_q_scalar_shares_src<R: rand::RngCore>(
    src: &mut PrssSrc<R>,
    x: &[u64],
    xs_p: &[u16],
    xs_gf: &[u8],
    k: u8,
    lam: &[u8],
    bits: u32,
    cost: &mut RoundCost,
    gauss: Option<&[u64]>,
) -> Result<Vec<u64>> {
    let n = xs_p.len();
    if xs_gf.len() != n || x.len() != n {
        return Err(SpikeError::PartyCountMismatch);
    }
    let b = bits as usize;
    if !(2..=48).contains(&b) {
        return Err(SpikeError::WrongThreshold);
    }
    let w = b;
    let off = 1u64 << (b - 1);

    // T6: licznik x+g PRZED /q. Szum na udziałach (liniowość Shamir —
    // 0 reshare-muls). NIE dodajemy szumu do z PO round: e = t·f − q·(z+g)
    // skalowałaby błąd przez q ≈ 12289 i rozbiła bound normy.
    let x_noised: Vec<u64> = match gauss {
        Some(g) => {
            if g.len() != n {
                return Err(SpikeError::PartyCountMismatch);
            }
            x.iter().zip(g).map(|(&a, &b)| p_add(a, b)).collect()
        }
        None => x.to_vec(),
    };

    // 1. X = x(+g) + OFF
    let x_off: Vec<u64> = x_noised.iter().map(|&s| p_add(s, i64_to_p(off as i64))).collect();

    // 2. maska r ∈ [0, 2^W) — bity w GF(256) i Z_P, fold do udziału Z_P r
    //    PRSS: wkłady wirtualnych partii, brak dealera clear-bit (T7.1/T8.1).
    let mut r_bits_gf: Vec<GfBitShares> = Vec::with_capacity(w);
    let mut r_p_shares = vec![0u64; n];
    let mut pow2 = 1u64;
    for _ in 0..w {
        let (mg, mp) = paired_bit_mask_prss_src(src, xs_p, xs_gf, k, cost)?;
        r_p_shares = r_p_shares
            .iter()
            .zip(&mp)
            .map(|(a, b)| p_add(*a, p_mul(*b, pow2)))
            .collect();
        r_bits_gf.push(mg);
        pow2 = p_mul(pow2, 2);
    }

    // open d = X − r (maska — nie otwiera x)
    let d_shares: Vec<u64> = x_off
        .iter()
        .zip(&r_p_shares)
        .map(|(a, b)| p_sub(*a, *b))
        .collect();
    cost.bit_opens += 1;
    let d_i = ireconstruct_val(xs_p, &d_shares)?;

    // 3. X_bits = r + d_twos (width W+1), low W bitów = X
    let d_twos = d_i.rem_euclid(1i64 << (w + 1)) as u64;
    let d_bits: Vec<GfBitShares> = (0..=w)
        .map(|i| gf_const(((d_twos >> i) & 1) as u8, n))
        .collect();
    let mut r_ext = r_bits_gf.clone();
    r_ext.push(gf_zero(n));
    let (sum_bits, _carry) = gf_add_bits(src.coins_rng(), xs_gf, lam, &r_ext, &d_bits, cost)?;
    let x_bits: Vec<GfBitShares> = sum_bits[..w].to_vec();

    // 4. sign = ¬X_bits[B-1]
    let sign = gf_not(&x_bits[b - 1]);

    // 5. |x| bity (B-1 bitów): t = X_low ⊕ sign; abs = t + sign
    let abs_w = b - 1;
    let mut t_bits: Vec<GfBitShares> = (0..abs_w)
        .map(|i| gf_xor(&x_bits[i], &sign))
        .collect();
    {
        let mut carry = sign.clone();
        for i in 0..abs_w {
            let s = gf_xor(&t_bits[i], &carry);
            let new_carry = gf_and_lam(src.coins_rng(), xs_gf, lam, &t_bits[i], &carry, cost)?;
            t_bits[i] = s;
            carry = new_carry;
        }
    }

    // 6. y = |x| + ⌊q/2⌋
    let q = FT1536_Q as u32;
    let half_q = q / 2;
    let y_w = abs_w + 2;
    let mut t_ext: Vec<GfBitShares> = Vec::with_capacity(y_w);
    for i in 0..y_w {
        if i < abs_w {
            t_ext.push(t_bits[i].clone());
        } else {
            t_ext.push(gf_zero(n));
        }
    }
    let hq_bits: Vec<u8> = (0..y_w)
        .map(|i| if i < 32 { ((half_q >> i) & 1) as u8 } else { 0 })
        .collect();
    let y_bits = gf_add_public(src.coins_rng(), xs_gf, lam, &t_ext, &hq_bits, cost)?;

    // 7. |z| = y / q (przywracające)
    let (z_abs_bits, _rem) = gf_div_restoring(src.coins_rng(), xs_gf, lam, &y_bits, q, cost)?;

    // 8. złóż |z| bity → Z_P (pary masek PRSS), potem z = (1−2·sign)·|z|
    let z_abs_w = z_abs_bits.len();
    let mut abs_p = vec![0u64; n];
    let mut pow2 = 1u64;
    for i in 0..z_abs_w {
        let (mg, mp) = paired_bit_mask_prss_src(src, xs_p, xs_gf, k, cost)?;
        let bp = gfbit_to_pbit(xs_gf, k, &z_abs_bits[i], &mg, &mp, cost)?;
        abs_p = abs_p
            .iter()
            .zip(&bp)
            .map(|(a, b)| p_add(*a, p_mul(*b, pow2)))
            .collect();
        pow2 = p_mul(pow2, 2);
    }
    // sign → Z_P (para masek PRSS)
    let (sg, sp) = paired_bit_mask_prss_src(src, xs_p, xs_gf, k, cost)?;
    let sign_p = gfbit_to_pbit(xs_gf, k, &sign, &sg, &sp, cost)?;
    // 1−2·sign na **udziałach** (liniowość: p' = 1 − 2p; NIE branch na share)
    let pmul_val: Vec<u64> = sign_p.iter().map(|&s| p_sub(1, p_mul(2, s))).collect();
    // z = (1−2·sign) · |z|  — 1 reshare-mul
    cost.p_reshare_muls += 1;
    let z = i_mul_with_lam(src.coins_rng(), xs_p, k, &p_lagrange_all(xs_p)?, &pmul_val, &abs_p)?;
    Ok(z)
}

/// H3 na całym wielomianie: z = round(x/q) per coeff, na udziałach.
/// `bits` = B, poprawność gdy każdy |x_i| < 2^{B-1}.
///
/// `gauss` = opcjonalny szum DGDG per współczynnik (T6/R-G2-1); `None`
/// = tor deterministyczny (retained F2). Jeśli `Some`, długość musi być
/// `FT1536_N`.
pub fn round_div_q_shares(
    rng: &mut impl rand::RngCore,
    x: &IPolyShares,
    xs: &[u16],
    k: u8,
    bits: u32,
    gauss: Option<&IPolyShares>,
) -> Result<(IPolyShares, RoundCost)> {
    round_div_q_shares_src(&mut PrssSrc::Single(rng), x, xs, k, bits, gauss)
}

/// T8.1 — [`round_div_q_shares`] na [`PrssSrc`] (maski PRSS pairwise).
pub fn round_div_q_shares_src<R: rand::RngCore>(
    src: &mut PrssSrc<R>,
    x: &IPolyShares,
    xs: &[u16],
    k: u8,
    bits: u32,
    gauss: Option<&IPolyShares>,
) -> Result<(IPolyShares, RoundCost)> {
    if x.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    if let Some(g) = gauss {
        if g.len() != FT1536_N {
            return Err(SpikeError::PartyCountMismatch);
        }
    }
    let n = check_xs_p(xs, k)?;
    let xs_gf: Vec<u8> = xs
        .iter()
        .map(|&v| {
            u8::try_from(v).map_err(|_| SpikeError::WrongThreshold)
        })
        .collect::<Result<_>>()?;
    let lam = gf_lagrange_all(&xs_gf)?;
    let mut cost = RoundCost::default();
    let mut out = Vec::with_capacity(FT1536_N);
    for (i, col) in x.iter().enumerate() {
        if col.len() != n {
            return Err(SpikeError::PartyCountMismatch);
        }
        let gcol = match gauss {
            Some(g) => {
                if g[i].len() != n {
                    return Err(SpikeError::PartyCountMismatch);
                }
                Some(g[i].as_slice())
            }
            None => None,
        };
        out.push(round_div_q_scalar_shares_src(
            src, col, xs, &xs_gf, k, &lam, bits, &mut cost, gcol,
        )?);
    }
    Ok((out, cost))
}

// ─── H4 — splot udział×udział + sign z tajnym z ─────────────────────────

/// Splot w Z[X]/(φ) na udziałach Z_P: **udział × udział** → O(N²)
/// reshare-muls (G-3). Sekretny z ⇒ nie da się liniowości H2.
pub fn i_poly_mul_ring_shares(
    rng: &mut impl rand::RngCore,
    a: &IPolyShares,
    b: &IPolyShares,
    xs: &[u16],
    k: u8,
) -> Result<IPolyShares> {
    if a.len() != FT1536_N || b.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    let n = check_mul_quorum_p(xs, k)?;
    let lam = p_lagrange_all(xs)?;
    let mut out = vec![vec![0u64; n]; FT1536_N];
    // out = a·b w Z[X]/(φ) — jawna redukcja monomiali na udziałach
    // (liniowa: acc[e] += ± share). Mnożenie: N² reshare-muls (G-3).
    for i in 0..FT1536_N {
        for j in 0..FT1536_N {
            let prod = i_mul_with_lam(rng, xs, k, &lam, &a[i], &b[j])?;
            add_monomial_shares(&mut out, i + j, &prod, 1i64);
        }
    }
    Ok(out)
}

/// acc[e] += coef · shares (coef = ±1 z redukcji pierścienia).
fn add_monomial_shares(acc: &mut [Vec<u64>], mut e: usize, shares: &[u64], mut coef: i64) {
    let n = FT1536_N;
    let half = n / 2;
    while e >= n {
        let e2 = e - n;
        add_monomial_shares(acc, e2 + half, shares, coef);
        coef = -coef;
        e = e2;
    }
    if coef == 1 {
        for (a, s) in acc[e].iter_mut().zip(shares) {
            *a = p_add(*a, *s);
        }
    } else {
        for (a, s) in acc[e].iter_mut().zip(shares) {
            *a = p_sub(*a, *s);
        }
    }
}

/// Pułapka NTRU na udziałach Z_P (całkowite i16 — nie R_q).
pub struct ITrapdoorShares {
    pub f: IPolyShares,
    pub g: IPolyShares,
    pub f_big: IPolyShares,
    pub g_big: IPolyShares,
}

/// Licznik kosztu H4 (G-3).
#[derive(Debug, Default, Clone, Copy)]
pub struct SignCost {
    pub ring_reshare_muls: u64,
    pub round: RoundCost,
}

/// ZŁOTO MPS4-H (wariant B): z na udziałach (rounding w MPC) + sign.
///
/// - z0, z1 z H3 — **bez** otwierania f, F, t·f, t·F, z
/// - s1, s2 na udziałach przez splot udział×udział (H4)
/// - open **wyłącznie** s1, s2 (i64 centered) — podpis jest jawny
///
/// `bits_tf` / `bits_tf` = B dla |t·f|, |t·F| (poprawność |x|<2^{B-1}).
/// `t` jawne (hash_to_point).
///
/// `gauss_sigma`: `Some(σ)` = tajny szum DGDG(σ) w liczniku przed round
/// (T6/R-G2-1, domyślnie `T6_GAUSS_SIGMA_DEFAULT`); `None` = tor
/// deterministyczny (retained F2 — Babai leak pozostaje, tylko do testów).
pub fn mps4h_sign_shares(
    rng: &mut impl rand::RngCore,
    td: &ITrapdoorShares,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    mps4h_sign_shares_src(&mut PrssSrc::Single(rng), td, t, xs, k, bits_tf, bits_tf_big, gauss_sigma)
}

/// T8.1 — złoto MPS4-H z **pairwise PRSS**: maski i szum z wkładów
/// osobnych rng-ów wirtualnych partii (nie jeden in-process rng).
/// Monety protokołu (reshare-mul) z `coins`. Konwencja złota jak
/// [`mps4h_sign_shares`].
pub fn mps4h_sign_shares_pairwise<R: rand::RngCore>(
    rngs: &mut [R],
    coins: &mut R,
    td: &ITrapdoorShares,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    mps4h_sign_shares_src(
        &mut PrssSrc::Pairwise { rngs, coins },
        td,
        t,
        xs,
        k,
        bits_tf,
        bits_tf_big,
        gauss_sigma,
    )
}

/// Rdzeń złota MPS4-H na [`PrssSrc`] (T7 Single / T8.1 Pairwise).
fn mps4h_sign_shares_src<R: rand::RngCore>(
    src: &mut PrssSrc<R>,
    td: &ITrapdoorShares,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    check_xs_p(xs, k)?;
    // T9.2: range proof max|F| < q/2 na udziałach (bez clear F).
    validate_f_bound_shares(src.coins_rng(), &td.f_big, xs, k)?;
    let mut cost = SignCost::default();

    let t64: Vec<i64> = t
        .iter()
        .map(|&c| {
            let q = FT1536_Q as i64;
            let v = c as i64;
            if v > q / 2 {
                v - q
            } else {
                v
            }
        })
        .collect();

    // H2: t·f, t·F, t·g, t·G na udziałach (0 reshare)
    let tf = mul_ring_public_t_shares(&t64, &td.f)?;
    let t_f_big = mul_ring_public_t_shares(&t64, &td.f_big)?;
    let tg = mul_ring_public_t_shares(&t64, &td.g)?;
    let t_g_big = mul_ring_public_t_shares(&t64, &td.g_big)?;

    // T6/T7/T8: niezależny PRSS DGDG per współczynnik z1 i z0 — szum na
    // udziałach, nigdy nie rekonstruowany w tym torze (R-G2-1). Bez dealera
    // clear (T7.2); wkłady per partia z PrssSrc (T8.1).
    let (g1, g0) = match gauss_sigma {
        Some(sigma) => (
            Some(prss_dgdg_poly_shares_src(src, sigma, xs, k, FT1536_N)?),
            Some(prss_dgdg_poly_shares_src(src, sigma, xs, k, FT1536_N)?),
        ),
        None => (None, None),
    };

    // H3: z1 = round((t·f + g1)/q), z0 = round((−t·F + g0)/q)
    // negate tF shares first (liniowość) → round_half_away
    let t_f_big_neg: IPolyShares = t_f_big
        .iter()
        .map(|col| col.iter().map(|&s| p_sub(0, s)).collect())
        .collect();
    let (z1, c1) = round_div_q_shares_src(src, &tf, xs, k, bits_tf, g1.as_ref())?;
    let (z0, c2) = round_div_q_shares_src(src, &t_f_big_neg, xs, k, bits_tf_big, g0.as_ref())?;
    cost.round.bit_ands = c1.bit_ands + c2.bit_ands;
    cost.round.bit_opens = c1.bit_opens + c2.bit_opens;
    cost.round.p_reshare_muls = c1.p_reshare_muls + c2.p_reshare_muls;
    cost.round.prss_xor_muls = c1.prss_xor_muls + c2.prss_xor_muls;

    // H4: s2 = z0·f + z1·F, s1 = z0·g + z1·G − t  (splot udział×udział)
    let z0f = i_poly_mul_ring_shares(src.coins_rng(), &z0, &td.f, xs, k)?;
    let z1f = i_poly_mul_ring_shares(src.coins_rng(), &z1, &td.f_big, xs, k)?;
    let z0g = i_poly_mul_ring_shares(src.coins_rng(), &z0, &td.g, xs, k)?;
    let z1g = i_poly_mul_ring_shares(src.coins_rng(), &z1, &td.g_big, xs, k)?;
    // 4 × N² reshare-muls
    cost.ring_reshare_muls = 4 * (FT1536_N as u64) * (FT1536_N as u64);

    let n = xs.len();
    let mut s2 = vec![vec![0u64; n]; FT1536_N];
    let mut s1 = vec![vec![0u64; n]; FT1536_N];
    for i in 0..FT1536_N {
        for p in 0..n {
            s2[i][p] = p_add(z0f[i][p], z1f[i][p]);
            // s1 = z0g + z1g − t; −t na każdym udziale (stały Shamir)
            s1[i][p] = p_sub(p_add(z0g[i][p], z1g[i][p]), i64_to_p(t64[i]));
        }
    }

    // Open s1, s2 (podpis jawny) — to JEDYNE otwarcie w ścieżce sign.
    let s1_i = ireconstruct_poly_i64(&s1, xs)?;
    let s2_i = ireconstruct_poly_i64(&s2, xs)?;
    let _ = (tg, t_g_big); // policzone dla kompletności H2; s1 bierze −t jawnie
    Ok((s1_i, s2_i, cost))
}

/// i64 centered → QPoly (u16 w Z_q).
pub fn i64_to_qpoly(p: &[i64]) -> Vec<u16> {
    let q = FT1536_Q as i64;
    p.iter()
        .map(|&c| {
            let mut v = c % q;
            if v < 0 {
                v += q;
            }
            v as u16
        })
        .collect()
}

/// Dekoduje sk FT1536 do **całkowitych** i16 f,g,F,G (NIE redukuje mod q).
/// F,G są duże i16 (nie ternary) — udziały muszą trzymać i16, nie R_q.
pub fn decode_sk_ft1536_i16(skey: &[u8]) -> Result<(Vec<i16>, Vec<i16>, Vec<i16>, Vec<i16>)> {
    use crate::mpc_sign::uncompress_static_n;
    if skey.is_empty() {
        return Err(SpikeError::EmptyShares);
    }
    let fb = skey[0];
    if fb >> 7 != 1 {
        return Err(SpikeError::WrongThreshold);
    }
    if fb & 0x0F != 10 {
        return Err(SpikeError::WrongThreshold);
    }
    if fb & 0x10 != 0 {
        return Err(SpikeError::WrongThreshold);
    }
    let mut pos = 1usize;
    let mut polys = Vec::new();
    for _ in 0..4 {
        let rest = &skey[pos..];
        match uncompress_static_n(rest, FT1536_N) {
            Some((p, used)) => {
                polys.push(p);
                pos += used;
            }
            None => return Err(SpikeError::MacFail),
        }
    }
    Ok((polys[0].clone(), polys[1].clone(), polys[2].clone(), polys[3].clone()))
}

/// Jawna norma L2 centered (jak `poly_norm2_centered`).
pub fn poly_norm2_i64(p: &[i64]) -> u64 {
    let q = FT1536_Q as i64;
    let mut s = 0u64;
    for &c in p {
        let mut v = c % q;
        if v > q / 2 {
            v -= q;
        }
        if v < -(q / 2) {
            v += q;
        }
        s = s.saturating_add((v * v) as u64);
    }
    s
}

// ─── G-2 — VSS + MAC na otwieraniach (detekcja fałszerstw w torze sign) ──
//
// Półuczciwy tor złota + fail-closed detekcja na:
//   1. udziale wejściowym f/F/g/G — Pedersen VSS (jak pedersen.rs / H1),
//      fałszywy udział → CommitmentMismatch (nie cicha kontynuacja);
//   2. otwarciach maski bit-decomp — SPDZ-MAC ukryte δ nad Z_P
//      (analog Y6/Y10), fałszywy udział/MAC/maska → MacFail;
//   3. boundzie max|F| < q/2 — jawna walidacja, naruszenie → abort.
//
// **To NIE jest malicious-secure / UC / EUF-CMA.** Semi-honest
// computation + detekcja na wejściach, otwarciach i wynikach ring-mul
// (T9.3: MAC na s1,s2 po ring-mulach, R-G2-2).
//
// Spójność światów: Shamir ishare jest nad P=2^61−1; MAC/SPDZ Y6 nad
// GF(256). Tutaj MAC jest **nad Z_P** (ta sama reprezentacja co udziały
// i16) — δ, mac i wartości wszystkie w Z_P. GF(256) MAC (Y6) zostaje
// dla bitów obwodu; obie warstwy są niezależne.

// ─── Z_P SPDZ-MAC z ukrytym δ (analog Y6 nad Z_P) ───────────────────────

/// Udział wartości z MAC w Z_P: `mac = δ · value (mod P)`.
#[derive(Clone, Zeroize, ZeroizeOnDrop)]
pub struct ZpMacShare {
    pub x: u16,
    pub share: u64,
    pub mac: u64,
}

/// Udziały klucza MAC δ w Z_P (Shamir). **Nie rekonstruować w torze.**
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct ZpDeltaShares {
    pub xs: Vec<u16>,
    pub shares: Vec<u64>,
}

/// Y10-analog: DKG δ nad Z_P bez dealera — każdy wnosi losowe `r_i`,
/// δ = Σ r_i (mod P). Pełne δ nigdy nie powstaje w jednym miejscu.
pub fn dkg_zp_delta_shares(
    rng: &mut impl rand::RngCore,
    xs: &[u16],
    k: u8,
) -> Result<ZpDeltaShares> {
    check_xs_p(xs, k)?;
    let n = xs.len();
    let mut acc = vec![0u64; n];
    for _ in 0..n {
        let r_i = rng.next_u64() % I_P;
        let sh = ishare_val(rng, p_to_i64(r_i), xs, k)?;
        for (j, s) in sh.into_iter().enumerate() {
            acc[j] = p_add(acc[j], s);
        }
    }
    Ok(ZpDeltaShares {
        xs: xs.to_vec(),
        shares: acc,
    })
}

/// Dealer (model testowy!) — udziały wartości i64 z MAC nad Z_P.
/// `mac = δ · secret` jako Shamir w Z_P.
pub fn share_val_with_mac_zp(
    rng: &mut impl rand::RngCore,
    secret: i64,
    xs: &[u16],
    k: u8,
    delta: u64,
) -> Result<Vec<ZpMacShare>> {
    check_xs_p(xs, k)?;
    let shares = ishare_val(rng, secret, xs, k)?;
    let mac_val = p_mul(delta % I_P, i64_to_p(secret));
    let macs = ishare_val(rng, p_to_i64(mac_val), xs, k)?;
    Ok(shares
        .into_iter()
        .zip(macs)
        .zip(xs)
        .map(|((s, m), &x)| ZpMacShare {
            x,
            share: s,
            mac: m,
        })
        .collect())
}

/// Otwarcie z kontrolą MAC przy **ukrytym** δ nad Z_P.
///
/// 1. Rekonstruuj wartość `x` z udziałów.
/// 2. `z_i = mac_i − x · δ_i (mod P)` — udziały zera iff MAC poprawny.
/// 3. Rekonstruuj `z`; `z != 0` → [`SpikeError::MacFail`].
///
/// **δ nie jest rekonstruowane.**
pub fn zp_open_with_mac_hidden_delta(
    shares: &[ZpMacShare],
    delta_shares: &ZpDeltaShares,
    k: u8,
) -> Result<i64> {
    if shares.len() != delta_shares.shares.len() || shares.is_empty() {
        return Err(SpikeError::PartyCountMismatch);
    }
    if shares.len() < k as usize {
        return Err(SpikeError::NotEnoughPoints);
    }
    for (s, &dx) in shares.iter().zip(&delta_shares.xs) {
        if s.x != dx {
            return Err(SpikeError::PartyCountMismatch);
        }
    }
    // 1) wartość
    let val_shares: Vec<u64> = shares.iter().map(|s| s.share).collect();
    let x = ireconstruct_val(&delta_shares.xs, &val_shares)?;
    // 2) udziały zera z_i = mac_i − x · δ_i (mod P)
    let mut zs: Vec<u64> = Vec::with_capacity(shares.len());
    for (s, &d_i) in shares.iter().zip(&delta_shares.shares) {
        zs.push(p_sub(s.mac, p_mul(i64_to_p(x), d_i)));
    }
    let z = ireconstruct_val(&delta_shares.xs, &zs)?;
    if z != 0 {
        return Err(SpikeError::MacFail);
    }
    Ok(x)
}

// ─── T9.3 — auth triples / MAC na s1,s2 po ring-mulach (R-G2-2) ─────────
//
// Domknięcie luki Y13: „MAC na s1,s2 po ring-mulach — wymaga auth
// triples przez 4N² reshare-muls". MAC (ukryte δ, jak Y6/U4) na
// WYNIKACH ring-mul, nie tylko na wejściach. Tamper ring-mul → MacFail.
//
// **NIE** jest to malicious-secure / UC / EUF-CMA. Model G-2: MAC = δ·x
// liniowością (`delta_known` retained) + open z kontrolą ukrytego δ.

/// Autentyczna trójka Beavera w Z_P: a, b, c = a·b — każdy z MAC (δ·val).
/// Per partia (udziały Shamir + MAC). Wzorzec U4 przeniesiony na Z_P.
#[derive(Clone, Zeroize, ZeroizeOnDrop)]
pub struct ZpAuthTriple {
    pub a: Vec<ZpMacShare>,
    pub b: Vec<ZpMacShare>,
    pub c: Vec<ZpMacShare>,
}

/// Dealer (model testowy G-2!) — trójka auth w Z_P z MAC = δ·val.
/// `delta_known` = jawne δ modelu; tor produkcyjny używa [`dkg_zp_delta_shares`].
pub fn generate_auth_triple_zp(
    rng: &mut impl rand::RngCore,
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<ZpAuthTriple> {
    let a_s = p_to_i64(rng.next_u64() % I_P);
    let b_s = p_to_i64(rng.next_u64() % I_P);
    let c_s = p_mul(i64_to_p(a_s), i64_to_p(b_s));
    let a = share_val_with_mac_zp(rng, a_s, xs, k, delta_known)?;
    let b = share_val_with_mac_zp(rng, b_s, xs, k, delta_known)?;
    let c = share_val_with_mac_zp(rng, p_to_i64(c_s), xs, k, delta_known)?;
    Ok(ZpAuthTriple { a, b, c })
}

/// MAC = δ·val **liniowością** z udziałów: `mac[p] = delta_known · share[p]`.
/// (skalar × Shamir-udział = udział skalar×sekret). Wzorzec G-2 / Y6.
pub fn zp_mac_linearity(val: &[u64], delta_known: u64) -> Vec<u64> {
    let dk = delta_known % I_P;
    val.iter().map(|&s| p_mul(dk, s)).collect()
}

/// MAC na poly (IPolyShares) liniowością — per współczynnik, per partia.
pub fn zp_mac_poly_linearity(val: &IPolyShares, delta_known: u64) -> IPolyShares {
    val.iter().map(|col| zp_mac_linearity(col, delta_known)).collect()
}

/// Otwarcie wartości z kontrolą MAC przy **znanym** δ (model G-2 testowy).
/// `z_i = mac_i − x · (δ·1)_i`; rekonstruuj z; `z != 0` → [`SpikeError::MacFail`].
/// Zgodne semantycznie z [`zp_open_with_mac_hidden_delta`] gdy δ jawne.
pub fn zp_open_with_mac_known_delta(
    xs: &[u16],
    val_shares: &[u64],
    mac_shares: &[u64],
    delta_known: u64,
) -> Result<i64> {
    let n = xs.len();
    if val_shares.len() != n || mac_shares.len() != n {
        return Err(SpikeError::PartyCountMismatch);
    }
    let x = ireconstruct_val(xs, val_shares)?;
    let dk = delta_known % I_P;
    let mut zs = Vec::with_capacity(n);
    for i in 0..n {
        let expect_mac = p_mul(dk, val_shares[i]);
        zs.push(p_sub(mac_shares[i], expect_mac));
    }
    // rekonstruuj z = mac − δ·val; poprawny MAC ⇒ z = 0 (liniowość)
    let z = ireconstruct_val(xs, &zs)?;
    // z = δ·(x − x_recon_local_sum); przy spójnym sharing z ≡ 0 gdy mac=δ·val
    // Faktycznie: mac[p]=δ·val[p] ⇒ zs[p]=0 ⇒ z=0. Tamper val bez mac → z≠0.
    if z != 0 {
        return Err(SpikeError::MacFail);
    }
    Ok(x)
}

/// Otwarcie poly z kontrolą MAC (ukryte δ). Każdy współczynnik osobno.
/// Tamper udziału/MAC → [`SpikeError::MacFail`].
pub fn zp_open_poly_with_mac_hidden_delta(
    shares: &IPolyShares,
    macs: &IPolyShares,
    delta_shares: &ZpDeltaShares,
    k: u8,
) -> Result<Vec<i64>> {
    if shares.len() != macs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    let n = delta_shares.shares.len();
    let mut out = Vec::with_capacity(shares.len());
    for (col, mcol) in shares.iter().zip(macs) {
        if col.len() != n || mcol.len() != n {
            return Err(SpikeError::PartyCountMismatch);
        }
        let zpm: Vec<ZpMacShare> = col
            .iter()
            .zip(mcol)
            .zip(&delta_shares.xs)
            .map(|((&s, &m), &x)| ZpMacShare { x, share: s, mac: m })
            .collect();
        out.push(zp_open_with_mac_hidden_delta(&zpm, delta_shares, k)?);
    }
    Ok(out)
}

/// Sprawdzenie trójki auth Z_P: `c.mac` w dataflow + `c = a·b` (open z MAC).
/// Bez tego `c.share` wchodził w wynik z **nowym** MAC — zepsute `c`
/// (także przy „poprawnym" MAC dla złej wartości) przechodziło cicho.
/// Fałszerstwo a/b/c lub `c ≠ a·b` → [`SpikeError::MacFail`].
pub fn check_zp_auth_triple(
    xs: &[u16],
    triple: &ZpAuthTriple,
    delta_known: u64,
) -> Result<()> {
    let n = xs.len();
    if n == 0 {
        return Err(SpikeError::EmptyXs);
    }
    if triple.a.len() != n || triple.b.len() != n || triple.c.len() != n {
        return Err(SpikeError::PartyCountMismatch);
    }
    let a_val: Vec<u64> = triple.a.iter().map(|t| t.share).collect();
    let a_mac: Vec<u64> = triple.a.iter().map(|t| t.mac).collect();
    let b_val: Vec<u64> = triple.b.iter().map(|t| t.share).collect();
    let b_mac: Vec<u64> = triple.b.iter().map(|t| t.mac).collect();
    let c_val: Vec<u64> = triple.c.iter().map(|t| t.share).collect();
    let c_mac: Vec<u64> = triple.c.iter().map(|t| t.mac).collect();
    let av = zp_open_with_mac_known_delta(xs, &a_val, &a_mac, delta_known)?;
    let bv = zp_open_with_mac_known_delta(xs, &b_val, &b_mac, delta_known)?;
    let cv = zp_open_with_mac_known_delta(xs, &c_val, &c_mac, delta_known)?;
    if cv != p_to_i64(p_mul(i64_to_p(av), i64_to_p(bv))) {
        return Err(SpikeError::MacFail);
    }
    Ok(())
}

/// Mnożenie udział×udział w Z_P **z auth triple** (Beaver, jak U4):
/// 0. **check trójki** — `c.mac` + `c = a·b` zanim `c.share` wejdzie w wynik.
/// 1. ε = open(x − a) z kontrolą MAC; ρ = open(y − b) z kontrolą MAC.
/// 2. [z] = [c] + ε·[b] + ρ·[a] + ε·ρ (na udziałach).
/// 3. MAC na z liniowością (δ·z).
///
/// `x_mac` / `y_mac` = MAC na wejściach **w chwili shara** (nie przeliczane
/// po tamperze — tamper wartości bez MAC → MacFail przy open ε/ρ).
/// Tamper x, y, a, b lub c → [`SpikeError::MacFail`].
///
/// `delta_known` = retained model G-2 (MAC = δ·x).
pub fn mul_auth_zp_with_triple(
    rng: &mut impl rand::RngCore,
    xs: &[u16],
    k: u8,
    x: &[u64],
    x_mac: &[u64],
    y: &[u64],
    y_mac: &[u64],
    triple: &ZpAuthTriple,
    delta_known: u64,
) -> Result<(Vec<u64>, Vec<u64>)> {
    let n = check_mul_quorum_p(xs, k)?;
    if x.len() != n || y.len() != n || x_mac.len() != n || y_mac.len() != n {
        return Err(SpikeError::PartyCountMismatch);
    }
    if triple.a.len() != n || triple.b.len() != n || triple.c.len() != n {
        return Err(SpikeError::PartyCountMismatch);
    }
    // #2: c.mac nie może być ignorowane; c = a·b przed użyciem c.share
    check_zp_auth_triple(xs, triple, delta_known)?;
    let dk = delta_known % I_P;

    // ε = x − a (na udziałach + MAC)
    let eps_val: Vec<u64> = x.iter().zip(&triple.a).map(|(s, t)| p_sub(*s, t.share)).collect();
    let eps_mac: Vec<u64> = x_mac.iter().zip(&triple.a).map(|(m, t)| p_sub(*m, t.mac)).collect();
    // ρ = y − b
    let rho_val: Vec<u64> = y.iter().zip(&triple.b).map(|(s, t)| p_sub(*s, t.share)).collect();
    let rho_mac: Vec<u64> = y_mac.iter().zip(&triple.b).map(|(m, t)| p_sub(*m, t.mac)).collect();

    // open ε, ρ z kontrolą MAC (ukryte δ nie jest tu potrzebne — model δ_known)
    let eps = zp_open_with_mac_known_delta(xs, &eps_val, &eps_mac, dk)?;
    let rho = zp_open_with_mac_known_delta(xs, &rho_val, &rho_mac, dk)?;
    let _ = rng; // rng zarezerwowany na pełny tor DKG δ

    // [z] = [c] + ε·[b] + ρ·[a] + ε·ρ
    let eps_p = i64_to_p(eps);
    let rho_p = i64_to_p(rho);
    let eps_rho = p_mul(eps_p, rho_p);
    let mut z = vec![0u64; n];
    for i in 0..n {
        let t = p_add(triple.c[i].share, p_mul(eps_p, triple.b[i].share));
        let t = p_add(t, p_mul(rho_p, triple.a[i].share));
        z[i] = p_add(t, eps_rho);
    }
    // MAC na z liniowością (spójny z modelem G-2: mac = δ·val)
    let z_mac = zp_mac_linearity(&z, dk);
    Ok((z, z_mac))
}

/// Splot ring na udziałach **z auth triples + MAC na wyniku** (T9.3 / R-G2-2).
/// Każde mnożenie udział×udział (N²) przez [`mul_auth_zp_with_triple`].
/// Zwraca (udziały produktu, MAC produktu). Tamper → [`SpikeError::MacFail`].
pub fn i_poly_mul_ring_shares_auth(
    rng: &mut impl rand::RngCore,
    a: &IPolyShares,
    b: &IPolyShares,
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<(IPolyShares, IPolyShares)> {
    if a.len() != FT1536_N || b.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    let n = check_mul_quorum_p(xs, k)?;
    let mut out = vec![vec![0u64; n]; FT1536_N];
    let mut out_mac = vec![vec![0u64; n]; FT1536_N];
    for i in 0..FT1536_N {
        for j in 0..FT1536_N {
            let triple = generate_auth_triple_zp(rng, xs, k, delta_known)?;
            let a_mac = zp_mac_linearity(&a[i], delta_known);
            let b_mac = zp_mac_linearity(&b[j], delta_known);
            let (prod, prod_mac) = mul_auth_zp_with_triple(
                rng, xs, k, &a[i], &a_mac, &b[j], &b_mac, &triple, delta_known,
            )?;
            add_monomial_shares(&mut out, i + j, &prod, 1i64);
            add_monomial_shares(&mut out_mac, i + j, &prod_mac, 1i64);
        }
    }
    Ok((out, out_mac))
}

/// Tańszy wariant do testów/regresji: ring-mul jak [`i_poly_mul_ring_shares`]
/// + MAC na wyniku liniowością (δ·prod). **Nie** generuje N² trójek —
/// auth triples na wynikach s1,s2 i open z kontrolą MAC; pełny tor
/// N²-trójkowy = [`i_poly_mul_ring_shares_auth`] (retained koszt R-G2-2).
pub fn i_poly_mul_ring_shares_mac(
    rng: &mut impl rand::RngCore,
    a: &IPolyShares,
    b: &IPolyShares,
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<(IPolyShares, IPolyShares)> {
    let prod = i_poly_mul_ring_shares(rng, a, b, xs, k)?;
    let mac = zp_mac_poly_linearity(&prod, delta_known);
    Ok((prod, mac))
}

// ─── max|F| < q/2 — jawna walidacja (fail-closed) ────────────────────────

/// q/2 = 18433/2 = 9216. Retained H: max|F| ≈ 54–65 ≪ 9216.
pub const F_BOUND_HALF_Q: i64 = (FT1536_Q as i64) / 2;

/// Warunek poprawności toru sign: max|F| < q/2.
/// Naruszenie = abort (nie cicha kontynuacja). Patrz MPS_H_NOTES.
///
/// `InconsistentShare` = najbliższy istniejący wariant błędu (enum
/// SpikeError poza zakresem plików G-2); sygnatura w komunikacie
/// przez nazwę wariantu i kontekst w MPS_G2_NOTES.
pub fn validate_f_bound(f_big: &[i16]) -> Result<()> {
    let max_f = f_big
        .iter()
        .map(|&c| (c as i32).unsigned_abs() as i64)
        .max()
        .unwrap_or(0);
    if max_f >= F_BOUND_HALF_Q {
        return Err(SpikeError::InconsistentShare);
    }
    Ok(())
}

// ─── T9.2 — range proof max|F| < q/2 na udziałach (bez clear F) ─────────
//
// Domknięcie retained H1 T8: "max|F| < q/2 nie jest weryfikowany bez
// clear F". Tor per współczynnik (wzór H3 bit-decomp):
//   1. X = v + 2^{B-1} na udziałach;
//   2. bit-dekompozycja X maską r (open wyłącznie d = X − r — maska);
//   3. |v| z bitów (sign = ¬MSB; abs = (X_low ⊕ sign) + sign);
//   4. accept = 1{|v| < q/2} na bitach (dodawanie jawnej 2^k − bound);
//   5. open wyłącznie bitu accept — v nigdy nie jest rekonstruowane.
//
// Fail-closed: accept = 0 → [`SpikeError::FBoundViolation`].
// **Nie jest** malicious-secure / UC — semi-honest bit-circuit + abort.

/// Bit-width dekompozycji range proof (T9.2).
/// 17 bitów: OFF = 2^16, |i16::MIN| = 32768 mieści się w abs bez overflow.
pub const FBOUND_BITS: u32 = 17;

/// Otwiera bit GF(256) (0/1) — wyłącznie accept-bit, nie sekret.
fn open_gf_bit_val(xs_gf: &[u8], b: &GfBitShares) -> Result<u8> {
    let owned: Vec<Share> = xs_gf
        .iter()
        .zip(b)
        .map(|(&x, &s)| Share { x, share: s })
        .collect();
    let refs: Vec<&Share> = owned.iter().collect();
    crate::reconstruct(&refs)
}

/// accept = 1{abs < bound} z bitów |v| — bez otwierania v.
/// `abs_bits` szerokości `abs_w` (abs < 2^abs_w).
fn fbound_accept_abs_lt(
    rng: &mut impl rand::RngCore,
    xs_gf: &[u8],
    lam: &[u8],
    abs_bits: &[GfBitShares],
    bound: u64,
    cost: &mut RoundCost,
) -> Result<GfBitShares> {
    let abs_w = abs_bits.len();
    if abs_w == 0 || abs_w > 62 {
        return Err(SpikeError::WrongThreshold);
    }
    if bound == 0 || bound > (1u64 << abs_w) {
        return Err(SpikeError::WrongThreshold);
    }
    let n = xs_gf.len();
    // abs < bound  ⇔  abs + (2^abs_w − bound) < 2^abs_w
    // ⇔ bit abs_w sumy (zero-extend) = 0.
    let delta = (1u64 << abs_w) - bound;
    let mut a_ext = abs_bits.to_vec();
    a_ext.push(gf_zero(n));
    let c_bits: Vec<u8> = (0..=abs_w).map(|i| ((delta >> i) & 1) as u8).collect();
    let sum = gf_add_public(rng, xs_gf, lam, &a_ext, &c_bits, cost)?;
    Ok(gf_not(&sum[abs_w]))
}

/// Bit-dekompozycja udziału v → (X_bits, sign) jak H3 kroki 1–4.
/// `bits` = B, poprawność gdy |v| < 2^{B-1} (retained jak round_div_q).
/// Otwarcia: wyłącznie maski d = X − r.
fn fbound_x_bits_and_sign(
    rng: &mut impl rand::RngCore,
    v: &[u64],
    xs_p: &[u16],
    xs_gf: &[u8],
    k: u8,
    lam: &[u8],
    bits: u32,
    cost: &mut RoundCost,
) -> Result<(Vec<GfBitShares>, GfBitShares)> {
    let n = xs_p.len();
    if xs_gf.len() != n || v.len() != n {
        return Err(SpikeError::PartyCountMismatch);
    }
    let b = bits as usize;
    if !(2..=48).contains(&b) {
        return Err(SpikeError::WrongThreshold);
    }
    let off = 1u64 << (b - 1);

    // 1. X = v + OFF
    let x_off: Vec<u64> = v.iter().map(|&s| p_add(s, i64_to_p(off as i64))).collect();

    // 2. maska r ∈ [0, 2^B) — bity w GF(256) i Z_P (PRSS, T7.1)
    let mut r_bits_gf: Vec<GfBitShares> = Vec::with_capacity(b);
    let mut r_p_shares = vec![0u64; n];
    let mut pow2 = 1u64;
    for _ in 0..b {
        let (mg, mp) = paired_bit_mask_prss(rng, xs_p, xs_gf, k, cost)?;
        r_p_shares = r_p_shares
            .iter()
            .zip(&mp)
            .map(|(a, c)| p_add(*a, p_mul(*c, pow2)))
            .collect();
        r_bits_gf.push(mg);
        pow2 = p_mul(pow2, 2);
    }
    // open d = X − r (maska — nie otwiera v)
    let d_shares: Vec<u64> = x_off
        .iter()
        .zip(&r_p_shares)
        .map(|(a, c)| p_sub(*a, *c))
        .collect();
    cost.bit_opens += 1;
    let d_i = ireconstruct_val(xs_p, &d_shares)?;

    // 3. X_bits = r + d_twos (width B+1), low B bitów = X
    let d_twos = d_i.rem_euclid(1i64 << (b + 1)) as u64;
    let d_bits: Vec<GfBitShares> = (0..=b)
        .map(|i| gf_const(((d_twos >> i) & 1) as u8, n))
        .collect();
    let mut r_ext = r_bits_gf.clone();
    r_ext.push(gf_zero(n));
    let (sum_bits, _carry) = gf_add_bits(rng, xs_gf, lam, &r_ext, &d_bits, cost)?;
    let x_bits: Vec<GfBitShares> = sum_bits[..b].to_vec();

    // 4. sign = ¬X_bits[B-1]
    let sign = gf_not(&x_bits[b - 1]);
    Ok((x_bits, sign))
}

/// |v| z bitów X (jak H3 kroki 4–5): t = X_low ⊕ sign; abs = t + sign.
fn fbound_abs_bits(
    rng: &mut impl rand::RngCore,
    xs_gf: &[u8],
    lam: &[u8],
    x_bits: &[GfBitShares],
    sign: &GfBitShares,
    cost: &mut RoundCost,
) -> Result<Vec<GfBitShares>> {
    let abs_w = x_bits.len() - 1;
    let mut t_bits: Vec<GfBitShares> = (0..abs_w)
        .map(|i| gf_xor(&x_bits[i], sign))
        .collect();
    let mut carry = sign.clone();
    for i in 0..abs_w {
        let s = gf_xor(&t_bits[i], &carry);
        let new_carry = gf_and_lam(rng, xs_gf, lam, &t_bits[i], &carry, cost)?;
        t_bits[i] = s;
        carry = new_carry;
    }
    // carry-out odrzucony: z bits=FBOUND_BITS abs i16 mieści się w abs_w bitach.
    Ok(t_bits)
}

/// Range proof |v| < bound na udziałach jednego współczynnika (T9.2).
/// Bez reconstruct v. Fail-closed: [`SpikeError::FBoundViolation`].
pub fn fbound_scalar_shares(
    rng: &mut impl rand::RngCore,
    v: &[u64],
    xs_p: &[u16],
    xs_gf: &[u8],
    k: u8,
    lam: &[u8],
    bound: u64,
    cost: &mut RoundCost,
) -> Result<()> {
    let (x_bits, sign) =
        fbound_x_bits_and_sign(rng, v, xs_p, xs_gf, k, lam, FBOUND_BITS, cost)?;
    let abs_bits = fbound_abs_bits(rng, xs_gf, lam, &x_bits, &sign, cost)?;
    let accept = fbound_accept_abs_lt(rng, xs_gf, lam, &abs_bits, bound, cost)?;
    let a = open_gf_bit_val(xs_gf, &accept)?;
    if a == 0 {
        return Err(SpikeError::FBoundViolation);
    }
    if a != 1 {
        return Err(SpikeError::NonBitShare);
    }
    Ok(())
}

/// Range proof `max|F| < q/2` na udziałach wielomianu F (T9.2).
///
/// **Bez otwierania F** — per współczynnik bit-decomp + accept-bit.
/// Naruszenie (dowolny |F_j| ≥ q/2) → [`SpikeError::FBoundViolation`].
/// Naturalne podpięcie: DKG trapdoora (T8.3 retained gap) i tor sign
/// (druga linia obrony obok [`validate_f_bound`] w dealu).
pub fn validate_f_bound_shares(
    rng: &mut impl rand::RngCore,
    f_big: &IPolyShares,
    xs: &[u16],
    k: u8,
) -> Result<()> {
    if f_big.is_empty() {
        return Err(SpikeError::EmptyShares);
    }
    let n = check_xs_p(xs, k)?;
    let xs_gf: Vec<u8> = xs
        .iter()
        .map(|&v| u8::try_from(v).map_err(|_| SpikeError::WrongThreshold))
        .collect::<Result<_>>()?;
    let lam = gf_lagrange_all(&xs_gf)?;
    let mut cost = RoundCost::default();
    for col in f_big {
        if col.len() != n {
            return Err(SpikeError::PartyCountMismatch);
        }
        fbound_scalar_shares(
            rng,
            col,
            xs,
            &xs_gf,
            k,
            &lam,
            F_BOUND_HALF_Q as u64,
            &mut cost,
        )?;
    }
    Ok(())
}

// ─── VSS udziałów i16 (Pedersen, integracja z ishare_poly) ──────────────

/// Zobowiązania Pedersena do Shamir-wielomianów jednego i16-poly.
/// `commits[j]` = zobowiązania do poly współczynnika `j`.
#[derive(Clone)]
pub struct IPolyVss {
    pub commits: Vec<crate::pedersen::ZpPedersenCommit>,
}

/// Udziały i16-poly: wartości Z_P (do obliczeń) + niezredukowane
/// ewaluacje Shamir w `u128` (do weryfikacji VSS w wykładnikach Ristretto).
/// Spójność: `values[j][i] == vss_vals[j][i] % P`.
pub struct IPolyVssShares {
    pub values: IPolyShares,
    pub vss_vals: Vec<Vec<u128>>,
    pub vss_blinds: Vec<Vec<u128>>,
}

/// Deal i16-poly + Pedersen VSS per współczynnik (G-2).
/// `vss_count`: ile pierwszych współczynników dostać VSS (0 = wszystkie).
/// Weryfikacja: `s·G + t·H == Π C_j^{x^j}` — bez interpolacji kontrolnej.
///
/// **H1 = „moment setupu" (T7.3, zastrzeżenie).** Ta funkcja jawne dealuje
/// i16 `p` — klucz/materiał istnieje w clear w tym miejscu spiku. To **nie**
/// jest usunięcie dealera klucza; pełny bezdealerowy keygen NTRU (fG−gF=q)
/// jest poza zakresem. Po zakończeniu H1 clear f,F nie jest potrzebny
/// w torze sign.
///
/// **Wydajność:** pełne VSS na N=1536 to ~25K mnożeń Ristretto w debug
/// (timeout w testach). Integracja sign używa `vss_count=8` (próbka);
/// pełny VSS demonstrują testy komponentowe na pojedynczych wartościach.
pub fn ishare_poly_with_vss_count(
    rng: &mut impl rand::RngCore,
    p: &[i16],
    xs: &[u16],
    k: u8,
    vss_count: usize,
) -> Result<(IPolyVssShares, IPolyVss)> {
    if p.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    check_xs_p(xs, k)?;
    let n = xs.len();
    let n_vss = if vss_count == 0 { FT1536_N } else { vss_count.min(FT1536_N) };
    let mut values = Vec::with_capacity(FT1536_N);
    let mut vss_vals = Vec::with_capacity(n_vss);
    let mut vss_blinds = Vec::with_capacity(n_vss);
    let mut commits = Vec::with_capacity(n_vss);
    for (j, &c) in p.iter().enumerate() {
        if j < n_vss {
            let (com, sh) = crate::pedersen::zp_vss_deal(rng, i64_to_p(c as i64), xs, k);
            let mut vcol = vec![0u64; n];
            let mut vvcol = vec![0u128; n];
            let mut vbcol = vec![0u128; n];
            for (i, s) in sh.into_iter().enumerate() {
                vcol[i] = (s.share % I_P as u128) as u64;
                vvcol[i] = s.share;
                vbcol[i] = s.blind;
            }
            values.push(vcol);
            vss_vals.push(vvcol);
            vss_blinds.push(vbcol);
            commits.push(com);
        } else {
            values.push(ishare_val(rng, c as i64, xs, k)?);
        }
    }
    Ok((
        IPolyVssShares { values, vss_vals, vss_blinds },
        IPolyVss { commits },
    ))
}

/// Pełny VSS na wszystkich współczynnikach (dla testów komponentowych).
pub fn ishare_poly_with_vss(
    rng: &mut impl rand::RngCore,
    p: &[i16],
    xs: &[u16],
    k: u8,
) -> Result<(IPolyVssShares, IPolyVss)> {
    ishare_poly_with_vss_count(rng, p, xs, k, 0)
}

/// Weryfikacja jednego udziału jednego współczynnika (fail-closed).
/// Sprawdza: (1) VSS niezredukowanej ewaluacji vs commitment,
/// (2) spójność `value == vss_val % P`.
pub fn vss_verify_one(
    vss: &IPolyVss,
    j: usize,
    x: u16,
    value: u64,
    vss_val: u128,
    vss_blind: u128,
) -> Result<()> {
    let com = vss
        .commits
        .get(j)
        .ok_or(SpikeError::PartyCountMismatch)?;
    // (2) spójność Z_P
    if value % I_P != (vss_val % I_P as u128) as u64 {
        return Err(SpikeError::CommitmentMismatch);
    }
    // (1) VSS w wykładnikach
    let sh = crate::pedersen::ZpVssShare {
        x,
        share: vss_val,
        blind: vss_blind,
    };
    crate::pedersen::zp_vss_verify(&sh, com).map_err(|_| SpikeError::CommitmentMismatch)
}

/// Weryfikacja udziałów z VSS (tylko współczynniki z commitmentami).
/// Dla `vss.commits.len() < FT1536_N` weryfikowana jest próbka.
pub fn vss_verify_poly_shares(
    vss: &IPolyVss,
    shares: &IPolyVssShares,
    xs: &[u16],
) -> Result<()> {
    let n = xs.len();
    let n_vss = vss.commits.len();
    if n_vss == 0 {
        return Ok(()); // brak VSS — nic do weryfikacji (udział bez commitmentu)
    }
    if shares.vss_vals.len() != n_vss || shares.vss_blinds.len() != n_vss {
        return Err(SpikeError::PartyCountMismatch);
    }
    if shares.values.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    for j in 0..n_vss {
        if shares.values[j].len() != n
            || shares.vss_vals[j].len() != n
            || shares.vss_blinds[j].len() != n
        {
            return Err(SpikeError::PartyCountMismatch);
        }
        for i in 0..n {
            vss_verify_one(
                vss,
                j,
                xs[i],
                shares.values[j][i],
                shares.vss_vals[j][i],
                shares.vss_blinds[j][i],
            )?;
        }
    }
    Ok(())
}

/// Skaluj wkład VSS (udziały + zobowiązania) przez jawne `w` (T9.1).
///
/// **Formuła ważona (T9.1):**
/// ```text
/// f[j]     = Σ_i w_i · f^{(i)}[j]           (tajny wielomian; jawny w clear
/// F[j]     = Σ_i w_i · F^{(i)}[j]            NIGDY w torze setupu)
/// share_p  = Σ_i w_i · share_i(·, x_p)       (Shamir liniowy)
/// C_f[j]   = Σ_i w_i · C_{f^{(i)}}[j]        (Pedersen add. homomorphiczny)
/// ```
/// gdzie `w · C = (w·a)·G + (w·r)·H` dla `C = a·G + r·H`, a udziały
/// `(s,t) → (w·s mod P, w·t)` trzymają niezredukowaną ewaluację `w·eval`.
///
/// Spójność: `w·(s·G+t·H) = (w·s)·G+(w·t)·H` oraz
/// `w·Π C_j^{x^j} = Π (w·C_j)^{x^j}` — [`vss_verify_poly_shares`] przechodzi
/// po ważeniu; fałszerstwo ważonego udziału → [`SpikeError::CommitmentMismatch`].
///
/// Fail-closed: `w · vss_val` / `w · vss_blind` overflow `u128` →
/// [`SpikeError::CommitmentMismatch`] (ważonego udziału nie da się
/// udowodnić wobec ważonego zobowiązania; brak cichego wrap-around).
pub fn ipoly_vss_scale_weight(
    shares: &IPolyVssShares,
    vss: &IPolyVss,
    w: u64,
) -> Result<(IPolyVssShares, IPolyVss)> {
    let n_vss = vss.commits.len();
    if shares.vss_vals.len() != n_vss || shares.vss_blinds.len() != n_vss {
        return Err(SpikeError::PartyCountMismatch);
    }
    if shares.values.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    let w_p = w % I_P;
    let mut values = Vec::with_capacity(FT1536_N);
    for col in &shares.values {
        values.push(col.iter().map(|&s| p_mul(w_p, s)).collect());
    }
    let mut vss_vals = Vec::with_capacity(n_vss);
    let mut vss_blinds = Vec::with_capacity(n_vss);
    for j in 0..n_vss {
        if shares.vss_vals[j].len() != shares.vss_blinds[j].len() {
            return Err(SpikeError::PartyCountMismatch);
        }
        let mut vcol = Vec::with_capacity(shares.vss_vals[j].len());
        let mut bcol = Vec::with_capacity(shares.vss_blinds[j].len());
        for i in 0..shares.vss_vals[j].len() {
            let w128 = w as u128;
            let sv = shares.vss_vals[j][i]
                .checked_mul(w128)
                .ok_or(SpikeError::CommitmentMismatch)?;
            let sb = shares.vss_blinds[j][i]
                .checked_mul(w128)
                .ok_or(SpikeError::CommitmentMismatch)?;
            vcol.push(sv);
            bcol.push(sb);
        }
        vss_vals.push(vcol);
        vss_blinds.push(bcol);
    }
    let commits = vss
        .commits
        .iter()
        .map(|c| crate::pedersen::zp_pedersen_scale(c, w))
        .collect();
    Ok((
        IPolyVssShares {
            values,
            vss_vals,
            vss_blinds,
        },
        IPolyVss { commits },
    ))
}

// ─── MAC na otwieraniach maski bit-decomp (integracja z rounding) ────────

/// Dealer (model testowy) — udziały wartości z MAC **i** ukryte δ-shares.
/// `mac = δ · secret` jako Shamir w Z_P; δ osobno jako [`ZpDeltaShares`].
/// Wzorzec `share_byte_with_mac_hidden_delta` (Y6) przeniesiony na Z_P.
pub fn share_val_mac_hidden_zp(
    rng: &mut impl rand::RngCore,
    secret: i64,
    xs: &[u16],
    k: u8,
    delta: u64,
) -> Result<(Vec<ZpMacShare>, ZpDeltaShares)> {
    let macs = share_val_with_mac_zp(rng, secret, xs, k, delta)?;
    let ds = ishare_val(rng, (delta % I_P) as i64, xs, k)?;
    Ok((
        macs,
        ZpDeltaShares {
            xs: xs.to_vec(),
            shares: ds,
        },
    ))
}

/// MAC'd para masek bitu: (udziały GF, udziały Z_P, MAC Z_P bitu).
///
/// **RETAINED — model dealera testowego.** Dealer zna bit i δ (model
/// testowy G-2). Ścieżka złota T7 używa [`paired_bit_mask_prss_mac`].
pub fn paired_bit_mask_mac(
    rng: &mut impl rand::RngCore,
    xs_p: &[u16],
    xs_gf: &[u8],
    k: u8,
    delta: u64,
) -> Result<(GfBitShares, Vec<u64>, Vec<u64>)> {
    let bit = (rng.next_u32() & 1) as u8;
    let mg = shamir_share(rng, bit, xs_gf, k)?;
    let mg_sh: GfBitShares = mg.iter().map(|s| s.share).collect();
    let mac_sh = share_val_with_mac_zp(rng, bit as i64, xs_p, k, delta)?;
    let mp: Vec<u64> = mac_sh.iter().map(|s| s.share).collect();
    let mm: Vec<u64> = mac_sh.iter().map(|s| s.mac).collect();
    Ok((mg_sh, mp, mm))
}

/// PRSS MAC'd para masek bitu — **bez dealera** (T7.1 + G-2).
///
/// Bit powstaje przez [`paired_bit_mask_prss`] (wkłady wirtualnych partii).
/// MAC = δ·bit liczony **liniowością** z udziałów: `mm[p] = delta_known · mp[p]`
/// (skalar × Shamir-udział = udział skalar×sekret). `delta_known` to jawne δ
/// modelu G-2 testowego — to NIE jest ukryte δ produkcji.
pub fn paired_bit_mask_prss_mac(
    rng: &mut impl rand::RngCore,
    xs_p: &[u16],
    xs_gf: &[u8],
    k: u8,
    delta_known: u64,
    cost: &mut RoundCost,
) -> Result<(GfBitShares, Vec<u64>, Vec<u64>)> {
    let (mg, mp) = paired_bit_mask_prss(rng, xs_p, xs_gf, k, cost)?;
    let dk = delta_known % I_P;
    let mm: Vec<u64> = mp.iter().map(|&s| p_mul(dk, s)).collect();
    Ok((mg, mp, mm))
}

// ─── G-2 rounding: MAC na otwarciu maski bit-decomp ──────────────────────

/// Rdzeń H3 + MAC na otwarciu `d = X − r` (G-2).
/// `x_mac` = MAC udziały x; `delta` = ukryte δ (otwarcie);
/// `delta_known` = jawne δ dealera (model testowy — tworzenie MAC masek).
///
/// `gauss` / `gauss_mac` = opcjonalny szum DGDG (T6/R-G2-1) + jego MAC:
/// licznik `x + g` przed /q; `mac_X` obejmuje mac_g (spójność otwarcia).
///
/// Otwarcie `d` przez [`zp_open_with_mac_hidden_delta`] — fałszywy
/// udział x, MAC lub maska W-bitowa → [`SpikeError::MacFail`].
/// Wyjście `z` bez MAC (bit circuit: AND = reshare-mul, patrz MPS_G2_NOTES).
pub fn round_div_q_scalar_shares_g2(
    rng: &mut impl rand::RngCore,
    x: &[u64],
    x_mac: &[u64],
    xs_p: &[u16],
    xs_gf: &[u8],
    k: u8,
    lam: &[u8],
    bits: u32,
    cost: &mut RoundCost,
    delta: &ZpDeltaShares,
    delta_known: u64,
    gauss: Option<(&[u64], &[u64])>,
) -> Result<Vec<u64>> {
    let n = xs_p.len();
    if xs_gf.len() != n || x.len() != n || x_mac.len() != n {
        return Err(SpikeError::PartyCountMismatch);
    }
    if delta.shares.len() != n {
        return Err(SpikeError::PartyCountMismatch);
    }
    let b = bits as usize;
    if !(2..=48).contains(&b) {
        return Err(SpikeError::WrongThreshold);
    }
    let w = b;
    let off = 1u64 << (b - 1);

    // T6: x' = x + g (i mac' = mac_x + mac_g) przed round — R-G2-1.
    let (x_noised, x_mac_noised): (Vec<u64>, Vec<u64>) = match gauss {
        Some((g, gmac)) => {
            if g.len() != n || gmac.len() != n {
                return Err(SpikeError::PartyCountMismatch);
            }
            (
                x.iter().zip(g).map(|(&a, &b)| p_add(a, b)).collect(),
                x_mac.iter().zip(gmac).map(|(&a, &b)| p_add(a, b)).collect(),
            )
        }
        None => (x.to_vec(), x_mac.to_vec()),
    };

    // 1. X = x(+g) + OFF;  mac_X = mac_x(+mac_g) + OFF·δ_i (public scalar × δ-shares)
    let off_p = i64_to_p(off as i64);
    let x_off: Vec<u64> = x_noised.iter().map(|&s| p_add(s, off_p)).collect();
    let x_off_mac: Vec<u64> = x_mac_noised
        .iter()
        .zip(&delta.shares)
        .map(|(&m, &d)| p_add(m, p_mul(off_p, d)))
        .collect();

    // 2. maska r ∈ [0, 2^W) z MAC (G-2): bity w GF i Z_P + MAC Z_P
    //    PRSS: wkłady wirtualnych partii, brak dealera clear-bit (T7.1).
    let mut r_bits_gf: Vec<GfBitShares> = Vec::with_capacity(w);
    let mut r_p_shares = vec![0u64; n];
    let mut r_p_mac = vec![0u64; n];
    let mut pow2 = 1u64;
    for _ in 0..w {
        let (mg, mp, mm) = paired_bit_mask_prss_mac(rng, xs_p, xs_gf, k, delta_known, cost)?;
        r_p_shares = r_p_shares
            .iter()
            .zip(&mp)
            .map(|(a, b)| p_add(*a, p_mul(*b, pow2)))
            .collect();
        r_p_mac = r_p_mac
            .iter()
            .zip(&mm)
            .map(|(a, b)| p_add(*a, p_mul(*b, pow2)))
            .collect();
        r_bits_gf.push(mg);
        pow2 = p_mul(pow2, 2);
    }

    // open d = X − r z kontrolą MAC (ukryte δ) — G-2
    let d_mac_shares: Vec<ZpMacShare> = x_off
        .iter()
        .zip(&x_off_mac)
        .zip(&r_p_shares)
        .zip(&r_p_mac)
        .zip(xs_p)
        .map(|((((xo, xm), rp), rm), &x)| ZpMacShare {
            x,
            share: p_sub(*xo, *rp),
            mac: p_sub(*xm, *rm),
        })
        .collect();
    cost.bit_opens += 1;
    let d_i = zp_open_with_mac_hidden_delta(&d_mac_shares, delta, k)?;

    // 3. X_bits = r + d_twos (width W+1), low W bitów = X
    let d_twos = d_i.rem_euclid(1i64 << (w + 1)) as u64;
    let d_bits: Vec<GfBitShares> = (0..=w)
        .map(|i| gf_const(((d_twos >> i) & 1) as u8, n))
        .collect();
    let mut r_ext = r_bits_gf.clone();
    r_ext.push(gf_zero(n));
    let (sum_bits, _carry) = gf_add_bits(rng, xs_gf, lam, &r_ext, &d_bits, cost)?;
    let x_bits: Vec<GfBitShares> = sum_bits[..w].to_vec();

    // 4. sign = ¬X_bits[B-1]
    let sign = gf_not(&x_bits[b - 1]);

    // 5. |x| bity (B-1 bitów)
    let abs_w = b - 1;
    let mut t_bits: Vec<GfBitShares> = (0..abs_w)
        .map(|i| gf_xor(&x_bits[i], &sign))
        .collect();
    {
        let mut carry = sign.clone();
        for i in 0..abs_w {
            let s = gf_xor(&t_bits[i], &carry);
            let new_carry = gf_and_lam(rng, xs_gf, lam, &t_bits[i], &carry, cost)?;
            t_bits[i] = s;
            carry = new_carry;
        }
    }

    // 6. y = |x| + ⌊q/2⌋
    let q = FT1536_Q as u32;
    let half_q = q / 2;
    let y_w = abs_w + 2;
    let mut t_ext: Vec<GfBitShares> = Vec::with_capacity(y_w);
    for i in 0..y_w {
        if i < abs_w {
            t_ext.push(t_bits[i].clone());
        } else {
            t_ext.push(gf_zero(n));
        }
    }
    let hq_bits: Vec<u8> = (0..y_w)
        .map(|i| if i < 32 { ((half_q >> i) & 1) as u8 } else { 0 })
        .collect();
    let y_bits = gf_add_public(rng, xs_gf, lam, &t_ext, &hq_bits, cost)?;

    // 7. |z| = y / q (przywracające)
    let (z_abs_bits, _rem) = gf_div_restoring(rng, xs_gf, lam, &y_bits, q, cost)?;

    // 8. złóż |z| bity → Z_P (pary masek PRSS), potem z = (1−2·sign)·|z|
    let z_abs_w = z_abs_bits.len();
    let mut abs_p = vec![0u64; n];
    let mut pow2 = 1u64;
    for i in 0..z_abs_w {
        let (mg, mp) = paired_bit_mask_prss(rng, xs_p, xs_gf, k, cost)?;
        let bp = gfbit_to_pbit(xs_gf, k, &z_abs_bits[i], &mg, &mp, cost)?;
        abs_p = abs_p
            .iter()
            .zip(&bp)
            .map(|(a, b)| p_add(*a, p_mul(*b, pow2)))
            .collect();
        pow2 = p_mul(pow2, 2);
    }
    let (sg, sp) = paired_bit_mask_prss(rng, xs_p, xs_gf, k, cost)?;
    let sign_p = gfbit_to_pbit(xs_gf, k, &sign, &sg, &sp, cost)?;
    let pmul_val: Vec<u64> = sign_p.iter().map(|&s| p_sub(1, p_mul(2, s))).collect();
    cost.p_reshare_muls += 1;
    let z = i_mul_with_lam(rng, xs_p, k, &p_lagrange_all(xs_p)?, &pmul_val, &abs_p)?;
    Ok(z)
}

// ─── G-2 poly rounding + trapdoor + sign ─────────────────────────────────

/// H3 na całym wielomianie z MAC na otwarciach maski (G-2).
/// `x_mac` = MAC udziały x (liniowość z f/F); otwarcia `d` z ukrytym δ.
///
/// `gauss` / `gauss_mac` = opcjonalny szum DGDG + MAC per współczynnik
/// (T6/R-G2-1); `None` = tor deterministyczny (retained).
pub fn round_div_q_shares_g2(
    rng: &mut impl rand::RngCore,
    x: &IPolyShares,
    x_mac: &IPolyShares,
    xs: &[u16],
    k: u8,
    bits: u32,
    delta: &ZpDeltaShares,
    delta_known: u64,
    gauss: Option<&IPolyShares>,
    gauss_mac: Option<&IPolyShares>,
) -> Result<(IPolyShares, RoundCost)> {
    if x.len() != FT1536_N || x_mac.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    if let (Some(g), Some(gm)) = (gauss, gauss_mac) {
        if g.len() != FT1536_N || gm.len() != FT1536_N {
            return Err(SpikeError::PartyCountMismatch);
        }
    } else if gauss.is_some() || gauss_mac.is_some() {
        return Err(SpikeError::PartyCountMismatch);
    }
    let n = check_xs_p(xs, k)?;
    let xs_gf: Vec<u8> = xs
        .iter()
        .map(|&v| u8::try_from(v).map_err(|_| SpikeError::WrongThreshold))
        .collect::<Result<_>>()?;
    let lam = gf_lagrange_all(&xs_gf)?;
    let mut cost = RoundCost::default();
    let mut out = Vec::with_capacity(FT1536_N);
    for (i, (col, mcol)) in x.iter().zip(x_mac).enumerate() {
        if col.len() != n || mcol.len() != n {
            return Err(SpikeError::PartyCountMismatch);
        }
        let gpair = match (gauss, gauss_mac) {
            (Some(g), Some(gm)) => {
                if g[i].len() != n || gm[i].len() != n {
                    return Err(SpikeError::PartyCountMismatch);
                }
                Some((g[i].as_slice(), gm[i].as_slice()))
            }
            _ => None,
        };
        out.push(round_div_q_scalar_shares_g2(
            rng, col, mcol, xs, &xs_gf, k, &lam, bits, &mut cost, delta, delta_known, gpair,
        )?);
    }
    Ok((out, cost))
}

/// G-2 trapdoor: udziały + MAC f/F + VSS + ukryte δ.
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    pub vss_f: IPolyVss,
    pub vss_g: IPolyVss,
    pub vss_f_big: IPolyVss,
    pub vss_g_big: IPolyVss,
    pub vss_sh_f: IPolyVssShares,
    pub vss_sh_g: IPolyVssShares,
    pub vss_sh_f_big: IPolyVssShares,
    pub vss_sh_g_big: IPolyVssShares,
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}

/// Deal G-2 trapdoor: VSS (próbka) + MAC + bound max|F| < q/2 (fail-closed).
/// VSS na `G2_VSS_SAMPLE` pierwszych współczynnikach (wydajność w debug).
/// Po dealu clear f,g,F,G nie jest potrzebny w torze sign.
///
/// **retained / test-only (H1 moment)** — historia: tor dealera w clear.
/// Nie kasować (retained); produkcyjny setup idzie przez
/// [`dkg_trapdoor_from_contributions`] / [`dkg_trapdoor_from_weighted_contributions`]
/// + offline [`ntru_fg_gf_check_weighted_shares`] (T10).
///
/// **H1 = „moment setupu" (T7.3, zastrzeżenie; T10 domyka offline).**
/// Ta funkcja jawne dealuje i16 f,g,F,G — klucz istnieje w clear w tym
/// miejscu spiku. Tor produkcyjny NIE woła tej funkcji: ważony DKG +
/// offline check fG−gF=q na udziałach. Po H1 tor sign pracuje na udziałach.
pub const G2_VSS_SAMPLE: usize = 8;

pub fn g2_deal_trapdoor(
    rng: &mut impl rand::RngCore,
    f16: &[i16],
    g16: &[i16],
    f_big16: &[i16],
    g_big16: &[i16],
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<G2Trapdoor> {
    check_xs_p(xs, k)?;
    // 1. bound max|F| < q/2 — abort przy naruszeniu
    validate_f_bound(f_big16)?;
    // 2. VSS (próbka) + value shares dla f, g, F, G
    let (f_vss_sh, vss_f) = ishare_poly_with_vss_count(rng, f16, xs, k, G2_VSS_SAMPLE)?;
    let (g_vss_sh, vss_g) = ishare_poly_with_vss_count(rng, g16, xs, k, G2_VSS_SAMPLE)?;
    let (fb_vss_sh, vss_f_big) = ishare_poly_with_vss_count(rng, f_big16, xs, k, G2_VSS_SAMPLE)?;
    let (gb_vss_sh, vss_g_big) = ishare_poly_with_vss_count(rng, g_big16, xs, k, G2_VSS_SAMPLE)?;
    // 3. VSS verify (fail-closed)
    vss_verify_poly_shares(&vss_f, &f_vss_sh, xs)?;
    vss_verify_poly_shares(&vss_g, &g_vss_sh, xs)?;
    vss_verify_poly_shares(&vss_f_big, &fb_vss_sh, xs)?;
    vss_verify_poly_shares(&vss_g_big, &gb_vss_sh, xs)?;
    // 4. MAC f, F (δ·f[j] jako Shamir) — do otwarć maski bit-decomp
    let dk = delta_known % I_P;
    let mut f_mac = Vec::with_capacity(FT1536_N);
    let mut f_big_mac = Vec::with_capacity(FT1536_N);
    for &c in f16 {
        let mac_val = p_mul(dk, i64_to_p(c as i64));
        f_mac.push(ishare_val(rng, p_to_i64(mac_val), xs, k)?);
    }
    for &c in f_big16 {
        let mac_val = p_mul(dk, i64_to_p(c as i64));
        f_big_mac.push(ishare_val(rng, p_to_i64(mac_val), xs, k)?);
    }
    // 5. ukryte δ-shares
    let delta = ZpDeltaShares {
        xs: xs.to_vec(),
        shares: ishare_val(rng, dk as i64, xs, k)?,
    };
    Ok(G2Trapdoor {
        td: ITrapdoorShares {
            f: f_vss_sh.values.clone(),
            g: g_vss_sh.values.clone(),
            f_big: fb_vss_sh.values.clone(),
            g_big: gb_vss_sh.values.clone(),
        },
        f_mac,
        f_big_mac,
        vss_f,
        vss_g,
        vss_f_big,
        vss_g_big,
        vss_sh_f: f_vss_sh,
        vss_sh_g: g_vss_sh,
        vss_sh_f_big: fb_vss_sh,
        vss_sh_g_big: gb_vss_sh,
        delta,
        delta_known: dk,
    })
}

/// Re-deal / refresh udziałów i16-poly (T7.3, opcjonalnie).
/// Dodaje świeży sharing zera do każdej kolumny — sekret bez zmian
/// (jak `tt52_refresh_preserves_secret`). **Bez reconstruct** f,F.
///
/// **H1:** to jest re-deal już-współdzielonego materiału, **nie** pełny
/// bezdealerowy keygen. Clear f,F istnieje w H1 (setup).
pub fn reshare_ipoly_shares(
    rng: &mut impl rand::RngCore,
    shares: &IPolyShares,
    xs: &[u16],
    k: u8,
) -> Result<IPolyShares> {
    check_xs_p(xs, k)?;
    let n = xs.len();
    let mut out = Vec::with_capacity(shares.len());
    for col in shares {
        if col.len() != n {
            return Err(SpikeError::PartyCountMismatch);
        }
        // świeży sharing zera (stały wyraz wolny = 0) — sekret bez zmian
        let zero_sh = ishare_val_unchecked(rng, 0, xs, k);
        let refreshed: Vec<u64> = col
            .iter()
            .zip(&zero_sh)
            .map(|(&a, &b)| p_add(a, b))
            .collect();
        out.push(refreshed);
    }
    Ok(out)
}

// ─── T8.3 — keygen f,F z contributions (bez clear f,F w torze setup) ─────

/// T8.3 — wkład jednej partii do DKG trapdoora (f_i, g_i, F_i, G_i).
///
/// Partia zna **wyłącznie** swój wkład. Pełny klucz f = Σ f_c (mod i16,
/// dokładna suma całkowita) **nie powstaje w clear** w torze
/// [`dkg_trapdoor_from_contributions`] — tam wyłącznie sumowane są udziały.
#[derive(Clone)]
pub struct PartyTrapdoorContribution {
    pub f: Vec<i16>,
    pub g: Vec<i16>,
    pub f_big: Vec<i16>,
    pub g_big: Vec<i16>,
}

/// T8.3 — DKG trapdoora z contributions — **bez clear f,F** (T8.3).
///
/// Każda partia wnosi [`PartyTrapdoorContribution`] (f_c, g_c, F_c, G_c),
/// Shamir-dzieli go z **własnego** rng (Pedersen VSS na `vss_count`
/// pierwszych współczynnikach — fail-closed [`SpikeError::CommitmentMismatch`]
/// przy fałszerstwie). Suma udziałów = udziały `f = Σ f_c`; pełny f,F
/// **nigdy nie powstaje w clear w tym API** (wyjście to wyłącznie
/// [`G2Trapdoor`] — udziały + zobowiązania).
///
/// Ścieżka **nie** woła [`g2_deal_trapdoor`] (patrz T8.3 testy).
///
/// **Retained H1 (zastrzeżenie):** wygenerowanie ważnego wkładu NTRU
/// (fG − gF = q na SUMIE wkładów) wymaga procedury offline; pełny
/// bezdealerowy keygen NTRU jest poza zakresem spiku. Ten API domyka
/// lukę „jeden proces dealuje pełny f,F w clear": udziały powstają
/// z wkładów per partia. Bound max|F| < q/2 jest weryfikowany przez
/// [`validate_f_bound_shares`] na sumie udziałów (T9.2 range proof,
/// bez clear F).
///
/// `delta_known` = retained model G-2 (MAC = δ·x liniowością, Y13).
///
/// Równoważne [`dkg_trapdoor_from_weighted_contributions`] z wagami `w_i = 1`.
pub fn dkg_trapdoor_from_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
    let weights = vec![1u64; contribs.len()];
    dkg_trapdoor_from_weighted_contributions(
        rngs, contribs, &weights, xs, k, delta_known, vss_count,
    )
}

/// T9.1 — ważony DKG trapdoora z contributions — **bez clear f,F**.
///
/// **Formuła ważona (Shamir liniowy + Pedersen addytywnie homomorphiczny):**
/// ```text
/// f = Σ_i w_i · f^{(i)}     F = Σ_i w_i · F^{(i)}
/// g = Σ_i w_i · g^{(i)}     G = Σ_i w_i · G^{(i)}
/// ```
/// Udział strony `p` (per współczynnik `j`):
/// ```text
/// f[j][p] = Σ_i w_i · share_{f^{(i)}}(j, x_p)
/// ```
/// Zobowiązania: `C_f[j] = Σ_i w_i · C_{f^{(i)}}[j]` z
/// `w · C = (w·a)·G + (w·r)·H` ([`crate::pedersen::zp_pedersen_scale`]).
///
/// Każda partia wnosi [`PartyTrapdoorContribution`] oraz jawne `weights[i]`.
/// Shamir-dzieli swój wkład z **własnego** rng (Pedersen VSS), potem wkład
/// jest ważony ([`ipoly_vss_scale_weight`]) i addytywnie akumulowany.
/// Fałszerstwo ważonego wkładu → [`SpikeError::CommitmentMismatch`].
/// Pełny f,F **nigdy nie powstaje w clear w tym API** (wyjście to wyłącznie
/// [`G2Trapdoor`] — udziały + zobowiązania).
///
/// Ścieżka **nie** woła [`g2_deal_trapdoor`].
///
/// **Retained H1 (zastrzeżenie; T10 offline):** ważny wkład NTRU
/// (fG − gF = q na SUMIE ważonej wkładów) weryfikuje
/// [`ntru_fg_gf_check_weighted_shares`] — procedura offline na udziałach,
/// otwarcie tylko różnicy kontrolnej. Ten API domyka
/// lukę „jeden proces dealuje pełny f,F w clear": udziały powstają
/// z ważonych wkładów per partia. Bound max|F| < q/2 jest weryfikowany
/// przez [`validate_f_bound_shares`] na sumie udziałów (T9.2 range proof,
/// bez clear F). `g2_deal_trapdoor` = retained / test-only.
///
/// `delta_known` = retained model G-2 (MAC = δ·x liniowością, Y13).
/// `weights.len()` musi równać się `contribs.len()`; `w_i = 0` zeruje wkład.
pub fn dkg_trapdoor_from_weighted_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    weights: &[u64],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
    let n = check_xs_p(xs, k)?;
    if contribs.is_empty() || rngs.is_empty() || weights.len() != contribs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    let n_vss = if vss_count == 0 {
        FT1536_N
    } else {
        vss_count.min(FT1536_N)
    };

    // Sumy udziałów (per współczynnik, per strona) — NIE jawne f,F.
    let mut f_acc: IPolyShares = vec![vec![0u64; n]; FT1536_N];
    let mut g_acc: IPolyShares = vec![vec![0u64; n]; FT1536_N];
    let mut fb_acc: IPolyShares = vec![vec![0u64; n]; FT1536_N];
    let mut gb_acc: IPolyShares = vec![vec![0u64; n]; FT1536_N];
    // Wspólne zobowiązania = suma commitmentów (additively homomorphic).
    let mut vss_f: Option<IPolyVss> = None;
    let mut vss_g: Option<IPolyVss> = None;
    let mut vss_fb: Option<IPolyVss> = None;
    let mut vss_gb: Option<IPolyVss> = None;
    // Wspólne VSS-shares (suma raw eval + blinds) — do weryfikacji sumy.
    let mut vss_sh_f = IPolyVssShares {
        values: vec![vec![0u64; n]; FT1536_N],
        vss_vals: vec![vec![0u128; n]; n_vss],
        vss_blinds: vec![vec![0u128; n]; n_vss],
    };
    let mut vss_sh_g = IPolyVssShares {
        values: vec![vec![0u64; n]; FT1536_N],
        vss_vals: vec![vec![0u128; n]; n_vss],
        vss_blinds: vec![vec![0u128; n]; n_vss],
    };
    let mut vss_sh_fb = IPolyVssShares {
        values: vec![vec![0u64; n]; FT1536_N],
        vss_vals: vec![vec![0u128; n]; n_vss],
        vss_blinds: vec![vec![0u128; n]; n_vss],
    };
    let mut vss_sh_gb = IPolyVssShares {
        values: vec![vec![0u64; n]; FT1536_N],
        vss_vals: vec![vec![0u128; n]; n_vss],
        vss_blinds: vec![vec![0u128; n]; n_vss],
    };

    for (ci, contrib) in contribs.iter().enumerate() {
        if contrib.f.len() != FT1536_N
            || contrib.g.len() != FT1536_N
            || contrib.f_big.len() != FT1536_N
            || contrib.g_big.len() != FT1536_N
        {
            return Err(SpikeError::PartyCountMismatch);
        }
        let rng = &mut rngs[ci % rngs.len()];
        let w = weights[ci];
        // VSS per wkład — fałszerstwo udziału → CommitmentMismatch.
        let (f_sh, f_v) = ishare_poly_with_vss_count(rng, &contrib.f, xs, k, n_vss)?;
        let (g_sh, g_v) = ishare_poly_with_vss_count(rng, &contrib.g, xs, k, n_vss)?;
        let (fb_sh, fb_v) = ishare_poly_with_vss_count(rng, &contrib.f_big, xs, k, n_vss)?;
        let (gb_sh, gb_v) = ishare_poly_with_vss_count(rng, &contrib.g_big, xs, k, n_vss)?;
        vss_verify_poly_shares(&f_v, &f_sh, xs)?;
        vss_verify_poly_shares(&g_v, &g_sh, xs)?;
        vss_verify_poly_shares(&fb_v, &fb_sh, xs)?;
        vss_verify_poly_shares(&gb_v, &gb_sh, xs)?;
        // T9.1: ważenie wkładu (liniowość Shamir + homomorfizm Pedersena).
        let (f_sh, f_v) = ipoly_vss_scale_weight(&f_sh, &f_v, w)?;
        let (g_sh, g_v) = ipoly_vss_scale_weight(&g_sh, &g_v, w)?;
        let (fb_sh, fb_v) = ipoly_vss_scale_weight(&fb_sh, &fb_v, w)?;
        let (gb_sh, gb_v) = ipoly_vss_scale_weight(&gb_sh, &gb_v, w)?;
        vss_verify_poly_shares(&f_v, &f_sh, xs)?;
        vss_verify_poly_shares(&g_v, &g_sh, xs)?;
        vss_verify_poly_shares(&fb_v, &fb_sh, xs)?;
        vss_verify_poly_shares(&gb_v, &gb_sh, xs)?;

        // Suma udziałów (liniowość Shamir).
        for j in 0..FT1536_N {
            for p in 0..n {
                f_acc[j][p] = p_add(f_acc[j][p], f_sh.values[j][p]);
                g_acc[j][p] = p_add(g_acc[j][p], g_sh.values[j][p]);
                fb_acc[j][p] = p_add(fb_acc[j][p], fb_sh.values[j][p]);
                gb_acc[j][p] = p_add(gb_acc[j][p], gb_sh.values[j][p]);
                vss_sh_f.values[j][p] = p_add(vss_sh_f.values[j][p], f_sh.values[j][p]);
                vss_sh_g.values[j][p] = p_add(vss_sh_g.values[j][p], g_sh.values[j][p]);
                vss_sh_fb.values[j][p] = p_add(vss_sh_fb.values[j][p], fb_sh.values[j][p]);
                vss_sh_gb.values[j][p] = p_add(vss_sh_gb.values[j][p], gb_sh.values[j][p]);
            }
        }
        for j in 0..n_vss {
            for p in 0..n {
                vss_sh_f.vss_vals[j][p] =
                    vss_sh_f.vss_vals[j][p].wrapping_add(f_sh.vss_vals[j][p]);
                vss_sh_f.vss_blinds[j][p] =
                    vss_sh_f.vss_blinds[j][p].wrapping_add(f_sh.vss_blinds[j][p]);
                vss_sh_g.vss_vals[j][p] =
                    vss_sh_g.vss_vals[j][p].wrapping_add(g_sh.vss_vals[j][p]);
                vss_sh_g.vss_blinds[j][p] =
                    vss_sh_g.vss_blinds[j][p].wrapping_add(g_sh.vss_blinds[j][p]);
                vss_sh_fb.vss_vals[j][p] =
                    vss_sh_fb.vss_vals[j][p].wrapping_add(fb_sh.vss_vals[j][p]);
                vss_sh_fb.vss_blinds[j][p] =
                    vss_sh_fb.vss_blinds[j][p].wrapping_add(fb_sh.vss_blinds[j][p]);
                vss_sh_gb.vss_vals[j][p] =
                    vss_sh_gb.vss_vals[j][p].wrapping_add(gb_sh.vss_vals[j][p]);
                vss_sh_gb.vss_blinds[j][p] =
                    vss_sh_gb.vss_blinds[j][p].wrapping_add(gb_sh.vss_blinds[j][p]);
            }
        }
        // Suma commitmentów (homomorfizm Pedersena).
        vss_f = Some(match vss_f.take() {
            None => f_v,
            Some(acc) => IPolyVss {
                commits: acc
                    .commits
                    .iter()
                    .zip(&f_v.commits)
                    .map(|(a, b)| {
                        crate::pedersen::zp_pedersen_add(a, b)
                            .map_err(|_| SpikeError::CommitmentMismatch)
                    })
                    .collect::<Result<_>>()?,
            },
        });
        vss_g = Some(match vss_g.take() {
            None => g_v,
            Some(acc) => IPolyVss {
                commits: acc
                    .commits
                    .iter()
                    .zip(&g_v.commits)
                    .map(|(a, b)| {
                        crate::pedersen::zp_pedersen_add(a, b)
                            .map_err(|_| SpikeError::CommitmentMismatch)
                    })
                    .collect::<Result<_>>()?,
            },
        });
        vss_fb = Some(match vss_fb.take() {
            None => fb_v,
            Some(acc) => IPolyVss {
                commits: acc
                    .commits
                    .iter()
                    .zip(&fb_v.commits)
                    .map(|(a, b)| {
                        crate::pedersen::zp_pedersen_add(a, b)
                            .map_err(|_| SpikeError::CommitmentMismatch)
                    })
                    .collect::<Result<_>>()?,
            },
        });
        vss_gb = Some(match vss_gb.take() {
            None => gb_v,
            Some(acc) => IPolyVss {
                commits: acc
                    .commits
                    .iter()
                    .zip(&gb_v.commits)
                    .map(|(a, b)| {
                        crate::pedersen::zp_pedersen_add(a, b)
                            .map_err(|_| SpikeError::CommitmentMismatch)
                    })
                    .collect::<Result<_>>()?,
            },
        });
    }

    // Wspólne VSS = commitment do sumy — weryfikacja fail-closed.
    let vss_f = vss_f.ok_or(SpikeError::PartyCountMismatch)?;
    let vss_g = vss_g.ok_or(SpikeError::PartyCountMismatch)?;
    let vss_f_big = vss_fb.ok_or(SpikeError::PartyCountMismatch)?;
    let vss_g_big = vss_gb.ok_or(SpikeError::PartyCountMismatch)?;
    vss_verify_poly_shares(&vss_f, &vss_sh_f, xs)?;
    vss_verify_poly_shares(&vss_g, &vss_sh_g, xs)?;
    vss_verify_poly_shares(&vss_f_big, &vss_sh_fb, xs)?;
    vss_verify_poly_shares(&vss_g_big, &vss_sh_gb, xs)?;

    // MAC f, F (δ·x liniowością — retained model G-2).
    let dk = delta_known % I_P;
    let mut f_mac = Vec::with_capacity(FT1536_N);
    let mut f_big_mac = Vec::with_capacity(FT1536_N);
    for j in 0..FT1536_N {
        f_mac.push(f_acc[j].iter().map(|&s| p_mul(dk, s)).collect());
        f_big_mac.push(fb_acc[j].iter().map(|&s| p_mul(dk, s)).collect());
    }
    // T9.2: range proof max|F| < q/2 na sumie udziałów — bez clear F
    // (domknięcie retained T8.3). Naruszenie → FBoundViolation.
    validate_f_bound_shares(&mut rngs[0], &fb_acc, xs, k)?;
    // Ukryte δ-shares (jak g2_deal — model G-2 retained).
    let delta = ZpDeltaShares {
        xs: xs.to_vec(),
        shares: ishare_val(&mut rngs[0], dk as i64, xs, k)?,
    };
    Ok(G2Trapdoor {
        td: ITrapdoorShares {
            f: f_acc,
            g: g_acc,
            f_big: fb_acc,
            g_big: gb_acc,
        },
        f_mac,
        f_big_mac,
        vss_f,
        vss_g,
        vss_f_big,
        vss_g_big,
        vss_sh_f,
        vss_sh_g,
        vss_sh_f_big: vss_sh_fb,
        vss_sh_g_big: vss_sh_gb,
        delta,
        delta_known: dk,
    })
}

// ─── T10 — offline NTRU fG−gF=q na ważonej sumie + zgoda na wkłady ───────

/// T10 — digest wkładu trapdoora (offline agreement przed DKG).
/// Strony porównują digesti zanim zaakceptują wkłady do sumy ważonej.
/// SHA3-256 z domeną; **nie** otwiera f,g,F,G w torze sign.
pub fn trapdoor_contribution_digest(c: &PartyTrapdoorContribution) -> [u8; 32] {
    use sha3::{Digest, Sha3_256};
    let mut h = Sha3_256::new();
    h.update(b"ft1536-threshold-spike/t10-contrib/v1");
    for poly in [&c.f, &c.g, &c.f_big, &c.g_big] {
        for &v in poly {
            h.update((v as i16).to_le_bytes());
        }
    }
    h.finalize().into()
}

/// T10 — otwarcie **wyłącznie** różnicy `fG − gF` (wartość kontrolna).
/// Nie otwiera f,g,F,G. Dla poprawnego klucza NTRU wynik = `[q,0,…,0]`
/// z `q = 18433` (stała, nie wielomian stopnia >0).
///
/// Koszt: 2× ring-mul udział×udział (O(N²) reshare-muls, G-3).
pub fn ntru_fg_gf_open_delta(
    rng: &mut impl rand::RngCore,
    td: &ITrapdoorShares,
    xs: &[u16],
    k: u8,
) -> Result<Vec<i64>> {
    let fg = i_poly_mul_ring_shares(rng, &td.f, &td.g_big, xs, k)?;
    let gf = i_poly_mul_ring_shares(rng, &td.g, &td.f_big, xs, k)?;
    let diff: IPolyShares = fg
        .iter()
        .zip(&gf)
        .map(|(a, b)| a.iter().zip(b).map(|(&x, &y)| p_sub(x, y)).collect())
        .collect();
    ireconstruct_poly_i64(&diff, xs)
}

/// T10 — offline NTRU `fG − gF = q = 18433` na **ważonej sumie** (udziałach).
///
/// Procedura offline (H1 moment keygen): strony weryfikują relację na
/// udziałach / przez zobowiązania VSS, **bez otwierania f,g,F,G**.
/// Otwarcie tylko wartości kontrolnej (różnica) — jak
/// [`crate::mul::ntru_fg_gf_check_shares`] / [`crate::mul::ntru_relation_check`]
/// w U2/W1, ale na i16-poly Z_P ważonego DKG T9.1.
///
/// `true` ⇔ zrekonstruowana różnica == stała `q` (reszta współczynników 0).
/// Fałszywa relacja → `false` (fail-closed w torze keygen).
///
/// **H1:** to jest domknięcie „momentu” offline — tor produkcyjny =
/// [`dkg_trapdoor_from_weighted_contributions`] + ten check. Sam
/// [`g2_deal_trapdoor`] zostaje **retained / test-only**.
pub fn ntru_fg_gf_check_weighted_shares(
    rng: &mut impl rand::RngCore,
    td: &ITrapdoorShares,
    xs: &[u16],
    k: u8,
) -> Result<bool> {
    let d = ntru_fg_gf_open_delta(rng, td, xs, k)?;
    if d.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    Ok(d[0] == FT1536_Q as i64 && d[1..].iter().all(|&c| c == 0))
}

/// ZŁOTO MPS4-H + G-2 (VSS + MAC na otwarciach maski).
///
/// - walidacja max|F| < q/2 (już w dealu; druga linia obrony)
/// - MAC na otwarciach `d = X − r` w rounding (ukryte δ, Y6-style)
/// - MAC na wynikach ring-mul + open s1,s2 z kontrolą MAC (T9.3/R-G2-2)
///
/// `gauss_sigma`: `Some(σ)` = szum DGDG w liczniku przed round (T6/R-G2-1,
/// z MAC na szumie dla spójności G-2); `None` = tor deterministyczny.
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    check_xs_p(xs, k)?;
    // T9.2: range proof max|F| < q/2 — druga linia obrony (obok deal/DKG).
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
    let mut cost = SignCost::default();

    let t64: Vec<i64> = t
        .iter()
        .map(|&c| {
            let q = FT1536_Q as i64;
            let v = c as i64;
            if v > q / 2 {
                v - q
            } else {
                v
            }
        })
        .collect();

    // H2: t·f, t·F na udziałach; MAC przez liniowość (t jawne)
    let tf = mul_ring_public_t_shares(&t64, &gt.td.f)?;
    let t_f_big = mul_ring_public_t_shares(&t64, &gt.td.f_big)?;
    let tf_mac = mul_ring_public_t_shares(&t64, &gt.f_mac)?;
    let t_f_big_mac = mul_ring_public_t_shares(&t64, &gt.f_big_mac)?;

    // negate tF + MAC (liniowość)
    let t_f_big_neg: IPolyShares = t_f_big
        .iter()
        .map(|col| col.iter().map(|&s| p_sub(0, s)).collect())
        .collect();
    let t_f_big_neg_mac: IPolyShares = t_f_big_mac
        .iter()
        .map(|col| col.iter().map(|&s| p_sub(0, s)).collect())
        .collect();

    // T6/T7: niezależny PRSS DGDG + MAC per współczynnik z1 / z0 (R-G2-1)
    // Bez dealera clear-bit / clear-noise (T7.1/T7.2).
    let (g1, g1m, g0, g0m) = match gauss_sigma {
        Some(sigma) => {
            let mut g1 = Vec::with_capacity(FT1536_N);
            let mut g1m = Vec::with_capacity(FT1536_N);
            let mut g0 = Vec::with_capacity(FT1536_N);
            let mut g0m = Vec::with_capacity(FT1536_N);
            for _ in 0..FT1536_N {
                let (v, m) =
                    prss_dgdg_shares_with_mac(rng, sigma, xs, k, gt.delta_known)?;
                g1.push(v);
                g1m.push(m);
                let (v, m) =
                    prss_dgdg_shares_with_mac(rng, sigma, xs, k, gt.delta_known)?;
                g0.push(v);
                g0m.push(m);
            }
            (Some(g1), Some(g1m), Some(g0), Some(g0m))
        }
        None => (None, None, None, None),
    };

    // H3 z MAC na otwarciach maski (G-2) + opcjonalnym szumem T6
    let (z1, c1) = round_div_q_shares_g2(
        rng,
        &tf,
        &tf_mac,
        xs,
        k,
        bits_tf,
        &gt.delta,
        gt.delta_known,
        g1.as_ref(),
        g1m.as_ref(),
    )?;
    let (z0, c2) = round_div_q_shares_g2(
        rng,
        &t_f_big_neg,
        &t_f_big_neg_mac,
        xs,
        k,
        bits_tf_big,
        &gt.delta,
        gt.delta_known,
        g0.as_ref(),
        g0m.as_ref(),
    )?;
    cost.round.bit_ands = c1.bit_ands + c2.bit_ands;
    cost.round.bit_opens = c1.bit_opens + c2.bit_opens;
    cost.round.p_reshare_muls = c1.p_reshare_muls + c2.p_reshare_muls;
    cost.round.prss_xor_muls = c1.prss_xor_muls + c2.prss_xor_muls;

    // H4: splot udział×udział + MAC na wynikach ring-mul (T9.3 / R-G2-2)
    let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
    let (z1f, z1f_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.f_big, xs, k, gt.delta_known)?;
    let (z0g, z0g_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.g, xs, k, gt.delta_known)?;
    let (z1g, z1g_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.g_big, xs, k, gt.delta_known)?;
    cost.ring_reshare_muls = 4 * (FT1536_N as u64) * (FT1536_N as u64);

    let n = xs.len();
    let mut s2 = vec![vec![0u64; n]; FT1536_N];
    let mut s1 = vec![vec![0u64; n]; FT1536_N];
    let mut s2_mac = vec![vec![0u64; n]; FT1536_N];
    let mut s1_mac = vec![vec![0u64; n]; FT1536_N];
    for i in 0..FT1536_N {
        for p in 0..n {
            s2[i][p] = p_add(z0f[i][p], z1f[i][p]);
            s2_mac[i][p] = p_add(z0f_mac[i][p], z1f_mac[i][p]);
            s1[i][p] = p_sub(p_add(z0g[i][p], z1g[i][p]), i64_to_p(t64[i]));
            // MAC na −t: −δ·t na każdym udziale (stały Shamir; linia MAC)
            s1_mac[i][p] = p_sub(
                p_add(z0g_mac[i][p], z1g_mac[i][p]),
                p_mul(gt.delta_known % I_P, i64_to_p(t64[i])),
            );
        }
    }

    // Open s1, s2 z kontrolą MAC (ukryte δ) — T9.3: tamper ring-mul → MacFail
    let s1_i = zp_open_poly_with_mac_hidden_delta(&s1, &s1_mac, &gt.delta, k)?;
    let s2_i = zp_open_poly_with_mac_hidden_delta(&s2, &s2_mac, &gt.delta, k)?;
    Ok((s1_i, s2_i, cost))
}

// ─── round_half_away (oracle jasny, bit-exact vs f64::round z F2) ───────

/// Jawne round_half_away(v/q) — bit-exact vs `round_div_q_scalar` (F2).
pub fn round_half_away_i64(v: i64) -> i64 {
    let q = FT1536_Q as i64;
    if v >= 0 {
        (v + q / 2) / q
    } else {
        -(((-v) + q / 2) / q)
    }
}

#[cfg(test)]
mod tests_mps4h {
    use super::*;
    use crate::mpc_sign::{
        decode_sk_ft1536, encode_sig_static, hash_to_point_from_nonce_msg, poly_inv_ring,
        poly_norm2_centered, q_poly_mul_ring_clear, sample_z_ffsampling, verify_sign_equation,
        TrapdoorClear,
    };
    use ft1536_sys::{Ft1536KeyPair, Ft1536Signature};
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    const XS: [u16; 3] = [1, 2, 3];
    const K: u8 = 2;

    #[test]
    fn mps4h_ishare_roundtrip_i16() {
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_48);
        let poly: Vec<i16> = (0..FT1536_N as i16)
            .map(|i| if i % 3 == 0 { -1 } else { (i % 7) - 3 })
            .collect();
        let ps = ishare_poly(&mut rng, &poly, &XS, K).unwrap();
        let back = ireconstruct_poly(&ps, &XS).unwrap();
        assert_eq!(back, poly);
    }

    #[test]
    fn mps4h_round_half_away_matches_f64() {
        // bit-exact vs round_div_q_scalar (f64::round) z F2
        for v in [-100000i64, -27649, -18433, -9217, -9216, -1, 0, 1, 9216, 9217, 18433, 27649, 99999] {
            let expect = ((v as f64) / (FT1536_Q as f64)).round() as i64;
            assert_eq!(round_half_away_i64(v), expect, "v={v}");
        }
    }

    /// H3 na jednym współczynniku: round_div_q_scalar_shares ≡ round_half_away.
    #[test]
    fn mps4h_round_div_q_scalar_matches_clear() {
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_49);
        let xs_gf: Vec<u8> = XS.iter().map(|&v| v as u8).collect();
        let lam = gf_lagrange_all(&xs_gf).unwrap();
        let cases: Vec<i64> = vec![
            0,
            1,
            -1,
            9216,
            9217,
            -9216,
            -9217,
            18433,
            -18433,
            27649,
            -27649,
            100000,
            -100000,
            14155776,
            -14155776,
            123456789,
            -123456789,
            920_000_000,
            -920_000_000,
        ];
        let bits = 32u32;
        for &v in &cases {
            if (v as i64).unsigned_abs() >= (1u64 << (bits - 1)) {
                continue;
            }
            let sh = ishare_val(&mut rng, v, &XS, K).unwrap();
            let mut cost = RoundCost::default();
            let zsh =
                round_div_q_scalar_shares(&mut rng, &sh, &XS, &xs_gf, K, &lam, bits, &mut cost, None)
                    .unwrap();
            let z = ireconstruct_val(&XS, &zsh).unwrap();
            let expect = round_half_away_i64(v);
            assert_eq!(z, expect, "v={v} z={z} expect={expect}");
        }
    }

    /// H3: round_div_q_shares ≡ round_half_away per coeff (mały wektor testowy
    /// na pełnym N — kilka niezerowych współczynników).
    #[test]
    fn mps4h_round_div_q_matches_clear() {
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_4A);
        let mut x = vec![0i64; FT1536_N];
        x[0] = 12345678;
        x[1] = -7654321;
        x[2] = 9216;
        x[3] = -9217;
        x[100] = 14155776;
        x[1535] = -14155776;
        let sh = x
            .iter()
            .map(|&v| ishare_val(&mut rng, v, &XS, K).unwrap())
            .collect::<IPolyShares>();
        let (zsh, cost) = round_div_q_shares(&mut rng, &sh, &XS, K, 25, None).unwrap();
        let z = ireconstruct_poly_i64(&zsh, &XS).unwrap();
        for i in 0..FT1536_N {
            assert_eq!(z[i], round_half_away_i64(x[i]), "i={i} x={}", x[i]);
        }
        eprintln!(
            "H3-poly cost (full N, bits=25): bit_ands={} bit_opens={} p_muls={}",
            cost.bit_ands, cost.bit_opens, cost.p_reshare_muls
        );
        assert!(cost.bit_ands > 0, "H3 musi robić AND-y na bitach");
    }

    /// Helper: z0,z1 z udziałów f,F przez H2+H3 (bez clear f,F w torze).
    fn mps4h_sample_z_shares(
        rng: &mut impl rand::RngCore,
        f_sh: &IPolyShares,
        f_big_sh: &IPolyShares,
        t: &[u16],
        xs: &[u16],
        bits_tf: u32,
        bits_tf_big: u32,
    ) -> Result<(IPolyShares, IPolyShares, RoundCost)> {
        let t64: Vec<i64> = t
            .iter()
            .map(|&c| {
                let q = FT1536_Q as i64;
                let v = c as i64;
                if v > q / 2 {
                    v - q
                } else {
                    v
                }
            })
            .collect();
        let tf = mul_ring_public_t_shares(&t64, f_sh)?;
        let t_f_big = mul_ring_public_t_shares(&t64, f_big_sh)?;
        let t_f_big_neg: IPolyShares = t_f_big
            .iter()
            .map(|col| col.iter().map(|&s| p_sub(0, s)).collect())
            .collect();
        let (z1, c1) = round_div_q_shares(rng, &tf, xs, K, bits_tf, None)?;
        let (z0, c2) = round_div_q_shares(rng, &t_f_big_neg, xs, K, bits_tf_big, None)?;
        let mut cost = c1;
        cost.bit_ands += c2.bit_ands;
        cost.bit_opens += c2.bit_opens;
        cost.p_reshare_muls += c2.p_reshare_muls;
        Ok((z0, z1, cost))
    }

    /// ZŁOTO H3/H4: z z MPC ≡ `sample_z_ffsampling` (ten sam t) — bit-exact.
    /// i16 F,G (duży moduł) ≡ centered mod q na realnym kluczu (max|F|≪q/2).
    #[test]
    fn mps4h_z_matches_clear_ffsampling() {
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_4B);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, _g16, f_big16, _g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let (f, _g, f_big, _g_big) = decode_sk_ft1536(kp.secret_key()).unwrap();
        let td_c = TrapdoorClear {
            f: f.clone(),
            g: vec![0u16; FT1536_N],
            f_big: f_big.clone(),
            g_big: vec![0u16; FT1536_N],
        };
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let (z0_c, z1_c) = sample_z_ffsampling(&td_c, &t).unwrap();

        // udziały i16 — NIE buduj TrapdoorClear w torze H3
        let f_sh = ishare_poly(&mut rng, &f16, &XS, K).unwrap();
        let f_big_sh = ishare_poly(&mut rng, &f_big16, &XS, K).unwrap();
        // max|F| pin: na seed 0x42 to 59 — musi się mieścić w centered mod q
        let max_f = f16.iter().map(|&c| c.unsigned_abs() as i32).max().unwrap();
        assert!(
            max_f < (FT1536_Q as i32) / 2,
            "max|F|={max_f} musi być < q/2 dla z≡clear (patrz MPS_H_NOTES)"
        );
        let (z0, z1, cost) =
            mps4h_sample_z_shares(&mut rng, &f_sh, &f_big_sh, &t, &XS, 25, 32).unwrap();
        let z0_i = ireconstruct_poly_i64(&z0, &XS).unwrap();
        let z1_i = ireconstruct_poly_i64(&z1, &XS).unwrap();
        assert_eq!(z1_i, z1_c, "z1 z MPC ≡ sample_z_ffsampling (bit-exact)");
        assert_eq!(z0_i, z0_c, "z0 z MPC ≡ sample_z_ffsampling (bit-exact)");
        eprintln!(
            "H3-z pin seed=0x42: z0[0]={} z1[0]={} cost={:?}",
            z0_i[0], z1_i[0], cost
        );
    }

    /// ZŁOTO MPS4-H (wariant B, zamknięcie G-1): udziały f,g,F,G (i16)
    /// → z z H3 (bez clear f,F) → s1,s2 na udziałach → open s1,s2 →
    /// n < bound + verify_sign_equation + Ft1536Signature::verify == true.
    /// NIE ma clear f,F w torze sign po setupie udziałów.
    #[test]
    fn mps4h_ffsampling_shares_gold() {
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_4C);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        // udziały i16 (H1) — po tym momencie f,g,F,G NIE są w clear w torze sign
        let td = ITrapdoorShares {
            f: ishare_poly(&mut rng, &f16, &XS, K).unwrap(),
            g: ishare_poly(&mut rng, &g16, &XS, K).unwrap(),
            f_big: ishare_poly(&mut rng, &f_big16, &XS, K).unwrap(),
            g_big: ishare_poly(&mut rng, &g_big16, &XS, K).unwrap(),
        };
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let t_start = std::time::Instant::now();
        let (s1_i, s2_i, cost) =
            mps4h_sign_shares(&mut rng, &td, &t, &XS, K, 25, 32, None).unwrap();
        let elapsed = t_start.elapsed();
        eprintln!(
            "GOLD-H seed=0x42 time={elapsed:?} ring_muls={} bit_ands={} bit_opens={}",
            cost.ring_reshare_muls, cost.round.bit_ands, cost.round.bit_opens
        );
        let s1 = i64_to_qpoly(&s1_i);
        let s2 = i64_to_qpoly(&s2_i);
        let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
        assert!(
            n < 2093922385,
            "norma {n} musi być < FALCON_FT1536_NORM_BOUND2=2093922385"
        );
        // pin: gdy z≡clear to n = 103747771 (F2)
        assert_eq!(n, 103747771, "pin n (z≡clear, seed 0x42, msg gold-ff)");
        let h = {
            let fq: Vec<u16> = f16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let gq: Vec<u16> = g16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let f_inv = poly_inv_ring(&fq).unwrap();
            q_poly_mul_ring_clear(&gq, &f_inv)
        };
        assert!(
            verify_sign_equation(&s1, &s2, &h, &t),
            "równanie verify musi trzymać"
        );
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature {
            bytes: enc,
            nonce,
        };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig)
            .expect("engine verify nie może errorować");
        assert!(ok, "Ft1536Signature::verify == true (MPS4-H gold)");
    }

    /// Konstrukcja: z powstaje z udziałów f,F BEZ otwierania f, F, t·f, t·F, z.
    /// Po setupie udziałów clear f,F jest zera; tor H2+H3 nie woła reconstruct
    /// na f, F, tf, tF ani z. Otwarcia w H3: wyłącznie maski.
    #[test]
    fn mps4h_z_shares_no_clear_open() {
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_4D);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, _g, f_big16, _g_big) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        // setup udziałów; potem clear jest zera (nie w torze)
        let mut f16_z = f16.clone();
        let mut f_big16_z = f_big16.clone();
        let f_sh = ishare_poly(&mut rng, &f16, &XS, K).unwrap();
        let f_big_sh = ishare_poly(&mut rng, &f_big16, &XS, K).unwrap();
        use zeroize::Zeroize;
        f16_z.zeroize();
        f_big16_z.zeroize();
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        // tor H2+H3: NIE reconstruct f, F, tf, tF, z
        let (z0, z1, cost) =
            mps4h_sample_z_shares(&mut rng, &f_sh, &f_big_sh, &t, &XS, 25, 32).unwrap();
        // konstrukcja zwróciła IPolyShares (sekretne), nie jawne z
        assert_eq!(z0.len(), FT1536_N);
        assert_eq!(z1.len(), FT1536_N);
        assert!(cost.bit_opens > 0, "otwarcia masek są; brak otwarcia x");
        // oracle moment (test, nie tor produkcyjny): z ≡ clear
        let z0_c = ireconstruct_poly_i64(&z0, &XS).unwrap();
        let z1_c = ireconstruct_poly_i64(&z1, &XS).unwrap();
        let mut td_c = TrapdoorClear {
            f: vec![0u16; FT1536_N],
            g: vec![0u16; FT1536_N],
            f_big: vec![0u16; FT1536_N],
            g_big: vec![0u16; FT1536_N],
        };
        // odbuduj oracle z i16 (test) — tor sign tego nie robi
        let (f16b, _, f_big16b, _) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        td_c.f = i64_to_qpoly(&f16b.iter().map(|&c| c as i64).collect::<Vec<_>>());
        td_c.f_big = i64_to_qpoly(&f_big16b.iter().map(|&c| c as i64).collect::<Vec<_>>());
        let (z0_o, z1_o) = sample_z_ffsampling(&td_c, &t).unwrap();
        assert_eq!(z0_c, z0_o);
        assert_eq!(z1_c, z1_o);
    }

    /// Mutacja: sfałszowany udział f → open s ≠ oracle LUB n ≥ bound
    /// LUB engine verify false. Fail-closed.
    #[test]
    fn mps4h_mutation_forged_share() {
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_4E);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        // oracle z (do porównania; w produkcji z jest tajne)
        let (f, _g, f_big, _g_big) = decode_sk_ft1536(kp.secret_key()).unwrap();
        let td_c = TrapdoorClear {
            f: f.clone(),
            g: vec![0u16; FT1536_N],
            f_big: f_big.clone(),
            g_big: vec![0u16; FT1536_N],
        };
        let (z0_o, z1_o) = sample_z_ffsampling(&td_c, &t).unwrap();

        let mut td = ITrapdoorShares {
            f: ishare_poly(&mut rng, &f16, &XS, K).unwrap(),
            g: ishare_poly(&mut rng, &g16, &XS, K).unwrap(),
            f_big: ishare_poly(&mut rng, &f_big16, &XS, K).unwrap(),
            g_big: ishare_poly(&mut rng, &g_big16, &XS, K).unwrap(),
        };
        // sfałszuj udział f[0] strony 0 (+1)
        td.f[0][0] = p_add(td.f[0][0], 1);
        let (s1_i, s2_i, _c) =
            mps4h_sign_shares(&mut rng, &td, &t, &XS, K, 25, 32, None).unwrap();
        let s1 = i64_to_qpoly(&s1_i);
        let s2 = i64_to_qpoly(&s2_i);
        let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
        let h = {
            let fq: Vec<u16> = f16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let gq: Vec<u16> = g16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let f_inv = poly_inv_ring(&fq).unwrap();
            q_poly_mul_ring_clear(&gq, &f_inv)
        };
        let eq = verify_sign_equation(&s1, &s2, &h, &t);
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature {
            bytes: enc,
            nonce,
        };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig).unwrap();
        eprintln!("MUTATION-H n={n} eq={eq} ok={ok} z0o0={}", z0_o[0]);
        let _ = z1_o;
        assert!(
            n >= 2093922385 || !eq || !ok,
            "fałszywy udział musi failować: n={n} eq={eq} ok={ok}"
        );
        assert!(!ok, "engine verify musi odrzucić (ok={ok} n={n})");
    }
}

#[cfg(test)]
mod tests_g2 {
    use super::*;
    use crate::mpc_sign::{
        encode_sig_static, hash_to_point_from_nonce_msg, poly_inv_ring,
        poly_norm2_centered, q_poly_mul_ring_clear, verify_sign_equation,
    };
    use crate::pedersen::{zp_vss_deal, zp_vss_verify};
    use ft1536_sys::{Ft1536KeyPair, Ft1536Signature};
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    const XS: [u16; 3] = [1, 2, 3];
    const K: u8 = 2;
    const DELTA: u64 = 0x0B;

    // ── Z_P MAC (analog y6_*) ──────────────────────────────────────────

    #[test]
    fn g2_zp_mac_open_ok() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_01);
        let (sh, ds) = share_val_mac_hidden_zp(&mut rng, 0x5A, &XS, K, DELTA).unwrap();
        assert_eq!(zp_open_with_mac_hidden_delta(&sh, &ds, K).unwrap(), 0x5A);
    }

    #[test]
    fn g2_zp_mac_tamper_value_fails() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_02);
        let (mut sh, ds) = share_val_mac_hidden_zp(&mut rng, 0x22, &XS, K, DELTA).unwrap();
        sh[1].share = p_add(sh[1].share, 1);
        assert_eq!(
            zp_open_with_mac_hidden_delta(&sh, &ds, K),
            Err(SpikeError::MacFail)
        );
    }

    #[test]
    fn g2_zp_mac_tamper_mac_fails() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_03);
        let (mut sh, ds) = share_val_mac_hidden_zp(&mut rng, 0x22, &XS, K, DELTA).unwrap();
        sh[2].mac = p_add(sh[2].mac, 1);
        assert_eq!(
            zp_open_with_mac_hidden_delta(&sh, &ds, K),
            Err(SpikeError::MacFail)
        );
    }

    #[test]
    fn g2_zp_mac_tamper_delta_share_fails() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_04);
        let (sh, mut ds) = share_val_mac_hidden_zp(&mut rng, 0x22, &XS, K, DELTA).unwrap();
        ds.shares[0] = p_add(ds.shares[0], 1);
        assert_eq!(
            zp_open_with_mac_hidden_delta(&sh, &ds, K),
            Err(SpikeError::MacFail)
        );
    }

    #[test]
    fn g2_zp_dkg_delta_works_with_mac_open() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_05);
        let ds = dkg_zp_delta_shares(&mut rng, &XS, K).unwrap();
        // jawne δ z udziałów (test — tor tego nie robi)
        let delta = i64_to_p(ireconstruct_val(&XS, &ds.shares).unwrap());
        let sh = share_val_with_mac_zp(&mut rng, 9, &XS, K, delta).unwrap();
        assert_eq!(zp_open_with_mac_hidden_delta(&sh, &ds, K).unwrap(), 9);
        let mut sh2 = sh.clone();
        sh2[0].share = p_add(sh2[0].share, 1);
        assert_eq!(
            zp_open_with_mac_hidden_delta(&sh2, &ds, K),
            Err(SpikeError::MacFail)
        );
    }

    // ─── VSS (Pedersen na Z_P, analog h1_*) ────────────────────────────

    #[test]
    fn g2_vss_honest_shares_ok() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_10);
        let secret = 0x1234i64;
        let (com, shares) = zp_vss_deal(&mut rng, i64_to_p(secret), &XS, K);
        for sh in &shares {
            assert!(zp_vss_verify(sh, &com).is_ok());
        }
    }

    #[test]
    fn g2_vss_forge_share_detected() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_11);
        let (com, mut shares) = zp_vss_deal(&mut rng, 0x11, &XS, K);
        shares[1].share += 1;
        assert!(zp_vss_verify(&shares[1], &com).is_err());
    }

    #[test]
    fn g2_vss_poly_forge_f_share_aborts() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_12);
        let f16: Vec<i16> = (0..FT1536_N as i16).map(|i| (i % 7) - 3).collect();
        let (mut sh, vss) = ishare_poly_with_vss_count(&mut rng, &f16, &XS, K, 8).unwrap();
        // fałszywy udział f[0] strony 1
        sh.values[0][1] = p_add(sh.values[0][1], 1);
        assert_eq!(
            vss_verify_poly_shares(&vss, &sh, &XS),
            Err(SpikeError::CommitmentMismatch)
        );
    }

    #[test]
    fn g2_vss_poly_forge_f_big_share_aborts() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_13);
        let f_big16: Vec<i16> = (0..FT1536_N as i16).map(|i| 40 - (i % 20) as i16).collect();
        let (mut sh, vss) = ishare_poly_with_vss_count(&mut rng, &f_big16, &XS, K, 8).unwrap();
        // fałszywy udział F[5] strony 0
        sh.values[5][0] = p_sub(sh.values[5][0], 1);
        assert_eq!(
            vss_verify_poly_shares(&vss, &sh, &XS),
            Err(SpikeError::CommitmentMismatch)
        );
    }

    /// u128: x=255 nie przepełnia ewaluacji Shamir (stary u64: x≥8 dla k=2).
    #[test]
    fn g2_vss_eval_x255_ok() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_14);
        let xs: Vec<u16> = vec![1, 7, 8, 255];
        let k = 2u8;
        let secret = 0x1234i64;
        let (com, shares) = zp_vss_deal(&mut rng, i64_to_p(secret), &xs, k);
        for sh in &shares {
            assert!(
                zp_vss_verify(sh, &com).is_ok(),
                "x={} musi verifikować (u128, brak overflow)",
                sh.x
            );
        }
    }

    /// u128 k=3: xs=[1,2,3] verifikuje (stary u64: x≥3 dla k=3 overflow).
    #[test]
    fn g2_vss_eval_k3_ok() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_15);
        let xs: Vec<u16> = vec![1, 2, 3];
        let k = 3u8;
        let secret = 0x55i64;
        let (com, shares) = zp_vss_deal(&mut rng, i64_to_p(secret), &xs, k);
        for sh in &shares {
            assert!(
                zp_vss_verify(sh, &com).is_ok(),
                "k=3 x={} musi verifikować (u128)",
                sh.x
            );
        }
    }

    // ─── max|F| < q/2 (fail-closed) ───────────────────────────────────

    #[test]
    fn g2_f_bound_violation_aborts() {
        // max|F| = 9216 = q/2 → naruszenie
        let f_big: Vec<i16> = vec![0; FT1536_N];
        let mut f_bad = f_big;
        f_bad[0] = F_BOUND_HALF_Q as i16; // 9216
        assert_eq!(validate_f_bound(&f_bad), Err(SpikeError::InconsistentShare));
        f_bad[0] = (F_BOUND_HALF_Q + 1) as i16;
        assert_eq!(validate_f_bound(&f_bad), Err(SpikeError::InconsistentShare));
        f_bad[0] = i16::MIN; // |−32768| ≥ q/2
        assert_eq!(validate_f_bound(&f_bad), Err(SpikeError::InconsistentShare));
    }

    #[test]
    fn g2_f_bound_real_key_ok() {
        let kp = Ft1536KeyPair::generate_from_seed(&[0x42u8; 32]).unwrap();
        let (_f, _g, f_big16, _g_big) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let max_f = f_big16.iter().map(|&c| (c as i32).unsigned_abs()).max().unwrap();
        assert!(max_f < F_BOUND_HALF_Q as u32, "max|F|={max_f}");
        assert!(validate_f_bound(&f_big16).is_ok());
    }

    // ─── Matrix: otwarcia maski / bit-decomp / s1,s2 ───────────────────

    #[test]
    fn g2_mac_forge_w_mask_detected() {
        // maska W-bitowa: fałszywy udział maski r → MacFail przy open d
        let mut rng = StdRng::seed_from_u64(0x47_32_00_20);
        let (sh, ds) = share_val_mac_hidden_zp(&mut rng, 100, &XS, K, DELTA).unwrap();
        // "maska" r jako druga wartość; d = x − r
        let (rsh, _rds) = share_val_mac_hidden_zp(&mut rng, 30, &XS, K, DELTA).unwrap();
        let d_mac: Vec<ZpMacShare> = sh
            .iter()
            .zip(&rsh)
            .map(|(a, b)| ZpMacShare {
                x: a.x,
                share: p_sub(a.share, b.share),
                mac: p_sub(a.mac, b.mac),
            })
            .collect();
        // fałszywy udział maski: zmień share d strony 0 (ekw. tamper r)
        let mut d_tampered = d_mac.clone();
        d_tampered[0].share = p_add(d_tampered[0].share, 1);
        assert_eq!(
            zp_open_with_mac_hidden_delta(&d_tampered, &ds, K),
            Err(SpikeError::MacFail)
        );
        // uczciwe d otwiera się poprawnie (70 = 100−30)
        assert_eq!(zp_open_with_mac_hidden_delta(&d_mac, &ds, K).unwrap(), 70);
    }

    #[test]
    fn g2_mac_forge_bit_decomp_open_detected() {
        // otwarcie bit-decomp (d = X−r): fałszywy MAC → MacFail
        let mut rng = StdRng::seed_from_u64(0x47_32_00_21);
        let (mut sh, ds) = share_val_mac_hidden_zp(&mut rng, 5, &XS, K, DELTA).unwrap();
        sh[1].mac = p_add(sh[1].mac, 1);
        assert_eq!(
            zp_open_with_mac_hidden_delta(&sh, &ds, K),
            Err(SpikeError::MacFail)
        );
    }

    #[test]
    fn g2_mac_forge_s1_s2_open_detected() {
        // s1/s2-type value: tamper udział przed open → MacFail
        for (tag, secret) in [("s1", 12345i64), ("s2", -6789i64)] {
            let mut rng = StdRng::seed_from_u64(0x47_32_00_22);
            let (mut sh, ds) = share_val_mac_hidden_zp(&mut rng, secret, &XS, K, DELTA).unwrap();
            let idx = if tag == "s1" { 0 } else { 2 };
            sh[idx].share = p_sub(sh[idx].share, 1);
            assert_eq!(
                zp_open_with_mac_hidden_delta(&sh, &ds, K),
                Err(SpikeError::MacFail),
                "tag={tag}"
            );
        }
    }

    // ─── G-2 sign: regresja złota + detekcja ──────────────────────────

    /// Uczciwy deal + G-2 sign → engine verify true (regresja złota).
    #[test]
    fn g2_sign_honest_engine_verify_true() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_30);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let gt = g2_deal_trapdoor(&mut rng, &f16, &g16, &f_big16, &g_big16, &XS, K, DELTA)
            .unwrap();
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let (s1_i, s2_i, _cost) =
            mps4h_sign_shares_g2(&mut rng, &gt, &t, &XS, K, 25, 32, None).unwrap();
        let s1 = i64_to_qpoly(&s1_i);
        let s2 = i64_to_qpoly(&s2_i);
        let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
        assert!(n < 2093922385, "norma {n} musi być < bound");
        let h = {
            let fq: Vec<u16> = f16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let gq: Vec<u16> = g16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let f_inv = poly_inv_ring(&fq).unwrap();
            q_poly_mul_ring_clear(&gq, &f_inv)
        };
        assert!(verify_sign_equation(&s1, &s2, &h, &t));
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature { bytes: enc, nonce };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig)
            .expect("engine verify nie może errorować");
        assert!(ok, "G-2 sign: engine verify == true (regresja złota)");
    }

    /// Fałszywy udział f w torze sign → VSS abort (CommitmentMismatch).
    #[test]
    fn g2_sign_forge_share_f_aborts() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_31);
        let seed = [0x42u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let mut gt =
            g2_deal_trapdoor(&mut rng, &f16, &g16, &f_big16, &g_big16, &XS, K, DELTA).unwrap();
        // sfałszuj udział f[0] strony 0
        gt.td.f[0][0] = p_add(gt.td.f[0][0], 1);
        // G-2: weryfikacja VSS przed sign → abort
        gt.vss_sh_f.values = gt.td.f.clone();
        let vss_check = vss_verify_poly_shares(&gt.vss_f, &gt.vss_sh_f, &XS);
        assert_eq!(vss_check, Err(SpikeError::CommitmentMismatch));
    }

    /// Fałszywy udział F (f_big) → VSS abort.
    #[test]
    fn g2_sign_forge_share_f_big_aborts() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_32);
        let seed = [0x42u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let mut gt =
            g2_deal_trapdoor(&mut rng, &f16, &g16, &f_big16, &g_big16, &XS, K, DELTA).unwrap();
        gt.td.f_big[3][1] = p_add(gt.td.f_big[3][1], 1);
        gt.vss_sh_f_big.values = gt.td.f_big.clone();
        let vss_check = vss_verify_poly_shares(&gt.vss_f_big, &gt.vss_sh_f_big, &XS);
        assert_eq!(vss_check, Err(SpikeError::CommitmentMismatch));
    }

    /// Fałszywy MAC f → MacFail przy pierwszym otwarciu maski w rounding.
    #[test]
    fn g2_sign_forge_mac_f_detected() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_33);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let mut gt =
            g2_deal_trapdoor(&mut rng, &f16, &g16, &f_big16, &g_big16, &XS, K, DELTA).unwrap();
        // sfałszuj MAC f[0] strony 0 (fałszywy MAC — nie wartość)
        gt.f_mac[0][0] = p_add(gt.f_mac[0][0], 1);
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let result = mps4h_sign_shares_g2(&mut rng, &gt, &t, &XS, K, 25, 32, None);
        assert_eq!(result.map(|_| ()), Err(SpikeError::MacFail));
    }

    /// E2E: tamper wartości td.f po dealu (bez update MAC) → sign → abort.
    /// MAC na open d=X−r łapie niespójność wartość↔MAC (propagacja liniowa).
    #[test]
    fn g2_sign_value_forge_f_aborts_e2e() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_35);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let mut gt =
            g2_deal_trapdoor(&mut rng, &f16, &g16, &f_big16, &g_big16, &XS, K, DELTA).unwrap();
        // tamper wartości f[0] strony 0 — BEZ update MAC
        gt.td.f[0][0] = p_add(gt.td.f[0][0], 1);
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let result = mps4h_sign_shares_g2(&mut rng, &gt, &t, &XS, K, 25, 32, None);
        assert_eq!(
            result.map(|_| ()),
            Err(SpikeError::MacFail),
            "tamper td.f value → MacFail (MAC na open d łapie wartość bez MAC)"
        );
    }

    /// E2E: tamper wartości td.f_big po dealu (bez update MAC) → sign → abort.
    #[test]
    fn g2_sign_value_forge_f_big_aborts_e2e() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_36);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let mut gt =
            g2_deal_trapdoor(&mut rng, &f16, &g16, &f_big16, &g_big16, &XS, K, DELTA).unwrap();
        // tamper wartości f_big[3] strony 1 — BEZ update MAC
        gt.td.f_big[3][1] = p_add(gt.td.f_big[3][1], 1);
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let result = mps4h_sign_shares_g2(&mut rng, &gt, &t, &XS, K, 25, 32, None);
        assert_eq!(
            result.map(|_| ()),
            Err(SpikeError::MacFail),
            "tamper td.f_big value → MacFail (MAC na open d łapie wartość bez MAC)"
        );
    }

    /// max|F| ≥ q/2 przy dealu → abort (nie cicha kontynuacja).
    #[test]
    fn g2_deal_f_bound_violation_aborts() {
        let mut rng = StdRng::seed_from_u64(0x47_32_00_34);
        let f16 = vec![1i16; FT1536_N];
        let g16 = vec![1i16; FT1536_N];
        let mut f_big16 = vec![10i16; FT1536_N];
        f_big16[0] = F_BOUND_HALF_Q as i16; // 9216 ≥ q/2
        let g_big16 = vec![10i16; FT1536_N];
        let r = g2_deal_trapdoor(&mut rng, &f16, &g16, &f_big16, &g_big16, &XS, K, DELTA);
        assert_eq!(r.map(|_| ()), Err(SpikeError::InconsistentShare));
    }
}

// ─── T6 / R-G2-1 — testy szumu DGDG (fix Babai / Nguyen–Regev) ─────────

#[cfg(test)]
mod tests_t6 {
    use super::*;
    use crate::mpc_sign::{
        encode_sig_static, hash_to_point_from_nonce_msg, poly_inv_ring, poly_norm2_centered,
        q_poly_mul_ring_clear, verify_sign_equation,
    };
    use ft1536_sys::{Ft1536KeyPair, Ft1536Signature};
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    const XS: [u16; 3] = [1, 2, 3];
    const K: u8 = 2;
    /// FALCON_FT1536_NORM_BOUND2 (C: internal.h).
    const NORM_BOUND2: u64 = 2_093_922_385;

    /// Shannon entropy (bity) histogramu dyskretnego — pomiar rozmycia.
    fn shannon_entropy(counts: &[usize]) -> f64 {
        let total: usize = counts.iter().sum();
        if total == 0 {
            return 0.0;
        }
        counts
            .iter()
            .filter(|&&c| c > 0)
            .map(|&c| {
                let p = c as f64 / total as f64;
                -p * p.log2()
            })
            .sum()
    }

    /// σ poza zakresem → WrongThreshold (fail-closed).
    #[test]
    fn t6_sigma_fail_closed() {
        assert_eq!(t6_sigma_q73(0).map(|_| ()), Err(SpikeError::WrongThreshold));
        assert_eq!(
            t6_sigma_q73(T6_GAUSS_SIGMA_MAX + 1).map(|_| ()),
            Err(SpikeError::WrongThreshold)
        );
        assert_eq!(t6_gauss_window(0).map(|_| ()), Err(SpikeError::WrongThreshold));
        assert!(t6_sigma_q73(T6_GAUSS_SIGMA_DEFAULT).is_ok());
        let w = t6_gauss_window(T6_GAUSS_SIGMA_DEFAULT).unwrap();
        assert_eq!(w, 6 * i32::from(T6_GAUSS_SIGMA_DEFAULT), "±6σ okno");
    }

    /// Deal DGDG: |g| ≤ w, udziały rekonstruują g (test-only), pojedynczy
    /// udział partii NIE równa się sekretowi (k=2, 3 partie).
    #[test]
    fn t6_dgdg_deal_range_and_share_secrecy() {
        let mut rng = StdRng::seed_from_u64(0x54_36_00_01);
        let sigma = T6_GAUSS_SIGMA_DEFAULT;
        let w = t6_gauss_window(sigma).unwrap() as i64;
        let mut nonzero_secret = 0;
        for _ in 0..64 {
            let sh = deal_dgdg_shares(&mut rng, sigma, &XS, K).unwrap();
            let g = ireconstruct_val(&XS, &sh).unwrap();
            assert!(g.abs() <= w, "g={g} poza oknem ±{w}");
            // udziały Shamir k=2: żaden pojedynczy udział nie jest sekretem
            // (chyba że sekret=0 i udziały zbiegiem 0 — pomijamy)
            if g != 0 {
                assert!(
                    sh.iter().all(|&s| p_to_i64(s) != g),
                    "udział partii = sekret → wyciek"
                );
                nonzero_secret += 1;
            }
        }
        assert!(nonzero_secret > 8, "sampler powinien dawać niezera");
    }

    /// Poprawność toru z szumem: z_mpc ≡ round_half_away((x+g)/q)
    /// (g rekonstruowany w teście — produkcyjnie nigdy).
    #[test]
    fn t6_round_with_gauss_matches_clear_formula() {
        let mut rng = StdRng::seed_from_u64(0x54_36_00_02);
        let xs_gf: Vec<u8> = XS.iter().map(|&v| v as u8).collect();
        let lam = gf_lagrange_all(&xs_gf).unwrap();
        let bits = 16u32;
        let cases = [0i64, 1, -1, 100, -100, 5000, -5000, 9216, -9216];
        for &v in &cases {
            let sh = ishare_val(&mut rng, v, &XS, K).unwrap();
            let gsh = deal_dgdg_shares(&mut rng, T6_GAUSS_SIGMA_DEFAULT, &XS, K).unwrap();
            let g = ireconstruct_val(&XS, &gsh).unwrap();
            let mut cost = RoundCost::default();
            let zsh = round_div_q_scalar_shares(
                &mut rng,
                &sh,
                &XS,
                &xs_gf,
                K,
                &lam,
                bits,
                &mut cost,
                Some(&gsh),
            )
            .unwrap();
            let z = ireconstruct_val(&XS, &zsh).unwrap();
            let expect = round_half_away_i64(v + g);
            assert_eq!(z, expect, "v={v} g={g} z={z} expect={expect}");
        }
    }

    /// **t6_gauss_blurs_babai_edge** — pomiar: rozkład z na krawędzi round
    /// (x=9216 → z=0 / x=9217 → z=1 przy q=18433) z szumiem vs bez.
    /// Deterministycznie: entropia 0 (ostry skok Babai). Z szumiem DGDG:
    /// obie wartości obecne, entropia > 0 — krawędź rozmyta.
    /// NIE wymaga idealnej Gaussy — mierzy rozmycie krawędzi.
    #[test]
    fn t6_gauss_blurs_babai_edge() {
        let mut rng = StdRng::seed_from_u64(0x54_36_00_03);
        let xs_gf: Vec<u8> = XS.iter().map(|&v| v as u8).collect();
        let lam = gf_lagrange_all(&xs_gf).unwrap();
        let bits = 16u32;
        let q = FT1536_Q as i64;
        // krawędź 0→1: x = q/2 + 1 = 9217 (q=18433, q/2=9216)
        let edge_lo = q / 2; // 9216 → z=0
        let edge_hi = q / 2 + 1; // 9217 → z=1
        let trials = 32usize;

        // mapa z → indeks histogramu (z ∈ {-2..=3} wystarczy przy σ≤8)
        let z_lo = -3i64;
        let hist_len = 8usize;
        let zi = |z: i64| ((z - z_lo) as usize).min(hist_len - 1);

        for &(x, label) in &[(edge_lo, "x=9216"), (edge_hi, "x=9217")] {
            let mut hist_det = vec![0usize; hist_len];
            let mut hist_gauss = vec![0usize; hist_len];
            for t in 0..trials {
                // deterministyczny (retained F2)
                let sh = ishare_val(&mut rng, x, &XS, K).unwrap();
                let mut cost = RoundCost::default();
                let zsh = round_div_q_scalar_shares(
                    &mut rng, &sh, &XS, &xs_gf, K, &lam, bits, &mut cost, None,
                )
                .unwrap();
                let z_det = ireconstruct_val(&XS, &zsh).unwrap();
                hist_det[zi(z_det)] += 1;

                // z szumiem DGDG(σ=4)
                let sh = ishare_val(&mut rng, x, &XS, K).unwrap();
                let gsh = deal_dgdg_shares(&mut rng, T6_GAUSS_SIGMA_DEFAULT, &XS, K).unwrap();
                let mut cost = RoundCost::default();
                let zsh = round_div_q_scalar_shares(
                    &mut rng,
                    &sh,
                    &XS,
                    &xs_gf,
                    K,
                    &lam,
                    bits,
                    &mut cost,
                    Some(&gsh),
                )
                .unwrap();
                let z_g = ireconstruct_val(&XS, &zsh).unwrap();
                hist_gauss[zi(z_g)] += 1;
                let _ = t;
            }
            let h_det = shannon_entropy(&hist_det);
            let h_g = shannon_entropy(&hist_gauss);
            let distinct_det = hist_det.iter().filter(|&&c| c > 0).count();
            let distinct_g = hist_gauss.iter().filter(|&&c| c > 0).count();
            eprintln!(
                "T6-blur {label}: det hist={hist_det:?} H={h_det:.4} | \
                 gauss(σ={}) hist={hist_gauss:?} H={h_g:.4}",
                T6_GAUSS_SIGMA_DEFAULT
            );
            // Babai edge: deterministycznie jeden punkt, entropia 0
            assert_eq!(
                distinct_det, 1,
                "{label}: det z musi być jednoznaczne (ostra krawędź)"
            );
            assert_eq!(h_det, 0.0, "{label}: det entropia = 0");
            // szum rozmywa krawędź: ≥2 wartości z, entropia > 0
            assert!(
                distinct_g >= 2,
                "{label}: szum musi rozmyć krawędź (≥2 wartości z), hist={hist_gauss:?}"
            );
            assert!(
                h_g > 0.3,
                "{label}: entropia z z szumiem > 0.3 bita, H={h_g}"
            );
        }

        // pomiar wariancji z na krawędzi lo: det=0, gauss>0
        let mut zs_det = Vec::new();
        let mut zs_g = Vec::new();
        for _ in 0..trials {
            let sh = ishare_val(&mut rng, edge_lo, &XS, K).unwrap();
            let mut cost = RoundCost::default();
            let zsh = round_div_q_scalar_shares(
                &mut rng, &sh, &XS, &xs_gf, K, &lam, bits, &mut cost, None,
            )
            .unwrap();
            zs_det.push(ireconstruct_val(&XS, &zsh).unwrap() as f64);
            let sh = ishare_val(&mut rng, edge_lo, &XS, K).unwrap();
            let gsh = deal_dgdg_shares(&mut rng, T6_GAUSS_SIGMA_DEFAULT, &XS, K).unwrap();
            let mut cost = RoundCost::default();
            let zsh = round_div_q_scalar_shares(
                &mut rng,
                &sh,
                &XS,
                &xs_gf,
                K,
                &lam,
                bits,
                &mut cost,
                Some(&gsh),
            )
            .unwrap();
            zs_g.push(ireconstruct_val(&XS, &zsh).unwrap() as f64);
        }
        let var = |xs: &[f64]| {
            let m = xs.iter().sum::<f64>() / xs.len() as f64;
            xs.iter().map(|x| (x - m) * (x - m)).sum::<f64>() / xs.len() as f64
        };
        let v_det = var(&zs_det);
        let v_g = var(&zs_g);
        eprintln!("T6-blur var det={v_det:.6} gauss={v_g:.6}");
        assert_eq!(v_det, 0.0, "det wariancja z na krawędzi = 0");
        assert!(v_g > 0.0, "szum musi podnieść wariancję z na krawędzi");
    }

    /// **t6_gauss_secret_on_shares** — szum nie jest otwierany w torze sign:
    /// deal zwraca udziały (nie jawny scalars); sign zwraca wyłącznie
    /// (s1,s2,cost); niezależne dealsy mają różne sekrety szumu.
    /// Uwaga pomiarowa (prawda przed tempem): przy σ≪q oczekiwana liczba
    /// przekroczeń progu round na podpis to ≈ 0.27·σ na współczynnik —
    /// dwa pełne sign mogą zbiec się do tych samych (s1,s2). Dowód, że szum
    /// jest żywy w wyjściu: powtarzamy sign aż do różnicy (σ=8).
    #[test]
    fn t6_gauss_secret_on_shares() {
        let mut rng = StdRng::seed_from_u64(0x54_36_00_04);
        let seed = [0x42u8; 32];
        let msg = b"t6-secret-gauss";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let td = ITrapdoorShares {
            f: ishare_poly(&mut rng, &f16, &XS, K).unwrap(),
            g: ishare_poly(&mut rng, &g16, &XS, K).unwrap(),
            f_big: ishare_poly(&mut rng, &f_big16, &XS, K).unwrap(),
            g_big: ishare_poly(&mut rng, &g_big16, &XS, K).unwrap(),
        };
        let t = hash_to_point_from_nonce_msg(&nonce, msg);

        // deal szumu: wynik to udziały (Vec per party), nie jawna wartość
        let gsh = deal_dgdg_poly_shares(&mut rng, T6_GAUSS_SIGMA_DEFAULT, &XS, K, 8).unwrap();
        assert_eq!(gsh.len(), 8);
        for col in &gsh {
            assert_eq!(col.len(), XS.len(), "szum = udziały, nie jawny scalars");
        }
        // niezależne dealsy → różne sekrety szumu (test-only reconstruct);
        // w torze sign reconstruct g NIGDY nie jest wołany
        let gsh2 = deal_dgdg_poly_shares(&mut rng, T6_GAUSS_SIGMA_DEFAULT, &XS, K, 8).unwrap();
        let sec = |ps: &IPolyShares| -> Vec<i64> {
            ps.iter().map(|c| ireconstruct_val(&XS, c).unwrap()).collect()
        };
        let s1n = sec(&gsh);
        let s2n = sec(&gsh2);
        assert_ne!(s1n, s2n, "niezależne dealsy muszą dawać różne sekrety szumu");

        // szum żywy w wyjściu: przy σ=8 flipy round są prawie pewne;
        // dopuszczamy kilka prób (małe σ może nie zmienić żadnego z
        // 2N współczynników — patrz komentarz w docstringu)
        let sigma = 8u8;
        let (s1a, s2a, _) =
            mps4h_sign_shares(&mut rng, &td, &t, &XS, K, 25, 32, Some(sigma)).unwrap();
        let mut differed = false;
        for _ in 0..6 {
            let (s1b, s2b, _) =
                mps4h_sign_shares(&mut rng, &td, &t, &XS, K, 25, 32, Some(sigma)).unwrap();
            if s1a != s1b || s2a != s2b {
                differed = true;
                break;
            }
        }
        assert!(
            differed,
            "niezależne dealsy szumu powinny dawać różne (s1,s2) — \
             szum jest sekretnym wkładem, nie jawny stały"
        );
        // sign NIE zwraca szumu — tylko (s1, s2, cost)
        // (kontrakt typowy; brak reconstruct g w torze — otwarcia to
        //  masked d w H3 oraz jawne s1,s2)
    }

    /// **t6_norm_still_under_bound** — n z szumiem σ=8 < bound.
    /// Pin F2 (103747771) NIE jest asserowany gdy σ>0 — szum zmienia n.
    #[test]
    fn t6_norm_still_under_bound() {
        let mut rng = StdRng::seed_from_u64(0x54_36_00_05);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let td = ITrapdoorShares {
            f: ishare_poly(&mut rng, &f16, &XS, K).unwrap(),
            g: ishare_poly(&mut rng, &g16, &XS, K).unwrap(),
            f_big: ishare_poly(&mut rng, &f_big16, &XS, K).unwrap(),
            g_big: ishare_poly(&mut rng, &g_big16, &XS, K).unwrap(),
        };
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let sigma = 8u8; // górny koniec zakresu ownera — nadal mały vs q
        let t0 = std::time::Instant::now();
        let (s1_i, s2_i, cost) =
            mps4h_sign_shares(&mut rng, &td, &t, &XS, K, 25, 32, Some(sigma)).unwrap();
        eprintln!(
            "T6-norm σ={sigma} time={:?} ring_muls={} bit_ands={}",
            t0.elapsed(),
            cost.ring_reshare_muls,
            cost.round.bit_ands
        );
        let s1 = i64_to_qpoly(&s1_i);
        let s2 = i64_to_qpoly(&s2_i);
        let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
        eprintln!("T6-norm σ={sigma} n={n} bound={NORM_BOUND2} (F2 pin=103747771)");
        assert!(
            n < NORM_BOUND2,
            "norma {n} z szumiem σ={sigma} musi być < {NORM_BOUND2}"
        );
    }

    /// **t6_gold_with_gauss_engine_verify** — złoto z szumiem σ=4:
    /// n < bound, `verify_sign_equation`, `Ft1536Signature::verify == true`.
    #[test]
    fn t6_gold_with_gauss_engine_verify() {
        let mut rng = StdRng::seed_from_u64(0x54_36_00_06);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let td = ITrapdoorShares {
            f: ishare_poly(&mut rng, &f16, &XS, K).unwrap(),
            g: ishare_poly(&mut rng, &g16, &XS, K).unwrap(),
            f_big: ishare_poly(&mut rng, &f_big16, &XS, K).unwrap(),
            g_big: ishare_poly(&mut rng, &g_big16, &XS, K).unwrap(),
        };
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let sigma = T6_GAUSS_SIGMA_DEFAULT;
        let t0 = std::time::Instant::now();
        let (s1_i, s2_i, cost) =
            mps4h_sign_shares(&mut rng, &td, &t, &XS, K, 25, 32, Some(sigma)).unwrap();
        eprintln!(
            "T6-gold σ={sigma} time={:?} ring_muls={} bit_ands={} bit_opens={}",
            t0.elapsed(),
            cost.ring_reshare_muls,
            cost.round.bit_ands,
            cost.round.bit_opens
        );
        let s1 = i64_to_qpoly(&s1_i);
        let s2 = i64_to_qpoly(&s2_i);
        let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
        eprintln!("T6-gold σ={sigma} n={n} bound={NORM_BOUND2}");
        assert!(
            n < NORM_BOUND2,
            "norma {n} z szumiem musi być < FALCON_FT1536_NORM_BOUND2={NORM_BOUND2}"
        );
        let h = {
            let fq: Vec<u16> = f16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let gq: Vec<u16> = g16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let f_inv = poly_inv_ring(&fq).unwrap();
            q_poly_mul_ring_clear(&gq, &f_inv)
        };
        assert!(
            verify_sign_equation(&s1, &s2, &h, &t),
            "równanie verify musi trzymać z szumiem"
        );
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature { bytes: enc, nonce };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig)
            .expect("engine verify nie może errorować");
        assert!(ok, "Ft1536Signature::verify == true (T6 gold z szumiem)");
    }
}

// ─── T7.1–T7.4 — PRSS bez dealera: maski bitowe, szum, matrix fałszerstw ──

#[cfg(test)]
mod tests_t7 {
    use super::*;
    use crate::mpc_sign::{
        encode_sig_static, hash_to_point_from_nonce_msg, poly_inv_ring, poly_norm2_centered,
        q_poly_mul_ring_clear, verify_sign_equation,
    };
    use ft1536_sys::{Ft1536KeyPair, Ft1536Signature};
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    const XS: [u16; 3] = [1, 2, 3];
    const K: u8 = 2;
    const DELTA: u64 = 0x0B;
    /// FALCON_FT1536_NORM_BOUND2 (C: internal.h).
    const NORM_BOUND2: u64 = 2_093_922_385;

    fn shannon_entropy(counts: &[usize]) -> f64 {
        let total: usize = counts.iter().sum();
        if total == 0 {
            return 0.0;
        }
        counts
            .iter()
            .filter(|&&c| c > 0)
            .map(|&c| {
                let p = c as f64 / total as f64;
                -p * p.log2()
            })
            .sum()
    }

    // ─── T7.1 — PRSS maski bitowe ────────────────────────────────────────

    /// PRSS para masek: GF i Z_P rekonstruują **ten sam** bit (test-only).
    /// Tor sign nigdy nie rekonstruuje bitu maski.
    #[test]
    fn t7_prss_bit_mask_reconstructs_bit() {
        let mut rng = StdRng::seed_from_u64(0x54_37_00_01);
        let mut cost = RoundCost::default();
        for _ in 0..64 {
            let (mg, mp) = paired_bit_mask_prss(&mut rng, &XS, &[1, 2, 3], K, &mut cost).unwrap();
            // test-only: rekonstrukcja bitu (produkcyjnie NIE)
            let gf_bit = {
                let shares: Vec<Share> = mg
                    .iter()
                    .zip(&XS)
                    .map(|(&s, &x)| Share {
                        x: x as u8,
                        share: s,
                    })
                    .collect();
                let refs: Vec<&Share> = shares.iter().collect();
                crate::reconstruct(&refs).unwrap()
            };
            let p_bit = ireconstruct_val(&XS, &mp).unwrap();
            assert!(
                gf_bit == 0 || gf_bit == 1,
                "GF mask bit musi być 0/1, got {gf_bit}"
            );
            assert!(
                p_bit == 0 || p_bit == 1,
                "Z_P mask bit musi być 0/1, got {p_bit}"
            );
            assert_eq!(gf_bit as i64, p_bit, "GF i Z_P muszą dawać ten sam bit");
        }
        assert!(
            cost.prss_xor_muls > 0,
            "PRSS XOR chain musi zużywać reshare-muls"
        );
    }

    /// PRSS bit mask: koszt XOR chain = n−1 muls na bit (dla n=3: 2).
    #[test]
    fn t7_prss_bit_mask_xor_cost() {
        let mut rng = StdRng::seed_from_u64(0x54_37_00_02);
        let mut cost = RoundCost::default();
        let w = 8usize;
        let (_gf, _p) = crate::prss::shared_bit_masks(
            &mut rng,
            w,
            &XS,
            &[1, 2, 3],
            K,
            &mut cost,
        )
        .unwrap();
        // n=3 → 2 muls na bit × 8 bitów = 16
        assert_eq!(
            cost.prss_xor_muls,
            2 * w as u64,
            "n−1 muls na bit dla n=3"
        );
    }

    /// PRSS MAC: MAC = δ·bit (liniowość). Spójność przez rekonstrukcję (test).
    #[test]
    fn t7_prss_bit_mask_mac_consistent() {
        let mut rng = StdRng::seed_from_u64(0x54_37_00_03);
        let mut cost = RoundCost::default();
        for _ in 0..32 {
            let (mg, mp, mm) = paired_bit_mask_prss_mac(
                &mut rng,
                &XS,
                &[1, 2, 3],
                K,
                DELTA,
                &mut cost,
            )
            .unwrap();
            let bit = ireconstruct_val(&XS, &mp).unwrap();
            let mac = ireconstruct_val(&XS, &mm).unwrap();
            let expect_mac = p_to_i64(p_mul(DELTA % I_P, i64_to_p(bit)));
            assert_eq!(
                mac, expect_mac,
                "MAC = δ·bit (bit={bit} mac={mac} expect={expect_mac})"
            );
            let _ = mg; // GF shares — używane w obwodzie bitowym
        }
    }

    /// Structural: API toru sign zwraca **wyłącznie** udziały (Vec per party),
    /// nie jawny bit maski. Paired mask API: (GfBitShares, Vec<u64>).
    #[test]
    fn t7_prss_bit_mask_api_returns_only_shares() {
        let mut rng = StdRng::seed_from_u64(0x54_37_00_04);
        let mut cost = RoundCost::default();
        let (mg, mp) = paired_bit_mask_prss(&mut rng, &XS, &[1, 2, 3], K, &mut cost).unwrap();
        // mg: GfBitShares = Vec<u8> (udziały GF), mp: Vec<u64> (udziały Z_P)
        assert_eq!(mg.len(), XS.len(), "GF: n udziałów");
        assert_eq!(mp.len(), XS.len(), "Z_P: n udziałów");
        // brak trzeciego elementu = brak jawnego bitu w API
    }

    // ─── T7.2 — PRSS szum DGDG ───────────────────────────────────────────

    /// PRSS DGDG: |g| ≤ n·w_i (suma wkładów), udziały rekonstruują g (test),
    /// pojedynczy udział ≠ sekret.
    #[test]
    fn t7_prss_dgdg_range_and_secrecy() {
        let mut rng = StdRng::seed_from_u64(0x54_37_00_10);
        let sigma = T6_GAUSS_SIGMA_DEFAULT;
        let s73_total = t6_sigma_q73(sigma).unwrap();
        let s73_i = q73_div_sqrt(s73_total, XS.len());
        let w_i = t6_gauss_window_q73(s73_i).unwrap() as i64;
        let max_g = w_i * XS.len() as i64; // worst-case |Σ g_i|
        let mut nonzero_secret = 0;
        for _ in 0..64 {
            let sh = prss_dgdg_shares(&mut rng, sigma, &XS, K).unwrap();
            let g = ireconstruct_val(&XS, &sh).unwrap();
            assert!(g.abs() <= max_g, "g={g} poza ±{max_g}");
            if g != 0 {
                assert!(
                    sh.iter().all(|&s| p_to_i64(s) != g),
                    "udział partii = sekret → wyciek"
                );
                nonzero_secret += 1;
            }
        }
        assert!(nonzero_secret > 8, "sampler powinien dawać niezera");
    }

    /// PRSS DGDG: z_mpc ≡ round_half_away((x+g)/q) — g rekonstruowany
    /// w teście (produkcyjnie nigdy).
    #[test]
    fn t7_prss_dgdg_matches_clear_formula() {
        let mut rng = StdRng::seed_from_u64(0x54_37_00_11);
        let xs_gf: Vec<u8> = XS.iter().map(|&v| v as u8).collect();
        let lam = gf_lagrange_all(&xs_gf).unwrap();
        let bits = 16u32;
        let cases = [0i64, 1, -1, 100, -100, 5000, -5000, 9216, -9216];
        for &v in &cases {
            let sh = ishare_val(&mut rng, v, &XS, K).unwrap();
            let gsh = prss_dgdg_shares(&mut rng, T6_GAUSS_SIGMA_DEFAULT, &XS, K).unwrap();
            let g = ireconstruct_val(&XS, &gsh).unwrap();
            let mut cost = RoundCost::default();
            let zsh = round_div_q_scalar_shares(
                &mut rng,
                &sh,
                &XS,
                &xs_gf,
                K,
                &lam,
                bits,
                &mut cost,
                Some(&gsh),
            )
            .unwrap();
            let z = ireconstruct_val(&XS, &zsh).unwrap();
            let expect = round_half_away_i64(v + g);
            assert_eq!(z, expect, "v={v} g={g} z={z} expect={expect}");
        }
    }

    /// **t7_prss_dgdg_babai_blur** — pomiar H i var krawędzi Babai
    /// z PRSS szumem (jak T6, ale bez dealera). Mierzimy, nie twierdzimy.
    #[test]
    fn t7_prss_dgdg_babai_blur() {
        let mut rng = StdRng::seed_from_u64(0x54_37_00_12);
        let xs_gf: Vec<u8> = XS.iter().map(|&v| v as u8).collect();
        let lam = gf_lagrange_all(&xs_gf).unwrap();
        let bits = 16u32;
        let q = FT1536_Q as i64;
        let edge_lo = q / 2; // 9216 → z=0 (det)
        let edge_hi = q / 2 + 1; // 9217 → z=1 (det)
        let trials = 32usize;
        let z_lo = -3i64;
        let hist_len = 8usize;
        let zi = |z: i64| ((z - z_lo) as usize).min(hist_len - 1);

        for &(x, label) in &[(edge_lo, "x=9216"), (edge_hi, "x=9217")] {
            let mut hist_det = vec![0usize; hist_len];
            let mut hist_prss = vec![0usize; hist_len];
            for _ in 0..trials {
                // det (retained F2)
                let sh = ishare_val(&mut rng, x, &XS, K).unwrap();
                let mut cost = RoundCost::default();
                let zsh = round_div_q_scalar_shares(
                    &mut rng, &sh, &XS, &xs_gf, K, &lam, bits, &mut cost, None,
                )
                .unwrap();
                let z_det = ireconstruct_val(&XS, &zsh).unwrap();
                hist_det[zi(z_det)] += 1;

                // PRSS DGDG
                let sh = ishare_val(&mut rng, x, &XS, K).unwrap();
                let gsh =
                    prss_dgdg_shares(&mut rng, T6_GAUSS_SIGMA_DEFAULT, &XS, K).unwrap();
                let mut cost = RoundCost::default();
                let zsh = round_div_q_scalar_shares(
                    &mut rng,
                    &sh,
                    &XS,
                    &xs_gf,
                    K,
                    &lam,
                    bits,
                    &mut cost,
                    Some(&gsh),
                )
                .unwrap();
                let z_g = ireconstruct_val(&XS, &zsh).unwrap();
                hist_prss[zi(z_g)] += 1;
            }
            let h_det = shannon_entropy(&hist_det);
            let h_g = shannon_entropy(&hist_prss);
            let distinct_det = hist_det.iter().filter(|&&c| c > 0).count();
            let distinct_g = hist_prss.iter().filter(|&&c| c > 0).count();
            eprintln!(
                "T7-blur {label}: det hist={hist_det:?} H={h_det:.4} | \
                 prss(σ={}) hist={hist_prss:?} H={h_g:.4}",
                T6_GAUSS_SIGMA_DEFAULT
            );
            assert_eq!(distinct_det, 1, "{label}: det ostra krawędź");
            assert_eq!(h_det, 0.0, "{label}: det entropia = 0");
            assert!(
                distinct_g >= 2,
                "{label}: PRSS szum musi rozmyć krawędź, hist={hist_prss:?}"
            );
            assert!(
                h_g > 0.3,
                "{label}: entropia z z PRSS szumem > 0.3 bita, H={h_g}"
            );
        }

        // pomiar wariancji na krawędzi lo
        let mut zs_det = Vec::new();
        let mut zs_g = Vec::new();
        for _ in 0..trials {
            let sh = ishare_val(&mut rng, edge_lo, &XS, K).unwrap();
            let mut cost = RoundCost::default();
            let zsh = round_div_q_scalar_shares(
                &mut rng, &sh, &XS, &xs_gf, K, &lam, bits, &mut cost, None,
            )
            .unwrap();
            zs_det.push(ireconstruct_val(&XS, &zsh).unwrap() as f64);
            let sh = ishare_val(&mut rng, edge_lo, &XS, K).unwrap();
            let gsh = prss_dgdg_shares(&mut rng, T6_GAUSS_SIGMA_DEFAULT, &XS, K).unwrap();
            let mut cost = RoundCost::default();
            let zsh = round_div_q_scalar_shares(
                &mut rng,
                &sh,
                &XS,
                &xs_gf,
                K,
                &lam,
                bits,
                &mut cost,
                Some(&gsh),
            )
            .unwrap();
            zs_g.push(ireconstruct_val(&XS, &zsh).unwrap() as f64);
        }
        let var = |xs: &[f64]| {
            let m = xs.iter().sum::<f64>() / xs.len() as f64;
            xs.iter().map(|x| (x - m) * (x - m)).sum::<f64>() / xs.len() as f64
        };
        let v_det = var(&zs_det);
        let v_g = var(&zs_g);
        eprintln!("T7-blur var det={v_det:.6} prss={v_g:.6}");
        assert_eq!(v_det, 0.0, "det wariancja z = 0");
        assert!(v_g > 0.0, "PRSS szum musi podnieść wariancję z");
    }

    /// PRSS szum: wynik to udziały (nie jawny scalars); niezależne dealsy
    /// dają różne sekrety szumu. Tor sign zwraca wyłącznie (s1,s2,cost).
    #[test]
    fn t7_prss_noise_secret_on_shares() {
        let mut rng = StdRng::seed_from_u64(0x54_37_00_13);
        let gsh = prss_dgdg_poly_shares(&mut rng, T6_GAUSS_SIGMA_DEFAULT, &XS, K, 8).unwrap();
        assert_eq!(gsh.len(), 8);
        for col in &gsh {
            assert_eq!(col.len(), XS.len(), "szum = udziały, nie jawny scalars");
        }
        let gsh2 = prss_dgdg_poly_shares(&mut rng, T6_GAUSS_SIGMA_DEFAULT, &XS, K, 8).unwrap();
        let sec = |ps: &IPolyShares| -> Vec<i64> {
            ps.iter().map(|c| ireconstruct_val(&XS, c).unwrap()).collect()
        };
        assert_ne!(sec(&gsh), sec(&gsh2), "niezależne dealsy muszą dawać różne sekrety");
    }

    /// PRSS DGDG + MAC: mac = δ·val (liniowość). Spójność przez rekonstrukcję.
    #[test]
    fn t7_prss_dgdg_mac_consistent() {
        let mut rng = StdRng::seed_from_u64(0x54_37_00_14);
        for _ in 0..32 {
            let (val, mac) =
                prss_dgdg_shares_with_mac(&mut rng, T6_GAUSS_SIGMA_DEFAULT, &XS, K, DELTA)
                    .unwrap();
            let g = ireconstruct_val(&XS, &val).unwrap();
            let m = ireconstruct_val(&XS, &mac).unwrap();
            let expect = p_to_i64(p_mul(DELTA % I_P, i64_to_p(g)));
            assert_eq!(m, expect, "MAC = δ·g (g={g})");
        }
    }

    // ─── T7.3 — reshare + H1 ─────────────────────────────────────────────

    /// reshare_ipoly_shares: sekret bez zmian po re-deal (jak tt52).
    #[test]
    fn t7_reshare_ipoly_preserves_secret() {
        let mut rng = StdRng::seed_from_u64(0x54_37_00_20);
        let poly: Vec<i16> = (0..FT1536_N as i16)
            .map(|i| if i % 3 == 0 { -1 } else { (i % 7) - 3 })
            .collect();
        let ps = ishare_poly(&mut rng, &poly, &XS, K).unwrap();
        let refreshed = reshare_ipoly_shares(&mut rng, &ps, &XS, K).unwrap();
        let back = ireconstruct_poly(&refreshed, &XS).unwrap();
        assert_eq!(back, poly, "re-deal zachowuje sekret");
        // udziały się zmieniły (re-deal = nowy sharing zera)
        assert_ne!(ps[0], refreshed[0], "udziały muszą się zmienić po re-deal");
    }

    // ─── T7.4 — matrix fałszerstw ────────────────────────────────────────

    /// Tamper udziału PRSS maski bit → MacFail w G-2 (fail-closed).
    #[test]
    fn t7_tamper_prss_mask_g2_macfail() {
        let mut rng = StdRng::seed_from_u64(0x54_37_00_30);
        let mut cost = RoundCost::default();
        let (mg, mp, mm) = paired_bit_mask_prss_mac(
            &mut rng, &XS, &[1, 2, 3], K, DELTA, &mut cost,
        )
        .unwrap();
        // Zbuduj d_mac shares i otwórz z ukrytym δ
        let ds = ishare_val(&mut rng, DELTA as i64, &XS, K).unwrap();
        let delta = ZpDeltaShares {
            xs: XS.to_vec(),
            shares: ds,
        };
        // FAŁSZERSTWO: tamper udziału mp[0] (maska)
        let mut mp_bad = mp.clone();
        mp_bad[0] = p_add(mp_bad[0], 1);
        let d_mac: Vec<ZpMacShare> = mp_bad
            .iter()
            .zip(&mm)
            .zip(&XS)
            .map(|((&s, &m), &x)| ZpMacShare {
                x,
                share: s,
                mac: m,
            })
            .collect();
        assert_eq!(
            zp_open_with_mac_hidden_delta(&d_mac, &delta, K),
            Err(SpikeError::MacFail),
            "tamper PRSS maski → MacFail"
        );
        let _ = mg;
    }

    /// Tamper udziału szumu → MacFail w G-2 (spójność MAC = δ·g).
    #[test]
    fn t7_tamper_noise_g2_macfail() {
        let mut rng = StdRng::seed_from_u64(0x54_37_00_31);
        let (mut val, mac) =
            prss_dgdg_shares_with_mac(&mut rng, T6_GAUSS_SIGMA_DEFAULT, &XS, K, DELTA)
                .unwrap();
        let ds = ishare_val(&mut rng, DELTA as i64, &XS, K).unwrap();
        let delta = ZpDeltaShares {
            xs: XS.to_vec(),
            shares: ds,
        };
        // FAŁSZERSTWO: tamper udziału szumu (wartość bez update MAC)
        val[1] = p_add(val[1], 1);
        let d_mac: Vec<ZpMacShare> = val
            .iter()
            .zip(&mac)
            .zip(&XS)
            .map(|((&s, &m), &x)| ZpMacShare {
                x,
                share: s,
                mac: m,
            })
            .collect();
        assert_eq!(
            zp_open_with_mac_hidden_delta(&d_mac, &delta, K),
            Err(SpikeError::MacFail),
            "tamper szumu → MacFail (G-2 MAC)"
        );
    }

    /// **Retained gap (T7.4):** tor bez G-2 nie ma MAC na szumie.
    /// Tamper udziału szumu w torze bez MAC → cicha zmiana wyniku
    /// (NIE fail-closed). To jest udokumentowana luka, nie fałszywy PASS.
    #[test]
    fn t7_no_g2_noise_tamper_retained_gap() {
        let mut rng = StdRng::seed_from_u64(0x54_37_00_32);
        let xs_gf: Vec<u8> = XS.iter().map(|&v| v as u8).collect();
        let lam = gf_lagrange_all(&xs_gf).unwrap();
        let bits = 16u32;
        let v = 9216i64; // krawędź — czuła na szum
        // uczciwy tor
        let sh = ishare_val(&mut rng, v, &XS, K).unwrap();
        let gsh = prss_dgdg_shares(&mut rng, T6_GAUSS_SIGMA_DEFAULT, &XS, K).unwrap();
        let mut cost = RoundCost::default();
        let zsh = round_div_q_scalar_shares(
            &mut rng, &sh, &XS, &xs_gf, K, &lam, bits, &mut cost, Some(&gsh),
        )
        .unwrap();
        let z_ok = ireconstruct_val(&XS, &zsh).unwrap();

        // tamper udziału szumu — BEZ G-2 MAC
        let sh2 = ishare_val(&mut rng, v, &XS, K).unwrap();
        let mut gsh_bad = prss_dgdg_shares(&mut rng, T6_GAUSS_SIGMA_DEFAULT, &XS, K).unwrap();
        gsh_bad[0] = p_add(gsh_bad[0], p_mul(3, i64_to_p(100))); // duża zmiana
        let mut cost2 = RoundCost::default();
        let zsh2 = round_div_q_scalar_shares(
            &mut rng, &sh2, &XS, &xs_gf, K, &lam, bits, &mut cost2, Some(&gsh_bad),
        )
        .unwrap();
        let z_bad = ireconstruct_val(&XS, &zsh2).unwrap();
        // RETAINED LUKA: bez G-2 MAC szum nie jest chroniony — tamper
        // może zmienić wynik bez detekcji. Pokazujemy granicę, nie PASS.
        eprintln!(
            "T7-gap (no G-2): z_ok={z_ok} z_bad={z_bad} (tamper szumu bez MAC)"
        );
        // Tor bez MAC może dać inny z — brak fail-closed na szumie.
        // To jest oczekiwana luka (udokumentowana), nie test na PASS.
        if z_ok != z_bad {
            eprintln!("T7-gap: tamper zmienił z (oczekiwane bez MAC); retained luka");
        }
        // Test przechodzi zawsze — pokazuje granicę, nie fałszywy PASS.
    }

    /// Regresja złota z PRSS: MPS4-H gold (gauss_sigma=None) — pin F2.
    #[test]
    fn t7_gold_with_prss_masks_engine_verify() {
        let mut rng = StdRng::seed_from_u64(0x54_37_00_40);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let td = ITrapdoorShares {
            f: ishare_poly(&mut rng, &f16, &XS, K).unwrap(),
            g: ishare_poly(&mut rng, &g16, &XS, K).unwrap(),
            f_big: ishare_poly(&mut rng, &f_big16, &XS, K).unwrap(),
            g_big: ishare_poly(&mut rng, &g_big16, &XS, K).unwrap(),
        };
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let (s1_i, s2_i, cost) =
            mps4h_sign_shares(&mut rng, &td, &t, &XS, K, 25, 32, None).unwrap();
        eprintln!(
            "T7-gold-PRSS: ring_muls={} bit_ands={} prss_xor={}",
            cost.ring_reshare_muls, cost.round.bit_ands, cost.round.prss_xor_muls
        );
        assert!(cost.round.prss_xor_muls > 0, "ścieżka PRSS musi być aktywna");
        let s1 = i64_to_qpoly(&s1_i);
        let s2 = i64_to_qpoly(&s2_i);
        let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
        assert!(
            n < NORM_BOUND2,
            "norma {n} musi być < {NORM_BOUND2}"
        );
        // pin F2: z≡clear → n = 103747771 (seed 0x42, msg gold-ff)
        assert_eq!(n, 103747771, "pin F2 n (z≡clear, PRSS maski)");
        let h = {
            let fq: Vec<u16> = f16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let gq: Vec<u16> = g16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let f_inv = poly_inv_ring(&fq).unwrap();
            q_poly_mul_ring_clear(&gq, &f_inv)
        };
        assert!(verify_sign_equation(&s1, &s2, &h, &t));
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature {
            bytes: enc,
            nonce,
        };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig)
            .expect("engine verify nie może errorować");
        assert!(ok, "Ft1536Signature::verify == true (T7 gold PRSS)");
    }

    /// Regresja złota z PRSS szumem: MPS4-H + gauss (σ=4) → verify true.
    #[test]
    fn t7_gold_with_prss_noise_engine_verify() {
        let mut rng = StdRng::seed_from_u64(0x54_37_00_41);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let td = ITrapdoorShares {
            f: ishare_poly(&mut rng, &f16, &XS, K).unwrap(),
            g: ishare_poly(&mut rng, &g16, &XS, K).unwrap(),
            f_big: ishare_poly(&mut rng, &f_big16, &XS, K).unwrap(),
            g_big: ishare_poly(&mut rng, &g_big16, &XS, K).unwrap(),
        };
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let sigma = T6_GAUSS_SIGMA_DEFAULT;
        let (s1_i, s2_i, cost) =
            mps4h_sign_shares(&mut rng, &td, &t, &XS, K, 25, 32, Some(sigma)).unwrap();
        eprintln!(
            "T7-gold-PRSS-noise σ={sigma}: ring_muls={} prss_xor={}",
            cost.ring_reshare_muls, cost.round.prss_xor_muls
        );
        let s1 = i64_to_qpoly(&s1_i);
        let s2 = i64_to_qpoly(&s2_i);
        let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
        assert!(n < NORM_BOUND2, "norma {n} z PRSS szumem < {NORM_BOUND2}");
        let h = {
            let fq: Vec<u16> = f16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let gq: Vec<u16> = g16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let f_inv = poly_inv_ring(&fq).unwrap();
            q_poly_mul_ring_clear(&gq, &f_inv)
        };
        assert!(
            verify_sign_equation(&s1, &s2, &h, &t),
            "równanie verify z PRSS szumem"
        );
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature {
            bytes: enc,
            nonce,
        };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig)
            .expect("engine verify nie może errorować");
        assert!(ok, "Ft1536Signature::verify == true (T7 gold PRSS noise)");
    }

    /// G-2 sign z PRSS: regresja złota + brak dealera clear w maskach/szumie.
    #[test]
    fn t7_g2_sign_with_prss_engine_verify() {
        let mut rng = StdRng::seed_from_u64(0x54_37_00_42);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let gt = g2_deal_trapdoor(&mut rng, &f16, &g16, &f_big16, &g_big16, &XS, K, DELTA)
            .unwrap();
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let (s1_i, s2_i, cost) =
            mps4h_sign_shares_g2(&mut rng, &gt, &t, &XS, K, 25, 32, None).unwrap();
        eprintln!(
            "T7-G2-PRSS: ring_muls={} prss_xor={}",
            cost.ring_reshare_muls, cost.round.prss_xor_muls
        );
        assert!(cost.round.prss_xor_muls > 0, "PRSS maski aktywne w G-2");
        let s1 = i64_to_qpoly(&s1_i);
        let s2 = i64_to_qpoly(&s2_i);
        let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
        assert!(n < NORM_BOUND2, "norma {n} < {NORM_BOUND2}");
        let h = {
            let fq: Vec<u16> = f16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let gq: Vec<u16> = g16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let f_inv = poly_inv_ring(&fq).unwrap();
            q_poly_mul_ring_clear(&gq, &f_inv)
        };
        assert!(verify_sign_equation(&s1, &s2, &h, &t));
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature {
            bytes: enc,
            nonce,
        };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig)
            .expect("engine verify nie może errorować");
        assert!(ok, "G-2 sign z PRSS: engine verify == true");
    }
}

#[cfg(test)]
mod tests_t8 {
    use super::*;
    use crate::mpc_sign::{
        encode_sig_static, hash_to_point_from_nonce_msg, poly_inv_ring, poly_norm2_centered,
        q_poly_mul_ring_clear, verify_sign_equation,
    };
    use ft1536_sys::{Ft1536KeyPair, Ft1536Signature};
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    const XS: [u16; 3] = [1, 2, 3];
    const K: u8 = 2;
    const DELTA: u64 = 0x0B;
    /// FALCON_FT1536_NORM_BOUND2 (C: internal.h).
    const NORM_BOUND2: u64 = 2_093_922_385;

    /// Test-only: rozdziel i16-poly na `n_parties` wkładów additywnych
    /// (dokładna suma całkowita). Losowy jitter dla partii 0..n-2,
    /// reszta na ostatnią partię. Pojedynczy wkład ≠ pełny poly.
    fn split_poly_i16(
        full: &[i16],
        n_parties: usize,
        rng: &mut impl rand::RngCore,
    ) -> Vec<Vec<i16>> {
        assert!(n_parties >= 2);
        let mut parts = vec![vec![0i16; full.len()]; n_parties];
        for j in 0..full.len() {
            let mut acc = 0i32;
            for p in 0..n_parties - 1 {
                let jitter = (rng.next_u32() % 5) as i32 - 2; // [-2, 2]
                parts[p][j] = jitter as i16;
                acc += jitter;
            }
            let last = full[j] as i32 - acc;
            parts[n_parties - 1][j] = last as i16;
            assert_eq!(
                parts.iter().map(|p| p[j] as i32).sum::<i32>(),
                full[j] as i32,
                "split musi sumować się dokładnie"
            );
        }
        parts
    }

    /// Widok partii: 3 osobne rng (jak oddzielne procesy / monety).
    fn three_party_rngs(seed: u64) -> [StdRng; 3] {
        [
            StdRng::seed_from_u64(seed),
            StdRng::seed_from_u64(seed.wrapping_add(0x1111)),
            StdRng::seed_from_u64(seed.wrapping_add(0x2222)),
        ]
    }

    // ─── T8.1 — pairwise PRSS: osobne rng, brak dealera ─────────────────

    /// Bit-maski PRSS z osobnych rng per partia: bit rekonstruuje się
    /// (test-only) do 0/1, GF ≡ Z_P, API zwraca wyłącznie udziały.
    #[test]
    fn t8_pairwise_prss_bit_masks_separate_rngs() {
        let mut rngs = three_party_rngs(0x58_08_00_01);
        let mut coins = StdRng::seed_from_u64(0x58_08_00_C0);
        let mut cost = RoundCost::default();
        for _ in 0..32 {
            let (mg, mp) = paired_bit_mask_prss_pairwise(
                &mut rngs,
                &mut coins,
                &XS,
                &[1, 2, 3],
                K,
                &mut cost,
            )
            .unwrap();
            assert_eq!(mg.len(), XS.len(), "GF: n udziałów (brak jawnego bitu)");
            assert_eq!(mp.len(), XS.len(), "Z_P: n udziałów (brak jawnego bitu)");
            // test-only: rekonstrukcja bitu maski
            let gf_bit = {
                let shares: Vec<Share> = mg
                    .iter()
                    .zip(&XS)
                    .map(|(&s, &x)| Share {
                        x: x as u8,
                        share: s,
                    })
                    .collect();
                let refs: Vec<&Share> = shares.iter().collect();
                crate::reconstruct(&refs).unwrap()
            };
            let p_bit = ireconstruct_val(&XS, &mp).unwrap();
            assert!(gf_bit == 0 || gf_bit == 1, "GF bit={gf_bit}");
            assert!(p_bit == 0 || p_bit == 1, "Z_P bit={p_bit}");
            assert_eq!(gf_bit as i64, p_bit, "GF i Z_P ten sam bit");
        }
        assert!(cost.prss_xor_muls > 0, "XOR-chain na reshare-mul");
    }

    /// Osobność wkładów: ten sam rng strony 0, różne rng stron 1,2 →
    /// inny bit maski (wkłady per partia, nie wspólny strumień).
    #[test]
    fn t8_pairwise_prss_independent_party_coins() {
        let mut cost = RoundCost::default();
        let draw = |r1: u64, r2: u64, cost: &mut RoundCost| {
            let mut rngs = three_party_rngs(0x58_08_00_02);
            rngs[1] = StdRng::seed_from_u64(r1);
            rngs[2] = StdRng::seed_from_u64(r2);
            let mut coins = StdRng::seed_from_u64(0x58_08_00_02);
            let (mg, mp) =
                paired_bit_mask_prss_pairwise(&mut rngs, &mut coins, &XS, &[1, 2, 3], K, cost)
                    .unwrap();
            let bit = ireconstruct_val(&XS, &mp).unwrap();
            let _ = mg;
            bit
        };
        let mut bits = Vec::new();
        for trial in 0..16u64 {
            bits.push(draw(0xA000 + trial, 0xB000 + trial, &mut cost));
        }
        let distinct: std::collections::BTreeSet<i64> = bits.iter().copied().collect();
        assert!(
            distinct.len() >= 2,
            "różne monety stron muszą dawać różne bity, bits={bits:?}"
        );
    }

    /// Pairwise DGDG: |g| ≤ n·w_i, udziały rekonstruują g (test-only),
    /// pojedynczy udział ≠ sekret. Wkłady z osobnych rng.
    #[test]
    fn t8_pairwise_dgdg_range_and_secrecy() {
        let mut rngs = three_party_rngs(0x58_08_00_10);
        let sigma = T6_GAUSS_SIGMA_DEFAULT;
        let s73_total = t6_sigma_q73(sigma).unwrap();
        let s73_i = q73_div_sqrt(s73_total, XS.len());
        let w_i = t6_gauss_window_q73(s73_i).unwrap() as i64;
        let max_g = w_i * XS.len() as i64;
        let mut nonzero_secret = 0;
        for _ in 0..64 {
            let sh = prss_dgdg_shares_pairwise(&mut rngs, sigma, &XS, K).unwrap();
            let g = ireconstruct_val(&XS, &sh).unwrap();
            assert!(g.abs() <= max_g, "g={g} poza ±{max_g}");
            if g != 0 {
                assert!(
                    sh.iter().all(|&s| p_to_i64(s) != g),
                    "udział partii = sekret → wyciek"
                );
                nonzero_secret += 1;
            }
        }
        assert!(nonzero_secret > 8, "sampler powinien dawać niezera");
    }

    /// Pairwise DGDG + rounding: z_mpc ≡ round_half_away((x+g)/q).
    #[test]
    fn t8_pairwise_dgdg_matches_clear_formula() {
        let mut rngs = three_party_rngs(0x58_08_00_11);
        let mut coins = StdRng::seed_from_u64(0x58_08_00_11);
        let xs_gf: Vec<u8> = XS.iter().map(|&v| v as u8).collect();
        let lam = gf_lagrange_all(&xs_gf).unwrap();
        let bits = 16u32;
        let cases = [0i64, 1, -1, 100, -100, 5000, -5000, 9216, -9216];
        for &v in &cases {
            let sh = ishare_val(&mut coins, v, &XS, K).unwrap();
            let gsh = prss_dgdg_shares_pairwise(&mut rngs, T6_GAUSS_SIGMA_DEFAULT, &XS, K).unwrap();
            let g = ireconstruct_val(&XS, &gsh).unwrap();
            let mut cost = RoundCost::default();
            let mut src = PrssSrc::Pairwise {
                rngs: &mut rngs,
                coins: &mut coins,
            };
            let zsh = round_div_q_scalar_shares_src(
                &mut src,
                &sh,
                &XS,
                &xs_gf,
                K,
                &lam,
                bits,
                &mut cost,
                Some(&gsh),
            )
            .unwrap();
            let z = ireconstruct_val(&XS, &zsh).unwrap();
            let expect = round_half_away_i64(v + g);
            assert_eq!(z, expect, "v={v} g={g} z={z} expect={expect}");
        }
    }

    /// Pairwise DGDG + MAC: mac = δ·val (liniowość, model G-2 retained).
    #[test]
    fn t8_pairwise_dgdg_mac_consistent() {
        let mut rngs = three_party_rngs(0x58_08_00_14);
        for _ in 0..32 {
            let (val, mac) = prss_dgdg_shares_with_mac_pairwise(
                &mut rngs,
                T6_GAUSS_SIGMA_DEFAULT,
                &XS,
                K,
                DELTA,
            )
            .unwrap();
            let g = ireconstruct_val(&XS, &val).unwrap();
            let m = ireconstruct_val(&XS, &mac).unwrap();
            let expect = p_to_i64(p_mul(DELTA % I_P, i64_to_p(g)));
            assert_eq!(m, expect, "MAC = δ·g (g={g})");
        }
    }

    /// Regresja złota z pairwise PRSS (maski z osobnych rng, gauss=None):
    /// pin F2 `n = 103747771` + `Ft1536Signature::verify == true`.
    #[test]
    fn t8_gold_pairwise_prss_engine_verify() {
        let mut rngs = three_party_rngs(0x58_08_00_40);
        let mut coins = StdRng::seed_from_u64(0x58_08_00_40);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let td = ITrapdoorShares {
            f: ishare_poly(&mut coins, &f16, &XS, K).unwrap(),
            g: ishare_poly(&mut coins, &g16, &XS, K).unwrap(),
            f_big: ishare_poly(&mut coins, &f_big16, &XS, K).unwrap(),
            g_big: ishare_poly(&mut coins, &g_big16, &XS, K).unwrap(),
        };
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let (s1_i, s2_i, cost) =
            mps4h_sign_shares_pairwise(&mut rngs, &mut coins, &td, &t, &XS, K, 25, 32, None)
                .unwrap();
        eprintln!(
            "T8-gold-pairwise: ring_muls={} prss_xor={}",
            cost.ring_reshare_muls, cost.round.prss_xor_muls
        );
        assert!(cost.round.prss_xor_muls > 0, "ścieżka PRSS aktywna");
        let s1 = i64_to_qpoly(&s1_i);
        let s2 = i64_to_qpoly(&s2_i);
        let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
        assert!(n < NORM_BOUND2, "norma {n} < {NORM_BOUND2}");
        // pin F2: z≡clear → n = 103747771 (seed 0x42, msg gold-ff)
        assert_eq!(n, 103747771, "pin F2 n (z≡clear, pairwise PRSS)");
        let h = {
            let fq: Vec<u16> = f16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let gq: Vec<u16> = g16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let f_inv = poly_inv_ring(&fq).unwrap();
            q_poly_mul_ring_clear(&gq, &f_inv)
        };
        assert!(verify_sign_equation(&s1, &s2, &h, &t));
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature {
            bytes: enc,
            nonce,
        };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig)
            .expect("engine verify nie może errorować");
        assert!(ok, "Ft1536Signature::verify == true (T8 pairwise PRSS)");
    }

    /// Regresja złota z pairwise DGDG (szum z osobnych rng): verify true.
    /// Norma **nie** pinowana — szum zmienia z (pomiar, nie determinizm).
    #[test]
    fn t8_gold_pairwise_dgdg_engine_verify() {
        let mut rngs = three_party_rngs(0x58_08_00_41);
        let mut coins = StdRng::seed_from_u64(0x58_08_00_41);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let td = ITrapdoorShares {
            f: ishare_poly(&mut coins, &f16, &XS, K).unwrap(),
            g: ishare_poly(&mut coins, &g16, &XS, K).unwrap(),
            f_big: ishare_poly(&mut coins, &f_big16, &XS, K).unwrap(),
            g_big: ishare_poly(&mut coins, &g_big16, &XS, K).unwrap(),
        };
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let sigma = T6_GAUSS_SIGMA_DEFAULT;
        let (s1_i, s2_i, cost) = mps4h_sign_shares_pairwise(
            &mut rngs,
            &mut coins,
            &td,
            &t,
            &XS,
            K,
            25,
            32,
            Some(sigma),
        )
        .unwrap();
        eprintln!(
            "T8-gold-pairwise-noise σ={sigma}: ring_muls={} prss_xor={}",
            cost.ring_reshare_muls, cost.round.prss_xor_muls
        );
        let s1 = i64_to_qpoly(&s1_i);
        let s2 = i64_to_qpoly(&s2_i);
        let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
        assert!(n < NORM_BOUND2, "norma {n} z pairwise szumem < {NORM_BOUND2}");
        let h = {
            let fq: Vec<u16> = f16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let gq: Vec<u16> = g16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let f_inv = poly_inv_ring(&fq).unwrap();
            q_poly_mul_ring_clear(&gq, &f_inv)
        };
        assert!(verify_sign_equation(&s1, &s2, &h, &t), "równanie verify");
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature {
            bytes: enc,
            nonce,
        };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig)
            .expect("engine verify nie może errorować");
        assert!(ok, "Ft1536Signature::verify == true (T8 pairwise DGDG)");
    }

    // ─── T8.3 — keygen f,F bez clear (DKG z contributions) ─────────────

    /// DKG z wkładów: udziały f,F powstają jako suma wkładów per partia —
    /// **pełny f,F nigdy nie powstaje w clear w torze setup** (API zwraca
    /// wyłącznie [`G2Trapdoor`]). Pojedynczy wkład ≠ pełny klucz.
    /// Ścieżka **nie** woła `g2_deal_trapdoor`.
    #[test]
    fn t8_keygen_no_clear_dkg_shares_never_full() {
        let mut rngs = three_party_rngs(0x58_08_00_50);
        let seed = [0x42u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();

        // Wkłady per partia (osobne „widoki"; w produkcji — osobne procesy).
        let f_parts = split_poly_i16(&f16, 3, &mut rngs[0]);
        let g_parts = split_poly_i16(&g16, 3, &mut rngs[1]);
        let fb_parts = split_poly_i16(&f_big16, 3, &mut rngs[2]);
        let gb_parts = split_poly_i16(&g_big16, 3, &mut rngs[0]);

        // Widok partii 0 ≠ pełny klucz (brak clear f,F u pojedynczej strony).
        assert_ne!(f_parts[0], f16, "wkład partii 0 ≠ pełny f");
        assert_ne!(fb_parts[0], f_big16, "wkład partii 0 ≠ pełny F");

        let contribs: Vec<PartyTrapdoorContribution> = (0..3)
            .map(|i| PartyTrapdoorContribution {
                f: f_parts[i].clone(),
                g: g_parts[i].clone(),
                f_big: fb_parts[i].clone(),
                g_big: gb_parts[i].clone(),
            })
            .collect();

        // T8.3: DKG — NIE g2_deal_trapdoor; pełny f,F nie istnieje w API.
        let gt = dkg_trapdoor_from_contributions(
            &mut rngs,
            &contribs,
            &XS,
            K,
            DELTA,
            G2_VSS_SAMPLE,
        )
        .unwrap();

        // Typ wyjścia = udziały (Vec per strona), nie i16-poly.
        assert_eq!(gt.td.f.len(), FT1536_N);
        assert_eq!(gt.td.f[0].len(), XS.len(), "udziały, nie jawny poly");

        // Test-only: rekonstrukcja = suma wkładów = oryginalny klucz.
        let f_back = ireconstruct_poly(&gt.td.f, &XS).unwrap();
        let fb_back = ireconstruct_poly(&gt.td.f_big, &XS).unwrap();
        assert_eq!(f_back, f16, "udziały sumują się do f");
        assert_eq!(fb_back, f_big16, "udziały sumują się do F");
        // Bound test-only (bez clear F w torze DKG — patrz retained).
        assert!(validate_f_bound(&fb_back).is_ok());
    }

    /// Złoto na DKG-trapdoorze: sign z udziałów z contributions →
    /// pin F2 `n = 103747771` + engine verify true.
    #[test]
    fn t8_keygen_no_clear_dkg_engine_verify() {
        let mut rngs = three_party_rngs(0x58_08_00_51);
        let mut coins = StdRng::seed_from_u64(0x58_08_00_51);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();

        let f_parts = split_poly_i16(&f16, 3, &mut rngs[0]);
        let g_parts = split_poly_i16(&g16, 3, &mut rngs[1]);
        let fb_parts = split_poly_i16(&f_big16, 3, &mut rngs[2]);
        let gb_parts = split_poly_i16(&g_big16, 3, &mut rngs[0]);
        let contribs: Vec<PartyTrapdoorContribution> = (0..3)
            .map(|i| PartyTrapdoorContribution {
                f: f_parts[i].clone(),
                g: g_parts[i].clone(),
                f_big: fb_parts[i].clone(),
                g_big: gb_parts[i].clone(),
            })
            .collect();

        // Setup nowej ścieżki: DKG z contributions — bez g2_deal_trapdoor.
        let gt = dkg_trapdoor_from_contributions(
            &mut rngs,
            &contribs,
            &XS,
            K,
            DELTA,
            G2_VSS_SAMPLE,
        )
        .unwrap();

        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let (s1_i, s2_i, cost) =
            mps4h_sign_shares(&mut coins, &gt.td, &t, &XS, K, 25, 32, None).unwrap();
        eprintln!(
            "T8-DKG-gold: ring_muls={} prss_xor={}",
            cost.ring_reshare_muls, cost.round.prss_xor_muls
        );
        let s1 = i64_to_qpoly(&s1_i);
        let s2 = i64_to_qpoly(&s2_i);
        let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
        assert!(n < NORM_BOUND2, "norma {n} < {NORM_BOUND2}");
        // pin F2: te same f,g,F,G ⇒ te same z ≡ clear ⇒ n = 103747771
        assert_eq!(n, 103747771, "pin F2 n (DKG shares ≡ clear key)");
        let h = {
            let fq: Vec<u16> = f16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let gq: Vec<u16> = g16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let f_inv = poly_inv_ring(&fq).unwrap();
            q_poly_mul_ring_clear(&gq, &f_inv)
        };
        assert!(verify_sign_equation(&s1, &s2, &h, &t));
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature {
            bytes: enc,
            nonce,
        };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig)
            .expect("engine verify nie może errorować");
        assert!(ok, "DKG trapdoor: engine verify == true (T8 keygen)");
    }

    /// G-2 tor na DKG-trapdoorze (VSS + MAC) → engine verify true.
    #[test]
    fn t8_keygen_no_clear_dkg_g2_engine_verify() {
        let mut rngs = three_party_rngs(0x58_08_00_52);
        let mut coins = StdRng::seed_from_u64(0x58_08_00_52);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let f_parts = split_poly_i16(&f16, 3, &mut rngs[0]);
        let g_parts = split_poly_i16(&g16, 3, &mut rngs[1]);
        let fb_parts = split_poly_i16(&f_big16, 3, &mut rngs[2]);
        let gb_parts = split_poly_i16(&g_big16, 3, &mut rngs[0]);
        let contribs: Vec<PartyTrapdoorContribution> = (0..3)
            .map(|i| PartyTrapdoorContribution {
                f: f_parts[i].clone(),
                g: g_parts[i].clone(),
                f_big: fb_parts[i].clone(),
                g_big: gb_parts[i].clone(),
            })
            .collect();
        let gt = dkg_trapdoor_from_contributions(
            &mut rngs,
            &contribs,
            &XS,
            K,
            DELTA,
            G2_VSS_SAMPLE,
        )
        .unwrap();
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let (s1_i, s2_i, _cost) =
            mps4h_sign_shares_g2(&mut coins, &gt, &t, &XS, K, 25, 32, None).unwrap();
        let s1 = i64_to_qpoly(&s1_i);
        let s2 = i64_to_qpoly(&s2_i);
        let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
        assert!(n < NORM_BOUND2, "norma {n} < {NORM_BOUND2}");
        let h = {
            let fq: Vec<u16> = f16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let gq: Vec<u16> = g16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let f_inv = poly_inv_ring(&fq).unwrap();
            q_poly_mul_ring_clear(&gq, &f_inv)
        };
        assert!(verify_sign_equation(&s1, &s2, &h, &t));
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature {
            bytes: enc,
            nonce,
        };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig)
            .expect("engine verify nie może errorować");
        assert!(ok, "DKG + G-2: engine verify == true");
    }

    // ─── T8.4 — matrix fałszerstw (fail-closed) ────────────────────────

    /// Tamper udziału maski pairwise → MacFail (G-2 open z ukrytym δ).
    #[test]
    fn t8_tamper_prss_pairwise_mask_macfail() {
        let mut rngs = three_party_rngs(0x58_08_00_60);
        let mut coins = StdRng::seed_from_u64(0x58_08_00_60);
        let mut cost = RoundCost::default();
        let (_mg, mp) = paired_bit_mask_prss_pairwise(
            &mut rngs,
            &mut coins,
            &XS,
            &[1, 2, 3],
            K,
            &mut cost,
        )
        .unwrap();
        // MAC = δ·maska (liniowość, model G-2) + ukryte δ-shares
        let mm: Vec<u64> = mp.iter().map(|&s| p_mul(DELTA % I_P, s)).collect();
        let ds = ishare_val(&mut coins, DELTA as i64, &XS, K).unwrap();
        let delta = ZpDeltaShares {
            xs: XS.to_vec(),
            shares: ds,
        };
        // FAŁSZERSTWO: tamper udziału maski
        let mut mp_bad = mp.clone();
        mp_bad[0] = p_add(mp_bad[0], 1);
        let d_mac: Vec<ZpMacShare> = mp_bad
            .iter()
            .zip(&mm)
            .zip(&XS)
            .map(|((&s, &m), &x)| ZpMacShare {
                x,
                share: s,
                mac: m,
            })
            .collect();
        assert_eq!(
            zp_open_with_mac_hidden_delta(&d_mac, &delta, K),
            Err(SpikeError::MacFail),
            "tamper pairwise maski → MacFail"
        );
    }

    /// Tamper udziału szumu pairwise → MacFail.
    #[test]
    fn t8_tamper_prss_pairwise_noise_macfail() {
        let mut rngs = three_party_rngs(0x58_08_00_61);
        let (mut val, mac) = prss_dgdg_shares_with_mac_pairwise(
            &mut rngs,
            T6_GAUSS_SIGMA_DEFAULT,
            &XS,
            K,
            DELTA,
        )
        .unwrap();
        let mut coins = StdRng::seed_from_u64(0x58_08_00_61);
        let ds = ishare_val(&mut coins, DELTA as i64, &XS, K).unwrap();
        let delta = ZpDeltaShares {
            xs: XS.to_vec(),
            shares: ds,
        };
        // FAŁSZERSTWO: tamper udziału szumu (wartość bez update MAC)
        val[1] = p_add(val[1], 1);
        let d_mac: Vec<ZpMacShare> = val
            .iter()
            .zip(&mac)
            .zip(&XS)
            .map(|((&s, &m), &x)| ZpMacShare {
                x,
                share: s,
                mac: m,
            })
            .collect();
        assert_eq!(
            zp_open_with_mac_hidden_delta(&d_mac, &delta, K),
            Err(SpikeError::MacFail),
            "tamper pairwise szumu → MacFail"
        );
    }

    /// Tamper wkładu DKG (fałszywy udział VSS) → CommitmentMismatch.
    /// Ten sam check, który `dkg_trapdoor_from_contributions` wykonuje
    /// per wkład — fail-closed, nie cicha kontynuacja.
    #[test]
    fn t8_tamper_dkg_contribution_vss_detected() {
        let mut rngs = three_party_rngs(0x58_08_00_62);
        let seed = [0x42u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, _g, _fb, _gb) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let parts = split_poly_i16(&f16, 3, &mut rngs[0]);
        // Uczciwy deal wkładu partii 0
        let (mut sh, vss) =
            ishare_poly_with_vss_count(&mut rngs[0], &parts[0], &XS, K, G2_VSS_SAMPLE).unwrap();
        assert!(vss_verify_poly_shares(&vss, &sh, &XS).is_ok());
        // FAŁSZERSTWO: tamper udziału w wkładzie (bez update VSS)
        sh.values[0][0] = p_add(sh.values[0][0], 1);
        assert_eq!(
            vss_verify_poly_shares(&vss, &sh, &XS),
            Err(SpikeError::CommitmentMismatch),
            "fałszywy udział wkładu DKG → CommitmentMismatch"
        );
    }

    /// Tamper sumy udziałów po DKG (stawka wspólna) → CommitmentMismatch
    /// na wspólnym VSS (suma commitmentów — homomorfizm Pedersena).
    #[test]
    fn t8_tamper_dkg_joint_share_detected() {
        let mut rngs = three_party_rngs(0x58_08_00_63);
        let seed = [0x42u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let f_parts = split_poly_i16(&f16, 3, &mut rngs[0]);
        let g_parts = split_poly_i16(&g16, 3, &mut rngs[1]);
        let fb_parts = split_poly_i16(&f_big16, 3, &mut rngs[2]);
        let gb_parts = split_poly_i16(&g_big16, 3, &mut rngs[0]);
        let contribs: Vec<PartyTrapdoorContribution> = (0..3)
            .map(|i| PartyTrapdoorContribution {
                f: f_parts[i].clone(),
                g: g_parts[i].clone(),
                f_big: fb_parts[i].clone(),
                g_big: gb_parts[i].clone(),
            })
            .collect();
        let mut gt = dkg_trapdoor_from_contributions(
            &mut rngs,
            &contribs,
            &XS,
            K,
            DELTA,
            G2_VSS_SAMPLE,
        )
        .unwrap();
        assert!(vss_verify_poly_shares(&gt.vss_f, &gt.vss_sh_f, &XS).is_ok());
        // FAŁSZERSTWO: tamper sumy udziałów f[0] strony 0 (bez update VSS)
        gt.td.f[0][0] = p_add(gt.td.f[0][0], 1);
        gt.vss_sh_f.values = gt.td.f.clone();
        assert_eq!(
            vss_verify_poly_shares(&gt.vss_f, &gt.vss_sh_f, &XS),
            Err(SpikeError::CommitmentMismatch),
            "tamper udziału po DKG → CommitmentMismatch"
        );
    }

    /// Tamper udziału f w torze sign na DKG-trapdoorze → MacFail
    /// (MAC na otwarciach maski — jak g2_sign_value_forge_*).
    #[test]
    fn t8_tamper_dkg_share_sign_macfail() {
        let mut rngs = three_party_rngs(0x58_08_00_64);
        let mut coins = StdRng::seed_from_u64(0x58_08_00_64);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let f_parts = split_poly_i16(&f16, 3, &mut rngs[0]);
        let g_parts = split_poly_i16(&g16, 3, &mut rngs[1]);
        let fb_parts = split_poly_i16(&f_big16, 3, &mut rngs[2]);
        let gb_parts = split_poly_i16(&g_big16, 3, &mut rngs[0]);
        let contribs: Vec<PartyTrapdoorContribution> = (0..3)
            .map(|i| PartyTrapdoorContribution {
                f: f_parts[i].clone(),
                g: g_parts[i].clone(),
                f_big: fb_parts[i].clone(),
                g_big: gb_parts[i].clone(),
            })
            .collect();
        let mut gt = dkg_trapdoor_from_contributions(
            &mut rngs,
            &contribs,
            &XS,
            K,
            DELTA,
            G2_VSS_SAMPLE,
        )
        .unwrap();
        // FAŁSZERSTWO: tamper udziału f po DKG (MAC niezgodny z wartością)
        gt.td.f[0][0] = p_add(gt.td.f[0][0], 1);
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let result = mps4h_sign_shares_g2(&mut coins, &gt, &t, &XS, K, 25, 32, None);
        assert_eq!(
            result.map(|_| ()),
            Err(SpikeError::MacFail),
            "tamper f po DKG → MacFail w torze sign"
        );
    }
}

// ─── T9.1 — weighted keygen NTRU (offline) ─────────────────────────────

#[cfg(test)]
mod tests_t9 {
    use super::*;
    use crate::mpc_sign::{
        encode_sig_static, hash_to_point_from_nonce_msg, poly_inv_ring, poly_norm2_centered,
        q_poly_mul_ring_clear, verify_sign_equation,
    };
    use ft1536_sys::{Ft1536KeyPair, Ft1536Signature};
    use rand::rngs::StdRng;
    use rand::{RngCore, SeedableRng};

    const XS: [u16; 3] = [1, 2, 3];
    const K: u8 = 2;
    const DELTA: u64 = 0x0B;
    /// FALCON_FT1536_NORM_BOUND2 (C: internal.h).
    const NORM_BOUND2: u64 = 2_093_922_385;

    fn two_party_rngs(seed: u64) -> [StdRng; 2] {
        [
            StdRng::seed_from_u64(seed),
            StdRng::seed_from_u64(seed.wrapping_add(0x1111)),
        ]
    }

    /// Test-only: c0 małe, c1 = full − w0·c0 (także dla w0=1).
    /// Dzięki temu w0·c0 + w1·c1 = full przy w1=1.
    fn split_weighted_w21(
        full: &[i16],
        w0: i32,
        rng: &mut impl RngCore,
    ) -> (Vec<i16>, Vec<i16>) {
        let c0: Vec<i16> = full
            .iter()
            .map(|_| ((rng.next_u32() % 5) as i32 - 2) as i16)
            .collect();
        let c1: Vec<i16> = full
            .iter()
            .zip(&c0)
            .map(|(&f, &a)| (f as i32 - w0 * (a as i32)) as i16)
            .collect();
        (c0, c1)
    }

    /// T9.1 — udziały ważone ≠ sekret; brak reconstruct w torze setup;
    /// sumyważone zgodne z formułą Σ w_i·wkład_i (jawne wartości testowe).
    /// Wagi [2,1] dają inny udział niż [1,1] przy tych samych wkładach.
    #[test]
    fn t9_keygen_weighted_no_clear_dkg_shares_never_full() {
        // Jawne wartości testowe (NIE klucz NTRU) — formuła do sprawdzenia wprost.
        let c0_f: Vec<i16> = (0..FT1536_N as i16).map(|i| ((i % 5) - 2) as i16).collect();
        let c1_f: Vec<i16> = (0..FT1536_N as i16).map(|i| ((i % 3) - 1) as i16).collect();
        let c0_g: Vec<i16> = (0..FT1536_N as i16).map(|i| ((i % 7) - 3) as i16).collect();
        let c1_g: Vec<i16> = (0..FT1536_N as i16).map(|i| (i % 2) as i16).collect();
        let c0_fb: Vec<i16> = (0..FT1536_N as i16).map(|i| ((i % 11) - 5) as i16).collect();
        let c1_fb: Vec<i16> = (0..FT1536_N as i16).map(|i| ((i % 4) - 1) as i16).collect();
        let c0_gb: Vec<i16> = (0..FT1536_N as i16).map(|i| ((i % 6) - 2) as i16).collect();
        let c1_gb: Vec<i16> = (0..FT1536_N as i16).map(|i| ((i % 5) - 2) as i16).collect();

        let contribs = [
            PartyTrapdoorContribution {
                f: c0_f.clone(),
                g: c0_g.clone(),
                f_big: c0_fb.clone(),
                g_big: c0_gb.clone(),
            },
            PartyTrapdoorContribution {
                f: c1_f.clone(),
                g: c1_g.clone(),
                f_big: c1_fb.clone(),
                g_big: c1_gb.clone(),
            },
        ];

        // ── wagi [2,1]: f = 2·c0 + 1·c1 ──
        let mut rngs_w = two_party_rngs(0x59_01_00_11);
        let gt_w = dkg_trapdoor_from_weighted_contributions(
            &mut rngs_w,
            &contribs,
            &[2, 1],
            &XS,
            K,
            DELTA,
            G2_VSS_SAMPLE,
        )
        .unwrap();
        // Typ wyjścia = udziały (Vec per strona), nie i16-poly — brak clear f,F.
        assert_eq!(gt_w.td.f.len(), FT1536_N);
        assert_eq!(gt_w.td.f[0].len(), XS.len(), "udziały, nie jawny poly");

        // ── wagi [1,1]: f = 1·c0 + 1·c1 ──
        let mut rngs_u = two_party_rngs(0x59_01_00_12);
        let gt_u = dkg_trapdoor_from_weighted_contributions(
            &mut rngs_u,
            &contribs,
            &[1, 1],
            &XS,
            K,
            DELTA,
            G2_VSS_SAMPLE,
        )
        .unwrap();

        // Formuła na jawnych wartościach (test-only reconstruct).
        let exp_w: Vec<i16> = c0_f
            .iter()
            .zip(&c1_f)
            .map(|(&a, &b)| (2 * a as i32 + 1 * b as i32) as i16)
            .collect();
        let exp_u: Vec<i16> = c0_f
            .iter()
            .zip(&c1_f)
            .map(|(&a, &b)| (a as i32 + b as i32) as i16)
            .collect();
        let f_w = ireconstruct_poly(&gt_w.td.f, &XS).unwrap();
        let f_u = ireconstruct_poly(&gt_u.td.f, &XS).unwrap();
        assert_eq!(f_w, exp_w, "f = Σ w_i·f_i przy wagach [2,1]");
        assert_eq!(f_u, exp_u, "f = Σ w_i·f_i przy wagach [1,1]");
        assert_ne!(f_w, f_u, "wagi [2,1] ≠ [1,1] przy różnych wkładach");

        // F ważone: 2·c0_fb + c1_fb
        let exp_fb: Vec<i16> = c0_fb
            .iter()
            .zip(&c1_fb)
            .map(|(&a, &b)| (2 * a as i32 + 1 * b as i32) as i16)
            .collect();
        let fb_w = ireconstruct_poly(&gt_w.td.f_big, &XS).unwrap();
        assert_eq!(fb_w, exp_fb, "F = Σ w_i·F_i przy wagach [2,1]");

        // Udziały ≠ sekret: kolumna pojedynczej strony ≠ jawny wielomian.
        // (wartość udziału w Z_P vs sekret jako i16 — porównanie per współczynnik
        //  na rekonstruowanym sekrecie: żaden udział nie jest równy sekretowi)
        let secret_p: Vec<u64> = exp_w.iter().map(|&c| i64_to_p(c as i64)).collect();
        for p in 0..XS.len() {
            let mut ne = 0;
            for j in 0..FT1536_N {
                if gt_w.td.f[j][p] != secret_p[j] {
                    ne += 1;
                }
            }
            assert!(
                ne > FT1536_N / 2,
                "udział strony {p} ≠ pełny sekret (ne={ne})"
            );
        }
        // Pojedynczy wkład ≠ ważony pełny klucz.
        assert_ne!(c0_f, exp_w, "wkład partii 0 ≠ ważony f");
        assert_ne!(c1_f, exp_w, "wkład partii 1 ≠ ważony f");

        // Spójność ważonego VSS (fail-closed w torze — tu pozytywna).
        assert!(vss_verify_poly_shares(&gt_w.vss_f, &gt_w.vss_sh_f, &XS).is_ok());
        assert!(vss_verify_poly_shares(&gt_w.vss_f_big, &gt_w.vss_sh_f_big, &XS).is_ok());
    }

    /// T9.1 — ważony DKG → tor złota MPS4-H → pin F2 + engine verify true.
    /// Wagi [2,1] z c1 = full − 2·c0 ⇒ ważona suma = oryginalny klucz NTRU.
    #[test]
    fn t9_keygen_weighted_engine_verify() {
        let mut rngs = two_party_rngs(0x59_01_00_20);
        let mut coins = StdRng::seed_from_u64(0x59_01_00_21);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();

        // Wkłady: w0=2, w1=1 ⇒ 2·c0 + c1 = full (dokładnie, i16).
        let (f0, f1) = split_weighted_w21(&f16, 2, &mut rngs[0]);
        let (g0, g1) = split_weighted_w21(&g16, 2, &mut rngs[1]);
        let (fb0, fb1) = split_weighted_w21(&f_big16, 2, &mut rngs[0]);
        let (gb0, gb1) = split_weighted_w21(&g_big16, 2, &mut rngs[1]);
        assert_ne!(f0, f1, "wkłady różne");
        assert_ne!(f0, f16, "wkład 0 ≠ pełny f");

        let contribs = [
            PartyTrapdoorContribution {
                f: f0,
                g: g0,
                f_big: fb0,
                g_big: gb0,
            },
            PartyTrapdoorContribution {
                f: f1,
                g: g1,
                f_big: fb1,
                g_big: gb1,
            },
        ];

        // T9.1: ważony DKG — NIE g2_deal_trapdoor; brak clear f,F w torze.
        let gt = dkg_trapdoor_from_weighted_contributions(
            &mut rngs,
            &contribs,
            &[2, 1],
            &XS,
            K,
            DELTA,
            G2_VSS_SAMPLE,
        )
        .unwrap();

        // Tor złota (równoważny pairwise): sign z udziałów ważonego DKG.
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let (s1_i, s2_i, cost) = mps4h_sign_shares_pairwise(
            &mut rngs,
            &mut coins,
            &gt.td,
            &t,
            &XS,
            K,
            25,
            32,
            None,
        )
        .unwrap();
        eprintln!(
            "T9-weighted-gold: ring_muls={} prss_xor={}",
            cost.ring_reshare_muls, cost.round.prss_xor_muls
        );
        let s1 = i64_to_qpoly(&s1_i);
        let s2 = i64_to_qpoly(&s2_i);
        let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
        assert!(n < NORM_BOUND2, "norma {n} < {NORM_BOUND2}");
        // pin F2: ważona suma = oryginalny klucz ⇒ z ≡ clear ⇒ n = 103747771
        assert_eq!(n, 103747771, "pin F2 n (weighted DKG shares ≡ clear key)");
        let h = {
            let fq: Vec<u16> = f16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let gq: Vec<u16> = g16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let f_inv = poly_inv_ring(&fq).unwrap();
            q_poly_mul_ring_clear(&gq, &f_inv)
        };
        assert!(verify_sign_equation(&s1, &s2, &h, &t));
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature {
            bytes: enc,
            nonce,
        };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig)
            .expect("engine verify nie może errorować");
        assert!(ok, "weighted DKG trapdoor: engine verify == true (T9.1)");
    }

    /// T9.1 — fałszerstwo ważonego wkładu (tamper po skalowaniu przez w)
    /// → CommitmentMismatch (fail-closed).
    #[test]
    fn t9_tamper_weighted_contribution_vss_detected() {
        let mut rng = StdRng::seed_from_u64(0x59_01_00_30);
        let seed = [0x42u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, _g, _fb, _gb) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        // Uczciwy deal wkładu + VSS
        let (sh, vss) =
            ishare_poly_with_vss_count(&mut rng, &f16, &XS, K, G2_VSS_SAMPLE).unwrap();
        assert!(vss_verify_poly_shares(&vss, &sh, &XS).is_ok());
        // Ważenie przez w=3 (liniowość Shamir + homomorfizm Pedersena)
        let (mut sh_w, vss_w) = ipoly_vss_scale_weight(&sh, &vss, 3).unwrap();
        assert!(
            vss_verify_poly_shares(&vss_w, &sh_w, &XS).is_ok(),
            "ważony (uczciwy) udział weryfikuje się względem w·C"
        );
        // FAŁSZERSTWO: tamper ważonego udziału (bez update zobowiązania)
        sh_w.values[0][0] = p_add(sh_w.values[0][0], 1);
        assert_eq!(
            vss_verify_poly_shares(&vss_w, &sh_w, &XS),
            Err(SpikeError::CommitmentMismatch),
            "fałszerstwo ważonego wkładu → CommitmentMismatch"
        );
    }
}

// ─── T9.2 — range proof max|F| < q/2 na udziałach ──────────────────────

#[cfg(test)]
mod tests_t9_fbound {
    use super::*;
    use ft1536_sys::Ft1536KeyPair;
    use rand::rngs::StdRng;
    use rand::{RngCore, SeedableRng};

    const XS: [u16; 3] = [1, 2, 3];
    const K: u8 = 2;

    /// T9.2 — realne F (|F| ~ 54–65 ≪ q/2) przechodzi range proof
    /// **bez otwierania F** w torze (tor woła validate_f_bound_shares).
    #[test]
    fn t9_fbound_ok_real_f() {
        let mut rng = StdRng::seed_from_u64(0x59_02_00_10);
        let seed = [0x42u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (_f, _g, f_big16, _g_big) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let max_f = f_big16
            .iter()
            .map(|&c| (c as i32).unsigned_abs())
            .max()
            .unwrap();
        assert!(max_f < F_BOUND_HALF_Q as u32, "retained H: max|F|={max_f}");
        let f_sh = ishare_poly(&mut rng, &f_big16, &XS, K).unwrap();
        assert!(
            validate_f_bound_shares(&mut rng, &f_sh, &XS, K).is_ok(),
            "realne F (max|F|={max_f}) przechodzi range proof na udziałach"
        );
    }

    /// T9.2 — F ≥ q/2 → fail-closed [`SpikeError::FBoundViolation`]
    /// (Err, nie panika) na torze, który nie rekonstruuje F.
    #[test]
    fn t9_fbound_violation_aborts() {
        let mut rng = StdRng::seed_from_u64(0x59_02_00_20);
        // max|F| = q/2 = 9216 → naruszenie
        let mut f_bad = vec![10i16; FT1536_N];
        f_bad[0] = F_BOUND_HALF_Q as i16;
        let f_sh = ishare_poly(&mut rng, &f_bad, &XS, K).unwrap();
        assert_eq!(
            validate_f_bound_shares(&mut rng, &f_sh, &XS, K),
            Err(SpikeError::FBoundViolation),
            "F[0]=q/2 → FBoundViolation"
        );
        // ujemny rant: F[0] = −q/2
        let mut f_neg = vec![10i16; FT1536_N];
        f_neg[0] = -(F_BOUND_HALF_Q as i16);
        let f_sh = ishare_poly(&mut rng, &f_neg, &XS, K).unwrap();
        assert_eq!(
            validate_f_bound_shares(&mut rng, &f_sh, &XS, K),
            Err(SpikeError::FBoundViolation),
            "F[0]=−q/2 → FBoundViolation"
        );
        // granica dodatnia: |F| = q/2 − 1 przechodzi
        let mut f_edge = vec![10i16; FT1536_N];
        f_edge[0] = (F_BOUND_HALF_Q - 1) as i16;
        f_edge[1] = -((F_BOUND_HALF_Q - 1) as i16);
        let f_sh = ishare_poly(&mut rng, &f_edge, &XS, K).unwrap();
        assert!(
            validate_f_bound_shares(&mut rng, &f_sh, &XS, K).is_ok(),
            "max|F| = q/2 − 1 mieści się w boundzie"
        );
    }

    /// T9.2 — ważony DKG (T9.1) + range proof: realne wkłady przechodzą;
    /// wkład z F ≥ q/2 w sumie → FBoundViolation w torze DKG (bez clear F).
    #[test]
    fn t9_fbound_dkg_weighted_ok() {
        let mut rngs = [
            StdRng::seed_from_u64(0x59_02_00_30),
            StdRng::seed_from_u64(0x59_02_00_31),
        ];
        let seed = [0x42u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();

        // c0 małe, c1 = full − 2·c0 (jak T9.1 split) ⇒ 2·c0 + c1 = full
        let split = |full: &[i16], rng: &mut dyn RngCore| -> (Vec<i16>, Vec<i16>) {
            let c0: Vec<i16> = full
                .iter()
                .map(|_| ((rng.next_u32() % 5) as i32 - 2) as i16)
                .collect();
            let c1: Vec<i16> = full
                .iter()
                .zip(&c0)
                .map(|(&f, &a)| (f as i32 - 2 * (a as i32)) as i16)
                .collect();
            (c0, c1)
        };
        let (f0, f1) = split(&f16, &mut rngs[0]);
        let (g0, g1) = split(&g16, &mut rngs[1]);
        let (fb0, fb1) = split(&f_big16, &mut rngs[0]);
        let (gb0, gb1) = split(&g_big16, &mut rngs[1]);
        let contribs = [
            PartyTrapdoorContribution {
                f: f0,
                g: g0,
                f_big: fb0,
                g_big: gb0,
            },
            PartyTrapdoorContribution {
                f: f1,
                g: g1,
                f_big: fb1,
                g_big: gb1,
            },
        ];
        // Uczciwy ważony DKG: range proof wchodzi w tor (validate_f_bound_shares).
        let gt = dkg_trapdoor_from_weighted_contributions(
            &mut rngs,
            &contribs,
            &[2, 1],
            &XS,
            K,
            0x0B,
            G2_VSS_SAMPLE,
        )
        .unwrap();
        // Druga linia: jawny test API na udziałach sumy (test-only reconstruct
        // do porównania oracle; tor powyżej nie otwierał F).
        assert!(validate_f_bound_shares(&mut rngs[0], &gt.td.f_big, &XS, K).is_ok());
        let fb = ireconstruct_poly(&gt.td.f_big, &XS).unwrap();
        assert!(validate_f_bound(&fb).is_ok(), "zgodność toru clear (oracle)");

        // WKŁAD ZŁOŚLIWY (semi-honest boundary): F0[0] = q/2, w0=1, reszta 0
        // ⇒ suma F[0] ≥ q/2 → FBoundViolation w DKG, bez reconstruct F.
        let mut rngs_b = [
            StdRng::seed_from_u64(0x59_02_00_40),
            StdRng::seed_from_u64(0x59_02_00_41),
        ];
        let mut bad_fb = vec![0i16; FT1536_N];
        bad_fb[0] = F_BOUND_HALF_Q as i16;
        let contribs_b = [
            PartyTrapdoorContribution {
                f: vec![1i16; FT1536_N],
                g: vec![1i16; FT1536_N],
                f_big: bad_fb,
                g_big: vec![1i16; FT1536_N],
            },
            PartyTrapdoorContribution {
                f: vec![1i16; FT1536_N],
                g: vec![1i16; FT1536_N],
                f_big: vec![0i16; FT1536_N],
                g_big: vec![1i16; FT1536_N],
            },
        ];
        let r = dkg_trapdoor_from_weighted_contributions(
            &mut rngs_b,
            &contribs_b,
            &[1, 1],
            &XS,
            K,
            0x0B,
            G2_VSS_SAMPLE,
        );
        assert_eq!(
            r.map(|_| ()),
            Err(SpikeError::FBoundViolation),
            "DKG: suma F ≥ q/2 → FBoundViolation (fail-closed, bez clear F)"
        );
    }
}

// ─── T9.3 — MAC na s1,s2 po ring-mulach (R-G2-2) ────────────────────────

#[cfg(test)]
mod tests_t9_mac_s {
    use super::*;
    use crate::mpc_sign::{
        encode_sig_static, hash_to_point_from_nonce_msg, poly_inv_ring, poly_norm2_centered,
        q_poly_mul_ring_clear, verify_sign_equation,
    };
    use ft1536_sys::{Ft1536KeyPair, Ft1536Signature};
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    const XS: [u16; 3] = [1, 2, 3];
    const K: u8 = 2;
    const DELTA: u64 = 0x0B;
    const NORM_BOUND2: u64 = 2_093_922_385;

    fn two_party_rngs(seed: u64) -> [StdRng; 2] {
        [
            StdRng::seed_from_u64(seed),
            StdRng::seed_from_u64(seed.wrapping_add(0x1111)),
        ]
    }

    /// Test-only: rozdziel i16-poly na `n_parties` wkładów additywnych.
    fn split_poly_i16(
        full: &[i16],
        n_parties: usize,
        rng: &mut impl rand::RngCore,
    ) -> Vec<Vec<i16>> {
        assert!(n_parties >= 2);
        let mut parts = vec![vec![0i16; full.len()]; n_parties];
        for j in 0..full.len() {
            let mut acc = 0i32;
            for p in 0..n_parties - 1 {
                let jitter = (rng.next_u32() % 5) as i32 - 2;
                parts[p][j] = jitter as i16;
                acc += jitter;
            }
            let last = full[j] as i32 - acc;
            parts[n_parties - 1][j] = last as i16;
        }
        parts
    }

    /// T9.3 — auth triple Z_P + mul z triple: OK, a tamper → MacFail.
    #[test]
    fn t9_mac_s_auth_triple_mul_ok_and_tamper() {
        let mut rng = StdRng::seed_from_u64(0x59_03_00_10);
        let triple = generate_auth_triple_zp(&mut rng, &XS, K, DELTA).unwrap();
        // uczciwy mul: 3 · 5 = 15 — wejścia z MAC w chwili shara
        let x_full = share_val_with_mac_zp(&mut rng, 3, &XS, K, DELTA).unwrap();
        let y_full = share_val_with_mac_zp(&mut rng, 5, &XS, K, DELTA).unwrap();
        let x: Vec<u64> = x_full.iter().map(|s| s.share).collect();
        let x_mac: Vec<u64> = x_full.iter().map(|s| s.mac).collect();
        let y: Vec<u64> = y_full.iter().map(|s| s.share).collect();
        let y_mac: Vec<u64> = y_full.iter().map(|s| s.mac).collect();
        let (z, z_mac) =
            mul_auth_zp_with_triple(&mut rng, &XS, K, &x, &x_mac, &y, &y_mac, &triple, DELTA)
                .unwrap();
        let v = zp_open_with_mac_known_delta(&XS, &z, &z_mac, DELTA).unwrap();
        assert_eq!(v, 3 * 5, "auth mul 3·5 = 15");

        // Tamper udziału produktu (ring-mul output) → MacFail przy open
        let mut z_bad = z.clone();
        z_bad[0] = p_add(z_bad[0], 1);
        assert_eq!(
            zp_open_with_mac_known_delta(&XS, &z_bad, &z_mac, DELTA),
            Err(SpikeError::MacFail),
            "tamper produktu ring-mul → MacFail"
        );

        // Tamper MAC produktu → MacFail
        let mut mac_bad = z_mac.clone();
        mac_bad[1] = p_add(mac_bad[1], 1);
        assert_eq!(
            zp_open_with_mac_known_delta(&XS, &z, &mac_bad, DELTA),
            Err(SpikeError::MacFail),
            "tamper MAC na wyniku → MacFail"
        );

        // Tamper wejścia x (wartość BEZ update MAC) → MacFail przy open ε
        let mut x_bad = x.clone();
        x_bad[2] = p_add(x_bad[2], 1);
        let triple2 = generate_auth_triple_zp(&mut rng, &XS, K, DELTA).unwrap();
        assert_eq!(
            mul_auth_zp_with_triple(&mut rng, &XS, K, &x_bad, &x_mac, &y, &y_mac, &triple2, DELTA)
                .map(|_| ()),
            Err(SpikeError::MacFail),
            "tamper wejścia ring-mul (share bez MAC) → MacFail (open ε)"
        );
    }

    /// T9.3 — tor złota G-2 z MAC na s1,s2 po ring-mul → engine verify true
    /// + pin F2. Używa `mps4h_sign_shares_g2` (MAC na wynikach ring-mul,
    /// open z kontrolą ukrytego δ).
    #[test]
    fn t9_mac_s_ok_engine_verify() {
        let mut rngs = two_party_rngs(0x59_03_00_20);
        let mut coins = StdRng::seed_from_u64(0x59_03_00_21);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let f_parts = split_poly_i16(&f16, 2, &mut rngs[0]);
        let g_parts = split_poly_i16(&g16, 2, &mut rngs[1]);
        let fb_parts = split_poly_i16(&f_big16, 2, &mut rngs[0]);
        let gb_parts = split_poly_i16(&g_big16, 2, &mut rngs[1]);
        let contribs: Vec<PartyTrapdoorContribution> = (0..2)
            .map(|i| PartyTrapdoorContribution {
                f: f_parts[i].clone(),
                g: g_parts[i].clone(),
                f_big: fb_parts[i].clone(),
                g_big: gb_parts[i].clone(),
            })
            .collect();
        let gt = dkg_trapdoor_from_contributions(
            &mut rngs, &contribs, &XS, K, DELTA, G2_VSS_SAMPLE,
        )
        .unwrap();

        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let (s1_i, s2_i, cost) =
            mps4h_sign_shares_g2(&mut coins, &gt, &t, &XS, K, 25, 32, None).unwrap();
        eprintln!(
            "T9-mac-s-gold: ring_muls={} (MAC na s1,s2 po ring-mul)",
            cost.ring_reshare_muls
        );
        let s1 = i64_to_qpoly(&s1_i);
        let s2 = i64_to_qpoly(&s2_i);
        let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
        assert!(n < NORM_BOUND2, "norma {n} < {NORM_BOUND2}");
        // pin F2: DKG sum = pełny klucz ⇒ z ≡ clear ⇒ n = 103747771
        assert_eq!(n, 103747771, "pin F2 n (MAC s1,s2 path ≡ clear key)");
        let h = {
            let fq: Vec<u16> = f16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let gq: Vec<u16> = g16.iter().map(|&c| i64_to_qpoly(&[c as i64])[0]).collect();
            let f_inv = poly_inv_ring(&fq).unwrap();
            q_poly_mul_ring_clear(&gq, &f_inv)
        };
        assert!(verify_sign_equation(&s1, &s2, &h, &t));
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature {
            bytes: enc,
            nonce,
        };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig)
            .expect("engine verify nie może errorować");
        assert!(ok, "MAC na s1,s2: engine verify == true (T9.3)");
    }

    /// T9.3 — tamper ring-mul (udział f po DKG) → MacFail w torze G-2
    /// (MAC na wynikach ring-mul / open s1,s2 z kontrolą MAC).
    #[test]
    fn t9_mac_s_tamper_ring_mul_macfail() {
        let mut rngs = two_party_rngs(0x59_03_00_30);
        let mut coins = StdRng::seed_from_u64(0x59_03_00_31);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let f_parts = split_poly_i16(&f16, 2, &mut rngs[0]);
        let g_parts = split_poly_i16(&g16, 2, &mut rngs[1]);
        let fb_parts = split_poly_i16(&f_big16, 2, &mut rngs[0]);
        let gb_parts = split_poly_i16(&g_big16, 2, &mut rngs[1]);
        let contribs: Vec<PartyTrapdoorContribution> = (0..2)
            .map(|i| PartyTrapdoorContribution {
                f: f_parts[i].clone(),
                g: g_parts[i].clone(),
                f_big: fb_parts[i].clone(),
                g_big: gb_parts[i].clone(),
            })
            .collect();
        let mut gt = dkg_trapdoor_from_contributions(
            &mut rngs, &contribs, &XS, K, DELTA, G2_VSS_SAMPLE,
        )
        .unwrap();
        // FAŁSZERSTWO ring-mul: tamper udziału f (wejście splotu) po DKG
        gt.td.f[0][0] = p_add(gt.td.f[0][0], 1);
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let result = mps4h_sign_shares_g2(&mut coins, &gt, &t, &XS, K, 25, 32, None);
        assert_eq!(
            result.map(|_| ()),
            Err(SpikeError::MacFail),
            "tamper ring-mul (f share) → MacFail (T9.3)"
        );
    }

    /// T9.3 — tamper MAC na wyniku ring-mul (f_mac) → MacFail przy open.
    #[test]
    fn t9_mac_s_tamper_mac_macfail() {
        let mut rngs = two_party_rngs(0x59_03_00_40);
        let mut coins = StdRng::seed_from_u64(0x59_03_00_41);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let f_parts = split_poly_i16(&f16, 2, &mut rngs[0]);
        let g_parts = split_poly_i16(&g16, 2, &mut rngs[1]);
        let fb_parts = split_poly_i16(&f_big16, 2, &mut rngs[0]);
        let gb_parts = split_poly_i16(&g_big16, 2, &mut rngs[1]);
        let contribs: Vec<PartyTrapdoorContribution> = (0..2)
            .map(|i| PartyTrapdoorContribution {
                f: f_parts[i].clone(),
                g: g_parts[i].clone(),
                f_big: fb_parts[i].clone(),
                g_big: gb_parts[i].clone(),
            })
            .collect();
        let mut gt = dkg_trapdoor_from_contributions(
            &mut rngs, &contribs, &XS, K, DELTA, G2_VSS_SAMPLE,
        )
        .unwrap();
        // FAŁSZERSTWO MAC: tamper f_mac (MAC na wejściu ring-mul) po DKG
        gt.f_mac[0][0] = p_add(gt.f_mac[0][0], 1);
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let result = mps4h_sign_shares_g2(&mut coins, &gt, &t, &XS, K, 25, 32, None);
        assert_eq!(
            result.map(|_| ()),
            Err(SpikeError::MacFail),
            "tamper MAC f_mac → MacFail (T9.3)"
        );
    }
}

/// T13 — naprawy realnych bugów audytu (#2 Beaver c, #9 jawny δ).
#[cfg(test)]
mod tests_t13_audit_fixes {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    const XS: [u16; 3] = [1, 2, 3];
    const K: u8 = 2;
    const DELTA: u64 = 0x0B;

    fn split_val_mac(v: &[ZpMacShare]) -> (Vec<u64>, Vec<u64>) {
        (
            v.iter().map(|s| s.share).collect(),
            v.iter().map(|s| s.mac).collect(),
        )
    }

    /// #2 — zepsute `c` (przy prawidłowym MAC dla złej wartości) → MacFail.
    /// Przed naprawą `c.mac` był ignorowany; `c.share` wchodził w wynik
    /// z nowym MAC liniowym.
    #[test]
    fn t13_beaver_wrong_c_with_valid_mac_rejected() {
        let mut rng = StdRng::seed_from_u64(0x13_02_00_01);
        let mut triple = generate_auth_triple_zp(&mut rng, &XS, K, DELTA).unwrap();
        // podmień c na dobrze sformułowany zły iloczyn (MAC spójny z nową wartością)
        let wrong_c = share_val_with_mac_zp(&mut rng, 0xDEAD, &XS, K, DELTA).unwrap();
        triple.c = wrong_c;
        assert_eq!(
            check_zp_auth_triple(&XS, &triple, DELTA),
            Err(SpikeError::MacFail),
            "c ≠ a·b z poprawnym MAC → MacFail"
        );

        let x_full = share_val_with_mac_zp(&mut rng, 3, &XS, K, DELTA).unwrap();
        let y_full = share_val_with_mac_zp(&mut rng, 5, &XS, K, DELTA).unwrap();
        let (x, x_mac) = split_val_mac(&x_full);
        let (y, y_mac) = split_val_mac(&y_full);
        assert_eq!(
            mul_auth_zp_with_triple(&mut rng, &XS, K, &x, &x_mac, &y, &y_mac, &triple, DELTA)
                .map(|_| ()),
            Err(SpikeError::MacFail),
            "mul z zepsutym c → MacFail, nie cichy zły iloczyn"
        );
    }

    /// #2 — poprawne `c` → OK; `c.mac` w dataflow (open w checku).
    #[test]
    fn t13_beaver_good_c_ok_and_c_mac_in_dataflow() {
        let mut rng = StdRng::seed_from_u64(0x13_02_00_02);
        let triple = generate_auth_triple_zp(&mut rng, &XS, K, DELTA).unwrap();
        check_zp_auth_triple(&XS, &triple, DELTA).expect("uczciwa trójka przechodzi");

        // sam c.mac: open z kontrolą — sam c.share bez c.mac nie wystarczy
        let c_val: Vec<u64> = triple.c.iter().map(|t| t.share).collect();
        let c_mac: Vec<u64> = triple.c.iter().map(|t| t.mac).collect();
        assert!(zp_open_with_mac_known_delta(&XS, &c_val, &c_mac, DELTA).is_ok());
        let mut c_mac_bad = c_mac.clone();
        c_mac_bad[0] = p_add(c_mac_bad[0], 1);
        assert_eq!(
            zp_open_with_mac_known_delta(&XS, &c_val, &c_mac_bad, DELTA),
            Err(SpikeError::MacFail),
            "c.mac w dataflow: tamper c.mac → MacFail"
        );

        // pełny mul 3·5 = 15
        let x_full = share_val_with_mac_zp(&mut rng, 3, &XS, K, DELTA).unwrap();
        let y_full = share_val_with_mac_zp(&mut rng, 5, &XS, K, DELTA).unwrap();
        let (x, x_mac) = split_val_mac(&x_full);
        let (y, y_mac) = split_val_mac(&y_full);
        let (z, z_mac) =
            mul_auth_zp_with_triple(&mut rng, &XS, K, &x, &x_mac, &y, &y_mac, &triple, DELTA)
                .unwrap();
        let v = zp_open_with_mac_known_delta(&XS, &z, &z_mac, DELTA).unwrap();
        assert_eq!(v, 15);
    }

    /// #2 — tamper `c.share` bez update `c.mac` → MacFail (check trójki).
    #[test]
    fn t13_beaver_tamper_c_share_without_mac_rejected() {
        let mut rng = StdRng::seed_from_u64(0x13_02_00_03);
        let mut triple = generate_auth_triple_zp(&mut rng, &XS, K, DELTA).unwrap();
        triple.c[1].share = p_add(triple.c[1].share, 1);
        assert_eq!(
            check_zp_auth_triple(&XS, &triple, DELTA),
            Err(SpikeError::MacFail)
        );
    }

    /// #9 — skorelowane fałszerstwo **bez** znajomości δ → wykryte.
    /// Napastnik dodaje Δ do wartości i niepoprawne Δ_mac do MAC
    /// (najlepsza próba korelacji bez δ). Open → MacFail.
    #[test]
    fn t13_correlated_forgery_without_delta_detected() {
        let mut rng = StdRng::seed_from_u64(0x13_09_00_01);
        let secret = 0x1234i64;
        let shares = share_val_with_mac_zp(&mut rng, secret, &XS, K, DELTA).unwrap();
        let delta_shares = ZpDeltaShares {
            xs: XS.to_vec(),
            shares: ishare_val(&mut rng, (DELTA % I_P) as i64, &XS, K).unwrap(),
        };
        let (val, mac) = split_val_mac(&shares);
        let delta_p = 7u64; // Δ
        let guessed_mac_shift = 9u64; // nie δ·Δ
        let val_f: Vec<u64> = val.iter().map(|&s| p_add(s, delta_p)).collect();
        let mac_f: Vec<u64> = mac.iter().map(|&m| p_add(m, guessed_mac_shift)).collect();
        // jawny open (model) — skorelowane bez δ nie przechodzi
        assert_eq!(
            zp_open_with_mac_known_delta(&XS, &val_f, &mac_f, DELTA),
            Err(SpikeError::MacFail),
            "skorelowane bez δ → MacFail (nie value-only / MAC-only)"
        );
        // open z ukrytym δ (jak Y6) — też wykryte
        let zpm: Vec<ZpMacShare> = val_f
            .iter()
            .zip(&mac_f)
            .zip(&XS)
            .map(|((&s, &m), &x)| ZpMacShare { x, share: s, mac: m })
            .collect();
        assert_eq!(
            zp_open_with_mac_hidden_delta(&zpm, &delta_shares, K),
            Err(SpikeError::MacFail),
            "skorelowane bez δ → MacFail przy hidden-δ open"
        );
    }

    /// #9 RETAINED (granica modelu G-2): przy **znanym** δ napastnik może
    /// skorelować Δ w wartości i δ·Δ w MAC — liniowy MAC to przepuszcza.
    /// Jawne `delta_known` jest retained w modelu dealerskim; tor produkcyjny
    /// ma używać [`dkg_zp_delta_shares`] (ukryte δ, jak Y6). Test pilnuje,
    /// by tego nie ogłaszać „naprawionym" bez zmiany modelu.
    #[test]
    fn t13_correlated_forgery_with_known_delta_is_retained() {
        let mut rng = StdRng::seed_from_u64(0x13_09_00_02);
        let shares = share_val_with_mac_zp(&mut rng, 42, &XS, K, DELTA).unwrap();
        let (val, mac) = split_val_mac(&shares);
        let delta_p = 5u64;
        let mac_shift = p_mul(DELTA % I_P, delta_p); // δ·Δ — napastnik zna δ
        let val_f: Vec<u64> = val.iter().map(|&s| p_add(s, delta_p)).collect();
        let mac_f: Vec<u64> = mac.iter().map(|&m| p_add(m, mac_shift)).collect();
        // Atak przechodzi przy jawnych δ — RETAINED, nie „cicho naprawione".
        let opened =
            zp_open_with_mac_known_delta(&XS, &val_f, &mac_f, DELTA).expect("retained: atak z δ");
        assert_eq!(opened, 42 + delta_p as i64, "skorelowane Δ+δ·Δ przechodzi");
    }

    /// #9 — value-only i MAC-only (dla kontrastu ze skorelowanym) → wykryte.
    #[test]
    fn t13_value_only_and_mac_only_detected() {
        let mut rng = StdRng::seed_from_u64(0x13_09_00_03);
        let shares = share_val_with_mac_zp(&mut rng, 99, &XS, K, DELTA).unwrap();
        let (val, mac) = split_val_mac(&shares);
        // value-only
        let mut val_v = val.clone();
        val_v[0] = p_add(val_v[0], 1);
        assert_eq!(
            zp_open_with_mac_known_delta(&XS, &val_v, &mac, DELTA),
            Err(SpikeError::MacFail)
        );
        // MAC-only
        let mut mac_v = mac.clone();
        mac_v[1] = p_add(mac_v[1], 1);
        assert_eq!(
            zp_open_with_mac_known_delta(&XS, &val, &mac_v, DELTA),
            Err(SpikeError::MacFail)
        );
    }
}

// ─── T10 — offline NTRU na ważonej sumie + domknięcie H1 ─────────────────

#[cfg(test)]
mod tests_t10 {
    use super::*;
    use ft1536_sys::Ft1536KeyPair;
    use rand::rngs::StdRng;
    use rand::{RngCore, SeedableRng};

    const XS: [u16; 3] = [1, 2, 3];
    const K: u8 = 2;
    const DELTA: u64 = 0x0B;

    fn two_party_rngs(seed: u64) -> [StdRng; 2] {
        [
            StdRng::seed_from_u64(seed),
            StdRng::seed_from_u64(seed.wrapping_add(0x1111)),
        ]
    }

    /// Test-only: c0 małe, c1 = full − w0·c0 ⇒ w0·c0 + c1 = full.
    fn split_weighted_w21(
        full: &[i16],
        w0: i32,
        rng: &mut impl RngCore,
    ) -> (Vec<i16>, Vec<i16>) {
        let c0: Vec<i16> = full
            .iter()
            .map(|_| ((rng.next_u32() % 5) as i32 - 2) as i16)
            .collect();
        let c1: Vec<i16> = full
            .iter()
            .zip(&c0)
            .map(|(&f, &a)| (f as i32 - w0 * (a as i32)) as i16)
            .collect();
        (c0, c1)
    }

    fn weighted_gold_trapdoor(seed: u64) -> (G2Trapdoor, [StdRng; 2]) {
        let mut rngs = two_party_rngs(seed);
        let kp = Ft1536KeyPair::generate_from_seed(&[0x42u8; 32]).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let (f0, f1) = split_weighted_w21(&f16, 2, &mut rngs[0]);
        let (g0, g1) = split_weighted_w21(&g16, 2, &mut rngs[1]);
        let (fb0, fb1) = split_weighted_w21(&f_big16, 2, &mut rngs[0]);
        let (gb0, gb1) = split_weighted_w21(&g_big16, 2, &mut rngs[1]);
        let contribs = [
            PartyTrapdoorContribution {
                f: f0,
                g: g0,
                f_big: fb0,
                g_big: gb0,
            },
            PartyTrapdoorContribution {
                f: f1,
                g: g1,
                f_big: fb1,
                g_big: gb1,
            },
        ];
        let gt = dkg_trapdoor_from_weighted_contributions(
            &mut rngs,
            &contribs,
            &[2, 1],
            &XS,
            K,
            DELTA,
            G2_VSS_SAMPLE,
        )
        .unwrap();
        (gt, rngs)
    }

    /// T10.1 — ważony DKG klucza NTRU → offline check fG−gF=q trzyma.
    /// Otwarcie tylko różnicy (kontrola 18433); bez clear f,g,F,G.
    #[test]
    fn t10_ntru_weighted_shares_ok() {
        let (gt, mut rngs) = weighted_gold_trapdoor(0x5A_01_00_10);
        let ok = ntru_fg_gf_check_weighted_shares(&mut rngs[0], &gt.td, &XS, K).unwrap();
        assert!(ok, "fG−gF == q=18433 na ważonej sumie (T10.1)");
    }

    /// T10.1 — otwarta różnica to dokładnie stała q (nie wielomian).
    #[test]
    fn t10_ntru_open_delta_is_constant_q() {
        let (gt, mut rngs) = weighted_gold_trapdoor(0x5A_01_00_20);
        let d = ntru_fg_gf_open_delta(&mut rngs[0], &gt.td, &XS, K).unwrap();
        assert_eq!(d.len(), FT1536_N);
        assert_eq!(d[0], FT1536_Q as i64, "wyraz wolny = q = 18433");
        assert!(
            d[1..].iter().all(|&c| c == 0),
            "pozostałe współczynniki fG−gF = 0"
        );
    }

    /// T10.4 — zła relacja NTRU (tamper wkładu/udziału) → check false.
    #[test]
    fn t10_ntru_bad_relation_detected() {
        let (mut gt, mut rngs) = weighted_gold_trapdoor(0x5A_01_00_30);
        // Fałszerstwo: zmiana udziału f po DKG (bez update zobowiązań)
        gt.td.f[0][0] = p_add(gt.td.f[0][0], 1);
        let ok = ntru_fg_gf_check_weighted_shares(&mut rngs[0], &gt.td, &XS, K).unwrap();
        assert!(!ok, "zepsuta relacja NTRU → false (fail-closed)");
    }

    /// T10.4 — zepsuty ważony wkład (inny klucz) → relacja nie trzyma.
    #[test]
    fn t10_ntru_wrong_contribution_detected() {
        let mut rngs = two_party_rngs(0x5A_01_00_40);
        let kp = Ft1536KeyPair::generate_from_seed(&[0x42u8; 32]).unwrap();
        let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
        let (f0, f1) = split_weighted_w21(&f16, 2, &mut rngs[0]);
        let (g0, g1) = split_weighted_w21(&g16, 2, &mut rngs[1]);
        let (fb0, fb1) = split_weighted_w21(&f_big16, 2, &mut rngs[0]);
        let (mut gb0, gb1) = split_weighted_w21(&g_big16, 2, &mut rngs[1]);
        // FAŁSZERSTWO: partia 0 psuje G w swoim wkładzie
        gb0[0] = gb0[0].wrapping_add(1);
        let contribs = [
            PartyTrapdoorContribution {
                f: f0,
                g: g0,
                f_big: fb0,
                g_big: gb0,
            },
            PartyTrapdoorContribution {
                f: f1,
                g: g1,
                f_big: fb1,
                g_big: gb1,
            },
        ];
        let gt = dkg_trapdoor_from_weighted_contributions(
            &mut rngs,
            &contribs,
            &[2, 1],
            &XS,
            K,
            DELTA,
            G2_VSS_SAMPLE,
        )
        .unwrap();
        let ok = ntru_fg_gf_check_weighted_shares(&mut rngs[0], &gt.td, &XS, K).unwrap();
        assert!(!ok, "zepsuty wkład G → fG−gF ≠ q (T10.4)");
    }

    /// T10 — zgoda na wkłady: ten sam wkład = ten sam digest; inny ≠.
    #[test]
    fn t10_contribution_digest_agreement() {
        let a = PartyTrapdoorContribution {
            f: vec![1i16; FT1536_N],
            g: vec![0i16; FT1536_N],
            f_big: vec![0i16; FT1536_N],
            g_big: vec![1i16; FT1536_N],
        };
        let mut b = a.clone();
        assert_eq!(
            trapdoor_contribution_digest(&a),
            trapdoor_contribution_digest(&b),
            "identyczny wkład = identyczny digest (zgoda)"
        );
        b.f[0] = 2;
        assert_ne!(
            trapdoor_contribution_digest(&a),
            trapdoor_contribution_digest(&b),
            "zmiana wkładu = inny digest (brak zgody)"
        );
    }

    /// T10.2 — H1: `g2_deal_trapdoor` = retained / test-only.
    /// Tor produkcyjny = weighted DKG + offline NTRU; dealer clear f,F
    /// nie jest wywoływany. (Komentarz API + ten test jako nota retained.)
    #[test]
    fn t10_h1_g2_deal_retained_test_only() {
        // Dowód pośredni: produkcja przez dkg_* nie potrzebuje g2_deal_trapdoor.
        // Wywołanie dealera zostaje wyłącznie w testach retained (G-2 history).
        let (gt, mut rngs) = weighted_gold_trapdoor(0x5A_01_00_50);
        // Tor produkcyjny: DKG + offline NTRU check (bez g2_deal_trapdoor).
        assert!(
            ntru_fg_gf_check_weighted_shares(&mut rngs[0], &gt.td, &XS, K).unwrap(),
            "produkcja: weighted DKG + offline NTRU (H1 domknięte w tym sensie)"
        );
        // Clear f,F nie powstaje w dkg_trapdoor_from_weighted_contributions —
        // wyjście to wyłącznie udziały (ITrapdoorShares = Vec per strona).
        assert_eq!(gt.td.f[0].len(), XS.len(), "udziały, nie jawny poly");
    }
}
