# BATCH_054 — certificate-execution transport across the block relocation

**B1.07: PARTIAL_PROOF / Acceptance NOT MET / NOT_REVIEWED.**
**Package: IN_PROGRESS / WORKING_NOT_FROZEN.**
2026-10-10, MiMo V2.6 Pro (`xiaomi-token-plan-ams`).
**CLOSED_AT_RECOVERABLE_MIDPOINT.** Exactly one close in this owner-started
window. B1.05/032 and B1.06/046 unchanged; B1.08/B4/B5 NOT entered.
Historical runner/session labels remain provenance.

## 1. Entry pins BEFORE edits/jobs

BATCH_015–053: **11377 distinct pins / 159 interface bindings**, no
supersession or active job, verified with the sealed 053 pair
(`bad72417…`/`84f1413c…`) into `.build/levels_054/ENTRY_PINS_054.json`
(`ebd30e83…`). All 015–053 source/product/report/failed bytes unchanged.
New proof sources use NEW modules; no inherited module is edited. The first
runner start aborted at the pre-step guard because a foreign Lean process
from another work directory was active (one computation at a time); the
abort is retained and the entry verification preceded all edits.

## 2. Exact operational scope — the certificate Exec transported

One new proof module and its generated internal audit were accepted 0/0, in
unchanged plan order (§33.1 item 1 first):

1. `KeygenMakeCertRelocation`: the certificate execution transported across
   the block relocation by the sigma=`swapBlock b` conjugation. The pinned
   certificate machine is block0-based (its `tmp` view
   `CertificateAfterConversion.workspacePointer`, its automatic flag object
   `C99Automatic32` and its `resolveLayout` block0 aliases), so a machine run
   against the general `fk->tmp` scratch at block b is exactly the conjugate
   `ExecAt b`: machine block0 reads original block b, the material pointers
   read the actual coefficient blocks and the flag object is appended to the
   scratch block. `CertBindAt b` is proven IDENTICAL to the canonical
   relocated binding (`certBindAt_iff`, both directions): the caller cells
   transport under the transposition (`cells_swap`) and the workspace bridge
   is one equality read in the two worlds (`workspaceAt_iff`).
2. `CallAt`/`CertificateGateAt` are the canonical relocated call/gate whose
   body is `ExecAt`; `callAt_run` packages an actual-world binding and
   relativized body into the actual-world call; `execAt_zero`/`execAt_swap`
   give the involution sanity theorems; the gate edge lemmas
   (`gateAt_flow`, `gateAt_no_normal`, `accepted_break_requires_callAt`,
   `retry_requires_callAt`) transport back with the profile read in the
   actual world (`profile_swapState`).
3. Every conclusion predicate reads ACTUAL-WORLD bytes: `StoredBoundsAt`
   (768 fpr words at the transported leaves slots of the actual scratch
   block), `CallerFrameAt` (the frame condition sigma-renamed: block b
   carries the workspace/automatic role block0 had), `DeadAt` (the flag
   object at `pointerAt`, appended to the scratch block) and `LegalAt`/
   `SpaceAt`/`layoutAt`, each with its transport iff back to the pinned
   predicates (`storedBoundsAt_iff`, `callerFrameAt_iff`, `deadAt_iff`,
   `legalAt_iff`, `spaceAt_iff`, `layoutAt_swap`). `wordRead_at_load64`
   links a physical 64-bit load from block b to the encoded word view;
   `foreign_block_retained_at`/`workspace_block_retained_at` are the
   actual-world byte-retention corollaries.

### Exact exported claims and REAL premises

`accepted_package_at`: from the allocation execution (`Binding`) and the
transported certificate call (`CallAt ctx.scratch.block`), with the derived
dimensions frame and the transported automatic space, the accepted package
is read in actual-world scratch-block bytes (`AcceptedPackageAt`) — NO
bridge, NO shape, NO scratch-legality and NO scratch-block input. The chain
is: allocation execution → derived shape/legality (053) → bridge discharged
by relocation (052/053) → certificate `Exec` transported (this window) →
conclusions transported back. The remaining input classes are the caller
cells (`Cells`), the dimensions frame, the certificate call execution itself
and the automatic `SpaceAt`.

