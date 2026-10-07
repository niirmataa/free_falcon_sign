# KEYGEN_SOURCE_TO_FIBER_001 — B1.05 recoverable source-bounds midpoint

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
2026-10-07: owner-scoped B1.05 window **CLOSED_AT_RECOVERABLE_MIDPOINT**
under `run2/notes/B1_STAGED_ROADMAP.md` rule3. **B1.05 Acceptance NOT MET.**
The next owner window resumes B1.05. B1.06 has not been entered.
No owned job or unresolved Lean draft remains. Resume protocol: **section6**.

Harness: GPT-6 Astra Ultrafast (`openai/gpt-6-astra-ultrafast`). Historical
runner labels remain provenance. Latest pair:
`KEYGEN_SOURCE_TO_FIBER_001_BATCH_021.json` + `_021_NOTES.md`.
B1.04 Acceptance and its complete NTT theorem remain BATCH_019 dependencies;
their historical checkpoint is preserved in Git at `2868c49e`/`30359d3b`.

## 1. Closed this window — full small-output bound and actual sampler stores

Source commits on main as niirmataa: `f17fe9b2`, `8b55f52f`, `20d4e524`.
The pair/checkpoint has a final local documentation commit. Git writes use
`proofs/ft1536/work/archive.lock` with exact owned paths.

### 1.1 Complete poly_big_to_small body

`KeygenSmallSource` binds the COMPLETE4495–4507 body, retaining scalar
declarations, MKN, counter initialization, loop, actual zint call, signed
guard, int16 store and both returns. The fixed `zint_one_to_plain` callee
executes the parsed4433–4436 prefix and the4437 signed32 object read. The
local uint32 value is interpreted through its four actual little-endian
bytes; object roundtrip and heap-readonly facts are proved. No abstract
small-output callee or postcondition occurs in the execution rules.

`KeygenSmallStep` derives accepted signed comparisons, the actual Store16
and z-local restoration. `KeygenSmallBounds.source_material` takes:

```text
Profile s                         -- actual logn10 / ter1 parameter slots
s.arrays "d" = some dst; dst.elementBytes = 2
KeygenSmallSource.Exec KeygenSmallSource.code s out
out.flow = returned (some (int32 1))
```

and concludes:

```text
exists v : Geometry.Vec,
  KeygenMaterial.Represents out.state.heap dst v
  and KeygenIntegerLift.Bound v 2047
```

The source n1536, initialized/incremented u, every bounded store, final bytes
and bound are derived. `KeygenSmallCalls.bound_call` also consumes actual
parameter Bind and a nonzero converted return, proving that return is1.
The byte frame and `two_outputs` retain F through a second disjoint bounded
write trace. **The actual enclosing F/G arguments and short-circuit gate
are still required**; these helpers do not yet instantiate the whole solver.

### 1.2 MODE1 post-refill tail

`KeygenTernaryStore.accepted_store` executes x extraction, rb shift, rbits
decrement and the actual comparison/store/break. With caller x/u slots and
destination binding it concludes an actual Store16 witness with coefficient
in[-1,1]. `rejected_heap` proves the rejected-draw edge has no heap effect.
There is no RNG or distribution premise in this tail theorem. **Refill,
both loops, source SHAKE binding and full f/g Vec witnesses remain open**.

### 1.3 Full dependency inventory and controls

`notes/run/KEYGEN_SOLVER_GRAPH_021.md` links the full recorded adjacency
tables:99-node unpruned solver,92-node root-M0-selected overapproximation
and6-node sampler. Deeper runtime branches remain included. The sampler
uses get_rng_u64(&fk->rng)→shake_extract→process_block/enc64le/memcpy.
This is a pinned compiler inventory, **not proved operational coverage**.

Fresh Sage/ZZ and14 normal/UBSan runs check36 small-output edge cases and
24 two-call sampler cases each, with six mutations detected in both modes.
Public SHAKE fixture labels and actual pinned shake.c; exact output/cursor,
refill/rejection and retained-array checks. The fixture's mock caller has
only an rng field. These tests do not prove the missing caller layout,
complete sampler execution, probability law or whole solver correctness.

### 1.4 Inherited BATCH_020 — common-memory solver validation

Source commits on main as niirmataa: `b4c2e87f`, `e92271d2`, `ed98536b`.
The BATCH_020 pair/checkpoint was saved at `1c8c3988`. Writer windows used
`proofs/ft1536/work/archive.lock` and exact owned paths.

