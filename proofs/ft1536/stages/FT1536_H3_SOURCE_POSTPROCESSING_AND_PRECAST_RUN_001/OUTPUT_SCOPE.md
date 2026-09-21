# Zakres OUTPUTS i niezmiennego przekazania

scripts/scope.py wylicza dokładny zbiór wszystkich regularnych plików W,
z wyłączeniem root tmp/,bin/,cache/,COMMANDS.log,executor.lock,OUTPUTS.sha256,
oraz __pycache__ i suffixes .olean/.ilean/.pyc. Żadnych symlinków, escapes,
secrets, prywatnych keys/seedów, project binaries lub caches w zakresie.
Każdy autorytatywny member≤32MiB. source/17 files jest unchanged i manifest-pinned.

Objęte: całe bootstrap/provenance/INPUTS, instructions, source, formal source,
checkery/original slices/observer diffs, public synthetic fixtures i exact outputs,
pełne logs/failed drafts/receipts, mathematical certificates oraz raporty.
Nie filtrujemy failed logs w celu otrzymania PASS. Frozen COMMANDS prefix przed
rehearsal jest niezmienny; final freeze dodatkowo zachowuje completed final prefix
i bytes/count/hash receipt. Root dynamic tail jest poza autorytatywnym zakresem.

Rehearsal anchor jest wcześniejszym manifestem nieobejmującym samego siebie,
final REPORT/RESULT/rehearsal receipts/OUTPUTS. Dokumentuje ówczesny snapshot;
final OUTPUTS obejmuje anchor i pełne późniejsze evidence bez cyklu hashy.
Fresh semantic paths/SHA są w SEMANTIC_FILES.json, faktyczne matched rows w
artifacts/rehearsal/REPLAY_RESULT.json. Po OUTPUTS freeze zapis tylko do nowego
DEST pod tmp; pakiet traktowany RO. Nie wykonuje się importu ani Git.
