# Standardowy replay L_V_BRIDGE

Pre-freeze rehearsal: **FRESH_REPLAY_PASS**,402/402 pliki znaczeniowe identyczne.
Lista matches(path,sha256): artifacts/fresh_replay.json. Każdy członek oraz
receipt są w OUTPUTS. Kotwica rehearsal semantic_manifest.sha256:
`b1980628b73e5ec494a4f0b9d31fee894dd3151e29be587d583f219a5e2d13ae`.
Ta kotwica nie zastępuje finalnego, zewnętrznego hasha OUTPUTS.

## Po freeze

```sh
python3 -B scripts/replay.py /ABSOLUTE/COPY/tmp/new-run EXTERNAL_OUTPUTS_SHA256
```

DEST musi być nowym podkatalogiem tmp kopii roboczej. Przed jego utworzeniem
skrypt weryfikuje wymagany zewnętrzny pin, wszystkich członków OUTPUTS,
bezpieczne ścieżki i powiązanie matches z manifestem. Nie kopiuje plików
niezadeklarowanych. Zapisuje wyłącznie w DEST; checkpoint jest wejściem.

Replay odbudowuje73 moduły Lean ze źródeł, regeneruje synthetic fixtures,
obserwatora i jawne mutanty, kompiluje C normal i ASan/UBSan, wykonuje modele
Lean i dokładny oracle Sage oraz sprawdza toolchain. Nie przenosi olean,
binariów/cache. Nie otwiera historycznych ścieżek proweniencji i nie wymaga
Dokumenty/H ani poprzednich W.

Sukces: DEST/REPLAY_RESULT.json, status FRESH_REPLAY_PASS i ta sama lista402
matches. Receipts i pełne strumienie: DEST/REPLAY_COMMANDS.json, COMMANDS.log,
artifacts/*receipts*, logs/ i checks/logs/. Czas/cwd/logi wykonawcze są
przechowywane osobno, nie porównuje się ich jako deterministycznych danych.

Lean uruchamiany jest z -j1 -M2048 i RLIMIT_AS8GiB. Tylko oddzielne joby C
ASan nie mają limitu virtual address space, aby móc zarezerwować shadow;
wall/CPU pozostają skończone. Kontroler replay nie może dziedziczyć twardego
8GiB limitu obejmującego również ASan. Każdy zwykły child runner narzuca
własne8GiB, a sanitizer uruchamia się osobno z FT1536_ASAN=1. To nie zmienia
granicy zapisu. Odpowiednią konfigurację stosuje scripts/replay.py.

## Rehearsal i historia

Przed freeze użyto jawnego `--rehearsal W/tmp/rehearsal_002`; zewnętrzny
controller miał konfigurację pozwalającą zarezerwować ASan shadow, a zwykłe
joby wewnętrzne wymuszały FT1536_ASAN=0 i8GiB. Żadne proof assumptions ani
źródła kandydata nie zostały w tym celu zmienione.

Pierwszy seed001 odbudował kernel, lecz audit wykrył brak provenance-only
scripts/archive_attempt.py. Dodano do kopiowania brakujące odziedziczone
helpers i wykonano całkowicie nowy seed002. Błąd pakowania nie był błędem
matematycznym. Pełne1092 pliki strumieni/receipts obu prób zachowano pod
artifacts/rehearsal/ i artifacts/attempts/rehearsal_001; wykaz w replay_evidence.json.

Rehearsal nie jest dostępny, gdy OUTPUTS już istnieje. Nie ma cyklu hashy:
matches nie zawiera samego receipt ani REPORT/RESULT/OUTPUTS. Późniejszy
standardowy replay wymaga finalnego pinu i pozostawia wynik tylko w DEST.
Protokół jest zgodny z archiwizatorem repo `--replay standard`.
