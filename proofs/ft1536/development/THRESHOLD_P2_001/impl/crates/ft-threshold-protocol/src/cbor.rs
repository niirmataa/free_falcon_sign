//! Kanoniczny CBOR (RFC 8949, deterministic encoding) — podzbiór wire v1
//! (WP-027, SPEC §9.2) rozszerzony o tablice dla `payloads_v0.cddl` (G2/WP-030).
//!
//! **Zakres.** Wyłącznie to, czego używa protokół: `uint` (major 0),
//! `bstr` (major 2), `array` (major 4) i mapy (major 5) z kluczami `uint`.
//! Wszystko inne (nint, text, tag, float/simple, długości nieokreślone) jest
//! **odrzucane**. To świadomie mały, ścisły dekoder, nie ogólny CBOR.
//!
//! **Kanoniczność jest wymuszona, nie akceptowana.** Dekoder odrzuca:
//! formę nieskróconą (`0x18 0x00`, `0x98 0x00`), długości nieokreślone
//! (`ai = 31`), wartości zarezerwowane (`ai = 28..30`), bajty po elemencie,
//! `bstr` lub `array` przekraczające limit oraz (na poziomie map, patrz
//! `envelope.rs`) klucze nieposortowane/podwójne/nieznane. Kodowanie
//! najkrótszą formą jest testowane wektorami RFC 8949 (Apendyks A).
//!
//! **Granica.** To warstwa formatu, nie kryptografia; MAC i `msg_id`
//! liczy `envelope.rs` na bajtach, które tutaj wychodzą.

#![forbid(unsafe_code)]

use ft_threshold_core::error::{CoreError, Result};

/// Maksymalny pojedynczy element `bstr` (SPEC §9.2: max bstr 16 MiB).
pub const MAX_ITEM_BYTES: usize = 16 << 20;
/// Maksymalna liczba elementów w pojedynczej tablicy CBOR (`payloads_v0.cddl`).
pub const MAX_ARRAY_LEN: usize = 4096;
/// Maksymalna głębokość zagnieżdżenia (SPEC §9.2: max nesting 8).
pub const MAX_DEPTH: usize = 8;

// Progi najkrótszej formy dla dodatkowych bajtów długości/wartości.
const AI_U8_MIN: u64 = 24;
const AI_U16_MIN: u64 = 1 << 8;
const AI_U32_MIN: u64 = 1 << 16;
const AI_U64_MIN: u64 = 1 << 32;

/// Pisze kanoniczny CBOR: tylko najkrótsze formy, bez tagów.
pub struct CborWriter {
    buf: Vec<u8>,
}

impl Default for CborWriter {
    fn default() -> Self {
        Self::new()
    }
}

impl CborWriter {
    /// Nowy bufor.
    pub fn new() -> Self {
        Self { buf: Vec::new() }
    }

    /// Dopisuje `uint` (major 0) w najkrótszej formie.
    pub fn put_uint(&mut self, v: u64) {
        self.put_len_head(0, v);
    }

    /// Dopisuje `bstr` (major 2) z długością w najkrótszej formie.
    pub fn put_bstr(&mut self, b: &[u8]) {
        self.put_len_head(2, b.len() as u64);
        self.buf.extend_from_slice(b);
    }

    /// Dopisuje nagłówek tablicy (major 4) z liczbą elementów w najkrótszej formie.
    pub fn put_array(&mut self, len: usize) {
        self.put_len_head(4, len as u64);
    }

    /// Dopisuje nagłówek mapy (major 5) z liczbą par w najkrótszej formie.
    pub fn put_map(&mut self, pairs: usize) {
        self.put_len_head(5, pairs as u64);
    }

    /// Surowy dostęp dla osadzania gotowych (kanonicznych) elementów.
    pub fn put_raw(&mut self, raw: &[u8]) {
        self.buf.extend_from_slice(raw);
    }

    /// Końcowe bajty.
    pub fn into_bytes(self) -> Vec<u8> {
        self.buf
    }

