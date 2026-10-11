# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_065 notes

2026-10-11, Codex. Owner-started B1.07 window from checkpoint44R.
**PARTIAL_PROOF / B1.07 Acceptance NOT MET / NOT_REVIEWED.**
**IN_PROGRESS / WORKING_NOT_FROZEN.** Exactly one expanded recoverable
midpoint, at this window's final close. B1.05/032 and B1.06/046 unchanged.
B1.08 local capacity/length seam advanced; full B1.08/09 and B4/B5 not reached.

## 1. Entry and fixed source boundary

Before edits/jobs, verify of the sealed064 pair and its recursively pinned
063 tooling supplement passed **12667 distinct pins**:
`.build/levels_065/ENTRY_PINS_065.json`, SHA256
`c58e0f05cc3f77cef0373139c469740bf83f838280ed01d6c3888b9ece8ef92a`.
Sealed064 JSON `8b9602b3dbd1c6e019936f66194234ce29cbc2c29b274fb53efd7d0176f745d9`;
notes `ce1600dfb7dfb5cb39e2e653d5376cfd825c8090157a4a701a2f44acfb7159d2`.
The recorded061 supersessions and owner-authorized063 notes correction
remain historical facts; no new supersession or silent pin correction.
Initial verify used the normal filesystem sandbox. The explicit host process
inventory immediately afterwards was empty before source/proof jobs. All
proof/Sage jobs used job_when_available.py in the host namespace, serially.

Base Git HEAD is the exact c1ff755a revision recorded in TARGET.json. Sources
remain live pinned `Extra/c/falcon-enc.c` (SHA2560f7085fa…) and the source
caller `Extra/c/falcon-keygen.c`; no archived C copy or production C edit.
All new proof modules are separate from064 and earlier immutable bytes.

## 2. Typed execution of all three complete bound bodies

`KeygenCodecValues` defines actual nullable pointer/scalar argument values,
fresh scalar activations, little-endian initialized int16 reads, typed C99
integer conversions/operations, signed-overflow and shift definedness,
pointer x++ with one-past arithmetic, and pre/post increments/decrements.
NULL differs from an uninitialized buf. Expressions change activation
locals/x, while heap writes occur only through the explicit byte store rule.
The existing C99IntegerReference rules supply GCC LP64 integer choices.

`KeygenCodecExecution.Exec` evaluates tests, reads, assignments, scopes,
finite while/for paths and the observed return word. The final false test's
postdecrement effect is retained. Scope exit restores the declared scalar
cells; the source's buf is not shadowed. Fixed terminal calls read the five
actual callee arguments, create a fresh private activation on the SAME heap,
and execute the bound compress_none/compress_static body. No arbitrary
callee callback, desired codec result, length, frame or projected run exists
in an execution constructor. Unsupported calls/heap lvalues have no rule.

`KeygenCodecCoverage` kernel-checks the full NONE/STATIC/dispatcher syntax,
non-shadowing buf scopes, and source operand-side-effect checks. Actual
unsequenced pairs with ++/-- have a constant companion operand (ne-- >=0,
++acc_len ==8). A concrete default-arm Call witness exists for every heap
with comp outside0/1. Coverage is syntactic, not a claim that undefined
reads/shifts/overflows acquire derivations. The ordered reference semantics
is not a compiler/OS or general ISO-C evaluation-order equivalence theorem.

## 3. The previously missing same-heap projection bridge

`KeygenCodecRefinement.exec_projection` inducts on actual typed executions.
It removes scalar values/local effects/guard decisions but preserves the
SAME before/after heaps, the actual buf destination and the return/control
path. Calls use the fixed body projection with the evaluated output pointer.
NULL runs can take no typed store edge, though the conservative projection
may hold an arbitrary destination pointer. Source projection coverage is
proved for each fixed body, never assumed by the final Call export.

The actual final interface is:

```lean
KeygenCodecExecution.Call args before after ret →
  KeygenCodecRefinement.Out args dst →
  KeygenCodecFootprint.Run dst before after
```

`Out args dst` identifies the non-NULL actual argument (`args.out=some p`
implies p=dst); it is not a write-frame assertion. `call_frame` derives the
foreign-BLOCK frame for every observed return, including partial writes and
rejection. There is no codec correctness/length/frame premise.

