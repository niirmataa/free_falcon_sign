# OUTPUT_SCOPE — co jest pieczętowane

Deterministyczne (SEMANTIC_FILES.json, 17 plików — odtwarzane bajtowo w replayu):
`artifacts/{fixtures.bin,fixtures.json,kat_vectors.json,harness_dump{,_sanitized,_altbranch}.json,model_dump.json,model_result.json,mutations.json,checker_result.json}`,
`LAYOUT.json`, `RESOURCE_INTERFACE.json`, `PRNG_LAYOUT_CERTIFICATE.json`,
`RESULT.json`, `TOOLCHAIN.txt`, `formal/CounterLayout.lean`,
`logs/lean_counter_layout.stdout`.

Narracyjne (pieczętowane przez OUTPUTS.sha256, nie przeliczane):
REPORT.md, CLAIM.md, LAYOUT.md, BLOCK_SPEC.md, COUNTER_AND_FRAME.md,
RESOURCE_INTERFACE.md, SOURCE_MODEL_BINDING.md, FAILED_ROUTES.md,
NEXT_INTERFACE.md, OUTPUT_SCOPE.md, REPLAY.md, skrypty/harness/model,
wejścia (INPUTS.sha256), logi/receipts. Poza manifestem: `bin/`, `cache/`,
`.build/`, `tmp/`, `executor.lock`, `COMMANDS.log` (mrożony snapshot to
`artifacts/COMMANDS.frozen.log`), `OUTPUTS.sha256` (kotwica zewnętrzna).
