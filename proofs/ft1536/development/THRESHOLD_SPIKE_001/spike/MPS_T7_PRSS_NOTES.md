# MPS_T7 — PRSS / MPC rejection bez dealera (masks + noise)

**Zadanie:** T7 `PROMPT_T7_PRSS_NO_DEALER.md` (2026-10-21).
**W:** `FT1536_THRESHOLD_SPIKE_001/spike/`. **Status:** kod + testy w W;
**nie** malicious-secure / UC / EUF-CMA / „próg FT gotowy”.
**Out:** `Obimages/`, `Extra/c`, `[N]`, git push.

## Wejście (pin okna)

- Suite przed T7: **349/349**, 0 warnings (F2→G→H→G-2→T6 PASS).
- Złoto: `Ft1536Signature::verify==true`, pin F2 (`n=103747771`, seed 0x42,
  msg `gold-ff`), `mps4h`/`t6_` zielone.
- Retained **nieskasowane**: F2-1, G-1..G-3, H-1..H-4, T6.

## Co T7 zmienia (i czego NIE)

| Element | Przed T7 | Po T7 | Scope twierdzenia |
|---|---|---|---|
| Maska W-bit (`r ∈ [0,2^W)`) | `paired_bit_mask` — dealer widzi bit w clear | `paired_bit_mask_prss` / `shared_bit_masks` — bit `b=⊕β_i` **nigdy w clear** | brak centralnego dealera maski; **nie** full PRSS/CDI |
| Szum DGDG(σ) w liczniku | `deal_dgdg_*` — dealer widzi clear `g` | `prss_dgdg_*` — suma wkładów `g_i~DGDG(σ/√n)` | brak dealera pełnego `g`; rozkład **mierzony** |
| i16 f,F (trapdoor) | `g2_deal_trapdoor` clear key | **bez zmian w modelu** + zastrzeżenie **H1 = moment setupu** | NIE „H1 bez dealera” |
| Złoto MPS4-H / T6 | verify true | verify true (regresja + nowe `t7_gold_*`) | pin F2 nietknięty |

## T7.1 — maski W-bit (PRSS / wkłady)

`ishare.rs::paired_bit_mask_prss`, `prss.rs::shared_bit_masks`.

Konstrukcja (udokumentowana w kodzie):

1. Każda wirtualna partia `i` losuje lokalną monetę `β_i ∈ {0,1}`.
2. Shamir-dzieli **tylko** `β_i` w GF(256) i Z_P.
3. `b = ⊕_i β_i` powstaje **wyłącznie na udziałach**:
   - GF(256) char 2: suma udziałów = udziały XOR (liniowość);
   - Z_P: `x⊕y = x+y−2·x·y` łańcuchem reshare-mul (`cost.prss_xor_muls`).

**Retained:** stary `paired_bit_mask` / `paired_bit_mask_mac` (dealer clear-bit)
zostają jako model testowy / porównanie dystrybucji. Ścieżka złota T7 woła
wersje `*_prss`.

**Model spiku (uczciwie):** symulacja in-process — jeden `rng` karmi monety
„wirtualnych” partii. API nie zwraca bitu maski w clear; widok partii to
udziały. Rozdzielenie rng per strona = wieloprocesowe iso — osobny tor.

## T7.2 — szum DGDG(σ) (wkłady partii)

`ishare.rs::prss_dgdg_shares` / `_poly_shares` / `_with_mac`.

Konstrukcja: `g = Σ_i g_i` z `g_i ← DGDG(σ/√n)` (lokalny wkład, Shamir tylko
`g_i`). Suma udziałów = udziały `g`. Tor sign **nie** rekonstruuje `g`
(reconstruct tylko w testach pomiarowych).

MAC G-2: `mac[p] = δ · val[p]` (liniowość; `delta_known` modelu testowego).

**Retained:** `deal_dgdg_*` zostaje (T6 / model dealera). Ścieżka złota
`mps4h_sign_shares` / `_g2` z `gauss_sigma=Some` → `prss_dgdg_*`.

