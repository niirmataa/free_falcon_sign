# TODO020E10 — dispatch act i zgodność wszystkich faz

Baza: `e8edf9f0b7115d92862c10b9c490d0d8acf1323d` (E9).
Runtime: `.build/pair_machine_020/action_equivalence_001/`.
Jedno okno, jeden ciężki proces; lokalny main, bez push. Monitor ROM PAUSED.

Cel: dla każdego typowanego Data i obu fresh powiązać rzeczywisty producent
z efektem starego CoreStep we wszystkich siedmiu fazach, bez Inv/reachability,
poprawności programu lub sukcesu. Nie zmieniać domeny h, initial ani momentu(M).

1. Dokładny opcjonalny wynik dawnej FixedAction.action; decyzja actionOK,
   semantycznie aktywne pola Edit i wszystkie11 słów Pending.
2. Run i again: wszystkie tagi, licznik zero, brak wartości/węzła, błędny
   rejestr/adres i odmowa wznowienia. Odróżnić odmowę od skutecznej akcji fault.
3. Zapis sterowania oraz co najwyżej jeden zapis danych w act. Połączyć z E9
   przez jawny bufor dowodowy i wykazać stary efekt dla wszystkich faz.
4. Kontrola autora, piny/receipty/aksjomaty/logi, checkpoint i mapa murów.

E9 daje równoważność efektu z dawną referencją; E10 kontynuuje tę drogę bez
roszczenia surowej równości obu starych/nowych list. Nie dodawać przesłanki
zgodności jako substytutu dowodu. Pomocnicze bufory nie zastępują runtime.
Pełny transport EveryTape/J/P przez producenta, pozostałe rodziny producenta,
cały czas/peak, source binding i QROM pozostają dalszymi obowiązkami.
