# Source FPEMU sqrt54, rozszerzone div i skalowanie

Model C99/GCC14.2/Linux LP64, uint64 wrapping, int32, arithmetic signed shift.
Active preprocessing potwierdza portable C1183–1256, nie CortexM4 asm.
Przypięte ROOT contracts add/sub/mul: finite |operands|≤2^100, error
U*scale+eta, U=2^-48,eta=2^-900, z source integer safety i finite outputs.
Nie zakładamy complete-IEEE arithmetic.

## 1. Sqrt — wszystkie dodatnie NORMALNE input words

Niech input significand m∈[2^52,2^53), true exponent E=ex−1023,
p=E mod2, h=floor(E/2), a=m*2^p. Source ma a∈[2^52,2^54), xu=2a,
q=s=0,r=2^53. Definiujemy mathematical integer N=a*2^54.

Przed KAŻDĄ iteracją zachodzi:

```
s=2q,  N=q²+r*xu,  q²≤N<(q+2r)²,
q+2r≤2^54, r>0.
```

Równanie (q+r)²=q²+r(2q+r) dowodzi, że comparison xu≥s+r wybiera dokładnie
poprawny następny bit. Dla r=2r' update jest q'=q+r lub q, xu'=2(xu−s−r)
lub2xu; inwariant i bracket zachodzą dla r'. Kernel Sqrt54 dowodzi obu
gałęzi, indukcji i osobnego final bit r1. runBits53 to dokładnie54 trials.

Z bracket i cap wynika xu<2^56, t=s+r<2^55, 2r≤2^54. Różnica xu−t ma
modulus<2^56<2^63, więc source `((xu-t)>>63)-1` jest all-ones iff xu≥t.
Nie ma overflow s/q ani utraty informacji w xu<<1; step_cap i końcowy
remainder bound obejmują również ostatni shift. Wszystkie r counts są
legalne; signed loop index0..54 mieści się w int. Kernel unsigned_trial_compare
wiąże word subtraction z integer branch. Source s-update zachowuje s=2q.

Po54 steps:

```
q²≤N<(q+1)²,  xu=2(N−q²),  2^53≤q<2^54.
```

Dlatego sticky bit jest dokładnie1 iff N≠q². `(xu|-xu)>>63` zachowuje ten
warunek także dla remainder0. Source mantissa M=2q+sticky jest w[2^54,2^55).
Exponent-zero mask jest1 dla ex1..2046. E mieści się w[-1022,1023], parity/
arithmetic shift daje E=2h+p, a pack bias b=h−54+1076∈[511,1533]. Nie ma
signed exponent overflow. SqrtPack dowodzi ponownie pack value dla bias≤2044,
zamiast ekstrapolować stare PackOf he≤1054; sqrt output jest positive finite.

## 2. Numerical enclosure z guard/sticky/pack

Niech r0=√N. Gdy remainder0, M=2r0. W innym przypadku q<r0<q+1 i
M=2q+1, zatem |M−2r0|<1. Source roundMant/0xC8 ma kernel bound
|4*roundMant(M)−M|≤2. Bezpiecznie |4R−2r0|≤4. Ponieważ2r0≥2^54,

```
|val(sqrt_C(x))−√val(x)| ≤ 2^-52 * √val(x).
```

Scaling jest dokładny: x=a*2^(2h−52), sqrt(x)=2√N*2^(h−54), a returned
word ma value4R*2^(h−54). Uwzględniono mantissa carry w pack. To dowód
source-bound, nie endpoint test lub założenie RN. W WIDTH_BOUNDS użyto
konserwatywnie większego U=2^-48. Publiczne testy dodatkowo porównały40930
words z niezależnym isqrt/RN oracle, lecz RN nie jest przesłanką proofu.

Sqrt(+0/−0) source daje+0 przez maskę. Dodatnie subnormal inputs NIE należą
do powyższego relative contract (source mask je zeruje); test preflight
oddziela tę domenę. Required stable D jest normal dzięki dolnym bounds.

## 3. Nowy div domain

```
finite |x|≤2^100, positive normal y∈[2^-16,2^80] ->
Defined(div_C(x,y)), finite normal or signed zero,
|val(div_C(x,y))−val(x)/val(y)| ≤ U*|val(x)/val(y)|+eta.
```

Mantissa loop i normalizer są DOKŁADNIE tymi z ROOT, bez zmiany source.
Kernel RootDiv.loop55 jest niezależny od exponent domains: U_m,V_m∈[2^52,2^53),
55 iterations, remainder<2V_m, remainder+quotient*V_m=2^55 U_m. Quotient
jest parzysty; sticky/optional right1 i pack dają relative error≤2^-51<U.
Wszystkie unsigned products/shifts/comparison ranges są te same.

Nowo rozliczony zakres: ey∈[1007,1103], normal ex∈[1,1123], pack bias
ex−ey+1021+w∈[-81,1138], output exponent≤1141<2047. Signed locals bez
overflow, pack_value_extended obejmuje positive branch. Underflow error
<2^-1021<eta. Dla numerator exponent0 source clamp daje0, a omitted quotient
<2^-1022*2^16=2^-1006<eta. Nie użyto dawnego y≤2^35 do większego e2.
Positive output dla potrzebnych stable/scale values wynika z ich lower bounds,
nie z twierdzenia, że arbitrary tiny numerator zawsze daje nonzero.

## 4. Domains stable i suffixu

W NORMALIZATION wyprowadzono przed instrukcjami stable scalar operands<2^72
i divisors<2^48 oraz positive lower>1/4 dla primary. Add/mul ROOT domain2^100
i nowy div domain obejmują je wszystkie. Exact half/double użyte są na normal
values daleko od exponent boundaries. Exact of3,of(q²=339775489),of768,of2
pochodzi z OF_EXACT/int32 caps.

Broad all-P_key stable D∈(1/4,2^31): sqrt source∈(1/4,2^16), zatem source
stored sigma∈(1/128,4096). Required sqrt/scale denominator jest positive
normal w rozszerzonym przedziale. Narrow emitted D jest w exact inclusive
gate; jego mocne width/paired/dss enclosures są w WIDTH_BOUNDS.json.

Source dss jest literalnym inv(mul(sqr(S),of2)). Nie zamieniono kolejności
na idealny wzór. Square/mul2 error daje denominator bounds
2*S²*(1±U)²±2^-800, a final div daje (1±U)/denominator±eta. Obie required
width classes są positive finite; dolny dss jest większy nawet od1/1536,
więc także od actual rounded bank coefficient. To sigma-only obligation.
