# T12.1 / RUN_003 — STABLE_BINARY_004

**Wynik dowodowy: B1–B4 PROVED_KERNEL_SCOPED w autorskiej semantyce
wskazanego fragmentu C99/GCC-LP64.** Świeży replay i piny odbiorcze:
sekcja 7. Stan organizacyjny: **WORKING_NOT_FROZEN / NOT_REVIEWED**.
Nie jest to niezależny odbiór ani freeze całego RUN_003.

| Obowiązek | Wynik i eksport |
|---|---|
| B1, pełny dotychczasowy `HeaderCompleteness` | `C99HeaderProof.header_completeness` |
| B2, dokładne słowa add/mul/div | `C99PrimitiveProof.primitive_completeness` |
| B3, osobny reference control/memory judgment i niepustość | `C99HelperReference.PinnedExec`, `C99HelperExists.pinned_inhabited`; normalizacja kolejności w `C99HelperOrders` |
| B4, pełna pamięć i rzeczywiste kontrole | `C99HelperComplete.pinned_complete`, `StableBinary004Outcome.source_outcome` |

Autor: GPT-6 Astra (`openai/gpt-6-astra`), ta sama sesja
`ses_f12636605ffeL1FZg4teLUwUf5`. Historyczne etykiety Sol i receipty są
zachowane. Projekt: Niirmata; atrybucja Falcon Project / Thomas Pornin
i licencje źródeł pozostają zachowane. Wszystkie źródła i produkty tego
kroku są w dotychczasowym W. TASK pozostaje bez Git/push; ewentualny zapis
źródeł do nowego development należy do koordynatora po handoffie.

## 1. Wejścia, profil i historia

W jest katalogiem zawierającym ten `run/`; formalne źródła własne:
`run/formal/Source3/`. Wcześniejszych raportów, closure, snapshotów prób,
failed attempts ani raw logs nie nadpisywano.

| Artefakt | Zachowany SHA256 |
|---|---|
| `_003_REPORT.md` | `d9e1ee9835a331bc0a0917fb0c4e5d58ed3c9f768d71e7174833ee6db46f9c46` |
| `_003_CLOSURE.json` | `bb5abe4fb8a02a2c1c6645e6f7a71bdb671ae444fd1f49f90c6be583ffeb4e6a` |
| `_002_REPORT.md` | `051ea643c13519fe538e024afdb2cd7da160691d42733661c9094d761da70102` |
| `_002_CLOSURE.json` | `f013bd471f4b7bda4eccca1748c5517e3c9c45d04816122558d5230872d5ff51` |

| `inputs/source/` | SHA256 |
|---|---|
| `falcon-keygen.c` | `0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf` |
| `fpr-emulated.c` | `7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f` |
| `fpr-emulated.h` | `242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa` |
| `Makefile` | `25cd0345332882ccab4beea68d5139955c871499733ab9f5fa3cc8ef898d5049` |

Helper: keygen7491–7514; stable-positive7478–7489; jego bitcast i
positive-finite callees7453–7476. Aktywny profil M0:
`FALCON_ASM_CORTEXM4=0`; add449–554, mul681–774, div916–1000, norm21–54.
Nie podmieniano nagłówka. A1–A3 oraz byte-frame, erasure, memcpy i recursion
refinement są konsumowanymi, przypiętymi zależnościami, nie nowymi celami.

## 2. B1 — od reguł operatorów do przypiętych header functions

`C99ShiftLeftBridge` domyka unsigned left shift; `C99CompareBridge` usual
conversions i porównania. `C99OperatorBridge` składa mosty z `_003`.
`C99Typing.infer` sprawdza typy AST bez testowania wartości lub powodzenia
wykonania. `C99ExpressionBridge.expression_complete` indukcyjnie wiąże
niezależne `Eval` z wyrażeniami modelu, łącznie z short circuit i wynikiem
boolowskim. Typ32 count oraz unsigned lhs dla użytych left shifts wynikają
ze sprawdzonego typowania tych AST; nie są nową przesłanką końcową.

`C99StateBridge`, `C99DeclarationsBridge`, `C99StatementBridge`,
`C99BodyBridge`, `C99ParametersBridge` dowodzą zachowania typów,
inicjalizacji, deklaracji, przypisań/compound assignments, konwersji
by-value oraz return. `C99HeaderProof.function_complete` konsumuje te
wyniki i kernelowo sprawdzone statyczne checkery FPR/ulsh/ursh.

Dokładny dawny typ pozostaje niezmieniony i ma zamknięty świadek:

```lean
C99HeaderProof.header_completeness :
  C99CompletenessObligations.HeaderCompleteness
```

