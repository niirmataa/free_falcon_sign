# BATCH_021 — source small-output bounds and recoverable B1.05 midpoint

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
Window: **CLOSED_AT_RECOVERABLE_MIDPOINT**. **B1.05 Acceptance NOT MET.**

Batch JSON SHA256:
`ed560886f8cacfe513cea222b46552cf3abc717a1232172a1da197753393395a`.
Proof commits on main: `f17fe9b2`, `8b55f52f`, `20d4e524`. A final local
documentation commit records this pair and the expanded checkpoint.

## Checked theorem boundary

`KeygenSmallBounds.source_material` consumes the complete parsed
`poly_big_to_small` execution, M0 parameter slots logn10/ter1, the actual
destination pointer binding and width2, and observed return1. It concludes:

```text
exists v : Geometry.Vec,
  KeygenMaterial.Represents out.state.heap dst v
  and KeygenIntegerLift.Bound v 2047
```

No coefficient bound, n1536, initialized u, postulated bounded-write trace,
or small-output correctness assumption is an input. Those are derived
from the same source execution. The zint callee is fixed: its entire parsed
load/update prefix is executed, followed by signed interpretation of the
actual uint32 local object's four little-endian bytes. Its heap-readonly
property is checked. This is the existing source/reference model boundary,
not a C compiler or machine-code correctness theorem.

`KeygenSmallCalls.bound_call` additionally consumes the actual argument
binding and converted nonzero return, deriving that the source return is1
and the same bounded-write trace/material. The byte frame and `two_outputs`
preserve the first output through the second disjoint conversion. These
exports still require the enclosing actual caller to supply its arguments,
profile, memory separation and two source-call derivations. The complete
short-circuit F/G gate is not yet instantiated.

`KeygenTernaryStore.accepted_store` proves the coefficient range[-1,1] and
actual Store16 for the complete post-refill MODE1 tail: x extraction,
rb shift, rbits decrement, comparison, store and break. Rejected draws
preserve the heap. This is stronger than the inherited scalar-only lemma,
but not yet a full sampler/f-g material theorem. Refill, both loops and
the real deterministic get_rng_u64/shake_extract body binding remain open.

## Evidence

- Preflight: BATCH_015–020 pairs,1594 distinct pinned files, all409 current
  final BATCH_020 inputs and1336 predecessor checks; no active proof job.
- Six new Lean modules, all accepted with0/0 logs and unchanged limits.
  Max accepted RSS2832532KiB. Accepted bindings are enumerated in the JSON.
- Internal audit:107 entries, all98 new declarations covered,97 complete
  flat terms and10 inductives with full constructor types, only standard
  axioms, zero elisions. All415 current final-audit inputs verified at sealing.
  Audit `1cb4f42e0da7ff629f0832c529c071a69c68efdc5a3116f47ad6dd36b3384825`;
  receipt `096ef38da8046f839f7f9502bf408c1c1ac730b170a8b1fff81f8ecb6d453d91`.
- Fresh standard-preparser Sage/ZZ controls:14 normal/UBSan executions,
  each with36 small-output edge cases and24 two-call public sampler cases.
  The sampler fixture links actual pinned shake.c; it checks exact outputs,
  consumed words, rejection counts, refill and preservation of the first
  array. Six mutations detected in both modes. A mock caller supplies only
  the rng member; this is finite evidence, not a struct-layout proof or IID law.
  Result `b7207ef3609c0b0b5b5a669869d7c2442737e7f799c86ffc4078769c902c3a9a`.
- Full compiler adjacency census:99-node unpruned solver,92-node root-M0
  overapproximation and6-node sampler; all transitive edges retained.
  [Graph scope and next obligations](KEYGEN_SOLVER_GRAPH_021.md).
  Result `dd0e42256a6178bc05d7304d06dfd5a2cea9d34e14ba81999b59958e7ebc3b7c`.
  This inventory does not prove full operational graph coverage.

## Retained attempts and limitations

18 attempts:9 accepted and9 failed, with snapshots/receipts/raw logs.
Failures record an unavailable optional tactic import (replaced by an
existing kernel byte-roundtrip theorem), reserved-word/record-layout errors,
parser diagnostics for the unsupported int32_t typedef spelling, one
ambiguous constructor, induction/field elaboration fixes, and a Sage Integer
JSON conversion. The first successful graph run remains historical after
the clearer translation-unit provenance wording in the final run.

There is no unresolved Lean draft or owned job. Predecessor evidence,
including BATCH_020's no-receipt interruption and BATCH_018/019 failures,
is retained unchanged. No historical dependency changed, so the new modules
were checked incrementally; no unchanged whole-project replay was repeated.

## Remaining, in B1.05 order

1. Complete root/search source execution, real member reads and pointer views,
   all actual callees, post-decrement depths and failure returns.
2. Bind the actual F/G short-circuit calls to the new full-function bound
   exports and carry f/g/F/G through common heaps into validation.
3. Complete MODE1 refill/loops and source SHAKE binding, yielding actual f/g
   Vec witnesses with Bound1; preserve them through the search.
4. Consume BATCH_020 `generated_converted_checked` with these derived bounds
   and caller bindings. The final exact NTRU equation must concern the same
   retained material. Its existing Bounds premise has not yet been discharged
   in the complete solver/caller theorem.

Resume through `KEYGEN_RESIDUE_CHECKPOINT.md` section6. B1.06 not entered.
No push, independent review, stages import, migration or new worker was run.
