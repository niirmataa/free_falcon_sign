# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_061 exact types, pins and traps

2026-10-11, BATCH_061, MiMo V2.6 Pro (`xiaomi-token-plan-ams`), B1.07
virtual-legal repair + loop-chronology midpoint. Status: **PARTIAL_PROOF /
Acceptance NOT MET / NOT_REVIEWED / IN_PROGRESS / WORKING_NOT_FROZEN.**
One close this window. B1.05/032, B1.06/046 and the 059/060 statement-machine
extractions unchanged; B1.08/B4/B5 NOT entered. This package supplies rung
B1 to B4/B5 under `END_TO_END_SCOPE.md`; it is not a review, not a codec
claim and not a law claim.

Owner-ordered work this window, in order: (PUNKT PIERWSZY) the
`VirtualLegal` repair of the cross-lane catch with the full dependent
re-validation, the new trap entry and the re-pin; then the plan item (40.1
(a)): the loop-trace chronology composition of the per-retry transport with
the derivation of the `TailCells` class.

## 1. PUNKT PIERWSZY — the `VirtualLegal` repair (edited module
## `Source3.KeygenMakeInvocation`, re-pinned)

The finding (S05 lane, `notes/ROM_INVOCATION_AUDIT_017.md`, kernel witness
`formal/BoundedAddressObstruction017.lean`): the 060 shape of `VirtualLegal`
quantified BOTH fields over ALL `Nat` block identifiers —

    bounded : ∀ block, vb block<2^64
    distinct : ∀ b c : Nat, vb b=vb c → b=c

— an injection `Nat → Fin (2^64)`, unsatisfiable by pigeonhole. Every
consumer of the class was therefore vacuous: the `Invocation.encoded`
branch (its `legal` field), the success paths of
`invocation_gate`/`invocation_certificate`, and the write-then-read
pointer tie `small_site_material`. The repair (owner instruction
2026-10-11):

- `VirtualLegal live vb` now constrains the map ONLY on a finite set of
  live blocks (`bounded`/`distinct` restricted to `block∈live`); the map
  is unconstrained outside. `Env.live` is the live-block set of one
  invocation: the six automatic-object blocks, the five external argument
  objects (`fk`, `privkey`, `privkey_len`, `pubkey`, `pubkey_len`) and the
  two fk-context objects (fk object and scratch) — 13 blocks
  (`blocks_mem_live`, `inputOf_mem_live`, `publicOf_mem_live`,
  `skePtr_mem_live` place every invocation block in the set).
- The pointer-uniqueness proofs are TRANSFERRED: `canonical_word_eq`,
  `read_unique` and `small_site_material` hold for canonical pointers
  whose blocks are live; `small_site_material` gains the honest side
  condition `site.src.block∈env.live` (a downstream derivation of that
  liveness from the write-then-read history of the `ske` cells stays with
  the codec persistence item, B1.08).
- The class is ACHIEVABLE again: `virtualLegal_identity` (the identity map
  on any finite set of sub-2^64 blocks) and `virtualLegal_exists` — the
  `Invocation.encoded` premise is satisfiable, no longer vacuous.
- The trap is pinned kernel-side IN the repaired module:
  `no_global_virtual_legal` refutes the unqualified all-`Nat` shape by
  pigeonhole (`not_injective_infinite_finite` over `Nat → Fin (2^64)`),
  mirroring the S05 witness (read-only cross-lane pin, not imported).
- `Invocation.encoded`'s `legal` field is `VirtualLegal env.live env.vb`;
  `invocation_flow`/`invocation_teardown`/`invocation_gate`/
  `invocation_certificate` re-elaborated unchanged in statement.

Re-pin (recorded in the batch receipt `superseded` map and PRESEAL): the
060 pins `c644d0ed…` (source) / `73f6a844…` (cache artifact) of
`KeygenMakeInvocation.lean` are superseded by `bee3984b…` / `d10ea529…`
with the repair reason bound. The sealed BATCH_060 pair
(`645f3111…`/`d4a5a41a…`) and the 060 job snapshots keep the 060 bytes
byte-exact; this window's entry pins (`.build/levels_061/ENTRY_PINS_061.json`,
`73aba5d6…`, 12050 files, BATCH_015-060) were verified BEFORE any edit.

## 2. What this window proved (NEW module `Source3.KeygenMakeLoopChronology`)

THE loop-trace chronology composition of the per-retry entry transport,
composed with the derivation of the `TailCells` tail-entry class across
rejected attempts. Exact exports (35 declarations, all full terms, standard
axioms, zero elisions):

- Prologue state cells: `ready_arrays_object` (the declaration allocation
  binds every automatic-object name to its fresh block pointer),
  `ready_arrays_other`/`ready_comp` (other array/scalar cells unchanged),
  `ready_logn`/`ready_ter`/`ready_limit`/`ready_dimensions` (the prologue
  `logn=10`/`ter=1`/`n=1536` profile cells under the pinned M0 profile,
  via `C99CountedWords.convert_self`).
