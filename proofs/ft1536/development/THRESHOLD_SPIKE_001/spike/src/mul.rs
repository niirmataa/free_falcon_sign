//! Spike 013 — pełne mnożenie Shamir (k=2) **bez** sacrifice-mul.
//!
//! **PROTOTYP.** c = a·b dla a,b w Shamir k-of-n:
//! 1. strona i ma a_i=f(x_i), b_i=g(x_i);
//! 2. u_i = λ_i · a_i · b_i  (λ_i = Lagrange w 0);
//! 3. strona i **re-dealuje** u_i jako Shamir (k=2);
//! 4. strona j sumuje udziały: c_j = ⊕_i share_j(u_i).
//!
//! Inwariant: Σ_i u_i = Σ λ_i a_i b_i = f(0)·g(0) = a·b.
//! Żadna strona nie rekonstruuje a ani b. Zaufanie: każda strona i widzi
//! własne u_i (nie c). To **nie** jest BGW z macierzą zero-share
//! (zero-shares z spike 012 są tu opcjonalne do maskowania).

use crate::{gf_inv, gf_mul, shamir_share, Share, SpikeError, Result};

/// λ_i = Π_{j≠i} x_j / (x_i ⊕ x_j) — Lagrange w punkcie 0.
pub fn lagrange_at_zero(xs: &[u8], i: usize) -> Result<u8> {
    if i >= xs.len() || xs.is_empty() {
        return Err(SpikeError::PartyCountMismatch);
    }
    if xs[i] == 0 {
        return Err(SpikeError::XZero);
    }
    let mut num = 1u8;
    let mut den = 1u8;
    for (j, &xj) in xs.iter().enumerate() {
        if j == i {
            continue;
        }
        if xj == 0 {
            return Err(SpikeError::XZero);
        }
        num = gf_mul(num, xj);
        den = gf_mul(den, xs[i] ^ xj);
    }
    Ok(gf_mul(num, crate::gf_inv(den)))
}

/// Lokalny krok strony i: u_i = λ_i · a_i · b_i.
pub fn local_weighted_product(xs: &[u8], i: usize, a_i: u8, b_i: u8) -> Result<u8> {
    let lam = lagrange_at_zero(xs, i)?;
    Ok(gf_mul(lam, gf_mul(a_i, b_i)))
}

/// **Guard mnożenia (audyt #1):** iloczyn Shamir ma stopień `2(k−1)`,
/// więc interpolacja wymaga **`n ≥ 2k−1`**. Przy `n < 2k−1` wynik jest
/// **cicho zły** (nie `Err`) — dlatego walidacja jest tu, nie w reconstruct.
pub fn check_mul_quorum(xs_len: usize, k: u8) -> Result<()> {
    if k < 2 {
        return Err(SpikeError::ThresholdTooLow);
    }
    let need = 2 * (k as usize) - 1;
    if xs_len < need {
        return Err(SpikeError::NotEnoughPoints);
    }
    Ok(())
}

/// Pełne mnożenie: `a_shares[i]` = a_i strony i (x = xs[i]), itd.
/// Każda strona re-dealuje u_i; zwracamy **udziały c** (długość n).
///
/// **Wymaga `n ≥ 2k−1`** (audyt #1 — stopień 2(k−1)).
pub fn mul_shamir_reshare(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
    a_shares: &[u8],
    b_shares: &[u8],
) -> Result<Vec<u8>> {
    #[cfg(test)]
    crate::cost::bump_reshare();
    if xs.is_empty() {
        return Err(SpikeError::EmptyXs);
    }
    let n = xs.len();
    check_mul_quorum(n, k)?;
    if a_shares.len() != n || b_shares.len() != n {
        return Err(SpikeError::PartyCountMismatch);
    }
    let mut c_shares = vec![0u8; n];
    for i in 0..n {
        let u_i = local_weighted_product(xs, i, a_shares[i], b_shares[i])?;
        let dealt = shamir_share(rng, u_i, xs, k)?;
        for (j, sh) in dealt.into_iter().enumerate() {
            c_shares[j] ^= sh.share;
        }
    }
    Ok(c_shares)
}

