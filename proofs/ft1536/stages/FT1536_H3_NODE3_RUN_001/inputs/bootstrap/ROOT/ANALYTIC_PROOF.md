# H3_ROOT_LDL — uniwersalny dowód numeryczny korzenia

Autor projektu: Niirmata. Ten argument jest analityczny z kernelowymi
lematami całkowitoliczbowymi i dokładnymi certyfikatami Sage. Nie jest pełnym
kernelowym interpreterem C ani dowodem poprawności GCC. Wszystkie źródła
wiąże bootstrap/CANDIDATE.sha256; aktywne C FPEMU, GCC14.2/C99/LP64.

## 1. Teza, domena i normy

P_key oznacza cztery wektory długości1536, f,g∈{-1,0,1}, |F_i|,|G_i|≤2047,
fG−gF=18433 modulo Phi=X^1536−X^768+1 oraz rzeczywisty mandatory Gate00_C:
każde real slot źródłowego root g00 jest positive finite i nie mniejsze od1/2.
EMITTED_BINDING wyprowadza wszystkie te warunki z successful emitted KeyGen
i roundtrip tego samego sk. Nie ma w P_key założenia małego L, dodatniego d11,
małego błędu, NumericCenter lub idealnego Babai quotient.

RootSlice to dokładnie source smallints_to_fpr/FFT3, znaki B=[[g,−f],[G,−F]],
Gram load_skey1232–1248 i LDL_dim2_fft3: dwa OSOBNE scalar divisions dla
składowych C, muladj, neg, add. D_C nie jest definiowane przez reciprocal.
Używamy zwykłego modułu liczby zespolonej; component error jest normą max
dwóch składowych. Val oznacza niezależną exact finite binary64 dyadic value.

Ustaw u=2^-48, eta=2^-900, eps=2^-50. Są to wyprowadzone majoranty źródłowe,
nie twierdzenie correctly-rounded complete IEEE. ZERO E2^-20 nie jest
stosowane do operacji root o wyższych exponentach.

## 2. Źródłowe primitive contracts i integer safety

### Add/sub

Dla wszystkich finite x,y o |val|≤2^100, active add/sub jest zdefiniowane,
finite, normal albo signed zero i ma błąd
`≤u*(|val(x)|+|val(y)|)+eta` względem sumy/różnicy.

Rozszerzamy ANALYTIC_PROOF ZERO§2, nie jego stałą domenową. Pola e≤1123.
Sort i maski nie zmieniają integer znaczenia; decoded normal mantissas są
exact, exp0 ma połowę rzeczywistej wartości (łącznie błąd<2^-1022).
Alignment d<60 ma error≤lambda=2^(e_max−1078); d≥60 gubi<lambda/16.
Signed magnitude T∈[0,2^57); normalize exact, h≥7 dla T≠0. Shrink9 error
≤4lambda, pack error≤8lambda albo underflow<2^-1022. ZERO kernel lemmas
sticky_interval/normalizer_for_add/shrink9_range/round_error są bez warunku
e≤1054 i mogą tu być użyte. Dla większego normal operand
lambda≤2^-55*max(|x|,|y|), więc13lambda≤u*(|x|+|y|).
Jeśli oba e=0, wynik jest zerem i błąd<2^-1021. Pozostałe tiny terms<eta.
Biased pack base≤1123, output exponent≤1125<2047.

Generalized pack binding w tym akapicie jest analityczny: dla m∈[2^54,2^55),
b=e+1076≥0, q=floor(m/4)+((0xC8>>(m mod8))&1)∈[2^52,2^53]. Word to
(s<<63)+(b<<52)+q, exact value=(-1)^s*4q*2^e, także przy carry q=2^53.
Dla b+2<2047 nie ma overflow exponent/sign. Gdy b<0 source zeruje m i e.
Nie podstawiamy większego b do dawnego PackOf.pack_normal_value o b≤1054.
Sub to dosłowny XOR znaku operand2, również dla±0.

### Mul/sqr

Dla tych samych operand caps source mul jest finite normal albo signed zero,
`|mul_C(x,y)−val(x)val(y)|≤u*|val(x)val(y)|+eta`.