    /// Nagłówek `major` z wartością/długością `v` w najkrótszej formie
    /// (RFC 8949 §4.2.1: direct < 24, potem 1/2/4/8 bajtów).
    fn put_len_head(&mut self, major: u8, v64: u64) {
        if v64 < AI_U8_MIN {
            self.buf.push((major << 5) | v64 as u8);
        } else if v64 < AI_U16_MIN {
            self.buf.push((major << 5) | 24);
            self.buf.push(v64 as u8);
        } else if v64 < AI_U32_MIN {
            self.buf.push((major << 5) | 25);
            self.buf.extend_from_slice(&(v64 as u16).to_be_bytes());
        } else if v64 < AI_U64_MIN {
            self.buf.push((major << 5) | 26);
            self.buf.extend_from_slice(&(v64 as u32).to_be_bytes());
        } else {
            self.buf.push((major << 5) | 27);
            self.buf.extend_from_slice(&v64.to_be_bytes());
        }
    }
}

/// Surowa klauzula nagłówka po weryfikacji kanoniczności.
struct Head {
    major: u8,
    value: u64,
}

/// Ścisły czytnik kanonicznego CBOR nad zewnętrznym slice'em.
pub struct CborReader<'a> {
    b: &'a [u8],
    pos: usize,
}

impl<'a> CborReader<'a> {
    /// Czytnik nad pełnym wejściem; koniec wejścia musi pokrywać się
    /// z końcem ostatniego elementu (`expect_end`).
    pub fn new(b: &'a [u8]) -> Self {
        Self { b, pos: 0 }
    }

    /// Czy całe wejście zostało skonsumowane (bez śmieci na końcu).
    pub fn at_end(&self) -> bool {
        self.pos == self.b.len()
    }

    /// Wymaga `uint` (major 0) w najkrótszej formie.
    pub fn expect_uint(&mut self) -> Result<u64> {
        let h = self.read_head()?;
        if h.major != 0 {
            return Err(CoreError::NonCanonicalCbor);
        }
        Ok(h.value)
    }

