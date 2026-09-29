# P02 — OUTPUT_SCOPE (co wchodzi do freeze B20_001_P02_FINAL_001)

## Wchodzą do OUTPUTS.sha256

- źródła formalne: `formal/B20/**` (32 moduły BUILD_PLAN, w tym Spec,
  RintExec, FloorExec, Domain, LERefinement, ScalarParser)
- skrypty kontrolne: `formal/checks/{scalar.sage, scalar_controls.c,
  word_helpers.c, word_helpers.sage, little_endian.c, little_endian.sage}`
- narzędzia: `formal/tools/*.py` (job-organizacja; matematyka w .sage/Lean)
- artefakty §9 TASK: REPORT/RESULT/CLAIM/GOAL_SPEC.md+json/FORMAL_EXPORTS/
  ASSUMPTIONS/SOURCE_MODEL_BINDING/INPUTS.sha256/TOOLCHAIN/COMMANDS.log/
  EXECUTION_RECEIPTS/SAGE_RUNS/AXIOMS/FAILED_ROUTES/NEXT_INTERFACE/REPLAY/
  SEMANTIC_FILES/OUTPUT_SCOPE/OUTPUTS.sha256/HANDOFF
- `OUTPUTS.sha256` nie obejmuje samego siebie (TASK §9)

## Nie wchodzą (świadomie)

- bootstrap Mathlib (pinned library; weryfikacja rev przed użyciem),
- run/ (receipty i logi wszystkich runów; cytowane w REPLAY/EXECUTION_RECEIPTS,
  nie kopiowane — pełne DEST pozostają w W),
- inputs/ (readonly closure pinowany przez BOUND_INPUTS.json),
- home/tmp/cache (środowisko procesu), *.olean/.lake (build cache),
- Probe*.lean i ParsedStatements.lean (diagnostyka; jawnie poza BUILD_PLAN
  lub generated_sealed).

## Skala twierdzeń

Wynik: source-bound refinement słów/pamięci + literalne wykonania skalarnych
prymitywów FPEMU z domenami + interfejsy obligation. NIE: kontrakt
arytmetyczny add/mul/div/sqrt, nearest-ties-even na rzeczywistych, kod
maszynowy, bezpieczeństwo schematu.
