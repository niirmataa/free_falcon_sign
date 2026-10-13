# TODO020E / continuation003 — skończone banki wykonawcy

PREPARED / OPEN / WARUNKOWY. Kontynuuje S05/ROADMAP i020E; wejście:
NODE_EXECUTION_020E2_CHECKPOINT, CHECKS, OUTPUTS/RUNTIME i kolejka020E2.
Bezpośrednie wykonanie tablicy jest domknięte w modelu listy ramek oraz
rekurencyjnego evaluatora. To teraz dokładny cel odniesienia dla realizacji.

1. Zastąpić listę Frame przez skończony bank adres/count i sp. Udowodnić
   zgodność odczytu, pop/push i nadpisywania martwych slotów ze step020E2.
   Pojemność wyprowadzić z osiągalności i istniejących bounds sterowania;
   nie zakładać, że bound32 dla wyrażeń ogranicza także ramki pętli.
2. Zrealizować odczyt wyrażeń na skończonych stosach i udowodnić dokładną
   zgodność z NodeExpr.evaluate. Wypełnić pojemność dla rzeczywistych877
   węzłów i osiągalnych wyrażeń. Uwzględnić lewo/prawo oraz błędne adresy.
3. Dodać ceny odczytów/zapisów/dispatch/arytmetyki oraz pełny rachunek
   wejścia, obrazu kodu, idealnych bitów, parsera, resetu i transferu.
   Osobno rozliczyć współistnienie banków i scratch; controlLimit nie jest
   ceną przejścia ani całym czasem,5264 słowa nie są całym peak.
4. Przenieść EveryTape i dokładną law_eq do zrealizowanego drivera.
   Dopiero po wypełnieniu wszystkich pól zamykać pełne Q-RESC. Zachować
   publiczny initial, jawne porażki, kierunek J/P i dokładne(M).

Dotychczasowe próby i manifesty pozostają niezmienne. Jedno okno i jeden
ciężki proces; świeże etykiety, małe lokalne commity, bez push. Daybreak jest
planowanym niezależnym odbiorem, nie uruchamianym przez tę kontynuację.
Źródłowe klucze/Sign/PRG i kwantowe mechanizmy pozostają w kolejce; nie
wznawiamy monitora ROM ani cudzych workerów.
