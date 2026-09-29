# P02 — NEXT_INTERFACE (dla V02/P03 i dalej)

## Wolno konsumować natychmiast

- `B20.Word.load_store_le_refines` + `load_le_refines` — LE64 w pinned
  shake.c:56–90, legalna pamięć LP64; razem z WORD_HELPERS_001 (3 shift
  helpers end-to-end, konwers CExec P01).
- `B20.Fpr.*_execution` dla neg/double/half/pack/rint/floor — literalne
  wyniki BitVec z domenami (`packDomain`, `rintDomain`, `floorDomain`);
  specy w `B20/Fpr/Spec.lean`, wykonania w `RintExec.lean`/`FloorExec.lean`.
- `B20.Fpr.reachable_domain_interfaces` (`Domain.lean`) — `PrimObligation`,
  `ShiftCountDomain`, instancje ulsh/ursh/irsh + registry `parsedCallSites`.
- `sub_refines_via_add_obligation` — konsument dostarcza `AddCallObligation`,
  dostaje wykonanie `subProgram`.

## Jawne missing types (NIE są założeniami)

1. **fpr_add/mul/div/sqrt**: kontrakty arytmetyczne i oszacowania błędu
   rzeczywistego wyniku — dokładne typy obligation w `Domain.lean`
   (`AddCallObligation` itd.), bez instancji. To blokuje pełny kontrakt
   `add_sub_mul_div_sqrt_refines` z TASK.
2. **nearest-ties-even na rzeczywistych**: `rint` ma spec słowa; matematyczne
   twierdzenie o zaokrągleniu wymaga nowego pomostu słowo→rzeczywista liczba.
3. **Raw −0 floor**: jawny wyjątek (impl zwraca −1); kontrakt wymaga decyzji
   właściciela, czy to akceptowalne zachowanie, czy poprawka impl.
4. **C→machine refinement** (kompilator w TCB; P01 A2).
5. **Full C frontend**: parser skalarny obsługuje użyty fragment (shifts,
   casts, bitop, arith, calls, decls) — nie cały C.

## Schemat rozszerzenia

Nowy callee: dodaj `XCallObligation` w `Domain.lean` + instancję z bieżących
przesłanek (jak `rint_ulsh_domain`) + rejestr w `parsedCallSites`. Nowy program
skalarny: `ParsedPrograms.lean` (AST), `SourceBinding.lean` (slice/lex/parse),
`*Exec.lean` (spec+wykonanie, wzór z RintExec/FloorExec: dwufazowa
normalizacja, `obtain` dla ∃, finał `rfl` gdy defeq).
