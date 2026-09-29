# Coefficientwise source variance proxy — orientacja i instancja

Ten theorem jest o deterministycznych coefficients a_e,r,i i Gaussian VARIANCE
PARAMETERS val(sigma_i)^2. Nie zakłada rzeczywistej covariance/independence lub
exact mean-zero adaptive innovations. Wszystkie source constants/inequalities
w VARIANCE_BRIDGE.json wyprowadzono dla wymaganych entries, nie dopasowano V.

## 1. Metric source-L / stable-D

Konsumujemy LEFT/METRIC_BRIDGE ze wszystkimi source ROOT/NODE3/TOWER
split/imaginary/LDL/pivot factors. Dla real root spectra A0 i Re(Droot):

```
Q_A0(u*) ≤ kappa0 Σ_left D_l Q_A2(r_l),
Q_ReD(y*) ≤ kappa1 Σ_right D_l Q_A2(r_l).
```

u*,y* są EXACT source-L reconstructions, Q_r=(1/768)Σ_j r_j|eval_j|².
Kappa0<2,kappa1<6; używamy mocniejszych rational metric_to_stable_factor,
nie tylko ich ceilings. Ta orientacja wynika z Q_parent≤S_raw/l oraz
S_raw≤r*S_stable. Raw L to actual source, stable D to osobne actual weights
w tej SAMEJ physical leaf order. Nie ma raw-L=ideal LDL ani raw/stable identity.

## 2. Root triangle i actual rounded basis

B0=(b00,b01),B1=(b10,b11),a=||B0||²,c=B1 B0*,j=||B1||²,v=det B.
ROOT daje |v−q|≤dc,|A0−a|≤8Ua oraz
|Re(Droot)−|v|²/a|≤256Uj, |L_C−c/a|≤32U sqrt(j/a).
W szczególności v NIE jest podstawiany jako dokładne q.

Dla z=(u*−y*L_C,y*) output image ma norm
`||u*B0+y*(B1−L_C B0)||²`.
Orthogonal decomposition B1=(c/a)B0+Borth i Young z alpha=1 dają

```
image² ≤c0*A0|u*|²+c1*Re(Droot)|y*|²,
c0=2/(1−8U),
c1=[1+2(32U)²*jmax*amax/(q−dc)²]/(1−beta),
beta=256U*jmax*amax/(q−dc)²<1.
```

Po Parseval/average i branch metric bounds:
`Q_out(BRec(r)) ≤ M Σ_all leaves D_l Q_A2(r_l)`,
M=max(kappa0*c0,kappa1*c1)=6.94587278329...<8.
M jest literalnym outward source instance, nie scalar gain77565 podmienionym
na covariance. Q_out jest sumą A2 quadratic forms obu coefficient vectors.

## 3. Terminal paired factor i actual widths

A2=[[1,1/2],[1/2,1]]. T(x0,x1)=(x0−x1/2,x1), więc
T^T A2 T=diag(1,3/4). Na source leaf D,stored sigma0=div_C(768,sqrt_C(D)),
paired sigma1=mul_C(IW1I,sigma0), ten SAM D w obu calls. Odebrany sqrt relative
bound2^-52,div/mul U/eta i literal IW1I dają:

```
D*sigma0² ≤ cw*768²,
(3/4)*D*sigma1² ≤ cw*768²,
cw=max(((1+U)/(1-2^-52)+eta)^2,
       (3/4)*[(1+U)*IW1I*((1+U)/(1-2^-52)+eta)+eta]^2)
 <1+2^-45.
```

Dmax<768² pozwala włączyć absolute eta po pomnożeniu sqrt(D)/768. Wszystkie
denominatory/positive domains są z NORMALIZED gate,nie nowym gate P_key.

## 4. KAŻDY coefficient row

Niech F mapuje z_i na output gdy xi_i=sigma_i*z_i. Z powyższych inequalities
Q_out(Fz)≤M*cw*768² ||z||² dla WSZYSTKICH real z. Dla dowolnego coordinate r,
A2 daje3(Fz)_r²≤4Q_out(Fz) (inverse A2 diagonal4/3). Wybierając
z_i=a_e,r,i*sigma_i, otrzymujemy V_r²≤V*V_r,V_r=Σ_i a_e,r,i²sigma_i²≥0,
więc V_r≤V=(4/3)M*cw*768². To elementary dual/operator norm argument,
nie założenie covariance i nie supremum po kilku matrix rows.

Exact QQ/RBF outward V jest w JSON; **V<5462457** dla wszystkich3072 rows,
obu vectors,wszystkich required e. Operator algebraic extension do arbitrary
real z nie wykonuje source na unbounded samples. Source domain/error theorem
dotyczy tylko właściwych positive-support histories.

Controls independently check transpose/direct inverse/closed constant-basis
formula; zmiana A2 na Euclidean lub paired variance na stored traci factor.
Rounded root L differs od ideal c/a także w local constant fixture. Wymagane
source instance wyżej konsumuje wszystkie actual correlations i ich błędy.
