# Zakres zamrożonego odbioru

REVIEW_OUTPUTS.sha256 obejmuje raporty,checkery recenzenta,wersje wykonanych
skryptów (także failed math-001),receipty/raw streams,produkty replayu,
odtworzony PDF i publiczne wejścia potrzebne do oceny. Bez HOME/TMP/cache,
olean,wykonywalnych binariów lub sekretów. Root EXECUTOR.json jest chwilowym
stanem procesu i nie jest evidence zakończonego rachunku.

Wejściowy snapshot właściciela ma323 członków; jeden z nich to historyczny
`subject/scripts/__pycache__/chi_tail_rigorous.cpython-313.pyc`,SHA
046e63cb1e3f1ce3f3084aff03ec69d136fdc783532ccb1354e624a52d88948c.
Zweryfikowano go podczas integralności100/100 i usunięto tylko z nowego MIRROR
przed obliczeniami. Jego bajty pozostają w oryginalnym W/inputs,ale zgodnie
z polityką repo cache/bytecode nie jest materiałem commita. Archiwum odbioru
zachowuje322 pozostałe pliki wejściowe,oryginalny pełny manifest i jawny zapis
pominięcia. Jest to projection99/100 author outputs,nie pełny import pakietu
autora do stages. Nowa poprawiona wersja autora powinna mieć czysty source
manifest bez cache. Nie zmieniono oryginalnego OUTPUTS.

Wszystkie matematyczne źródła,certyfikaty,logi i tekst/PDF są zachowane.
Reprodukcja zarejestrowanego pełnego source replayu wymaga oryginalnego100-file
freeze,łącznie z niewykorzystywanym .pyc na etapie walidacji. Nowe checkery
recenzenta i ich dokładne wersje/wyjścia są zachowane samodzielnie; mogą być
uruchamiane w nowym W z odpowiednim mapowaniem inputów. Checkpoint archiwum
jest dokumentacyjnym review (`replay=none`),co nie usuwa rzeczywiście wykonanego
fresh replayu i jego pełnych receiptów.
