//! NTT ternarna w `R_q` — port 1:1 z silnika FT1536.
//!
//! Odwzorowuje `mq_mkgm3`, `mq_NTT_ternary` i `mq_iNTT_ternary` z
//! `Extra/c/falcon-vrfy.c` (gałąź ternary: `q = 18433`, `n = 3·2^(logn-1)`,
//! `logn = 10` → `n = 1536`, pierścień `X^n − X^(n/2) + 1`). Kolejność
//! wyjścia, tablice pierwiastków i arytmetyka Montgomery'ego są takie same
//! jak w silniku; różnica jest tylko językowa.
//!
//! **Zakres:** wyłącznie `logn = 10`. Inne `logn` wymagają innych tablic
//! (silnik ma osobne ścieżki dla `logn ≤ 9`); ten moduł ich nie udaje.
//!
//! **Granica:** to arytmetyka jawna, nie MPC. NTT na udziałach (butterfly
//! bez rekonstrukcji) to osobny krok protokołu; ten moduł nie deklaruje
//! bezpieczeństwa progowego.
//!
//! Tablice są generowane raz (deterministycznie) i trzymane w `OnceLock`.
//! Wartości `gm[0..8]` i `igm[0]` są przypięte testem do tablic silnika
//! (`GMt_square`/`iGMt_square`), więc rozjazd generatora jest widoczny.

use std::sync::OnceLock;

use crate::ring::{N, Poly, Q, inv_mod, mul_mod};

/// `-1/q mod 2^16` dla `q = 18433` (stała silnika `Q0It`).
pub const Q0I: u32 = 18431;

/// `2^16 mod q` (stała silnika `Rt`).
pub const R: u16 = 10237;

/// `2^32 mod q` (stała silnika `R2t`).
pub const R2: u16 = 4564;

/// `logn` obsługiwany przez ten moduł (N = 3·2^9 = 1536).
pub const TERNARY_LOGN: u32 = 10;

/// Maksymalny `logn` tablic silnika (`TERNARY_LOGN_MAX`).
pub const TERNARY_LOGN_MAX: u32 = 11;

/// Rozmiar tablic silnika (`TERNARY_GM_SIZE`).
pub const GM_SIZE: usize = 1 << TERNARY_LOGN_MAX;

const _: () = assert!(N == 3 << (TERNARY_LOGN - 1));

/// Mnożenie Montgomery'ego: `x·y/R mod q` (port `mq_montymul`).
///
/// Operandy w `0..q`. Dolne 16 bitów iloczynu `z·Q0I` jest liczone
/// z zawijaniem `u32`, dokładnie jak w C (unsigned wraparound).
#[inline]
fn montymul(x: u16, y: u16) -> u16 {
    let z = u32::from(x) * u32::from(y);
    let w = (z.wrapping_mul(Q0I) & 0xFFFF) * u32::from(Q);
    // Suma mieści się w 29 bitach (analiza silnika), więc brak zawijania.
    let mut z = (z + w) >> 16;
    z = z.wrapping_sub(u32::from(Q));
    z = z.wrapping_add(u32::from(Q) & 0u32.wrapping_sub(z >> 31));
    z as u16
}

/// Dzielenie modulo `q` (odpowiednik `mq_div_18433`; wynik ten sam).
fn div_q(x: u16, y: u16) -> u16 {
    let inv = inv_mod(y).expect("tablice NTT: pierwiastek niezerowy");
    mul_mod(x, inv)
}

/// Odwrócenie 10 bitów (port `rev10`).
fn rev10(x: u32) -> u32 {
    let mut y = 0u32;
    let mut x = x;
    for _ in 0..10 {
        y = (y << 1) | (x & 1);
        x >>= 1;
    }
    y
}

struct Tables {
    gm: Vec<u16>,
    igm: Vec<u16>,
}

