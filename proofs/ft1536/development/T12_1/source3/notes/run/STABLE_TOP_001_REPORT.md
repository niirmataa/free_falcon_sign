# T12.1/source3 — STABLE_TOP_001

Status autora: **PROVED_KERNEL_SCOPED / NOT_REVIEWED** dla wskazanego
fragmentu C99/GCC-LP64. Fresh replay/piny: sekcja7. Pełne M6 pozostaje
dalszym celem T12.1; ten raport dotyczy wyłącznie stable-top i jego closure.

Wykonawca: GPT-6 Astra / openai/gpt-6-astra, ta sama sesja
`ses_f12636605ffeL1FZg4teLUwUf5`. Projekt Niirmata; Falcon Project /
Thomas Pornin i licencje przypiętych źródeł zachowane.

## 1. Handoff, miejsce pracy i Git

Przejęto wyłącznie `proofs/ft1536/development/T12_1/source3` po sprawdzeniu
5/5 kopii i receiptu `HANDOFF_RECONCILIATION_20260930_001.json`, SHA256
`d6e460b94b858dfbb65bb2d6c725a477d932e3fcbfeb9903bc4ea36524518eb2`.
Commit rozliczenia: `c358871ab99f4aabfefc78d0b6be873852f2678e`.
Pięć historycznych różnic pending jest rozliczone; BASELINE nie zmieniono.

Źródła: komponentowe `formal/`, `sage/`, `tools/`. Runtime:
`.build/jobs/<etykieta>`, `.build/cache`. Nowy `tools/job.py` jest jawnie
podłączony do tego drzewa i pinów `_004`; poprzedni W, `tools/original/`
i wcześniejsze kopie w notes pozostają proweniencją. Nie edytowano run2,
t5 ani zastanej zmiany `docs/onboarding/STATE.md`.

Zapisane małe kroki:
- `d3e50a19` — ACTIVE source3, runner i bootstrap; push wykonany przed
  późniejszą zmianą polecenia;
- `c679746c` — source fpr_of(3); push wykonany przed zmianą polecenia;
- `24ef6865` — parser/top loop/pamięć/inicjalizacja, lokalny checkpoint.

**Obecne polecenie: push tylko po jawnym sygnale właściciela.** Po jego
otrzymaniu nie uruchamiano push. Kolejne commity pracy pozostają lokalne;
końcowe hashe commitów przekazuje handoff, aby nie tworzyć samoodnoszących
się pinów raportu. Commity właściciela run2 są zachowane w historii.

## 2. Przypięte wejścia

STABLE_BINARY_004 konsumowane jako **PROVED_KERNEL_SCOPED / NOT_REVIEWED**:
- REPORT SHA256 `3bc800efe63cc0b829b44d10d19d7d54dfc72678366a7f71c60e27b4b4378f96`;
- CLOSURE SHA256 `d62d6eb1104879c4b920b9e5a0324d0e2ee78cfcf41f9b8edf434a22d7a1a5e2`.

Nie odtwarzano dowodów zakończonego binary. Konsumowane są dokładne
header/primitive completeness, helper completeness/inhabited, source
outcome, A1–A3, pamięć bajtowa, memcpy i reguły porządku efektów.
Nowe `C99HelperShape` wyprowadza z tych samych reguł zachowanie metadanych
caller memory; nie zastępuje wyniku `_004` ani nie nadaje mu REVIEWED.

| Źródło C w dawnym `inputs/source/` | SHA256 |
|---|---|
| falcon-keygen.c | `0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf` |
| fpr-emulated.c | `7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f` |
| fpr-emulated.h | `242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa` |
| Makefile | `25cd0345332882ccab4beea68d5139955c871499733ab9f5fa3cc8ef898d5049` |

Top: keygen7516–7542, pełne27 linii. Profil M0:
FALCON_ASM_CORTEXM4=0, fpr=uint64_t, little-endian, GCC-LP64. Nagłówka
nie podmieniono na nowszy P02. Produkcyjnego C ani parametrów nie zmieniono.

## 3. Nowa zależność fpr_of(3)

`FprScaledBinding` kernelowo wiąże wygenerowane AST z:
header86–90 fpr_of, C150–204 fpr_scaled w M0 oraz makrem norm21–54.
`EmitScaledAST` i `capture_scaled_ast.py` są niezaufanym transportem AST;
ich wydruk nie stanowi dowodu bez równości parsera w Binding.

