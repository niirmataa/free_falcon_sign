# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_057 exact types, pins and traps

2026-10-10, BATCH_057, MiMo V2.6 Pro (`xiaomi-token-plan-ams`), B1.07
retry-frame midpoint. Status: **PARTIAL_PROOF / Acceptance NOT MET /
NOT_REVIEWED / IN_PROGRESS / WORKING_NOT_FROZEN.** One close this window.
B1.05/032 and B1.06/046 unchanged; B1.08/B4/B5 NOT entered. This package
supplies rung B1 to B4/B5 under `END_TO_END_SCOPE.md`; it is not a review,
not a codec claim and not a law claim.

## 1. What this window proved (NEW module `Source3.KeygenMakeRetryFrames`)

The rejected-edge half of the retry-frame item: the solver-call frame on
EVERY edge of the solver gate, with the public h block as the consumed
instance.

Exact exports (11 declarations, all full terms, standard axioms, zero
elisions):

- `writesOnly (names : List Name) : KeygenSmallSource.Stmt → Bool` — the
  write-footprint check of the small conversion body: `modular`
  sub-statements must be `C99ModularFrame.readOnly`, `plain` calls write
  only locals, `store16` writes only the named destinations.
- `small_frame (names block offset) (code before out) (_source :
  KeygenSmallSource.Exec code before out) (checked : writesOnly names
  code=true) (outside : ...)` : `out.state.arrays=before.arrays ∧
  out.state.heap.bytes block offset=before.heap.bytes block offset` — a
  checked small body keeps every byte outside the destination bindings and
  keeps the array map. The loop case is the rejected-edge core: a
  `loopReturn` (conversion aborted mid-loop) still keeps the footprint
  because the partial `store16` chain writes only `element dst i` words.
- `writes_gate_code : writesOnly ["d"] KeygenSmallSource.code=true`.
- `call_bytes (ctx) (second) (bigF bigG) (before after) (v) (m0 :
  ctx.ternary=1) (caller : KeygenOutputGateBounds.Caller before bigF bigG)
  (source : KeygenOutputGateSource.Call ctx (arguments second) before after
  v) (block) (sepF) (sepG)` : `∀ offset, after.heap.bytes block
  offset=before.heap.bytes block offset` — one `poly_big_to_small` call
  keeps every byte outside its destination block (the bound `d` parameter,
  `F` or `G`), through `KeygenOutputGateBounds.binding_entry` and
  `small_frame` with names `["d"]`.
- `negate_call` — a negated call evaluation executes exactly one conversion
  call (mirror of the pinned `negate_call_false`, any flag).
- `failed_guard_bytes` / `passed_guard_bytes` — the guard evaluations keep
  every byte outside F/G: the short-circuit rejection runs at most one
  (partial) F conversion, the two-call rejection may also leave a partial G
  column, the passing guard runs both.
- `gate_frame (ctx) (bigF bigG) (before out) (m0) (caller) (source :
  KeygenOutputGateSource.Exec ctx before out) (block) (sepF) (sepG)` — THE
  gate bytes frame on every edge. The failed edge uses
  `KeygenSmallStep.reject_result` (the `return 0` body is
  state-preserving: `out=⟨middle,abortFlow⟩`).
- `validation_frame (ctx) (before out) (input) (primes rev) (entry :
  KeygenRootValidation.Entry ctx before input primes rev) (source :
  KeygenRootValidationSource.Exec ctx before out) (block) (separate :
  block≠ctx.scratch.block)` : `SameBlock before.heap out.state.heap block` —
  the four-leg validation suffix frame (generation via
  `KeygenMkgm3Frame.outside_bytes`, conversion trace via
  `KeygenMakeMaterialWitness.trace_bytes`, transform sequence via
  `KeygenSolverValidation.sequence_frame`, read-only final check via
  `KeygenSolverValidation.read_only_heap`) re-derived from the RAW
  `KeygenRootValidationSource.Exec` legs with NO accepted-flow premise —
  this is `KeygenMakeMaterialWitness.validation_record_same` at source
  level, so the zero-return validation edge is covered.
- `solver_frame (ctx) (before after) (v) (input) (_h primes rev) (legal :
  KeygenRootCaller.Legal ctx before input primes rev) (source :
  KeygenRootSource.Call ctx before after v) (block) (protectedBlock :
  KeygenRootSearch.Protected ctx before block) (sepF : block≠(input
  2).block) (sepG : block≠(input 3).block)` : `SameBlock before.heap
  after.heap block` — THE solver-call frame on EVERY edge: `searchRejected`
  (search frame + stability), `outputRejected` (search frame + failed gate
  frame + state-preserving return-0 body), `validated` (search frame +
  passed gate frame + validation frame on either return).
- `solver_h_frame` — the named instance: the solver-call h frame on EVERY
  edge, the rejected edges (partial output-gate writes included) keeping
  every byte of the public h block, from `hProtected` + `hBigF` + `hBigG`.

