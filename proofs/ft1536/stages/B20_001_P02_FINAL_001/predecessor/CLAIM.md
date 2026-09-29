# P02 — CLAIM

TASK_ID=B20_001_P02_WORD_FPEMU_REFINEMENT, ROADMAP_ID=F03–F06, para V02.
W=proofs/ft1536/work/B20_001/P02.

## Co twierdzimy (kernel-checked, Lean4.34.0 + Mathlib4@5ed2965)

1. **B20.Word.load_store_le_refines / load_le_refines** — dla legalnej pamięci
   (LP64, 8-bajtowe obiekty w granicach) wykonanie przypiętych dec64le/enc64le
   (shake.c:56–90) w modelu CExec daje little-endian BitVec64, round-trip
   load/store, rama poza 8 bajtami; obie strony wykonanie iff.
2. **Wykonania skalarnych prymitywów FPEMU** — neg, double, half, pack
   (packDomain), rint (rintDomain: mantysa <= 1072), floor (floorDomain:
   mantysa <= 1072 i x != raw −0) — dla 7 funkcji sparsowanych z przypiętego
   fpr-emulated.h, wynik = jawny literal-BitVec spec. Dodatkowo sub
   warunkowo na wartości wywołania fpr_add (interfejs MS2).
3. **B20.Fpr.reachable_domain_interfaces** — nazwane typy obligation dla
   4 parsed call-sites; udowodnione instancje dla 3 shift callee
   (ulsh/ursh/irsh, warunek count<64), fpr_add/mul/div/sqrt jako jawne
   unresolved types (bez instancji).
4. **Źródłowe wiązanie** — slice/lex/parse certyfikaty dla shake.c (dec/enc)
   i 7 funkcji skalarnych; parser niemutualny, kernel-checked.

## Czego NIE twierdzimy

- Nie ma kontraktu nearest-ties-even na liczbach rzeczywistych — wynik rint
  to słowo BitVec, nie zaokrąglenie rzeczywiste (jawny missing type).
- Nie ma kontraktu błędu/zaokrąglenia add/mul/div/sqrt — to unresolved types.
- Raw −0: implementacja floor zwraca −1; jawny wyjątek poza kontraktem.
- Semantyka to model C (CExec), nie kod maszynowy; kompilator w TCB.
- Wynik NIE jest ogłoszeniem bezpieczeństwa schematu ani compiler verification.

## Werdykt

PARTIAL_PROOF dla całej rodziny TASK; PROVED w zadeklarowanych zawężonych
zakresach powyżej (pełne typy w FORMAL_EXPORTS.json, granice w NEXT_INTERFACE.md).
owner_accepted=false; independent_review=false.
