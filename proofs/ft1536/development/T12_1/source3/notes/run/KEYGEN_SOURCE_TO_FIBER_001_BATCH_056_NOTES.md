# BATCH_056 — THE attempt-level spine: six gates on ONE AttemptExec

**B1.07: PARTIAL_PROOF / Acceptance NOT MET / NOT_REVIEWED.**
**Package: IN_PROGRESS / WORKING_NOT_FROZEN.**
2026-10-10, MiMo V2.6 Pro (`xiaomi-token-plan-ams`).
**CLOSED_AT_RECOVERABLE_MIDPOINT.** Exactly one close in this owner-started
window. B1.05/032 and B1.06/046 unchanged; B1.08/B4/B5 NOT entered.
Historical runner/session labels remain provenance.

## 1. Entry pins BEFORE edits/jobs

BATCH_015–055: **11570 distinct pins / 200 interface bindings**, no
supersession or active job, verified with the sealed 055 pair
(`47406731…`/`a2fdf0ee…`) into `.build/levels_056/ENTRY_PINS_056.json`
(`ad607f64…`). All 015–055 source/product/report/failed bytes unchanged.
New proof sources use NEW modules; no inherited module is edited. The entry
verification preceded all edits and jobs. The 051-window
`KeygenMakeCertAudit.lean` git/pin anomaly of BATCH_055 §1 was resolved by
the owner-signal provenance commit `c0e26975` before this window; the pinned
bytes are unchanged.

## 2. Exact operational scope — the attempt-level spine

One new proof module and its generated internal audit were accepted 0/0, in
unchanged plan order (§35.1 item 1 first):

1. `KeygenMakeAttemptSpine`: **all six gates on ONE `AttemptExec`
   derivation**. `accepted_spine` extracts the six-gate spine of a single
   accepted attempt from ONE `AttemptExec` derivation: the f/g sampler calls
   and the resultant gate (gate 1), the raw and orthogonal FPEMU norm bodies
   (gates 2/3), the public computation (gate 4), the NTRU solver (gate 5)
   and the mandatory leaf certificate call at the accepted break (gate 6).
   Every other edge is impossible on the accepted break: the early five-gate
   rejection, the certificate-rejected loop edge, the unprofiled skip (via
   the pinned `Profile` from `Dimensions`) and the normal fallthrough.
2. **Entry facts derived from the allocation**: `entry_of_allocation` derives
   the `Initial` entry facts and the loop-entry `Remaining 0` of the first
   attempt from the pinned already-ready prologue over the fresh six-array
   `Declarations` allocation; `root_legal_prepared`,
   `context_norm_prepared` and `context_public_prepared` lift the
   allocation-derived facts to the actual prepared gate state
   (`prepared`/`advanced` transports), and `entry_from_prepared` supplies the
   attempt `Entry`.
3. **The spine composition on one derivation** (`spine_witness`): gates 1-3
   supply the sampled f/g material (`ternary_material`), gate 4 the 046
   public equations on the actual caller arrays
   (`KeygenMakeMaterialWitness.public_material_equations`), gate 5 the exact
   integer NTRU equation on the same physical arrays through the solver-call
   h frame (`witness_at_solver`), gate 6 the certificate frame
   (`attempt_witness`). The result lands on the SAME physical f/g/F/G/h
   arrays of that single derivation at `Witness` (certificate-entry state)
   and `EncodingInputs` (accepted-break state), the input boundary of the
   encoding tail. `attempt_spine` states this on the `AttemptExec`
   derivation itself.

### Exact exported claims and REAL premises

