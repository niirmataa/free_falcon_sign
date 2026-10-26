//! PRSS: pairwise seeds i udziały zera (bez dealera).
//!
//! Model: strony `i,j` znają wspólny klucz pary `ρ_ij` (w protokole
//! uzgodniony przez uwierzytelniony kanał — transport/TLS, G2). Ten moduł
//! **nie** robi wymiany kluczy; rozwija klucz w strumień PRF i składa
//! udziały zera.
//!
//! Dla pary `(i,j)` strona o niższym indeksie dostaje `+ρ`, wyższa `−ρ`
//! modulo `q` (albo to samo `ρ` w GF(2^8), gdzie `−ρ = ρ`). Suma udziałów
//! zera po wszystkich stronach wynosi 0, więc maskowanie nie zmienia
//! otwieranej wartości.
//!
//! **Granica:** to jest budulec PRSS, a nie pełny protokół CDI z dowodem
//! bezpieczeństwa. Klucze par muszą pochodzić z uwierzytelnionej wymiany;
//! PRF to SHAKE256 (nie FNV ze spike'a — świadome odejście od prototypu).

use std::collections::BTreeMap;

use sha3::Shake256;
use sha3::digest::{ExtendableOutput, Update, XofReader};
use zeroize::{Zeroize, ZeroizeOnDrop};

use crate::MAX_PARTIES_V1;
use crate::error::{CoreError, Result};
use crate::ring::{Q, add_mod, sub_mod};

/// Domena wyprowadzania klucza pary.
pub const PAIR_KEY_DOMAIN: &[u8] = b"FT1536-P2/prss-pair/v1";

/// Klucz pary stron (32 B). Brak `Clone`; drop zeroizuje, `Debug` nie
/// pokazuje materiału klucza.
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct PairwiseKey {
    bytes: [u8; 32],
}

impl PairwiseKey {
    /// Tworzy klucz z bajtów (np. z KDF transportu albo testu).
    pub fn from_bytes(bytes: [u8; 32]) -> Self {
        Self { bytes }
    }

    /// Porównanie w stałym przepływie.
    pub fn ct_eq(&self, other: &Self) -> bool {
        let mut diff = 0u8;
        for i in 0..32 {
            diff |= self.bytes[i] ^ other.bytes[i];
        }
        diff == 0
    }

    /// PRF: 8 bajtów z `key || counter || label`, interpretowane big-endian.
    fn prf_u64(&self, counter: u64, label: &[u8]) -> u64 {
        let mut h = Shake256::default();
        h.update(&self.bytes);
        h.update(&counter.to_be_bytes());
        h.update(label);
        let mut out = [0u8; 8];
        let mut reader = h.finalize_xof();
        reader.read(&mut out);
        u64::from_be_bytes(out)
    }

    /// PRF: jeden bajt (dla GF(2^8)).
    fn prf_byte(&self, counter: u64, label: &[u8]) -> u8 {
        let mut h = Shake256::default();
        h.update(&self.bytes);
        h.update(&counter.to_be_bytes());
        h.update(label);
        let mut out = [0u8; 1];
        let mut reader = h.finalize_xof();
        reader.read(&mut out);
        out[0]
    }
}

impl std::fmt::Debug for PairwiseKey {
    /// Debug celowo **nie** pokazuje materiału klucza.
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str("PairwiseKey(..)")
    }
}

