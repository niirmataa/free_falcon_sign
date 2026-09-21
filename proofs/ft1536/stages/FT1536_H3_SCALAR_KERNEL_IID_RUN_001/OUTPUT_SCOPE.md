# Zakres OUTPUTS

scripts/scope.py obejmuje wszystkie regularne pliki W poza root tmp/,bin/,cache/,
COMMANDS.log,executor.lock,OUTPUTS.sha256 oraz __pycache__/.olean/.ilean/.pyc.
Odrzuca symlinki i member>32MiB. Publiczne byte/refill fixtures są częścią
matematycznych wejść; brak keys/seeds/private extraction/credentials/binaries.
Pełne bootstrap/provenance/TASK/instrukcje,source/formal/checkers,expected/native
outputs,logs,failed attempts,certificates i docs są objęte manifestem.

COMMANDS.frozen.log zachowuje completed prefix sprzed rehearsal anchor,
final freeze dodaje completed final prefix z bytes/count/hash receipt.
Root dynamic COMMANDS tail jest poza authoritative scope. Nie usuwa się
failed logs lub warnings z historii, final clean logs są osobną kopią audytową.

Rehearsal anchor poprzedza sam anchor/fresh_replay/REPORT/RESULT/OUTPUTS, więc
nie ma cyklu. Sealed artifacts/fresh_replay.json ma status FRESH_REPLAY_PASS
i niepuste matches[{path,sha256}] z faktycznego fresh rebuild. Fresh child
REPLAY_RESULT.json ma ten sam format. SEMANTIC_FILES wylicza wszystkie
regenerowane outputs; receipt potwierdza każdą ścieżkę i hash.

Po freeze zapis tylko do nowego DEST pod tmp. Source17 files nie zmienione;
source_changed=false,production_source_changed=false,new_source_patch_integrated=false,
owner_accepted=false. Pakiet jest dowodem w IID_BUFFER, nie real-PRNG acceptance
ani integracją C. Import/commit pozostaje zadaniem prowadzącego.
