# SOURCE_MAP — dyspozycja spike'a THRESHOLD_SPIKE_001

**Wersja:** 0.1 (2026-10-26) · **Status:** G0
**Zasada:** spike jest **spec/oracle/testkit**, nie fundamentem produkcji.
Każdy moduł ma jawną dyspozycję; „niejasne” nie istnieje.

Statusy:

- **REUSE** — koncept/kod do przejęcia po review, z pinem i testem.
- **REWRITE** — koncept tak, kod od nowa (API/bezpieczeństwo/CT).
- **RESEARCH** — materiał badawczy; nie wchodzi do `PROD` bez dowodu.
- **TEST-ONLY** — wyłącznie `#[cfg(test)]`/`testkit`; zakaz w `PROD`.
- **FORBIDDEN** — nie może istnieć w ścieżce `PROD` (nawet jako feature).
- **REFERENCE** — dokument/wektor; nie kod produkcyjny.
- **OUT** — poza lane (obcy/untracked); nie importować.

---

## 1. Kod (`spike/src`)

| Moduł | Rola w spiku | Dyspozycja | Co konkretnie | Spec | WP |
|---|---|---|---|---|---|
| `lib.rs` | GF(256) Shamir, guardy H-28, błędy, seed deal/reconstruct, `sign_ceremony_v2` | **REWRITE** + **FORBIDDEN** dla `sign_ceremony_v2` | GF(256) tylko MAC/bytes; `sign_ceremony_v2` reconstructuje `sk` — zakaz w `PROD` | §2, §7 | WP-012 |
| `ishare.rs` | Z_P: Shamir, DKG wkładów, VSS, MAC, ring-mul, ffSampling shares, codec, KAT | **REUSE/REWRITE** | arytmetyka i KAT; usunąć `delta_known`, `G2_VSS_SAMPLE=8`; `g2_deal_trapdoor` → test-only; pełny VSS; ukryte δ | §6, §7 | WP-012–016 |
| `mpc_sign.rs` | q-arytmetyka, Shamir, HTP, równanie verify, codec, trapdoor sign, ff_lite/Babai | **REUSE** (arytmetyka/HTP/codec) + **FORBIDDEN** (deterministyczny Babai/ff_lite w `PROD`) + **REWRITE** (ffSampling) | HTP i codec 0xAA muszą być byte-exact; `sample_z_ffsampling`/`ff_lite` tylko `TEST-ORACLE` | §2, §7 | WP-012, WP-041 |
| `pedersen.rs` | Pedersen VSS (Ristretto) | **REWRITE** | pełne `N` zobowiązań, zeroize, stała kontrola, brak „próbki 8” | §6.2 | WP-016 |
| `mul.rs` | mnożenie Shamir / reshare | **REUSE** (badania) + **REWRITE** (auth) | brak malicious-secure; potrzebne auth triples/sacrifice | §6, §7 | WP-013 |
| `prss.rs` | PRSS-lite, pairwise, maski bitowe | **RESEARCH/REWRITE** | FNV-derived seeds i brak CDI proof; nie `PROD` | §9 | WP-012 |
| `rejection.rs` | eksperymenty rejection sampling | **RESEARCH** | fail-open w części API; brak Klein 73-bit; tylko testy do czasu naprawy | §7.7 | WP-040 |
| `select.rs` | wybór „pierwszy przyjęty” | **RESEARCH** | ujawnia `found`/okno kandydatów; wymaga CT i analizy | §7.4 | WP-040 |
| `cmp.rs` | accept-bit probed | **RESEARCH** | 255 Beaver/bit; brak bit-decomp; budżet i bezpieczeństwo do dowodu | §7.4 | WP-040 |
| `klein.rs` | Bernoulli/Klein building blocks | **RESEARCH** | nie jest Klein 73-bit; port z dowodem/TV | §7.4 | WP-040 |
| `shake.rs` | SHAKE256 na udziałach (bit-level) | **REUSE** (badania/MAC) | poprawny FIPS bit-exact; koszt ~10³×; nie używać jako dowodu wydajności | §7.5 | WP-012 |
| `xof.rs` | stand-in XOF (nie SHAKE) | **FORBIDDEN** w `PROD` | wyłącznie model kosztu/test; brak w release | §5.2 | WP-025 |
| `cost.rs` | liczniki kosztu | **TEST-ONLY** | `#[cfg(test)]`; przenieść do benchmarków | §14 | WP-044 |
| `bin/iso.rs` | plikowy mailbox/process demo | **TEST-ONLY** | nie jest siecią; nie ma auth; testkit | §9 | WP-045 |

---

## 2. Testy (`spike/tests`)