- Per-attempt preservation: `attempt_arrays` (every array cell outside
  `rt1/2/3` survives one whole attempt on every return edge: sampler setup
  rebinds only the runtime scratch names, the five-gate prefix preserves
  the slot map (`KeygenAttemptSlots.Slots`/`ternary_slots`), the scope
  close restores only `norm`/`bound`/rt-names, the certificate gate keeps
  every cell (`gate_cells`)); `attempt_comp`; `attempt_tail_cells` (the
  whole `TailCells` class survives one attempt: cells by `attempt_arrays`,
  `comp` by `attempt_comp`, `logn`/`ter` by the advanced `Remaining`
  instance of the attempt).
- Loop-trace chronology composition: `loop_tail_cells` (a whole
  `LoopTrace` carries `TailCells` from the loop entry to the loop output on
  the successful edge, through every rejected attempt instance) and
  `loop_retry_entry` (the fold of the per-retry `Initial`/legal/static
  transport with the entry frame and the advanced counter
  `i+attempts.length` to the loop output).
- `TailCells` derivation: `entry_tail_cells` (the class at the loop entry:
  the external argument cells and `comp` from the executed argument
  binding, the `logn`/`ter`/`n` prologue cells, the six automatic-object
  cells from the declaration allocation, all through the readiness gate
  call), `entry_dimensions`/`entry_remaining` (the `Remaining 0`
  loop-entry instance), `tail_cells_of_loop` (THE derivation across
  rejected attempts landing the class at the accepted-break state — the
  encoding-tail entry) and `loop_tail_entry` (the composed export: tail
  cells + transported `Initial` + advanced `Remaining` + entry frame at the
  accepted-break state).

`TailCells` remains the named explicit input class of
`Invocation.encoded` (060); this window DERIVES it from the entry facts +
the loop chronology (`tail_cells_of_loop` consumes `original`/`binding`/
`readyPrefix`/`loop`/`succeeded` — the same inputs the constructor has,
plus the M0-profile entry fact `KeygenMakeEntry.Original` in the style of
`entry_of_allocation`).

## 3. Dependent-proof re-validation record

The 061 internal audit (`KeygenMakeLoopChronologyAudit`, producer
`tools/keygen_make_loop_chronology_audit.py`) re-checks ALL declarations of
both modules plus the consumed earlier-batch interfaces: **213 entries =
93 declarations + 120 inherited interfaces; 171 full terms + 42 kernel
inductives; standard axioms (`propext`/`Classical.choice`/`Quot.sound`),
zero elisions**. This covers every consumer of `VirtualLegal`/
`Invocation.encoded` (`canonical_word_eq`, `read_unique`,
`small_site_material`, `Invocation`, `invocation_flow`,
`invocation_teardown`, `invocation_gate`, `invocation_certificate`,
`CertPackage`). Earlier-batch scan: NO earlier module consumes
`VirtualLegal`/`Invocation.encoded` and NO earlier module carries the
all-`Nat` legality pattern (the only earlier consumer is the sealed 060
audit module, preserved byte-identical as history); the earlier-batch
INHERITED closure is re-checked by the 061 audit entries. Native Sage
scripted PUBLIC controls: 5 families×4 mutations, all detected (EXPLICIT
MOCK SEMANTICS; the transcription reads the reference C attempt-loop/
encoding-tail region; no real KeyGen/solver/certificate/codec, no law
claim).

## 4. Retained attempts (all bytes preserved, causes sealed in the batch)

- `keygen_make_invocation_legal_061_001` — guard rejection at PREFLIGHT
  (a foreign Lean process from `work/FT1536_PREMISE_AUDIT_20261011_001`;
  environment race, no source bytes); retried as `_slot_retry_001`.
- `keygen_make_invocation_legal_061_001_slot_retry_001` — first rejected
  elaboration of the repair (the Fin map ascription in the trap
  refutation, `congrArg Fin.val` on the named map, two unused lambda
  binders).
- `keygen_make_loop_chronology_061_001` — first rejected elaboration
  (unused simp arguments, prologue-cell ite chains, `Eq.elim` misuse, the
  reserved-word `prefix` binder clash, `induction`/`cases` binder slots,
  the entry-frame first-state binder).
- `keygen_make_loop_chronology_061_002` — second rejected elaboration
  (`prepared_local` namespace, explicit `convert_self` values,
  index-filling constructor arguments bind nothing under `cases`, the
  9-name `Prefix.run` alternative).
- `keygen_make_loop_chronology_061_003` — third rejected elaboration (the
  `ready_arrays_other` disequalities at the evaluated char-list normal
  form).