`FprScaledBridge.complete/sound` obejmują parametry int64/int, prefix,
norm block/lifetime nt, suffix i wywołanie rzeczywistego FPR.
`FprOfThree` daje:

```lean
FprOfThree.source_exists : FprOfThree.SourceExec (.uint64 FprOfThree.three)
FprOfThree.source_exact (z) : FprOfThree.SourceExec z → z=.uint64 FprOfThree.three
-- three = 0x4008000000000000
```

Słowo3 jest wnioskiem wykonania, nie przesłanką. Kontrakt dotyczy użytego
literalnego int3 wraz z konwersją by-value do int64. Nie zakłada globalnej
specyfikacji IEEE dla wszystkich prymitywów.

## 4. Parser, niezależne wykonanie i pamięć pętli

`StableTopSyntax.pinned_source` parsuje cały helper: sygnaturę const roots,
deklaracje, inicjalizator, u=0/v=0, comma sequence, guard, u+=3/v++, wszystkie
instrukcje i trzy końcowe wywołania. AST zawiera drzewa operacji i offsety,
więc source binding zachowuje `(a+b)+c`, `(ab+ac)+bc`, `ab*c`, dzielenia
oraz `fpr_mul(three,abc)` we właściwym miejscu.

`StableTopExpr.Eval` jest niezależną relacją pure word expressions opartą
na przypiętych `C99Frontend.primitiveCall`; `independent_scalar` wiąże ją
z `C99ScalarReference.Eval`. Nie ma dowolnego interfejsu FprCalls w wyniku.
`StableTopReference.Step/Body/Loop/Branches/Exec` są indukcyjnymi regułami
source-fragment, bez wywołań modelowego evaluatora w konstruktorach.
Counter iteration index nie jest execution fuel. Final false guard i
`final_index` wyznaczają dokładnie256 wykonanych iteracji.

`StableTopMemory.WellFormed/Legal` zawierają alignment, extents, separację,
writable leaves/scratch/bad i reads roots/bad. **Nie wymagają początkowych
reads leaves/scratch**, positivity roots, Grama, exact leaves ani delty.
Deskryptory mają roots768, leaves768, scratch256 i bad uint32. Adresy są
LP64 byte offsets w jawnej pamięci; pozostałe bloki też są obserwowalne.

`StableTopEffects` dowodzi Legal/Grows/Safe dla rzeczywistych stores i
uint32 RMW. `StableTopBodyTotal` korzysta ze statycznie sprawdzonego
dataflow locals. `StableTopLoop.loop_exists/filled_all/counters` dowodzą
u=3*v, pełnego zakresu roots, wszystkich trzech części leaves i ich
inicjalizacji. Każda z12 instrukcji iteracji wykonuje dokładnie jedną
kontrolę; nested add/mul pozostają w wyrażeniach i nie dostają dodatkowych
wymyślonych kontroli. Private locals są świeże przy każdej iteracji.

`StableTopControl` daje C99/GCC size_t guard i increment, sekwencję
u+=3 **przed** v++ dla operatora przecinka, brak przypisań do counters/three
wewnątrz body oraz równoważność obu lhs/rhs orders dla leaves store.
Argument pointer bad jest czysto obliczany; `_004` checker-order theorem
obejmuje oba porządki argumentów. Operand calls są value-only.

## 5. Trzy binary256, wspólny scratch i pełny trace

`StableTopBranchLayout.branch_legal` konstruuje dawny Layout/Legal dla
każdej gałęzi j<3: values=leaves+8*(256*j), scratch ten sam, bad ten sam,
length256 i k8. Czytelność wartości wynika z Filled256, a nie z założenia
o początkowych leaves. `leaves_after_branch` zachowuje czytelność wszystkich
768 słów: bieżącej części przez wynik binary Legal, innych części przez
bajtową ramę binary. Metadane, roots i wymagane write regions są zachowane.

`StableTopBinaryBridge.complete/exists_execution` konsumują literalne
`C99HelperComplete.pinned_complete`, `pinned_inhabited` i
`StableBinary004Outcome.source_outcome`. `StableTopBranches` składa je
kolejno na offsetach0,256,512. Scratch może zostać ponownie użyty, bo każde
wywołanie potrzebuje jego writable region, nie wcześniejszej zawartości.

