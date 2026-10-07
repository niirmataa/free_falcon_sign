# KEYGEN_SOURCE_TO_FIBER_001 — B1.04 Acceptance checkpoint

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
2026-10-07: owner-scoped B1.04 window **CLOSED AT ACCEPTANCE** under
`run2/notes/B1_STAGED_ROADMAP.md`. Stage result **PROVED_KERNEL_SCOPED**;
the package status above remains unchanged. Next owner-scoped stage is
B1.05, which has not been entered. No owned job or unresolved Lean draft
remains. Resume protocol is in **section6**.

Harness: GPT-6 Astra Ultrafast (`openai/gpt-6-astra-ultrafast`); unchanged
runner labels remain historical provenance. Latest pair:
`KEYGEN_SOURCE_TO_FIBER_001_BATCH_019.json` + `_019_NOTES.md`.
B1.03 Acceptance was recorded by `0a72596b` in `run2/notes/B4_SYNTHESIS.md`.
Earlier checkpoint bytes/traps and all failed attempts remain in Git/jobs.

## 1. Closed this window — checked source and mathematical seams

Three local source commits on main as niirmataa: `e58e2a51`, `6e6b98d0`,
`7665543b`. This pair/checkpoint has its own final documentation commit.
All writer windows use `proofs/ft1536/work/archive.lock` and exact owned
paths. Foreign changes are preserved; no push or independent review.

| Module (under formal/Source3) | Checked result |
|---|---|
| `KeygenNttControl` | Scalar/pointer frames and actual block-local restoration, derived from Exec. |
| `KeygenNttMiddleValues` | Actual u1Inner declarations/gm read/pointer binds/vLoop; all u1 blocks and8 m rounds, canonical source-ordered arrays, gm and disjoint-cell preservation through common heaps. |
| `KeygenNttTripleValues` | Source wSquared value from gm[1] reads/Montgomery, all512 triple iterations, exact physical quadratic outputs. |
| `KeygenNttExecution` | Complete existing forwardBody split/composition through common States; prologue/local slots and canonical full butterfly array. |
| `KeygenNttTwiddleCert` |32 kernel chunks on source rowExponent/REV10:510 non-top signed child identities,512 bounded candidates; byte-identical Sage generation. |
| `KeygenNttTwiddleTree` | Even/odd square/cube transports, h^2304=-1, exceptional gm[3]²=1-w, actual leaf point powers. |
| `KeygenNttRoundPolynomial` | Sequential block identities, degree-bounded physical polynomials and evaluation transport through all8 rounds; transform_evaluation for every coefficient vector/index. |
| `KeygenNttTransform` | Full1536-cell canonical/evaluation theorem, extended through actual preceding table generation and coefficient conversion. |
| `KeygenNttTransformAudit` | Internal131-entry complete type/term/axiom audit, including exact final premises and source binding exports. |

BATCH_018 remains the checked dependency for Cells/FirstValues/Polynomial,
FirstComposition/Geometry/Roots/BinaryValues/Subpolynomial/Evaluation,
its85-entry audit and the lossless prime-proof DAG. Its source commits
`bb2ca842`, `cd23c3f1`, `6f7cde92`, `1a9f4ef3` and midpoint checkpoint
`a37e48e5` remain historical; their open B1.04 seams are now discharged.

### 1.1 Exact source-chain boundary

`KeygenNttTransform.generated_converted_transform` consumes the BATCH_017
generator Entry/source execution, p0i source initialization, legal
scratch/input separation, original four Vec byte representations with
bound2047, actual coefficient conversion and the **complete forwardBody**
execution. Actual caller pointer/scalar bindings and equal returned/next
entry heaps are explicit. It concludes normal flow and:

```text
KeygenNttTransform.Contract nttEntry.heap out.state.heap
  (arrays.output slot) (KeygenMkgm3Layout.gm scratch) (material slot)
```

Contract expands to the following Image, preserved initialized gm and a
disjoint canonical-cell frame:

```text
forall i : Fin1536, exists word,
  Load32 out.state.heap (element p i.val) word
  and Canonical word
  and value word = (CoefficientQuotient.polynomial
    (KeygenNttPolynomial.castVec originalVec)).eval (KeygenNttRoots.point i)
```

The full actual type/term and premise definitions are in the131-entry
audit. The same original Vec is retained from before generation to the
NTT output. Canonical inputs/initialized gm are derived in the composition;
neither the desired NTT result nor a source-completeness/callee oracle is
a premise. Legal caller/profile/material and actual source executions are
the boundary. The enclosing solver/caller must still supply those bindings.

