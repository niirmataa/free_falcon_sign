# Kontrola autora — producent020E6

**Werdykt główny: incomplete, with the smallest missing implication.**
Cel: źródłowo zgodny producent poleceń samplera z dowiedzioną pamięcią roboczą.
Najmniejsza brakująca implikacja: równość całego konkretnego okna/circuitu
z wcześniejszą decyzją CoreStore/CoreStep. Brakuje też złożenia okresów życia
obu etapów i pozostałych rodzin producentów. Nie ma niezależnego odbioru.

## Graf

closed Expr → compile/frame correctness → executeList/output
→ stored code/pc termination → fetched-instruction machine refinement
→ full stored-state codec + primitive stores → region traces and local peak.

Osobna gałąź: konkretne Window/CoreCircuit/Slots → workspace bound
→ stored execution equals their own expressions. Połączenie do starego
samplera wymaga nadal SourceSnapshot/decision equivalence. Diagram nie
został domknięty kołowo przez nazwanie oczekiwanego wyniku definicją.

## Macierz

- PASSED: typy i wszystkie końcowe logi nowych modułów; zgodność hashy;
  audit standardowych aksjomatów; brak sorry/admit/native_decide/bv_decide.
- PASSED: register-frame proof zabezpiecza wcześniejsze wyniki bin/select;
  checked load obsługuje niepoprawny adres; pierwotna flaga pozostaje sticky.
- PASSED: IR ma jawne 23 słowa i fazę; initial image jest równy ALLOC_ZERO.
- PASSED: kod jest jawnie zapisaną tablicą,22 słowa/instrukcję, z odczytem
  bieżącego wiersza. invoke nie zawiera kompilacji ani produkcji tablic.
- PASSED SCOPED: bound pojedynczego wywołania obejmuje rzeczywiste tablice
  źródeł i kodu oraz każdy stan fetch/execute. To model RegionRAM, bez native.
- COMPUTATION ONLY:4480 syntetycznych snapshotów; brak wyczerpującego pokrycia
  512-bitowych wartości i brak dowodu poprawnego uformowania snapshotu.
- OPEN: oba uniwersalne source bindings, dalsze rodziny, dwufazowy sterownik
  i wspólne okresy życia. Same 186 słów nie zamykają pełnego producenta.
- OUT OF SCOPE: niezależny odbiór, QROM reduction, źródłowe M/Sign/PRG,
  native C/Lean, bitowy koszt implementacji ALU.

## Przesłanki/model

Word512 i stałe instrukcje RAM są modelem, nie założeniem kryptograficznym.
Sources jest rodziną rzeczywistych banków odczytywanych po indeksie;
context source_read/fetched_word wiąże je ze składowaną reprezentacją.
Nie ma instrukcji wywołującej dowolną funkcję hosta. Model nie twierdzi,
że natywne Array.set jest in-place. Globalna integracja alokatora pozostaje
poza tymi lokalnymi twierdzeniami.

Masa(M), publiczne initial, h, prawo kluczy i poprzednie J/P nie zmienione.
Nowy kandydat nie dostaje odziedziczonego J/P przed dowodem równości efektu.

## Proofread

Przejrzano wyłącznie nową partię020E6. Doprecyzowano słowa „lokalny”,
„pojedyncze wywołanie”, „własne wyrażenia” i granicę diagnostyki. Bez
kosmetycznego zmieniania matematyki zaakceptowanych modułów. Otwarte
implikacje pozostały jawne; brak konwencji zmieniającej zakres po cichu.
