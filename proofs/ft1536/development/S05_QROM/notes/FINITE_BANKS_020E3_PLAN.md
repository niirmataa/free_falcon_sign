# TODO020E / continuation003 — skończone banki ramek i wartości

IN_PROGRESS / WARUNKOWY / NOT_REVIEWED.2026-10-13.
Baza1236b53f237eb55bf4e685f721f7b9dfd5bf6751; zakres właściciela:
skonkretyzować banki i dowieść zgodności/pojemności, następnie checkpoint.

Wybrana realizacja: stos ramek z Fin-capacity bankiem i sp; dla wyrażeń
bank Option Word, indeksowany po stałej tablicy kodu. Wartości są wyliczane
od najniższego indeksu do najwyższego, z odczytem wyłącznie wcześniejszych
dzieci. Każde użycie po zmianie State otrzymuje świeżo wyliczony bank.
Ten wariant usuwa rekurencyjny stos wyrażeń kosztem ponownego przejścia
po877 komórkach. Nie zakładamy bound32 dla ramek i nie udajemy, że pełne
przeliczenie jest darmowe. Skończone payloady/flag oraz stack frames są
modelem; koszt pełnego drivera i backend fizyczny pozostają odrębne.

Plan: wspólny ograniczony stos → pojemność sterowania z reserve → bank
wartości i topologiczna zgodność → zastąpienie evaluatora w dispatch →
całe wykonanie z bankami → konkretna instancja/public initial/law →
audyt/piny/checkpoint. Dalszy rachunek całkowitego czasu, wejścia/losowości,
scratch i peak pozostaje kolejką020E. Nie zmieniamy(M), praw ani gry QROM.
Jedno okno/proces Lean, świeże próby, małe lokalne commity bez push.
