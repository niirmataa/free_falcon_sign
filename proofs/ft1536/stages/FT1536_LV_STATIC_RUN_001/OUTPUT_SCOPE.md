# Baza i zakres OUTPUTS.sha256

Bazą ścieżek jest katalog W zawierający ten plik. Wszystkie wpisy manifestu
są względnymi ścieżkami do zwykłych plików, bez symlinków. Manifest nie
obejmuje samego siebie; jego SHA-256 jest przekazywany na zewnątrz.

Manifest obejmuje:

- REPORT.md, RESULT.json, REPLAY.md, OUTPUT_SCOPE.md, TOOLCHAIN.txt, INPUTS.sha256;
- wszystkie regularne pliki `reference/`, `inputs/`, `scripts/`, `formal/`,
  `artifacts/` oraz `resume_001/`, z poniższymi wyłączeniami;
- konkretne stdout/stderr wskazane przez snapshot dziennika, zapisane w logs.

## Dziennik append-only

`COMMANDS.log` pozostaje plikiem append-only. Zamiast wymagać stałości całego
rosnącego pliku, freeze zapisuje jego dokładny niezmienny prefiks jako
`artifacts/COMMANDS.frozen.log` i opis długości/hashu w
`artifacts/COMMANDS.frozen.json`. Te dwa pliki są objęte OUTPUTS.

Wszystkie stdout/stderr wskazane przez ten snapshot są objęte manifestem.
Wyjątkiem nie jest „pusty log”: przerwane wykonanie pierwszego Lean ma jawne
null/unavailable i osobny opis timeoutu; nie istnieje odzyskany strumień,
który można by zahashować.

Receipt samego tworzenia manifestu oraz przyszłe odczytowe kontrole/replaye
mogą zostać dopisane do żywego COMMANDS/logs po tym prefiksie. Nie wchodzą
automatycznie do zamrożonego zbioru. Ich istnienie nie zmienia hashy plików
matematycznych ani nie wymaga przepisania manifestu. Końcowy check musi
potwierdzić, że żywy COMMANDS zaczyna się dokładnie zapisanym prefiksem.

## Jawne wyłączenia

- główny `COMMANDS.log` jako rosnący plik (jego zamrożona kopia jest objęta);
- `cache/` i `tmp/`, w tym robocza kopia replayu; trwały receipt i kopie
  strumieni zakończonego replayu są w objętym `artifacts/`;
- bieżące `bin/` oraz zachowane `resume_001/snapshot/bin/`; hashe binariów
  i ich source/build bindingi znajdują się w objętych receipts/inwentarzach;
- pliki blokad `*.lock`, `__pycache__` i `.pyc`;
- późniejszy ogon logs, którego nie wskazuje snapshot;
- OUTPUTS.sha256.

Skompilowane binaria nie są autonomicznym źródłem prawdy. Replay odbudowuje
je z hash-sprawdzonych źródeł. Wariant z debug information może różnić się
bajtowo przy innym cwd; deterministyczne pliki matematyczne muszą pozostać
identyczne. Obecność zachowanej nieukończonej próby Lean w formal/ nie nadaje
jej statusu dowodu: RESULT i REPORT wskazują wyłącznie WitnessBlocks.lean
jako sprawdzony certyfikat.