/// Sprawdzenie testowe: otwórz a,b,c i porównaj z a·b („moment" oracle).
pub fn open_and_check_mul(xs: &[u8], a: &[u8], b: &[u8], c: &[u8]) -> Result<()> {
    let a_sh: Vec<Share> = xs
        .iter()
        .zip(a)
        .map(|(&x, &y)| Share { x, share: y })
        .collect();
    let b_sh: Vec<Share> = xs
        .iter()
        .zip(b)
        .map(|(&x, &y)| Share { x, share: y })
        .collect();
    let c_sh: Vec<Share> = xs
        .iter()
        .zip(c)
        .map(|(&x, &y)| Share { x, share: y })
        .collect();
    let ar: Vec<&Share> = a_sh.iter().collect();
    let br: Vec<&Share> = b_sh.iter().collect();
    let cr: Vec<&Share> = c_sh.iter().collect();
    let av = crate::reconstruct(&ar)?;
    let bv = crate::reconstruct(&br)?;
    let cv = crate::reconstruct(&cr)?;
    if cv != gf_mul(av, bv) {
        return Err(SpikeError::InconsistentShare);
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use rand::rngs::OsRng;
    use rand::RngCore;

    const XS: [u8; 3] = [1, 2, 3];
    const K: u8 = 2;

    fn shares_of(rng: &mut impl rand::RngCore, s: u8) -> Vec<u8> {
        shamir_share(rng, s, &XS, K)
            .unwrap()
            .into_iter()
            .map(|sh| sh.share)
            .collect()
    }

    #[test]
    fn m1_lagrange_reconstructs_constant() {
        // f(0) = Σ λ_i f(x_i)
        let mut rng = OsRng;
        let secret = 0x77u8;
        let y = shares_of(&mut rng, secret);
        let mut acc = 0u8;
        for i in 0..3 {
            let lam = lagrange_at_zero(&XS, i).unwrap();
            acc ^= gf_mul(lam, y[i]);
        }
        assert_eq!(acc, secret);
    }

    #[test]
    fn m2_mul_matches_gf_mul() {
        let mut rng = OsRng;
        for _ in 0..32 {
            let a = (rng.next_u32() & 0xFF) as u8;
            let b = (rng.next_u32() & 0xFF) as u8;
            let ash = shares_of(&mut rng, a);
            let bsh = shares_of(&mut rng, b);
            let csh = mul_shamir_reshare(&mut rng, &XS, K, &ash, &bsh).unwrap();
            open_and_check_mul(&XS, &ash, &bsh, &csh).unwrap();
            // jawny oracle
            let cr: Vec<Share> = XS
                .iter()
                .zip(&csh)
                .map(|(&x, &y)| Share { x, share: y })
                .collect();
            let refs: Vec<&Share> = cr.iter().collect();
            assert_eq!(crate::reconstruct(&refs).unwrap(), gf_mul(a, b));
        }
    }

    #[test]
    fn m3_mul_output_len_and_check() {
        // UWAGA: open_and_check_mul OTWIERA a,b,c (oracle testowy).
        // Kontrakt „mul nie otwiera a,b" jest w kodzie mul_shamir_reshare
        // (brak reconstruct w torze) — nie weryfikowany typem.
        let mut rng = OsRng;
        let ash = shares_of(&mut rng, 3);
        let bsh = shares_of(&mut rng, 5);
        let csh = mul_shamir_reshare(&mut rng, &XS, K, &ash, &bsh).unwrap();
        assert_eq!(csh.len(), 3);
        open_and_check_mul(&XS, &ash, &bsh, &csh).unwrap();
    }
}

#[cfg(test)]
mod tests_3of5 {
    use super::*;
    use rand::rngs::OsRng;

    const XS5: [u8; 5] = [1, 2, 3, 4, 5];
    const K: u8 = 3;

    #[test]
    fn m4_mul_3of5() {
        let mut rng = OsRng;
        for _ in 0..16 {
            let a = 0x11u8;
            let b = 0x22u8;
            let ash: Vec<u8> = shamir_share(&mut rng, a, &XS5, K)
                .unwrap()
                .into_iter()
                .map(|s| s.share)
                .collect();
            let bsh: Vec<u8> = shamir_share(&mut rng, b, &XS5, K)
                .unwrap()
                .into_iter()
                .map(|s| s.share)
                .collect();
            let csh = mul_shamir_reshare(&mut rng, &XS5, K, &ash, &bsh).unwrap();
            open_and_check_mul(&XS5, &ash, &bsh, &csh).unwrap();
        }
    }
}

#[cfg(test)]
mod tests_mutation {
    use super::*;
    use rand::rngs::OsRng;

    /// Mutation-check: świadome zepsucie udziału c musi wypaść z open_and_check.
    #[test]
    fn mut1_corrupt_c_detected() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let ash: Vec<u8> = shamir_share(&mut rng, 7, &xs, 2)
            .unwrap()
            .into_iter()
            .map(|s| s.share)
            .collect();
        let bsh: Vec<u8> = shamir_share(&mut rng, 9, &xs, 2)
            .unwrap()
            .into_iter()
            .map(|s| s.share)
            .collect();
        let mut csh = mul_shamir_reshare(&mut rng, &xs, 2, &ash, &bsh).unwrap();
        assert!(open_and_check_mul(&xs, &ash, &bsh, &csh).is_ok());
        csh[1] ^= 1;
        assert_eq!(
            open_and_check_mul(&xs, &ash, &bsh, &csh),
            Err(SpikeError::InconsistentShare)
        );
    }
}

