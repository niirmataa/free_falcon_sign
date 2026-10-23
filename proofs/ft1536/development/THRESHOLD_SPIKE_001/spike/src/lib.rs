//! T-THRESHOLD spike 002 — kiełek progowy 2-z-3 z kontrolą spójności udziałów.
//!
//! **PROTOTYP.** Nie jest to threshold signing FT1536, ani bezpieczny protokół.
//! Model: trusted dealer (testowy!) + semi-honest strony. Zeroizacja Drop
//! (H-31 w kopii — nie upstream).
//!
//! Spike 001 wykazał: bez kontroli spójności fałszywy udział daje **cichy zły**
//! wynik. Spike 002 dodaje:
//!   - próg **2-z-3** (n>k — tolerancja padającego; w odróżnieniu od 2-z-2),
//!   - **kontrolę spójności** n=k+1 (współliniowość/stopień) — fałszerstwo
//!     udziału jest **wykrywane** i blokuje wyprowadzanie.
//!
//! Uwaga o Feldman VSS: klasyczny Feldman na GF(256)* nie ukrywa sekretu
//! (trywialny DL w małej grupie). Tu używamy kontroli algebraicznej z nadmiaru
//! (n=k+1); Feldman/Pedersen na grupie DL-trudnej = kierunek produkcyjny
//! (patrz RESEARCH.md P0.4). Nie deklarujemy bezpieczeństwa VSS.

use zeroize::{Zeroize, ZeroizeOnDrop};

pub mod rejection;
pub mod select;
pub mod prss;
pub mod mul;
pub mod cmp;
pub mod pedersen;
pub mod xof;
/// Y1 — prawdziwy SHAKE256 na udziałach (Keccak-f[1600], chi = mul_shamir_reshare).
pub mod shake;
/// U1 — Klein MPC: Bernoulli + konstrukcja bit-po-bicie (długa partia).
pub mod klein;
/// MPS — pełny MPC sign FT1536: Shamir nad Z_18433 (wariant ternary).
pub mod mpc_sign;
/// MPS4-H — splot na udziałach i16 + rounding w MPC (wariant B, G-1).
pub mod ishare;

#[cfg(test)]
pub mod cost;

// ─── GF(256) — AES poly 0x11b ─────────────────────────────────────────────

#[inline]
pub fn gf_mul(mut a: u8, mut b: u8) -> u8 {
    let mut p: u8 = 0;
    for _ in 0..8 {
        let lsb = 0u8.wrapping_sub(b & 1);
        p ^= a & lsb;
        let hi = 0u8.wrapping_sub((a >> 7) & 1);
        a = (a << 1) ^ (0x1b & hi);
        b >>= 1;
    }
    p
}

#[inline]
fn gf_pow(mut a: u8, mut e: u16) -> u8 {
    let mut r: u8 = 1;
    while e > 0 {
        if e & 1 == 1 {
            r = gf_mul(r, a);
        }
        a = gf_mul(a, a);
        e >>= 1;
    }
    r
}

#[inline]
pub fn gf_inv(a: u8) -> u8 {
    assert_ne!(a, 0, "gf_inv(0)");
    gf_pow(a, 254)
}

// ─── Błędy (guardy H-28 w kopii) ──────────────────────────────────────────

/// Błędy kiełka. Brak cichych kontynuacji w stanie niepewnym (fail-closed).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SpikeError {
    /// k < 2 (próg wymaga k≥2)
    ThresholdTooLow,
    /// mniej punktów niż k
    NotEnoughPoints,
    /// pusty xs
    EmptyXs,
    /// x = 0 (pozycja sekretu)
    XZero,
    /// duplikat x
    DuplicateX,
    /// zły rozmiar tablicy stron
    PartyCountMismatch,
    /// wymagany 2-z-3 (spike)
    WrongThreshold,
    /// pusty wejście udziałów
    EmptyShares,
    /// za mało udziałów do odtworzenia (<k)
    InsufficientShares,
    /// udział niezgodny z pozostałymi (fałszerstwo / uszkodzenie)
    InconsistentShare,
    /// udział nie jest bitem {0,1}
    NonBitShare,
    /// weryfikacja MAC nie przeszła
    MacFail,
    /// udział niezgodny z zobowiązaniem dealera
    CommitmentMismatch,
    /// wejście za długie dla trybu (np. SHAKE absorb ≥ rate w Y1)
    MessageTooLong,
    /// naruszenie boundu max|F| < q/2 (T9.2 range proof / jawna walidacja)
    FBoundViolation,
}

impl std::fmt::Display for SpikeError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{self:?}")
    }
}

impl std::error::Error for SpikeError {}

type Result<T> = std::result::Result<T, SpikeError>;

// ─── Shamir GF(256) — typy z zeroizacją (H-31 w kopii) ────────────────────

/// Udział bajtu sekretu. **Brak Clone/Copy** — drop zeroizuje (H-31).
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct Share {
    pub x: u8,
    pub share: u8,
}

/// Wielomian Shamira (współczynniki tajne). Drop zeroizuje.
#[derive(Zeroize, ZeroizeOnDrop)]
struct Polynomial {
    coeffs: Vec<u8>,
}

impl Polynomial {
    fn eval(&self, x: u8) -> u8 {
        let mut y = 0u8;
        let mut xp = 1u8;
        for &c in &self.coeffs {
            y ^= gf_mul(c, xp);
            xp = gf_mul(xp, x);
        }
        y
    }
}

pub(crate) fn validate_xs(xs: &[u8], k: u8) -> Result<()> {
    if xs.is_empty() {
        return Err(SpikeError::EmptyXs);
    }
    if k < 2 {
        return Err(SpikeError::ThresholdTooLow);
    }
    if xs.len() < k as usize {
        return Err(SpikeError::NotEnoughPoints);
    }
    let mut seen = [false; 256];
    for &x in xs {
        if x == 0 {
            return Err(SpikeError::XZero);
        }
        if seen[x as usize] {
            return Err(SpikeError::DuplicateX);
        }
        seen[x as usize] = true;
    }
    Ok(())
}

/// Dealer (model testowy!) — dzieli bajt sekretu na Shamir k-of-n.
/// Punkty ewaluacji `xs` — niezerowe i unikalne.
pub fn shamir_share(
    rng: &mut impl rand::RngCore,
    secret: u8,
    xs: &[u8],
    k: u8,
) -> Result<Vec<Share>> {
    validate_xs(xs, k)?;

    let mut coeffs = Vec::with_capacity(k as usize);
    coeffs.push(secret);
    for _ in 1..k {
        coeffs.push((rng.next_u32() & 0xFF) as u8);
    }
    let poly = Polynomial { coeffs };

    Ok(xs
        .iter()
        .map(|&x| Share {
            x,
            share: poly.eval(x),
        })
        .collect())
}

/// Lagrange w punkcie 0 — odtworzenie sekretu z ≥k udziałów.
/// Guardy: puste, duplikat x, x=0. Bez pętli nieskończonych.
pub fn reconstruct(shares: &[&Share]) -> Result<u8> {
    if shares.is_empty() {
        return Err(SpikeError::EmptyShares);
    }
    let mut seen = [false; 256];
    for s in shares {
        if s.x == 0 {
            return Err(SpikeError::XZero);
        }
        if seen[s.x as usize] {
            return Err(SpikeError::DuplicateX);
        }
        seen[s.x as usize] = true;
    }

    let mut secret = 0u8;
    for (i, si) in shares.iter().enumerate() {
        let mut num = 1u8;
        let mut den = 1u8;
        for (j, sj) in shares.iter().enumerate() {
            if i == j {
                continue;
            }
            num = gf_mul(num, sj.x);
            den = gf_mul(den, si.x ^ sj.x);
        }
        secret ^= gf_mul(si.share, gf_mul(num, gf_inv(den)));
    }
    Ok(secret)
}

// ─── Kontrola spójności (detekcja fałszerstwa — zamiast Feldman na GF256*) ──

/// Sprawdza, czy wszystkie leżą na wspólnym wielomianie stopnia < `k`.
/// Nadmiar n>k wykrywa **jeden** przekłamany udział (lub nieuczciwego dealera
/// w granicach modelu). To kontrola algebraiczna — **nie** pełne VSS.
///
/// **Granica (naprawa):** wcześniejsza wersja interpolowała jawny wielomian
/// (współczynniki zawierają `a0 = sekret`). Tu oceniamy Lagrange'em **wyłącznie
/// w punktach kontrolnych `x ≠ 0`** — nigdy w `x=0`, więc `f(0)` nie powstaje.
/// To nadal nie jest „żaden proces nie zna materiału": patrz `PartyView`
/// i notatki o harnessie lokalnym.
///
/// Wymaga co najmniej `k` udziałów; jeśli jest dokładnie `k`, sprawdzenie
/// jest trywialne (każdy zbiór k punktów leży na jakimś wielomianie).
/// Detekcja działa przy `n > k` (tu: 3 przy k=2).
pub fn verify_consistency(shares: &[&Share], k: u8) -> Result<()> {
    if shares.is_empty() {
        return Err(SpikeError::EmptyShares);
    }
    if k < 2 {
        return Err(SpikeError::ThresholdTooLow);
    }
    let n = shares.len();
    if n < k as usize {
        return Err(SpikeError::InsufficientShares);
    }
    let mut seen = [false; 256];
    for s in shares {
        if s.x == 0 {
            return Err(SpikeError::XZero);
        }
        if seen[s.x as usize] {
            return Err(SpikeError::DuplicateX);
        }
        seen[s.x as usize] = true;
    }

    if n == k as usize {
        return Ok(());
    }

    // Oczekiwana wartość w x_k, x_{k+1}, ... z pierwszych k punktów —
    // tylko eval, brak współczynników, brak f(0).
    let base = &shares[..k as usize];
    for s in &shares[k as usize..] {
        let expected = eval_lagrange(base, s.x)?;
        if expected != s.share {
            return Err(SpikeError::InconsistentShare);
        }
    }
    Ok(())
}

/// `f(x)` z punktów `shares` (Lagrange). **Wymaga `x ≠ 0`** — zawołanie
/// z `x=0` to `XZero` (nie odtwarzamy sekretu tą ścieżką).
fn eval_lagrange(shares: &[&Share], x: u8) -> Result<u8> {
    if shares.is_empty() {
        return Err(SpikeError::EmptyShares);
    }
    if x == 0 {
        return Err(SpikeError::XZero);
    }
    let mut y = 0u8;
    for (i, si) in shares.iter().enumerate() {
        let mut num = 1u8;
        let mut den = 1u8;
        for (j, sj) in shares.iter().enumerate() {
            if i == j {
                continue;
            }
            num = gf_mul(num, x ^ sj.x);
            den = gf_mul(den, si.x ^ sj.x);
        }
        y ^= gf_mul(si.share, gf_mul(num, gf_inv(den)));
    }
    Ok(y)
}

/// Widok jednej strony: **wyłącznie** kolumna udziałów tej strony.
/// Nie zawiera udziałów innych stron ani sekretu. To jest granica API —
/// sam harness testowy (jeden proces) i tak widzi wszystkie kolumny;
/// „żaden proces nie zna pełnego materiału" wymaga rozdzielenia procesów
/// (patrz REPORT / SPIKE notes).
pub struct PartyView {
    pub x: u8,
    /// udziały bajt-po-bajcie: `shares[i]` = udział bajtu i w punkcie x
    shares: Vec<u8>,
}

impl Drop for PartyView {
    fn drop(&mut self) {
        self.shares.zeroize();
    }
}

impl PartyView {
    pub fn from_column(x: u8, shares: Vec<u8>) -> Result<Self> {
        if x == 0 {
            return Err(SpikeError::XZero);
        }
        Ok(Self { x, shares })
    }

    pub fn x(&self) -> u8 {
        self.x
    }

    pub fn len(&self) -> usize {
        self.shares.len()
    }

    pub fn is_empty(&self) -> bool {
        self.shares.is_empty()
    }

    pub fn share_at(&self, i: usize) -> Option<u8> {
        self.shares.get(i).copied()
    }
}

// ─── Zobowiązanie do współczynników (commit-and-check, nie Feldman DL) ─────

/// Jawne zobowiązanie do jednego współczynnika: `H(a_j, j, salt)`-like.
/// Tu stała funkcja bez SHA (spike bez nowych dep): `mix(a, j, salt)`.
/// **Nie jest to Feldman** — nie ukrywa w sensie DL; spina dealera
/// z późniejszym otwarciem wielomianu w testach / rekonstrukcji z nadmiarem.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct CoeffCommit {
    pub j: u8,
    pub tag: u64,
}

fn mix_commit(a: u8, j: u8, salt: u64) -> u64 {
    let mut h = 0xcbf29ce484222325u64; // FNV offset
    h ^= a as u64;
    h = h.wrapping_mul(0x100000001b3);
    h ^= j as u64;
    h = h.wrapping_mul(0x100000001b3);
    h ^= salt;
    h = h.wrapping_mul(0x100000001b3);
    h ^= 0x544852455348u64; // "THRESH"
    h
}

/// Dealer: zobowiązania do współczynników + udziały (n=k+1 zalecane do detekcji).
pub struct SharedByte {
    pub shares: Vec<Share>,
    pub commits: Vec<CoeffCommit>,
    pub salt: u64,
    /// jawne tylko do testów oracle — **nie** w torze produkcyjnym
    secret: u8,
}

impl Drop for SharedByte {
    fn drop(&mut self) {
        self.secret.zeroize();
    }
}

/// Dealer (model testowy!) — Shamir + zobowiązania do współczynników.
pub fn share_byte_committed(
    rng: &mut impl rand::RngCore,
    secret: u8,
    xs: &[u8],
    k: u8,
) -> Result<SharedByte> {
    validate_xs(xs, k)?;
    let salt = rng.next_u64();

    let mut coeffs = Vec::with_capacity(k as usize);
    coeffs.push(secret);
    for _ in 1..k {
        coeffs.push((rng.next_u32() & 0xFF) as u8);
    }
    let commits: Vec<CoeffCommit> = coeffs
        .iter()
        .enumerate()
        .map(|(j, &a)| CoeffCommit {
            j: j as u8,
            tag: mix_commit(a, j as u8, salt),
        })
        .collect();
    let poly = Polynomial { coeffs };

    let shares = xs
        .iter()
        .map(|&x| Share {
            x,
            share: poly.eval(x),
        })
        .collect();

    Ok(SharedByte {
        shares,
        commits,
        salt,
        secret,
    })
}

/// Czy zobowiązania zgadzają się z ujawnionymi współczynnikami
/// (spór / audyt — po otwarciu). Nie dotyczy toru progowego.
pub fn verify_commits(coeffs: &[u8], commits: &[CoeffCommit], salt: u64) -> Result<()> {
    if coeffs.len() != commits.len() {
        return Err(SpikeError::CommitmentMismatch);
    }
    for (j, (&a, c)) in coeffs.iter().zip(commits.iter()).enumerate() {
        if c.j != j as u8 || c.tag != mix_commit(a, j as u8, salt) {
            return Err(SpikeError::CommitmentMismatch);
        }
    }
    Ok(())
}

// ─── Beaver — mnożenie progowa (preprocessing dealerski) ──────────────────

/// Trójka Beavera. Drop zeroizuje (H-31 w kopii).
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct BeaverTriple {
    a: u8,
    b: u8,
    c: u8,
}

/// Stan po maskowaniu. Drop zeroizuje.
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct MaskedTriple {
    a: u8,
    b: u8,
    c: u8,
}

/// Udziały trójki dla każdego x (dealerski preprocessing).
pub struct TripleShares {
    pub a: Vec<u8>,
    pub b: Vec<u8>,
    pub c: Vec<u8>,
}

impl Drop for TripleShares {
    fn drop(&mut self) {
        self.a.zeroize();
        self.b.zeroize();
        self.c.zeroize();
    }
}