/// Generator tablic `mq_mkgm3` dla `logn = 10`.
fn mkgm3(logn: u32) -> (Vec<u16>, Vec<u16>) {
    // Ten moduł obsługuje wyłącznie logn=10 (N=1536); inne wymagają
    // osobnych tablic i nie są deklarowane.
    assert_eq!(logn, TERNARY_LOGN);
    let mut gm = vec![0u16; GM_SIZE];
    let mut igm = vec![0u16; GM_SIZE];

    // g = 25 w reprezentacji Montgomery'ego, podniesione do pierwiastka
    // rzędu 9216 (liczba podniesień: TERNARY_LOGN_MAX - logn).
    let mut g = montymul(25, R2);
    let mut k = logn;
    while k < TERNARY_LOGN_MAX {
        g = montymul(g, g);
        k += 1;
    }
    let ig = div_q(R2, g);

    if logn == 1 {
        gm[1] = g;
        igm[1] = ig;
    } else {
        let mut x = g;
        let mut ix = ig;
        let g2 = montymul(g, g);
        let g4 = montymul(g2, g2);
        let ig2 = montymul(ig, ig);
        let ig4 = montymul(ig2, ig2);
        let shift = TERNARY_LOGN_MAX - logn;
        let b = 1usize << (logn - 1);
        let mut u = 0usize;
        while u < b {
            gm[b + rev10((u as u32) << shift) as usize] = x;
            igm[b + rev10((u as u32) << shift) as usize] = ix;
            x = montymul(x, g4);
            ix = montymul(ix, ig4);
            gm[b + rev10(((u + 1) as u32) << shift) as usize] = x;
            igm[b + rev10(((u + 1) as u32) << shift) as usize] = ix;
            x = montymul(x, g2);
            ix = montymul(ix, ig2);
            u += 2;
        }
    }

    let k = (logn - 2) as usize;
    for u in (1usize << k)..(1usize << (k + 1)) {
        let y = gm[u << 1];
        let z = igm[u << 1];
        gm[u] = montymul(y, montymul(y, y));
        igm[u] = montymul(z, montymul(z, z));
    }
    for u in (1..=(1usize << k) - 1).rev() {
        let v = u << 1;
        gm[u] = montymul(gm[v], gm[v]);
        igm[u] = montymul(igm[v], igm[v]);
    }
    gm[0] = gm[1];
    let w = gm[1];
    igm[0] = div_q(R2, crate::ring::sub_mod(crate::ring::add_mod(w, w), R));

    (gm, igm)
}

fn tables() -> &'static Tables {
    static TABLES: OnceLock<Tables> = OnceLock::new();
    TABLES.get_or_init(|| {
        let (gm, igm) = mkgm3(TERNARY_LOGN);
        Tables { gm, igm }
    })
}

/// NTT w miejscu (port `mq_NTT_ternary`).
pub fn ntt_in_place(a: &mut [u16; N]) {
    let t = tables();
    let gm = &t.gm;
    let hn = N >> 1;

    let r = gm[1];
    for u in 0..hn {
        let a0 = a[u];
        let a1 = a[u + hn];
        let b = montymul(a1, r);
        a[u] = crate::ring::add_mod(a0, b);
        a[u + hn] = crate::ring::sub_mod(crate::ring::add_mod(a0, a1), b);
    }

    let mut t = hn;
    let mut m = 2usize;
    while t > 3 {
        let ht = t >> 1;
        let mut u1 = 0usize;
        let mut v1 = 0usize;
        while u1 < m {
            let s = gm[m + u1];
            for v in v1..v1 + ht {
                let a0 = a[v];
                let a1 = montymul(a[v + ht], s);
                a[v] = crate::ring::add_mod(a0, a1);
                a[v + ht] = crate::ring::sub_mod(a0, a1);
            }
            u1 += 1;
            v1 += t;
        }
        t = ht;
        m <<= 1;
    }

    let w = montymul(gm[1], gm[1]);
    let mut u = 0usize;
    let mut v = 1usize << (TERNARY_LOGN - 1);
    while u < N {
        let fa = a[u];
        let fb = a[u + 1];
        let fc = a[u + 2];
        let x = gm[v];
        let x2 = montymul(x, x);
        let fb0 = montymul(fb, x);
        let fb1 = montymul(fb0, w);
        let fb2 = montymul(fb1, w);
        let fc0 = montymul(fc, x2);
        let fc1 = montymul(fc0, w);
        let fc2 = montymul(fc1, w);
        a[u] = crate::ring::add_mod(fa, crate::ring::add_mod(fb0, fc0));
        a[u + 1] = crate::ring::add_mod(fa, crate::ring::add_mod(fb1, fc2));
        a[u + 2] = crate::ring::add_mod(fa, crate::ring::add_mod(fb2, fc1));
        u += 3;
        v += 1;
    }
}

