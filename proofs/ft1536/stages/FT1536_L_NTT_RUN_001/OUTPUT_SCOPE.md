# Baza i zakres OUTPUTS.sha256

Baza: W zawierający ten manifest. Wpisy są względnymi ścieżkami do zwykłych
plików, bez symlinków i `..`. Manifest nie obejmuje samego siebie.
Jego digest jest przekazywany na zewnątrz.

Objęte są REPORT.md, RESULT.json, CLAIM.md, DERIVATION.md, OBLIGATIONS.json,
REPLAY.md, OUTPUT_SCOPE.md, INPUTS.sha256, TOOLCHAIN.txt, a także regularne
pliki source/, inputs/, scripts/, formal/, observed/, mutants/, fixtures/
i artifacts/, z pominięciem .pyc, __pycache__ i *.lock.

Freeze kopiuje dotychczasowy COMMANDS.log do artifacts/COMMANDS.frozen.log
i zapisuje długość oraz hash w artifacts/COMMANDS.frozen.json. Te pliki i
wszystkie stdout/stderr wskazane w tym prefiksie wchodzą do manifestu.
Główny COMMANDS pozostaje append-only; receipt samego freeze i późniejsze
odczytowe kontrole mogą dopisać jawny, nieobjęty prefiksem ogon.

Jawne wyłączenia: bin/, cache/, tmp/ (w tym robocze kopie replayu), główny
rosnący COMMANDS.log, późniejsze strumienie logs niewskazane w snapshot,
pliki blokad, __pycache__, .pyc oraz OUTPUTS.sha256. Hashe binariów i
build/source bindingi są w objętych receipts; binaria są odbudowywane.

Trwały receipt i strumienie udanej świeżej kopii są archiwizowane pod
artifacts/. Binaria z debug information mogą zależeć od cwd. Pliki
znaczeniowe porównuje się bajtowo. Obecność zachowanych nieudanych szkiców
w formal/attempts nie oznacza ich konsumpcji: właściwe moduły końcowe
i ich zakres wskazują RESULT oraz audit.

Manifest obejmuje także opisane luki. Integralność lub udany replay nie
promuje `PARTIAL_PROOF` do dodatniego werdyktu L_NTT.