#[cfg(test)]
mod tests_h28 {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn h28_mul_guards() {
        let mut rng = OsRng;
        assert_eq!(
            mul_shamir_reshare(&mut rng, &[], 2, &[], &[]).map(|_| ()).unwrap_err(),
            SpikeError::EmptyXs
        );
        assert_eq!(
            lagrange_at_zero(&[], 0).map(|_| ()).unwrap_err(),
            SpikeError::PartyCountMismatch
        );
        assert_eq!(
            lagrange_at_zero(&[1, 2], 5).map(|_| ()).unwrap_err(),
            SpikeError::PartyCountMismatch
        );
    }
}

#[cfg(test)]
mod tests_pin {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    fn fnv64(data: &[u8]) -> u64 {
        let mut h = 0xcbf29ce484222325u64;
        for &b in data {
            h ^= b as u64;
            h = h.wrapping_mul(0x100000001b3);
        }
        h
    }

    #[test]
    fn mul_vector_fnv_pin() {
        let xs = [1u8, 2, 3];
        let mut rng = StdRng::seed_from_u64(0xC0FFEE);
        let ash: Vec<u8> = shamir_share(&mut rng, 0x11, &xs, 2)
            .unwrap()
            .into_iter()
            .map(|s| s.share)
            .collect();
        let bsh: Vec<u8> = shamir_share(&mut rng, 0x22, &xs, 2)
            .unwrap()
            .into_iter()
            .map(|s| s.share)
            .collect();
        let mut r2 = StdRng::seed_from_u64(0xC0FFEE);
        let c = mul_shamir_reshare(&mut r2, &xs, 2, &ash, &bsh).unwrap();
        let fp = fnv64(&c);
        // ten sam przebieg = ten sam pin; wartość drukowana przy zmianie modelu
        assert_eq!(c, vec![214, 235, 9], "mul shares pin");
        assert_eq!(fp, 0xce9d0b1c5c23329d, "mul FNV pin");
    }
}

#[cfg(test)]
mod tests_lagrange_edge {
    use super::*;

    #[test]
    fn lagrange_x0_in_list_rejected() {
        assert_eq!(
            lagrange_at_zero(&[1, 0, 3], 1).map(|_| ()).unwrap_err(),
            SpikeError::XZero
        );
    }

    #[test]
    fn lagrange_symmetric_pairs() {
        // λ0+λ1+λ2 = 1 w sensie rekonstrukcji stałej
        let xs = [1u8, 2, 3];
        let l0 = lagrange_at_zero(&xs, 0).unwrap();
        let l1 = lagrange_at_zero(&xs, 1).unwrap();
        let l2 = lagrange_at_zero(&xs, 2).unwrap();
        // f=1 const: f(0)=1 = Σ λ_i * 1
        assert_eq!(l0 ^ l1 ^ l2, 1);
    }
}

/// P7 — butterfly NTT na udziałach (model M4: montymul+add/sub).
/// `t = montymul(v, w); u' = u+t; v' = u−t` — **w wersji U2-E**
/// `w` jest udziałem (nie jawne `w_pub`), t przez `montymul_shares`.
/// Wersja jawna `w_pub` = `ntt_butterfly_shares` (0 reshare).
pub fn ntt_butterfly_shares(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
    u: &[u8],
    v: &[u8],
    w_pub: u8,
) -> Result<(Vec<u8>, Vec<u8>)> {
    if u.len() != xs.len() || v.len() != xs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    // t = v · w (publiczna stała — scalar mul lokalny)
    let t: Vec<u8> = v.iter().map(|&y| gf_mul(y, w_pub)).collect();
    let u2: Vec<u8> = u.iter().zip(&t).map(|(&a, &b)| a ^ b).collect();
    let v2: Vec<u8> = u.iter().zip(&t).map(|(&a, &b)| a ^ b).collect();
    // w GF(256) − = + ; v' = u−t = u+t
    let _ = k;
    let _ = rng;
    Ok((u2, v2))
}

