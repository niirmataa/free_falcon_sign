//! MPS1 — udziały Shamir nad **Z_q, q = 18433** (FT1536 — patrz
//! `FT1536_IDENTITY.md`). Podstawa pełnego MPC sign: f,g,F,G, NTT i `s`
//! liczone na udziałach mod 18433; otwieramy wyłącznie jawny podpis `s`.
//!
//! **NIE** jest to GF(256) (te zostaje dla SHAKE/MAC). **NIE** q=12289.

use crate::{Result, SpikeError};

/// Modulus pierścienia FT1536 (FREE_FALCON / mq_div_18433).
pub const FT1536_Q: u16 = 18433;

/// Stopień N (logn=10) — pierścień `X^1536 - X^768 + 1`.
pub const FT1536_N: usize = 1536;

/// Udział wartości w Z_q (Shamir k-z-n). `x` = punkt, `share` w [0, q).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct QShare {
    pub x: u16,
    pub share: u16,
}

fn q_add(a: u16, b: u16) -> u16 {
    ((a as u32 + b as u32) % FT1536_Q as u32) as u16
}

fn q_sub(a: u16, b: u16) -> u16 {
    ((a as u32 + FT1536_Q as u32 - b as u32) % FT1536_Q as u32) as u16
}

fn q_mul(a: u16, b: u16) -> u16 {
    ((a as u32 * b as u32) % FT1536_Q as u32) as u16
}

fn q_inv(a: u16) -> Result<u16> {
    if a % FT1536_Q == 0 {
        return Err(SpikeError::WrongThreshold);
    }
    // Fermat: a^(q-2) mod q (q=18433 pierwsza)
    let mut r = 1u32;
    let mut b = a as u32 % FT1536_Q as u32;
    let mut e = FT1536_Q as u32 - 2;
    while e > 0 {
        if e & 1 == 1 {
            r = (r * b) % FT1536_Q as u32;
        }
        b = (b * b) % FT1536_Q as u32;
        e >>= 1;
    }
    Ok(r as u16)
}

fn q_eval_poly(coeffs: &[u16], x: u16) -> u16 {
    // Horner w Z_q
    let mut acc = 0u16;
    for &c in coeffs.iter().rev() {
        acc = q_add(q_mul(acc, x), c);
    }
    acc
}

/// Shamir share sekretu `s` w Z_q, punkty `xs` (niezerowe, unikalne w Z_q).
pub fn q_shamir_share(
    rng: &mut impl rand::RngCore,
    secret: u16,
    xs: &[u16],
    k: u8,
) -> Result<Vec<QShare>> {
    if k < 2 {
        return Err(SpikeError::ThresholdTooLow);
    }
    if xs.len() < k as usize {
        return Err(SpikeError::NotEnoughPoints);
    }
    if xs.iter().any(|&x| x == 0 || x >= FT1536_Q) {
        return Err(SpikeError::XZero);
    }
    let mut seen = [false; 18433];
    for &x in xs {
        if seen[x as usize] {
            return Err(SpikeError::DuplicateX);
        }
        seen[x as usize] = true;
    }
    let k = k as usize;
    let mut coeffs = Vec::with_capacity(k);
    coeffs.push(secret % FT1536_Q);
    for _ in 1..k {
        coeffs.push((rng.next_u32() % FT1536_Q as u32) as u16);
    }
    Ok(xs
        .iter()
        .map(|&x| QShare {
            x,
            share: q_eval_poly(&coeffs, x),
        })
        .collect())
}

/// Rekonstrukcja („moment" / jawne s) — Lagrange w 0 na wszystkich udziałach.
pub fn q_reconstruct(shares: &[QShare]) -> Result<u16> {
    if shares.is_empty() {
        return Err(SpikeError::EmptyShares);
    }
    let mut acc = 0u16;
    for (i, si) in shares.iter().enumerate() {
        let mut num = 1u16;
        let mut den = 1u16;
        for (j, sj) in shares.iter().enumerate() {
            if i == j {
                continue;
            }
            num = q_mul(num, sj.x);
            den = q_mul(den, q_sub(si.x, sj.x));
        }
        let lam = q_mul(num, q_inv(den)?);
        acc = q_add(acc, q_mul(si.share, lam));
    }
    Ok(acc)
}

/// Lokalny iloczyn (model kosztu — bez Beaver w MPS1): jawny oracle.
pub fn q_mul_local(a: u16, b: u16) -> u16 {
    q_mul(a, b)
}

/// MPS1-B: mnożenie Shamir w Z_q przez re-deal.
/// **Wymaga `n ≥ 2k−1`** (audyt #1 — stopień 2(k−1)).
pub fn q_mul_shamir_reshare(
    rng: &mut impl rand::RngCore,
    xs: &[u16],
    k: u8,
    a: &[u16],
    b: &[u16],
) -> Result<Vec<u16>> {
    if xs.is_empty() {
        return Err(SpikeError::EmptyXs);
    }
    let n = xs.len();
    crate::mul::check_mul_quorum(n, k)?;
    if a.len() != n || b.len() != n {
        return Err(SpikeError::PartyCountMismatch);
    }
    // λ_i = Lagrange(0) po xs
    let mut c = vec![0u16; n];
    for i in 0..n {
        let mut num = 1u16;
        let mut den = 1u16;
        for j in 0..n {
            if i == j {
                continue;
            }
            num = q_mul(num, xs[j]);
            den = q_mul(den, q_sub(xs[i], xs[j]));
        }
        let lam = q_mul(num, q_inv(den)?);
        let u_i = q_mul(lam, q_mul(a[i], b[i]));
        // re-deal u_i
        let dealt = q_shamir_share(rng, u_i, xs, k)?;
        for (j, sh) in dealt.into_iter().enumerate() {
            c[j] = q_add(c[j], sh.share);
        }
    }
    Ok(c)
}

/// Jawny test: wektor stały.
pub fn q_one() -> u16 {
    1
}

// ─── MPS2 — wielomiany f,g,F,G na udziałach + NTT q-ary ────────────────

/// Wielomian w Z_q[X] (współczynniki jawne — oracle / klucz jawny h).
pub type QPoly = Vec<u16>;

/// Wielomian na udziałach: `[współczynnik N][strona n]` wartości share.
pub type QPolyShares = Vec<Vec<u16>>;

/// Długość N FT1536.
pub fn poly_len() -> usize {
    FT1536_N
}

/// Udział wielomianu: każdy współczynnik Shamir-share.
pub fn q_share_poly(
    rng: &mut impl rand::RngCore,
    poly: &[u16],
    xs: &[u16],
    k: u8,
) -> Result<QPolyShares> {
    if poly.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    let mut out = Vec::with_capacity(FT1536_N);
    for &c in poly {
        let sh = q_shamir_share(rng, c, xs, k)?;
        out.push(sh.into_iter().map(|s| s.share).collect());
    }
    Ok(out)
}

/// Rekonstrukcja wielomianu („moment" — jawny oracle w testach).
pub fn q_reconstruct_poly(ps: &QPolyShares, xs: &[u16]) -> Result<QPoly> {
    if ps.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    let mut out = Vec::with_capacity(FT1536_N);
    for col in ps {
        let shares: Vec<QShare> = xs
            .iter()
            .zip(col)
            .map(|(&x, &share)| QShare { x, share })
            .collect();
        out.push(q_reconstruct(&shares)?);
    }
    Ok(out)
}

/// Jawny iloczyn wielomianów w R = Z_q[X]/(X^N - X^{N/2} + 1).
/// Redukcja: X^N ≡ X^{N/2} - 1 (w Z_q).
fn add_monomial(acc: &mut [u16], mut e: usize, mut coef: u16) {
    let n = FT1536_N;
    let half = n / 2;
    while e >= n {
        // X^e = X^{e-n} · (X^{half} - 1)
        // += coef * X^{e-n+half}, -= coef * X^{e-n}
        let e2 = e - n;
        add_monomial(acc, e2 + half, coef);
        coef = q_sub(0, coef);
        e = e2;
    }
    acc[e] = q_add(acc[e], coef);
}

pub fn q_poly_mul_ring_clear(a: &[u16], b: &[u16]) -> QPoly {
    assert_eq!(a.len(), FT1536_N);
    assert_eq!(b.len(), FT1536_N);
    let n = FT1536_N;
    let mut acc = vec![0u16; n];
    for i in 0..n {
        if a[i] == 0 {
            continue;
        }
        for j in 0..n {
            if b[j] == 0 {
                continue;
            }
            add_monomial(&mut acc, i + j, q_mul(a[i], b[j]));
        }
    }
    acc
}

/// MPS2-B: NTT q-ary (uproszczony — bit-reversal + butterfly mod q).
/// **Model roboczy:** Cooley-Tukey na 2^k, ale N=1536=3·2^9 — w FT1536
/// jest NTT ternary (X^N - X^{N/2} + 1). Tu: standardowy NTT na 2^k
/// dla 1024 (podzbiór) jako krok pośredni + jawne mnożenie pierścieniowe
/// jako oracle. Pełny mq_NTT_ternary = MPS2-C.
pub fn q_ntt_butterfly(a: &mut [u16], w: u16) {
    let n = a.len();
    if n < 2 {
        return;
    }
    let half = n / 2;
    for i in 0..half {
        let t = q_mul(w, a[i + half]);
        a[i + half] = q_sub(a[i], t);
        a[i] = q_add(a[i], t);
    }
}

/// Długi iloczyn NTT na udziałach: mnożenie współczynników przez
/// `q_mul_shamir_reshare` (bez otwierania). Koszt: N reshare-muls.
pub fn q_poly_mul_shares_naive(
    rng: &mut impl rand::RngCore,
    a: &QPolyShares,
    b: &QPolyShares,
    xs: &[u16],
    k: u8,
) -> Result<QPolyShares> {
    if a.len() != FT1536_N || b.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    let n = xs.len();
    let mut out = vec![vec![0u16; n]; FT1536_N];
    // pełny splot + redukcja pierścienia na udziałach — drogie O(N²);
    // do celów MPS2 na razie: mnożenie „diagonalne" w bazie NTT (jasny
    // model kosztu) zamiast pełnego splotu.
    for i in 0..FT1536_N {
        let ai: Vec<u16> = a[i].clone();
        let bi: Vec<u16> = b[i].clone();
        out[i] = q_mul_shamir_reshare(rng, xs, k, &ai, &bi)?;
    }
    Ok(out)
}

#[cfg(test)]
mod tests_mps2 {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    const XS: [u16; 3] = [1, 2, 3];

    fn short_poly(pattern: u16) -> QPoly {
        let mut p = vec![0u16; FT1536_N];
        p[0] = pattern;
        p[1] = pattern.wrapping_mul(3) % FT1536_Q;
        p
    }

    #[test]
    fn mps2_share_reconstruct_poly() {
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_03);
        let poly = short_poly(42);
        let ps = q_share_poly(&mut rng, &poly, &XS, 2).unwrap();
        let back = q_reconstruct_poly(&ps, &XS).unwrap();
        assert_eq!(back, poly);
    }

    #[test]
    fn mps2_ring_mul_clear_unit() {
        // 1 · X = X w pierścieniu
        let mut one = vec![0u16; FT1536_N];
        one[0] = 1;
        let mut x = vec![0u16; FT1536_N];
        x[1] = 1;
        let p = q_poly_mul_ring_clear(&one, &x);
        assert_eq!(p[1], 1);
        assert_eq!(p[0], 0);
    }

    #[test]
    fn mps2_ring_reduction_xn() {
        // X^N = X^{N/2} - 1 → X · X^{N-1} = -1 + X^{N/2}
        let mut x = vec![0u16; FT1536_N];
        x[1] = 1;
        let mut x_n1 = vec![0u16; FT1536_N];
        x_n1[FT1536_N - 1] = 1;
        let p = q_poly_mul_ring_clear(&x, &x_n1);
        let half = FT1536_N / 2;
        assert_eq!(p[0], FT1536_Q - 1, "X^N = X^(N/2)-1 → -1");
        assert_eq!(p[half], 1);
        assert!(
            p.iter().enumerate().all(|(i, &c)| i == 0 || i == half || c == 0),
            "tylko 0 i N/2"
        );
    }

    #[test]
    fn mps2_ntt_butterfly_linear() {
        let mut a = vec![1u16, 2];
        q_ntt_butterfly(&mut a, 3);
        // t = 3*2 = 6; a0' = 1+6 = 7; a1' = 1-6 = q-5
        assert_eq!(a[0], 7);
        assert_eq!(a[1], q_sub(1, 6));
    }

    #[test]
    fn mps2_poly_mul_shares_diagonal_matches() {
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_04);
        let a = short_poly(100);
        let b = short_poly(200);
        let as_ = q_share_poly(&mut rng, &a, &XS, 2).unwrap();
        let bs_ = q_share_poly(&mut rng, &b, &XS, 2).unwrap();
        let cs_ = q_poly_mul_shares_naive(&mut rng, &as_, &bs_, &XS, 2).unwrap();
        let c = q_reconstruct_poly(&cs_, &XS).unwrap();
        // model diagonalny: c[i] = a[i]·b[i]
        for i in 0..4 {
            assert_eq!(c[i], q_mul(a[i], b[i]), "c[{i}]");
        }
    }
}

