# Uniform dodatni source acceptance floor: A≥1/256

Wymagane wejścia: zero-aware NumericCenter, certified actual stored/paired
widths. ORDERED source arithmetic daje r,delta sign0/finite z value[0,1],
positive dss<1, selected coefficient≤dss i support≤365. LEFT dostarcza
NumericCenter przed actual source calls; nie zakładamy desired output law.

## 1. Świadek dodatniej masy w każdym fixed wejściu

Wybierz source atom **k=0**. Każdy bank ma mass n_j,0/2^128. Minimum literalnych
pięciu liczników to9658096583921298676775519021886532885, większe od2^122,
zatem p_j(0)>1/64. To exact integer table fact, nie ideal exp positivity.

Jeśli val(r)≤1/2, wybierz b*=0,delta=r. W przeciwnym razie b*=1 i
delta=sub_C(1,r). Conservative source subtraction bound daje
0≤val(delta)≤1/2+2U+η, U=2^-48,η=2^-900. Ten wybór zależy tylko od PAST r;
fresh sign bit trafia b* z prawdopodobieństwem1/2, niezależnie od K=0.

Dla k0 literal x ma postać
add_C(mul_C(0,gap),mul_C(add_C(mul_C(0,delta),sqr_C(delta)),dss)).
ACCEPTANCE_FLOOR.json zapisuje pełne QQ step-by-step outward bounds, z błędami
każdego mul/add, także zerowych składników. Otrzymujemy x<1/3 oraz
mul_C(x,inv_ln2)<1/2. x jest sign0, więc **e=0**, także x=+0. Żadnego−0 floor
wyjątku w tym BerExp input; raw−0 mu został wcześniej rozliczony w r/delta.

rB=sub_C(x,mul_C(of_C(0),log2)). Product of positive zero jest+0. W source
add/sub z positive x i−0 sorting wybiera nonnegative larger operand, sign0
również przy cancellation; packing w tej finite small domain nie tworzy
ujemnego wyniku. Stąd rB≥0 i coarse source error daje rB<1/3. Potem actual
v=val(mul_C(rB,p63)) jest0≤v<2^62. Każda instrukcja ma ustaloną domenę przed
wykonaniem; dokładne rational caps w certyfikacie, nie observed maxima.

## 2. Small-domain trunc i Horner integer floor

Dla nonnegative finite word v<2^62 source trunc to floor(v): przy ex<1022
mask zeruje wynik; ex1022 shift63 daje0; przy1023≤ex≤1084 mamy cc1..62,
mantissa m=2^62+fraction*2^10 i val=m/2^cc. Unsigned right shift daje floor,
signed cast jest exact. +0/subnormals mieszczą się w pierwszym przypadku.
Ten theorem nie jest używany poza małą domeną. Zatem z=2*floor(v)≤2^63,
bez left-shift wrap.

Literal coefficients C0..C12 są positive, nondecreasing, C12=2^63,
C11=2^63−47104. Dla0≤z≤2^63 i0≤y≤Cprev:
high64(z*y)≤floor(y/2)≤floor(Cprev/2). Indukcyjnie
`C_u−floor(C_(u−1)/2) ≤ y_u ≤ C_u`, bez unsigned underflow/wrap na tej
wyprowadzonej domenie. Jest to whole-interval integer proof, nie interpolacja
finite samples. Kernel high_half_bound/horner_interval/final_positive_threshold
i fresh coefficient checks rozliczają każdy z12 steps.

W szczególności y12≥2^62+23552, więc
**Z≥2^54+92=18014398509482076**, a Beta_C(x)≥Zmin/2^55>1/2 (e0).
Nie użyto approximating exp(-r), remainder accuracy theorem ani dawnego9/20.

## 3. Normalizer

Accepted mass tego jednego source atom wynosi przynajmniej
pmin0*(1/2)*(Zmin/2^55)>1/256. Inne atomy mają nonnegative mass, więc
**A(mu,sigma)≥a_min=1/256** dla WSZYSTKICH required raw inputs. Exact mocniejszy
rational floor również zapisany w JSON, lecz eksportowany prosty bound to1/256.
To dowód pozytywności rzeczywistego integer rejection denominator w IID_BUFFER.
Nie oznacza pełnego proposal supportu returned law, nie ogranicza BadPrecast
i nie mówi nic o cryptographic randomness realnego PRNG.
