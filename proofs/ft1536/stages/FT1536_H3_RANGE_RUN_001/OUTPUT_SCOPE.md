# Zakres freeze H3_RANGE

OUTPUTS.sha256 zawiera autorytatywny zbiór plików względnych wobec W:
dokumenty główne, wynik i macierz, ledger, INPUTS, TOOLCHAIN, lokalny AGENTS,
source/, inputs/ (w tym cały immutable bootstrap), formal/, scripts/,
checks/, artifacts/ i logs/ istniejące podczas seal. Wszystkie96 matches
i artifacts/fresh_replay.json są członkami manifestu.

Wyłączone: sam OUTPUTS, dynamiczny COMMANDS.log, executor.lock, tmp/, cache/,
bin/, olean/ilean/pyc. Binariów/cache nie używa się jako dowodu. Rehearsal
receipts/strumienie skopiowano do artifacts. Późniejszy standardowy replay
pisze wyłącznie do nowego DEST pod tmp i nie przepisuje pakietu.

artifacts/COMMANDS.frozen.log jest dokładnym prefiksem nadrzędnego dziennika
z chwili seal; bytes/hash określa command_prefix.json. Receipt samego seal
i późniejszych kontroli odczytowych leży poza tym prefiksem.

Finalny zakres kernelowy:6 modułów dowodu + Audit/Types,49 twierdzeń;
aktualne hashe w artifacts/formal_audit.json, czyste pełne logs/final/.
Standardowe aksjomaty: propext, Classical.choice, Quot.sound. Pełne typy
ujawniają C_mu, NotNegZero i inne lokalne przesłanki. Nie ma finalnego
globalnego H3 theorem z ukrytą przesłanką range.

formal/attempts/, scripts/attempts/, artifacts/attempts/ i wcześniejsze logi
są zachowaną historią. Mogą zawierać failed elaboration/errors/warnings lub
generowane przez Lean zastępcze sorryAx; nie są konsumowane jako final proof.
Nie wyciszano linterów ani nie filtrowano strumieni, by uzyskać clean log.

REACHABILITY jest definicją operacyjnej domeny C i opisem source projection,
nie dowodem kompletnego C interpreter/compiler refinement. Syntetyczne
modele/diagnostyki w checks nie są keys, Sign traces z sekretem ani świadkami
przynależności do required support. Historyczne bootstrap OUTPUTS to
proweniencja z pierwotnymi bazami, nie pełny nowy eksport dawnych pakietów.
