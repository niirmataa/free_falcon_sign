//! R1 — accept-bit `a = 1{u < w}` z udziałów Shamira u i **publicznego** w.
//!
//! **Bez `reconstruct(u)` na tej ścieżce.** Jawny `accept_bit_from_u_opened`
//! (select.rs) otwiera u; to jest tor alternatywny.
//!
//! ## Dlaczego nie bit-split / nie compare w GF
//!
//! GF(256) to nie Z/256 — całkowite `u < w` nie wynika z arytmetyki pola.
//! Rozbicie u na bity na udziałach wymaga osobnego protokołu (bit-decomp),
//! którego ten spike nie ma. Uczciwe obejście z **istniejących** prymitywów:
//!
//! Predykat całkowity `j ↦ 1{j<w}` (j = wartość bajtowa elementu pola)
//! jest **funkcją GF(256)→GF(256)**; istnieje więc jedyny wielomian
//! `P_w` stopnia ≤255 z `P_w(j) = 1{j<w}` dla **każdego** j∈{0..255}.
//! Współczynniki `P_w` liczymy w czystości z publicznego w (to nie jest
//! compare „w GF" — rząd całkowity jest wtopiony w jawne współczynniki).
//! Potem **ewaluujemy P_w(u) na udziałach** (Horner + Beaver muls).
//!
//! Otwarcia na tej ścieżce: **wyłącznie maski Beavera (d,e)** — nigdy u,
//! nigdy bitów pośrednich. Wynik: udziały bitu a ∈ {0,1}.
//!
//! Domknięcie algebraiczne (GF(256), AES poly 0x11b):
//! `X^{256}+X = Π_{t∈GF}(X-t)`, a `Π_{t≠j}(j-t) = 1` (iloczyn niezerowych
//! elementów pola = 1 w char. 2). Stąd `P_w(X) = Σ_{j<w} Π_{t≠j}(X-t)`,
//! a `Q_j = Π_{t≠j}(X-t) = (X^{256}+X)/(X+j)` — syntetyczne dzielenie.

use crate::{
    generate_triple_shares, gf_mul, mask_one, reconstruct_vals, validate_xs, Share, SpikeError,
    Result,
};
use zeroize::Zeroizing;

/// Beaver: c = a·b dla wektorów udziałów. Otwiera **tylko** d,e (maski).
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

/// `Q_j` = Π_{t≠j}(X-t) jako 256 współczynników (little-endian).
fn quotient_all_but(j: u8) -> Vec<u8> {
    // A(X) = X^{256} + X, syntetyczne dzielenie przez (X + j) = (X - j).
    // b_{255} = a_{256}; b_{k-1} = a_k + j·b_k.
    let mut b = vec![0u8; 256];
    b[255] = 1u8; // a[256] = 1
    for k in (2..256).rev() {
        // a[k] = 0 dla k = 2..255
        b[k - 1] = gf_mul(j, b[k]);
    }
    // k = 1: a[1] = 1
    b[0] = 1u8 ^ gf_mul(j, b[1]);
    b
}

/// Współczynniki `P_w` (little-endian, len 256): `P_w(j) = 1{j < w}` dla j=0..255.
/// `w > 255` → `WrongThreshold` (w=256 → Err). `w = 0` → wielomian zerowy.
pub fn step_poly_coeffs(w: u32) -> Result<Vec<u8>> {
    if w > 255 {
        return Err(SpikeError::WrongThreshold);
    }
    let mut acc = vec![0u8; 256];
    for j in 0..w {
        let q = quotient_all_but(j as u8);
        for i in 0..256 {
            acc[i] ^= q[i];
        }
    }
    Ok(acc)
}