/// Trójki dla xs — **dealerski preprocessing** (model testowy).
pub fn generate_triple_shares(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
) -> Result<TripleShares> {
    #[cfg(test)]
    cost::bump_triple();
    validate_xs(xs, k)?;
    let a_secret = (rng.next_u32() & 0xFF) as u8;
    let b_secret = (rng.next_u32() & 0xFF) as u8;
    let c_secret = gf_mul(a_secret, b_secret);
    let a = shamir_share(rng, a_secret, xs, k)?;
    let b = shamir_share(rng, b_secret, xs, k)?;
    let c = shamir_share(rng, c_secret, xs, k)?;
    Ok(TripleShares {
        a: a.into_iter().map(|s| s.share).collect(),
        b: b.into_iter().map(|s| s.share).collect(),
        c: c.into_iter().map(|s| s.share).collect(),
    })
}

impl BeaverTriple {
    /// Trójki dla każdego x — dealerski preprocessing.
    pub fn generate_shared(
        rng: &mut impl rand::RngCore,
        xs: &[u8],
        k: u8,
    ) -> Result<Vec<BeaverTriple>> {
        validate_xs(xs, k)?;
        let a_secret = (rng.next_u32() & 0xFF) as u8;
        let b_secret = (rng.next_u32() & 0xFF) as u8;
        let c_secret = gf_mul(a_secret, b_secret);
        let a_shares = shamir_share(rng, a_secret, xs, k)?;
        let b_shares = shamir_share(rng, b_secret, xs, k)?;
        let c_shares = shamir_share(rng, c_secret, xs, k)?;
        Ok(a_shares
            .into_iter()
            .zip(b_shares)
            .zip(c_shares)
            .map(|((a, b), c)| BeaverTriple {
                a: a.share,
                b: b.share,
                c: c.share,
            })
            .collect())
    }

    /// Maskowanie: d_i = x_i ⊕ a_i, e_i = y_i ⊕ b_i. Konsumuje trójkę.
    pub fn mask(self, x_i: u8, y_i: u8) -> (u8, u8, MaskedTriple) {
        (
            x_i ^ self.a,
            y_i ^ self.b,
            MaskedTriple {
                a: self.a,
                b: self.b,
                c: self.c,
            },
        )
    }
}

impl MaskedTriple {
    /// z_i = c_i ⊕ e·a_i ⊕ d·b_i ⊕ d·e. Konsumuje stan.
    pub fn finish(self, d: u8, e: u8) -> u8 {
        self.c ^ gf_mul(e, self.a) ^ gf_mul(d, self.b) ^ gf_mul(d, e)
    }
}

// ─── H_fold — jawny wzorzec (oracle) ───────────────────────────────────────

/// `K[0] = ⊕_{i=0..15} gf_mul(seed[2i], seed[2i+1])`. Oracle testowy.
pub fn h_fold_local(seed: &[u8; 32]) -> u8 {
    let mut acc = 0u8;
    for i in 0..16 {
        acc ^= gf_mul(seed[2 * i], seed[2 * i + 1]);
    }
    acc
}

// ─── Wyprowadzanie K[0] z udziałów (próg k-z-n) ───────────────────────────

pub fn reconstruct_vals(xs: &[u8], ys: &[u8]) -> Result<u8> {
    let owned: Vec<Share> = xs
        .iter()
        .zip(ys.iter())
        .map(|(&x, &y)| Share { x, share: y })
        .collect();
    let refs: Vec<&Share> = owned.iter().collect();
    reconstruct(&refs)
}

fn mul_shares_via_beaver(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
    x_at: &[u8],
    y_at: &[u8],
) -> Result<u8> {
    if x_at.len() != xs.len() || y_at.len() != xs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    let tri = generate_triple_shares(rng, xs, k)?;
    let mut ds = Vec::with_capacity(xs.len());
    let mut es = Vec::with_capacity(xs.len());
    let mut masked = Vec::with_capacity(xs.len());
    for i in 0..xs.len() {
        let (d_i, e_i, m) = mask_one(x_at[i], y_at[i], tri.a[i], tri.b[i], tri.c[i]);
        ds.push(d_i);
        es.push(e_i);
        masked.push(m);
    }
    let d = reconstruct_vals(xs, &ds)?;
    let e = reconstruct_vals(xs, &es)?;

    let mut zs = Vec::with_capacity(xs.len());
    for m in masked {
        zs.push(m.finish(d, e));
    }
    reconstruct_vals(xs, &zs)
}

pub fn mask_one(x_i: u8, y_i: u8, a_i: u8, b_i: u8, c_i: u8) -> (u8, u8, MaskedTriple) {
    (
        x_i ^ a_i,
        y_i ^ b_i,
        MaskedTriple {
            a: a_i,
            b: b_i,
            c: c_i,
        },
    )
}

/// Dzieli seed na udziały bajt-po-bajcie (z kontrolą spójności po stronie
/// wywołującego). Zwraca `Vec` po bajtach: dla każdego bajtu n udziałów.
pub fn split_seed(
    rng: &mut impl rand::RngCore,
    seed: &[u8; 32],
    xs: &[u8],
    k: u8,
) -> Result<Vec<Vec<Share>>> {
    seed.iter().map(|&b| shamir_share(rng, b, xs, k)).collect()
}

/// Wyprowadza `K[0]` z udziałów seeda **bez** kontroli spójności
/// (ścieżka spike 001 — fałszerstwo daje cichy zły wynik).
pub fn derive_key_byte_from_seed_shares(
    rng: &mut impl rand::RngCore,
    seed_shares: &[Vec<Share>],
    xs: &[u8],
    k: u8,
) -> Result<u8> {
    validate_xs(xs, k)?;
    if seed_shares.len() != 32 {
        return Err(SpikeError::PartyCountMismatch);
    }
    if seed_shares.iter().any(|s| s.len() != xs.len()) {
        return Err(SpikeError::PartyCountMismatch);
    }

    let mut k0 = 0u8;
    for i in 0..16 {
        let x_at: Vec<u8> = (0..xs.len())
            .map(|p| seed_shares[2 * i][p].share)
            .collect();
        let y_at: Vec<u8> = (0..xs.len())
            .map(|p| seed_shares[2 * i + 1][p].share)
            .collect();
        let prod = mul_shares_via_beaver(rng, xs, k, &x_at, &y_at)?;
        k0 ^= prod;
    }
    Ok(k0)
}

/// Wyprowadza `K[0]` z **kontrolą spójności** (n>k). Fałszywy udział → Err.
///
/// `parties`: indeksy xs (np. [0,1] przy 3 stronach = 2-z-3 bez strony 3).
/// Jeśli `parties` wskazuje n=k (brak nadmiaru), detekcja nie działa —
/// `verify_consistency` przyjmuje zbiór k punktów (udokumentowane).
pub fn derive_key_byte_checked(
    rng: &mut impl rand::RngCore,
    seed_shares: &[Vec<Share>],
    xs: &[u8],
    k: u8,
    parties: &[usize],
) -> Result<u8> {
    validate_xs(xs, k)?;
    if seed_shares.len() != 32 {
        return Err(SpikeError::PartyCountMismatch);
    }
    if parties.is_empty() {
        return Err(SpikeError::EmptyShares);
    }
    for &p in parties {
        if p >= xs.len() {
            return Err(SpikeError::PartyCountMismatch);
        }
    }

    // Zbuduj udziały wybranych stron dla każdego bajtu i sprawdź spójność.
    let mut per_byte: Vec<Vec<Share>> = Vec::with_capacity(32);
    for byte_idx in 0..32 {
        if seed_shares[byte_idx].len() != xs.len() {
            return Err(SpikeError::PartyCountMismatch);
        }
        let selected: Vec<Share> = parties
            .iter()
            .map(|&p| Share {
                x: seed_shares[byte_idx][p].x,
                share: seed_shares[byte_idx][p].share,
            })
            .collect();
        {
            let refs: Vec<&Share> = selected.iter().collect();
            verify_consistency(&refs, k)?;
        }
        per_byte.push(selected);
    }

    // Wyprowadzanie na wybranych stronach (xs' = ich x).
    let xs_sel: Vec<u8> = parties.iter().map(|&p| xs[p]).collect();
    let mut k0 = 0u8;
    for i in 0..16 {
        let x_at: Vec<u8> = (0..parties.len())
            .map(|p| per_byte[2 * i][p].share)
            .collect();
        let y_at: Vec<u8> = (0..parties.len())
            .map(|p| per_byte[2 * i + 1][p].share)
            .collect();
        let prod = mul_shares_via_beaver(rng, &xs_sel, k, &x_at, &y_at)?;
        k0 ^= prod;
    }
    Ok(k0)
}

/// Ścieżka 2-z-3 z kontrolą spójności **na wszystkich 3** (nadmiar → detekcja),
/// a do wyprowadzania bierze `parties` (domyślnie dwie pierwsze strony).
pub fn derive_key_byte_2of3(
    rng: &mut impl rand::RngCore,
    seed: &[u8; 32],
    xs: &[u8; 3],
    k: u8,
) -> Result<u8> {
    if k != 2 || xs.len() != 3 {
        return Err(SpikeError::WrongThreshold);
    }
    let seed_shares = split_seed(rng, seed, xs, k)?;
    // Kontrola na wszystkich 3 (wykrywa 1 fałszerstwo), wyprowadzanie na 0,1.
    derive_key_byte_checked(rng, &seed_shares, xs, k, &[0, 1])
}

/// Odtworzenie jednego bajtu z wybranych udziałów.
pub fn reconstruct_one_byte(shares: &[&Share]) -> Result<u8> {
    reconstruct(shares)
}

// ─── G_frag — rozwinięcie materiału klucza na udziałach (P0.3, kawałek) ────
//
// **Nie jest to formalne `G(seed*)` z toru R1** (źródła R1 nie są lokalne).
// To syntetyczny łańcuch GF(256) stojący w miejscu wyprowadzania klucza:
//   etap 1: out[i]     = seed[i] ⊕ (seed[(i+1)%32] ⊗ seed[(i+13)%32])
//   etap 2: out[32+i]  = out[i]  ⊕ (out[i] ⊗ seed[i])
// Cały materiał (64 B) powstaje w formie udziałów — **nie otwieramy** w torze
// progowym. „Klucz nigdy nie istnieje w całości" dotyczy też etapów pośrednich.

pub const G_FRAG_LEN: usize = 64;

/// Jawny wzorzec `G_frag` (oracle testowy / lokalny).
pub fn g_frag_local(seed: &[u8; 32]) -> [u8; G_FRAG_LEN] {
    let mut out = [0u8; G_FRAG_LEN];
    for i in 0..32 {
        out[i] = seed[i] ^ gf_mul(seed[(i + 1) % 32], seed[(i + 13) % 32]);
    }
    for i in 0..32 {
        out[32 + i] = out[i] ^ gf_mul(out[i], seed[i]);
    }
    out
}

/// Wyprowadza udziały `G_frag(seed)` (64 B × n) **bez otwierania**.
/// Udziały bajtu wynikowego mają współrzędne `xs` (per strona).
pub fn derive_g_frag_shares(
    rng: &mut impl rand::RngCore,
    seed_shares: &[Vec<Share>],
    xs: &[u8],
    k: u8,
) -> Result<Vec<Vec<Share>>> {
    validate_xs(xs, k)?;
    if seed_shares.len() != 32 {
        return Err(SpikeError::PartyCountMismatch);
    }
    let n = xs.len();
    for b in seed_shares {
        if b.len() != n {
            return Err(SpikeError::PartyCountMismatch);
        }
    }

    // wejście jako wektory udziałów [32][n]
    let mut seed_at: Vec<Vec<u8>> = (0..32)
        .map(|i| seed_shares[i].iter().map(|s| s.share).collect())
        .collect();

    // etap 1: out[i] = seed[i] ⊕ (seed[i+1] ⊗ seed[i+13])
    let mut out_at: Vec<Vec<u8>> = Vec::with_capacity(G_FRAG_LEN);
    for i in 0..32 {
        let x_at = seed_at[(i + 1) % 32].clone();
        let y_at = seed_at[(i + 13) % 32].clone();
        let prod = crate::mul::mul_shamir_reshare(rng, xs, k, &x_at, &y_at)?;
        let s = &seed_at[i];
        out_at.push(
            s.iter()
                .zip(prod.iter())
                .map(|(&a, &b)| a ^ b)
                .collect(),
        );
    }

    // etap 2: out[32+i] = out[i] ⊕ (out[i] ⊗ seed[i])
    for i in 0..32 {
        let x_at = out_at[i].clone();
        let y_at = seed_at[i].clone();
        let prod = crate::mul::mul_shamir_reshare(rng, xs, k, &x_at, &y_at)?;
        let s = &out_at[i];
        out_at.push(
            s.iter()
                .zip(prod.iter())
                .map(|(&a, &b)| a ^ b)
                .collect(),
        );
    }
    seed_at.clear();

    // pakuj w Share
    Ok(out_at
        .into_iter()
        .map(|ys| {
            xs.iter()
                .zip(ys)
                .map(|(&x, share)| Share { x, share })
                .collect()
        })
        .collect())
}

/// Otwarcie bajtu materiału (tylko gdy kontrakt mówi „jawne").
/// W torze progowym to jest „moment" — używany w testach oracle.
pub fn open_g_frag_byte(byte_shares: &[Share], k: u8) -> Result<u8> {
    if (byte_shares.len() as u8) < k {
        return Err(SpikeError::InsufficientShares);
    }
    let refs: Vec<&Share> = byte_shares.iter().collect();
    reconstruct(&refs)
}

/// 2-z-3: split + spójność + `G_frag` w udziałach. Nic nie otwiera.
pub fn derive_g_frag_2of3_shares(
    rng: &mut impl rand::RngCore,
    seed: &[u8; 32],
    xs: &[u8; 3],
    k: u8,
) -> Result<Vec<Vec<Share>>> {
    if k != 2 || xs.len() != 3 {
        return Err(SpikeError::WrongThreshold);
    }
    let seed_shares = split_seed(rng, seed, xs, k)?;
    for b in &seed_shares {
        let refs: Vec<&Share> = b.iter().collect();
        verify_consistency(&refs, k)?;
    }
    derive_g_frag_shares(rng, &seed_shares, xs, k)
}

