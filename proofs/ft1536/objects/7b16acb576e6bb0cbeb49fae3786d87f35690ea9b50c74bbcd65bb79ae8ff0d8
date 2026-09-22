# MODEL_BOUNDARIES.md — granice modeli, klas dowodowych i mapy zależności

FT_FAMILY_SCALING_CORRECTIONS_RUN_003 (S01), 2026-09-22. Autor projektu
Niirmata; atrybucja Falcon Project / Thomas Pornin zachowana.

## 1. Czego NIE dowodzi ten pakiet

- **Kompilacja lokalnej arytmetyki nie dowodzi C allocatora.** Fakt, że
  moduły Lean 4 kompilują się czysto i że lokalne rekurencje/limity są
  sprawdzone w kernelu, nie implikuje poprawności alokacji pamięci,
  bezpieczeństwa ani zgodności implementacji C (`Extra/c`). Wiązanie
  kernel↔C ma charakter analityczny/źródłowy (SOURCE_FACT + ANALYTIC),
  nigdy automatyczny.
- Kernel ≠ proof bezpieczeństwa. `KERNEL` znaczy: zdanie sprawdzone przez
  Lean 4.34 bez sorry/admit/native_decide/Lean.ofReduceBool i bez aksjomatu
  celu (audyt `results/lean_AxiomAudit.log`: wyłącznie propext/Quot.sound).
- `FLOAT_DIAGNOSTIC` nie jest dowodem ani arytmetyką dokładną (binary64/MPFR/
  balls diagnostyczne). `RIGOROUS_INTERVAL` obejmuje tylko dokładnie
  zadeklarowany model i obudowę (patrz `results/chi_tail.json`).
- Zgodność hashy ≠ poprawność matematyczna; testy ≠ dowód; diagnostyka
  estymatora ≠ redukcja bezpieczeństwa ≠ bezpieczeństwo źródeł.
- Żadna liczba tego pakietu nie jest poziomem bezpieczeństwa, atakiem ani
  prawem rzeczywistego Sign. Ogon χ² (C19) to statystyka odrzuceń **idealnego
  modelu ciągłego przed castami/retry**; próg `2^−28` jest **PROPOSED**
  (model-level target), nie zatwierdzonym celem projektu.

## 2. Granice modeli

| model | obejmuje | NIE obejmuje |
|---|---|---|
| MODEL_CHI2_IDEAL (C19) | iid N(0,σ²) w ortonormalnych współrzędnych Q_A2, σ=768, przed castami/retry | dyskretny sampler, rint→int16, retry normy, prawo Sign, ataki, PRNG |
| gra M0 / P1–P3 (`ATTACK_PROBLEMS.md`) | typy Forge/Extract/Solve_rel, budżety (Q_s,Q_H,t,w,L), cele z tabeli ROM, union bound po nazwach rozłącznych | symulacja ROM/Sign, freshness, zasoby M7 (OPEN), odwrotny most `Enc` (OPEN) |
| P1a/P1b (C15, R3) | P1a: krótka para w Λ_h z progiem per-populacja; P1b: osobny solve NTRU na (F,G) | próg dla populacji EMITTED (OPEN), koszty solve (NOT_RUN) |
| layout (C6) | rekurencje strukturalnie niezmienionych źródeł | istnienie implementacji FT768/FT3072, czasy |
| FFT3 (C11/C12) | PROPOSED_BOUND z czynnikiem ‖a‖₁ + 12 przypadków MPFR (nie-przeczenie) | stała c, domeny operacji, budżet ε_tw, równoważność bitowa port↔FPEMU, perturbacja twiddles (osobny dowód) |
| kampania estymatora (C21) | guarded interfejs + testy mock (brak wywołań, detekcja SIS→P2) | jakikolwiek pomiar kosztów (NOT_RUN; estymator nie był uruchamiany) |

## 3. Mapa zależności (konsumpcja odebranych wyników)

Możliwe do konsumpcji (REUSED z pinami, patrz `REUSED_RESULTS.md`):

- **M0** (kontrakt gry), **L_V** (bajty→świadczenie, jednostronnie),
  **JOINT / H6P** (odebrane certyfikaty referencyjne),
  **T01 REVIEWED** — **wyłącznie** w zakresie post-H2P cap16 `G_retry_IID`
  (model IID_BUFFER), oraz RAW_ASSEMBLY (layout N=1536) i poboczne
  SCALAR_* w ich oryginalnych zakresach.

Nadal **OPEN** (nie konsumować jako zamknięte):

- realny PRNG i most do SHAKE/ChaCha; H2P (pełna kompozycja);
- integer recovery (T03 — odrębny tor); Sign→Verify dla całego real Sign;
- całe real Sign (prawo po castach/retry); bezpieczeństwo i CT;
- SIG-001 (dobór σ=768, 1.075); prawo samplera i straty Rényiego; η_pre;
- FT768/FT3072: implementacja, certyfikaty domen numerycznych, progi.

## 4. Konwencje (zachowane)

- Poprawna konwencja objętości: `det G = (3/4)^N` (Gram Q_A2 na (z1,z2)),
  `covol_Q = (3/4)^(N/2) q^N`, `covol_Q^(1/2N) = (3/4)^(1/4) sqrt(q)`;
  `det(Lambda_h) = q^N` w metryce współczynnikowej (C7).
- Konwencja A2: `Q_A2` dosłownie jak w `falcon_is_short` (pary offsetu N/2).
- Tryb rachunku: zasada SageMath (kopia `supplements/`), autorytatywnie
  `.sage` przez `sage scripts/lemma_*.sage`; Lean = kernel formalizacji;
  `.py` = organizacja; historyczne piny zachowują format.
