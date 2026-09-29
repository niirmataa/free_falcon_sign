# C/model binding H3_NODE3

Candidate manifest2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a,
BASE3d6bf58b833d729983718f80da020118fa94188a. Source/bootstrap read-only,
byte-identical. Spans/hashes: artifacts/source_binding.json i inputs/slices.
GCC14.2/C99/Linux x86_64 LP64, portable FPEMU, dokładne Makefile flags.

node_model.py transliteruje source1275–1322 i505–595: pobranie triples,
conjugate cubic twiddle, W2/W4, kolejność additions, rzeczywiste SQR i sześć
mul przez actual inverse3; potem Adj i wszystkie operacje LDL_dim3.
Nie zastępuje pivots przez e_i ani nie reassocjuje quotients/products.
Optional ideal_third służy wyłącznie negatywnej kontroli mutacji; domyślny
source model zawsze używa rzeczywistego kappa.

Guards w Python node_point są preflight checkerem przed wywołaniem C dla
synthetic controls, nie nowymi guardami programu i nie nowym P_key. Na
całej wymaganej domenie ich warunki wynikają z dowodu. Poza nią kontroler
zatrzymuje się przed scalar division zamiast wykonywać nieuzasadniony C call.

backend.py/fp_literal.py są niezmienionymi ROOT integer transducers.
Source-normalized RootModel.lean i RootDiv.lean zachowują restoring loop,
exponent0 correction i pack. Wybrane numeric results nie są zdefiniowane
przez idealny encoder. NodeInverse dowodzi dokładnego inverse3 word/value
i nowego exponent range. New NodeDataflow koduje dokładny scalar graph
nad dowolnymi pure Ops; rfl proof ujawnia real-slot noninterference, nie
usuwa input imag przed split. NodeFrame modeluje frame list stores.

NodeConstants używa exact par (Int numerator,Nat denominator). Valid wymaga
dodatniości WSZYSTKICH mianowników, positive pivot lower bounds i nonnegative
error budgets; porównania są cross-multiplied integer relations. Certificate
wiąże te pola z QQ records c3. To omija problem redukcji Std.Rat w początkowej
próbie, bez native_decide, wyciszania warnings albo aksjomatu wniosku.

## Analityczna warstwa

ANALYTIC_PROOF wiąże independent exact split z parent/child roots, unitary
phases i Hermitian Gram; dokładne number-field identities sprawdza Sage.
Późniejsza Hermitian comparison H zawiera RZECZYWISTE offdiagonal child
values i Re(t0); jest obiektem dowodu, nie modyfikacją source. Związek jej
pivotów z actual source jest wyprowadzony z real-slot graph i error ledgeru.

Pełna source numerical kompozycja nie jest kernelowym C theorem. Kernel
lematy mają pełne types/terms/axioms; universal primitive extension,
spectral positivity i Schur error composition mają jawne dowody analityczne
wspierane exact QQ certificates. ROOT upstream domain statements są
rozliczone w ROOT_CONSUMPTION; stare complete-IEEE premise nie jest przyjęte.

## Kontrole i rzeczywista pamięć

checks/node.c dołącza oryginalny falcon-sign.c wyłącznie dla static LDL,
łączy oryginalne FFT/FPEMU; nie uruchamia private loadera/Sign/KeyGen.
Zachowuje source repeated const inputs, actual branch1 root-D storage reuse,
chronologię split/adj/Node3, checks child input frame i canaries.
Normal/ASan/UBSan obejmują wszystkie256 slots obu branches i176 scalar pairs
nowej domain div. RBF/QQ oracle porównuje niezależne exact split/Schur i
projected-H stage errors; host double nie jest oracle.

Mutacje zmieniają rzeczywiste wartości: input imag, Adj, root slot, ideal1/3,
imag zamiast real d11 w mul_autoadj, ideal pivot formula, pominięty rounding.
Old div-domain sprawdzany jest na rzeczywistych nowych denominators>2^23;
no-op XOR0 przechodzi. Dane są publiczne synthetic envelope instances,
nie witnessami P_key/emitted. Finite controls nie zastępują universal proof.

Licencje i atrybucje Falcon Project/Thomas Pornin pozostają w source;
autorem projektu jest Niirmata. Modele/kontrolery są jawnymi adaptacjami;
piny, różnice i nowe layout dependencies zapisano w artifacts/reuse.json
i artifacts/diffs. Nie zmieniono C, guards lub parametrów, aby uzyskać PASS.