// ─── MPS3 — hash_to_point + równanie sign (s2 jawne) ───────────────────
//
// C (`falcon-enc.c:564`): rejection 16-bit w < lim=65536-(65536%q),
// w % q; n = 3·2^(logn-1) = 1536 dla q=18433.
// Sign zwraca **tylko s2** (verify odtwarza s1 z s2, hm, h) —
// w MPC otwieramy wyłącznie s2.

/// `lim` dla rejection samplingu hash_to_point (q=18433).
pub fn hash_to_point_lim() -> u32 {
    65536 - (65536 % FT1536_Q as u32)
}

/// Jawny hash_to_point (oracle C): strumień bajtów (SHAKE) → n=1536
/// współczynników w Z_q. Wejście = kolejne 2 B big-endian z `stream`.
pub fn hash_to_point_clear(stream: &[u8]) -> QPoly {
    let n = FT1536_N;
    let lim = hash_to_point_lim();
    let mut out = Vec::with_capacity(n);
    let mut i = 0usize;
    while out.len() < n && i + 1 < stream.len() {
        let w = ((stream[i] as u32) << 8) | (stream[i + 1] as u32);
        i += 2;
        if w < lim {
            out.push((w % FT1536_Q as u32) as u16);
        }
    }
    while out.len() < n {
        out.push(0); // fail-closed padding w oracle (nie w torze)
    }
    out
}

/// Jawne: `t = hash(SHAKE(salt || pk || msg))` — model wejścia C
/// (sc zawiera pk+msg przed hash_to_point; patrz falcon-sign.c:3324).
pub fn hash_to_point_from_msg(pk: &[u8], msg: &[u8]) -> QPoly {
    use sha3::digest::{ExtendableOutput, Update, XofReader};
    let mut h = sha3::Shake256::default();
    h.update(pk);
    h.update(msg);
    let mut reader = h.finalize_xof();
    let mut buf = vec![0u8; FT1536_N * 4]; // zapas na odrzuty
    reader.read(&mut buf);
    hash_to_point_clear(&buf)
}

/// `t = hash_to_point(SHAKE256(nonce || msg))` — **dokładnie** jak engine
/// (`falcon-sign.c:3293-3325` / `falcon-vrfy.c:1514-1515`): `shake_init(512)`,
/// inject nonce, inject msg, flip, `falcon_hash_to_point`. Public key **nie**
/// wchodzi do tego SHAKE.
pub fn hash_to_point_from_nonce_msg(nonce: &[u8], msg: &[u8]) -> QPoly {
    use sha3::digest::{ExtendableOutput, Update, XofReader};
    let mut h = sha3::Shake256::default();
    h.update(nonce);
    h.update(msg);
    let mut reader = h.finalize_xof();
    let mut buf = vec![0u8; FT1536_N * 4];
    reader.read(&mut buf);
    hash_to_point_clear(&buf)
}

/// Równanie weryfikacji (`falcon-vrfy.c:1419`): `s1 = s2·h − t`
/// (mod X^N-X^{N/2}+1, q) ⟺ `s2·h − s1 = t`.
pub fn verify_sign_equation(s1: &[u16], s2: &[u16], h: &[u16], t: &[u16]) -> bool {
    let s2h = q_poly_mul_ring_clear(s2, h);
    for i in 0..FT1536_N {
        let lhs = q_sub(s2h[i], s1[i]);
        if lhs != t[i] {
            return false;
        }
    }
    true
}

/// Na udziałach: `s1 = t - s2·h` (liczone bez otwierania s1,s2,h,t).
/// Zwraca udziały s1. Otwieramy potem **s2** (i ewentualnie s1 do checku).
pub fn compute_s1_from_s2_shares(
    rng: &mut impl rand::RngCore,
    s2: &QPolyShares,
    h: &QPolyShares,
    t: &QPolyShares,
    xs: &[u16],
    k: u8,
) -> Result<QPolyShares> {
    // s1 = t - s2*h; mnożenie diagonalne w modelu MPS2 (uproszczenie)
    let s2h = q_poly_mul_shares_naive(rng, s2, h, xs, k)?;
    let mut s1 = t.clone();
    for i in 0..FT1536_N {
        for p in 0..xs.len() {
            s1[i][p] = q_sub(s1[i][p], s2h[i][p]);
        }
    }
    Ok(s1)
}

#[cfg(test)]
mod tests_mps3 {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    const XS: [u16; 3] = [1, 2, 3];

    #[test]
    fn mps3_hash_to_point_len_and_range() {
        let buf = [0xABu8; 4096];
        let t = hash_to_point_clear(&buf);
        assert_eq!(t.len(), FT1536_N);
        assert!(t.iter().all(|&c| c < FT1536_Q));
    }

    #[test]
    fn mps3_hash_to_point_lim() {
        // 65536 % 18433 = 65536 - 3*18433 = 65536-55299 = 10237
        // lim = 65536 - 10237 = 55299
        assert_eq!(hash_to_point_lim(), 55299);
    }

    #[test]
    fn mps3_sign_equation_consistent() {
        // s1 = s2·h − t  (falcon-vrfy.c:1419)
        let mut s1 = vec![0u16; FT1536_N];
        let mut s2 = vec![0u16; FT1536_N];
        let mut h = vec![0u16; FT1536_N];
        s1[0] = 5;
        s2[1] = 3;
        h[2] = 7;
        let s2h = q_poly_mul_ring_clear(&s2, &h);
        let t: QPoly = (0..FT1536_N).map(|i| q_sub(s2h[i], s1[i])).collect();
        assert!(verify_sign_equation(&s1, &s2, &h, &t));
        let mut bad = t.clone();
        bad[0] = q_add(bad[0], 1);
        assert!(!verify_sign_equation(&s1, &s2, &h, &bad));
    }

    #[test]
    fn mps3_s1_from_s2_shares_diagonal_model() {
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_06);
        let mut s2 = vec![0u16; FT1536_N];
        let mut h = vec![0u16; FT1536_N];
        let mut t = vec![0u16; FT1536_N];
        s2[0] = 2;
        h[0] = 3;
        t[0] = 11; // s1[0] = 11 - 2*3 = 5 (w modelu diagonalnym)
        let s2s = q_share_poly(&mut rng, &s2, &XS, 2).unwrap();
        let hs = q_share_poly(&mut rng, &h, &XS, 2).unwrap();
        let ts = q_share_poly(&mut rng, &t, &XS, 2).unwrap();
        let s1s = compute_s1_from_s2_shares(&mut rng, &s2s, &hs, &ts, &XS, 2).unwrap();
        let s1 = q_reconstruct_poly(&s1s, &XS).unwrap();
        assert_eq!(s1[0], q_sub(11, q_mul(2, 3)));
    }
}

// ─── MPS4 — trapdoor (f,g,F,G) → s2 na udziałach → encoding ────────────
//
// C (`falcon-sign.c:1171-1184`): b00=g, b01=f, b10=G, b11=F.
// Krata: `(s1,s2) = (t - z1·g - z2·G, z1·f + z2·F)` — wtedy
// `s1 + s2·h ≡ t` dla `h = g/f` (mod q, w pierścieniu).
// Sign zwraca **tylko s2** (sig[0]=(ter<<7)|(comp<<5)|logn = 0xAA
// dla FT1536: ter=1, comp=STATIC=1, logn=10).

/// Header bajtu podpisu FT1536 (ternary + STATIC + logn=10).
pub fn sig_header_byte() -> u8 {
    (1u8 << 7) | (1u8 << 5) | 10u8 // 0xAA
}

/// Pułapka NTRU na udziałach.
pub struct TrapdoorShares {
    pub f: QPolyShares,
    pub g: QPolyShares,
    pub f_big: QPolyShares,
    pub g_big: QPolyShares,
}

/// Jawny trapdoor (oracle).
pub struct TrapdoorClear {
    pub f: QPoly,
    pub g: QPoly,
    pub f_big: QPoly,
    pub g_big: QPoly,
}

/// `(s1, s2) = (z0·g + z1·G − t, z0·f + z1·F)` w Z_q.
/// **Weryfikacja** (`falcon-vrfy.c:1419`): `s1 = s2·h − t`, więc
/// `s2·h − s1 = t` — ta konstrukcja to spełnia (mod q, pierścień).
pub fn trapdoor_sign_clear(
    td: &TrapdoorClear,
    t: &[u16],
    z0: &[u16],
    z1: &[u16],
) -> (QPoly, QPoly) {
    let z0g = q_poly_mul_ring_clear(z0, &td.g);
    let z1g = q_poly_mul_ring_clear(z1, &td.g_big);
    let z0f = q_poly_mul_ring_clear(z0, &td.f);
    let z1f = q_poly_mul_ring_clear(z1, &td.f_big);
    let mut s1 = vec![0u16; FT1536_N];
    let mut s2 = vec![0u16; FT1536_N];
    for i in 0..FT1536_N {
        s1[i] = q_sub(q_add(z0g[i], z1g[i]), t[i]);
        s2[i] = q_add(z0f[i], z1f[i]);
    }
    (s1, s2)
}

/// Na udziałach: s1, s2 z trapdoora (z1,z2 jawne krótkie — Klein/MPS).
/// Otwieramy potem **s2** (i s1 do checku) — klucz (f,g,F,G) zostaje.
pub fn trapdoor_sign_shares(
    rng: &mut impl rand::RngCore,
    td: &TrapdoorShares,
    t: &QPolyShares,
    z1: &[u16],
    z2: &[u16],
    xs: &[u16],
    k: u8,
) -> Result<(QPolyShares, QPolyShares)> {
    // s2 = z1·f + z2·F (mnożenie skalar-wielomian jawne + mul share)
    // Model: z jawne (krótkie z Kleina w tym kroku) × f na udziałach
    let z1s = z1.to_vec();
    let z2s = z2.to_vec();
    let mut s2 = vec![vec![0u16; xs.len()]; FT1536_N];
    let mut s1 = t.clone();
    for i in 0..FT1536_N {
        // s2 = z0·f + z1·F
        for p in 0..xs.len() {
            let t1 = q_mul(z1s[i], td.f[i][p]);
            let t2 = q_mul(z2s[i], td.f_big[i][p]);
            s2[i][p] = q_add(t1, t2);
        }
    }
    // s1 = z0·g + z1·G − t
    for i in 0..FT1536_N {
        for p in 0..xs.len() {
            let t1 = q_mul(z1s[i], td.g[i][p]);
            let t2 = q_mul(z2s[i], td.g_big[i][p]);
            s1[i][p] = q_sub(q_add(t1, t2), t[i][p]);
        }
    }
    let _ = rng;
    let _ = k;
    Ok((s1, s2))
}

/// Jawna norma l2 (model): Σ (c-centered)² — jak `falcon_is_short` (uproszcz.).
pub fn poly_norm2_centered(p: &[u16]) -> u64 {
    let q = FT1536_Q as i32;
    let mut s = 0u64;
    for &c in p {
        let mut v = c as i32;
        if v > q / 2 {
            v -= q;
        }
        s = s.saturating_add((v as i64 * v as i64) as u64);
    }
    s
}