    /// Wymaga `bstr` (major 2); zwraca slice wejścia (zero-copy).
    pub fn expect_bstr(&mut self, max: usize) -> Result<&'a [u8]> {
        let h = self.read_head()?;
        if h.major != 2 {
            return Err(CoreError::NonCanonicalCbor);
        }
        let len = usize::try_from(h.value).map_err(|_| CoreError::NonCanonicalCbor)?;
        if len > max || len > MAX_ITEM_BYTES || len > self.b.len() - self.pos {
            return Err(CoreError::NonCanonicalCbor);
        }
        let out = &self.b[self.pos..self.pos + len];
        self.pos += len;
        Ok(out)
    }

    /// Wymaga tablicy (major 4) o liczbie elementów `<= max` (oraz `<= MAX_ARRAY_LEN`).
    ///
    /// Każdy element CBOR zajmuje co najmniej 1 bajt, więc deklaracja większej
    /// liczby elementów niż pozostałe bajty bufora jest odrzucana natychmiast.
    pub fn expect_array(&mut self, max: usize) -> Result<usize> {
        let h = self.read_head()?;
        if h.major != 4 {
            return Err(CoreError::NonCanonicalCbor);
        }
        let len = usize::try_from(h.value).map_err(|_| CoreError::NonCanonicalCbor)?;
        if len > max || len > MAX_ARRAY_LEN || len > self.b.len() - self.pos {
            return Err(CoreError::NonCanonicalCbor);
        }
        Ok(len)
    }

    /// Wymaga mapy (major 5) i zwraca jej liczbę par; klucze weryfikuje
    /// wywołujący (`expect_uint` na kolejnych pozycjach).
    pub fn expect_map(&mut self) -> Result<usize> {
        let h = self.read_head()?;
        if h.major != 5 {
            return Err(CoreError::NonCanonicalCbor);
        }
        usize::try_from(h.value).map_err(|_| CoreError::NonCanonicalCbor)
    }

    /// Zwraca slice całego następnego elementu i przesuwa pozycję.
    ///
    /// Element jest w pełni przeglądany (rekurencyjnie, z limitem
    /// głębokości) i każdy pod-element musi mieć kanoniczny nagłówek;
    /// pełną walidacją typu/zawartości zajmie się późniejsze dekodowanie
    /// tego slice'a.
    pub fn next_item_bytes(&mut self, depth: usize) -> Result<&'a [u8]> {
        if depth > MAX_DEPTH {
            return Err(CoreError::NonCanonicalCbor);
        }
        let start = self.pos;
        let h = self.read_head()?;
        match h.major {
            0 => {}
            2 => {
                let len = usize::try_from(h.value).map_err(|_| CoreError::NonCanonicalCbor)?;
                if len > MAX_ITEM_BYTES || len > self.b.len() - self.pos {
                    return Err(CoreError::NonCanonicalCbor);
                }
                self.pos += len;
            }
            4 => {
                let len = usize::try_from(h.value).map_err(|_| CoreError::NonCanonicalCbor)?;
                if len > MAX_ARRAY_LEN || len > self.b.len() - self.pos {
                    return Err(CoreError::NonCanonicalCbor);
                }
                for _ in 0..len {
                    self.next_item_bytes(depth + 1)?;
                }
            }
            5 => {
                let pairs = usize::try_from(h.value).map_err(|_| CoreError::NonCanonicalCbor)?;
                if pairs > MAX_ARRAY_LEN || pairs > (self.b.len() - self.pos) / 2 {
                    return Err(CoreError::NonCanonicalCbor);
                }
                for _ in 0..pairs {
                    self.next_item_bytes(depth + 1)?;
                    self.next_item_bytes(depth + 1)?;
                }
            }
            _ => return Err(CoreError::NonCanonicalCbor),
        }
        Ok(&self.b[start..self.pos])
    }

    /// Wymaga końca wejścia (bez niedojedzonych bajtów).
    pub fn expect_end(&self) -> Result<()> {
        if self.at_end() {
            Ok(())
        } else {
            Err(CoreError::NonCanonicalCbor)
        }
    }

    fn read_head(&mut self) -> Result<Head> {
        if self.pos >= self.b.len() {
            return Err(CoreError::NonCanonicalCbor);
        }
        let ib = self.b[self.pos];
        self.pos += 1;
        let major = ib >> 5;
        let ai = ib & 0x1f;

        // Nieokreślona długość i kody zarezerwowane są zakazane w całości.
        if ai >= 28 {
            return Err(CoreError::NonCanonicalCbor);
        }

        let (value, extra): (u64, usize) = match ai {
            0..=23 => (u64::from(ai), 0),
            24 => {
                if self.b.len() - self.pos < 1 {
                    return Err(CoreError::NonCanonicalCbor);
                }
                (u64::from(self.b[self.pos]), 1)
            }
            25 => {
                if self.b.len() - self.pos < 2 {
                    return Err(CoreError::NonCanonicalCbor);
                }
                (
                    u64::from(u16::from_be_bytes([self.b[self.pos], self.b[self.pos + 1]])),
                    2,
                )
            }
            26 => {
                if self.b.len() - self.pos < 4 {
                    return Err(CoreError::NonCanonicalCbor);
                }
                let mut v = [0u8; 4];
                v.copy_from_slice(&self.b[self.pos..self.pos + 4]);
                (u64::from(u32::from_be_bytes(v)), 4)
            }
            27 => {
                if self.b.len() - self.pos < 8 {
                    return Err(CoreError::NonCanonicalCbor);
                }
                let mut v = [0u8; 8];
                v.copy_from_slice(&self.b[self.pos..self.pos + 8]);
                (u64::from_be_bytes(v), 8)
            }
            _ => return Err(CoreError::NonCanonicalCbor),
        };
        self.pos += extra;

        // W protokole istnieją tylko uint (0), bstr (2), array (4) i mapa (5);
        // nint/text/tag/float są odrzucane centralnie.
        if !matches!(major, 0 | 2 | 4 | 5) {
            return Err(CoreError::NonCanonicalCbor);
        }

        // Forma nieskrócona = non-canonical (RFC 8949 §4.2.1).
        let min = match ai {
            0..=23 => 0,
            24 => AI_U8_MIN,
            25 => AI_U16_MIN,
            26 => AI_U32_MIN,
            _ => AI_U64_MIN,
        };
        if value < min {
            return Err(CoreError::NonCanonicalCbor);
        }

        Ok(Head { major, value })
    }
}

