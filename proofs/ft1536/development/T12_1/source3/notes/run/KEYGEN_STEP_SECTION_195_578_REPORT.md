# R1: complete forward image and additional-prime section (window 578)

Date: 2026-10-26. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**.
The requested window scope is COMPLETE: the full forward call-frame
image, concrete productFd/productGd composition, false !out_ntt skip,
loop composition and part-4 section export at the actual CRT exit.

WYKONANE: sixteen new Lean modules across two canonical phases, including
two type/axiom audits; evidence, retained attempts and WORK_STATE.
PRZETESTOWANE: **16/16 canonical module runs accepted**, diagnostics
**0 errors / 0 warnings**, warningAsError, forbidden markers [].
NIEZALEZNIE ODEBRANE: NOT_RUN / NOT_REVIEWED. No subagent or reviewer.
No push, stages import, migration or production C change.

This is an additive completion supplement to
KEYGEN_STEP_FORWARDIMAGE_195_578_REPORT.md and its unchanged evidence.
The owner explicitly instructed continuation to completion after that
intermediate checkpoint. Its proposed context freeze and OPEN integration
list are historical; the obligations below are now discharged.

## What the completed theorem says

`StepAddSection195.source` has NO caller-supplied execution or image
hypothesis. It constructs the SAME sequence of actual states for:

```
SelectedStepMove187.after
  -- part .step 2 --> after2
  -- part .step 3 --> after3 (actual CRT exit)
  -- part .step 4 --> out
```

The same out has u=2 and BOTH exact additional-prime product images:
fd[1+2*v] and gd[1+2*v], for every v<256. The input fs/gs families are
`StepAddConcrete195.inputF/inputG`: the executed normalized CRT words of
the earlier source chain. Each product image uses the corresponding
512-word modular-reduction march, the COMPLETE forward executed-word
image and the two nested source Montgomery products with r21. Both NTTs
use the same loaded gm family constructed at the actual u=1 generator
output. These are recursive executed words; no root/table law or
closed-form spectral identity is introduced.

`StepNttForwardImage195.complete_image/call_image` from the first phase
construct all 512 forward output words at logn=9/full=0/stride=1, through
the first pass, eight counted doubling rounds and skipped triple pass,
then execute the actual seven-argument call binding and heap return to
the caller. This complete image feeds the concrete product loops through
the job-577 literal-read bridge and the source-image invariants; no target
execution or resulting image is assumed by the final section export.

## How the section is connected

- StepMemoryInit195 proves initialization monotonicity through actual
  modular, word, zint, level, binary, top and make helper executions.
  Initialization is preserved as a property of writes, not as a callee
  oracle or an assumed output-domain fact.
- StepAddEntry195 extends the existing CRT source construction with
  locals/arrays/tables projections. Abstract Memory projection bridges
  avoid normalizing nested concrete walk heaps. The canonical table
  lookup equality uses the accepted prepared-state and conversion/public
  frames plus kernel computation of the finite ready table list.
- StepAddConcrete195.entry uses determinism to bind the CRT construction
  to the accepted first-prime exit facts. It derives every Entry field:
  cells, pointer bindings, allocations, writability, immutable prime/rev
  objects, raw initialized generator domains and both normalized fs/gs
  input images. There is no remaining body_entry premise to discharge.
- StepAddReady195 executes the actual u=slen initializer and the seven
  additional-prime prefix statements. It constructs Basic and the full
  StepU1Entry195.Input at that prefix state, including the row-1 .g load,
  rev source/binding and raw initialized scratch. The row-1 .p load comes
  from the transported prime object; p1/p0i1/r21/rx1 are the executed words.
- StepAddGenerator195 executes the original generator branch, derives
  readable gm words from initialization and allocation, and preserves
  the earlier fs/gs region through its source write frame.
- StepWalkKeep195 and StepAddProductKeep195 add arbitrary per-cell
  bystander keeps to the actual march and fd/gd product engines. All
  writes remain the original source statements; no replacement loop is
  used. StepAddBasic195/StepAddOps195 transport individual caller domains,
  metadata and table bindings through the resulting executions.
- StepAddBody195.remaining composes generator; walkFs; nttFs; productFd;
  walkGs; nttGs; productGd; the FALSE !out_ntt branch; final skip. The gm
  words survive both marches and the fd product. The fd image survives
  the later gs march, forward call and gd writes. This closes the prior
  simultaneous-image gap at ONE body-exit state.
- StepAddSection195.part4_run consumes the actual body_entry continuation,
  restores the aBody scope, executes u=1→2, proves the terminal u<tlen
  guard FALSE at 2<2, and composes aLoop/aFor/part4 with both product
  images preserved through the heap-free scope and increment tail.

## Canonical checks and pins

First phase, unchanged:

```sh
python3 -B tools/job111.py lean keygen_publicforward159_578 \
  Source3.StepNttForwardImage195 Source3.StepAddProduct195 \
  Source3.StepAddForwardProduct195 Source3.StepForwardProductAudit195
```

4/4 accepted; 21 separate standard-only axiom results. Its exact pins,
6.936/4.676/4.275/3.024s and maxRSS 4103296 KiB are retained in
KEYGEN_STEP_FORWARDIMAGE_195_578.json.