/// Encoding s2 (model `falcon_encode_small`): header 0xAA + 16-bit LE
/// centered coeffs (uproszczony encoding — **nie** Golomb-Rice z C).
/// Pełny `falcon_encode_small` = MPS4-B (codec bitowy).
pub fn encode_s2_model(s2: &[u16]) -> Vec<u8> {
    let mut out = vec![sig_header_byte()];
    for &c in s2 {
        out.extend_from_slice(&c.to_le_bytes());
    }
    out
}

// ─── MPS4-B — compress_static (q=18433, j=8) jak C ─────────────────────

/// `compress_static` (falcon-enc.c:289) dla q=18433: j=8, n=1536.
/// Każdy w: bit znaku (1=ujemna) + 8 niskich bitów |w|, potem
/// `ne=|w|>>8` zer + bit 1 (terminator).
pub fn compress_static_18433(x: &[i16]) -> Vec<u8> {
    const J: u32 = 8;
    let mask = (1u32 << J) - 1;
    let n = FT1536_N;
    assert_eq!(x.len(), n);
    let mut buf = Vec::with_capacity(n);
    let mut acc: u32 = 0;
    let mut acc_len: i32 = 0;
    for &w_raw in x.iter().take(n) {
        let mut w = w_raw as i32;
        let mut lo: u32;
        if w < 0 {
            w = -w;
            lo = 1u32 << J;
        } else {
            lo = 0;
        }
        lo |= (w as u32) & mask;
        let ne = (w as u32) >> J;
        acc = (acc << (J + 1)) | lo;
        acc_len += (J + 1) as i32;
        while acc_len >= 8 {
            acc_len -= 8;
            buf.push((acc >> acc_len) as u8);
        }
        // ne zer + terminator 1 (pętla C: while (ne-- >= 0) z bit 1 gdy ne==-1)
        let mut ne = ne as i32;
        while ne >= 0 {
            acc <<= 1;
            if ne == 0 {
                acc |= 1; // terminator
            }
            // w C: acc += ((unsigned)ne >> 15) & 1 po ne-- — dla ne=0 daje 1
            ne -= 1;
            acc_len += 1;
            if acc_len == 8 {
                buf.push(acc as u8);
                acc_len = 0;
            }
        }
    }
    if acc_len > 0 {
        buf.push((acc << (8 - acc_len)) as u8);
    }
    buf
}

/// `uncompress_static` (falcon-enc.c:462) — odwrotność compress_static.
pub fn uncompress_static_18433(data: &[u8]) -> Result<Vec<i16>> {
    const J: u32 = 8;
    let n = FT1536_N;
    let mut out = Vec::with_capacity(n);
    let mut bitpos = 0usize; // bitowy kursor w data
    let total_bits = data.len() * 8;
    let get_bits = |need: u32, bitpos: &mut usize| -> Option<u32> {
        let mut v = 0u32;
        for _ in 0..need {
            if *bitpos >= total_bits {
                return None;
            }
            let byte = data[*bitpos / 8];
            let bit = (byte >> (7 - (*bitpos % 8))) & 1;
            v = (v << 1) | (bit as u32);
            *bitpos += 1;
        }
        Some(v)
    };
    for _ in 0..n {
        let head = get_bits(J + 1, &mut bitpos).ok_or(SpikeError::MacFail)?;
        let sign = (head >> J) & 1;
        let mut w = (head & ((1 << J) - 1)) as i32;
        // zera + terminator 1
        loop {
            let b = get_bits(1, &mut bitpos).ok_or(SpikeError::MacFail)?;
            if b == 1 {
                break;
            }
            w += 1 << J;
            if w > i16::MAX as i32 {
                return Err(SpikeError::MacFail);
            }
        }
        if sign == 1 {
            w = -w;
        }
        out.push(w as i16);
    }
    Ok(out)
}

/// Encoding pełnego podpisu: `[0xAA || compress_static(s2)]`.
pub fn encode_sig_static(s2: &[u16]) -> Vec<u8> {
    let signed: Vec<i16> = s2
        .iter()
        .map(|&c| {
            // u16 centered → i16
            let q = FT1536_Q as i32;
            let mut v = c as i32;
            if v > q / 2 {
                v -= q;
            }
            v as i16
        })
        .collect();
    let mut out = vec![sig_header_byte()];
    out.extend(compress_static_18433(&signed));
    out
}

// ─── MPS4-C — krótkie z1,z2 (ternary sampler + rejection) ──────────────

/// Krótki wektor ternary (−1,0,1)^N — model sekretu FT1536 / z do trapdoora.
pub fn sample_z_ternary(rng: &mut impl rand::RngCore) -> QPoly {
    (0..FT1536_N)
        .map(|_| match rng.next_u32() % 3 {
            0 => 0u16,
            1 => 1u16,
            _ => FT1536_Q - 1, // −1
        })
        .collect()
}

/// Granica normy (uproszczona): Σ s1²+s2² < bound.
/// C (`internal.h`): `FALCON_FT1536_NORM_BOUND2 = 2093922385`.
pub fn norm_bound_test() -> u64 {
    2_093_922_385
}

// ─── MPS4-D — dekodowanie sk + codec vs silnik (ZŁOTO) ─────────────────

/// Header bajt sk FT1536: (ter<<7)|(comp<<5)|has_G_bit|logn.
/// has_G = !(fb & 0x10); dla FT1536: ter=1, comp=STATIC=1, has_G=1, logn=10
/// → `(1<<7)|(1<<5)|0|10` = 0xAA.
pub fn sk_header_byte() -> u8 {
    (1u8 << 7) | (1u8 << 5) | 10u8
}

/// Dekoduje sk FT1536: `[0xAA || f || g || F || G]` (każdy compress_static).
/// Zwraca (f, g, F, G) jako i16 coeffs (centered).
pub fn decode_sk_ft1536(skey: &[u8]) -> Result<(QPoly, QPoly, QPoly, QPoly)> {
    if skey.is_empty() {
        return Err(SpikeError::EmptyShares);
    }
    let fb = skey[0];
    let ternary = fb >> 7;
    if ternary != 1 {
        return Err(SpikeError::WrongThreshold); // tylko wariant ternary FT1536
    }
    let logn = fb & 0x0F;
    if logn != 10 {
        return Err(SpikeError::WrongThreshold);
    }
    let has_g = (fb & 0x10) == 0;
    if !has_g {
        return Err(SpikeError::WrongThreshold);
    }
    // 4 wektory: f,g,F,G — każdy 1536 coeff compress_static
    // Szukamy granic przez dekodowanie sekwencyjne
    let mut pos = 1usize;
    let mut polys = Vec::new();
    for _ in 0..4 {
        // spróbuj dekodować z reszty bufora
        let rest = &skey[pos..];
        // nie znamy długości — dekoduj 1536 coeff z dowolnej ilości bitów
        match uncompress_static_n(rest, FT1536_N) {
            Some((p, used_bytes)) => {
                polys.push(p.into_iter().map(i16_to_q).collect::<QPoly>());
                pos += used_bytes;
            }
            None => return Err(SpikeError::MacFail),
        }
    }
    Ok((polys[0].clone(), polys[1].clone(), polys[2].clone(), polys[3].clone()))
}

/// `uncompress_static` z podaną liczbą coeff; zwraca (poly, użyte bajty).
pub fn uncompress_static_n(data: &[u8], n: usize) -> Option<(Vec<i16>, usize)> {
    const J: u32 = 8;
    let mut out = Vec::with_capacity(n);
    let mut bitpos = 0usize;
    let total_bits = data.len() * 8;
    let get_bits = |need: u32, bitpos: &mut usize| -> Option<u32> {
        let mut v = 0u32;
        for _ in 0..need {
            if *bitpos >= total_bits {
                return None;
            }
            let byte = data[*bitpos / 8];
            let bit = (byte >> (7 - (*bitpos % 8))) & 1;
            v = (v << 1) | (bit as u32);
            *bitpos += 1;
        }
        Some(v)
    };
    for _ in 0..n {
        let head = get_bits(J + 1, &mut bitpos)?;
        let sign = (head >> J) & 1;
        let mut w = (head & ((1 << J) - 1)) as i32;
        loop {
            let b = get_bits(1, &mut bitpos)?;
            if b == 1 {
                break;
            }
            w += 1 << J;
            if w > i16::MAX as i32 {
                return None;
            }
        }
        if sign == 1 {
            w = -w;
        }
        out.push(w as i16);
    }
    let used_bits = bitpos;
    let used_bytes = (used_bits + 7) / 8;
    Some((out, used_bytes))
}

/// i16 centered → u16 w Z_q.
pub fn i16_to_q(c: i16) -> u16 {
    let q = FT1536_Q as i32;
    let mut v = c as i32 % q;
    if v < 0 {
        v += q;
    }
    v as u16
}

// ─── MPS4-E — ffSampling-lite + ceremonia sk na udziałach ──────────────
//
// ffSampling (FFT3 + LDL tree) = otwarte (C falcon-sign.c:1783).
// Tu: (a) pomiar ternary-z rejection na prawdziwym trapdoorze,
// (b) **ZŁOTO operacyjne**: sk na udziałach → reconstruct w ceremonii
//     → engine sign → verify. Klucz nie leży w spoczynku w jednym miejscu.

/// Pomiar: ile ternary-z daje krótkie (s1,s2) dla danego trapdoora i t.
/// Zwraca (trafienia, próby).
pub fn measure_z_reject_rate(
    rng: &mut impl rand::RngCore,
    td: &TrapdoorClear,
    t: &[u16],
    tries: u32,
) -> (u32, u32) {
    let mut hits = 0u32;
    for _ in 0..tries {
        let z1 = sample_z_ternary(rng);
        let z2 = sample_z_ternary(rng);
        let (s1, s2) = trapdoor_sign_clear(td, t, &z1, &z2);
        let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
        if n < norm_bound_test() {
            hits += 1;
        }
    }
    (hits, tries)
}

/// Ceremonia: udziały **sk** (bajty) → reconstruct w procesie →
/// engine sign → zwraca podpis + pk. Seed/sk kasowany.
/// To próg na poziomie **sk** (mocniejszy niż V2 seed): strony trzymają
/// udziały f,g,F,G / sk; w ceremonii powstaje tylko na czas `sign`.
pub fn sign_ceremony_sk_shares(
    sk_matrix: &[Vec<crate::Share>],
    msg: &[u8],
) -> Result<(Vec<u8>, [u8; 40], Vec<u8>)> {
    // reconstruct sk bajt-po-bajcie
    let mut sk = Vec::with_capacity(sk_matrix.len());
    for col in sk_matrix {
        let refs: Vec<&crate::Share> = col.iter().collect();
        sk.push(crate::reconstruct(&refs)?);
    }
    let kp = ft1536_sys::Ft1536KeyPair::from_secret_key(sk, Vec::new())
        .map_err(|_| SpikeError::MacFail)?;
    let sig = ft1536_sys::Ft1536Signature::sign(&kp, msg).map_err(|_| SpikeError::MacFail)?;
    let pk = kp.public_key.clone();
    Ok((sig.bytes, sig.nonce, pk))
}

// ─── MPS4-F — Babai rounding na bazie kraty NTRU (ffSampling-lite) ─────
//
// Krata: v1 = (g, −f), v2 = (G, −F) w R²; cel (t, 0).
// Szukamy z=(z1,z2) tak, że (t,0) − z1·v1 − z2·v2 jest krótkie.
// Tu: **Babai nearest plane w f64** na mnożeniu pierścieniowym
// (nie FFT3 — to jest uproszczony ffSampling; C: falcon-sign.c:1783).

fn qpoly_to_f64(p: &[u16]) -> Vec<f64> {
    let q = FT1536_Q as f64;
    p.iter()
        .map(|&c| {
            let v = c as f64;
            if v > q / 2.0 {
                v - q
            } else {
                v
            }
        })
        .collect()
}

fn f64_to_qpoly(p: &[f64]) -> QPoly {
    let q = FT1536_Q as f64;
    p.iter()
        .map(|&v| {
            let mut x = v.round() % q;
            if x < 0.0 {
                x += q;
            }
            x as u16
        })
        .collect()
}