#[cfg(test)]
mod tests {
    use super::{CborReader, CborWriter, MAX_ARRAY_LEN, MAX_DEPTH};
    use ft_threshold_core::error::CoreError;

    fn uint_bytes(v: u64) -> Vec<u8> {
        let mut w = CborWriter::new();
        w.put_uint(v);
        w.into_bytes()
    }

    #[test]
    fn shortest_uint_forms_match_rfc8949_appendix_a() {
        let cases: &[(u64, &[u8])] = &[
            (0, &[0x00]),
            (1, &[0x01]),
            (10, &[0x0a]),
            (23, &[0x17]),
            (24, &[0x18, 0x18]),
            (25, &[0x18, 0x19]),
            (100, &[0x18, 0x64]),
            (255, &[0x18, 0xff]),
            (256, &[0x19, 0x01, 0x00]),
            (1_000, &[0x19, 0x03, 0xe8]),
            (65_535, &[0x19, 0xff, 0xff]),
            (65_536, &[0x1a, 0x00, 0x01, 0x00, 0x00]),
            (4_294_967_295, &[0x1a, 0xff, 0xff, 0xff, 0xff]),
            (
                4_294_967_296,
                &[0x1b, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00],
            ),
            (
                u64::MAX,
                &[0x1b, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff],
            ),
        ];
        for (v, expect) in cases {
            assert_eq!(&uint_bytes(*v), expect, "uint {v}");
            let mut r = CborReader::new(expect);
            assert_eq!(r.expect_uint().expect("uint"), *v);
            r.expect_end().expect("end");
        }
    }

    #[test]
    fn bstr_lengths_use_shortest_form() {
        for (len, head_len) in [(0usize, 1usize), (23, 1), (24, 2), (255, 2), (256, 3)] {
            let data = vec![0xa5u8; len];
            let mut w = CborWriter::new();
            w.put_bstr(&data);
            let bytes = w.into_bytes();
            assert_eq!(bytes.len(), head_len + len, "len {len}");
            let mut r = CborReader::new(&bytes);
            assert_eq!(r.expect_bstr(len.max(1)).expect("bstr"), &data[..]);
            r.expect_end().expect("end");
        }
    }

    #[test]
    fn array_lengths_use_shortest_form_and_roundtrip() {
        for (len, head_len) in [(0usize, 1usize), (1, 1), (23, 1), (24, 2), (255, 2), (256, 3)] {
            let mut w = CborWriter::new();
            w.put_array(len);
            for i in 0..len {
                w.put_uint((i % 24) as u64);
            }
            let bytes = w.into_bytes();
            assert_eq!(bytes.len(), head_len + len, "array len {len}");

            let mut r = CborReader::new(&bytes);
            let decoded_len = r.expect_array(len).expect("array header");
            assert_eq!(decoded_len, len);
            for i in 0..decoded_len {
                assert_eq!(r.expect_uint().expect("item"), (i % 24) as u64);
            }
            r.expect_end().expect("end");

            // `next_item_bytes` musi przejść po całej tablicy i zwrócić identyczny slice.
            let mut r2 = CborReader::new(&bytes);
            assert_eq!(r2.next_item_bytes(0).expect("item slice"), &bytes[..]);
            r2.expect_end().expect("end 2");
        }
    }

