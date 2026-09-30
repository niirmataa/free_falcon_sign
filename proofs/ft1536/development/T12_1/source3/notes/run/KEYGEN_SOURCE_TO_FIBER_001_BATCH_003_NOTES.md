# Internal batch003 — source FFT/LDL procedures and recursive byte frames

Package status: **IN_PROGRESS / NOT_REVIEWED**. This is an internal step of
the complete B1 package. No full-certificate or successful-KeyGen theorem
is exported by this batch.

Receipt: `KEYGEN_SOURCE_TO_FIBER_001_BATCH_003.json`, SHA256
`0cd3002b2d9e25b4ba967381a8034d2c2ce3cb26265db9f0a575cad1382fae21`.
Fresh replay `keygen_fiber_batch3_fresh_001`:15/15 clean,20 type/term/axiom
audits,309.128s, peak5049120KiB. Transitive axioms are the standard Lean
axioms or none. Limits were unchanged. Source/checker pins and raw logs are
in the receipt and its persistent job directories.

## Actual exports

- `C99ProcedureReference`: finite natural execution with value return,
  return conversion, break, continue and source-body calls. Return stops a
  sequence. Compound call assignment performs the C operator/conversion.
- `FpcSourceExpansion`: consumes the six pinned FPC macro ASTs, with a
  kernel equality between cached and reparsed expansion. It uses the fixed
  source FPR calls, not FftSemantics' parametric numerical call interface.
- `FftProcedurePrograms`: complete parsed FFT3, muladj, split_top,
  split_deep, LDL_dim2, LDL_dim3, ffLDL_inner, ffLDL_depth1 and ffLDL_top,
  plus the seven existing leaf functions. Header caches are kernel-bound.
- `C99PointerFootprint`/`C99ProcedureFootprint`: byte frame across pointer
  declarations/rebinding, bounded memcpy, scope and recursive calls.
  Generic metatheorems require a checked program; `FftProcedureFrames`
  supplies that check for all16 actual source bodies. The finite execution
  derivation, not an assumed callee frame, drives recursive induction.
- `FftProcedureFrames.parsed_body_frame`: for an actual parsed body and its
  execution, bytes outside the initially writable pointer tails and source
  tables are unchanged. The caller must instantiate the actual pointer
  layout. This does not yet prove the enclosing certificate frame.

The array memcpy execution rule now requires both source and destination
subobject extents, in addition to backing memory bounds. This closes an
over-permissive draft byte-copy rule before use in procedure frames.

## Checks and retained failures

`keygen_fft_procedure_bindings_001` ran the Sage preparser checker against
the pinned source files: nine function regions and three internal.h aliases.
Three kernel mutations reject writes/copies to a read-only input, aliasing a
write-capable local from that input, and passing it as a writable callee
argument. These are footprint checks, not complete B1 mutation coverage.

Earlier jobs retain the missing dereference-store syntax, oversized
signature reductions, constructor-pattern errors and unused-simp warnings.
Later footprint drafts retain two Bool/projection errors. All failed source
snapshots, receipts and raw logs remain in `.build/jobs/`. Factoring source
signatures and macro caches solved the reduction cost without higher limits.

## Remaining B1 composition

The four smallint conversions, prefix layout/allocation, actual g00 copy,
Gate00, suffix and local-object teardown still need one complete function
execution. The new prefix-connection drafts are outside this batch receipt.
The attempt-interface implementation, same-attempt serializer round-trip,
source NTT/table/public/inverse proofs and emitted-to-fiber theorem remain
open. No stored-word bound is identified with exact LDL or FiniteFlat.

Publication follows the adapted B1 instruction: local commits only, until
an explicit owner push signal. No reviewer or new subagent was started.
