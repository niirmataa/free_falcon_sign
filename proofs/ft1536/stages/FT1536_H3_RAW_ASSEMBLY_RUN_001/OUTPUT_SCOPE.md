# Autorytatywny zakres RAW_ASSEMBLY

OUTPUTS.sha256 wraz z przekazanym zewnętrznym hashem obejmuje dokładne
regularne pliki wybrane przez scripts/package_scope.py. Manifest nie
obejmuje siebie. Każdy członek ma bezpieczną ścieżkę i≤32MiB; symlinki,
cache/obiekty kompilacji i nieoczekiwane pliki w tym zakresie są odrzucane.

Włączone: wszystkie wymagane dokumenty/JSON, pełne source17 files,
inputs/bootstrap/context/provenance i odtworzony publiczny previous header,
formalne źródła, scripts, C slice/observer, publiczne synthetic fixtures,
expected/intermediate/actual words i traces, LEAF_MAP, preprocessed source,
pełne command/kernel logs, próby nieudane, numerical certificates, piny/diffy
reuse oraz rehearsal receipts i jego niezależna kotwica.

Publiczne .bin zawierają wyłącznie syntetyczne Word64 outputs/mutants;
nie są private keys/seeds. Rehearsal stdout/stderr będące semantic matches
mają te same przypięte bajty pod głównymi relative paths (np.checks/logs).
Ich nowe command receipts są w artifacts/rehearsal; nie wymagają drugiej
kopii identycznych streams. Unikalne/dynamiczne replay logs także zachowano.

Wyłączone korzenie: tmp/,bin/,cache/,executor.lock,dynamiczny COMMANDS.log
i sam OUTPUTS.sha256; dodatkowo robocze formal/*.olean/*.ilean. Brak .o/.pyc
w archiwum. scripts/verify.py porównuje manifest z exact authoritative set.

artifacts/COMMANDS.frozen.log jest dokładnym prefiksem zakończonych poleceń.
commands_prefix.json przypina jego bytes/count/SHA. Root COMMANDS istnieje
jako dziennik roboczy; importer może odtworzyć go z tego prefiksu. Finalizacja
i post-freeze replay mają pełne nowe receipts tylko w tmp/final_*; nie
dopisują plików do zapieczętowanego zakresu.

SEMANTIC_FILES.json określa195 odtwarzanych path/SHA, bez cwd/elapsed/timestamps.
Wszystkie są członkami finalnego OUTPUTS. Rehearsal anchor powstał wcześniej
i nie obejmuje siebie, wyniku replayu, finalnego REPORT/RESULT/OUTPUTS.
To usuwa hash cycle. Finalne external REPORT/OUTPUTS piny podaje handoff.
Historyczne archiwa i ich OUTPUTS zachowują swoje wcześniejsze bazy/statusy.
