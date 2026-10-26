//! Kanoniczny CBOR (RFC 8949, deterministic encoding) — podzbiór wire v1
//! (WP-027, SPEC §9.2).
//!
//! **Zakres.** Wyłącznie to, czego używa protokół: `uint` (major 0),
//! `bstr` (major 2) i mapy (major 5) z kluczami `uint`. Wszystko inne
//! (nint, text, array, tag, float/simple, długości nieokreślone) jest
//! **odrzucane**. To świadomie mały, ścisły dekoder, nie ogólny CBOR.
//!
//! **Kanoniczność jest wymuszona, nie akceptowana.** Dekoder odrzuca:
//! formę nieskróconą (`0x18 0x00`), długości nieokreślone (`ai = 31`),
//! wartości zarezerwowane (`ai = 28..30`), bajty po elemencie, bstr
//! przekraczające limit oraz (na poziomie map, patrz `map` w
//! `envelope.rs`) klucze nieposortowane/podwójne/nieznane. Kodowanie
//! najkrótszą formą jest testowane wektorami RFC 8949 (Apendyks A).
//!
//! **Granica.** To warstwa formatu, nie kryptografia; MAC i `msg_id`
//! liczy `envelope.rs` na bajtach, które tutaj wychodzą.

use ft_threshold_core::error::{CoreError, Result};

/// Maksymalny pojedynczy element `bstr` (SPEC §9.2: max bstr 16 MiB).
pub const MAX_ITEM_BYTES: usize = 16 << 20;

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
        if len > max || len > self.b.len() - self.pos {
            return Err(CoreError::NonCanonicalCbor);
        }
        let out = &self.b[self.pos..self.pos + len];
        self.pos += len;
        Ok(out)
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
                if len > self.b.len() - self.pos {
                    return Err(CoreError::NonCanonicalCbor);
                }
                self.pos += len;
            }
            5 => {
                let pairs = usize::try_from(h.value).map_err(|_| CoreError::NonCanonicalCbor)?;
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
        // W protokole istnieją tylko uint (0), bstr (2) i mapa (5);
        // nint/text/array/tag/float są odrzucane centralnie.
        if !matches!(major, 0 | 2 | 5) {
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
    use super::{CborReader, CborWriter, MAX_DEPTH};
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
        // 0x40 to bstr, nie mapa.
        let mut r = CborReader::new(&[0x40]);
        assert_eq!(r.expect_map(), Err(CoreError::NonCanonicalCbor));
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
    fn next_item_bytes_walks_nested_maps_with_depth_limit() {
        // Mapa {1: bstr(2)}.
        let mut w = CborWriter::new();
        w.put_map(1);
        w.put_uint(1);
        w.put_bstr(&[0xde, 0xad]);
        let bytes = w.into_bytes();

        let mut r = CborReader::new(&bytes);
        let item = r.next_item_bytes(0).expect("item");
        assert_eq!(item, &bytes[..]);
        r.expect_end().expect("end");

        // Zagnieżdżenie ponad MAX_DEPTH = odrzucone.
        let mut r = CborReader::new(&bytes);
        assert_eq!(
            r.next_item_bytes(MAX_DEPTH + 1),
            Err(CoreError::NonCanonicalCbor)
        );
    }
}
