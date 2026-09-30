# T12.1 / source3 — aktualne zasady wykonawcy

Wykonawca: **GPT-6 Astra / openai/gpt-6-astra**, ta sama sesja
`ses_f12636605ffeL1FZg4teLUwUf5`. Historyczne etykiety Sol w `notes/`
i starych receiptach pozostają proweniencją, nie aktualnym przydziałem.

Przeczytaj `../README.md`, `HANDOFF.md`, AGENTS repo i development oraz
`docs/onboarding/WORK_COMMITS.md`. Status: **ACTIVE** po potwierdzeniu
przejęcia przez tę samą sesję i sprawdzeniu5/5 kopii według receiptu
`d6e460b94b858dfbb65bb2d6c725a477d932e3fcbfeb9903bc4ea36524518eb2`.

Docelowe źródła: `proofs/ft1536/development/T12_1/source3/`.
Bieżący uzgodniony podetap: **CERTIFICATE_SUFFIX_001**, kontynuacja ROADMAP T12.1.
Właściciel wyjaśnił sprzeczność w TASK odpowiedzią **„Trzy commity i push”**:
po trzech logicznych commitach podetapu wykonaj push origin/main. To jawny
sygnał dla tej sekwencji; wcześniejsze raporty/piny pozostają niezmienione.
Dalsza migracja/scalanie SOURCE_MAP i duplikatów czeka do końca wszystkich
omawianych prac T12.1; pracujemy nadal w tym source3.
Instrukcje i raporty w `notes/` oraz skrypty `tools/original/` są historyczne.
Zaktualizuj rzeczywiste source/runtime paths runnera przed użyciem.

Po handoffie sam wykonujesz małe lokalne commity własnych źródeł na `main`,
po uzgodnieniu kroku z właścicielem i dostępu do indeksu z koordynatorem.
**Późniejsze polecenie właściciela: push dopiero po jego jawnym sygnale.**
Ta decyzja zastępuje wcześniejszą zgodę na bieżący push w tym TASK.
Małe commity zastępują stare „bez Git” dla development.
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
