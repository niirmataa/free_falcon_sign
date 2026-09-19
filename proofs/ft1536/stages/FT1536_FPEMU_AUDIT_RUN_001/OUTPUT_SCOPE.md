# Zakres freeze

Autorytatywny exact list to `OUTPUTS.sha256`, bez self-inclusion. Pakiet obejmuje:

- REPORT, RESULT, AUDIT_MATRIX.json/.md, FINDINGS, IMPACT_MATRIX, TIMING_REVIEW,
  REPLAY, TOOLCHAIN, INPUTS, COMMANDS, ten OUTPUT_SCOPE, EXECUTION_NOTES,
  SEMANTIC_FILES oraz otrzymane AGENTS/PREPARATION;
- wszystkie publiczne `inputs/` (bootstrap126+manifest i przypięte zlecenie);
- źródła nowych checkerów/harnessów w `scripts/` i `checks/`;
- pełne `logs/`, także failed Sage attempts, child receipts, pełne Lean
  types/axioms oraz logs pre-freeze rehearsal;
- `artifacts/`: dokładne wyniki, corpus/reproducer, źródłowe assembly,
  provenance, coverage, fresh_replay receipt i frozen COMMANDS prefix.

Poza manifestem: OUTPUTS sam, robocze `bin/`, `formal/` (kopie/olean),
`cache/`, `tmp/`, executor.lock. Nie zawierają nowych matematycznych wejść.
Wyniki post-freeze standard replay są w nowym `tmp/postfreeze001/`, z własnym
REPLAY_RESULT i pełnymi logs; nie dopisuje się ich do zamrożonego raportu.

Archiwum nie zawiera kluczy, seedów, prywatnych coefficients, cache ani
roboczych executable/object/olean. Assembly `.s` jest publicznym tekstowym
wynikiem kompilacji, a word corpus jest jawnie syntetyczny. Wersjonowane C
pozostaje byte-identical do candidate manifest.

29 plików znaczeniowych w `SEMANTIC_FILES.json` jest odtwarzanych i
porównywanych bajtowo. Surowe receipts z datami, wall time, system state,
ścieżkami DEST i sanitizer debug binary hashes są zachowane oddzielnie,
bez obietnicy identycznych czasów/adresów/path-dependent build IDs.
Nie było surowych pomiarów dudect do odtwarzania.