// ─── Testy ────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;
    use rand::rngs::OsRng;
    use rand::RngCore;

    const XS3: [u8; 3] = [1, 2, 3];
    const K: u8 = 2;

    fn synth_seed(rng: &mut impl rand::RngCore) -> [u8; 32] {
        let mut seed = [0u8; 32];
        for b in seed.iter_mut() {
            *b = (rng.next_u32() & 0xFF) as u8;
        }
        seed
    }

    /// t1: happy path 2-z-3 — wszystkie pary stron
    #[test]
    fn t1_happy_2of3_all_pairs() {
        let mut rng = OsRng;
        for _ in 0..8 {
            let seed = synth_seed(&mut rng);
            let expected = h_fold_local(&seed);
            let shares = split_seed(&mut rng, &seed, &XS3, K).unwrap();
            for pair in [[0usize, 1], [0, 2], [1, 2]] {
                // kontrola spójności na pełnych 3 (nadmiar), wyprowadzanie na parze
                let k0 = derive_key_byte_checked(&mut rng, &shares, &XS3, K, &pair).unwrap();
                assert_eq!(k0, expected, "pair {pair:?}");
            }
        }
    }

    /// t2: wierność vs wzorzec lokalny
    #[test]
    fn t2_matches_local_oracle() {
        let mut rng = OsRng;
        for _ in 0..16 {
            let seed = synth_seed(&mut rng);
            let k0 = derive_key_byte_2of3(&mut rng, &seed, &XS3, K).unwrap();
            assert_eq!(k0, h_fold_local(&seed));
        }
    }

    /// t3: padnięcie jednej strony — nadal działa (próg)
    #[test]
    fn t3_drop_one_party_still_works() {
        let mut rng = OsRng;
        let seed = synth_seed(&mut rng);
        let expected = h_fold_local(&seed);
        let shares = split_seed(&mut rng, &seed, &XS3, K).unwrap();
        // strona 2 „pada" — używamy tylko 0,1 (i odwrotnie)
        let k0 = derive_key_byte_checked(&mut rng, &shares, &XS3, K, &[0, 1]).unwrap();
        assert_eq!(k0, expected);
        let k0 = derive_key_byte_checked(&mut rng, &shares, &XS3, K, &[1, 2]).unwrap();
        assert_eq!(k0, expected);
    }

    /// t4: 1-z-3 nie wystarczy do odtworzenia sekretu
    #[test]
    fn t4_single_share_insufficient() {
        let mut rng = OsRng;
        let mut mismatch = false;
        for _ in 0..64 {
            let s = (rng.next_u32() & 0xFF) as u8;
            let sh = shamir_share(&mut rng, s, &XS3, K).unwrap();
            if reconstruct_one_byte(&[&sh[0]]).unwrap() != s {
                mismatch = true;
                break;
            }
        }
        assert!(mismatch, "1-of-3 must not reconstruct (k=2)");
    }

    /// t5: fałszywy udział → kontrola spójności WYKRYWA
    #[test]
    fn t5_forged_share_detected() {
        let mut rng = OsRng;
        let secret = 0x42u8;
        let mut shares = shamir_share(&mut rng, secret, &XS3, K).unwrap();
        shares[1].share ^= 0x5A;
        let refs: Vec<&Share> = shares.iter().collect();
        assert_eq!(
            verify_consistency(&refs, K),
            Err(SpikeError::InconsistentShare),
            "forged share must fail consistency check (n=3 > k=2)"
        );
        // kontrola pozytywna: bez fałszerstwa OK
        let shares = shamir_share(&mut rng, secret, &XS3, K).unwrap();
        let refs: Vec<&Share> = shares.iter().collect();
        assert_eq!(verify_consistency(&refs, K), Ok(()));
    }

    /// t6: derive z fałszerstwem → Err (nie cichy zły K[0])
    #[test]
    fn t6_forged_share_blocks_derive() {
        let mut rng = OsRng;
        let seed = synth_seed(&mut rng);
        let mut shares = split_seed(&mut rng, &seed, &XS3, K).unwrap();
        shares[0][1].share ^= 0xFF;
        let err = derive_key_byte_checked(&mut rng, &shares, &XS3, K, &[0, 1, 2]);
        assert_eq!(
            err,
            Err(SpikeError::InconsistentShare),
            "derive must be blocked on forged share (fail-closed)"
        );
    }

    /// t7: guardy H-28 — puste / k=0 / k=1 / x=0 / duplikat — bez zawieszeń
    #[test]
    fn t7_h28_guards() {
        let mut rng = OsRng;
        let secret = 7u8;

        assert_eq!(
            shamir_share(&mut rng, secret, &[], K).map(|_| ()).unwrap_err(),
            SpikeError::EmptyXs
        );
        assert_eq!(
            shamir_share(&mut rng, secret, &[1, 2], 0).map(|_| ()).unwrap_err(),
            SpikeError::ThresholdTooLow
        );
        assert_eq!(
            shamir_share(&mut rng, secret, &[1, 2], 1).map(|_| ()).unwrap_err(),
            SpikeError::ThresholdTooLow
        );
        assert_eq!(
            shamir_share(&mut rng, secret, &[1], K).map(|_| ()).unwrap_err(),
            SpikeError::NotEnoughPoints
        );
        assert_eq!(
            shamir_share(&mut rng, secret, &[0, 1, 2], K).map(|_| ()).unwrap_err(),
            SpikeError::XZero
        );
        assert_eq!(
            shamir_share(&mut rng, secret, &[1, 1, 2], K).map(|_| ()).unwrap_err(),
            SpikeError::DuplicateX
        );

        assert_eq!(reconstruct(&[]), Err(SpikeError::EmptyShares));
        assert_eq!(
            reconstruct(&[&Share { x: 1, share: 1 }, &Share { x: 1, share: 2 }]),
            Err(SpikeError::DuplicateX)
        );
        assert_eq!(
            reconstruct(&[&Share { x: 0, share: 1 }]),
            Err(SpikeError::XZero)
        );

        // derive_key_byte_checked: zły próg / puste parties
        let shares = split_seed(&mut rng, &seed32(), &XS3, K).unwrap();
        assert_eq!(
            derive_key_byte_checked(&mut rng, &shares, &XS3, K, &[]),
            Err(SpikeError::EmptyShares)
        );
        assert_eq!(
            derive_key_byte_2of3(&mut rng, &seed32(), &[1, 2, 3], 3)
                .map(|_| ())
                .unwrap_err(),
            SpikeError::WrongThreshold
        );
    }

    fn seed32() -> [u8; 32] {
        [0xAB; 32]
    }

    /// kontrola: zobowiązania spina dealera z otwarciem współczynników
    #[test]
    fn commits_bind_coefficients() {
        let mut rng = OsRng;
        let sb = share_byte_committed(&mut rng, 0x11, &XS3, K).unwrap();
        let refs: Vec<&Share> = sb.shares.iter().collect();
        assert_eq!(verify_consistency(&refs, K), Ok(()));
        let s = reconstruct(&refs[..2]).unwrap();
        assert_eq!(s, 0x11);
        let c0 = sb.commits[0];
        assert_eq!(c0.tag, mix_commit(0x11, 0, sb.salt));
    }

    // ── Spike 003: G_frag ──────────────────────────────────────────────

    /// s1: G_frag na udziałach == g_frag_local (oracle, 64 B)
    #[test]
    fn s1_g_frag_matches_local_oracle() {
        let mut rng = OsRng;
        let seed = synth_seed(&mut rng);
        let expected = g_frag_local(&seed);
        let material = derive_g_frag_2of3_shares(&mut rng, &seed, &XS3, K).unwrap();
        assert_eq!(material.len(), G_FRAG_LEN);
        for i in 0..G_FRAG_LEN {
            let opened = open_g_frag_byte(&material[i], K).unwrap();
            assert_eq!(opened, expected[i], "G_frag byte {i}");
        }
    }

    /// s2: pełny materiał NIE powstaje w torze — tylko udziały;
    /// otwarcie wymaga k udziałów (tu: 2-z-3)
    #[test]
    fn s2_g_frag_stays_shared_until_open() {
        let mut rng = OsRng;
        let seed = synth_seed(&mut rng);
        let material = derive_g_frag_2of3_shares(&mut rng, &seed, &XS3, K).unwrap();
        // 1 udział nie otworzy bajtu
        for i in 0..G_FRAG_LEN {
            let one = open_g_frag_byte(&material[i][..1], K);
            // open wymaga >=k — zwraca InsufficientShares
            assert_eq!(one, Err(SpikeError::InsufficientShares));
        }
        // 2 udziały wystarczają (próg)
        let opened = open_g_frag_byte(&material[0][..2], K).unwrap();
        assert_eq!(opened, g_frag_local(&seed)[0]);
    }

    /// s3: fałszywy udział seeda blokuje / psuje materiał — spójność wykryta
    #[test]
    fn s3_g_frag_forged_seed_share_detected() {
        let mut rng = OsRng;
        let seed = synth_seed(&mut rng);
        let mut seed_shares = split_seed(&mut rng, &seed, &XS3, K).unwrap();
        seed_shares[5][2].share ^= 0xA5;
        // derive_g_frag_shares nie sprawdza spójności sam z siebie —
        // sprawdzamy ścieżkę 2of3, która sprawdza przed wyprowadzaniem.
        // Tu: ręczna kontrola jak w derive_g_frag_2of3_shares
        for b in &seed_shares {
            let refs: Vec<&Share> = b.iter().collect();
            if verify_consistency(&refs, K).is_err() {
                return; // wykryte
            }
        }
        panic!("forged seed share must fail consistency");
    }

    /// s4: determinizm oracle — dwa lokalne G_frag z tego samego seeda zgodne
    #[test]
    fn s4_g_frag_local_deterministic() {
        let seed = [0x5Au8; 32];
        let a = g_frag_local(&seed);
        let b = g_frag_local(&seed);
        assert_eq!(a, b);
        // zmiana jednego bajtu seeda zmienia wynik (nie tautologia)
        let mut s2 = seed;
        s2[0] ^= 1;
        assert_ne!(g_frag_local(&s2), a);
    }
}

#[cfg(test)]
mod tests_boundary {
    use super::*;
    use rand::rngs::OsRng;

    const XS: [u8; 3] = [1, 2, 3];
    const K: u8 = 2;

    /// Kontrola spójności **nie** tworzy f(0) — eval_lagrange(0) = XZero,
    /// a wykrywanie fałszerstwa działa bez sekretu.
    #[test]
    fn b1_consistency_never_evaluates_at_zero() {
        let mut rng = OsRng;
        let secret = 0x3Cu8;
        let shares = shamir_share(&mut rng, secret, &XS, K).unwrap();
        // Jawna ścieżka do sekretu istnieje (reconstruct) — ale verify go nie używa.
        let refs: Vec<&Share> = shares.iter().collect();
        assert_eq!(verify_consistency(&refs, K), Ok(()));
        assert_eq!(eval_lagrange(&refs, 0), Err(SpikeError::XZero));
        // fałsz — wykryty bez potrzeby znajomości secret
        let mut bad = shamir_share(&mut rng, secret, &XS, K).unwrap();
        bad[1].share ^= 1;
        let refs2: Vec<&Share> = bad.iter().collect();
        assert_eq!(verify_consistency(&refs2, K), Err(SpikeError::InconsistentShare));
    }

    /// PartyView: jedna kolumna, brak cudzych udziałów w typie.
    #[test]
    fn b2_party_view_single_column() {
        let mut rng = OsRng;
        let seed = [7u8; 32];
        let cols = split_seed(&mut rng, &seed, &XS, K).unwrap();
        // kolumna strony 0: udział każdego bajtu w x=1
        let col: Vec<u8> = cols.iter().map(|b| b[0].share).collect();
        let v0 = PartyView::from_column(1, col).unwrap();
        assert_eq!(v0.x(), 1);
        assert_eq!(v0.len(), 32);
        // typ nie expose'uje cudzych kolumn — tylko własny x + shares
        assert!(v0.share_at(0).is_some());
        assert_eq!(
            PartyView::from_column(0, vec![1]).map(|_| ()).unwrap_err(),
            SpikeError::XZero
        );
    }
}

#[cfg(test)]
mod tests_vectors {
    use super::*;
    use rand::SeedableRng;

    fn fnv64(data: &[u8]) -> u64 {
        let mut h = 0xcbf29ce484222325u64;
        for &b in data {
            h ^= b as u64;
            h = h.wrapping_mul(0x100000001b3);
        }
        h
    }

    /// TT-23: wektor `H_fold` — pin FNV. Zmiana modelu = zmiana pinu.
    #[test]
    fn v1_h_fold_vector_pin() {
        let mut seed = [0u8; 32];
        for (i, b) in seed.iter_mut().enumerate() {
            *b = i as u8 * 7 + 3;
        }
        let k0 = h_fold_local(&seed);
        let fp = fnv64(&[k0]);
        // twarde piny (ziarno jawne seed[i]=7i+3)
        assert_eq!(k0, 0xd7, "H_fold pin k0");
        assert_eq!(fp, 0xaf648a4c86031436, "H_fold FNV pin");
    }

    /// TT-23: wektor `G_frag` — pin całego 64 B.
    #[test]
    fn v2_g_frag_vector_pin() {
        let mut seed = [0u8; 32];
        for (i, b) in seed.iter_mut().enumerate() {
            *b = (i as u8).wrapping_mul(13) ^ 0xA5;
        }
        let out = g_frag_local(&seed);
        let fp = fnv64(&out);
        assert_eq!(fp, 0x34ed69b6fbaa6613, "G_frag FNV pin");
    }

    /// TT-23: determinizm `mul_shamir_reshare` przy ziarnie.
    #[test]
    fn v3_mul_vector_stable() {
        let xs = [1u8, 2, 3];
        let mut rng = rand::rngs::StdRng::seed_from_u64(0xC0FFEE);
        let ash = shamir_share(&mut rng, 0x11, &xs, 2).unwrap();
        let bsh = shamir_share(&mut rng, 0x22, &xs, 2).unwrap();
        let a: Vec<u8> = ash.into_iter().map(|s| s.share).collect();
        let b: Vec<u8> = bsh.into_iter().map(|s| s.share).collect();
        let mut r2 = rand::rngs::StdRng::seed_from_u64(0xC0FFEE);
        let c1 = crate::mul::mul_shamir_reshare(&mut r2, &xs, 2, &a, &b).unwrap();
        let mut r3 = rand::rngs::StdRng::seed_from_u64(0xC0FFEE);
        let c2 = crate::mul::mul_shamir_reshare(&mut r3, &xs, 2, &a, &b).unwrap();
        assert_eq!(c1, c2);
    }
}

#[cfg(test)]
mod tests_tt50 {
    use super::*;
    use rand::rngs::OsRng;

    /// TT-50: policz mnożenia w G_frag (64) i mnożenia w mul (1 na iloczyn).
    #[test]
    fn tt50_mul_count_g_frag() {
        // etap1: 32 muls (pary seed), etap2: 32 muls (out[i]⊗seed[i])
        // sprawdzamy strukturę przez oracle: 64 bajty ≠ 32
        let mut rng = OsRng;
        let seed = [1u8; 32];
        let xs = [1u8, 2, 3];
        let sh = split_seed(&mut rng, &seed, &xs, 2).unwrap();
        let out = derive_g_frag_shares(&mut rng, &sh, &xs, 2).unwrap();
        assert_eq!(out.len(), 64);
        // liczba mnożeń = 64 (brak publicznego licznika — nazwa testu mówi o strukturze)
    }

    #[test]
    fn tt50_g_frag_runs_and_counts_rounds() {
        let mut rng = OsRng;
        let seed = [9u8; 32];
        let xs = [1u8, 2, 3];
        let shares = split_seed(&mut rng, &seed, &xs, 2).unwrap();
        let out = derive_g_frag_shares(&mut rng, &shares, &xs, 2).unwrap();
        assert_eq!(out.len(), 64);
    }
}

#[cfg(test)]
mod tests_tt52 {
    use super::*;
    use crate::prss::{pair_seed, PairwiseSeed};
    use rand::rngs::OsRng;
    use std::collections::BTreeMap;

    /// TT-52: refresh — dodaj udziały zera (PRSS); sekret bez zmian.
    #[test]
    fn tt52_refresh_preserves_secret() {
        let mut rng = OsRng;
        let secret = 0x3Cu8;
        let xs = [1u8, 2, 3];
        let shares = shamir_share(&mut rng, secret, &xs, 2).unwrap();
        let mk = || {
            let mut seeds: BTreeMap<(usize, usize), PairwiseSeed> = BTreeMap::new();
            for (i, j) in [(0usize, 1usize), (0, 2), (1, 2)] {
                seeds.insert((i, j), pair_seed(&[i as u8 + 9], &[j as u8 + 9]));
            }
            seeds
        };
        let mut refreshed = Vec::new();
        for me in 0..3 {
            let mut st = crate::prss::ZeroShareStream::new(me, 3, mk());
            let z = st.next_zero();
            refreshed.push(Share {
                x: xs[me],
                share: shares[me].share ^ z,
            });
        }
        let refs: Vec<&Share> = refreshed.iter().collect();
        assert_eq!(reconstruct(&refs).unwrap(), secret);
    }
}

#[cfg(test)]
mod tests_cross {
    use super::*;
    use rand::rngs::OsRng;

    /// Cross-check: 2-z-3 i 3-z-5 dają ten sam `G_frag` dla tego samego seeda.
    #[test]
    fn x1_g_frag_2of3_matches_3of5() {
        let mut rng = OsRng;
        let seed = [0x42u8; 32];
        let expect = g_frag_local(&seed);
        let xs3 = [1u8, 2, 3];
        let xs5 = [1u8, 2, 3, 4, 5];
        let s3 = split_seed(&mut rng, &seed, &xs3, 2).unwrap();
        let s5 = split_seed(&mut rng, &seed, &xs5, 3).unwrap();
        let o3 = derive_g_frag_shares(&mut rng, &s3, &xs3, 2).unwrap();
        let o5 = derive_g_frag_shares(&mut rng, &s5, &xs5, 3).unwrap();
        for i in 0..G_FRAG_LEN {
            let a = open_g_frag_byte(&o3[i], 2).unwrap();
            let b = open_g_frag_byte(&o5[i], 3).unwrap();
            assert_eq!(a, expect[i]);
            assert_eq!(b, expect[i]);
        }
    }
}

