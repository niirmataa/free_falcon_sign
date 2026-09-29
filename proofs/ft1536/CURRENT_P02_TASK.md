# P02 — istniejący wynik; uzupełnienie freezu przed V02

**Decyzja właściciela2026-09-29:** najpierw rozliczyć wykonany P02 w work,
uzupełnić pakiet i wykonać V02. Nową matematykę add/sub odłożono do odbioru
rzeczywistego zakresu. Koordynator:sesja `ses_f137502d0ffe6BYk3HEHU1xxZL`.

## Co już istnieje

`proofs/ft1536/work/B20_001/P02/output/`:
**COMPLETE_FOR_REVIEW / PARTIAL_PROOF**,autor Astra Fast,
sesja `ses_f33f9f0afffeLad43JuCwKBDk2`,freeze2026-09-25,joby zakończone.
68/68 plików zgodnych:

- REPORT `98ea050bfe15b39b4ad2a6d26428bcd7e12f22ca33b06b6bc98e9e964bb295a5`.
- OUTPUTS `4e8942ccaf46f0971688a0f0cc1d07c5831a46175e6ad2dde903c9f55b046a01`.

Zakres deklarowany:LE64,shifty,literal-BitVec wykonania neg/double/half/
pack/rint/floor z domenami,sub warunkowo. Pełne real-error add/mul/div/sqrt,
real-rint i C→machine pozostają otwarte. T03-B potwierdził brak arithmetic
callee w frozen shiftCalls;V02 oceni dokładny scope P02.

## Precheck i bieżące zlecenie

Stary OUTPUTS nie obejmuje runnera `run/job.py`,AuditExports/AuditTerms
z34-entry BUILD_PLAN ani9 cytowanych receiptów i raw logs. Materiały są
w W,zgodnie z historycznym OUTPUT_SCOPE. HANDOFF odsyła po final HEAD do
OUTPUTS/REPLAY,ale nie zapisuje tam tego pinu. Kontrolę zatrzymano i zgłoszono;
właściciel wybrał przygotowanie uzupełnienia. Nie zmieniono starych bajtów.
[Precheck,decyzja i receipty przygotowania](background/P02_FREEZE_CLOSURE_2026-09-29/README.md).

**PREPARED_OWNER_START — FT1536_P02_FREEZE_CLOSURE_RUN_001**:

- [TASK](documents/FT1536_ZADANIE_P02_FREEZE_CLOSURE_2026-09-29.md),SHA
  `ce02389fffec9edf11c5f2430d9e8b7081f612d63ec3f38f761ac97773db259e`.
- W: `proofs/ft1536/work/FT1536_P02_FREEZE_CLOSURE_RUN_001/`.
- OUTPUT_DIR=`W/output/`;oryginalny P02 read-only.
- Bootstrap8700 członków/359332583B;MANIFEST
  `088b407a3be937a49b1a23d4305e83641123d9770040d78b4a43b7cabe14c65f`.
- Sprawdzone inputs7371,9 przebiegów/144 kroków/288 raw logs;bez nowego replayu.
- Wykonawca/model wybierany i uruchamiany ręcznie przez właściciela.

Nowy pakiet ma zachować `RESULT.task_id=B20_001_P02_WORD_FPEMU_REFINEMENT`,
dodać `packaging_task_id`,revision/predecessor pins oraz rzeczywisty nowy HEAD.
Koordynator po handoffie użyje kanonicznego settera P02 i generatora V02.
Obecny STATUS B20 ma jeszcze historyczne IN_PROGRESS:final binding wymaga
kompletnego handoffu z HEAD. Nie zastąpiono go domysłem ani ręczną edycją.

## Prompt do ręcznego startu

> Wykonaj `FT1536_P02_FREEZE_CLOSURE_RUN_001` w repo
> `/media/footfalcon/FT1536_DATA/free_falcon_sign`. Przeczytaj AGENTS,
> START_HERE,STATE,CURRENT_P02_TASK,własne W/AGENTS i przypięty TASK.
> Zapisz model/session i sprawdź ownership oraz piny bootstrapu.
> Uzupełnij istniejący P02 o F1–F4:runner,audytowe źródła,pełne receipty/logi
> oraz jawny HEAD. Zachowaj stare frozen bajty i PARTIAL scope. Pracuj tylko
> w `proofs/ft1536/work/FT1536_P02_FREEZE_CLOSURE_RUN_001/`;finalny successor
> w `W/output/`. Wykonaj portable fresh replay i oddaj jeden frozen handoff
> z REPORT/OUTPUTS SHA,HEAD i zakończonymi jobami. RESULT.task_id ma być
> parentem P02 według TASK. Bez Git/push/uruchamiania innych modeli.

Po uzupełnieniu:V02 we własnym W → zaakceptowane stages → lokalny commit
main przez koordynatora. Dotychczasowy P02 nie został jeszcze niezależnie odebrany.
