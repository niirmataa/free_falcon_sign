# R1: the word image of one doubling-round u1 block (job 575)

Date: 2026-10-26. Status: **PROVED_KERNEL_SCOPED / NOT_REVIEWED**.
Owner scope: the v-loop of one u1 block; later windows compose the u1
loop, rounds, m-walk and the tail_keep_words/productFd/productGd bridge.
No push, external review, stages import or migration was performed.

## What is proved

`StepNttVImage195` composes the accepted atomic
`StepNttImage195.binary_step` along the executed v-loop. At iteration v
the pair is `(l+v,l+h+v)` and its new words are `leftWord` and
`rightWord` of the two current image words and the loaded twiddle.
`pairWords` names that update; `vWords n i` folds n updates starting
at i in source order, and `blockWords W l h tw pw p0i` is the full
`vWords h 0` image. These are exact executable-word recurrences, not
an assertion of an algebraic NTT law or a closed-form spectral image.

Three kernel-checked exports:

- `v_loop_image`: from `i+n=h`, the geometry, `MFixed`, `Image s a W`,
  the counter/limit/twiddle slots and the two walked pointer bindings,
  constructs an actual `Exec StepNttMiddle195.vLoop` ending normally,
  with `MFixed`, terminal v=h, the write frame and the exact image
  `vWords n i l h W tw pw p0i`.
- `v_loop_full_image`: also executes v=0 initialization, accepting any
  declared old v value, then exports the actual source vLoop and its
  `blockWords` image.
- `u1_body_image`: consumes the existing `u1_setup` execution to load
  **the actual table word** `gvs ⟨m+j,tableBound⟩` and bind r1/r2,
  runs the full v-loop, restores the block scope and exports the actual
  `u1Block` execution together with `MFixed`, the write frame,
  `out.locals=s.locals`, and `Image out a (blockWords W l h
  (gvs ⟨m+j,tableBound⟩) pw p0i)`.

`Image` specifies all 512 marched words. The recurrence changes only the
selected pair at each step; it carries every other word through the
atomic `pairAt` update. The image survives the counter/pointer updates,
setup and scope restoration via heap equality. The source statement,
image and frame share the same existential output state.

The assumptions remain explicit: `MFixed` supplies readable/writable a
cells, the a/gm bindings, width/capacity, p/p0i/full/hn/stride slots,
table loads and separation. The block export requires `l+2*h≤512`,
`0<h`, `m+j<gmn`, `m+j<1024` and the m/u1/v1/ht slots. None of these
premises assumes the resulting execution or output image.

## Verification and pins

Entry manifest: `.build/steprx195/ENTRY_PINS.json`, SHA256
`00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964`.
Read-only verification before and after work: **74673/74673, 0 missing,
0 changed**. The manifest and the old `99ac47a1…` manifest remain intact.
The job-570 sources, job-571 corrected states, job-572 round engine and
job-574 image foundation are unchanged. The permanent layer-195
bodyHeap supplement remains authoritative; no construction uses the
defective `StepNttFirst195.stepState`.

Command, from source3:

```sh
python3 -B tools/job111.py lean keygen_publicforward159_575 \
  Source3.StepNttVImage195 Source3.StepNttVImageAudit195
```

Result: **2/2 accepted**, exit 0, compiler diagnostics **0 errors /
0 warnings**, `-DwarningAsError=true`, forbidden proof markers `[]`.
Proof module: 10.700 s; type/axiom audit: 2.674 s; cumulative child
maxRSS 4085136 KiB. Existing limits and bwrap network isolation retained.
The proof module's stdout/stderr and the audit stderr are empty; the
audit stdout intentionally contains the original types and axiom lists.

All three theorem exports depend only on
`[propext, Classical.choice, Quot.sound]`. The three definitions
pairWords/vWords/blockWords depend on `[propext, Quot.sound]`.
An earlier live job-record line mistakenly called the definitions
axiom-free; its explicit correction is retained in WORK_STATE, and the
original raw audit is unchanged.

Proof source SHA256:
`ace1fd18e06fdfc1fd7992a331fd12354fcf318a238510e6c4e1988faee77eff`.
Proof olean SHA256:
`2b69221b0335ec609a43d82b09b4824f71d987a98c209afe007eae239f6b7bae`.
Audit source SHA256:
`c38bb2f4a49527ae343b1b9971c19c5f2f0d43b0d1761ed787d89dd172feb029`.
Machine-readable receipt/source/product/log bindings:
`KEYGEN_STEP_VIMAGE_195_575.json` beside this report.

No Sage job was needed: this step composes existing executed-word
operations kernel-wise and makes no new numerical estimate. No C
production source was edited and no finite testing claim is substituted
for the Lean theorem.

## Retained attempts and traps

The historical **65 + 58 + 4 plus the bodyHeap finding** are preserved.
This window adds **two local setup/environment failures**, recorded in
`KEYGEN_STEP_VIMAGE_195_FAILURES_575.json` with raw logs, snapshots and
receipts under `.build/vimage575/`. Neither is a mathematical failure or
a consumed lane-job suffix. Attempt003 then checked the unchanged proof
source successfully (19.670 s, maxRSS 4084196 KiB, diagnostics 0/0).
The canonical lane acceptance is job 575, not the local check.

- Outer sandbox restriction → bwrap could not create NETLINK_ROUTE,
  before Lean started → the same checker ran with the required host
  permissions; bwrap network isolation and resource limits were retained.
- Incomplete first namespace tree → Lean found Source3 in the empty
  output lib and stopped before finding StepNttImage195 → use the full
  pinned job-574 lib as the first workshop import root. This confirms
  the already documented LEAN_PATH namespace trap; the lane runner
  provides its complete tree normally.
- `if_pos`/`if_neg` deprecation and record-update parser traps were
  already known and avoided. No pinned source or historical failed
  receipt was patched. The new proof uses the canonical binary step,
  the existing v-step/fixed/frame engine and heap-equality image bridges.

## Next window and boundaries

Next unused lane-job suffix: **576**. Compose `u1_body_image` across the
u1 loop, using the u1 increment's unchanged heap to carry the image.
Then lift to mInner, the eight rounds and the m-walk. Only after these
steps bind the productFd/productGd loads through `tail_keep_words` and
`image_keep`. Retain the existing order of the remaining false !out_ntt
skip, loop/section assembly and body_entry discharge.

This step proves one block in the pinned author-defined reference
semantics at the selected logn=9/full=0 call words. It is not an
independent acceptance, a full forward image, a root/table law, a
compiler theorem or an unconditional positivity/security result.
Z>0, p_accept, p_K and the prospective Z≥2^-256 bound remain open;
Old110, measured wording and the five do_sign items are unchanged.
