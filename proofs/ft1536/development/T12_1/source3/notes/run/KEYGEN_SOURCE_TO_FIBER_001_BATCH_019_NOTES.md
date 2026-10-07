# BATCH_019 — B1.04 Acceptance: the complete source NTT

2026-10-07. **B1.04: PROVED_KERNEL_SCOPED / Acceptance MET.**
The owner-scoped window closes here. The enclosing
KEYGEN_SOURCE_TO_FIBER_001 package remains **PARTIAL_PROOF / IN_PROGRESS /
NOT_REVIEWED / WORKING_NOT_FROZEN**. B1.05 was not entered.

## 1. Result and actual premise boundary

`KeygenNttTransform.source_transform` consumes the **complete existing
parsed `forwardBody` execution**, not separate freely chosen pass heaps.
It concludes normal flow and this contract for the same original Vec:

```lean
def Image (heap : Memory) (p : ArrayPointer) (v : Geometry.Vec) : Prop :=
  ∀ i : Fin 1536, ∃ word, Load32 heap (element p i.val) word ∧
    KeygenNttButterflyAlgebra.Canonical word ∧
    KeygenNttWordAlgebra.value word =
      (CoefficientQuotient.polynomial (KeygenNttPolynomial.castVec v)).eval
        (KeygenNttRoots.point i)

def Contract (before after : Memory) (p gm : ArrayPointer)
    (v : Geometry.Vec) : Prop :=
  Image after p v ∧ KeygenMkgm3Table.Initialized after gm ∧
    KeygenNttFirstValues.Frame before after p
```

The physical point family remains exactly BATCH_018's
`h^(E(512+i/3)+1536*(i%3))`, where h=g², g=1907584673 in
ZMod2147355649. The same1536 points are distinct roots of
Phi=X^1536-X^768+1. `KeygenNttEvaluation.equation_of_pointwise` is the
already checked coefficient-equation consumer.

`KeygenNttTransform.generated_converted_transform` additionally consumes
the actual table generation and coefficient conversion. Its full argument
list is in `formal/Source3/KeygenNttTransform.lean:44–69` and the complete
non-elided audit. In order, its **actual premises** are:

1. Source generator Entry: p/p0i/logn10/full1/g bindings, scratch aliases,
   actual read-only REV10 source bytes and legal scratch memory.
2. Executed p0i initializer and executed parsed table generator.
3. Conversion entry heap equal to the generator's returned heap;
   actual four-array scratch layout, input widths2 and input/scratch
   separation; declared uint64 counter and actual conversion Inputs.
4. Executed coefficient conversion; the original four Vec byte
   representations in the generator-entry heap and coefficient Bound2047.
5. Selected slot, NTT entry heap equal to the converted heap, actual NTT
   Entry bindings (including stride1), and executed complete forwardBody.

Its conclusion is `out.flow=.normal` and the above Contract for
`arrays.output slot`, `gm scratch`, and **the same `material slot`**.
Canonical conversion outputs and initialized gm are derived inside the
proof. No transform-result, polynomial-equation, source-completeness,
arbitrary-callee or solver-correctness premise has been introduced.

The enclosing caller must still derive the scalar/pointer/cross-call
bindings and original coefficient bounds. This is the planned B1.05/B1.07
boundary. NTT Frame preserves disjoint canonical32-bit cells; it does not
yet export arbitrary16-bit original-material byte preservation.

## 2. Checked construction

| Layer | New checked source result |
|---|---|
| `KeygenNttControl` | Actual scalar/pointer writes, normal flow, block-local restoration; no memory-value assumption. |
| `KeygenNttMiddleValues` | Re-inverted declarations, gm[m+u1] read, v1/ht pointer binds and vLoop; all u1 blocks and8 m rounds with common heaps, canonical output arrays and gm/frame preservation. |
| `KeygenNttTripleValues` | Actual wSquared Montgomery value, all512 source triple iterations and exact physical quadratic values. |
| `KeygenNttExecution` | Glue/sequence equivalence and complete forwardBody composition, including prologue and required local slots. |
| `KeygenNttTwiddleCert` | 32 bounded kernel chunks on the existing rowExponent/REV10 definitions;510 non-top signed child laws, without changing the ordering. |
| `KeygenNttTwiddleTree` | h^2304=-1, even/odd square and cube laws, exceptional gm[3]²=1-w, and leaf point powers. |
| `KeygenNttRoundPolynomial` | Sequential block arrays, exact low/high polynomials, degree-bounded evaluation invariants through every round, unconditional transform_evaluation for every coefficient vector/index. |
| `KeygenNttTransform` | Whole source-transform Image and preceding generator/conversion composition. |

