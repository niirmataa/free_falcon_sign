# FT1536 H3_NODE3 — split_top → Adj → LDL_dim3

Data:2026-09-19. Autor projektu: Niirmata. Wykonawca: GPT-ASTRA.
W: `/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H3_NODE3_RUN_001`.

## 1. Werdykt i dokładny zakres

**H3_NODE3_PROVED_FOR_PINNED_MODEL.** Domknięto dokładny typ z TASK§3
i ROOT/NEXT_INTERFACE: jeden jawny uniform Node3Constants c3 dla wszystkich
P_key, OBU root branches i wszystkich256 physical frequencies każdej.
Nie dodano do P_key małych błędów/L, dodatnich nowych pivotów, norm acceptance
lub NumericCenter. Numerical/domain premises nie pozostały otwarte.

Wynik jest **mixed analytical/kernel**: kernel inverse3, integer dependencies,
dataflow/constant/frame lemmas oraz uniwersalna analityczna spectral/source
error composition wsparta exact QQ/number-field/RBF certificates.
`full_node3_theorem_kernelized=false`. C/compiler semantics nie skernelizowano;
replay tekstu i finite controls nie są przedstawiane jako taki proof.

Nie nadano statusu proved niższym nodes, initial targets, global Reach ani
prawu samplera. Root chronology i defined-prefix frame są zachowane.

## 2. Piny i domena

- TASK SHA-256: `9960e9a2a5f749761f8c7aba4d861e8b4fd5ba98a6523cb0d4d2cae61bbb1d30`.
- Bootstrap MANIFEST: `426db8a67b74de0de0141a8d9ca406fca7a2bdad45a42e97a913bad4d62b6ca3`.
- BASE: `3d6bf58b833d729983718f80da020118fa94188a`.
- Candidate manifest: `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`.
- Sprawdzono108/108 członków,106 original records i17 source files. INPUTS
  obejmuje112 publicznych rekordów z TASK/AGENTS/manifestem.

P_key jest dokładnie ROOT: Key4=cztery Int^1536 vectors, ternary f/g,
caps2047 F/G, exact NTRU i actual Gate00_C. Odebrane source-analytic
Emitted_C+source decode tego samego STATIC sk→P_key pozostaje konsumowane
w swoim zakresie. Nie zastąpiono go arbitrary-loader lub iid key law.

N1536/q18433/Phi=X^1536−X^768+1/sigma768/B2093922385, MODE1/FPEMU i Makefile
flags, M0 caller4096/nonce40,16 attempts, jeden K_seed[E] i parametryczny cel
są zachowane. Źródłem jest bootstrap, nie bieżące Extra/c lub indeks Git.

## 3. Zamknięta teza

```
exists c3 : Node3Constants, ValidConstants(c3) and
 forall p : Key4, P_key(p) -> forall b : Fin2,
  let S := RootSlice_C(p);
  let v := if b=0 then S.g00 else S.d11;
  let (t0,t1,t2) := SplitTop_C(v,10);
  let u1 := Adj_C(t1,9,0); let u2 := Adj_C(t2,9,0);
  Defined(SplitTop_C;Adj_C;LDL_dim3_C(t0,u1,t0,u2,u1,t0,9,0)) and
  forall j : Fin256,
   Node3Certificate(c3,j,t0,u1,u2,LDL_dim3_C(t0,u1,t0,u2,u1,t0,9,0),
    ExactSplitAndSchur(if b=0 then A(p) else q²/A(p),j)).
```

API premises: legalne sizes/lifetimes/buffers, rozłączne outputs/scratch
wobec const inputs, dozwolone repeated const aliases i fixed GCC14.2/C99/
Linux x86_64 LP64 portable FPEMU. Wszystkie numerical conditions są wnioskami.

