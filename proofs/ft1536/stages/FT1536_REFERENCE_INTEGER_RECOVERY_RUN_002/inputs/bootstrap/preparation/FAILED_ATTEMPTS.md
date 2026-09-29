# Nieudane próby i decyzja właściciela

## run001 — zapis stałych QQ

`run_check.py` zweryfikował REPORT/OUTPUTS i85 członków T03. Nowy
`sage check_budget.sage` zakończył się exit1: Sage10.9 nie przyjął
`QQ("0.0000033")`. To błąd zapisu wejścia nowego checkera przygotowawczego;
nie stwierdzono rozbieżności pinów ani wyniku źródeł T03.
Snapshot `.sage`, runner, stdout/stderr i receipt pozostały w `run001/`.

Wykonanie zatrzymano i zgłoszono właścicielowi. Właściciel wybrał
„Popraw i kontynuuj (Recommended)” na pytanie o poprawkę dwóch stałych
i ponowienie w osobnym runie, następnie dokończenie przygotowania T03-B.
Poprawka: `33/10^7`, `37/10^6` w dokładnym QQ zamiast dziesiętnych stringów.
Następna próba: `run002/`; nie nadpisuje pierwszej.
