# C_TASK_3_REFINE — Warstwa 3: refinement liście → algebra → LDL → Gauss

Folder zadania w W `FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001` (repo tylko-do-odczytu;
zapisy WYŁĄCZNIE w tym folderze + własny `build/`; równoległe C_TASK_* mają
swoje sesje — NIE DOTYKAĆ; `run/check_lib` tylko-do-odczytu).

## Cel

Zszyć wynik numeryczny FPEMU (liście z błędem) z algebrą, którą Astra MA
gotową, i domknąć ich jawne „brakujące utożsamienie": lista exact leaves =
**LDL konkretnego coefficient Gram** → affine shift + skala dla trójkątnego
Gaussa → `ActualNTRUFiber`/`NTRUBasis` (per-key transport).

## Wejścia (kopiować z pinami, jak `CENTERING_CLOSURE/run2_src`)

Czytać, NIE odtwarzać (to jest zamknięte u Astry!):
- `Run2/StableLeafAlgebra.lean`, `Run2/StableLeafSchedule.lean` (tożsamości
  reciprocal, kolejność liści: 3 branches, 8 binary levels, reverse reciprocal;
  `lower ≥ 991 → upper ≤ q²/991`),
- `Run2/NTRUBasis.lean`, `Run2/ActualNTRUFiber.lean` (bijekcja `(g,G;−f,−F)`,
  `gaussian_fiber_in_basis`),
- `Run2/T5ScalarMass.lean`, `Run2/ShiftedGaussian.lean`, `Run2/TriangularGaussian.lean`
  (transport masy trójkątnej — to zasila per-key!).

## Zakres

1. `GramLDL.lean` — **nowy lemat Astry-nie-zrobiony**: dla konkretnego Grama
  (z NTRU-bazy) jego rozkład LDL ma liście dokładne = ich lista stable leaves;
  wyprowadzić z `StableLeafSchedule` + algebra bazy; zawierać affine shift
  i skalę → parametry `TriangularGaussian`.
2. `SourceLeafBridge.lean` — most do Warstwy 2: hipoteza-kontrakt
  `leaf_error_bound : |leaf_computed − leaf_exact| ≤ E_leaf` (sygnatura
  uzgodniona z C_TASK_2_FPERROR/CONTRACTS.md; dostosować nazwy, nie logikę!)
  ⇒ `source value ≥ 1024 → leaf_exact > 991` ⇒ warunki `lower ≥ 991` z
  StableLeafSchedule ⇒ `upper ≤ q²/991`.
3. `PerKeyTransport.lean` — złożenie: liście+LDL → affine shift/skala →
  `TriangularGaussian`/`T5ScalarMass`-per-key dla każdego `h` z `Adm`.

## Start NATYCHMIAST (nie czeka na W1/W2!)

Warstwa 1 i 2 są równoległe; punkty 1 i 3 nie zależą od ich wyników.
Punkt 2 pisz wobec KONTRAKTU (sygnatury w CONTRACTS.md obu zadań) —
zostanie podpięty po ich stronie.

## Zasady (identyczne w projekcie: ZERO sorry/admit/native_decide; grep przed
kompilacją; logi 0 err/0 warn; serialna kompilacja; pgrep przed kompilacją;
python-patche z assert; bez Git; CONTRACTS.md po każdym etapie).

## Kryterium odbioru

`GramLDL` kernelowo bez premises poza algebraicznymi własnościami bazy
(jawne w tezie); `PerKeyTransport` kernelowo dla każdego `h`;
axioms ≤ {propext, Classical.choice, Quot.sound}.
