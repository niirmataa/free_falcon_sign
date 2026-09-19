# Źródła i proof layers NODE2

Candidate manifest2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a;
BASEafa52d89be2f21208ac3135e74a1a60fc66d52c4. Dokładne source copies są
read-only i niezmienione. Span/hash matrix: artifacts/source_binding.json,
inputs/slices. Fixed C99/GCC14.2/LP64, aktywny portable FPEMU, Makefile flags.

half_model.py jest dosłowną unsigned wrap/subtract/mask transkrypcją headera.
Half.halfC redukuje udowodnioną0/1 maskę do równoważnego wyboru; half_bits,
half_fields,half_value,half_error_units,finite_half są kernelowe. Definicja
nie jest RHS desired error theorem. Interpretacja finite word to pełne
valueNum/2^1074, także zeros/subnormals, bez IEEE backend assumption.

node2_model.py wykonuje source add/half, sub/complex-mul/half, potem Adj,
per-component div, muladj/neg/add. Normal/zero/subnormal bits pozostają
widoczne. Guard w modelu jest preflight checkerem denominator domain dla
kontroli, nie nowym guardem w C lub P_key. Na required inputs jego warunki
są wnioskami proof. Ideal_half option służy wyłącznie kontroli mutacji.

Oryginalne backend.py/fp_literal.py/node_model.py są byte-identical helperami
przypiętego NODE3. Źródłowe NODE3 parent words w pipeline są także dumpowane
przez C i porównywane z modelem, zanim będą użyte jako oracle inputs.
Nowe refinement i binary step nie przyjmują starych independent boxes jako
pełnego required domain; source-to-H i computed Gram powiązania rozlicza
UPSTREAM_REFINEMENT.

Kernel dodatkowo sprawdza paired identity z (tau_a-tau_b)², fixed rational
c2 validity i generic store frame. Rationals są exact numerator/positive
denominator pairs, porównania integer cross-products; QQ certificate wiąże
wszystkie pola. Pełne nowe types/implicits/terms i axioms są w final audit.
Kernel validity rekordu nie jest przedstawiana jako cały source theorem.

Pełny source numerical root-imag refinement, paired eigenvalue/Schur error
composition i C/compiler translation są ANALITYCZNE z exact QQ/RBF
certificates. API/buffer/lifetime model jest w NODE2_FRAME. Isolated local
slice i defined-prefix frame nie są totality theorem wcześniejszej recursion.

checks/binary.c używa oryginalnych FFT/split/LDL i publicznych synthetic
arrays. 2*3*128 positions,98 half boundary words,128 post-half-subnormal
positions, root-imaginary controls i trzy frame examples są normal/sanitizer
checks, nie dowodem emitted membership. Nie wywołuje private loadera,
KeyGen lub Sign. Preflight zatrzymuje zero divisor przed C call.

Box counterexample9±34i ma legalny pierwszy divisor9, więc samo obliczenie
ujemnego końcowego pivota nie jest niedozwolonym dzieleniem. Nie wykonuje
dalszej recursion. Jego status dotyczy wyłącznie coarse box, nie P_key/H3.
Mutacje/root-phase/Adj/complex-div/harmonic/half/rounding są sprawdzane na
wartościach; no-op przechodzi. Źródła nie są patchowane dla PASS.

Oryginalne licencje Falcon Project/Thomas Pornin i atrybucje pozostały
w source; autor projektu Niirmata. Diffs/piny nowych adapterów są jawne.
