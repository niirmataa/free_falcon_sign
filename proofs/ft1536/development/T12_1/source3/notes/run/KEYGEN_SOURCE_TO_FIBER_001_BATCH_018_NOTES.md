# BATCH_018 — B1.04 recoverable midpoint

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
Window closed at a recoverable midpoint under staged-roadmap rule3.
**B1.04 Acceptance is NOT met.** Next window continues B1.04.
Harness: GPT-6 Astra Ultrafast (`openai/gpt-6-astra-ultrafast`).
The runner's historical model/session labels are unchanged provenance.

## Checked result and actual premise boundary

The new source-chain export is
`KeygenNttFirstComposition.generated_converted_prefix`. It consumes:

- BATCH_017's M0 table-generator entry and its ordinary source execution;
- actual p0i initialization, legal scratch/input layout and separation;
- the original four Vec byte representations and their bound2047;
- executed coefficient conversion with its real `igm=ft` overwrite;
- equal returned/next-entry heaps and the explicit caller pointer/scalar
  bindings for the selected same coefficient array;
- the NTT prologue and first-pass executions with their shared State.

Its conclusions are canonical first-pass cells of the SAME selected Vec,
the two exact degree-<768 remainders of the existing
`CoefficientQuotient.polynomial`, preservation of gm, and a disjoint-cell
frame. Initialized gm and canonical results are not premises of this
composition. The whole caller still has to supply those source fragments
and cross-call bindings. This is not the full `forwardBody` theorem.

`KeygenNttSubpolynomial.source_remainders` consumes the entire actual
radix-2 **vLoop**, including v initialization, all butterfly stores and
pointer/counter advances. Its local inputs are canonical entry cells,
the scaled twiddle, legal positions/extents, scalar bindings and the p0i
execution. It concludes the two exact degree-<ht remainders, canonical
cells throughout the1536-word array and preservation outside its block.
`KeygenNttBinaryValues.load_twiddle` separately derives the actual
`gm[m+u1]` read's value. The enclosing u1/m loops must join these facts;
their missing memory/locals connections have not been made premises.

The point family is fixed by physical row9/REV10 and triple store order:

```text
h = (1907584673 : ZMod 2147355649)^2
point(i) = h^(E(512+i/3) + 1536*(i%3)),  i : Fin 1536
```

The kernel proves primality, all1536 points distinct, every point a root
of Phi, and degree/root-count injectivity. Quotient evaluation respects the
existing multiply/subtract. Thus `equation_of_pointwise` derives
`multiply f G - multiply g F = constantCoeffs rhs` over this field **from
pointwise equalities**. Their whole-source derivation and the integer lift
remain separate obligations.

## Six-part B1.04 progress

| Plan item | Actual state |
|---|---|
| 1. Canonical ranges | All three source butterfly bodies; full first pass and full binary v-loop proved. Whole transform still open. |
| 2. First pass | Closed at the source-fragment seam, including low/high placement, same Vec, `w^2-w+1=0` and Phi factorization. |
| 3. Intermediate passes | Binary v-loop values/remainders, actual twiddle read, header `t*m=1536`, seam `ht*m=768`, index bounds and source exit `m=512,t=3` proved. u1/m composition open. |
| 4. Triple pass/order | Source cell formulas, root-unity law and exact physical point family proved. Executed wSquared plus all512 triple iterations open. |
| 5. Original polynomial | First-pass same-Vec and local binary remainder identities proved. Propagation through the complete transform open. |
| 6. Distinct roots/injectivity | Mathematical layer closed, including quotient operations and coefficient equation from pointwise equality. Full source evaluation input still open. |

Do not move `t*m=n` into B1.02/B1.03. It holds at loop headers; after
`t=ht` and before `m<<=1`, the product is768 instead.

## Validation and retained attempts

- Preflight: BATCH_015/016/017 pairs,1031 distinct file checks,382 current
  final-BATCH_017 inputs; no active proof job. All393 current inputs of
  the final BATCH_018 audit also matched at sealing.
- Eleven current modules have accepted source/snapshot/olean/receipt
  bindings and0/0 stdout/stderr. Max accepted RSS3451292KiB. New modules
  checked incrementally in dependency order; unchanged closure not replayed.
- Final job `keygen_ntt_values_audit_005`:85 exports,81 full pretty terms,
  3 kernel structures with expanded constructor types,1 complete shared
  Expr DAG. Only `propext`, `Classical.choice`, `Quot.sound`; zero elisions.
- `modulusPrime`'s flat pretty print exhausted memory in audit_001/002.
  `_002` retained52 completed entries and the exact failing declaration.
  `ExprAuditDag` exports277341 nodes,6602246 bytes, then parses its own
  serialized JSON and reconstructs an `Expr.equal` term. Names, levels,
  binders and children are structural. Free/metavariable/metadata nodes
  are rejected. No proof/resource limit or warning setting changed.
- Sage/C `keygen_ntt_values_checks_002`:14 runs (normal/UBSan × baseline
  plus six mutations),3 public arrays,10 snapshots ×1536 words per array.
  Baselines agree with direct Sage polynomial evaluation in physical
  order; all six mutations are detected in both modes. gm/guards preserved.
  This diagnoses finitely many inputs; it does not close source NTT proof.
- All29 attempts retained,17 failed. The failed triple mutation initially
  triggered `-Werror` by leaving fC2 unused; swapping both operands fixed
  the diagnostic without relaxing flags. Failed Lean API/elaboration
  attempts and the first DAG-exporter attempt are also pinned.

## Pins

- BATCH_018 JSON: `f4e28b724e588b7e91cdb429646dfefe5939332f307f0ae15dc282369edc72cf`.
- Final audit: `d2a382db71b59da88b80211cb5f76c2cae14557593b88f8d550649d9d3311245`.
- Prime DAG: `66888cfd48b56990145d0dca30c6c6691d2aa52da2771a91c76aebcc08cb9534`.
- Final RECEIPTS: `f27763d473c53e98a7f88f7ec7a4383401b72e0592104b56a6e635c60f627aaa`.
- Final SOURCE_INPUTS: `d84223a8198e1dbe6665400122b27401cf1f4ea84f52f3919199f12f37940cb5`.
- Sage/C result: `d07d2d5787ca5a2dffbcc1262b0bd63e0ee66e84dc5b0704cc8b6c68970d372e`.

Full paths, per-module source/product pins and every raw receipt/log are
in the JSON. DAG and raw controls stay in durable `.build/jobs`; their
generators and pins are tracked. No large artifact is added to Git.

## Git and restart

Four small source commits: `bb2ca842`, `cd23c3f1`, `6f7cde92`, `1a9f4ef3`.
All use main, approved identity niirmataa, shared archive.lock and exact
owned paths. This pair/checkpoint has a separate final documentation
commit. Foreign changes remain preserved. No push or independent review.

Read `KEYGEN_RESIDUE_CHECKPOINT.md` section6 for restart and section3
for the exact missing interfaces. No owned job or unfinished Lean draft
remains. Resume u1Inner/u1/m composition, then triple and full-transform
assembly; do not restart the completed first-pass work or advance to B1.05.
