# One-root IID consumer — właściwy kierunek i podstawienie beta

Odebrany JOINT dla SAMEGO B_e i entry PAST daje, dla P=P_VALUE w IID_BUFFER
i Q=Q_S, forward chi2(P||Q)≤Delta, TV(P,Q)≤2^-25:

```
p=P_IID(B_e|PAST) <= q+min(2^-25,sqrt(Delta*q*(1-q))),
Delta=(1+2^-60)^3072−1 <=3/(2^50−3)<2^-48.
```

Nie odwracamy direction. Po nowym reference theorem q≤beta<1/2,
q(1−q)≤beta(1−beta): różnica=(beta−q)(1−beta−q)≥0. To jawnie domknięta
monotonicity premise; nie podstawiamy beta(1−beta) dla dowolnego beta>1/2.

Stąd sound i nieco ciaśniejszy consumer:

```
p <= min(1,beta+min(2^-25,sqrt(Delta*beta*(1-beta)))) <= 2^-84.
```

Exact expression Delta oceniono RBF512 z outward rational upper i sprawdzono
względem odebranego3/(2^50−3). JOINT_TAIL_BOUND.json zawiera pełne bounds,
q/variance/error/margin i floating-free outward rational rezultat. To **ONE
ROOT w IID_BUFFER**, event Live+joint BadPrecast obu pre-narrow vectors.
Analogiczny bound można skonsumować przez Q_stop(B)≤beta,bezEXIT w event.

Nie komponujemy16 attempts,nie przypisujemy eta_pre do M0,nie ogłaszamy
universal Safe16 lub integer recovery. Retry scheduler/reach probabilities,
nonce/fault/abort decisions,real PRNG,whole Sign/Sign→Verify/security/CT są
dalszymi obowiązkami. Single K_seed[E]/p_K i source success event bez zmian.
Uniform conditional entry result może być użyty przy reached legal attempts,
ale dopiero po osobnym dowodzie odpowiedniej whole-call kompozycji.
