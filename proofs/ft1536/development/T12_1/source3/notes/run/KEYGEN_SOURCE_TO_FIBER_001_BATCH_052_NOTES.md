# BATCH_052 — workspace relocation, bridge discharge and extent witness

**B1.07: PARTIAL_PROOF / Acceptance NOT MET / NOT_REVIEWED.**
**Package: IN_PROGRESS / WORKING_NOT_FROZEN.**
2026-10-10, MiMo V2.6 Pro (`xiaomi-token-plan-ams`).
**CLOSED_AT_RECOVERABLE_MIDPOINT.** Exactly one close in this owner-started
window. B1.05/032 and B1.06/046 unchanged; B1.08/B4/B5 NOT entered.
Historical runner/session labels remain provenance.

## 1. Entry pins BEFORE edits/jobs

BATCH_015–051: **11149 distinct pins / 126 literal source bindings**, no
supersession or active job, verified with the sealed051 pair
(`87d0f645…`/`88c112f7…`) into `.build/levels_052/ENTRY_PINS_052.json`
(`bd2d5a2d…`). All015–051 source/product/report/failed bytes unchanged.
New proof sources use NEW modules; no inherited module is edited.

## 2. Exact operational scope — workspace relocation and the bridge

Four new proof modules and their generated internal audit were accepted 0/0,
in unchanged plan order (§31.1 item 1 first):

1. `KeygenMakeWorkspaceRelocation`: the block transposition `swapBlock`/`swap`/
   `swapPtr` that moves the general `fk->tmp` scratch descriptor into the
   certificate model's block0. The byte machine is an isomorphism: `Allocated`,
   `Load64/32`, `Store64/32`, `Memcpy`, `Initialized`, `Preserves` and `Steps`
   are preserved AND reflected (`*_swap` iff lemmas), and `fprCast`/
   `workspacePointer` transport. The bridge is characterized componentwise:
   `workspacePointer base 0 = fprCast p ↔ p.block=0 ∧ base=ArrayPointer.offset p
   ∧ extent p/8=35840` (`bridge_iff`), and after relocation the block condition
   is DERIVED (`relocated_scratch_block`) so the bridge becomes exactly the
   extent condition (`bridge_relocated`, `bridge_of_extent`). No bridge
   equality, scratch block fact or certificate outcome is a premise.
2. `KeygenMakeWorkspaceBridge`: the caller binding assembled from source
   facts. `Shape` (exact fpr-cast extent 286720 bytes, 8-alignment) and `Cells`
   (the seven caller cell bindings plus `ReadTmp`) replace the bridge field:
   `cert_bind_of_source` derives `CertBind` in a block0 world, and
   `cert_bind_relocated` derives the FULL `CertBind` in the canonical relocated
   world with NO bridge input at all. State/context/argument relocation
   (`swapState`/`relocateCtx`/`swapArgs`) transports `Bound`, `ObjectLegal`,
   `PointerLegal`, `ReadTmp` and all cells; `pointerWord` is relocation
   invariant. `legal_of_shape`/`legalWorkspace_of_shape` derive
   `CertificateFrameEntry.Legal` and the pinned `LegalWorkspace` input class
   from the same source facts, and `accepted_certificate_source` consumes the
   accepted certificate package with the bridge discharged.
3. `KeygenMakeWorkspaceTables`: the M0 table-block inversion that stayed OPEN
   in051 is now closed with clean logs: the pinned `FftGlobalMemory.tables`
   dispatch puts the static tables exactly in blocks 1 and 2 (`tables_block`,
   split inversion, no char-list simp noise), so `TablesOutside` holds on
   every other block (`tablesOutside_nonTable`, `tablesOutside_zero`). The
   general same-block call frame is consumed on `CallerFrame` for any live
   foreign block (`foreign_block_retained`), including workspace block0
   (`workspace_block_retained`).
4. `KeygenMakeWorkspaceExtent`: the workspace-extent source witness. The
   pinned `temp_size` reservation block (`(22*n + 4*(n/3))*sizeof(fpr)` at
   `n = MKN(logn,1)`, folded into `gmax`), every candidate assignment of the
   body, the per-depth fold, `return gmax`, and the `fk->tmp_len = temp_size(…)`
   / `fk->tmp = malloc(fk->tmp_len)` lines are literal kernel pins against
   `Pinned.keygenLines`. The candidate mirror at (logn=10, ternary=1) has 60
   candidates; kernel-checked (`decide +kernel`): the certificate candidate is
   a member, every candidate is bounded by it, and the fold maximum equals it
   and `CertificateWorkspace.bytes` = 286720 (`reservation_matches_workspace`).
   The mirror transcribes the pinned source statements line by line; the
   transcription is additionally checked by the native Sage control against
   the REFERENCE C source (`Extra/c/falcon-keygen.c`).