### 1.2 Binary blocks and final point family

`KeygenNttMiddleValues.inner_values` derives the actual read/bind/vLoop
connections. The old U1Run/RoundRun free nested States are not silently
identified with enclosing memory. The actual iterations are re-inverted,
and all prefix/suffix heap equalities follow from their source executions.
The sequential block array equals the exact low/high child polynomials;
the inherited degree-<ht remainder identities apply to those same arrays.
The evaluation invariant follows from the signed twiddle-child laws and
the exceptional top complement, with lengths768→384→...→3.

Here h=g², g=1907584673 in ZMod2147355649, and w=h^768. The fixed physical point family is
`point(i)=h^(E(512+i/3)+1536*(i%3))`, `i : Fin1536`.
`triple_order` identifies `3*j+k` with `h^E(512+j)*unity^k`,
`unity=w^2`, `k<3`. These are1536 distinct Phi roots. All512 source triple
iterations now evaluate the final degree-<3 block polynomials there.
`KeygenNttEvaluation.equation_of_pointwise` proves
`multiply f G-multiply g F=constantCoeffs rhs` over ZMod2147355649 from
the pointwise equations. The whole source transform now supplies actual
evaluations; the successful solver comparison and integer lift are B1.05.

## 2. Pins, validation and recoverable artifacts

Start preflight:1204 distinct file checks, BATCH_015–018 pairs and all393
inputs of the final BATCH_018 audit matched, no active proof job.
`.build/ntt_composition_019/PREFLIGHT.json`:
`37dfa7eff55c01b8fa269825943301b1d114d52f4f8275956d3b22467647dda1`.
At sealing, all402 current final-audit inputs and all1204 predecessor files
match. Exact module/artifact/import pins and all attempts are in BATCH_019.

- **BATCH_019 JSON:** `983a481a10293c01bf80250a9dd4ad2797e351db0a3c5d41825845d80fde6098`.
- **BATCH_019 notes:** `289d85f0ec1f25fe5950ad6b182363afe9ede0484c3053cf0c915d9cd52b1c01`.
- Final transform source: `0f60483e60ec1f37664d8fc788894144e8cc7e96f504845f786c4c4ec4f3d68a`.
- Round-polynomial source: `a9a7b49ed26e22c9c7a33310df1f95d3c36a92cd822673aa2bf29a68a420128d`.
- `.build/jobs/keygen_ntt_transform_audit_019_002/RECEIPTS.json`:
  `a1d285c9b286c68449e89ddbbbfadbd0df79a7f1aca4e6b47d50dbdb433005aa`.
- Same job `SOURCE_INPUTS.json`:
  `30248a21172622c868791591960a595bd584b5b3c60c9710165fd03dbefa9a1c`.
- Same job `NTT_TRANSFORM_AUDIT.json`:
  `b0c28ef18d7adac420967897725867f5e8bc59ab980f0500b4c16558d68e50de`.
- `.build/jobs/keygen_ntt_children_gen_019_001/NTT_CHILDREN_GENERATION.json`:
  `90bff537f6d9452b152aa40356726070d04472a58bb01edab286035cf1c21610`.
- Generated/tracked child certificate:
  `fc255abb3660434efd791db0117d3af623fff218c52e717505a4b5a9c6418320`.

- **BATCH_018 JSON:** `f4e28b724e588b7e91cdb429646dfefe5939332f307f0ae15dc282369edc72cf`.
- **BATCH_018 notes:** `c19d5c9cb893793dd6ff23fa232271fcfe704f0821160de1a1e2065551bd546d`.
- First composition source: `9c1321ba3e9880b8b918cab0d0a83d5726c5959bf352da9f2a6021a007a297de`.
- Binary values source: `63fb1628299aee4ef9045086694b011423aea680918cf03ef96c78f42712e39c`.
- Subpolynomial source: `b95e7dfeba6b2442246b58b965348f3ffaea656666beb550935f3694607174e0`.
- `.build/jobs/keygen_ntt_values_audit_005/RECEIPTS.json`:
  `f27763d473c53e98a7f88f7ec7a4383401b72e0592104b56a6e635c60f627aaa`.
- Same job `SOURCE_INPUTS.json`:
  `d84223a8198e1dbe6665400122b27401cf1f4ea84f52f3919199f12f37940cb5`.
- Same job `NTT_VALUES_AUDIT.json`:
  `d2a382db71b59da88b80211cb5f76c2cae14557593b88f8d550649d9d3311245`.
