# REPORT — FT1536_MUTATION_WRONG_H_RUN_001

Autor projektu: Niirmata. Status: **PARTIAL_PROOF**.
Zakres: kernelowy kontrprzykład mutacji M_wrong_h_relation na małej wiernej
instancji; instancja 1536 dokładnie zweryfikowana poza kernelem.

## Wejścia (mrożone piny)
- `stages/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001/scripts/py_crosscheck/exact_ring_checks.py`
  `59c52dcd217c0485ac077a6729fecf1aad6d6d87d3655510491fa1a3d33c2a22`
  (blok mutacji, seedy Random(7)/Random(8)/Random(20260922)).
- `stages/.../checks/sage/exact_ring_checks.sage`
  `f9d4b9ead001b15f39285c335e5d43737e551c3013605cf20c082266aa0eed7c`
  (niezależna implementacja Sage, LCG(7)).
- `stages/.../checks/exact_ring_checks.json`
  `0fa61d6f95dee8525980d0f15e0813d8760a0c546e8d7a5849fae03fbef7e52c`
  (M_wrong_h_relation: true, pozostałe mutacje wykryte, NOOP czysty).

## Udowodnione tezy
1. Replikacja 1536 (czyste inty Pythona + cross-check w `GF(18433)[x]/Phi`):
   `A_holds=False B_holds=False M_detected=True`; sformułowanie indeksowe
   pointwise równe mrożonemu (`idx_mul=mul`, `idx_fmulq=fmulq`).
   Pierwsza różnica pod indeksem 0 (16599 vs 0, wszystkie 1536 pozycji różne).
2. Kernel Lean na wiernej instancji N=6/q=17/Phi=X^6-X^3+1 (ten sam kod,
   seedy 1000/1001): `keyrel_wrong_h_ne` i `mutation_wrong_h_detected`
   (`¬(relacja ∧ congruent)`), obie nogi liczone w kernelu przez `decide`.

## Weryfikacja (exit 0)
- `sage gen_mutation_wrong_h.sage`: GEN_MUTATION_PASS.
- `lean MutationWrongHSmall.lean`: czysty log, zero `sorry/admit/native_decide`,
  aksjomaty tylko `[propext]`.
- `sage check_first_diff.sage`: FIRST_DIFF_PASS.

## Jawnie otwarte / ograniczenia
- Pełny-1536 `decide` przekracza `maxRecDepth 1000000` w Lean 4.34 core
  (zmierzono na sformułowaniu listowym i indeksowym, 600 s bez wyniku);
  instancja 1536 pozostaje dokładnie zweryfikowana, nie kernelowo.
  `native_decide` zakazane protokołem.
- Kontrola czułości na kluczach syntetycznych, NIE Emitted membership.