| Część c3 | Branch0 | Branch1 |
|---|---|---|
| Re(t0) lower / upper | 1/4 / 2^24 | 16 / 2^33 |
| Re(d11),Re(d22) lower / upper | **1/8 / 2^25** | **8 / 2^34** |
| abs Im(t0) | 0, raw+0 | ≤32 |
| abs Im(d11) | ≤1/256 | ≤33 |
| abs Im(d22) | ≤1/256 | ≤34 |
| norms L10,L20 / norm L21 | <2 / <4 | <2 / <4 |
| source split-only norm error | <1/8192 | <1/16 |
| split norm error do exact reference | <9/8192 | <2^22+1/16 |
| L10/L20 error do exact reference | <1/64 | <3 |
| L21 error do exact reference | <1/16 | <5 |
| d11 complex error do exact reference | <1/128 | <2^25 |
| d22 complex error do exact reference | <1/8 | <2^29 |

Actual real values przekraczają dodatnie lower bounds, upper bounds są
ścisłe. Wszystkie source words finite, primitive outputs normal/zero;
dodatnie divisors/pivots są normal. Norm to complex Euclidean modulus.
NODE3_CERTIFICATE.json zawiera pełny rekord, intermediate caps, imaginary
bounds i mocniejsze source-to-H relations do następnego etapu.

Source inverse_of(3) ma bity `3fd5555555555555`, exact value
6004799503160661/18014398509481984 =1/3−1/(3*2^54). Source używa sześciu mul
przez ten word. Child root y=x³, x=ζ^(1+6 rev8(j)), ζ order4608; child
order1536, real j/imag j+256. Exact reference ma scaling1/3 oraz Hermitian
Gram z eigenvalues trzech real spectrum entries, pivots e1/3,e2/e1,3abc/e2.
Source pivots pozostają rzeczywistą subtractive sekwencją, nie tymi wzorami.

## 4. Mechanizm dodatniości i części urojonej

Branch1 zachowuje ROOT comparison r=|det(Bhat)|²/a, |D_C−r|≤E=256U*jmax.
Z mhat=(q−delta)²/amax i nowym split error s=E+1/16 wynika
`mhat−3s>16`. Dla branch0 `1/2−3/8192>1/4`. Nie użyto absolute error2^22
do positivity ani independent root Re/Im boxes.

Z actual child words tworzymy analityczny Hermitian H z diagonal Re(t0)
i rzeczywistymi lower u1,u2,u1. Source pozostawia Im(t0). Kernelowy
real-slot dataflow proof wiąże L/real pivots z H; pominięcie input imag
PRZED split byłoby błędem i jest wykrywane przez kontrolę mutacji.

H≥lambda I i near-equal offdiagonal moduli dają exact-H L21<3, bez small-L
premise. Kolejno wyprowadzono t0 domain, real d11 domain przed final div,
potem L21<4 i dodatni d22. Source-to-H real errors to64U*h i65536U*h;
L21 error≤1024U*h/d. Te bounds są silniejsze niż luźne branch1 errors
do q²/A. Imaginary values są propagowane; mul_autoadj(tmp,d11) czyta real
d11, nawet gdy Im(d11) jest niezerowe.

Nowy div domain **[1/16,2^35]**, U=2^-48,eta=2^-900, został wyprowadzony
z actual restoring/sticky/pack/underflow instructions. All operand caps≤2^100
ustalono przed użyciem primitive contracts. ZERO E2^-20 nie jest globalnym
boundem, a legacy complete-IEEE nie zastępuje nowej domain proof.

## 5. Chronologia i source frame

Branch0 zaczyna się przed root dim2. Jej certyfikat pochodzi z wcześniejszych
FFT/Gram/Gate facts g00, nie z przyszłego wykonania root. Branch1 actual call
ma conditional defined-prefix binding, bez twierdzenia o ukończeniu całej
wcześniejszej recursion.

Node3 input aliases są dokładnie(t0,u1,t0,u2,u1,t0), outputs i scratch
rozłączne. New frame chroni1536 child input words. Branch1 najpierw czyta
root D_C z t3 i zapisuje child prefix, potem legalnie używa starego root-D
storage dla d11/d22. Nie obiecuje zachowania tych danych po dalszym scratch
reuse. Node3 kończy się przed split_deep/niższymi nodes.

## 6. Audyty, kontrole i replay

- **21 modułów,115 twierdzeń,16 nowych**,15 inherited modules byte-identical
  i rebuild ze źródeł. Pełne final logs są czyste; bez sorry/admit/native_decide
  lub lokalnych axioms wniosku. Standardowe propext/Classical.choice/Quot.sound.
