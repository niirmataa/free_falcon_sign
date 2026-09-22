# Root gain i literalny U=t0+CM_C(z1,Lroot)

Snapshot t0 jest tym samym source targetem z TARGETS; right recursion go
zachowuje. Z1 i Lroot są actual words po right return i w immutable tree.
Root update1818–1820 używa CM, nie CMadj, potem source add.

## 1. Gain actual Lroot/Re(Droot)

ROOT rounded-value Gram a,c,j i v=fhat Ghat−ghat Fhat dają |v−q|<=dc.
Source L ma norm≤(1+32U)*sqrt(j/a), a real Droot jest co najmniej
`(q-dc)²/a−256U*j`. Dla
`beta=256U*jmax*amax/(q-dc)²<1` wynika dla każdego physical slot:

```
|Lroot_C|²/Re(Droot_C)
 <=(1+32U)²*jmax / ((q-dc)²*(1-beta)) <77565.
```

Każdy parametr pochodzi z actual correlated ROOT certificate. Nie użyto
det rounded basis=q, arbitrary independent boxes lub ideal root L.

## 2. Mathematical norm transport i source correction

Dla physical768 complex slots, coefficient/A2 Gram normalizuje sumę przez768.
Unweighted coefficient l2²≤2*Q_A2, z odebranej exact Phi evaluation identity.
Zatem dla Z* z RIGHT_RESIDUAL_ENERGY:

```
||inverse_eval(Z* Lroot)||₂² <=2*77565*3913789077504.
max_j |Z*(j)Lroot(j)|² <=768*77565*3913789077504.
```

Ceil integer square-root majorants są zapisane w energy_transfer.json.
Actual z1−Z* ma uniform norm error delta<0.036. Jego product z Lroot ma
coefficient l2 error≤2*(2^25)*delta i frequency error≤2^25*delta. To source
reconstruction defect, nie dodatkowy assumed metric premise.

Przed source CM wszystkie operands są w proved2^100 domain. Pointwise
complex-product magnitude jest teraz ograniczone przez powyższą weighted
energię plus defect, nie przez luźny iloczyn115M*2^25. CM roundoff bound
to6U*productcap+8eta. Następny source add ma error U*(t0cap+productcap+
CMerror)+2eta. Uwzględniono source CM/add osobno; same correlations nie
czynią ich exact. Dziedzina ustalona PRZED operations.

## 3. Dwa wyjścia do left induction

Źródłowy U vector po add ma:

```
complex modulus/component cap M =20099472117,
mathematical inverse-eval coefficient linf cap B =786308210.
```

B zawiera TARGETS coefficient bound173861259265/36866 (z target FFT/basis/
reciprocal error), weighted correction, reconstruction defect i oba nowe
source-rounding terms. Nie został otrzymany przez source iFFT ani przez
interpretację dużej frequency majoranty jako scalar center.

Te boundy inicjalizują nowy signal/history invariant LEFT_INVARIANT.
Sam root correction bound nie jest jeszcze finalnym center theorem; source
split/merge i subsequent updated targets mają własny error recurrence.
