# Source order i deterministic value projection

## Literalny scheduler

Source falcon-sign.c1616–1839, bez zastępowania recursion idealnym samplerem.
Root logn10: n1536,tn512, tree0 offset1536, tree1 offset9984. Najpierw t1→
SplitTop→depth(tree1)→MergeTop(z1), potem CM(z1,Lroot)+t0, split i depth(tree0),
merge oraz final subtraction tego samego CM(z1,Lroot). W cubic logn9 kolejność
child2→child1→child0. Child1 odejmuje P21 PRZED użyciem jego z1 do child0.
Binary inner(k>0) najpierw right/tree1, potem updated left/tree0. Recomputed
CM mają te same operand bits, ale rounded add/sub nie zostają anulowane idealnie.

Terminal logn0 czyta sigma,*t1,*t0 do locals. Pierwszy callback ma mu1 i
mul_C(IW1I,sigma); następnie r1=sub_C(mu1,of_C(Y1)), rx=half_C(r1),
mu0'=add_C(old_mu0,rx); drugi callback ma mu0',stored sigma. Na końcu
r0=sub_C(sub_C(mu0',of_C(Y0)),rx), stores z0=r0,z1=r1. Output arrays to
RESIDUALS, a nie ordered integers Y. Raw signed zeros pozostają słowami źródła.

Call-count wynika z control flow, nie z listy testów:
I(0)=2, I(k+1)=2I(k), D(k)=3I(k−1), R(l)=2D(l−1).
Zatem I(k)=2^(k+1), D(9)=1536, R(10)=3072. Są1536 terminal blocks,
768 w każdej root branch. Lean JointOrder dowodzi tych identities.
SOURCE_ORDER.json daje świeżą exact structural instancję wszystkich positions,
leaf-word addresses i klas width; tabela nie jest domain proofem.

## Stan pełny i projekcja

Pełny stan na cut przed callbackiem zawiera PC/stack, caller memory, live
snapshots, immutable tree/basis/targets, fault, prng.ptr, aktualny block index,
historię ujawnionych getter words i liczniki. Unread buffer contents są ukrytą
częścią gry, nie składnikiem legalnej PAST. Zdarzenia obserwowalne są jak w IID.

Fix entry e (readonly words,legal memory,initial caller scratch/targets oraz
PAST). Deterministyczny transducer V_e(h), h=(y1,...,yi), wykonuje dokładnie
caller statements pomiędzy callbackami, z podanymi już completed returns.
Zdefiniowany jest rekurencyjnie tylko na positive-support prefixes, a jego
totality na tej dziedzinie wynika z PREFIX_CLOSURE. Zawiera read-time words,
więc parametry mu_i(h),sigma_i(h) są jednoznaczne, także przy cancellation/−0.

**Source-frame simulation:** w callbacku jedyne writes poza scalar locals to
PRNG context i fault. Literal source fault jest NONE w legal domain; rejected
proposal wraca do tej samej scalar loop i nie wykonuje żadnego caller store.
Caller używa z contextu wyłącznie zwróconego integera; nie czyta N,ptr lub
ujawnionych byte values. Probe/statistical branches nie są aktywne w tym buildzie.
Frame ORDERED utrzymuje disjoint const targets/tree/context i scratch.

Indukcja po source caller statements: dwie rzeczywiste finite realizacje z
tym samym e,h, ale różnymi rejection histories/ptr, mają identyczne PC/stack,
live caller words, kolejne parametry i wszystkie final root residual words.
Instrukcje między cutami są deterministyczne; przy następnym return równe y
dają równe of_C,sub/half/add i store. Getter schedule zależy od p i liczby
proposals, lecz nie wpływa na ten caller induction. Dlatego projekcja nie jest
założeniem wywnioskowanym tylko z braku ptr we wzorze K.

Kontrola: dwa pełne original-C-bound public tapes dały te same3072 values,
mu/sigma/banks/recomputed products i POST bytes przy3147 versus6219 proposals
oraz różnych start/end ptr. To kontrola powyższego uniwersalnego frame,
nie claim, że resources mają takie same prawa jak values.
