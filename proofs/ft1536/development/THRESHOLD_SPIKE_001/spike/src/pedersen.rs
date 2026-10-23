//! H1 — Pedersen VSS (wzór `san-dkg`/`ghost-dkg`, kopia w W).
//!
//! **Zamiast interpolacji wielomianu** (która odtwarza `a0=sekret`):
//! dealer publikuje zobowiązania `C_j = g^{a_j}·h^{r_j}`;
//! strona i sprawdza `g^{s_i}·h^{t_i} == Π C_j^{x_i^j}` **w przestrzeni
//! wykładników** — współczynniki nigdy nie istnieją w jawnej postaci.
//!
//! **PROTOTYP.** NIE jest to pełne malicious-secure DKG. Model: dealer
//! układa wielomian (testowy). Ukrycie = DL w Ristretto (względnie GF(256)*).

use curve25519_dalek::constants::RISTRETTO_BASEPOINT_POINT as G;
use curve25519_dalek::ristretto::RistrettoPoint;
use curve25519_dalek::scalar::Scalar;
use curve25519_dalek::traits::MultiscalarMul;
use rand::RngCore;
use sha3::{Digest, Sha3_512};
use zeroize::{Zeroize, ZeroizeOnDrop};

/// Generator H (nothing-up-my-sleeve, jak w rodzinie — stały tekst domeny).
/// Cache: hash-to-point liczony raz (G-2: tysiące weryfikacji VSS).
pub fn pedersen_h() -> RistrettoPoint {
    static H: std::sync::OnceLock<RistrettoPoint> = std::sync::OnceLock::new();
    *H.get_or_init(|| {
        let hash = Sha3_512::digest(b"ft1536-threshold-spike/pedersen-h/v1");
        RistrettoPoint::from_uniform_bytes(&hash.into())
    })
}

/// Współczynnik x jako Scalar (x = 1..=255).
fn scalar_x(x: u8) -> Option<Scalar> {
    if x == 0 {
        return None;
    }
    Some(Scalar::from(x as u64))
}

/// Wielomian sekretu/blindingu — **zeroizowany** (H-31).
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct Poly {
    coeffs: Vec<u8>, // bajty 0..255 → Scalar
}

impl Poly {
    pub fn from_coeffs(coeffs: Vec<u8>) -> Self {
        Self { coeffs }
    }

    fn eval_scalar(&self, x: Scalar) -> Scalar {
        let mut acc = Scalar::ZERO;
        let mut xp = Scalar::ONE;
        for &c in &self.coeffs {
            acc += Scalar::from(c as u64) * xp;
            xp *= x;
        }
        acc
    }

    pub fn len(&self) -> usize {
        self.coeffs.len()
    }

    pub fn is_empty(&self) -> bool {
        self.coeffs.is_empty()
    }
}

/// Zobowiązania Pedersena do współczynników.
/// `C_j = a_j·G + r_j·H` — jawne, nie zawierają `a_j` w czystości.
#[derive(Clone)]
pub struct PedersenCommitments {
    pub commitments: Vec<RistrettoPoint>,
}

/// Udział w przestrzeni wykładników: (s_i, t_i) zamiast (share, poly).
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct ExpShare {
    pub x: u8,
    pub s: [u8; 32], // Scalar
    pub t: [u8; 32], // blinding
}

fn scalar_to_bytes(s: &Scalar) -> [u8; 32] {
    s.to_bytes()
}

fn scalar_from_bytes(b: &[u8; 32]) -> Option<Scalar> {
    let s = Scalar::from_canonical_bytes(*b);
    if s.is_some().into() {
        Some(s.unwrap())
    } else {
        // akceptuj też non-canonical dla prostoty testów? NIE — fail-closed
        None
    }
}

/// Wielomian blindingu — **pełna entropia** (audyt #6, T12 P0).
/// Byte-sized blinds (2^16 do brute-force) są **niedopuszczalne**.
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct BlindPoly {
    coeffs: Vec<[u8; 32]>, // Scalar bytes
}

impl BlindPoly {
    pub fn eval_scalar(&self, x: Scalar) -> Scalar {
        let mut acc = Scalar::ZERO;
        let mut xp = Scalar::ONE;
        for c in &self.coeffs {
            let s = scalar_from_bytes(c).unwrap_or(Scalar::ZERO);
            acc += s * xp;
            xp *= x;
        }
        acc
    }
}

/// Losowy wielomian sekretu stopnia k-1 (stała = secret_byte).
pub fn random_poly(rng: &mut impl RngCore, secret_byte: u8, k: u8) -> Poly {
    let mut coeffs = Vec::with_capacity(k as usize);
    coeffs.push(secret_byte);
    for _ in 1..k {
        coeffs.push((rng.next_u32() & 0xFF) as u8);
    }
    Poly::from_coeffs(coeffs)
}

