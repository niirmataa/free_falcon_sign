# Zachowane routes, countermodels i poprawki dowodu

1. ORDERED supnorm-only root update3864968087959271 i hypothetical full
   continuation7729936365272004 pozostają historycznym failed route. Są za
   luźne, nie dowodzą bug/overflow. Nowy proof konsumuje source covariance,
   nie podmienia tych liczb w starym pakiecie.
2. Stary ideal weighted diagnostic275528238/maxR²D424673294 nie był source
   boundem. Nowe first-bank inequalities, paired3/4*A2 weighting i source
   metric factor6 zostały wyprowadzone niezależnie. Nie zatrzymano się na
   odtworzeniu optymistycznej liczby.
3. Raw L=ideal stable LDL bez defect jest fałszywą identity w publicznych
   source fixtures: exact nonzero Hermitian factor defects i full weighted
   ratios różne od1 są zachowane. To kontrmodel tej silniejszej identity,
   nie required-domain counterexample do bezpieczeństwa C.
4. Pominięcie imaginary data daje local matrix error~1 mimo maleńkiego
   split-roundoff budgetu. Natywny SplitDeep2 na28±i i exact dyadic checker
   odrzucają taką mutację; fixture ma local domain, nie emitted provenance.
5. Podczas przeglądu pierwszego draftu normC bound znaleziono pominięty U²
   cross term. Zamiast `2U*16+128eta` użyto dowiedzionej majoranty
   `3U*16+128eta`, która dominuje(2U+U²)*16+(3+2U)eta. Draft/check outputs
   zachowano w attempts/norm_square_cross_term_v1. Final local2048U*h,
   factor6 i left937866518 nie zmieniły się; source C nie był błędny.
6. Początkowe Lean elaboration wymagające product normalization oraz redundant
   positivity hypothesis zachowano; final logs są czyste, bez suppression.

Executed controls odrzucają reversed bank inequality, paired-as-stored,
omitted A2 cross term, wrong reciprocal reversal, omitted raw-factor/imaginary
defect, root conjugation/stale snapshot i exact rounded cancellation. ZERO
przedcurrent NumericCenter jest odrzucone na synthetic2^40 entry bez native
unsafe call. No-op przechodzi. Nie wyszukiwano kluczy, więc żaden z tych
negative controls nie jest automatycznie emitted/source-reachable witness.

Po poprawkach main bridge/left closure są domknięte w zadanym mixed modelu.
Otwarte pozostają świadomie oddzielone whole termination, postprocessing,
sampler law, security/CT i old CenterClass; nie są luką maskowaną nowym statusem.
