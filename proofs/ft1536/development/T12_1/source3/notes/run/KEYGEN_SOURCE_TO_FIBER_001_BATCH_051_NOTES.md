# BATCH_051 — sixth certificate gate, retries and foreign-block transport

**B1.07: PARTIAL_PROOF / Acceptance NOT MET / NOT_REVIEWED.**
**Package: IN_PROGRESS / WORKING_NOT_FROZEN.**
2026-10-10, GPT-6.1 Sol Fast window continued under MiMo V2.6 Pro
(`xiaomi-token-plan-ams`). **CLOSED_AT_RECOVERABLE_MIDPOINT.** Exactly one
close in this owner-started window. B1.05/032 and B1.06/046 unchanged;
B1.08/B4/B5 NOT entered. Historical runner/session labels remain provenance.

## 1. Entry pins BEFORE edits/jobs

BATCH_015–050: **10876 distinct pins / 746 literal source bindings**, no
predecessor supersession or active job, verified with the sealed050 pair
(`08c7c50c…`/`da3871b6…`) into `.build/levels_051/ENTRY_PINS_051.json`
(`c594bf1e…`). All015–050 source/product/report/failed bytes unchanged.
New proof sources use NEW modules; no inherited module is edited.

## 2. Exact operational scope — the sixth gate executes, without premises

Three new proof modules and their generated internal audit were accepted0/0:

1. `KeygenMakeCertCall`: the sixth (mandatory leaf-certificate) gate at the
   actual caller tail. Fixed source shapes (`expectedTail` position of
   `certificateGate` and the final `.breakLoop`, profile test `ter && logn==10
   && n==1536`, the seven arguments with `(fpr *)fk->tmp`) are kernel
   equalities. `CertBind` binds the actual caller cells plus the **workspace
   bridge** (`workspacePointer args.base 0 = fprCast ctx.scratch`); the bridge
   is an explicit field and the relocation derivation stays OPEN. `Call`
   executes the pinned certificate body (`CertificateM0Environment.Exec`) with
   the boolean return; no acceptance/correctness input exists. Under the
   derived profile the call is MANDATORY: an accepted break requires the
   truthy certificate return, a retry requires the falsy one, and no
   normal-flow fallthrough of the attempt body exists.
2. `KeygenMakeCertChronology`: whole-attempt chronology through ALL SIX gates.
   `AttemptExecution` = five-gate prefix plus the sixth-gate edge;
   `AttemptAccepted/AttemptRejected` are the PLAN's named exit interfaces;
   `LoopExecution/LoopSucceeded` use the loop-statement exit (accepted break
   consumed by the loop is `.normal`), `attemptCap=3000000`
   (`actual_attempt_cap`). Certificate rejection retries extend the same
   chronology: consecutive numbering, counter transport through the gate
   (callee does not write caller cells), cap bound from counter0, no normal
   full-body fallthrough, and `successful_loop_last_attempt` (rejected prefix
   ++ single accepted final).
3. `KeygenMakeCertMaterial`: the accepted call DERIVES the pinned certificate
   package at the actual call — `CertificateFunctionSyntax.Bound`,
   `StoredBounds` (the 1536 stored leaf words), `CallerFrame`, the dead `bad`
   word and 768 gate words — via `CertificateFunctionOutcome.accepted` with
   `Profile` derived from the dimensions frame and `LegalWorkspace` as the
   same explicit local input class the pinned theorem consumes. Foreign
   blocks retain their bytes through every gate edge (general `ret` frame
   from `CertificateFunctionFrame.source_frame` plus the `C99Automatic32`
   leave shape): `KeygenMaterial.Represents`, `KeygenPublicInputCells.Cell`
   and `KeygenPublicNormalizePolynomial.Represents` transport across
   certificate rejections and the accepted break. `workspace_scratch_block`
   DERIVES scratch.block=0 from the bridge field; the M0 tables (blocks 1,2)
   are excluded by an explicit inversion.

### Exact exported types and REAL premises

The full types/terms/constructors are in the audit. The gate edge exports:

```text
CertificateGate ctx before : Result → Prop
  | rejected (call : Call ctx before after v false) : ⟨after,.continueLoop⟩
  | accepted (call : Call ctx before after v true) : ⟨after,.breakLoop⟩
  | unprofiled : ⟨before,.breakLoop⟩
```

and the loop-level PLAN interfaces (`successful_loop_last_attempt`) hold over
`LoopTrace` with the `Remaining`/counter0 boundary, exactly as the050 five-
gate trace but extended through certificate rejections and the accepted
break. `Call`'s constructor carries `CertBind` including the workspace
bridge; every downstream theorem quantifies over `Call` derivations and never
assumes the bridge content.

## 3. Internal complete-term audit — no independent review

**Three proofs+audit0/0**, unchanged runner/proof/print limits: audit entries
= new declarations + inspected inherited interfaces; full terms; standard
axioms only; zero elisions. Certificate interfaces (Exec/initial/resolveLayout/
accepted/source_frame) are consumed at their pinned types or inspected; the
complete transitive closures are not re-audited. Not a review.

## 4. Native Sage finite PUBLIC scripted controls — explicit mocks

`sage/check_keygen_make_cert.sage` (preparser, ZZ): 6 PUBLIC scripted cases ×
4 mutations (counter reset after sampling, certificate writing the caller h
block, skipping the certificate gate, accepting despite a falsy return), all
mutations detected; baseline chronological shape/counter/h-retention hold.
**EXPLICIT MOCK SEMANTICS**: synthetic public bytes; no real KeyGen, sampler,
solver, certificate or codec result; no private key; no probability or law
claim. These supplement, never replace, the kernel proofs.

## 5. Retained attempts and traps

All failed snapshots from this window are retained with recorded causes
(projection depth on `Dimensions`, `prefix` as a Lean keyword binder,
index-determined constructor fields are not pattern binders, refine
placeholder on an `Or` goal, simp char-list vs `toList` normalization in
table inversion, `if_pos/if_neg` deprecations avoided, lints on unused
bindings/simp arguments). No proof/job/print limit was raised; max RSS well
below the unchanged 8GiB ceiling; no interruption or active job at close.

## 6. Remaining B1.07 in unchanged plan order — resume31R

1. **Workspace relocation:** discharge `CertBind.workspace` from source facts
   (general scratch descriptor vs block0 model). Until then the six-gate
   composition is internal to worlds where the bridge holds.
2. **SAME h/equations on one material witness:** solver-call h frame and the
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