The degree bound is `KeygenNttSubpolynomial.degree_bound` on each physical
block polynomial of length t(i); low_round/high_round identify the exact
degree-<ht child polynomials. The inherited low/high remainder identities
apply to those same polynomials. Polynomial propagation uses the child
power laws, not finite-array tests or an assumed root-evaluation invariant.

## 3. Evidence and pins

- BATCH_019 JSON:
  `983a481a10293c01bf80250a9dd4ad2797e351db0a3c5d41825845d80fde6098`.
- Transform source:
  `0f60483e60ec1f37664d8fc788894144e8cc7e96f504845f786c4c4ec4f3d68a`.
- Round-polynomial source:
  `a9a7b49ed26e22c9c7a33310df1f95d3c36a92cd822673aa2bf29a68a420128d`.
- Audit result `.build/jobs/keygen_ntt_transform_audit_019_002/NTT_TRANSFORM_AUDIT.json`:
  `b0c28ef18d7adac420967897725867f5e8bc59ab980f0500b4c16558d68e50de`.
- Same job RECEIPTS:
  `a1d285c9b286c68449e89ddbbbfadbd0df79a7f1aca4e6b47d50dbdb433005aa`;
  SOURCE_INPUTS:
  `30248a21172622c868791591960a595bd584b5b3c60c9710165fd03dbefa9a1c`.
- Sage generation result:
  `90bff537f6d9452b152aa40356726070d04472a58bb01edab286035cf1c21610`;
  generated/tracked certificate:
  `fc255abb3660434efd791db0117d3af623fff218c52e717505a4b5a9c6418320`.

Preflight and sealing rechecked1204 predecessor files, including
BATCH_015–018 pairs and393 then-current audit inputs. All402 current
inputs of the new final audit match. All9 new modules have current accepted
source/snapshot/olean/import/receipt bindings and0/0 logs. The internal
audit contains131 entries:128 full terms and3 kernel structures with
complete constructor types, only propext/Classical.choice/Quot.sound,
zero elisions. Its11906748-byte JSON is regenerable with the tracked
audit module and retained under durable .build. The unchanged prime
proof's complete round-tripped DAG remains pinned in BATCH_018.

19 attempts,8 failures retained with raw streams and source snapshots.
The failures are syntax/API/linter/elaboration errors, not mathematical
counterexamples. Maximum accepted new-module RSS2864452KiB. Limits and
warning policy are unchanged. Sage used `sage file.sage` with the standard
preparser and exact ZZ. No unchanged project-wide replay was performed.
The previous normal/UBSan controls (14 executions,3 public arrays,
10 snapshots and6 mutation families) remain pinned, without another run.

Proof commits: `e58e2a51`, `6e6b98d0`, `7665543b`. Exact-path local main
commits as niirmataa under the shared archive.lock; foreign work preserved.
No live owned job remains. No independent review, stage import or push.

## 4. Next owner stage

**B1.05 only**, in a new owner-scoped window: bind the actual four-transform
solver sequence and successful final comparison, derive original f/g
bounds1 and F/G bounds2047 with material preservation, consume pointwise
equality/injectivity and then `exact_ntru_of_modular_check` with residual
bound37748737. Actual source callee coverage and caller bindings must be
proved; the desired solver equation cannot be added as a premise.

Later plan order remains B1.06 public/inverse, B1.07 caller/attempt/gates,
B1.08–09 codecs, B1.10 emitted-to-fiber and B1.11 fresh final replay/handoff.
This window establishes the NTT bridge needed for that sequence; it does
not claim the complete solver or the final security theorem.
