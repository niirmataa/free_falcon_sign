# Exact output scope INITIAL_TARGETS

Autorytatywne są OUTPUTS.sha256 i przekazany external SHA. Manifest nie
obejmuje siebie; każdy członek jest regularny, ma bezpieczną relative path
i≤32MiB. scripts/package_scope.py wyznacza dokładny zbiór; verify odrzuca
symlinki/unexpected files/caches w autorytatywnym zakresie.

Włączone: wszystkie wymagane documents/JSON/certificate/ledger, TASK/AGENTS/
INPUTS/TOOLCHAIN, pełne17 source files, bootstrap/context/provenance,
odtworzony publiczny previous header, formal/checker/harness/slice sources,
diffs/preprocessing, pełne publiczne inputs/snapshots/traces/oracles/mutations,
kernel logs/types/terms/axioms i failed attempts. Publiczne .bin zawierają
wyłącznie synthetic target words, nie keys/seeds; membership jawnie opisano.

Wyłączone korzenie: tmp/,bin/,cache/,executor.lock,dynamiczny COMMANDS.log
i OUTPUTS.sha256; dodatkowo robocze formal/*.olean/*.ilean. Nie ma .o/.pyc
w archiwum. artifacts/COMMANDS.frozen.log to exact completed prefix dziennika,
przypięty przez commands_prefix.json(bytes/count/SHA). Importer może z niego
odtworzyć roboczy COMMANDS. Finalizacja i post-freeze standard mają własne
pełne argv/limits/exit/streams tylko w nowych tmp/final_* destinations.

SEMANTIC_FILES ma219 odtwarzanych path/SHA, bez cwd/elapsed/timestamps;
wszystkie należą do OUTPUTS. Rehearsal streams będące matches są identyczne
z głównymi relative paths (np.checks/logs), więc nie wymagają drugiej kopii;
nowe command receipts i unikalne/dynamiczne logs są w artifacts/rehearsal.

Kotwica rehearsal predatuje jego wynik/finalny raport i nie zawiera siebie,
co usuwa hash cycle. REPORT/OUTPUTS piny podaje zewnętrzny handoff. Po freeze
nie dopisuje się do pakietu. Historyczne INPUTS/OUTPUTS zachowują swoje bazy.
