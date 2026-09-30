# T5-FLAT-REJECT — dokładny interfejs T5AnalyticObligation

Dokument roboczy W `FT1536_T5_FLAT_REJECT_RUN_001`. Opisuje matematyczną
zawartość nazwanych przesłanek, których domknięcie zamyka tezę TASK §1.
Stan modułów i piny: `WORK_STATE.md`.

**AKTUALIZACJA po etapie (b) (2026-09-25):** interfejs jest już rozłożony
na dwa minimalne certyfikaty kernelowe — `T5TowerMass.TowerRep` /
`KeyTowerCert` (algebra: completed squares + pivoty + cap z bramki) oraz
`T5BoxTransport.BoxTransportCert` (transport infinite→box). Most
`T5BoxTransport.flat_reject_of_towers` wyprowadza tezę TASK §1 kernelowo
z obu. Poniższa sekcja 2 opisuje matematyczną zawartość certyfikatu
wieżowego; sekcja 3 — transportu.

## 1. Co jest już kernelowo domknięte (nie powtarzać)

Łańcuch w `run/formal/Run2/` (joby `t5_gate_budget_006`, `t5_coset_scale_002`,
`t5_keygen_quant_003`, `t5_flat_reject_001`; wszystkie exit 0, accepted, czyste
logi, wyłącznie propext/Classical.choice/Quot.sound):

- `T5GateBudget`: z podłogi liści **1023** (combined list; q²/332054 =
  1023.25) wyprowadza cap współczynników `gateCoefficientCap`, bazę
  `gateRatio = 2^-50`, `product_sandwich` (masa wieży 3072 w
  `productLo/productHi`, odchylenie ~2^-37.4 — w budżecie flat 2^-36),
  `flat_factor_margins` (czynniki do `finiteFlat_of_common_scale` i
  współczynnik `17/16` dla rejectu) oraz `scale_tilt_ratio`:
  `∏ continuousMass((7/8)s_j) = (8/7)^1536 · ∏ continuousMass(s_j)`.
- `T5KeyGenQuant`: `successfulKeyGen` = dokładne równania NTRU
  (`multiply f bigG - multiply g bigF = constantCoeffs 18433`,
  `mulRq h (reduceVec f) = reduceVec g`, odwracalność f) + **akceptacja
  mandatory gate** (`scan words 0#32 = 0#32`, 768 słów) — legalne klucze
  NIE są zdefiniowane przez FiniteFlat/CoefficientRange/deltę. Kernelowo:
  `gate_scan_values` (wartości w [1024, 332054]; nowe `accepted_value_upper`
  dla `upperBits`), propagacja przedziałów przez CAŁY stable schedule
  (average/harmonic/ternary0-2/pairMap/tripleMap/binaryLeaves/primary/
  reciprocal — średni ważone, zachowują [lo,hi]) i `gate_full_floor`:
  combined list `full (18433^2) 8` ma wszystkie liście ≥ 1023.
- `T5CosetScale`: `CosetScaleCert h` (wspólna skala v; F1-F3) → kernelowo
  `FiniteFlat h flatBudget` (przez `NormalizerComparison.
  finiteFlat_of_common_scale`) i `rejection h c < rejectBudget` (przez
  `RejectionNumericMargin.actual_rejection_from_tilted_normalizers` +
  `GaussianFiberTilt.rejection_chernoff`).
- `T5FlatReject`: `all_key_flat_reject` / `all_key_flat_reject_obligation`:
  `∀ h, successfulKeyGen h → FlatRejectObligation h` z nazwaną przesłanką
  `T5AnalyticObligation` (wzorzec RadialObligations) + `all_key_three_digits`
  (warunkowo na rawBad enclosure — warstwa (b)/R, poza zakresem).

Niezależny checker: `run/sage/check_t5_flat_reject_margins.sage`
(job `t5_flat_reject_margins_001`, exit 0, accepted; 12/12 PASS; receipt
`t5_flat_reject_margins_result.json`). Wartości: lowerValue 1024.02,
upperValue 332053.48, leafFloor 1023.25, log margin 34.6574 < 35.0539,
coordinateTail(65536) ≈ 1.37e-1188, boxTail(3072·) ≈ 4.2e-1185 ≤ 2^-2800.

## 2. T5AnalyticObligation — co dokładnie trzeba dostarczyć

```lean
def T5AnalyticObligation : Prop := ∀ h : Rq, successfulKeyGen h → CosetScaleCert h
```

czyli dla każdego `h` z successfulKeyGen istnieje `v > 0` z:

- (F1) `productLo*v ≤ fiberMass h c alpha` dla każdego c,
- (F2) `fiberMass h c alpha ≤ productHi*v` dla każdego c,
- (F3) `fiberMass h c (alpha-alpha/8) ≤ productHi*(8/7)^1536*v` dla każdego c.

