# Joint reference BadPrecast bound — wszystkie coefficients i oba znaki

Fix required e i legal entry PAST. Źródłowo domknięte V,E,C_MGF są w
VARIANCE_BRIDGE/ERROR_LEDGER/CONDITIONAL_MGF JSON, z outward QQ/RBF instancjami.
Nie są nowymi desired premises. Dla każdego row r w obu1536-vectors,
L_r=Σa_r,i xi_i,d_r=0, i |source_t_r−L_r|≤E.

Conditional MGF wraz z exponential Markov/Chernoff, dla theta>0:
Q_S(L_r≥M)≤C^3072 exp(theta²V/2−theta M). Ta sama inequality dla−L_r
używa t_i=−theta a_i, bez symetrii/mean-zero assumption. Optimum theta=M/V,
M=32767.5−E, jest dodatnie (V>0,E<1095<32767.5).

Rint-event inclusion i union po **3072 coefficients ×2 znaki** dają:

```
q_e=Q_S(B_e|entry PAST)
 <= beta_exact = 6144*C_MGF^3072*exp(-(32767.5-E)^2/(2V)).
```

JOINT_TAIL_BOUND.json podaje expression,all rational inputs,log-prefactor,
theta i outward rational beta z512-bit interval exp. Najmocniejszy zapisany
outward rational jest tam dostępny; prosty eksport:

**q_e ≤ 2^-119**, uniform po wszystkich required e/PAST, w **Q_S**.

Wartości pomocnicze: V<5462457,E<1095. Wyliczenie używa pełnych dokładniejszych
rationals zamiast tylko tych ceilings. Union bound nie wymaga independence
coefficients,vectors lub innovations. Wartości d0,V,E nie wzięto z sample maxima.

Q_S jest zawsze live; dla Q_stop event B wykluczaEXIT i pointwise live
domination daje także Q_stop(B)≤beta. Nie doliczamy ponownie support-exit
kosztu. B∪EXIT,whole-call survival conditioning i whole Sign są innymi typami.

Coarse independent product error≥3.68e9 nie dawał dodatniego marginesu,
a więc dawał tylko1. To zachowany za luźny bound,nie kontrprzykład. Użycie
POST energy10436770873344 jako variance byłoby nieuzasadnioną zmianą typu.
Nowy coefficientwise metric/Cauchy argument domyka właściwą source instancję.
