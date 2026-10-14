# TODO020E9 — aktywne zapisy clear/scan/push

Baza: `8244a7185b61b0868b36ba4c39970d8aacf4d5e5` (E8).
Runtime: `.build/pair_machine_020/data_equivalence_001/`.
Jedno okno, jeden ciężki proces; lokalny main, bez push. Monitor ROM PAUSED.

Cel: dla każdego typowanego Data, obu wartości fresh i każdej z faz
clear/scan/push dowieść zgodności tagu obecności, adresu i wartości wszystkich
trzech slotów danych rzeczywistego producenta. Razem z E8 sterowaniem i ogonem
otrzymać pełny efekt starego CoreStep w tych fazach. Nie zakładać osiągalności,
poprawności programu ani sukcesu; obejmować pusty wynik skanu (dwa aktywne
zapisy zer), końcowy kursor, pusty pending i pełny stos.

Droga: bezpośredni efekt jawnej listy danych z CoreFieldPatch.values/frames,
a następnie zgodność rzeczywistego wyjścia z jej kodowaniem. To jawnie
równoważność efektu z dawnym generatorem; nie deklaracja równości jego
proof-generated listy ani podstawienie listy do wykonania. Act pozostaje
poza tezą składową, bez zmiany celu uniwersalnego. Wszystkie próby zachowane.

1. Jawna lista, limit trzech zapisów i efekt danych/sterowania.
2. Flagi obecności, adresy i payloady; powiązanie slotów clear/scan/push.
3. Cały bufor poza act, efekt starego kroku i jawne przypadki brzegowe.
4. Kontrola autora: typy/aksjomaty/logi/piny/zakres; checkpoint i mapa murów.

Nie dodawać przesłanki równości jako substytutu dowodu. Nie zmieniać runtime
E6, dziedziny publicznego initial, J≪P ani momentu (M). Bez nowego transportu
całego prawa, rachunku peak/czasu lub deklaracji bezpieczeństwa QROM.
