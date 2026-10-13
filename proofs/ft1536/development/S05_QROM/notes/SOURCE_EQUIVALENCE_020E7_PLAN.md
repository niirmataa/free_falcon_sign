# S05 / E7 — uniwersalna zgodność producenta (WARUNKOWY)

Cel właściciela: zamknąć zgodność wykonywanego producenta E6 ze starszym
krokiem CoreStep020E5. Jedno okno, jeden proces Lean naraz, lokalny main,
bez push. Baza S05: 8ed5e9e9a800ca7cee9a5b38f42b788ef3c9a8af.

1. Odczyt wszystkich 96 pól z rzeczywistych banków, dla każdego typowanego
   stanu, włącznie z porażkami. Bez przesłanki poprawnego programu lub cache.
2. Rachunek ustalonych slotów: trzy opcjonalne zapisy danych, szesnaście
   zapisów sterowania i puste sloty; porównanie efektu z dawną listą zapisów.
3. Zgodność konkretnego obwodu CoreCircuit/CoreSlots z CoreControl/CoreData
   i CoreStep, a następnie połączenie z wykonywanym kodem ProducerStored.

Żaden z etapów nie zastępuje brakującego następnego. W szczególności sam
odczyt wszystkich pól NIE dowodzi zgodności kroku. Pełny cel pozostaje OPEN
do otrzymania bezwarunkowego względem tej zgodności twierdzenia kernelowego.
Nie dodajemy zgodności kroku jako pola wejściowego certyfikatu.

Rachunek J/P, MassCondition, prawo kluczy i modele pozostają bez wzmocnienia.
To obowiązek Q-SAMPLER/Q-BIND/Q-RESC, nie nowe założenie kryptograficzne.
Dalsze rodziny producenta, pełne życie obu maszyn, natywna realizacja i
redukcja QROM pozostają osobnymi otwartymi obowiązkami.

Próby i nieudane elaboracje: .build/pair_machine_020/source_equivalence_001/.
Każde uruchomienie ma odrębną etykietę, kopię źródeł i receipt; bez nadpisywania.
