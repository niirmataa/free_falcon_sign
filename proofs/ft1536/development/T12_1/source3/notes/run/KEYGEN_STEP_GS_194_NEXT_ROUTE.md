# CRT part-3 route — obligation (a) closed, the normZero engine next

2026-10-21 (restart window after the provider failure). The table-word
transport is closed: SelectedStepCrtWord194 (job 516) carries the
block-21 ternary table word primes[0].p (SelectedTopInit178.p) from the
body input state through the whole s0-s7 chain and the heap-free tail to
the make_fg_step loop exit state, and entry_keep delivers it to the
zint_rebuild_CRT callee entry state (the storePrime consumer). The s0/s2
per-cell bystander keeps StepCopyKeepCell194/StepProductKeepCell194
(job 512) closed the keep-arity gap of the copy/product loops. Commits
543f751d/6016c4f3. The interrupted job 512 consumed the 512 suffix;
next unused proof job suffix is **517**.

## Exact remaining obligations (in order)

1. The zint_norm_zero / zint_sub body runs at len = 1: the two comparison
   branches of zint_norm_zero are data-dependent, so the honest export is
   the executed-word image `normWord p0 x = if x < p0>>>1 then x else if
   p0>>>1 < x then x-p0 else x` (decidable case splits; the zint_sub
   write at len = 1 is the unconditional word x-p0).
2. The 512-step normalize loop induction over the x walk, the rebuildCrt
   body run (the tmp[0] = primes[0].p storePrime, the empty co-reduction
   loop at xlen = 1, the normalize branch), then both call statements of
   part 3 composed at the exit state.
3. Then the additional-prime part (slen 1 / tlen 2), the remaining
   d-levels and the root/certificate/codec path, before the complete
   emitted witness can instantiate the corrected KeygenProbability134
   consumers (KeygenModelUnlock134.package_of_witness,
   KeygenSuccessMass134.success_lower_of_witness).

---

# Continuation after the discharge — s0-s7 unconditional, the tail open

The discharge window (this stage's previous route) closed all three
discharge obligations: the per-cell bystander keep through the final
pass, the correction and the whole inverse (jobs 480/481/482/483), the
s0/s2 keep arity gap with two- and three-image keep modules (job 485),
the keep-threaded s3/s7 call statements (job 487), the s0-s3 re-assembly
with the gs/igm/fd keeps and the v = 256 cell (job 498), and the
unconditional full first-prime assembly with the gd written image at the
final assembled state (job 501). At resume verify the entry receipt
`.build/stepgs194/ENTRY_PINS.json` (SHA256
`99ac47a1d981ebfc3afe3c54aac98c02773816faa489682d205682fd31c475b8`)
against the pins in `KEYGEN_STEP_GS_194_REPORT.md`, re-check the
inherited pin chain and confirm no active owned job/Lean/Sage process
before any new proof work. Next unused proof job suffix is **502**. Keep
one Lean process (`tools/job111.py`, `-j1 -M6144`), logs 0/0, standard
axioms. Never edit sealed 187-193 sources; the 194 modules of this stage
stay byte-stable too (edit-by-new-module only).

## Exact remaining obligations (in order)

1. The outer u++/final guard tail of the make_fg_step prime loop (the
   `SelectedStepGsChain194.fullPrefix` export now closes the first-prime
   body; the loop's u increment, the false-guard exit and the state
   transport to the second prime remain), then both `zint_rebuild_CRT`
   calls, the additional-prime part (slen 1 / tlen 2), the remaining
   d-levels and the root/certificate/codec path, before the complete
   emitted witness can instantiate the corrected KeygenProbability134
   consumers (KeygenModelUnlock134.package_of_witness,
   KeygenSuccessMass134.success_lower_of_witness).
2. The fd written image at the assembled s0-s3 state and the gd written
   image at the final state are now exported as executed words (jobs
   498/501) and feed the CRT/additional-prime consumers; their
   consumption is part of obligation 1. The gs source words `gvs` are
   the actual executed loads of `SelectedGen0Frame189.g_read`; no table
   law is assumed for them.

## Traps met (do not re-derive)

- The parser leaf `modp_iNTT2_ext` of the false-ter branches is a
  make-level binary call (`Stmt.binary`, bound through `KeygenBinaryNtt`),
  not a `KeygenLevelCalls` call; its rule returns the caller state with
  the callee heap (probe records `NttInverseTerProbe194` /
  `NttInverseLocalSafeProbe194`). The generic caller-local extraction
  `SelectedStepChainKeep194.localSafe_result` covers it.
- `=` binds tighter than `&&` in Lean annotations: `(x && y) = true`
  must be parenthesized or the right operand is coerced through `decide`.
- The sealed `SelectedStepGsChain194.source` exports s4/s5/s6/s7, the
  gsPrefix run, the composed fullPrefix run, the gs image, the gd image
  and the two caller frames (13 components after the existentials).
- The keep shape for the bystander is per-cell in the
  `NttInverseMiddleRounds192.source` form; `KeygenLevelCalls.call_frame`
  and `KeygenMakeFgSource.frame` exist but their `Outside` notion covers
  only cells before the named region's start (the walked pointers inherit
  the scratch block count), which is not enough for the gs/igm keeps.

Only executed-word semantics is in scope: no transform property, table
law, root law or positivity claim; unconditional Z>0, numerical
p_accept, conditional coding and positive p_K remain OPEN. Old110 stays
frozen; measured wording 8192/23628 with the separate 256/739 control
and the five do_sign items remain unchanged. Scoped proof, NOT_REVIEWED;
no IID/D1/F04 premise; no push (batch 4 waits for the owner's signal).
Retained failures: `KEYGEN_STEP_GS_194_FAILURES.json` (18 workshop jobs),
the inherited checkpoint192 register (58) and checkpoint193 register (4).