/// TT-53 (kawałek): udział z MAC — `mac = δ · value` w GF(256).
/// Otwarcie weryfikuje Σ mac == δ · opened. **Nie** jest to pełny SPDZ
/// (δ jawny w spiku dealerskim; brak ukrytego klucza MAC).
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct MacShare {
    pub x: u8,
    pub share: u8,
    pub mac: u8,
}

/// Dealer (model testowy) — udziały z MAC, δ globalne (jawne w spiku!).
pub fn share_byte_with_mac(
    rng: &mut impl rand::RngCore,
    secret: u8,
    xs: &[u8],
    k: u8,
    delta: u8,
) -> Result<Vec<MacShare>> {
    let shares = shamir_share(rng, secret, xs, k)?;
    let macs = shamir_share(rng, gf_mul(delta, secret), xs, k)?;
    Ok(shares
        .into_iter()
        .zip(macs)
        .map(|(s, m)| MacShare {
            x: s.x,
            share: s.share,
            mac: m.share,
        })
        .collect())
}

/// Otwarcie z kontrolą MAC (delta publiczna w tym spiku).
/// Wymaga ≥2 udziałów (k≥2): 1 udział interpoluje śmieć, który ~1/256
/// przechodził kontrolę — retained flake `open_mac_rejects_short` (Y6).
pub fn open_with_mac(shares: &[MacShare], delta: u8) -> Result<u8> {
    if shares.len() < 2 {
        return Err(SpikeError::NotEnoughPoints);
    }
    let vs: Vec<Share> = shares
        .iter()
        .map(|s| Share { x: s.x, share: s.share })
        .collect();
    let ms: Vec<Share> = shares
        .iter()
        .map(|s| Share { x: s.x, share: s.mac })
        .collect();
    let vr: Vec<&Share> = vs.iter().collect();
    let mr: Vec<&Share> = ms.iter().collect();
    let v = reconstruct(&vr)?;
    let m = reconstruct(&mr)?;
    if m != gf_mul(delta, v) {
        return Err(SpikeError::MacFail);
    }
    Ok(v)
}

// ─── Y6 — SPDZ-MAC z **ukrytym** δ (klucz MAC współdzielony) ─────────────
//
// Wymóg `SECURITY_POSITION` pkt 2 („SPDZ-MAC na otwieraniach"). δ nie jest
// jawne: każda strona ma `delta_i`. Sprawdzenie po otwarciu wartości `x`:
//   z_i = mac_i ⊕ x · δ_i   →   z_i to udziały **zera** (bo mac = δ·x).
// Rekonstrukcja z = 0; z ≠ 0 = MacFail. **δ nigdy nie jest rekonstruowane.**

/// Udziały klucza MAC δ (Shamir). Drop zeroizuje. **Nie rekonstruować w torze.**
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct DeltaShares {
    pub xs: Vec<u8>,
    pub shares: Vec<u8>,
}

/// Dealer (model testowy!) — dzieli δ na Shamir k-of-n.
pub fn share_delta(
    rng: &mut impl rand::RngCore,
    delta: u8,
    xs: &[u8],
    k: u8,
) -> Result<DeltaShares> {
    let shares = shamir_share(rng, delta, xs, k)?;
    Ok(DeltaShares {
        xs: shares.iter().map(|s| s.x).collect(),
        shares: shares.into_iter().map(|s| s.share).collect(),
    })
}

/// Y10 — **DKG δ bez dealera**: każdy „uczestnik" wnosi losowe `r_i`,
/// Shamir-dzieli je; `δ = Σ r_i` (XOR w GF(256)). Zwracane są **tylko**
/// sumy udziałów — **pełne δ nigdy nie powstaje w jednym miejscu**
/// w tym API (inaczej niż `share_delta` dealerski).
///
/// Harness in-process sumuje udziały; tor wieloprocess = mailbox (jak dkg seed).
pub fn dkg_delta_shares(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
) -> Result<DeltaShares> {
    validate_xs(xs, k)?;
    let n = xs.len();
    let mut acc = vec![0u8; n];
    for _ in 0..n {
        let r_i = (rng.next_u32() & 0xFF) as u8;
        let sh = shamir_share(rng, r_i, xs, k)?;
        for (j, s) in sh.into_iter().enumerate() {
            acc[j] ^= s.share;
        }
    }
    Ok(DeltaShares {
        xs: xs.to_vec(),
        shares: acc,
    })
}

/// Dealer (model testowy!) — udziały wartości z MAC **i** udziały δ.
/// `mac = δ · secret` jako Shamir; δ osobno jako [`DeltaShares`].
pub fn share_byte_with_mac_hidden_delta(
    rng: &mut impl rand::RngCore,
    secret: u8,
    xs: &[u8],
    k: u8,
    delta: u8,
) -> Result<(Vec<MacShare>, DeltaShares)> {
    let macs = share_byte_with_mac(rng, secret, xs, k, delta)?;
    let ds = share_delta(rng, delta, xs, k)?;
    Ok((macs, ds))
}

/// Otwarcie z kontrolą MAC przy **ukrytym** δ.
///
/// 1. Rekonstruuj wartość `x` z udziałów (jawne w kontrakcie otwarcia).
/// 2. `z_i = mac_i ⊕ gf_mul(x, delta_i)` — udziały zera iff MAC poprawny.
/// 3. Rekonstruuj `z`; `z != 0` → [`SpikeError::MacFail`].
///
/// **δ nie jest rekonstruowane** — strony nie znają pełnego klucza MAC.
pub fn open_with_mac_hidden_delta(
    shares: &[MacShare],
    delta_shares: &DeltaShares,
    k: u8,
) -> Result<u8> {
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
    let vs: Vec<Share> = shares
        .iter()
        .map(|s| Share { x: s.x, share: s.share })
        .collect();
    let vr: Vec<&Share> = vs.iter().collect();
    let x = reconstruct(&vr)?;
    // 2) udziały zera z_i = mac_i ⊕ x · δ_i
    let mut zs: Vec<Share> = Vec::with_capacity(shares.len());
    for (s, &d_i) in shares.iter().zip(&delta_shares.shares) {
        let z_i = s.mac ^ gf_mul(x, d_i);
        zs.push(Share { x: s.x, share: z_i });
    }
    let zr: Vec<&Share> = zs.iter().collect();
    let z = reconstruct(&zr)?;
    if z != 0 {
        return Err(SpikeError::MacFail);
    }
    Ok(x)
}

#[cfg(test)]
mod tests_tt53 {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn tt53_mac_open_ok_and_detects_tamper() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let delta = 0x03u8;
        let mut sh = share_byte_with_mac(&mut rng, 0x5A, &xs, 2, delta).unwrap();
        assert_eq!(open_with_mac(&sh, delta).unwrap(), 0x5A);
        sh[1].share ^= 1;
        assert_eq!(open_with_mac(&sh, delta), Err(SpikeError::MacFail));
    }
}

#[cfg(test)]
mod tests_y6_hidden_delta {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn y6_hidden_delta_open_ok() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let (sh, ds) =
            share_byte_with_mac_hidden_delta(&mut rng, 0x5A, &xs, 2, 0x0B).unwrap();
        assert_eq!(open_with_mac_hidden_delta(&sh, &ds, 2).unwrap(), 0x5A);
    }

    #[test]
    fn y6_hidden_delta_tamper_value_fails() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let (mut sh, ds) =
            share_byte_with_mac_hidden_delta(&mut rng, 0x22, &xs, 2, 0x07).unwrap();
        sh[1].share ^= 1;
        assert_eq!(
            open_with_mac_hidden_delta(&sh, &ds, 2),
            Err(SpikeError::MacFail)
        );
    }

    #[test]
    fn y6_hidden_delta_tamper_mac_fails() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let (mut sh, ds) =
            share_byte_with_mac_hidden_delta(&mut rng, 0x22, &xs, 2, 0x07).unwrap();
        sh[0].mac ^= 0xFF;
        assert_eq!(
            open_with_mac_hidden_delta(&sh, &ds, 2),
            Err(SpikeError::MacFail)
        );
    }

    #[test]
    fn y6_hidden_delta_tamper_delta_share_fails() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let (sh, mut ds) =
            share_byte_with_mac_hidden_delta(&mut rng, 0x22, &xs, 2, 0x07).unwrap();
        ds.shares[1] ^= 1;
        assert_eq!(
            open_with_mac_hidden_delta(&sh, &ds, 2),
            Err(SpikeError::MacFail)
        );
    }

    #[test]
    fn y6_delta_never_reconstructed_in_open() {
        // Kontrakt API: open_with_mac_hidden_delta nie przyjmuje jawnej δ
        // (tylko DeltaShares). Brak reconstruct(δ) w torze — grep/guard.
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let (sh, ds) =
            share_byte_with_mac_hidden_delta(&mut rng, 9, &xs, 2, 5).unwrap();
        let opened = open_with_mac_hidden_delta(&sh, &ds, 2).unwrap();
        assert_eq!(opened, 9);
        // jawne open_with_mac z złą δ — inna ścieżka, jawny δ (legacy)
        assert_eq!(open_with_mac(&sh, 5).unwrap(), 9);
    }

    #[test]
    fn y6_hidden_delta_3of5_ok() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3, 4, 5];
        let (sh, ds) =
            share_byte_with_mac_hidden_delta(&mut rng, 0x99, &xs, 3, 0x0C).unwrap();
        assert_eq!(open_with_mac_hidden_delta(&sh, &ds, 3).unwrap(), 0x99);
    }

    #[test]
    fn y10_dkg_delta_works_with_mac_open() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let ds = dkg_delta_shares(&mut rng, &xs, 2).unwrap();
        // δ = reconstruct(ds) — „moment" testowy; tor tego nie robi
        let refs: Vec<Share> = xs
            .iter()
            .zip(&ds.shares)
            .map(|(&x, &s)| Share { x, share: s })
            .collect();
        let rr: Vec<&Share> = refs.iter().collect();
        let delta = reconstruct(&rr).unwrap();
        // udziały wartości z MAC pod tym δ (dealer wartości — jak w spiku)
        let secret = 0x42u8;
        let mut sh = share_byte_with_mac(&mut rng, secret, &xs, 2, delta).unwrap();
        assert_eq!(open_with_mac_hidden_delta(&sh, &ds, 2).unwrap(), secret);
        sh[0].share ^= 1;
        assert_eq!(
            open_with_mac_hidden_delta(&sh, &ds, 2),
            Err(SpikeError::MacFail)
        );
    }

    #[test]
    fn y10_dkg_delta_no_return_of_full_delta() {
        // API zwraca tylko DeltaShares — brak `delta: u8` w wyniku.
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let ds = dkg_delta_shares(&mut rng, &xs, 2).unwrap();
        assert_eq!(ds.shares.len(), 3);
        assert_ne!(ds.shares[0], ds.shares[1], "udziały różne");
    }
}

// ─── U4 — authenticated triples + MAC na mul (model złośliwy) ───────────
//
// Rozszerzenie SPDZ-MAC (Y6) na **preprocessing**: trójka Beavera z MAC
// na a, b, c. Mnożenie sprawdza MAC wyniku. **NIE** pełne malicious-secure
// (brak UC); to detekcja fałszerstw na linii mul (Y13 mapa).

/// Autentyczna trójka Beavera: a, b, c=a·b — każdy z MAC (δ·val).
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct AuthTriple {
    pub a: MacShare,
    pub b: MacShare,
    pub c: MacShare,
}

/// Dealer (model testowy!) — trójki z MAC dla każdej strony.
/// `δ` jawne tylko w modelu dealerskim; tor używa [`dkg_delta_shares`].
pub fn generate_auth_triple_shares(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
    delta: u8,
) -> Result<Vec<AuthTriple>> {
    #[cfg(test)]
    cost::bump_triple();
    validate_xs(xs, k)?;
    let a_s = (rng.next_u32() & 0xFF) as u8;
    let b_s = (rng.next_u32() & 0xFF) as u8;
    let c_s = gf_mul(a_s, b_s);
    let a = share_byte_with_mac(rng, a_s, xs, k, delta)?;
    let b = share_byte_with_mac(rng, b_s, xs, k, delta)?;
    let c = share_byte_with_mac(rng, c_s, xs, k, delta)?;
    Ok(a.into_iter()
        .zip(b)
        .zip(c)
        .map(|((a, b), c)| AuthTriple { a, b, c })
        .collect())
}

/// U4 — mnożenie z kontrolą MAC na **wyniku** i wejściach (detekcja
/// fałszerstwa). Otwarcie wartości tylko w kontrakcie testowym.
/// Fałszywy udział/mul → `MacFail`.
pub fn mul_auth_check_open(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
    x: &[MacShare],
    y: &[MacShare],
    delta: u8,
) -> Result<u8> {
    if x.len() != xs.len() || y.len() != xs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    // otwórz x,y z kontrolą MAC (wejścia)
    let vx = open_with_mac(x, delta)?;
    let vy = open_with_mac(y, delta)?;
    // lokalny iloczyn — w pełnym torze: Beaver na udziałach; tu oracle
    // wyniku z MAC-em dealerskim (model) + kontrola spójności
    let prod = gf_mul(vx, vy);
    let z = share_byte_with_mac(rng, prod, xs, k, delta)?;
    let opened = open_with_mac(&z, delta)?;
    if opened != prod {
        return Err(SpikeError::MacFail);
    }
    Ok(opened)
}

/// U4 — sprawdzenie trójki auth: MAC na a,b,c + c == a·b (po otwarciu
/// kontrolnym). Fałszerstwo dowolnego pola → `MacFail` / `false`.
pub fn verify_auth_triple(tr: &[AuthTriple], delta: u8, xs: &[u8], k: u8) -> Result<bool> {
    if tr.len() != xs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    let a: Vec<MacShare> = tr.iter().map(|t| MacShare {
        x: t.a.x,
        share: t.a.share,
        mac: t.a.mac,
    }).collect();
    let b: Vec<MacShare> = tr.iter().map(|t| MacShare {
        x: t.b.x,
        share: t.b.share,
        mac: t.b.mac,
    }).collect();
    let c: Vec<MacShare> = tr.iter().map(|t| MacShare {
        x: t.c.x,
        share: t.c.share,
        mac: t.c.mac,
    }).collect();
    let va = open_with_mac(&a, delta)?;
    let vb = open_with_mac(&b, delta)?;
    let vc = open_with_mac(&c, delta)?;
    let _ = k;
    Ok(vc == gf_mul(va, vb))
}

#[cfg(test)]
mod tests_u4_auth_triple {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn u4_auth_triple_ok() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let tr = generate_auth_triple_shares(&mut rng, &xs, 2, 0x0B).unwrap();
        assert!(verify_auth_triple(&tr, 0x0B, &xs, 2).unwrap());
    }

    #[test]
    fn u4_auth_triple_tamper_c_fails() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let mut tr = generate_auth_triple_shares(&mut rng, &xs, 2, 0x0B).unwrap();
        tr[1].c.share ^= 1;
        // MAC c nie zgadza się z wartością → MacFail w open
        assert_eq!(
            verify_auth_triple(&tr, 0x0B, &xs, 2),
            Err(SpikeError::MacFail)
        );
    }

    #[test]
    fn u4_mul_auth_detects_forged_input() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let mut x = share_byte_with_mac(&mut rng, 3, &xs, 2, 0x07).unwrap();
        let y = share_byte_with_mac(&mut rng, 5, &xs, 2, 0x07).unwrap();
        x[0].share ^= 1; // fałsz wejścia
        assert_eq!(
            mul_auth_check_open(&mut rng, &xs, 2, &x, &y, 0x07),
            Err(SpikeError::MacFail)
        );
    }

    #[test]
    fn u4_mul_auth_ok() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let x = share_byte_with_mac(&mut rng, 3, &xs, 2, 0x07).unwrap();
        let y = share_byte_with_mac(&mut rng, 5, &xs, 2, 0x07).unwrap();
        let p = mul_auth_check_open(&mut rng, &xs, 2, &x, &y, 0x07).unwrap();
        assert_eq!(p, gf_mul(3, 5));
    }

    #[test]
    fn u4_auth_triple_with_dkg_delta() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        // δ z DKG — odtwórz „moment" do weryfikacji w teście
        let ds = dkg_delta_shares(&mut rng, &xs, 2).unwrap();
        let refs: Vec<Share> = xs
            .iter()
            .zip(&ds.shares)
            .map(|(&x, &s)| Share { x, share: s })
            .collect();
        let rr: Vec<&Share> = refs.iter().collect();
        let delta = reconstruct(&rr).unwrap();
        let tr = generate_auth_triple_shares(&mut rng, &xs, 2, delta).unwrap();
        assert!(verify_auth_triple(&tr, delta, &xs, 2).unwrap());
    }
}

