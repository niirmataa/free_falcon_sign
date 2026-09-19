# Eksport level8 i pełny następny typ

NODE2_CERTIFICATE eksportuje dla każdego(b,k) source d00=s0,d11,L po256 words,
real f/imag f+128. Boundy są w CLAIM/JSON. Do dalszego step zachować nie tylko
endpoints, lecz paired real/imag identity i actual-input Hermitian H:

- h0=(r_a+r_b)/2, norm offdiag²=((r_a-r_b)²+(tau_a-tau_b)²)/4;
- determinant=r_a*r_b-(tau_a-tau_b)²/4, nowy input imaginary refinement;
- actual H ma eigen lower1/16 albo4 po rozliczeniu source split;
- source L error do u1/h<2U, real pivot error<64U*h;
- imaginary pivot error do rzeczywistego Im(s0)<64U*h, bez raw-preservation
  założonego po half. Klasy half/exp0 należy zachować w dalszym wywołaniu.

## Nieudowodniony jeszcze następny lokalny typ

Key4/P_key jak ROOT; b∈Fin2,k∈Fin3,ell∈Fin2 wybiera nową diagonal branch,
g∈Fin64. C7 to JEDEN uniform rational rekord, ewentualnie z ustalonymi
polami(b,k,ell), positive lower bounds i finite nonnegative errors.

```
exists c7 : Node2Level7Constants, ValidConstants7(c7) and
 forall p : Key4, P_key(p) ->
 forall b : Fin2, forall k : Fin3, forall ell : Fin2,
  let S := Node2Slice_C(p,b,k);
  let v := select(ell,[S.s0,S.d11]);
  let (t0,t1) := SplitDeep_C(v,8);
  let u1 := Adj_C(t1,7,0);
  Defined(SplitDeep_C;Adj_C;LDL_dim2_C(t0,u1,t0,7,0)) and
  forall g : Fin64,
   Node2Level7Certificate(c7,b,k,ell,g,t0,u1,LDL_dim2_C(t0,u1,t0,7,0),
    ExactSplitAndSchur(select(ell,ExactNode2Diagonals(p,b,k)),g)).
```

Node2Level7Certificate oznacza source instruction domains/finite words,
positive real divisors/pivots, bound L, osobne imaginary bounds/errors,
exact reference errors oraz physical layout/frame. Nie przyjmuje desired
pivot/error w poprzedniku. ExactNode2Diagonals to exact binary h,D reference
obecnego level8, nie source projected words.

Aktualny parametric step jest w ANALYTIC_PROOF§4–6 i ma rzeczywistą instancję
na wszystkich sześciu grupach. Jego kolejne zastosowanie wymaga nowych
input/imag/margin/domain facts. W szczególności current d11 upper2^36 nie
jest automatycznie w obecnej div domain[1/16,2^35]. Nie pomijać half boundary.

Chronologia inner7: pierwsza niższa recursion następuje przed jego local dim2.
Isolated slice/frame nie dowodzi jej totalności. Dla ell0 dostępny wcześniej
s0 nie może być uzasadniony przyszłym d11; ell1 wymaga stosownego source
prefixu i momentu scratch read. NODE2_FRAME zachowuje te rozróżnienia.

Po tym następnym lokalnym poziomie pozostają wszystkie dalsze levels i ich
kompozycja w full internal tree. INITIAL_TARGETS jest osobne. ORDERED_REACH
ma wykazać NumericCenter przed konsumpcją ZERO_SCALAR366+2^-20, również
pre-dss/norm-rejected attempts; fault0 nie ma closeness. Sampler-law/H1R/
FFO/R5T/M7 i straty redukcji nie wynikają z obecnego lokalnego certyfikatu.
