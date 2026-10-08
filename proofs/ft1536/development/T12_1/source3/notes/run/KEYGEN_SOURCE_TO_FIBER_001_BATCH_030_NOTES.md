# BATCH_030 — complete active root/caller, remaining pre-solver arrival

2026-10-08. GPT-6 Astra Ultrafast (`openai/gpt-6-astra-ultrafast`).
**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
**CLOSED_AT_RECOVERABLE_MIDPOINT; B1.05 Acceptance NOT MET.**
The context-discipline checkpoint closes the root/caller unit. The next
window resumes B1.05 with the pre-solver attempt prefix; B1.06 was not entered.
Historical runner model/session labels remain provenance.

## 1. Exact new boundary

The kernel-checked `KeygenRootCaller.success` has this boundary (names below
abbreviate the fully printed types in `ROOT_AUDIT.json`):

```text
ctx : KeygenSearchContext.Context
before, after : C99ArrayReference.State
v : C99IntegerReference.Value
input : Fin 4 → C99MemoryReference.ArrayPointer
primes, rev : C99MemoryReference.ArrayPointer
legal : KeygenRootCaller.Legal ctx before input primes rev
source : KeygenRootSource.Call ctx before after v
returned : v = int32 1
f, g : Geometry.Vec
fRepr : KeygenMaterial.Represents before.heap (input 0) f
gRepr : KeygenMaterial.Represents before.heap (input 1) g
fBound : KeygenIntegerLift.Bound f 1
gBound : KeygenIntegerLift.Bound g 1
---------------------------------------------------------------------
∃ F G,
  Bounds (material f g F G) ∧
  multiply f G - multiply g F = constantCoeffs (18433 : Int) ∧
  ∀ slot, Represents after.heap (input slot) (material f g F G slot)
```

`Legal` contains the actual fk/f/g/F/G caller pointer slots, input M0
context words, source-initialized PRIMES3 and REV10 objects, scratch
allocation/alignment/capacity, input widths and object/byte separation.
Its complete constructor and `Call`/`Exec` constructors are audited.
`Call` performs the actual five-pointer parameter Bind, executes the full
active M0 root composition, converts the return and restores caller slots.
There is no arbitrary callee, equation, F/G bound, heap-frame or Validation
premise. Static initialization/profile/allocation facts remain legal input
facts at this local root boundary.

**The incoming f/g representation and Bound1 are still premises.** They
must be obtained from the actual sampler and transported through the SAME
preceding attempt. This is why B1.05 Acceptance is not met. The new theorem
must not be presented as that missing enclosing-attempt theorem.

## 2. Root execution and retained material

### Search and control

`KeygenRootSearch` binds all55 physical prefix lines7282–7336: scalar and
pointer declarations, logn/member reads, the actual MKN calculation,
deepest gate, root dispatch, depth declaration/assignment, post-decrement
loop, intermediate gates, depth0 and scope restoration. All callees consume
the existing complete fixed source bodies. Rejection exits are retained.

`KeygenRootControl.dispatch_enabled` derives the active root dispatch from
the initial M0 words and the deepest byte frame. `loop_trace` derives actual
intermediate calls at depths `[9,8,7,6,5,4,3,2,1]` and final depth0 after the
false post-decrement test. The small-logn and binary arms remain pinned;
this is the active M0 reference path, not an all-profile theorem.

`material` preserves the SAME incoming f/g through deepest, every executed
intermediate, depth0 and either finite defined return. `output_caller`
derives logn10/n1536/F/G slots rather than requiring the old suffix Caller.

### Metadata and static objects

`KeygenMemoryStability.Stable` states size/writability preservation and
unchanged bytes in read-only objects. It follows from actual Store32,
Store64, memcpy, memmove and memzero semantics. `KeygenHelperStability`
and `KeygenSearchStability` propagate it through the complete fixed helper
closure, all control outcomes and root search. `KeygenRootObjects` transports
prime/size/REV10 objects, legal scratch and M0 context reads; the output gate
also has a derived metadata frame. Static bytes do not need the impossible
premise that a static object is disjoint from itself in the writable-name
overapproximation.

### Validation and return to the caller

`KeygenRootValidationSource` executes actual tmp/alias setup, conditional
prime selection, indexed p/g member reads, the ninv31 source call, generator
argument Bind, generator body, coefficient conversion, four NTT calls,
target and comparison. `prepared` derives the source prime; `generator_entry`
derives the complete Mkgm3 entry from those same arguments and static objects.

`KeygenRootValidation.validation` constructs EVERY field of the inherited
Validation record. It is now a result, not a premise. `KeygenRootSource.success`
composes search, output bounds and this validation on shared heaps.
`KeygenRootCaller.success` handles actual caller Bind and return conversion.
The same final arrays satisfy the existing integer lift, including the
37748737 residual bound and modulus2147355649. No Babai/Bezout arithmetic
correctness assumption is used to obtain the equation.

`KeygenRootCoverage.complete_body` partitions all115 physical body lines
7282–7396 into the certified search, output/setup, generation, conversion,
transform dispatch/calls/target, inactive arm and comparison regions. The
header, closing brace, MKN macro and M0-selected actual caller gate8097–8106
are bound separately.

## 3. Pins and checks

