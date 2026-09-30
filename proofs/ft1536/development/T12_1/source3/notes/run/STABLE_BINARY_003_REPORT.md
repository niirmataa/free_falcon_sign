# T12.1 / RUN_003 — STABLE_BINARY_003

**Łączny status: PARTIAL_PROOF / WORKING_NOT_FROZEN.**

| Obowiązek właściciela | Bieżący wynik |
|---|---|
| A1 — `allPinnedFprWordsDefined` | **PROVED_KERNEL** dla wszystkich par Word64, bez dodatkowych domen |
| A2 — `allLegalHelpersDefined` | **PROVED_KERNEL**, niezmieniony `Legal`, scratch może być niezainicjalizowane |
| A3 — fuel i ograniczenia parsera/AST | **PROVED_KERNEL w istniejącym interpreterze**: strukturalny limit wyrażeń, stabilność block-fuel, piny pełnych AST |
| B — niezależne C99 wykonanie → interpreter całego helpera | **NOT_CLOSED**; istnieją niezależne relacje i częściowe mosty, nie ma finalnej kompletności |

**Zlecenie nie jest zakończone według końcowego kryterium B.** Totalność A
nie zastępuje zgodności wyniku z niezależnym wykonaniem źródłowym.
Żaden brakujący lemat B nie został użyty jako przesłanka lub aksjomat.

Autor bieżącego kroku: GPT-6 Astra (`openai/gpt-6-astra`), ta sama sesja
`ses_f12636605ffeL1FZg4teLUwUf5`. To identyfikacja aktualnego harnessu;
historycznych etykiet Sol i receiptów nie zmieniano. Projekt: Niirmata;
atrybucja Falcon Project / Thomas Pornin i źródłowe licencje zachowane.
Bez subagentów, nowej sesji, relay, zmian produkcyjnego C, Git/push,
freeze i samodzielnego niezależnego odbioru.

## 1. Wejścia i zachowana historia

Zweryfikowano i zachowano bez zmian:

- `run/STABLE_BINARY_002_REPORT.md`:
  `051ea643c13519fe538e024afdb2cd7da160691d42733661c9094d761da70102`;
- `run/STABLE_BINARY_002_CLOSURE.json`:
  `f013bd471f4b7bda4eccca1748c5517e3c9c45d04816122558d5230872d5ff51`;
- starsze raporty, 37 produktów closure `_002`, ich źródła i raw logs.

Piny M0 bez podmiany nagłówka:

| `inputs/source/` | SHA256 |
|---|---|
| `falcon-keygen.c` | `0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf` |
| `fpr-emulated.c` | `7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f` |
| `fpr-emulated.h` | `242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa` |
| `Makefile` | `25cd0345332882ccab4beea68d5139955c871499733ab9f5fa3cc8ef898d5049` |

Aktywne C M0: add449–554, mul681–774, div916–1000, norm21–54,
`FALCON_ASM_CORTEXM4=0`. Dotychczasowych byte-frame, memcpy, parser,
erasure, recursion refinement oraz `pinned_byte_source_outcome` nie
wyprowadzano ponownie. Nowa kompozycja je importuje.

## 2. Totalność prymitywów — zamknięte A1

Eksport bez przesłanek arytmetycznych/kluczowych:

```lean
theorem FprAllTotal.all_pinned_fpr_words_defined :
  StableBinaryRefinementGoal.allPinnedFprWordsDefined
-- definicja celu:
-- (∀ x y : BitVec 64, (FprPrimitives.add x y).isSome) ∧
-- (∀ x y : BitVec 64, (FprPrimitives.mul x y).isSome) ∧
-- (∀ x y : BitVec 64, (FprPrimitives.div x y).isSome)
```

Wykonania obejmują też raw zera, ujemne słowa, subnormale i kody
Inf/NaN. Jest to dokładna totalność operacji **słowowych**, nie poprawność
IEEE, normalność wyniku ani oszacowanie rzeczywistego błędu.

Łańcuch dowodu:

1. `EmitFprAST` jedynie wypisuje dotychczasowy wynik parsera. Wygenerowany
   `FprAST.lean` jest **niezaufanym transportem**, sprawdzonym następnie
   równościami kernela `FprASTBinding`: każdy add/mul/div/header/makro
   jest równy dokładnie wynikowi pinned parsera. Nie zastąpiono C nowym
   matematycznym algorytmem.
2. `UnsignedSafety`/`UnsignedState` są dowodem wystarczającego checkera
   skalarnego. Udany checker pociąga rzeczywiste wykonanie i typ wyniku;
   unsigned+casts/prefixy nie zależą od wartości bitów. Nie wyłączono żadnej
   kontroli UB w `B20.C` ani `CLogic`.
3. `FprHeaderTotal`: M0 `ulsh/ursh` totalne dla każdego Word64/int32,
   także rzeczywista konwersja literalnego argumentu1 w add. `FPR` ma
   jawny warunek representowalności `e+1076`; jest on **wyprowadzony**
   w każdym z trzech callerów.
4. `FprSmallSigned`: zakresy ex/ey0…2047, w≤511, bezpieczne signed
   sumy/różnice i negacja flagi0/1. Mul aggregate −2100…2505,
   div aggregate −2102…2503. Warunek `FPR` wynika z tych oszacowań,
   nie z pozytywności wejść.
5. `FprDivRound`/`FprDivLoopTotal`: każda iteracja operuje na dowolnych
   słowach xu/yu/q. Indukcja po liczbie iteracji dowodzi wszystkich55
   kroków, wartości licznika0…55, bezpiecznego int-increment, true guards
   przed nimi i false guard po nich. Lokalny `b` jest świeży i usuwany
   przy wyjściu z bloku każdej iteracji.
6. `FprAddDecode`, `FprAddCombine`, `FprNormRound`/`FprNormTotal`:
   ex po dekodowaniu −1078…969, cc i cc−60 bez overflow; każdy
   norm64-stage daje przyrost0…32, ostatni0…1. Użyty bezpieczny bound
   całego norm: −1141…1067, potem +9 i pack+1076. To szeroki bound
   bezpieczeństwa signed, nie oszacowanie wartości realnej.
7. `FprAddTotal`, `FprMulTotal`, `FprDivTotal` składają sekwencje z
   identycznym aktualnym fuel256 i źródłowym `FprPrimitives.call`.

Nie znaleziono kontrprzykładu A1. Nie stosowano nowej domeny lub selekcji
kluczy; mocniejszy żądany typ jest udowodniony w całości.

## 3. Totalność helpera i fuel — zamknięte A2/A3

```lean
theorem HelperAllTotal.all_legal_helpers_defined :
  StableBinaryRefinementGoal.allLegalHelpersDefined
-- ∀ l k heap, l.wellFormed k → StableBinaryByteView.Legal l heap →
--   (StableBinaryCExec.run l k heap).isSome
```

`HelperMemoryTotal` dowodzi zachowania `Legal` i inicjalizacji odczytywalnych
obiektów przy źródłowym positive-update oraz każdym dopuszczalnym zapisie.
`HelperLoopTotal.Filled` śledzi zapisane **obie** części scratch. Indukcja
pętli daje inicjalizację całego kopiowanego prefiksu. `HelperCopyTotal`
dowodzi totalnego odczytu snapshotu i zapisów values. `HelperAllTotal`
indukuje po k: base, pętla, memcpy, lewa rekurencja, prawa na values+hn.
Flaga uint32 jest dowolna. Dotychczasowy `Legal` nie został wzmocniony.

`ExpressionFuel.fuel_adequate` wiąże bounded eval z jego strukturalną,
nieograniczoną wersją dla `depth e≤fuel`. **Nie nazywa się tej wersji
niezależną semantyką C99.** `FprFuelPins` kernelowo sprawdza każdy
pinned AST i inline/macro closure względem granicy32. `FprBlockFuel`
dowodzi dla wszystkich stanów, nie tylko osiągalnych, że fuel256+extra
daje ten sam wynik co256 dla każdego z trzech programów. Nie zwiększono
stałych wykonania ani nie uzyskano totalności przez łagodzenie UB.