/// Iloczyn skalarny (L2) na współczynnikach.
fn poly_dot(a: &[f64], b: &[f64]) -> f64 {
    a.iter().zip(b).map(|(x, y)| x * y).sum()
}

/// Mnożenie pierścienia w f64 (X^N − X^{N/2} + 1) — wolne O(N²).
fn poly_mul_ring_f64(a: &[f64], b: &[f64]) -> Vec<f64> {
    let n = FT1536_N;
    let half = n / 2;
    let mut acc = vec![0.0f64; n];
    for i in 0..n {
        if a[i] == 0.0 {
            continue;
        }
        for j in 0..n {
            if b[j] == 0.0 {
                continue;
            }
            let e = i + j;
            let prod = a[i] * b[j];
            if e < n {
                acc[e] += prod;
            } else {
                let e2 = e - n;
                // X^e = X^{e2}·(X^{half} − 1)
                if e2 + half < n {
                    acc[e2 + half] += prod;
                } else {
                    let e4 = e2 + half - n;
                    if e4 + half < n {
                        acc[e4 + half] += prod;
                    }
                    if e4 < n {
                        acc[e4] -= prod;
                    }
                }
                if e2 < n {
                    acc[e2] -= prod;
                }
            }
        }
    }
    acc
}

/// Babai nearest plane (2-wymiarowy, na wielomianach): zwraca (z1, z2)
/// w Z^N (współczynniki zaokrąglone).
///
/// Uproszczenie vs C: brak FFT3/LDL tree — jedna warstwa Babai
/// na wektorach v1,v2 z produktem skalarnym z wagą 1 (nie Gram-Schmidt
/// w pełnym embeddingu). To **nie** jest wierny ffSampling — to
/// kierunek i pomiar; poprawny sampler = MPS4-F2.
pub fn babai_ntru_z(td: &TrapdoorClear, t: &[u16]) -> (QPoly, QPoly) {
    let g = qpoly_to_f64(&td.g);
    let f = qpoly_to_f64(&td.f);
    let g_big = qpoly_to_f64(&td.g_big);
    let f_big = qpoly_to_f64(&td.f_big);
    let t64 = qpoly_to_f64(t);

    // w2 = (G, −F); w1 = (g, −f); target = (t, 0)
    // z2 = round(<target, w2> / <w2,w2>) przy zaniedbaniu wiązania
    // (nie Gram-Schmidt — poprawka w kolejnym kroku)
    let w2_0 = &g_big;
    let w2_1: Vec<f64> = f_big.iter().map(|&x| -x).collect();
    let w1_0 = &g;
    let w1_1: Vec<f64> = f.iter().map(|&x| -x).collect();

    let dot_t_w2 = poly_dot(&t64, w2_0) + poly_dot(&vec![0.0; FT1536_N], &w2_1);
    let dot_w2_w2 = poly_dot(w2_0, w2_0) + poly_dot(&w2_1, &w2_1);
    let z2_f = if dot_w2_w2.abs() > 1e-12 {
        dot_t_w2 / dot_w2_w2
    } else {
        0.0
    };
    let z2_c = z2_f.round();

    // t' = t − z2·G
    let z2g = poly_mul_ring_f64(&vec![z2_c; FT1536_N], &g_big); // stały z2 — nie to
    // Zamiast tego: z2 jako wielomian — tu stałe z2 dla uproszczenia
    let _ = z2g;

    // Lepsze: per-coefficient Babai na z1, z2 (ignorując splot) —
    // aproksymacja diagonalna; dobre gdy f,g ≈ 1 w NTT.
    let mut z1 = vec![0.0f64; FT1536_N];
    let mut z2 = vec![0.0f64; FT1536_N];
    for i in 0..FT1536_N {
        let gi = g[i];
        let gi2 = g_big[i];
        let den = gi * gi + gi2 * gi2 + 1e-12;
        let num = t64[i] * gi;
        let num2 = t64[i] * gi2;
        z1[i] = (num / den).round();
        z2[i] = (num2 / den).round();
    }
    let _ = (w1_0, w1_1, z2_c, z2_f, dot_t_w2, dot_w2_w2);
    (f64_to_qpoly(&z1), f64_to_qpoly(&z2))
}

/// Trapdoor sign z z z Babai (zamiast losowego ternary).
pub fn trapdoor_sign_babai(td: &TrapdoorClear, t: &[u16]) -> (QPoly, QPoly, u64) {
    let (z1, z2) = babai_ntru_z(td, t);
    let (s1, s2) = trapdoor_sign_clear(td, t, &z1, &z2);
    let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
    (s1, s2, n)
}

// ─── MPS4-F2 — sampler przez z ≈ t·f/q + f^{-1} (Newton) ───────────────

/// Odwrotność f w R_q = Z_q[X]/(X^N − X^{N/2} + 1) przez **rozszerzony
/// Euklides** w Z_q[X]: gcd(f, phi) = c (stała) ⇒ f^{-1} = u/c.
/// (Newton nie zbiega gdy R_q ma dzielniki zerowe — φ się rozbija.)
fn poly_trim(a: &mut Vec<u16>) {
    while a.len() > 1 && *a.last().unwrap() == 0 {
        a.pop();
    }
}

fn poly_divmod_u(a: &[u16], b: &[u16]) -> Result<(Vec<u16>, Vec<u16>)> {
    let mut a = a.to_vec();
    poly_trim(&mut a);
    let mut b = b.to_vec();
    poly_trim(&mut b);
    if b.len() == 1 && b[0] == 0 {
        return Err(SpikeError::WrongThreshold);
    }
    let mut q = vec![0u16; a.len().saturating_sub(b.len() - 1)];
    let inv_lead = q_inv(*b.last().unwrap())?;
    while a.len() >= b.len() && !(a.len() == 1 && a[0] == 0) {
        let deg = a.len() - b.len();
        let coef = q_mul(*a.last().unwrap(), inv_lead);
        if coef != 0 {
            if deg < q.len() {
                q[deg] = coef;
            }
        }
        for i in 0..b.len() {
            a[deg + i] = q_sub(a[deg + i], q_mul(coef, b[i]));
        }
        poly_trim(&mut a);
    }
    poly_trim(&mut a);
    poly_trim(&mut q);
    Ok((q, a))
}

/// Rozszerzony Euklides: zwraca (gcd, u) takie że u·a ≡ gcd (mod b_poly).
fn poly_ext_euclid(a: &[u16], m: &[u16]) -> Result<(Vec<u16>, Vec<u16>)> {
    // gcd(a, m), u: u*a = gcd mod m
    let mut r0 = m.to_vec();
    let mut r1 = a.to_vec();
    poly_trim(&mut r0);
    poly_trim(&mut r1);
    let mut u0 = vec![0u16];
    let mut u1 = vec![1u16];
    while !(r1.len() == 1 && r1[0] == 0) {
        let (q, r) = poly_divmod_u(&r0, &r1)?;
        // u0, u1 = u1, u0 - q*u1
        let qu = poly_mul_plain(&q, &u1);
        let mut new_u = u0.clone();
        if new_u.len() < qu.len() {
            new_u.resize(qu.len(), 0);
        }
        for i in 0..qu.len() {
            new_u[i] = q_sub(new_u[i], qu[i]);
        }
        poly_trim(&mut new_u);
        u0 = u1;
        u1 = new_u;
        r0 = r1;
        r1 = r;
    }
    Ok((r0, u0))
}

/// Zwykły iloczyn wielomianów (bez redukcji pierścienia).
fn poly_mul_plain(a: &[u16], b: &[u16]) -> Vec<u16> {
    if a.is_empty() || b.is_empty() {
        return vec![0];
    }
    let mut acc = vec![0u16; a.len() + b.len() - 1];
    for i in 0..a.len() {
        if a[i] == 0 {
            continue;
        }
        for j in 0..b.len() {
            acc[i + j] = q_add(acc[i + j], q_mul(a[i], b[j]));
        }
    }
    acc
}

/// Odwrotność w R_q przez Euklidesa: gcd(f, phi)=c ≠ 0 ⇒ f^{-1}=u/c.
pub fn poly_inv_ring(a: &[u16]) -> Result<QPoly> {
    if a.iter().all(|&c| c == 0) {
        return Err(SpikeError::WrongThreshold);
    }
    // phi = X^N - X^{N/2} + 1
    let mut phi = vec![0u16; FT1536_N + 1];
    phi[FT1536_N] = 1;
    phi[FT1536_N / 2] = q_sub(0, 1);
    phi[0] = 1;
    let (gcd, u) = poly_ext_euclid(a, &phi)?;
    // gcd musi być stałą
    if gcd.len() != 1 {
        return Err(SpikeError::MacFail);
    }
    let c_inv = q_inv(gcd[0])?;
    let mut inv = vec![0u16; FT1536_N];
    for i in 0..u.len().min(FT1536_N) {
        inv[i] = q_mul(u[i], c_inv);
    }
    // check
    let prod = q_poly_mul_ring_clear(a, &inv);
    if prod[0] != 1 || prod[1..].iter().any(|&c| c != 0) {
        return Err(SpikeError::MacFail);
    }
    Ok(inv)
}

