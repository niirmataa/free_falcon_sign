# REPORT — C_TASK_3_REFINE (Warstwa 3: liście → algebra → LDL → Gauss)

Zadanie: domknąć jawne „brakujące utożsamienie" Astry — lista exact leaves
(`StableLeafSchedule`) = LDL konkretnego coefficient Gram (z NTRU-bazy) →
affine shift + skala → trójkątny Gauss/T5 per-key. Wykonanie: MiMo V2.6 Pro,
2026-09-29. Zapisy wyłącznie w tym folderze + `build/`; bez Git; repo i
foldery równoległe tylko-do-odczytu.

## Artefakty

| plik | status | log |
|---|---|---|
| `GramLDL.lean` | build czysty 0 err/0 warn | `build/logs/GramLDL.log` (pusty) |
| `SourceLeafBridge.lean` | build czysty 0 err/0 warn | `build/logs/SourceLeafBridge.log` (pusty) |
| `PerKeyTransport.lean` | build czysty 0 err/0 warn | `build/logs/PerKeyTransport.log` (pusty) |
| `*_audit.lean` (3 pliki) | audyty `#print axioms`: **25/25 tez ⊆ {propext, Classical.choice, Quot.sound}** | `build/logs/*_audit.log` |
| `run2_src/` + `run2_src.SHA256SUMS` | 16/16 pinów OK (zgodne z weryfikowanymi pinami `CENTERING_CLOSURE/run2_src`) | — |
| `sage/check_gram_ldl.sage` | `GRAM_LDL_ALGEBRA_PASS` (QQ, asserty) | `build/logs/check_gram_ldl.sage.log` |
| `CONTRACTS.md` | kontrakt wejścia (W2) + wyjście per-key (FinalDelta) | — |

Zero `sorry`/`admit`/`native_decide`/`Lean.ofReduceBool` (grep przed każdą
kompilacją); zero wyciszeń ostrzeżeń; kompilacja seryjna, strzeżona
(`run_guarded.sh`/`run_sage_guarded.sh`: pgrep lean/sage/lake + wolne okno +
timeout); brak jobów na koniec; wszystkie zapisy pod zadaniem.

## Co wykazano (kernelowo)

1. **GramLDL** — brakujące utożsamienie w warstwie algebry:
   - bloki kanoniczne `pairGram`/`tripleGram`/`a2Gram`/`dualPairGram` mają
     pivotsy LDL **dokładnie** = operacje StableLeafAlgebra
     (`average`/`harmonic`, `ternary0/1/2`, `(lam, 3*lam/4)`, reciprokala
     odwrócona) — z rekonstrukcją `G = L*D*L^T`;
   - `a2_scalar_split`: `lam*(x²+xy+y²) = lam*(x+y/2)² + (3*lam/4)*y²` —
     affine shear `y/2` (niecałkowity) + skala = parametry
     `TriangularGaussian.Tower` (`gaussian_tower_atom`, `towerOfLeaves_scale`);
   - składanie węzłów = rozkład liści ich `binaryLeaves`/`primary`/`full`
     (`nodal*_eq_*` — wywodzone z ich lematów, nie zakładane);
   - **teza**: `toLeaves (ldlPivots 3072 (coefficientGram …)) =
     StableLeafSchedule.full (18433^2) 8 roots` — konkretny Gram z bazy
     `(g,G;−f,−F)` (`ActualNTRUFiber.coefficientBasis` + polaryzacja
     `Geometry.Q`, `qBilinear_self` wiąże z `Q`).
   - audyt axioms: 10/10 tez ⊆ {propext, Classical.choice, Quot.sound}.
2. **SourceLeafBridge** — łańcuch ich kontraktu: `source value ≥ 1024`
   (bramka `KeygenLeafGate.scan`) → `leaf_exact > 991` (kontrakt
   `leaf_error_bound` + budżet `E_leaf < 33`) → `lower ≥ 991` →
   `upper ≤ 18433^2/991` (ich `full_lower_gives_upper`). Sygnatura
   kontraktu dokładnie z `C_TASK_2_FPERROR/CONTRACTS.md` (logika bez zmian).