Ślad jest przechowywany od najnowszej kontroli. Nowe kontrole gałęzi są
dołączane jako `branchChecks ++ previousChecks`; tak samo w reference
i modelu. Invariant Safe przenosi frame, sticky i clear/no-fallback przez
całą pętlę i wszystkie trzy wywołania, bez zgubienia wcześniejszych kontroli.

## 6. Końcowe eksporty — dokładny zakres

W `FT1536.Source3.StableTop001Outcome`:

```lean
theorem reference_exists (l : StableTopMemory.Layout)
    (before : C99MemoryReference.Memory)
    (hl : StableTopMemory.WellFormed l)
    (legal : StableTopMemory.Legal l (C99MemoryBridge.encode before)) :
    ∃ after checks, StableTopReference.PinnedExec l before after checks

theorem source_outcome (l : StableTopMemory.Layout)
    (before after : C99MemoryReference.Memory) (checks : List (BitVec 64))
    (hl : StableTopMemory.WellFormed l)
    (legal : StableTopMemory.Legal l (C99MemoryBridge.encode before))
    (source : StableTopReference.PinnedExec l before after checks) :
    (∃ final, StableTopExec.run l (C99MemoryBridge.encode before)=some final ∧
      C99MemoryBridge.Related after final.heap ∧ checks=final.checks) ∧
    after.size=before.size ∧ after.writable=before.writable ∧
    (∀ i<768, ∀ b : Fin 8,
      after.bytes 0 (l.roots+8*i+b.val)=before.bytes 0 (l.roots+8*i+b.val)) ∧
    (∀ block offset, ¬StableTopMemory.Allowed l ⟨block,offset⟩ →
      after.bytes block offset=before.bytes block offset) ∧
    (∀ bad : BitVec 32,
      StableBinaryByteView.flagRead (C99MemoryBridge.encode before) l.bad=some bad →
      bad≠0 → StableBinaryByteView.flagRead (C99MemoryBridge.encode after) l.bad≠some 0) ∧
    (StableBinaryByteView.flagRead (C99MemoryBridge.encode after) l.bad=some 0 →
      StableBinaryByteView.flagRead (C99MemoryBridge.encode before) l.bad=some 0 ∧
      ∀ w∈checks,
        Run2.KeygenLeafGate.positive w=true ∧ Run2.KeygenLeafGate.stableWord w=w)
```

`StableTopCore.complete` ma nawet dokładną równość
`run l (encode before)=some ⟨encode after,checks⟩`. Bijekcja całej pamięci
z `_004` zachowuje wszystkie bajty, rozmiary i writable flags, nie tylko
wartości trzech buforów. Niepustość i completeness są dowodami, nie nowymi
przesłankami. Końcowy typ nie zakłada sukcesu modelowego interpretera.

## 7. Sprawdzenia, replay i piny

Nowe Lean: pojedyncze joby, Lean4.34.0 i przypięta Mathlib,
`-j1 -M6144 -DwarningAsError=true`, AS12GiB/RSS8GiB/wall1800s na krok,
network-off; wszystkie zapisy jobów pod ignorowanym trwałym `.build/`.
Zachowano snapshot każdej próby i raw stdout/stderr/receipty.

Fresh job **stable_top_fresh_001**: **23/23 moduły accepted/clean**, w tym
`StableTop001Exports`, i119 wydruków typów/termów/transitive axioms
(`pp.proofs=true`). Czas kroków **110.151s**, maxRSS **4224628KiB**.
Wszystkie exit0, bez warnings i forbidden proof markers. Wszystkie
transitive axiom sets zawierają wyłącznie propext/Classical.choice/
Quot.sound albo są puste. Nie pozostał sorryAx ani aksjomat celu.

`tools/stable_top_closure.py record stable_top_fresh_001` potwierdził
source/product/receipt/raw-log hashes oraz146 odziedziczonych zależności
i bibliotekową granicę importów. Closure:
`notes/run/STABLE_TOP_001_CLOSURE.json`, SHA256
`1447448efc172809c76c56e2f0cfa6ab73054cf5b47003b57994c447e451e33a`.
Źródło audytu `formal/Source3/StableTop001Exports.lean`, SHA256
`95511c61aaa27d19d3dd75ad9e6fb28b79bd66056c32a89db7a17c22e7148a32`.
Pełny stdout: `.build/jobs/stable_top_fresh_001/logs/Source3_StableTop001Exports.stdout`.

