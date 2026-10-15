# TODO020E11 — konsument kodowanych poleceń i driver rdzenia

Baza main: `8d8614bc55a6d9bb7b14e4fb754cda6b9b8a20d9`.
Baza S05: `fadfca600ec9c852cd2ba9f7655b10f4f7b03423` (E10), bez późniejszego
rozjazdu źródeł S05. Runtime: `.build/pair_machine_020/consumer_driver_001/`.
Jedno okno, jeden ciężki proces, lokalny main, bez push. Monitor ROM PAUSED.

Cel: wykonywalny konsument rzeczywistych96 słów wyjścia producenta, a potem
sterownik kolejnych kroków na aktualizowanym surowym banku pamięci. Dowód
zgodności ze starym CoreRun dla każdego typowanego stanu i każdego paliwa,
włącznie z0, terminalnymi stanami i porażkami. Stary CoreStep i kanoniczna
lista mogą być wyłącznie celem porównania, nie implementacją sterownika.

1. Sprawdzany dekoder trzech słów: tag0 wymaga zerowego paddingu; tag1 wymaga
   poprawnego signed adresu; pozostałe kodowania dają błąd. Rozróżnić błędne
   kodowanie od pustego slotu i zapisu wartości0. Roundtrip i soundness.
2. Konsument czyta jeden slot na krok, bez listy zdekodowanych poleceń.
   Zgodność ze ScriptMachine, granice kursora, latch błędu i pełne wykonanie.
3. Porty stałe jawnie oddzielone od surowego core. Każdy krok uruchamia te
   same dwa kody producenta i konsumenta na aktualnej pamięci. Bez dekodowania
   Core lub odtwarzania historii między krokami.
4. Driver, zatrzymanie, paliwo, końcowy odczyt i pełny stary wynik. Nie utożsamiać
   transportowego błędu kodowania z dawnym wynikiem None/fault.
5. Kontrola autora, piny/logi/aksjomaty, lokalny checkpoint i mapa murów.

To runtime modelowy oparty na bankach/prymitywach E5/E6, bez nowej deklaracji
native lub pełnego czasu/peak. Inne rodziny producenta, całe publiczne wywołanie,
transport EveryTape/J/P i QROM mają pozostać jawnie oddzielone. Nie zmieniać(M),
publicznego initial, dziedziny h lub statusów T12.1/B20/paperu.
