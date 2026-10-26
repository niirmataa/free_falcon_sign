# WORK PACKAGES — konkretne działania

**Zasada:** każdy pakiet ma zakres, kryterium odbioru, dowód i zależności.
Statusy: `DONE`, `IN_PROGRESS`, `TODO`, `BLOCKED`, `DROPPED` (z powodem).
Rozmiar: S (1 okno), M (2–3), L (4–8), XL (badania, bez daty).

---

## Batch 0 — G0 (start programu)

| ID | Gate | Zadanie | Kryterium odbioru | Dowód | Zależy | Rozmiar | Status |
|---|---|---|---|---|---|---|---|
| WP-001 | G0 | Otworzyć lane: README/PLAN/THREAT/CLAIMS/GATES/WP/RISKS/SOURCE_MAP | pliki istnieją, spójne ID, brak sprzeczności | ten katalog | — | S | **DONE** |
| WP-002 | G0 | `SPEC.md` v0: role, rundy, komunikaty, transkrypt, abort, otwarte punkty | spec czytelny, punkty otwarte jawnie oznaczone | `SPEC.md` | WP-001 | M | **DONE** (v0) |
| WP-003 | G0 | Potwierdzić decyzje blokujące G1 (D-003/010/011/013/016/021) | wpisy `ACCEPTED` w `DECISIONS.md` | decyzja właściciela | WP-001 | S | **DONE** (2026-10-26; D-021 → D-024 B′) |
| WP-004 | G0 | Dyspozycja spike'a: reużyj/przepisz/zakaż | tabela per moduł, brak „niejasne” | `SOURCE_MAP.md` | WP-001 | S | **DONE** |

---

## Batch 1 — G1 (hardened foundation)

| ID | Gate | Zadanie | Kryterium odbioru | Dowód | Zależy | Rozmiar | Status |
|---|---|---|---|---|---|---|---|
| WP-010 | G1 | Workspace crate'ów + `rust-toolchain.toml` + `deny.toml` | `cargo build --locked --offline` w CI; **brak `ftkey-vm`/QSX/VM** (D-023) | CI log | WP-003 | M | **DONE** (2026-10-26; `impl/ci/WP010_CHECK_2026-10-26.txt`) |
| WP-011 | G1 | Linty i polityki: `forbid(unsafe_code)`, `clippy -D warnings`, `cargo deny`, `miri` | CI czerwone na naruszeniu | CI | WP-010 | S | **DONE** 2026-10-26 — `ci/check.sh`: fmt/build/test/clippy/deny/miri; dowód `ci/WP011_CHECK_2026-10-26.txt`; czerwona ścieżka `deny` (wildcard) potwierdzona |
| WP-012 | G1 | Port/rewrite prymitywów: `gf_mul`, Shamir, `R_q`, NTT, SHAKE, PRSS, Pedersen | KAT ze spike'a przechodzą; brak `unsafe` | `core/tests` | WP-010 | L | **IN_PROGRESS** (`gf_mul`/GF(256)+Shamir seeda, `R_q` szkolne, SHAKE256+`hash_to_point`, PRSS z parami kluczy i udziałami zera, ternarna NTT silnika (logn=10, port `mq_mkgm3`/`mq_NTT_ternary`) DONE z KAT; Pedersen TODO) |
| WP-013 | G1 | **#9** ukryte δ w G-2; usunąć `delta_known` z API prod | skorelowane Δ+δ·Δ → `MacFail`; test retained znika | test + audyt | WP-012 | M | TODO |
| WP-014 | G1 | **#3** typestate DKG/NTRU: sign tylko z walidowanego stanu | nie da się zbudować sesji sign bez evidence | test kompilacyjny | WP-012 | M | TODO |
| WP-015 | G1 | **#4** maski: świeże, niezależne szerokości | dwa otwarcia tego samego sekretu nie korelują | test statystyczny | WP-012 | M | TODO |
| WP-016 | G1 | **#7** pełne VSS w sign (usunąć `G2_VSS_SAMPLE=8`) | wszystkie współczynniki weryfikowane | test + benchmark | WP-012 | M | TODO |
| WP-017 | G1 | **#11** zeroizacja: `ZeroizeOnDrop`, brak `Clone`/`Debug`, `mlock`, no-dump | test braku kopii; `valgrind`/allocator hook | test | WP-012 | M | TODO |
| WP-018 | G1 | **#13** SHAKE: bitność i spójność każdego udziału | forged bit → `Err` | test | WP-012 | S | TODO |
| WP-019 | G1 | **#14** malformed input: `TryFrom`, limity, brak paniki | fuzz 10⁶ bez paniki | fuzz log | WP-010 | M | TODO |
| WP-020 | G1 | **#15** koperty uwierzytelnione, licznik rund, replay-window | replay/rollback → `Err` | test | WP-010 | M | TODO |
| WP-021 | G1 | Fail-closed wszystkie samplery (`AttemptsExhausted`) | brak `SampleOutcome` na capie | test | WP-012 | S | TODO |
| WP-022 | G1 | Fuzz targets: wire, codec, `hash_to_point`, `decode_sk` | corpus + CI | fuzz | WP-019 | M | TODO |
| WP-023 | G1 | Differential vs silnik: KAT + 10⁴ | 0 rozjazdów | raport | WP-012 | M | TODO |
| WP-024 | G1 | KAT pins: seed/nonce/msg → pk/podpis/transkrypt | pin w repo + test | `KAT/` | WP-023 | M | TODO |
| WP-025 | G1 | Usunąć ścieżki zakazane z builda prod (dealer, `xof`, `iso`, oracle sampler) | build prod bez symboli | CI + `grep` | WP-010 | S | TODO |
| WP-026 | G1 | Hermetyczne CI + reproducible build (offline, pinned, SBOM) | dwa buildy = ten sam hash | CI | WP-010 | M | TODO |
| WP-027 | G1 | Wire/CBOR/CDDL freeze: canonical CBOR, envelope, MAC, limity | non-canonical odrzucone; schematy w repo; test vectors | test + dokument | WP-010 | M | TODO |