/// a = 1{u < w} z udziałów u i publicznego w — **bez reconstruct(u)**.
///
/// 1. k+1 consistency (`verify_consistency`, eval tylko w x≠0 — brak f(0)).
/// 2. Horner `P_w` na udziałach: `acc ← acc·u ⊕ c_i` (Beaver; jawne d,e = maski).
///
/// Zwraca udziały bitu. Fail-closed: zły próg / zły kształt / niespójny udział → Err.
pub fn accept_bit_from_u_shares_probed(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
    u_shares: &[u8],
    w: u32,
) -> Result<Vec<u8>> {
    validate_xs(xs, k)?;
    let n = xs.len();
    if u_shares.len() != n {
        return Err(SpikeError::PartyCountMismatch);
    }
    if w > 255 {
        return Err(SpikeError::WrongThreshold);
    }
    // k+1 consistency — bez interpolacji f(0)
    if n as u8 > k {
        let owned: Vec<Share> = xs
            .iter()
            .zip(u_shares.iter())
            .map(|(&x, &y)| Share { x, share: y })
            .collect();
        let refs: Vec<&Share> = owned.iter().collect();
        crate::verify_consistency(&refs, k)?;
    }
    if w == 0 {
        // P_0 ≡ 0 — pusty Σ; strzałka z kontraktu, nie skrót sekretu.
        return Ok(vec![0u8; n]);
    }
    let c = step_poly_coeffs(w)?;
    // Horner: acc = c_255; acc = acc·u + c_i (publiczna stała = lokalny XOR)
    let mut acc = Zeroizing::new(vec![c[255]; n]);
    for i in (0..255).rev() {
        let prod = mul_vec(rng, xs, k, &acc, u_shares)?;
        for p in 0..n {
            acc[p] = prod[p] ^ c[i];
        }
    }
    Ok(acc.to_vec())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::shamir_share;
    use rand::rngs::OsRng;

    fn eval_poly_clear(coeffs: &[u8], x: u8) -> u8 {
        let mut y = 0u8;
        for &c in coeffs.iter().rev() {
            y = gf_mul(y, x) ^ c;
        }
        y
    }

    fn bit_of(shares: &[u8], xs: &[u8]) -> u8 {
        let owned: Vec<Share> = xs
            .iter()
            .zip(shares.iter())
            .map(|(&x, &y)| Share { x, share: y })
            .collect();
        let refs: Vec<&Share> = owned.iter().collect();
        crate::reconstruct(&refs).unwrap()
    }

    /// Wektor P_w musi zgadzać się z 1{j<w} na **każdym** elemencie pola.
    #[test]
    fn r1_step_poly_matches_int_order() {
        for w in [0u32, 1, 2, 3, 20, 128, 254, 255] {
            let c = step_poly_coeffs(w).unwrap();
            assert_eq!(c.len(), 256);
            for j in 0..256u32 {
                let got = eval_poly_clear(&c, j as u8);
                let want = if j < w { 1u8 } else { 0u8 };
                assert_eq!(got, want, "P_{w}({j}) = {got}, want {want}");
            }
        }
    }

    #[test]
    fn r1_accept_boundaries() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let k = 2u8;
        let w = 20u32;
        // u == w → 0
        let us = shamir_share(&mut rng, 20, &xs, k).unwrap();
        let a = accept_bit_from_u_shares_probed(&mut rng, &xs, k, &us.iter().map(|s| s.share).collect::<Vec<_>>(), w)
            .unwrap();
        assert_eq!(bit_of(&a, &xs), 0, "u==w must reject");
        // u == w-1 → 1
        let us = shamir_share(&mut rng, 19, &xs, k).unwrap();
        let a = accept_bit_from_u_shares_probed(&mut rng, &xs, k, &us.iter().map(|s| s.share).collect::<Vec<_>>(), w)
            .unwrap();
        assert_eq!(bit_of(&a, &xs), 1, "u==w-1 must accept");
    }

    #[test]
    fn r1_accept_zero_and_max() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let k = 2u8;
        // u = 0, w ≥ 1 → 1
        let us = shamir_share(&mut rng, 0, &xs, k).unwrap();
        let a = accept_bit_from_u_shares_probed(&mut rng, &xs, k, &us.iter().map(|s| s.share).collect::<Vec<_>>(), 255)
            .unwrap();
        assert_eq!(bit_of(&a, &xs), 1, "u=0 < w=255");
        // u = 255: 255 < w ≤ 255 nigdy — a=0 dla każdego dopuszczonego w
        let us = shamir_share(&mut rng, 255, &xs, k).unwrap();
        let a = accept_bit_from_u_shares_probed(&mut rng, &xs, k, &us.iter().map(|s| s.share).collect::<Vec<_>>(), 255)
            .unwrap();
        assert_eq!(bit_of(&a, &xs), 0, "u=255 must reject for w≤255");
        let a = accept_bit_from_u_shares_probed(&mut rng, &xs, k, &us.iter().map(|s| s.share).collect::<Vec<_>>(), 1)
            .unwrap();
        assert_eq!(bit_of(&a, &xs), 0, "u=255 must reject for w=1");
    }

    #[test]
    fn r1_w_256_err_and_guards() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let k = 2u8;
        let us = shamir_share(&mut rng, 1, &xs, k).unwrap();
        let shares: Vec<u8> = us.iter().map(|s| s.share).collect();
        assert_eq!(
            accept_bit_from_u_shares_probed(&mut rng, &xs, k, &shares, 256)
                .map(|_| ())
                .unwrap_err(),
            SpikeError::WrongThreshold,
            "w=256 must Err"
        );
        assert_eq!(
            accept_bit_from_u_shares_probed(&mut rng, &xs, k, &[1, 2], 10)
                .map(|_| ())
                .unwrap_err(),
            SpikeError::PartyCountMismatch
        );
    }

    #[test]
    fn r1_forged_u_share_detected() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3, 4];
        let k = 2u8;
        let us = shamir_share(&mut rng, 5, &xs, k).unwrap();
        let mut shares: Vec<u8> = us.iter().map(|s| s.share).collect();
        shares[3] ^= 0x5A;
        assert_eq!(
            accept_bit_from_u_shares_probed(&mut rng, &xs, k, &shares, 10)
                .map(|_| ())
                .unwrap_err(),
            SpikeError::InconsistentShare
        );
    }
}

/// K3 — SHAKE w MPC: **nie zaimplementowane w spiku** (koszt 10³–10⁵ × G_frag
/// na perm — `I3_SHAKE_MPC_COST.md`). Stub fail-closed zamiast udawania.
pub fn shake256_share_native(_u_shares: &[u8], _out_len: usize) -> Result<Vec<u8>> {
    Err(SpikeError::WrongThreshold) // K3: nie w spiku — I3_SHAKE_MPC_COST.md
}

#[cfg(test)]
mod tests_k3 {
    #[test]
    fn k3_shake_stub_fail_closed() {
        assert!(super::shake256_share_native(&[0; 3], 32).is_err());
    }
}
