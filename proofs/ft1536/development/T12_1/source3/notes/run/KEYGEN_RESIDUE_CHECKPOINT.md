# KEYGEN_SOURCE_TO_FIBER_001 — B1.04 expanded recovery checkpoint

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
2026-10-07: owner-scoped B1.04 window closes at a **recoverable midpoint**
under `run2/notes/B1_STAGED_ROADMAP.md` rule3. **B1.04 Acceptance NOT met.**
Next window resumes B1.04; B1.05 has not been entered. No owned job or
unresolved Lean draft remains. Resume protocol is in **section6**.

Harness: GPT-6 Astra Ultrafast (`openai/gpt-6-astra-ultrafast`); unchanged
runner labels remain historical provenance. Latest pair:
`KEYGEN_SOURCE_TO_FIBER_001_BATCH_018.json` + `_018_NOTES.md`.
B1.03 Acceptance was recorded by `0a72596b` in `run2/notes/B4_SYNTHESIS.md`.
Earlier checkpoint bytes/traps and all failed attempts remain in Git/jobs.

## 1. Closed this window — checked source and mathematical seams

Four local source commits on main as niirmataa: `bb2ca842`, `cd23c3f1`,
`6f7cde92`, `1a9f4ef3`. This pair/checkpoint has its own final documentation
commit. All writer windows use `proofs/ft1536/work/archive.lock` and exact
owned paths. Foreign changes are preserved; no push or independent review.

| Module (under formal/Source3) | Checked result |
|---|---|
| `KeygenNttCells` | Existing source first/binary/triple executions yield canonical ordinary-residue cells, exact formulas, actual store order and disjoint-cell preservation. |
| `KeygenNttFirstValues` | Actual gm[1] read and all768 first butterflies, physical low/high halves and complete first-pass frame. |
| `KeygenNttPolynomial` | Conversion's original Vec to cells; same existing CoefficientQuotient.polynomial; two exact degree-<768 remainders; source w^2-w+1=0 and Phi factorization. |
| `KeygenNttFirstComposition` | Actual table generation → coefficient conversion → NTT prologue → first pass; same Vec and preserved gm; no canonical-result/initialized-gm premise in this composition. |
| `KeygenNttGeometry` | Header t*m=1536, different ht*m=768 update seam, source binary positions/twiddle bounds, complete coverage and source exit m=512,t=3. |
| `KeygenNttRoots` | Kernel primality, exact row9/REV10 triple point family,1536 distinct Phi roots and degree/root-count injectivity. |
| `KeygenNttBinaryValues` | Complete executed radix-2 vLoop, canonical full array and unchanged cells outside its block; actual gm[m+u1] scaled-value read. |
| `KeygenNttSubpolynomial` | Exact degree-<ht low/high remainders in those same vLoop output cells; evaluation identities and final quadratic polynomial. |
| `KeygenNttEvaluation` | Existing quotient multiply/subtract respect point evaluation; coefficient equation follows from pointwise equalities. |
| `ExprAuditDag`, `KeygenNttValuesAudit` | Internal85-export audit, complete terms/constructor types and lossless shared prime-proof DAG. |

### 1.1 Exact source-chain boundary

`KeygenNttFirstComposition.generated_converted_prefix` consumes the
BATCH_017 generator Entry/source execution, p0i source initialization,
legal scratch/input separation, the original four Vec byte representations
with bound2047, actual coefficient conversion, and NTT prologue/firstPass
executions. It also consumes the explicit caller pointer/scalar bindings
and equal returned/next-entry heaps. It concludes normal flow and:

```text
KeygenNttFirstComposition.Contract nttEntry.heap out.state.heap
  (arrays.output slot) (KeygenMkgm3Layout.gm scratch) (material slot)
```

Contract expands to `FirstImage`, `RemainderImage`, preserved initialized
gm and a disjoint-cell frame. Full actual type/term is in the85-export
audit. The original Vec is the same witness before table generation and
after conversion. The enclosing caller must still supply the fragments;
this theorem does not claim the full NTT body or allocator/caller proof.