**Exit G1:** wszystkie powyższe `DONE` + niezależny odbiór.

---

## Batch 2 — G2 (signing protocol on `TEST-ORACLE`)

| ID | Gate | Zadanie | Kryterium odbioru | Dowód | Zależy | Rozmiar | Status |
|---|---|---|---|---|---|---|---|
| WP-030 | G2 | Setup message flow 2-of-3 na `TEST-ORACLE`: znany klucz testowy, pełny VSS, complaints, transkrypt, `pk_hash` | każda runda przechodzi; fałszywy wkład → complaint + abort; `pk_hash` zgodny; `profile=0x01` | test | G1 | L | TODO |
| WP-031 | G2 | Sign 2-of-3 z oracle-samplerem (tylko plumbing) | engine verify; brak reconstruct w ścieżce sign | test | WP-030 | L | TODO |
| WP-032 | G2 | Malicious harness: ≥10 strategii | każda → abort/`Err` z winnym | macierz | WP-030 | L | TODO |
| WP-033 | G2 | Nonce commit/reveal, transkrypt/sesje/epoki/replay/abort | replay odrzucony; abort identyfikowalny; nonce unikalny | test | WP-031 | M | TODO |
| WP-034 | G2 | Parametryzacja 3-of-5 | te same testy dla k=3,n=5 | test | WP-030 | M | TODO |
| WP-035 | G2 | Audyt „brak reconstruct w sign” | brak API/slotu na pełny klucz w ścieżce sign | raport + `grep` | WP-031 | S | TODO |
| WP-036 | G2 | `SPEC.md` v1 (po implementacji) | spec = kod; profile jawnie rozdzielone | dokument | WP-033 | M | TODO |

**Exit G2:** protokół referencyjny działa na `TEST-ORACLE`; złośliwy nie
forge'uje; brak reconstruct w sign. **To nie jest `PROD`.**

---

## Batch 2b — G3 (realna krypto: setup + sampler)

