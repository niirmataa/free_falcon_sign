# H3_NODE3 — uniwersalna kompozycja split_top/Adj/LDL3

Autor projektu: Niirmata. Dowód ma zakres mieszany: poniższy uniwersalny
argument analityczny, dokładne certyfikaty QQ/number-field/RBF oraz kernelowe
integer/dataflow/frame lemmas. Nie jest pełnym kernelowym interpreterem C.
P_key, Emitted_C i profil są DOKŁADNIE te z odebranego ROOT, bez nowych
premises o pivotach, małym L, norm acceptance lub NumericCenter.

## 1. Ściśle określone wejście i ROOT reuse

RootSlice_C(p), p∈P_key, daje g00 i rzeczywiste subtractive d11. Konsumujemy
ROOT/ROOT_CERTIFICATE oraz ROOT/ANALYTIC_PROOF z ich pinami. U=2^-48 i eta=2^-900
oznaczają konserwatywne source error coefficients, nie complete IEEE assumption.
Użyte są następujące POWIĄZANE root facts:

- branch0: v=g00_C jest realne, imag raw+0, value∈[1/2,2^23), error do A<1/1024;
- branch1: v=D_C jest finite, normal/zero, Re∈(32,2^31), |Im|<32;
- dla każdej frequency istnieje realny r=|det(Bhat)|²/a, z
  `mhat=(q-delta)²/amax <=r<=4(q+delta)²=Mhat`, i `|v-r|<=E=256U*jmax`;
- delta,amax,jmax pochodzą z exact Gram obliczonej FFT macierzy. Piny/QQ
  wartości są w ROOT/artifacts/numeric_certificate.json, odczytane i ponownie
  sprawdzone przez nowy certificate.py. E≈17.98, mhat>72, a mhat−E>32.

Nie używamy luźnego error2^22 do positivity. Pozostaje on boundem wobec
niezależnego exact spectrum q²/A i zostanie użyty tylko w końcowym error
interface. Dla branch0 comparison spectrum R to rzeczywiste realne g00_C;
dla branch1 to opisane r. ROOT_CONSUMPTION.md rozlicza reuse i chronology.

## 2. Primitive domains i rzeczywisty inverse_of(3)

ROOT add/sub/mul contracts obowiązują dla finite |operand|≤2^100:
add/sub error≤U(|x|+|y|)+eta, mul error≤U|xy|+eta. Outputs są normal albo
signed zero. Dziedziny wszystkich nowych użyć wyprowadzamy poniżej.
Double występuje tylko w FPC_SQR unit twiddle; jego normal/zero input ma
modulus<2, więc literalny exponent increment jest exact i finite.

Rozszerzony div: finite |x|≤2^100, positive normal y∈[1/16,2^35]. Source
55-bit restoring loop, remainder invariant i sticky normalizacja są te same
co w ROOT. Normal inputs Ux,Vy∈[2^52,2^53) dają
`r+q Vy=2^55 Ux`, 0≤r<2Vy, q parzyste; sticky remainder error≤1, conditional
sticky shift error≤1 i pack≤2 units. Relative error≤2^-51<U. Nie zakładamy
correct rounding każdej klasy IEEE.

Nowy denominator ma encoded exponent1019..1058, normal numerator1..1123.
Biased pack base ex−ey+1021+w, w∈{0,1}, daje output exponent≤1128<2047.
Wszystkie signed locals i masked shift counts są zdefiniowane. Underflow
normal quotient gubi<2^-1021; exponent0 numerator jest clampowane do+0
(także−0/subnormal), a pominięty exact quotient<2^-1018<eta. Nie ma y=0.
Stąd `|div_C(x,y)-val(x)/val(y)|<=U*|val(x)/val(y)|+eta`, output finite
normal/zero. Stara domena[1/2,2^23] nie została przeniesiona bez tego kroku.

Source inverse_of(3)=div_C(1,of_C(3)). Of jest exact signed32 z przebudowanego
ZERO.OF_EXACT. Literalny loop/pack daje

```
kappa_bits = 0x3fd5555555555555,
kappa = 6004799503160661/18014398509481984
      = 1/3 - 1/(3*2^54).
```