The first output halves represent remainders modulo `X^768-C w` and
`X^768-C (1-w)`, where `w=h^768`, `h=g^2`, `g=1907584673` in ZMod2147355649.
The kernel proves `w^2-w+1=0` and the factorization of the existing Phi.

### 1.2 Binary blocks and final point family

`KeygenNttSubpolynomial.source_remainders` consumes the **entire vLoop**
with canonical entry cells, scaled twiddle, legal block extent/positions,
local bindings and p0i execution. It derives canonical output cells,
the exact remainders modulo `X^ht-C s` / `X^ht-C (-s)` and preservation
outside the block. `load_twiddle` separately derives the actual source
gm[m+u1] value. Joining that read/binds/vLoop through u1/m is still open.

The fixed physical point family is
`point(i)=h^(E(512+i/3)+1536*(i%3))`, `i : Fin1536`.
`triple_order` identifies `3*j+k` with `h^E(512+j)*unity^k`,
`unity=w^2`, `k<3`. These are1536 distinct Phi roots.
`KeygenNttEvaluation.equation_of_pointwise` proves
`multiply f G-multiply g F=constantCoeffs rhs` over ZMod2147355649 from
the pointwise equations. It does not derive those equations from the
whole source transform or perform the integer lift.

## 2. Pins, validation and recoverable artifacts

Start preflight:1031 distinct file checks, BATCH_015–017 pairs and all382
current inputs of final BATCH_017 audit matched, no active proof job.
`.build/ntt_values_018/PREFLIGHT.json`:
`cffb1bdd4684ffe06da48b4bf98d1c6c83ade8faf1879eef786de83ac88cc18f`.
At sealing, all393 current final-audit inputs match.

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

All11 modules have accepted current source/snapshot/olean/receipt bindings
with0/0 logs. Max accepted RSS3451292KiB. There were29 attempts,17 failed,
all retained and pinned in BATCH_018. Checking was incremental, not a new
whole-project replay. Reference/parser and predecessor proof files were
not modified. Limits and warning policy are unchanged.

The85-entry audit has81 complete pretty terms,3 kernel structures with
expanded constructor types, and a277341-node prime-term DAG (6602246 bytes).
Flat printing that shared proof exhausted memory in audit_001/002; _002
retains52 complete entries plus the current-name progress. The DAG's
serialized JSON is parsed back into a structurally equal Lean Expr before
acceptance. Standard axioms only; no elisions. The artifact is regenerated
by the tracked audit module and remains in durable .build with its pin.

Sage/C finite controls passed (14 normal/UBSan runs,3 public arrays each,
10 snapshots ×1536 words). They compare first/eight middle/final snapshots
and direct polynomial evaluation in physical output order. Six mutations
detected in both modes; gm and guard cells preserved. Failed initial
mutation compilation is retained. These controls do not replace the
missing universal source-transform theorem.

## 3. In-flight boundary and exact next obligations

**No active job and no unresolved Lean draft.** The following are missing
proofs, not existing exports or added assumptions. Continue B1.04 here.

### 3.1 u1Inner, u1 and m source composition — next action

First join the actual `sAssign`, `v1Bind`, `htBind` and `vLoop`, including
their source scopes/declarations. The next u1-block conclusion is:

```text
out.flow = normal
Cells out.state.heap p 1536
  (KeygenNttBinaryValues.values a (j*t i) (ht i)
    (h^E(m i+j)))
KeygenMkgm3Table.Initialized out.state.heap gm
```

Here `i≤7`, `j<m i`, `m i=2^(i+1)`, `t i=768/2^i`, `ht i=t i/2`;
the inputs are the same before.heap cells/table, legal separated buffers,
actual m/u1/v1/ht/stride/p/p0i and a/gm bindings, p0i source initialization,
and `Exec (block u1Inner) before out`. Derive positions and table word
through execution, then apply the already checked `load_twiddle` and
`loop_values`/`source_remainders`. The desired output is not a premise.

Then compose every u1 and all8 m rounds with polynomial/table/frame
invariants. B1.02's `U1Run.nested` does **not** carry equality of its s0.heap
with before.heap, and `RoundRun.nested` does not connect both heaps/locals
of the nested trace to its enclosing round. Re-invert the existing Exec
seams to derive those connections; do not assume them or treat a free
nested-trace State as the same memory. Keep the old B1.02 proofs unchanged
unless an actual dependency change is justified and all descendants rebuilt.