## 4. Niezależny most C99 — stan częściowy B

Referencyjne definicje są nowe i oddzielne od evaluatorów:

- `C99IntegerReference`: indukcyjne relacje arytmetyki, przesunięć,
  bitwise, negacji i porównań. Wartości mają matematyczny Int, residue-class
  conversion i explicit signed representability. Przyjęto int32/long64,
  two's complement, GCC low-bit signed conversion, arithmetic signed >>.
  Podstawy: ISO/IEC9899:1999 6.2.5–6.2.6, 6.3.1, 6.5.3/6.5.6/6.5.7/6.5.10–12.
- `C99ScalarReference`: **nieograniczone fuel** `Eval`, `Exec`,
  `FunctionExec`, parametry by-value, deklaracje, block scope, return,
  short circuit i prawdziwa relacja `while`. Jest to autorska formalizacja
  użytej części normy, nie import mechanicznie zweryfikowanego modelu ISO.
- `C99Frontend`: syntax-directed translation kernel-bound M0 AST;
  `for` staje się inicjalizacją licznika + reference while + increment,
  a norm rozszerza się do reference block. Udowodniono, że wszystkie
  trzy pinned programy dają AST referencyjny. To jeszcze **nie** dowód
  zgodności ich wykonań.
- `C99MemoryReference`: odrębne relacje LE32/64 load/store, array-pointer
  extent/alignment, pointwise memcpy i deterministyczność kopii. Deklaracje
  i lifetime descriptors pointer-taking helpera nie są jeszcze z nimi związane.