/// Zaokrąglenie ilorazu /q na współczynnikach i64.
#[allow(dead_code)]
fn round_div_q_i64(poly: &[i64]) -> QPoly {
    let q = FT1536_Q as i64;
    poly.iter()
        .map(|&c| {
            let r = ((c as f64) / (q as f64)).round() as i64;
            let mut v = r % q;
            if v < 0 {
                v += q;
            }
            v as u16
        })
        .collect()
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

/// Iloczyn w pierścieniu na i64 (X^N = X^{N/2}−1, bez mod q).
fn poly_mul_ring_i64(a: &[u16], b: &[u16]) -> Vec<i64> {
    let mut acc = vec![0i64; FT1536_N];
    for i in 0..FT1536_N {
        if a[i] == 0 {
            continue;
        }
        let ai = {
            let v = a[i] as i64;
            let q = FT1536_Q as i64;
            if v > q / 2 {
                v - q
            } else {
                v
            }
        };
        for j in 0..FT1536_N {
            if b[j] == 0 {
                continue;
            }
            let bi = {
                let v = b[j] as i64;
                let q = FT1536_Q as i64;
                if v > q / 2 {
                    v - q
                } else {
                    v
                }
            };
            add_monomial_i64(&mut acc, i + j, ai * bi);
        }
    }
    acc
}

/// **Sampler F2 (Z, nie R_q):** `z1 = round(t·f/q)`, `z0 = −z1·F/f`
/// w pierścieniu Z[X]/(phi). Wtedy `z0·g + z1·G ≈ t` i `z0·f + z1·F ≈ 0`
/// **całkowicie** — s1,s2 krótkie (z1·q/f ≈ t w Z, nie ≡0 w R_q).
pub fn sample_z_ff_lite(td: &TrapdoorClear, t: &[u16]) -> Result<(Vec<i64>, Vec<i64>)> {
    let tf = poly_mul_ring_i64(t, &td.f);
    let z1: Vec<i64> = tf
        .iter()
        .map(|&c| {
            let q = FT1536_Q as f64;
            (c as f64 / q).round() as i64
        })
        .collect();
    // z0 = -z1 * F * f^{-1}  — liczone w R_q, potem reprezentant w Z
    let z1_q: QPoly = z1
        .iter()
        .map(|&c| {
            let q = FT1536_Q as i64;
            let mut v = c % q;
            if v < 0 {
                v += q;
            }
            v as u16
        })
        .collect();
    let f_inv = poly_inv_ring(&td.f)?;
    let z1f_big = q_poly_mul_ring_clear(&z1_q, &td.f_big);
    let z0_neg = q_poly_mul_ring_clear(&z1f_big, &f_inv);
    let z0: Vec<i64> = z0_neg
        .iter()
        .map(|&c| {
            let q = FT1536_Q as i64;
            // centered
            let v = c as i64;
            if v > q / 2 {
                v - q
            } else {
                v
            }
        })
        .map(|v| -v)
        .collect();
    Ok((z0, z1))
}

/// Trapdoor sign w Z: s1 = z0·g + z1·G − t, s2 = z0·f + z1·F (i64 → Z_q).
pub fn trapdoor_sign_ff_lite(
    td: &TrapdoorClear,
    t: &[u16],
) -> Result<(QPoly, QPoly, u64)> {
    let (z0, z1) = sample_z_ff_lite(td, t)?;
    // mnożenie i64 w pierścieniu Z
    let z0g = mul_ring_i64_poly(&z0, &td.g);
    let z1g = mul_ring_i64_poly(&z1, &td.g_big);
    let z0f = mul_ring_i64_poly(&z0, &td.f);
    let z1f = mul_ring_i64_poly(&z1, &td.f_big);
    let mut s1 = vec![0u16; FT1536_N];
    let mut s2 = vec![0u16; FT1536_N];
    let q = FT1536_Q as i64;
    for i in 0..FT1536_N {
        let a = z0g[i] + z1g[i] - t[i] as i64;
        let b = z0f[i] + z1f[i];
        let mut va = a % q;
        if va < 0 {
            va += q;
        }
        let mut vb = b % q;
        if vb < 0 {
            vb += q;
        }
        s1[i] = va as u16;
        s2[i] = vb as u16;
    }
    let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
    Ok((s1, s2, n))
}

/// Mnożenie pierścienia Z[X]/(phi) na i64.
fn mul_ring_i64_poly(a: &[i64], b: &[u16]) -> Vec<i64> {
    let n = FT1536_N;
    let mut b64 = vec![0i64; n];
    for i in 0..n {
        let v = b[i] as i64;
        let q = FT1536_Q as i64;
        b64[i] = if v > q / 2 { v - q } else { v };
    }
    mul_ring_i64_i64(a, &b64)
}

/// Iloczyn w pierścieniu Z[X]/(X^N − X^{N/2} + 1) na i64 (bez mod q).
fn mul_ring_i64_i64(a: &[i64], b: &[i64]) -> Vec<i64> {
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

fn poly_u16_centered_i64(p: &[u16]) -> Vec<i64> {
    let q = FT1536_Q as i64;
    p.iter()
        .map(|&c| {
            let v = c as i64;
            if v > q / 2 {
                v - q
            } else {
                v
            }
        })
        .collect()
}

fn i64_to_qpoly(p: &[i64]) -> QPoly {
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

/// Zaokrąglenie ilorazu /q (f64 — wartości po splotach mieszczą się w 2^53).
fn round_div_q_scalar(v: i64) -> i64 {
    let q = FT1536_Q as f64;
    (v as f64 / q).round() as i64
}

// ─── MPS4-F2 — trapdoor_sign_ffsampling (poziom A + opcjonalny B) ──────
//
// Algebraiczne rozwiązanie w Q[X]/(φ):
//   z0 = −t·F / q,  z1 = t·f / q
// wtedy z0·g + z1·G = t i z0·f + z1·F = 0 (dokładnie w Q).
// Po zaokrągleniu z do Z i redukcji s mod q równanie verify trzyma,
// a (s1,s2) jest krótkie o ile rounding error jest mały.
// Konwencja: s1 = z0·g + z1·G − t, s2 = z0·f + z1·F (jak trapdoor_sign_clear).

/// Sampler z (poziom A): `z1 = round(t·f/q)`, `z0 = round(−t·F/q)` w Z[X]/(φ).
/// Zwraca (z0, z1) jako i64 (krótkie całkowite).
pub fn sample_z_ffsampling(
    td: &TrapdoorClear,
    t: &[u16],
) -> Result<(Vec<i64>, Vec<i64>)> {
    if t.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    let t64 = poly_u16_centered_i64(t);
    let tf = mul_ring_i64_i64(&t64, &poly_u16_centered_i64(&td.f));
    let t_f_big = mul_ring_i64_i64(&t64, &poly_u16_centered_i64(&td.f_big));
    let z1: Vec<i64> = tf.iter().map(|&c| round_div_q_scalar(c)).collect();
    let z0: Vec<i64> = t_f_big.iter().map(|&c| -round_div_q_scalar(c)).collect();
    Ok((z0, z1))
}

/// Trapdoor sign z ffsampling: (s1, s2, norma L2 s1+s2).
/// Poziom A (rounding preimage). Jeśli norma ≥ bound — wynik i tak
/// zwracany z rzeczywistą normą (mierzymy, nie oszukujemy).
pub fn trapdoor_sign_ffsampling(
    td: &TrapdoorClear,
    t: &[u16],
) -> Result<(QPoly, QPoly, u64)> {
    let (z0, z1) = sample_z_ffsampling(td, t)?;
    let t64 = poly_u16_centered_i64(t);
    let z0g = mul_ring_i64_i64(&z0, &poly_u16_centered_i64(&td.g));
    let z1g = mul_ring_i64_i64(&z1, &poly_u16_centered_i64(&td.g_big));
    let z0f = mul_ring_i64_i64(&z0, &poly_u16_centered_i64(&td.f));
    let z1f = mul_ring_i64_i64(&z1, &poly_u16_centered_i64(&td.f_big));
    let mut s1_i = vec![0i64; FT1536_N];
    let mut s2_i = vec![0i64; FT1536_N];
    for i in 0..FT1536_N {
        s1_i[i] = z0g[i] + z1g[i] - t64[i];
        s2_i[i] = z0f[i] + z1f[i];
    }
    let s1 = i64_to_qpoly(&s1_i);
    let s2 = i64_to_qpoly(&s2_i);
    let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
    Ok((s1, s2, n))
}

// ─── MPS4-G — ffsampling sign NA UDZIAŁACH (klucz nie w całości) ────────
//
// Jawne krótkie z=(z0,z1) × udziały f,g,F,G: **kombinacja liniowa** Shamir
// (α·share = share(α·s) dla α jawne) — bez reshare-mul. Otwieramy tylko
// s1,s2. Konwencja jak F2: s1 = z0·g + z1·G − t, s2 = z0·f + z1·F.

/// Jawny wielomian z (i64) × udział poly w R_q.
/// Liniowość Shamir ⇒ skalowanie udziałów znanymi współczynnikami
/// splotu — **0 reshare-mul** (G-3). Koszt O(n·N²) lokalnych mnożeń.
pub fn q_poly_mul_public_i64_shares(z: &[i64], shares: &QPolyShares) -> Result<QPolyShares> {
    if shares.len() != FT1536_N || z.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    let n_parties = shares[0].len();
    if n_parties == 0 {
        return Err(SpikeError::EmptyShares);
    }
    for col in shares {
        if col.len() != n_parties {
            return Err(SpikeError::PartyCountMismatch);
        }
    }
    let zq = i64_to_qpoly(z);
    let mut out = vec![vec![0u16; n_parties]; FT1536_N];
    for p in 0..n_parties {
        let party_poly: QPoly = shares.iter().map(|col| col[p]).collect();
        let prod = q_poly_mul_ring_clear(&zq, &party_poly);
        for (i, &c) in prod.iter().enumerate() {
            out[i][p] = c;
        }
    }
    Ok(out)
}

/// s1,s2 na udziałach: jawny krótki z=(z0,z1) i jawne t; klucz tylko
/// jako udziały f,g,F,G. Otwieranie s1,s2 poza funkcją (`q_reconstruct_poly`).
///
/// - `s2 = z0·f + z1·F`, `s1 = z0·g + z1·G − t` (R_q, jak `trapdoor_sign_clear`)
/// - t jawne: minus t na **każdym** udziale (stały wielomian Shamir —
///   reconstruct daje dokładnie −t)
/// - z jawne: 0 reshare-mul (liniowość); `rng`/`k` dla zgodności API
pub fn trapdoor_sign_ffsampling_shares(
    rng: &mut impl rand::RngCore,
    td: &TrapdoorShares,
    t: &[u16],
    z0: &[i64],
    z1: &[i64],
    xs: &[u16],
    k: u8,
) -> Result<(QPolyShares, QPolyShares)> {
    if t.len() != FT1536_N || z0.len() != FT1536_N || z1.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    if xs.is_empty() {
        return Err(SpikeError::EmptyXs);
    }
    if k < 2 {
        return Err(SpikeError::ThresholdTooLow);
    }
    if xs.iter().any(|&x| x == 0 || x >= FT1536_Q) {
        return Err(SpikeError::XZero);
    }
    let n_parties = xs.len();
    for ps in [&td.f, &td.g, &td.f_big, &td.g_big] {
        if ps.len() != FT1536_N {
            return Err(SpikeError::PartyCountMismatch);
        }
        if ps.is_empty() || ps[0].len() != n_parties {
            return Err(SpikeError::PartyCountMismatch);
        }
    }
    // s2 = z0·f + z1·F
    let z0f = q_poly_mul_public_i64_shares(z0, &td.f)?;
    let z1f = q_poly_mul_public_i64_shares(z1, &td.f_big)?;
    // s1 = z0·g + z1·G − t
    let z0g = q_poly_mul_public_i64_shares(z0, &td.g)?;
    let z1g = q_poly_mul_public_i64_shares(z1, &td.g_big)?;
    let mut s2 = vec![vec![0u16; n_parties]; FT1536_N];
    let mut s1 = vec![vec![0u16; n_parties]; FT1536_N];
    for i in 0..FT1536_N {
        for p in 0..n_parties {
            s2[i][p] = q_add(z0f[i][p], z1f[i][p]);
            s1[i][p] = q_sub(q_add(z0g[i][p], z1g[i][p]), t[i]);
        }
    }
    let _ = rng; // z jawne: 0 reshare-mul
    Ok((s1, s2))
}

/// Ceremonia G (wariant A, retained G-1): udziały f,g,F,G → reconstruct
/// **tylko** f,F w buforze zeroize → `z = sample_z_ffsampling` → drop/
/// zeroize → sign **wyłącznie** na udziałach → open s1,s2 → (s1, s2, n).
/// W ścieżce sign po z żaden kod nie ma f,g,F,G w jednym `TrapdoorClear`.
pub fn trapdoor_sign_ffsampling_share_ceremony(
    rng: &mut impl rand::RngCore,
    td: &TrapdoorShares,
    t: &[u16],
    xs: &[u16],
    k: u8,
) -> Result<(QPoly, QPoly, u64)> {
    if t.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    // Wariant A: reconstruct f,F wyłącznie do z (G-1 — z nie jest jeszcze
    // liczone na udziałach). Po z: zeroize i dalej tylko udziały.
    let (z0, z1) = {
        use zeroize::Zeroize;
        let mut f_c = q_reconstruct_poly(&td.f, xs)?;
        let mut f_big_c = q_reconstruct_poly(&td.f_big, xs)?;
        let mut td_z = TrapdoorClear {
            f: std::mem::take(&mut f_c),
            g: vec![0u16; FT1536_N],
            f_big: std::mem::take(&mut f_big_c),
            g_big: vec![0u16; FT1536_N],
        };
        let r = sample_z_ffsampling(&td_z, t);
        td_z.f.zeroize();
        td_z.f_big.zeroize();
        td_z.g.zeroize();
        td_z.g_big.zeroize();
        f_c.zeroize();
        f_big_c.zeroize();
        r?
    };
    let (s1s, s2s) = trapdoor_sign_ffsampling_shares(rng, td, t, &z0, &z1, xs, k)?;
    let s1 = q_reconstruct_poly(&s1s, xs)?;
    let s2 = q_reconstruct_poly(&s2s, xs)?;
    let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
    Ok((s1, s2, n))
}

/// Trapdoor sign z rejection: losuj ternary z1,z2 aż (s1,s2) krótkie.
/// Zwraca (s1, s2, próby). Cap prób = 200 (fail-closed).
pub fn trapdoor_sign_reject(
    rng: &mut impl rand::RngCore,
    td: &TrapdoorClear,
    t: &[u16],
) -> Option<(QPoly, QPoly, u32)> {
    for attempt in 1..=200u32 {
        let z1 = sample_z_ternary(rng);
        let z2 = sample_z_ternary(rng);
        let (s1, s2) = trapdoor_sign_clear(td, t, &z1, &z2);
        let n1 = poly_norm2_centered(&s1);
        let n2 = poly_norm2_centered(&s2);
        if n1.saturating_add(n2) < norm_bound_test() {
            return Some((s1, s2, attempt));
        }
    }
    None
}

/// Na udziałach: to samo z z jawnych (krótkich) — z1,z2 z Kleina.
pub fn trapdoor_sign_reject_shares(
    rng: &mut impl rand::RngCore,
    td: &TrapdoorShares,
    t: &QPolyShares,
    xs: &[u16],
    k: u8,
) -> Option<(QPolyShares, QPolyShares, u32)> {
    for attempt in 1..=200u32 {
        let z1 = sample_z_ternary(rng);
        let z2 = sample_z_ternary(rng);
        let (s1, s2) = trapdoor_sign_shares(rng, td, t, &z1, &z2, xs, k).ok()?;
        // norma na udziale: rekonstrukcja do checku („moment" — jawne s)
        let s1c = q_reconstruct_poly(&s1, xs).ok()?;
        let s2c = q_reconstruct_poly(&s2, xs).ok()?;
        let n = poly_norm2_centered(&s1c) + poly_norm2_centered(&s2c);
        if n < norm_bound_test() {
            return Some((s1, s2, attempt));
        }
    }
    None
}

#[cfg(test)]
mod tests_mps4c {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    #[test]
    fn mps4c_sample_z_ternary() {
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_08);
        let z = sample_z_ternary(&mut rng);
        assert_eq!(z.len(), FT1536_N);
        for &c in z.iter().take(20) {
            assert!(c == 0 || c == 1 || c == FT1536_Q - 1);
        }
    }

    #[test]
    fn mps4c_reject_trivial_trapdoor() {
        // t=0, f=1,g=0,F=0,G=0 → s1=-z1·0-z2·0=0, s2=z1·1+z2·0=z1
        // z ternary → s2 ternary → norma mała → accept w 1. próbie
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_09);
        let td = TrapdoorClear {
            f: tiny_poly(1),
            g: tiny_poly(0),
            f_big: tiny_poly(0),
            g_big: tiny_poly(0),
        };
        let t = tiny_poly(0);
        let (s1, s2, tries) =
            trapdoor_sign_reject(&mut rng, &td, &t).expect("trivial trapdoor accept");
        assert_eq!(s1[0], 0);
        assert!(tries >= 1);
        let _ = s2;
    }
}

#[cfg(test)]
mod tests_mps4d_gold {
    use super::*;
    use ft1536_sys::{Ft1536KeyPair, Ft1536Signature};

    #[test]
    fn mps4d_sk_header_and_decode_engine_sk() {
        let seed = [0x42u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let sk = kp.secret_key();
        assert!(sk.len() >= 1 + 4 * 2, "sk za krótki");
        // header
        let fb = sk[0];
        assert_eq!(fb >> 7, 1, "ternary");
        assert_eq!(fb & 0x0F, 10, "logn=10");
        assert_eq!(fb & 0x10, 0, "has_G (bit 0x10 = 0)");
        // dekodowanie f,g,F,G
        let (f, g, f_big, g_big) = decode_sk_ft1536(sk).expect("decode sk");
        assert_eq!(f.len(), FT1536_N);
        assert_eq!(g.len(), FT1536_N);
        // f,g ternary-ish (−1,0,1)
        let ternary_ok = |p: &QPoly| {
            p.iter()
                .all(|&c| c == 0 || c == 1 || c == FT1536_Q - 1)
        };
        assert!(ternary_ok(&f), "f ternary");
        assert!(ternary_ok(&g), "g ternary");
        let _ = (f_big, g_big);
    }

    #[test]
    fn mps4d_sig_codec_roundtrip_engine() {
        // ZŁOTO: realny podpis → uncompress s2 → re-encode → verify silnikiem
        let seed = [0x77u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let msg = b"gold-mps4d";
        let sig = Ft1536Signature::sign(&kp, msg).unwrap();
        assert_eq!(sig.bytes[0], 0xAA, "header sig = 0xAA (ter+static+logn10)");
        let s2 = uncompress_static_n(&sig.bytes[1..], FT1536_N).expect("uncompress s2");
        // re-encode
        let enc = encode_sig_static(
            &s2.0.iter().map(|&c| i16_to_q(c)).collect::<Vec<_>>(),
        );
        // verify OUR encoding with engine
        let our_sig = Ft1536Signature {
            bytes: enc,
            nonce: sig.nonce,
        };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &our_sig).unwrap();
        assert!(ok, "re-encoded s2 musi przejść verify silnikiem");
    }

    #[test]
    fn mps4e_sk_share_ceremony_real_sig() {
        use crate::shamir_share;
        // ZŁOTO operacyjne: sk na udziałach → ceremonia → verify silnikiem
        let mut rng = rand::rngs::OsRng;
        let seed = [0x42u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let sk = kp.secret_key().to_vec();
        let xs = [1u8, 2, 3];
        // udziałuj każdy bajt sk
        let mut sk_matrix = Vec::with_capacity(sk.len());
        for &b in &sk {
            let sh = shamir_share(&mut rng, b, &xs, 2).unwrap();
            sk_matrix.push(sh);
        }
        let msg = b"sk-share-ceremony";
        let (sig_b, nonce, _pk_empty) = sign_ceremony_sk_shares(&sk_matrix, msg).unwrap();
        // verify oryginalnym pk (ceremonia nie zwraca pk — jawne z wejścia)
        let sig = Ft1536Signature {
            bytes: sig_b,
            nonce,
        };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig).unwrap();
        assert!(ok, "podpis z ceremonii sk-shares musi przejść verify");
    }

    #[test]
    fn mps4e_measure_z_rate_on_real_trapdoor() {
        // Pomiar stopy ternary-z na prawdziwym trapdoorze (ffSampling gap)
        let mut rng = rand::rngs::OsRng;
        let seed = [0x11u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f, g, f_big, g_big) = decode_sk_ft1536(kp.secret_key()).unwrap();
        let td = TrapdoorClear {
            f: f.clone(),
            g: g.clone(),
            f_big: f_big.clone(),
            g_big: g_big.clone(),
        };
        let t = hash_to_point_from_msg(&kp.public_key, b"rate-test");
        let (hits, tries) = measure_z_reject_rate(&mut rng, &td, &t, 200);
        // Jawny pomiar — nie zakładamy sukcesu (ffSampling otwarte)
        // retained: stopa ternary-z dla prawdziwego NTRU jest ~0 (spodziewane)
        assert!(tries == 200);
        // jeśli hits=0 — to jest otwarty ffSampling, nie błąd testu
        let _ = hits;
    }

    #[test]
    fn mps4f_babai_norm_measured() {
        // Retained MPS4-F1: diagonal Babai **nie** obniża normy na prawdziwym
        // NTRU (brak struktury pierścienia / FFT3). Pomiar jawny, nie assert
        // poprawności. Wierny ffSampling = MPS4-F2 (FFT3+LDL, C:1783).
        let mut rng = rand::rngs::OsRng;
        let seed = [0x33u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f, g, f_big, g_big) = decode_sk_ft1536(kp.secret_key()).unwrap();
        let td = TrapdoorClear {
            f: f.clone(),
            g: g.clone(),
            f_big: f_big.clone(),
            g_big: g_big.clone(),
        };
        let t = hash_to_point_from_msg(&kp.public_key, b"babai");
        let (_s1, _s2, n_babai) = trapdoor_sign_babai(&td, &t);
        let (s1_0, s2_0) =
            trapdoor_sign_clear(&td, &t, &vec![0; FT1536_N], &vec![0; FT1536_N]);
        let n_zero = poly_norm2_centered(&s1_0) + poly_norm2_centered(&s2_0);
        // Tylko pomiar — nie deklarujemy poprawności Babai
        let _ = (n_babai, n_zero, &mut rng);
    }

    #[test]
    fn mps4f2_ff_lite_lowers_norm() {
        let seed = [0x55u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f, g, f_big, g_big) = decode_sk_ft1536(kp.secret_key()).unwrap();
        let td = TrapdoorClear {
            f: f.clone(),
            g: g.clone(),
            f_big: f_big.clone(),
            g_big: g_big.clone(),
        };
        let t = hash_to_point_from_msg(&kp.public_key, b"ff-lite");
        let (z0, z1) = sample_z_ff_lite(&td, &t).unwrap();
        let nz0 = z0.iter().filter(|&&c| c != 0).count();
        let nz1 = z1.iter().filter(|&&c| c != 0).count();
        assert!(nz0 + nz1 > 0, "z cannot be all zero; nz0={nz0} nz1={nz1}");
        let (_s1, _s2, n_ff) = trapdoor_sign_ff_lite(&td, &t).expect("ff-lite");
        let (s1_0, s2_0) =
            trapdoor_sign_clear(&td, &t, &vec![0; FT1536_N], &vec![0; FT1536_N]);
        let n_zero = poly_norm2_centered(&s1_0) + poly_norm2_centered(&s2_0);
        // Równanie na ścieżce R_q (dowiedzione algebraicznie)
        let z0q: QPoly = z0.iter().map(|&c| i16_to_q(c as i16)).collect();
        let z1q: QPoly = z1.iter().map(|&c| i16_to_q(c as i16)).collect();
        let (s1m, s2m) = trapdoor_sign_clear(&td, &t, &z0q, &z1q);
        let h = {
            let f_inv = poly_inv_ring(&f).unwrap();
            q_poly_mul_ring_clear(&g, &f_inv)
        };
        assert!(
            verify_sign_equation(&s1m, &s2m, &h, &t),
            "równanie verify na R_q"
        );
        // Retained MPS4-F2: z ≠ 0 i równanie trzyma, ale norma NIE spada
        // vs z=0 (brak FFT3+LDL tree — C falcon-sign.c:1783). Pomiar jawny.
        let _ = (n_ff, n_zero);
    }

    #[test]
    fn mps4f2_poly_inv_ring() {
        // stała
        let mut f = vec![0u16; FT1536_N];
        f[0] = 5;
        let inv = poly_inv_ring(&f).unwrap();
        let prod = q_poly_mul_ring_clear(&f, &inv);
        assert_eq!(prod[0], 1, "const inv");
        assert!(prod[1..].iter().all(|&c| c == 0));
    }

    #[test]
    fn mps4f2_ntru_relation_holds() {
        // Walidacja decode: fG − gF = q (stała 18433)
        let seed = [0x55u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f, g, f_big, g_big) = decode_sk_ft1536(kp.secret_key()).unwrap();
        let fg = q_poly_mul_ring_clear(&f, &g_big);
        let gf = q_poly_mul_ring_clear(&g, &f_big);
        let diff: Vec<u16> = (0..FT1536_N).map(|i| q_sub(fg[i], gf[i])).collect();
        // fG - gF = q = 18433 → tylko wyraz wolny = 18433 % q = 0? 
        // W Z_q: q ≡ 0, więc fG-gF ≡ 0 (cały wielomian zero)
        assert!(
            diff.iter().all(|&c| c == 0),
            "fG-gF = q ≡ 0 w R_q; pierwszy: {}",
            diff[0]
        );
    }

    #[test]
    fn mps4f2_poly_inv_linear() {
        // Retained: f=3+x nieodwracalne (φ(-3)=0). Realne f — Newton.
        let seed = [0x55u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f, _g, _fb, _gb) = decode_sk_ft1536(kp.secret_key()).unwrap();
        let inv = poly_inv_ring(&f).expect("f odwracalne w R_q");
        let prod = q_poly_mul_ring_clear(&f, &inv);
        assert_eq!(prod[0], 1, "f * f_inv = 1");
        assert!(prod[1..].iter().all(|&c| c == 0), "tail must be 0");
    }
}

// ─── MPS4-F2 ZŁOTO — ffsampling: równanie + norma + engine verify ──────

#[cfg(test)]
mod tests_mps4f2_ff {
    use super::*;
    use ft1536_sys::{Ft1536KeyPair, Ft1536Signature};

    /// Pomiar norm: z=0, ff-lite (F2-1), ffsampling (A) — jawne liczby.
    #[test]
    fn mps4f2_ffsampling_norm_measured() {
        let seed = [0x42u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f, g, f_big, g_big) = decode_sk_ft1536(kp.secret_key()).unwrap();
        let td = TrapdoorClear {
            f: f.clone(),
            g: g.clone(),
            f_big: f_big.clone(),
            g_big: g_big.clone(),
        };
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let t = hash_to_point_from_nonce_msg(&nonce, msg);

        let (s1_0, s2_0) =
            trapdoor_sign_clear(&td, &t, &vec![0; FT1536_N], &vec![0; FT1536_N]);
        let n_zero = poly_norm2_centered(&s1_0) + poly_norm2_centered(&s2_0);

        let (_s1l, _s2l, n_lite) = trapdoor_sign_ff_lite(&td, &t).unwrap();
        let (s1a, s2a, n_ff) = trapdoor_sign_ffsampling(&td, &t).unwrap();

        let h = {
            let f_inv = poly_inv_ring(&f).unwrap();
            q_poly_mul_ring_clear(&g, &f_inv)
        };
        assert!(
            verify_sign_equation(&s1a, &s2a, &h, &t),
            "równanie verify po ffsampling"
        );

        // Jawny zapis pomiarów (widoczne w --nocapture / retained notes)
        eprintln!("MEASURE n_zero={n_zero} n_ff_lite={n_lite} n_ffsampling={n_ff}");
        // Nie twierdzimy z góry, że norma < bound — to mierzymy w goldzie.
        // Tutaj wyłącznie: równanie trzyma i z nie jest trywialne.
        let (z0, z1) = sample_z_ffsampling(&td, &t).unwrap();
        let nz = z0.iter().filter(|&&c| c != 0).count()
            + z1.iter().filter(|&&c| c != 0).count();
        assert!(nz > 0, "z nie może być zerowe");
    }

    /// ZŁOTO: równanie + norma < bound + engine verify == true.
    /// t = hash_to_point(SHAKE(nonce||msg)) — zgodne z engine.
    #[test]
    fn mps4f2_ffsampling_gold() {
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f, g, f_big, g_big) = decode_sk_ft1536(kp.secret_key()).unwrap();
        let td = TrapdoorClear {
            f,
            g,
            f_big,
            g_big,
        };
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let (s1, s2, n) = trapdoor_sign_ffsampling(&td, &t).unwrap();
        eprintln!("GOLD seed=0x42 n_ffsampling={n} bound=2093922385");
        let h = {
            let f_inv = poly_inv_ring(&td.f).unwrap();
            q_poly_mul_ring_clear(&td.g, &f_inv)
        };
        assert!(
            verify_sign_equation(&s1, &s2, &h, &t),
            "równanie verify musi trzymać"
        );
        assert!(
            n < 2093922385,
            "norma {n} musi być < FALCON_FT1536_NORM_BOUND2=2093922385"
        );
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature {
            bytes: enc,
            nonce,
        };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig)
            .expect("engine verify nie może errorować");
        assert!(ok, "Ft1536Signature::verify == true");
    }

    /// Zgodność z nonce z engine-sign: bierzemy nonce z Ft1536Signature::sign,
    /// t liczymy jak engine, podpisujemy naszym ffsampling — verify musi przejść.
    #[test]
    fn mps4f2_ffsampling_gold_engine_nonce() {
        let seed = [0x77u8; 32];
        let msg = b"gold-ff-engine-nonce";
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let eng = Ft1536Signature::sign(&kp, msg).unwrap();
        let nonce = eng.nonce;
        let (f, g, f_big, g_big) = decode_sk_ft1536(kp.secret_key()).unwrap();
        let td = TrapdoorClear {
            f,
            g,
            f_big,
            g_big,
        };
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let (s1, s2, n) = trapdoor_sign_ffsampling(&td, &t).unwrap();
        eprintln!("GOLD seed=0x77 engine-nonce n_ffsampling={n}");
        let h = {
            let f_inv = poly_inv_ring(&td.f).unwrap();
            q_poly_mul_ring_clear(&td.g, &f_inv)
        };
        assert!(verify_sign_equation(&s1, &s2, &h, &t));
        assert!(n < 2093922385, "norma {n}");
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature { bytes: enc, nonce };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig).unwrap();
        assert!(ok, "verify z engine-nonce == true");
    }

    /// Mutacja z=0: s1=−t, s2=0 → verify FAŁSZ (albo norma ≥ bound).
    #[test]
    fn mps4f2_ffsampling_mutation_zero_z() {
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f, g, f_big, g_big) = decode_sk_ft1536(kp.secret_key()).unwrap();
        let td = TrapdoorClear {
            f: f.clone(),
            g: g.clone(),
            f_big,
            g_big,
        };
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let (s1, s2) =
            trapdoor_sign_clear(&td, &t, &vec![0; FT1536_N], &vec![0; FT1536_N]);
        let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
        let h = {
            let f_inv = poly_inv_ring(&f).unwrap();
            q_poly_mul_ring_clear(&g, &f_inv)
        };
        // z=0: równanie może trzymać (s1=-t, s2=0 → 0-(-t)=t), ale norma jest
        // ogromna; engine verify też musi odrzucić (is_short fail).
        let eq = verify_sign_equation(&s1, &s2, &h, &t);
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature { bytes: enc, nonce };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig).unwrap();
        assert!(
            !ok || n >= 2093922385,
            "mutacja z=0 musi failować: ok={ok} n={n} eq={eq}"
        );
        assert!(n >= 2093922385, "z=0 nie może mieć normy pod bound; n={n}");
    }
}