Dla normal inputs U,V∈[2^52,2^53). Limb25 code680–773 oblicza P=UV:
z0,z1 są dwiema dolnymi25-bit cyframi; zu=floor(P/2^50). W z1 jest mniej
niż3*2^25, w z2 mniej niż2^29; żaden uint32 accumulator nie przepełnia się.
64-bit products i sumy mają mniej niż2^64. Source OR ustawia low bit zu
dokładnie wtedy, gdy P mod2^50≠0; error≤1. Conditional sticky right1,
w∈{0,1}, wnosi≤1 w nowych mantissa units. Pack wnosi≤2: łącznie≤4 units.
Względem P≥2^104 relative error≤8/2^54=2^-51<u. Exponent computation jest
ex+ey−2100+w; bias b≤1223, output exponent≤1225<2047.

Gdy source clamp underflows, pominięty product<2^-1021. Gdy input e=0,
source corrective mask daje signed zero, nawet dla subnormal: pominięty
product<2^-1022*2^100=2^-922<eta. Dotyczy obu znaków, nie tylko input0.
Sqr jest tym samym mul(x,x). Double użyte wyłącznie w FPC_SQR twiddle jest
exact dla jego normal/zero input o |value|<2; nie może overflowować.

### Div/reciprocal

Dla finite |x|≤2^100 i dodatniego normal y∈[1/2,2^23], source div jest finite
normal albo zero i ma błąd `≤u*|val(x)/val(y)|+eta`. Dla x=1 wynik jest
positive normal; ta dodatkowa reciprocal własność nie zmienia instrukcji
div_autoadj, która używa bezpośredniego div każdego componentu.

Source916–999: U,V∈[2^52,2^53), początkowo r=U,q=0. Każda z55 iteracji
wybiera b=1 iff r≥V, następnie r'=2(r−bV),q'=2(q+b). Zawsze0≤r<2V<2^54,
q<2^56; unsigned compare/subtract/shift nie tracą informacji. RootDiv
kernelowo dowodzi `r+qV=2^55 U` i remainder range po wszystkich iteracjach.
q jest parzyste, stąd OR sticky remainder daje przybliżenie2^55 U/V z
błędem≤1. Conditional sticky right1 i pack dają łącznie≤4 normalized units;
relative error≤2^-51<u. Błąd underflow<2^-1021<eta. Exponent0 numerator
jest clampowane do+0 (także−0/subnormal), z błędem≤2^-1021 dla y≥1/2.
Denominator ma e≥1022: nie występuje nielegalna domena y=0. Output exponent
≤1125. Wybrany GCC arithmetic shift i unsigned wrapping są jawne w modelu.

Wszystkie signed locals ex/ey/cc/e/s/d mają małe zakresy; shifts po helper
maskach są0..63. Wynik każdej instrukcji source jest zdefiniowany w podanej
domenie. Literal backend.py i source-normalized Lean mulC/divC zachowują
rzeczywiste normalizacje i pack; nie są zdefiniowane przez oracle RN.

## 3. FFT3 pełnego N1536, layout i błędy

certificate.py rekonstruuje255 square twiddles,256 cubic twiddles i6 fixed
components w RBF256. Każdy component różni się od odpowiedniego pierwiastka
ζ=exp(2πi/4608) o<eps. Użyte mapy są zgodne z historycznymi digestami, lecz
sprawdzenie jest wykonane ponownie na aktualnych bajtach i bez założenia IEEE.

Idealny pierwszy pass to a_u+a_{u+768}ζ^768. Każdy z8 square passes zastępuje
rozłączne części przez A±ζ^e B; ostatni pass przez A+xB+x²C, A+ωxB+ω²x²C,
A+ω²xB+ωx²C. Tutaj ω=ζ^1536. Pełny symbolic coefficient checker przenosi
WSZYSTKIE1536 indeterminates, sprawdza rozłączność supportu i każdą z1179648
wag. W slot i=3j+k wynik to p(ζ^r), r=1+6*rev8(j)+1536k; real w i, imag
w i+768. Zbiór768 r plus ich negacje to dokładnie1536 różnych pierwiastków
Phi. Nie ma normalizacji1/N ani konwencji dualnej B^T M B.

