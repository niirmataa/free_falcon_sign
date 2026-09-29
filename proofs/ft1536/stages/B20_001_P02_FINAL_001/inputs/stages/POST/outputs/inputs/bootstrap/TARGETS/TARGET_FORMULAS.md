# Source words, rounded-value reference i idealne współrzędne

Autor projektu: Niirmata. N1536,q18433,Phi=X^1536−X^768+1, candidate56974571….
CanonicalChallenge oznacza każdy vector c∈{0,…,18432}^1536; bez center_q,
uniformity/independence lub przesłanki przyszłej norm acceptance.

## 1. Literalne funkcje Word i kolejność

Niech Cw=FFT3_C(map of_C c). Normalized certificate zachowuje dokładny
SourceFFT_B=[ghat,neg_C(fhat),Ghat,neg_C(Fhat)] w sk[0,6144).
ni=div_C(one,of_C(18433)), ni bits=**3f0c7161fb1566d0**.
Source target prefix wykonuje kolejno:

```
Cw := FFT3_C(of_C(c)) at t0
ni := inverse_of_C(q)
copy := memcpy(t1,t0,N words)
P1 := complex_mul_C(copy,b01)
t1 := per_word_mul_C(P1,neg_C(ni))
P0 := complex_mul_C(t0,b11)       -- t0 still equals Cw here
t0 := per_word_mul_C(P0,ni)
cut before ffSampling_fft3
```

Każdy source complex product to4 scalar mul i2 add/sub, nie fused operation.
Real slot i0..767 i imag slot i+768 stanowią jedną parę. Komentarz o implicit
zero t1 nie wykonuje żadnego loop. T1 jest initialized przez memcpy PRZED
multiplication, a kopiowany jest jeszcze niezmieniony Cw. Targets otrzymują
exact words tych funkcji, nie RN/host-double substitutions.

## 2. Rounding-only layer

Niech Ĉ_j to exact complex VALUE słów Cw, B01_j/B11_j wartości source basis.
Przy dokładnym rational1/q definiujemy

```
R0_j = Ĉ_j B11_j / q,
R1_j = −Ĉ_j B01_j / q.
```

To TE SAME rzeczywiste operands, z których source oblicza P0/P1. Reference
nie jest inverse rounded-basis matrix. Nie zakładamy, że jej determinant
wynosi q. Ni word ma exact value500372811634285/9223372036854775808,
absolute error403/170014416755344082468864 od1/18433 i normal positive class,
2^-15<ni<2^-14. Kernel TargetWords oblicza literal divC/ofC word i scaled
value; source binding/cross-check potwierdza rzeczywisty helper.

## 3. Ideal coefficient/root reference

Dla exact coefficient matrix B=[[g,−f],[G,−F]], detB=fG−gF=q w Q[X]/Phi.
Adjugate to[[-F,f],[-G,g]]. Zatem ROW coordinates [c,0] B^-1 są
[-cF/q,cf/q]. Algebra identities w kernelu i symbolic QQ certificate
sprawdzają determinant/sign convention. Nie użyto B^T M B lub centered c.

W physical root ζ_j=exp(2πi*r_j/4608), r_(3v+k)=1+6*rev8(v)+1536k:

```
T0_ref(j) = eval_j((-c*F/q) mod Phi),
T1_ref(j) = eval_j(( c*f/q) mod Phi).
```

Są to rational polynomials i ich complex evaluations. Nie ma redukcji modulo
q po dzieleniu, coefficient rounding ani normalizacji FFT przez1/N.
Evaluation jest homomorfizmem, ponieważ wszystkie physical roots zerują Phi.
Nowy all-coefficient symbolic checker odtwarza unscaled FFT map; source FFT
z rounding NIE jest uznana za funkcję liniową.

## 4. Actual execution i matching

P_key caps i normalized basis-preservation dają finite domains b01/b11.
Canonical c daje exact of. FFT_CHALLENGE_BOUNDS dowodzi domains/termination
wszystkich FFT statements przed ich wykonaniem. Reciprocal ma proved nonzero
denominator18433. Memory disjointness daje legal copy i chroni t0/sk podczas
całej gałęzi t1. Następne mul/scales mają ustalone wcześniej domains.
Finite loops oraz te local contracts prowadzą do actual cut; żaden completed
target prefix nie jest założony. TargetSequence to kernelowa kompozycja
partial operations; jego premises są instantiated przez niniejszy argument,
FFT/error certificate i MEMORY_FRAME, nie są dodaną przesłanką celu.

Word outputs mogą być signed zero; reference zero/cancellation ma absolute
error. Relative-only argument nigdy nie dzieli przez nieznane nonzero T_ref.
Te początkowe frequency targets nie są jeszcze scalar mu.
