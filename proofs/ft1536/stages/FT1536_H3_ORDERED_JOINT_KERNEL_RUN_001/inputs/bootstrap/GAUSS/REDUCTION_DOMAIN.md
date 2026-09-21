# Actual source reduction — przed probability accuracy

## First-bank envelopes i correction errors

REDUCTION_DOMAIN.json ma10 rows (5 banks × stored/paired class). a jest literal
dyadic coefficient; d_lo=max(width.dss_lower,a); d_hi=min(width.dss_upper,
previous coefficient) dla j>0. Source selection rzeczywiście ma upper STRICT
previous coefficient; closed bound jest conservative. Zachowano supports
K=[29,59,118,235,365],delta_C∈[0,1]. Nie użyto luźnego dss<1 dla każdego k.

Dla U=2^-48,η=2^-900 source gap≤(d_hi−a)+U(d_hi+a)+η. Używając osobno
M(x,y)=(1+U)xy+η i A(x,y)=(1+U)(x+y)+η dla dodatnich bounds, obliczamy
tail_C i x_C w literal order2939–2944. Ceil bounds stored:
170,273,268,262,123; paired:106,273,268,262,123. Wszystkie actual x<273,
operands są finite i w odebranej primitive domain przed instrukcjami.

Dokładny Xhat używa d_hat,a i exact delta_hat=rho_hat lub1−rho_hat.
Gap subtraction error≤U(d_hi+a)+η; first product error≤K²gap_error+UK²gap_cap+η.
Tail error rozlicza2K*eps_delta,2eps_delta+eps_delta²,oba mul i add. Potem
source tail*dss i final add mają własne błędy. Wszystkie rational terms,
z oddzielnym CENTER_REFINEMENT i parameter transport, są w JSON; nie observed maxima.

## Normal multiplication refinement, nie blanket IEEE premise

Dla użytych normal positive operands w reduction (x∈[1/2,273],inv_ln2;
of(e),literal log2,e≥1) products są normal, daleko od overflow/underflow.
W source mul limbs base B=2^25 dają dokładne P=Mx*My=z0+B*z1+B²*zu,
0≤z0,z1<B. Poszczególne products mają≤56bits, wszystkie carries mieszczą się
w uint64. GaussianMul sprawdza expansion/ranges/reconstruction. Source sticky
`((z0|z1)+(B−1))>>25` jest1 iff low50 product bits są nonzero. OR do zu
zachowuje guard/round/sticky. Conditional shift o1 wybiera normalization zależnie
od top product bit. Po nim m∈[2^54,2^55); m>>2 to53 retained bits, bit1 round,
bit0 OR wszystkich niższych discarded bits. Lookup0xC8 zwiększa tylko przy
strict half albo odd tie (kernel round_lookup). Exponent arithmetic i carry
w FPR pack kodują ten nearest-ties-even normal product. To derived refinement
konkretnego portable C, nie założenie o wszystkich operacjach FPEMU/IEEE.

RNE na uporządkowanym zbiorze positive representables jest monotone: gdy x<y
i wybrane nearest a>b, nearest inequalities implikują2x≥a+b≥2y, sprzeczność;
przy x=y algorytm jest deterministyczny. Normal word order jest value order,
a source floor przy sign0 jest ordinary floor, więc f(x)=floor_C(mul_C(x,inv))
jest monotone na [1/2,273]. Dla x<1/2 odziedziczony coarse source bound daje
0≤mul_C(x,inv)<1 i positive zero, więc f(x)=0 także dla subnormals.

## Całe word buckets

Exact integer binary searches dają394 rozłączne, przyległe raw-word intervals
[x_first(e),x_last(e)] pokrywające WSZYSTKIE sign0 words od+0 doof(273).
Dla e1..393 checks sprawdzają f(first)=e,f(first−1)=e−1; f(max)=393.
Source monotonicity i GaussianIntervals.monotone_bracket podnoszą te exact
endpoint certificates na cały interval, nie interpolują grid error.
GaussianData kernel sprawdza contiguous coverage, ranges i63 nominal overruns.

c_e=mul_C(of_C(e),log2) jest sprawdzony exact RN. Dla każdego e≥1 certificate
ma c_e≤x_first oraz x_first≥c_e/2,x_last≤2c_e. W source subtraction
opposite-sign mantissas mają exponent gap≤1, alignment exact, a Sterbenz bound
na cancellation≤53 significant bits; normalize/shrink/pack exact jak w ZERO§5.
Zatem rB=val(x)−val(c_e) dla całego bucket. e0 ma sub_C(x,+0)=x dla normal,
+0 przy subnormal, z błędem<2^-1022. Wszystkie source rB są NONNEGATIVE.

Wynik globalny: **0≤e≤393**, **0≤rB≤12193974156573/17592186044416**.
63 buckets mają rB_last>literal binary64(log2). Przykład scalar-derived
mu3fe944a55eca5136,sigma3ff5555555555555,k4,b0 daje
x4013687a9f1af2b1,e6,rB3fe62e42fefa39f0 (literal log2 kończy się...9ef).
Sigma pochodzi z standalone gated leaf D331776; Emitted membership OPEN.
COUNTERMODELS zachowuje native confirmation i pełny scope.

Wszystkie buckets/endpoints/sąsiednie words i e*log2 sprawdzono w original C
normal/ASan/UBSan oraz niezależnym dyadic RN oracle. Universal instance opiera
się na powyższym source bit/RNE/Sterbenz argumentzie i exact full coverage,
nie na54 PMFs. Odchylenie c_e od e*REAL log2 ma fresh RBF384 enclosure w
EXPM_ACCURACY.json; żaden generic remainder[0,log2] theorem nie jest przemycony.