Dowód soundness checkera: source ideal operations są liniowe w niezależnych
współczynnikach; każdy dictionary reprezentuje sumę c_j ζ^{weight_j}.
Shift mnoży ją przezζ^e, union dodaje sumy o rozłącznym supporcie. Sprawdzenie
wszystkich wag jest więc równością liniowych map na całej dziedzinie, nie
testem polinomowych próbek. W każdym square stage exact complex modulus
≤liczba współczynników*cap; po pierwszym pass M=2cap, potem M*=2 osiem razy.

Niech e będzie component error, a d component error unit twiddle. Z§2 dla
FPC_MUL wynika majorant
`CM(M,e,d)=2Md+2e(1+d)+6u(M+e)(1+d)+4eta`.
Pierwszy pass ma e≤cap*eps+4u*cap*(1+eps)+3eta. Square recurrence:
`p=CM(M,e,eps); e'=e+p+u*(2M+e+p)+eta; M'=2M`.
Final cubic bierze dwa CM na gałęzi B, rzeczywisty FPC_SQR z boundem
CM(1,eps,eps) dla x², dwa CM na C i dwa source complex additions. Dokładne
racjonalne wyrażenia są w certificate.py. Daje to:

```
FFT component error f,g <2^-26; F,G <2^-15.
Exact |f|,|g|≤1536=:N; |F|,|G|≤3144192=:H.
```

Przez całą FFT |operand|<2^30, więc§2 ma udowodnioną domenę. Input signed32
conversion jest exact przez przebudowane ZERO.OF_EXACT. Wszystkie outputs
są finite normal/zero; nie zakładamy braku cancellation.

## 4. Skorelowany Gram przy obliczonej macierzy FFT

Hat oznacza dokładne complex value słów obliczonej FFT, nie dodatkowe
zaokrąglenie. Niech
`a=|fhat|²+|ghat|²`, `c=Ghat conj(ghat)+Fhat conj(fhat)`,
`j=|Fhat|²+|Ghat|²`, `v=fhat Ghat−ghat Fhat`.
Dokładna tożsamość `aj−|c|²=|v|²` jest sprawdzona jako polynomial identity
nad ZZ, we wszystkich8 independent real/imag variables. Cauchy daje|c|≤√(aj).
Nie zastępujemy tych korelacji niezależnym interval boxem.

Ustaw df=2*2^-26, dF=2*2^-15. Względem niezależnych exact ring evaluations:

```
da=2(2N df+df²), dj=2(2H dF+dF²), dc=2(N dF+H df+df dF),
|a−A|≤da, |j−J|≤dj, |c−C|≤dc, |v−18433|≤dc<1,
amax=2(N+df)², jmax=2(H+dF)².
```

Source Gram rounding jest małe RELATYWNIE do tej macierzy, nie do worst-case
niezależnych operands. Dla czterech squares i trzech positive sums:
`|g00_C−a|≤4u*a+8eta`, analogicznie `|g11_C−j|≤4u*j+8eta`.
8eta obejmuje również propagation pierwszych rounding floors.
Gate g00_C≥1/2 stąd daje a>1/4; certificate sprawdza też A>1/4.
Z |v|≥q−dc i a≤amax wynika j>1/4. Gram complex products mają norm error
≤6u|x||y|+8eta; final sum daje C error≤(7u+6u²)√(aj)+(18+16u)eta.
Zatem dla gamma=8u, po rozliczeniu tiny terms dokładnymi QQ comparisons:

```
|g00_C−a|≤gamma*a,
|g11_C−j|≤gamma*j,
|g10_C−c|≤gamma*sqrt(a*j).
```

G00/G11 imaginary slots są dokładnie+0: mulselfadj jawnie wpisuje of(0),
następnie add(+0,+0). Całkowite błędy względem A,C,J:
`da+gamma*amax<1/1024`, `dc+gamma*2(N+df)(H+dF)<1`,
`dj+gamma*jmax<1024`. G00_C∈[1/2,2^23), positive normal.

