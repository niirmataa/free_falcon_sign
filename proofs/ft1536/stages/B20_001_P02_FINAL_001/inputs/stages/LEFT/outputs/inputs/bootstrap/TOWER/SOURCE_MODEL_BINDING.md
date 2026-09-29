# Source/model/proof binding BINARY_TOWER

Candidate manifest2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a,
BASEb27a0557f785eabd30632eeea9da6b9cf170a7d0. Source/bootstrap byte-identical
i read-only. Toolchain GCC14.2/C99/LP64, portable FPEMU, Makefile flags.
Dokładne spans/hashes i adapter diffs: artifacts/source_binding.json.

## Modele i źródłowa kolejność

tower_model.py parametryzuje split po q8..2 i LDL po k7..1, zachowując
actual add/half/sub/mul/Adj/direct-div/muladj/neg/add. Reuse NODE2 backend,
half i local dim2 jest byte-identical. Recursive build wykonuje pierwszy
child przed local operation, a drugi dopiero po source D; base zwraca L
oraz literalne real leaf stores. Nie ma SplitDeep1/IW1I w tej ścieżce.

Kernel TowerShape dowodzi tree/internal/leaf/scratch counts. TowerOrder
koduje actual event order i frame dowolnych stores do disjoint locations.
TowerExecution to partial-operation model z immutable input snapshots:
successful_execution wymaga osobnych local base/step domains i wyprowadza
ordinary some result w actual order. Numeric induction i C destination
inspection w INDUCTION rozliczają jego premises oraz preservation snapshot
po pierwszym child. Nie przedstawia się generic conditional theorem jako
samodzielnego dowodu całego C.

## Native observer controls

checks/tower.c dołącza NIEZMIENIONE falcon-sign.c. W translation unit tylko
wybrane wywołania publicznych FFT helpers przechodzą przez obserwatory,
które wywołują oryginalną funkcję dokładnie raz. Nie zastępują algorytmu,
zmieniają wyników lub danych source. Trace zapisuje wszystkie split calls,
completion każdego local LDL (z każdym input/output word) i base leaf
observations. Base stores są bezpośrednimi source assignments; observer
sprawdza je przy następnym hook lub final return, po ich wykonaniu.

C body zachowuje actual recursive call graph i repeated const alias g00=g11.
Input snapshots,1024 tree extent,256 scratch extent i canaries są sprawdzone.
Modele porównują pełny raw tree oraz każde local output i ordered event.
Połączenie unchanged source body, source-order inspection i global final
layout nie jest obietnicą zweryfikowanego GCC; ten translation layer jest jawny.

## Uniwersalność i kontrole

INIT i STEP są dowiedzionymi parametric bounds w INDUCTION, z exact QQ
instancjami dla1524 nodes i całego horyzontu. Bez candidate-dependent fitted
constants. Source-to-H, imaginary difference, separate d00/d11 transfer i
outward grid2^-40 pozostają widoczne w certificate.py i records.
Independent oracle przenosi exact NODE3/binary references, nie source H,
oraz QQ/RBF sprawdza wszystkie5376 positions. Finite synthetic data nie
są P_key/emitted witnessami ani dowodem uniwersalności przez próby.

Nowe/edytowane Lean mają full types/terms/axioms i czyste final logs.
Full_binary_tower_theorem_kernelized=false: scalar/shape/order/frame/
abstract execution są kernelowe; uniwersalna source numeric/memory composition
ma jawny dowód analityczny. Piny tekstów w replay nie kernelizują ich treści.

Nie zmieniono C/guards/parametrów/P_key/M0. Nie użyto KeyGen/private loadera/
Sign lub sekretów. FPEMU_AUDIT pozostaje osobnym W/sesją, poza odczytem.
Falcon/Pornin attribution i source notices są zachowane; autor projektu Niirmata.
