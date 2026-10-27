//! Codec sygnatury FT1536: `sig = 0xAA || compress_static(s2)` (WP-031).
//!
//! Wierny port `compress_static`/`uncompress_static` z `Extra/c/falcon-enc.c`
//! dla `q = 18433` (`j = 8`, `n = 1536`, logn = 10) — bajt po bajcie zgodny
//! z silnikiem C (SPEC §2, I-05). Każdy współczynnik kodowany jest jako:
//! bit znaku (1 = ujemny), `j` niskich bitów wartości bezwzględnej,
//! a następnie `|x| >> j` zer i bit `1` (terminator).
//!
//! **Własności (fail-closed):** dekoder odrzuca dane ucięte, nadmiarowe bity
//! paddingu po ostatnim współczynniku (niekanoniczność), `ne > 255`
//! i wartości nie mieszczące się w `i16`. Dekoder **nie** „naprawia" wejścia:
//! `decode_sig(decode_sig(b))` jest tożsamy na bajtach silnika (fixpoint,
//! patrz testy i `impl/KAT/`).
//!
//! **Granica:** moduł koduje **jawny** wynik podpisu (`s2` jest publiczne
//! po otwarciu — SPEC §7.5). Nie dotyka klucza; nie ma tu ścieżki do
//! `sk` ani udziałów.

use crate::error::{CoreError, Result};
use crate::ring::{N, Poly, Q};

/// Pierwszy bajt podpisu: ternary (`1<<7`) | comp = STATIC (`1<<5`) |
/// rezerwa 0 | logn = 10 — dokładnie `0xAA` (SPEC §2, I-05).
pub const SIG_HEADER_BYTE: u8 = 0xAA;

/// Szerokość niskich bitów współczynnika w `compress_static` dla `q = 18433`.
const J: u32 = 8;
/// Liczba współczynników (logn = 10: `3 << 9`).
const COEFFS: usize = N;

/// Centruje współczynnik `R_q` do reprezentanta w `(−q/2, q/2]`.
pub fn center(c: u16) -> i16 {
    let v = i32::from(c);
    let q = i32::from(Q);
    if v > q / 2 { (v - q) as i16 } else { v as i16 }
}

