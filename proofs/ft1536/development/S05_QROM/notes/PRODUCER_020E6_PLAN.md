# TODO020E / producent — kontynuacja020E6

IN_PROGRESS / WARUNKOWY. Baza S05 `3aed7cb57767886318625927252d4880ecc0c114`.
Runtime `.build/pair_machine_020/producer_001`; poprzedni runtime zamknięty.
Cel właściciela: konkretny producent poleceń z policzoną pamięcią roboczą,
nie bound samej długości wyniku. Jedno okno, jeden ciężki proces, bez push.

Trasy:
1. Policzyć listy starego producenta: odłożone, wymaga także dowodu liveness
   argumentów i pośrednich struktur; nie zakładamy optymalizacji kompilatora.
2. Wytwarzać polecenia bezpośrednio w stałych slotach — wybrana trasa.
   Jawne odczyty, rejestry, operacje skalarne, tagi nieaktywnych slotów;
   dowód równości efektu zamiast wymagania identycznego ułożenia listy.
3. Dowolna funkcja hosta jako atomowy generator: odrzucone jako ukrywanie
   brakującego rachunku pamięci we wnętrzu prymitywu.

Kryterium: zamknięte realizacje źródłowych odczytów i obliczeń producentów,
stały bank roboczy z danymi i śladem, zgodność zapisanego bufora ze starym
krokiem (także błędy), dokładny rachunek Sage i kernel, czyste audyty/piny.
Full-call allocation controller, nowy pełny czas, źródłowe M/Sign/PRG i QROM
pozostają odrębnymi obowiązkami. Nie zmieniamy M, h, prawa kluczy lub J/P.