## 5. Direct division, L i subtractive Schur

Pisz a0=g00_C, c0=g10_C. Source L_C to (div(c0.re,a0),div(c0.im,a0)).
Bezpośrednio z§2 i gamma:

```
|L_C−c/a| ≤ [(u(1+gamma)+2gamma)/(1−gamma)] sqrt(j/a)+2eta
          <32u sqrt(j/a).
```

Tiny term jest rozliczony przez `sqrt(j/a)≥(q−dc)/amax`, nie przez nieprawdziwe
założenie sqrt(j/a)≥1. certificate.py sprawdza właściwy współczynnik
`2eta*amax/(q−dc)`. Stąd |L_C|≤(1+32u)√(j/a)<2√(j/a)<2^25.

Następny rzeczywisty muladj daje p0=c0*adj(L_C) z rounding. Propagation
zmiany inputs oraz jego błąd≤6u|c0||L_C|+8eta daje
`|p0−|c|²/a|<64u*j`. Ostatnie neg/add i g11 rounding dają

```
|D_C − (j−|c|²/a)| ≤256u*j.
```

Końcowa wartość w nawiasie jest Dhat=|v|²/a>0; wykorzystanie tożsamości
jest punktem ODNIESIENIA dla błędu subtractive kodu. Nie podmieniono kodu na
q²/g00 ani nie pominięto imag part. Dhat jest realne, ale D_C nie musi być.

Exact QQ certificate, z j≤jmax, daje:

```
(q−dc)²/amax −256u*jmax >32,
4(q+dc)²+256u*jmax <2^31,
256u*jmax <32.
```

Zatem **32<Re(D_C)<2^31, |Im(D_C)|<32**; Re jest positive normal,
Im jest finite normal albo signed zero. Source L ma finite normal/zero
components. Względem exact L=C/A, D=q²/A:

```
|L_C−L| ≤128u*2(H+dF)+4dc+16H*da <2^14,
|D_C−D| ≤4(2q dc+dc²)+16q² da+256u*jmax <2^22.
```

Bound L używa a,A≥1/4 i |C/A|≤4H. D-error korzysta z
|1/a−1/A|≤16da. Luźne absolute error2^22 NIE służy do dowodu dodatniości;
dodatni margines pochodzi z zachowanej determinantowej korelacji powyżej.

## 6. Domain closure i frame

Root operands pozostają daleko od2^100: FFT<2^30 (outputs f,g components
<2^11, F,G<2^22), Gram real products/sums<2^47, C components<2^35.
Direct denominator≥1/2 daje wstępny |L component|<2^37; products C*L<2^72,
sumy i końcowe subtraction<2^75. Te COARSE bounds dowodzą primitive domains
PRZED zastosowaniem ostrzejszej korelacyjnej analizy, więc nie ma koła.
Reciprocal 1/a0 jest normal w[2^-23,2]; nie jest faktyczną implementacją L.
Pack finite/normal-or-zero wynika z instrukcji w§2, nie z idealnej nazwy IEEE.

ROOT_FRAME.md oddziela RootSlice od wcześniejszego subtree. Jeśli defined
source prefix dociera do root call, wcześniejsze stores nie zmieniają root
g00/g10/g11. Nie dowodzi to poprawnych pivots ani numerycznej domeny każdego
wcześniejszego subtree. RootCertificate eksportuje g00_C, L_C, D_C do osobnego
internal-LDL etapu; nie wyprowadza global Reach lub prawa samplera.

## 7. Warstwy i kontrole

Kernel: importowane integer normalization/sticky/pack i exact of, nowe
restoring-division invariants, frame składania stores i jawne error consumers.
Pełne primitive error contracts, linear-map/source reasoning i korelacyjna
kompozycja są ANALITYCZNE z exact Sage certificates, nie pełnym Lean theorem
całego C. Brak unknown numerical premise; typy warunkowych konsumentów są jawne.
Kontrole C/ASan/UBSan/Lean/dyadic/RBF sprawdzają binding, nie zastępują
kwantyfikacji po wszystkich P_key i wszystkich częstotliwościach.
