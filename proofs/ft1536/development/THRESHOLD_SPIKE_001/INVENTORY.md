# Inwentaryzacja warsztatu MPC rodziny

**Status: SPIKE / PROTOTYP — inwentaryzacja, nie audyt.**
Źródła (tylko odczyt): `/home/footfalcon/Obrazy/INTEGRATION_PREVIEW_20260908/sAInet/secure_ai_network/crates/`
Testy **nie uruchomiono** (drzewo tylko-do-odczytu); status z inspekcji treści testów.

## A) Publiczne API (skrót)

### san-mpc (`src/lib.rs`, 2439 ln)
| Element | Uwagi | Derywy |
|---|---|---|
| `MpcByte` | `x: u8, share: u8` | **Debug**, Serde, `Zeroize` bez Drop — `lib.rs:90` |
| `MpcValue` | `Drop` zeroizuje heap `:106-109` | **Debug**, Serde — `:101` |
| `BeaverTriple` / `MaskedTriple` | typestate `mask`→`finish`; Drop zeroizuje | brak |
| `PrssGenerator` | uproszczony PRF, **nie** pairwise CDI | — |
| `SpdzKeyShare` | `delta_i: u64` | **Debug, Clone, Copy** `:1009` |
| `AuthShare` | `value, mac: u64` | **Debug, Clone** `:1016` |
| `MpcSession` | Shamir k-z-n / Spdz | — |
| Funkcje | `shamir_share_byte`, `mpc_add/sub/scalar_mul`, Beaver, `spdz_setup/input_dealer/add/mul_public/open/open_batch`, `blind_compare`, `reshare_threshold` (**stub**) | — |

### san-shard-processor
Escrow 32 B → Shamir k-of-n, każdy udział podpisany falcon512 + self-verify.
`SignedShard` **Clone** `:267`; Debug redaguje pola `:285-302`. Stałe V1: 2-z-3; V2: 3-z-5.
**To backup/escrow, NIE threshold signing** (komentarz `:27-28`).

### san-dkg
Pedersen VSS 4-z-7 (`DKG_THRESHOLD=4`, `DKG_TOTAL=7`).
`DkgResult` **Clone, Debug** z `secret_shares: Vec<Scalar>` `mod.rs:100-105`.
`Share` **Clone, Debug**, Zeroize bez Drop `shamir.rs:63-72`.
`run_to_completion` zbiera **wszystkie** udziały w jednym wyniku — harness procesowy, nie rozproszony runtime.

## B) Co naprawdę działa (z treści testów)

| Obszar | Testy | Status |
|---|---|---|
| Shamir GF(256) share/refresh/reconstruct | ~10 (3-of-5, exhaustive) | **działa** (z inspekcji) |
| Beaver mul + `mpc_add` | `mpc_mul_with_beaver`, 3-of-5 | **działa** |
| SPDZ MAC open/mul/tamper | happy + MAC fail | **działa** (model dealerski) |
| Escrow shard split/sign/reconstruct | ~26 w tym 10k random | **działa** |
| Pedersen DKG 4-z-7 in-process | full + C(7,4) combos | **działa** (harness) |
| `reshare_threshold` | brak (stub `bail!`) | **nie istnieje** |
| H-28 edge cases | **brak testów** | **nie naprawione upstream** |
| Klein / sampler MPC / threshold FT | brak | **poza zakresem crates** |

## C) Trusted dealer vs distributed

| Ścieżka | Model | Dowód |
|---|---|---|
| Shamir split | **Trusted dealer** | `shamir_share_byte` `lib.rs:155` |
| Beaver triples | **Dealer** (preprocessing) | `generate_shared` `:267` |
| SPDZ input | **Jawny dealer** | komentarz `:1041-1043` |
| `san-shard-processor` | **Dealer / escrow** | `split_and_sign` `:308` |
| `san-dkg` core | **Rozproszony** (VSS) | `produce_round1` `protocol.rs:68` |
| `DkgSession::run_to_completion` | **Harness zbiera sekret** | `mod.rs:34-97` |

