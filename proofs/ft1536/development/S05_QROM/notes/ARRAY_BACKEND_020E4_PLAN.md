# TODO020E / continuation004 — tablicowy backend i pełne zasoby

IN_PROGRESS / WARUNKOWY / NOT_REVIEWED.2026-10-13.
Baza7eee9439f94a80d279e9b7c84fa31e1dbf123dce. Jedno okno/proces Lean,
próby append-only, małe lokalne commity bez push. Zakres właściciela:
realizacja prymitywów w backendzie oraz pełny rachunek czasu i pamięci.

Zgodnie z TODO_RESOURCES_020E kryterium końcowe dotyczy jawnego modelu
Word512/RAM; ceny bitowe/C są osobnym mostem. Wybrany backend: gęste Array
z dowodem get/set i invariantów rozmiaru; prymitywy oraz ich ceny muszą
być jawne. Semantyka Array nie dowodzi sama jednostkowej ceny natywnego
kompilatora ani in-place/copy-on-write. Rachunek musi nazwać przyjęty model
alokacji i cen, zamiast ukrywać go jako przesłankę poprawności samplera.

Kolejność: banki Array → backend stanów/sterowania/wartości i zgodność020E3
→ kosztowane prymitywy i przebiegi → producent wejścia/obrazu/losowości,
inicjalizacja i transfer → globalny czas/peak tego samego drivera →
EveryTape/J/P, audyt i checkpoint. Konstruktor kosztu bez świadków faz
nie zamyka Q-RESC. Zachować(M), publiczny initial, pełne porażki i prawo.
Nie zmieniać statusów T12.1/B20 ani konsumować nowego ROM bez osobnego
sprawdzenia; nie startować monitora ani niezależnego odbioru.