## 3. Internal complete-term audit — no independent review

**One proof+audit 0/0**, unchanged runner/proof/print limits: audit entries
= new declarations + inspected inherited interfaces: **150 entries = 66 new
declarations + 84 inherited interfaces**, **132 complete terms + 18 kernel
inductives**, standard axioms only, zero elisions. Certificate interfaces
(Exec/Pinned/Call/accepted) are consumed at their pinned types or
inspected; the complete transitive closures are not re-audited. Not a
review.

## 4. Native Sage finite PUBLIC scripted controls — explicit mocks

`sage/check_keygen_make_cert_relocation.sage` (preparser, ZZ): 5 baseline
families × 4 mutations, all mutations detected: the exec conjugation table
(wrong block label, non-involutive swap, unmoved material pointer, workspace
left at block0), the workspace view/call binding (misaligned base, wrong
word count, view block0 not b, extent drift), the layout/flag transport
(flag computed from block0's size, wrong slot constant, roots slot drift,
alignment drift), the frame transport renaming (scratch block not excluded,
table block included, wrong rename direction, b colliding with a table
block) and the certificate-call transcription against the reference C
source (transcription drift, argument-order drift, workspace-argument
drift, profile-argument drift). **EXPLICIT MOCK SEMANTICS**: no real KeyGen,
sampler, solver, certificate or codec result, no private key, no probability
or law claim. These supplement, never replace, the kernel proofs.

## 5. Retained attempts and traps

All failed/aborted snapshots from this window are retained with recorded
causes: one pre-step guard abort (a foreign Lean process from another work
directory was active; the one-computation runner refused to start), two
rejected elaboration snapshots (002: `swapResult` declared as a theorem
instead of a def with its autoImplicit cascade, a reversed
`swapBlock_self_zero` citation, a `CertBind` passed where `Cells` was
expected, a reversed profile-negation transport, congrArg/simp shapes the
elaborator rejected in the gate transports, `assumption` through a
definition in `legalAt_iff`, misplaced `swapBlock_self` rewrites and wrong
`swapBlock_fixed` argument order in the frame transports, inconsistent
`load32` direction annotations in `deadAt_iff`, and `set` of the scratch
block against an elaborated application; 003: the `pointerAt_swap` simp list
omitting the `address` unfolding and the projection application
`(iff).mp space` parsing as two arguments), and two Sage runs (001: relative
reference-C path not resolving from the job directory; 002: three
check-definition defects in the controls themselves — a roots/leaves slot
confusion and two undetectable mutation phrasings). No proof/job/print limit
was raised; max RSS well below the unchanged 8GiB ceiling; no interruption
or active job at close.

## 6. Remaining B1.07 in unchanged plan order — resume 34R

1. **Same h/equations on one material witness:** solver-call h frame and the
   complete six-gate composition joining public equations, NTRU and the
   certificate witness; accepted physical material through the encoding
   tail. This is now the first remaining item.
2. **Retry frames/whole invocation:** `Initial`/legal/static transport for
   every retry instance; general typed execution, every later return and the
   gate-time `ReadTmp` tie across the search body; the full six-gate
   chronology transport over loop traces (`Sampled`/`Remaining`) is stated
   at the gate level only.
3. **Statement-machine extraction:** tying the C call site
   `(fpr *)fk->tmp` to `ExecAt` (temp_size body, `falcon_keygen_new`
   prologue, the gate call) and the actual globals/common call ID/snapshots
   composition beyond the pinned `Pinned` input. The M0 pinned transport and
   the frame retention corollaries carry the side condition that the
   transposition leaves the static table blocks alone (b not 1/2), to be
   discharged from allocation freshness at that step. Codecs remain
   B1.08/09; no IID/p_accept/availability law follows.