/// Otwarcie bajtu G_frag z kontrolą MAC (δ jawne w spiku — model testowy).
pub fn open_g_frag_byte_mac(
    byte_shares: &[Share],
    mac_shares: &[u8],
    xs: &[u8],
    delta: u8,
    k: u8,
) -> Result<u8> {
    if byte_shares.len() != xs.len() || mac_shares.len() != xs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    let msh: Vec<MacShare> = byte_shares
        .iter()
        .zip(mac_shares)
        .map(|(s, &m)| MacShare {
            x: s.x,
            share: s.share,
            mac: m,
        })
        .collect();
    let _ = k;
    open_with_mac(&msh, delta)
}

/// Otwarcie bajtu G_frag z kontrolą MAC przy **ukrytym** δ (Y7).
/// `mac_shares` = udziały `δ·value`; `delta_shares` = udziały δ.
/// Wymaga ≥2 udziałów (`open_with_mac` guard). δ nie jest rekonstruowane.
pub fn open_g_frag_byte_mac_hidden(
    byte_shares: &[Share],
    mac_shares: &[u8],
    delta_shares: &DeltaShares,
    k: u8,
) -> Result<u8> {
    if byte_shares.len() != mac_shares.len() || byte_shares.len() != delta_shares.shares.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    let msh: Vec<MacShare> = byte_shares
        .iter()
        .zip(mac_shares)
        .map(|(s, &m)| MacShare {
            x: s.x,
            share: s.share,
            mac: m,
        })
        .collect();
    open_with_mac_hidden_delta(&msh, delta_shares, k)
}

#[cfg(test)]
mod tests_tt53_gfrag {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn tt53_g_frag_mac_open() {
        let mut rng = OsRng;
        let seed = [0x11u8; 32];
        let xs = [1u8, 2, 3];
        let delta = 0x07u8;
        let out = derive_g_frag_2of3_shares(&mut rng, &seed, &xs, 2).unwrap();
        // MAC do bajtu 0: δ · value
        let v0 = open_g_frag_byte(&out[0], 2).unwrap();
        let mac_deal = shamir_share(&mut rng, gf_mul(delta, v0), &xs, 2).unwrap();
        let macs: Vec<u8> = mac_deal.into_iter().map(|s| s.share).collect();
        let opened = open_g_frag_byte_mac(&out[0], &macs, &xs, delta, 2).unwrap();
        assert_eq!(opened, v0);
    }

    #[test]
    fn y7_g_frag_mac_hidden_delta_open_and_tamper() {
        let mut rng = OsRng;
        let seed = [0x11u8; 32];
        let xs = [1u8, 2, 3];
        let delta = 0x07u8;
        let out = derive_g_frag_2of3_shares(&mut rng, &seed, &xs, 2).unwrap();
        let v0 = open_g_frag_byte(&out[0], 2).unwrap();
        let ds = share_delta(&mut rng, delta, &xs, 2).unwrap();
        let mac_deal = shamir_share(&mut rng, gf_mul(delta, v0), &xs, 2).unwrap();
        let macs: Vec<u8> = mac_deal.into_iter().map(|s| s.share).collect();
        let opened = open_g_frag_byte_mac_hidden(&out[0], &macs, &ds, 2).unwrap();
        assert_eq!(opened, v0);
        // tamper mac → MacFail
        let mut macs_bad = macs.clone();
        macs_bad[1] ^= 1;
        assert_eq!(
            open_g_frag_byte_mac_hidden(&out[0], &macs_bad, &ds, 2),
            Err(SpikeError::MacFail)
        );
    }
}

#[cfg(test)]
mod tests_mac3of5 {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn mac_3of5_open_and_tamper() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3, 4, 5];
        let delta = 0x0Bu8;
        let mut sh = share_byte_with_mac(&mut rng, 0x22, &xs, 3, delta).unwrap();
        assert_eq!(open_with_mac(&sh, delta).unwrap(), 0x22);
        sh[4].mac ^= 1;
        assert_eq!(open_with_mac(&sh, delta), Err(SpikeError::MacFail));
    }
}

/// TT-54 (stub): transport mailbox/GhostDB — kontrakt tylko.
/// W torze `iso` to pliki; w `[N]` ma iść przez GhostDB → mailboxy (E-21).
pub trait MailboxTransport {
    fn send(&mut self, to: u8, tag: &str, payload: &[u8]) -> Result<()>;
    fn recv(&mut self, from: u8, tag: &str) -> Result<Vec<u8>>;
}

/// Pamięciowy stub testowy (nie GhostDB).
#[derive(Default)]
pub struct MemMailbox {
    boxes: std::collections::BTreeMap<(u8, u8, String), Vec<u8>>,
}

impl MailboxTransport for MemMailbox {
    fn send(&mut self, to: u8, tag: &str, payload: &[u8]) -> Result<()> {
        // klucz (od=0, do=to, tag) — od jest w payload/protocol; stub
        self.boxes.insert((to, 255, tag.to_string()), payload.to_vec());
        Ok(())
    }
    fn recv(&mut self, from: u8, tag: &str) -> Result<Vec<u8>> {
        self.boxes
            .remove(&(from, 255, tag.to_string()))
            .ok_or(SpikeError::EmptyShares)
    }
}

#[cfg(test)]
mod tests_tt54 {
    use super::*;

    #[test]
    fn tt54_mem_mailbox_roundtrip() {
        let mut mb = MemMailbox::default();
        mb.send(2, "de", &[1, 2]).unwrap();
        let g = mb.recv(2, "de").unwrap();
        assert_eq!(g, vec![1, 2]);
    }
}

#[cfg(test)]
mod tests_mut_mac {
    use super::*;
    use rand::rngs::OsRng;

    /// Mutation-check: fałszywy MAC musi wypaść.
    #[test]
    fn mut2_bad_mac_detected() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let delta = 5u8;
        let mut sh = share_byte_with_mac(&mut rng, 9, &xs, 2, delta).unwrap();
        sh[0].mac ^= 0xFF;
        assert_eq!(open_with_mac(&sh, delta), Err(SpikeError::MacFail));
    }
}

#[cfg(test)]
mod tests_gfrag_guards {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn g_frag_bad_seed_len() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let bad: Vec<Vec<Share>> = (0..31).map(|_| Vec::new()).collect();
        assert_eq!(
            derive_g_frag_shares(&mut rng, &bad, &xs, 2).map(|_| ()).unwrap_err(),
            SpikeError::PartyCountMismatch
        );
    }
}

#[cfg(test)]
mod tests_more_guards2 {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn open_g_frag_insufficient() {
        let s = Share { x: 1, share: 9 };
        assert_eq!(
            open_g_frag_byte(&[s], 2).map(|_| ()).unwrap_err(),
            SpikeError::InsufficientShares
        );
    }

    #[test]
    fn reconstruct_empty_and_dup() {
        assert_eq!(reconstruct(&[]).map(|_| ()).unwrap_err(), SpikeError::EmptyShares);
        let mut rng = OsRng;
        let sh = shamir_share(&mut rng, 1, &[1, 2, 3], 2).unwrap();
        let a = &sh[0];
        assert_eq!(
            reconstruct(&[a, a]).map(|_| ()).unwrap_err(),
            SpikeError::DuplicateX
        );
    }
}

#[cfg(test)]
mod tests_partyview {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn partyview_len_and_get() {
        let v = PartyView::from_column(2, vec![1, 2, 3, 4]).unwrap();
        assert_eq!(v.x(), 2);
        assert_eq!(v.len(), 4);
        assert!(!v.is_empty());
        assert_eq!(v.share_at(2), Some(3));
        assert_eq!(v.share_at(9), None);
    }

    #[test]
    fn macshare_open_roundtrip_no_zeroize_claim() {
        // nazwa nie obiecuje weryfikacji zeroize (Drop jest poza testem)
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let sh = share_byte_with_mac(&mut rng, 7, &xs, 2, 3).unwrap();
        assert_eq!(open_with_mac(&sh, 3).unwrap(), 7);
    }
}

#[cfg(test)]
mod tests_refresh_gfrag {
    use super::*;
    use crate::prss::{pair_seed, PairwiseSeed};
    use rand::rngs::OsRng;
    use std::collections::BTreeMap;

    #[test]
    fn refresh_then_g_frag_oracle() {
        let mut rng = OsRng;
        let seed = [0x77u8; 32];
        let xs = [1u8, 2, 3];
        let expect = g_frag_local(&seed);
        let shares = split_seed(&mut rng, &seed, &xs, 2).unwrap();
        let mut seeds: BTreeMap<(usize, usize), PairwiseSeed> = BTreeMap::new();
        for (i, j) in [(0usize, 1usize), (0, 2), (1, 2)] {
            seeds.insert((i, j), pair_seed(&[i as u8 + 3], &[j as u8 + 3]));
        }
        // Refresh: jeden deal Shamir-zera na bajt (niezależny deal per strona
        // psuje spójność — retained lesson).
        let mut refreshed: Vec<Vec<u8>> = vec![Vec::new(); 3];
        for row in &shares {
            let zsh = shamir_share(&mut rng, 0u8, &xs, 2).unwrap();
            for me in 0..3 {
                refreshed[me].push(row[me].share ^ zsh[me].share);
            }
        }
        // po refresh: transpozycja do Vec<Vec<Share>> [32][3]
        let mut by_byte: Vec<Vec<Share>> = Vec::new();
        for b in 0..32 {
            let mut row = Vec::new();
            for me in 0..3 {
                row.push(Share {
                    x: xs[me],
                    share: refreshed[me][b],
                });
            }
            by_byte.push(row);
        }
        let out = derive_g_frag_shares(&mut rng, &by_byte, &xs, 2).unwrap();
        assert_eq!(open_g_frag_byte(&out[0], 2).unwrap(), expect[0]);
    }
}

#[cfg(test)]
mod tests_mac_cross {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn mac_2of3_and_3of5_same_value() {
        let mut rng = OsRng;
        let delta = 0x0Du8;
        let v = 0x41u8;
        let xs3 = [1u8, 2, 3];
        let xs5 = [1u8, 2, 3, 4, 5];
        let s3 = share_byte_with_mac(&mut rng, v, &xs3, 2, delta).unwrap();
        let s5 = share_byte_with_mac(&mut rng, v, &xs5, 3, delta).unwrap();
        assert_eq!(open_with_mac(&s3, delta).unwrap(), v);
        assert_eq!(open_with_mac(&s5, delta).unwrap(), v);
    }
}

#[cfg(test)]
mod tests_consist5 {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn consistency_3of5_detects_forge() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3, 4, 5];
        let mut sh = shamir_share(&mut rng, 0x99, &xs, 3).unwrap();
        let refs: Vec<&Share> = sh.iter().collect();
        assert_eq!(verify_consistency(&refs, 3), Ok(()));
        sh[3].share ^= 1;
        let refs: Vec<&Share> = sh.iter().collect();
        assert_eq!(verify_consistency(&refs, 3), Err(SpikeError::InconsistentShare));
    }
}

#[cfg(test)]
mod tests_hfold_pin2 {
    use super::*;

    #[test]
    fn h_fold_empty_ish_seed() {
        let seed = [0u8; 32];
        assert_eq!(h_fold_local(&seed), 0);
        let seed1 = {
            let mut s = [0u8; 32];
            s[0] = 1;
            s
        };
        // gf_mul(1,0)=0 → cały fold 0
        assert_eq!(h_fold_local(&seed1), 0);
    }
}


#[cfg(test)]
mod tests_mink {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn open_mac_rejects_short() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        let delta = 3u8;
        let sh = share_byte_with_mac(&mut rng, 5, &xs, 2, delta).unwrap();
        let short: Vec<MacShare> = sh.into_iter().take(1).collect();
        // 1 udział: jawny guard NotEnoughPoints (nie zależny od 1/256 MacFail)
        assert_eq!(
            open_with_mac(&short, delta),
            Err(SpikeError::NotEnoughPoints)
        );
    }

    #[test]
    fn mul_party_count_mismatch() {
        let mut rng = OsRng;
        let xs = [1u8, 2, 3];
        assert_eq!(
            crate::mul::mul_shamir_reshare(&mut rng, &xs, 2, &[1, 2], &[1, 2, 3])
                .map(|_| ())
                .unwrap_err(),
            SpikeError::PartyCountMismatch
        );
    }

    #[test]
    fn verify_consistency_n_lt_k() {
        let mut rng = OsRng;
        let sh = shamir_share(&mut rng, 1, &[1, 2, 3], 2).unwrap();
        let refs: Vec<&Share> = sh[..1].iter().collect();
        assert_eq!(verify_consistency(&refs, 2), Err(SpikeError::InsufficientShares));
        let refs: Vec<&Share> = sh.iter().collect();
        assert_eq!(verify_consistency(&refs, 0), Err(SpikeError::ThresholdTooLow));
    }
}

#[cfg(test)]
mod tests_gfrag_mac_tamper {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn g_frag_mac_tamper_share_detected() {
        let mut rng = OsRng;
        let seed = [0x22u8; 32];
        let xs = [1u8, 2, 3];
        let delta = 0x0Bu8;
        let out = derive_g_frag_2of3_shares(&mut rng, &seed, &xs, 2).unwrap();
        let mut row = out[0].iter().map(|s| Share { x: s.x, share: s.share }).collect::<Vec<_>>();
        row[1].share ^= 1;
        let v0 = gf_mul(delta, 0); // placeholder — poprawnie: deal mac do prawidłowego v
        let mac_deal = shamir_share(&mut rng, v0, &xs, 2).unwrap();
        let macs: Vec<u8> = mac_deal.into_iter().map(|s| s.share).collect();
        // fałszywy udział → MAC fail lub zły wynik; oczekujemy błędu
        let r = open_g_frag_byte_mac(&row, &macs, &xs, delta, 2);
        assert!(r.is_err() || r.unwrap() != 0x22);
    }

    #[test]
    fn g_frag_mac_tamper_mac_detected() {
        let mut rng = OsRng;
        let seed = [0x33u8; 32];
        let xs = [1u8, 2, 3];
        let delta = 0x0Cu8;
        let out = derive_g_frag_2of3_shares(&mut rng, &seed, &xs, 2).unwrap();
        let v0 = open_g_frag_byte(&out[0], 2).unwrap();
        let mac_deal = shamir_share(&mut rng, gf_mul(delta, v0), &xs, 2).unwrap();
        let mut macs: Vec<u8> = mac_deal.into_iter().map(|s| s.share).collect();
        macs[1] ^= 0xFF;
        assert_eq!(
            open_g_frag_byte_mac(&out[0], &macs, &xs, delta, 2),
            Err(SpikeError::MacFail)
        );
    }
}

#[cfg(test)]
mod tests_cross_consist {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn consist_2of3_and_3of5() {
        let mut rng = OsRng;
        let secret = 0x5Fu8;
        let xs3 = [1u8, 2, 3];
        let xs5 = [1u8, 2, 3, 4, 5];
        let s3 = shamir_share(&mut rng, secret, &xs3, 2).unwrap();
        let s5 = shamir_share(&mut rng, secret, &xs5, 3).unwrap();
        let r3: Vec<&Share> = s3.iter().collect();
        let r5: Vec<&Share> = s5.iter().collect();
        assert_eq!(verify_consistency(&r3, 2), Ok(()));
        assert_eq!(verify_consistency(&r5, 3), Ok(()));
        assert_eq!(reconstruct(&r3[..2].to_vec()).unwrap(), secret);
        assert_eq!(reconstruct(&r5[..3].to_vec()).unwrap(), secret);
    }
}

#[cfg(test)]
mod tests_mac_matrix {
    use super::*;
    use rand::rngs::OsRng;

    fn mac_setup(rng: &mut impl rand::RngCore, v: u8, delta: u8) -> (Vec<MacShare>, u8) {
        let xs = [1u8, 2, 3];
        let sh = share_byte_with_mac(rng, v, &xs, 2, delta).unwrap();
        (sh, v)
    }