- Same job `NTT_PRIME_TERM_DAG.json`:
  `66888cfd48b56990145d0dca30c6c6691d2aa52da2771a91c76aebcc08cb9534`.
- `.build/jobs/keygen_ntt_values_checks_002/NTT_VALUES_CHECK.json`:
  `d07d2d5787ca5a2dffbcc1262b0bd63e0ee66e84dc5b0704cc8b6c68970d372e`.
- BATCH_017 JSON: `50f35519c32d1d16dd6987b781ac43e59cc835dd076ce15f146a1fe9ac9cbc0b`;
  notes: `814660ca606d29600793dc3e61e5903b05ef56e83042b4d6aba131f86c6f28d6`.
- BATCH_016 JSON: `cc28381bb1188400d0ea1d15e3c83ba045a2e5476a9644ee4dd0585c58e2b25f`;
  notes: `e323ac9783e41e2143638088af6cfb0453b756a8418273b62bd961c1b0695419`.
- BATCH_015 JSON: `b5bb63f5ddfb423ff6a4742dfd2893bcc7587b4cb50f51877b9b3910285be134`;
  notes: `aec981ffab3f9065ac10d6d99f4f931ceccd852f237382e3b0240b64fbe53cd8`.

All9 new modules have accepted current source/snapshot/olean/receipt
bindings with0/0 logs. Max accepted RSS2864452KiB. There were19 attempts,
8 failed, all retained and pinned in BATCH_019. Failures were syntax/API/
linter/elaboration issues, not mathematical counterexamples. Checking was
incremental, not a new whole-project replay. Reference/parser and
predecessor proof files were not modified. Limits/warning policy unchanged.

The131-entry new audit has128 complete terms and3 kernel structures with
expanded constructor types. Only standard axioms; zero elisions. Its
11906748-byte JSON is regenerated by the tracked audit module and remains
in durable .build with its pin. The unchanged predecessor's85-entry audit
and277341-node round-tripped prime-term DAG remain BATCH_018 dependencies;
its earlier flat-print failures and all29 attempts are preserved.

Inherited BATCH_018 Sage/C finite controls passed (14 normal/UBSan runs,3 public arrays each,
10 snapshots ×1536 words). They compare first/eight middle/final snapshots
and direct polynomial evaluation in physical output order. Six mutations
detected in both modes; gm and guard cells preserved. Failed initial
mutation compilation is retained. These unchanged controls were not rerun.
The new universal source-transform theorem is the checked Lean proof above;
the new Sage job generated/checked source exponent candidates only.

## 3. Clean boundary and exact next obligations

**No active job, unresolved draft or remaining B1.04 obligation.** The
next work belongs to **B1.05 in a new owner-scoped window**. These are
missing enclosing proofs, not new assumptions or claims of completion.

### 3.1 Four-transform solver sequence and successful check

Compose the actual ft/gt/Ft/Gt calls, keeping each original material and
all four output arrays through common States. Apply `source_transform`
and its canonical-cell frame with the actual disjoint layout; do not apply
four independent fresh-conversion theorems to unrelated heaps.
Derive the p,p0i,r,n and pointer slots of
`KeygenCheckLoopBridge.accepted_coordinates`, including the actual
`modp_montymul(18433,1,p,p0i)` target initialization. Its successful parsed
comparison yields the pointwise equations. Connect the exact loaded words
to NTT Image, then consume `KeygenNttEvaluation.equation_of_pointwise`.

### 3.2 Original material, bounds and exact integer lift

Bind the complete active source call graph, `poly_big_to_small`,
`zint_one_to_plain`, and MODE1 sampling. The same retained f/g need Bound1;
the actual F/G need Bound2047. The existing NTT Frame is only for canonical
32-bit cells; derive any needed original16-bit material byte preservation
from actual writes rather than claiming it follows automatically.

The existing integer-lift theorem requires exactly:

```text
hf : Bound f 1, hg : Bound g 1
hF : Bound bigF 2047, hG : Bound bigG 2047
check : mapCoeffs (Int.castRingHom (ZMod2147355649))
          (KeygenIntegerLift.residual f g bigF bigG) = 0
```

It concludes `multiply f bigG-multiply g bigF=constantCoeffs (18433:Int)`
using residual bound37748737. All premises above must be derived from the
same source solver execution and retained material. No `solver_correct`,
desired equation or unproved source-completeness premise may fill a gap.

## 4. Remaining execution-plan order after B1.04

