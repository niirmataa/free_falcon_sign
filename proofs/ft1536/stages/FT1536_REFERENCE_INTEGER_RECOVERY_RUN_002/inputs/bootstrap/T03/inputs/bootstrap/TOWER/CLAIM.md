# H3_BINARY_TOWER — pełne warstwy A i B

Autor projektu: Niirmata. Status: **H3_BINARY_TOWER_PROVED_FOR_PINNED_MODEL**.
Zakres mixed analytical/kernel, z fixed GCC14.2/C99/LP64 portable FPEMU,
legalnymi buffers/lifetimes/disjointness i niezmienionym P_key/M0.

## A — wszystkie isolated levels/paths

S8 to poprzedni Node2Slice_C(p,b,k). Dla l∈1..7 i path w długości8−l:
S_l powstaje literalnym BinaryStep_C z wybranego d00/d11 poprzednika.
Arrays mają2^l words, real j/imag j+2^(l−1). R_l jest niezależnym exact
reference z NODE2, przenoszonym po tych samych path choices.

```
exists C : BinaryTowerConstants, ValidTowerConstants(C) and
 forall p : Key4, P_key(p) -> forall b : Fin2,k : Fin3,
 forall l : {1,...,7}, forall w : BitPath(length=8-l),
  Defined(S_l(p,b,k,w)) and
  forall j : Fin(2^(l-1)),
   BinaryNodeCertificate(C,l,b,k,w,j,S_l(p,b,k,w),R_l(p,b,k,w)).
```

Rekord C zawiera1524 node records plus6 refined S8 bases i explicit INIT.
Każdy STEP sprawdzono exact QQ z outward rounding na stałej siatce2^-40.
Mocny transfer d11 lower=m−I²/m−4delta−eD zachowuje imaginary difference;
nie iteruje mechanicznie zgrubnych c2 endpoints.

Wspólne granice dla WSZYSTKICH levels7–1, source d00/d11:

| Wielkość | Branch0 | Branch1 |
|---|---|---|
| Real lower | >49/100 | >27 |
| Real upper | <8388610 | <2147483650 |
| abs imaginary | <1/32768 | <9/8 |
| Complex error do independent reference | <32768 | <4294967296 |
| Norm L | <2 | <2 |
| Norm L-reference | <3 | <3 |

Każdy real denominator/pivot normal positive, wszystkie words finite.
d00 imaginary może być subnormal po half; d11/L normal lub zero. Każde
primitive use ma wcześniej udowodnione cap/domain; div[1/16,2^35] jest
wykazane od nowego INIT, nie przeniesione z samego old c2 upper2^36.

## B — original inner7 totality

```
forall p : Key4, P_key(p) -> forall b : Fin2,k : Fin3,e : Fin2,
 let v := select(e,[S8(p,b,k).d00,S8(p,b,k).d11]);
 let (a,t) := SplitDeep_C(v,8); let b1 := Adj_C(t,7,0);
 forall memory, LegalInner7Buffers(memory,a,b1,a) ->
 OrdinaryDefinedTerminatingReturn(ffLDL_inner_fft3(tree,a,b1,a,7,tmp)) and
 WrittenTreeMatchesTowerA(p,b,k,e) and InputsPreserved and
 TreeExtent=1024 and ScratchExtent<=256 and
 AllStoredLFinite and AllRawRealLeavesPositiveFinite.
```

INDUCTION§7–8 dowodzi tego w actual order: first child, local LDL, second
child. First-child domain pochodzi z wcześniej istniejącego g00, a d11
child dopiero z wykonanego local LDL. Base inner1: dwa L words i dwa real
leaf stores, return4. Nie ma inner0. Frame nie jest jedyną przesłanką B.

12 subtrees:10752 internal L words +1536 raw leaves. Source layout i future
assembly offsets wyprowadza ASSEMBLY_INTERFACE. Full loader/raw-tree assembly,
stable leaf replacement/normalize, targets, Reach i sampler law pozostają open.

`binary_tower_proved=true`, `remaining_binary_subtrees_proved=true`,
`source_inner7_totality_proved=true`, `levels_proved=[7,6,5,4,3,2,1]`.
`full_binary_tower_theorem_kernelized=false`: kernelowe scalar/shape/frame/
abstract execution lemmas, analityczna pełna source numeric/memory induction.
`full_internal_tree_proved=false`, H3/global Reach/law/security flags false.
