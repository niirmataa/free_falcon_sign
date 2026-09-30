# CONTRACTS.md — C_TASK_3_REFINE (Warstwa 3: refinement liście → algebra → LDL → Gauss)

Żywy kontrakt: **wejście** (Warstwy 1–2 + Run2) i **wyjście per-key dla FinalDelta**.
Aktualizowany po każdym etapie. Zapisy tylko w tym folderze + `build/`; repo
tylko-do-odczytu; równoległe `C_TASK_1_BINBIND`/`C_TASK_2_FPERROR`/`CENTERING_CLOSURE`
tylko-do-odczytu (ich `CONTRACTS.md` czytane jako kontrakt, nie modyfikowane).

---

## KONTRAKT WEJŚCIA (uzgodniony z warstwami; NIE zmieniamy ich logiki)

### Z Warstwy 2 (C_TASK_2_FPERROR/CONTRACTS.md, poz. `LeafError.lean`)

- `leaf_error_bound : ∀ input, |leaf_computed − leaf_exact| ≤ E_leaf`
  (ich linie 44–46; „nazwy dostosować obustronnie w CONTRACTS, nie zmieniać
  logiki!") — u mnie instancja per-liść w strukturze
  `SourceLeafBridge.LeafErrorContract.leaf_error_bound`.
- `source value ≥ 1024 → leaf_exact > 991` (ich poz. 3, druga część) — to
  domyka `SourceLeafBridge` (Etap 2 tego zadania).
- Ich fakty piny: M0 logn = 10; N = 1536 (MKN(10,1)); q = 18433;
  finalny leaf scan = 1536 słów; PRIMES3 = 2147355649. Zgodne z moim
  `18433^2/991` (q²/991 dla q = 18433) i `StableLeafSchedule.ft1536_full_length`.
- **Otwarte po ich stronie** (nie przesądzam): wartość liczbowa `E_leaf`
  (wymagany budżet: `E_leaf < 33`, bo `1024 − 991 = 33`) oraz ścieżka
  `source_binding : sourceValue ≤ leaf_computed` (wiązanie bramki z wartością
  wyliczaną). Moje tezy mają te przesłanki JAWNIE w signature.

### Z Warstwy 1 (C_TASK_1_BINBIND/CONTRACTS.md) + Run2/Astra

- `KeygenLeafGate.successful_scan_all_leaf_values` (Run2, pin SHA256) ⇒
  `sourceValue = positiveNormalValue w ≥ 1024` dla każdego słowa udanego
  skanu (`scan ws bad).2 = 0#32`) — owinięte jako
  `SourceLeafBridge.source_value_ge_1024`.
- `step_sem`/`fpRound : ℝ → ℝ` z Warstwy 1 jest kontraktem Warstwy 2 —
  Warstwa 3 go nie zakłada (czysta hierarchia).
- Pin binarium M0/flagi/kompilator: wg ich `CONTRACTS.md` Etap 1
  (fpr-emulated.o `bbd78077…`, falcon-keygen.o `b1b319b9…`) — cytowane
  przez Warstwę 2; mi potrzebne wyłącznie jako kontekst pinu liści.

### Z Run2 (Astra, zamknięte — kopie z pinami w `run2_src/`, `run2_src.SHA256SUMS`)

- 16/16 plików hash-zgodnych z weryfikowanymi pinami `CENTERING_CLOSURE/run2_src`
  (sprawdzone 2026-09-29); konsumowane moduły przebudowane od zera do
  własnego `build/` (logi 0 err/0 warn).
- Kluczowe obiekty: `StableLeafSchedule.full/primary/binaryLeaves/tripleMap`,
  `StableLeafAlgebra.average/harmonic/ternary0-2/reciprocal`,
  `NTRUBasis.Key/basis`, `ActualNTRUFiber.coefficientBasis/gaussian_fiber_in_basis`,
  `TriangularGaussian.Tower/atom/scale/total/LocalExponent`,
  `T5ScalarMass.uniform_shifted_mass_3072/CoefficientRange/maxCoefficient`,
  `ShiftedGaussian.continuousMass`, `KeygenLeafGate.*`.

---

## DOSTARCZONE — ETAP 1: `GramLDL.lean` (build czysty 0 err/0 warn, 0 luk)

Audyt `#print axioms` (build/logs/GramLDL_audit.log): **10/10 tez wyłącznie
[propext, Classical.choice, Quot.sound]**.

- Bloki kanoniczne + dokładne rozkłady LDL (rekonstrukcja `G = L*D*L^T`):
  `pairGram` (dane spektralne `(a,b)`) — pivotsy `average`/`harmonic`
  (`pairGram_pivots`); `tripleGram` (`(a,b,c)`, `det = a*b*c`) — pivotsy
  `ternary0/1/2` (`tripleGram_pivots`); `a2Gram` — pivotsy `(lam, 3*lam/4)`;
  `dualPairGram` (q·A⁻¹) — pivotsy odwrócone-reciprokalnie
  (`dualPairGram_pivots`) = krok `reciprocal`+`reverse`.
- `a2_scalar_split`/`block_split`: `lam*(x²+xy+y²) = lam*(x+y/2)² + (3*lam/4)*y²`
  → affine shift `y/2` (niecałkowity shear) + skala → `a2Tower`/`towerOfLeaves`
  (`TriangularGaussian.Tower`); `gaussian_tower_atom` = tożsamość atomu;
  `towerOfLeaves_scale` = skala = iloczyn `continuousMass`.
- Identyfikacja składania węzłów ze StableLeafSchedule:
  `nodalBinary_eq_binaryLeaves`, `nodalPrimary_eq_primary`, `nodalFull_eq_full`.
- Konkretny `coefficientGram` (baza `(g,G;−f,−F)` przez
  `ActualNTRUFiber.coefficientBasis` + polaryzacja `Geometry.Q`;
  `qBilinear_self : qBilinear z z = (Q z : ℝ)`).
- Teza główna `gram_ldl_leaves : toLeaves (ldlPivots 3072 (coefficientGram …))
  = StableLeafSchedule.full (18433^2) 8 roots` — przesłanki JAWNIE w
  `BasisLeafAlgebra` (algebra bazy w duchu pól `NTRUBasis.Key`);
  tożsamość listy liści WYWODZONA (`nodalFull_eq_full`), nie zakładana.
- **Granica (jawna)**: `BasisLeafAlgebra.ldl_shape` = algebraiczna własność
  bazy (postać bloków Grama w `(f,g,−f,−F)`) dla source refinement — typ
  brakujący do pełnej bezprzesłankowości, dokładnie wywołany w strukturze.

## DOSTARCZONE — ETAP 2: `SourceLeafBridge.lean` (build czysty 0 err/0 warn, 0 luk)

Most hipotez-kontraktu Warstwy 2 → `StableLeafSchedule` (logika warstw BEZ
zmian; sygnatura dokładnie z `C_TASK_2_FPERROR/CONTRACTS.md`):

- `LeafErrorContract leaf_computed leaf_exact E_leaf` z polem
  `leaf_error_bound : |leaf_computed − leaf_exact| ≤ E_leaf` — ich sygnatura
  `∀ input, …` w instancji per-liść.
- `source_to_leaf_exact : source value ≥ 1024 → 991 < leaf_exact` (ich poz. 3,
  druga część) — przesłanki jawne: kontrakt + `source_binding :
  sourceValue ≤ leaf_computed` + budżet `E_leaf < 33` (= `1024 − 991`).
- `source_value_ge_1024`/`scan_to_leaf_exact` — wpięcie w bramkę
  `KeygenLeafGate.scan` (`successful_scan_all_leaf_values`).
- `schedule_lower_ge_991` → `schedule_upper_le_q2_div_991` (ich
  `full_lower_gives_upper`): **lower ≥ 991 ⇒ upper ≤ 18433²/991 = q²/991**;
  pakiet `schedule_leaf_bounds` = wejście liczbowe Etapu 3.
- Granica (jawna): wartość liczbowa `E_leaf` i ścieżka `source_binding` są
  po stronie Warstwy 2 (`LeafError.lean`, w przygotowaniu u nich) — u mnie
  występują jawnie w signature, nie jako zakamuflowane założenie.

## DOSTARCZONE — ETAP 3: `PerKeyTransport.lean` (build czysty 0 err/0 warn, 0 luk)

Złożenie per-key dla **każdego** `h : Adm` (`Adm` abstrakcyjny parametr modelu —
dopuszczone klucze, decyzja właściciela; nie definiuję zbioru ani niepustości):

- `pivotScale := 1/(2π·768²)` + `maxCoefficient_eq`:
  `maxCoefficient = (18433²/991)·pivotScale` — skalowanie pivots→`a` zgodne
  z ich `T5ScalarMass.maxCoefficient` (a ≤ maxCoefficient ↔ pivot ≤ q²/991);
- `towerOfScaledLeaves` — wieża `TriangularGaussian` ze skalowanymi pivotsami
  `(3*lam/4, lam)·pivotScale`, shear `y/2`, affine shift per-współrzędna;
  `towerOfScaledLeaves_scale` = skala = iloczyn `continuousMass`;
- `coefficientRange_scaled` — `T5ScalarMass.CoefficientRange` WYŁĄCZNIE
  z brzegów liści (`991 ≤ leaf ≤ 18433²/991` — oba z `SourceLeafBridge`);
- `perKey_ldl_leaves` (liście = LDL pivotsy `coefficientGram` klucza),
  `perKey_scale`, `perKey_fiber_reindex` (= ich `gaussian_fiber_in_basis`
  per-key — tu wchodzi `GramLDL.gaussian_tower_atom`);
- `mass_bounds_of_leaves` (ogólne dla listy liści o długości 1536; transport
  indeksu `2·leaves.length = 3072` do `uniform_shifted_mass_3072`) oraz
- **`perKey_mass_bounds`** — TEZA WYJŚCIA DLA `FinalDelta`: ∀ `h : Adm`
  sandwich `(1−2^−34)·scale ≤ total ≤ (1+2^−34)·scale` na
  `towerOfScaledLeaves (full (18433^2) 8 (rootsOf h)) (shiftOf h)`.

Audyt `#print axioms`: 8/8 ⊆ {propext, Classical.choice, Quot.sound}.
Uwaga techniczna (jawna): instancjacje `full …` w pozycjach unifikacji
`CoefficientRange`-match bywają kosztowne dla whnf — teza per-key jest
wypowiedziana na `towerOfScaledLeaves (full …)` (forma sprawdzona), a
`CoefficientRange` per-key uzyskuje się przez `coefficientRange_scaled`
w dowodzie `mass_bounds_of_leaves`. Bez podnoszenia limitów heartbeats.

## Kontrakt wyjścia dla FinalDelta (konsument: CENTERING_CLOSURE/FinalTails)

Dla każdego `h : Adm`:
- **masa per-key**: `(1 − 2^−34)·scale T_h ≤ total T_h ≤ (1 + 2^−34)·scale T_h`
  z `T_h = towerOfScaledLeaves (full (18433^2) 8 (rootsOf h)) (shiftOf h)`
  (`perKey_mass_bounds`) — wkład do `FinalDelta(h)`;
- **skala**: `scale T_h = ∏ (continuousMass (3·lam·pivotScale/4) ·
  continuousMass (lam·pivotScale))` po liściach (`perKey_scale`);
- **brzegi liści**: `991 ≤ lam ≤ 18433²/991` (`SourceLeafBridge.
  schedule_leaf_bounds`) — z bramki `KeygenLeafGate.scan` + kontraktu W2;
- **most włókna**: `perKey_fiber_reindex` (ich `gaussian_fiber_in_basis`) +
  `GramLDL.gaussian_tower_atom` (tożsamość atomu pary A2 z translacją
  `(centerRq c, 0)`).
