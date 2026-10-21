# CRT part-3 route — obligation (b) closed, the 512-step normalize loop next

2026-10-21 (R1 normZero window). The len = 1 engines are closed:
`ZintSubWord194` (job 520) executes the pinned zint_sub leaf body at
len = 1 and exports the single limb write `subWord x p = (x - p) &&&
2147483647` (the parsed store is `w & 0x7FFFFFFF`; the old route
shorthand "the unconditional word x-p0" drops the 31-bit mask and is
WRONG at bit 31 — always compose `ZintSubWord194.subWord`, never a bare
`x - p0`) plus the borrow word `(x - p) >>> 31`; `ZintNormWord194`
(job 524) executes the pinned zint_norm_zero body at len = 1 with the
two comparison branches resolved by decidable case splits and exports
`normWord p0 x = if x < p0>>>1 then x else if p0>>>1 < x then subWord x
p0 else x`, `normImage` (the heap image), `normFlow` (`.returned none`
on both comparison returns, `.normal` on the tie path whose trailing
`u -= 1` wraps), the heap-keeps-except-x[0] frame and the void return
flow of both reached end flows. `norm_call` is the per-step engine for
the consumer call `zint_norm_zero(x, tmp, xlen)` (consumerArgs,
`normEntry`/`bind_norm`); `call_len1`/`bind_leaf` cover the inner leaf
call. Commits and the window report record the details; jobs 520/524
logs 0/0, standard three axioms (audit job 525). Next unused proof job
suffix is **526**.

## Exact remaining obligations (in order)

1. The 512-step normalize loop induction over the x walk (obligation
   (c) of the previous route): the loop of
   `zint_rebuild_CRT`'s normalize branch is `for (u = 0, x = xx; u < num;
   u ++, x += xstride) zint_norm_zero(x, tmp, xlen)` with num = 512 (the
   n cell), xstride = slen = 1 and xlen = 1, so exactly 512 iterations,
   each one `norm_call` at the walked word with the SAME p0 = tmp[0]
   (the gm scratch word stored by the `tmp[0] = primes[0].p` storePrime
   — its load is a `storePrime`/`PrimeRead` image, already transported
   by SelectedStepCrtWord194 for the table word). The caller's `x` is
   rebind per iteration by `bindPtr x xx (var xstride)`; the induction
   threads the `normImage` writes through `Word32Memory176` keeps over
   the twin fs/gs walks (512-word separation, the same per-cell
   bystander shape as StepCopyKeepCell194/StepGsCopyKeepCell194). The
   exported image is `fun i => normWord p0 (word i)` over the fs walk
   (first call) and the gs walk (second call), with the flow of the
   composed loop.
2. The `zint_rebuild_CRT` body run at xlen = 1 (the body spine is
   decide-bound by `MakeFgCrtShape194.crtBody`): the u/x declarations,
   the `tmp[0] = primes[0].p` storePrime (the `KeygenLevelCalls.PrimeRead`
   of block 21), the u = 1 init, the EMPTY co-reduction loop at xlen = 1
   (one false guard), the normalize branch (the 512-step loop above) and
   the void return flow; then both call statements of part 3
   (`MakeFgCrtShape194.first3`/`second3`, args `crtArgs "fs"/"gs"`)
   composed at the loop exit state over the named arguments.
3. Then the additional-prime part (slen 1 / tlen 2), the remaining
   d-levels and the root/certificate/codec path, before the complete
   emitted witness can instantiate the corrected KeygenProbability134
   consumers (KeygenModelUnlock194... see the report).

## Engine facts to consume (do not re-derive)

- The len = 1 step engine is `ZintNormWord194.norm_call` over
  `consumerArgs = [pointer "x" 0, pointer "tmp" 0, scalar (var xlen)]`
  with hypotheses: `before.arrays "x" = some px`,
  `before.arrays "tmp" = some pp`, `before.locals "xlen" =
  some (.uint64, some (.uint64 1#64))`, `Load32 before.heap px xw`,
  `Load32 before.heap pp pw`, `Allocated before.heap px`,
  `px.elementBytes = 4`, `before.heap.writable px.block = true` and the
  two `index+0 <= count` bounds. The result state is
  `{before with heap := normImage before px pw xw}` with value `none`.
- The tie path (x = p0>>>1) ends `.normal` with u wrapped; both strict
  comparison paths end `.returned none`. `void_flow`/`flow_shape` give
  `ReturnValue none (normFlow pw xw) none`.
- `ZintSubWord194.subWord` is the ONLY correct name for the zint_sub
  limb write at len = 1 (masked); `borrowWord` is the discarded return.
- The parse shapes are decide-bound (`sub_shape`, `norm_shape`) against
  the pinned probe-510 record; no parse probe is needed again.

---
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

## normZero body shape — read this before writing the engine (do not re-derive)

From the retained ZintCrtParseProbe194 record (job 510 stdout), the
parsed `KeygenZintCall.calleeBody .normZero` is:

- `normBody = seq normDeclC (seq normDeclU (seq normCC0 (seq normSetU
  (seq normLoopDec normFinalSkip))))` with `normDeclC` = declare u32
  [cc], `normDeclU` = declare u64 [u], `normCC0` = assign cc 0,
  `normSetU` = assign u (var len), `normFinalSkip` = word skip.
- `normLoopDec = seq (loop (u>0) loopBody (word skip)) (word (u-=1))` —
  the C post-decrement `u -- > 0` is modeled as the guard `u > 0` plus a
  `u-=1` at the body head, and the final false-guard decrement is the
  trailing `word (u-=1)` AFTER the loop (do not look for the decrement
  in the guard or the increment slot).
- `loopBody = seq (word (u-=1)) (scope [w] [] (seq decl(w:u32) (seq
  (w = (p[u]>>1)|(cc<<30)) (seq (cc = p[u]&1) (seq branch1 (seq branch2
  (word skip)))))))` with `branch1 = branch (x[u] < w) (scope [] []
  (seq retVoid (word skip))) (word skip)` and `branch2 = branch (x[u] > w)
  (scope [] [] (seq (call (leaf sub) [ptr x 0, ptr p 0, scalar (var len)]
  .discard) (seq retVoid (word skip)))) (word skip)`.
- At len = 1 the loop runs exactly one iteration (u: 1 -> 0 at the body
  head, word index u = 0), the `w` variable holds `p[0]>>>1` because
  `cc = 0` on the only iteration, and the two `retVoid` paths exit
  through `Exec.loopReturn` while the tie path falls out through the
  false guard into the trailing `u-=1`. The zint_sub leaf call at
  len = 1 is the unconditional word `x[0] = x[0]-p[0]` (the leaf body
  run is part of the engine work).
- The honest export (obligation (b)) is the executed-word image
  `normWord p0 x = if x < p0>>>1 then x else if p0>>>1 < x then x-p0
  else x` with decidable case splits on the two branch guards; the three
  cases must each carry the same heap-keeps-except-x[0] frame and the
  void return flow of the callee (check the exact
  `C99ProcedureReference.ReturnValue (result .normZero)` shape for both
  the `.returned` and `.normal` end flows against `KeygenZintCall.Call`).

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
