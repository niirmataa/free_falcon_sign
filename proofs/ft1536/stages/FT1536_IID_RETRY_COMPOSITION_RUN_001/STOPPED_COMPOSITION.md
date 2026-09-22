# Joint stopped probability, bez niezależności retries

Niech p oznacza dokładny `IID_upper` z przypiętego H6P/JOINT_TAIL_BOUND.json,
nie tylko jego zaokrąglenie2^-84. JSON tego etapu zachowuje exact rational.
Dla reached/completed j, Bad_j oznacza naruszenie signed16 range przez
KTÓRYKOLWIEK z obu1536 source int64 rint outputs przed cast. Obejmuje również
attempty odrzucone stored normą. Source computations wykonują te wartości
przed normą, bez extra Verify lub success conditioning.

REENTRY_AND_FRAME i FILTRATION wyprowadzają wszystkie H6P premises na R_j.
H6P daje `Pr(Bad_j | F_j,R_j)<=p` a.s. JOINT daje completed probability1
na R_j. Definiujemy X_j=1_(R_j AND completed_j AND Bad_j), z analitycznym
zerem poza completed/reached domain. Nie istnieje tam fikcyjny source sample.
Wtedy, conditional on początkowej legalnej F_0:

```
1_B <= sum_j X_j,
Pr(B|F_0) <= sum_j E[X_j|F_0]
          = sum_j E[1_Rj Pr(completed_j AND Bad_j|F_j,R_j)|F_0]
          <= p sum_j Pr(R_j|F_0) = p E[J|F_0]
          <= 16p <= 2^-80.
```

Tower i nonnegative integration są dla skończonej sumy16; żadne exchange
nieskończonych granic nie jest potrzebne. Pointwise source entry proof,
nie finite sample maximum, dostarcza uniform p także po earlier Bad.
Kernel `weighted_stopped_sum` sprawdza scaled finite-sum algebra;
probability integral/tower instantiation jest jawną częścią analityczną.

## Dodatkowy conditional-hazard bound

Nie zakładamy independence. Niech S_k oznacza brak bad w pierwszych k
indeksach, przy proof-only zero-event padding po source stop. Na S_(k-1)
conditional hazard kolejnego bad jest <=p: jeśli próba nie jest reached,
wynosi0; w przeciwnym przypadku stosuje się ten sam uniform H6P na F_k.
Wobec tego `Pr(S_k|F_0)>= (1-p)Pr(S_(k-1)|F_0)` i indukcyjnie
`Pr(B|F_0)<=1-(1-p)^16<=16p`. Hipoteza jest conditional history bound,
nie sam fakt, że16 unconditional marginals<=p. Exact QQ potwierdza
nierówność i outward value. Bound hazard może być słabszy od reached-weighted
pE[J]; oba obowiązują i można wziąć minimum.

## Success

Dla A=positive source return `Pr(B AND A|F_0)<=Pr(B|F_0)` przez inclusion.
Jeśli s=Pr(A|F_0)>0, jedyny eksport stąd to
`Pr(B|A,F_0)<=min(1,bound/s)`. Nie udowodniono lower bound s. Dla s=0
to conditioning jest nieokreślone, nie równe0. Finite controls dają
kontrmodel Bad|A=1 przy małym unconditional Bad. Nie importujemy global
Gaussian/chi-square norm-success heurystyki. M0 eta_pre pozostaje null.
