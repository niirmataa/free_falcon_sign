# T12.1 — przygotowane nowe miejsce małych commitów

**MIGRATION_HOLD — decyzja właściciela2026-09-30 po raporcie SOURCE_MAP.**
Dalsze przenosiny, uzupełnianie migracji i porządkowanie duplikatów nastąpią
dopiero po zakończeniu wszystkich omawianych prac. Bieżąca praca toczy się
w już potwierdzonych katalogach. Poniższe statusy komponentów pozostają
opisem ich pracy; samo zakończenie kroku nie jest zgodą na kolejną migrację.

Docelowy katalog: [development/T12_1](development/T12_1/README.md).
Statusy są osobne dla komponentów. `source3` ma obecnie **ACTIVE**:
GPT-6 Astra (`openai/gpt-6-astra`), ta sama sesja
`ses_f12636605ffeL1FZg4teLUwUf5`, potwierdziła5/5 kopii i receipt handoffu
`d6e460b94b858dfbb65bb2d6c725a477d932e3fcbfeb9903bc4ea36524518eb2`.
Bieżący krok: **STABLE_TOP_001**; źródła `source3/formal`, `sage`, `tools`,
runtime `source3/.build/`. Żywy stan: [source3/WORK_STATE.md](development/T12_1/source3/WORK_STATE.md).
`run2` i `t5` pozostają
PREPARED_HANDOFF. [Receipt i przekazanie indeksu](development/T12_1/source3/HANDOFF.md).
Ta wskazówka nie uruchamia wykonawcy ani nie nadaje statusu REVIEWED.

Właściciel2026-09-30 polecił: małe zwykłe commity i bieżący GitHub,
potem osobny commit/tag stages; nowy katalog; tylko nowości względem stages;
zachowanie bezpieczeństwa pracy aktywnego agenta. Wybrał „Przenieść nowości”.
Szczegóły: [WORK_COMMITS](../../docs/onboarding/WORK_COMMITS.md).

**Zatwierdzenie właściciela2026-09-30:** małe commity i push wykonuje worker
po uzgodnieniu z nim. Koordynator prowadzi odbiór oraz import/commit/tag stages.
Nowy katalog jest zatwierdzony; kolejne przekazanie czeka do zakończenia
wszystkich omawianych prac, zgodnie z MIGRATION_HOLD powyżej.
Po przejęciu zgoda zastępuje dawne „bez Git” dla źródeł development.