- `keygen_make_loop_chronology_audit_061_001` — rejected generated audit
  (stale `KeygenMakeSampling.prepared_local` in INHERITED; producer fixed,
  rejected artifact retained in the job snapshot).
- `keygen_make_loop_chronology_sage_061_001` — job aborted at source copy
  (redundant `sage/` prefix in the runner argument; no source bytes).
- Accepted: `keygen_make_invocation_legal_061_003`,
  `keygen_make_loop_chronology_061_004`,
  `keygen_make_loop_chronology_audit_061_002`,
  `keygen_make_loop_chronology_sage_061_002`.
- Slot waits (pinned in `slot_waits`): the shared proof slot was held by
  the parallel lane's long S05 row campaign for most of the window; one
  background wait-runner shell was killed while waiting (relaunched with a
  fresh label) and one own-vs-own `JOB.lock` race burned the
  `keygen_make_invocation_legal_061_002` label (no source bytes). All are
  environment races per the handoff note, not pin mismatches.

## 5. NEW trap entry — the impossible-premise class (unbounded quantifiers)

TRAP: a premise class quantified over ALL `Nat` blocks / ALL `State`s is
unsatisfiable, and compiling conditional theorems does NOT test premise
consistency — consumers silently become vacuous. TWO confirmed instances:

1. `VirtualLegal` (060) — all-`Nat` bounded injective address map;
   kernel-refuted by the S05 witness and now by the in-module
   `no_global_virtual_legal`. REPAIRED here (finite live set).
2. `KeygenMakeSearchPrefix.Dimensions` over all `State`s — the
   `invocation_certificate` premise `(s : State) → Dimensions s` is
   refuted by the S05 kernel lemmas `empty_locals_not_dimensions`/
   `no_global_dimensions` (`formal/GlobalDimensionsObstruction017.lean`,
   commit `ef354c48`, landed mid-window; read-only cross-lane pin). The
   same shape likely applies to its `(s : State) → LegalWorkspace s ctx`
   premise. NOT repaired here (owner scope named VirtualLegal): the
   reachable-state replacement is exactly this window's export class —
   `entry_dimensions`/`loop_tail_entry`/`tail_cells_of_loop` derive
   `Dimensions`/`TailCells` at the reachable loop/attempt states (the
   attempt-level `Remaining` transport reaches the certificate-gate state
   via `sampled_remaining`). Next-window obligation, see §6.

Rule going forward: legality/readiness classes must be restricted to
reachable or finite-live domains, and every premise class of a success
branch gets an achievability witness (`virtualLegal_exists`-style) before
the branch is consumed downstream.

## 6. Open obligations (honest, named)

- The `invocation_certificate` global-premise repair: replace
  `(s : State) → Dimensions s` (and the matching `LegalWorkspace`
  quantifier) with the reachable-state derivations (`Remaining`
  transport to the certificate-gate state + this window's exports);
  kernel obstruction pinned by the S05 lane. The theorem is sound as a
  conditional; its success premise is currently uninhabited.
- The `small_site_material` side condition `site.src.block∈env.live`: a
  downstream derivation from the write-then-read history of the `ske`
  cells (rather than the readable-word hypothesis) belongs to the codec
  persistence item.
- The codec bodies and their write frames are B1.08/09: the exact encoded
  lengths, the persistence of the stored length words and of the source
  arrays through later encoder calls, and the bytewise round-trips.
- Residue pin of the plan phrase "globals/common call ID/snapshots": the
  globals, snapshots, bad-flag lifetime and shared call material are
  instantiated (`cert_package_of_call`) and tied to the same invocation
  (`invocation_certificate`); if the phrase intends an EXPLICIT identifier
  value beyond the shared derivation, that composition stays OPEN with its
  intended shape.

These are missing source composition proofs, NOT C/numerical
counterexamples. Acceptance NOT met; B1.08/B4/B5 stay outside.

## 7. Pins

- Entry pins verified BEFORE edits: `.build/levels_061/ENTRY_PINS_061.json`
  `73aba5d6…` (12050 files, BATCH_015-060, from the sealed 060 pair
  `645f3111…`/`d4a5a41a…`).
- Re-pin (supersession, bound in PRESEAL `11f59cdd…` and the batch
  receipt): `KeygenMakeInvocation.lean` `c644d0ed…`→`bee3984b…`, cache
  artifact `73f6a844…`→`d10ea529…`.
- Repaired module job: `keygen_make_invocation_legal_061_003`; new module
  job: `keygen_make_loop_chronology_061_004`; audit job:
  `keygen_make_loop_chronology_audit_061_002` (213 entries); controls:
  `keygen_make_loop_chronology_sage_061_002` (5×4, all detected).
- Own commits `e1f409ba` (proof), `73134f1b` (tools) + closing pair;
  foreign S05 commits and working tree preserved. No push (owner signal
  required), no review, no stages import.
