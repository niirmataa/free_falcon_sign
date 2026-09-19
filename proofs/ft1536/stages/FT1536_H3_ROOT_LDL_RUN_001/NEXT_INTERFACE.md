# Eksport korzenia i najbliższy następny lemat

Wejście następnego etapu to rekord S=RootSlice_C(p), z p∈P_key,
RootCertificate i źródłowym layoutem wszystkich768 frequencies. Eksport:

1. Pierwsza branch: d00_C=g00_C, real∈[1/2,2^23), imag raw+0,
   error względem exact A<1/1024.
2. Root multiplier L_C: norm<2^25, error względem C/A<2^14, finite
   components normal/zero; source sign/conjugation B B*.
3. Druga branch: d11_C=D_C, real∈(32,2^31), |imag|<32,
   complex error względem exact q²/A<2^22, finite.
4. Zachowane korelacje: hat matrix determinant, a/c/j identities,
   |D_C−|det(Bhat)|²/a|≤256*2^-48*j. Ta lokalna bound jest silniejsza
   dla positivity niż globalny absolute error2^22; jej premises są
   wyprowadzone, a nie niezależnie przyjęte boxy.

## Następny pełny typ — jeszcze niedowiedziony

Poniższy jest operacyjnym matematycznym typem, nie deklaracją zakończonego
Lean theorem. Key4=cztery Int^1536 vectors; Branch=Fin2, Freq3=Fin256.
Node3Constants to skończony rekord racjonalnych uniform lower/upper bounds
na real divisors/pivots, component/modulus bounds multipliers, imaginary
errors i błędy wszystkich operations. ValidConstants wymaga STRICTLY
positive lower bounds i skończonych nonnegative error budgets.

```
exists c3 : Node3Constants,
 ValidConstants(c3) and
 forall p : Key4, P_key(p) ->
 forall b : Branch,
   let S := RootSlice_C(p);
   let v := if b=0 then S.g00 else S.d11;
   let (t0,t1,t2) := SplitTop_C(v,logn=10);
   let u1 := Adj_C(t1,logn=9,full=0);
   let u2 := Adj_C(t2,logn=9,full=0);
   Defined(SplitTop_C;Adj_C;LDL_dim3_C(t0,u1,t0,u2,u1,t0,9,0)) and
   forall j : Freq3,
     Node3Certificate(c3,j,t0,u1,u2,
       LDL_dim3_C(t0,u1,t0,u2,u1,t0,9,0),
       ExactSplitAndSchur(if b=0 then A(p) else q^2/A(p),j)).
```

Node3Certificate oznacza: finite wszystkich source words, defined każdy
real-slot div, real denominators/pivots w [lower,upper], boundy L10/L20/L21,
errors względem podanej exact3x3 Schur decomposition oraz osobne errors imag.
Nie przyjmuje tych properties w poprzedniku. Outer existential wymaga JEDNEGO
explicit rational record dla wszystkich p,b,j, a nie per-key empirical boundu.

Potem potrzebne są split_deep, lower-node recursion oraz physical tree
certificate. Imag D_C nie może zostać po cichu odrzucone jako exact0;
div_autoadj czyta real denominator, a pozostałe operations mogą przenosić imag.
Przy przenoszeniu nowych primitive lemmas trzeba dowieść ich operand caps
i denominator domain; obecne [1/2,2^23] nie jest automatycznie domeną każdego
późniejszego node. Historyczne H4 leaf positivity nie certyfikuje16896
internal words; normalize zmienia wyłącznie1536 terminal widths.

Chronologia: first branch0 jest badana przed rzeczywistym root dim2. Jej
wejściowy g00 i jego certyfikat pochodzą z FFT/Gram, nie z późniejszego
wykonania drugiej branch. Root frame umożliwia późniejsze użycie tego samego
RootSlice. Nie ogłoszono defined execution całej earlier recursion.

## Osobne obowiązki po drzewie

ROOT_LDL→INTERNAL_LDL, niezależnie INITIAL_TARGETS (source FFT3(c), products
z B01/B11 i actual inverse_of(q)), potem ORDERED_REACH dla emitted-KeyGen/M0.
Ten ostatni musi objąć pre-dss i później norm-rejected attempts, zachować
ordered buffers/fault propagation i dowieść NumericCenter PRZED użyciem
ZERO_SCALAR residual366+2^-20. Fault0 nie spełnia closeness lemma.
Sampler-law/H1R/FFO/R5T/M7 mają własne distribution/acceptance/error obowiązki.
Nie zmieniono M0, nie dodano abortu lub automatycznej małej globalnej straty.