NodeInverse dowodzi raw bits i scaled exact value w kernelze; C/Python/QQ
sprawdzają ten sam word. Sześć source końcowych multiplications używa TEGO
kappa. Idealne1/3 jest wyłącznie reference, nigdy definicją maszynowego split.

## 3. Pełna mapa split i niezależny exact reference

Niech ζ=exp(2πi/4608), e_j=1+6 rev8(j), x=ζ^e_j i omega=ζ^1536.
Source1275–1322 czyta slots3j,3j+1,3j+2 (imag+768). Ich roots to x,x omega,
x omega². Child root to y=x³=exp(2πi e_j/1536); j∈0..255 zawiera wszystkie
wybrane roots X^512−X^256+1. Real child slot j, imag j+256.

Dla idealnego spectrum (a,b,c), source-order limit z exact coefficients:

```
t0=(a+b+c)/3,
t1=conj(x)*(a+omega²*b+omega*c)/3,
t2=conj(x)²*(a+omega*b+omega²*c)/3.
```

To współczynniki podziału p(X)=p0(X³)+X p1(X³)+X² p2(X³). Następuje Adj(t1),
Adj(t2), dokładny bit sign flip wraz z signed zero. Dla REALNEGO dodatniego
spectrum macierz wejściowa jest Hermitian: diag h=t0, lower b0=conj(t1),
c0=conj(t2),b0. Po usunięciu diagonalnych faz diag(1,x,x²) jest to circulant
matrix U diag(a,b,c) U*/3, gdzie U_{rk}=omega^(rk), U U*=3I. Eigenvalues to
a,b,c, bez dodatkowej normalizacji. Number-field checker nad QQ(omega)
sprawdza każdą równość matrix/polynomial, det=abc i h²−|b0|²=e2/3. Zatem
exact pivots w TEJ kolejności to e1/3,e2/e1,3abc/e2. To independent reference,
nie source implementation.

RBF256 odtwarza wszystkie256 użytych cubic pairs i4 fixed components W2/W4;
component error<eps=2^-50. Sprawdza także wszystkie child/root exponent map
bindings do ROOT. Nie polegamy na samej zgodności długości tablic.

## 4. Źródłowy split error, także dla complex v

Dla |v_k|≤B source integer transducer daje każde t_i z norm error<delta_s
wobec powyższego exact split COMPLEX v, gdzie delta_s=B/2^36. B0=2^23,
B1=2^32; zatem delta_s0=1/8192, delta_s1=1/16.

Szczegółowy checker używa ROOT component bound
`CM(M,e,d)=2Md+2e(1+d)+6U(M+e)(1+d)+4eta`. Dla complex multiply przez
approx unit coefficient norm error≤2CM. Complex add error≤U(|z|+|w|)+2eta.

- W2/W4 multiplication każdego B/C: ew=2CM(B,0,eps).
- Dwa weighted sums: ebc=2ew+U(2B+2ew)+2eta,
  esum=ebc+U(3B+ebc)+2eta.
- Computed conjugate twiddle square ma component error esq=CM(1,eps,eps).
- Obie rotated gałęzie mają norm error≤2CM(3B,esum,esq); esq≥eps.
- Plain t0 sum ma error≤2UB+2eta+U(3B+2UB+2eta)+2eta.
- Jeżeli Et jest max tych pre-scale errors, sześć rzeczywistych końcowych
  mul daje `kappa Et+3B|kappa-1/3|+U*kappa*(3B+Et)+2eta < B/2^36`.

Wszystkie to exact QQ outward inequalities po symbolicznych norm bounds;
nie dopasowanie do testów. W całym split operands<2^40, inverse divisor3
w nowej domenie. Adj jest exact, nie zmienia normy błędu.

## 5. Hermitian comparison i pierwsza dodatniość

Definiujemy z RZECZYWISTYCH child words h=Re(t0), tau=Im(t0), b=Adj(t1),
c=Adj(t2). H ma diagonal h (real) i lower b,c,b, upper ich conjugates.
Jest to obiekt dowodowy. W programie tau zostaje i nigdzie nie jest zerowane.
NodeDataflow.real_slot_noninterference kernelowo dowodzi dla dowolnych
scalar Ops, że L10/L20/L21 oraz REAL outputs nie zależą od samego tau,
ponieważ wszystkie divisions i final mul_autoadj czytają REAL slots.
To nie pozwala usuwać imaginary INPUT v przed split: wpływa ono na b,c,h.

