# R1: the word image of the full u1 loop (job 576)

Date: 2026-10-26. Status: **PROVED_KERNEL_SCOPED / NOT_REVIEWED**.
Owner scope: compose the accepted v-loop block image over the full u1
loop. Rounds, m-walk and the tail_keep_words/productFd/productGd bridge
remain for later windows. No push, independent review, stages import or
migration was performed.

## What is proved

`StepNttU1Image195.u1Words` folds the job-575 `blockWords` recurrence
in source order. Block j starts at j*t, visits the pairs
`(j*t+v,j*t+h+v)` and uses the actual loaded table word at m+j.
`roundWords` names all m blocks starting at u1=v1=0; the name describes
the u1 image only, without claiming the enclosing mInner round execution.

Two main kernel-checked exports:

- `u1_loop_image`: for j+n=m, constructs an actual normal execution of
  `StepNttMiddle195.u1LoopCode`, with `MFixed`, terminal u1=m, the write
  frame and `Image out a (u1Words gvs n j m t h W pw p0i)`.
- `u1_loop_full_image`: also executes the original u1/v1 initialization
  from arbitrary declared old values and exports the actual source
  `KeygenNttForwardPrograms.u1Loop` with its exact `roundWords` image.

The same existential output state witnesses execution, fixed context,
frame and all 512 image words. Each body uses the accepted
`StepNttVImage195.u1_body_image`; its locals equality transfers the
control slots. The u1/v1 update and initialization preserve the heap,
so `StepNttImage195.image_keep` carries the image without a new semantic
assumption. The frames compose over actual body executions.

Explicit inherited premises are m*t=512, t=2*h, m<=256, t<=256, h>0,
512<=gmn, `MFixed`, the initial word image and the m/t/ht/u1/v1 slots.
From j<m the proof derives block bounds and m+j<gmn, m+j<1024.
`tableWord` is total notation with zero outside the table;
`tableWord_eq` proves its equality to `gvs` at every executed index.
No out-of-range fallback is executed or used to justify a table load.
No premise assumes the resulting execution or resulting image.

## Verification and pins

Entry manifest: `.build/steprx195/ENTRY_PINS.json`, SHA256
`00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964`.
Before and after work: **74673/74673, 0 missing / 0 changed**.
The predecessor handoff bindings also passed 31/31; all 12 raw members
of its three local attempts, including both setup failures, were checked.
The prior manifests, job-570 sources, job-571 corrected states,
job-572 engine and job-574/job-575 image sources/products are unchanged.
The permanent layer-195 bodyHeap supplement remains authoritative.
No use of the defective `StepNttFirst195.stepState` was introduced.

Command from source3:

```sh
python3 -B tools/job111.py lean keygen_publicforward159_576 \
  Source3.StepNttU1Image195 Source3.StepNttU1ImageAudit195
```

Result: **2/2 accepted**, exit 0, compiler diagnostics **0 errors /
0 warnings**, `-DwarningAsError=true`, forbidden proof markers `[]`.
Proof 4.426 s; original-type/axiom audit 3.125 s;
cumulative child maxRSS 4138824 KiB.
Existing -j1/-M6144, AS12GiB/RSS8GiB/wall1800s limits and bwrap network
isolation were retained. Proof stdout/stderr and audit stderr are empty;
audit stdout intentionally contains original types and all six axiom lists.

Both main exports depend only on
`[propext, Classical.choice, Quot.sound]`; `tableWord` is axiom-free,
`tableWord_eq` uses `[propext]`, and u1Words/roundWords use
`[propext, Quot.sound]`. These are separate recorded axiom results.

Proof source SHA256: `e2985514024708a9c3128045e0ff79e1efb0e0a587d53224c0104abd0fb02d58`.
Proof olean SHA256: `bc57776f8d4fb1ec36f6a5e965b3ba44447ba88ecc571a378e1b5d3b25d43636`.
Machine-readable source/product/log/receipt bindings:
`KEYGEN_STEP_U1IMAGE_195_576.json` beside this report.
No Sage job was needed: this is kernel composition of executed words,
with no new numerical bound. No production C source was edited.

## Retained attempts and traps

The historical **65 + 58 + 4 plus the bodyHeap finding**, and the two
job-575 setup/environment failures remain retained. This window adds
**one tooling failure** and one accepted local check, pinned in
`KEYGEN_STEP_U1IMAGE_195_FAILURES_576.json`; raw snapshots, logs and
receipts remain under `.build/u1image576/`. No failed artifact entered
the lane cache and no historical failed receipt was overwritten.

- Dependent-if simplification -> `dif_pos` was rejected under
  warningAsError in attempt001 (18.065 s) -> the same deprecation family
  as if_pos/if_neg -> use `dite_eq_left bound`. This is a tooling failure,
  with no mathematical counterexample. The one-token repair passed
  attempt002 (3.273 s, diagnostics 0/0) before canonical acceptance.
- Empty first Source3 namespace tree -> missing imports before proof
  elaboration -> use the complete pinned job-575 lib as the first
  workshop import root. Both inherited setup failures remain unchanged;
  they were not deliberately repeated in this window.
- Outer sandbox setup -> bwrap needs host permission to construct its
  isolation -> retain the existing bwrap isolation and resource limits.
- Record updates and case syntax -> known parser traps -> no inline
  record-update construction was needed; use the existing precomputed
  state constructors and structured induction branches.

## Next window and boundaries

Next unused lane-job suffix: **577**. Lift `u1_loop_full_image` to the
actual mInner/mBlock round, following `StepNttMiddle195.m_body` and its
scope restoration while preserving the same image. Then compose the
rounds and m-walk; afterwards bind tail_keep_words/productFd/productGd.
The owner assigns these later windows; no next proof job was started.

This proves the full u1-loop image in the pinned author-defined
reference semantics at the selected logn=9/full=0 call words. It is
not an independent acceptance, the enclosing round/m-walk execution,
a closed-form transform/root/table law, a compiler theorem or full
KeyGen/Sign security. Z>0, p_accept, p_K and the prospective Z>=2^-256
bound remain open; Old110, measured wording and the five do_sign items
are unchanged. The six pre-existing unpublished commits remain local;
this window adds one local checkpoint. The unrelated threshold prompt
was left untouched.