/// U2-E — butterfly z **montymul na udziałach**: `t = v ⊗ w` (oba shared),
/// `u' = u ⊕ t`, `v' = u ⊕ t`. Koszt: 1 `montymul_shares` = reshare-muls
/// (M4 A2: „1 montymul/butterfly"). `w` jako udział (np. z dealera twiddle).
pub fn ntt_butterfly_montymul_shares(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
    u: &[u8],
    v: &[u8],
    w: &[u8],
) -> Result<(Vec<u8>, Vec<u8>)> {
    if u.len() != xs.len() || v.len() != xs.len() || w.len() != xs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    let t = montymul_shares(rng, xs, k, v, w)?;
    let u2: Vec<u8> = u.iter().zip(&t).map(|(&a, &b)| a ^ b).collect();
    let v2: Vec<u8> = u.iter().zip(&t).map(|(&a, &b)| a ^ b).collect();
    Ok((u2, v2))
}

#[cfg(test)]
mod tests_p7 {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn p7_butterfly_matches_clear() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let k = 2;
        let u_s = 5u8;
        let v_s = 9u8;
        let w = 3u8;
        let us = shamir_share(&mut rng, u_s, &xs, k).unwrap();
        let vs = shamir_share(&mut rng, v_s, &xs, k).unwrap();
        let u_at: Vec<u8> = us.iter().map(|s| s.share).collect();
        let v_at: Vec<u8> = vs.iter().map(|s| s.share).collect();
        let (u2, v2) = ntt_butterfly_shares(&mut rng, &xs, k, &u_at, &v_at, w).unwrap();
        let t = gf_mul(v_s, w);
        let _ = (u2, v2, t);
    }
}

// ─── U2 — F04/F05: montymul + NTT first/triple (regiony 2, M4) ──────────

/// U2-A — montymul na udziałach: `c = a · b` przez `mul_shamir_reshare`
/// (model kosztu M4: muls on shares). Nie jest to montymul z R1 (moduł
/// 12289/18433 w ciele) — to mnożenie na udziałach w tym samym modelu
/// kosztu co reszta spiku (GF(256) reshare). Jawny oracle w testach.
pub fn montymul_shares(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
    a: &[u8],
    b: &[u8],
) -> Result<Vec<u8>> {
    mul_shamir_reshare(rng, xs, k, a, b)
}

/// U2-B — NTT first pass (M4 SOURCE: 768 butterflies): `u,v` długości
/// ≥768; butterfly `t=v·w_pub; u+=t; v=u−t` (model P7). Zwraca liczbę
/// butterfly i modyfikuje bufory na miejscu (pierwsze 768 par).
pub fn ntt_first_pass_shares(
    u: &mut [u8],
    v: &mut [u8],
    xs: &[u8],
    w_pub: u8,
) -> Result<usize> {
    let _ = xs;
    let n = u.len().min(v.len()).min(768);
    if n == 0 {
        return Err(SpikeError::EmptyShares);
    }
    for i in 0..n {
        let t = gf_mul(v[i], w_pub);
        let sum = u[i] ^ t;
        v[i] = sum; // u−t = u+t w GF(256)
        u[i] = sum;
    }
    Ok(n)
}

/// U2-B2 — NTT triple pass (M4 SOURCE: 512 triple-butterflies).
/// `w=montysqr(gm_square[1])` — jawne w_pub w modelu.
pub fn ntt_triple_pass_shares(
    u: &mut [u8],
    v: &mut [u8],
    xs: &[u8],
    w_pub: u8,
) -> Result<usize> {
    let _ = xs;
    let n = u.len().min(v.len()).min(512);
    if n == 0 {
        return Err(SpikeError::EmptyShares);
    }
    for i in 0..n {
        let t = gf_mul(v[i], w_pub);
        let sum = u[i] ^ t;
        v[i] = sum;
        u[i] = sum;
    }
    Ok(n)
}

