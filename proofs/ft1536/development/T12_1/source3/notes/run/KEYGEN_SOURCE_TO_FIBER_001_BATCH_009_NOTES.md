# Internal batch009 — forward-NTT grammar, complete body composition, prologue execution

Status: **IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN**. Stage B1.02
frozen at a recoverable mid-point per `run2/notes/B1_STAGED_ROADMAP.md`
iron rule 3 (the stage is sized BIG; the window closed at ~the budget
boundary, not at a failure). Session harness: **MiMo V2.6 Pro**, B1
continuation window under the explicit handoff
`run2/notes/PROMPT_B1_CONTINUATION.md`.

Passing evidence (all logs 0/0, limits unchanged, no push):

- `keygen_ntt_frontend_004` — 23/23 accepted, full cached descendant
  closure of the grammar change. RECEIPTS.json
  `f2efa0ee078c3d84dc8754829a46ad8e5944d3372a58d2c468499904d9ba621c`.
  Every earlier pinned parse re-proved unchanged: `region 7386 11`
  (KeygenCheckProgram), `region 7367 6` (KeygenResidueProgram, with the
  signed annotation), `region 3070 7 / 3095 7 / 3115 20`
  (KeygenNttButterflyPrograms), and the KeygenCheckMutations rejections.
- `keygen_ntt_forward_programs_003` — 24/24 accepted.
  RECEIPTS.json
  `12beedee53807afa7fa9d329b5d776956bad43f9d38c9a9f5a6e2a02f633fdcc`.
- `keygen_ntt_forward_exec_005` — 1/1 accepted. RECEIPTS.json
  `87fd901fed7228e3022469037c14f6cf6fb19230c87b19ae1bfb782d6a8fa958`.

## What is derived

1. **Grammar (syntax/control, its own commit `a2679fc5`).** The modular
   frontend now accepts exactly the forward-NTT control syntax and no
   more: void `return;` (`Stmt.retVoid` + `Exec.retVoid`),
   `uint32_t *r1, *r2;` declarations, pointer assignment/advance
   (`r1 = a`, `r2 = a + hn * stride`, `r2 = r1 + ht * stride`,
   `r1 += stride`) through a threaded pointer-name Context and
   `bindPtr`, comma-separated for-init/for-increment clauses with
   compound updates (`m <<= 1`, `u += 3`, `v1 += t`), and the MKN macro
   expansion (never modelled as a Call). All five consumers listed in
   checkpoint 2.3 were patched (`C99ModularAnnotation.statement`,
   `C99ModularFlow.onlyReturn`+`source_flow`, `C99ModularFrame.readOnly`+
   `source_frame`, `KeygenCheckLoopBridge.complete`,
   `KeygenResidueLoop.complete`). `KeygenCheckGate.return_literal` needed
   no change (retVoid cannot match its index). Pointer `++` is rejected
   rather than mis-parsed as scalar update.

2. **Complete body (commit `5ec12a55`).**
   `KeygenNttForwardPrograms.body_source : C99ModularParser.region 3046 91
   = some forwardBody` with `forwardBody = glue prologue (glue firstPass
   (glue intermediatePass triplePass))`; `glue` is sequence composition
   modulo the parser's synthetic skip terminator. Each part is separately
   pinned to its contiguous source region (3046 9 / 3066 12 / 3082 24 /
   3110 27) — the later three under `regionContext ["r1","r2"]`, the
   continuation context established by the top-level pointer
   declarations. Every guard is retained, including `if (logn == 0)
   return;`. The wrapper `modp_NTT3(a, gm, logn, full, p, p0i)` →
   `modp_NTT3_ext(a, 1, ...)` stays separately pinned
   (`wrapper_source`).

3. **Prologue execution (commit `c4d02bac`).**
   `KeygenNttForwardExec.prologue_result`: for ANY `Exec` derivation of
   the parsed prologue with `logn ↦ 10`, `full ↦ 1`, the result is
   exactly `⟨ready before, .normal⟩` with `n ↦ 1536`, `hn ↦ 768`
   (`ready_n_slot`, `ready_hn_slot`). The values are derived from
   execution: `mkn_value` evaluates the expanded MKN macro through the
   `size_t` cast and both shifts (`plus_three_value`, `minus_nine_value`,
   `shl_full_value`), `half_value` evaluates `n >> 1`, and `guard_value`
   derives the logn0 guard verdict from the actual `logn` slot. No
   success constructor carries evaluations; the only callees are the
   pinned `Call` bodies (modp_montymul/add/sub), no NTT oracle.

## Boundaries kept explicit

- Loop counters and pointer positions (first/intermediate/triple passes)
  are NOT yet derived from execution; this is the exact B1.02 remainder
  (Trace/KeygenCheckLoopBridge shape). No range or polynomial invariant
  was committed here (B1.04 territory) — the syntax/control separation
  required by the plan is preserved.
- Checkpoint 2.4 (butterfly call-observation extraction from the parsed
  bodies) remains open; `FirstCalls`/`BinaryCalls`/`TripleCalls` stay
  interface, not conclusion.
- `stride = 1` is bound to the pinned wrapper argument; its caller-frame
  instantiation is B1.07 work. It is not claimed as a derived execution
  fact in this batch.
- The pinned runner `tools/job.py` (sha256 `3bc29bf7…`) is byte-identical
  to previous batches; its hardcoded PREFLIGHT `model`/`session` fields
  are historical labels and do not describe this window's harness (MiMo
  V2.6 Pro). Recorded rather than silently edited.

## Traps met this batch (carried to the checkpoint)

- Region sub-parses need their continuation context: standalone
  `region` starts with an empty Context, so `r1 = a` parses as scalar
  assign there. `regionContext` states the pins with the actual
  continuation context; `region` keeps the empty context so every older
  pin is untouched.
- Elaborator shapes that bit: `names.map String.toList` needs
  parentheses inside constructor applications; `chain` lives in
  `KeygenNttButterflyPrograms`; `B20.C.Ty.i32` cannot be written `.i32`
  with `C99IntegerReference.Ty` open; Int literals and `((n:Nat):Int)`
  casts are different terms for `rw`; `rw [he] at exit` with
  `he : out = r` needs `subst`, not `rw`, when the target mentions `r`;
  a final `rw` may leave a residual `rfl` goal behind a def.
- Failed jobs `keygen_ntt_frontend_003`,
  `keygen_ntt_forward_programs_001/002`,
  `keygen_ntt_forward_exec_001..004` are retained with raw logs; note
  that `keygen_ntt_forward_programs_002` (failed overall) already
  contained the successful `prologue_source`/`body_source` evaluations —
  cite the passing `_003` job for those claims.
