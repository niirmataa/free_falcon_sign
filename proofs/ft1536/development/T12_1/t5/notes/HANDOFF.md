# HANDOFF — start sesji T5-FLAT-REJECT

## Kolejność startu (5-10 minut)

1. `TASK.md` — cel, zakres, kryteria odbioru (§1-2, §6-7).
2. `AGENTS.md` — zasady W i twarde reguły dowodowe.
3. `dep/run2_WORK_STATE.md` — stan i lekcje poprzedniej sesji
   (szczególnie wpisy 2026-09-24: „ChangedTailReduction Accepted",
   „kroki 1-3 freeze", lekcje składni na końcu każdej sekcji).
4. `run/LEAN_INSTANCE_HYGIENE.md` — obowiązkowy wzorzec dla modułów
   sądowych (bez niego: pętla elaboratora).
5. TASK.md §4 — dalsze zależności wg potrzeb (T5ScalarMass,
   UniformErrorBound, LegalKeyErrorTransfer, kontekst T5 w `inputs/`).

## Środowisko

- Runner: `python3 -B run/job.py <lean|sage|command> <label> <args...>`
  (kopia w tym W; W i LIB liczone lokalnie — działa bez poprawek).
  Tryb lean: moduły z `run/formal/` (np. `Run2/T5FlatReject`),
  importy `Run2.*` rozwiązywane przez oleany w `run/devlib` (kopia
  closure RUN_002 — nie odświeżać, nie kasować).
- Sage: `run/sage/<plik>.sage`, uruchamiany przez job.py sage lub
  bezpośrednio `sage run/sage/<plik>.sage`; zapisy do katalogów pod W.
- Przed każdym procesem Lean/Sage sprawdzić tło (`ps` — inni workerzy
  pracują równolegle: P02, CENTERING_CLOSURE) i czekać na czyste;
  po procesie — wg rytmu ustalonego przez właściciela (domyślnie:
  raport po każdym jobu, kontynuacja po znaku).

## Pierwsze kroki merytoryczne

1. Przeczytać `dep/run2_formal/Run2/LegalKeyErrorTransfer.lean` (linie
   34-40: `FiniteFlat`; 89+: `all_key_error_from_local_certificates`) —
   dokładne formy zobowiązań.
2. Przeczytać `run/B_CERTIFICATE_PACKAGE.md` + `dep/run2_formal/Run2/
   T5ScalarMass.lean`, `UniformErrorBound.lean` — co już jest.
3. Rozpoznanie mostu: `inputs/legal_key_context/T5/` (GLOBAL_LEAF_A2_BRIDGE.md,
   DEPENDENCY_BINDINGS.json) + bramki KeyGen (`KeygenLeafGate.lean`).
4. Pierwszy job diagnostyczny na rozruch (np. pusty moduł importujący
   zależności) — sprawdza środowisko i closure.

## Czego unikać (kosztowne lekcje z RUN_002)

- Moduł sądowy BEZ `attribute [-instance] boxVecFintype/boxPairFintype`
  = pętla elaboratora (Fin.foldr/elems).
- `simp` nie odpala sprzeczności z hipotez typu `¬(A ∧ B)` przy
  zredukowanym celu; nieużyte argumenty `simp` = błąd.
- `and_true` obsługuje `a ∧ True`, nie `True ∧ a` (potrzebne `true_and`).
- Aplikacja `Iff` jak funkcji nie działa — `.mp/.mpr`.
- Warunkowe `rw [lemma]` zostawia side-goals — podawać argumenty jawnie.
- Definicje z dzieleniem w ℝ wymagają `noncomputable`.
- Koercje anonimowego `Equiv` (`⇑⟨f,g,_,_⟩`) nie redukują się przez
  `simp` — domykać defeq (`exact`/`rfl`), albo nazwany Equiv + `rfl`.
- `rw` w złym kierunku (`.symm` vs `←`) objawia się maxRecDepth/mismatch;
  `maxRecDepth` bywa objawem realnego błędu typów, nie głębokości.
- `Finset.sum_congr` bez asrypcji typu nie zsyntetyzuje zbiorów.

## Stan narzędzi w W

- `run/devlib/` — 124 oleany (closure Run2) ✓ gotowe.
- `run/formal/`, `run/sage/` — puste, na nowe moduły i checkersy.
- `inputs` → RUN_002/inputs (RO).
- `dep/` → dowiązania RO do RUN_002 (formal, WORK_STATE, pakiet (b)).

## Rytm pracy

Jedno zlecenie → moduły + (checkersy) → joby → wpis w `WORK_STATE.md`
→ raport dla właściciela → następny krok po znaku. Na końcu sesji:
kompletny handoff w WORK_STATE (co wykazano, co zostaje, piny, lekcje).
