# Jawna pierwsza instancja: dokładny NODE2/NEXT_INTERFACE

Nowy INIT wyprowadza mocniejsze bounds tego SAMEGO S8=Node2Slice_C(p,b,k),
bez zmiany P_key lub historii NODE2. Po każdym e∈Fin2 wybrany source diagonal
ma256 words; SplitDeep8 daje128-word entry, Adj7, potem local LDL7.

```
exists c7 : Node2Level7Constants, ValidConstants7(c7) and
 forall p : Key4, P_key(p) -> forall b : Fin2,k : Fin3,e : Fin2,
  let S := Node2Slice_C(p,b,k);
  let v := select(e,[S.s0,S.d11]);
  let (t0,t1) := SplitDeep_C(v,8); let u1 := Adj_C(t1,7,0);
  Defined(SplitDeep_C;Adj_C;LDL_dim2_C(t0,u1,t0,7,0)) and
  forall f : Fin64,
   Node2Level7Certificate(c7,b,k,e,f,t0,u1,LDL_dim2_C(t0,u1,t0,7,0),
    ExactSplitAndSchur(select(e,ExactNode2Diagonals(p,b,k)),f)).
```

Key4/P_key jak ROOT; compiler/API model jak CLAIM. c7 jest restriction
jednego TOWER_CERTIFICATE do level7/path length1, z12 records. Error reference
pozostaje niezależną exact NODE2 diagonal/split funkcją.

Najmniejsze wspólne lower bounds outputs z dokładnego certyfikatu level7:
- branch0:272726097863/549755813888 (>49/100);
- branch1:15347590460695/549755813888 (>27).
Norm L<2. Kompletny record zawiera osobne d00/d11, real upper, imag bounds,
exact-reference i source-to-H errors oraz wszystkie domain checks.

Każda z12 entries ma64 physical frequencies:768 positions. To bezpośrednio
zamyka pierwszy obowiązek; pełny wynik zadania zawiera ponadto levels6–1
oraz actual terminating inner7 execution z INDUCTION§7–8. Level7 sam nie
jest utożsamiony z całym tower proof.
