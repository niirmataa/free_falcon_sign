# P01 v2 — OUTPUT_SCOPE (co wchodzi do freeze, co nie)

v2 zastępuje v1 dla odbioru V01 (uzupełnienie po uwagach recenzenta:
kompletne przypięte źródła/configi/logi replayu, replay do nowego DEST,
opis ról aux). Freeze v1 (`output/`) zachowany bez zmian dla historii.

## Wchodzą do OUTPUTS.sha256 (freeze B20_001_P01_FINAL_001)

- `formal/` — kompletne źródła Lean projektu (8 modułów + B20.lean +
  FT1536P01.lean + PrintedTypes.lean)
- `aux/` — pliki pomocnicze **z opisanymi rolami** (aux/README.md):
  Debug.lean (inspektor pipeline'u checkera), RedTest.lean (pozytywny probe
  redukcji kernelowej), RedTestStringFailures.lean (negatywny probe —
  materiał dowodowy FAILED_ROUTES#8; celowo nie kompiluje się, nie budowany)
- `build/` — **piny konfiguracji build**: lakefile.toml, lake-manifest.json
  (rev-y wszystkich 9 pakietów), lean-toolchain
- `certificates/` — skrypty `.sage` v2 (rachunek autorytatywny; wyjście przez
  FT1536_P01_OUT)
- `tools/restore_replay.py` — **sterownik replayu** (odtworzenie do nowego
  DEST; W autora tylko do odczytu)
- `replay/` — **REPLAY_RESULT.json + logi replayu** (6 jobów, pełne receipty)
- `CERTIFICATES/` — wygenerowane certyfikaty (identyczne z v1: `33cf2381…`,
  `a6c06215…`, `16d4ca49…`)
- `EXPECTED.json` — pinowane oczekiwane hashe produktów + statystyki axiom
  scan (semantic match przy replayu)
- `failed_attempts/` — wybrane logi nieudanych tras (cytowane w
  FAILED_ROUTES.md)
- artefakty TASK §9: REPORT/RESULT/CLAIM/GOAL_SPEC.md+json/FORMAL_EXPORTS/
  ASSUMPTIONS/SOURCE_MODEL_BINDING/INPUTS.sha256/TOOLCHAIN/COMMANDS/
  EXECUTION_RECEIPTS/SAGE_RUNS/AXIOMS/FAILED_ROUTES/NEXT_INTERFACE/REPLAY/
  SEMANTIC_FILES/OUTPUT_SCOPE/formal_printed_types.txt/HANDOFF
- `OUTPUTS.sha256` — manifest NIE obejmuje siebie ani HANDOFF (jedyne
  spójne domknięcie: HANDOFF niesie SHA manifestu)

Snapshot źródeł w replayu obejmuje exact set `formal/ aux/ build/
certificates/ tools/` — wszystkie te pliki są w pakiecie (poprawka uwagi #3).

## Nie wchodzą (świadomie)

- `bootstrap/mathlib4`, `.lake/packages` (immutable pinned library build —
  reuse za bramką provenance rev, poza manifestem; biblioteka nie jest
  twierdzeniem), `.lake/` cache build,
- `home/`, `tmp/`, `cache/` (środowisko procesu),
- `run/` (historia pracowni autora w W; nie jest freeze),
- `replay-work/B20_001_P01_RESTORE_A|B` (DEST replayów autora; ich receipt
  jest w `replay/`),
- `checkout*`, `inputs/` (readonly closure — pinowane przez BOUND_INPUTS.json
  i INPUTS.sha256).

## Skala twierdzeń

Wynik jest fundamentem formalnym (eksporty + kontrakty certyfikatów +
źródłowe binding), NIE dowodem bezpieczeństwa schematu, NIE bridge'em real
PRNG i NIE refinemencie kodu maszynowego (ASSUMPTIONS.json).