Odtworzenie z katalogu komponentu, z nową jednorazową etykietą:

```sh
python3 -B tools/job.py lean NOWA_ETYKIETA $(python3 -B tools/stable_top_closure.py modules)
python3 -B tools/job.py sage NOWA_SAGE1 check_stable_top_inputs.sage
python3 -B tools/job.py sage NOWA_SAGE2 check_stable_top_mutations.sage
```

`tools/stable_top_closure.py` jest organizatorem hashy/import graph,
nie dowodem. Closure przypina nowe source/products/receipts/logs,
odziedziczone zależności, bibliotekowe boundary imports i generator AST.
Raw produkty mogą zostać odtworzone przez runner; nie trafiają do zwykłego
commita. Stare niezmienne W nadal zapewniają bajty przypiętych zależności.

## 8. Mutacje i rzeczywiste niepowodzenia

Kernelowe `StableTop001Audit`: błędny u step, błędny v update, zamiana
offsetów stores, zmiana nawiasowania/callee, zgubiona kontrola, reset bad
między gałęziami oraz zły adres binary. AST binding odrzuca zmienione
programy; step theorem wymusza dopisanie faktycznie wykonanej kontroli;
source outcome uniemożliwia zmianę initial bad7 w final bad0.

Sage standard preparser, ZZ/QQ:
- `stable_top_inputs_sage_001`: exact fpr_scaled/FPR dla3, QQ decode=3,
  oraz diagnostyka harmonogramu indeksów;
- `stable_top_c_mutations_002`: **18 wykonań GCC C99/LP64**, normal i UBSan;
  **16/16 mutantów wykrytych** (8 zmian w każdym trybie). Baseline: bad7,
  niezmienione roots/outside leaves i **22272** rzeczywiste kontrole.
  Generator składa dosłowne przypięte fragmenty C i dodaje wyłącznie
  diagnostyczny raw-word trace. Produkcyjnego C nie zmienia.

Zachowany niewygodny wynik: `stable_top_c_mutations_001` zakończył się
FAIL na niewykrytym abc mul→add. Przy c=1 i dużym ab oba słowa były równe
po zaokrągleniu; pierwszy probe był za słaby. Zmieniono dane testowe na
c=1/2/3, zachowując wiersze ujawniające niełączność dodawania. `_002`
wykrywa ten mutant. To ograniczenie pierwszego testu, nie błąd C ani
kontrprzykład do dowodu. Inne failed attempts były błędami elaboracji,
normalizacji simp, notacji i linterów; źródła i logi zachowane.

Testy skończone i instrumentowany C są diagnostyką siły wiązania;
nie zastępują uniwersalnych twierdzeń kernela.

## 9. Ocena i następny krok

Zamknięto źródłowe fpr_of(3), pętlę i kompozycję trzech binary256 dla
wszystkich legalnych pamięci oraz dowolnych Word64 roots i uint32 bad.
To usuwa brak stable-top w dalszej kompozycji certificate i zachowuje
rzeczywisty trace przez wspólny bad/scratch. Nie dodano warunków Grama,
positivity ani wyniku delty do populacji wejść.

**Granica zaufania:** użyte relacje są autorską formalizacją wskazanego
fragmentu C99/GCC-LP64, z wyspecjalizowanym source frontend i prywatnymi
Env/SSA locals. Dowód jest o tych regułach i przypiętym AST. Nie oznacza
weryfikacji całej normy ISO C, kompilatora, libc ani kodu maszynowego.
Adekwatność tej formalizacji, operatora przecinka, lifetime i normalizacji
kolejności efektów wymaga niezależnego odbioru równie mocno jak replay.

Real-error FPEMU, FFT/exact Gram, reverse reciprocal, cały
ft_keygen_leaf_certificate, pełny KeyGen, T5, M6 i C Sign zachowują dalsze
obowiązki. run2 jest torem matematycznym właściciela. Następny krok:
niezależny odbiór stable-top oraz zaplanowana kompozycja source3; recenzenta
wybiera/startuje właściciel, koordynator prowadzi import/stages/tag.
Ten wykonawca nie uruchamia recenzenta ani nie nadaje REVIEWED.
