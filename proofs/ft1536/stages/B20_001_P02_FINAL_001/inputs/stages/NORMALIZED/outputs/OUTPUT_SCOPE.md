# Autorytatywny zakres STABLE_NORMALIZATION

OUTPUTS.sha256 wraz z zewnętrznym pinem przekazanym w handoffie obejmuje
dokładny zestaw regularnych plików scripts/package_scope.py. Manifest nie
obejmuje siebie. Członkowie mają bezpieczne relative paths i≤32MiB;
symlinki, nieoczekiwane pliki oraz przypadkowy compiled/cache material są
odrzucane przez scope/verify.

Włączone: wymagane dokumenty/JSON/certificate, TASK/AGENTS/INPUTS/TOOLCHAIN,
pełne candidate source17 files, publiczne bootstrap/context/provenance,
formalne źródła, checkers/harness/slices/diffs/preprocessing, scalar i pełne
pipeline inputs/expected/actual words/traces, oracles/mutations, clean kernel
types/terms/axioms i wszystkie failed attempts/full receipts.

Publiczne .bin są wyłącznie synthetic stable/sk/mutant outputs, nie klucze
lub private seeds. Nie przypisano im P_key/emitted membership. Rehearsal
streams będące semantic matches mają te same przypięte bajty pod głównymi
relative paths (np.checks/logs); nowe command receipts wskazują ich hashe.
Unikalne/dynamiczne logs zachowano w artifacts/rehearsal.

Wyłączone korzenie: tmp/,bin/,cache/,executor.lock,dynamiczny COMMANDS.log
i OUTPUTS.sha256; dodatkowo formal/*.olean/*.ilean. Nie ma .o/.pyc w scope.
artifacts/COMMANDS.frozen.log to dokładny completed prefix dziennika;
commands_prefix.json podaje bytes/count/SHA. Importer może z niego odtworzyć
roboczy COMMANDS. Finalizacja/post-freeze replay mają własne argv/limits/
exit/stdout/stderr tylko w nowych tmp/final_* destinations i nie dopisują
do archiwum.

SEMANTIC_FILES zawiera262 odtwarzane path/SHA bez cwd/elapsed/timestamps.
Wszystkie są członkami finalnego OUTPUTS. Rehearsal anchor powstał przed
jego wynikiem/finalnym raportem i nie zawiera siebie lub późniejszych
receipts: brak hash cycle. Historyczne projekcje/OUTPUTS zachowują swoje
bazy/statusy. REPORT/OUTPUTS piny końcowe są podane zewnętrznie.