| Module under formal/Source3 | Checked result |
|---|---|
| `KeygenSolverEquation` | Actual check-loaded words agree with four Images; pointwise equations yield the quotient equation and integer recovery. |
| `KeygenSolverNttCalls` | Parsed7374–7377 call sequence; pinned macro inserts stride1; actual arguments bind the complete NTT body; caller locals/pointers restored. |
| `KeygenSolverTransforms` | Sequential ft/gt/Ft/Gt execution on common heaps; later converted input words and earlier output Images are preserved. |
| `KeygenSolverTarget` | Parsed7378 Montgomery target, signed-literal parameter conversion and final check pointer/scalar/canonical bindings derived. |
| `KeygenNttMemoryFrame` | Actual pointer provenance and Store32 footprints preserve outside-scratch bytes, including original16-bit material; no canonical-cell premise. |
| `KeygenSolverValidation` | Generation, conversion, four calls, target and successful comparison composed; same original material retained in final memory. |
| `KeygenSolverValidationAudit` |88 full type/term/axiom entries, including all69 new declarations and19 inherited interfaces. |

#### 1.4.1 Exact inherited theorem boundary

`KeygenSolverValidation.generated_converted_checked` concludes:

```text
KeygenSolverEquation.Equation material
and forall slot, KeygenMaterial.Represents out.state.heap
  (arrays.input slot) (material slot)
```

Here `Equation material` expands to:

```text
multiply (material 0) (material 3) - multiply (material 1) (material 2)
  = constantCoeffs (18433 : Int)
```

The type takes generator Entry/source execution, executed p0i initialization,
legal scratch/input separation, original four-Vec byte representation,
`Bounds material`, conversion caller bindings and execution, the source-bound
four-call sequence and target/check execution with observed return1.
Generation-return and conversion-entry heaps are explicitly equal; later
executions share their actual States directly. **Bounds are still premises**:

```text
Bound (material 0) 1 and Bound (material 1) 1
and Bound (material 2) 2047 and Bound (material 3) 2047
```

Canonical converted words, initialized gm, NTT Image, targetCall, successful
coordinate equations, modular residual and final retained bytes are derived.
The source primitives/callees of this validation seam execute fixed bodies;
there is no arbitrary NTT/solver oracle. The initial caller/profile/bounds
must still be supplied by the enclosing full source derivation.
**This helper is not the complete successful-solver theorem.**

#### 1.4.2 Mathematical and memory seams

The BATCH_019 full NTT theorem now supplies evaluations of the same four
original polynomials. Canonical value injectivity preserves exact words of
later inputs, not merely their residues. Earlier Images survive later calls.
The actual `r = modp_montymul(18433,1,p,p0i)` execution supplies the target;
the signed literal arguments are converted into the same uint32 parameter
environment as the proved primitive contract. Check-loaded words are
identified through deterministic Load32, then
`KeygenNttEvaluation.equation_of_pointwise` and
`KeygenIntegerLift.exact_ntru_of_modular_check` are applied. The residual
bound remains37748737, less than2147355649.

The new byte frame is independent of the older canonical32-bit-cell Frame.
It follows a/r1/r2 pointer provenance within the scratch object, handles
actual declarations/binds/scopes/stores, and preserves arbitrary bytes
outside that object. Table-generation and conversion frames retain the same
material before it reaches the four transforms. The final comparison tail
is proved heap-readonly.

## 2. Pins and validation

The current preflight verified BATCH_015–020 and1594 distinct files,
including all409 final BATCH_020 inputs and1336 predecessor pins. No active
job was present. `.build/bounds_021/PREFLIGHT.json`:
`f5826bbb7d8b277751330e6edb717b2a0d9419b653168a46a115ec5c06347303`.
At sealing all415 final-audit inputs and1594 predecessor files match.
Postseal integrity check:1840 distinct file pins,415 current inputs,
no active job; `.build/bounds_021/POSTSEAL.json` SHA256
`621b757c4ec7083cbba15b14727d72cd77093c896bc71a2fc9a269c7c9d1774c`.

- **BATCH_021 JSON:** `ed560886f8cacfe513cea222b46552cf3abc717a1232172a1da197753393395a`.
- **BATCH_021 notes:** `a08b583aae3dc02996e21717eeab54085470b662b4854eb2dc5fa250b0701b55`.
- Full small-output bound source: `c2fe02ab3e5d9556a9ebffafe1a1467c698524fd53935e5a2d2432f84a1ca677`.
- Sampler store-tail source: `7fd5038f27fb247e69724b8d18ef4f5f4e41d66944718351b167a27841416fae`.
- `.build/jobs/keygen_small_audit_021_001/RECEIPTS.json`:
  `096ef38da8046f839f7f9502bf408c1c1ac730b170a8b1fff81f8ecb6d453d91`.
