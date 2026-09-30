# RUN_003: granica aktualnej kernelizacji źródeł

T12.1 pozostaje WORKING / PARTIAL. Końcowy zakres tej kontynuacji nadal
oznacza **M6 dla całej populacji emitted C-KeyGen, potem C Sign/M7**.
Niniejszy rejestr nie definiuje nowej populacji kluczy.

## Podetap stable-binary — STABLE_BINARY_004, 2026-09-30

**B1–B4 PROVED_KERNEL_SCOPED w autorskiej semantyce fragmentu;
NOT_REVIEWED / WORKING_NOT_FROZEN.**

- `C99HeaderProof.header_completeness` realizuje pełny dawny typ
  `HeaderCompleteness`, a `C99PrimitiveProof.primitive_completeness`
  pełny `PrimitiveCompleteness`. Definicje i komentarze z pinned `_003`
  pozostają historią; nowe twierdzenia są ich świadkami.
- `C99HelperReference.PinnedExec` jest niezależną indukcyjną relacją
  sterowania/pamięci, bez bounded evaluatora w regułach.
  `C99HelperExists.pinned_inhabited` dowodzi jej niepustości z niezmienionego
  Legal: dowolne Word64 values, dowolny uint32 bad, scratch bez initial reads.
- `C99HelperComplete.pinned_complete` zachowuje całą pamięć i metadata
  przez bijekcję `C99MemoryBridge`, a także dokładny ślad kontroli.
  `StableBinary004Outcome.source_outcome` daje bezpośrednio reference
  frame, sticky dowolnego bad≠0 oraz final bad0→initial bad0, każda kontrola
  positive-finite i bez fallbacku. Brak przesłanek niewykazanej kompletności.
- Deskryptory/loads/stores, bytewise memcpy, scalar scope/SSA locals,
  size_t control oraz dozwolone kolejności efektów są opisane i wykazane
  w `C99MemoryAccess`, `C99HelperObjects`, `C99HelperControl`,
  `C99HelperOrders`, `C99CheckReference` i mostach.
- Fresh `stable_binary004_fresh_001`:54/54 accepted/clean,261 twierdzeń,
  pięć mutacji; closure SHA256
  `d62d6eb1104879c4b920b9e5a0324d0e2ee78cfcf41f9b8edf434a22d7a1a5e2`.
  Raport: `run/STABLE_BINARY_004_REPORT.md`; materiał do niezależnego
  odbioru: `run/STABLE_BINARY_004_REVIEW_TASK.md`.

Granica pozostaje jawna: autorska semantyka wskazanego fragmentu C99/GCC
i jej wyspecjalizowany frontend/normalizacja prywatnych locals, nie dowód
całej normy ISO ani kompilatora. Ocenę adekwatności źródłowej musi wykonać
niezależny odbiorca. Nie jest to nowe założenie matematyczne w eksporcie.
Cały KeyGen/certificate, FPEMU real-error, FFT/exact Gram, T5, M6 i C Sign
pozostają poza domkniętym zakresem.

## Podetap stable-binary — historyczny STABLE_BINARY_003, 2026-09-30

W `_003` **zamknięto kernelowo** oba dawne named types:
`FprAllTotal.all_pinned_fpr_words_defined` i
`HelperAllTotal.all_legal_helpers_defined`. Wszystkie Word64 add/mul/div,
makro norm i55-iteracyjne div, scratch początkowo niezainicjalizowane,
k≤8 i dowolna initial flag — bez zmiany Legal i bez usuwania UB checks.
`FprBlockFuel`/`ExpressionFuel` i piny normalizowanego AST dowodzą
wystarczalności stałych256/32. Nowy zamknięty eksport A:
`StableBinary003Outcome.memory_only_outcome`, bez premise `run=some`.

