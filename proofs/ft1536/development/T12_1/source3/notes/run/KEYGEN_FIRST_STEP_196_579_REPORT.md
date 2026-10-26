# R1: complete first make_fg_step return and concrete d=2 entry (579)

Date: 2026-10-26. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**.
WYKONANE: seven proof modules and one original-type/axiom audit.
PRZETESTOWANE: canonical keygen_firststep196_579, **8/8 accepted**,
exit 0, diagnostics **0 errors / 0 warnings**, warningAsError,
forbidden markers [], no linter suppression.
NIEZALEZNIE ODEBRANE: NOT_RUN / NOT_REVIEWED.
No subagents, push, stages import, migration or production C change.

## What is proved

The selected FIRST `make_fg_step` now has a complete body execution,
including parts 0 and 1, and BOTH complete 512-word fd/gd output images.
The theorem starts at FirstStepEntry187.entry and constructs its output;
it does not assume a target execution or output-image premise.

Window 578 supplied the additional-prime column at index 1+2*v.
StepAddBodyKeep196/StepAddSectionKeep196 additionally preserve arbitrary
separate earlier cells through the generator, both marches, both forward
calls, both product loops and the heap-free section tail. StepFirstColumns196
uses the actual CRT handoff and determinism to bind the older prime's
fd[2*v]/gd[2*v] product images to that SAME entry. The CRT keeps and the
new section keeps retain both older columns to the same final output as
the additional-prime columns. No simultaneous-image premise is assumed.

StepFirstImage196.columns_image joins the two stride-2 columns by parity
into all 512 contiguous words: even index 2*v reads the first prime's
executed nested Montgomery product; odd index 2*v+1 reads the additional
prime's corresponding product. interleave is a total Nat-indexed function;
only indices below 512 are observed. StepFirstImage196.source composes
parts 2/3/4 with the accepted declaration/size/layout/move prefix through
SelectedStepPrefix187.continue_step, exporting `Exec (code .step)` and
both whole images on ONE output state. Values remain executed words,
without a closed-form transform, CRT-number or root/table interpretation.

FirstStepReturn196.source executes the actual `.step arguments` call,
heap-only return to FirstStepEntry187.caller, enclosing empty-scope d-loop
body, the uint32 increment d=1→2, and the TRUE next d<depth guard at 2<10.
The two whole images survive on the same returned/advanced heap. Caller
arrays are unchanged and caller locals outside d are preserved.
continue_loop is an explicit continuation hook for the remaining loop;
its future-loop execution premise is NOT advertised as a closed loop.

SecondStepEntry196 constructs the actual next six-argument Bind from that
advanced state, evaluating the pinned `logn-d`, `d`, and outExpr source
expressions: data=ft, logn=8, depth=2, ter=1, in_ntt=1, out_ntt=1.
The last argument is derived by the source's true `(d+1)<depth` disjunct
at 3<10. Both complete data images belong to the resulting fresh callee
heap, with no target second-step execution premise.

SecondStepStart196 executes the second call's original declarations,
`n = (size_t)1 << logn` and `hn = n >> 1`, deriving n=256 and hn=128.
Both 512-word input arrays are preserved. part1_continue exposes the
literal remainder after these assignments for the next layer.

This closes the d=1 body/return/d=2-entry milestone. The complete d=2 body
has not been executed by this step.

## Canonical checks and pins

From source3:

```sh
python3 -B tools/job111.py lean keygen_firststep196_579 \
  Source3.StepAddBodyKeep196 Source3.StepAddSectionKeep196 \
  Source3.StepFirstColumns196 Source3.StepFirstImage196 \
  Source3.FirstStepReturn196 Source3.SecondStepEntry196 \
  Source3.SecondStepStart196 Source3.FirstStepAudit196
```

