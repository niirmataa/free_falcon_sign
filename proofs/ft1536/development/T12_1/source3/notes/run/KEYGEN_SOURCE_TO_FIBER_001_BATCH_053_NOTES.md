# BATCH_053 — workspace shape extraction from the allocation execution

**B1.07: PARTIAL_PROOF / Acceptance NOT MET / NOT_REVIEWED.**
**Package: IN_PROGRESS / WORKING_NOT_FROZEN.**
2026-10-10, MiMo V2.6 Pro (`xiaomi-token-plan-ams`).
**CLOSED_AT_RECOVERABLE_MIDPOINT.** Exactly one close in this owner-started
window. B1.05/032 and B1.06/046 unchanged; B1.08/B4/B5 NOT entered.
Historical runner/session labels remain provenance.

## 1. Entry pins BEFORE edits/jobs

BATCH_015–052: **11321 distinct pins / 237 interface bindings**, no
supersession or active job, verified with the sealed052 pair
(`3d50a4d3…`/`e0f9e0e5…`) into `.build/levels_053/ENTRY_PINS_053.json`
(`c39aadac…`). All015–052 source/product/report/failed bytes unchanged.
New proof sources use NEW modules; no inherited module is edited.

## 2. Exact operational scope — the allocation extraction

One new proof module and its generated internal audit were accepted 0/0,
in unchanged plan order (§32.1 item 1 first):

1. `KeygenMakeWorkspaceAllocation`: the workspace `Shape` extracted from the
   enclosing allocation execution. The pinned `falcon_keygen_new` allocation
   region (creation header, `fk = malloc(sizeof *fk)`, profile stores, the
   `fk->tmp_len`/`fk->tmp` binding block and the fpr-cast alignment comment)
   is pinned line-by-line against `Pinned.keygenLines`. `tempSizeBytes` is
   the exact reservation value (`candidates.foldl max 0`), tied to
   `CertificateWorkspace.bytes` by the052 mirror
   (`reservation_matches_workspace`). The executed binding `Binding` is the
   allocation-level execution record: the pinned `tmp_len` member store of
   that value, the `malloc` of a fresh block of exactly those bytes and the
   pointer store into the `tmp` member; the descriptor `scratchOf block` is
   the block-model `uint32_t` scratch of the reserved extent.
2. From the executed binding the extent/alignment `Shape` facts
   (`binding_shape`), the scratch legality frame `KeygenMkgm3Layout.Legal`
   (`binding_legal`) and the `tmp` member readback feeding the `ReadTmp`
   bytes premise (`binding_tmp_load`, `readTmp_of_binding`) are DERIVED.
   `Shape` and legality transport across the block swap (`shape_relocated`,
   `legal_relocated`), so `cert_bind_of_allocation`,
   `legalWorkspace_of_allocation` and `accepted_certificate_of_allocation`
   take NO `Shape`/scratch-legality input, and the relocated consumption
   `accepted_certificate_relocated_of_allocation` additionally derives the
   scratch block from the relocation theorem (`relocated_scratch_block`), so
   no block0 input remains either. `AcceptedPackage` names the consumed
   accepted-package facts (binding, syntax bound, stored bounds, caller
   frame, dead flag, 768-word gate trace, good events).

### Exact exported claims and REAL premises

The accepted-package consumption chain is now: allocation execution
(`Binding`) → derived `Shape`/legality → bridge discharged by relocation →
pinned accepted package. Remaining honest inputs at the gate are the caller
cells (`Cells`), the dimensions frame, the certificate `Call`, the base
equation and the automatic `Space`. The two remaining input classes of the
previous window are now NAMED GAPS instead of premises: (a) `Binding` is the
allocation-level execution record; extracting it from the C statement
machine (`temp_size` body, `falcon_keygen_new` prologue) is still open, in
the same class as the declaration projection; (b) the certificate execution
`Call`/`Exec` is still NOT transported across the block relocation (or
re-derived in a generalized layout), so the six-gate composition still runs
only where the block0 bridge holds.

## 3. Internal complete-term audit — no independent review

**One proof+audit 0/0**, unchanged runner/proof/print limits: audit entries
= new declarations + inspected inherited interfaces: **95 entries = 31 new
declarations + 64 inherited interfaces**, **83 complete terms + 12 kernel
inductives**, standard axioms only, zero elisions. Certificate interfaces
(Exec/initial/resolveLayout/accepted) are consumed at their pinned types or
inspected; the complete transitive closures are not re-audited. Not a
review.

## 4. Native Sage finite PUBLIC scripted controls — explicit mocks

`sage/check_keygen_make_workspace_allocation.sage` (preparser, ZZ): 4
baseline families × 14 mutations, all mutations detected: scratch descriptor
geometry (shrunk word count, fpr word view, misaligned offset, shifted
index), the temp_size binding (transcription drift against the reference C
source, tampered reservation coefficient, unaligned `tmp_len`, malloc count
drift), the legality frame extraction (undersized block, readonly block,
words beyond count) and the relocation composition (wrong block label,
non-involutive swap, assumed rather than derived block0). The binding check
reads the reference C source and requires the pinned `fk->tmp_len`/`malloc`
statements in source order. **EXPLICIT MOCK SEMANTICS**: no real KeyGen,
sampler, solver, certificate or codec result, no private key, no probability
or law claim. These supplement, never replace, the kernel proofs.

## 5. Retained attempts and traps

All failed/aborted snapshots from this window are retained with recorded
causes: a pre-step abort (the module name was passed without its `Source3.`
namespace prefix, so source resolution failed before elaboration; no
computation ran) and one rejected elaboration snapshot (`decide` on open
goals with the free block variable — replaced by closed `rfl`/`Nat.zero_mod`/
`scratch_fit` forms and `omega` with the substituted widths; the bridge
`Shape` structure left unqualified so `autoImplicit` captured it; the
`tmp_len` member readback citing the store pre-state instead of the
post-state heap — dropped in favour of the `tmp` member readback that its
own store post-state supplies). No proof/job/print limit was raised; max RSS
well below the unchanged 8GiB ceiling; no interruption or active job at
close.

## 6. Remaining B1.07 in unchanged plan order — resume33R

1. **Transport of the certificate `Exec` across the relocation** (or a
   block-generalized layout): `CertificateM0Environment.Exec`, hence
   `Call`/`CertificateGate`, so the six-gate composition runs in the
   relocated world where the bridge is derived and its conclusions transport
   back. This is now the first remaining item.
2. **Same h/equations on one material witness:** solver-call h frame and the
   complete six-gate composition joining public equations, NTRU and the
   certificate witness; accepted physical material through the encoding tail.
3. **Retry frames/whole invocation:** `Initial`/legal/static transport for
   every retry instance; general typed execution, every later return and the
   gate-time `ReadTmp` tie across the search body.
4. **Statement-machine extraction of the allocation binding** (`temp_size`
   body execution, `falcon_keygen_new` prologue) and the actual globals/
   common call ID/snapshots composition beyond the pinned `Pinned` input.
   Codecs remain B1.08/09; no IID/p_accept/availability law follows.
   Acceptance precedes capacity checks and differs from return1.

These are missing source/composition proofs, NOT demonstrated production C/
mathematical counterexamples or insufficient arithmetic estimates. B1.07
Acceptance is NOT met. Whole KeyGen/emitted-to-fiber, laws/seed quality/PRG/
security, OS/Windows/compiler/machine/CT and independent review stay outside.
