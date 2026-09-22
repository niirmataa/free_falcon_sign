# Support, survival factors i jawna strata exit

S_h jest finite nonempty positive K support, nie całym proposal window.
Specyfikacja: n_j,k>0,e_C(k,b)<64,y=s_C+z(k,b); GAUSS wyprowadza Z>0.
Poza S mogą występować source table holes i forced cutoff atoms, a także
nieskończony Gaussian tail. Wszystkie zostały ujęte w odebranym tau:

```
tau = 25108406941893570520985316636436632133419632284097977125243
    / 115792089237316195423570985008687907853269984665640564039457584007913129639936.
```

To dokładny rational z GAUSS/ERROR_LEDGER.json,
entries.G_mass_outside_positive_K_support_upper. Każde0<t_h=G_h(S_h^c)≤tau<1.
Positive lower t_h pochodzi z G_h(s_C+367)>0 i braku tej wartości w source
support, nie z zaokrąglonej tail estimate. Nie zakładamy, że to y powoduje UB.

Na live paths D(y)=Π_i(1−t_hi). Q_stop(live y)=Q_S(y)D(y), więc

```
Q_stop(EXIT)=1-E_QS[D]
            <=1-(1-tau)^3072 <=3072*tau <2^-50.
```

Pierwsza inequality pointwiseD≥(1−tau)^M; druga to Bernoulli/union bound,
nie independence survival factors. Exit event jest rozłączną sumą first-exit
cylinders, o massQ_stop(prefix h)*t_h. Gdy prefix już wyszedł, nie stosujemy
następnego local kernelu ani domain theorem.

Ponieważ0≤Q_stop(live y)≤Q_S(y), L1 różnicy na live paths to exit mass, a na
EXIT atoms również exit mass. Dlatego **TV(Q_S,Q_stop)=Q_stop(EXIT)** dokładnie.
W obu P_VALUE,Q_S EXIT ma probability0. P≪Q_stop, lecz Q_stop≪P jest fałszywe:
EXIT ma positive Q_stop mass już w pierwszym draw. Zatem reverse chi2∞.

Inaczej z Q_S: każde jego live y ma także positive P mass, i odwrotnie.
Lokalne i pełne supports są równe. Forward chi2 zmniejsza się pod właściwym
conditioning identity z JOINT_COMPARISON. Reverse nie jest∞ przez argument
dotyczący Q_stop. Można wyprowadzić bardzo luźną skończoną majorantę z D=2^264
possible proposal byte atoms; nie odzyskujemy małego reverse boundu.

Conditioning całego Q_stop na survival zmienia wagi o history-dependentD(y).
Countermodel TV1/10 jest zachowany. Nie stwierdzamy równości lub nierówności
tych dwóch praw dla wszystkich konkretnych emitted entries na podstawie
samego toy example; obalamy generic identity, której nie wolno użyć w dowodzie.

EXIT pozostaje proof-only tag. Gdy source sampler rzeczywiście działa w IID,
zwraca tylko S_h i nigdy tego tagu. Nie dodano abortu,clippingu,limitów na y
do oryginalnego C ani nowych key gates/conditioning na norm success.