/// Odwrotna NTT w miejscu (port `mq_iNTT_ternary`).
pub fn intt_in_place(a: &mut [u16; N]) {
    let t = tables();
    let igm = &t.igm;
    let hn = N >> 1;

    let w = montymul(igm[1], igm[1]);
    let mut u = 0usize;
    let mut v = 1usize << (TERNARY_LOGN - 1);
    while u < N {
        let f0 = a[u];
        let f1 = a[u + 1];
        let f2 = a[u + 2];
        let x = igm[v];
        let x2 = montymul(x, x);
        let f11 = montymul(f1, w);
        let f12 = montymul(f11, w);
        let f21 = montymul(f2, w);
        let f22 = montymul(f21, w);
        a[u] = crate::ring::add_mod(f0, crate::ring::add_mod(f1, f2));
        a[u + 1] = montymul(x, crate::ring::add_mod(f0, crate::ring::add_mod(f11, f22)));
        a[u + 2] = montymul(x2, crate::ring::add_mod(f0, crate::ring::add_mod(f12, f21)));
        u += 3;
        v += 1;
    }

    let mut t = 6usize;
    let mut m = 1usize << (TERNARY_LOGN - 2);
    while t < N {
        let ht = t >> 1;
        let mut u1 = 0usize;
        let mut v1 = 0usize;
        while u1 < m {
            let s = igm[m + u1];
            for v in v1..v1 + ht {
                let a0 = a[v];
                let a1 = a[v + ht];
                a[v] = crate::ring::add_mod(a0, a1);
                a[v + ht] = montymul(crate::ring::sub_mod(a0, a1), s);
            }
            u1 += 1;
            v1 += t;
        }
        t <<= 1;
        m >>= 1;
    }

    let r = igm[0];
    for u in 0..hn {
        let a0 = a[u];
        let a1 = a[u + hn];
        let b = montymul(r, crate::ring::sub_mod(a0, a1));
        a[u] = crate::ring::sub_mod(crate::ring::add_mod(a0, a1), b);
        a[u + hn] = crate::ring::add_mod(b, b);
    }

    let ni = div_q(R, N as u16);
    for x in a.iter_mut() {
        *x = montymul(*x, ni);
    }
}

/// NTT pierścienia: oceny w punktach pierwiastków (kolejność silnika).
pub fn ntt(p: &Poly) -> Poly {
    let mut a = *p.coeffs();
    ntt_in_place(&mut a);
    Poly::from_coeffs(&a).expect("NTT: współczynniki w 0..q")
}

/// Odwrotna NTT pierścienia.
pub fn intt(e: &Poly) -> Poly {
    let mut a = *e.coeffs();
    intt_in_place(&mut a);
    Poly::from_coeffs(&a).expect("iNTT: współczynniki w 0..q")
}

/// Mnożenie w `R_q` przez NTT; wynik identyczny ze szkolnym `Poly::mul`.
pub fn mul(a: &Poly, b: &Poly) -> Poly {
    let mut ea = *a.coeffs();
    let mut eb = *b.coeffs();
    ntt_in_place(&mut ea);
    ntt_in_place(&mut eb);
    let mut prod = [0u16; N];
    for i in 0..N {
        // montymul daje e_a·e_b/R; R2 = R^2 zdejmuje czynnik R.
        prod[i] = montymul(montymul(ea[i], eb[i]), R2);
    }
    intt_in_place(&mut prod);
    Poly::from_coeffs(&prod).expect("NTT mul: współczynniki w 0..q")
}

#[cfg(test)]
mod tests {
    use super::{
        GM_SIZE, Q0I, R, R2, intt, intt_in_place, montymul, mul, ntt, ntt_in_place, tables,
    };
    use crate::ring::{N, Poly, Q, inv_mod, mul_mod};

    fn sample(i: usize) -> u16 {
        ((i * i * 13 + 7 * i + 3) % Q as usize) as u16
    }

    fn sample_b(i: usize) -> u16 {
        ((i * 29 + 5) % Q as usize) as u16
    }

    fn poly_from(f: impl Fn(usize) -> u16) -> Poly {
        let coeffs: Vec<u16> = (0..N).map(f).collect();
        Poly::from_coeffs(&coeffs).expect("poly")
    }

    fn fnv1a64_le(values: &[u16]) -> u64 {
        let mut h = 0xcbf2_9ce4_8422_2325u64;
        for &v in values {
            for byte in [v as u8, (v >> 8) as u8] {
                h ^= byte as u64;
                h = h.wrapping_mul(0x0000_0100_0000_01b3);
            }
        }
        h
    }

