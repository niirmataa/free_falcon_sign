# FT1536 — wersjonowane punkty kontrolne dowodów

To archiwum ukończonych etapów FT1536 w docelowym `free_falcon_sign`.
Każdy wpis `catalog/*.json` wskazuje konkretny raport, zewnętrzny pin
OUTPUTS oraz niezmienione bajty objęte tym manifestem.

Źródła projektu zachowują ścieżkę `Extra/c`; `FT1536` jest nazwą profilu/builda.
Kopie źródeł wewnątrz checkpointów dokumentują badane wersje i umożliwiają
replay. Integracja zaakceptowanej poprawki do źródeł odbywa się osobnym
commitem w `Extra/c`, bez przemianowania historycznego katalogu Extra.

## Układ

- `stages/<id>/`: wyłącznie OUTPUTS.sha256 i jego członkowie; bez cache,
  nieprzypiętego ogona dziennika i roboczych binariów;
- `objects/<sha256>`: publiczne wejścia wymienione w INPUTS, deduplikowane
  po treści; oryginalne ścieżki są zachowane w katalogu jako proweniencja;
- `catalog/<id>.json`: piny, status, mapa INPUTS i przepis replayu;
- `documents/`: czytelne kopie zleceń i notatek; historia istnieje w Git;
- `tools/archive.py`: import, odczytowa weryfikacja i izolowany replay;
- `work/`, `replay-work/`: lokalne, ignorowane obszary robocze.

Historycznych INPUTS, raportów i skryptów nie przepisuje się, aby zmienić
ich ścieżki. Weryfikator używa mapy oryginalne wejście → obiekt w repo.
Weryfikacja archiwum nie potrzebuje oryginalnych katalogów Dokumenty/H/USB.
Nie jest ona nowym dowodem matematycznym: raport zachowuje swój zakres i werdykt.

## Weryfikacja po pobraniu repo

### Zapisane etapy

| Etap | Werdykt / zakres | Commit checkpointu |
|---|---|---|
| L_V-STATIC | kontrprzykład do ustalonego Ext0 | `791f092` |
| Odbiór Blue | niezależne potwierdzenie kontrprzykładu | `60f574e` |
| L_RHO | poprawna normalizacja całej dziedziny int16 w przypiętym modelu | `9333a08` |
| L_NTT | lokalne kontrakty i certyfikaty; globalna kompozycja częściowa | `e1ab6af` |
| L_NTT_GLOBAL | globalny inverse domknięty; forward_product nadal otwarte | `341d9f7` |

Odtwarzanie z czystego checkoutu Git i ukrytymi oryginałami sprawdzono
2026-09-18: [zapis kontroli](validation/2026-09-18/README.md).

Z katalogu głównego repo, Python 3.11 lub nowszy (biblioteka standardowa):

```sh
python3 -B proofs/ft1536/tools/archive.py list
python3 -B proofs/ft1536/tools/archive.py verify
python3 -B -m unittest discover -s proofs/ft1536/tests -v
```

Polecenie verify sprawdza zewnętrzne piny w katalogu, wszystkie członki
OUTPUTS, dokładny zbiór plików archiwum oraz wszystkie zarchiwizowane INPUTS.
Nie traktuje zgodnych hashy jako potwierdzenia pełnego L_V.

## Odtwarzanie obliczeń

Przykład dla lokalnego L_RHO:

```sh
python3 -B proofs/ft1536/tools/archive.py replay FT1536_L_RHO_RUN_001 --run replay-001 --hide-originals
```

Analogicznie dla `FT1536_LV_STATIC_RUN_001`, `FT1536_L_NTT_RUN_001`
i `FT1536_L_NTT_GLOBAL_RUN_001`.
Wpis katalogu określa właściwy punkt wejścia. Odbiór Blue jest archiwum
recenzji i receipts; nie ma zadeklarowanego pojedynczego pełnego runnera.

Runner tworzy świeżą kopię pod `replay-work/<id>/<run>/`, przywraca roboczy
COMMANDS wyłącznie z zamrożonego prefiksu, a następnie uruchamia przypięty
skrypt replayu z oczekiwanym hashem OUTPUTS. Root sandboxa jest read-only,
zapis dozwolony tylko w tej świeżej kopii, sieć odłączona. Opcja
`--hide-originals` dodatkowo ukrywa historyczne Dokumenty i H, jeśli istnieją.
Katalog uruchomienia musi być nowy. Wszystkie logi i wynik pozostają w nim,
również przy błędzie lub przekroczeniu limitu. Archiwum pozostaje read-only.

Wynik operacji zawiera status historycznej tezy osobno od wyniku replayu:
udane odtworzenie `PARTIAL_PROOF` nadal jest wynikiem częściowym.

### Przypięte środowisko

