# COUNTERMODELS — kontrprzykłady lokalne/rozzerzerzone (nie atak)

1. **center_q nie jest monotoniczne dla formy z cross terms** (lokalny,
   syntetyczny skalarny model, NIE required-domain, nie claim o ataku):
   forma Q(x,y) = x^2 + 2ρxy + y^2, ρ = 9/10 (dodatnio określona: 1−ρ^2>0).
   q = 5; (x,y) = (−3, 1): Q = 9 − 27/5 + 1 = 23/5 = 4.6.
   center_5(−3) = 2: Q(2,1) = 4 + 18/5 + 1 = 43/5 = 8.6 > 4.6.
   Wniosek: congruence + Q(s1,s2)<B nie pociągają Q(center_q(s1),s2)<B dla
   formy A2 z cross terms — potrzebny lemma kompatybilności dla dokładnej formy
   CheckNorm (VERIFY_NEXT_INTERFACE §3). Nie postulowano monotonicity.
2. **„source output jako referencja" jest równoważne w exact skeleton**
   (mutation M_source_output_as_reference): tam t − z = Z(Y) dokładnie dla
   każdego (t, L), więc mutacji nie da się wykryć na tej domenie — wykazane
   wprost (TASK §7: „wykaż zamiast udawać wykrycie"). W modelu z jitter
   zaokrągleń mutacja jest wykrywana (derived Z zależy od t) — kontrola w
   checks/skeleton_cancellation.json.
3. Brak wymaganego witnessa nierówności |gap| ≥ 1/2 dla actual words;
   luźny bound 6086.4 NIE jest kontrprzykładem (TASK §5/§10).
Syntetyczne klucze/drzewa w kontrolach nie mają Emitted membership i nie są
używane do twierdzeń o wymaganej domenie.
