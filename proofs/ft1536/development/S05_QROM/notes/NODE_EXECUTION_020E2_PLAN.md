# TODO020E / continuation002 — bezpośrednie wykonanie węzłów

IN_PROGRESS / WARUNKOWY / NOT_REVIEWED. Start2026-10-13.
Baza21aabee4945d62da958c511a216f4d09ace2ee50;28 pinów wyników,
173 runtime i524 moduły sprawdzone. Runtime node_execution_001.

Cel podetapu: wykonywać niezmienny parsed node bank bez odbudowywania Code.
Wyrażenia czytają adresy dzieci. Ramki run/repeat zawierają adres i licznik;
znaczenie AST jest tylko narzędziem dowodu. Kroki, pętle i końcowe wykonanie
mają odpowiadać ControlStack020E, z rzeczywistymi instancjami lokalnych przesłanek.

Kolejność: odczyt/wyrażenia → atomy → run/repeat/seq/branch/loop → pełny
refinement → bank ramek i bounds → audyt/piny. Licznik przejść nie jest
pełnym czasem. Rekurencja evaluatora wymaga osobnego rozliczenia/realizacji
stosów; pełny Q-RESC nie jest domknięty przez samą zgodność semantyczną.

Wybrana trasa to niezmienna tablica kodu, bez nowych węzłów podczas wykonania.
Dwie areny, streaming i backend C pozostają odroczonymi alternatywami.
Nie zmieniać(M), J/P, prawa kluczy, nonce ani QROM. Jedno okno i jeden
ciężki proces, świeże próby, małe lokalne commity bez push. Daybreak planowany
osobno przez właściciela; nie startujemy odbioru ani monitora ROM.