Niech Hhat będzie idealnym Hermitian split spectrum R z§1. Każdy entry
H−Hhat ma modulus≤s: s0=delta_s0, s1=E+delta_s1. Operator norm≤3s
(Hermitian row/column norm bound). Weryfikowane dokładnie:

```
branch0: 1/2−3s0 >1/4=:lambda0,
branch1: mhat−3s1 >16=:lambda1,
2s_b<m_b; 1+4s_b/lambda_b<9.
```

Stąd H≥lambda I, h≥lambda>0; coarse h<T, T0=2^24,T1=2^33. Pierwszy div
ma zatem wykazaną domenę PRZED wykonaniem. |b|,|c|≤h z principal minors.
Norms odpowiadających exact offdiagonal Hhat są równe, więc
`||b|-|c||≤2s`. Source tau=+0 w branch0 (plain sums imag+0, mul by positive
kappa); w branch1 |tau|≤s1<32 oraz h≥mhat−s1>s1, więc |tau|≤h.

Zapisz exact LDL H: d=h−|b|²/h, q2=h−|c|²/h, nu=b−c conj(b)/h,
ell10=b/h, ell20=c/h, ell21=nu/d, d2=q2−|ell21|²*d.
Schur variational characterization daje d,d2,q2≥lambda, także d,q2≤h.
Po pierwszym elimination 2x2 Schur jest positive, więc |nu|²≤d*q2.
Ponadto |q2−d|≤4s. Zatem
`|ell10|,|ell20|≤1`, `|ell21|²≤1+4s/lambda<9`.
To jest WYPROWADZONY bound, nie dodatkowe small-L założenie P_key.

## 6. Source LDL3, w rzeczywistej kolejności

### First division i d11

Direct component divisions dają L10/L20 errors wobec b/h,c/h≤U+2eta<2U;
norms<2. Source p11=b*adj(L10), oraz p20=L20*adj(c), mają norm error wobec
realnych |b|²/h,|c|²/h mniejszy niż r_p*h, gdzie
`r_p=U+2eta+6U(1+U+2eta)+8eta/lambda`.
Source neg/add zachowuje oddzielne components. QQ checker dowodzi:

```
|Re(d11_C)−d| <64U*h,
|Im(d11_C)−tau| <64U*h,
analogicznie q2_C versus (q2,tau).
```

Przed ostatnim division L21 mamy `64U*T<lambda/2`. Wobec tego
`Re(d11_C)>lambda/2`, normal i <2T; denominator należy do[1/16,2^35].
Nie użyto przyszłego d22 do uzasadnienia tego kroku.

### L21

Rzeczywista kolejność to muladj(c,b), div przez h, neg/add b, dopiero div
przez real d11_C. Muladj error≤6U*h²+8eta; po div i add numerator nu_C ma
`|nu_C−nu|<64U*h`. Ponieważ d_C=d+epsilon_d, |epsilon_d|<64U*h i d_C>0,
porównanie quotientów oraz source final div daje

```
|L21_C−ell21| <1024U*h/d ≤1024U*T/lambda <1;
|L21_C|<4.
```

Checker używa rho=64U*T/lambda i coefficient
`a=(64U+3*64U)/(1-rho)`; dodatkowe div rounding daje a+U(3+a)+2eta<1024U.
W przejściu od błędu absolutnego do coefficient używa h/d≥1, nie utożsamia
zmiennego h/d z jego największą wartością.

### d22

Program najpierw oblicza q2_C, potem normC=mulselfadj(L21_C), następnie
tmp=mul_autoadj(normC,d11_C), wreszcie sub(q2_C,tmp). Nie reassocjujemy.
Z norm L21_C<4, ell21<3:

```
|normC_re−|ell21|²| ≤7*1024U*h/d+48U+4eta,
normC_im=raw+0,
tmp używa wyłącznie Re(d11_C).
```

Mnożąc przez d_C≤d(1+rho), dodając |ell21|²*|epsilon_d| oraz rounding mul
i końcowego sub, exact QQ coefficient jest<65536U. Używa też
|ell21|²*d≤q2≤h. Wniosek:

```
|Re(d22_C)−d2| <65536U*h ≤65536U*T,
Re(d22_C)>lambda/2,
Re(d11_C),Re(d22_C)<2T.
```