/// Wyprowadza klucz pary z nonce'ów stron i kontekstu sesji.
///
/// Nonce są sortowane leksykograficznie, więc obie strony dostają ten sam
/// klucz. Puste lub identyczne nonce są odrzucane (fail-closed). Długości
/// są wstawiane do absorpcji, żeby granice danych były jednoznaczne.
pub fn pair_key(nonce_a: &[u8], nonce_b: &[u8], context: &[u8]) -> Result<PairwiseKey> {
    if nonce_a.is_empty() || nonce_b.is_empty() || nonce_a == nonce_b {
        return Err(CoreError::InvalidInput);
    }
    let (a, b) = if nonce_a <= nonce_b {
        (nonce_a, nonce_b)
    } else {
        (nonce_b, nonce_a)
    };
    let len_a = u32::try_from(a.len()).map_err(|_| CoreError::InvalidLength)?;
    let len_b = u32::try_from(b.len()).map_err(|_| CoreError::InvalidLength)?;
    let len_ctx = u32::try_from(context.len()).map_err(|_| CoreError::InvalidLength)?;

    let mut input =
        Vec::with_capacity(PAIR_KEY_DOMAIN.len() + 12 + context.len() + a.len() + b.len());
    input.extend_from_slice(PAIR_KEY_DOMAIN);
    input.extend_from_slice(&len_ctx.to_be_bytes());
    input.extend_from_slice(context);
    input.extend_from_slice(&len_a.to_be_bytes());
    input.extend_from_slice(a);
    input.extend_from_slice(&len_b.to_be_bytes());
    input.extend_from_slice(b);

    let mut bytes = [0u8; 32];
    let mut h = Shake256::default();
    h.update(&input);
    let mut reader = h.finalize_xof();
    reader.read(&mut bytes);
    Ok(PairwiseKey { bytes })
}

/// Klucze par jednej strony i operacje na udziałach zera.
///
/// `me` to indeks strony (0..n-1), `n` liczba stron. Wszystkie pary
/// `(i,j)` dla `i<j` muszą być obecne; brak klucza to `MissingKey`.
pub struct PairwiseKeys {
    me: usize,
    n: usize,
    keys: BTreeMap<(usize, usize), PairwiseKey>,
}

impl std::fmt::Debug for PairwiseKeys {
    /// Debug pokazuje wyłącznie indeksy i liczbę par, nie klucze.
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("PairwiseKeys")
            .field("me", &self.me)
            .field("n", &self.n)
            .field("pairstotal", &self.keys.len())
            .finish()
    }
}

impl PairwiseKeys {
    /// Buduje zestaw kluczy strony; waliduje liczbę stron i kompletność par.
    pub fn new(me: usize, n: usize, keys: BTreeMap<(usize, usize), PairwiseKey>) -> Result<Self> {
        if !(2..=MAX_PARTIES_V1).contains(&n) || me >= n {
            return Err(CoreError::PartyCountMismatch);
        }
        for i in 0..n {
            for j in (i + 1)..n {
                if !keys.contains_key(&(i, j)) {
                    return Err(CoreError::MissingKey);
                }
            }
        }
        Ok(Self { me, n, keys })
    }

    /// Indeks tej strony.
    pub fn me(&self) -> usize {
        self.me
    }

    /// Liczba stron.
    pub fn n(&self) -> usize {
        self.n
    }

    /// Udział zera w `Z_q` dla pary `(me, other)` i licznika.
    pub fn zero_share_zq(&self, other: usize, counter: u64) -> Result<u16> {
        if other >= self.n || other == self.me {
            return Err(CoreError::PartyCountMismatch);
        }
        let key = self
            .keys
            .get(&(self.me.min(other), self.me.max(other)))
            .ok_or(CoreError::MissingKey)?;
        let rho = (key.prf_u64(counter, b"zq") % Q as u64) as u16;
        Ok(if self.me < other {
            rho
        } else {
            sub_mod(0, rho)
        })
    }

    /// Udział zera w GF(2^8) dla pary `(me, other)` i licznika.
    pub fn zero_share_gf256(&self, other: usize, counter: u64) -> Result<u8> {
        if other >= self.n || other == self.me {
            return Err(CoreError::PartyCountMismatch);
        }
        let key = self
            .keys
            .get(&(self.me.min(other), self.me.max(other)))
            .ok_or(CoreError::MissingKey)?;
        // W charakterystyce 2: -ρ = ρ, więc znak nie jest potrzebny.
        Ok(key.prf_byte(counter, b"gf"))
    }