/// `compress_static` (`falcon-enc.c`) dla `q = 18433`.
///
/// Wejście: współczynniki `s2` jako `i16` (reprezentanty skrócone);
/// kodowanie wartości nie zależy od długości wektora. Wyjście: strumień
/// bitowy zakończony dopełnieniem zerowym do bajtu — bitowo identyczny
/// z silnikiem C.
pub fn compress_static(x: &[i16]) -> Vec<u8> {
    let mask = (1u32 << J) - 1;
    let mut buf = Vec::with_capacity(x.len() * 2);
    let mut acc: u32 = 0;
    let mut acc_len: i32 = 0;
    for &raw in x {
        let mut w = i32::from(raw);
        let lo = if w < 0 {
            w = -w;
            1u32 << J
        } else {
            0
        };
        let lo = lo | ((w as u32) & mask);
        let ne = w >> J;

        // Część pierwsza: bit znaku + j niskich bitów.
        acc = (acc << (J + 1)) | lo;
        acc_len += (J + 1) as i32;
        while acc_len >= 8 {
            acc_len -= 8;
            buf.push((acc >> acc_len) as u8);
        }

        // Część druga: `ne` zer + bit terminatora (dokładna pętla C:
        // `while (ne-- >= 0)` z bitem 1 przy przejściu przez 0).
        let mut ne = ne;
        while ne >= 0 {
            acc <<= 1;
            if ne == 0 {
                acc |= 1;
            }
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

/// `uncompress_static` (`falcon-enc.c`) dla `q = 18433`.
///
/// Dekoduje dokładnie `n` współczynników; zwraca `(współczynniki, liczba
/// zużytych bajtów)`. Odrzuca: dane ucięte (`InvalidLength`), `ne > 255`
/// (`OutOfRange`), wartości poza `i16` (`OutOfRange`) i niezerowe bity
/// paddingu po ostatnim współczynniku (`InvalidInput` — niekanoniczność).
pub fn uncompress_static(data: &[u8], n: usize) -> Result<(Vec<i16>, usize)> {
    let mask = (1u32 << J) - 1;
    let mut out = Vec::with_capacity(n);
    let mut v = 0usize;
    let mut db: u32 = 0;
    let mut db_len: u32 = 0;

    while out.len() < n {
        while db_len <= J {
            let b = *data.get(v).ok_or(CoreError::InvalidLength)?;
            v += 1;
            db = (db << 8) + u32::from(b);
            db_len += 8;
        }
        let sign = (db >> (db_len - 1)) & 1;
        db_len -= J + 1;
        let lo = (db >> db_len) & mask;

        let mut ne = 0u32;
        loop {
            if db_len == 0 {
                let b = *data.get(v).ok_or(CoreError::InvalidLength)?;
                v += 1;
                db = u32::from(b);
                db_len = 8;
            }
            db_len -= 1;
            if ((db >> db_len) & 1) == 1 {
                break;
            }
            ne += 1;
            if ne > 255 {
                return Err(CoreError::OutOfRange);
            }
        }

        let magnitude = lo + (ne << J);
        let signed = if magnitude > i16::MAX as u32 {
            return Err(CoreError::OutOfRange);
        } else {
            magnitude as i16
        };
        out.push(if sign == 1 { -signed } else { signed });
    }

    // Padding po ostatnim współczynniku MUSI być zerowy (jak w C).
    if db & ((1u32 << db_len) - 1) != 0 {
        return Err(CoreError::InvalidInput);
    }
    Ok((out, v))
}

/// Koduje podpis: `0xAA || compress_static(center(s2))`.
pub fn encode_sig(s2: &Poly) -> Vec<u8> {
    let signed: Vec<i16> = s2.coeffs().iter().map(|&c| center(c)).collect();
    let mut out = Vec::with_capacity(2 * COEFFS + 1);
    out.push(SIG_HEADER_BYTE);
    out.extend(compress_static(&signed));
    out
}

/// Dekoduje podpis: sprawdza nagłówek `0xAA`, dekoduje `N` współczynników
/// `s2` i wymaga, by strumień kończył się dokładnie na końcu danych.
pub fn decode_sig(sig: &[u8]) -> Result<Poly> {
    let (&header, body) = sig.split_first().ok_or(CoreError::InvalidLength)?;
    if header != SIG_HEADER_BYTE {
        return Err(CoreError::InvalidInput);
    }
    let (signed, used) = uncompress_static(body, COEFFS)?;
    if used != body.len() {
        return Err(CoreError::InvalidInput);
    }
    let coeffs: Vec<u16> = signed
        .iter()
        .map(|&v| {
            let q = i32::from(Q);
            let mut v = i32::from(v) % q;
            if v < 0 {
                v += q;
            }
            v as u16
        })
        .collect();
    Poly::from_coeffs(&coeffs)
}

#[cfg(test)]
mod tests {
    use super::{
        SIG_HEADER_BYTE, center, compress_static, decode_sig, encode_sig, uncompress_static,
    };
    use crate::ring::{N, Poly, Q};

    fn poly_from_i16(xs: &[i16]) -> Poly {
        let q = i32::from(Q);
        let mut coeffs = vec![0u16; N];
        for (slot, &v) in coeffs.iter_mut().zip(xs.iter()) {
            let mut v = i32::from(v) % q;
            if v < 0 {
                v += q;
            }
            *slot = v as u16;
        }
        Poly::from_coeffs(&coeffs).expect("coeffs")
    }

    fn roundtrip(xs: &[i16]) {
        let enc = compress_static(xs);
        let (dec, used) = uncompress_static(&enc, xs.len()).expect("decode");
        assert_eq!(dec, xs, "roundtrip wartości");
        assert_eq!(used, enc.len(), "roundtrip długości");
    }

    #[test]
    fn roundtrip_all_zero() {
        roundtrip(&[0i16; N]);
    }

    #[test]
    fn roundtrip_extremes() {
        let mut xs = [0i16; N];
        for (i, slot) in xs.iter_mut().enumerate() {
            *slot = match i % 7 {
                0 => 0,
                1 => 1,
                2 => -1,
                3 => 255,
                4 => -256,
                5 => 256,
                _ => -32767,
            };
        }
        roundtrip(&xs);
    }

    #[test]
    fn roundtrip_patterns_cover_bit_boundaries() {
        // Wartości wymuszające przejścia granic acc_len (8/16 bitów)
        // i różne długości unarnego terminatora.
        for &w in &[
            2i16, -2, 511, -512, 512, 1023, -1024, 4095, -4096, 9216, -9216,
        ] {
            let mut xs = [0i16; N];
            xs[0] = w;
            xs[N / 2] = w;
            xs[N - 1] = w;
            roundtrip(&xs);
        }
    }

    #[test]
    fn truncated_input_is_rejected() {
        let enc = compress_static(&[1i16; N]);
        for cut in 0..enc.len() {
            assert!(
                uncompress_static(&enc[..cut], N).is_err(),
                "ucięcie do {cut} musi być odrzucone"
            );
        }
    }

    #[test]
    fn nonzero_padding_is_rejected() {
        // 3 zerowe współczynniki = 30 bitów danych + 2 bity paddingu w 4 bajcie.
        let mut enc = compress_static(&[0i16; 3]);
        assert_eq!(enc.len(), 4);
        let last = enc.len() - 1;
        enc[last] |= 0x01;
        assert!(
            uncompress_static(&enc, 3).is_err(),
            "niezerowy padding musi być odrzucony"
        );
    }

    #[test]
    fn oversized_unary_run_is_rejected() {
        // Same zera: bit znaku + 8 bitów = 0, potem 256+ zer zamiast
        // terminatora → `ne > 255` przed wyczerpaniem danych.
        let bits = vec![0u8; 40];
        assert!(
            uncompress_static(&bits, 1).is_err(),
            "ne > 255 musi być odrzucone"
        );
    }

    #[test]
    fn center_maps_half_open_range() {
        assert_eq!(center(0), 0);
        assert_eq!(center(1), 1);
        assert_eq!(center(Q / 2), (Q / 2) as i16);
        assert_eq!(center(Q / 2 + 1), (Q / 2 + 1) as i16 - Q as i16);
        assert_eq!(center(Q - 1), -1);
    }

    #[test]
    fn encode_sig_header_and_fixpoint() {
        let s2 = poly_from_i16(&[3i16, -7, 0, 256, -256]);
        let sig = encode_sig(&s2);
        assert_eq!(sig[0], SIG_HEADER_BYTE);
        let back = decode_sig(&sig).expect("decode sig");
        assert!(back.ct_eq(&s2), "fixpoint encode/decode");

        // Nadmiarowe bajty po poprawnym strumieniu = niekanoniczne.
        let mut padded = sig.clone();
        padded.push(0);
        assert!(decode_sig(&padded).is_err());

        // Zły nagłówek.
        let mut bad = sig;
        bad[0] = 0x9A;
        assert!(decode_sig(&bad).is_err());
    }

    #[test]
    fn engine_kat_signature_decodes_and_reencodes_byte_exact() {
        // Wektor z rzeczywistego silnika (`impl/KAT/`, WP-024): dekod i
        // ponowne kodowanie muszą dać identyczne bajty — dowód zgodności
        // codec'u z `compress_static` silnika na niezależnych danych.
        const KAT: &str = include_str!("../../../KAT/falcon_ternary_logn10_v1.txt");
        let sig_hex = KAT
            .lines()
            .find_map(|l| l.strip_prefix("sig = "))
            .expect("pole sig w KAT");
        let sig: Vec<u8> = (0..sig_hex.len())
            .step_by(2)
            .map(|i| u8::from_str_radix(&sig_hex[i..i + 2], 16).expect("hex"))
            .collect();
        assert_eq!(sig[0], SIG_HEADER_BYTE);

        let s2 = decode_sig(&sig).expect("decode sygnatury silnika");
        assert_eq!(
            encode_sig(&s2),
            sig,
            "re-encoding musi być bajtowo identyczny"
        );
    }
}
