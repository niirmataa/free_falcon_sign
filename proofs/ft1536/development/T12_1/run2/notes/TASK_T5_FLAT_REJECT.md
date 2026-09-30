# TASK: T5-FLAT-REJECT — domknięcie hipotez flat/reject dla wszystkich kluczy KeyGen

TASK_ID: T5_FLAT_REJECT (kontynuacja toru matematycznego T12.1, W=RUN_002)
Data przygotowania: 2026-09-24
Przygotował: bieżący wykonawca RUN_002 (GPT-6 Astra Fast), na polecenie właściciela.
Wykonawca: NOWY KONTEKST w tym samym W
`proofs/ft1536/work/FT1536_MATH_EUFCMA_MTISIS_RUN_002` (jeden wykonawca; W
poprzednika RUN_001 i P02 nie modyfikować).

## 1. Cel (teza końcowa)

Dowieść kernelowo, dla WSZYSTKICH kluczy dopuszczonych przez przypięty
KeyGen FT1536 (bez nowej selekcji, bez nowego conditioning):

    ∀ h : Rq, successfulKeyGen h →
      FiniteFlat h (1/2^36) ∧ (∀ c, rejection h c ≤ 1/2^24)

co wraz z już domkniętym łańcuchem (`RawRadialEnclosure` →
`RadialObligations` → `RadialTriangleSplit` → `RadialSymmetry` →
`RadialWindowSplit` → `RadialBinningSandwich` → `ChangedTailReduction`)
zamyka `GuaranteedDigits.three_significant_digits` i warunkowe trzy cyfry
błędu poprawności (1.265…1.275)e-24 dla delta h.

Dokładne definicje (Run2/LegalKeyErrorTransfer.lean, cytaty):

    def FiniteFlat (h : Rq) (eps : ℝ) : Prop := ∀ c,
      (1-eps)*totalWeight ≤ (Fintype.card Rq : ℝ)*evalCount (Z h c) ∧
      (Fintype.card Rq : ℝ)*evalCount (Z h c) ≤ (1+eps)*totalWeight

    -- rejection h c: z CorrectnessProbability (cap16; rejection_bounds).
    -- Most (JUŻ udowodniony, NIE POWTARZAĆ):
    theorem all_key_error_from_local_certificates (h) (eps r) ... :
      rawBad/(1+eps) ≤ delta h ∧ delta h ≤ rawBad/((1-eps)*(1-r))

FiniteFlat jest „pośrednim CERTYFIKATEM, nie definicją wybranego zbioru
kluczy" — obowiązek ∀ successfulKeyGen → FiniteFlat/rejection pozostaje
jawny i musi wynikać z rzeczywistych bramek KeyGen (mandatory gate,
exact-leaf/T5), nie z nowego conditioningu.

## 2. Zakres matematyczny (wg `run/LEGAL_KEY_NUMERIC_ROUTE.md`)

Historyczny T5 daje punktowo sumę niezerowych graph-dual theta weights
< 2^-40 (rzeczywisty bound ≈ 2^-51.83). Poisson daje stąd pointwise
relative mass comparison KAŻDEGO cosetu i KAŻDEGO realnego przesunięcia
(1+eps z eps ≈ 2^-40 rządu). Z tego uniform MGF i Chernoff tails:

(A) FLATNESS: dla każdego c, masа cosetu `evalCount (Z h c)` w granicach
    `(1±eps)*totalWeight/|Rq|` z eps = 1/2^36. Trasa: relative mass
    comparison per coset (Poisson/T5) + kontrola przesunięć (M6).
(B) REJECTION: `∀ c, rejection h c ≤ 1/2^24` — norm reject przy B
    (bramka `Q(…) < B`) ma upper < 2^-24 przez uniform MGF/Chernoff;
    tor: ShiftedGaussian/TriangularGaussian/A2Theta + ogony współrzędne.
(C) KWANTYFIKACJA: z bramek KeyGen (KeygenLeafGate, mandatory gate,
    exact leaves) dla każdego successfulKeyGen output — bez nowej selekcji.

Uwaga: cap16 przy reject ≤ r zmienia daną positive bad-event mass
o czynnik w [1, 1/(1-r)] (to już w `geometric_loss_bound`/
`capped_upper_from_rejection` — nie powtarzać).

## 3. Co JEST udowodnione (NIE POWTARZAĆ — czytać, nie odtwarzać)

- `LegalKeyErrorTransfer`: FiniteFlat, first_bad_flat_bounds,
  geometric_loss_bound, capped_upper_from_rejection,
  all_key_error_from_local_certificates, rawBad, rawBad_sum.
- `GuaranteedDigits`: exact_decimal_margin, three_significant_digits.
- `T5ScalarMass`: scalar_reciprocal_exponent, row_exponential_bound,
  local_exponents, dimension_margins, scalar_power_margins,
  uniform_shifted_mass_3072 (T : Tower 3072).
- `UniformErrorBound`: gaussian_le_one, fiber_normalizer_le_card,
  first_atom_bound, emitted_atom_bound, event_ge_atom,
  event_le_without_atom, uniform_lower.
- `RawIndependence`: prob/prob_mono-lematy (uwaga: prob_nonneg/prob_mono/
  prob_or_le są też w `ChangedTailReduction`), pairPenalty_exact.
- Łańcuch rawBad→rawLo/rawHi→trzy cyfry (moduły z sekcji 1) + sandwich
  binningowy + symetrie + dekompozycja weight×gap (`RadialWindowSplit`).
- Redukcje ogonowe: `ChangedTailReduction` (hchange ⇒ P(|x|≥9217)≤tau9217),
  `RadialObligations` (hemit ⇒ ogon unsignedHalf ≤ emitCap).