**Nadal OPEN — obowiązek B:** niezależne C99 reference wykonanie całego
helpera→ten sam wynik i kontrole w interpreterze. Powstały osobne
indukcyjne `C99IntegerReference`, `C99ScalarReference`, `C99MemoryReference`
oraz częściowe operator/load/conversion bridges i syntax-directed
`C99Frontend`. Nie przyjęto `C99CompletenessObligations.HeaderCompleteness`
ani `PrimitiveCompleteness`. Dalsze zależności: związanie reference
Expr/Stmt/FunctionExec z parserem/ABI, wywołaniami i lokalnymi obiektami;
osobna reference control-memory relacja pointer-taking helpera oraz
argument-order/effects proof dla stable-positive. Nie definiować jej
przez `StableBinaryCExec.run=some` ani nie zastępować B totalnością A.
Pełny raport i piny: `run/STABLE_BINARY_003_REPORT.md` oraz
`run/STABLE_BINARY_003_CLOSURE.json`. Status PARTIAL; nie gotowy full source PASS.

## Podetap stable-binary — historyczny STABLE_BINARY_002, 2026-09-30

`run/STABLE_BINARY_001_REPORT.md` i zachowany
`run/STABLE_BINARY_002_BEFORE_BYTE_REFINEMENT.md` są historią przed bajtowym
mostem. Bieżący wynik, dokładne typy i hashe:
`run/STABLE_BINARY_002_REPORT.md` oraz
`run/STABLE_BINARY_002_CLOSURE.json` (37 bieżących, czystych produktów).
Przypięty parser C helpera 7491–7514 buduje AST; `StableBinaryCExec`
wykonuje wąski source-C fragment na bajtach. Dla każdego jego zdefiniowanego
wykonania `SourceProof.byte_interpreter_refinement` dowodzi pełnego
byte→typed modelu, sześciu kontroli w każdej iteracji, obu zapisów scratch,
`memcpy`, lewa→prawa na `values+hn` oraz bajtowej ramy poza obszarami.
`SourceProof.pinned_byte_source_outcome` wyprowadza clear→initial clear,
każdą wykonaną positive-finite kontrolę i brak fallbacku; `prior_nonzero`
obejmuje wszystkie niezerowe flagi. Scratch nie wymaga wcześniejszych
zainicjalizowanych bajtów. Literalne M0 `fpr_add/mul/div`, norm/FPR,
ulsh/ursh i div55 są wykonane; osobny byte-heap interpreter callee
`FprCFrame` ma ramę całej caller-owned pamięci, a `FprCErasure` wiąże
argumenty i wynik Word64 z `FprCalls`. `MemcpySpec` dowodzi extensional
kontraktu kopiowania bajt-po-bajcie.

**Na etapie `_002` OPEN / PARTIAL:** brak niezależnego twierdzenia, że *każdy* przebieg
zdefiniowany przez pełną C99/LP64/GCC semantykę przypiętego tekstu będzie
`some` w tym ograniczonym scalar-C interpreterze. Nieprzyjęte typy
`StableBinaryRefinementGoal.allPinnedFprWordsDefined` i
`allLegalHelpersDefined` są zapisem silnego, konkretnego obowiązku, nie
przesłankami źródłowego eksportu. Leaf `n=1` oraz inline half/double są
totalne kernelowo; skończone sondy add/mul/div nie są dowodem totalności.
Nie utożsamiać zakresowego `CExec.run=some` z niezależnym pełnym
standard-C execution/kompilatorem. Brak dowodu nie jest kontrprzykładem.

## Domknięte14:10Z, job source_suffix_005

- `FprCompare.source_refines`: dosłowne `fpr_lt` z nagłówka M0,
  kopiowanie obiektów→signed64→porównania→wynik. Wszystkie pary Word64.
  `spec_of_nonnegative_words`: na słowach z zerowym bitem znaku wynik jest
  porządkiem unsigned. Raw −0/+0 pozostaje jawnym odstępstwem od porządku
  liczb rzeczywistych; nie używa się globalnej fałszywej specyfikacji IEEE.
- `LeafCertificateSuffix.source_return_one_forces_word_bounds`: końcowy
  skan1536 liści i rzeczywiste `return bad == 0` z source7765–7776.
  Return1 daje początkowe bad0, zachowanie listy i inclusive zakres każdego
  oryginalnego słowa. Typ wymaga wejścia do TEGO suffixu z listą długości1536.

## Domknięte w następnych jobach, z zachowanymi ograniczeniami