8/8 accepted, elapsed sum **24.743s**, cumulative child maxRSS
**4148624 KiB**. Seven proof stdout/stderr files and audit stderr are empty;
audit stdout retains 9 original types and 15 separate axiom results.
interleave is axiom-free; columns_image uses [propext, Quot.sound]; all
other audited declarations use only
[propext, Classical.choice, Quot.sound]. No new axiom or suppression.
The inherited maxRecDepth 32768 / maxHeartbeats 2000000, -j1/-M6144,
AS12GiB/RSS8GiB/wall1800s, bwrap isolation and warningAsError remain intact.
Canonical PREFLIGHT records no competing process. No Sage job was needed:
this is source-execution composition and kernel Nat/layout arithmetic.

ENTRY_PINS `.build/steprx195/ENTRY_PINS.json`, SHA256
`00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964`:
**74673/74673, 0 missing / 0 changed before and after**.
The job-578 evidence and retained artifacts verify **383/383** bindings
before and after. No re-baseline or change to pinned predecessors.
Complete source/snapshot/olean/log/receipt bindings are in
KEYGEN_FIRST_STEP_196_579.json beside this report.

Full first-step image source:
`21ef2e579951c7fdf0ad0635ba5c616bc504e2645f594957b9145b6651aceb41`;
olean `83f7e02d65755400cf6c8e11d74bb1541b9edf1afeb653c9b00c024af105b5a7`.
Second-step prefix source:
`54b5b9c06a943f95142c95fb0df12d901869b3793754d6562d82c758097c2f5a`;
olean `8ac33da3770d6999e577ed4b71fb8f15e84ac7c4f02bf6f45adf6e37f45c8496`.

## Retained attempts and traps

All inherited registers remain intact: historical 65 + 58 + 4 plus the
permanent bodyHeap finding, job-575/576/577 failures and all eighteen
failed/partial attempts of 578. This step adds FOUR failed/partial local
attempts, among eight retained local attempts; no canonical lane job
failed. All snapshots, receipts, stdout/stderr and accepted local products
remain under .build/step579 and are enumerated in
KEYGEN_FIRST_STEP_196_FAILURES_579.json. No failed cache product.

- attempts003/004: a record-update lambda leaves the congrArg pointer
  result under-inferred. Use an explicitly typed ArrayPointer constructor.
  Attempt004 was an avoidable duplicate: it was launched before the prior
  result was inspected, with the same failing source. Its actual record
  is retained; it adds no mathematical evidence.
- attempt005: the returned-state constructor refers to the existing
  noncomputable caller. Mark that state constructor noncomputable; this
  adds no hypothesis or axiom. The four preceding modules accepted.
- attempt007: `heap := rfl` at SecondStepStart196 triggers concrete-state
  normalization and reaches the unchanged 2000000-heartbeat whnf limit
  after 114.950s. Replace it with bind_heap, StepDeclarations187.heap and
  SecondStepEntry196.entry_heap, then explicitly transport images with
  image_keep. Attempt008 accepts that module in 2.470s without raised
  limits. This was a proof-tool performance failure, not a counterexample.

Attempts001/002/006/008 accepted all requested local modules with logs
0/0. The canonical job rechecks all final sources. Unrelated run2
pin-reference edits and the untracked threshold prompt are untouched and
excluded from this checkpoint.

## Scope and continuation

Next unused suffix: **580**. Continue from SecondStepStart196.ready and
part1_continue: execute the actual d=2 length/table/layout/move branch,
then its multi-limb source reductions, CRT and loops. Later d levels and
the enclosing root/certificate/codec path remain OPEN. The static small3
entries at depths 2/3 are 2/3, but this report does not substitute that
static fact for the still-required actual table loads and body execution.

This remains a theorem about the pinned author-defined reference
semantics, not compiler correctness, complete d=2/all d levels, a
closed-form NTT/root/table law, full KeyGen/Sign or security.
Unconditional Z>0/p_accept/p_K and prospective Z>=2^-256 remain OPEN;
Old110, measured wording and the five do_sign obligations are unchanged.
One local logical checkpoint adds to nine waiting commits: ten waiting,
without push.