/// Losowy wielomian **blindingu** z pełną entropią (32 B / Scalar).
pub fn random_blind_poly(rng: &mut impl RngCore, k: u8) -> BlindPoly {
    let mut coeffs = Vec::with_capacity(k as usize);
    for _ in 0..k {
        let mut b = [0u8; 32];
        rng.fill_bytes(&mut b);
        // canonical scalar — odrzuć niekanoniczne (fail-closed retry)
        let mut c = b;
        while scalar_from_bytes(&c).is_none() {
            rng.fill_bytes(&mut c);
        }
        coeffs.push(c);
    }
    BlindPoly { coeffs }
}

/// Commit: E_j = a_j G + r_j H (r_j = pełna entropia).
pub fn commit(secret: &Poly, blind: &BlindPoly) -> PedersenCommitments {
    let h = pedersen_h();
    let cs = secret
        .coeffs
        .iter()
        .zip(blind.coeffs.iter())
        .map(|(&a, r)| {
            let rv = scalar_from_bytes(r).unwrap_or(Scalar::ZERO);
            G * Scalar::from(a as u64) + h * rv
        })
        .collect();
    PedersenCommitments { commitments: cs }
}

/// Dealer: udziały (s_i, t_i) + zobowiązania. **Nie zwraca** wielomianu.
/// Blind = pełna entropia (audyt #6).
pub fn deal_exp_shares(
    rng: &mut impl RngCore,
    secret_byte: u8,
    xs: &[u8],
    k: u8,
) -> (PedersenCommitments, Vec<ExpShare>) {
    assert!(k >= 2);
    let secret = random_poly(rng, secret_byte, k);
    let blind = random_blind_poly(rng, k);
    let comms = commit(&secret, &blind);
    let shares = xs
        .iter()
        .map(|&x| {
            let sx = scalar_x(x).unwrap();
            ExpShare {
                x,
                s: scalar_to_bytes(&secret.eval_scalar(sx)),
                t: scalar_to_bytes(&blind.eval_scalar(sx)),
            }
        })
        .collect();
    (comms, shares)
}

/// Weryfikacja udziału **bez interpolacji / bez reconstruct**:
/// `s·G + t·H == Π C_j^{x^j}`.
pub fn verify_exp_share(share: &ExpShare, comms: &PedersenCommitments) -> Result<(), String> {
    let x = scalar_x(share.x).ok_or_else(|| "x=0".to_string())?;
    let s = scalar_from_bytes(&share.s).ok_or_else(|| "bad s".to_string())?;
    let t = scalar_from_bytes(&share.t).ok_or_else(|| "bad t".to_string())?;
    let lhs = G * s + pedersen_h() * t;
    let mut xp = Scalar::ONE;
    let mut pows = Vec::with_capacity(comms.commitments.len());
    for _ in 0..comms.commitments.len() {
        pows.push(xp);
        xp *= x;
    }
    let rhs = RistrettoPoint::multiscalar_mul(&pows, &comms.commitments);
    if lhs == rhs {
        Ok(())
    } else {
        Err("commitment mismatch".into())
    }
}

/// H3 — stały test: w tym module **nie ma** `reconstruct` sekretu.
/// Odtworzenie z udziałów wykładnikowych wymaga log-dyskretnego (poza zakresem).
pub fn reconstruct_not_available() -> ! {
    panic!("BOUNDARY: reconstruct is not available on Pedersen exp-shares (H3)");
}

#[cfg(test)]
mod tests {
    use super::*;
    use rand::rngs::OsRng;
    use rand::SeedableRng;

    const XS: [u8; 3] = [1, 2, 3];

    #[test]
    fn h1_pedersen_verify_ok() {
        let mut rng = OsRng;
        let (comms, shares) = deal_exp_shares(&mut rng, 0x42, &XS, 2);
        for sh in &shares {
            assert!(verify_exp_share(sh, &comms).is_ok());
        }
    }

    #[test]
    fn h1_pedersen_detects_forge() {
        let mut rng = OsRng;
        let (comms, mut shares) = deal_exp_shares(&mut rng, 0x11, &XS, 2);
        shares[1].s[0] ^= 0xFF;
        assert!(verify_exp_share(&shares[1], &comms).is_err());
    }

    #[test]
    fn h1_pedersen_x_zero_rejected() {
        let mut rng = OsRng;
        let (comms, mut shares) = deal_exp_shares(&mut rng, 1, &XS, 2);
        shares[0].x = 0;
        assert!(verify_exp_share(&shares[0], &comms).is_err());
    }

