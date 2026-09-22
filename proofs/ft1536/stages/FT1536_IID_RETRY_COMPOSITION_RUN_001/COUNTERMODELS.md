# Kontrole zależności, niewłaściwego conditioning i mutacji

Wszystkie witnesses tutaj są finite toy laws lub public scripted-source
controls. NIE są Emitted counterexamples, atakami ani wykonaniami pełnego
do_sign. Maszynowe evidence: artifacts/probability_controls.json,
artifacts/mutations.json, artifacts/models/, logs/mutation_*.

1. Adaptive cap4 law ma31 leaves i WholeRegionBad=198527/4194304. Bad może
   być w odrzuconej próbie, a późniejszy good accept nie usuwa zdarzenia.
   Zero-probability edges są recorded, ale nie dzielimy przez ich mass.
2. Cap3 law z rare bad-accept i resztą good-reject ma Bad|positive=1 mimo
   małego unconditional boundu. Przy zero success probability conditional
   jest undefined. Samo inclusion B∩A⊆B nie daje conditioning claimu.
3. Dwa disjoint bad events o marginals1/10 mają union1/5, większą od
   nieuprawnionego independent product19/100. Conditional hazard drugiego
   eventu po no-first-bad to1/9, nie1/10. Poprawny uniform CONDITIONAL
   bound1-(1-p)^16 pozostaje sound bez independence i nie jest „killed”.
4. Native mutations: allow17th init, premature rejection16th attempt,
   omitted fault reset (defined prepoison control), stale target scratch,
   encoder failure incorrectly retries, reuse buffer after re-init — killed.
   No-op unchanged driver i prepoison-then-original-reset zachowują wynik.
5. Exact-model mutations: independent marginals, no success denominator,
   accepted-only bad event, omitted initial blocks i pointer conservation
   without re-init abandonment — killed przez exact witness inequalities.

Łącznie11 meaningful mutations i2 no-ops. C mutants kompilują się czysto,
a detekcja pochodzi z real branch/trace/assertion/byte disagreement, nie
z compile failure. Assertion stderr z platformowym executable path jest
zachowane jako evidence, a nie obiecany path-independent replay hash.
