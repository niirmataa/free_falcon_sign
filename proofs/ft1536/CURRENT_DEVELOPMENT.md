# T12.1 — przygotowane nowe miejsce małych commitów

Docelowy katalog: [development/T12_1](development/T12_1/README.md).
Statusy są osobne dla komponentów. `source3` ma obecnie
**RECONCILED_AWAITING_WORKER_ACK**: zakończony STABLE_BINARY_004 i wszystkie
pięć późniejszych dopisków skopiowano z pinami. Przejęcie potwierdza ta sama
sesja **GPT-6 Astra** (`ses_f12636605ffeL1FZg4teLUwUf5`), następnie zapisuje
ACTIVE dla source3 i podłącza nowy runtime. `run2` i `t5` pozostają
PREPARED_HANDOFF. [Receipt i przekazanie indeksu](development/T12_1/source3/HANDOFF.md).
Ta wskazówka nie uruchamia wykonawcy ani nie nadaje statusu REVIEWED.

Właściciel2026-09-30 polecił: małe zwykłe commity i bieżący GitHub,
potem osobny commit/tag stages; nowy katalog; tylko nowości względem stages;
zachowanie bezpieczeństwa pracy aktywnego agenta. Wybrał „Przenieść nowości”.
Szczegóły: [WORK_COMMITS](../../docs/onboarding/WORK_COMMITS.md).

**Zatwierdzenie właściciela2026-09-30:** małe commity i push wykonuje worker
po uzgodnieniu z nim. Koordynator prowadzi odbiór oraz import/commit/tag stages.
Nowy katalog jest zatwierdzony; przekazanie pracującej sesji następuje po jej
kroku. Po przejęciu zgoda zastępuje dawne „bez Git” dla źródeł development.
