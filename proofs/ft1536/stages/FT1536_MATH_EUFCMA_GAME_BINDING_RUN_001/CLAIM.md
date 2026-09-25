# CLAIM — faktycznie uzyskane twierdzenia

**PARTIAL_PROOF — gry zaprogramowane i policzone straty; redukcja nie
zamknięta kernelowo.** Nie uzyskano `PROVED_CONDITIONAL_REDUCTION_FOR_FINITE_BOX_E0_MODEL`.

1. **Front-end i tabela (Etap A).** Bijekcja `NameKind ≃` literalnych ciągów
   bajtów; bijekcja nonce↔40 bajtów (256^40=2^320); brak kolizji nazw
   krótkich z Sign i brak obcinania; adresacja tabeli pair-kompatybilna z
   `ROM.State` (`paint ∘ tableAddr = id`).
2. **Trzy gry z jednego interpretera (Etap A).** `step` z trybami
   real/stopped/sim; Sign atomowy (m przed solą), SeenSign na wszystkich
   gałęziach, STOP wewnętrzny i absorbujący, budżet nie zmienia gry dla A
   w granicach; dyscyplina celów (cached H i Sign nie zużywają, final ≤1).
3. **Paid-step counter lemma (Etap C).** `second p p = 1` i
   `second(transcript j n, transcript p n) ≤ (1+e)^(liczba płatnych kroków)`;
   przy ≤Q_s płatnych: `≤ (1+e)^Q_s` — niezależnie od liczby kroków maszyny.
   Q_s=0 ⇒ brak straty (`Phi 0 b = b`).
4. **Transfer i postać końcowa (Etap C/D).** `Pr_stopped[Win] ≤
   min 1 (Pr_stopped[Bad] + Phi((1+e)^Q_s−1, Pr_sim[MT]))` dla zdarzeń
   abstrakcyjnego transkryptu z `extracts : Win∧¬Bad → MT`.
5. **Konflikty (Etap D).** Iniektywna 40-bajtowa rama nazw Sign; per-call
   ryzyko z realnego rozmiaru tabeli; dokładna suma `Q_s·Q_H + Q_s(Q_s−1)/2`
   i `eps_coll = min 1 (…/2^320)`; świeżość finalnego werdyktu kernelowo;
   ekstrakcja indeksowa (dziedziczona) łączy przyjęte fałszerstwo z
   `ShortPreimage h (targets j)` dla j<Q_H+1.
6. **Kontrprzykład centrowania** zachowany: 2051350378 < B przed
   centrowaniem, 2143496945 > B po nim (kernelowo, certyfikat).
7. **Kontrole dokładne małych modeli** (Sage, ZZ/QQ): zgodność kroków
   wspólnych gier, licznik płatnych, dyscyplina celów, jednostajność/niezależność
   nieużytych celów, suma konfliktów, instancjacja realnych parametrów;
   8/8 kontroli negatywnych reaguje na realną zmianę semantyki.

8. **Typy wiążące zamknięte kernelowo**: `one_key_lift` (mieszanina
   jednorazowego klucza + faktoryzacja latent sk przez `SigmaMath.muH`),
   `lazy_sampling_refinement` (`lazy_independence` + `seqTargets_eq_uniform`),
   `game_kernel_identification` (jądra z logiki `step`, bound `(1+e)^Q_s`,
   `conditional_shape` z `eps_coll`).

9. **Ostatnie kawałki zamknięte kernelowo** (decyzja właściciela 2026-09-23,
   „do celu"): `adversary_fold_paid_flag_binding` (fold `stateAt/kernelOf`,
   paid flag = Sign A, `PathCounter.paid_counter_pathwise` daje
   `second ≤ (1+e)^Q_s` z per-ścieżkowego budżetu) oraz Etap E:
   `cost_interpreter`/`cost_composition`/`reducer_bit_cost_bound`
   (długościowe formuły bitowe, `Resources(B) ≤ derivedResourceBound`).

10. **Ekstrakcja na poziomie Hist i rdzeń kolizji zamknięte** (FinalBind +
    FinalTheorem): `Win → MT` z `j<Q_H+1` i `ShortPreimage` (silniejsze niż
    wymagane `Win ∧ ¬Bad → MT`), `stateAt_good`/`stateAt_used` przez fold,
    `kernelOf_halt_mass` — per-ścieżkowe ryzyko kolizji ≤ `K/2^320`
    (iniektywna rama soli + realny rozmiar tabeli).

11. **Doprecyzowanie 2026-09-24**: dwa ostatnie obowiązki zamknięte
    odpowiednikami w RUN_002 (decyzja właściciela — bez dublowania):
    `badAt_ordinal_union_bound` → `StoppingLoss.game_stopping_loss` +
    `loss_exact` (= moje `eps_coll` przez `ROM.collision_sum`);
    `end_to_end_assembled_theorem_statement` →
    `ConcreteReduction.exists_concrete_reducer` (+ `concrete_hardness_substitution`).
    Mój `BitCost.reducer_bit_cost_bound` (po recenzji §5E: `lookupCost` per
    wpis, `stateMem`/`targetsMem`/`w_peak_bound` — peak, nie suma) to
    konjunkt `Resources B ≤ bound` jeszcze nieobecny w ich twierdzeniu.

NIE uzyskano po stronie scalonego projektu: konjunkt `Resources` w
`exists_concrete_reducer` (wymaga ich `MachineImplements` + mojego BitCost),
ich M1 (Reader.weaken ma defekt) oraz M6 (skala błędu).
instancji samplera, małych e_img/e_sign, bridge M0–C–FPEMU, bezpieczeństwa
implementacji, nowego oszacowania trudności MT-ISIS, niezależnego odbioru.

Zdarzenie MT jest zdefiniowane jako wynik programu B (indeks + świadek
z `Relation.extract`), nie dowolnym predykatem. `AdvMT` i `AdvEUF` są
prawdopodobieństwami zdarzeń zdefiniowanych eksperymentów. Certyfikaty
lokalne S (prawo i koszt) są parametrami metatwierdzenia; nie podstawiono
ich treści jako gotowego boundu globalnego.
