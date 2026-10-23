# MPS_T6 — szum dyskretnego Gaussa na udziałach przed round (R-G2-1)

**Zadanie:** T6 / R-G2-1 fix kryptograficzny właściciela (2026-10-21).
**Zakres:** `src/ishare.rs` (T6 helpers + round/sign), testy `tests_t6`,
suplement w `MPS_G2_NOTES.md`. OUT: Extra/c, [N], git push, kasowanie retained.

## Problem (R-G2-1, Nguyen–Regev)

`sample_z_ffsampling` / `mps4h_sign_shares` liczyły
`z1 = round(t·f/q)`, `z0 = round(−t·F/q)` **deterministycznie**
(`round_half_away`). To Babai nearest plane w kratce NTRU: błędy (s1,s2)
rozkładają się równomiernie w równoległościanie bazy (f,g,F,G) → atak
statystyczny Nguyen–Regev (NTRUSign) odzyskuje klucz z wielu podpisów.
Weryfikator engine tego nie łapie (równanie + krótkość) — to wyciek
KLUCZA, nie błąd verify.

## Fix (wdrożony)

Tajny szum dyskretnego Gaussa w liczniku **przed** dzieleniem przez q:

```
# było: z = round(x / q)
# jest: z = round((x + g) / q)   # g ← DGDG(σ) na udziałach, tajny
```

Wzorce spiku (reuse, nie duplikacja):
- `rejection.rs::sample_gaussian_q73_clear` — jawny rejection z wagami Q73
  (model clear; deal → `ishare_val`, re-deal jak w spiku)
- `ishare.rs::ishare_val` — Shamir shares w Z_P
- G2: `deal_dgdg_shares_with_mac` dokłada MAC = δ·g (spójność otwarcia `d`)

### API (nowe, `ishare.rs`)

| symbol | rola |
|---|---|
| `T6_GAUSS_SIGMA_DEFAULT = 4` | domyślne σ (owner: σ∈[2,8]) |
| `T6_GAUSS_SIGMA_MAX = 64` | fail-closed powyżej |
| `t6_sigma_q73(sigma)` | σ → Q73 (`GAUSS_Q73_ONE`-units) |
| `t6_gauss_window(sigma)` | okno ±6σ (min 8, max 127) |
| `deal_dgdg_shares` | 1× DGDG(σ) → Shamir shares (re-deal) |
| `deal_dgdg_poly_shares` | n_coeffs × DGDG(σ) shares |
| `deal_dgdg_shares_with_mac` | (value, MAC) dla G-2 |

Zmienione sygnatury (parametr szumu; `None` = retained det. F2):
- `round_div_q_scalar_shares(..., gauss: Option<&[u64]>)`
- `round_div_q_shares(..., gauss: Option<&IPolyShares>)`
- `mps4h_sign_shares(..., gauss_sigma: Option<u8>)`
- `round_div_q_scalar_shares_g2(..., gauss: Option<(&[u64], &[u64])>)`
- `round_div_q_shares_g2(..., gauss, gauss_mac)`
- `mps4h_sign_shares_g2(..., gauss_sigma: Option<u8>)`

### Wpływ na rozkład

- **Przed round (wdrożone):** `e = x + g − q·round((x+g)/q)` — residuum
  round jest smużone przez g; krawędzie Babai rozmyte (patrz pomiary).
- **Po round na z (NIE wdrożone — komentarz wymagany przez ownera):**
  `z' = z + g` dałby `e = x − q·(z+g) = e_det − q·g` — szum skalowany
  przez q ≈ 18433 **rozbija bound normy** (n ~ q²·σ²·N). Dlatego szum
  jest wyłącznie w liczniku przed /q.

### Tajność szumu

- Deal przez `ishare_val` (re-deal): po dealu wartość żyje **tylko** jako
  udziały; tor sign nigdy nie woła reconstruct na g.
- Otwarcia w torze sign: masked `d = X − r` w H3 (maska jednorazowa) oraz
  jawne s1,s2. Ujawnienie g ujawniłoby informację o f (R-G2-1) — dlatego
  szum jest sekretny na udziałach.
- Pojedynczy udział partii ≠ sekret (`t6_dgdg_deal_range_and_share_secrecy`).

## Pomiary (debug, seed 0x42 / złoto MPS4-H)

Zap normy: n ≈ 1.04e8 vs bound `FALCON_FT1536_NORM_BOUND2 = 2093922385`.

### `t6_gauss_blurs_babai_edge` (krawędź round, q=18433, x=9216/9217)