    #[test]
    fn constants_match_engine() {
        assert_eq!(Q, 18433);
        assert_eq!(Q0I, 18431);
        assert_eq!(R, 10237);
        assert_eq!(R2, 4564);
        assert_eq!((1u32 << 16) % u32::from(Q), u32::from(R));
        assert_eq!((u32::from(R) * u32::from(R)) % u32::from(Q), u32::from(R2));
        assert_eq!(GM_SIZE, 2048);
    }

    #[test]
    fn montymul_matches_definition() {
        let r_inv = inv_mod(R).expect("R invertible");
        for &(x, y) in &[
            (1u16, 1u16),
            (2, 3),
            (9358, 9358),
            (18432, 18432),
            (1234, 5678),
        ] {
            let expected = mul_mod(mul_mod(x, y), r_inv);
            assert_eq!(montymul(x, y), expected, "x={x} y={y}");
        }
    }

    #[test]
    fn tables_match_engine_prefix() {
        let t = tables();
        // Prefix zgodny z `GMt_square` z falcon-vrfy.c.
        assert_eq!(
            &t.gm[..8],
            &[9358, 9358, 8086, 11703, 5774, 14509, 12722, 9851]
        );
        // Prefix zgodny z `iGMt_square`.
        assert_eq!(
            &t.igm[..8],
            &[3318, 879, 6730, 10347, 8582, 5711, 3924, 12659]
        );
    }

    #[test]
    fn ntt_intt_roundtrip() {
        for p in [
            Poly::zero(),
            poly_from(|i| if i == 0 { 1 } else { 0 }),
            poly_from(|i| if i == 1 { 1 } else { 0 }),
            poly_from(sample),
        ] {
            let e = ntt(&p);
            let back = intt(&e);
            assert!(back.ct_eq(&p));
        }
    }

    #[test]
    fn ntt_intt_in_place_roundtrip() {
        let p = poly_from(sample);
        let mut a = *p.coeffs();
        ntt_in_place(&mut a);
        intt_in_place(&mut a);
        assert_eq!(&a, p.coeffs());
    }

    #[test]
    #[cfg_attr(miri, ignore = "szkolne O(N^2) jest zbyt wolne pod Miri")]
    fn mul_matches_schoolbook() {
        for p in [
            Poly::zero(),
            poly_from(|i| if i == 0 { 1 } else { 0 }),
            poly_from(sample),
        ] {
            let b = poly_from(sample_b);
            let fast = mul(&p, &b);
            let slow = p.mul(&b);
            assert!(fast.ct_eq(&slow));
        }
    }

    #[test]
    #[cfg_attr(miri, ignore = "szkolne O(N^2) porównanie jest zbyt wolne pod Miri")]
    fn mul_by_x_matches_ntt() {
        let x = poly_from(|i| if i == 1 { 1 } else { 0 });
        let a = poly_from(sample);
        let expected = a.mul_by_x();
        let got = mul(&a, &x);
        assert!(got.ct_eq(&expected));
    }

    #[test]
    fn ntt_matches_independent_python_kat() {
        let e = ntt(&poly_from(sample));
        assert_eq!(
            &e.coeffs()[..8],
            &[6066, 9648, 3454, 4403, 8667, 15186, 4700, 6839]
        );
        assert_eq!(fnv1a64_le(e.coeffs()), 0x4795_5aa8_4836_ff09);
    }

    #[test]
    #[cfg_attr(miri, ignore = "szkolne O(N^2) porównanie jest zbyt wolne pod Miri")]
    fn mul_matches_independent_python_kat() {
        let a = poly_from(sample);
        let b = poly_from(sample_b);
        let prod = mul(&a, &b);
        assert_eq!(
            &prod.coeffs()[..8],
            &[9960, 14671, 9872, 1334, 15523, 7435, 8060, 13784]
        );
        assert_eq!(fnv1a64_le(prod.coeffs()), 0xf995_4b55_c857_ad34);
        assert!(prod.ct_eq(&a.mul(&b)));
    }

    #[test]
    #[cfg_attr(miri, ignore = "szkolne O(N^2) porównanie jest zbyt wolne pod Miri")]
    fn mul_not_commutative_only_on_different_inputs() {
        // Sanity: mnożenie NTT jest przemienne (jak w pierścieniu).
        let a = poly_from(sample);
        let b = poly_from(sample_b);
        assert!(mul(&a, &b).ct_eq(&mul(&b, &a)));
    }
}
