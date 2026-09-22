# S06 — poprawki przed domknięciem częściowej kampanii

1. **E1/subfields:** stopień N/2 ma wejść do pętli jako n=N/2,wymiar=2n=N.
   Dodać kontrolę β<=declared lattice dimension. Przeliczyć wszystkie21 rows;
   old values zachować. Rozdzielić exact moments,RMS/centered variance,
   heuristic geometry i LIFT. Nie raportować uniwersalnego braku przewagi.
2. **E2/aggregation:** `point=log2_rop` wymaga rzeczywistego log2; zachować
   również raw rop/status. Nie mieszać classical/quantum/cost modelów w głównym
   minimum. Ewentualna sensitivity envelope ma jawny osobny opis.
3. **E3/grid:** naprawić MATZOV spelling we wszystkich inputs/runners,nie
   tylko w nowej wersji jednego skryptu. EMPTY/ERROR/NO_FINITE_RESULT osobno;
   kanoniczny key/version i reguła supersession dla repair. Nie liczyć
   failed/empty duplikatów jako nowych poprawnych komórek. Rozliczyć missing50.
4. **E4/summary:** FT1536 minimum zadeklarowanych main costs wskazuje P1.
   Usunąć bezwarunkową regułę `per-target cost*Q`; podać prawidłowy
   success/resource model. P1a nie jest gotowym trapdoorem,P2 relation proxy
   nie daje akceptowanych bajtów bez dodatkowego mostu.
5. **Provenance:** finalny report/INPUTS/OUTPUTS z dokładnymi wersjami
   skryptów,vendor/param/source pins oraz rzeczywistymi argv/exit/logs.
   Nowe autorytatywne rachunki przez `sage file.sage`; historyczne tryby jawne.

Naprawy tylko w nowej wersji lub kontrolowanym wznowieniu przez właściciela;
ten recenzent nie dopisywał komórek do źródłowej kampanii.