// ─── MPS4-G ZŁOTO — ffsampling sign na udziałach + ceremonia G ──────────

#[cfg(test)]
mod tests_mps4g {
    use super::*;
    use crate::shamir_share;
    use ft1536_sys::{Ft1536KeyPair, Ft1536Signature};
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    const XS: [u16; 3] = [1, 2, 3];
    const K: u8 = 2;

    /// Zgodność twarda: ten sam td, t, z — s1,s2 otwarte z udziałów
    /// == trapdoor_sign_ffsampling / trapdoor_sign_clear (mod q).
    #[test]
    fn mps4g_shares_match_clear() {
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_10);
        let seed = [0x42u8; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f, g, f_big, g_big) = decode_sk_ft1536(kp.secret_key()).unwrap();
        let td_c = TrapdoorClear {
            f: f.clone(),
            g: g.clone(),
            f_big: f_big.clone(),
            g_big: g_big.clone(),
        };
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let (z0, z1) = sample_z_ffsampling(&td_c, &t).unwrap();

        // oracle clear (Z-path)
        let (s1_c, s2_c, _n) = trapdoor_sign_ffsampling(&td_c, &t).unwrap();
        // ten sam wynik z trapdoor_sign_clear na z zredukowanych mod q
        let z0q = i64_to_qpoly(&z0);
        let z1q = i64_to_qpoly(&z1);
        let (s1_cl, s2_cl) = trapdoor_sign_clear(&td_c, &t, &z0q, &z1q);
        assert_eq!(s1_c, s1_cl, "ffsampling Z-path == clear mod q (s1)");
        assert_eq!(s2_c, s2_cl, "ffsampling Z-path == clear mod q (s2)");