`KeygenCodecTypedSegments.Site` carries the actual SmallSite and a typed
fixed-body execution with that observed return. The argument adapter uses
`compCell`/env.args.comp: legacy SmallSite.comp has no equality connecting
it to that source read and is deliberately not used. The other values are
actual skbuf+skoff, klen-skoff, ter?18433:12289, the pointer read from ske[i],
and logn. The new Segments follows the concrete caller's cursor/counter and
zero/nonzero branches. `projection` derives064's body-bound trace;
`chain_call_histories` consumes063's nine-statement word creation and the
derived frames; `chain_call_material` yields the same input pointer at every
segment, in particular1–3, under the pinned finite virtual-map extension.

**Direction boundary:** `erase` maps this typed trace to the old caller
Segments. The inverse from the old unrestricted heap relation is neither
true nor claimed. Full replacement of that open seam in the enclosing
Invocation/Head remains an explicit composition step. The new trace's
premise is actual typed body execution, not an assumed footprint/frame.

## 4. B1.08 capacity/length progress and a retained false generalization

`KeygenCodecProfile` derives preservation of logn/ter/comp through the
actual pre-loop chain and segment chronology. `chain_profiles` plus
`arguments_profile` derives q18433/logn10 at ALL actual segment boundaries,
from TailCells and source local updates. No profile result is postulated.

`KeygenCodecNoneLength.assignment_source` identifies the exact bound else
assignment. `rhs_eval` proves its evaluated `(size_t)3 << logn` value is
uint64 3072 from the logn10 local cell, with no local side effects. This is
ONLY the source RHS value, NOT a complete encoded/returned length theorem.
Capacity failure, NULL dry run, the pair-write loop and its final return
still need their source control/length proof.

`KeygenCodecGuardedWrite` identifies ALL THREE STATIC guarded write blocks
(node051/node071/node111, rfl against the bound syntax). `guarded_window`
consumes their complete typed Exec and derives the exact capacity WINDOW
frame, including return0. Its explicit local facts are live u:uint64, the
actual max_out_len argument cell and the actual non-NULL buf binding; no
strict inequality is supplied. `guard_false_bound` derives u<capacity from
the evaluated source test; `reject_state` proves the return0 branch makes
no write. The byte offset equality and StoreByte rule yield the exact frame.
Full-body extraction/transport of those local facts and folding the three
blocks over all loops/scopes are still open; do not promote this to a
complete STATIC capacity-window theorem.

The unqualified capacity generalization fails outside the actual profile.
Native Sage/C normal and UBSan both reproduce q18433/logn0/NONE, capacity3,
an8-byte destination and two readable PUBLIC input coefficients:
return3, bytes `12345678a5a5a5a5`, changed offsets0,1,2,3. The body computes
odd len3 then writes pairs. All accesses in this probe are inside allocated
objects; byte3 is outside the REQUESTED [0,3) window. This is a real scoped
counterexample to an all-input capacity-window claim, not a KeyGen-profile
bug, failure of the block frame, or security counterexample. The caller's
q18433/logn10 restriction is derived above and must be used honestly.

## 5. Validation and all retained attempts

Final guarded job `keygen_codec_typed_audit_065_018` rebuilt all8 current
modules plus the audit:9 steps, exit0, clean diagnostic streams0/0.
Full audit **128 entries =112 named source interfaces +16 inherited**,
**103 full terms +25 kernel inductives**, standard propext/Classical.choice/
Quot.sound only, zero elisions. SEARCH_AUDIT SHA256
`8ddb4a9d12fa7ce5711767efb14476b9fa50cb3a4ca3ed121cd861f3bc458c0e`.
The audit producer reproduces byte-exactly (GENERATOR_CHECK); its first
unbuilt pre-profile audit is retained as AUDIT_BEFORE_PROFILE.lean.

Native Sage `keygen_codec_typed_sage_065_final`:64 baseline cases per mode
(normal/UBSan),128 total, including int16 extrema -32768/32767, zero values,
NULL/capacity/default dispatch, exact ZZ-derived bytes and input preservation.
All6 mutation kinds detected in EACH mode (12 detections). These finite
controls supplement, and do not substitute for, the universal kernel bridge.
The separate capacity-scope counterexample passed under019;016's two C
executions/assertions also passed before metadata serialization failed.