- `LeafWordBounds`: dokładny realny odczyt zapisanego słowa, upper332054
  oraz matematyczny iloraz18433²/value>1023. Job root_and_leaf_bounds_002
  accepted/clean; pierwsza nieudana próba calc zachowana. **Iloraz rzeczywistych nie jest wynikiem
  FPEMU fpr_div**, a stored leaf nie jest przez to exact LDL leaf.
- `RootGate00`/`CElementLoop`: źródłowy skan768 real-part słów g00.
  Model pojedynczej komórki wymaga rozłącznego, zainicjalizowanego typed
  widoku tablicy, local uint32 bad, size_t64 i callee table. Pełna rama
  bajtowej pamięci C przy tym callerze pozostaje osobnym refinementem.
  RootGate00 accepted/clean w mandatory_control_001.
- `KeygenCPP`: preprocessing lokalnego call site, bez FG_DISTRIBUTION_PROBE.
  Job mandatory_control_002 accepted/clean. `KeygenMandatory` dodaje
  parsed-control execution, rozwiązywanie argumentów w caller Frame oraz
  dowód break→zdefiniowany niezerowy wynik wywołania (mandatory_control_005).
  Semantyka callee jest parametrem, nie wyprowadzoną tu implementacją całego
  ft_keygen_leaf_certificate. To nie dowód całego emitted KeyGen ani jego heap.
- `check_source_gates.sage`: kontrola publicznych syntetycznych słów i pełnych
  tablic, oracle QQ, kompilacja normal/UBSan i mutanty. source_gate_controls_001:
  611/611 zgodnych przypadków normal/UBSan/no-op; oba mutanty wykryte.
  Te kontrole nie zastępują uniwersalnych twierdzeń.

Historyczna lokalna grupa17 modułów:218 audited exports, w tym85 twierdzeń;
types/terms/axioms w source3_progress_audit_001. Receipt zakresu:
`run/SOURCE3_PROGRESS_RECEIPT.json`.

## Nadal trzeba wyprowadzić, nie przyjmować jako nowe assumptions

1. Pełny source-success KeyGen → wywołanie bramki na tych samych f,g,F,G,
   z poprawnymi n/hn i buforami. Nie konsumować dawnego lematycznego
   `mandatory && privateSerialized && publicSerialized` jako definicji
   źródłowego success. Capped attempts, legalne wyjście, zachowanie key buffers
   i obie serializacje muszą wynikać z właściwej semantyki wykonania.
2. Kompozycja całego ft_keygen_leaf_certificate: raw FFT/LDL prefix, Gate00,
    stable top/binary (binary ma scoped B w `_004`; nadal otwarte pełne stable-top), reverse reciprocal
   i końcowy scan. Final bad0 ma wymusić bad0 także we wcześniejszych
   bramkach; lokalny stable-binary nie dowodzi braku zapisu/aliasu kasującego
   bad między innymi fragmentami certificate.
3. Successful solve_NTRU/public-key → dokładne równania NTRU/public relation
   i ten sam materiał klucza. Modulus lifting wymaga boundu współczynników
   oraz correct NTT/Montgomery (PRIMES3[0]=2147355649).
4. Po dokładnym i totalnym wykonaniu słów add/mul/div oraz scoped niezależnej
    C99 completeness w `_004` pozostają: ich real-error/domain oraz sqrt, FFT i stable
   sequence → exact Gram/liście z odpowiednimi błędami. Historyczne mixed-proof raporty
   nie są brakującymi eksportami kernela. Nie założyć IEEE RN z komentarza.
5. Konstrukcja wież i box transport T5 dla tej samej populacji; T5 W pozostaje
   RO. Nowe law/normalizer interfaces nie wyprowadzają ich automatycznie.
6. M6 hbLo/hbHi i kernelowe tails: dokładne masy silnika rawBad pozostają
   obowiązkiem opisanym w frozen RUN_002/NEXT_INTERFACE.

Po tej kompozycji dopiero konsumować `GuaranteedDigits.three_significant_digits`.
Wszystkie obecne source lemmas dotyczą określonego typed fragmentu i pinned
profilu. Nie dowodzą kompilatora, pełnego heap C, PRNG ani rzeczywistego Sign.
