# G_retry_IID, state projection i stopping cuts

Ustal legal entry state e (lub dowolny jego rozkład spełniający Ready).
Na jego iloczynie z produktową przestrzenią nieskończonych independent
uniform4096-byte blocks B_0,B_1,... uruchom tę samą source control flow,
targets, scalar kernel, root, postprocess, norm i codec. TYLKO output bytes
każdego `falcon_prng_refill` zastąp kolejnym B_m. Globalny ordinal m nie
resetuje się przy init, niezależnie od fizycznego ponownego użycia `tsc`.

Init zachowuje source56-byte `shake_extract(&fs->rng,...)` oraz rzeczywiste
advance SHAKE state, type0→1 i type return1. Te bytes są dowolną deterministic
funkcją legalnego state, mogą się powtarzać; nie są nową IID przesłanką.
Refill zachowuje projection: czyta unsigned64 cc na state[48..55], source
loop u=0,64,...,4032 zwiększa cc64 razy modulo2^64, zapisuje go w277,
pozostawia first48 bytes, kończy ptr0 w338. Tylko buf[0..4095] staje się
świeżym B_m. Real ChaCha output computation nie jest uruchamiany w kontrolach.

Na Ready cut bieżącego prng nie ma. Każdy reached init generuje JEDEN nowy
block; późniejsze getter refills generują kolejne. Wznowienie po norm
rejection nie może reuse poprzedniego B, nawet gdy source56 jest identyczny.
Przypięte getters (internal.h) zachowują cutoff u64 ptr>=4087, u8 refill
po ostatnim byte, actual endianness i pomijane tails. Bity/bytes, których
getter nie zwrócił, nie zostały ujawnione przez ich fizyczne wygenerowanie.

## Dozwolone sigma-fields

F dla finite history zawiera entry latent state, osiągnięte PC/indices,
dotychczas returned bytes, outcomes i decisions, counts/pointers/state
projection, values deterministycznie od nich zależne. NIE zawiera current
unread buffer, future B_m ani future norm success. Dopuszczenie samego
latent key/rng state nie ujawnia idealnego tape, bo produkt gry deklaruje
jego niezależność. F może zawierać wcześniejsze Bad flags: są funkcjami
wykonanych source calculations. Unread/abandoned ideal bytes nie służą
do wyznaczenia następnego ordinalu ani decyzji o re-entry.

Na każdym finite cylinder history next requested block ma uniform law
independent od F: ordinal jest determined przez previous reads/controls,
a nowy block nie był odczytany. Dla partial current block pozostałe bytes
mają tę samą conditional product law. To argument po cylinder histories
i deterministic read order, nie niezależność prób. Getter skips nie testują
pomijanych bytes. Re-init usuwa stare unread bytes z live state i wybiera
nowy, nigdy nieużyty ordinal; conditional fresh-tail zachodzi ponownie.

R_j (j=1..16) to osiągnięcie j-tego init/root po przejściu guard. Jego
attempt-entry cut jest po init/fault reset i target prefix, przed1897;
osiągnięcie i latent premises są F_j-measurable, current block jeszcze
nieprzeczytany przez root. F_j nie zna końcowej normy tej próby. H6P i JOINT
są uniform po tym samym current-entry state/PAST, więc pozostają prawdziwe
przy dowolnych korelacjach z wcześniejszymi wynikami.

Regular conditional kernels można podać na pozytywnych finite cylinder
histories; równoważnie stosować a.s. conditional expectation. Dla probability0
histories wybieramy dowolną wersję kernel — nie dzielimy przez0 i nie
wyciągamy z niej dodatkowych claims. JOINT a.s. return umożliwia kolejne
finite stopping cuts poza null set. Dla nieosiągniętych/nieukończonych prób
nie tworzymy source outputs. Tylko wskaźniki w sumach są analitycznie
dopełnione zerem; ewentualne survival-index padding jest proof-only.

Real SHAKE/ChaCha→taki produktowy oracle jest otwartym kryptograficznym
hopem. W szczególności repeated real seeds/state mogą dawać repeated real
bufs; świeżość w tym pliku jest DEFINICJĄ i dowodem filtracji gry IID,
nie twierdzeniem o kryptograficznym PRNG.
