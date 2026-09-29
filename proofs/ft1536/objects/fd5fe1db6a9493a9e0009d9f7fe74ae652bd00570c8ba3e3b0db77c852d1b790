# P02 — rozliczenie F1–F4 (successor v2)

F1 CLOSED: oryginalny runner byte-exact `replay/original_job.py`; przenośny `replay/job.py`, pełny `RUNNER_DELTA.diff`, nowy bez-Git gate i `TOOLCHAIN_DELTA.diff`. Bez żywego PRIOR_W/src/run. Preflight INPUTS i dwa external piny.
Predeclared SEMANTIC_FILES wskazał koniec pipeline (krok3) przy czterech plikach generowanych wcześniej; `REPLAY_RESULT.json` koryguje pole realnego producenta na krok1/2 z argv/exit, zachowując wcześniej przypięte hash/baseline.

F2 CLOSED dla 34 kernelowych buildów: 32 sealed proof sources i dwa Audit moduły bajtowo zgodne z `replay_001` source_before. ProbeFreezeScan źródło i log związane z `freeze_scan` (nie dodawane do BUILD_PLAN). Historyczne pełne **typy** i aksjomaty 489 nazw przypięte; historyczny wydruk AuditTerms ma 51 znaków `⋯` i pozostaje niekompletnym wydrukiem. Osobny, źródłowo przypięty `formal/AuditTermsFull.lean` jest krokiem43 świeżego replayu, z pełnym wydrukiem 20 terms (0 `⋯`) bez zmiany dowodów.

F3 BYTE CLOSURE WITH PROVENANCE LIMIT: 9 receiptów, 144 kroków i 288 krokowych stdout/stderr, 76 child commands, źródła oraz publiczne tekstowe failed attempts przypięte. Sześć oryginalnych child log pathów w replay_001 zostało nadpisanych przez późniejszy kontroler. `OVERWRITTEN_LOGS.json` zawiera hash-równe bajty z innych przypiętych przebiegów; pierwotnej ścieżki/proweniencji nie można odzyskać. Nowy runner snapshotuje własne child raw logs osobno dla word/LE/scalar przed nadpisaniem nazw.

F4 NEW_HEAD_BOUND: rzeczywisty `main` z read-only `.git/HEAD` i ref w `HEAD_CONTEXT.json`; historyczny końcowy HEAD starego freezu nieudokumentowany, nie myli się z SOURCE_BASE. Zakres PARTIAL_PROOF zachowany; V02 decyduje o niezależnym odbiorze.