| Plik | Rola | Dyspozycja |
|---|---|---|
| `tests/spike.rs` | 10 testów złotego łańcucha i progów | **REUSE** jako regresja `TEST-ORACLE` |
| `tests/isolation.rs` | 14 testów procesów/mailboxa | **REUSE** jako testkit; nie `PROD` |
| `tests/measure_fg.rs` | pomiar zakresu `f,g` | **REUSE** jako benchmark |
| `Cargo.toml` | absolute path do `ft1536-sys` | **REPLACE**: vendor + pin (R-05) |

**Pin F2 `n = 103747771`** (seed 0x42, msg `gold-ff`, nonce `[0;40]`) jest
regresją `TEST-ORACLE`; nie jest KAT `PROD`.

---

## 3. Dokumenty spike'a

| Dokument | Dyspozycja | Uwaga |
|---|---|---|
| `REPORT.md`, `PACKAGE_INDEX.md` | **REFERENCE** | stan 414/414, historia |
| `FAILURES.md` | **REFERENCE** | retained failures; checklist G1 |
| `AUDYT_WEWNĘTRZNY_T12.md` | **REFERENCE** | 16 findingów; mapowanie na WP-013–020 |
| `Y13_MALICIOUS_MAP.md` | **REFERENCE** | co łapiemy / luki |
| `BOUNDARY_*`, `SECURITY_POSITION.md` | **REFERENCE** | granice claimów |
| `MPS_F2_NOTES.md` | **REFERENCE** | złoto F2, F2-1 odrzucone |
| `MPS_T6_GAUSS_NOTES.md` | **REFERENCE** | Gauss/Q73 |
| `MPS_T7_PRSS_NOTES.md` | **REFERENCE** | PRSS |
| `MPS_T8_PRSS_CDI_NOTES.md` | **REFERENCE** | pairwise/CDI luki |
| `MPS_T9_NOTES.md` | **REFERENCE** | ważony DKG, bound F, MAC |
| `MPS_T10_NOTES.md` | **REFERENCE** | offline NTRU, retained H1 |
| `MPS_T13_NOTES.md` | **REFERENCE** | #16/#2/#9 |
| `M6_FAILURE_ABORT.md` | **REFERENCE** | fail-closed |
| `M5_PINS_SCHEMA.md` | **REFERENCE** | pin seeds; packet OPEN |
| `DESIGN.md` | **REFERENCE** | A vs B; D-021 → D-024 (B′); nie wybiera zadania |
| `P1_SIGN_PROTOCOL.md` | **REFERENCE** | szkic rund; nie spec |
| `MAP_GSEED_SHARE_NATIVE.md` | **REFERENCE** | wejście do O-16 (B′); nadal nie kod |
| `I1_COST_NOTES.md`, `I3_SHAKE_MPC_COST.md` | **REFERENCE** | rzędy kosztów, nie pomiar |
| `PROMPT_T11_PUBLIC_KEYGEN_CEREMONY.md`, `SECURITY_AUDIT_T11_REPORT.md` | **REFERENCE** | wymagania, nie implementacja |
| `PROMPT_T14_HIDDEN_DELTA_G2.md` | **OUT** | untracked/obcy; nie importować |
| `PROMPT_*`, `SPIKE*_NOTES.md` | **REFERENCE** | historia; nie wybierają zadania |
| `iso-tmp/` | **OUT** | artefakty testowe; nie do repo |

---

## 4. Czego nie przenosimy nigdy

1. `g2_deal_trapdoor` w ścieżce `PROD` (dealer).
2. `sign_ceremony_sk_shares` / `sign_ceremony_v2` (reconstruct `sk`).
3. `trapdoor_sign_ffsampling_share_ceremony` (reconstruct `f,F` do `z`).
4. `xof.rs` jako generator kluczy.
5. `delta_known` w API `PROD`.
6. `G2_VSS_SAMPLE=8` jako pełny VSS.
7. `bin/iso.rs` jako transport.
8. Absolutna ścieżka `ft1536-sys`.
9. Deterministyczny Babai/`ff_lite` jako sampler `PROD`.

---

## 5. Kolejność importu

1. **WP-012:** arytmetyka `Z_q`/`R_q`, HTP, codec, Shamir — z KAT.
2. **WP-013–016:** ukryte δ, typestate, maski, pełny VSS.
3. **WP-017–020:** zeroizacja, malformed, envelope/replay.
4. **WP-041:** ffSampling — nowy kod, nie port `ff_lite`.
5. **WP-040:** Klein — badania, nie port `klein.rs` 1:1.

**Zasada:** każdy import ma test KAT i wpis w `SOURCE_MAP`; brak testu =
brak importu.
