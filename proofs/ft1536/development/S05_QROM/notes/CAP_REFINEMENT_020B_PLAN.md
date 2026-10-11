# TODO020 / continuation020B — cap80, fallback, pair suffix

Status: IN_PROGRESS / WARUNKOWY / bez niezależnego odbioru.
Wejście: checkpoint020A c1ff755ada8d3be8179204a17fa50fa4b9214ddc;
30 pinów wyników i265 runtime zweryfikowanych. Początkowy HEAD51ddda5e.

1. B-CAP-LIGHT: ogólna indukcja pierwszego sukcesu, bez tabel019.
2. Wypełniona instancja: rzeczywisty krok TrialCorrect020A, licznik, guard,
   ramki i indeksy taśmy; cap80 wraz z wyczerpaniem wszystkich prób.
3. Fallback zerowy i równość z rzeczywistym StandaloneRuntime019.pair.
4. Sufiks pair: zapis obu współrzędnych, pełna forma x²+xy+y², akumulator
   i licznik. Jeśli pojawi się granica dowodowa/zasobowa, zachować dokładny
   częściowy wynik i otwarte przesłanki zamiast promować cały EveryTape.
5. Audyt eksportów/aksjomatów, piny/receipty, małe lokalne commity,
   aktualna mapa murów. To własna kontrola, nie niezależny odbiór.

Klasa: obowiązki Q-SAMPLER/Q-RESC. Model512bit pozostaje jawny.
Bez nowych założeń kryptograficznych, zmiany(M), e lub limitów samplera.
Jeden proces Lean i jeden writer; M4096/AS8GiB/CPU110s. Monitor ROM PAUSED.
Próby020A pozostają nienaruszone; nie powtarzamy szerokiego caploop011.
Runtime: .build/pair_machine_020/cap_light_001, świeże etykiety prób.
Bez push/T12.1/B20/paperu/strony; EveryTape i pełne zasoby nadal OPEN.
