# Immutable scope i regenerated semantic scope

scripts/scope.py enumeruje WSZYSTKIE regular files pakietu z wyłączeniem
root tmp/,runtime/,cache/,bin/,executor.lock,COMMANDS.log,OUTPUTS.sha256,
__pycache__ oraz formal build .olean/.ilean/.trace. Symlinks i member>32MiB
są odrzucane. Cache/binaries/ephemeral runtime nie stanowią certyfikatu.
Inputs/source/formal source/checks/scripts/docs/logs/failed attempts/
provenance są w manifestcie. Public scripted arrays są synthetic input data,
nie prywatnymi keys/seeds. Żadnych sekretów nie generowano.

Root COMMANDS.log jest dynamicznym dziennikiem workerów. Completed prefixes
są snapshotowane do artifacts/COMMANDS.rehearsal.log przed anchor i do
artifacts/COMMANDS.frozen.log przy freeze; ich receipts/hashes są immutable.
Jest zachowany również historyczny timeout i source snapshot. odmowy flock
przed rozpoczęciem run.py mają osobną jawną notę w FAILED_ROUTES.

Rehearsal anchor obejmuje ówczesny scope BEZ samego siebie i bez nieistniejących
jeszcze REPORT/RESULT/fresh-replay receipt. Po rzeczywistym replayu dodaje się
receipt, report i result, a końcowy OUTPUTS obejmuje także anchor. Unika to
hash cycle. Po freeze nie zmienia się authoritative members; jedyny nowy
zapis to ABSENT_DEST pod wyłączonym tmp/ lub odrębny durable replay-work.

SEMANTIC_FILES.json to osobna lista rzeczywiście regenerowanych path/SHA
matches: exact certificates/model artifacts, generated control slices,
native outputs, clean final Lean logs/types/audit i mutation outcomes.
Runtime timestamps/cwd/elapsed, build binaries, assertion stderr z path,
historyczne failures i tekst analitycznych proofów nie są udawane jako
path-independent computed outputs; nadal są pinned full OUTPUTS members.

Fresh seed: inputs/,source/,scripts/, selected formal *.lean (BEZ generated
RetryAudit/RetryTypes), bazowe checks/retry.c i reset.c, top-level proof *.md
bez REPORT, INPUTS.sha256 i artifacts/reuse.json jako provenance mapping.
Żadne expected fixture, native output, numerical certificate, log, .olean,
project cache lub bin nie jest seedem. Exact seed list jest w nowym DEST.
Przepis regeneruje audit modules, expected models, compiler outputs i
semantic certificates, a dopiero potem porównuje hashe do package manifestu.