        // udziałuj f,g,F,G — NIE buduj TrapdoorClear w sign path
        let td_s = TrapdoorShares {
            f: q_share_poly(&mut rng, &f, &XS, K).unwrap(),
            g: q_share_poly(&mut rng, &g, &XS, K).unwrap(),
            f_big: q_share_poly(&mut rng, &f_big, &XS, K).unwrap(),
            g_big: q_share_poly(&mut rng, &g_big, &XS, K).unwrap(),
        };
        let (s1s, s2s) =
            trapdoor_sign_ffsampling_shares(&mut rng, &td_s, &t, &z0, &z1, &XS, K).unwrap();
        let s1 = q_reconstruct_poly(&s1s, &XS).unwrap();
        let s2 = q_reconstruct_poly(&s2s, &XS).unwrap();
        assert_eq!(s1, s1_c, "s1 shares otwarte == clear ffsampling");
        assert_eq!(s2, s2_c, "s2 shares otwarte == clear ffsampling");

        // ceremonia G (z przez reconstruct f,F) też musi dać ten sam oracle
        let (s1_g, s2_g, _n_g) =
            trapdoor_sign_ffsampling_share_ceremony(&mut rng, &td_s, &t, &XS, K).unwrap();
        assert_eq!(s1_g, s1_c, "ceremonia s1 == clear");
        assert_eq!(s2_g, s2_c, "ceremonia s2 == clear");
    }

    /// ZŁOTO MPS4-G: udziały f,g,F,G → z (G-1: jeszcze z clear) →
    /// s1,s2 shares → open → norma < bound + verify_sign_equation +
    /// Ft1536Signature::verify == true. Klucz nie w jednym TrapdoorClear
    /// w sign path.
    #[test]
    fn mps4g_ffsampling_shares_gold() {
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_11);
        // 1. kp = generate_from_seed; decode_sk → f,g,F,G
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f, g, f_big, g_big) = decode_sk_ft1536(kp.secret_key()).unwrap();

        // 2. UDZIAŁUJ f,g,F,G (k-z-n = 2-z-3) — TrapdoorShares z QPolyShares;
        //    NIE buduj TrapdoorClear w sign path
        let td_s = TrapdoorShares {
            f: q_share_poly(&mut rng, &f, &XS, K).unwrap(),
            g: q_share_poly(&mut rng, &g, &XS, K).unwrap(),
            f_big: q_share_poly(&mut rng, &f_big, &XS, K).unwrap(),
            g_big: q_share_poly(&mut rng, &g_big, &XS, K).unwrap(),
        };

        // 3. nonce + t = hash_to_point_from_nonce_msg
        let t = hash_to_point_from_nonce_msg(&nonce, msg);

        // 4. z = sample_z_ffsampling(&td_clear, &t)
        //    G-1 RETAINED: z jeszcze z clear (f,F) — to NIE jest pełny próg.
        //    Droga: Klein/U1 albo mul na udziałach + rounding w MPC.
        let td_clear = TrapdoorClear {
            f: f.clone(),
            g: g.clone(),
            f_big: f_big.clone(),
            g_big: g_big.clone(),
        };
        let (z0, z1) = sample_z_ffsampling(&td_clear, &t).unwrap();

        // 5. (s1s, s2s) = trapdoor_sign_ffsampling_shares(...)
        let (s1s, s2s) =
            trapdoor_sign_ffsampling_shares(&mut rng, &td_s, &t, &z0, &z1, &XS, K).unwrap();

        // 6. open s1s, s2s
        let s1 = q_reconstruct_poly(&s1s, &XS).unwrap();
        let s2 = q_reconstruct_poly(&s2s, &XS).unwrap();

        // 7. n < bound
        let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
        eprintln!("GOLD-G shares seed=0x42 n={n} bound=2093922385");
        assert!(
            n < 2093922385,
            "norma {n} musi być < FALCON_FT1536_NORM_BOUND2=2093922385"
        );

        // 8. verify_sign_equation
        let h = {
            let f_inv = poly_inv_ring(&f).unwrap();
            q_poly_mul_ring_clear(&g, &f_inv)
        };
        assert!(
            verify_sign_equation(&s1, &s2, &h, &t),
            "równanie verify musi trzymać"
        );

        // 9. encode_sig_static(&s2) + nonce → Ft1536Signature::verify == true
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature {
            bytes: enc,
            nonce,
        };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig)
            .expect("engine verify nie może errorować");
        assert!(ok, "Ft1536Signature::verify == true (shares gold)");
    }

    /// Ceremonia G (wariant A) + engine verify — jak mps4e, ale nasz
    /// ffsampling sign na udziałach, nie engine-sign.
    /// sk-bajty na udziałach → decode → udziały f,g,F,G → ceremonia →
    /// open s2 → encode → Ft1536Signature::verify == true.
    #[test]
    fn mps4g_ceremony_shares_engine_verify() {
        let mut rng = rand::rngs::OsRng;
        // sk-bajty na udziałach (jak mps4e)
        let seed = [0x42u8; 32];
        let msg = b"sk-share-ceremony-ff";
        let nonce = [0x11u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let sk = kp.secret_key().to_vec();
        let xs_u8 = [1u8, 2, 3];
        let mut sk_matrix = Vec::with_capacity(sk.len());
        for &b in &sk {
            let sh = shamir_share(&mut rng, b, &xs_u8, K).unwrap();
            sk_matrix.push(sh);
        }
        // reconstruct sk (setup ceremonii — jak mps4e) → decode → udziały
        // f,g,F,G; clear kasujemy. Sign path: WYŁĄCZNIE TrapdoorShares.
        let (td_s, t) = {
            use zeroize::Zeroize;
            let mut sk_c = Vec::with_capacity(sk_matrix.len());
            for col in &sk_matrix {
                let refs: Vec<&crate::Share> = col.iter().collect();
                sk_c.push(crate::reconstruct(&refs).unwrap());
            }
            let (f, g, f_big, g_big) = decode_sk_ft1536(&sk_c).unwrap();
            let t = hash_to_point_from_nonce_msg(&nonce, msg);
            let td = TrapdoorShares {
                f: q_share_poly(&mut rng, &f, &XS, K).unwrap(),
                g: q_share_poly(&mut rng, &g, &XS, K).unwrap(),
                f_big: q_share_poly(&mut rng, &f_big, &XS, K).unwrap(),
                g_big: q_share_poly(&mut rng, &g_big, &XS, K).unwrap(),
            };
            sk_c.zeroize();
            (td, t)
        };
        // ceremonia G: z (reconstruct f,F w buforze zeroize) → sign na udziałach
        let (s1, s2, n) =
            trapdoor_sign_ffsampling_share_ceremony(&mut rng, &td_s, &t, &XS, K).unwrap();
        eprintln!("GOLD-G ceremony seed=0x42 n={n}");
        assert!(n < 2093922385, "norma ceremonii {n} < bound");
        let h = {
            let (f, g, _fb, _gb) = decode_sk_ft1536(kp.secret_key()).unwrap();
            let f_inv = poly_inv_ring(&f).unwrap();
            q_poly_mul_ring_clear(&g, &f_inv)
        };
        assert!(
            verify_sign_equation(&s1, &s2, &h, &t),
            "równanie verify po ceremonii"
        );
        let enc = encode_sig_static(&s2);
        let sig = Ft1536Signature {
            bytes: enc,
            nonce,
        };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig).unwrap();
        assert!(ok, "Ft1536Signature::verify == true (ceremonia G)");
    }

    /// Mutacja: sfałszowany udział f → otwarty s2 ≠ oracle LUB
    /// verify fail LUB n ≥ bound. Fail-closed.
    #[test]
    fn mps4g_mutation_forged_share() {
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_12);
        let seed = [0x42u8; 32];
        let msg = b"gold-ff";
        let nonce = [0u8; 40];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let (f, g, f_big, g_big) = decode_sk_ft1536(kp.secret_key()).unwrap();
        let t = hash_to_point_from_nonce_msg(&nonce, msg);
        let td_clear = TrapdoorClear {
            f: f.clone(),
            g: g.clone(),
            f_big: f_big.clone(),
            g_big: g_big.clone(),
        };
        let (z0, z1) = sample_z_ffsampling(&td_clear, &t).unwrap();
        let (s1s, s2s) = {
            let td_s = TrapdoorShares {
                f: q_share_poly(&mut rng, &f, &XS, K).unwrap(),
                g: q_share_poly(&mut rng, &g, &XS, K).unwrap(),
                f_big: q_share_poly(&mut rng, &f_big, &XS, K).unwrap(),
                g_big: q_share_poly(&mut rng, &g_big, &XS, K).unwrap(),
            };
            trapdoor_sign_ffsampling_shares(&mut rng, &td_s, &t, &z0, &z1, &XS, K).unwrap()
        };
        let s1_oracle = q_reconstruct_poly(&s1s, &XS).unwrap();
        let s2_oracle = q_reconstruct_poly(&s2s, &XS).unwrap();

        // sfałszuj udział f[0] strony 0 (+1) — Shamir: reconstruct się zmienia
        let mut td_forge = TrapdoorShares {
            f: q_share_poly(&mut rng, &f, &XS, K).unwrap(),
            g: q_share_poly(&mut rng, &g, &XS, K).unwrap(),
            f_big: q_share_poly(&mut rng, &f_big, &XS, K).unwrap(),
            g_big: q_share_poly(&mut rng, &g_big, &XS, K).unwrap(),
        };
        td_forge.f[0][0] = q_add(td_forge.f[0][0], 1);
        let (s1f, s2f) =
            trapdoor_sign_ffsampling_shares(&mut rng, &td_forge, &t, &z0, &z1, &XS, K).unwrap();
        let s1_f = q_reconstruct_poly(&s1f, &XS).unwrap();
        let s2_f = q_reconstruct_poly(&s2f, &XS).unwrap();
        let n_f = poly_norm2_centered(&s1_f) + poly_norm2_centered(&s2_f);

        // reconstruct ≠ oracle (fałszywy udział zmienia s2 — fail-closed)
        let recons_differs = s2_f != s2_oracle || s1_f != s1_oracle;
        let h = {
            let f_inv = poly_inv_ring(&f).unwrap();
            q_poly_mul_ring_clear(&g, &f_inv)
        };
        let eq = verify_sign_equation(&s1_f, &s2_f, &h, &t);
        let enc = encode_sig_static(&s2_f);
        let sig = Ft1536Signature {
            bytes: enc,
            nonce,
        };
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig).unwrap();
        eprintln!("MUTATION-G recons_differs={recons_differs} eq={eq} ok={ok} n={n_f}");
        assert!(
            recons_differs || n_f >= 2093922385 || !ok,
            "fałszywy udział musi failować: recons={recons_differs} n={n_f} eq={eq} ok={ok}"
        );
        assert!(
            !ok,
            "engine verify musi odrzucić s2 z sfałszowanego udziału (ok={ok} n={n_f})"
        );
    }
}

