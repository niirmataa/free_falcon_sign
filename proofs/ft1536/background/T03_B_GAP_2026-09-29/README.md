# T03-B — rachunek spójności przygotowywanego zlecenia

2026-09-29, GPT-6 Astra Fast, prowadzący. Projekt Niirmata; atrybucja Falcon
Project / Thomas Pornin zachowana. Ten pakiet przechowuje przygotowanie
kontynuacji T03, nie nowy source proof ani niezależny review starego T03.

`INPUTS.sha256` przypina8 wybranych wejść frozen T03. INPUT_BINDING zapisuje
sprawdzenie zewnętrznych pinów REPORT/OUTPUTS i85 członków. Rachunek:
`sage check_budget.sage INPUT_DIR OUTPUT_JSON`, Sage10.9,preparser,QQ/RIF256.
Wykonywać kopię źródła w NOWYM trwałym W z własnym HOME/TMPDIR/cache;
ten snapshot po zapisaniu jest RO. Nie uruchamiać historycznego run_check.py
w archiwum — utrwala oryginalny launcher i układ ówczesnego W.

run002: exit0,stderr pusty,źródła przed/po zgodne. BUDGET_CHECK.json rozlicza
sumę10 składników6086.40076165; po wyzerowaniu A2,A4,B,C1,C2,C3 zostaje
majoranta16.10835956 (nie dolna granica actual error). D=15.66749912;
przy D=0 i zachowaniu A1/A3/E margines≈0.05913956. Historyczne share=0.1
to nie1/10 połowy. Podana paraδ/eroot daje C1≈0.14172287>0.1.
Nowa alokacja0.4098125 jest proponowanym budżetem, nie uzyskanym boundem C.

run001 exit1 i jego źródła/logi/receipt zachowano. FAILED_ATTEMPTS opisuje
stop-and-report i zgodę właściciela na dokładny zapis ułamków i osobny run002.
Nie nadano statusu PROVED/REVIEWED; source_bounds_proved=false,B_gap_closed=false.

TASK: `proofs/ft1536/documents/FT1536_ZADANIE_T03_B_GAP_FIX_2026-09-29.md`,
SHA c10d50304e8272df1f8367c5e19a432a0746e1239d1d7029c4447b20df75781a.
W wykonawcy: `work/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002`, ręczny start.
