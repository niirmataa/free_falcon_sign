# S05/E8 — porównanie decyzji konkretnego producenta

IN_PROGRESS / WARUNKOWY / NOT_REVIEWED. Kontynuacja zlecenia pełnej
uniwersalnej zgodności producenta ze starszym CoreStep, baza fa9253b8.
Jedno okno, jeden ciężki proces, lokalny main, bez push. Runtime:
.build/pair_machine_020/decision_equivalence_001/; nowe etykiety prób.

Kolejność: (1) małe prawa słów/flag i wszystkie pola sterowania poza act;
(2) scanPresent/scanValue wobec rzeczywistego ArrayValues.entry;
(3) pełne decyzje act wobec FixedAction/MemoryEdit, włącznie z porażkami;
(4) połączenie stałych slotów danych i sterowania z referencją E7,
wykonywanym kodem i CoreStep. Nie awansujemy samego sterowania do zgodności
całego kroku. Cel forall d, RemainingEquality d pozostaje otwarty do dowodu.

Wspólne przesłanki samplera, (M), prawo kluczy, J/P i model nie zmieniają
się. Ta praca rozładowuje obowiązek dowodowy, nie dodaje założeń kryptograficznych.
Dalsze rodziny producenta, cały peak/czas i QROM pozostają osobnymi obowiązkami.