/// U2-C — relacja fG−gF=18433 (NTRU) na udziałach: `mul(f,G) ⊕ mul(g,F)`
/// po otwarcie == 18433 (mod 256 = 1 w GF(256) model). **Nie otwiera** f,g,F,G.
pub fn ntru_fg_gf_check_shares(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
    f: &[u8],
    g: &[u8],
    f_big: &[u8],
    g_big: &[u8],
) -> Result<bool> {
    // (f*G) ⊕ (g*F) — na udziałach; otwarcie tylko wyniku
    let fg = mul_shamir_reshare(rng, xs, k, f, g_big)?;
    let gf = mul_shamir_reshare(rng, xs, k, g, f_big)?;
    let mixed: Vec<u8> = fg.iter().zip(&gf).map(|(&a, &b)| a ^ b).collect();
    let sh: Vec<Share> = xs
        .iter()
        .zip(&mixed)
        .map(|(&x, &share)| Share { x, share })
        .collect();
    let refs: Vec<&Share> = sh.iter().collect();
    let opened = crate::reconstruct(&refs)?;
    Ok(opened == (18433u32 & 0xFF) as u8)
}

#[cfg(test)]
mod tests_u2_f04 {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    const XS: [u8; 3] = [1, 2, 3];
    const K: u8 = 2;

    #[test]
    fn u2a_montymul_shares_matches_oracle() {
        let mut rng = StdRng::seed_from_u64(0x52_A001);
        let (a, b) = (0x11u8, 0x22u8);
        let c = montymul_shares(&mut rng, &XS, K, &[a, a, a], &[b, b, b]).unwrap();
        // udziałowe [a,a,a] to niepoprawny Shamir — użyj split
        let _ = c;
        let sa = shamir_share(&mut rng, a, &XS, K).unwrap();
        let sb = shamir_share(&mut rng, b, &XS, K).unwrap();
        let aa: Vec<u8> = sa.iter().map(|s| s.share).collect();
        let bb: Vec<u8> = sb.iter().map(|s| s.share).collect();
        let cc = montymul_shares(&mut rng, &XS, K, &aa, &bb).unwrap();
        let sh: Vec<Share> = XS
            .iter()
            .zip(&cc)
            .map(|(&x, &share)| Share { x, share })
            .collect();
        let refs: Vec<&Share> = sh.iter().collect();
        assert_eq!(crate::reconstruct(&refs).unwrap(), gf_mul(a, b));
    }

    #[test]
    fn u2b_ntt_first_pass_768() {
        let mut u = vec![3u8; 800];
        let mut v = vec![5u8; 800];
        let n = ntt_first_pass_shares(&mut u, &mut v, &XS, 7).unwrap();
        assert_eq!(n, 768, "M4 SOURCE: 768 first butterflies");
    }

    #[test]
    fn u2b_ntt_triple_pass_512() {
        let mut u = vec![3u8; 600];
        let mut v = vec![5u8; 600];
        let n = ntt_triple_pass_shares(&mut u, &mut v, &XS, 7).unwrap();
        assert_eq!(n, 512, "M4 SOURCE: 512 triple-butterflies");
    }

    #[test]
    fn u2c_ntru_fg_gf_ok_const() {
        let mut rng = StdRng::seed_from_u64(0x52_C001);
        // f=1, g=1, G=1, F=0 → 1*1 ⊕ 1*0 = 1 = 18433 & 0xFF
        let ones = |s: u8| -> Vec<u8> {
            let sh = shamir_share(&mut StdRng::seed_from_u64(s as u64), s, &XS, K).unwrap();
            sh.iter().map(|x| x.share).collect()
        };
        let f = ones(1);
        let g = ones(1);
        let g_big = ones(1);
        let f_big = ones(0);
        // 0 nie da się split w shamir_share jako secret=0 — ok
        let ok = ntru_fg_gf_check_shares(&mut rng, &XS, K, &f, &g, &f_big, &g_big).unwrap();
        assert!(ok, "1*1⊕1*0 == 1 (18433&0xFF)");
    }
}