Tmp imaginary jest dokładnie+0 (explicit selfadj store, positive real d11).
q2_C jest normal/zero i sub(q2_im,+0) zachowuje jego raw bits: wynika to z
literalnego add normalize/pack, nie complete-IEEE assumption. Zatem Im(d22_C)
=Im(q2_C), a konserwatywnie |Im(d22_C)|≤I+65536U*T, gdzie I0=0,I1=32.
Tak uzyskano imaginary bounds1/256 dla obu branch0 pivots i33/34 dla branch1.

### Domain order i caps

H positivity najpierw daje h i L10/L20 domain. Produkt c*adj(b)<2T²≤2^67;
po pierwszym div jego norm<2T, numerator L21<4T. Następnie dowiedziony d11
domain umożliwia final division; przed refinements coarse quotient<16T/lambda,
dalej wyprowadzony L21<4 umożliwia normC_re<32 i tmp_real<128T≤2^40.
Wszystkie scalar operands<2^100 PRZED zastosowaniem primitive lemmas.
Outputs są finite normal/zero, dodatnie real denominators/pivots normal.
Imag parts nie są po cichu usuwane ani canonicalizowane.

## 7. Błędy do niezależnego exact split A lub q²/A

H_ref to exact Hermitian split tego spectrum, nie projekcja źródła. Maksymalny
entry error do H_ref: e0=9/8192, e1=2^22+1/16, z ROOT error i source split.
Exact spectrum jest positive; exact L10/L20/L21 mają norms≤1, ponieważ jego
circulant structure daje równe dwa Schur diagonals. Source H ma L21<3.

Variational pivot bounds: first Schur pivot jest minimum quadratic form
na vectors(z,1). Minimizers dla H i H_ref mają norm²≤2, a leading2x2
matrix difference norm≤2e. Stąd |d−d_ref|≤4e.
Last pivot minimizer ma components o bounds4,3,1 dla H (inverse triangular
row); norm²≤26. Dla H_ref jest jeszcze mniejszy. Cały matrix difference
norm≤3e, więc |d2−d2_ref|≤78e. Ten argument nie wymaga małego relative e.

Ponadto
`|ell10−ell10_ref|,|ell20−ell20_ref|≤min(2,2e/lambda)` oraz
`|ell21−ell21_ref|≤min(4,(8e+2e²/lambda)/lambda)`.
Druga nierówność wynika z numerator difference≤4e+2e²/h i |d−d_ref|≤4e;
reference multiplier ma norm≤1. Dodając source rounding:

```
error L10/L20 ≤min(2,2e/lambda)+2U,
error L21 ≤min(4,(8e+2e²/lambda)/lambda)+1024U*T/lambda,
complex error d11 ≤4e+I+2*(64U*T),
complex error d22 ≤78e+I+2*(65536U*T).
```

Dokładne comparisons dają rekord c3 w NODE3_CERTIFICATE. Branch0 errors
L10/L20<1/64,L21<1/16,d11<1/128,d22<1/8. Branch1 odpowiednio<3,<5,<2^25,<2^29.
Te luźniejsze branch1 bounds do q²/A nie służą do positivity; mocniejsze
source-to-H bounds i korelacje są eksportowane osobno.

## 8. Uniwersalność i granica kernelizacji

Wszystkie kroki dotyczą dowolnego P_key, b∈Fin2,j∈Fin256. Jedna stała c3
ma dwa ustalone branch records; nie dopasowuje się jej do konkretnego klucza.
Źródłowo związane RootCertificate i powyższe explicit inequalities rozliczają
numerical premises. C buffers/lifetimes, packed layout i fixed compiler model
są jawnym API/source bindingiem w NODE3_FRAME i SOURCE_MODEL_BINDING.

Kernel sprawdza inverse3, restoring-loop zależności, dataflow projection,
rational-pair validity i frame. Pełna spectral/Schur/error kompozycja jest
ANALITYCZNA z dokładnymi certyfikatami, a nie full Lean C theorem.
Finite C/ASan/UBSan/QQ/RBF/Lean controls sprawdzają binding i mutacje; nie
zastępują uniwersalnego argumentu. Full-node3-kernelization=false pozostaje jawne.
