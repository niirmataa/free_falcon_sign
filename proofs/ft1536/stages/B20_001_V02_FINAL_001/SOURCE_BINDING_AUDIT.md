# Source binding / preflight V02

Własny replay startował w bwrap network-off. Zewnętrzny wrapper montował
`W/inputs/subject` jako RO `AUTHOR_W/output`, `W/run` pod wirtualnym
`AUTHOR_W/run`, `W/inputs` RO, resztę `/` RO oraz własne `/proc`,`/dev`;
fizycznie wszystkie zapisy są pod V02 W. Preflight zweryfikował 29751 static,
30612 outputs i pełne manifesty **przed** utworzeniem nowego DEST. Oryginalne
`AUTHOR_W/output`, `AUTHOR_W/src/run` nie są wejściami źródłowymi runnera.
Sealed `replay/original_job.py` i `portable_toolchain_gate.py` mają przypięte
diffy; gate sprawdził 9 rootów P01, ich tracked bytes i pinned cache, bez Git
procesów/sieci. P01 konsumowany wyłącznie w wąskim zakresie odebranym V01.

Konkretny source17 `CANDIDATE.sha256` =
`56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`;
`fpr-emulated.h` = `6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f`,
`shake.c` = `c3e7864bf4139264f8c287053214bf869e242757bf555235da81454e40ea316a`.
Regeneracja pinned header/slices i shake/LE/scalar daje sześć identycznych
plików z semantycznej listy, `check_transport` zgodny. Lean osobno sprawdza
slice→token→parse→AST dla trzech shift helpers, dec/enc i siedmiu skalarów;
nie traktuje AST wygenerowanego Pythonem jako udowodnionej przesłanki.
Wykonania bazują na określonym fragmencie `B20.C.Scalar` i
`B20.C.Byte`, nie na pełnym frontendzie/preprocesorze C. Własne C controls
kompilowały **oryginalne przypięte** header i `shake.c`, z osobnym
syntetycznym stubem add tylko dla testu połączenia sub.

GCC two's complement, LP64, zachowanie arithmetic right shift signed i
konwersje bitowe signed są jawnie modelowane; samo C/modele nie dowodzą
zgodności wszystkich wersji kompilatora i hardware. `fpr_irsh` ma
implementation-defined signed right shift. `fpr_add/mul/div/sqrt` i realny
kontrakt błędu nie mają w P02 związanego z kodem dowodu. Żaden pozytywny
fixture lub zgodny hash nie jest rozszerzony do unproved domain.
