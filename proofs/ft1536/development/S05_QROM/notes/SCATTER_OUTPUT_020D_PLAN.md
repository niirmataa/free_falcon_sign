# TODO020 / continuation020D — scatter, wyjście, EveryTape

Status IN_PROGRESS / WARUNKOWY, bez niezależnego odbioru.
Wejście3209aa5b: cały select zgodny z019,115 eksportów020C;38 pinów
wyników i244 runtime sprawdzone,447 zależności. Kod020 nie jest zmieniany.

1. Interleaved indeksy/exponent, reprezentacja wybranego wektora i klucza.
2. Aktualizacja bufora modulo18433, wszystkie gałęzie scatterTerm,
   czyszczenie i obie pętle multiply; zgodność z istniejącym Scatter018/019.
3. emitWord oraz emitPair50689bit z właściwą kolejnością i znakiem.
4. Złożenie select/multiply/emitPair w EveryTape i brak błędu, następnie
   dokładne rozliczenie możliwości przeniesienia pełnego prawa J/P.
5. Audyt eksportów, piny/receipty, zachowane nieudane próby, małe commity.

Kroki pozostają oddzielnymi obowiązkami. W razie rzeczywistej granicy
udokumentować PARTIAL i brakującą implikację, bez zamiany konstruktora
na instancję ani dowodu modelu na bezpieczeństwo źródłowego C/QROM.
Model słowa512bit i cen instrukcji jawny; pełne zasoby/driver osobno OPEN.
(M), e=2^-47, kierunek J/P, nonce320 i quantum composition bez zmian.

Runtime .build/pair_machine_020/scatter_output_001, świeże etykiety prób.
Jeden proces/rdzeń, M6144/AS10GiB/CPU110s; stare źródła i receipty nietknięte.
Bez push, nowych gałęzi, równoległych wykonawców i zmian T12.1/B20/paperu.
