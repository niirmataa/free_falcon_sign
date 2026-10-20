# BATCH_089 — R1 discharge window: hypothesis discharge closed (2026-10-20)

Window per `notes/run/KEYGEN_STEP_GS_194_NEXT_ROUTE.md`; jobs 479-501.
Receipt: `notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_089.json`.

## What this batch establishes

The stage hypotheses of the sealed `SelectedStepGsChain194.source` (gs
source image, igm twiddle reads, heap writability at the assembled s0-s3
state) are **discharged**. Concretely, as executed words only:

1. **Bystander keeps through the inverse** (jobs 480-483): every load
   from a cell separate from the walked a region survives the final
   pass, the correction and the whole `KeygenLevelNtt.inverse` at
   logn 9 / full 0 (per-cell keep in the
   `NttInverseMiddleRounds192.source` shape, with writable transport).
   This yields the fd/gd image keeps through the s3/s7 calls for free.
2. **Keep arity gap closed** (job 485): copy keeps two simultaneous
   images, product keeps three (gs source + igm through s0; fs + gs +
   igm through s2).
3. **Call keeps** (job 487): both modp_iNTT3_ext call statements (s3 fs
   instance, s7 gs instance) with the keep lifted through the call
   wrapper (the call result is the caller state with the callee heap).
4. **Re-assembly s0-s3** (job 498): the gs source image `gvs`, the igm
   twiddle reads `tws`, the fd written image, the transformed fs image,
   the v = 256 cell and the caller frames all hold at the assembled
   state, unconditionally.
5. **Unconditional s0-s7** (job 501): `SelectedStepFull194.stage_discharge`
   instantiates the sealed chain at the re-assembled state; `source`
   extends the gd written image to the final assembled state through the
   s7 keep (bounded gd/gs walk separation).

## Method notes

- The v cell rides through the s3 wrapper via the generic
  `localSafe_result` caller-local extraction; the parser leaf
  `modp_iNTT2_ext` of the false-ter branch is a make-level binary call
  (`Stmt.binary` via KeygenBinaryNtt) whose rule returns the caller
  state with the callee heap. Diagnostic probe records:
  `NttInverseLocalSafeProbe194`, `NttInverseTerProbe194` (jobs 492/495
  probes; accepted as records in job 501). NOT proof evidence.
- `KeygenLevelCalls.call_frame` / `KeygenMakeFgSource.frame` were
  evaluated and rejected as insufficient: their `Outside` notion covers
  only cells before the named region's start (walked pointers inherit the
  scratch block count), which does not reach the gs/igm keeps.

## Status and limits

Scoped proof, NOT_REVIEWED. 8 accepted jobs, logs 0/0, standard three
axioms, one Lean process, unchanged limits. 15 workshop failures
retained with causes in `notes/run/KEYGEN_STEP_GS_194_FAILURES.json`
(18 entries incl. the inherited 4). No source statement, value, pin or
sealed module was touched by any failure. No push (batch 4 waits for
the owner's signal); no IID/D1/F04 premise.

**Not established**: any transform property, table law, root law,
positivity, unconditional Z>0, numerical p_accept, conditional coding or
positive p_K. The prospective bound Z>=2^-256 is NOT established. The
outer u++/final guard tail, both `zint_rebuild_CRT` calls, the
additional-prime part (slen 1 / tlen 2), the remaining d-levels and the
root/certificate/codec path remain OPEN (route item 4 of the previous
window). Old110 stays frozen; measured wording and the five do_sign
items unchanged. Next unused proof job suffix: **502**.
