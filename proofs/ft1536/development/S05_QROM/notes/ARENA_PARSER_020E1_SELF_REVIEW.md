# Kontrola autora — skończona arena parsera020E1

Data2026-10-13; baza d2e192ec744d77e5e6dd8663bfbc59e5881c7e09.
Self-review, bez niezależnego odbioru. Daybreak jest planowanym recenzentem;
nie uruchomiono odbioru i nie nadano statusu REVIEWED.

**Werdykt dla parsera w zadeklarowanym zakresie: proved as written.**
Dla legalnego Code c, maxCap c<2^511 i nodes c≤capacity, parsowanie jego
komórek od pustej areny zwraca stan s, z którego bank-only root odtwarza
.code c. Licznik used=nodes c, sp=1. Dla konkretnego FT1536 capacity=877
przesłanki są wypełnione. Pełny Q-RESC nadal jest incomplete.

## Zależności

SyntaxTape/SyntaxCells020E → ArenaTypes/Stack/StackRead oraz Token/TokenLaw.
Heap Rep opisuje wcześniejsze dzieci i znaczenie węzłów; Meaning jest
wyłącznie parametrem dowodowym. Runtime ArenaStep nie otrzymuje Meaning.
Commit zachowuje stare węzły i znaczenie stosu → Inv/step_refines →
parse_refines → build_correct i actual_exists. Niezależny od Meaning
rekurencyjny decoder banku ma dowód decode_correct i root_correct.
ArenaExecution składa wynik z istniejącym ControlStack oraz EveryTape020D.
ArenaWords daje iniektywne kodowanie wszystkich pól trwałego stanu.

## Macierz kontroli

- [passed] zero pojemności, pełna arena, niedostateczna głębokość stosu;
  strażniki odrzucają krok przed zwróceniem nowego stanu.
- [passed] wskaźnik-sentinel capacity nie jest dostępną komórką banku;
  checkedKind odrzuca każdy adres≥used. Typy i guardy chronią oba banki.
- [passed] ścisłe earlier-child dla aktywnych pól. Nieużywane pola mogą
  zawierać0; nie twierdzimy, że każde z trzech pól zawsze jest dzieckiem.
- [passed] kolejność rhs/lhs, no/yes/guard oraz body/guard. Kształt zgadza
  się z konkretnymi konstruktorami SyntaxTape.push, nie tylko z arity.
- [passed] dopisanie nie zmienia starych komórek ani ich denotacji;
  nowy ghost wpis nie wpływa na wcześniejsze adresy.
- [passed] powiązanie take/drop logicznego stosu z konkretnym zapisem banku;
  depth≤used oraz StackValid zachowane po każdym poprawnym kroku.
- [passed] decoder kończy dla poprawnych wskaźników: każde aktywne dziecko
  ma mniejszy indeks. Fuel nie jest dowodem pełnego kosztu czasu/stacku.
- [passed] `ArenaGuard.rejects_iff` obejmuje dokładnie wszystkie strażniki
  kroku: pojemność, arity, miejsce stosu i listę wymaganych typów dzieci.
- [passed] generic build ma jawne Legal/capacity; konkretne877-tokenowe
  wejście wypełnia te warunki i odtwarza oryginalny program.
- [passed] iniektywne kodowanie obejmuje bank węzłów, bank stosu, used i sp,
  pod capacity<2^511. Nie zawiera ghost Meaning.
- [not addressed] bezpośrednie wykonanie programu po adresach węzłów,
  stos ramek sterowania, scratch i cena każdego prymitywu.
- [not addressed] pełna cena producenta obrazu/losowości, inicjalizacji,
  dekodowania i cała pamięć szczytowa samplera/reduktora.
- [out of scope] fizyczna alokacja natywnego Lean/C, źródłowe KeyGen/Sign/PRG,
  nowa gra wariantu A i mechanizmy QROM.

## Ważne granice interpretacji

`stepCell` używa istniejącego SyntaxCells.decode. Nie jest nowym walidatorem
kanoniczności wszystkich surowych komórek: decoder ignoruje nieużywane
payloady niektórych tagów i może dopuszczać inne reprezentacje tego samego
tokenu. Twierdzenie dla FT1536 dotyczy kanonicznego image(program).
Nie interpretujemy normalizacji wejścia jako bezstratności dowolnych bajtów.

Nieprawidłowy token, referencja lub brak miejsca są błędami parsera. Nie
są dodanymi abortami prawa Sign. Program image ma dowód przejścia bez tych
błędów, bez zmiany wcześniejszego J/P ani warunku(M).

5264 słowa to rozmiar bezstratnego kodowania **trwałego stanu areny877**.
Nie dolicza wejścia, Option/statusu, scratch, stosu dekodera lub reszty
maszyny. `ArenaExecution` najpierw odtwarza Code, potem używa logicznego
interpretera; nie przedstawiamy go jako bezpośredniego wykonawcy węzłów.

## Próby i dalsza trasa

heap001 miał błąd zapisu `<index`: parser rozpoznał notację `<i`. Wtórne
komunikaty o wygenerowanym sorry należą do odrzuconej próby. Przyjęty heap002
jest czysty; niczego nie instalowano z heap001. Inne niepowodzenia dotyczą
elaboracji, zastrzeżonego `at`, zależnych indeksów i nadmiarowych taktyk.
Wszystkie snapshoty i receipty są zachowane. Żaden nieczysty wynik nie jest
podstawą twierdzeń końcowych.

Następna wybrana trasa: zachować parsed bank jako niezmienną tablicę kodu,
wykonać program po adresach i użyć osobnego, skończonego stosu ramek. To
pozwala ominąć potrzebę alokowania nowych węzłów w czasie wykonywania pętli.
Trzeba tę własność udowodnić w nowym wykonawcy, nie założyć darmowego GC.
