# TODO020E / continuation005 — plan dowodu peak

IN_PROGRESS / WARUNKOWY / NOT_REVIEWED. Baza dd041b73228c59fc14ff80dc56ea46780974db79.
Runtime .build/pair_machine_020/peak_memory_001, osobny od zamkniętego020E4.
Cel: pełny peak konkretnego samplera w jawnym modelu RAM, z EveryTape/J/P
oraz jawnie policzoną reprezentacją, alokacją i scratch. Nie kończyć na
kolejnym rekordzie z brakującym świadkiem ani na sumie naliczeń.

Rozważone mechanizmy:
- Uniwersalne przejście Run.allocated→payload: odrzucone kernelowym
  CostSpaceGap020E4; tej reguły nie próbujemy ponownie.
- Pełny ślad wszystkich kopii020E4 bez zwalniania: otwarta alternatywa;
  wymaga opisania także zatrzymanych kontynuacji i każdej konstrukcji.
- Wybrana trasa: banki RAM przydzielone raz, jawne przejścia po komórkach,
  skończony stan sterowania i scratch. Dowód zgodności z backendem Array
  jest obowiązkowy; native Lean/C pozostaje innym modelem wykonania.

Najpierw allocator i reprezentacja danych z odczytem po zapisie; potem
stan całej maszyny, reset/scan/dispatch i zgodność wykonania; następnie
producent wejścia, parser, kopia wyniku, pełne layout/peak oraz certyfikat.
Wszystkie przejścia wykonawcy mają konkretnych konsumentów. Zmieniona
realizacja pamięci nie zmienia programu, M, e, prawa porażek ani kluczy.

Kontrole: dokładne Sage/ZZ, kernel Lean, czyste logi/aksjomaty, snapshoty
nieudanych prób i piny; małe commity main, bez push. Jeden wykonawca i jeden
ciężki proces. Bez obcych workerów, monitora, odbioru Daybreak i zmian T12.1/B20.
