# Odtwarzanie z archiwum — protokół standardowy

Wynik pre-freeze rehearsal: **FRESH_REPLAY_PASS**, 217/217 plików znaczeniowych
bajtowo identycznych. `artifacts/fresh_replay.json` zawiera autorytatywną listę
`matches`: względne `path` i `sha256`. Wszystkie te pliki wchodzą do OUTPUTS.

## Interfejs po freeze

Ze świeżej kopii pakietu, mającej zarchiwizowane pliki i przypięty toolchain:

```sh
python3 -B scripts/replay.py /ABSOLUTE/COPY/tmp/new-run EXTERNALLY_GIVEN_OUTPUTS_SHA256
```

DEST musi być nieistniejącym podkatalogiem tmp tej kopii. Drugi argument jest
OBOWIĄZKOWYM zewnętrznym pinem całego OUTPUTS.sha256. Przed utworzeniem DEST
skrypt sprawdza pin, wszystkie członki manifestu i powiązanie listy matches
z tym manifestem. Odrzuca ucieczki ścieżek, symlinki, duplikaty i zmienione bajty.
Nie kopiuje niezadeklarowanych wejść. Standardowy replay zapisuje tylko w DEST.

Nowy seed zawiera lokalne, przypięte źródła i kopie wejść. Nie zawiera olean,
binariów ani cache. LeafData/LeafChecks i Audit/AuditTypes są regenerowane.
Wszystkie63 moduły buduje Lean4.34.0/Std z `-j1 -M2048`. Ponownie uruchamiane
są małe kontrole Lean/C/Sage i toolchain check. Każdy podproces ma sandbox
write-only dla nowego drzewa, source read-only, limity czasu i8GiB address space.

Sukces: `DEST/REPLAY_RESULT.json`, status `FRESH_REPLAY_PASS`, dokładnie ta sama
lista matches. Cwd, czasy i receipts są osobno w DEST/REPLAY_COMMANDS.json,
COMMANDS.log, artifacts/*receipts*, logs/ i checks/logs/. Oryginalne ścieżki
proweniencji nie są otwierane; Dokumenty/H ani poprzednie katalogi robocze
nie są potrzebne. Kompilatory i Sage pozostają wymaganym przypiętym toolchainem.

Archiver repo obsługuje ten wariant przez `--replay standard`. Import i commit
wykona prowadzący sesję po odbiorze raportu i zewnętrznych pinów.

## Rehearsal i rozdzielenie kotwic

Przed freeze użyto jawnego trybu:

```sh
python3 -B scripts/replay.py --rehearsal W/tmp/rehearsal_001
```

Jego kotwica `artifacts/semantic_manifest.sha256` ma hash
`16f343a76c2e61a4d47c462ae8b26daf97985e7715e1e26d15e7bef3364477b7`.
To NIE jest pin OUTPUTS i tryb standardowy go w tej roli nie akceptuje.
Rehearsal jest odrzucany, gdy OUTPUTS już istnieje. Nie ma cyklu hashowania:
lista217 plików nie zawiera samego receipt, końcowego raportu ani OUTPUTS.

Rehearsal odbudował dowody w około190s i przeszedł wszystkie kontrole.
Pełne294 pliki jego strumieni/receipts skopiowano bez zmian do
`artifacts/rehearsal/`; wykaz i hashe w artifacts/rehearsal_evidence.json.
Po freeze standardowy interfejs może być sprawdzony ponownie z finalnym
zewnętrznym pinem; receipt takiego późniejszego wykonania pozostaje w jego DEST,
bez przepisywania zamrożonego checkpointu.

Kontrole samego protokołu: poprawny manifest PASS; odrzucone błędny zewnętrzny
hash, zmieniony członek, traversal, symlink i duplikat. Receipt:
`artifacts/replay_protocol_tests.json`. Nie są to dowody matematyczne L_NTT.
