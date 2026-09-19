# H3_NODE2 — pełna teza pierwszego poziomu binarnego

Autor projektu: Niirmata. Status: **H3_NODE2_PROVED_FOR_PINNED_MODEL**.
Poziom jest dokładnie SplitDeep9→Adj8→LDL_dim2(8,full0), nie całe remaining tree.
P_key zachowuje definicję ROOT; źródła C/profil/M0 są bez zmian.

```
exists c2 : Node2Constants, ValidConstants2(c2) and
 forall p : Key4, P_key(p) -> forall b : Fin2, forall k : Fin3,
  let N := Node3Slice_C(p,b);
  let v := select(k,[N.t0,N.d11,N.d22]);
  let (s0,s1) := SplitDeep_C(v,9);
  let u1 := Adj_C(s1,8,0);
  Defined(SplitDeep_C;Adj_C;LDL_dim2_C(s0,u1,s0,8,0)) and
  forall f : Fin128,
   Node2Certificate(c2,b,k,f,s0,u1,LDL_dim2_C(s0,u1,s0,8,0),
    ExactSplitAndSchur(select(k,ExactNode3Diagonals(p,b)),f)).
```

Key4 to cztery Int^1536 vectors. P_key: ternary f/g, caps2047 F/G, exact NTRU,
actual Gate00_C; Emitted_C+same STATIC decode→P_key w odebranym source-analytic
zakresie. API/model premises: legal buffers/lifetimes/disjoint outputs i
scratch, repeated const alias s0=g00=g11, fixed GCC14.2/C99/LP64 portable FPEMU.
Nie ma nierozliczonej numerical premise dotyczącej nowego marginu/pivota.

## Jeden c2 — stałe sześciu grup

| Bound, dla każdego k∈Fin3 | Branch0 | Branch1 |
|---|---|---|
| Re(s0) lower / upper | 1/16 / 2^26 | 4 / 2^35 |
| Re(d11_C) lower / upper | **1/32 / 2^27** | **2 / 2^36** |
| Norma L_C | <2 | <2 |
| abs Im(s0),abs Im(d11_C) | ≤1/8192 | ≤9/8 |
| Source split norm error | <1/16384 | <1/32 |
| Source real pivot error wobec actual-input H | <1/65536 | <1/128 |

Wartości real przekraczają dodatnie lower bounds, upper są ścisłe.
Denominator s0 i positive computed pivot są normal. Half może utworzyć
subnormal w innych split components; L/d11 outputs są normal/zero.

| b,k | Błąd normy L do niezależnego reference | Complex d11 error |
|---|---|---|
|0,0|<1/16|<1/128|
|0,1|<1/2|<1/16|
|0,2|<3|<1|
|1,0|<3|<2^25|
|1,1|<3|<2^28|
|1,2|<3|<2^32|

Reference używa REALNYCH exact Node3 diagonals, potem prawdziwego binary
split: (a+b)/2, L=x(a-b)/(a+b), D=2ab/(a+b). Source zachowuje actual half,
conjugation, per-component div i subtractive muladj/neg/add.

Nowe upstream theorem: root imaginary<1; NODE3 imaginary dla b0:
(0,1/262144,1/262144), dla b1:(17/16,545/512,545/512). Z niego, z jawnym
(tau_a-tau_b)², wynika paired margin. Stare certyfikaty nie są nadpisane.

Half theorem: wszystkie finite words, output finite i value error≤2^-1023
wobec x/2, z oddzielną raw class analysis. Oba zera/exp0 mapują do+0;
exponent1 może dawać subnormal, e>=2 daje exact half. Nie zakładamy IEEE
rounding lub sub(x,+0) raw-preservation po half.

Full_node2_theorem_kernelized=false: half bit/value proof, paired identity,
c2 validity i frame są kernelowe; upstream refinement i full complex/source
error composition analityczne z exact QQ/RBF certificates. C/compiler
refinement nie jest w pełni kernelizowane. Global H3, remaining internal
tree, targets, Reach i sampler law pozostają odrębne.
