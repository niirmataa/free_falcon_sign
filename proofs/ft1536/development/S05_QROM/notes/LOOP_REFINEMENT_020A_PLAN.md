# TODO020 / kontynuacja A: zgodność pętli

IN_PROGRESS / WARUNKOWY / NOT_REVIEWED. Baza wejścia i limity:
`.build/pair_machine_020/loops_001/ENTRY.json`.
Nie zmieniamy samplera019 ani programu020 i nie domykamy QROM.
Poprzedni checkpoint020 pozostaje zamrożony; nowe pliki mają sufiks020A.

Najpierw rzeczywisty readWord: każda taśma, szerokości do384, poprawne
adresy, brak overflow, brak zmian pozostałych rejestrów/pamięci/fault.
Następnie faktyczna pętla wyszukiwania CDF, potem cap80.
Trasa: jawne równania instrukcji → niezmiennik indukcyjny → zgodność
z definicjami019. Nie zastępujemy dowodu eksperymentem ani przesłanką
stwierdzającą już poprawność całej pętli. Pomocnicze równania erasure
muszą dotyczyć istniejącego interpretera020.

Alternatywy i wcześniejsze przeszkody pozostają w PLAN020. W tym oknie
nie wracamy do pełnego drzewa bitowego ani nie zmieniamy reprezentacji.
Jedno aktywne okno, jeden proces Lean naraz,1rdzeń,2048MiB limitLean,
4GiB przestrzeni adresowej,110sCPU/120swall na próbę. Porażki zachowane.
Q-RESC/Q-SAMPLER: obowiązki dowodowe; model słów/banków020 bez zmian.

Korekta budżetu po próbach001–004:2GiB Lean było niewystarczające do
ładowania bibliotek (jawny memory_exception, peakRSS około2,78GiB).
Przywrócono historyczne020 M4096/AS8GiB, nadal1rdzeń i jeden proces.
Wall600s obejmuje zimny odczyt bibliotek; CPU110s bez zmian.
ENVIRONMENT_001/002 zachowują diagnostykę i odrzucone zacieśnienie.
