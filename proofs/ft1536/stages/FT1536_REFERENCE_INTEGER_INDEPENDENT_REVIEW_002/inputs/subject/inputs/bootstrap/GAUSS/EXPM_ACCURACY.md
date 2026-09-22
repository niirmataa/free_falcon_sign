# Source expm accuracy na rzeczywistym zakresie

Zakres: actual nonnegative rB∈[0,R] z REDUCTION_DOMAIN, R<7/10, obejmujący
63 buckets poza nominalnym literal log2. Ujemne wejścia samego expm mają
osobny countermodel; nie przenosimy na nie tego theorem.

Source mul(rB,2^63) jest exact power-of-two scaling dla positive normal rB:
mantissa mnoży się przez2^52, discarded product bits są zerowe, pack tylko
przesuwa exponent o63; wynik jest finite normal<2^63. rB+0 daje+0. Actual
rB nie jest subnormal (source add output normal albozero); można też dopuścić
subnormal jako extended input z trunc0, nadal theta error<2^-63.
Literal fpr_trunc w tej dodatniej domenie to floor. Rozszerzamy small-domain
argument IID z v<2^62 na v<2^63: przy1023≤ex≤1085 count1085−ex jest0..62
(nowy kernel positive_trunc_counts), m=2^62+fraction*2^10<2^63 i val(v)=m/2^count.
Shift daje floor także przy count0, a signed cast jest exact. ex≤1022 daje0
przez mask/shift, zgodnie z v<1. To jawny nowy endpoint, nie milcząca konsumpcja
węższego IID theorem. Zatem z=2floor(val(rB)*2^63) bez wrap,
theta=z/2^64∈[0,rB],rB−theta<2^-63.

Horner13 literal coefficients C,high64(z*y) source-exact z IID. Ponieważ
C są nondecreasing, z<2^64 i0≤y≤Cprev, high≤y≤Cprev≤Cnext. Subtractions nie
underflowują; nowy y∈[0,Cnext]. Ten invariant zachodzi nawet dla arbitrary
uint64 z, zatem zawsze y12≤2^63, Z=y12>>8≤2^55. Saturation above2^55 jest
niemożliwa dla TEJ recurrence, chociaż generic IID comparator formula ją zawiera.

P(t)=Σ_i=0^12 (-1)^i C_(12−i)t^i/2^63. Integer rounding error recurrence
E_i≤theta E_(i−1)+2^-63 daje E_H≤2^-63 Σ_i=0^11 R^i. Nierówności source
uint64/limbs i exact coefficient identities są rozliczone przed użyciem P.

Nowy exact QQ certificate: na256 cells całego[0,R] rozwijamy
D(t)=P(t)−Σ_i=0^24(-t)^i/i! w Bernstein basis24. Jej weights są nonnegative
i sumują się do1, więc minimum/maximum współczynników ograniczają WSZYSTKIE
t w cell. Power→Bernstein formula b_i=Σ_j≤i a_j*binom(i,j)/binom(24,j)
jest exact rational; nie dopasowanie do sample points. Taylor/Lagrange remainder
≤R^25/25! dla exp(-t),t≥0. Certificate podaje wszystkie endpoints/coefficient
extrema i outward rationals. Wynik **polynomial abs error≤2^-51**.

Dodajemy E_H,theta quantization<2^-63 i final >>8 error<2^-55 po skalowaniu
przez2^55. Literal source c_e=mul_C(of(e),log2) różni się od e*REAL log2 o
fresh RBF384 bounded amount; source rB=x−c_e jest exact w e≥1 buckets.
Dla e0 doliczamy harmless2^-1022. Dla e<64:

```
|Beta_C(x)/exp(-val(x))−1|
 ≤ exp(R+E_red)*E_count + exp(E_red)−1 ≤ 2^-44.
```

Source Z jest dodatni (P(theta) blisko exp(-theta)≥exp(-R)>0, z ujętym
integer error). e≥64 daje dokładnie0 i jest rozliczane przez cutoff-tail,
nie przez relative accuracy na usuniętych atomach. Wszystkie boundy są fresh
whole-domain instances, nie reuse komentarza lub sampled FPEMU audit limitu.

Extended rB=−2^-50 daje unsigned theta blisko1, zamiast continuation blisko0;
native word result/2^63≈0.367879, exp(-rB)≈1, gap>3/5. To zachowany NEGATYWNY
wynik dla extended expm domain, wykluczony przez proved rB≥0 actual reduction.
Nie clampowano reszty, nie poprawiono exponenta,coefficients lub programu.
