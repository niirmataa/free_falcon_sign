# Autorytatywny scope ORDERED_REACH

OUTPUTS.sha256 z external pinem w handoffie obejmuje dokładny zestaw regularnych
files według package_scope.py. Manifest nie zawiera siebie; każdy member ma
bezpieczną relative path i≤32MiB. Symlinki/unexpected files/cache są odrzucane.

Włączone: wymagane documents/typed partial certificate/ledger, TASK/AGENTS/
INPUTS/TOOLCHAIN, pełne17 source files, bootstrap/context/provenance/slices,
formal sources, code/harness/diffs/preprocessing, full public response tapes,
word snapshots/scalar inputs/oracles/expected/actual traces i outcomes,
mutation states, kernel types/terms/axioms i failed attempts/full receipts.
.bin to wyłącznie synthetic memory snapshots, nie klucze/secrets. Tapes są
jawnymi test data i nie mają emitted/PRNG distribution membership claim.

Wyłączone root entries: tmp/,bin/,cache/,executor.lock,dynamiczny COMMANDS.log,
sam OUTPUTS.sha256; ponadto robocze formal/*.olean/*.ilean. Nie ma .o/.pyc
w archiwum. artifacts/COMMANDS.frozen.log to dokładny completed prefix;
commands_prefix.json ma bytes/count/SHA. Importer może przywrócić dziennik
roboczy z tego prefiksu. Seal/post-freeze replay mają własne pełne receipts
tylko w nowych tmp/final_* destinations, bez dopisywania do pakietu.

SEMANTIC_FILES.json określa225 deterministycznych path/SHA. Dynamiczne cwd,
elapsed i timestamps nie są semantic matches. Nowe rehearsal receipts są
w artifacts/rehearsal, a bytes odpowiadające matches są już pod głównymi
ścieżkami; unikalne streams skopiowano. Kotwica rehearsal predatuje wynik/
raport/OUTPUTS i nie zawiera siebie: brak hash cycle. Historyczne projections
zachowują własne OUTPUTS bazy/statusy. Replay integrity PASS zachowuje
mathematical status PARTIAL_PROOF.