## 2. Retained attempts (all bytes preserved, causes sealed in the batch)

- `keygen_make_retry_frames_057_001..005` — five rejected elaboration
  snapshots (induction motive rebinding, `Pointer.add` case arity,
  determined-index case binders (`before` is not a binder), export
  namespace (`KeygenRootValidation.ready_caller`), reversed separations,
  `refine` metavariable assignment of the `Caller.table` field, the
  determined `v` binder of `Evaluate.second`). All causes sealed in
  `CAUSES`.
- `keygen_make_retry_frames_057_006` — prestep aborted on a stale source
  cache entry left by the diagnostic `ProbeEvaluate` scratch module (two
  probe runs, retained under their own job directories). The cache entry
  was removed canonically (canonical `CACHE_INDEX.json` maintenance, no
  frozen byte touched) and the probe source deleted; run 007 built clean.
- `keygen_make_retry_frames_audit_057_001/002` — audit generation
  rejections (constructor names are bodyless for the audit template).
- `keygen_make_retry_frames_sage_057_001..003` — three retained FAIL runs
  of the scripted controls (verbatim multi-line needle absent from the
  reference C; four mutation conventions wrong — vacuous dropped-edge
  check, non-destination block in the partial-write baseline, validated-0
  edge not required by the edge set, whole-file rejection needle surviving
  the drift; rejection drift detected through a later `return 0;`). The
  corrected run 004 is the accepted one.

Accepted jobs: `keygen_make_retry_frames_057_007` (module),
`keygen_make_retry_frames_audit_057_003` (audit),
`keygen_make_retry_frames_sage_057_004` (controls).

## 3. Pins

- Entry: `.build/levels_057/ENTRY_PINS_057.json` `8b6ae474…` (11642
  pinned files, BATCH_015-056, no supersession, no active job), verified
  BEFORE edits against the sealed 056 pair `9704cfff…`/`4ca62477…`.
- Module source `formal/Source3/KeygenMakeRetryFrames.lean`; audit
  `formal/Source3/KeygenMakeRetryFramesAudit.lean` reproduced byte-exact
  by `tools/keygen_make_retry_frames_audit.py` (GENERATOR_CHECK
  `c5e33ac4…`).
- Audit: 100 entries = 11 new declarations + 89 inherited interfaces,
  full terms + kernel inductives, standard axioms
  (propext/Classical.choice/Quot.sound), zero elisions.
- Sage: `sage/check_keygen_make_retry_frames.sage`, 5 families × 4
  mutations (20 mutation kinds), all detected, baseline pass; **EXPLICIT
  MOCK SEMANTICS** — scripted rejected-edge/partial-write/footprint/
  edge-coverage records plus a conversion/rejection transcription check
  against the pinned reference C (`Extra/c/falcon-keygen.c`); no real
  KeyGen/solver/certificate/codec result, no private key, no law claim.
- Own commits `4e0128c3` (proof), `d9c551c0` (tools) + closing pair.
  Foreign commit `a068d1ff` preserved untouched. NO push / review /
  delegation / relay / migration / import this window.

## 4. Traps met and exact remaining obligations

Traps: the `cases`-with alternatives silently skip binder names for
determined constructor arguments (the `before` of `Evaluate` and the `v`
of `second`) — name them at your own risk; `Pointer.add` patterns bind
seven names; `Eq` transports of array maps go `rw [← eq]` inside the
binding; the audit template rejects constructors as inherited exports.

Remaining B1.07 (in unchanged plan order):

1. **Retry transport** — the `Initial`/legal/static transport for every
   retry instance (the per-retry transport of `entry_of_allocation` across
   the whole attempt), general typed execution, every later return and the
   **gate-time `ReadTmp` tie** from the executed `fk->tmp` binding
   (`KeygenMakeWorkspaceAllocation.readTmp_of_binding` transported through
   the attempt frames); the loop-trace chronology transport stays at the
   gate level. The solver edge needed here is now available as
   `solver_frame` at any protected block (instance at `ctx.object.block`
   via `contextScratch`/`contextTables`/`contextSeparate`).
2. **Statement-machine extraction** — tying the C call site
   `(fpr *)fk->tmp` to `ExecAt` (temp_size body, `falcon_keygen_new`
   prologue, the gate call), the actual globals/common call ID/snapshots
   composition and the b-not-1/2 side condition of the pinned transport;
   that step also discharges the residual h-side/material-block/workspace
   inputs of `EntryFacts` (legalF/legalG/legalH, hTables, hProtected,
   blocks, pubBlocks) from allocation freshness.
3. Whole-invocation material to the actual encoding call sites, output
   capacity events and complete teardown; the encoding-tail codec bodies
   stay B1.08/09.

These are missing source composition proofs, NOT C/numerical
counterexamples. Acceptance NOT met; Codecs B1.08/09 and B4/B5 laws stay
outside.