### Exact exported claims and REAL premises

The bridge is no longer an input where the source facts hold: `Cells` +
`Shape` (+ block0, or its relocation derivation) construct `CertBind`; the
accepted package consumption (`accepted_certificate_source`) takes only
`Cells`-level caller facts, `Shape`, the scratch legality frame and automatic
space. The two remaining inputs are honest and named: (a) `Shape` is still an
explicit allocation-shape input (its derivation from the enclosing allocation
execution is open), and (b) the certificate execution `Call`/`Exec` itself is
unchanged and NOT yet transported across the block relocation. Until (b) is
done, the discharged bridge composes inside the relocated world only as a
binding statement; the six-gate composition still quantifies over worlds
where the block0 bridge holds.

## 3. Internal complete-term audit — no independent review

**Four proofs+audit 0/0**, unchanged runner/proof/print limits: audit entries
= new declarations + inspected inherited interfaces: **182 entries = 127 new
declarations + 55 inherited interfaces**, **166 complete terms + 16 kernel
inductives**, standard axioms only, zero elisions. Certificate interfaces
(Exec/initial/resolveLayout/accepted/source_frame) are consumed at their
pinned types or inspected; the complete transitive closures are not
re-audited. Not a review.

## 4. Native Sage finite PUBLIC scripted controls — explicit mocks

`sage/check_keygen_make_workspace.sage` (preparser, ZZ): 4 baseline families ×
9 mutations, all mutations detected: bridge componentwise characterization
(block perturbation, relaxed extent), relocation swap (non-involutive swap,
scratch not relocated), temp_size extent (transcription drift against the
reference C source, tampered/shrunk reservation coefficient) and the
table-block inversion (table moved into the workspace block). The temp_size
check reads the reference C source and compares its candidate assignments
with the mirror; it also recomputes the reservation value 286720 in ZZ.
**EXPLICIT MOCK SEMANTICS**: no real KeyGen, sampler, solver, certificate or
codec result, no private key, no probability or law claim. These supplement,
never replace, the kernel proofs.

## 5. Retained attempts and traps

All failed snapshots from this window are retained with recorded causes:
whole-memory equalities vs function-field equalities, projection parenthesis
slips in `swapPtr` applications, single-instance `rw` matching inside
`Memcpy` copy frames, structure-instance literals with projection values that
would not parse in this toolchain (fixed by explicit constructor/`where`
forms), `Option.some.inj` equality orientation, an extra split branch after
the none inversion, `omega` through nonlinear `elementBytes*count` products
(fixed by substituting the pinned width first), the unused-simp-argument lint
(which is an error here), goals closed early by `rw` followed by a trailing
tactic, and a non-Decidable `List.maximum` formulation (replaced by the
equivalent fold). No proof/job/print limit was raised; max RSS well below the
unchanged 8GiB ceiling; no interruption or active job at close.

## 6. Remaining B1.07 in unchanged plan order — resume32R

1. **Shape from the enclosing allocation:** derive the `Shape` extent/
   alignment facts from source execution (the `temp_size` reservation is now
   exact; the `fk->tmp_len`/`malloc` binding extraction remains) and the
   scratch block from the relocation theorem instead of an input.
2. **Same h/equations on one material witness:** solver-call h frame and the
   complete six-gate composition joining public equations, NTRU and the
   certificate witness; accepted physical material through the encoding tail.
3. **Retry frames/whole invocation:** `Initial`/legal/static transport for
   every retry instance; general typed execution and every later return.
4. **Actual globals/common call ID/snapshots** composition beyond the pinned
   `Pinned` input. Codecs remain B1.08/09; no IID/p_accept/availability law
   follows. Acceptance precedes capacity checks and differs from return1.

These are missing source/composition proofs, NOT demonstrated production C/
mathematical counterexamples or insufficient arithmetic estimates. B1.07
Acceptance is NOT met. Whole KeyGen/emitted-to-fiber, laws/seed quality/PRG/
security, OS/Windows/compiler/machine/CT and independent review stay outside.
