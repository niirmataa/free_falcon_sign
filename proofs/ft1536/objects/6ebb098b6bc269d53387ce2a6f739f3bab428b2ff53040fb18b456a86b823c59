# P01 — CLAIM (zakres dowodzony)

TASK_ID=B20_001_P01_FORMAL_FOUNDATIONS, ROADMAP_ID=F02–F09, para=V01.
Autor projektu: Niirmata. Raport z zajęć:2026-09-22/23.

## Twierdzenia (kernel Lean4.34.0 + Mathlib4@5ed2965)

1. **CExec** — `B20.Foundation.CExec : Program → State → Outcome → Prop`,
   relacyjna semantyka modelowanego fragmentu C z konstruktorami dla każdego
   używanego składnika (`skip`, `assign`, `storeU64`, `seq`, `ret`,
   `assumeFalse`, `unimplemented`) i dla każdego z czterech wyników
   nienormalnych (`stuck`, `abort`, `nonreturn`, `fault`) na granicach
   instrukcji; `evalStmt_sound`/`CExec_complete` (relacja ≥ evaluator) oraz
   `compile_refines`. `Outcome.stuck_ne_abort` i6 rozłączności wyników.
   Zakres: **semantyka C abstrakcyjna modelowanego fragmentu, NIE kod
   maszynowy** (SOURCE_MODEL_BINDING.md, ASSUMPTIONS.json).

2. **SourceBinding** — `SourceBinding : PinnedSource → Program → Prop` oraz
   `checker_sound` (akceptacja checkera ⇒ wiązanie tokeny/AST ↔ semantyka)
   dla dowolnego programu; dla realnego przypiętego fragmentu
   `return 0;` (tool.c:753, SHA `920ac2d8…377890`): `translateStmt`
   (poprawność translacji używanego fragmentu tekstu C, nie tylko checksum),
   `source17ReturnZero_translation`, `source17ReturnZero_binding`.
   Mutacje (`return 1;`, `goto 0;`) **zrywają** binding
   (`mutated_constant_rejected`, `mutated_operator_rejected` + wersje
   translacyjne). Osobno oznaczony synthetic/extended witness
   `syntheticShapeFragment` (shape `seq/assign/store/ret`, NIE źródło C).

3. **CertificateSound** — `certificate_sound`/`CertificateSound`:
   `checkSqrt2 = true ⇒ lower < √2 < upper` dla exact rational interval;
   `sqrt2Witness_sound` dla liczb z Sage. Testy negatywne **odrzucone**:
   fałszywa nierówność, odwrócony endpoint, brakujący denominator
   (`false_inequality_rejected`, `reversed_endpoint_rejected`,
   `missing_denominator_rejected`, `certificate_checker_discriminates`).
   Transport liczb/rozmiarów: `Transport.decodeNat_encodeNat`
   (decode∘encode = id dla każdego `Nat`) + wiązanie4 pól certyfikatu
   do literałów checkera (`*_transport`).

4. **ObservedKernel** — `ObservedKernel`, `conditionalHistory`,
   `totalVariation`, `directedChi2` na Mathlib `PMF`; lematy ogólne
   (`totalVariation_self_zero`, `directedChi2_self_zero`) ORAZ pełna
   instancja dla **pinned modelu** (deterministyczna egzekucja
   `source17ReturnZeroProgram` w `CExec`, obserwacja „returned 0"):
   `pinnedKernel`, `pinnedObserved`, `pinned_observed_initState`,
   `pinned_tv_self`, `pinned_chi2_self`, `pinned_conditionalHistory_*`.

5. **End-to-end** — `endToEnd_chain`: pinned tekst źródłowy → program →
   teza kernela (`source17ReturnZero_exec`) → zaakceptowany certyfikat.

## Czego NIE dowiedziono (jawne)

- kod maszynowy / poprawność translacji C→maszynowy (kompilator w TCB),
- translacja bogatych w operatory fragmentów source17 (np. `fpr_ursh`) —
  poza deklarowanym użytym fragmentem P01; obowiązek jawny dla dalszych
  zadań (NEXT_INTERFACE.md),
- pełny front-end C (gramatyka `translateStmt` = `return <stała>;`),
- real PRNG/SHAKE/ChaCha, KeyGen, Sign→Verify — poza zakresem P01.