`EntryFacts ctx s input h primes rev` is the spine's entry class: the
`initial` field is the allocation-derived `Initial`; the named residual
fields (legalF/legalG/legalH, `hTables`, `hProtected`, the material-block
separations `blocks`/`pubBlocks`) are the SAME class of explicit local
inputs the witness module names (`LegalWorkspace` class). The workspace
legality stays a `LegalWorkspace`-class residual at the certificate-entry
state (`attempt_spine` consumes its uniform form). The chain is now: one
accepted `AttemptExec` derivation → six-gate spine → one material with both
equations → `EncodingInputs`. The retry frames, the per-retry transport of
the entry facts and the statement-machine discharge of the residuals are the
named remaining items; these are missing source composition proofs, NOT
C/numerical counterexamples. Acceptance NOT met; Codecs B1.08/09 and B4/B5
laws stay outside.

## 3. Internal complete-term audit — no independent review

**One proof+audit 0/0**, unchanged runner/proof/print limits: audit entries
= new declarations + inspected inherited interfaces: **93 entries = 22 new
declarations + 71 inherited interfaces**, **69 complete terms + 24 kernel
inductives**, standard axioms only, zero elisions. Witness/solver/public/
certificate/chronology interfaces are consumed at their pinned types or
inspected; the complete transitive closures are not re-audited. Not a
review.

## 4. Native Sage finite PUBLIC scripted controls — explicit mocks

`sage/check_keygen_make_attempt_spine.sage` (preparser, ZZ): 5 baseline
families × 4 mutations, all mutations detected: the six-gate spine on one
attempt (gate bound to a foreign attempt, dropped solver gate, public/solver
order swap, two attempts sharing one spine), the allocation-freshness entry
(reused block, h sharing f's block, workspace block0 collision, table1
collision), the accepted-break edge (rejection counted as accept, normal
fallthrough, unprofiled skip counted as executed call, retry edge counted as
final break), the one-material chain across the gates (solver writes h,
solver writes f, f substituted, scratch write missing) and the reference-C
transcription (solver argument drift, certificate argument drift, gate-order
drift, missing certificate gate).
**EXPLICIT MOCK SEMANTICS**: no real KeyGen, sampler, solver, certificate or
codec result, no private key, no probability or law claim. These supplement,
never replace, the kernel proofs.

## 5. Retained attempts and traps

All failed snapshots from this window are retained with recorded causes:
two rejected elaboration snapshots (001: seven errors — dimensions_locals
rewrote before unfolding `Limit`, `live_tables_same` rewrote in the wrong
direction, a `protected_same` binder named a Lean keyword, the `Spine`
record was Prop-valued with data fields, `cases` patterns omitted
constructor binders and the `names_zero` bridge rewrote in the wrong
direction; 002: six type mismatches — the close-heap transport chained at
`Memory` level where a size-function equality was needed, the table
transports into `publicState` were composed in the wrong direction and the
`dimsR` locals chains mixed function equalities with pointwise
`close_locals` equalities) and one Sage run (001: the accepted-break-edge
mutations were phrased with a doubled negation that reasserted the corrupted
check, and the one-material chain wrote only the scratch block in its
written set, so its baseline failed and two mutations were misreported).
No proof/job/print limit was raised; max RSS well below the unchanged 8GiB
ceiling; no interruption or active job at close. The accepted kernel run is
003; the accepted Sage run is 002.

## 6. Remaining B1.07 in unchanged plan order — resume 36R

1. **Retry frames/whole invocation:** the solver-call h frame on the
   REJECTED edges (searchRejected/outputRejected partial writes),
   `Initial`/legal/static transport for every retry instance (the per-retry
   transport of `entry_of_allocation`), general typed execution, every later
   return and the gate-time `ReadTmp` tie; the loop-trace chronology
   transport (`Sampled`/`Remaining`) stays at the gate level.
2. **Statement-machine extraction:** tying the C call site
   `(fpr *)fk->tmp` to `ExecAt` (temp_size body, `falcon_keygen_new`
   prologue, the gate call), the actual globals/common call ID/snapshots
   composition and the b-not-1/2 side condition of the pinned transport.
   That step also discharges the residual h-side/material-block/workspace
   inputs of `EntryFacts` from allocation freshness.
3. Codecs remain B1.08/09; no IID/p_accept/availability law follows.