| ID | Gate | Zadanie | Kryterium odbioru | Dowód | Zależy | Rozmiar | Status |
|---|---|---|---|---|---|---|---|
| WP-037 | G3 | **O-16/O-04** MPC `G(seed*)` w setupie B′; zero-test relacji NTRU bez otwierania różnicy | udziały `(f,g,F,G)` bez rekonstrukcji `seed*`/klucza; seed zeroizowany; brak dealera | test + audyt | WP-030 | XL | TODO |
| WP-038 | G3 | **O-05** `pk` bez reconstruct: MPC `f^{-1}`, `h=g·f^{-1}` | tylko `h` otwarte; `pk_hash` zgodny | test + raport | WP-037 | L | TODO |
| WP-039 | G3 | Pełny VSS/complaints w `PROD`; dyskwalifikacja bez reconstruct | wszystkie współczynniki; koszt zmierzony | test + benchmark | WP-037 | M | TODO |
| WP-040 | G3 | Realny sampler: Klein 73-bit / `D_Λ` | TV vs target z CI; zero fail-open | raport stat. | G2 | XL | TODO |
| WP-041 | G3 | ffSampling: FFT3 + LDL; **O-06** check normy wierny silnikowi | krótkie `z`; `c·L2 < B_norm`; engine verify | test + raport | WP-040 | XL | TODO |
| WP-042 | G3 | `s2` w całości na udziałach | brak reconstruct `f,F` | test + audyt | WP-041 | L | TODO |
| WP-043 | G3 | Byte-compat + `pk` binding | 10³ KAT + 10⁵ differential; 0 rozjazdów | raport | WP-042 | M | TODO |
| WP-044 | G3 | Performance: rundy/bajty/latency | budżet zmierzony, nie szacowany | benchmark | WP-042 | M | TODO |
| WP-045 | G3 | Transport w sieci: 3 nody, mTLS, chaos | brak cichych błędów przy partition | raport | G2 | L | TODO |
| WP-046 | G3 | Refresh/reshare | `pk` bez zmian; stare udziały bezużyteczne | test | WP-030 | L | TODO |
| WP-047 | G3 | HSM/TPM adapter | seal/unseal; brak plaintextu na dysku | test | WP-045 | M | TODO |
| WP-048 | G3 | `ft1536-sys` vendor + pin + SBOM | build offline; brak absolutnej ścieżki | CI | WP-010 | M | TODO |

**Exit G3:** podpis bez oracle-samplera, byte-exact, sieciowy, z refresh,
na MPC `G(seed*)` B′. To pierwsza bramka `PROD`.

---

## Batch 4 — G4 (assurance)

| ID | Gate | Zadanie | Kryterium odbioru | Dowód | Zależy | Rozmiar | Status |
|---|---|---|---|---|---|---|---|
| WP-050 | G4 | Dowód game-based/UC | jawne założenia, redukcja, brak luk | proof | G3 | XL | TODO |
| WP-051 | G4 | Model formalny protokołu (Tamarin/ProVerif) | ataki z modelu nie przechodzą | raport | G3 | L | TODO |
| WP-052 | G4 | Side-channel: dudect/TVLA + CT | brak wysokich otwartych | raport | G3 | L | TODO |
| WP-053 | G4 | Fault injection | fail-closed, brak wycieku | raport | G3 | M | TODO |
| WP-054 | G4 | Zewnętrzny audyt | brak critical/high | raport | G3 | XL | TODO |
| WP-055 | G4 | Red team | scenariusze z threat modelu | raport | G3 | M | TODO |
| WP-056 | G4 | Disclosure/bug bounty | polityka + kanał | dokument | G3 | S | TODO |

**Exit G4:** niezależny PASS albo podpisana decyzja o ryzyku.

---

## Batch 5 — G5 (production readiness)

| ID | Gate | Zadanie | Kryterium odbioru | Dowód | Zależy | Rozmiar | Status |
|---|---|---|---|---|---|---|---|
| WP-060 | G5 | HSM/TPM produkcja | attestation, seal/unseal, rotacja | raport | G4 | L | TODO |
| WP-061 | G5 | Recovery/revocation | utrata kworum, restore, unieważnienie | test DR | G4 | L | TODO |
| WP-062 | G5 | Polityka koordynatora | limity, approvals, kill switch | test | G4 | M | TODO |
| WP-063 | G5 | Monitoring/audyt | hash-chain, alerty, brak sekretów | test | G4 | M | TODO |
| WP-064 | G5 | Release: reproducible, SBOM, podpisy | dwa buildy = hash | CI | G4 | M | TODO |
| WP-065 | G5 | IR/DR runbook | ćwiczenie + raport | dokument | G4 | M | TODO |
| WP-066 | G5 | Operacyjny odbiór | owner+ops+security | protokół | G4 | S | TODO |

**Exit G5:** checklista „production” z `PLAN.md` §12 w całości `PASS`.

---

## Najbliższy batch

1. **WP-003** — **DONE** 2026-10-26 (B′ + domyślne decyzje).
2. **WP-010/011** — workspace + CI (mechaniczne, bez krypto).
3. **WP-012** — port prymitywów z KAT (największy kawałek G1).
4. **WP-013** — T14 ukryte δ (najpierw mały, izolowany fix).
5. **WP-019/022** — fuzz od pierwszego dnia.

Kolejność uzasadniona: CI i KAT przed krypto, żeby każdy kolejny krok
miał natychmiastową regresję.
