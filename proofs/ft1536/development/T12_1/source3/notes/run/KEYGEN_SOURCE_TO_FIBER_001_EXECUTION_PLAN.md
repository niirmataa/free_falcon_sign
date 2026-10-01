# B1 execution plan through final handoff

Status: **ACTIVE / IN_PROGRESS / NOT_REVIEWED**. Updated2026-10-01 after
the owner's instruction to save the complete remaining implementation plan.
This expands the existing ROADMAP T12.1 task and
`KEYGEN_SOURCE_TO_FIBER_001_PLAN.md`; it does not create another task or
change `development/T12_1/END_TO_END_SCOPE.md`.

This is an implementation and verification plan. Proposed module/theorem
names below are targets, not declarations of completed proofs.

## 1. Exact destination and fixed boundaries

The final theorem is `KeygenSourceToFiber001.emitted_to_actual_fiber`, with
the complete target type in section1 of the existing PLAN. Its inputs are:

1. the pinned M0 profile and actual call arguments;
2. legal input memory, object extents, alignment and required non-aliasing;
3. a finite independent source-execution derivation with observed return1.

Its conclusions must concern the SAME emitted secret/public bytes and the
SAME final accepted attempt:

- decoding the four secret arrays f,g,F,G and public h;
- the full accepted certificate with the actual source snapshots;
- exact integer NTRU, public equation and inverse equation;
- the existing ActualNTRUFiber equivalence and Gaussian fiber identity.

NTRU, public/inverse equations, certificate acceptance, suffix Legal,
serializer round-trip, canonical NTT output or solver correctness cannot
be added as final premises. No arbitrary callee or unproved source
completeness premise may fill a missing link.

Reuse Geometry.Vec, Relation.Rq, reduceVec/mulRq, CoefficientQuotient and
ActualNTRUFiber. Keep n1536, q18433, Phi=X^1536-X^768+1 and the pinned
source version. This lane provides deterministic facts to B4/B5; their
probability laws, conditioning, e, PRG advantage and final security assembly
remain separate contracts in END_TO_END_SCOPE.

## 2. Recovery baseline: what is actually checked

| Component | Current result | Important boundary |
|---|---|---|
| Certificate function | Source fragments, closed conversion/FFT/raw-LDL calls, Gate00, suffix, frame and teardown composed | Must be instantiated in the same complete KeyGen call |
| Static FFT environment | All3072 pairs parsed, exact source words in read-only blocks, scalar constants bound | Word semantics; no exact-real LDL or error estimate |
| Final solver check | Parsed7386--7396, all1536 executed comparisons and return1 imply pointwise modular equations | Earlier transform ranges, pointer bindings and initializers remain local inputs |
| Source modp primitives | Montgomery/ninv31, add/sub and signed modp_set contracts | Caller domains and source NTT composition remain |
| Coefficient conversion | Parsed7367--7372,6144 stores, canonical residues, original input preservation, same Vec relation | Source entry layout and non-aliasing remain local inputs |
| Attempt cap | Actual uint64 increment and rejection before sampling3000001 | Full attempt body/trace is not yet instantiated |
| MODE1 scalar bound | Executed x<3, cast/subtraction and narrowing yield {-1,0,1} | Full sampler and material-preservation proof remain |
| Integer lift/fiber | Residual bound37748737 and conditional lift/fiber assembly | Their equations/domains must be derived from the same source call |
| Key codecs/full caller/public equation | Research and identified source paths | Complete source theorems remain open |

Latest recovery commits at this plan's creation:

- `0d29f339`: modular-memory extension and coefficient-conversion program;
- `cdc1edb7`: conversion trace/ranges/frame/material/Vec proofs and evidence;
- `49ad5794`, `ac8c985e`: parsed final solver check and signed modular helper;
- `73d42e14`, `f256b438`, `6004ad89`: static environment, CPP/cap and batch007.

Detailed conversion evidence: `KEYGEN_RESIDUE_CHECKPOINT.md`. Batch008
receipt: `64198d2e86af3f48c650cde4868f4db3bad73ae3494233f03a8f70fdd9cf455a`.
Use WORK_STATE and Git log for later checkpoints rather than modifying these
historical references to pretend that they cover later sources.

## 3. Ordered implementation steps and commit boundaries

### B1.01 — NTT word algebra, one small next step

**Goal:** make the already checked scalar modular contracts usable inside
source NTT expressions without repeating the word proofs at each butterfly.

- Add source-derived addition congruence alongside the existing range result.
- Package subtraction and Montgomery results as operations in
  `ZMod 2147355649`, explicitly accounting for radix2^31.