- Same job `SOURCE_INPUTS.json`:
  `24802776ee7ddf068b1aced540e4ad79986d898b898e3da602952da1defeee70`.
- Same job `SMALL_BOUNDS_AUDIT.json`:
  `1cb4f42e0da7ff629f0832c529c071a69c68efdc5a3116f47ad6dd36b3384825`.
- `.build/jobs/keygen_small_checks_021_001/RECEIPTS.json`:
  `16da9f8bc4b6feda36f46f723ad0cbb24ebe41e346ec1248df8c80ab1f5b5fac`.
- Same job `SMALL_BOUNDS_CHECK.json`:
  `b7207ef3609c0b0b5b5a669869d7c2442737e7f799c86ffc4078769c902c3a9a`.
- `.build/jobs/keygen_solver_graph_021_003/RECEIPTS.json`:
  `cbf8538dc48dd5309a18cf5ebd0cd09d764b656d8a0458c3ac164ce1af185c4b`.
- Same job `SOLVER_GRAPH.json`:
  `dd0e42256a6178bc05d7304d06dfd5a2cea9d34e14ba81999b59958e7ebc3b7c`.

All6 new modules have accepted source/snapshot/olean/receipt bindings and
0/0 logs; max accepted RSS2832532KiB.18 new attempts are retained:9 accepted
and9 failed. The audit has107 entries covering all98 new declarations,
97 complete flat terms and10 inductives with full constructor types, only
standard axioms, no elisions. Its819214-byte JSON is regenerated by the
tracked audit. Historical dependencies were unchanged; no broad replay.

**Inherited BATCH_020 pins, unchanged:** its preflight verified
BATCH_015–019 and1336 distinct files, including402 BATCH_019 audit inputs.
`.build/solver_020/PREFLIGHT.json`:
`5f0e6d6e1829fd93b5a4c0e1b728351e16b731bec9b0bfec68baa06bf187501a`.
At BATCH_020 sealing all409 final-audit inputs and1336 predecessor files matched.

- **BATCH_020 JSON:** `6b8a839151d8d174eb1b6a8b09e1b2f02a8f6c20b8c9055d40e687e951602dff`.
- **BATCH_020 notes:** `b402d5035667835182f539ed8ee8a812ad00a75687bd0662950373a098e26c6d`.
- BATCH_020 validation theorem source: `60faf3802b348e7080d6285a828d6a4e70c42d61f2c8bceec3e9f37e4ecc8baf`.
- `.build/jobs/keygen_solver_audit_020_005/RECEIPTS.json`:
  `fa26d87d7c85dd5e7d45773dd4a2ea0f36f0fba3523b2f3f828ce67cf1538674`.
- Same job `SOURCE_INPUTS.json`:
  `b6ab79b9638d1d08d9fe51872575cb08e4a1373c614c9638ba6bcafa9f55ffbe`.
- Same job `SOLVER_VALIDATION_AUDIT.json`:
  `c7d037950b751c0287e9dbd15a189aadaa9ef133bf9ea66a862ef424ddbd6abc`.
- `.build/jobs/keygen_solver_checks_020_001/RECEIPTS.json`:
  `0061d34ebcb0421d44c02ea562490b4a5fc6bd5487fd80bfb726cf08ba65a740`.
- Same job `SOLVER_VALIDATION_CHECK.json`:
  `2e69ed931116fcc622ae9c006502d2594ece9e77ea2d94eb7093314bf1223d28`.
- Same job `PUBLIC_FIXTURE.json`:
  `d9cc77c74b13c542adf6cf7d8333cb0e3656f9709c46dfcd67b5c7912497c455`.

Predecessor pairs, unchanged:

- BATCH_019 JSON `983a481a10293c01bf80250a9dd4ad2797e351db0a3c5d41825845d80fde6098`;
  notes `289d85f0ec1f25fe5950ad6b182363afe9ede0484c3053cf0c915d9cd52b1c01`.
- BATCH_018 JSON `f4e28b724e588b7e91cdb429646dfefe5939332f307f0ae15dc282369edc72cf`;
  notes `c19d5c9cb893793dd6ff23fa232271fcfe704f0821160de1a1e2065551bd546d`.
- BATCH_017 JSON `50f35519c32d1d16dd6987b781ac43e59cc835dd076ce15f146a1fe9ac9cbc0b`;
  notes `814660ca606d29600793dc3e61e5903b05ef56e83042b4d6aba131f86c6f28d6`.
- BATCH_016 JSON `cc28381bb1188400d0ea1d15e3c83ba045a2e5476a9644ee4dd0585c58e2b25f`;
  notes `e323ac9783e41e2143638088af6cfb0453b756a8418273b62bd961c1b0695419`.