Pełne replaye wymagają Linux x86_64 LP64, GCC 14.2.0, Python 3, bwrap,
SageMath 10.9 i Lean 4.34.0/Std. Zachowane skrypty używają ścieżek:

```text
/home/footfalcon/.local/bin/sage
/home/footfalcon/miniforge3/envs/sage/bin/python
/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean
```

Te narzędzia i ich środowiska trzeba udostępnić pod zapisanymi ścieżkami.
Repo nie zawiera dystrybucji kompilatorów ani menedżerów pakietów i niczego
nie instaluje. Inne wersje lub mapowanie narzędzi trzeba opisać jako osobną
konfigurację odtworzenia, zachowując oryginalne piny.

## Import następnego etapu

Po zakończeniu pracy, zamrożeniu OUTPUTS i otrzymaniu hashy w przekazaniu:

```sh
python3 -B proofs/ft1536/tools/archive.py import /ABSOLUTE/COMPLETED_STAGE \
  --manifest-sha MANIFEST_SHA256 --report-sha REPORT_SHA256 \
  --replay standard
python3 -B proofs/ft1536/tools/archive.py verify COMPLETED_STAGE
```

`standard` oznacza sprawdzony protokół `scripts/replay.py DEST OUTPUTS_SHA`,
z DEST pod tmp świeżej kopii. Dla dawnego L_V użyj `--replay lv-static`;
dla GLOBAL z jego przepisem pre-freeze `--replay global-crt`, a dla pakietu
bez takiego runnera `--replay none`. Przed wyborem protokołu
przeczytaj REPLAY danego etapu. Inne nazwy raportu/JSON podaje się przez
`--report` i `--result`.

Adapter `global-crt` pomija w świeżym seed wyłącznie dawny podkatalog replay/
i metadane jego odtworzenia, które skrypt tworzy ponownie. Pominięcia są
wymienione w receipt. Wrapper przed wykonaniem weryfikuje pełne archiwum,
a po wykonaniu porównuje cały wykaz i bajty plików znaczeniowych ze
**zarchiwizowanym** receipt. Sam nowy napis PASS nie wystarcza.

Importer kopiuje tylko jawne członki manifestu i publiczne zadeklarowane
wejścia, weryfikuje hashe, odrzuca symlinki i ucieczki ścieżek. Nie nadpisuje
etapu inną wersją: nowy wynik wymaga nowego identyfikatora. Powtórzenie
identycznego importu tylko sprawdza już zapisany checkpoint.

Zlecenie/notatkę można dołączyć czytelną kopią:

```sh
python3 -B proofs/ft1536/tools/archive.py document /ABSOLUTE/TASK.md --sha SHA256
```

## Commit po każdym zakończonym zadaniu

1. Sprawdzić raport, status i piny. Zachować dokładnie `PROVED`,
   `PARTIAL_PROOF`, kontrprzykład albo blokadę — bez zmiany znaczenia.
2. Zaimportować zamknięty pakiet oraz zlecenie; uruchomić verify.
3. Wykonać kontrole właściwe dla nowych narzędzi lub zmienionego replayu.
4. Sprawdzić `git status`, diff roboczy/staged i `git log --oneline -10`.
5. Dodać wyłącznie pliki danego etapu i utworzyć osobny commit, np.
   `proof: record L_NTT partial proof checkpoint`.
6. Podać hash commita obok hashy raportu i OUTPUTS w przekazaniu użytkownikowi.

Docelowa gałąź to lokalny **main**. Jeśli checkpoint powstał na innej gałęzi,
po sprawdzeniu przenieś go fast-forward, o ile historia na to pozwala.
Przy zajętym roboczym indeksie użyj osobnego worktree do operacji na main.
Rozbieżnej historii nie nadpisuj. Push pozostaje osobnym poleceniem właściciela.

Nowe zadania mogą używać `proofs/ft1536/work/<id>/` jako sandboxa obliczeń.
Ta robocza zawartość jest ignorowana; po zakończeniu zadania importer zapisze
jej zamrożony zakres pod stages/, a następny commit obejmie ten checkpoint.

Przy wcześniejszych staged zmianach używać dokładnych pathspeców i
`git commit --only -- <własne ścieżki>`. Jeden wykonawca operuje na indeksie.
Obecnie prowadzący sesję wykonuje commit po sprawdzeniu raportu Astry.
Jeśli obowiązek przejmie Astra, musi otrzymać ten zakres i odpowiedni dostęp
do repo; sandbox samego obliczenia nadal powinien obejmować tylko jego W.

Commit checkpointu nie integruje kandydata z Extra/c ani nie nadaje
owner acceptance. Każde kolejne zadanie dodaje się po zamknięciu
odpowiedniego punktu kontrolnego. Aktywnego drzewa nie migruje się podczas
zapisu przez wykonawcę.