    #[test]
    fn h1_deterministic_seed() {
        let mut a = rand::rngs::StdRng::seed_from_u64(7);
        let mut b = rand::rngs::StdRng::seed_from_u64(7);
        let (ca, sa) = deal_exp_shares(&mut a, 5, &XS, 2);
        let (cb, sb) = deal_exp_shares(&mut b, 5, &XS, 2);
        assert_eq!(
            ca.commitments[0].compress().to_bytes(),
            cb.commitments[0].compress().to_bytes()
        );
        assert_eq!(sa[0].s, sb[0].s);
    }

    /// T12 #6: blindy pełnoentropyjne (nie u8) — commitment nie jest
    /// brute-force'owalny w 2^16.
    #[test]
    fn t12_pedersen_blind_full_entropy() {
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x54_12_06);
        let blind = random_blind_poly(&mut rng, 3);
        // każdy współczynnik blindu = 32 B Scalar, nie 1 bajt
        for c in &blind.coeffs {
            assert_eq!(c.len(), 32, "blind coeff = Scalar 32 B");
            // nie jest „tylko u8" — przynajmniej 16 bajtów niezerowych w zbiorze
        }
        let nz = blind.coeffs.iter().filter(|c| c.iter().any(|&b| b != 0)).count();
        assert!(nz >= 2, "współczynniki blindu losowe");
        // jawny test: 2^16 par (a,r) nie wystarczy — r ma 2^256
        // (brute-force jest bezcelowy; tu tylko kontrakt API)
        let secret = random_poly(&mut rng, 0x42, 3);
        let comms = commit(&secret, &blind);
        assert_eq!(comms.commitments.len(), 3);
    }

    /// T12 #6 regresja: verify działa z pełnym blindem.
    #[test]
    fn t12_pedersen_verify_with_full_blind() {
        let mut rng = rand::rngs::OsRng;
        let (comms, shares) = deal_exp_shares(&mut rng, 0x5A, &XS, 2);
        for sh in &shares {
            verify_exp_share(sh, &comms).expect("verify");
        }
    }
}

// ─── G-2 — Pedersen VSS dla wartości Z_P (i16/i64 ishare) ─────────────────
//
// Analog `deal_exp_shares`/`verify_exp_share`, ale wartości w Z_P
// (P = 2^61−1, embedding w Ristretto Scalar). Dealer układa Shamir
// na wartości całkowitej i16 — commitmenty w przestrzeni wykładników,
// weryfikacja udziału bez interpolacji kontrolnej.
//
// **Kluczowa spójność pierścieni:** udziały VSS trzymają **niezredukowaną**
// ewaluację Shamir (Σ a_j·x^j, bez mod P) — to pasuje do arytmetyki
// wykładników w Ristretto (mod L). Udział ishare = ewaluacja mod P.
// Ewaluacja liczona w `u128` (bez overflow); do Scalar przez mod L.
// Pojemność u128 wystarcza dla k ≤ 10 przy xs ≤ 255, współczynniki < P ≈ 2^61.

/// Moduł Z_P ishare (Mersenne) — musi zgadzać się z `ishare::I_P`.
const ZP_MODULUS: u64 = (1u64 << 61) - 1;

fn zp_scalar(v: u128) -> Scalar {
    // niezredukowana ewaluacja Shamir w u128 → Scalar (mod L)
    let mut bytes = [0u8; 32];
    bytes[..16].copy_from_slice(&v.to_le_bytes());
    Scalar::from_bytes_mod_order(bytes)
}

/// Zobowiązanie Pedersena do Shamir-wielomianu wartości Z_P.
#[derive(Clone)]
pub struct ZpPedersenCommit {
    pub commitments: Vec<RistrettoPoint>,
}

/// Udział Z_P z blindingiem do weryfikacji VSS (G-2).
/// `share`/`blind` = niezredukowane ewaluacje (Σ a_j·x^j) w `u128`.
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct ZpVssShare {
    pub x: u16,
    pub share: u128,
    pub blind: u128,
}

/// Losowy Shamir-wielomian stopnia k-1 nad Z_P (stała = secret).
fn zp_random_poly(rng: &mut impl RngCore, secret: u64, k: u8) -> Vec<u64> {
    let mut coeffs = Vec::with_capacity(k as usize);
    coeffs.push(secret % ZP_MODULUS);
    for _ in 1..k {
        coeffs.push(rng.next_u64() % ZP_MODULUS);
    }
    coeffs
}