Entry check BEFORE any source edit/job: BATCH_015–029,4243 distinct pins,
527 current inputs,no supersession,no active job.
`.build/levels_030/ENTRY_PINS_030.json` SHA256
`081d46659ff070cf49dc92446b8b84f3d694372b77c586b9c51120ba21133c6a`.
Preseal checks the identical predecessor closure:
`.build/levels_030/PRESEAL_PREDECESSOR.json` SHA256
`e0a9ebcb4465c8f2a2ffb03a0d64ff478b8f5af5814e824957eb6ca6507313e3`.

Twelve current accepted Lean modules including the audit, all0/0 streams.
The full audit has173 entries:149 new named declarations and24 inherited
interfaces,145 complete terms and28 inductives/structures with full
constructor types. Only propext/Classical.choice/Quot.sound; zero elisions.
The19538876-byte audit stays in
`.build/jobs/keygen_root_audit_030_001/ROOT_AUDIT.json`, with tracked generator
`tools/keygen_root_audit_source.py` and tracked producer
`formal/Source3/KeygenRootAudit.lean`.

- Audit SHA256: `f2ccbea7495f2df6fe26e3f10dcaa52a0b376c7b782cf4bbf41efb3ada1ba0a8`.
- Audit RECEIPTS SHA256: `e3221ba0f193d46c7afb349a5d20ee2462d1fd03911dfa49a96eae5c2073d262`.
- Current final audit inputs:539.
- Maximum accepted cumulative RSS:4917460KiB; all limits unchanged.

Exact controls: `sage/check_keygen_root.sage`, guarded job
`keygen_root_checks_030_001`, standard Sage preparser/ZZ,73.693s,0/0 streams.
Ten normal/UBSan runs ×14 public synthetic cases; four mutations detected in
both modes. Instrumented copies and every compiler/runtime stdout/stderr
are retained. Each baseline has nine successful bounded-input cases, three
random-looking public bounded-input rejections, one constant bounded-input
rejection and one successful constant helper case outside MODE1 bounds.
Every successful case has the exact ZZ quotient equation, bound2047,
unaltered f/g/context/sentinels and full depth trace with terminal zero.
Public deterministic fixtures are not private KeyGen outputs or evidence
of the real sampler law. Finite checks are not the universal theorem.

Mutations: skip depth1; wrong final target18434; overwrite retained f after
validation; swap the first small-output source. All are rejected by the
recorded frame/trace/equation/baseline comparisons.

Twenty-six attempts/27 steps retained:12 wholly accepted,13 failed,one
accepted-but-superseded source-order draft. The mixed failed control job's
Search step is the current accepted Search artifact. The JSON records
source/snapshot/olean bindings and full raw attempt history without erasing
earlier failures. No broad unchanged replay or independent review.

## 4. Traps142–150

142. Restore `depth` AFTER depth0, not between the loop and depth0. The first
accepted Search draft (`search_030_004`) had the earlier restoration; it was
superseded before its first source commit. The corrected `DepthBody` keeps
the actual source ordering. That draft remains explicitly non-evidence.
143. The final false `depth-- > 1` test changes1 to0. Loop semantics that
leave1 are wrong even when the list of called depths looks plausible.
144. Static-byte preservation needs read-only write semantics. The generic
table-pointer footprint cannot prove a table disjoint from itself.
145. Local inference may identify two States merely because their heaps
are definitionally equal. Name the actual State or derive the result in a
local `have` before composing; do not weaken the binding relation.
146. A `cases` on a call indexed by `out.state` can fail dependent elimination.
Use a separate slot-preservation theorem and compose its equalities.
147. C parameter Bind starts from globals/tables, not arbitrary caller
locals/arrays. Derive static array lookup from caller.tables and each of
the five explicit pointer arguments from the actual zero-offset access.
148. The generator Bind has repeated uint32 conversions. Normalize them
with a typed conversion lemma before assembling Entry; one retained attempt
hit the unchanged2000000-heartbeat limit through implicit definitional
unification. No larger limit or suppressed diagnostic was used.
149. Generic composition automation must name the intended `Stable` theorem;
unqualified `trans` is ambiguous. Incorrect memmove projections and routine
syntax/import errors remain in failed snapshots/logs.
150. Whole-root success with incoming Bound1 is not sampler-to-root success.
The in-range public fixtures establish nonempty finite controls, not the
missing universal pre-solver source/material composition.

## 5. Remaining, in plan order

1. Actual sampler caller: resolve fk->rng subobject/layout and active profile,
   provide the source-initialized static environment and transport it.
2. Compose the existing two sampler calls and resultant gates with raw bound
   initialization7958–7964, raw norm and the complete GS body/gate7995–8019.
   Bind the missing `falcon_poly_mulconst_fft3` alias/helper explicitly.
3. Full operational `falcon_compute_public` closure from pinned
   `falcon-vrfy.c`1521–1547, including the automatic t array, uint16 stores,
   actual mq transforms/division and every failure. Only material preservation
   is needed here; public/inverse algebra remains B1.06.
4. Derive RootCaller.Legal and the incoming f/g Represents/Bound1 from that
   SAME attempt prefix; consume `KeygenRootCaller.success`. No arbitrary
   prefix/frame, assumed source coverage or stronger key-population filter.
5. Close B1.05 Acceptance only after that composition. Do not redo the root
   call graph, helper frames, generator binding or Validation construction.

Source commits: `691b965e`, `2fa9a920`, `095f1ba9`, plus the coverage/control/
audit-tools commit and the final batch/checkpoint commit. Exact owned paths
under the shared archive.lock, main as niirmataa. No push, review, worker,
relay, stages import, migration or foreign-file modification by this worker.
