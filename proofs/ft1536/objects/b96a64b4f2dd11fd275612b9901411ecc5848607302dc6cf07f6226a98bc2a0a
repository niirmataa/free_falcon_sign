# NEGATIVE_RESULTS — wiersze odrzucone i wyniki ujemne (zachowane)

1. **Jednorodny SIS nie jest problemem P2 — potwierdzone także przez
   estymator.** Dla FT1536/FT3072 promień `sqrt(B_N - 1)` przekracza `q`,
   więc wektory trywialne `q*e_i` rozwiązują `A z = 0` (ale nie `A z = c`).
   Sam estymator zwraca dosłownie: `SIS trivially easy. Please set norm bound
   < q`. Wiersze `artifacts/sis_controls.json` są oznaczone
   `REJECTED_FOR_P2` i **nie wchodzą do minimum P2**; pozostają danymi
   kontrolnymi (w tym dłuższy wariant `large_norm` estymatora, zapisany bez
   użycia).
2. **Atak podciałowy ABD (indeks 2) nie daje tu przewagi — wynik ujemny,
   dokładny.** Wszystkie 7 podgrup rzędu 2 × 3 stopnie: dokładne momenty
   norm względnych ternary secrets dają `sigma_fg' ∈ [26.1, 73.9]` (vs 0,816
   pełnego wymiaru) — cel podciałowy jest 32–90× dłuższy na współczynnik.
   Dla FT768 pętla eq. (2.3) daje `beta_sub ∈ {1311..1519}` przy
   `beta_full = 462` (gorzej dla atakującego); dla FT1536/FT3072 warunek
   ataku nie zachodzi poniżej `2N` w ogóle (`beta_sub = None`,
   `TARGET_TOO_LONG_NO_SUBFIELD_ADVANTAGE`). Zgodne jakościowo z historycznym
   wnioskiem majowego worksheetu (dla tamtego, Gaussian-like prawa).
   `artifacts/subfield_normdown.json`.
3. **Model χ²: kryterium 2^-40 obalone** (odbiór R5, certyfikowany ogon
   2^-28.32) — patrz CLAIMS C19 pakietu FT_FAMILY_SCALING.
4. **Trywialna definicja celów P2** (`c=0, z=0`) — kontrmodel N1; cel musi
   pochodzić z tabeli ROM (ATTACK_PROBLEMS.md §2).
5. **`(1-p)^Q` bez niezależności** — kontrmodel N2 (dwa identyczne zdarzenia
   p=1/2 mają sumę 1/2); obowiązuje union bound po nazwach rozłącznych.
6. **Proxy euklidesowy dla wierszy forgery** — zachowany wyłącznie jako
   wiersz wrażeniowy `WITHDRAWN_SENSITIVITY_ONLY`
   (`artifacts/hostile_envelope.*`), nie wchodzi do wyników.