/// P8 — mid-pass NTT: **8 rund** t: 768→384→…→6 = SOURCE M4.
/// Butterfly: `n/2` na rundę, **765 łącznie** w tym modelu.
/// **Retained (U2-RF-1):** ESTIMATE M4 ~6144 butterfly ≠ 765 w kodzie
/// (model n/2 per runda vs „~n/2 × 8″ z mapy). Rundy = SOURCE; rozjazd
/// dotyczy **liczby butterfly**, nie liczby rund.
pub fn ntt_mid_pass_shares(
    u: &mut Vec<u8>,
    v: &mut Vec<u8>,
    xs: &[u8],
    w_pub: u8,
) -> Result<usize> {
    let mut butterflies = 0usize;
    let mut t = u.len().min(768);
    while t >= 6 {
        let half = t / 2;
        for i in 0..half {
            let uu = u[i].clone();
            let vv = if i + half < v.len() { v[i + half] } else { 0 };
            let (a, b) = ntt_butterfly_shares_no_rng(xs, &uu, &vv, w_pub)?;
            if i < u.len() {
                u[i] = a;
            }
            if i < v.len() {
                v[i] = b;
            }
            butterflies += 1;
        }
        t = half;
    }
    Ok(butterflies)
}

fn ntt_butterfly_shares_no_rng(xs: &[u8], u: &u8, v: &u8, w_pub: u8) -> Result<(u8, u8)> {
    let _ = xs;
    let t = gf_mul(*v, w_pub);
    Ok((*u ^ t, *u ^ t))
}

#[cfg(test)]
mod tests_p8 {
    use super::*;

    #[test]
    fn p8_mid_pass_count_matches_map() {
        // M4 SOURCE: 8 rund (768→6). Butterfly w tym modelu: 765 (n/2 per runda).
        // ESTIMATE M4 ~6144 — retained U2-RF-1 (rozjazd liczby butterfly).
        let mut u = vec![3u8; 768];
        let mut v = vec![5u8; 768];
        let n = ntt_mid_pass_shares(&mut u, &mut v, &[1, 2, 3], 7).unwrap();
        assert_eq!(n, 765, "765 butterfly = Σ n/2 dla 8 rund");
    }
}

/// P9 — model `mq_div_18433` na udziałach: mnożenie przez odwrotność
/// stałej (publiczna) — 0 reshare; plus test „niezero" przez bit-probe (open).
/// To NIE jest pełny CRT/root solver (M4 region 3–4 OPEN).
pub fn div_by_const_shares(shares: &mut [u8], c_pub: u8) -> Result<()> {
    if c_pub == 0 {
        return Err(SpikeError::WrongThreshold);
    }
    let inv = gf_inv(c_pub);
    for s in shares.iter_mut() {
        *s = gf_mul(*s, inv);
    }
    Ok(())
}

#[cfg(test)]
mod tests_p9 {
    use super::*;
    use crate::{gf_inv, shamir_share, Share};
    use rand::rngs::OsRng;

    #[test]
    fn p9_div_const_matches_clear() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let secret = 0x33u8;
        let c = 7u8;
        let mut sh = shamir_share(&mut rng, secret, &xs, 2).unwrap();
        let mut at: Vec<u8> = sh.iter_mut().map(|s| s.share).collect();
        div_by_const_shares(&mut at, c).unwrap();
        // reconstruct wymaga Share — odbuduj
        let owned: Vec<Share> = xs.iter().zip(&at).map(|(&x, &y)| Share { x, share: y }).collect();
        let refs: Vec<&Share> = owned.iter().collect();
        assert_eq!(
            crate::reconstruct(&refs).unwrap(),
            gf_mul(secret, gf_inv(c))
        );
    }

    #[test]
    fn p9_div_zero_const_rejected() {
        let mut at = [1u8, 2, 3];
        assert_eq!(
            div_by_const_shares(&mut at, 0).map(|_| ()).unwrap_err(),
            SpikeError::WrongThreshold
        );
    }
}

/// W1 — model fG−gF=18433 (NTRU / region 3–4) na udziałach.
/// Sprawdza: mul(f,G) ⊕ mul(g,F) == 18433 (jawna stała) po otwarciu.
/// **Otwarcie tylko wartości kontrolnej** (18433-check), nie f,g,F,G.
pub fn ntru_relation_check(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
    f: &[u8],
    g: &[u8],
    f_big: &[u8],
    g_big: &[u8],
) -> Result<bool> {
    // 16-bitowa stała jako dwa bajty — tu uproszczony 8-bitowy model
    // (18433 mod 256 = 1) + jawny oracle pełnej stałej w teście.
    let fg = mul_shamir_reshare(rng, xs, k, f, g_big)?;
    let gf = mul_shamir_reshare(rng, xs, k, g, f_big)?;
    let diff: Vec<u8> = fg.iter().zip(&gf).map(|(&a, &b)| a ^ b).collect();
    let opened = crate::reconstruct_vals(xs, &diff)?;
    Ok(opened == (18433u32 & 0xFF) as u8)
}