    /// Suma udziałów zera tej strony w `Z_q` (powinna znosić się z innymi).
    pub fn sum_zq(&self, counter: u64) -> Result<u16> {
        let mut acc = 0u16;
        for other in 0..self.n {
            if other == self.me {
                continue;
            }
            acc = add_mod(acc, self.zero_share_zq(other, counter)?);
        }
        Ok(acc)
    }

    /// XOR udziałów zera tej strony w GF(2^8).
    pub fn sum_gf256(&self, counter: u64) -> Result<u8> {
        let mut acc = 0u8;
        for other in 0..self.n {
            if other == self.me {
                continue;
            }
            acc ^= self.zero_share_gf256(other, counter)?;
        }
        Ok(acc)
    }
}

/// Buduje komplet kluczy dla strony `me` z deterministycznych nonce'ów.
///
/// To helper **testowy/protokolowy**: nonce stron muszą być unikalne
/// i uwierzytelnione. Nie jest to wymiana kluczy.
pub fn keys_from_nonces(
    me: usize,
    n: usize,
    nonces: &[Vec<u8>],
    context: &[u8],
) -> Result<PairwiseKeys> {
    if nonces.len() != n {
        return Err(CoreError::PartyCountMismatch);
    }
    let mut keys = BTreeMap::new();
    for i in 0..n {
        for j in (i + 1)..n {
            keys.insert((i, j), pair_key(&nonces[i], &nonces[j], context)?);
        }
    }
    PairwiseKeys::new(me, n, keys)
}

#[cfg(test)]
mod tests {
    use super::{PAIR_KEY_DOMAIN, PairwiseKey, PairwiseKeys, keys_from_nonces, pair_key};
    use crate::error::CoreError;
    use std::collections::BTreeMap;

    const CTX: &[u8] = b"FT1536-P2/prss/v1";

    fn nonces(n: usize) -> Vec<Vec<u8>> {
        (0..n).map(|i| vec![0x20 + i as u8; 16]).collect()
    }

    fn party(me: usize, n: usize) -> PairwiseKeys {
        keys_from_nonces(me, n, &nonces(n), CTX).expect("keys")
    }

    #[test]
    fn pair_key_is_symmetric_and_context_bound() {
        let a = pair_key(b"alice", b"bob", CTX).expect("a");
        let b = pair_key(b"bob", b"alice", CTX).expect("b");
        assert!(a.ct_eq(&b));
        let c = pair_key(b"alice", b"bob", b"other").expect("c");
        assert!(!a.ct_eq(&c));
    }

    #[test]
    fn pair_key_rejects_bad_nonces() {
        assert_eq!(
            pair_key(b"", b"bob", CTX).unwrap_err(),
            CoreError::InvalidInput
        );
        assert_eq!(
            pair_key(b"same", b"same", CTX).unwrap_err(),
            CoreError::InvalidInput
        );
    }

    #[test]
    fn pair_key_matches_independent_python_kat() {
        let k01 = pair_key(&nonces(3)[0], &nonces(3)[1], CTX).expect("k01");
        let expected = hex("832e14778fc150a660a13e74a2b9129f4a4cafe887985dc083f8e565d3ac239d");
        assert!(k01.ct_eq(&expected));
        let k02 = pair_key(&nonces(3)[0], &nonces(3)[2], CTX).expect("k02");
        let expected = hex("530ce4373c25d1bde880f80034c0d5096a2821cdea97f917b4b32d310d8b6fee");
        assert!(k02.ct_eq(&expected));
        let k12 = pair_key(&nonces(3)[1], &nonces(3)[2], CTX).expect("k12");
        let expected = hex("d121a2c2c52a620c2000af96158907f014a0f0f52c672b7fbb4363babd75249a");
        assert!(k12.ct_eq(&expected));
        assert_eq!(PAIR_KEY_DOMAIN, b"FT1536-P2/prss-pair/v1");
    }

