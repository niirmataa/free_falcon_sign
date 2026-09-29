# Source iFFT3: inverse identity, indeksy, błędy i termination

Zakres N1536/logn10/full1, source falcon-fft.c854–965. I(F) to mathematical
inverse evaluation z POSTPROCESSING_MAP, nie uprzednio certyfikowany source iFFT.

## 1. Dokładny algorytm i kolejność

First cubic:256 rozłącznych triples (3j,3j+1,3j+2), imag+768. Wszystkie6
input words są odczytane przed pierwszym store. x=conj(cubic[512+j]),w=e^(2πi/3).
Ideal outputs: A+B+C, x(A+w²B+wC), x²(A+wB+w²C). Source używa literal W4/W2,
dwóch source sums i FPC_SQR(x) z mul/sub/double. Symbolic Q(sqrt(-3))(x)
certificate sprawdza inverse×forward=3I, bez utożsamienia rounded phases
z exact roots. Ideale square/cubic phases i conjugation są tymi z ROOT.

Osiem binary stages: t=6,12,...,768; m=256,128,...,2. Dla u1<hm=m/2,
v∈[u1*t,u1*t+t/2) odczyt A=a[v],B=a[v+t/2], następnie stores
A+B,(A-B)conj(square[m+u1]). Każdy stage ma384 rozłączne pairs pokrywające
wszystkie768 complex slots; actual lists są w numeric_certificate.json.
Source locals zapewniają read-before-write, wszystkie real/imag indices<1536.
Ideal inverse×forward=2I. Wzajemnie odwrócona hierarchia oddaje ten sam physical
root order co ROOT; końcowy factor3*2^8=768.

Terminal:768 par xr/xi odczytanych przed zapisami;
b=mul_C(xi,IW1I),a=sub_C(xr,half_C(b)). Ideal inverse dla w1=exp(iπ/3)
to b=2xi/sqrt3,a=xr-b/2. Potem source inverse_of(768), bit
**3f55555555555555**, i1536 mul_C(ni,a). Source reciprocal nie równa się1/768.

## 2. Uniform error induction

U=2^-48,η=2^-900 to odebrany conservative finite primitive bound, ε=2^-50
outward twiddle-component error. Fresh RBF256 sprawdza255 square+256 cubic
pairs,6 fixed W components oraz IW1I. Numeric script sprawdza także normalne
nonzero product inputs do wszystkich256 source double w FPC_SQR. Double nie
jest stosowany do arbitrary data/subnormals; nie poszerzamy jego theorem.

M jest ideal complex-modulus cap, e per-real-component source error. Dla CM
z unit ideal phase, phase-component defect d, source error zawiera:
`C(M,e,d)=2Md+2e(1+d)+6U(M+e)(1+d)+4η`.
To expansion obu products i sum/sub, z osobnym roundoff; cancellation/−0
nie wymaga relative-output-error assumption. Add/sub bound to
U(sum abs operands)+η. Wszystkie mniej ciasne factor choices są outward.

Start M=B=89531345,e=0. Cubic plain branch ma errors dla B+C i następnie+A;
dwa rotated branches mają dwa CM errors, dwa add errors i końcowe CM.
Square phase defect pochodzi z C(1,ε,ε). M po cubic=3B; e jest maximum
trzech opisanych recurrences (pełne rational terms zapisane w skrypcie).
Binary stage: es=2e+U(2M+2e)+η; nowy e=max(es,C(2M,es,ε)), M'=2M.
Indukcja wszystkich8 stages daje source operands<2^38; nie jest to maksimum
fixture. Terminal e1=IW1I*e+εM+U*IW1I*(M+e)+η; dla a doliczamy e1/2,
all-finite source Half error2^-1023 i źródłowy sub error. M'≤2M.

Nieidealne source half może flush/zmienić subnormal; odebrany bezwzględny
all-finite bound to obejmuje. Add/mul signed-zero/subnormal effects mieszczą
się w η. Operands wszystkich stages<2^40<2^100 PRZED instrukcjami; div ma
numerator1/denominator768 w positive normal domain. Scale error:
rho*e+|rho-1/768|*M+U*rho*(M+e)+η, rho=val(ni).
Exact QQ replay daje outward **≤1/128**; actual output abs≤4572095+1/128<2^23.

## 3. Kontrole i granica

Original falcon_iFFT3 i observer porównano word-for-word, wszystkie11 stages,
normal/ASan/UBSan, signed zeros, tiny subnormals, cancellation i duże wejścia.
Niezależny RBF256 oracle liczy wszystkie1536 coefficients przez direct sum:
z_k=(1/768)ΣF_j exp(-2πir_j k/4608),
a_k=Re(z_k)-Im(z_k)/sqrt3, a_(k+768)=2Im(z_k)/sqrt3.
Nie używa source butterfly implementation. Phase powers są liczone przez
integer modular exponents; niepowodzenie wcześniejszych iterated balls
(rosnące enclosure radii) zachowano, nie uznano za błąd C.

Algorytm ma skończone, ustalone loop bounds; nie wywołuje callbacks/PRNG.
Symbolic/QQ induction i source instantiation są analityczne z certificates;
nie jest to pełny kernel proof real FFT ani proof kompilatora.
