# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_059 exact types, pins and traps

2026-10-10, BATCH_059, MiMo V2.6 Pro (`xiaomi-token-plan-ams`), B1.07
statement-machine midpoint. Status: **PARTIAL_PROOF / Acceptance NOT MET /
NOT_REVIEWED / IN_PROGRESS / WORKING_NOT_FROZEN.** One close this window.
B1.05/032 and B1.06/046 unchanged; B1.08/B4/B5 NOT entered. This package
supplies rung B1 to B4/B5 under `END_TO_END_SCOPE.md`; it is not a review,
not a codec claim and not a law claim.

## 1. What this window proved (NEW module `Source3.KeygenMakeStatementMachine`)

The statement-machine extraction of the call/allocation binding with the
residual discharges from allocation freshness. Exact exports (20
declarations, all full terms, standard axioms, zero elisions):

- `allocated_of_load64` — `Allocated` follows from a 64-bit load, stated
  with a VARIABLE word index (the documented determined-index trap: `Load64`
  elimination fails on a DEFINED index such as a table word).
- `pinned_block_live` / `pinned_one_live` / `pinned_two_live` — the pinned
  FFT table environment keeps both static table blocks LIVE (blocks 1/2):
  its word loads are allocations at those blocks.
- `binding_scratch_free` — THE b-not-1/2 side condition of the pinned
  transport, DISCHARGED from allocation freshness: the executed `fk->tmp`
  binding allocates a FRESH block (zero size before the malloc) while the
  pinned environment keeps blocks 1/2 live, so the scratch block of
  `KeygenMakeWorkspaceAllocation.Binding` is neither 1 nor 2.
- `objects_table_free` — the same separation for the six automatic arrays of
  the `Declarations` allocation (freshness at every declaration).
- `allocated_same` — `Allocated` transports along the pointwise block-size
  equality (the call frame supplies pointwise, not functional, equalities).
- `scratch_extent_exact` / `scratch_extent_workspace` — the `temp_size`
  reservation of the M0 inputs spans EXACTLY the certificate workspace
  extent (the pinned candidate mirror of `KeygenMakeWorkspaceExtent`).
- `fprCast_scratch_span` — the `(fpr *)` cast of the bound scratch spans the
  remaining buffer bytes (`count = extent/8`).
- `call_site_bridge` — THE call-site tie: the `(fpr *)fk->tmp` cast of the
  bound scratch IS the certificate workspace view of the machine at the
  scratch block (composition of the `temp_size` extent with
  `KeygenMakeWorkspaceRelocation.bridge_of_extent`).
- `certBindAt_of_allocation` / `callAt_of_allocation` — the extraction: the
  caller cells plus the executed `falcon_keygen_new` binding give the
  actual-world `CertBindAt` and the gate call binds to the relativized
  `ExecAt`/`CallAt` at the ACTUAL scratch block.
- `call_same_block` — THE general call frame on a foreign block: the
  certificate body keeps every byte of any block outside the model workspace
  block0 and the static table blocks 1/2, on BOTH return values (live bytes
  through `CertificateFunctionFrame.source_frame` with the M0 table-block
  inversion `tablesOutside_nonTable`, beyond-size bytes through
  `leave_bytes`). This CLOSES the previously open `call_same_block` item.
- `cert_entry_frame` — the `CertEntryFrame` residual of the retry transport
  is DERIVED at the three entry blocks (fk object, PRIMES3, REV10) from
  `call_same_block`; no residual premise remains at the certificate leg.
- `scratch_block_of_call` — the canonical block0 numbering is forced by the
  call's own bridge field (`workspace_scratch_block`), never assumed.
- `legal_of_pointer` — the material-legality cells of the fresh arrays from
  their whole-array allocation.
- `input_of_pointer` — the input pointers are the allocation pointers.
- `entry_facts_of_allocation` — THE `EntryFacts` residual discharge from
  allocation freshness: legalF/legalG/legalH from the fresh array
  allocations, hTables/hProtected from `fresh_separate` against
  `staticLive`/scratch liveness, `blocks`/`pubBlocks` against the workspace
  block0 (through the executed binding) and blocks 1/2 (through pinned
  liveness); `initial` from `entry_of_allocation`.
- `cert_package_of_call` — the complete mandatory certificate instantiated
  at the actual caller call: pinned globals (`FftGlobalScalars.environment`
  through `FftGlobalMemory.environment`), the common call material (768-word
  gate trace and good event stream of the same call), stored leaf words, the
  bad-flag lifetime and the prefix/reverse source snapshots
  (`CertificateReverse.Snapshot`).

## 2. Retained attempts (all bytes preserved, causes sealed in the batch)

- `keygen_make_statement_machine_059_001` — first rejected elaboration
  (`Load64` determined-index elimination on the defined table word;
  direction-reversed `scratchOf` rewrite; `decide` over a free block
  variable; dropped `entered` argument; extent rewritten before `exact`;
  functional vs pointwise size equality; block0 rewrite on both sides;
  simp-normalized separations not matching the pointer projection; wrong
  accepted-package tuple order).