    #[test]
    fn non_canonical_and_malformed_arrays_are_rejected() {
        // Nieskrócona długość 0: 0x98 0x00 zamiast 0x80.
        let mut r = CborReader::new(&[0x98, 0x00]);
        assert_eq!(r.expect_array(16), Err(CoreError::NonCanonicalCbor));

        // Nieskrócona długość 23: 0x98 0x17 zamiast 0x97.
        let mut b = vec![0x98, 0x17];
        b.extend(std::iter::repeat_n(0x01u8, 23));
        let mut r = CborReader::new(&b);
        assert_eq!(r.expect_array(32), Err(CoreError::NonCanonicalCbor));

        // Nieskrócona długość 255: 0x99 0x00 0xff zamiast 0x98 0xff.
        let mut b = vec![0x99, 0x00, 0xff];
        b.extend(std::iter::repeat_n(0x01u8, 255));
        let mut r = CborReader::new(&b);
        assert_eq!(r.expect_array(512), Err(CoreError::NonCanonicalCbor));

        // Nieokreślona długość tablicy (ai = 31: 0x9f ... 0xff).
        let mut r = CborReader::new(&[0x9f, 0x01, 0x02, 0xff]);
        assert_eq!(r.expect_array(16), Err(CoreError::NonCanonicalCbor));

        // Kody zarezerwowane ai = 28, 29, 30 w major 4 (0x9c, 0x9d, 0x9e).
        for ib in [0x9cu8, 0x9d, 0x9e] {
            let buf = [ib];
            let mut r = CborReader::new(&buf);
            assert_eq!(r.expect_array(16), Err(CoreError::NonCanonicalCbor));
        }

        // Przekroczenie limitu `max` podanego przez wywołującego.
        let mut r = CborReader::new(&[0x83, 0x01, 0x02, 0x03]);
        assert_eq!(r.expect_array(2), Err(CoreError::NonCanonicalCbor));

        // Przekroczenie globalnego limitu MAX_ARRAY_LEN.
        let mut w = CborWriter::new();
        w.put_array(MAX_ARRAY_LEN + 1);
        let bytes = w.into_bytes();
        let mut r = CborReader::new(&bytes);
        assert_eq!(
            r.expect_array(MAX_ARRAY_LEN + 10),
            Err(CoreError::NonCanonicalCbor)
        );

        // Obcięta tablica: nagłówek deklaruje 3 elementy, w buforze są tylko 2 bajty.
        let mut r = CborReader::new(&[0x83, 0x01, 0x02]);
        assert_eq!(r.expect_array(8), Err(CoreError::NonCanonicalCbor));

        // Tablica z niekanonicznym elementem wewnątrz ([uint(5) jako 0x18 0x05])
        // musi zostać odrzucona również przez `next_item_bytes`.
        let mut r = CborReader::new(&[0x81, 0x18, 0x05]);
        assert_eq!(r.next_item_bytes(0), Err(CoreError::NonCanonicalCbor));

        // Nadmiarowy bajt po poprawnej tablicy.
        let mut r = CborReader::new(&[0x81, 0x01, 0x00]);
        assert_eq!(r.expect_array(4).expect("len"), 1);
        assert_eq!(r.expect_uint().expect("elem"), 1);
        assert_eq!(r.expect_end(), Err(CoreError::NonCanonicalCbor));
    }

    #[test]
    fn non_shortest_uint_is_rejected() {
        // 0 == 0x18 0x00 (forma nieskrócona).
        let mut r = CborReader::new(&[0x18, 0x00]);
        assert_eq!(r.expect_uint(), Err(CoreError::NonCanonicalCbor));
        // 255 == 0x19 0x00 0xff.
        let mut r = CborReader::new(&[0x19, 0x00, 0xff]);
        assert_eq!(r.expect_uint(), Err(CoreError::NonCanonicalCbor));
        // 65535 == 0x1a 0x00 0x00 0xff 0xff.
        let mut r = CborReader::new(&[0x1a, 0x00, 0x00, 0xff, 0xff]);
        assert_eq!(r.expect_uint(), Err(CoreError::NonCanonicalCbor));
    }

