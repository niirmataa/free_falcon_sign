# R1: eight doubling-round images, m-walk and product-read bridge (job 577)

Date: 2026-10-26. Status: **PROVED_KERNEL_SCOPED / NOT_REVIEWED**.
Owner scope: compose job-576 u1 images into actual rounds and the
m-walk, then carry the image through tail_keep_words to the literal
productFd/productGd reads. No push, independent review, stages import,
migration or production C change was performed.

## What is proved

`StepNttRoundImage195.m_body_image` executes the original mInner/mBlock:
local declarations, ht=t/2 assignment, the accepted full u1-loop image,
t=ht assignment and scope restoration. The same output witnesses the
actual execution, MFixed, terminal t=h, the write frame and the exact
`StepNttU1Image195.roundWords gvs W m t h pw p0i` image on all 512
marched words. Initializing locals and restoring scope preserve the
heap, so the image transfers by image_keep.

`RoundPlan` is a counted form of the existing m schedule. The
axiom-free `selected_plan : RoundPlan 8 2 256` fixes exactly eight
rounds with (m,t,h):

```
(2,256,128), (4,128,64), (8,64,32), (16,32,16),
(32,16,8), (64,8,4), (128,4,2), (256,2,1).
```

`walkWords` composes n roundWords images in that order, doubling m and
halving t. Its structural recursion decreases n; `doublingWords` is
`walkWords gvs 8 2 256 W pw p0i`. `m_walk_image` constructs the actual
mWalk execution with this image, MFixed, m=512/t=1 and the composed
write frame. Every guard and mStep uses the accepted source engine.
No premise assumes the resulting execution or resulting image.

`StepNttProductImage195.tail_run_image` also executes t=hn, m=2 and
the actual full=0 triplePass skip, exporting the same output for tailT,
MFixed, counters, frame and doublingWords image. The skipped branch
moves no heap word. The bridge consumes `StepNttKeep195.tail_keep_words`
explicitly, avoiding the static localsWritten over-approximation trap.

The bridge exports:

- `product_shapes`: productFd and productGd are their respective
  initializers followed by the same pinned productLoop/productBody.
- `tail_pair_loads`: for v<256, an image at the post-doubling state and
  the taken-side heap equality give the exact words W(2*v), W(2*v+1).
- `product_reads`: with the actual t1 binding and v cell, evaluates the
  literal source expressions `t1[(v<<1)+0]` and `t1[(v<<1)+1]`, including
  the scalar shift/add, pointer construction and Load32. Pointer
  capacity is derived from the actual image load, not assumed.
- `product_assignments`: the original w0 and w1 assignments execute in
  order at the declared/w0-updated block states, with those same words.

The bridge is reusable after a heap-preserving product initialization
or with the loop's current source image. The image, heap equality,
t1 binding and v cell are explicit inputs to this bridge; the round/tail
exports construct the nontrivial resulting image. This does not yet
assemble the complete productFd/productGd loops from the concrete
additional-prime entry or discharge their destination layout/frame.
The first-pass image and complete forward/call-frame image assembly,
false !out_ntt skip, loop/section assembly and body_entry discharge
remain downstream work. Values remain recursive executed words, without
a closed-form transform, root/table law or spectral interpretation.

## Verification and pins

Entry manifest `.build/steprx195/ENTRY_PINS.json`, SHA256
`00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964`:
**74673/74673, 0 missing / 0 changed before and after work**.
The job-576 handoff/retained-attempt bindings were checked 33/33 before
and after. No re-baseline; original job-570 sources, corrected job-571
states, job-572 engine, job-574/575/576 images and the permanent bodyHeap
supplement remain intact. No construction uses the defective
StepNttFirst195.stepState image.

Command from source3:

```sh
python3 -B tools/job111.py lean keygen_publicforward159_577 \
  Source3.StepNttRoundImage195 Source3.StepNttProductImage195 \
  Source3.StepNttRoundImageAudit195
```

Result: **3/3 accepted**, exit 0, compiler diagnostics **0 errors /
0 warnings**, warningAsError, forbidden proof markers `[]`.
Round module 5.529 s, tail/product module 2.570 s, type/axiom audit
2.522 s; cumulative child maxRSS 3871920 KiB. Existing -j1/-M6144,
AS12GiB/RSS8GiB/wall1800s and bwrap network isolation retained.
Proof stdout/stderr and audit stderr are empty; audit stdout contains
eight original types and eleven separate axiom results.

