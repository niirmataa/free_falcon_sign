# PACKAGE_INDEX — T-THRESHOLD spike (kompletny wynik roboczy)

**Suite:** `cargo test --manifest-path spike/Cargo.toml` → **414/414** (389+14+1+10).
**Status:** SPIKE/PROTOTYP. Nie threshold FT, nie MPC-90, nie produkt.
**T13 (2026-10-24):** #16, #2 NAPRAWIONY; #9 RETAINED (granica G-2) — `spike/MPS_T13_NOTES.md`.

## Rdzeń (kod, `spike/src/`)
| Plik | Rola |
|---|---|
| `lib.rs` | Shamir, H_fold, G_frag, MAC, H4 native 128 B |
| `mul.rs` | Lagrange re-deal (bez reconstruct a,b) |
| `cmp.rs` | accept-bit `P_w` bez reconstruct(u); SHAKE stub |
| `pedersen.rs` | VSS verify bez interpolacji (H1) |
| `select.rs` | first-accepted, probed accept, `sample_gauss_native` |
| `rejection.rs` | Gaussa, TV vs target, wektory |
| `prss.rs` | zero-shares, piny |
| `cost.rs` | liczniki + koszty I1/M4 |
| `bin/iso.rs` | procesy: dkg, ped, mac (H2/F-13) |

## Mapy i koszty
- `MAP_GSEED_SHARE_NATIVE.md` (L0–L4, M1–M8)
- `M4_REGION_MAP.md` (regiony 2–4, NTT 768/8/~6144/512)
- `I1_COST_NOTES.md`, `I3_SHAKE_MPC_COST.md`
- `M5_PINS_SCHEMA.md`, `VECTOR_PINS.md`
- `M7_BOUNDS_NOTE.md`, `M6_FAILURE_ABORT.md`, `M8_STOP_AND_REPORT.md`

## Dowody / akta
- `TESTS.md` (201), `FAILURES.md` (F-01..F-21), `REPORT.md`, `TODO.md`
- `K1_R1_ANSWERS_PRELIM.md`, `K1_R1_QUESTIONS.md`, `R5_R1_INTERFACE_NOTES.md`
- `H5_PAPER_SKETCH.md`, `J3_PAPER_OUTLINE.md`, `H28_H31.patch`
- `BOUNDARY_NO_FULL_MATERIAL.md`, `TT43_F04_vs_2026_1300.md`
- **Y:** `Y1_SHAKE_ON_SHARES.md`, `X1_KLEIN_PRECISION.md` §Y4, `Y5_VERIFY_Y_PACKAGE.md`
- **Kod Y:** `src/shake.rs` (SHAKE256 na udziałach), `src/rejection.rs` (Q73)

## Y — konkretne rozwiązania (2026-10-21)
Realny SHAKE256 (FIPS) na udziałach + multi-block + derive z domeną +
wagi Q73 vs analityczna Gaussa. 201/201. Y1–Y3: WERYFIKATOR PASS.

## NIE implikuje
Progu FT, zgodności z formalnym `G(seed*)` (brak pinu/świadka),
pełnego Klein MPC, SPDZ-MAC, modelu złośliwego — `SECURITY_POSITION`
wymagania otwarte.

## ZŁOTO MPS4-H (2026-10-21) — łańcuch F2→G→H

| Plik | Treść |
|---|---|
| `spike/src/ishare.rs` | Shamir i16 (P=2^61−1), rounding w MPC, bit-decomp |
| `spike/src/mpc_sign.rs` | trapdoor, hash_to_point, codec 0xAA, ffsampling |
| `spike/MPS_F2_NOTES.md` | sampler, f^{-1} Euclid, równanie verify |
| `spike/MPS_G_NOTES.md` | splot jawne-t + rounding (wariant B) |
| `spike/MPS_H_NOTES.md` | udziały i16, G-1 zamknięte, retained H-1..H-4 |
| `spike/FT1536_IDENTITY.md` | q=18433, N=1536, ternary (wariant autorski) |

**Złoto:** z z udziałów f,F → s1,s2 → engine verify==true.
**Retained:** G-2 (semi-honest), G-3, H-1..H-4, F2-1.

## T6 / R-G2-1 (2026-10-21) — 349/349

| Plik | Treść |
|---|---|
| `spike/MPS_T6_GAUSS_NOTES.md` | DGDG szum w liczniku Babai, pomiar H/σ |
| `spike/MPS_G2_NOTES.md` | suplement R-G2-1 |
| `spike/Y13_MALICIOUS_MAP.md` | aktualizacja mapy |

Łańcuch: F2→G→H→G-2→T6 PASS. Otwarte: PRSS bez dealera, Klein/ffLDL D_Λ,
σ vs atak, flake s8.

## T7 (2026-10-21) — PRSS/MPC bez dealera — 365/365

| Plik | Treść |
|---|---|
| `spike/MPS_T7_PRSS_NOTES.md` | PRSS masek/szumu, H=0.9544, var=0.249 |
| `spike/Y13_MALICIOUS_MAP.md` | upd. |

Otwarte: pairwise PRSS/CDI, H1/keygen bez clear f,F, Klein/ffLDL, σ vs atak.

## T8 (2026-10-21) — pairwise PRSS + DKG bez clear f,F — 384/384

| Plik | Treść |
|---|---|
| `spike/MPS_T8_PRSS_CDI_NOTES.md` | pairwise CDI, DKG z contributions, retained H1 |
| `spike/prss.rs` | `pairwise_prss_bit_masks`, `pairwise_zero_streams` |
| `spike/ishare.rs` | `*_pairwise`, `dkg_trapdoor_from_contributions` |
| `spike/Y13_MALICIOUS_MAP.md` | upd. (T8 detekcje + luki) |

Otwarte: pełny NTRU keygen offline (ważny wkład, bound F), auth triples
(R-G2-2), Klein/ffLDL, σ vs atak. **Nie** malicious-secure / UC / CDI proof.

## T9 (2026-10-21) — 394/394

| Plik | Treść |
|---|---|
| `spike/MPS_T9_NOTES.md` | weighted keygen, bound F, MAC s1,s2 |
| `spike/ishare.rs` | `dkg_trapdoor_from_weighted_contributions`, `validate_f_bound_shares`, `i_poly_mul_ring_shares_auth` |
| `spike/Y13_MALICIOUS_MAP.md` | upd. |

Otwarte: offline NTRU fG−gF=q (H1), pełny Beaver 4N², Klein/ffLDL, σ vs atak.

## T10 (2026-10-22) — offline NTRU + H1 — 400/400

| Plik | Treść |
|---|---|
| `spike/MPS_T10_NOTES.md` | offline fG−gF=q na ważonej sumie, domknięcie H1 |
| `spike/ishare.rs` | `ntru_fg_gf_open_delta`, `ntru_fg_gf_check_weighted_shares`, `trapdoor_contribution_digest` |
| `spike/Y13_MALICIOUS_MAP.md` | upd. (T10 detekcje) |
| `spike/PROMPT_T10_OFFLINE_NTRU_H1.md` | zlecenie T10 |

Otwarte: pełna ceremonia publicznego keygen NTRU (sumowanie wkładów),
pełny Beaver w złocie, Klein/ffLDL, σ vs atak. `g2_deal_trapdoor` = retained/test-only.
**Nie** malicious-secure / UC / „brak dealera” w pełnym sensie.
