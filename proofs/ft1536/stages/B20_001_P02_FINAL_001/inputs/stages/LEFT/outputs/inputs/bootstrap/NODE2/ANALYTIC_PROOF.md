# H3_NODE2 — pierwszy binarny step po NODE3

To dokładnie split_deep(logn9), Adj(logn8,full0), LDL_dim2(logn8,full0),
dla 2*3*128 positions. P_key jest niezmienione. Proof mixed: kernelowe
half/identity/constant/frame lemmas, uniwersalne source/error argumenty
analityczne i exact QQ/RBF certificates. Pełnego C/compiler theorem nie
kernelizowano; local positive result nie obejmuje całej niższej recursion.

## 1. Dane wejściowe, refinement i porządek

Z NODE3 bierzemy source arrays(t0,d11,d22), każdy512 words, real j/imag j+256.
UPSTREAM_REFINEMENT dowodzi nowych I_{b,k} przy tych samych source pins:

```
I_0 = (0, 1/262144, 1/262144),
I_1 = (17/16, 545/512, 545/512).
```

Wspólne niższe real bounds m0=1/8,m1=8; upper R0=2^25,R1=2^34. Są
wnioskami P_key, nie added premises. Complex caps B0=2^26,B1=2^35.
Source-to-H/tau records nie zostały zastąpione samymi dawnymi boxes:
nowy imaginary refinement jest niezbędnym dodatkowym wyprowadzeniem.
Do split→div→computed pivot dochodzimy w tej kolejności.

## 2. Rzeczywisty half na wszystkich finite words

Header165–174 najpierw odejmuje2^52 modulo2^64, oblicza flagę z exponentu
tego wyniku, a następnie maskuje cały word. Half.half_bits dowodzi w kernelze:
half_C(x).bits=0 gdy input exponent0, inaczej x.bits−2^52. Half.half_fields
wiąże exponent/fraction/sign; half_value i half_error_units wiążą pełną
niezależną interpretację valueNum/2^1074.

Dla znaku s, exponentu e i fraction f:
- e=0: oba zera i WSZYSTKIE subnormals mapują do raw+0;
- e=1: output ma te same s,f, lecz exponent0; przy f=0 jest signed zero,
  przy f>0 subnormal. Jego wartość to(-1)^s f*2^-1074, nie zwykłe RN(x/2);
- e>=2: exponent jest zmniejszony o1, sign/fraction zachowane; value exact x/2.

W e=1 difference względem x/2 ma modulus(2^51−f/2)*2^-1074≤2^-1023.
W e=0 modulus<2^-1023, w pozostałych0. Zatem dla każdego finite word:
**half output finite i |val(half_C x)−val(x)/2|≤2^-1023**.
Kernel dowodzi równoważnego scaled bound
`|2*valueNum(half_C x)-valueNum(x)|≤2^52`. Pary finite/class hypotheses
są jawne przy interpretacji tych integer numerators. Nie przyjęto complete IEEE.

Half może wyprodukować subnormal ze źródłowego normal. Nie korzystamy
więc z raw-preservation sub(x,+0) dla nowych split outputs. Ogólne inherited
add/mul/div contracts obejmują finite exp0 z policzonym eta, a nie tylko normals.
Oddzielne kontrole raw bits pokazują: minnormal+1ulp → minimum subnormal,
a kolejne sub(+0) może wyzerować tę wartość.

## 3. Mapa split_deep i exact reference

NODE3 parent roots mają order1536, exponents1+6 rev8(j). Dla pary j=2f,2f+1
są to x i−x, x=exp(2πi(1+6 rev7(f))/1536). Użyty square twiddle256+f jest
przybliżeniem x; source bierze jego conjugate. Child root x² ma order768,
exponent1+6 rev7(f);128 wybranych roots plus conjugates daje dokładnie roots
X^256−X^128+1. Child real f,imag f+128. RBF256 sprawdza wszystkie128 pairs,
component error<eps=2^-50 i wiązanie mapy do przypiętego NODE3 certificate.

Idealny limit źródła:
`s0=(v_a+v_b)/2`, `s1=conj(x)*(v_a-v_b)/2`, potem Adj(s1).
To p(X)=p0(X²)+X p1(X²), bez dodatkowej normalizacji. Dla realnych dodatnich
a,b independent reference ma h_ref=(a+b)/2,
L_ref=x*(a-b)/(a+b), D_ref=2ab/(a+b). Norm L_ref≤1, reference positive.
Te wzory nie zastępują source operations lub subtractive d11.

## 4. Źródłowy split error i parametryczny paired margin

U=2^-48,eta=2^-900; inherited add/sub/mul mają cap2^100, a div domain
[1/16,2^35]. Half error2^-1023<eta jest wyprowadzony powyżej. Complex add
norm error≤U(|v_a|+|v_b|)+2eta. Przy |v|≤B, e_add=2UB+2eta.
ROOT CM component lemma i complex half dają

```
error s0 ≤e_add/2+2eta,
error s1 ≤CM(2B,e_add,eps)+2eta,
CM(M,e,d)=2Md+2e(1+d)+6U(M+e)(1+d)+4eta.
```

Exact QQ comparisons dowodzą obu norm errors<delta=B/2^40:
delta0=1/16384,delta1=1/32. Adj jest exact value sign flip i zachowuje normę.
Split działa literalnie add/half, sub/mul/half; nie przez harmonic formula.

Pisz v_a=r_a+i*tau_a,v_b=r_b+i*tau_b. Idealny paired Hermitian comparison
ma real h0=(r_a+r_b)/2 i lower z=conj(s1). W szczególności:

```
|z|²=((r_a-r_b)²+(tau_a-tau_b)²)/4,
h0²-|z|²=r_a*r_b-(tau_a-tau_b)²/4.
```

Tożsamość jest sprawdzona symbolicznie nad QQ i w integer kernel lemma.
Różnica tau NIE jest usuwana. Jeśli r_a,r_b≥m, |tau_a|,|tau_b|≤I, to
determinant≥m²−I² i min eigenvalue≥m−I (trójkąt w |z|).
Actual H ma diagonal h=Re(s0_C), lower u1_C=Adj(s1_C), upper conjugate.
To proof object, nie zmiana source. Entry errors≤delta, operator norm≤2delta.
W sześciu instancjach exact QQ dowodzi

```
m_b-I_{b,k}-2delta_b >lambda_b,
lambda0=1/16, lambda1=4.
```

Stąd actual H≥lambda I i h≥lambda PRZED division. Coarse real upper h<T,
T0=2^26,T1=2^35, wynika osobno z positive real add i half:
h≤(1+U)R+eta<T. Real add input/output jest daleko od najmniejszej normalnej;
finiteness half jest już udowodnione niezależnie. Tą metodą nie rozciągamy
div-domain: istniejące[1/16,2^35] wystarcza na TYM poziomie.

## 5. Source L i rzeczywisty subtractive Schur

H positive z równymi diagonals daje |u1_C|≤h. Direct two scalar divisions
produkują L_C, z norm error≤U+2eta<2U wobec L_H=u1_C/h i norm L_C<2.
Numerators≤h<T≤2^35, denominator h w proven domain; obie divisions finite.
Source muladj u1_C*adj(L_C) ma error względem real |u1_C|²/h mniejszy niż
`rp*h`, rp=U+2eta+6U(1+U+2eta)+8eta/lambda.

Następne neg/add do rzeczywistego g11=s0_C, z tau=Im(s0_C), daje

```
|Re(d11_C)-D_H| <64U*h,
|Im(d11_C)-tau| <64U*h,
D_H=h-|u1_C|²/h>=lambda.
```

Dla imag użyto |tau|≤I+delta<lambda≤h i OGÓLNEGO finite add contract,
także kiedy tau po half jest subnormal. Nie zastosowano raw zero identity.
Żadne przyszłe computed d11 nie jest tu założeniem wcześniejszego div.

Weryfikowane64U*T<lambda/2 daje positive normal computed pivot:
`Re(d11_C)>lambda/2`, upper<2T. L/d11 outputs są normal/zero przez primitive
contracts; s0/s1 mogą dodatkowo mieć subnormal imaginary/components po half.
Wszystkie intermediate scalar operands mają cap2^100 zanim użyto error lemmas;
split temporaries<2^40, L<2, muladj norm<4T≤2^37.

Wnioski uniform:
- branch0: s0 real≥1/16,<2^26; d11 real≥1/32,<2^27;
- branch1: s0 real≥4,<2^35; d11 real≥2,<2^36;
- norm L<2; imag s0/d11≤1/8192 (b0),≤9/8 (b1).
Ostatnie wynika z I+delta+64U*T. Pivots są normal, nie tylko positive values
idealnego modelu. Następny poziom ma własny denominator-domain obligation.

## 6. Błędy do NIEZALEŻNEGO reference

E_{b,k} to NODE3 norm error t0/d11/d22 do dokładnych real diagonals
(e1/3,e2/e1,3abc/e2) w appropriate A lub q²/A spectrum. Dla nowego exact
binary split entry error jest e=E_{b,k}+delta. H_ref jest positive Hermitian,
norm L_ref≤1; H też ma norm L_H≤1. Quotient identity daje
`|L_H-L_ref|≤min(2,2e/lambda)`.

Schur variational characterization, z minimizer vector norm²≤2 dla obu
macierzy i matrix error norm≤2e, daje `|D_H-D_ref|≤4e`. Nie wymaga małego e.
Dodając actual source errors i imaginary component:

```
L error ≤min(2,2e/lambda)+2U,
complex d11 error ≤4e+I+delta+2*(64U*T).
```

Dokładne QQ porównania produkują sześć stałych:

| b | k | L norm error | complex d11 error |
|---|---|---|---|
|0|0|<1/16|<1/128|
|0|1|<1/2|<1/16|
|0|2|<3|<1|
|1|0|<3|<2^25|
|1|1|<3|<2^28|
|1|2|<3|<2^32|

Luźniejsze reference errors nie są podstawą positivity; stronger actual-H
error64U*h i paired margins pozostają w eksportowanym rekordzie.

## 7. Zakres, binding i dalsza granica

Wszystkie argumenty są uniwersalne po P_key, b∈Fin2,k∈Fin3,f∈Fin128.
Jeden c2 ma sześć fixed rational records; validity positive denominators
jest sprawdzana kernelowo, a pola wiąże QQ certificate. Własny parametrized
paired-step lemma powyżej jest rzeczywiście instancjowany, nie pozostawiony
z unknown imaginary/pivot premise. Pełnego remaining tree nie wyprowadzono.

NODE2_FRAME opisuje source lifetimes/repeated input alias i earlier recursive
call inner(logn8). Frame dla defined prefixes nie jest jego totality proof.
Źródłowy C/model/ABI binding pozostaje jawny; pełna error/complex-matrix
kompozycja jest analityczna z exact certificates. Finite C/Lean/QQ/RBF
controls nie zastępują uniwersalnego dowodu. Bez zmiany C, P_key lub M0.