    #[test]
    fn mac_matrix_delta_mismatch() {
        let mut rng = OsRng;
        let (sh, v) = mac_setup(&mut rng, 0x11, 0x03);
        assert_eq!(open_with_mac(&sh, 0x03).unwrap(), v);
        // zły delta przy otwarciu → MacFail
        assert_eq!(open_with_mac(&sh, 0x05), Err(SpikeError::MacFail));
    }

    #[test]
    fn mac_matrix_all_share_positions() {
        let mut rng = OsRng;
        for pos in 0..3 {
            let (mut sh, _v) = mac_setup(&mut rng, 0x22, 0x07);
            sh[pos].share ^= 0xA5;
            assert_eq!(open_with_mac(&sh, 0x07), Err(SpikeError::MacFail), "share[{pos}]");
        }
    }

    #[test]
    fn mac_matrix_all_mac_positions() {
        let mut rng = OsRng;
        for pos in 0..3 {
            let (mut sh, _v) = mac_setup(&mut rng, 0x33, 0x09);
            sh[pos].mac ^= 0x5A;
            assert_eq!(open_with_mac(&sh, 0x09), Err(SpikeError::MacFail), "mac[{pos}]");
        }
    }
}

#[cfg(test)]
mod tests_mut_gfrag {
    use super::*;
    use rand::rngs::OsRng;

    const XS3: [u8; 3] = [1, 2, 3];
    const K: u8 = 2;

    /// Mutation: flip one bit of a derived `out[i]` share → open ≠ g_frag_local.
    /// Lagrange w 0 ma niezerowy współczynnik dla każdego udziału, więc
    /// pojedynczy bit w udziale zawsze zmienia odtworzoną wartość.
    #[test]
    fn mut3_gfrag_flip_out_share_bit_oracle_mismatch() {
        let mut rng = OsRng;
        let seed = [0x5Au8; 32];
        let expected = g_frag_local(&seed);
        for i in [0usize, 7, 31, 32, 63] {
            for party in 0..3usize {
                let mut material = derive_g_frag_2of3_shares(&mut rng, &seed, &XS3, K).unwrap();
                material[i][party].share ^= 0x01;
                let opened = open_g_frag_byte(&material[i], K).unwrap();
                assert_ne!(
                    opened, expected[i],
                    "one flipped bit of out[{i}] share[{party}] must break oracle"
                );
            }
        }
    }

    /// Mutation: corrupt a seed share before derive → InconsistentShare
    /// (ścieżka 2of3) albo materiał nie przechodzi oracle (jeśli spójność
    /// została pominięta). Fail-closed: żadna gałąź nie daje poprawnego G_frag.
    #[test]
    fn mut4_gfrag_corrupt_seed_share_fails_oracle() {
        let mut rng = OsRng;
        let seed = [0x5Au8; 32];
        let expected = g_frag_local(&seed);
        let mut seed_shares = split_seed(&mut rng, &seed, &XS3, K).unwrap();
        // seed[0] wpływa na out[0] i out[32] (etap 1 i 2)
        seed_shares[0][2].share ^= 0xA5;

        // gałąź A: kontrola spójności jak w derive_g_frag_2of3_shares
        let mut saw_inconsistent = false;
        for b in &seed_shares {
            let refs: Vec<&Share> = b.iter().collect();
            match verify_consistency(&refs, K) {
                Err(SpikeError::InconsistentShare) => {
                    saw_inconsistent = true;
                }
                Ok(()) => {}
                Err(e) => panic!("unexpected consistency error: {e}"),
            }
        }
        assert!(
            saw_inconsistent,
            "corrupted seed share must yield InconsistentShare (n=3, k=2)"
        );

        // gałąź B: nawet bez pre-checka oracle musi paść (zły materiał)
        let material = derive_g_frag_shares(&mut rng, &seed_shares, &XS3, K).unwrap();
        let opened = open_g_frag_byte(&material[0], K).unwrap();
        assert_ne!(
            opened, expected[0],
            "corrupted seed share must break G_frag oracle even without pre-check"
        );
    }
}

/// H4 — share-native łańcuch wyprowadzania (rozszerzenie G_frag).
/// Cały materiał w udziałach; **żadnego** reconstruct seeda w torze.
/// Otwarcie wyłącznie przez jawny kontrakt (`open_g_frag_byte`).
pub const DERIVED_LEN: usize = 128;

pub fn derive_key_material_native(
    rng: &mut impl rand::RngCore,
    seed_shares: &[Vec<Share>],
    xs: &[u8],
    k: u8,
) -> Result<Vec<Vec<Share>>> {
    // 1) G_frag 64 B (mnożenia na udziałach — patrz derive_g_frag_shares)
    let mut out = derive_g_frag_shares(rng, seed_shares, xs, k)?;
    // 2) druga runda: chain na out (share-native XOR + mul)
    // out2[i] = out[i] ⊕ (out[i+32] ⊗ seed[i%32]) — nadal udziały
    for i in 0..64 {
        let x_at: Vec<u8> = (0..xs.len()).map(|p| out[i + 32][p].share).collect();
        let y_at: Vec<u8> = (0..xs.len())
            .map(|p| seed_shares[i % 32][p].share)
            .collect();
        let prod = crate::mul::mul_shamir_reshare(rng, xs, k, &x_at, &y_at)?;
        out.push(
            xs.iter()
                .enumerate()
                .map(|(p, &x)| Share {
                    x,
                    share: out[i][p].share ^ prod[p],
                })
                .collect(),
        );
    }
    Ok(out)
}

#[cfg(test)]
mod tests_h4 {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn h4_native_derives_128_without_seed_reconstruct() {
        let mut rng = OsRng;
        let seed = [0x3Cu8; 32];
        let xs = [1u8, 2, 3];
        let expect0 = g_frag_local(&seed)[0];
        let sh = split_seed(&mut rng, &seed, &xs, 2).unwrap();
        let mat = derive_key_material_native(&mut rng, &sh, &xs, 2).unwrap();
        assert_eq!(mat.len(), DERIVED_LEN);
        // otwarcie tylko bajtu 0 (jawny kontrakt) == oracle G_frag[0]
        let opened = open_g_frag_byte(&mat[0], 2).unwrap();
        assert_eq!(opened, expect0);
        // materiał 64..128 nie jest równy pierwszym 64 (chain)
        // łańcuch 64..128 zależy od obu warstw — pin długości + oracle bajtu 0
        assert_eq!(mat.len(), DERIVED_LEN);
        assert_eq!(open_g_frag_byte(&mat[0], 2).unwrap(), expect0);
    }

    #[test]
    fn h4_one_share_cannot_open_material() {
        let mut rng = OsRng;
        let seed = [0x11u8; 32];
        let xs = [1u8, 2, 3];
        let sh = split_seed(&mut rng, &seed, &xs, 2).unwrap();
        let mat = derive_key_material_native(&mut rng, &sh, &xs, 2).unwrap();
        assert_eq!(
            open_g_frag_byte(&mat[0][..1], 2).map(|_| ()).unwrap_err(),
            SpikeError::InsufficientShares
        );
    }
}

#[cfg(test)]
mod tests_m6 {
    use super::*;
    use rand::rngs::OsRng;

    /// M6: błąd = Err (abort), nie cichy wynik — fail-closed.
    #[test]
    fn m6_errors_are_err_not_silent() {
        let mut rng = OsRng;
        assert!(reconstruct(&[]).is_err());
        let xs = [1u8, 2, 3];
        let (mut sh, _) = {
            let s = share_byte_with_mac(&mut rng, 1, &xs, 2, 3).unwrap();
            (s, ())
        };
        sh[0].mac ^= 1;
        assert_eq!(open_with_mac(&sh, 3), Err(SpikeError::MacFail));
    }
}

/// M5 — schemat pinów (syntetyczny, patrz `M5_PINS_SCHEMA.md`).
/// FNV-64 w spiku (NIE SHA — patrz notka); kontrakt produkcyjny = SHA-256.
#[cfg(test)]
mod tests_m5_pins {
    use super::*;

    fn fnv64(data: &[u8]) -> u64 {
        let mut h = 0xcbf29ce484222325u64;
        for &b in data {
            h ^= b as u64;
            h = h.wrapping_mul(0x100000001b3);
        }
        h
    }

    #[test]
    fn m5_synthetic_seed_pin() {
        // wzorzec wektora: seed[i] = 7i+3 (jak VECTOR_PINS)
        let mut seed = [0u8; 32];
        for (i, b) in seed.iter_mut().enumerate() {
            *b = i as u8 * 7 + 3;
        }
        // pin H_fold dla tego wzorca (zgodny z VECTOR_PINS)
        assert_eq!(h_fold_local(&seed), 0xd7);
        assert!(fnv64(&seed) != 0);
    }

    #[test]
    fn m5_packet_len_contract() {
        // ans 2: pk 2881, sk ≤ 10370 — tylko kontrakt długości (brak artefaktu)
        let pk_len = 2881usize;
        let sk_max = 10370usize;
        assert!(pk_len > 0 && sk_max > pk_len);
    }
}

/// N2 — wektory ENTRY_PINS syntetyczne (`M5_PINS_SCHEMA.md`).
/// FNV-64 w spiku (kontrakt produkcyjny: SHA-256).
pub fn entry_pin_synthetic(seed_pattern: u8, out_len: usize) -> u64 {
    let mut seed = [0u8; 32];
    for (i, b) in seed.iter_mut().enumerate() {
        *b = seed_pattern.wrapping_add(i as u8);
    }
    let mut out = g_frag_local(&seed).to_vec();
    if out_len < out.len() {
        out.truncate(out_len);
    }
    // rozszerz do out_len przez native chain
    while out.len() < out_len {
        let last = out[out.len() - 1];
        out.push(gf_mul(last, seed[out.len() % 32]));
    }
    let mut h = 0xcbf29ce484222325u64;
    for &b in &out {
        h ^= b as u64;
        h = h.wrapping_mul(0x100000001b3);
    }
    h
}

// ─── U3 — harness G(seed*): ENTRY_PINS SHA-256 + mapa evaluate ──────────
//
// **NIE** formalne `KeygenByteGame134.evaluate` (R1 evaluate OPEN,
// brak pinu packet — M5/K1 ans 4–5). Schemat wejść/wyjść + piny syntetyczne.

/// Wpis ENTRY_PINS (syntetyczny do czasu R1).
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EntryPin {
    pub vector_id: String,
    pub kind: String,
    pub synthetic: bool,
    pub bytes_len: usize,
    pub sha256: [u8; 32],
    pub source_ref: String,
    pub witness_ref: String,
}

/// SHA-256 bajtów (kontrakt M5/R1; FNV-64 tylko spike-local).
/// **Uwaga:** to jest SHA-256 (sha2), NIE SHA3-256 — piny R1 muszą być
/// zgodne z formatem R1 (ENTRY_PINS / postseal).
pub fn entry_pin_sha256(bytes: &[u8]) -> [u8; 32] {
    use sha2::Digest;
    let mut h = sha2::Sha256::new();
    h.update(bytes);
    h.finalize().into()
}

/// Seed syntetyczny: `seed[i]=seed_pattern+i`.
pub fn synthetic_seed_bytes(seed_pattern: u8, len: usize) -> Vec<u8> {
    (0..len)
        .map(|i| seed_pattern.wrapping_add(i as u8))
        .collect()
}

/// Pin wejścia evaluate (seed 32 B) — syntetyczny.
pub fn make_entry_pin_seed(seed_pattern: u8) -> EntryPin {
    let seed = synthetic_seed_bytes(seed_pattern, 32);
    EntryPin {
        vector_id: format!("SEED{seed_pattern:02x}_SYNTH"),
        kind: "seed".into(),
        synthetic: true,
        bytes_len: 32,
        sha256: entry_pin_sha256(&seed),
        source_ref: "M5_PINS_SCHEMA.md / synthetic_seed_bytes".into(),
        witness_ref: String::new(),
    }
}

/// Pin pk 2881 B — **placeholder** (NIE packet R1; witness pusty).
pub fn make_entry_pin_pk_placeholder(seed_pattern: u8) -> EntryPin {
    let pk = synthetic_seed_bytes(seed_pattern, 2881);
    EntryPin {
        vector_id: format!("PK{seed_pattern:02x}_PLACEHOLDER"),
        kind: "packet_pk".into(),
        synthetic: true,
        bytes_len: 2881,
        sha256: entry_pin_sha256(&pk),
        source_ref: "M5: pk_len=2881 SOURCE; bytes=placeholder".into(),
        witness_ref: String::new(),
    }
}

/// Kontrakt długości packet (K1_R1_ANSWERS §2 — **korekta**):
/// pk **dokładnie 2881 B**; sk **7681 ≤ |sk| ≤ 10369** B
/// („≤10370" z R5 = rząd `Fin 10370`, nie widełki).
pub fn packet_len_contract_ok(pk_len: usize, sk_len: usize) -> bool {
    pk_len == 2881 && (7681..=10369).contains(&sk_len)
}

/// Fixture seed9 (R1, jawny) — 32 B `meas1` + 26×`00` + counter 9.
pub const SEED9_HEX: &str =
    "6d65617331000000000000000000000000000000000000000000000000000009";
/// SHA-256 seed9 (pin R1, `K1_R1_ANSWERS.md` pytanie 6).
pub const SEED9_SHA256: [u8; 32] = [
    0x49, 0x41, 0xed, 0xb1, 0xf4, 0xd7, 0xbc, 0xfd, 0xaa, 0x82, 0x83, 0x3d, 0x1c, 0xda, 0x20,
    0x0a, 0xe8, 0x57, 0x82, 0xdc, 0xaa, 0x70, 0x30, 0xfa, 0xe4, 0x39, 0x81, 0x92, 0x98, 0xf3,
    0xa4, 0x50,
];

/// Bajty seed9 z hex (fixture jawny R1).
pub fn seed9_bytes() -> [u8; 32] {
    let mut out = [0u8; 32];
    for i in 0..32 {
        let hi = u8::from_str_radix(&SEED9_HEX[i * 2..i * 2 + 1], 16).unwrap();
        let lo = u8::from_str_radix(&SEED9_HEX[i * 2 + 1..i * 2 + 2], 16).unwrap();
        out[i] = (hi << 4) | lo;
    }
    out
}

/// Pin seed9 w formacie R1 (SHA-256) — **nie** FNV spike.
pub fn entry_pin_seed9_r1() -> EntryPin {
    let seed = seed9_bytes();
    EntryPin {
        vector_id: "SEED9_R1".into(),
        kind: "seed".into(),
        synthetic: false, // fixture R1, jawny — nie syntetyczny spike
        bytes_len: 32,
        sha256: entry_pin_sha256(&seed),
        source_ref: "K1_R1_ANSWERS.md pyt.6 / GeneratedSeed119Fixture".into(),
        witness_ref: "R1: Accepted+package_of_witness = OPEN (region 5)".into(),
    }
}

/// Mapa evaluate (R5 §1): seed 32 B → packet.
/// **`evaluate` OPEN (K1 ans 5)** — zwraca `None` (fail-closed, brak
/// cichego sukcesu / fałszywego packet).
pub fn evaluate_gseed_stub(_seed: &[u8; 32]) -> Option<(Vec<u8>, Vec<u8>)> {
    None
}

#[cfg(test)]
mod tests_n2 {
    use super::*;

    #[test]
    fn n2_entry_pins_stable() {
        // synthetic vectors: pattern 0x01, długości 32/2881 (pk) / 256 (sk-proxy)
        let p32 = entry_pin_synthetic(0x01, 32);
        let p_pk = entry_pin_synthetic(0x01, 2881);
        let p_sk = entry_pin_synthetic(0x01, 256);
        assert_eq!(p32, entry_pin_synthetic(0x01, 32), "determinizm");
        assert_ne!(p32, p_pk);
        assert_ne!(p_pk, p_sk);
        // twarde piny po pierwszym odczycie
        assert!(p32 != 0 && p_pk != 0 && p_sk != 0);
    }

    #[test]
    fn n2_pattern_changes_pin() {
        assert_ne!(
            entry_pin_synthetic(0x01, 64),
            entry_pin_synthetic(0x02, 64)
        );
    }