### 3.2 Polynomial twiddle-child propagation

The existing even-child cube/square laws are usable. Needed next are the
odd-child sign laws modulo4608 and their root/degree transports:

- for `2≤r<256`: `(2*E(2*r+1)) %4608=(E(r)+2304)%4608`;
- for `256≤r<512`: `(3*E(2*r+1)) %4608=(E(r)+2304)%4608`;
- bridge the existing h^2304=-1 word certificate into the field;
- handle the top separately: gm[3]'s square is **1-w**, not -w.

These formulas are next proof targets, not newly certified finite tables.
Use the source row/exponent definitions, not a convenient replacement
ordering. Compose `KeygenNttSubpolynomial` remainder/evaluation identities
to keep each physical block tied to the original CoefficientQuotient
polynomial. Preserve the degree bound as t halves.

### 3.3 Triple loop and complete transform

Derive the actual `wSquared` value from the preserved gm[1] and source
Montgomery call; use `unity_cube`. Compose all512 actual triple iterations
with `KeygenNttCells.triple` and the prior degree3 block remainder invariant.
`KeygenNttRoots.triple_order` fixes the physical ordering already.

The still-missing whole-transform result, for the same source execution,
is exactly:

```text
forall i : Fin 1536, exists word,
  Load32 out.state.heap (element p i.val) word
  and Canonical word
  and value word = (CoefficientQuotient.polynomial
      (KeygenNttPolynomial.castVec originalVec)).eval (KeygenNttRoots.point i)
```

Compose the existing parsed `forwardBody` parts through common States,
then extend `generated_converted_prefix` to the full transform so canonical
inputs/tables are derived from the preceding source executions. Only then
close B1.04 Acceptance. The whole solver must supply legal memory/profile
and source execution, not the desired transform result.

## 4. Remaining execution-plan order after B1.04

B1.05 solver/source success → modular equation → integer lift;
B1.06 public/inverse equations; B1.07 whole caller/attempt/gate/material;
B1.08–09 actual secret/public codecs; B1.10 emitted-to-fiber;
B1.11 complete fresh replay/mutations/final handoff.
`emitted_to_actual_fiber` remains uninhabited. No solver/serializer,
acceptance or source-completeness premise may fill a missing proof.

## 5. Traps — earlier1–61 remain in Git; new62–69

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

## 6. Resume protocol

1. Read source3/WORK_STATE, this checkpoint, EXECUTION_PLAN B1.04 and
   `run2/notes/B1_STAGED_ROADMAP.md`. One owner-scoped stage per window.
   Do not treat historical B1.03 next-step headers as the current task.
2. Verify BATCH_015/016/017 **and018 pairs** against the pins above. Then
   verify BATCH_018's current module/snapshot/olean/receipt/log/audit/DAG
   pins and the393 final SOURCE_INPUTS. Keep all29 attempts. The organizer
   `tools/keygen_ntt_batch.py` explains the checks, but intentionally refuses
   to overwrite an existing historical receipt.
3. Confirm main, physical repo, ownership, Git status/staging/log and no
   owned live job before starting another. Respect the shared Git writer
   lock and preserve foreign work. The interruption-resume check during
   this window matched all then-current8 proof modules and found no job.
4. Continue section3.1. Use unique labels and
   `python3 -B tools/job_when_available.py lean LABEL Source3.Module...`.
   One guarded proof job, unchanged limits and0/0 logs. Rebuild affected
   cached descendants after dependency changes. No duplicate worker/relay.
5. Exact calculations/checkers use `sage file.sage` with the standard
   preparser; all HOME/TMPDIR/cache/logs stay in durable component .build.
   The C inputs remain pinned, public/synthetic and read-only.
6. Save small logical local commits. Close at B1.04 Acceptance or another
   recoverable midpoint with a fresh expanded checkpoint and the next
   batch JSON/notes pair. No automatic push, review, migration or import.
