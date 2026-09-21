# Eksport NODE3 do split_deep/inner

Jeden c3 w NODE3_CERTIFICATE obowiązuje dla wszystkich p∈P_key, b∈Fin2,
j∈Fin256. Eksportowane source arrays po LDL_dim3: d00=t0,d11,d22 (512 słów
każdy), L10/L20/L21, z physical real j/imag j+256. Constants: CLAIM/JSON.
Trzy diagonal branches na każdą z dwóch root branches mają dodatnie real
pivots (1/8 lub8 jako wspólne branch lower boundy), finite words i jawne imag.

Zachować także mocniejszy rekord dowodowy, nie tylko independent boxes:
- actual-input comparison H=Hermitian(Re(t0),u1,u2,u1), H≥lambda I;
- h<T, offdiagonal norms≤h i ich różnica≤2s;
- exact-H d,d2≥lambda, q2≤d+4s, exact-H L21<3;
- actual real d11 error≤64U*h, d22 error≤65536U*h;
- actual L21 error≤1024U*h/d;
- diagonal imag tau pochodzi z tego samego split, |tau|≤h; imaginary outputs
  są bliskie tau, a final mul_autoadj używa real d11. Nie zastąpić ich exact0.

## Pełny najbliższy następny typ — jeszcze niedowiedziony

Key4=cztery Int^1536 vectors; B=Fin2, K=Fin3, F=Fin128. Node2Constants to
jeden skończony rekord racjonalnych bounds, ewentualnie z ustalonymi polami
(b,k). ValidConstants2 wymaga positive lower bounds dzielników/pivotów,
finite upper bounds i nonnegative errors, niezależnie od konkretnego klucza.

```
exists c2 : Node2Constants,
 ValidConstants2(c2) and
 forall p : Key4, P_key(p) -> forall b : B, forall k : K,
  let N := Node3Slice_C(p,b);
  let v := select(k,[N.t0,N.d11,N.d22]);
  let (s0,s1) := SplitDeep_C(v,logn=9);
  let u1 := Adj_C(s1,logn=8,full=0);
  Defined(SplitDeep_C;Adj_C;LDL_dim2_C(s0,u1,s0,8,0)) and
  forall f : F,
   Node2Certificate(c2,b,k,f,s0,u1,LDL_dim2_C(s0,u1,s0,8,0),
    ExactSplitAndSchur(select(k,ExactNode3Diagonals(p,b)),f)).
```

Node2Certificate wymaga defined każdej source operation, positive real
denominators i pivots, boundu nowego L, oddzielnych real/imag errors oraz
błędów wobec niezależnej exact binary split/Schur w source layout/scaling.
ExactNode3Diagonals to e1/3,e2/e1,3abc/e2 z exact spectrum A lub q²/A.
Nie zakłada się positivity następnego node w poprzedniku ani nie wstawia
żądanego małego błędu jako premise. Nowa domain div również wymaga sprawdzenia.

Rzeczywisty ffLDL_inner(logn8) wykonuje własną wcześniejszą recursion przed
lokalnym dim2. Powyższy isolated slice oraz frame/input binding trzeba
odróżnić od total execution tej wcześniejszej recursion. NODE3_FRAME nie
nadaje jej statusu proved. Outputs NODE3 opisane są w momencie końca dim3;
późniejsze scratch reuse jest związane kolejnymi source moments.

Po lokalnym NODE2 pozostają wszystkie niższe levels/split_deep i pełny tree
certificate. Initial targets (FFT3(c), basis products, inverse(q)) są osobnym
wejściem. Dopiero ORDERED_REACH ma dowieść NumericCenter przed użyciem
ZERO_SCALAR366+2^-20, dla pełnych emitted/M0 histories, również pre-dss
i norm-rejected attempts. Fault0 nie ma residual-closeness. Sampler law,
H1R/FFO/R5T/M7 i globalne straty pozostają odrębnymi obowiązkami.

Nie zmieniono M0, nie dodano abortu lub małej automatycznej straty. Root
branch0 chronology jest zachowana: zaczyna się z wcześniej obliczonego
g00, przed root dim2 i branch1. Ten eksport nie uzasadnia jej przyszłym call.
