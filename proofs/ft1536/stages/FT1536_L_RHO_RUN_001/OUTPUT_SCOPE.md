# Zakres finalnego OUTPUTS.sha256

Baza wszystkich wpisów: katalog W zawierający manifest. Wpisy są względne,
bez `..` i symlinków. Manifest nie obejmuje samego siebie; jego digest jest
przekazywany na zewnątrz.

Objęte są REPORT.md, RESULT.json, REPLAY.md, OUTPUT_SCOPE.md, TOOLCHAIN.txt,
INPUTS.sha256, CANDIDATE.sha256 i candidate.patch, a także regularne pliki
reference/, candidate/, inputs/, scripts/, formal/, mutants/, observed/,
fixtures/ i artifacts/ (bez .pyc, __pycache__ i plików blokad).

W szczególności objęte są pełne tablice scalar CSV, faktyczne wyniki Verify,
checker Sage, sprawdzony certyfikat Lean, source/model bindingi, kopie
skonsumowanych wejść i receipts. Początkowy nieudany szkic Lean zachowuje się
wyłącznie jako historia; jego obecność nie oznacza pozytywnego werdyktu.

COMMANDS.log pozostaje append-only. Freeze tworzy dokładną kopię swojego
dotychczasowego prefiksu jako artifacts/COMMANDS.frozen.log oraz opis długości
i hashu w artifacts/COMMANDS.frozen.json. Oba pliki i wszystkie wskazane w
tym prefiksie strumienie stdout/stderr są objęte OUTPUTS.

Jawnie wyłączone są:

- bieżący, rosnący COMMANDS.log i późniejszy ogon logs niewskazany przez snapshot;
- bin/, cache/ i tmp/, w tym robocza kopia świeżego replayu;
- *.lock, __pycache__, *.pyc;
- OUTPUTS.sha256.

Trwały receipt i logi wykonanej świeżej kopii są archiwizowane w artifacts/.
Hashe binariów, flagi i source bindingi są w objętych receipts; replay
odbudowuje ELF i nie ufa samemu istniejącemu binarium. Debug ELF może się
różnić z powodu cwd. Kopie źródeł i deterministyczne pliki znaczeniowe muszą
zachować hashe. Tworzenie manifestu i późniejsze kontrole mogą dopisać swoje
receipts poza zamrożonym prefiksem, bez przepisywania wcześniejszych rekordów.
