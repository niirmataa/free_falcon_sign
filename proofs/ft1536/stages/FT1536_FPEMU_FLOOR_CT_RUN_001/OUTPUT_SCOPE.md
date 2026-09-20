# Zakres zamrożonego pakietu FLOOR_CT

Autorytatywny zakres określa `OUTPUTS.sha256`, którego zewnętrzny SHA-256
jest podany przy przekazaniu. Manifest nie zawiera siebie. Każdy członek
jest regularnym plikiem, ma bezpieczną relatywną ścieżkę i najwyżej32MiB.
`scripts/package_scope.py` definiuje sprawdzany dokładny zestaw; `verify.py`
odrzuca nieprzypięte pliki w tym zakresie, symlinki i przypadkowy cache.

Włączone:
- TASK/AGENTS, REPORT/RESULT/CLAIM, PATCH i wszystkie wymagane dokumenty;
- INPUTS, kopie bootstrap/context/provenance/source slices i TOOLCHAIN;
- pełne17-file baseline/source i candidate/source, nowy CANDIDATE manifest;
- formalne źródła, scripts/checks, deterministyczne syntetyczne corpora
  i wyniki.bin (publiczne Word64, nie klucze lub seedy projektu);
- vendor/harness z licencją i pinami, .s/.i/.d/disassembly/object hash receipts;
- wszystkie logs/artifacts, próby nieudane, pełne kernel types/terms/axioms;
- TIMING_PLAN/TIMING_REPORT i cały timing/: run/receipts/public orders,
  machine snapshots, stdout/stderr oraz lossless raw parts i STREAMS.json;
- pełne42 raw recalculations, świeży rehearsal z jego pełnymi streams,
  artifacts/fresh_replay.json i osobna pre-freeze kotwica;
- SEMANTIC_FILES:235 deterministycznych path/SHA, niezależnych od runtime,
  cwd i command timestamps. To sprawdzane outputs, nie lista cache objects.

Wyłączone na poziomie korzenia: tmp/, bin/, cache/, executor.lock,
dynamiczny COMMANDS.log i sam OUTPUTS.sha256. Dodatkowo robocze .olean/.ilean
w formal/. Brak .o/.pyc/private danych w autorytatywnym zakresie. Archiwalne
podkatalogi artifacts/rehearsal/tmp zawierają publiczne replay receipts,
nie roboczy cache; nie są objęte wyłączeniem korzeniowego tmp/.

`artifacts/COMMANDS.frozen.log` jest dokładnym prefiksem zakończonych poleceń
z root COMMANDS.log. `artifacts/commands_prefix.json` zapisuje bytes/count/SHA.
Jest to sposób zachowania dziennika bez dopisywania do zapieczętowanych
bajtów. Finalizacja i kontrola po freeze mają własne kompletne argv/limits/
stdout/stderr/exit receipts tylko w nowych tmp/final_* destinations; nie
stanowią dopisywanych członków archiwum. Importer może przywrócić COMMANDS
z zamrożonego prefiksu. Kopie niesplitowanych streamów w tmp są zbędnymi
roboczymi kopiami dokładnych bajtów już reprezentowanych w parts.

Nie ma hash cycle: rehearsal_inputs powstał przed wynikiem rehearsal i
finalnym raportem; nie zawiera siebie ani późniejszych receipts. REPORT/
RESULT opisują ukończony rehearsal. Finalne REPORT/OUTPUTS hashe podaje
handoff. Nowy standard replay czyta finalny pin i zapisuje tylko nowy DEST.
Historycznych pakietów, ich pinów i zewnętrznej night inventory nie zmieniono.
