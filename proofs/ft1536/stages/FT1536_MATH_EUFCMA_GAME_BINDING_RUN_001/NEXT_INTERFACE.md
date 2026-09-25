# NEXT_INTERFACE — dokładne następne obowiązki

**Doprecyzowanie po domknięciu: trzy typy wiążące są ZAMKNIĘTE kernelowo**
(`one_key_lift` — Mixture; `lazy_sampling_refinement` — Lazy;
`game_kernel_identification` — GameLaw). Pozostały: mechaniczny fold-binding
dla konkretnego A oraz bit-cost (Etap E). Poniżej historyczny opis trójki
zamkniętych (zachowany dla proweniencji) + bieżące pozycje 1–4 zaktualizowane.

## Bieżące brakujące typy (po domknięciu kawałków 0 i 4)

0. *(zamknięty — `AdversaryFold.adversary_fold_paid_flag_binding` +
   `PathCounter.paid_counter_pathwise`: flaga paid = zapytania Sign A,
   licznik per-ścieżka ≤ Q_s z budżetu A, `second ≤ (1+e)^Q_s` na kernelach
   `kernelOf`; jądro datowania stanu: `bind_eq_map_snd`/`second_map_le`/
   `ac_map_any`/`signKernel_bound`).*
1–3. *(zamknięte — CLAIM poz. 8 i MAIN_THEOREM §4b).*
4. *(zamknięty — `BitCost.cost_interpreter`/`cost_composition`/
   `reducer_bit_cost_bound` dla modelu jednostek t/w/L z RESOURCE_BOUND).*

