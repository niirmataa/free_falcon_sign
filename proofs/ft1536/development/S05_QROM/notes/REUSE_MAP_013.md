# S05 — mapa ponownego użycia013

Baza tego kroku: `75ae62d6` (po domknięciu dokumentacji BATCH058).
Klasa: **obowiązki dowodowe**, bez nowych założeń kryptograficznych.
To przegląd własnej ścieżki i plan konsumpcji eksportów, nie niezależny odbiór ROM.

Właściciel zwrócił uwagę, że wcześniejsze prace już zawierają znaczną część
ogólnej matematyki. Poniższa mapa rozdziela gotowe eksporty, adaptery i brakujące
instancje. Liczba nowych deklaracji Lean nie mierzy liczby nowych wyników.
Frozen012 pozostaje prawidłowym zapisem tamtego kroku, z zachowaniem historii.

| Potrzeba S05 | Istniejący eksport | Decyzja |
|---|---|---|
| Rzeczywiste równania NTRU, całe włókno i reindeksacja | `Run2.ActualNTRUFiber.coordinates`, `coordinates_formula`, `gaussian_fiber_in_basis`; source3 `KeygenFiberAssembly.from_modular_check` | Używać istniejących typów i tych samych f/g/F/G/h; nie odtwarzać bijekcji |
| Jednowymiarowy przesunięty Gaussian i Poisson | `Run2.ShiftedGaussian.shifted_mass_bounds`, `shifted_summable` | Gotowy kernel, używany w012 |
| Masa i zbieżność wieży z zależnymi przesunięciami | `Run2.TriangularGaussian.tower_summable`, `triangular_mass_bounds` | Gotowy kernel; nie powtarzać sumowania wierszy |
| Budżet masy3072 dla progu991 | `Run2.T5ScalarMass.uniform_shifted_mass_3072` | Gotowy bound2^-34;012 jest konsumentem |
| Pakowanie współrzędnych i Cholesky → wieża | `T5Cholesky.pointsEquiv`, `quad_choleskyTower` | Część012 pokrywa podobne zadanie przy odwrotnym kierunku eliminacji; preferować adapter indeksów |
| Skala niezależna od challenge | `T5CholeskyCert.scale_choleskyTower`, `keyTowerCert_of_cholesky` | Gotowy konsument, ale wejście `CholeskyKeyCert.gramEq` nadal jawne |
| Temperatura/globalny tilt | `T5TowerMass.scale_tiltTower`, `localExponent_tiltTower` | Ogólne skalowanie już istnieje; część TemperatureScale012 powtarza tę funkcję |
| Całe włókno = wieża | `T5TowerMass.infFiberMass_eq_quad` | Gotowy transport po dostarczeniu konkretnego `quadEq` |
| Ogony współrzędnych/MGF | `T5Tail.tilt_sum_bound`, `coord_tail_bound` | Użyć po związaniu pól `TiltCert`; wynik pod tym certyfikatem nie dostarcza jego instancji |
| Skończony box → flat/reject | `T5BoxBound.fiberMass_le_infFiberMass`, `T5BoxTransport.flat_reject_of_towers` | Gotowi konsumenci; konkretny `BoxTransportCert` i budżety wymagają dopasowania |
| Pełna odpowiedź, abort i moment | `Run2.EmitMixture`, `JointDecomp`, `FiberBinding`; S05 `KeySupport011` | Zachować kierunek J/P, pełną przestrzeń i publiczny initial |
| Numeryka źródłowa root/stable | H3 ROOT/STABLE oraz ROM_REUSE010 | Użyć przypiętych argumentów; zakres mixed/source nie staje się pełnym kernelem |
| Retry wejścia i scratch pointer | source3 `KeygenMakeRetryTransport.retry_entry`, `readTmp_of_binding_attempt` (BATCH058) | Kandydat Q-KEY/Q-BIND, pod `CertEntryFrame`; nie przejmować aktywnej kompozycji source3 |

## Granice, których adapter nie może usunąć

- `T5CholeskyCert` używa mocniejszego `gateCoefficientCap` z progiem1023.
  Wariant991/2^-34 nie daje tego wejścia. Potrzebne jest jawne dopasowanie
  budżetu do wybranego eksportu; nie osłabiamy jego hipotez po cichu.
- `GramLDL.gram_ldl_*` przyjmuje `BasisLeafAlgebra.ldl_shape`. Ta przesłanka
  ma zachowaną przeszkodę008 dla podanego porządku współczynników. Sama nazwa
  twierdzenia nie dostarcza rzeczywistego rozkładu tej macierzy.
- `T5CholeskyCert.gramEq` i `TowerRep.quadEq` są wejściami wiążącymi konkretną
  energię z danymi algebraicznymi. Dotąd przeczytane źródła nie dają gotowej
  instancji dla całego emitted KeyGen.
- BATCH058 ma `PARTIAL_PROOF / Acceptance NOT MET / NOT_REVIEWED`.
  `CertEntryFrame`, cała chronologia pętli, codec i prawo emisji pozostają jawne.

## Wybrany brakujący krok013

Z rzeczywistego `ActualNTRUFiber.coefficientBasis`, zbudowanego przez
mnożenie modulo `X^1536-X^768+1`, wyprowadzić jego całkowitą macierz i
rzeczywistą macierz Grama w metryce `Geometry.Q`. Dowieść równości energii
tej macierzy z **tym samym Q**, bez przyjmowania `gramEq` jako przesłanki.
To potrzebna algebra, którą następnie będzie można podłączyć do gotowego T5.

Pozostałe kierunki: adapter starego T5 do nowej kolejności współrzędnych
(po dokładnym związaniu Grama); numeryka/source harmonic (przypięte010 i praca
source3, bez duplikacji wykonawcy). Nie uruchamiamy ponownie Poissona, ogólnej
wieży, Cholesky/tiltu ani gotowych ogonów.

Wynik wykonania: `CoefficientGram013` domyka dokładną macierz bazy, jej
energię, odwrotność z NTRU, dodatniość Grama oraz pełne włókno z jawnym
przesunięciem. Pozostała ilościowa geometria (przekątne/widmo i wybrany
podział blokowy), a następnie konsumpcja istniejącego T5. Szczegóły:
`COEFFICIENT_GRAM_013_CHECKPOINT.md` i przypięty receipt.
