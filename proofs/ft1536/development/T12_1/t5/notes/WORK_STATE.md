# WORK_STATE — FT1536_T5_FLAT_REJECT_RUN_001

## 2026-09-24 — utworzenie W (przygotowane przez wykonawcę RUN_002)

Cel: T5 → flatness/rejection dla wszystkich successfulKeyGen
(`TASK.md`, sha `09d60050d7f65f6e0d85747f7c51e1c17f5f963a271d04880f3e4459ce8c7060`).

Zawartość W:
- `TASK.md`, `AGENTS.md`, `HANDOFF.md` — start w 5-10 minut.
- `run/job.py` — runner (W/LIB liczone lokalnie).
- `run/devlib/` — 124 oleany, pełne closure modułów Run2 z RUN_002
  (importy `Run2.*` rozwiązywane bez źródeł).
- `run/LEAN_INSTANCE_HYGIENE.md` — obowiązkowy wzorzec higieny instancji.
- `run/B_CERTIFICATE_PACKAGE.md` — architektura (b) z RUN_002 (kopia).
- `inputs`, `dep/` — dowiązania RO do RUN_002 (kontekst T5, źródła,
  WORK_STATE, pakiety).

Stan bazowy (do NIE-powtarzania, szczegóły w `dep/run2_WORK_STATE.md`):
- Łańcuch rawBad → rawLo/rawHi → warunkowe trzy cyfry: kernelowo
  domknięty poza hipotezami `flat`/`reject` (to jest przedmiot tego W)
  oraz warstwą liczbową (b) jako certified computation (poza zakresem).
- Checkersy ogonów: 6/6 PASS (Arb512).
- Certyfikat fold na rzeczywistym wektorze binów: kernel decide,
  4/4 twierdzenia bez żadnych aksjomatów.

Zobowiązanie do wykonania (TASK.md §1):
    ∀ h : Rq, successfulKeyGen h →
      FiniteFlat h (1/2^36) ∧ (∀ c, rejection h c ≤ 1/2^24)

Status: READY_OWNER_START. Kolejny wpis: po pierwszym etapie badawczym.

## 2026-09-24 — etap 0: start wykonawcy, rozpoznanie (bez procesów Lean/Sage)

Wykonawca: MiMo V2.6 Pro (`xiaomi-token-plan-ams/mimo-v2.6-pro`), sesja
`ses_f2afd6557ffeaDS2QhN7jZNU9b`. Start na bezpośrednie polecenie właściciela
wskazujące W tego zadania. Wszystkie zapisy wyłącznie pod tym W; zależności
RO (RUN_002, RUN_001, B20/P01 LIB) nietknięte. Tło w momencie wejścia:
aktywny worker P02 (B20_001/P02, joby `floor_exec_011`, potem `floor_ax`,
lean -j1), otwarty edytor właściciela na CENTERING_CLOSURE/ThetaPoisson.lean.
Zgodnie z HANDOFF nie uruchomiono żadnego własnego procesu Lean/Sage —
czekam na czyste tło przed pierwszym jobem diagnostycznym.

TASK SHA zweryfikowany wg AGENTS: `09d60050d7f65f6e0d85747f7c51e1c17f5f963a271d04880f3e4459ce8c7060`.

### Rozpoznanie — precyzyjny stan zobowiązań T5

Cel (TASK §1): `∀ h, successfulKeyGen h → FiniteFlat h (2^-36) ∧ (∀ c,
rejection h c ≤ 2^-24)` z `GuaranteedDigits.flatBudget=2^-36`,
`rejectBudget=2^-24`. Stan po lekturze źródeł Run2 (RO) i kontekstu T5:

1. **Istnieją kernelowe redukcje obu tez** (NIE powtarzać):
   - `NormalizerComparison.finiteFlat_from_box_normalizers`: z granic
     `lowerFactor*v ≤ fiberMass h c alpha ≤ upperFactor*v` (dla wszystkich c,
     wspólna skala v) wynika `FiniteFlat h flatBudget`; `lowerFactor=(1-2^-40)^2`,
     `upperFactor=1+2^-40`, marginesy do flatBudget są `norm_num`.
   - `NormalizerComparison.actual_rejection_from_box_normalizers` +
     `RejectionNumericMargin.actual_rejection_from_tilted_normalizers`:
     z dolnej granicy fiberMass przy `alpha` i górnej przy `alpha-alpha/8`
     (`≤ upperFactor*v*(8/7)^1536`) wynika `rejection h c < 2^-24`
     (Chernoff `rejection_chernoff` + `rejection_numeric`, kernel).
   - Cały reject jest więc zredukowany do trzech granic mas włókien
     przy dwóch skalach: (F1) `lowerFactor*v ≤ fiberMass h c alpha`,
     (F2) `fiberMass h c alpha ≤ upperFactor*v`, (F3)
     `fiberMass h c (alpha-alpha/8) ≤ upperFactor*v*(8/7)^1536`.