| x | det hist z | H (bit) | gauss σ=4 hist z | H (bit) |
|---|---|---|---|---|
| 9216 (→0) | `[0,0,0,32,0,…]` | 0 | `[0,0,0,19,13,0,…]` | 0.9745 |
| 9217 (→1) | `[0,0,0,0,32,0,…]` | 0 | `[0,0,0,11,21,0,…]` | 0.9284 |

Wariancja z na x=9216: det = 0.0, gauss = 0.25. **Krawędź Babai rozmyta**
(wartości z ∈ {0,1} obecne; entropia > 0.3 bita).

### Złoto i norma z szumiem

| test | σ | n | bound | verify |
|---|---|---|---|---|
| `t6_gold_with_gauss_engine_verify` | 4 | 103747771 | < 2.09e9 ✓ | `verify_sign_equation` + `Ft1536Signature::verify == true` |
| `t6_norm_still_under_bound` | 8 | 104106830 | < 2.09e9 ✓ | (sam pomiar n) |
| retained F2 pin (det) | 0 | 103747771 | ✓ | ✓ |

Koszt sign (bez zmian vs det — deal szumu to lokalne odrzucanie + Shamir):
`ring_muls=9437184 bit_ands=4706304 bit_opens=96768`, ~30 s/sign w debug.

### Szczerość o σ=4 na złocie (ważne)

Przy σ=4 i q=18433 oczekiwana liczba przekroczeń progu round na podpis
to `E[flipy] ≈ 2N · 1.6σ / q ≈ 1.07` (2N = 3072 współczynników z0,z1).
Na seedzie 0x42 / msg gold-ff **żaden współczynnik nie przekroczył progu**
— n wyszło **identyczne** jak pin F2 (103747771), mimo że szum był dodany
w liczniku. Przy σ=8: n = 104106830 ≠ pin (co najmniej jeden flip).

Implikacja (nie przemilczać): małe σ smuży rozkład **gęstościowo**
(histograme z na krawędzi), ale typowy podpis z małym σ może mieć
identyczne (s1,s2) jak det (P(≥1 flip) ≈ 1 − e^{−0.27σ}; σ=4 → ~66%,
σ=8 → ~88%). To **łagodzenie**, nie full gaussian sampling.

## Co NIE jest zrobione (zostaje otwarte)

1. **NIE deklarujemy** bezpieczeństwa statystycznego / UC / EUF-CMA.
   To łagodzenie wycieku Babai, nie proof.
2. Pełne **ffLDL / Gaussian sampling z C** (Klein/Falcon) — właściwy
   sampler z·D_Λ; DGDG-per-coeff to stand-in o słabym smużeniu przy σ≪q.
3. Security proof (EU-CMA → MT-ISIS; T07–T14) — poza zakresem T6.
4. MAC na s1,s2 (R-G2-2) — wymaga auth triples przez 4×N² reshare-muls.
5. VSS na pełnym N (R-G2-3) — integracja używa próbki `G2_VSS_SAMPLE=8`.
6. Dystrybucja dealu szumu: obecny model to re-deal przez dealera
   (jak f_mac w G-2). Produkcyjnie: PRSS/MPC rejection sampling bez
   zaufanego dealera (wzorzec `select.rs::sample_gauss_q73_native`
   otwiera wynik — wariant bez otwarcia do przyszłej pracy).
7. Uzasadnienie kryptograficzne poziomu σ vs atak Nguyen–Regev
   (jaka σ wystarcza dla bezpieczeństwa statystycznego) — brak.

## Testy

| test | twierdzenie |
|---|---|
| `t6_sigma_fail_closed` | σ=0 / σ>64 → `WrongThreshold`; okno = 6σ |
| `t6_dgdg_deal_range_and_share_secrecy` | \|g\|≤6σ; udział ≠ sekret |
| `t6_round_with_gauss_matches_clear_formula` | z_mpc ≡ round_half_away((x+g)/q) |
| `t6_gauss_blurs_babai_edge` | krawędź round rozmyta (hist/entropy/var) |
| `t6_gauss_secret_on_shares` | szum = udziały; żywy w (s1,s2); brak reconstruct w sign |
| `t6_norm_still_under_bound` | n(σ=8) < bound (bez pinu F2) |
| `t6_gold_with_gauss_engine_verify` | złoto σ=4: n<bound, eq, engine verify |

Regresja retained: `mps4h_*` i `g2_*` przechodzą z `gauss_sigma=None`
(deterministyczny tor F2/G2 — piny nienaruszone). NIE kasowano F2/G/H/G2.

## Suite

`cargo test` — **349/349 passed, 0 warnings**
(lib 324 = 317 retained + 7 T6; isolation 14; measure_fg 1; spike 10).

*T6 / R-G2-1 — 2026-10-21. Status: closed-by-T6 (łagodzenie wdrożone),
NIE closed jako pełne bezpieczeństwo statystyczne.*
