# TODO020E13 — liczniki rzeczywistego wykonania

Kontynuacja E6-FULL-RESOURCES z checkpointu E12 `5f36087c`.
Status: DEVELOPMENT / WARUNKOWY / NOT_REVIEWED. Jeden wykonawca, bez push.

Cel etapu: liczby przejść powiązane z wykonywanym kodem, z kernelową
równością wyniku po usunięciu liczników. Zakres: fetch/execute producenta,
sprawdzany konsument wszystkich slotów, surowy driver i jego wynik.
Uwzględniamy malformed/terminal/zero fuel, bez warunkowania na sukces.

Droga aktywna: instrumentacja tych samych rekurencji, indukcja względem
paliwa, następnie złożenie. Pierwszy test: ogólna równość producenta dla
każdego resident code i sources, bez redukowania konkretnych dużych programów.
Droga alternatywna (odroczona): wyprowadzenie cen bezpośrednio ze śladów
regionów; wymaga pełnych odczytów, arytmetyki, scratch i sterowania.
Nie używamy samych dawnych cen E4: dotyczą innego wykonania i nie dają
wymaganego powiązania. Próby graniczne badają błędne kodowanie, zatrzymanie
i pełny skan mimo wykrycia błędu.

Liczby przejść nie są pełnym czasem, liczbą operacji bitowych, alokacją ani
peak. Ładowanie kodu, przygotowanie publicznych portów, parser, odczyt wyniku,
wszystkie kopie oraz wspólne okresy życia zostają jawnie w kolejce. Rachunek
nie zmienia(M), J/P ani wcześniejszego EveryTape. Liczniki są instrumentacją
dowodową; nie twierdzimy, że zostały już ulokowane w backendzie.

Każda próba ma osobny label/snapshot/log. Jeden Lean, limity istniejącego
runnera4GiB/AS8GiB; bez zwiększania limitów i bez wykonania ogromnej taśmy.
Końcowy checkpoint: źródła, clean logs, audit axioms, zachowane porażki,
klasy warunków, mapa murów, piny i lokalny commit main.