- Distinguish ordinary residues from Montgomery-scaled table words. A
  multiplication by a twiddle stored as R*s must yield ordinary x*s.
- Bind the first PRIMES3 entry to source bytes, including p=2147355649 and
  g=1907584673. Derive the p0i initializer through the existing source proof.
- Prove any needed radix invertibility/prime facts in the kernel; Sage may
  produce/check exact certificates, but cannot stand in for those proofs.

**Acceptance:** source-call premises yield canonical outputs and the exact
field operation, with the representation scale visible in the type.
Commit this algebra adapter before extending the larger NTT machine.

### B1.02 — complete forward-NTT source grammar and execution

**Goal:** execute the pinned `modp_NTT3_ext` body, with the actual wrapper
`modp_NTT3(...)=modp_NTT3_ext(...,1,...)` bound separately.

- Extend the modular frontend only for syntax genuinely used here: pointer
  dereferences, dereferenced stores, pointer assignment/advance, comma
  initialization/increments, block-local pointers and void return.
- Reuse existing scalar, pointer-addition and object-representation rules.
  Preserve signedness, integer promotions, update order and subobject bounds.
- Parse prologue, first pass, intermediate passes and final triple pass;
  prove their composition is the complete source body. Retain every guard,
  including the logn0 return, and prove the M0 path from the actual profile.
- Derive n1536, hn768, stride1, counters and every pointer position from
  execution. Do not introduce a success constructor containing evaluations.
- Use a fixed source callee table. Source functions that are only needed
  operationally still need actual body execution and source coverage.

**Acceptance:** the whole forward body has a source-bound execution
relation with no abstract NTT oracle. Check affected existing consumers
after each semantic extension. Commit syntax/control separately from the
range and polynomial invariants that follow.

### B1.03 — source twiddle-table generation and memory layout

**Goal:** derive the table words consumed by that NTT from `modp_mkgm3`.

- Bind source `modp_R`, `modp_R2`, the required division body and REV10 data.
- Follow the actual M0 generator conversion, squaring, last-row writes,
  full-case cubing and upward squaring. Prove each row's exponent/order law
  and its Montgomery scale from the executed stores.
- Establish the concrete generator order needed at logn10. Expected route:
  source g has order9216 and its M0 squaring gives order4608. This remains
  a proof obligation until checked, not an input assumption.
- Account for the actual alias `igm=ft`: temporary inverse-table contents
  are overwritten by the checked coefficient-conversion loop. Preserve gm
  and the source material across that overwrite.
- Derive allocation, table extents, writable/read-only access discipline
  and non-overlap from the caller's buffer layout.

**Acceptance:** initialized source gm words with canonical ranges and exact
scaled root identities. Save finite-table certificates via a generator/pin
if they are too large for normal source commits. Keep failed reductions.

### B1.04 — NTT canonical range and polynomial evaluation

**Goal:** prove both properties of the SAME source transform execution.

1. Use the conversion's canonical input theorem, table ranges and the
   source primitive contracts to preserve range after every butterfly store.
2. Prove first-pass formulas a0+a1*w and a0+a1-a1*w, including physical
   low/high-half positions and the relation w^2-w+1=0.
3. Prove intermediate radix2 formulas x+s*y and x-s*y. Track the invariant
   t*m=n, sub-polynomial degrees and actual twiddle indices.
4. Prove the final triple formulas using x,x*w,x*w^2 in the actual emitted
   order. Resolve the permutation from source indices/REV10 rather than
   choosing whichever ordering makes the pointwise check convenient.
5. Relate the resulting words to evaluations of the existing
   CoefficientQuotient.polynomial of the original Vec.
6. Prove the1536 evaluation points are distinct roots of Phi. Use a
   degree/root-count or equivalent quotient injectivity theorem to recover
   the coefficient equation from equality at those points.

**Acceptance:** a source transform theorem with canonical range and exact
evaluation as conclusions. The complete solver must supply only legal
memory/profile and source execution, not this theorem's desired result.
Commit first-pass, remaining-pass and full-transform compositions as
separate recoverable steps.

### B1.05 — source solver success to exact integer NTRU

**Goal:** discharge the explicit premises of the existing integer lift.

- Cover the complete active solver call graph with source-bound execution.
  The final validation supplies the equation; earlier search routines need
  not be independently proved to solve NTRU, but cannot be arbitrary callees.
- Bind `poly_big_to_small` and `zint_one_to_plain` to complete executed
  bodies/caller control, obtaining the actual F/G bytes and bounds2047.
- Bind the full MODE1 sampler loop, rejection draws and stores to obtain
  f/g bounds1. Retain the real generator's deterministic draw interface;
  uniformity is not needed for this bound and is not assumed here.