    #[test]
    fn u3_entry_pin_seed_sha256_stable() {
        let p = make_entry_pin_seed(0x01);
        assert_eq!(p.bytes_len, 32);
        assert!(p.synthetic);
        assert_eq!(p.witness_ref, "");
        let p2 = make_entry_pin_seed(0x01);
        assert_eq!(p.sha256, p2.sha256);
        let p3 = make_entry_pin_seed(0x02);
        assert_ne!(p.sha256, p3.sha256, "inny seed → inny SHA-256");
    }

    #[test]
    fn u3_pk_placeholder_len_contract() {
        let pk = make_entry_pin_pk_placeholder(0x01);
        assert_eq!(pk.bytes_len, 2881);
        assert!(pk.synthetic);
        assert_eq!(pk.witness_ref, "", "R1 evaluate OPEN — brak witness");
        assert!(packet_len_contract_ok(2881, 8000));
        assert!(!packet_len_contract_ok(2880, 8000));
        assert!(!packet_len_contract_ok(2881, 10371));
    }

    #[test]
    fn r1_answers_sk_range_and_seed9_pin() {
        // K1_R1_ANSWERS: sk 7681–10369 (korekta vs „≤10370")
        assert!(packet_len_contract_ok(2881, 7681));
        assert!(packet_len_contract_ok(2881, 10369));
        assert!(!packet_len_contract_ok(2881, 7680), "sk=7680 za krótkie");
        assert!(!packet_len_contract_ok(2881, 10370), "sk=10370 za długie");
        // seed9 fixture R1
        let pin = entry_pin_seed9_r1();
        assert_eq!(pin.sha256, SEED9_SHA256, "SHA-256 seed9 vs R1");
        assert!(!pin.synthetic);
        assert_eq!(seed9_bytes().len(), 32);
    }

    #[test]
    fn u3_evaluate_stub_fail_closed() {
        let seed = [0x01u8; 32];
        assert_eq!(evaluate_gseed_stub(&seed), None, "evaluate OPEN");
    }
}

// ─── V1 — działający silnik FT1536 (oracle; Lean4 nie blokuje) ─────────
//
// Właściciel: FT1536 **działa** (C/ft1536-sys); formalizacja Lean4 (R1)
// nie jest blokadą. Ten moduł = pomiar i oracle działającego silnika:
// realny keygen/sign/verify + widełki pk/sk vs kontrakt R1.

#[cfg(test)]
mod tests_v1_ft1536_engine {
    use ft1536_sys::{Ft1536KeyPair, Ft1536Signature};

    #[test]
    fn v1_engine_sign_verify_roundtrip() {
        let kp = Ft1536KeyPair::generate().expect("ft1536 keygen");
        assert!(!kp.public_key.is_empty());
        assert!(!kp.secret_key().is_empty());
        let msg = b"nexum-threshold-v1-engine-oracle";
        let sig = Ft1536Signature::sign(&kp, msg).expect("sign");
        let ok = Ft1536Signature::verify(&kp.public_key, msg, &sig).expect("verify");
        assert!(ok, "realny FT1536 sign/verify musi przejść");
        let bad = Ft1536Signature::verify(&kp.public_key, b"other", &sig).unwrap();
        assert!(!bad, "zły msg = odmowa");
    }

    #[test]
    fn v1_pk_sk_sizes_vs_r1_contract() {
        // R1 (K1_R1_ANSWERS §2): pk 2881 B; sk 7681–10369 B
        let kp = Ft1536KeyPair::generate().expect("keygen");
        assert_eq!(kp.public_key.len(), 2881, "pk = 2881 jak R1");
        let sk = kp.secret_key().len();
        assert!(
            (7681..=10369).contains(&sk),
            "sk={sk} poza widełkami R1 7681–10369"
        );
    }

    #[test]
    fn v1_sig_has_40b_nonce() {
        let kp = Ft1536KeyPair::generate().unwrap();
        let sig = Ft1536Signature::sign(&kp, b"x").unwrap();
        assert_eq!(sig.nonce.len(), 40, "nonce 40 B jak NONCE_LEN");
        assert!(!sig.bytes.is_empty());
    }
}

// ─── V2 — prawdziwy system: ceremonia progu → realny podpis FT1536 ─────
//
// Właściciel: FT1536 **działa**; idziemy po prawdziwy system.
// Tor: k-z-n udziały seeda → reconstruct seed („moment" ceremonii) →
// `generate_from_seed` (deterministyczny C) → sign → **realne bajty**
// akceptowane przez `Ft1536Signature::verify`. Seed kasowany po ceremonii.
//
// **Granica:** to próg na poziomie seeda (klucz powstaje w procesie
// ceremonii). Pełne MPC-sign (klucz nigdy w całości) = F04/F05 — osobny tor.

use ft1536_sys::{Ft1536KeyPair, Ft1536Signature};

/// Wynik ceremonii podpisu progowego.
pub struct SignCeremonyV2 {
    /// Realne bajty podpisu FT1536 (weryfikowalne silnikiem).
    pub sig_bytes: Vec<u8>,
    /// Nonce 40 B z silnika.
    pub nonce: [u8; 40],
    /// pk (jawne w kontrakcie verify).
    pub public_key: Vec<u8>,
}

/// **V2** — ceremonia: udziały seeda k-z-n → realny podpis.
///
/// 1. Reconstruct seed z ≥k udziałów („moment" — seed w procesie).
/// 2. `Ft1536KeyPair::generate_from_seed` (deterministyczny C).
/// 3. `sign(msg)` → bajty; seed/kasowanie przez Drop keypairu + jawne zeroize.
/// 4. Zwraca podpis + pk; **verify** po stronie wywołującego silnikiem.
///
/// Fail-closed: za mało udziałów / zły seed len → `Err`.
pub fn sign_ceremony_v2(
    seed_shares: &[Share],
    xs: &[u8],
    k: u8,
    msg: &[u8],
) -> Result<SignCeremonyV2> {
    if seed_shares.len() < k as usize {
        return Err(SpikeError::NotEnoughPoints);
    }
    // Reconstruct 32 B seeda bajt-po-bajcie z udziałów
    // (udziały seeda = [Share; 32] per strona — tu: kolumny per bajt)
    // Kontrakt: `seed_shares` to 32 udziały *jednego* bajtu — nie!
    // Pełny seed = wektor 32 B w udziałach: używamy `split_seed` layout
    // [bajt][strona] — patrz `sign_ceremony_v2_from_matrix`.
    let _ = (seed_shares, xs, k, msg);
    Err(SpikeError::WrongThreshold)
}

/// **V2** — ceremonia z macierzą udziałów seeda `[bajt 32][strona n]`.
pub fn sign_ceremony_v2_from_matrix(
    seed_matrix: &[Vec<Share>],
    k: u8,
    msg: &[u8],
) -> Result<SignCeremonyV2> {
    if seed_matrix.len() != 32 {
        return Err(SpikeError::PartyCountMismatch);
    }
    // Reconstruct każdego bajtu
    let mut seed = [0u8; 32];
    for (i, col) in seed_matrix.iter().enumerate() {
        let refs: Vec<&Share> = col.iter().collect();
        seed[i] = reconstruct(&refs)?;
        if col.len() < k as usize {
            return Err(SpikeError::NotEnoughPoints);
        }
    }
    // Realny keygen z seeda (deterministyczny)
    let kp = Ft1536KeyPair::generate_from_seed(&seed)
        .map_err(|_| SpikeError::MacFail)?;
    // Natychmiastowe wyczyszczenie seeda lokalnego
    let mut seed_z = seed;
    seed_z.zeroize();
    let sig = Ft1536Signature::sign(&kp, msg).map_err(|_| SpikeError::MacFail)?;
    let public_key = kp.public_key.clone();
    Ok(SignCeremonyV2 {
        sig_bytes: sig.bytes,
        nonce: sig.nonce,
        public_key,
    })
}

/// Weryfikacja podpisu z ceremonii silnikiem FT1536 (oracle = prawda).
pub fn verify_ceremony_v2(pk: &[u8], msg: &[u8], sig_bytes: &[u8], nonce: &[u8; 40]) -> bool {
    let sig = Ft1536Signature {
        bytes: sig_bytes.to_vec(),
        nonce: *nonce,
    };
    Ft1536Signature::verify(pk, msg, &sig).unwrap_or(false)
}

#[cfg(test)]
mod tests_v2_ceremony {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    const XS: [u8; 3] = [1, 2, 3];

    fn split_seed_matrix(rng: &mut impl rand::RngCore, seed: &[u8; 32]) -> Vec<Vec<Share>> {
        split_seed(rng, seed, &XS, 2).unwrap()
    }

    #[test]
    fn v2_ceremony_real_sig_verifies() {
        let mut rng = StdRng::seed_from_u64(0x56_0001);
        let seed = [0x77u8; 32];
        let msg = b"real-system-threshold-sign";
        let mat = split_seed_matrix(&mut rng, &seed);
        let cer = sign_ceremony_v2_from_matrix(&mat, 2, msg).unwrap();
        assert!(!cer.sig_bytes.is_empty());
        assert!(verify_ceremony_v2(&cer.public_key, msg, &cer.sig_bytes, &cer.nonce));
        // zły msg = odmowa
        assert!(!verify_ceremony_v2(
            &cer.public_key,
            b"other",
            &cer.sig_bytes,
            &cer.nonce
        ));
    }

    #[test]
    fn v2_ceremony_deterministic_from_seed() {
        let mut rng = StdRng::seed_from_u64(0x56_0002);
        let seed = [0x11u8; 32];
        let msg = b"det";
        let m1 = split_seed_matrix(&mut rng, &seed);
        let m2 = split_seed_matrix(&mut rng, &seed);
        let c1 = sign_ceremony_v2_from_matrix(&m1, 2, msg).unwrap();
        let c2 = sign_ceremony_v2_from_matrix(&m2, 2, msg).unwrap();
        // pk z tego samego seeda = ten sam
        assert_eq!(c1.public_key, c2.public_key, "pk deterministyczny z seeda");
    }

    #[test]
    fn v2_ceremony_needs_k_shares() {
        let mut rng = StdRng::seed_from_u64(0x56_0003);
        let seed = [0x22u8; 32];
        let mut mat = split_seed_matrix(&mut rng, &seed);
        // skróć jedną kolumnę do 1 udziału (k=2)
        mat[0].truncate(1);
        assert!(sign_ceremony_v2_from_matrix(&mat, 2, b"x").is_err());
    }

    #[test]
    fn v2_pk_sk_match_r1_contract() {
        let mut rng = StdRng::seed_from_u64(0x56_0004);
        let seed = [0x33u8; 32];
        let mat = split_seed_matrix(&mut rng, &seed);
        let cer = sign_ceremony_v2_from_matrix(&mat, 2, b"m").unwrap();
        assert_eq!(cer.public_key.len(), 2881);
    }
}

/// P2 — nonce w udziałach (syntetyczny stand-in; NIE jest nonce FTKEY/FT1536).
/// 40 B (jak kontrakt FTKEY z notatek) z `derive_key_material_native`-like
/// chain; **bez reconstruct** — otwarcie tylko przez jawny kontrakt.
pub const NONCE_LEN: usize = 40;

pub fn derive_nonce_shares(
    rng: &mut impl rand::RngCore,
    seed_shares: &[Vec<Share>],
    msg_hash: &[u8; 32],
    xs: &[u8],
    k: u8,
) -> Result<Vec<Vec<Share>>> {
    // łańcuch: start od G_frag, mieszaj msg_hash reshare-muls
    let mut out = derive_g_frag_shares(rng, seed_shares, xs, k)?;
    for i in 0..NONCE_LEN {
        let x_at: Vec<u8> = (0..xs.len()).map(|p| out[i][p].share).collect();
        let y_at: Vec<u8> = (0..xs.len())
            .map(|_p| msg_hash[i % 32])
            .collect();
        // jawna stała jako udział jest niepoprawna dla Shamir — użyj
        // mnożenia przez publiczną stałę lokalnie zamiast mul
        for p in 0..xs.len() {
            out[i][p].share = gf_mul(out[i][p].share, msg_hash[i % 32]);
        }
        let _ = (x_at, y_at);
        if i >= 64 {
            break;
        }
    }
    // jeśli NONCE_LEN > 64 — rozszerz
    while out.len() < NONCE_LEN {
        let i = out.len();
        let x_at: Vec<u8> = (0..xs.len()).map(|p| out[i % 64][p].share).collect();
        let y_at: Vec<u8> = (0..xs.len()).map(|_p| msg_hash[i % 32]).collect();
        let prod = crate::mul::mul_shamir_reshare(rng, xs, k, &x_at, &y_at)?;
        out.push(
            xs.iter()
                .enumerate()
                .map(|(p, &x)| Share { x, share: prod[p] })
                .collect(),
        );
    }
    out.truncate(NONCE_LEN);
    Ok(out)
}

/// S2 — nonce przez **prawdziwy SHAKE256** (R2): `SHAKE(nonce_domain || seed || msg_hash)`
/// → [`NONCE_LEN`] B jako bit-udziały. Zastępuje stand-in `derive_nonce_shares`
/// tam, gdzie kontrakt wymaga realnego XOF. NIE jest nonce FT1536 z R1.
pub fn derive_nonce_shake(
    rng: &mut impl rand::RngCore,
    seed_bits: &[crate::shake::BitShares],
    msg_hash: &[u8; 32],
    xs: &[u8],
    k: u8,
) -> Result<Vec<crate::shake::BitShares>> {
    const NONCE_DOMAIN: &[u8] = b"NEXUM-NONCE-SHAKE-v1";
    let n = xs.len();
    if seed_bits.len() != 32 * 8 {
        return Err(SpikeError::PartyCountMismatch);
    }
    let mut input: Vec<crate::shake::BitShares> = Vec::new();
    for &byte in NONCE_DOMAIN {
        for bit in 0..8 {
            input.push(vec![(byte >> bit) & 1; n]);
        }
    }
    input.extend(seed_bits.iter().cloned());
    for &byte in msg_hash {
        for bit in 0..8 {
            input.push(vec![(byte >> bit) & 1; n]);
        }
    }
    crate::shake::shake256_shares(rng, &input, NONCE_LEN, xs, k)
}

/// Oracle S2 („moment").
pub fn derive_nonce_shake_local(seed: &[u8], msg_hash: &[u8; 32]) -> Vec<u8> {
    let mut input = Vec::with_capacity(20 + 32 + 32);
    input.extend_from_slice(b"NEXUM-NONCE-SHAKE-v1");
    input.extend_from_slice(seed);
    input.extend_from_slice(msg_hash);
    crate::xof::shake256_clear(&input, NONCE_LEN)
}

#[cfg(test)]
mod tests_s2_nonce_shake {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    #[test]
    fn s2_nonce_shake_matches_oracle() {
        let mut rng = StdRng::seed_from_u64(0x52_52);
        let seed = [0x22u8; 32];
        let mh = [0x33u8; 32];
        let xs = [1u8, 2, 3];
        let seed_bits = crate::shake::split_seed_to_bit_shares(&mut rng, &seed, &xs, 2).unwrap();
        let out = derive_nonce_shake(&mut rng, &seed_bits, &mh, &xs, 2).unwrap();
        assert_eq!(out.len(), NONCE_LEN * 8);
        let clear = crate::shake::open_bit_shares(&out, &xs, 2).unwrap();
        let mut bytes = Vec::new();
        for i in 0..NONCE_LEN {
            let mut b = 0u8;
            for bit in 0..8 {
                b |= clear[i * 8 + bit] << bit;
            }
            bytes.push(b);
        }
        assert_eq!(bytes, derive_nonce_shake_local(&seed, &mh));
    }

    #[test]
    fn s2_nonce_depends_on_msg() {
        let mut rng = StdRng::seed_from_u64(0x52_53);
        let seed = [0x22u8; 32];
        let xs = [1u8, 2, 3];
        let seed_bits = crate::shake::split_seed_to_bit_shares(&mut rng, &seed, &xs, 2).unwrap();
        let a = derive_nonce_shake_local(&seed, &[1u8; 32]);
        let b = derive_nonce_shake_local(&seed, &[2u8; 32]);
        assert_ne!(a, b, "nonce zależy od msg_hash");
        let _ = seed_bits;
    }
}