2. **Most kosetowy istnieje**: `ActualNTRUFiber.gaussian_fiber_in_basis`
   przelicza nieskończoną masę włókna na `∑' u, exp(-a*Q((centerRq c,0)+
   coefficientBasis f g F G u))` — czyli sumę Gaussa po afinej kosie kraty
   NTRU (baza `[[M(g),M(G)],[-M(f),-M(F)]]`), dokładnie obiekt T5.
   `fiber_weight_reindex`/`coordinates_formula`/`all_fiber_points` domykają
   reindeksację.
3. **Analiza T5 jest w dużej mierze sformalizowana**: `ShiftedGaussian`
   (Poisson dla dowolnego realnego przesunięcia, obustronne oszacowanie),
   `TriangularGaussian` (indukcja wieży z dowolnymi shear-shiftami,
   `triangular_mass_bounds`), `A2Theta` (theta A2), `T5ThetaNumeric`
   (`centered_product_theta`: ∏1536 bloków − 1 < 2^-40 przy liściach ≥ 991),
   `StableLeafAlgebra`/`StableLeafSchedule` (pivoty binary/ternary,
   reciprocal reversal, `full_lower_gives_upper`), `KeygenLeafGate`
   (accepted scan → wartości liści ≥ 1024 > 991).
4. **Otwarte ogniwa (uczciwie)**:
   - **K-źródło**: brak definicji `successfulKeyGen` (nie istnieje nigdzie
     w Lean) oraz kernelowego dowodu source KeyGen→exact LDL/leaves.
     wg M6_BINDING_STATUS to obowiązek K; nie wolno definiować kluczy
     przez FiniteFlat/CoefficientRange/żądaną deltę. Zakres TASK §6.1
     dopuszcza jawny rozkład na nazwane prymitywy + kernelowe redukcje.
   - **Wieża/konsumpcja**: brak konstrukcji `Tower`/Certificate z konkretnej
     macierzy Gram klucza i równości jej masy z `fiberMass` (M6: „równości
     jego masy z masą konkretnego włókna i poprawnej wspólnej skali").
   - **Transport infinite→box**: jednolity ogon propozal box ±65535 dla
     wszystkich kosetów i obu skal (do zrobienia; rachunkowo trywialny:
     poza boxem Q ≥ 65536²/2, e^{-1820}-rzędów ≪ 2^-40).
   - **Skala tilted**: tożsamość `v(7α/8)=(8/7)^1536*v(α)` (homogeniczność
     `continuousMass`, kernelowo przez potęgi).
5. **Piny kontekstu T5**: `inputs/legal_key_context/MANIFEST.sha256`
   (manifest `1fdf82136da325eec6727eae14a89f31be368af113a8210170b7d3c339084bab`),
   T5/GLOBAL_LEAF_A2_BRIDGE.md (dokument analityczny, status
   PROVED_CANDIDATE_PENDING_DUAL_REVIEW, bez plików Lean), THEOREM.md,
   SOURCE_BINDINGS.json, DEPENDENCY_BINDINGS.json.

### Plan modułów (roboczy)

- `Run2/T5CosetScale` — prymityw wspólny F1–F3: transport infinite→box,
  granice nieskończonej sumy kosety z certyfikatu liści/wieży,
  tożsamość skali tilted.
- `Run2/T5KeyGenQuant` — definicja `successfulKeyGen` (równania NTRU +
  mandatory gate + stable schedule; NIE przez FiniteFlat) i łańcuch
  gate→liście≥991.
- `Run2/T5FlatReject` — złożenie: prymitywy → `finiteFlat_from_box_normalizers`
  + `actual_rejection_from_box_normalizers` → teza główna TASK §1.
- Checkers Sage dla nowych faktów liczbowych (ogon boxa, marginesy).

Rytm: raporty dla właściciela po etapach (+ wynik każdego jobu w raporcie),
wpis w WORK_STATE po etapie; procesy Lean/Sage tylko przy czystym tle.
Właściciel doprecyzował rytm 2026-09-24: **stop tylko przy ciężkich jobach
(>~5 min)**; lekkie joby lecą ciągle, wynik każdego w raporcie etapu.

## 2026-09-24 — etap 1: diagnostyka + T5GateBudget (budżety gate≥1023)

Wykonawca: MiMo V2.6 Pro, sesja `ses_f2afd6557ffeaDS2QhN7jZNU9b`.

- Job `t5_diagnostic_001` (exit 0, accepted, 2.1s): closure 124 oleanów
  sprawna; `#print axioms` dla 9 kluczowych redukcji Run2 — wyłącznie
  propext/Classical.choice/Quot.sound.
- `run/formal/Run2/T5GateBudget.lean` — joby 001-003 odrzucone (iteracje
  składni: `unfold at` na nazwie lematu, kierunki linarith, `mul_rpow`/
  rpow zastąpione sqrt, nieużyte argumenty, `ring` po domkniętym `field_simp`),
  **`t5_gate_budget_006`: exit 0, accepted**. Co dowodzi kernel:
  - `gateLeafFloor = 1023` (combined list; q²/332054 = 1023.25),
    `gateCoefficientCap = 18433^2/(1023*2*pi*768^2)`;
    `gate_log_margin`: 50·ln2 < π/cap (margines 0.396);
    `gate_row_exponential`: exp(-π/a) ≤ 2^-50 dla a ≤ cap;
  - `productLo = 1-3072*x`, `productHi = 1/(1-3072*x)`, x = 2/(2^50-1):
    `product_sandwich` — masa wieży `Tower 3072` z `LocalExponent gateRatio`
    leży w (1±~2^-37.4)·scale — **w budżecie FiniteFlat 2^-36** (droga
    991/2^-34 z T5ScalarMass jest za luźna; obie precyzje rozdzielone);
  - `flat_factor_margins`: (1-2^-36)·productHi ≤ productLo ∧ productHi ≤
    (1+2^-36)·productLo ∧ productHi/productLo ≤ 17/16 (norm_num, exact);
  - `continuousMass_scale`, `tilt_const_power`, `scale_tilt_ratio`:
    dokładna tożsamość skali tilted `(8/7)^1536` (sqrt/ℕ-potęgi, bez rpow).

## 2026-09-24 — etap 2: T5CosetScale + T5KeyGenQuant (redukcje i kwantyfikacja)

- `run/formal/Run2/T5CosetScale.lean` — **`t5_coset_scale_002`: exit 0,
  accepted**. `CosetScaleCert h` (wspólna skala v; F1-F3 przy alpha i
  alpha-alpha/8) → kernelowo `flat_of_coset_scale` (FiniteFlat h 2^-36 przez
  `NormalizerComparison.finiteFlat_of_common_scale`), `tilted_ratio_
  of_coset_scale` (≤ 17/16·(8/7)^1536), `reject_of_coset_scale`
  (`rejection h c < 2^-24` przez `RejectionNumericMargin`), oraz
  `flat_reject_of_coset_scale`.
- `run/formal/Run2/T5KeyGenQuant.lean` — job 001-002 odrzucone (zła nazwa
  namespace `QuotientOperations`→`CoefficientQuotient`, `exact_mod_cast`
  jako taktyka, konstrukcja pary argumentów), **`t5_keygen_quant_003`:
  exit 0, accepted**. Co dowodzi kernel:
  - `successfulKeyGen h` = dokładne równania NTRU materiału klucza +
    **akceptacja mandatory gate** (768 słów, `scan words 0#32 = 0#32`) —
    bez nowej selekcji i bez definiowania kluczy przez FiniteFlat/
    CoefficientRange/żądaną deltę (zakaz M6/K);
  - `accepted_value_upper` (mirror accepted_value_lower dla `upperBits`):
    wartości bramki w [1024, 332054] (dokładnie 1024.02…332053.48);
    `gate_scan_values`;
  - propagacja przedziałów [lo,hi] przez CAŁY stable schedule: average,
    harmonic, ternary0/1/2 (średnie ważone — nowe lematy), pairMap,
    tripleMap, binaryLeaves, primary, reciprocal, oraz `gate_full_floor`:
    combined list `full (18433^2) 8` ma wszystkie liście ≥ 1023 —
    **dokładnie podłoga zużywana przez budżet gate**; to jest kernelowy
    łańcuch kwantyfikacji (C): mandatory gate → liście ≥ 1023 → cap
    współczynników → margines mieszczący się w flatBudget.

## 2026-09-24 — etap 3: T5FlatReject (złożenie) + checker Sage

- `run/formal/Run2/T5FlatReject.lean` — **`t5_flat_reject_001`: exit 0,
  accepted**. `T5AnalyticObligation : Prop` (nazwana przesłanka analityczna
  w wzorcu RadialObligations; składniki (a) source/leaf binding,
  (b) Poisson/LDL per coset i shift, (c) transport infinite→box — opis
  matematyczny w `run/T5_ANALYTIC_OBLIGATION.md`, wraz z kluczową
  tożsamością completing-squares `Q(x_c+Bu) = (u+v)^T G (u+v)` — reszta
  dokładnie 0, bo B kwadratowe). Twierdzenia:
  - `all_key_flat_reject`: `∀ h, successfulKeyGen h → FiniteFlat h
    flatBudget ∧ (∀ c, rejection h c ≤ rejectBudget)` (z obligation),
  - `all_key_flat_reject_obligation`: kształt dosłowny TASK §1,
  - `all_key_three_digits`: `(1265)/10^27 < delta h < (1275)/10^27`
    warunkowo na rawBad enclosure (warstwa (b)/R — poza zakresem TASK §8).
  `#print axioms`: 8/8 głównych twierdzeń wyłącznie
  propext/Classical.choice/Quot.sound.
- Checker `run/sage/check_t5_flat_reject_margins.sage` (natywny
  `sage <plik>.sage` przez runner, tryb preparsera), job
  `t5_flat_reject_margins_001`: exit 0, accepted, 35.9s; **12/12 PASS**
  (exact ZZ/QQ + Arb512, bez RDF/RNG). Piny w receipcie
  `t5_flat_reject_margins_result.json`: lowerValue 4503601027220343/
  4398046511104 (=1024.02), upperValue 356537342113749/1073741824
  (=332053.48), leafFloor 339775489/332054 (=1023.25), log margin
  34.65736 < 35.05385, coordinateTail(65536) ≈ 1.37e-1188,
  boxTail(3072·) ≈ 4.2e-1185 ≤ 2^-2800.

## Stan końcowy sesji (handoff, bez freeze)

**Wykazano kernelowo** (nowe moduły, wszystkie joby accepted, czyste logi,
tylko standardowe aksjomaty):
redukcja tezy TASK §1 do nazwanej przesłanki analitycznej + pełny łańcuch
kwantyfikacji (mandatory gate → wartości liści [1024,332054] → combined
stable schedule ≥ 1023 → cap współczynników 2^-50/kolumna → odchylenie
2^-37.4 < próg flat 2^-36) + dokładna tożsamość skali tilted (8/7)^1536 +
warunkowe trzy cyfry dla wszystkich successfulKeyGen (przy hraw).

**Zostaje otwarte (nie mylić z brakiem redukcji)** — `T5AnalyticObligation`,
opis w `run/T5_ANALYTIC_OBLIGATION.md`:
1. source/leaf binding: 768 słów gate ↔ liście dokładnego block-LDL
   Grama (refinement falcon-keygen; pinned T5-a2 to dokument, nie Lean);
2. konsumpcja wieży z konkretnej macierzy Gram (`Tower 3072` + równość
   mas z `fiberMass`/infinite + wspólna skala — tożsamość
   completing-squares podana w dokumencie);
3. transport infinite→box: marginal transfer ogonów (sam cap liczbowy
   już certyfikowany: 2^-2800 z ogromnym marginesem).
Poza zakresem: warstwa (b)/R rawBad enclosure, bezpieczeństwo kodu, PRNG.

Znane lekcje składni (dopisane do puli RUN_002): `structure` w `: Prop`
nie może nieść danych (użyć `∃`-def); `set_option exponentiation.threshold`
przy potęgach 1536; `unfold X at h` wymaga lokalnego `have`, nie nazwy
lematu; `exact_mod_cast` to taktyka (`by exact_mod_cast`); `field_simp`
potrafi domykać cel całkowicie (zbędne `ring` = „No goals"); nazwa
namespace w `open` musi być dokładna (QuotientOperations.lean ma
namespace CoefficientQuotient).

Status: WORKING, bez freeze, bez Git. Zakończonych jobów nie wznawiać.

## 2026-09-25 — etap (c2-4): coord_tail_bound — per-coordinate Chernoff kernelowo

Kontynuacja „jedzoiemy". Wykonawca: MiMo V2.6 Pro, ta sama sesja.

- `run/formal/Run2/T5Tail.lean` — joby 017-043 iterowane (bisect timeoutu:
  winowajcą był `congr`/łańcuchy `.add/.mul_left` na funkcjach tsum ≡
  defeq przez `Real.exp`→ℂ; fix: jawne formy + transport `Eq.mpr/mp` +
  `rw [show … by ring]` zamiast `congr 1`; nazwy: `Summable.tsum_le_tsum
  (h) (hg)`, `hf.tsum_add hg`, `hf.tsum_le_tsum hpt hgmaj`),
  **`t5_tail_044`: exit 0, accepted**. Co dowodzi kernel:
  - `chernoff_exp_core`: `1 ≤ e^{-tL+tz} + e^{-tL-tz}` dla |z| ≥ L, t ≥ 0;
  - `coord_tail_pointwise`: wskaźnik ogona ≤ `e^{-tL}·(e^{-aQ+tz} + e^{-aQ-tz})`;
  - `tilt_summable`: Summable tiltowanej funkcji włókna (przez wieżę);
  - **`coord_tail_bound`**: `∑' (ogon i-tej współrzędnej) ≤
    2·e^{-t·65536 + t²(1/3)/a}·(productHi·certScale)` — z `tilt_sum_bound`
    (uniform MGF) dla obu znaków t.
- Audyt `t5_tail_audit_002`: 4/4 wyłącznie propext/Classical.choice/Quot.sound.

### Został montaż końcowy (wąski, plan domknięty)

1. Union 3072 współrzędnych + dekompozycja boxa (`Equiv.sumCompl`-split;
   `fiberEmbed`/`decode_injective` są) →
   `infFiberMass - fiberMass ≤ 3072 * coord_tail_bound(65536, t=1/12)`.
2. Stała: `t := 1/12` daje wykładnik `e^{-2730.67}`; kernelowo przez
   log/exp bounds (margines bezpieczny) → `≤ 2^-2800*v` (cap checkera).
3. Wpięcie: `BoxTransportCert` (tail-only) domknięty →
   `flat_reject_of_towers` → **teza TASK §1 z dwóch certyfikatów**.

Lekcje (ostatnie): `congr`/taktyki strukturalne na funkcjach tsum z
`Real.exp` powodują defeq-eksplozję (exp → ℂ) — używać `rw [show … by
ring]` i transportów `Eq.mpr/congrArg Summable`; `Summable.tsum_le_tsum`
kolejność (punktowo, Summable); `hf.tsum_add hg` metodycznie; bisect
`sorry`-obcinaniem szybko lokalizuje whnf-timeouty.

## 2026-09-25 — etap (c2-3): uniform-MGF kompletny kernelowo

Kontynuacja montażu ogona. Wykonawca: MiMo V2.6 Pro, ta sama sesja.

- `TiltCert` rozszerzone o **`varEq`** (odpowiedź Riesz każdej współrzędnej
  = 1/3 — postać `diag(M^-1) = 4/3` bloków A2; stała **niezależna od
  klucza** → σ̂² = 1/(3a) = 393216 dla a = alpha).
- `run/formal/Run2/T5Tail.lean` — **`t5_tail_015` i `t5_tail_016`:
  exit 0, accepted** (+ fixy: `open ShiftedGaussian`, `maxRecDepth`,
  koercja `w : Fin 3072 → ℝ`, kierunki `hq1`/`tsum_mul_left`, brak
  argumentu `t`). Co dowodzi kernel:
  - `certScale`/`certScale_eq` — wspólna skala Cholesky-wież
    (przesunięcia niewidoczne);
  - **`tilt_sum_eq`** — tożsamość uniform-MGF na poziomie tsum:
    tiltowana masa włókna = `e^{t·(t/a)·GForm ρ_i} · total(wieża w
    przesuniętym shifcie)` (przez `coordinates`-Equiv + `quad_choleskyTower`
    + `tilt_tower_quad` + `total_eq_tsum`);
  - **`tilt_sum_bound`** — `M(t) ≤ e^{t²·(1/3)/a}·(productHi·certScale)`
    — jednolita granica MGF ze skalą niezależną od c i od przesunięcia
    (dokładnie gwarancja T5 „każdy realny shift").
- Audyt `t5_tail_audit_001`: 5/5 wyłącznie propext/Classical.choice/Quot.sound.

### Ostatni element (c) — montaż ogona (wąski, plan domknięty)

1. Chernoff per współrzędna: `1[|z_i| ≥ 65536]·e^{-aQ} ≤ e^{-tL}(e^{t z_i}
   + e^{-t z_i})·e^{-aQ}` (punktowo) → `≤ 2·e^{-tL + t²/3a}·productHi·v`
   przy `t := 1/12` (optymum: L/(2σ̂²) = 65536/786432) — wykładnik
   `e^{-2730.67}`; stała **weryfikowalna kernelowo** przez log/exp bounds
   (margines: 2730.7 ≫ 2813·ln2·(1/2)-ish — bezpieczny).
2. Union 3072 współrzędnych + dekompozycja boxa (`Equiv.sumCompl`-split +
   bijekcja decode/encode — `fiberEmbed`/`decode_injective` już są) →
   `infFiberMass - fiberMass ≤ 3072·2·e^{-2730.7}·productHi·v ≤ 2^-2800·v`.
3. `BoxTransportCert` (tail-only) domknięty → `flat_reject_of_towers`
   zamyka tezę TASK §1 z dwóch certyfikatów (`CholeskyKeyCert+TiltCert`
   algebraiczny/source + tail).

## 2026-09-25 — etap (c2-2): tilt_tower_quad — uniform-MGF kernelowo

Kontynuacja montażu ogona. Wykonawca: MiMo V2.6 Pro, ta sama sesja.

- `run/formal/Run2/T5Tilt.lean` — **`t5_tilt_007` (po 005-006): exit 0,
  accepted**. `GForm_smul`, `GBil_smul_right/left` (skalowanie kwadratu/
  formy) + wcześniejsze `GBil`/`GForm_add_shift`/`GForm_sub_shift`/
  `gform_tilt_completion`.
- `run/formal/Run2/T5Tail.lean` — joby 001-011 iterowane (kaskada nazw;
  `nlinarith` nie widzi monomów `a·k·X` — stopień 3; `linear_combination`
  ring nie domyka z `a⁻¹`; **tożsamość `a·(t/a)=t` fałszywa dla a=0 →
  wymagane `0 < a`**; rozwiązanie: `set k := t/a` + `set P := k*E`
  (atomizacja) + podstawienie `t → a·k` przez `rw [← hka]` przed `ring`),
  **`t5_tail_012`: exit 0, accepted**. Co dowodzi kernel:
  - `TiltCert` — rozszerzenie certyfikatu: `lin` (rzut i-tej współrzędnej
    primalnej na współrzędne w), `rho` (odpowiedź Riesz/inverse-Gram),
    `lin_spec`, `rho_spec`, **`muZero`** (przesunięcie completing-squares
    rzutuje na rep kosety — kernelowa postać B·G⁻¹·Bᵀ = M⁻¹);
  - **`tilt_tower_quad`** — teza uniform-MGF: przekrzywiony wykładnik
    kosety = wykładnik wieży w przesuniętym shifcie **+ czysty składnik
    kwadratowy `t·(t/a)·GForm ρ_i`** (brak składnika liniowego!). To
    gwarantuje `M(t) ≤ e^{t²σ̂²}·productHi·v` ze skalą niezależną od c i
    wykładnik Chernoffa `e^{-L²/(4σ̂²)} = e^{-2730.6}` dla L = 65536 —
    dokładnie stała z checkera Sage.

### Pozostało do zamknięcia (c) — wąskie i opisane

1. Transport `tilt_tower_quad` → tożsamość tiltowanej sumy tsum
   (tor `infFiberMass_summable` + `quad_choleskyTower`) i granica
   `M(±t) ≤ e^{t²σ̂²}·productHi·v` (product_sandwich + scale-invariance).
2. Chernoff per współrzędna + union 3072 + dekompozycja boxa
   (`Equiv.sumCompl`-split) + cap 2^-2800 z checkera → tail-only
   `BoxTransportCert` → `flat_reject_of_towers` zamyka tezę TASK §1.
Lekcje: `nlinarith` ≤ stopień 2 w atomach (atomizuj iloczyny przez `set`,
  ale NIE rozjeżdżaj terminów cel/fakty); `rw [← hka]` przed `ring`;
  `set` nie przenosi hipotez (spójność terminów cel↔hipotezy krytyczna);
  warunek `0 < a` wymagany przez tożsamości ilorazowe.

## 2026-09-25 — etap (c2-1): warstwa kwadratowa tiltu (uniform MGF)

Kontynuacja „jedziemy" — ogon (c). Wykonawca: MiMo V2.6 Pro, ta sama sesja.

- `run/formal/Run2/T5Tilt.lean` — joby 001-003 odrzucone (sum_congr vs
  `∑ = ∑ + ∑` — fix przez `← Finset.sum_add_distrib`; brak `GBil_sub_right`;
  asymetria `mul_add` vs `add_mul` w celach per-j — zbędne `ring`),
  **`t5_tilt_004`: exit 0, accepted**. Co dowodzi kernel:
  - `GBil` — forma dwuliniowa kwadratu Cholesky'ego + add/sub/symm;
  - `GForm_eq_GBil`, `GForm_add_shift`, `GForm_sub_shift` — rozwinięcia
    kwadratowe wokół przesunięć;
  - **`gform_tilt_completion`** — completing-squares z perturbacją
    liniową: odjęcie `2*GBil rho w` przesuwa slot liniowy o `rho` i zmienia
    wartość o jawny składnik stały. To jest kernelowa postać kroku
    „uniform MGF" — tilt masy kosety = wieża z przesuniętym shiftem ×
    jawny mnożnik e^{składnik kwadratowy w t}.

### Projekt domknięcia ogona (dokładnie, dla kontynuacji)

Wykładnik Chernoffa dla współrzędnej i: `t*μ̂_i + t²σ̂²` z
`σ̂² = GForm r_i/a = 1/(3a)` (r_i = odpowiedź Riesz współrzędnej) — optimum
`t = L/(2σ̂²)` daje `e^{-L²/(4σ̂²)} = e^{-2730.6}` dla L = 65536 — **dokładnie
stała z checkera Sage** (coordinateTail65536 ≈ 1.37e-1188).
Tożsamość `μ̂_i = 0` (brak składnika liniowego!) wynika algebraicznie:
przesunięcie completing-squares jest rzutem rep na kosę (B kwadratowe ⇒
reszta = 0); formalnie wymaga w certyfikacie danych `resp` (odpowiedź
Riesz/inverse-Gram) + `muZero` (rzut shiftOf na rep = rep) — czysta
algebra źródłowa (B·G⁻¹·Bᵀ = M⁻¹).
Dalej: tilt-tower z `tiltTower`/`gform_tilt_completion` (współczynniki te
same ⇒ skala v bez zmian), granica `M(t) ≤ e^{t²σ̂²}*productHi*v`,
union po 3072 współrzędnych + cap 2^-2800 z checkera → tail-only
`BoxTransportCert` domknięty → `flat_reject_of_towers` zamyka tezę TASK §1.

Lekcje: `Finset.sum_congr` wymaga `∑ = ∑` (dla `∑ = ∑ ± ∑` najpierw
`← sum_add_distrib`); `mul_add` nie rozkłada `(A+B)*C` (asymetria zadań
per-j); jawnie podawać `d L` przy wywołaniach lematów z jawnymi
parametrami.

## 2026-09-25 — etap (c1): kierunek monotoniczny transportu kernelowo

Kontynuacja „lecimy dalej" — strona (c): `fiberMass ≤ infFiberMass`.
Wykonawca: MiMo V2.6 Pro, ta sama sesja.

- `run/formal/Run2/T5BoxBound.lean` — joby 001-008 iterowane (brak
  `import GaussianFiberTilt` w łańcuchu → kaskada `open`; nawiasy w
  formach `hform`; `HasSum.congr`/`Filter.Tendsto.congr` zły kierunek —
  fix przez transport `Eq.mpr/congrArg Summable`; `rw` z `Decidable`-
  zależnością — fix przez `simp only [hkey]` z `hkey := rfl`; **lambda do
  `Finset.map` bez `Embedding` zostawiała metazmienne → whnf timeout** —
  fix przez jawny `fiberEmbed`; nazwy: `Summable.sum_le_tsum`,
  `exact_mod_cast` dla Nat/Int), **`t5_box_bound_009`: exit 0, accepted**.
  Co dowodzi kernel:
  - `decodeVec_injective`/`decode_injective`/`fiberEmbed` — iniektywne
    osadzenie box-fiber w podtyp włókna;
  - `infFiberMass_summable`: Summable funkcji włókna przez wieżę
    (tower_summable + comp_injective przez `idx` i `coordinates`-Equiv);
  - **`fiberMass_le_infFiberMass`** — kierunek monotoniczny transportu:
    skończona masa boxa ≤ nieskończona masa kosety (nonneg + finset ≤ tsum);
  - `tiltedTowerRep` — rep-tłumaczenie tiltu kernelowo (bez drugiego
    wejścia algebraicznego).
- `run/formal/Run2/T5BoxTransport.lean` — **`t5_box_transport_005`:
  exit 0, accepted**. `BoxTransportCert` zredukowany do **SAMEGO OGONA**
  (`infFiberMass - fiberMass ≤ 2^-2800*v`); oba kierunki monotoniczne
  wyprowadzane kernelowo (także w skali tilted przez `tiltedTowerRep`).
  `flat_reject_of_towers` bez zmian: `KeyTowerTransportCert h → FiniteFlat h
  flatBudget ∧ (∀ c, rejection h c ≤ rejectBudget)`.
- Audyt `t5_box_audit_001`: 5/5 wyłącznie propext/Classical.choice/Quot.sound.

### Stan po (c1): jedno wejście algebraiczne + jeden ogon

`CholeskyKeyCert` (gramEq/coefBound/flat) → [kernel] → `KeyTowerCert` →
(+ `BoxTransportCert` = tail-only) → [kernel: flat_reject_of_towers] →
teza TASK §1. Pozostające NAZWANE wejścia:
1. **gramEq + coefBound + flat** — Cholesky konkretnego Grama (block-LDL
   z T5-a2 + source refinement liści);
2. **tail** — uniform out-of-box: transfer marginalny (analityka) + cap
   2^-2800 (liczba certyfikowana checkerm Sage).
Lekcje dopisane: `open`-kaskada przez brak importu; `Finset.map` wymaga
`Function.Embedding` (lambda w wyrażeniu → metazmienne/whnf);
`Summable.sum_le_tsum` (s, h, hf); transport `Eq.mpr (congrArg Summable _)`
zamiast `congr`-taktyk dla Summable.

## 2026-09-25 — etap (b2): quadEq dla konkretnego Grama — warstwa kernelowa

Właściciel: „jedziemy" — kontynuacja od quadEq (completed squares).
Wykonawca: MiMo V2.6 Pro, ta sama sesja.

- `run/formal/Run2/T5Cholesky.lean` — joby 001-002 odrzucone (linter
  nieużytych zmiennych we wzorcach; `simp [Fin.lt_def]` pętla — fix przez
  `rw [Fin.lt_def]`; beta-czerwonych wyrażeń w `rw` — fix przez
  beta-czyste formy + `simp only`; brak domknięcia eta w `pointsOf_coordsOf`),
  **`t5_cholesky_003`: exit 0, accepted**. Co dowodzi kernel:
  - `pointsOf`/`coordsOf`/`coordsOf_pointsOf`/`pointsOf_coordsOf`/
    `pointsEquiv : (Fin n → ℤ) ≃ Points n` — pakowanie współrzędnych;
  - `GForm d L x = ∑ j, d j*(∑ i, L j i*x i)^2` (forma x^T L^T D L x);
  - `choleskyTower k d L v` — wieża z danych Cholesky'ego (współczynniki
    k*d_j, shear-shifty z wierszy L i przesunięcia v);
  - **`quad_choleskyTower` — twierdzenie completed-squares**: dla unit-lower
    L i dowolnego realnego przesunięcia `quad (choleskyTower k d L v)
    (pointsOf z) = k*GForm d L (z+v)` (indukcja + `GForm_succ`);
  - `localExponent_choleskyTower`: `LocalExponent gateRatio` z boundów
    współczynników (cap bramki).
- `run/formal/Run2/T5CholeskyCert.lean` — **`t5_cholesky_cert_003`:
  exit 0, accepted**. `CholeskyKeyCert h a` = materiał klucza (równania
  NTRU) + dane (d, L, flat : (Vec×Vec) ≃ (Fin 3072 → ℤ)) + unit-lower/
  unit-diag + `coefBound` (współczynniki ≤ cap z liści ≥ 1023) + **jedyna
  tożsamość algebraiczna `gramEq`** (wielomianowa tożsamość na punktach
  całkowitych) + `shiftOf : Rq → Fin 3072 → ℝ`. Kernelowo:
  `towerRep_of_cholesky` (→ TowerRep z T5TowerMass) i
  `keyTowerCert_of_cholesky` (→ KeyTowerCert; skala wieży = ∏
  continuousMass(k*d_j), **niezależna od c** — `scale_choleskyTower`).
- Audyt `t5_cholesky_audit_001`: 7/7 twierdzeń wyłącznie
  propext/Classical.choice/Quot.sound (równoważność współrzędnych nawet
  bez Classical.choice).

### Stan po (b2): pełny łańcuch kernelowy z minimalnym certyfikatem

`CholeskyKeyCert` → [kernel] → `TowerRep` → [kernel] → `KeyTowerCert` →
(+ `BoxTransportCert`) → [kernel: T5BoxTransport.flat_reject_of_towers] →
teza TASK §1: `FiniteFlat h (2^-36) ∧ (∀ c, rejection h c ≤ 2^-24)`.

Pozostające NAZWANE wejścia (nic więcej):
1. **`gramEq`** — tożsamość Cholesky'ego konkretnego Grama (dokładny
   block-LDL z T5-a2: pivoty d z liści schedule, unit-lower L,
   per-target real shifts) + `coefBound` (liście ≥ 1023 → cap; to już
   kernelowo wyprowadzalne z T5KeyGenQuant.gate_full_floor przy dowiązaniu
   słów bramki do liści) + `flat` (pakowanie współrzędnych materiału).
2. **`BoxTransportCert`** — (c): monotoniczność fiberMass ≤ infFiberMass
   + uniform tail ≤ 2^-2800·v (liczba certyfikowana checkerm Sage).
Po domknięciu (1)+(2): teza TASK §1 dla wszystkich successfulKeyGen
gotowa kernelowo. Poza zakresem: warstwa (b)/R, bezpieczeństwo kodu, PRNG.

## 2026-09-25 — etap (b): warstwa wieżowa kernelowo + most transportu

Właściciel: „jedziemy od b" — kontynuacja w tym W od obowiązku
Poisson/LDL. Wykonawca: MiMo V2.6 Pro, ta sama sesja.

- `run/formal/Run2/T5TowerMass.lean` — joby 001-003 odrzucone (brak
  `open ActualNTRUFiber` → kaskada autoImplicit; kształt wzorców rekursji
  na `Tower`; `-π/a` vs `-(π/a)` w linarith — fix przez `neg_div` +
  `neg_le_neg`; wielonazwowy binder pól struktury parsowany jako pi-typ —
  pola po jednej linii; kolejność `rw` przy przekształceniach ilorazu),
  **`t5_tower_mass_004`: exit 0, accepted**. Co dowodzi kernel:
  - `quad`/`atom_eq_exp`: wieża = kwadrat postaci completed-squares,
    `atom T z = exp(-π*quad T z)`;
  - `tiltTower` + `quad_tiltTower`/`scale_tiltTower`/
    `localExponent_tiltTower`: globalny tilt mnoży kwadrat przez k, skaluje
    `scale` o `(1/√k)^n` i zachowuje `LocalExponent` (przy k ≤ 1);
  - `total_eq_tsum`: `total T` = nieskończona suma po współrzędnych przez
    bijekcję `idx : (Vec×Vec) ≃ Points 3072`;
  - `infFiberMass` + `infFiberMass_basis` (gaussian_fiber_in_basis) +
    `infFiberMass_eq_quad`: **kluczowa redukcja — tożsamość
    completed-squares (quadEq) ⇒ masa włókna = `total T`**;
  - `TowerRep` (certyfikat algebraiczny: materiał klucza + wieża +
    quadEq + `LocalExponent gateRatio`) oraz `infFiberMass_bounds`,
    `infFiberMass_tilted` (przechylone (8/7)^1536 wyprowadzone **kernelowo
    z tego samego certyfikatu** — bez drugiego wejścia algebraicznego),
    `KeyTowerCert`/`inf_bounds_of_keyTower` (wspólna skala v dla wszystkich
    c — skale wież nie zależą od shear-shiftów).
- `run/formal/Run2/T5BoxTransport.lean` — **`t5_box_transport_002`:
  exit 0, accepted**. `transportBudget = 2^-2800` (pin checkera Sage),
  `BoxTransportCert` (dwa kierunki monotoniczne + uniform tail), nowe
  marginesy `transport_factor_margins` (exact QQ, lower factor
  productLo−2^-2800 — mieści się w budżecie 2^-36) oraz teza mostu:
  `flat_reject_of_towers : KeyTowerTransportCert h → FiniteFlat h
  flatBudget ∧ (∀ c, rejection h c ≤ rejectBudget)` — **cały łańcuch
  kernelowy między dwoma certyfikatami a tezą TASK §1**.
- Audyt `t5_tower_audit_001` (exit 0, accepted): 8/8 nowych twierdzeń
  wyłącznie propext/Classical.choice/Quot.sound.

### Nowy, minimalny stan otwartych zobowiązań (po etapie (b))

1. **(b-algebra/source)** `TowerRep`/`KeyTowerCert`: dla każdego
   successfulKeyGen zbudować wieżę 3072 z pivotów block-LDL Grama
   (stable leaf schedule z bramki) i dowieść quadEq (completed squares:
   `Q(x_c + B u) = (u+v)^T G (u+v)` — reszta **dokładnie 0**, bo B
   kwadratowe) + `LocalExponent gateRatio` (z liści ≥ 1023 → cap).
   Czysta algebra + refinement źródła; zero probabilistyki.
2. **(c-transport)** `BoxTransportCert`: monotoniczność (fiberMass ≤
   infFiberMass — potrzebna Summability/nieskończona indukcja) + uniform
   tail ≤ 2^-2800·v (margines z checkera; transfer marginalny).
Po domknięciu (1)+(2) teza TASK §1 jest gotowa kernelowo
(`flat_reject_of_towers` + `all_key_flat_reject`-kształt z T5FlatReject).
Poza zakresem: warstwa (b)/R rawBad enclosure, bezpieczeństwo kodu, PRNG.