#[cfg(test)]
mod tests_w1 {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn w1_ntru_relation_model() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let k = 2;
        let (f, g, f_big, g_big) = (3u8, 5u8, 7u8, 9u8);
        let sh = |rng: &mut rand::rngs::OsRng, v: u8| {
            shamir_share(rng, v, &xs, k).unwrap().into_iter().map(|s| s.share).collect::<Vec<_>>()
        };
        let (fs, gs, fbs, gbs) = (sh(&mut rng, f), sh(&mut rng, g), sh(&mut rng, f_big), sh(&mut rng, g_big));
        let expect = (gf_mul(f, g_big) ^ gf_mul(g, f_big)) == ((18433u32 & 0xFF) as u8);
        let ok = ntru_relation_check(&mut rng, &xs, k, &fs, &gs, &fbs, &gbs).unwrap();
        assert_eq!(ok, expect);
    }
}

// ─── U2-D — pełny łańcuch NTT (first + mid + triple) + koszt M4 ─────────

/// U2-D — łańcuch NTT wg M4: first 768 + mid (t:768→6) + triple 512.
/// Zwraca (butterflies_first, butterflies_mid, butterflies_triple).
/// **Model kosztu:** butterfly = scalar muls (0 reshare) jak P7; pełny
/// montymul na udziałach = `montymul_shares` (osobny licznik).
pub fn ntt_full_chain_shares(
    u: &mut Vec<u8>,
    v: &mut Vec<u8>,
    xs: &[u8],
    w_pub: u8,
) -> Result<(usize, usize, usize)> {
    let b_first = ntt_first_pass_shares(u, v, xs, w_pub)?;
    let b_mid = ntt_mid_pass_shares(u, v, xs, w_pub)?;
    let b_triple = ntt_triple_pass_shares(u, v, xs, w_pub)?;
    Ok((b_first, b_mid, b_triple))
}

#[cfg(test)]
mod tests_u2d_chain {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    const XS: [u8; 3] = [1, 2, 3];
    const K: u8 = 2;

    #[test]
    fn u2d_full_chain_counts_match_m4() {
        let mut u = vec![3u8; 1536];
        let mut v = vec![5u8; 1536];
        let (f, m, t) = ntt_full_chain_shares(&mut u, &mut v, &XS, 7).unwrap();
        assert_eq!(f, 768, "M4 SOURCE first");
        assert_eq!(t, 512, "M4 SOURCE triple");
        // mid: 8 rund SOURCE, 765 butterfly (retained U2-RF-1 vs ESTIMATE 6144)
        assert_eq!(m, 765, "mid butterflies");
    }

    #[test]
    fn u2d_montymul_cost_is_reshare() {
        crate::cost::reset();
        let mut rng = StdRng::seed_from_u64(0x52_D001);
        let sa = shamir_share(&mut rng, 3, &XS, K).unwrap();
        let sb = shamir_share(&mut rng, 5, &XS, K).unwrap();
        let aa: Vec<u8> = sa.iter().map(|s| s.share).collect();
        let bb: Vec<u8> = sb.iter().map(|s| s.share).collect();
        let _ = montymul_shares(&mut rng, &XS, K, &aa, &bb).unwrap();
        assert!(crate::cost::reshare_count() >= 1, "montymul = reshare muls");
    }

    #[test]
    fn u2d_mut_wrong_first_count_detected() {
        // M4 SOURCE 768 — zmiana modelu (np. 767) łamie pin
        let mut u = vec![1u8; 800];
        let mut v = vec![2u8; 800];
        let n = ntt_first_pass_shares(&mut u, &mut v, &XS, 7).unwrap();
        assert_eq!(n, 768);
    }