- Checkers Sage: `run/sage/check_tail_obligations.sage` (6/6 PASS,
  run/tail_obligations_001, _002) — wartości ogonów zweryfikowane Arb512.

## 4. Zasoby i piny (kolejność czytania)

1. `WORK_STATE.md` (W) — stan, lekcje składni, piny; wpis końcowy
   „kroki 1-3 freeze" + handoff T5.
2. `run/LEGAL_KEY_NUMERIC_ROUTE.md` — trasa liczbowa (właściciel: zakres
   = wszystkie successfulKeyGen).
3. `run/formal/Run2/LegalKeyErrorTransfer.lean`, `GuaranteedDigits.lean`,
   `rawBadEnclosure.lean` (uwaga: zawiera `hypothesis` — NIE używać).
4. `run/formal/Run2/T5ScalarMass.lean`, `UniformErrorBound.lean`,
   `ShiftedGaussian.lean`, `TriangularGaussian.lean`, `A2Theta.lean`,
   `T5ThetaNumeric.lean`, `KeygenLeafGate.lean`, `M6Audit.lean`.
5. Kontekst T5: `inputs/legal_key_context/` (MANIFEST.sha256; manifest
   kontekstu `1fdf82136da325eec6727eae14a89f31be368af113a8210170b7d3c339084bab`;
   T5/GLOBAL_LEAF_A2_BRIDGE.md, DEPENDENCY_BINDINGS.json).
6. `run/LEAN_INSTANCE_HYGIENE.md` + `run/B_CERTIFICATE_PACKAGE.md` (architektura).
7. TASK nadrzędny: `proofs/ft1536/documents/FT1536_ZADANIE_ASTRA_INTERACTIVE_GAME_BINDING_2026-09-23.md`
   (sha b4c11e3c…) oraz `proofs/ft1536/CURRENT_MATH_TASK.md`.

## 5. Metodyka i rytm (zasady obowiązujące w W)

- Lean4.34 + Mathlib (kernel); rachunek Sage przez `sage <plik>.sage`
  (exact ZZ/QQ; real balls przez rygorystyczne Arb). Zakaz: sorry/sorryAx/
  admit/native_decide/Lean.ofReduceBool; `-DwarningAsError=true` (job.py).
- `run/job.py <mode> <label> <moduły>` — tryby lean/sage/command; logi
  muszą być czyste; przyjęte joby trafiają do devlib.
- Higiena instancji w KAŻDYM nowym module sądowym:
  `attribute [-instance] FT1536.PublicSimulation.boxVecFintype/boxPairFintype`
  (bez tego: pętla elaboratora przez dane elems — patrz WORK_STATE).
- Znane pułapki składni (z WORK_STATE): `true_and` vs `and_true`;
  `.mp/.mpr` zamiast aplikacji `Iff`; jawne argumenty warunkowych `rw`;
  `noncomputable` przy dzieleniu w ℝ; koercje anonimowego `Equiv` domykane
  przez defeq (`exact`), nie `simp`; `Finset.sum_congr` wymaga asrypcji
  typu; nieużyte argumenty `simp` = błąd; `set_option maxRecDepth 65536`
  przy głębokich defeq.
- Przed procesem Lean/Sage sprawdzać tło (inni workerzy: P02, CENTERING_CLOSURE
  równolegle) i czekać na czyste; po procesie — wg rytmu ustalonego przez
  właściciela dla nowego kontekstu.
- Zapisywyłącznie pod W; biblioteki/inputs RO; bez Git/push/subagentów/relay.
- Uczciwe raportowanie: rozróżniać brak dowodu / zbyt luźne oszacowanie /
  zakres poza zadaniem; nie ogłaszać freeze; po każdym etapie wpis w
  `WORK_STATE.md` + krótkie podsumowanie dla właściciela po polsku.

## 6. Kryteria odbioru

1. Moduł(y) Run2 z twierdzeniem `∀ h, successfulKeyGen h → FiniteFlat h
   flatBudget ∧ (∀ c, rejection h c ≤ rejectBudget)` — lub jawny rozkład na
   nazwane prymitywy (jak w RadialObligations) + kernelowe redukcje.
2. Wszystkie nowe twierdzenia: tylko propext/Classical.choice/Quot.sound
   (sprawdzone `#print axioms` w logu), logi czyste, joby accepted.
3. Fakty liczbowe (o ile pojawiają się nowe) — przez checkers Sage
   (Arb512/exact QQ) z receiptem i pinem.
4. Kwantyfikacja ∀ successfulKeyGen zachowana; bez nowego conditioningu
   i bez „dobrej selekcji kluczy".
5. Aktualizacja `WORK_STATE.md` + raport końcowy dla właściciela
   (co wykazano, co zostaje, co zmienia, następny krok).

## 7. Czego NIE robić

- Nie powtarzać zamkniętych dowodów (sekcja 3); czytać je jako zależności.
- Nie używać `hypothesis numerical_bounds_assumption` z rawBadEnclosure.
- Nie rozszerzać zakresu o pełne bezpieczeństwo kodu ani o nowe selekcje
  kluczy; nie modyfikować RUN_001/P02/stages; nie commitować.
- Nie ogłaszać PASS/freeze szerzej niż zakres dowodu.

## 8. Handoff techniczny

- Stan i piny: `WORK_STATE.md` (wpisy 2026-09-24).
- Łańcuch kernelowy ukończonej części: moduły Run2 wymienione w sekcji 3;
  manifest artefaktów: `run/INTERVAL_CERTIFICATES_MANIFEST.json`.
- Znane otwarte punkty poza tym zadaniem: (b) certyfikat liczbowy —
  warstwa symboliczna zamknięta, liczby jako certified computation
  (pakiet `run/B_CERTIFICATE_PACKAGE.md`); to NIE jest przedmiotem tego
  zadania.