Relacja `headerCalls` jest instancjowana przez `FunctionExec noCalls`
przypiętej tabeli `C99Frontend.lookup`, nie przez zakładany wynik callees.

## 3. B2 — dokładny wynik trzech prymitywów

`C99MulProof`, `C99AddProof`, `C99DivProof` zachowują słowo dostarczone
przez reference derivation. `C99ScopeBridge` obejmuje blok norm64 i
przywracanie lokalnych wiązań. `C99DivLoopBridge`/`C99DivWhileProof`
obejmują inicjalizację `i`, rzeczywiste guardy, 55 iteracji, increment,
lokalne `b` tworzone na nowo w każdym bloku i końcowy false guard.
Nie zastąpiono reference while przez bounded fold w definicji semantyki;
fold pojawia się wyłącznie po stronie istniejącego modelu w dowodzie mostu.

```lean
C99PrimitiveProof.primitive_completeness :
  C99CompletenessObligations.PrimitiveCompleteness
```

Kierunek odwrotny także ma dowody: `C99IntegerSound`, `C99UnarySound`,
`C99ShiftSound`, `C99ExpressionSound`, `C99StateSound`, `C99BodySound`,
`C99HeaderSound`, `C99AddMulSound`, `C99DivSound`. Razem z A1 dają
`C99PrimitiveExists.all_primitives_inhabited` dla wszystkich par Word64.
Totalność jest tu narzędziem konstrukcji reference witness, a nie
substytutem zachowania jego wyniku.

## 4. B3 — pamięć, obiekty, efekty, sterowanie, istnienie

- `C99MemoryAccess`: dwukierunkowe mosty Load32/64 i Store32/64 oraz
  unikalność zapisów. Store nie wymaga starych zainicjalizowanych bajtów.
- `C99BitcastReference`: dwa osobne prywatne obiekty callee, jawny
  bytewise `Memcpy` z pre-call snapshotu i Load64; dowody istnienia
  i dokładnego wyniku. `C99LeafCalls` wiąże positive-finite oraz half/double
  z `C99ScalarReference.FunctionExec` odpowiednich źródłowych AST.
- `C99CheckReference.Exec`: niezależna semantyka sekwencji skalarnej,
  rhs compound assignment, Load32, operacji/konwersji, Store32 i suffixu.
  `source_body` zachowuje dokładne miejsce `*bad |= ...` między prefixem
  i suffixem; `source_parameters` wiąże x oraz pointer bad.
  `C99CheckBridge.check_iff` wyprowadza wynik i uint32 RMW z tych reguł.
- `C99HelperObjects`: deskryptory values/scratch/bad, osiem/cztery bajty,
  wyrównanie, pełne rozmiary tablic, index i PointerAdd. `Allocated` jest
  wyprowadzane z istniejącego `Legal` i `Layout.wellFormed`.
- `C99HelperReference`: indukcyjne Pair/Gram/HalfStore/Suffix/Step/Loop/Exec.
  Sześć kontroli każdej iteracji zapisuje faktycznie sprawdzane raw słowa.
  Load obu elementów, oba zapisy scratch, bytewise Copy, baza n1 oraz
  lewa i prawa rekurencja mają osobne reguły. `Exec` jest indeksowane
  rzeczywistym n, a Loop rzeczywistym u, bez execution fuel i bez `run=some`.
- `C99HelperControl`: dokładny odczyt size_t, unsigned guard, n>>1,
  increment, n*sizeof(fpr), granice indeksów i brak overflow w zakresie
  zadania. Source grammar wiąże parametry i deklaracje; lokalne a/b/
  product/sum są reprezentowane przez prywatne SSA witnesses jednej
  iteracji. Dowody tworzenia deklaracji i block restore opisują lifetime.
- `C99HelperOrders`: oba porządki lhs/rhs przypisania są równoważne,
  ponieważ obliczenie adresu zależy od niezmiennych by-value locals,
  nie od bajtów modyfikowanych przez rhs. Twierdzenia obejmują bazowy
  zapis values i oba scratch stores. Oba porządki argumentu word i
  pointer bad normalizują się do tej samej kontroli. Argumenty add/mul/div
  i half/double są value-only; ich pure operand order opisuje także
  `C99ScalarReference`. Nie przestawia się kolejnych pełnych instrukcji C.
- `C99HelperGroupExists` i `C99HelperExists`: konstrukcja reference
  wykonania dla każdego legalnego wejścia. Początkowy scratch nie musi
  być zainicjalizowany; inicjalizację przed memcpy dostarcza ukończona pętla.