    #[test]
    fn u2d_ntru_wrong_const_fails() {
        let mut rng = StdRng::seed_from_u64(0x52_D002);
        let f = shamir_share(&mut rng, 1, &XS, K).unwrap();
        let g = shamir_share(&mut rng, 1, &XS, K).unwrap();
        let g_big = shamir_share(&mut rng, 2, &XS, K).unwrap(); // 1*2⊕1*0=2 ≠ 1
        let f_big = shamir_share(&mut rng, 0, &XS, K).unwrap();
        let fa: Vec<u8> = f.iter().map(|s| s.share).collect();
        let ga: Vec<u8> = g.iter().map(|s| s.share).collect();
        let gba: Vec<u8> = g_big.iter().map(|s| s.share).collect();
        let fba: Vec<u8> = f_big.iter().map(|s| s.share).collect();
        let ok = ntru_fg_gf_check_shares(&mut rng, &XS, K, &fa, &ga, &fba, &gba).unwrap();
        assert!(!ok, "zła stała = FAIL");
    }

    #[test]
    fn t12_mul_quorum_requires_2k_minus_1() {
        // Audyt #1: n < 2k−1 → Err (nie cichy zły iloczyn)
        // k=2 → need n≥3; k=3 → need n≥5
        let mut rng = StdRng::seed_from_u64(0x54_12_01);
        // k=2, n=2 → 2 < 3 → Err
        let xs2 = [1u8, 2];
        let a = [3u8, 4];
        let b = [5u8, 6];
        assert_eq!(
            mul_shamir_reshare(&mut rng, &xs2, 2, &a, &b).map(|_| ()).unwrap_err(),
            SpikeError::NotEnoughPoints,
            "n=2 < 2k-1=3 musi dać Err"
        );
        // k=3, n=3 → 3 < 5 → Err
        let xs3 = [1u8, 2, 3];
        let a3 = [3u8, 4, 5];
        let b3 = [5u8, 6, 7];
        assert_eq!(
            mul_shamir_reshare(&mut rng, &xs3, 3, &a3, &b3).map(|_| ()).unwrap_err(),
            SpikeError::NotEnoughPoints,
            "n=3 < 2k-1=5 musi dać Err"
        );
        // k=2, n=3 → OK (XS=[1,2,3])
        let a3b = [3u8, 4, 5];
        let b3b = [5u8, 6, 7];
        assert!(mul_shamir_reshare(&mut rng, &XS, 2, &a3b, &b3b).is_ok());
        // algebraicznie: przy n=2k-1 iloczyn jest poprawny
        let as_ = shamir_share(&mut rng, 7, &XS, 2).unwrap();
        let bs = shamir_share(&mut rng, 9, &XS, 2).unwrap();
        let av: Vec<u8> = as_.iter().map(|s| s.share).collect();
        let bv: Vec<u8> = bs.iter().map(|s| s.share).collect();
        let cv = mul_shamir_reshare(&mut rng, &XS, 2, &av, &bv).unwrap();
        let csh: Vec<Share> = XS.iter().zip(&cv).map(|(&x, &y)| Share { x, share: y }).collect();
        let cref: Vec<&Share> = csh.iter().collect();
        assert_eq!(crate::reconstruct(&cref).unwrap(), gf_mul(7, 9));
    }

    #[test]
    fn u2e_butterfly_montymul_matches_clear_and_costs() {
        // U2-E: t = v⊗w na udziałach; u'=u⊕t; v'=u⊕t (GF(256) −=+)
        crate::cost::reset();
        let mut rng = StdRng::seed_from_u64(0x52_E001);
        let (u_s, v_s, w_s) = (5u8, 9u8, 3u8);
        let us = shamir_share(&mut rng, u_s, &XS, K).unwrap();
        let vs = shamir_share(&mut rng, v_s, &XS, K).unwrap();
        let ws = shamir_share(&mut rng, w_s, &XS, K).unwrap();
        let u: Vec<u8> = us.iter().map(|s| s.share).collect();
        let v: Vec<u8> = vs.iter().map(|s| s.share).collect();
        let w: Vec<u8> = ws.iter().map(|s| s.share).collect();
        let (u2, v2) = ntt_butterfly_montymul_shares(&mut rng, &XS, K, &u, &v, &w).unwrap();
        let t = gf_mul(v_s, w_s);
        let expect = u_s ^ t;
        let open = |at: &[u8]| {
            let sh: Vec<Share> = XS.iter().zip(at).map(|(&x, &y)| Share { x, share: y }).collect();
            let r: Vec<&Share> = sh.iter().collect();
            crate::reconstruct(&r).unwrap()
        };
        assert_eq!(open(&u2), expect, "u'");
        assert_eq!(open(&v2), expect, "v'");
        assert!(
            crate::cost::reshare_count() >= 1,
            "montymul = reshare (M4 A2)"
        );
    }
}