- `C99ValueBridge`/`C99ArithmeticBridge`/`C99BitwiseBridge`/
  `C99UnaryBridge`/`C99ShiftBridge`: kernelowe source→interpreter dla
  promocji/usual conversions, casts, +/−/*, bitwise, negacji, komplementu
  i prawego przesunięcia. Ostatni jawnie wymaga 32-bitowego typu count,
  który trzeba jeszcze wyprowadzić z całego reference frontendu.
- `C99MemoryBridge`: bijekcja **wszystkich** bajtów i metadanych,
  `Related a b ↔ encode a=b`, oraz reference LE64 load→wordRead w używanej
  domenie płaskiego bloku0. Nie pomija zmian pamięci poza tablicami.

**Nie ma zamkniętego C99 source→interpreter dla całych funkcji.**
Następne konkretne, nazwane typy są w `C99CompletenessObligations.lean`:

```lean
def HeaderCompleteness : Prop :=
  ∀ name args z,
    name ∈ [['F','P','R'],['f','p','r','_','u','l','s','h'],
      ['f','p','r','_','u','r','s','h']] →
    C99Frontend.headerCalls name (args.map C99ValueBridge.value)
      (C99ValueBridge.value z) → FprPrimitives.headerCalls name args=some z

def PrimitiveCompleteness : Prop :=
  ∀ name (x y z : BitVec 64),
    name ∈ [['f','p','r','_','a','d','d'],['f','p','r','_','m','u','l'],
      ['f','p','r','_','d','i','v']] →
    C99Frontend.primitiveCall name [.uint64 x,.uint64 y] (.uint64 z) →
    (if name=['f','p','r','_','a','d','d'] then FprPrimitives.add x y
     else if name=['f','p','r','_','m','u','l'] then FprPrimitives.mul x y
     else FprPrimitives.div x y)=some z
```

Oba są **nieudowodnionymi Prop**, bez aksjomatu/instancji i nie są
przesłankami osiągniętego eksportu A. Ich zależności to pełne podnoszenie
`C99ScalarReference.Eval/Exec/FunctionExec` przez frontend i stos lokalnych
obiektów, domknięcie wywołań header table i reguł operatorów dla wszystkich
osiągalnych typów. Dalej brak niezależnego control-memory judgment całego
pointer-taking helpera, wiązania deskryptorów obiektów i dowodu kolejności
efektów przy source stable-positive oraz assignment. **Tego judgmentu nie
zdefiniowano sztucznie jako `StableBinaryCExec.run=some`.** Wobec tego
końcowy theorem zaczynający się od niezależnego wykonania helpera C99
**jeszcze nie istnieje**. Nie twierdzi się, że recenzja zastąpi te dowody.

To jest niedokończony dowód B, nie wykryty kontrprzykład w produkcyjnym C
i nie brak totalności interpretera. Gdyby kontynuować: najpierw
`HeaderCompleteness`, potem `PrimitiveCompleteness`, następnie właściwy
reference judgment pointer-taking helpera i kompozycja z gotowym wynikiem
`pinned_byte_source_outcome`/`prior_nonzero`.

## 5. Dokładny osiągnięty eksport i granica zaufania

Poniższy theorem domyka A i usuwa dawną przesłankę zdefiniowanego wykonania.
Nie jest on oczekiwanym końcowym theorem B:

```lean
theorem StableBinary003Outcome.memory_only_outcome
    (l : StableBinary.Layout) (k : Nat) (heap : B20.C.Byte.Memory)
    (hl : l.wellFormed k) (legal : StableBinaryByteView.Legal l heap) :
    ∃ final, StableBinaryCExec.run l k heap=some final ∧
      (∀ p, ¬StableBinaryRefinementGoal.allowedByte l p →
        final.heap.contents p=heap.contents p) ∧
      (∀ bad : BitVec 32, StableBinaryByteView.flagRead heap l.bad=some bad → bad≠0#32 →
        StableBinaryByteView.flagRead final.heap l.bad≠some 0#32) ∧
      (StableBinaryByteView.flagRead final.heap l.bad=some 0#32 →
        StableBinaryByteView.flagRead heap l.bad=some 0#32 ∧
        ∀ w∈final.checks, Run2.KeygenLeafGate.positive w=true ∧
          Run2.KeygenLeafGate.stableWord w=w)
```

Granica zaufania A: Lean4.34.0 kernel, Mathlib
`5ed2965256430c3649e86755f9576b54eca72435`, przypięty transport źródeł,
obecna semantyka `B20.C/CLogic/StableBinaryCExec`. Nie ma „FPEMU działa”
ani `C99Completeness` w assumptions. Granica B jest jawnie otwarta:
autorska formalizacja reguł C99/GCC wymaga dokończenia wskazanych
refinementów; nie dowodzi ona kompilatora ani nieużytych fragmentów C.

## 6. Weryfikacja, mutacje i zachowane próby

Świeży job `run/stable_binary003_fresh_001`: **45/45 accepted/clean**, exit0,
łącznie344.709s, max RSS5928532KiB. Każdy proces `-j1 -M6144`, AS12GiB,
RSS-limit8GiB, wall1800s i network-off. `StableBinary003Exports.lean`
drukuje rzeczywiste typy, termy i transitive axioms **194** nowych twierdzeń.
185 ma niepusty zestaw z `{propext, Classical.choice, Quot.sound}`, 9 nie
ma aksjomatów. Nie użyto `sorry`, `native_decide`, `Lean.ofReduceBool`,
aksjomatu tezy ani wyciszenia warningów.

Kernelowe kontrole `_003`: obcięcie fuel do3 odrzuca **każdą** parę mul,
podczas gdy oryginał jest totalny; dodatkowy filtr `x=0 → none` wykryty
dla każdego y; signed overflow nadal `none` i brak reference derivation;
błędna zero-extension −1→uint64 oraz logical zamiast arithmetic signed >>
wykryte. Zachowano dotychczasowe mutanty prymitywów, bad reset i zły prawy
adres. Nowych sond skończonych nie awansowano do uniwersalnego proofu.

`sage check_stable_binary_totality.sage` (preparser, ZZ/QQ) sprawdza jawne
zakresy z dowodów i przykłady konwersji; `stable_binary003_sage_bounds_001`
accepted/clean. To exact cross-check, nie zależność dowodu Lean.

Wszystkie próby nieudane zachowano, m.in.:

- `stable_binary003_expr_fuel_001` i `*_fuel_pins_002`: zbyt ciężka redukcja
  parsera, bad_alloc/limit pamięci; rozwiązane przez niezaufany AST print
  i kernelowe `rfl` source bindings, bez podnoszenia fuel/limitów;
- `stable_binary003_mul_suffix_002`, `*_groups_total_001`: nadmiarowy
  rozmiar termów; rozdzielone na kernelowe sekwencje i niezależne lematy;
- `stable_binary003_c99_values_001`: wykryto **błąd nowej formalizacji
  referencyjnej**, wybór uint32 zamiast uint64 dla uint64+int32. Poprawiono
  regułę rank, a `usual_matches` pokrywa wszystkie16 par. Nie był to błąd C;
- `stable_binary003_c99_arithmetic_001…004`, `*_c99_shift_001`,
  `*_c99_bitwise_001/002`: jawne niedomknięte konwersje/modulo w próbach,
  potem czyste uniwersalne mosty. Nie ogłoszono na ich podstawie pełnego B.

## 7. Piny produktów końcowych

`run/STABLE_BINARY_003_CLOSURE.json` SHA256:
`bb5abe4fb8a02a2c1c6645e6f7a71bdb671ae444fd1f49f90c6be583ffeb4e6a`.
Zawiera45 nowych source/product/log/receipt records, odziedziczone37
przypiętych modułów `_002`, 17 dalszych lokalnych zależności sprawdzonych
po aktualnych hashach source/olean/receipt, 2 frozen task dependencies oraz
14 granicznych importów z przypiętych bibliotek. Są też piny generatora
AST, Sage i cache/library inputs. Pierwszą wersję listy45+37 zachowano jako
`STABLE_BINARY_003_CLOSURE_BEFORE_DEPENDENCY_EXPANSION.json`;
rozwinięcie zależności nie zmienia żadnego dowodu ani starej closure `_002`.

| Plik / receipt | SHA256 |
|---|---|
| `Source3/FprAllTotal.lean` | `4cb7f05c449f2690127608850a262e2de181fa6dc1a77e5a2daf19959c3e24bd` |
| `Source3/HelperAllTotal.lean` | `659aa8f102261307bb81b213ffa049a5324b68b1c5275567279cabcd0f6b2625` |
| `Source3/FprBlockFuel.lean` | `9112ee28fc6a0595a01de1663c0928af08657cd968a12daf22e87920338da1c9` |
| `Source3/StableBinary003Outcome.lean` | `7e73a5461ae62a7586a6f19f8b6d91bdbdccf15777863e2a5fc36ebed08d1dd2` |
| `Source3/C99CompletenessObligations.lean` | `1e3ba913ce679d36c2fea4df4bed7f23b7da769e813b8994cf866816b6bcb6c1` |
| `stable_binary003_fresh_001/RECEIPTS.json` | `63e21f68d3abae43dc965343a428025df4fc4dd05b1834aa9b70789aafb9a77d` |
| `stable_binary003_fresh_001/logs/Source3_StableBinary003Exports.stdout` | `7fdba841702101b74d871d52da9a5b9c100b3dcb6f6f94c56c00c7b9e1d34972` |
| `stable_binary003_sage_bounds_001/RECEIPTS.json` | `78f284d80c5cd1c1215d86774a3ca698f82676f8ae5eb274578d4b1892099fab` |
| `stable_binary003_sage_bounds_001/TOTALITY_RANGES.json` | `edaca558355b8fe6e5e2499a3032d1e38254e6305011f5cd1c2051180782abdb` |

### Własna ocena

Usunięto całą lukę totalności: legalne wejście pamięciowe helpera nie może
odpaść przez brak dowodu lub `none` w obecnym interpreterze. To istotny
krok względem `_002`. Pozostał jednak osobny problem równości wyników
z niezależnym wykonaniem źródłowym; samo isSome go logicznie nie rozwiązuje.
Jego konkretny front C99 został rozpoczęty, ale nie zakończony. Projekt
nie uzyskał jeszcze pełnego source PASS STABLE_BINARY ani podstawy do
promowania tego wyniku do pełnego KeyGen/M6/C Sign.