`C99HelperReference` jest **autorską, wyspecjalizowaną formalizacją
fragmentu** po normalizacji prywatnych locals i czysto obliczanych adresów.
Nie jest importem całej semantyki ISO C. Tę normalizację, source grammar,
granice LP64 oraz rozdzielenie prywatnego Env i pamięci caller-owned należy
szczególnie sprawdzić podczas niezależnego odbioru.

## 5. B4 — zamknięta kompozycja

`C99HelperComplete.pinned_complete` daje z niezależnego wykonania
`∃ final, run=some final ∧ Related after final.heap ∧ checks=final.checks`.
`Related ↔ encode after=final.heap` to bijekcja **wszystkich** bajtów,
rozmiarów bloków i writable bits, również poza values/scratch/bad.
`C99HelperCopy` używa pre-copy snapshotu oraz pełnego bytewise kontraktu,
a nie tylko równości słów w trzech obszarach.

Dokładny typ końcowy (wewnątrz `namespace FT1536.Source3.StableBinary004Outcome`):

```lean
theorem source_outcome (l : StableBinary.Layout) (k : Nat)
    (before after : C99MemoryReference.Memory) (checks : List (BitVec 64))
    (hl : l.wellFormed k)
    (legal : StableBinaryByteView.Legal l (C99MemoryBridge.encode before))
    (source : C99HelperReference.PinnedExec l (2^k) before after checks) :
    (∃ final, StableBinaryCExec.run l k (C99MemoryBridge.encode before)=some final ∧
      C99MemoryBridge.Related after final.heap ∧ checks=final.checks) ∧
    (∀ block offset, ¬StableBinaryRefinementGoal.allowedByte l ⟨block,offset⟩ →
      after.bytes block offset=before.bytes block offset) ∧
    (∀ bad : BitVec 32,
      StableBinaryByteView.flagRead (C99MemoryBridge.encode before) l.bad=some bad →
      bad≠0#32 →
      StableBinaryByteView.flagRead (C99MemoryBridge.encode after) l.bad≠some 0#32) ∧
    (StableBinaryByteView.flagRead (C99MemoryBridge.encode after) l.bad=some 0#32 →
      StableBinaryByteView.flagRead (C99MemoryBridge.encode before) l.bad=some 0#32 ∧
      ∀ w∈checks,
        Run2.KeygenLeafGate.positive w=true ∧ Run2.KeygenLeafGate.stableWord w=w)
```

Niepustość, bez dodatkowego warunku wykonania:

```lean
theorem source_execution_exists (l : StableBinary.Layout) (k : Nat)
    (before : C99MemoryReference.Memory) (hl : l.wellFormed k)
    (legal : StableBinaryByteView.Legal l (C99MemoryBridge.encode before)) :
    ∃ after checks, C99HelperReference.PinnedExec l (2^k) before after checks
```

Profil M0 i callee table są konkretne w definicjach/pinach. `wellFormed`
zawiera n=2^k, k≤8, alignment i separation; `Legal` nie zmienił się.
W tych eksportach nie ma przesłanek HeaderCompleteness,
PrimitiveCompleteness, helper completeness ani ekwiwalentu brakującego
wniosku. Własność positive-finite/no-fallback jest warunkowa od **końcowego
bad=0**, nie od każdego legalnego wejścia bezwarunkowo.

## 6. Kontrole mutacyjne i zachowane niepowodzenia

`StableBinary004Audit` sprawdza kernelowo pięć zmian istotnych dla mostu B:

1. Zmieniony bit wyniku mul przy zachowanym `Some` i isSome — wykrywany
   względem dokładnego wyniku reference execution (twierdzenie uniwersalne).
2. Pominięcie block exit lokalnego b — kolejna deklaracja jest odrzucana,
   podczas gdy po poprawnym restore jest świeża.
3. Błędna zero-extension signed32 −1 w by-value uint64 parameter binding.
4. Usunięcie wykonanej kontroli ze śladu — niemożliwa równość długości.
5. Pominięcie zapisu bad przy kontroli raw0 i początkowym bad0 — sprzeczność
   już na pierwszym bajcie obiektu bad.

Mutacje są kontrolami siły specyfikacji, nie zastępują uniwersalnych
dowodów. Wcześniejsze mutanty `_002/_003` i ich receipty są zachowane.

Nieudane próby obejmowały błędy elaboracji/normalizacji `simp`, indeksów
konstruktorów oraz lintery; logi są w `run/stable_binary004_*/`.
`stable_binary004_addmul_sound_001` i próby groups wykazały przekroczenie
pamięci kernela przy monolitycznej redukcji. Zastąpiono ją małymi lematami
inwersji/kompozycji i jawnymi bindami, bez podnoszenia limitów i bez
wyciszania ostrzeżeń. Ostatni zaakceptowany groups ma receipt `_006`.
Żadne z tych niepowodzeń nie jest kontrprzykładem w produkcyjnym C.