### Pomiary (pomiar, nie twierdzenie) — `t7_prss_dgdg_babai_blur`

| x | det H | prss H (σ=4) |
|---|---|---|
| 9216 (→0) | −0.0000 | **0.9544** |
| 9217 (→1) | −0.0000 | **0.9544** |

| | det var | prss var |
|---|---|---|
| residuum z | 0.000000 | **0.249023** |

Cel T6/T7: H≈0.95 bita, var≈0.25 — **spełnione w pomiarze** (32 powt. na
krawędź, jak T6). To łagodzenie Babai/Nguyen–Regev, **nie** proof.

## T7.3 — i16 f,F: H1 = moment setupu (zastrzeżenie)

Pełny bezdealerowy keygen NTRU (`fG−gF=q`) **poza zakresem spiku**.

- `g2_deal_trapdoor` / `ishare_poly_with_vss`: jawny deal klucza = **H1
  ceremony**. Clear f,F istnieje w tym momencie. Po H1 tor sign pracuje
  na udziałach.
- `reshare_ipoly` / `t7_reshare_ipoly_preserves_secret`: re-deal już-
  współdzielonego materiału bez reconstruct (jak TT-52 refresh) — **nie**
  keygen.
- **NIE deklarować:** „H1 bez dealera” / „klucz nigdy w clear”.

## T7.4 — matrix fałszerstw (fail-closed)

| Atak | Mechanizm | Test |
|---|---|---|
| Tamper maski PRSS (G-2) | MAC open `d` → `MacFail` | `t7_tamper_prss_mask_g2_macfail` |
| Tamper udziału szumu (G-2) | MAC → `MacFail` | `t7_tamper_noise_g2_macfail` |
| Tamper szumu **bez** G-2 | brak MAC — **retained luka** | `t7_no_g2_noise_tamper_retained_gap` |

## Regresja złota (po T7)

- `mps4h_ffsampling_shares_gold`, `t6_gold_with_gauss_engine_verify`,
  `g2_sign_honest_engine_verify_true` — zielone (349 retained).
- Nowe: `t7_gold_with_prss_masks_engine_verify`,
  `t7_gold_with_prss_noise_engine_verify`,
  `t7_g2_sign_with_prss_engine_verify` — verify true.
- Pin F2 nietknięty (`n2_entry_pins_stable`).
- Suite po T7: **365/365**, 0 warnings.

## Retained failures / pułapki okna

1. **In-process rng** — monety wirtualnych partii z jednego `rng`; nie jest
   to pairwise PRSS z `pair_seed`. Do produkcji: osobne rng/iso + CDI.
2. **`prss_dgdg` ≈ DGDG(σ)** przez sumę `σ/√n` — bliskie, mierzone; nie
   równość dystrybucji dyskretnej.
3. **delta_known w G-2** — nadal jawny klucz MAC w modelu testowym
   (jak przed T7). Ukryte δ-shares do otwarcia; tworzenie MAC przez
   `delta_known` = szczątkowy „dealer MAC”.
4. **H1 clear f,F** — zastrzeżone, nieusunięte.
5. **Bez G-2** tor rounding nie wykrywa tamperu szumu — luka jawna
   (`t7_no_g2_noise_tamper_retained_gap`).

## Trzy zdania T7

1. **Wykazano:** maski W-bit i szum DGDG w ścieżce złota powstają bez
   centralnego dealera widzącego clear maskę/pełny szum; pomiar H=0.9544,
   var=0.249; regresja złota i pin F2 nietknięte; 365/365.
2. **Najbliższy brak:** pełne pairwise PRSS/CDI z osobnymi rng partii oraz
   H1/keygen bez clear f,F (NTRU trapdoor).
3. **NIE implikuje:** malicious-secure, UC, EUF-CMA, „próg FT gotowy”,
   równości dystrybucji DGDG ani braku dealera klucza.

*Suplement do MPS_T6_GAUSS_NOTES / Y13 / MPS_G2_NOTES — nie nadpisuje retained.*