- NodeAudit.stdout SHA: `ea8f8ef7074a6bcc86f12084760ce6589012960a229909746f741175616479af`.
  Pełne types/implicits/terms NodeTypes.stdout SHA:
  `35f1644732d67d64c4db616d7c0c6546a52afb6351f1890ee05b4d80c2ba5d79`.
- Exact number-field checker: unitary split/Hermitian identities i3 pivots;
  RBF256:256 cubic pairs i4 fixed components; QQ: wszystkie c3 inequalities.
- Normal C i ASan/UBSan: wszystkie256 pozycje OBU branches,8192 raw output
  words;176 scalar pairs obejmuje rozszerzone domain endpoints/exp0/zeros.
  Lean mul/div zgadza się bitowo ze źródłem i literalnym modelem.
- Independent QQ/RBF oracle:512 frequency cases,4096 complex outputs,
  exact projected-H and independent split/Schur comparisons, bez host double.
- Imag d11/d22 jest niezerowe także w branch0 (61/62 positions w kontrolach).
  Mutacje input-imag/Adj/slot/ideal1/3/pivot formula/real-slot/rounding/domain
  są wykryte po rzeczywistych wartościach; no-op przechodzi. Dwa preflight
  cases zatrzymano przed C call poza denominator domain.
- **Fresh rehearsal PASS123/123**, z pełnym rebuildem i sanitizerami,
  bez wcześniejszych olean/bin/cache. Standard po freeze wymaga finalnego
  zewnętrznego OUTPUTS pin; jego wynik jest zapisywany wyłącznie w nowym DEST.

Finite controls są publicznymi synthetic envelope instances, bez dowodu
P_key/emitted membership. Nie są kontrprzykładami w required support ani
uniwersalnym dowodem przez próbki. Tekst dowodu odtworzony bajtowo przez
replay nadal ma jawny analityczny proof layer.

## 7. Próby, proweniencja i wykonanie

Zachowano wszystkie command/cwd/limits/exit codes/streams i failed attempts.
Początkowe Std.Rat decide nie redukowało closed comparisons; próba kernel
reduction zakończyła się thread-allocation diagnostic przy zadanym limicie.
Zastąpiono reprezentację przez exact numerator/positive-denominator pairs
i zwykłe kernel integer comparisons. Nie zwiększono8GiB, nie użyto native
axiom lub wyciszenia warnings. Nowe c3 fields są powiązane z QQ certyfikatem.

Rzeczywisty bwrap i EROFS probes potwierdziły W-only zapis, readonly wejścia
i source. Executor lock, wall/CPU limity, Lean -j1 -M2048/8GiB, osobny ASan
shadow mode; cache/HOME/TMPDIR/DOT_SAGE/LEAN_PATH pod W. Brak instalacji,
sieci, innych agentów, Git, sekretów, KeyGen/private loadera/Sign. Nie
zmieniono C/guardów/parametrów. Falcon/Pornin attributions zachowano.

## 8. Następny pełny typ i pozostawione obowiązki

NEXT_INTERFACE eksportuje sześć diagonal branches wraz z L i korelacjami.
Najbliższy NIEUDOWODNIONY cel:

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

Znaczenie wszystkich pól i quantifier domains podaje NEXT_INTERFACE.
Nie przyjmuje się nowych pivots w poprzedniku. Lower-tree totality, initial
targets, ORDERED_REACH przed ZERO_SCALAR i sampler-law/hybrid losses są
odrębne; fault0 nie dostaje residual-closeness. Nie dodano nowego abortu
lub automatycznej małej globalnej straty.

H3_range_proved=false; global_reachability_proved=false;
full_internal_tree_proved=false; sampler_law_proved=false;
security_reduction_proved=false; baseline_source_integrated=true;
source_changed=false; new_source_patch_integrated=false;
protocol_wrapper_integrated=false; owner_accepted=false;
full_node3_theorem_kernelized=false.

Odbiór, import i osobny commit wykonuje prowadzący; etap kończy się przekazaniem.
