# FT1536_MUTATION_WRONG_H_2026-09-24 — M_wrong_h_relation do kernela

Roboczy W (nie frozen, nie do importu bez handoff). Archiwum `stages/` nietknięte.

## Mrożone wejścia (SHA-256)
- `stages/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001/scripts/py_crosscheck/exact_ring_checks.py`:
  `59c52dcd217c0485ac077a6729fecf1aad6d6d87d3655510491fa1a3d33c2a22`
- `stages/.../checks/sage/exact_ring_checks.sage`:
  `f9d4b9ead001b15f39285c335e5d43737e551c3013605cf20c082266aa0eed7c`
- `stages/.../checks/exact_ring_checks.json`:
  `0fa61d6f95dee8525980d0f15e0813d8760a0c546e8d7a5849fae03fbef7e52c`
  (M_wrong_h_relation: true, M_wrong_sign_in_v2_row: true,
  M_wrong_target_sign: true, M_wrong_basis_swap_rows_det: true, NOOP clean)

## Pliki W i wyniki
- `gen_mutation_wrong_h.sage` — wierna replikacja bloku mutacji z frozen `.py`
  (seedy Random(7)/Random(8)/Random(20260922), klucz degenerate, czyste inty
  Pythona) + asercje C1/C5/Poprawne-h/M_wykryte + niezależny cross-check
  w ilorazowym pierścieniu Sage `GF(18433)[x]/Phi` + instancja mała (N=6,q=17,
  seedy 1000/1001, ten sam kod) + emisja pliku Lean. `sage`: exit 0,
  `A_holds=False B_holds=False M_detected=True`.
- `MutationWrongHSmall.lean` — kernelowy kontrprzykład na instancji N=6/q=17
  o tym samym kształcie kodu: `keyrel_wrong_h_ne`, `mutation_wrong_h_detected`
  (`¬(relacja ∧ congruent)`), obie nogi liczone w kernelu przez `decide`.
  `lean`: exit 0, zero warningów, zero tokenów zakazanych, aksjomaty tylko
  `[propext]`.
- `mutation_vectors.json` — przypięte wektory 1536 (rekord oracle, nie dowód).
- `mutation_vectors_small.json` — przypięte wektory N=6 (wejście kernela).
- `check_first_diff.sage` — diagnostyka: pierwsza różnica pod indeksem 0.

## Uczciwy podział: kernel vs oracle
- Kernel (Lean) dowodzi negację detekcji na małej wiernej instancji.
- Instancja 1536 jest zweryfikowana dokładnie (inty Pythona + Sage-native),
  ale NIE w kernelu Lean: pełny `decide` przekracza `maxRecDepth 1000000`
  w Lean 4.34 core — zmierzono na sformułowaniu spine i indeksowym
  (short-circuit od indeksu 0), 600 s bez wyniku. `native_decide` jest
  zakazane protokołem, więc pełne-1536 `decide` w czystym core jest
  niewykonalne; złożoność leży w 1536-szerokich fałdach, nie w treści tezy.

## Replay
```
sage proofs/ft1536/work/FT1536_MUTATION_WRONG_H_2026-09-24/gen_mutation_wrong_h.sage
lean proofs/ft1536/work/FT1536_MUTATION_WRONG_H_2026-09-24/MutationWrongHSmall.lean
sage proofs/ft1536/work/FT1536_MUTATION_WRONG_H_2026-09-24/check_first_diff.sage
```
HOME/TMPDIR/DOT_SAGE pod W (`sage-home/`, `tmp/`).

## Zakres
Kontrola czułości na kluczach syntetycznych, NIE Emitted membership
(zakres frozen). Udowodniona instancja: N=6; przeniesienie na 1536 wymaga
albo kernela o większych limitach, albo zmiany protokołu (poza tym W).
