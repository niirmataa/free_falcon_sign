# Kontrola autora — skończone banki020E3

2026-10-13. Baza1236b53f237eb55bf4e685f721f7b9dfd5bf6751.
Self-review / NOT_REVIEWED. Nie uruchomiono niezależnego odbioru Daybreak.
Werdykt dla jawnie określonego modelu banków: **proved as written**.
Pełny Q-RESC oraz bezpieczeństwo QROM pozostają incomplete.

## Twierdzenia i wypełnienie przesłanek

BoundedStack definiuje bank Fin capacity→A i sp:Fin(capacity+1).
view jest tylko specyfikacją. Runtime top/drop/push/pushMany nie odtwarza
całej listy kontynuacji. view_put/view_drop dowodzą efektów operacji,
a pushMany_correct wymaga i wykorzystuje rzeczywiste miejsce w banku.

FrameReserve wyprowadza length≤footprint≤reserve; next_reserve zachowuje
budżet każdego przejścia. BankStep wypełnia warunek miejsca dla konkretnego
prefiksu action, łącznie z zachowaną resztą stosu. BankExecute dowodzi
równości wykonania dla każdego fuel. BankProgram.invariant_correct korzysta
z prawdziwego invariant parsera; actual_correct wypełnia go dla877 węzłów,
pojemności28941 i dotychczasowego controlLimit. Nie pozostała tu swobodna
przesłanka „poprawny krok”, „brak overflow” ani „wystarczy stos”.

## Bank wartości i wybrany kompromis

Zamiast stosu rekurencyjnej ewaluacji wybrano topologiczny przebieg po całej
stałej tablicy. Values to dokładnie Fin cap→Option Word. Każdy zapis entry
korzysta wyłącznie z wcześniejszych indeksów, co runtime jawnie sprawdza.
Prefix jest dowodowym niezmiennikiem. HeapValid daje sens bieżącego węzła
i wcześniejszość dzieci; advance_correct zachowuje wszystkie stare wartości.
Tail-recursive sweep przechodzi po ograniczonych indeksach, zawsze z bankiem
tej samej wielkości. build_correct i lookup_correct dowodzą wartości komórek.

ValueRefinement.evaluator_eq jest równością dla KAŻDEGO wskaźnika: wyrażenie,
węzeł kodu i adres poza used. Wypełnia podstawienie w BankAction dla każdej
gałęzi. action buduje świeży bank dla aktualnego State; nie przechowuje
starego cache po zapisie rejestru/pamięci. Nie wymaga kwantowej historii.

Ten wybór świadomie przelicza również czyste wyrażenia niewybranych gałęzi.
Expr czyta tylko rejestry/literały i wykonuje totalną arytmetykę Word;
operacje pamięci/taśmy pozostają atomami. Nie dodaje to efektów ani fault,
ale kosztuje pracę. ValueScan wiąże instrumentowane wykonanie z tym samym
sweep i dowodzi877 wywołań advance dla877 komórek. To liczba zapisów
w abstrakcyjnym przebiegu, nie całkowity czas/prymitywowa cena.
Bound32 dla wyrażeń nie jest używany jako pojemność ramek.28941 to
konserwatywna, udowodniona pojemność; nie twierdzimy, że jest minimalna.

## Sprawdzone przypadki graniczne

- Stos pusty kończy poprawnie; przy fuel=0 niepusty stos daje ten sam none
  co020E2. drop jest nasycany, top nie odczytuje martwego slotu.
- Stos pełny odrzuca push. Instancja dowodzi, że potrzebne pushe mają miejsce.
- Pop nie czyści danych: sp wyznacza żywy zakres. Kolejny push nadpisuje
  dokładnie martwy slot; view dowodzi zachowania całej reszty.
- Węzły dziecka są wcześniejsze od rodzica, a wskaźnik-sentinel nie jest
  dostępną komórką. Lookup poza used daje none również przy dowolnym banku.
- Wartości code-node są none. Dla poprawnego wyrażenia wartość jest some
  właściwego Word, więc obecność None nie staje się nową porażką samplera.
- Kolejność binary(left=second,right=first), branch i loop jest zachowana.
  Zgodność z020E2 obejmuje cap0, guard0, retry i błędne adresy atomów.
- Działający stos jest bankiem, nie listą. Chwilowy prefiks action nadal
  ma postać listy, ale action_prefix dowodzi≤2 dla każdej związanej ramki;
  nie ukrywamy w nim rosnącej kontynuacji.
- Pojemności są wypełnione dla wszystkich wejść i stanów; publiczny driver
  nadal resetuje do initial i zachowuje pełne wyjście na każdej taśmie.
- J≪P pozostaje all-h. Moment≤1+2^-47 wymaga dokładnie tego samego(M).
  same_key_law używa tego samego mu, Covered i M na pokrytej dziedzinie.

## Słowa, model i otwarte koszty

BankStorage daje iniektywne kodowanie: Option Word jako flaga+payload,
ramka jako tag+adres+licznik, sp jako słowo. Jawne przesłanki cap/capacity<2^511
są wypełnione dla877/28941. Zarezerwowane komórki obu banków wraz ze sp mają
88578 słów512bit. To rozmiar kodowania ich trwałego stanu, bez areny kodu,
wejścia/core State, indeksów skanu, tymczasowych ramek i całego peak.

Banki są modelem Fin→payload z Function.update. Nie wykazano, że natywny
Lean realizuje je mutable/in-place ani że nie zachowuje domknięć poprzednich
wersji funkcji. Ta implementacja fizyczna i jej koszt pozostają oddzielnym
powiązaniem z backendem. Dowód pojemności dotyczy jawnego modelu banków,
a nie pomiaru RAM procesu. Brak nowej alokacji węzłów kodu nie oznacza
zerowego kosztu pozostałych prymitywów lub inicjalizacji.

Nie domknięto ceny bitowej/word-RAM wszystkich operacji, producenta obrazu,
banków początkowych, idealnej taśmy, resetu/transferu, scratch ani globalnego
peak/time. ControlLimit nadal liczy przejścia sterowania. Koszty kompilacji
w receipcie nie są kosztami samplera. Nie zmieniono modelu Sign ani źródłowej
gry wariantu A; certyfikat pozostaje w przypiętym środowisku legacy.

## Historia i odbiór

Nieudane stack001 i values001 zachowano z logami i źródłami. Dotyczyły
indeksów zależnych, wyboru lematu update i ostrzeżenia taktyki; nie były
kontrprzykładami. Końcowe źródła mają czyste logi. Szczegółowy audyt eksportów,
aksjomaty, piny oraz wszystkie próby są w CHECKS i manifestach tego checkpointu.
Żaden wynik nie otrzymał statusu REVIEWED; A-QMT i primitive-bound Q-PRG
pozostają jawnymi założeniami. Źródłowe KeyGen/M, Sign/PRG i mechanizmy
kwantowe wymagają dalszych dowodów.