## 7. Świeży replay i closure

Polecenia odtwarzania (w W, pojedynczy job, nowa jednorazowa etykieta):

```sh
python3 -B run/job.py lean <nowa_etykieta> $(python3 -B run/stable_binary004_tools.py modules)
```

Źródło audytu: `run/formal/Source3/StableBinary004Exports.lean`;
wypisuje typ, term i transitive axioms wszystkich **261** nowych twierdzeń.
Świeża closure: **54/54 moduły accepted/clean**, w tym audyt.
Job: `run/stable_binary004_fresh_001/`.

Wynik: wszystkie exit0, czyste logi przy warningAsError, bez forbidden
proof markers. Łączny czas kroków **171.661s**, maxRSS **5953120KiB**.
Audyt261 twierdzeń dopuszcza wyłącznie `propext`, `Classical.choice`,
`Quot.sound` lub brak aksjomatów. Żaden eksport nie zależy od sorryAx,
własnego aksjomatu celu lub niezrealizowanego named completeness.

`python3 -B run/stable_binary004_tools.py record stable_binary004_fresh_001`
sprawdził source/product/raw-log/receipt hashes, cały import graph,
94 reused local dependencies, dwie frozen task dependencies i granicę
przypiętych bibliotek. Historyczne raporty i closure `_002/_003` zachowują
wartości z sekcji1. Piny aktualnego wyniku:

- `run/STABLE_BINARY_004_CLOSURE.json`:
  `d62d6eb1104879c4b920b9e5a0324d0e2ee78cfcf41f9b8edf434a22d7a1a5e2`;
- `run/stable_binary004_fresh_001/RECEIPTS.json`:
  `5d1af659b13588bee958dda41261791521d4867bdfab7beeec7b43490aab2fd5`;
- `run/formal/Source3/StableBinary004Exports.lean`:
  `f565291e0d5bc53000f9b6be0980377c05d72e160548b52b5efd309097e6a66a`.

Pełne typy/termy/aksjomaty:
`run/stable_binary004_fresh_001/logs/Source3_StableBinary004Exports.stdout`.
Raport uzyskuje własny zewnętrzny pin w handoffie/review task; nie zawiera
samoodnoszącego się hasha.

Runner: Lean4.34.0/Mathlib5ed2965256430c3649e86755f9576b54eca72435,
`-j1 -M6144 -DwarningAsError=true`, AS12GiB, RSS8GiB, wall1800s/moduł,
network-off. HOME/TMPDIR/cache oraz rzeczywisty magazyn tmp są w W.
Nie wykonywano nowego numerycznego eksperymentu: nowa arytmetyka jest
formalną arytmetyką kernela, a Sage exact cross-check A pozostaje przypięty
w closure `_003`; nie uruchamiano go ponownie bez potrzeby.

## 8. Znaczenie i granica wyniku

Udało się usunąć dwa nazwane brakujące dowody B oraz skonstruować
niepustą, niezależną relację control/memory. Wynik odnosi się do wszystkich
legalnych wejść tego helpera: dowolnych słów values i dowolnej flagi uint32.
Dokładny wynik słowowy, bajty i kontrole są zachowane przez most.

**Granica zaufania:** relacje C99/GCC i wyspecjalizowany frontend są
autorską formalizacją użytego fragmentu. Kernel potwierdza twierdzenia
o tych definicjach oraz ich binding do przypiętych AST. Nie stanowi to
mechanicznej weryfikacji całej normy ISO C, preprocessora systemowego ani
kompilatora/binarnego kodu maszynowego. Prywatne scalar locals są Env/SSA;
caller memory zachowuje pełną bijekcję bajtów i metadanych.

FPEMU real-error, sqrt/FFT/exact Gram, cały KeyGen/certificate, T5, M6
i rzeczywiste C Sign pozostają odrębnymi otwartymi zadaniami. Nie jest
to dowód bezpieczeństwa całego podpisu ani zakończenie T12.1.

Następny krok: niezależny odbiór tego zamkniętego zakresu, szczególnie
referencji źródłowej, lifetime i normalizacji kolejności efektów, według
materiału `run/STABLE_BINARY_004_REVIEW_TASK.md`. Recenzenta uruchamia
właściciel. Ten wykonawca nie nadaje statusu REVIEWED i nie zamraża RUN_003.