B1.05 solver/source success → modular equation → integer lift;
B1.06 public/inverse equations; B1.07 whole caller/attempt/gate/material;
B1.08–09 actual secret/public codecs; B1.10 emitted-to-fiber;
B1.11 complete fresh replay/mutations/final handoff.
`emitted_to_actual_fiber` remains uninhabited. No solver/serializer,
acceptance or source-completeness premise may fill a missing proof.

## 5. Traps — earlier1–61 remain in Git; retained62–69 and new70–75

62. `if_true/if_false` and `dif_pos/dif_neg` are deprecated under this
    toolchain's warning-as-error policy; use ite_true/ite_false and
    dite_eq_left/dite_eq_right. Do not suppress warnings.
63. Rewriting a proposition inside ite by `rw` can break the dependent
    Decidable instance. Use `simp only [the_equivalence]`.
64. `simpa only` may not unfold element or normalize pointer-index sums.
    Include element/Nat.add_assoc explicitly; normalize Result.state
    projections before subst. `prefix` is still a reserved identifier.
65. Explicitly instantiate a chain's head/tail before its supported proof;
    the two historical chain definitions need not be inferred from metas.
66. R=ZMod2147355649 needs a Nontrivial instance for polynomial remainders;
    its Field/IsDomain instance also needs the proved Fact Prime and
    Mathlib.Algebra.Field.ZMod. natDegree_lt_iff_degree_lt takes p≠0;
    handle the zero polynomial explicitly.
67. `t*m=1536` is a header invariant, not an invariant between the separate
    t and m assignments. Preserve the ht*m=768 seam and its update order.
68. Pretty printing may expand expression sharing beyond memory limits.
    Retain failures and export a lossless, structurally round-tripped DAG;
    do not omit the prime term, claim a truncated print complete or raise
    the proof/resource limits. audit_004/005 demonstrate the checked route.
69. Replacing only fC2 by fC1 makes fC2 unused and is stopped by -Werror.
    Swap both final cross operands to obtain an executable semantic mutant.
70. `from` and `at` are reserved identifiers. Use origin/tripleValue.
    Syntax failures can generate internal error-recovery placeholders in
    failed Lean logs; only clean accepted artifacts belong to the proof.
71. Exec is an abbreviation of GenExec. Explicit constructor applications
    use `C99ModularReference.GenExec.seqNormal` or a typed `.seqNormal`.
72. `if_neg` is also deprecated here. Use `simp only [ne,ite_false]`.
    Do not silence the warning-as-error policy.
73. With List.mem_cons unfolding to the empty tail, explicitly simplify
    List.not_mem_nil/or_false before a three-way equality split.
74. Fin.ext goals may retain an opaque value projection; `change` to the
    concrete Nat equation before omega. Unfold TripleValues.root before
    rewriting a point formula that displays its underlying exponent.
75. Double-backtick names resolve declarations, not bare namespaces.
    Use a single-backtick namespace when assembling audit chunk names.

## 6. Resume protocol

1. Read source3/WORK_STATE, this checkpoint, EXECUTION_PLAN B1.05 and
   `run2/notes/B1_STAGED_ROADMAP.md`. One owner-scoped stage per window.
   Start only the stage assigned by the owner. This B1.04 window is closed.
2. Verify BATCH_015–019 pairs against the pins above. Verify BATCH_019's
   current module/snapshot/olean/receipt/log/audit pins and all402 final
   SOURCE_INPUTS. Retain the19 new and29 predecessor attempts. The organizers
   `tools/keygen_ntt_transform_batch.py` and `tools/keygen_ntt_batch.py`
   explain the checks but intentionally refuse to overwrite old receipts.
3. Confirm main, physical repo, ownership, Git status/staging/log and no
   owned live job before starting another. Respect the shared Git writer
   lock and preserve foreign work. Source3 is the confirmed active lane;
   historical runner labels remain provenance. No owned job is live.
4. The next owner stage starts from section3 and EXECUTION_PLAN B1.05.
   Use unique labels and
   `python3 -B tools/job_when_available.py lean LABEL Source3.Module...`.
   One guarded proof job, unchanged limits and0/0 logs. Rebuild affected
   cached descendants after dependency changes. No duplicate worker/relay.
5. Exact calculations/checkers use `sage file.sage` with the standard
   preparser; all HOME/TMPDIR/cache/logs stay in durable component .build.
   The C inputs remain pinned, public/synthetic and read-only.
6. Save small logical local commits. Close at the assigned Acceptance or a
   recoverable midpoint with a fresh expanded checkpoint and the next
   batch JSON/notes pair. No automatic push, review, migration or import.
