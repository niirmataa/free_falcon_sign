# Nowy refinement imaginary ROOT/NODE3 — bez zmiany historycznych certyfikatów

Autor projektu: Niirmata. Ten lemat jest nowym wynikiem H3_NODE2. Konsumuje
przypięte ROOT/ANALYTIC_PROOF oraz NODE3/ANALYTIC_PROOF w ich mixed zakresie;
nie nadpisuje poprzednich liczb lub flag. Wszystkie dziedziny poniżej są
wyprowadzone dla dokładnie tego samego P_key.

## 1. Source root imaginary contribution

U=2^-48, eta=2^-900, gamma=8U. ROOT dowodzi dla exact Gram obliczonej FFT
macierzy a,c,j oraz source a0=g00_C,c0=g10_C:

```
a0 >=(1-gamma)*a, |c0| <=(1+gamma)*sqrt(a*j), j>=1/4,
|c0|<2^35, a0 in[1/2,2^23], j<=jmax.
```

Rzeczywisty Lroot ma dwie divisions c0.re/a0,c0.im/a0. Porównujemy go
teraz do **c0/a0**, nie do idealnego C/A ani do c/a. Są to te same computed
operands, więc imaginary część c0*conj(c0/a0) jest dokładnie0.

Z wyprowadzonego source div contract:
`|Lroot-c0/a0| <=U|c0|/a0+2eta` i
`|Lroot| <=(1+U)|c0|/a0+2eta`.
Source FPC_MUL/muladj error≤6U|c0||Lroot|+8eta. Zatem jego imaginary output pI
spełnia

```
|pI| <=(7U+6U²)*|c0|²/a0 +(2+12U)*eta*|c0|+8eta.
```

Nie użyto error boundu całego subtractive real Schur. Ponieważ
`|c0|²/a0 <=K*j`, K=(1+gamma)²/(1-gamma), j>=1/4, |c0|<2^35,
coefficient przy j jest co najwyżej
`r=(7U+6U²)K +4*((2+12U)*eta*2^35+8eta)`.
ROOT g11 imaginary to raw+0. Source neg/add daje jeszcze factor(1+U) ieta,
więc nowy imaginary coefficient to `(1+U)*r+4eta <8U`, sprawdzone dokładnie QQ.
Nie założono raw zero-preservation ani IEEE rounding dla tego kroku.

**Uniwersalnie |Im(D_ROOT_C)|<8U*j<=8U*jmax<1.**
Piny source operands/domains pozostały te same. Numeric certificate podaje
dokładny rational coefficient i 8U*jmax=2653737706650536509441/4722366482869645213696.
Nowa liczba nie została wybrana na podstawie kontroli C.

## 2. Przeniesienie do trzech diagonal NODE3

NODE3 source split_top ma norm error<1/16 dla branch1. Idealny imaginary
component t0 to średnia trzech root imaginary values; z nowego |ImDroot|<1
otrzymujemy **|tau=Im(t0_NODE3)|<17/16**.

NODE3§6, z jawną real-slot semantyką, już wyprowadził dla actual-input
Hermitian H i h=Re(t0):
`|Im(d11_NODE3)-tau|<64U*h` oraz ten sam bound dla q2_C (pierwszej części d22).
Końcowy tmp imaginary jest raw+0; q2_C powstaje przez FPEMU add, więc jest
normal/zero. Dlatego source sub(q2_im,+0) zachowuje jego raw bits w TYM
upstream miejscu i Im(d22_NODE3)=Im(q2_C).

Używając NODE3 h<T1=2^33:

```
branch1: |Im(t0)|<17/16,
         |Im(d11)|,|Im(d22)|<17/16+64U*2^33=545/512.
```

Dla branch0 tau jest raw+0; h<T0=2^24:

```
branch0: Im(t0)=raw+0,
         |Im(d11)|,|Im(d22)|<64U*2^24=1/262144.
```

To wykorzystuje silniejsze source-to-H oraz wspólne tau, zamiast dawnego
coarse I+65536U*T. Wszystkie NODE3 operations poprzedzają nowy half;
nie przenosi się raw-preservation na nieudowodnioną klasę po half.

## 3. Instancja na required support

Emitted_C+same STATIC decode→P_key pochodzi z odebranego ROOT bindingu.
NODE3 source-domain/error premises są rozliczone dla każdego P_key i obu
branches. Powyższe uses mają te same source pins i mieszczą się w domains:
root numerator/denominator i mul inputs są wcześniej ograniczone, NODE3
divisor h oraz jego typed error bounds są proved. Nie dodano małego imag
lub nowych gates do P_key.

Nowy refinement umożliwia przejście do prostszego lokalnego nadzbioru:
każde wybrane source v_k ma real≥1/8 albo8 i powyższy imaginary bound.
Dla każdej pary zachowuje się RÓŻNICĘ tau_a−tau_b, a jej modulus jest≤2I.
Nie zakłada się tau_a=tau_b. Parametric pair proof i jego sześć instancji
znajdują się w ANALYTIC_PROOF/certificate.py.

## 4. Kontrola zakresu wyniku negatywnego

Publiczna para9+34i,9−34i mieści się w dawnym coarse branch1/k2 boxie.
Jej idealny determinant to81−34²=−1075, pivot−1075/9; rzeczywisty C też
zwraca ujemny pivot. Divisor s0=9 jest legalny, więc kontrola nie wykonuje UB.
To **COUNTERMODEL_COARSE_NODE3_BOX_ONLY_NOT_P_KEY_OR_EMITTED**. Para nie
spełnia nowo dowiedzionego refinementu; nie jest świadkiem required-domain
naruszenia nowej tezy lub globalnego H3.

Source/model/compiler boundary pozostaje jawnie analityczny. Dodatkowe
768 C root-imaginary controls, z independent dyadic bounds, wspierają binding;
nie zastępują argumentu uniwersalnego.