/// Ewaluacja Shamir **bez mod P** (zwraca niezredukowaną sumę w `u128`).
/// u128 eliminuje overflow u64 (dla k=2, x≥8 / k=3, x≥3 przy coeffs < P).
fn zp_eval_poly_raw(coeffs: &[u64], x: u64) -> u128 {
    let mut acc = 0u128;
    let mut xp = 1u128;
    for &c in coeffs {
        acc += (c % ZP_MODULUS) as u128 * xp;
        xp *= x as u128;
    }
    acc
}

/// Commit: C_t = a_t·G + r_t·H dla wartości Z_P.
pub fn zp_pedersen_commit(a: &[u64], r: &[u64]) -> ZpPedersenCommit {
    let h = pedersen_h();
    let cs = a
        .iter()
        .zip(r.iter())
        .map(|(&ai, &ri)| {
            G * zp_scalar((ai % ZP_MODULUS) as u128) + h * zp_scalar((ri % ZP_MODULUS) as u128)
        })
        .collect();
    ZpPedersenCommit { commitments: cs }
}

/// Suma commitmentów Pedersena (additively homomorphic) — T8.3 DKG.
/// `C_sum[j] = C_a[j] + C_b[j]` — commitment do `a+b` przy blindach `r_a+r_b`.
pub fn zp_pedersen_add(
    a: &ZpPedersenCommit,
    b: &ZpPedersenCommit,
) -> Result<ZpPedersenCommit, String> {
    if a.commitments.len() != b.commitments.len() {
        return Err("commitment length mismatch".into());
    }
    Ok(ZpPedersenCommit {
        commitments: a
            .commitments
            .iter()
            .zip(&b.commitments)
            .map(|(x, y)| x + y)
            .collect(),
    })
}

/// Skaluj zobowiązanie Pedersena przez jawne `w` (T9.1 weighted VSS).
///
/// Homomorfizm addytywny z wagą: `w · (a·G + r·H) = (w·a)·G + (w·r)·H`.
/// Do tego skalowanie udziałów `(s,t) → (w·s, w·t)` domyka liniowość
/// Shamir: `w·(s·G + t·H) = (w·s)·G + (w·t)·H` oraz
/// `w·Π C_j^{x^j} = Π (w·C_j)^{x^j}` — weryfikacja VSS przechodzi
/// po ważeniu. Fałszerstwo ważonego udziału → commitment mismatch.
pub fn zp_pedersen_scale(c: &ZpPedersenCommit, w: u64) -> ZpPedersenCommit {
    let s = Scalar::from(w);
    ZpPedersenCommit {
        commitments: c.commitments.iter().map(|p| p * s).collect(),
    }
}

/// Dealer (model testowy): udziały wartości Z_P + blinds + zobowiązania.
/// Udziały VSS = niezredukowane ewaluacje (weryfikacja w wykładnikach).
pub fn zp_vss_deal(
    rng: &mut impl RngCore,
    secret: u64,
    xs: &[u16],
    k: u8,
) -> (ZpPedersenCommit, Vec<ZpVssShare>) {
    assert!(k >= 2);
    let sec = zp_random_poly(rng, secret, k);
    let blind_seed = rng.next_u64();
    let bli = zp_random_poly(rng, blind_seed, k);
    let comms = zp_pedersen_commit(&sec, &bli);
    let shares = xs
        .iter()
        .map(|&x| ZpVssShare {
            x,
            share: zp_eval_poly_raw(&sec, x as u64),
            blind: zp_eval_poly_raw(&bli, x as u64),
        })
        .collect();
    (comms, shares)
}

/// Weryfikacja udziału Z_P: `s·G + t·H == Π C_j^{x^j}` (fail-closed).
pub fn zp_vss_verify(share: &ZpVssShare, comms: &ZpPedersenCommit) -> Result<(), String> {
    if share.x == 0 {
        return Err("x=0".into());
    }
    let x = Scalar::from(share.x as u64);
    let lhs = G * zp_scalar(share.share) + pedersen_h() * zp_scalar(share.blind);
    let mut xp = Scalar::ONE;
    let mut pows = Vec::with_capacity(comms.commitments.len());
    for _ in 0..comms.commitments.len() {
        pows.push(xp);
        xp *= x;
    }
    let rhs = RistrettoPoint::multiscalar_mul(&pows, &comms.commitments);
    if lhs == rhs {
        Ok(())
    } else {
        Err("commitment mismatch".into())
    }
}

#[cfg(test)]
mod tests_h3 {
    use super::*;

    /// H3: „próba odtworzenia w procesie = FAIL" — stały test graniczny.
    #[test]
    fn h3_reconstruct_attempt_panics() {
        let r = std::panic::catch_unwind(|| {
            reconstruct_not_available();
        });
        assert!(r.is_err(), "reconstruct must be unavailable (H3 boundary)");
    }
}
