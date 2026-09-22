# REPLAY — standardowy protokół i receipty

Standard: `python3 -B scripts/replay.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA
[--manifest OUTPUTS.sha256|artifacts/rehearsal_anchor.sha256]`.
Skrypt jest samodzielny (nie czyta COMMANDS.log). Weryfikuje PEŁNY manifest
+ zewnętrzny hash PRZED utworzeniem DEST; DEST = nieistniejąca ścieżka pod
`proofs/ft1536/{work,replay-work}`; ukrywa oryginalne drzewa (RO-empty),
buduje fresh project + cache w sandboxie bwrap (network-off) i przelicza
`scripts/recipe.py` od zera; porównuje 17 plików z SEMANTIC_FILES.json.

## Schemat kotwicy (bez cyklu hashy)

1. `scripts/make_anchor.py` → `artifacts/rehearsal_anchor.sha256` (bez siebie).
2. Rehearsal z `--manifest <anchor>`: receipt `artifacts/fresh_replay.json`
   (+ kopia `receipts/REPLAY_RESULT.json`).
3. `scripts/freeze.py` mrozi OUTPUTS.sha256 (w tym receipt rehearsal).
4. Replay po freeze z finalnym manifestem w nowym DEST (zapis tylko do DEST).

## Receipty (RUN_003)

| Przebieg | DEST | Wynik |
|---|---|---|
| rehearsal | `W/tmp/rehearsal-001` (kotwica `e85f95f3…`, 136 członków) | FRESH_REPLAY_PASS 17/17, exit 0, 26.0 s |
| po freeze | (po `freeze.py`; nowy DEST, manifest OUTPUTS) | (receipt w DEST; liczby w handoffie) |

Sealed: `artifacts/fresh_replay.json` (FRESH_REPLAY_PASS, matches[{path,sha256}],
mismatches=[]), child `receipts/REPLAY_RESULT.json` + `DEST/REPLAY_RESULT.json`.
17 plików semantycznych (15 z RUN_001 + `formal/CounterLayout.lean` +
`logs/lean_counter_layout.stdout`). Nieudane próby RUN_001 dziedziczone
w FAILED_ROUTES.md; nowe próby RUN_002 dopisywane tamże.
