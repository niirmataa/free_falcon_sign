# TODO020E / continuation004 — pełne ceny i realizacja prymitywów

PREPARED / OPEN / WARUNKOWY. Kontynuacja S05/ROADMAP i020E.
Wejście: FINITE_BANKS_020E3_CHECKPOINT, CHECKS, manifesty, klasy i kolejka020E3.
Banki oraz pojemność są dowiedzione w modelu Fin-indexed storage; właściwy
cel odniesienia to BankProgram/BankDriver020E3, bez cofania się do Code.

1. Ustalić jawny model wykonania read/write/update i jego związek z backendem.
   Function.update w Lean nie jest dowodem zapisu in-place przez kompilator.
   Nie dopisywać „pełne memory bound” na podstawie samej pojemności typów.
2. Przypisać ceny sprawdzeniom adresów/tagów, operacjom Word512, licznikom,
   odczytom/zapisom banków, dispatch, push/pop i krótkim prefiksom. Wypełnić
   koszty tego konkretnego forward scan;877 zapisów nie obejmuje wszystkich
   odczytów i arytmetyki. Uwzględnić przeliczenie banku dla bieżącego State.
3. Rozliczyć inicjalizację877/28941 slotów, produkcję/ładowanie obrazu kodu,
   parser, idealne bity, publiczny obraz wejścia, reset oraz transfer wyjścia.
   Cena dotychczasowych kopii jest składnikiem, nie całą ceną producenta.
4. Wyprowadzić całkowity czas i pamięć z faktycznej kolejności życia banków,
   tymczasowych wartości i stanów.88578 słów to trwałe kontrola/wartości;
   poza tym są arena, core State, wejście i scratch. ControlLimit liczy
   przejścia sterowania. Nie utożsamiać go z końcową liczbą prymitywów.
5. Podłączyć całą realizację i ceny do aktualnego drivera oraz EveryTape/J/P.
   Dopiero wypełnienie wszystkich pól pozwala zamknąć Q-RESC w obranym modelu.
   Zachować publiczny initial, pełne porażki, dokładne(M) i kierunek momentu.

Opcjonalna optymalizacja: przeliczać tylko potrzebne wyrażenia lub utrzymywać
cache z dowiedzioną invalidacją. Obecny pełny skan jest poprawną trasą;
optymalizacja wymaga nowego refinement i kosztów, nie cichej zamiany programu.

Źródłowe KeyGen/M, real Sign/PRG, wariant A oraz QROM pozostają w kolejce.
Próby i receipty append-only; jedno okno/proces Lean; małe lokalne commity,
bez push. Niezależny Daybreak i monitor ROM nie są uruchamiane przez ten plan.