Completion phase:

```sh
python3 -B tools/job111.py lean keygen_publicforward159_578_section \
  Source3.StepMemoryInit195 Source3.StepAddEntry195 Source3.StepWalkKeep195 \
  Source3.StepAddProductKeep195 Source3.StepAddBasic195 Source3.StepAddOps195 \
  Source3.StepAddGenerator195 Source3.StepAddReady195 Source3.StepAddBody195 \
  Source3.StepAddConcrete195 Source3.StepAddSection195 Source3.StepAddSectionAudit195
```

12/12 accepted; elapsed sum 124.958s; cumulative child maxRSS 5683872 KiB.
Its eleven proof stdout/stderr files and audit stderr are empty. Audit
stdout retains 11 original types and 16 #print axioms results, including
the final source export: every list is exactly
[propext, Classical.choice, Quot.sound]. The two phases retain **37**
axiom results in total. Limits unchanged: maxHeartbeats 2000000,
maxRecDepth 32768 in new proofs, -j1/-M6144, AS12GiB/RSS8GiB/wall1800s,
bwrap isolation and warningAsError. No linter was disabled.

ENTRY_PINS `.build/steprx195/ENTRY_PINS.json` SHA256
`00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964`:
**74673/74673, 0 missing / 0 changed before and after** both phases.
The job-577 handoff/retained evidence remains 52/52 bindings before/after.
No re-baseline. Final source/snapshot/olean/log/receipt bindings are in
KEYGEN_STEP_SECTION_195_578.json. Canonical PREFLIGHTs record no competing
proof job. No Sage job was needed: this is kernel composition and Nat
layout arithmetic, with no new numerical estimate.

Headline source SHA256:
`a6cad5b30081433ef49a993a639e5a40dca21ea90b67e7594a6b680ff25e95d0`;
olean `dca11ef657b6c8b69bcde51ab9532e9c36a70171329d5529e651041ce48c3a2f`.

## Retained attempts and traps

Historical **65 + 58 + 4 plus the permanent bodyHeap finding**, the two
job-575 setup failures, job-576 dif_pos and job-577 performance failure
remain unchanged. Twenty-three local attempts are retained in this
window: five complete successes and eighteen failed/partial attempts,
with accepted modules inside partial attempts recorded separately.
The first-phase register retains attempts 001–006 (four failures).
KEYGEN_STEP_SECTION_195_FAILURES_578.json retains 007–023 (fourteen
additional failures). There were ZERO failed canonical lane jobs.

All failures were environment, organizer, parser, elaboration or clean-log
failures; no mathematical counterexample. Source snapshots, actual engine
receipts/stdout/stderr, local input pins and accepted artifacts remain
under .build/forwardimage578/. Attempt015 failed before the engine started:
its failed organizer source and setup-error summary are retained separately.
No failed product was inserted into the canonical lane cache.

Additional traps beyond the first-phase report:

- Concrete Memory projections → rfl unfolds nested write/walk closures
  → use abstract proj_heap/proj_locals/proj_arrays/proj_tables bridges.
- Opaque prepared/converted tables → canonical bindings are not defeq
  → use conversion/public/prepared_eq bridges, then a kernel equality of
  finite table lists and congruence of lookup. Remove now-unused fallbacks.
- addr src 0 i 1 versus elem src i → mul_one/add_zero are propositional
  normalizations → normalize explicitly, and use exact elem offsets in
  layout change statements.
- walk_run versus remaining → their exported tuple orders differ
  → inspect the original type; walk_run exports image before v/x.
- `gm.offset≤igm.offset` → lexer takes `≤i` as InitialSeg notation
  → insert spaces: `gm.offset ≤ igm.offset`. The intermediate live
  attribution to a reserved `relation` identifier was incorrect and has
  an append-only correction; raw logs preserve the actual cause.
- `prefix` is reserved → use prefixState. Broad simp on arbitrary names
  normalizes string lists before hypotheses match → use named cell/frame
  lemmas and one-step wrapper rewrites.
- restoreScope leaves scalar restore opaque → unfold
  C99ScalarReference.restore for the u/tlen keeps; retain all linters.
- Local versus canonical receipts → the local engine lacks olean_sha256
  → pin accepted local source/artifact/receipt triples explicitly before
  reuse. Canonical replay rechecks every final new module independently
  of those local artifact choices.

The untracked threshold prompt and a concurrent edit of the run2 pin
reference are unrelated and excluded from this checkpoint. The reference
file is not a member of ENTRY_PINS; its edit does not change pinned inputs.

## Project boundary and next step

Window 578 closes the requested forward/product/additional-prime section
scope. Next unused suffix: **579**. Continue with the remaining d levels
and enclosing root/certificate/codec route, using these concrete exports.
The final theorem still concerns the pinned author-defined reference
semantics. It is not compiler correctness, a closed-form NTT/root/table
law, all d levels, full KeyGen/Sign or security. Unconditional Z>0,
p_accept, p_K and prospective Z>=2^-256 remain OPEN. Old110, measured
wording and the five do_sign obligations remain unchanged.

One local logical checkpoint closes this window; eight unpublished
commits at entry plus this checkpoint = nine waiting. No push.