    #[test]
    fn indefinite_and_reserved_lengths_are_rejected() {
        // ai = 31 (nieokreślona), major 2.
        let mut r = CborReader::new(&[0x5f, 0x41, 0xaa, 0xff]);
        assert_eq!(r.expect_bstr(16), Err(CoreError::NonCanonicalCbor));
        // ai = 29 (zarezerwowane).
        let mut r = CborReader::new(&[0x1d, 0x00]);
        assert_eq!(r.expect_uint(), Err(CoreError::NonCanonicalCbor));
        // ai = 30 (zarezerwowane) w mapie.
        let mut r = CborReader::new(&[0xbe]);
        assert_eq!(r.expect_map(), Err(CoreError::NonCanonicalCbor));
    }

    #[test]
    fn wrong_major_types_are_rejected() {
        // 0x20 = nint(-1) — niedozwolone w protokole.
        let mut r = CborReader::new(&[0x20]);
        assert_eq!(r.expect_uint(), Err(CoreError::NonCanonicalCbor));
        // 0x61 'a' = text — niedozwolone.
        let mut r = CborReader::new(&[0x61, 0x61]);
        assert_eq!(r.expect_bstr(8), Err(CoreError::NonCanonicalCbor));
        // 0x40 to bstr, nie mapa i nie tablica.
        let mut r = CborReader::new(&[0x40]);
        assert_eq!(r.expect_map(), Err(CoreError::NonCanonicalCbor));
        let mut r = CborReader::new(&[0x40]);
        assert_eq!(r.expect_array(4), Err(CoreError::NonCanonicalCbor));
        // 0xc0 = tag(0) — niedozwolone.
        let mut r = CborReader::new(&[0xc0, 0x00]);
        assert_eq!(r.expect_uint(), Err(CoreError::NonCanonicalCbor));
        // 0xf6 = null (major 7).
        let mut r = CborReader::new(&[0xf6]);
        assert_eq!(r.next_item_bytes(0), Err(CoreError::NonCanonicalCbor));
    }

    #[test]
    fn trailing_bytes_and_truncation_are_rejected() {
        let mut w = CborWriter::new();
        w.put_uint(5);
        let mut bytes = w.into_bytes();
        bytes.push(0x00);

        let r = CborReader::new(&bytes);
        assert!(!r.at_end());
        assert_eq!(r.expect_end(), Err(CoreError::NonCanonicalCbor));

        // Obcięty bstr: deklaruje 4 bajty, ma 2.
        let mut r = CborReader::new(&[0x44, 0xaa, 0xbb]);
        assert_eq!(r.expect_bstr(16), Err(CoreError::NonCanonicalCbor));

        // Obcięta mapa: deklaruje 1 parę, brak wartości.
        let mut r = CborReader::new(&[0xa1, 0x01]);
        assert!(r.expect_map().is_ok());
        assert_eq!(r.expect_uint().expect("key"), 1);
        assert_eq!(r.expect_uint(), Err(CoreError::NonCanonicalCbor));
    }

    #[test]
    fn next_item_bytes_walks_nested_maps_and_arrays_with_depth_limit() {
        // Mapa {1: [bstr(2), uint(7)]}.
        let mut w = CborWriter::new();
        w.put_map(1);
        w.put_uint(1);
        w.put_array(2);
        w.put_bstr(&[0xde, 0xad]);
        w.put_uint(7);
        let bytes = w.into_bytes();

        let mut r = CborReader::new(&bytes);
        let item = r.next_item_bytes(0).expect("item");
        assert_eq!(item, &bytes[..]);
        r.expect_end().expect("end");

        // Zagnieżdżenie ponad MAX_DEPTH = odrzucone.
        let mut r = CborReader::new(&bytes);
        assert_eq!(
            r.next_item_bytes(MAX_DEPTH),
            Err(CoreError::NonCanonicalCbor)
        );
    }
}