RoundPlan/selected_plan are axiom-free. walkWords/doublingWords and
tail_pair_loads use [propext, Quot.sound]. m_body_image/m_walk_image,
tail_run_image, product_shapes, product_reads and product_assignments
use only [propext, Classical.choice, Quot.sound]. This is an author
check and axiom audit, not an independent acceptance.

Round source SHA256:
`265c793c779c5fb94b8805481f818c43ac7e31bd32a91cb8f8beb1bfa5bba3b6`;
olean `a0a2c33ba1dec1d06ee9399d06933f301967bfb4d3449b39f8288ddd61565d2c`.
Tail/product source SHA256:
`26b5a943fc673dc537f1d3831b67abc02307e81d59baffd59ce17a7ab83a6ba7`;
olean `aa87ed639537a376ec3f755ac20863f6f9de68658e2113256f4828b57e94aed3`.
Full source/snapshot/olean/log/receipt bindings are in
`KEYGEN_STEP_ROUNDIMAGE_195_577.json` beside this report.
No Sage job was needed: this is kernel composition of executed-word
operations, with no new numerical estimate or finite-test substitute.

## Retained attempts and traps

Historical **65 + 58 + 4 plus the permanent bodyHeap finding**, both
job-575 setup failures and the repaired job-576 dif_pos failure remain
retained. This window adds **one tooling/performance failure**, recorded
with the accepted local attempt in
`KEYGEN_STEP_ROUNDIMAGE_195_FAILURES_577.json`. Raw snapshots, stdout,
stderr and receipts are under `.build/roundimage577/attempt001/002`.
No failed product was inserted into the lane cache.

- Recursive simplification -> attempt001 reached the existing
  2000000-heartbeat limit in the done-case simp/definitional comparison
  of the well-founded walkWords (191.821 s, exit 1, maxRSS 4469920 KiB)
  -> rewriting the recursive functional image caused excessive
  reduction -> replace it by structural recursion on the explicit round
  count, with counted geometric plan. Limits were not raised. No
  mathematical counterexample was found. Attempt002 accepted both
  modules in 3.423/2.520 s, logs 0/0, maxRSS 4146244 KiB.
- Slow-job disposition -> a SIGINT was requested after the process had
  already exited; kill returned "No such process", so no signal was
  delivered -> the first live record incorrectly described interruption
  and the next called the location termination elaboration -> explicit
  append-only corrections in WORK_STATE preserve both mistakes and
  identify the actual done-case timeout. Raw receipt/logs are unchanged.
- Host-process visibility -> ordinary sandbox ps sees only its PID
  namespace -> it cannot establish host-wide absence of proof jobs ->
  use host-permitted inspection and the canonical host preflight. The
  local check was the only Lean observed on the host; canonical
  PREFLIGHT records no competing processes.
- First LEAN_PATH namespace root -> an incomplete Source3 tree masks
  later trees -> each local attempt builds a complete symlink import
  tree from pinned job 576 and writes its own new products. Both old
  setup failures are preserved and were not repeated.
- Scope/taken branch -> static localsWritten includes the unexecuted
  triple branch -> use actual full=0 skip and heap equality, then
  tail_keep_words/image_keep. No freshness inference crosses that branch.
- Known deprecations/record-update/Memory traps -> use existing state
  constructors, named heap-equality bridges and structural recurrences;
  no if_pos/if_neg/dif_pos proof tactic or concrete-memory normalization
  was introduced. The inherited dif_pos repair remains unchanged.

## Handoff and boundaries

Next unused lane-job suffix: **578**. The accepted round/m-walk/tail
image and literal product read/assignment bridge can now be consumed
by the first-pass/full forward/call-frame image assembly and by the
product source-image invariants. Destination frames, product init and
full loop/section assembly still need their concrete additional-prime
state bindings; then follow the false !out_ntt skip and body_entry
obligations in the existing route.

WYKONANE: two proof modules, one type/axiom audit, retained evidence and
this report. PRZETESTOWANE: canonical job 577, 3/3 accepted, diagnostics
0/0, exact pins above. NIEZALEZNIE ODEBRANE: NOT_RUN / NOT_REVIEWED.
The single local checkpoint adds to seven previously unpublished
commits; no push. The unrelated threshold prompt stays untouched.

This is a scoped theorem in the pinned author-defined reference
semantics at logn=9/full=0, not compiler correctness or full source
KeyGen/Sign security. Z>0, p_accept, p_K and prospective Z>=2^-256
remain open; Old110, measured wording and the five do_sign obligations
are unchanged.