- BATCH_015 JSON `b5bb63f5ddfb423ff6a4742dfd2893bcc7587b4cb50f51877b9b3910285be134`;
  notes `aec981ffab3f9065ac10d6d99f4f931ceccd852f237382e3b0240b64fbe53cd8`.

All7 BATCH_020 modules have accepted source/snapshot/olean/receipt
bindings and0/0 logs; max accepted RSS3004140KiB.19 attempts are retained:
8 accepted,10 failed, one interrupted outer-shell launch with no receipt.
The audit has85 complete flat terms and3 inductives/structures with full
constructor types, only standard axioms and zero elisions. Its1477559-byte
JSON is regenerated by the tracked audit source. No new DAG is needed.

Sage standard-preparser QQ inverse/ZZ quotient checks generated public
synthetic data, including a bounded valid tuple with maxima1/1/41/168.
14 normal/UBSan executions ×6 cases pass; six mutations detected in both
modes. Actual small-output conversions, original material, gm and scratch
guards are checked. The large-G exact tuple is accepted by validation and
rejected by the actual small-output gate. These finite controls supplement
the kernel seam; they do not supply the remaining universal source proofs.
The changed dependency closure was rebuilt after the smaller binding proof;
no unchanged full-project replay, compiler theorem or independent review.

## 3. Exact remaining B1.05 obligations, in execution-plan order

### 3.1 Complete active solver/caller execution

Bind the full `solve_NTRU` source7278–7397, including struct-member reads,
local declarations, MKN/logn10/ternary1 and all branch/call results. The M0
search path is `solve_NTRU_deepest`, the post-decrement intermediate loop
(body depths9 through1), and `solve_NTRU_ternary_depth0`. Each active callee
must execute its pinned body and active dependencies. Their search algorithm
need not itself prove NTRU, since final validation now supplies that equation;
an arbitrary heap transformer, return-value oracle or source-completeness
premise remains forbidden. Retain real failure/return control.

Supply actual PRIMES3[0]/p/p0i, ft/scratch aliases, generation caller binding,
conversion locals and source fragments to `generated_converted_checked`.
The existing first-prime and alias facts are available, but the complete
source caller derivation has not yet instantiated them.

### 3.2 Actual caller output bounds and material

The complete executed poly_big_to_small/zint_one_to_plain body boundary is
NOW CHECKED by the new modules in1.1. Do not redo it or use the older
`KeygenSmallOutput.Loop` as a substitute for the new source execution.
Bind both actual caller gates7342–7346: F/fk->tmp/logn/fk->ternary followed
by G/(fk->tmp+n)/logn/fk->ternary with real short-circuit/failure control.
Supply these actual bindings/executions to `bound_call`, derive retained
F/G Vec witnesses with Represents/Bound2047 and use the checked disjoint
frame through the second conversion. Preserve f/g and carry all four
vectors into the common-memory BATCH_020 validation.

### 3.3 MODE1 sampler and original f/g

Bind the full MODE1 loop4754–4781, refill, rejected2-bit draws, decrement,
store and break/outer increment. Derive actual f/g material and `Bound1`,
then preserve it through the intervening search/caller operations.
Reuse `KeygenTernaryStore.accepted_store` and `rejected_heap` for the
post-refill tail; the older scalar-only lemma is now consumed there.
The actual full-loop/source-refill theorem is still absent.
Use the real deterministic draw interface: the pinned KeyGen helper
`get_rng_u64`4706–4735 calls `shake_extract` on fk->rng. Do not replace it
by an IID word oracle or infer a distribution from the bound proof.

### 3.4 B1.05 Acceptance

The final result must consume actual source sampling/caller/solver
derivations and legal M0 memory/profile, and conclude the exact integer
NTRU identity about their same retained material. Discharge the remaining
`Bounds material` and caller-binding premises above; do not simply rename
the local validation helper as the successful-solver theorem. The M0 sampler
history supplies f/g bounds; arbitrary int16 solver inputs do not do so.

## 4. Later plan order

After B1.05 Acceptance: B1.06 public/inverse equations; B1.07 complete
caller/attempt/gate/material; B1.08–09 source codecs; B1.10 emitted-to-fiber;
B1.11 complete fresh replay/mutations/final handoff.
`emitted_to_actual_fiber` remains uninhabited. No serializer, solver,
certificate acceptance or source-completeness premise may fill a gap.

## 5. Traps — prior1–75 in Git, retained76–81, new82–87

76. The outer shell's120s timeout can interrupt a guarded job before its
    receipt. `_equation_020_001` is retained as INTERRUPTED_NO_RECEIPT with
    snapshots/raw logs, not accepted evidence. Use background notification
    or timeout0 for the shell wait; keep the runner's original limits.
