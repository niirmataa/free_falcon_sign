# Source weights → główny untruncated Gaussian: TV i forward chi2

Zakres IID_BUFFER/D_env/PAST z CLAIM. Wszystkie constants poniżej są actual
outward values w ERROR_LEDGER.json, z source instancjami podanymi w zależnościach.
Nie ma założenia small epsilon lub A≥9/20.

## 1. Wagi i source errors

Niech p=p_j,q=q_j,H=H_j,dhat=val(dss),mhat=s+val(r), d=1/(2val(sigma)^2).
Pary(k,b) są bijekcją na y∈Z. Oznacz
rhohat_y=q(k)/2 exp(-Xhat)=exp(-dhat(y-mhat)²)/(2H),
rho_y=exp(-d(y-m)²)/(2H), C=Σrho=Z_G/(2H), Chat=Σrhohat.
G=rho/C pozostaje niezależnym głównym celem, Ghat=rhohat/Chat jest osobne.

D_j={s-K_j,...,s+K_j+1}. Na D_j:
|x_C−Xhat|≤ec i |d(y-m)²−dhat(y-mhat)²|≤ep z per-bank source ledger.
Na F⊆D_j, gdzie e_C<64, źródłowy BerExp daje relative error eb względem
exp(-val(x_C)). Wobec tego

```
|Beta_C/exp(-Xhat)-1|≤eh=(1+eb)exp(ec)-1,
|Beta_C/[exp(-Xhat)*exp(-(d(y-m)²-dhat(y-mhat)²))]-1|
 ≤eg=(1+eb)exp(ec+ep)-1.
```

Oba znaki błędu obejmuje e^|error|−1; nie sumujemy różnych miar bez transportu.
Auxiliary v_y=q(k)/2*Beta_C na k≤K,0 poza. Actual w_y=p(k)/2*Beta_C.
Na cutoff e≥64 oba v,w0. Wartości Beta poza finite source support definiujemy
wyłącznie jako mathematical0; nie wykonujemy source na unbounded k.

## 2. Uniform normalizery i infinite tails

Dla f(x)=exp(-d(x-m)²), total variation funkcji to2. Podziel R na cells
[n−1/2,n+1/2]. Integracja |f(n)-f(x)| po każdej cell daje≤(1/2) integral
|f'| po niej; po sumowaniu **|Z_G−sqrt(pi/d)|≤1**, dla każdego real m.
To uniwersalny integral comparison, nie minimum na sample grid.

True d≤d_hi/(1-eps_d). H≤H_hi. Fresh RBF/QQ rows sprawdzają dla OBU width
classes i wszystkich5 banks:
(sqrt(pi/[d_hi/(1-eps_d)])−1)/(2H_hi)>1/4.
Analogicznie Chat>1/4. Wszystkie denominatory positive; µ/mean nie jest
ograniczony do wybranych fractional sample positions.

Poza D_j, exact rho_true=m−s∈[0,1], więc |y−m|≥k i d≥a_j/(1+eps_d).
T_prop upper na unnormalized rho-tail:
`2 exp(-d_lo(K+1)^2)/[1-exp(-d_lo(2K+3))]/(2H_lo)`.

Na D_j\F source x≥x_first(64) z whole-word monotone brackets. Z Xhat≥x−ec
i parameter error ep wynika
rho_y≤q_j(k)/2 * exp(-x_first(64)+ec+ep).
Sumowanie q/2 po obu znakach to1, dlatego **T_cut≤exp(-x_first(64)+ec+ep)**,
bez mnożenia empirical frequency lub założenia idealnego rejection law.
T=T_prop+T_cut obejmuje CAŁE Z\F. Nie zgubiono cutoff ani nieskończonego ogona.

## 3. L1, accepted normalizer i TV

Beta_C≤1, więc Σ|w-v|≤L1(p,q)=L. Na F, |v-rho|≤eg*rho, a poza F v0.
Zatem δ=Σ|w-rho|≤L+eg*C+T. Skoro C≥1/4:
η=4L+eg+4T≥δ/C i |A/C−1|≤η, A=Σw.
Rational certificate ma η<1 i A≥(1-η)/4>**1/8**.

Triangle i |A-C|≤δ dają
TV(w/A,rho/C)≤δ/A≤η/(1-η). Exact outward certificate yields
**TV(K_C,G)≤2^-36**. Nie jest to maksimum101 kontrolnych PMFs.

## 4. Forward chi-square

Na F, source/source-table perturbation spełnia
Σ(w-v)²/rho≤exp(ep)(1+eh)²*chi2(p||q), gdyż Xhat≥0 przez first-bank dss≥a.
Dotyczy też d slightly below a: ten transport jest jawnie w exp(ep), nie
fałszywym założeniu true d≥a. Poza finite support (w-v)=0.
Drugi składnik: Σ(v-rho)²/rho≤eg²*C+T. Używając(a+b)²≤2a²+2b² i C≥1/4,

```
E=Σ(w-rho)²/rho / C
 ≤8 exp(ep)(1+eh)²*chi2(p||q)+2eg²+8T.
```

Normalization identity:
chi2(w/A||rho/C)=[E-(A/C-1)²]/(A/C)² ≤E/(1-η)².
Kernel GaussianMetrics.normalization_variance_identity dowodzi cleared
polynomial identity; actual positive real weights/sums są instancjonowane
tutaj. Outward exact certificate yields **chi2(K_C||G)≤2^-60**.

## 5. Oddzielny transport i likelihood

ERROR_LEDGER podaje także TV(K_C,Ghat) i TV(Ghat,G). Dla drugiego na D_j
normalized conditional density ratios są w[exp(-2ep),exp(2ep)]; outside
window tails obu praw są jawnie bounded. Stąd
TV(Ghat,G)≤exp(2ep)-1+8T_prop. Main bound wyżej używa ciaśniejszego direct
weight transport+jednej normalizacji, nie utożsamienia Ghat z G.

Forward likelihood K_C/G≤(max p_j/q_j)*(1+eg)/(1-η), z actual finite table
ratio certificate. Mała chi2 nie oznacza pointwise ratio≈1 na najrzadszych
quantized atoms. Reverse direction/support opisano w SUPPORT_AND_METRICS.
