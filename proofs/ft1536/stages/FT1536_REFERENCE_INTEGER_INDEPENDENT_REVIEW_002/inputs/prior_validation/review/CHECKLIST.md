# CHECKLIST — FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_001

- [x] Ownership: jeden recenzent/jeden job; REVIEW_W wolne, SOURCE_W RO; brak
      drugiego workera T03 (aktywny job T02.1 w innym W odnotowany, bez kolizji).
- [x] Piny zewnętrzne: REPORT/OUTPUTS/TASK/MANIFEST/CANDIDATE/POLICY — MATCH.
- [x] OUTPUTS 85/85 (traversal/symlink/duplikat/mismatch: 0).
- [x] INPUTS 28 plików + alias TASK_DOCUMENT_provenance (hash = kanoniczne TASK).
- [x] Bootstrap 1275/1275, source17, closure-note.
- [x] Postfreeze autora: 3 piny MATCH (historia, nie mój replay).
- [x] Seed: 85 sealed members + OUTPUTS + INPUTS closure + adapter alias; bez
      cache/bin/olean/tmp autora; COMMANDS.log zachowany (nie kasowany).
- [x] Fresh replay w bwrap (net-off, SOURCE_W ukryte, HOME/TMP/XDG/DOT_SAGE
      lokalne): 11/11, exit 0, ~12 s; SAGE_RUNS = mój run; bajty 11/11
      niezależnie; pierwsza próba zachowana (PASS).
- [x] Sage autora: 4 × `.sage` przez `sage lemma.sage`, preflight, ZZ/QQ,
      RIF256 + exact bound²≥p; rachunek w `.sage`, Python organizuje.
- [x] Własne 3 × `.sage` (POLICY): gap-recompute / zmap-bijection /
      ring-independent — wszystkie exit 0, Sage 10.9.
- [x] A: definicja/mapping-3072/cancellation/integrality/congruence — scope OK.
- [x] B: TOTAL QQ-recomputed 6086.4008 ≥ 1/2, gap_met=false, missing type dokładny.
- [x] C: 15 twierdzeń, czyste logi, aksjomaty [propext, Quot.sound], orientacja
      tie OK; 20110 fixtures vs 60384 wykonania; 880/198 osobny zakres;
      mutacje/no-op/preflight/±0/oracles OK; zastosowanie warunkowe od B.
- [x] D: consumer warunkowy, kolejność, Safe16 spoza stored-norm, kontrprzykład
      lokalny, flagi false/null.
- [x] Port v3→v4: 17 ścieżek, 5 wyników, wiersze Z identyczne / pliki nie,
      12 enclosures representation-only, MT→LCG, tie_odd_case, stare receipty —
      rozliczone + 2 uwagi low.
- [x] Piny SOURCE_W ponownie na końcu (werdykt + handoff).
- [x] Artefakty REVIEW_W + REVIEW_OUTPUTS.sha256 (bez cache/olean/bin/sekretów).
- [x] Bez Git/importu/push/relay/subagentów/KeyGen/secrets/Sign/PRNG/sieci.
- [x] Joby zakończone; owner_accepted=false.