Twenty job directories retained:7 wholly accepted,12 failed,1 prestep abort;
32 completed command steps,20 accepted/12 rejected. Max observed cumulative
child RSS2979768KiB. Unchanged j1/-M6144,AS12GiB/RSS8GiB/wall1800s,
maxHeartbeats2000000. No broad replay of unchanged predecessors or independent
review. Historical runner model/session labels remain provenance; author Codex.

Exact causes are pinned in CAUSES.json and every snapshot/raw stream remains:

- 001: own Lean stopped with TERM/143 after471.693s of cold random page I/O;
  verified exact own PID/argv/io/stat preserved in IMPORT_STOP_001.json.
  Removed an unnecessary full caller/certificate import from the value layer;
  no foreign process stopped and no limit raised.
- 002: constructor-name linter on step, and ++/-- accidentally opened a
  nested Lean comment. Operation binders and explicit words fixed it.
- 003: Values/Execution accepted; Coverage body-name collision and closed
  decide with free variables. 004: Coverage accepted, Refinement rejected
  reserved syntax binder, Match index reconstruction and Option reassociation.
- 005: overbroad simp modified induction hypotheses, branch inversions and
  return-case tactic control failed; explicit projection inversion lemmas
  and Match fields fixed it. 006 accepted both bridge/typed trace modules.
- 007–009: profile local-cell rewriting/deprecated lemma/constructor case
  handling, then dependent index-field names and original-vs-rewritten Result
  inference. Explicit local-cell frame and original seg/run closed010.
- 010: Profile accepted, NoneLength index binder aliases/unnecessarySeqFocus
  failed.011 accepted the exact RHS proof.
- 012–013: guard comparison normalization lacked Value.type, then the last
  int32 Boolean-to-strict-Nat step.014 accepted;015 accepted complete guarded
  blocks, including return0.018 rebuilt current final bytes plus audit.
- 016: C/UBSan assertions passed; Sage Integer JSON metadata serialization
  failed. Native int metadata fixed.017: strict runner rejected stale source
  cache after a documentation-only GuardedWrite edit, before Sage began.
  Current bytes rebuilt018 without bypass;019 accepted the same C probe.

No linter suppression, admitted proof, native decision axiom, frame/result/
length assumption, changed production C, pin repair or limit increase.
Author self-review is pinned in SELF_REVIEW.md: primary B1.07 verdict remains
incomplete, with the exact source-composition/whole-body seams below.

## 6. Exact next obligations, plan order

1. Replace the old open SmallSite/Segments seam in the enclosing source
   Invocation/Head with the actual typed executions and retain the SAME
   observed return/call chronology. The new trace and its extraction are
   proved; the old unrestricted relation cannot imply this strengthening.
2. Fold the three derived STATIC guarded windows over the complete body,
   deriving the live u:uint64/max_out_len/buf local facts from declaration,
   assignment, increment and scope execution. NONE: derive its3072 temporary
   from the actual q18433 branch, initial capacity test, even pair-write loop,
   non-wrapping cursor, exact return and whole capacity window.
3. B1.08: uint32 low-suffix accumulator (never a false whole-acc bound),
   source terminal ne=-2, independent padding, exact encoded/consumed lengths,
   decoder body/round-trip of encodedSegment++tail, then four-segment caller
   bytes/final length/input preservation. No result/length/frame premise.
4. B1.09: actual public codec bodies, canonical15-bit packing/unpacking,
   same h,2880 payload bytes/header, actual2881 return; no invented trailing
   rejection. These have not been entered by this window.
5. Inherited explicit common call ID/snapshots and all-state LegalWorkspace
   refutation status; remaining full B1.07/B1.10 source target. B4/B5 laws,
   probability/availability/PRG/security and compiler/OS remain outside.

Before the next owner-started edits/jobs, verify this sealed065 pair into
levels_066/ENTRY_PINS_066.json with tools/keygen_codec_typed_batch.py.
A mismatch is stop-and-report, never silent repair. One new window/one close,
serial host-guarded jobs/native Sage, unchanged limits, small exact-path local
commits. No push, review/delegation/relay, migration or archive import.

Own local source/tooling commits: `28663c9f`, `2d262037`, `1864060b`,
`4e66c979`; the final pair/checkpoint is a separate closing commit.
Foreign S05 history and existing working-tree/staging changes are preserved.
The finite controls use pinned custom runner receipts/snapshots; they do not
claim v2 before/after compiler-input closure or compiler verification.
