# GAME_BINDING — notatki toru matematycznego T12.1

Źródło: zamrożony W wykonawcy GAME_BINDING_RUN_001 (przeniesione wg zasady
dyskrecji ścieżek — pełna historia w oryginalnym W). Kolejne kroki tego
toru powstają już tutaj, małymi commitami.

## Zakres toru

Łańcuch delta dla kluczy prawych: `FinalTails` (hchange/htail) →
`ConvolutionCert`/`ConvStruct` (struktura splotu + boundy Chernoffa +
`mgf1_eq`) → `FinalDelta` (`all_keys_delta`, forma finalna warunkowa od
`certLo`/`certHi` i `flat`/`reject`).

## Stan (2026-09-30)

- 13 modułów Lean: build 0/0 (czyste logi, 0 sorry/admit/native_decide),
  audyty `#print axioms` ⊆ [propext, Classical.choice, Quot.sound].
- L0 (`sage/check_conv_window.sage`, L0_PASS): reprodukcja pinów
  `arb_radial_result.json` bajt w bajt; geometria sektora — `Qc−Q = 18433·δ`,
  wyrodnienie okna lo ⟺ `δ = 1` (≡ straż silnika `lhi ≥ llo`), hiWin
  zawsze otwarte; momenty θ (G zawiera granicę `2π/(α√3)`); margines
  `certLo` = dokładnie `aliasCap`, wymagane dopuszczenie zawijania ≤ 7.83e-10.
- Kluczowe konstrukcje: `windowMassWin_rest` (okno = splot 1535 bloków),
  `fiber_moment_eq` (Dirac w slocie 0 ⇒ moment = `mgf₁^1535`),
  `sum_imp_exp_bound` + `windowMassWin_half_le` (Chernoff z implikacją),
  `mgf1_eq` (mgf₁ = `blockSum (c0−ℓ)/blockSum c0`).

## Lekcje (nie powtarzać błędów)

- Rozbiory rodzin: gotowe `Fin.prod_univ_succ`/`Fin.sum_univ_succ`
  (grep w `Mathlib/Algebra/BigOperators/Fin` PRZED pisaniem bijekcji!).
- Formy kastów **w stwierdzeniach**: `((∑ … : ℤ) : ℝ)` per-kawałek vs
  `↑(Σ+Σ−E)` to różne termy (klasa `Int.cast_sub`).
- `show … from by simp` zamiast kaskad `unfold`+`simp`; pełne `open`
  (restrykcyjna lista z jednym złym identyfikatorem wywala całą komendę);
  nie dokładać taktyk „na wszelki wypadek"; licznik błędów w logach
  łapie format `error(typ):`.

## Otwarte (kontrakty z torami)

1. `certLo`/`certHi` — droga (b): splot strukturalny kernel-side;
   REUSE z toru T5: `T5ScalarMass.uniform_shifted_mass_3072`,
   `TriangularGaussian`, `ShiftedGaussian`, `A2Theta`.
2. `flat`/`reject` — teza toru T5 (`TASK_T5_FLAT_REJECT`); po jej
   zamknięciu `all_keys_delta_of_conv_cert` traci przesłanki modelowe.
3. Styk z source3: `hbLo`/`hbHi` (źródłowa strona silnika) oraz
   `E_leaf < 33` + `source_binding` → `LeafErrorContract` (REFINE).

## Zasady

- **Recenzja przed commitem** (decyzja właściciela 2026-09-30): każdy
  krok przed commitem przechodzi przegląd subagenta (pisownia, literówki,
  spójność nazw i nawiasów); poprawki wdrażane przed zapisem.
- **Rytm 2026-09-30 (właściciel, wersja późniejsza)**: partia 3 commitów,
  potem przegląd subagenta CAŁEJ partii i push (recenzja przed pushem, nie
  przed każdym commitem — oszczędność tokenów).
- **Język angielski od 2026-09-30**: komentarze/docstringi i treści commitów
  po angielsku, wyłącznie utrwalony język kryptograficzny (Cramér tilt,
  Chernoff bound, MGF, lattice, tail bound, sector, window sandwich).
  Polskie teksty sprzed tej daty zostają jako historia.

Zero sorry/admit/native_decide; logi 0/0 (licznik `error(\(|:)`);
kompilacja seryjna strzeżona (`tools/original/run_lean_guarded.sh`);
Sage przez `sage <plik>.sage`; asserty w każdym patchu python.

## Walidacja nowego workspace (2026-09-30)

- Pełny build przeszedł: closure 27 modułów `Run2.*` (przystosowany
  `build_run2_closure.py`) + 13/13 modułów toru czysto (0/0).
- Lekcja: `FT1536.*` to zależności archiwalne (67 plików = referencje do
  stages, świadomie niekopiowane) — ich **oleany** przywraca się do
  ignorowanego `.build/check_lib/` z hash-zgodnej kopii buildu (28/28);
  same źródła zostają w stages. Build-cache, nie treść.
- REUSE pod certHi potwierdzony: `ShiftedGaussian.complex_poisson_shift`/
  `shiftedMass` (zwrot liniowy = shift środka), `A2Theta.powerWeight`/
  `majorant` (`degree = block x y`), `TriangularGaussian.Tower`,
  `T5ScalarMass.row_exponential_bound`.
