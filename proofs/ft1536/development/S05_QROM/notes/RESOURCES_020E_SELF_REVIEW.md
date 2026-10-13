# TODO020E — kontrola autora, zakres zasobów

Data2026-10-13. Baza ad59b07632fb05ae3d06441f44d9fc47cbad31a4.
Tryb self-review, bez niezależnego odbioru.

**Werdykt dla pełnego celu020E: incomplete, with the smallest missing
implication.** Nie wykazano jeszcze, że konkretny wykonawca na skończonych
komórkach realizuje kroki stosu z pełnym rachunkiem przydziału pamięci i czasu.
Poniższe lokalne wyniki mają dowody kernelowe; nie nadają całemu Q-RESC
statusu CLOSED.

## Dokładne zdania i zależności

1. Dla każdego stanu i Expr, postfix zwraca dokładnie eval i nie podpełnia
   stosu. Liczba wykonanych opcodów i stos wartości są≤exprNodes.
   ExprStack → ExprMeter → ExprBackend; pola źródłowe są wypełnione.
2. Dla każdego Input, Code i State, jawna lista oczekujących zadań
   uruchomiona z work c zwraca stan pierwotnego WordRAM020.run.
   ControlStack → ControlSpace/ControlMeter. Guard false i cap zero są
   osobnymi przypadkami. Fuel to liczba przejść sterowania, nie całkowity czas.
3. Osiągalne kolejki FT1536 mają objętość składni≤28941; stara i nowa
   kolejka razem≤57882. Każdy użyty Expr ma≤32 węzłów, więc stos wartości
   i liczba opcodów≤32, głębokość kompilatora≤32, jego syntaktyczny budżet
   kopiowania≤1024. To nie liczba bajtów całego procesu lub stosu Lean.
4. SyntaxTape parser odtwarza każdy Expr/Atom/Code. SyntaxCells odtwarza
   każdy legalny token; zakres cap<2^511 jest zachowany przez każdy krok.
   Kodowanie ma dwa słowa512bit na token. Nie zawiera jeszcze alokatora,
   stosu wskaźników, separatorów zadań ani wykonania instrukcji na tym obrazie.
5. CopyBank i CopyLoop realizują dokładne kopiowanie każdego banku. Pełny
   przebieg ma n transferów, brak błędu i cenę8n+4 w zadeklarowanym modelu
   checked-read/checked-write/increment/branch. Nie jest to koszt producenta
   obrazu h/tablic ani natywnego wykonania tych funkcji Lean.
6. PublicDriver resetuje dowolny dirty do publicznego initial, kopiuje
   wejście, uruchamia interpreter stosowy i kopiuje pełne wyjście. Option
   fallback jest nieosiągalny. Jego prawo jest dokładnie law020D(initial).
   DriverCertificate dziedziczy all-h AC i moment≤1+2^-47 pod tym samym(M),
   także przy tym samym pokrytym μ. Legacy proof world bez zamiany Run2.Games.

## Sprawdzone granice

- [passed] n=0 i pusta kolejka; brak transferu/odczytu spoza banku.
- [passed] cap zero, guard false, wyczerpanie fuel i poprawny fuel work.
- [passed] kolejność dwóch operandów: binary zdejmuje b,a i liczy op a b.
- [passed] pełny reset dowolnego dirty; fallback Option nie zmienia prawa.
- [passed] ustawiona wcześniej flaga fault nie jest zgubiona przez samo
  wykonanie core; driver rozpoczyna z jawnie wyzerowaną flagą.
- [passed] legalność capów i bezstratność każdej komórki dla osiągalnych zadań.
- [passed] obie strony porównania prawa używają tego samego wire i pełnego P;
  nie warunkujemy na sukcesie, nie zmieniamy e ani pokrycia kluczy.
- [not addressed] alokacja i kroki wykonawcy na pamięci komórkowej, relacja
  z AST/listami, kodowanie kolejek i bieżących ramek oraz pełny koszt.
- [not addressed] koszt producenta input image, źródła idealnych bitów,
  decode dla interfejsu wymagającego strukturalnej pary zamiast pełnych bitów.
- [out of scope] natywny Lean/C, źródłowe Sign/PRG, QROM, statusy T12.1/B20.

## Korekta interpretacji kosztu

ExprCompileBudget definiuje i ogranicza **syntaktyczną rekurencję kopiowania**.
Pierwszy komentarz sugerował dokładny rachunek alokatora. Zawężono opis;
nie zmieniono definicji ani proofów. Stare źródło i czysty build są zachowane
w resources_001, poprawiony i odbudowany konsument w resources_002.

Probe association001 sprawdzał prawą łączność append i nie przeszedł rfl.
association002 dowodzi lewostronnego kształtu faktycznej definicji. Zatem
składnik2·left+right odpowiada jej składni; nie jest automatycznie liczbą
alokacji zoptymalizowanego wykonawcy. Nie używamy nieudanej sondy jako dowodu.

Dodatkowy kernelowy wynik unbounded_expression_work pokazuje, że jedna
instrukcja sterowania może zawierać dowolnie duże wyrażenie. Sam licznik
sterowania nie uzasadnia ceny wszystkich prymitywów. Dla FT1536 osobny
reachable-expression bound≤32 usuwa ten lokalny problem, lecz nie zastępuje
realizacji pamięci.

## Następna rozstrzygająca próba — nadal020E

Zrealizować krok parsera na jawnej tablicy węzłów oraz stosie adresów:
każdy token dopisuje najwyżej jeden węzeł, dzieci wskazują wcześniejsze
komórki, a odkodowanie stosu po kroku jest równe SyntaxTape.push. Najpierw
wykazać ten lemat dla wszystkich rodzajów tokenów. Potem związać cały parser
z program_roundtrip, zaplanować dwie areny/zwalnianie i interpreter kontrolny.
Wszystkie odczyty/zapisy, rozmiary wskaźników oraz pamięć scratch muszą mieć
świadki. Ta kontynuacja jest wykonalna i OPEN; nie ogłaszamy trasy wyczerpaną.

Bezpośrednie mnożenie57882 przez koszt komórki nie zamyka pamięci:
nie obejmuje jeszcze ramek parsera, wskaźników i współistnienia reprezentacji.
Najmocniejszy obecny wynik to dokładny driver z J/P i lokalne kernelowe
budżety. Pełne domknięcie zasobów nadal wymaga wskazanej implikacji.