77. `List.mem_cons` can unfold the singleton tail to `p∈[]`; simplify
    `List.not_mem_nil/or_false`. `sub_eq_iff_eq_add` uses `x=z+y`.
78. Dependent `cases` fixes some constructor indices, so binders may disappear.
    Use the actual constructor shape/`rename_i` instead of guessing names.
79. Explicitly name the post-assignment State when applying check theorems.
    Type inference from `images : Images before.heap ...` may choose the
    pre-assignment State despite the two States sharing the same heap.
80. Layout's raw record equality may not rewrite an opaque `output` term.
    First give it the typed equality `arrays.output slot=output root slot`.
81. Flat audit printing of a large simplification term can truncate despite
    a checked theorem. The annotation-free DAG exporter correctly rejected
    this term's metadata. The repaired proof uses rfl and the existing
    convert_self identity, with the same statement and complete flat audit.
    No annotation was silently dropped and no limit was increased. When
    rewriting `convert_self`, `Value.type` may obstruct syntactic rw; use
    congrArg on its checked equality, and fully type ambiguous `.uint32`.

Earlier active reminders: no deprecated if_true/if_false/dif_pos/dif_neg/
if_neg; use ite_true/ite_false/dite_eq_left/dite_eq_right. `from`, `at` and
`prefix` are reserved. Exec abbreviates GenExec. Scope restores actual local
slots. The source root/permutation and Montgomery scale remain fixed.

82. `variable` is also reserved in Lean. Use `var` for expression helpers.
83. Multi-field record updates with function-valued fields need unambiguous
    layout: newline after `with`, then aligned fields. Keep failed probes.
84. The inherited scalar type parser recognizes `int` but not `int32_t`.
    The new small-output grammar handles that precise typedef declaration
    under the pinned32-bit-int profile; it does not silently retag stores.
85. `Mathlib.Tactic.BVDecide` is unavailable in the pinned closure. The byte
    roundtrip reuses `StableBinaryByteView.flag_join_bytes`; no toolchain,
    limits, axioms or warnings changed to force a build.
86. `j<i` can tokenize unexpectedly; use `j < i`. For heap-updated records,
    infer `congrArg State.locals/arrays equal` before ascribing its simplified
    type. A generalized-shape induction may put the equality AFTER other
    arguments. Do not guess the induction hypothesis's binder order.
87. Standard Sage preparsing makes literal0 an Integer. Explicitly convert
    JSON boundary numerics to Python int. Compiler graph nodes identify
    translation units, not necessarily definition files; header inputs must
    remain pinned. GCC raw addresses/hashes are run-specific.

## 6. Resume protocol

1. Read source3/WORK_STATE, this checkpoint, EXECUTION_PLAN B1.05 and
   `run2/notes/B1_STAGED_ROADMAP.md`. Resume only B1.05; this window closed
   at a recoverable midpoint, not Acceptance.
2. Verify BATCH_015–021 pairs against section2/WORK_STATE. Verify all current
   BATCH_021 source/snapshot/olean/receipt/log/audit/control/graph pins and415
   final SOURCE_INPUTS. Check the1594 predecessor file pins in its preflight.
   Retain18 BATCH_021 attempts, all19 BATCH_020 attempts (including its
   no-receipt interruption) and all BATCH_018/019 attempts.
   `tools/keygen_small_batch.py` documents the checks
   but intentionally refuses to overwrite its historical receipt.
3. Confirm main, physical repo, ownership, status/staging/log and no live
   owned job. Preserve foreign work and use the shared archive.lock for Git.
   Source3 is the active lane; historical runner labels are provenance.
4. Resume section3 and KEYGEN_SOLVER_GRAPH_021.md: complete active source
   solver/caller execution and actual output-call bindings; derive full
   sampler f/g material using the checked post-refill tail, then consume
   the checked validation seam. The complete small-output bound is reusable.
   Use unique labels with `python3 -B tools/job_when_available.py lean LABEL
   Source3.Module...`. One guarded proof job, unchanged limits,0/0 logs.
   Rebuild affected cached descendants after any dependency change.
5. Exact calculations/checkers use `sage file.sage`, standard preparser,
   ZZ/QQ or rigorous intervals. HOME/TMPDIR/cache/logs/products stay in the
   durable component .build. Pinned C remains read-only; fixtures public.
6. Save small local commits. Close at B1.05 Acceptance or another expanded
   recoverable checkpoint with the next JSON/notes pair. No automatic push,
   review, worker/relay, migration or stages import.
