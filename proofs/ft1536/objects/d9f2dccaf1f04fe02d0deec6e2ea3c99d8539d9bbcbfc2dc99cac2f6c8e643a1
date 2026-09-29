# P02 successor v2 — odtwarzanie

Portable runner `replay/job.py` używa wyłącznie zapieczętowanego pakietu `output/`, nie czyta `PRIOR_W/src/run`, i zapisuje nowy absent DEST `W/run/<label>`. Oryginał sprzed korekty zachowano w `replay/original_job.py`, dokładny diff `replay/RUNNER_DELTA.diff`; oryginalny gate Git na potrzeby proweniencji pozostał w `formal/tools/toolchain_gate.py`, nowy bez-Git gate `replay/portable_toolchain_gate.py` i diff `replay/TOOLCHAIN_DELTA.diff`.

```
W=/media/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_P02_FREEZE_CLOSURE_RUN_001
python3 -B "$W/output/replay/job.py" nowy_absent_dest --inputs-sha256 <SHA W/output/INPUTS.sha256> --outputs-sha256 <zewnętrzny SHA W/output/OUTPUTS.sha256>
```

Przed utworzeniem DEST preflight: porównanie external SHA starego OUTPUTS/REPORT, BOUND_INPUTS, source17, pełnego nowego INPUTS, exact set/no-symlink/escape dla statycznych wejść, starego OUTPUTS 68/68 i nowego OUTPUTS (jeśli pin podano). `--outputs-sha256` pomija się tylko przy pierwszym tworzeniu pakietu przed freeze; V02 musi podać go po freeze. Istniejący DEST jest odrzucany.

Źródła formalne kopiowane do RO snapshotu; własne olean od zera. Przypięty zewnętrzny P01 weryfikowany gate'em przed generatorami. 8 kroków: gate, trzy transporty, check_transport, kontrole word/LE/scalar; 34 Lean build modules w kolejności BUILD_PLAN (w tym obydwa historyczne audyty), a po nich osobny pełny wydruk `AuditTermsFull.lean` — razem **43 kroki**. Child controller logi są przechwytywane po każdym kontrolerze, zanim następny może nadpisać jego nazwę. Własne wejścia W-only i `--unshare-net`, `--proc /proc`, `--dev-bind /dev /dev`, osobny RW dest/tmp pod `/tmp`. Lean `-j1 -M2048`, wall1800s/krok, limit AS 8GiB. Sanity/fresh semantic plan w `SEMANTIC_FILES.json` powstał *przed* końcowym replayem; receipts, logi i porównania po wykonaniu w `REPLAY_RESULT.json` i `replay_evidence/`.

Surowe historyczne failed routes zebrano jako tekst w `evidence/earlier_routes/`, index `FAILED_HISTORY_INDEX.json`; historyczne child-log overwrites opisuje `OVERWRITTEN_LOGS.json`. Nowe zachowane child logi mają własne `replay_evidence/fresh_003/logs/child/{word,le,scalar}/` i nie są przedstawiane jako oryginalne logi starych kroków. Pierwszy ukończony `fresh_001`/15 matches przed rozszerzeniem audytu oraz `fresh_002`/16 matches przed końcową korektą top-level OUTPUTS preflight zachowane jako historia z własnymi manifestami/runnerami w `replay_evidence/`.
