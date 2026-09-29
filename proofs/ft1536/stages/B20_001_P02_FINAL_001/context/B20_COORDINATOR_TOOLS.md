# B20 — użycie narzędzi koordynatora

Obowiązuje workflow **work → niezależny review → zaakceptowane stages →
lokalny commit main jako niirmataa**. Komendy uruchamiaj z REPO. Każde pole
SHA poniżej pochodzi z handoffu; zgodność hashy nie zastępuje oceny dowodu.
Modele uruchamia właściciel. Kolejne Pxx nadal wymagają odebranych eksportów
swoich zależności; `--start` zapisuje przydział,nie dowodzi gotowości wejść.

## 1. Start i frozen handoff autora

Przykład P01. `--model` i `--context` to literalne teksty; zachowują cały
provider/model ID. `--head` to pełny40- lub64-znakowy source commit ID.

```sh
python3 -B tools/b20_status_set.py P01 --start --model 'provider/model' --context 'fresh'
python3 -B tools/b20_status_set.py P01 --bound-inputs "$P/inputs/BOUND_INPUTS.json"
python3 -B tools/b20_status_set.py P01 \
  --final-report "$P/output/REPORT.md" --final-outputs "$P/output/OUTPUTS.sha256" \
  --report-sha "$REPORT_SHA" --outputs-sha "$OUTPUTS_SHA" --head "$SOURCE_HEAD"
python3 -B tools/b20_review_prompt.py V01 --out "$V/run/REVIEW_PROMPT_001.md"
```

P i V oznaczają właściwe W z INDEX. Frozen binding weryfikuje wszystkich
członków manifestu i RESULT.task_id. Import do stages nie jest potrzebny
do przygotowania review. Generator sprawdza typ pary,piny TASK w INDEX/PACKAGE
i ponownie frozen autora. Bez handoffu generuje szkic z jawnymi placeholderami.
Nowy prompt zapisuj pod nową nazwą; istniejącego zmienionego pliku nie nadpisuje.

## 2. Handoff recenzenta

REVIEW_OUTPUTS.sha256 przypina REVIEW.md,REVIEW_RESULT.json,INPUTS.sha256
i wszystkie wymagane źródła/receipty/logi. Używaj ścieżek względnych bez `./`,
duplikatów,traversal i samoodwołania manifestu. RESULT autora ma dokładne
`task_id` z INDEX. Minimalne pola REVIEW_RESULT dla P01/V01:

```json
{
  "review_id": "B20_001_V01_FORMAL_FOUNDATIONS",
  "source_task": "B20_001_P01_FORMAL_FOUNDATIONS",
  "source_report_sha256": "<REPORT_SHA autora>",
  "source_outputs_sha256": "<OUTPUTS_SHA autora>",
  "verdict": "PASS_SCOPED_REVIEW",
  "verdict_scope": "<rzeczywisty zakres i pozostające obowiązki>"
}
```

Uzupełnij pozostałe artefakty według TASK. Odrębność recenzenta i prawdziwość
wykonania sprawdza prowadzący. Narzędzie kontroluje przypisanie dokumentów.

Werdykty negatywne: CHANGES_REQUIRED,INTEGRITY_FAIL,REPLAY_FAIL,
EXECUTION_BLOCKED,BLOCKED. Przy nich użyj komendy z §3 dla `--review-verdict`
bez `--stage/--review-stage`; zostają zapisane jako takie,a pliki pozostają w W.
Nowe `--start` po negatywnym odbiorze zachowuje poprzedni binding w historii.

## 3. Po zaakceptowaniu zakresu

Najpierw importer zachowuje dokładne źródła i manifesty obu pakietów.
Wybór `--replay standard/none` autora zależy od jego rzeczywistego REPLAY;
przykład zakłada protokół standard i domyślny sealed receipt.

```sh
python3 -B proofs/ft1536/tools/archive.py import "$P/output" \
  --id B20_001_P01_FINAL_001 --report-sha "$REPORT_SHA" --manifest-sha "$OUTPUTS_SHA" \
  --replay standard
python3 -B proofs/ft1536/tools/archive.py import "$V/output" \
  --id B20_001_V01_FINAL_001 --report REVIEW.md --result REVIEW_RESULT.json \
  --manifest REVIEW_OUTPUTS.sha256 --report-sha "$REVIEW_SHA" --manifest-sha "$REVIEW_OUTPUTS_SHA"
python3 -B tools/b20_status_set.py P01 --review-verdict PASS_SCOPED_REVIEW \
  --review-report "$V/output/REVIEW.md" --review-outputs "$V/output/REVIEW_OUTPUTS.sha256" \
  --review-report-sha "$REVIEW_SHA" --review-outputs-sha "$REVIEW_OUTPUTS_SHA" \
  --stage B20_001_P01_FINAL_001 --review-stage B20_001_V01_FINAL_001
```

Setter wymaga zgodności obu stage'ów z zadeklarowanymi pinami,identyfikatorami
pary i sealed werdyktem. Sam istniejący stage,inny wynik lub dowolny napis PASS
nie wystarcza. Zaakceptowane PARTIAL zachowuje ten matematyczny status.

Przed commitem dopisz do `COORDINATOR_LOG.md`:UTC,komendy,piny/wynik i następny
krok. Następnie:

```sh
python3 -B proofs/ft1536/tools/archive.py checkpoint B20_001_P01_FINAL_001 \
  --with-stage B20_001_V01_FINAL_001
```

Checkpoint obejmuje parę stage/catalog,tylko jej wymagane objects oraz STATUS
i append-only dziennik. `--include docs/onboarding/STATE.md` (analogicznie
ROADMAP lub proofs/ft1536/README.md) dołącza jawnie wskazane metadane.
Weryfikuje exact bytes,zachowuje cudzy staging,działa na main i używa
niirmataa jako author/committer bez zmiany Git config. Nie uruchamia push.

Frozen B20/PACKAGE oraz wcześniejsze archiwa pozostają przypięte. To instrukcja
narzędziowa od2026-09-23; nie zmienia celów dowodowych ani startuje workerów.
