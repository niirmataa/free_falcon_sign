# Conditional Gaussian MGF z normalizerami i lokalnym support conditioning

Gra/reference: IID_BUFFER/Q_S. Fix dowolny required entry e i legalny value
prefix h. Gaussian ma m=val(actual mu_h),v=val(actual sigma_h)^2, nie Ghat.
Y|h∼G_(m,v) conditioned on S_h, mass t_h≤tau z GAUSS/JOINT. Mean parameter m
nie jest zakładany jako dokładna E[Y]. Nie zakładamy independence innovations.

## 1. Discrete Gaussian normalizer dla wszystkich shifted means

Z(m,v)=Σ_z∈Z exp(-(z−m)^2/(2v)). Gaussian jest Schwartz dla v>0. Standardowa
Poisson identity (Fourier transform Gaussian, absolutely convergent series):

```
Z(m,v)/sqrt(2*pi*v)=1+2Σ_n>=1 exp(-2*pi²*v*n²)*cos(2*pi*n*m).
```

Actual normalized widths dają v≥vmin=min(stored/paired real_square_lower)>1.
Dla c=2*pi²*vmin>0 i n≥1, iloraz kolejnych exp(-c*n²)≤exp(-3c).
Zatem absolute nonzero modes≤rho=2exp(-c)/(1-exp(-3c)). Fresh RBF512
z exact rational vmin daje outward rho<2^-48. Remainder nie jest ucięty
bez kosztu. Dla WSZYSTKICH real m,m' i każdego actual v:

```
Z(m',v)/Z(m,v)≤(1+rho)/(1-rho).
```

Positivity denominator wynika z rho<1. To uniform-in-center argument,
nie histogram albo grid extrema. Fourier/Poisson/real integral krok jest
jawną analityczną warstwą poza Lean/Std; scaled algebra ma kernel checks.

## 2. Actual parameter-centered innovation

Dla xi=m−Y, completing square daje dla dowolnego real t:

```
E_G exp(t xi)=exp(t²*v/2)*Z(m−t*v,v)/Z(m,v).
```

Shifted mean m−t*v może być poza NumericCenter: jest wyłącznie argumentem
matematycznego normalizera, nigdy source call/cast. Stosunek nie jest zastąpiony1.
Na Q_S wszystkie summands są dodatnie, więc

```
E_QS[exp(t xi)|h]
 ≤ C_MGF exp(t²*v/2),
C_MGF=(1+rho)/(1-rho)/(1-tau),
```

gdzie tau jest dokładnym odebranym rational upper bound t_h,nie nowym η_pre.
Local support normalization jest policzone raz. To nie Q_stop conditioned on
whole-call survival i nie theorem o dowolnych reference byte generators.

## 3. Adaptacyjne złożenie

Dla ustalonego coefficient row r, wszystkie a_e,r,i oraz sigma_i są entry-fixed
przez immutable tree/basis i actual call order. mu_i jest adapted do source
filtration. Podstaw t_i=theta*a_i w conditional lemma i iteruj tower property
po3072 draws. Otrzymujemy bez independence i bez mean-zero:

```
E_QS exp(theta Σ_i a_i xi_i)
 ≤ C_MGF^3072 exp(theta² Σ_i a_i² sigma_i²/2)
 ≤ C_MGF^3072 exp(theta² V/2).
```

Nie wybieramy row/weights po zobaczeniu przyszłego Y. Dla każdego fixed row
stosujemy ten sam uniform bound; joint event domyka późniejszy union bound.
SOURCE_NOISE_MAP d0 jest osobnym deterministic theorem, nie mean-zero premise.
History-dependent bounded roundoff delta nie jest traktowane jako niezależny
martingale noise: przechodzi przez pointwise error-to-tail implication.

## Kontrole

RBF384 low-dimensional reference odtwarza1209 atoms actual local terminal
paired→updated-stored sequence, z exact source support i actual word centers.
Wykazuje niezerowe conditional innovation means i rozbieżność joint MGF z
iloczynem unconditional innovation marginals. Świadek normalizer ratio
Z(0,v)/Z(1/2,v)>1 (około1+2.30e-15) obala ratio=1. Osobny toy support{0,1}
obala generic pominięcie support-normalization factor. Scope local/toy jawny;
nie są emitted keys ani proofem uniform supremum. Exact two-point probability
control osiąga equality w forward event-transfer Cauchy-Schwarz.