Trzy składniki dowodu (zalecana kolejność):

### (a) Source/leaf binding (refinement źródła)

768 zaakceptowanych słów bramki są źródłami liści pierwotnych dokładnego
block-LDL macierzy Grama piwnicy klucza (T5-a2 bridge, GLOBAL_LEAF_A2_BRIDGE).
Z gate_full_floor combined list ≥ 1023, więc każdy liść λ ≥ 1023 i każdy
pivot λ_j ≤ q²/1023. **Nie definiować kluczy przez FiniteFlat/CoefficientRange.**
Most `ActualNTRUFiber.key` + `gaussian_fiber_in_basis` (istnieje) daje
afine reprezentacje włókien w bazie `coefficientBasis f g bigF bigG`.

### (b) Poisson/LDL — porównanie mas per coset i per real shift

Kluczowa tożsamość (dokładna, do formalizacji): dla B = coefficientBasis
(kwadratowe, det = ±q^1536), G = B^T M B (M = metryka A2 = Q), x_c =
(centerRq c, 0):

```
Q (x_c + B u) = (u + G^{-1} B^T M x_c)^T G (u + G^{-1} B^T M x_c)
```

reszta completing-squares jest **dokładnie 0** (B kwadratowe ⇒
M - M B G^{-1} B^T M = 0). Stąd nieskończona masa włókna = `total` wieży
`Tower 3072` z współczynnikami `a_j = alpha*d_j/(2*pi*768^2)`... (równoważnie
`d_j/(pi*1179648)`), gdzie `d_j` to pivoty LDL G, oraz shear-shiftami
`u_j + (L^T v)_j` zwanymi w TriangularGaussian `shift`. Dalej:

- pivoty skalarne (λ, 3λ/4) z liści λ ≤ q²/1023 ⇒ `a_j ≤
  T5GateBudget.gateCoefficientCap`, więc `LocalExponent gateRatio T`
  (kernelowo: `gate_row_exponential`),
- `T5GateBudget.product_sandwich` daje obustronne (1±~2^-37.4)·`scale T`
  — tu schodzi cała siła: **wspólna skala v := scale T nie zależy od c**
  (przesunięcia są w shear-shiftach, `shifted_mass_bounds` jest uniform),
- skala: `scale T = (pi/alpha)^1536/sqrt(det G)`; tilt `alpha → (7/8)alpha`
  skaluje wszystkie a_j i daje `scale T' = (8/7)^1536*scale T`
  (kernelowo: `scale_tilt_ratio`).

Uwaga: droga skalarna przez `T5ScalarMass` (2^-34, liście 991) jest **za
luźna** dla flatBudget 2^-36; tylko podłoga 1023 z mandatory gate daje
potrzebny margines. Nie utożsamiać obu precyzji.

### (c) Transport infinite → finite proposal box

`fiberMass` (skończona, po BoxPair) = nieskończona masa kosety minus ogon
poza boxem ±65535 (istnieje reindeksacja `ActualNTRUFiber.fiber_weight_reindex`
+ `decode`/`encodeVec` dla ograniczenia do boxa). Do (F2)/(F3) starczy
`fiberMass ≤ infinite` (ogon tylko pomaga); do (F1) potrzebny uniform tail:

- wartość numeryczna (checker, Arb512): `boxTail ≈ 4.2e-1185 ≤ 2^-2800`
  (3072·coordinate_tail(65536) dla bloku A2 σ=768),
- warstwa analityczna do formalizacji: marginal transfer — brzegowy ogon
  per coset ≤ (1+2^-40)·ogonu brzegowego 1-D marginesu (ta sama broń
  Poissona/fazy co w (b), „każdy realny shift"), plus union bound po 3072
  współrzędnych. Z ogonem ≤ 2^-2800 wystarczy dowolny transfer ≤ 2^100 —
  margines jest astronomiczny, dowolna poprawna metoda starczy.

Alternatywnie (bez marginesu): ograniczyć sumę wieży do kostki
`|u_j| ≤ 15` (odchylenie σ_u ≈ 1.34; ogon ~2^-77) i pokazać
`|B u|_∞ ≤ 56319` — wymaga wtedy norm wierszy B z liści (do rozważenia).

## 3. Granice zakresu (uczciwie)

- Brak dowodu: source KeyGen→LDL/leaves (refinement falcon-keygen), pełna
  konsumpcja wieży z konkretnej macierzy Gram, transport marginesowy.
  To elementy T5AnalyticObligation, nie nowe założenia o kluczach.
- Poza zakresem: warstwa liczbowa (b) rawBad enclosure (rawLo/rawHi),
  pełne bezpieczeństwo kodu, real PRNG, Sign→Verify.
- `all_key_three_digits` jest warunkowy na hraw (surowa closure radialna).
- Żadnego freeze; status: WORKING.