- `keygen_make_statement_machine_059_002` — second rejected elaboration
  (definitional fpr-cast `rfl` whnf timeout over the free block variable —
  replaced by composition of `scratch_extent`/`bridge_of_extent` with no
  arithmetic reduction; unused `snapshot` binder flagged by the linter).
- `keygen_make_statement_machine_audit_059_001` — audit elaboration
  REJECTED (unknown constant `KeygenSearchPrefix.Dimensions`, wrong
  namespace; the step record is retained and the job driver then lost its
  final RECEIPTS.json write to a harness restart — classified
  `INTERRUPTED_RETAINED` with the step record pinned).
- `keygen_make_statement_machine_sage_059_001` — scripted controls run
  REJECTED (the reference-source locator stopped one parent level short of
  the repository root; fixed to twelve levels).

Accepted jobs: `keygen_make_statement_machine_059_003` (module),
`keygen_make_statement_machine_audit_059_002` (audit),
`keygen_make_statement_machine_sage_059_002` (controls).

## 3. Pins

- Entry: `.build/levels_059/ENTRY_PINS_059.json` `c143c1db…` (11874 pinned
  files, BATCH_015-058, no supersession, no active job), verified BEFORE
  edits against the sealed 058 pair `081ac276…`/`06cc5801…`. One transient
  guard rejection before the successful verify: the parallel S05 lane's
  `gram_011` Sage run tripped the global `job.active()` probe at 21:53:19
  local; no bytes were written and the retry passed (documented here as an
  environment race, not a pin mismatch).
- Module source `formal/Source3/KeygenMakeStatementMachine.lean`
  `7f2d74b8…`; audit `formal/Source3/KeygenMakeStatementMachineAudit.lean`
  reproduced byte-exact by `tools/keygen_make_statement_machine_audit.py`
  (GENERATOR_CHECK `f9fc62e7…`).
- Audit: 181 entries = 20 new declarations + 161 inherited interfaces,
  full terms + kernel inductives, standard axioms
  (propext/Classical.choice/Quot.sound), zero elisions.
- Sage: `sage/check_keygen_make_statement_machine.sage`, 5 families × 4
  mutations (20 mutation kinds), all detected, baseline pass; **EXPLICIT
  MOCK SEMANTICS** — scripted freshness-side-condition/call-site-bridge/
  foreign-block-frame records, an EntryFacts/CertEntryFrame freshness-
  discharge presence check and an allocation/gate-call transcription check
  against the pinned reference C (`Extra/c/falcon-keygen.c`); no real
  KeyGen/solver/certificate/codec, no private key, no law claim.
- Own commits `c25b93c9` (proof), `3e4452eb` (tools) + closing pair.
  Foreign S05 commits (`80233ea4` and its working tree) preserved
  untouched. NO push / review / delegation / relay / migration / import
  this window.

## 4. Traps met and exact remaining obligations

Traps: `Load64`/determined-index elimination fails on a DEFINED index
(table words) — use a variable-index helper (`allocated_of_load64`); a
definitional `rfl` over structure-literal arithmetic with a free variable
can exceed the heartbeat budget in whnf — compose existing pinned exports
(`scratch_extent`/`bridge_of_extent`) instead of reducing; `rw` with an
equality whose LHS is a projection of a structure literal needs the
projection first normalized (`simpa [scratchOf]`); the block-size transport
must be pointwise at the block, not functional; `rw` on `← block0` rewrites
both sides of `0 < size 0` — move the hypothesis instead; unused `obtain`
binders and unused existential binders in stated types are linter errors;
generated audit producers refuse overwrite — regenerate by deleting this
window's untracked generated file only; the batch history distinguishes
`INTERRUPTED_RETAINED` (a retained step record without the driver's final
receipt) from `PRESTEP_ABORTED_RETAINED`.

Remaining B1.07 (in unchanged plan order):

1. **Whole-invocation statement-machine execution** — the call-site/`ExecAt`
   tie is now composed at the binding level (`call_site_bridge` +
   `callAt_of_allocation`); the enclosing typed expression/statement
   execution of the gate call through the actual encoding call sites, the
   output-capacity events and the complete teardown remain open. If the
   plan phrase "globals/common call ID/snapshots" intends a further
   call-identifier composition beyond the instantiated globals/common call
   material/snapshots of `cert_package_of_call`, it stays to be pinned with
   the enclosing invocation.
2. The loop-trace chronology composition of the per-retry transport (kept
   at gate level).
3. The encoding-tail codec bodies stay B1.08/09.

These are missing source composition proofs, NOT C/numerical
counterexamples. Acceptance NOT met; Codecs B1.08/09 and B4/B5 laws stay
outside.