    #[test]
    fn zero_shares_cancel_across_three_parties_zq() {
        for counter in 0..8u64 {
            let sum = (0..3)
                .map(|me| party(me, 3).sum_zq(counter).expect("sum"))
                .fold(0u16, crate::ring::add_mod);
            assert_eq!(sum, 0, "counter {counter}");
        }
    }

    #[test]
    fn zero_shares_cancel_across_three_parties_gf256() {
        for counter in 0..8u64 {
            let x = (0..3)
                .map(|me| party(me, 3).sum_gf256(counter).expect("sum"))
                .fold(0u8, |acc, v| acc ^ v);
            assert_eq!(x, 0, "counter {counter}");
        }
    }

    #[test]
    fn zero_share_kat_counter_7() {
        let p0 = party(0, 3);
        let p1 = party(1, 3);
        let p2 = party(2, 3);
        assert_eq!(p0.zero_share_zq(1, 7).unwrap(), 10130);
        assert_eq!(p0.zero_share_zq(2, 7).unwrap(), 2262);
        assert_eq!(p1.zero_share_zq(0, 7).unwrap(), 8303);
        assert_eq!(p1.zero_share_zq(2, 7).unwrap(), 3554);
        assert_eq!(p2.zero_share_zq(0, 7).unwrap(), 16171);
        assert_eq!(p2.zero_share_zq(1, 7).unwrap(), 14879);
        // Pary muszą znosić się osobno: (0,1), (0,2), (1,2).
        assert_eq!(crate::ring::add_mod(10130, 8303), 0);
        assert_eq!(crate::ring::add_mod(2262, 16171), 0);
        assert_eq!(crate::ring::add_mod(3554, 14879), 0);
        // GF(2^8): 196/227, 196/190, 227/190.
        assert_eq!(p0.zero_share_gf256(1, 7).unwrap(), 196);
        assert_eq!(p0.zero_share_gf256(2, 7).unwrap(), 227);
        assert_eq!(p1.zero_share_gf256(0, 7).unwrap(), 196);
        assert_eq!(p1.zero_share_gf256(2, 7).unwrap(), 190);
        assert_eq!(p2.zero_share_gf256(0, 7).unwrap(), 227);
        assert_eq!(p2.zero_share_gf256(1, 7).unwrap(), 190);
    }

    #[test]
    fn missing_pair_key_is_rejected() {
        let mut keys = BTreeMap::new();
        keys.insert((0, 1), pair_key(b"a", b"b", CTX).expect("pair"));
        // Brakuje (0,2) i (1,2).
        assert_eq!(
            PairwiseKeys::new(0, 3, keys).unwrap_err(),
            CoreError::MissingKey
        );
    }

    #[test]
    fn party_count_is_validated() {
        let keys = BTreeMap::new();
        assert_eq!(
            PairwiseKeys::new(0, 1, keys).unwrap_err(),
            CoreError::PartyCountMismatch
        );
        assert_eq!(
            PairwiseKeys::new(3, 3, BTreeMap::new()).unwrap_err(),
            CoreError::PartyCountMismatch
        );
        assert_eq!(
            PairwiseKeys::new(0, crate::MAX_PARTIES_V1 + 1, BTreeMap::new()).unwrap_err(),
            CoreError::PartyCountMismatch
        );
    }

    #[test]
    fn zero_share_rejects_self_and_out_of_range() {
        let p = party(0, 3);
        assert_eq!(
            p.zero_share_zq(0, 0).unwrap_err(),
            CoreError::PartyCountMismatch
        );
        assert_eq!(
            p.zero_share_zq(3, 0).unwrap_err(),
            CoreError::PartyCountMismatch
        );
    }

    fn hex(s: &str) -> PairwiseKey {
        let mut bytes = [0u8; 32];
        for (i, chunk) in s.as_bytes().chunks(2).enumerate() {
            bytes[i] =
                u8::from_str_radix(std::str::from_utf8(chunk).expect("utf8"), 16).expect("hex");
        }
        PairwiseKey::from_bytes(bytes)
    }
}