- Prove the coefficient arrays are preserved through table generation,
  conversions and the four transforms. Connect their names and byte ranges
  to the same original f,g,F,G.
- Derive p,p0i,r, the final-check pointer bindings and canonical arrays from
  preceding execution. Apply the parsed final-check theorem, then NTT
  injectivity, then `exact_ntru_of_modular_check` with residual bound37748737.

**Acceptance:** successful source solver execution implies
`multiply f G - multiply g F = constantCoeffs 18433`, for the material
actually retained by the caller. No `solver_correct` premise remains.

### B1.06 — source public computation and inverse

**Goal:** derive both remaining equations required by ActualNTRUFiber.

- Bind the ternary q18433 branch of `falcon_compute_public` and its modular
  helpers/tables, using their pinned source files and correct word widths.
- Relate forward transforms to the same source f/g. Derive nonzero f
  evaluations from the executed failure tests on the successful path.
- Prove the actual pointwise division and inverse transform. Construct the
  mathematical fInv witness from these nonzero evaluations; it need not be
  an additional externally serialized array.
- Prove canonical h output and translate into existing Relation.Rq:
  `mulRq h (reduceVec f)=reduceVec g` and
  `mulRq fInv (reduceVec f)=constantCoeffs 1`.
- Reuse B3 exports only after inspecting their exact types and pinning their
  complete dependency closure. A transform fact in another model does not
  automatically bind this source call.

**Acceptance:** public/inverse equations are conclusions about the same
f/g/h retained by KeyGen. Commit source modular helpers, transform link and
public-call composition separately.

### B1.07 — whole KeyGen control, attempts and the final invocation

**Goal:** instantiate the required attempt interface with real derivations.

- Bind argument/context reads, MKN, RNG readiness, automatic coefficient
  objects, scratch layout, local initialization and eventual teardown.
- Extend source syntax/semantics as required for struct-member access,
  pointer views and actual call destinations. Record every supported
  construct and prove the pinned active source closure is covered.
- Follow the actual gate order: resultants f/g, raw FPEMU norm, orthogonal
  FPEMU norm, public computation, NTRU solver, mandatory leaf certificate.
  Expose the actual outcomes and preserve their common attempt identifier.
- Instantiate the cap theorem: increment before sampling, rejection at
  3000001, no wrap on reachable counter values, no normal fallthrough of an
  attempt, and final break after all successful gates.
- Extract chronological attempts from execution, prove every preceding
  attempt is rejected and the last is accepted, with length<=3000000.
- Tie the final attempt's f/g/F/G/h to the later encoding inputs. Trace
  actual stores and caller frames; do not substitute equality of abstract
  names for equality of memory/material.
- Instantiate the already checked complete certificate on those arrays,
  including its concrete globals, snapshots and lifetime of bad.

**Acceptance:** the named AttemptAccepted/Rejected, LoopSucceeded and
successful_loop_last_attempt interfaces from the existing PLAN, with all
gate facts and material identity derived from source execution.

**Important law boundary:** loop acceptance precedes output capacity checks.
If capacities can reject some accepted materials, expose this extra event
to B5. Do not equate call-level return1 with per-attempt acceptance silently.
Similarly, `1-(1-p_accept)^cap` needs a justified probability law; deterministic
trace facts alone do not establish IID trials for the real PRG.

### B1.08 — source secret-key serialization/decoding

**Goal:** prove bytewise round-trip of the four actual STATIC segments.

- Bind the source encoder/decoder bodies, dispatcher, q18433/logn10 branch,
  sign and low-magnitude bits, unary loop and independent segment padding.
- Use the accumulator low-suffix invariant: old emitted bits remain in the
  uint32 accumulator. Do not assume the whole accumulator is bounded by
  2^acc_len. Account for source post-decrement, including terminal ne=-2.
- Prove exact consumed lengths and decoding of `encodedSegment ++ tail`
  without consuming another segment. Treat noncanonical encodings only as
  the actual decoder does; success on honest encodings is the needed route.
- Compose f,g,F,G in source order with header0xaa, four independent paddings,
  capacity tests, cursor updates and the actual final length store.
- Preserve earlier segments, all source arrays and public material through
  subsequent writes. Derive observed output bytes from memory after return.

**Acceptance:** DecodeSecret of the exact emitted sk equals the same
four-Vec material, including G. Prove length formulas rather than borrowing
a signature-codec bound. Commit scalar bit/cursor laws, segment round-trip
and four-segment caller composition separately.

### B1.09 — source public-key serialization/decoding

**Goal:** bind canonical h to the exact emitted public bytes.