**Zamknięte dodatkowo (właściciel: „az do celu")**:
`hist_extraction_implication` (FinalBind: `stateAt_good`/`stateAt_used`/`isWin`/`isMT`
z pełną spójnością odpowiedzi; `Win → MT` z `j < Q_H+1` + `ShortPreimage` —
silniejsze niż `Win ∧ ¬Bad → MT`) oraz rdzeń kolizji (FinalTheorem:
`kernelOf_halt_mass` — per-ścieżkowe ryzyko kolizji soli ≤ `K/2^320`
z `sign_conflict_risk` + realny rozmiar tabeli przez fold).

**Doprecyzowanie 2026-09-24 (decyzja właściciela): dwa ostatnie obowiązki
są ZAMKNIĘTE sprawdzonymi odpowiednikami w RUN_002 — nie dublikować:**
1. `badAt_ordinal_union_bound` → **`StoppingLoss.game_stopping_loss` +
   `StoppingLoss.loss_exact`** (`AdvEUF ≤ Pr[stopped win] + loss`, a
   `loss = ((q_s·q_H + q_s(q_s−1)/2)/2^320)` przez ten sam
   `ROM.collision_sum` — dokładne `eps_coll`). Mój szkic na semantyce
   kernelOf/Law leży w `history/DRAFT_ConflictUnion_SUPERSEDED.lean`
   jako kontrola krzyżowa — bez osobnego księgowania.
2. `end_to_end_assembled_theorem_statement` →
   **`ConcreteReduction.exists_concrete_reducer`** +
   `concrete_euf_cma_to_mt_isis` + `concrete_hardness_substitution` +
   `exact_collision_parameter` (ich `AdvMT` = konkretne zdarzenie solvera).

**Jedyny brak w scalonym wyniku końcowym**: konjunkt
`Resources B ≤ bound beta S` w ich `exists_concrete_reducer` (tam jeszcze
nieobecny) — to jest mój `BitCost.reducer_bit_cost_bound` (§5E: lookup
ładowany per-wpis, `w` szczytowo z pełną tabelą i całą listą celów)
połączony z ich stroną maszynową (Bit*/FieldMachine, `MachineImplements`
w przygotowaniu). Pozostałe osie po ich stronie: M1 (Reader compilation,
uwaga: `Reader.weaken` pomija pierwszy element taśmy) oraz M6 (skala błędu).

## Brakujące typy (dokładnie; to JEDYNE luki redukcji)

1. **`game_kernel_identification`** — dla zdefiniowanych interpreterów
   `GameMach.step` (real/stopped/sim) i przeciwnika `A` z taśmą monet,
   niech `Law_run(mode) : Law (Hist Reply n)` będzie prawem transkryptu
   odpowiedzi przy jednorazowym `(sk,h) ∼ muKey`, leniwym `targets` i
   per-krokowym `Env`. Brakujący typ:

   ```
   theorem game_kernel_identification (muKey) (A) (S) (certS) (n) :
     ∃ (j p : (k : ℕ) → Hist Reply k → Law Reply)
       (paid : ℕ → Prop) [DecidablePred paid],
       Law_run sim = transcript j n ∧ Law_run stopped = transcript p n
       ∧ (∀ i x, ¬ paid i → j i x = p i x)
       ∧ (∀ i x, paid i → second (j i x) (p i x) ≤ 1 + e)
       ∧ (∀ k, countPaid paid k ≤ A.beta.Qs)
       ∧ (∀ i x, AC (j i x) (p i x))
   ```

   Dowód na papierze: MAIN_THEOREM §2(ii)–(iii) (wspólne kroki = ten sam
   kod; płatne = wywołania Sign z certyfikatem). Kernelowe wsparcie:
   `GameMach.sign_atomic/step_sq_seen/stopped_absorbing`,
   `PaidSteps.second_self/paid_counter_chi2`.

2. **`lazy_sampling_refinement`** — rownowość praw
   (a) wejściowy wektor `Law.uniform : Law (Fin (Q_H+1) → Rq)`,
   (b) sekwencyjne niezależne losowania `Q_H+1` uniform,
   (c) leniwa wyrocznia `ROM.hash` na `targets : ℕ → Rq`
   po ograniczeniu do ≤Q_H+1 odczytów (`used ≤ Q_H+1` — gotowe:
   `used_le_of_step`, `target_count_le_QH_add_one`), z warunkową
   jednostajnością/niezależnością nieużytych celów względem przeszłości.
   Kernelowe wsparcie: `ROM.hash_nonanticipating`, dyscyplina odczytów;
   Sage: dokładna kontrola małego modelu.

3. **`one_key_lift`** — jednorazowe włączenie latent sk/h: z boundu per-h
   i `key_marginal_normalized` wyprowadzić bound uśredniony po `muH` (z
   osobnym przypadkiem p_K = 0, jak w poprzedniku). Marginał `muH` jest
   zdefiniowany (`SigmaMath.muH`), nie uniform.

4. **Etap E**: `cost_interpreter`, `cost_composition`, `reducer_bit_cost_bound`
   (RESOURCE_BOUND.md).

Po domknięciu 1–3 twierdzenie z MAIN_THEOREM §1 idzie wprost
(`paid_trace_bound` + `conflict_bound_shape` + `hardness_substitution`) i
można uzyskać `PROVED_CONDITIONAL_REDUCTION_FOR_FINITE_BOX_E0_MODEL`
przy parametrycznych S/e/cost.

## Już gotowe punkty zaczepienia (nowe)

`GameByte.pow256_40/nonceBytes_*/render_injective/pair_framing`;
`GameNames.nameKind_bijection/tableAddr_*/paint_tableAddr`;
`GameMach.step_eq/step_sq_seen/sign_atomic/stopped_absorbing/
used_le_of_step/signStep_used/signStep_table/verdict_fresh/
stepBounded_eq_step_of_within`;
`PaidSteps.second_self/paid_counter_chi2/paid_counter_le/paid_event_bound/
paid_trace_bound/sign_frame_injective/sign_conflict_risk/conflict_bound_shape/
zero_paid_boundary`. Plus dziedziczone (101) — typy w formal_types.txt.

Nie konsumować samych nazw jako szerszych twierdzeń. Osobne osie:
instancja samplera, małe e_img/e_sign, full M0, C/PRNG/H2P, QROM —
świadomie poza zakresem cyklu (§1 zlecenia).