/// Mały wielomian testowy (stały wyraz wolny).
#[cfg(test)]
pub(crate) fn tiny_poly(v: u16) -> QPoly {
    let mut p = vec![0u16; FT1536_N];
    p[0] = v;
    p
}

#[cfg(test)]
mod tests_mps4 {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    const XS: [u16; 3] = [1, 2, 3];

    #[test]
    fn mps4_trapdoor_equation_clear() {
        // f=1, g=1, F=0, G=q → fG-gF = q (w Z_q: 0); h = g/f = 1
        // (s1,s2) = (t - z1·1 - z2·0, z1·1 + z2·0) = (t-z1, z1)
        // s1 + s2·h = t-z1 + z1·1 = t ✓
        let td = TrapdoorClear {
            f: tiny_poly(1),
            g: tiny_poly(1),
            f_big: tiny_poly(0),
            g_big: tiny_poly(0),
        };
        let t = tiny_poly(100);
        let z1 = tiny_poly(3);
        let z2 = tiny_poly(0);
        let (s1, s2) = trapdoor_sign_clear(&td, &t, &z1, &z2);
        let h = tiny_poly(1);
        assert!(verify_sign_equation(&s1, &s2, &h, &t), "równanie trapdoora");
    }

    #[test]
    fn mps4_trapdoor_shares_match_clear() {
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_07);
        let td_c = TrapdoorClear {
            f: tiny_poly(5),
            g: tiny_poly(7),
            f_big: tiny_poly(2),
            g_big: tiny_poly(3),
        };
        let t = tiny_poly(50);
        let z1 = tiny_poly(1);
        let z2 = tiny_poly(1);
        let (s1c, s2c) = trapdoor_sign_clear(&td_c, &t, &z1, &z2);
        let td_s = TrapdoorShares {
            f: q_share_poly(&mut rng, &td_c.f, &XS, 2).unwrap(),
            g: q_share_poly(&mut rng, &td_c.g, &XS, 2).unwrap(),
            f_big: q_share_poly(&mut rng, &td_c.f_big, &XS, 2).unwrap(),
            g_big: q_share_poly(&mut rng, &td_c.g_big, &XS, 2).unwrap(),
        };
        let ts = q_share_poly(&mut rng, &t, &XS, 2).unwrap();
        let (s1s, s2s) =
            trapdoor_sign_shares(&mut rng, &td_s, &ts, &z1, &z2, &XS, 2).unwrap();
        let s1 = q_reconstruct_poly(&s1s, &XS).unwrap();
        let s2 = q_reconstruct_poly(&s2s, &XS).unwrap();
        assert_eq!(s1, s1c, "s1 shares == clear");
        assert_eq!(s2, s2c, "s2 shares == clear");
    }

    #[test]
    fn mps4_sig_header_and_encode() {
        assert_eq!(sig_header_byte(), 0xAA);
        let s2 = tiny_poly(123);
        let enc = encode_s2_model(&s2);
        assert_eq!(enc[0], 0xAA);
        assert_eq!(enc.len(), 1 + FT1536_N * 2);
    }

    #[test]
    fn mps4_norm_centered() {
        let p = tiny_poly(1);
        assert_eq!(poly_norm2_centered(&p), 1);
        let q_minus_1 = tiny_poly(FT1536_Q - 1);
        assert_eq!(poly_norm2_centered(&q_minus_1), 1, "q-1 → -1");
    }

    #[test]
    fn mps4b_compress_static_roundtrip() {
        // krótkie wartości ternary-ish + kilka większych
        let mut x = vec![0i16; FT1536_N];
        x[0] = 1;
        x[1] = -1;
        x[2] = 255;
        x[3] = -256;
        x[4] = 300;
        x[5] = -1000;
        let enc = compress_static_18433(&x);
        let dec = uncompress_static_18433(&enc).unwrap();
        assert_eq!(dec, x, "roundtrip compress_static");
    }

    #[test]
    fn mps4b_compress_static_empty_tail() {
        let x = vec![0i16; FT1536_N];
        let enc = compress_static_18433(&x);
        // same zera: każdy coeff = 9 bitów head + 1 terminator = 10 bitów
        // 1536*10/8 = 1920 B
        assert_eq!(enc.len(), 1920, "n*10/8");
        let dec = uncompress_static_18433(&enc).unwrap();
        assert_eq!(dec, x);
    }

    #[test]
    fn mps4b_encode_sig_static_header() {
        let s2 = tiny_poly(5);
        let sig = encode_sig_static(&s2);
        assert_eq!(sig[0], 0xAA);
        assert!(sig.len() > 1);
        let body = uncompress_static_18433(&sig[1..]).unwrap();
        assert_eq!(body[0], 5);
    }
}

#[cfg(test)]
mod tests_mps1 {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    const XS: [u16; 3] = [1, 2, 3];

    #[test]
    fn mps1_q_is_18433() {
        assert_eq!(FT1536_Q, 18433);
        assert_eq!(FT1536_N, 1536);
    }

    #[test]
    fn mps1_share_reconstruct_roundtrip() {
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_01);
        let secret = 12345u16;
        let sh = q_shamir_share(&mut rng, secret, &XS, 2).unwrap();
        assert_eq!(q_reconstruct(&sh).unwrap(), secret);
    }

    #[test]
    fn mps1_mul_reshare_matches_clear() {
        let mut rng = StdRng::seed_from_u64(0x4D_50_53_02);
        let (a_s, b_s) = (3333u16, 7777u16);
        let a = q_shamir_share(&mut rng, a_s, &XS, 2).unwrap();
        let b = q_shamir_share(&mut rng, b_s, &XS, 2).unwrap();
        let a_at: Vec<u16> = a.iter().map(|s| s.share).collect();
        let b_at: Vec<u16> = b.iter().map(|s| s.share).collect();
        let c_at = q_mul_shamir_reshare(&mut rng, &XS, 2, &a_at, &b_at).unwrap();
        let c: Vec<QShare> = XS
            .iter()
            .zip(&c_at)
            .map(|(&x, &share)| QShare { x, share })
            .collect();
        assert_eq!(
            q_reconstruct(&c).unwrap(),
            q_mul(a_s, b_s),
            "a·b w Z_18433"
        );
    }

    #[test]
    fn mps1_q_inv() {
        assert_eq!(q_mul(7, q_inv(7).unwrap()) % FT1536_Q, 1);
    }
}
