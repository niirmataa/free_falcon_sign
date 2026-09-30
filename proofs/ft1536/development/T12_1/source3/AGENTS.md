# T12.1 / source3 — aktualne zasady wykonawcy

Wykonawca: **GPT-6 Astra / openai/gpt-6-astra**, ta sama sesja
`ses_f12636605ffeL1FZg4teLUwUf5`. Historyczne etykiety Sol w `notes/`
i starych receiptach pozostają proweniencją, nie aktualnym przydziałem.

Przeczytaj `../README.md`, `HANDOFF.md`, AGENTS repo i development oraz
`docs/onboarding/WORK_COMMITS.md`. Status przy przygotowaniu:
**RECONCILED_AWAITING_WORKER_ACK**; nie ogłaszaj ACTIVE przed własnym
potwierdzeniem przejęcia i sprawdzeniem pinów rozliczenia.

Docelowe źródła: `proofs/ft1536/development/T12_1/source3/`.
Następny uzgodniony podetap: **STABLE_TOP_001**, kontynuacja ROADMAP T12.1.
Instrukcje i raporty w `notes/` oraz skrypty `tools/original/` są historyczne.
Zaktualizuj rzeczywiste source/runtime paths runnera przed użyciem.

Po handoffie sam wykonujesz małe commity i bieżący push własnych źródeł
na `main`, po uzgodnieniu kroku z właścicielem i dostępu do indeksu z
koordynatorem. Ta decyzja zastępuje stare „bez Git” dla development.
Jeden writer naraz; dokładne pathspecs, zachowanie obcego stagingu i zmian;
bez amend, force-push i pomijania hooks. Nie commituj starego `work/`.

HOME/TMPDIR/cache, produkty i logi jobów w ignorowanym trwałym `.build/`
komponentu albo uzgodnionym runtime W. Małe źródła są śledzone normalnie;
duże wyniki przez generator, pin i trwałą lokalizację. Archiwalne zależności
przez `ARCHIVED_DEPENDENCIES.json`; frozen i dawne W pozostają read-only.

Lean4.34.0/Mathlib z przypiętej closure; Sage ze standardowym preparserem,
ZZ/QQ i rygorystyczne przedziały. Jedno obliczenie naraz z kontrolą tła,
dotychczasowe limity i czyste logi. Bez nowych sesji/subagentów/relay,
zmian produkcyjnego C i samodzielnego nadawania REVIEWED.

STABLE_BINARY_004: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Recenzję wykonuje
osobno wybrany niezależny model; koordynator prowadzi import, commit/tag stages.