## D) H-28 — potwierdzone w kodzie

1. **`spdz_setup(0)` nieskończona pętla** — `n=0` ⇒ `sum=0` ⇒ `if sum != 0` nigdy; `loop` `:1025-1034`. Brak guarda, brak testu.
2. **Underflow pustych kluczy** — `spdz_input_dealer`: `(0..n-1)` `:1061,:1072` przy `n=0` (usize underflow). `new_spdz` odrzuca `n<2`, ale `spdz_input_dealer` jest publiczne.
3. **Batch open pusty/ragged** — `spdz_open_batch` `:1143`: `all_values[0]` panikuje na pustym; brak kontroli długości wierszy `:1152`.

## E) H-31 — potwierdzone w kodzie

1. **Copy/Clone/Debug na udziałach/kluczach:**
   - `SpdzKeyShare`: **Copy+Clone+Debug** `lib.rs:1009`
   - `AuthShare`: **Clone+Debug** `:1016`
   - `MpcByte`: **Debug** `:90` (brak Copy — nuance)
   - `Share` (dkg): **Clone+Debug** `shamir.rs:63`
   - `DkgResult`, `EpochStore`, `Polynomial`: **Clone+Debug**
   - Kontrast: `SignedShard` Debug redaguje (`san-shard-processor:285`)
2. **Brak kontraktu zeroization:** `SpdzKeyShare`/`AuthShare` bez Zeroize/Drop. `Share` ma Zeroize **bez Drop** (wipe ręczny). `MpcByte` doc: „Does NOT auto-zeroize on drop" `:87-89`.
3. **Słaby wipe:** `MpcValue::drop` zeroizuje tylko heap `Vec`. Kopie stackowe żyją. `SealedShare::drop` tylko ciphertext. Silne Drop mają `MaskedTriple`/`AuthMaskedTriple`.

## F) Granice — czego tu NIE ma

- Threshold signing Falcon / FT1536 — **brak** (shard = osobne podpisy udziałów)
- Klein / Gaussian sampler MPC — **brak**
- Production PRSS (pairwise CDI) — **brak** (jeden seed)
- Dystrybuowany SPDZ input — **brak** (dealer-only)
- Złośliwi uczestnicy w GF256 — **semi-honest**, nieuwierzytelnione d/e
- Reshare/refresh progu — stub `reshare_threshold` `bail!` `:815`

## G) Naprawy w kopii kiełka (NIE upstream)

W `spike/` tego okna (kopia, nie modyfikacja Obrazy):

| Flaw | Status w kopii |
|---|---|
| H-31 Copy/Clone/Debug na udziałach | **naprawiony w kopii**: brak `derive(Clone/Copy)` na typach sekretów; `Drop` zeroizuje |
| H-31 słaby wipe | **naprawiony w kopii**: `Share`/`SeedShare` zeroizują na Drop |
| H-28 edge cases | **nie naprawione** — poza zakresem kiełka (lista napraw do portu poniżej) |

## H) Lista napraw do ewentualnego portu (z H-28/H-31)

1. `spdz_setup`: guard `n>=2`, `bail` zamiast pętli na `n=0`
2. `spdz_input_dealer`: guard `n>=1`, usunąć `n-1` underflow
3. `spdz_open_batch`: guard pustego `all_values`, jednolita długość wierszy
4. `SpdzKeyShare`/`AuthShare`: usunąć `Copy`, dodać `Zeroize` + `Drop`
5. `Share` (dkg): dodać `Drop` do istniejącego `Zeroize`
6. `DkgResult`/`EpochStore`: redakcja Debug albo usunięcie Clone z polami sekretów
7. `MpcByte`: Drop zeroize (nie tylko trait Zeroize)

*Koniec inwentaryzacji. Status: z inspekcji kodu, bez uruchomienia testów.*
