# Zakres freeze H3_ZERO_SCALAR

Autorytatywny zbiór bajtów: OUTPUTS.sha256, ścieżki względem W. Obejmuje
wymagane dokumenty, ANALYTIC_PROOF, wynik/macierz/error ledger, AGENTS,
INPUTS/TOOLCHAIN oraz source/, inputs/, formal/, scripts/, checks/,
artifacts/ i logs/ istniejące podczas seal. Cały bootstrap pozostaje
immutable inputem. Włączone są95 matches i artifacts/fresh_replay.json.

Wyłączone: sam OUTPUTS, dynamiczny COMMANDS.log, executor.lock, tmp/,
cache/, bin/, olean/ilean/pyc. Binariów/cache nie uznaje się za replay.
artifacts/COMMANDS.frozen.log jest dokładnym prefiksem dziennika z chwili
seal; bytes/hash w command_prefix.json. Receipt seal i późniejsze checks
nie zmieniają tego prefiksu. Po freeze replay zapisuje tylko nowy DEST pod tmp.

## Finalny zakres dowodu

17 modułów (w tym6 odziedziczonych i2 audyty),97 twierdzeń:49 odziedziczonych,
48 nowych. Wszystkie aktualne Lean mają czyste logs/final i jawne axioms.
Pełne typy i termy: ZeroTypes.stdout. Standardowe propext, Classical.choice,
Quot.sound; bez sorry/admit/native_decide/lokalnych aksjomatów wniosku.

Uniwersalny SOURCE_ADD_ERROR i sharp r/delta-domain argument są **analityczne**,
oparte na source branches, kernelowych integer lemmas i exact class certificate.
Nie ogłasza się pełnego kernelowego theorem source sub error. W Lean jego
typ jest definicją SUB_*_CONTRACT, a konsument jawnie ujawnia tę przesłankę;
ANALYTIC_PROOF zamyka ją dla wszystkich NumericCenter. Nie jest to unknown E
przyjęte do końcowego wniosku lub dowód wywiedziony z finite tests.

formal/attempts/ oraz wcześniejsze logs zachowują failed elaborations,
ostrzeżenia i zastępcze sorryAx generowane przy błędach. Nie są importowane
jako końcowe moduły; nie wyciszano linterów i nie filtrowano strumieni.
Historyczne bootstrap OUTPUTS/VALIDATION zachowują swoje pierwotne bazy.

Freeze nie zmienia źródeł/guardów, nie canonicalizuje zera i nie nadaje
globalnej reachability, sampler-law lub security reduction. Git/import/commit
wykonuje prowadzący po odbiorze.