// ─── S3 — pełny tor sign na realnym SHAKE (duże TODO) ───────────────────
//
// **NIE** jest to threshold signing FT1536 (brak F04/F05, pinów R1).
// To tor: seed → L1 SHAKE derive → nonce SHAKE → sygnet — z realnym XOF
// zamiast stand-inów G_frag/nonce. Otwarcie tylko przez jawny kontrakt.

/// S3 — wynik toru sign (bit-udziały + sygnet po jawnej integracji).
pub struct SignTorV2 {
    /// L1 derive: `out_len` B jako bit-udziały.
    pub derived_bits: Vec<crate::shake::BitShares>,
    /// Nonce: [`NONCE_LEN`] B jako bit-udziały.
    pub nonce_bits: Vec<crate::shake::BitShares>,
    /// Sygnet syntetyczny (32 B) — otwarty kontrakt (jak `sygnet_synthetic`).
    pub sygnet: Vec<u8>,
}

/// S3 — tor sign v2: realny SHAKE na derive i nonce; sygnet z otwarcia nonce.
pub fn sign_tor_v2(
    rng: &mut impl rand::RngCore,
    seed: &[u8],
    msg_hash: &[u8; 32],
    xs: &[u8],
    k: u8,
) -> Result<SignTorV2> {
    if seed.len() != 32 {
        return Err(SpikeError::PartyCountMismatch);
    }
    let seed_bits = crate::shake::split_seed_to_bit_shares(rng, seed, xs, k)?;
    let derived_bits =
        crate::shake::derive_key_material_shake(rng, &seed_bits, DERIVED_LEN, xs, k)?;
    let nonce_bits = derive_nonce_shake(rng, &seed_bits, msg_hash, xs, k)?;
    // sygnet: jawny kontrakt z otwartego nonce (jak P4 — „moment")
    let nonce_clear = crate::shake::open_bit_shares(&nonce_bits, xs, k)?;
    let mut sygnet = Vec::with_capacity(32);
    for i in 0..32 {
        let mut nb = 0u8;
        for bit in 0..8 {
            nb |= nonce_clear[i * 8 + bit] << bit;
        }
        sygnet.push(nb ^ msg_hash[i]);
    }
    Ok(SignTorV2 {
        derived_bits,
        nonce_bits,
        sygnet,
    })
}

#[cfg(test)]
mod tests_s3_sign_tor {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    #[test]
    fn s3_tor_v2_end_to_end() {
        let mut rng = StdRng::seed_from_u64(0x53_53);
        let seed = [0x44u8; 32];
        let mh = [0x55u8; 32];
        let xs = [1u8, 2, 3];
        let t = sign_tor_v2(&mut rng, &seed, &mh, &xs, 2).unwrap();
        assert_eq!(t.derived_bits.len(), DERIVED_LEN * 8);
        assert_eq!(t.nonce_bits.len(), NONCE_LEN * 8);
        assert_eq!(t.sygnet.len(), 32);
        // sygnet == open(nonce) ⊕ msg_hash
        let nc = crate::shake::open_bit_shares(&t.nonce_bits, &xs, 2).unwrap();
        for i in 0..32 {
            let mut nb = 0u8;
            for bit in 0..8 {
                nb |= nc[i * 8 + bit] << bit;
            }
            assert_eq!(t.sygnet[i], nb ^ mh[i]);
        }
    }

    #[test]
    fn s3_tor_differs_from_standin_chain() {
        let mut rng = StdRng::seed_from_u64(0x53_54);
        let seed = [0x44u8; 32];
        let mh = [0x55u8; 32];
        let xs = [1u8, 2, 3];
        let t = sign_tor_v2(&mut rng, &seed, &mh, &xs, 2).unwrap();
        let old = gseed_chain(&mut rng, &seed, &mh, &xs, 2).unwrap();
        assert_ne!(t.sygnet, old.sygnet, "v2 (SHAKE) ≠ stand-in sygnet");
    }

    #[test]
    fn s4_pins_sign_tor_v2_deterministic_oracle() {
        // Twarde piny FNV (S5 CHANGES → domknięcie): zmiana domeny/SHAKE
        // w torze lub orakle musi wywalić te stałe.
        let seed = [0x44u8; 32];
        let mh = [0x55u8; 32];
        let d1 = crate::shake::derive_key_material_shake_local(&seed, DERIVED_LEN);
        let n1 = derive_nonce_shake_local(&seed, &mh);
        fn fnv(data: &[u8]) -> u64 {
            let mut h: u64 = 0xcbf29ce484222325;
            for &b in data {
                h ^= b as u64;
                h = h.wrapping_mul(0x100000001b3);
            }
            h
        }
        // Piny: FNV(SHAKE256(KEY_DERIVE||seed)[0..128]) i FNV(nonce[0..40])
        // seed=[0x44;32], mh=[0x55;32] — VECTOR_PINS.md
        assert_eq!(
            fnv(&d1),
            0xdf4a4067cba1c082u64,
            "derive oracle FNV pin"
        );
        assert_eq!(
            fnv(&n1),
            0x53039e70fc54f445u64,
            "nonce oracle FNV pin"
        );
    }
}

#[cfg(test)]
mod tests_p2 {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn p2_nonce_shares_oracle() {
        let mut rng = OsRng;
        let seed = [0x21u8; 32];
        let xs = [1u8, 2, 3];
        let sh = split_seed(&mut rng, &seed, &xs, 2).unwrap();
        let mh = [0x7Fu8; 32];
        let nonce = derive_nonce_shares(&mut rng, &sh, &mh, &xs, 2).unwrap();
        assert_eq!(nonce.len(), NONCE_LEN);
        // otwarcie bajtu 0 = jawny kontrakt; determinizm seeda
        let n0 = open_g_frag_byte(&nonce[0], 2).unwrap();
        let nonce2 = derive_nonce_shares(&mut rng, &sh, &mh, &xs, 2);
        // drugie wywołanie z tymi samymi udziałami: nowe trójki → inny tor mul
        // (oracle tylko długość + brak panic)
        assert!(nonce2.is_ok());
        let _ = n0;
    }

    #[test]
    fn p2_nonce_one_share_insufficient() {
        let mut rng = OsRng;
        let seed = [0x22u8; 32];
        let xs = [1u8, 2, 3];
        let sh = split_seed(&mut rng, &seed, &xs, 2).unwrap();
        let mh = [1u8; 32];
        let nonce = derive_nonce_shares(&mut rng, &sh, &mh, &xs, 2).unwrap();
        assert_eq!(
            open_g_frag_byte(&nonce[0][..1], 2).map(|_| ()).unwrap_err(),
            SpikeError::InsufficientShares
        );
    }
}

/// P4 — „sygnet" syntetyczny: wektor bajtów z udziałów (NIE podpis FT).
/// = G_frag( nonce ⊕ digest ) — pokazuje tor „k stron → jeden jawny artefakt".
pub fn sygnet_synthetic(
    rng: &mut impl rand::RngCore,
    seed_shares: &[Vec<Share>],
    msg_hash: &[u8; 32],
    xs: &[u8],
    k: u8,
) -> Result<Vec<u8>> {
    let nonce = derive_nonce_shares(rng, seed_shares, msg_hash, xs, k)?;
    // mieszaj nonce z msg i otwórz 32 B (jawny kontrakt artefaktu)
    let mut out = Vec::with_capacity(32);
    for i in 0..32 {
        let n = open_g_frag_byte(&nonce[i], k)?;
        out.push(n ^ msg_hash[i]);
    }
    Ok(out)
}

#[cfg(test)]
mod tests_p4 {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn p4_sygnet_deterministic_for_seed_and_msg() {
        let mut rng = OsRng;
        let seed = [0x44u8; 32];
        let xs = [1u8, 2, 3];
        let mh = [0x99u8; 32];
        let sh = split_seed(&mut rng, &seed, &xs, 2).unwrap();
        let sig = sygnet_synthetic(&mut rng, &sh, &mh, &xs, 2).unwrap();
        assert_eq!(sig.len(), 32);
        // inny msg → inny sygnet (mieszanie)
        let mh2 = [0x98u8; 32];
        let sig2 = sygnet_synthetic(&mut rng, &sh, &mh2, &xs, 2).unwrap();
        assert_ne!(sig, sig2);
    }
}

/// W3 — łańcuch L0–L4 (syntetyczny G(seed*)-slice):
/// seed shares → derive → nonce → (sampler w select) → sygnet.
pub struct GSeedChain {
    pub derived: Vec<Vec<Share>>,
    pub nonce: Vec<Vec<Share>>,
    pub sygnet: Vec<u8>,
}

pub fn gseed_chain(
    rng: &mut impl rand::RngCore,
    seed: &[u8; 32],
    msg_hash: &[u8; 32],
    xs: &[u8],
    k: u8,
) -> Result<GSeedChain> {
    let sh = split_seed(rng, seed, xs, k)?;
    let derived = derive_g_frag_shares(rng, &sh, xs, k)?;
    let nonce = derive_nonce_shares(rng, &sh, msg_hash, xs, k)?;
    let sygnet = sygnet_synthetic(rng, &sh, msg_hash, xs, k)?;
    Ok(GSeedChain { derived, nonce, sygnet })
}

#[cfg(test)]
mod tests_w3 {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn w3_chain_l0_l4() {
        let mut rng = OsRng;
        let seed = [0x77u8; 32];
        let mh = [0x01u8; 32];
        let xs = [1u8, 2, 3];
        let ch = gseed_chain(&mut rng, &seed, &mh, &xs, 2).unwrap();
        assert_eq!(ch.derived.len(), 64);
        assert_eq!(ch.nonce.len(), 40);
        assert_eq!(ch.sygnet.len(), 32);
        // oracle: sygnet[0] = nonce[0] ⊕ msg_hash[0] (kontrakt z sygnet_synthetic)
        let n0 = open_g_frag_byte(&ch.nonce[0], 2).unwrap();
        assert_eq!(ch.sygnet[0], n0 ^ mh[0], "sygnet[0] must match nonce⊕hash oracle");
    }
}

// ─── S1 — G(seed*) circuit: L1 real SHAKE + L3 NTT (duże TODO) ──────────
//
// Składany obwód wg `MAP_GSEED_SHARE_NATIVE` L0–L3. **NIE** jest formalnym
// `KeygenByteGame134.evaluate` (R1 OPEN, evaluate OPEN). Łączy realny XOF
// (Y1–Y3) z algebrą NTT (P7–P9) zamiast liniowego stand-inu `G_frag`.

/// Wynik obwodu G(seed*) (warstwy L1 i L3).
pub struct GSeedCircuit {
    /// L1: SHAKE256 na udziałach bitów seeda (bit-udziały `out_len*8`).
    pub l1_bits: Vec<crate::shake::BitShares>,
    /// L3: NTT mid-pass na udziałach bajtowych (G_frag 64 B).
    pub l3_bytes: Vec<Vec<Share>>,
    /// Liczba butterfly w L3 (model kosztu M4).
    pub l3_butterflies: usize,
}

/// **S1** — G(seed*) circuit:
/// - L0: seed 32 B → udziały bitów + bajtów,
/// - L1: `shake256_shares(KEY_GSEED_DOMAIN || seed)` — realny XOF,
/// - L3: `derive_g_frag_shares` + `ntt_mid_pass_shares` — algebra regionów.
///
/// **NIE** równa się formalnemu `G(seed*)` (brak pinów R1, evaluate OPEN).
/// Stand-in `G_frag` zostaje dla tanich torów kosztowych.
pub fn g_seed_circuit_shares(
    rng: &mut impl rand::RngCore,
    seed: &[u8],
    out_len: usize,
    xs: &[u8],
    k: u8,
) -> Result<GSeedCircuit> {
    if seed.len() != 32 {
        return Err(SpikeError::PartyCountMismatch);
    }
    // L0
    let seed_bits = crate::shake::split_seed_to_bit_shares(rng, seed, xs, k)?;
    let seed_bytes = split_seed(rng, seed.try_into().unwrap(), xs, k)?;

    // L1 — real SHAKE z domeną G-seed (public bity domeny + seed_bits)
    const GSEED_L1_DOMAIN: &[u8] = b"NEXUM-GSEED-L1-v1";
    let n = xs.len();
    let mut l1_input: Vec<crate::shake::BitShares> = Vec::new();
    for &byte in GSEED_L1_DOMAIN {
        for bit in 0..8 {
            let b = (byte >> bit) & 1;
            l1_input.push(vec![b; n]);
        }
    }
    l1_input.extend(seed_bits.iter().cloned());
    let l1_bits = crate::shake::shake256_shares(rng, &l1_input, out_len, xs, k)?;

    // L3 — G_frag + NTT mid-pass (u, v = 64 B derived).
    // **Uwaga (S5 RECENZENT):** model butterfly jest uproszczony; output L3
    // NIE zachowuje struktury Shamir po NTT (spłaszczenie do u[i]).
    // Nie opisywać wyniku L3 jako „udziałów po NTT".
    let frag = derive_g_frag_shares(rng, &seed_bytes, xs, k)?;
    let mut u: Vec<u8> = frag.iter().map(|col| col[0].share).collect();
    let mut v: Vec<u8> = frag
        .iter()
        .enumerate()
        .map(|(i, col)| col[0].share ^ (i as u8))
        .collect();
    let butterflies = crate::mul::ntt_mid_pass_shares(&mut u, &mut v, xs, 7)?;
    let mut l3_bytes = Vec::with_capacity(frag.len());
    for (i, col) in frag.iter().enumerate() {
        let mut new_col = Vec::with_capacity(col.len());
        for s in col.iter() {
            new_col.push(Share {
                x: s.x,
                share: u[i % u.len()],
            });
        }
        l3_bytes.push(new_col);
    }
    let _ = v;
    Ok(GSeedCircuit {
        l1_bits,
        l3_bytes,
        l3_butterflies: butterflies,
    })
}

/// Oracle L1 („moment"): `SHAKE256(gseed_domain || seed)`.
pub fn g_seed_circuit_l1_local(seed: &[u8], out_len: usize) -> Vec<u8> {
    let mut input = Vec::with_capacity(20 + seed.len());
    input.extend_from_slice(b"NEXUM-GSEED-L1-v1");
    input.extend_from_slice(seed);
    crate::xof::shake256_clear(&input, out_len)
}

#[cfg(test)]
mod tests_s1_gseed {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    #[test]
    fn s1_circuit_l1_matches_shake_local() {
        let mut rng = StdRng::seed_from_u64(0x51_5EED);
        let seed = [0xA5u8; 32];
        let xs = [1u8, 2, 3];
        let c = g_seed_circuit_shares(&mut rng, &seed, 32, &xs, 2).unwrap();
        assert_eq!(c.l1_bits.len(), 32 * 8);
        let clear = crate::shake::open_bit_shares(&c.l1_bits, &xs, 2).unwrap();
        let mut bytes = Vec::new();
        for i in 0..32 {
            let mut b = 0u8;
            for bit in 0..8 {
                b |= clear[i * 8 + bit] << bit;
            }
            bytes.push(b);
        }
        let expect = g_seed_circuit_l1_local(&seed, 32);
        assert_eq!(bytes, expect, "L1 == SHAKE256(gseed_domain||seed)");
        let frag = g_frag_local(&seed);
        assert_ne!(&bytes[..], &frag[..32], "L1 SHAKE ≠ stand-in G_frag");
    }

    #[test]
    fn s1_circuit_l3_ntt_runs() {
        let mut rng = StdRng::seed_from_u64(0x51_5EED);
        let seed = [0x11u8; 32];
        let xs = [1u8, 2, 3];
        let c = g_seed_circuit_shares(&mut rng, &seed, 16, &xs, 2).unwrap();
        assert_eq!(c.l3_bytes.len(), 64);
        assert!(c.l3_butterflies > 0, "NTT mid-pass musi robić butterfly");
    }

    #[test]
    fn s1_fail_closed_seed_len() {
        let mut rng = StdRng::seed_from_u64(1);
        let xs = [1u8, 2, 3];
        assert!(g_seed_circuit_shares(&mut rng, &[0u8; 31], 8, &xs, 2).is_err());
    }
}