3. **PerKeyTransport** — złożenie dla **każdego** `h : Adm` (`Adm`
   abstrakcyjny parametr modelu — decyzja właściciela): liście+LDL
   (`perKey_ldl_leaves`) → affine shift/skala (`towerOfScaledLeaves`,
   `perKey_scale`) → `T5ScalarMass.uniform_shifted_mass_3072`
   (`perKey_mass_bounds` + generyczne `mass_bounds_of_leaves`: sandwich
   `(1±2^−34)*scale` dla `total` = wkład per-key do **FinalDelta**), z
   `CoefficientRange` wyliczonym z brzegów liści (`coefficientRange_scaled`,
   przez `SourceLeafBridge.schedule_leaf_bounds`) i mostem włókna
   `perKey_fiber_reindex` (= ich `gaussian_fiber_in_basis`).

## Czego NIE wykazano / granice (niewygodne, jawne)

- **`BasisLeafAlgebra.ldl_shape` (GramLDL) to otwarta premisa algebraiczna
  bazy** — równanie dekompozycji LDL konkretnego Grama na bloki kanoniczne
  o danych spektralnych `roots` (korelacje `(f,g,−f,−F)`). To jest dokładnie
  algebra bazy, której nie da się wyprowadzić z samych równań klucza
  (`Key.ntru`/`public_eq`/`inverse_eq`); typ brakujący dla source
  refinement, jawnie wywołany w strukturze (wzór pól `NTRUBasis.Key`).
  Tożsamość listy liści ze StableLeafSchedule jest wywodzona, nie zakładana —
  ale krok „korelacje bazy → bloki kanoniczne" pozostaje do dostarczenia
  przez source refinement. **Bez niego twierdzenia są warunkowe** (premise
  jawne, nie ukryte).
- **`E_leaf` i `source_binding`** — po stronie Warstwy 2 (`LeafError.lean`,
  u nich „w przygotowaniu"); u mnie jawne w signature. Wymagany budżet:
  `E_leaf < 33` (=`1024−991`). Jeśli ich finalne `E_leaf` wyjdzie ≥ 33,
  wniosek `leaf_exact > 991` nie przejdzie — wtedy trzeba podnieść bramkę
  źródła lub wzmocnić analizę ścieżki leaf.
- Pełna tożsamość atomu na CAŁEJ przestrzeni 3072 (iloczyn atomów par =
  `exp(−k·Q(t+Bu))`) jest domknięta per-para (`gaussian_tower_atom`);
  złożenie globalne idzie przez `ldl_shape` (ta sama sfera algebra bazy).
- Nie dotykałem równoległych `C_TASK_1_BINBIND`/`C_TASK_2_FPERROR`/
  `CENTERING_CLOSURE` ani repo; ich `CONTRACTS.md` czytane jako kontrakt.
- `Adm` jest abstrakcyjne (decyzja właściciela) — nie definiuję zbioru
  dopuszczonych kluczy ani nie twierdzę niepustości `Adm`.
- Uwaga techniczna (jawna): instancjacje `full …` w pozycjach unifikacji
  `CoefficientRange` (match-def) bywają kosztowne dla whnf (~200k heartbeats);
  rozwiązane strukturalnie (teza per-key na `towerOfScaledLeaves (full …)`,
  transport indeksu wewnątrz `mass_bounds_of_leaves` na zmiennych) —
  **bez podnoszenia limitów heartbeats/maxRecDepth**.

## Co wynik zmienia w projekcie

- Brakujące utożsamienie Astry jest domknięte **warunkowo, ale bez ukrytych
  przesłanek**: wszystkie tezy kernelowe, axioms ⊆ standardowe, premise =
  jedno jawne równanie algebraiczne bazy (`ldl_shape`).
- Per-key transport dla FinalDelta jest gotowy do podpięcia
  (`perKey_mass_bounds` ∀ h) — łańcuch: bramka → 991/18433²/991 →
  `CoefficientRange` → sandwich masy.
- Kontrakty W1/W2/W3 są spójne liczbowo (1536 liści, q = 18433, q²/991).

## Następny krok

1. Source refinement: dostarczyć `BasisLeafAlgebra.ldl_shape` (korelacje
   bazy `(f,g,−f,−F)` → bloki kanoniczne) — wtedy `gram_ldl_leaves` staje
   się bezwarunkowy dla konkretnych kluczy.
2. Warstwa 2: finalne `E_leaf` (< 33) + `source_binding` → podpięcie
   `LeafErrorContract` w `SourceLeafBridge`.
3. FinalDelta (CENTERING_CLOSURE/FinalTails): konsumpcja
   `PerKeyTransport.perKey_mass_bounds`.