- Prove source15-bit packing/unpacking of1536 coefficients,2880 payload
  bytes and header0x8a, with canonical h<18433 supplied by B1.06.
- Respect that the public decoder returns its supplied length; do not invent
  trailing-byte rejection. The theorem uses the exact emitted length2881.
- Connect capacity checks, byte writes and final output-length store to
  ObservedEncoding and the same accepted attempt.

**Acceptance:** DecodePublic of the actual emitted pk equals the h already
used in the public/inverse equations.

### B1.10 — one emitted-to-fiber theorem

**Goal:** close the exact target without adding mathematical premises.

- Define PinnedExec/Success/Emitted from source execution and observable
  return/bytes, independently of the desired equations or acceptance facts.
- From return1 extract the final accepted attempt, both successful encoders
  and exact lengths. Combine B1.05--B1.09 on a single material witness.
- Supply the three derived equations to the existing ActualNTRUFiber
  coordinates/coordinates_formula/gaussian_fiber_in_basis exports.
- Print the full theorem type and its actual axioms. Check that no local
  canonical-range, initializer, source-completeness, arbitrary-callee,
  round-trip or pre-established certificate premise leaked into the final type.
- Export a small named contract table for B4/B5: same-key certificate,
  equations/fiber, emitted-byte identity and deterministic attempt structure.

**Acceptance:** the complete theorem type in the existing PLAN is inhabited
by a checked kernel term, with exactly the allowed premise boundary.

### B1.11 — complete replay, mutations and final artifacts

- Snapshot all new sources and exact dependency pins; run one serial fresh
  replay of the complete final closure with clean logs and unchanged limits.
- Audit final types/terms/axioms and source bindings. Retain all failed runs.
- Exercise targeted mutations at the final interfaces: missing gate/cap,
  accepted-vs-emitted confusion, F/G swaps or omitted G, wrong modulus/root
  order, weak integer-lift bound, wrong codec length/padding, different h,
  stale bad-pointer reads and mismatched attempt/material snapshots.
- Use only public synthetic helper inputs; no private KeyGen generation.
  Sage tests supplement kernel proofs and do not replace a missing theorem.
- Write `KEYGEN_SOURCE_TO_FIBER_001_REPORT.md`, `_CLOSURE.json` and
  `_REVIEW_TASK.md`. Begin the report with the full theorem type and actual
  premises. Include B4/B5 exports, source/model scope, reproducible commands,
  raw-log/receipt pins and every remaining limitation.

**Acceptance:** full package ready for the owner's independently arranged
review. Source commits remain distinct from REVIEWED, stages import or
security acceptance. Coordinator owns import/checkpoint/tag after review.

## 4. Work discipline and restart protocol

- One source3 worker/session, one proof job, one coordinated Git writer.
  No automatic subagents, reviewers, sessions or relays.
- Work only in this component. run2/t5 and frozen dependencies are consumed
  through pins. Migration/SOURCE_MAP cleanup remains on hold.
- Use unique job labels and `tools/job_when_available.py`; wait on occupied
  slots without ending the owner task or weakening preflight/limits.
- New exact calculations/checkers use `sage file.sage`, ZZ/QQ or rigorous
  intervals. Keep HOME/TMPDIR/cache and outputs in the durable .build tree.
- After a logical step: inspect status/diff/staging/log; commit exact owned
  paths locally on main under the shared writer lock. Record tested or draft
  status honestly. Do not accumulate an entire major step without a commit.
- At each checkpoint update WORK_STATE with the latest theorem, its remaining
  premises, source/evidence pins, live job or no-job status and next action.
- Avoid repeated broad replay after unchanged checks pass. Recheck modified
  dependency closures, new audits and actual failures. Reserve the complete
  fresh replay for B1.11 and other explicitly required acceptance checks.
- On interruption: preserve the current source files and raw failed job;
  save a small draft checkpoint if needed. On resume verify ownership, branch,
  current pins and running jobs before launching another computation.
- No push until a separate explicit owner signal. Keep foreign staged/worktree
  changes and unpublished commits intact; no amend or force-push.

## 5. Progress and honest completion test

Do not infer a completion percentage from module count or passed helper
jobs. The large remaining obligations are NTT polynomial refinement, whole
caller/gate/material composition and the actual codecs/public equation.
If a planned proof fails, retain the concrete counterexample/error or exact
missing type, update this plan at that boundary and continue independent
work where justified. Never weaken the final theorem to manufacture closure.

The task is complete only after B1.10 and B1.11 are satisfied. A completed
parser, internal audit, helper, checkpoint or busy compute slot is not the
completion criterion. The next implementation step is B1.01.
