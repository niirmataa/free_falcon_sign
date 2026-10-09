# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_042: complete original public forward evaluations

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
2026-10-09, GPT-6 Astra Ultrafast (`openai/gpt-6-astra-ultrafast`).
**CLOSED_AT_RECOVERABLE_MIDPOINT. B1.06 Acceptance NOT MET.**
One midpoint in this window. B1.05 remains BATCH_032; B1.07 is not entered.
The owner started checkpoint21R, requiring outer radix composition and actual
triple execution before nonzero/division/inverse. This midpoint closes that
forward-evaluation obligation. Historical runner model/session constants
are provenance, not the identity of this window's worker.

## 1. Complete checked forward type

`KeygenPublicEvaluation.source_complete` has the boundary:

```text
original : Geometry.Vec; s : State; out : Result; a : ArrayPointer
Slot s "logn" 10
s.arrays "a" = some a
Cells s.heap a 1536 (KeygenPublicInputMaterial.reduced original)
Exec fixedPublicProgram [] (code forwardT) s out
---------------------------------------------------------------
out.flow = normal
forall i : Fin1536,
  Cell out.state.heap a i.val
    ((CoefficientQuotient.polynomial (Relation.reduceVec original)).eval
      (KeygenPublicRoots.point i))
```

Each `Cell` includes an actual unsigned16 load, a canonical value below18433,
and the field-value equality. This is universal in the ORIGINAL polynomial,
the finite defined source execution and all1536 indices. Original converted
input cells are the local forward-call input; the complete public headline
below derives them rather than assumes them. No final image, generated table,
initial residue-local domain, NTT correctness, nonzero or equation premise.

### Source composition

- **Exact outer syntax:** row/stage declarations, scopes, comma initializers,
  u1++/v1+=t, m<<=1, t=ht and the actual t>3 guard are parser-bound. The
  ++ scalar statement and +=/<<= word assignments are distinct constructors.
- **One row:** table index m+u1, scaled s, v2=v1+ht and v=v1 are derived;
  the previous complete inner v-loop theorem produces every updated and
  untouched cell. u1's scoped s/v2 lifetime and the persistent v type are kept.
- **All rows/stages:** `source_rows` and `source_stages` fold every executed
  row and all eight stages. Physical base j*t, t*m=1536, exact halving,
  m512/t3 terminal state, full1536 images and writable-table frames are proved.
- **Actual full entry:** `source_radix` derives n1536/hn768, both aliases,
  generated gm values and all required scalar declaration types through the
  first fold. It selects the SAME triple seam and retains both final automatic
  table disposals. Table values are not caller premises of the full theorem.
- **Original-polynomial invariant:** public-field root-tree lemmas reuse
  only natural source-index/REV10 exponent certificates. The low/high block
  remainders preserve evaluation of the ORIGINAL CoefficientQuotient
  polynomial at every assigned physical root, across all eight stages.
- **Actual triple:** the source body derives scaled w/x/x2, all ordinary B/C
  contributions and three chronological Store16 witnesses, including C2/C1
  in the second/third stores. The full512-body loop proves every untouched
  cell and table frame. Source seed w and u/v initializers are derived from
  the live header. Physical order and the original-polynomial invariant then
  produce all1536 final values; the two table disposals preserve those cells.

No transform theorem in the older p2147355649 model substitutes for this
q18433 execution proof. Finite diagnostics and canonicality alone do not
establish the value invariant.

## 2. SAME public f/g boundary

`KeygenPublicEvaluationMaterial.source_same_material` takes:

```text
s : State; out : Result; f,g,h : ArrayPointer; fv,gv : Geometry.Vec
Slot s "logn" 10; Ternary s
actual f/g/h array bindings
Legal s.heap f; Legal s.heap g; Legal s.heap h
Represents s.heap f fv; Represents s.heap g gv
Bound fv 1; Bound gv 1
h.block != f.block; h.block != g.block
LiveTables s
Exec fixedPublicProgram ["f","g"] (code compute) s out
---------------------------------------------------------------
Front s out h fv gv
```

`Front` selects the actual fresh3072-cell t block, converted/afterH/afterT
states and inner public suffix result. Its conclusions include:

1. Original converted h=gv and t=fv arrays, each with all1536 cells.
2. Both actual forward Call/Bind executions, h first and t second.
3. **Every gv evaluation in h at afterH; every fv evaluation in t at afterT.**
4. The SAME public suffix afterT→inner, observed flow and exact final t
   disposal linking inner to the complete compute result.

These are respective forward-return boundaries. This theorem does not assert
the g image at afterT or either image after the subsequent division/inverse.
For the next pointwise consumer, expose/preserve h/g across the t call at the
common afterT seam, alongside its header/array/frame facts. The f cells across
the h call already use the actual source footprint and Fresh-derived separation.

No success return1 premise is required for this before-test theorem. The
retained SAME suffix may reject. Legal entry/profile/material/bounds1 and
static-table liveness remain explicit obligations of enclosing KeyGen.

## 3. Audit and finite controls

BEFORE proof edits/jobs, the exact BATCH_015–041 closure was rehashed:
**7417 distinct files /633 literal source bindings**, no supersession/job.
Entry `.build/levels_042/ENTRY_PINS_042.json`:
`9d32b6d8b6d4ed3636da57a34c92bee066d6fd4d126b7889b017e8fe774aedc2`.

Eighteen new proof modules and the audit producer have accepted guarded
0/0 streams, with all limits unchanged. Internal audit:
**607 entries =171 new declarations +436 inherited interfaces;557 complete
terms +50 kernel inductives with constructor types;zero elisions;only
propext/Classical.choice/Quot.sound**. Literal inventory652. This is an
internal declaration/type/axiom audit, not independent review.

- Full-forward source: `d3be5c8c6d88d4bda32cc17a6b3d3e2436b443ef3b6f42c1c820021fd2a34a25`.
- SAME-material source: `ab963c43d51a4ef8c1caa03119b4ca1d326a8261c2394b718faefa0538f4fee8`.
- Audit JSON: `0d5f6557b84c7d0757b2073b4a32e4e49bb7f2b0adca43ff9ca80ca27f83392c`.
- Audit receipt: `a1cc956c582e634f6b51e6df69f7d50ae692e6c64137ecacc351022dc4dbbb78`.

New Sage job `keygen_public_evaluation_checks_042_002`, standard preparser:
eight public synthetic vectors, **122880 physical polynomial evaluations,
8176 block remainder identities,13824 root-tree laws**, wrong-order and
wrong-Montgomery-scale negative controls detected. Every first/radix boundary
is checked against direct original-polynomial evaluation. All assertions pass.

- Sage source: `dcb179d75324df25ccf53d760102aa248f363fb1381b624d24eca2cf0c9a448c`.
- Result: `9836fd36e98b4208cc9b061334a29884d94c0c3b675e8a7742add8e3e01364f0`.
- Receipt: `c1411340691c8b03c603a4ef2f8b6978551e36ea50b9495756148680218120af`.

The unchanged041 twelve C/UBSan runs, fixtures, source/include pins and raw
artifacts were rehashed, not rerun. No new C execution. The inherited039
owner-approved live FPR-header difference is unchanged; this is not a full
historical M0 build. New finite checks supplement the universal Lean proof.

## 4. Retained attempts and traps224–232

All **23 job directories** remain:13 wholly accepted,nine failed,one interrupted.
Completed engine receipts record30 steps:21 accepted,nine rejected. Recorded
maximum cumulative RSS4714196KiB. The interrupted job has no final resource/
engine receipt; do not infer one or include it in that recorded maximum.

1. **224:** SizeOps used the reserved identifier `variable`; generic
   bindValue initialization also needs explicit set/USlot simplification.
2. **225:** `initialize` is reserved too; rename the own local execution proof.
3. **226:** post-row v declaration needs the explicit `Option Value` witness.
4. **227:** remove unnecessary `<;>` focus; no linter suppression.
5. **228:** Polynomial001 was interrupted by the120s foreground TOOL timeout.
   Snapshots/input inventory/partial raw streams are retained; no RECEIPTS.json
   or WAIT completion was produced. Administrative observation:
   `.build/levels_042/INTERRUPTED_POLYNOMIAL_001.json`, SHA256
   `4088e08ff596824527bb5660d17c44f5569a3e74f3914a9d7f7b4fd793119dd8`.
   Unique002 ran under the unchanged guard and reached the heartbeat limit:
   implicit coefficient congruence and an imprecise eval block-base match
   triggered excessive reduction. Exact natural-index rewrites and explicitly
   typed eval lemmas close003 in2.769s. Initial boolean-image/split errors are
   also retained. No limit was raised and no old proof was weakened.
6. **229:** bare numerical word arguments did not match the named
   Montgomery modulus/inverse in the square equation; use the exact definitions.
7. **230:** triple-body bookkeeping requires total getD statements instead of
   an unavailable Inhabited instance, explicit Known pairs, complete list
   membership simplification and declaration-local transport.
8. **231:** avoid unfolding USlot/word conversion to prove a counter identity;
   rewrite the natural index explicitly. Unfold Cells pointwise for image0.
9. **232:** Sage001 reached all arithmetic assertions but failed JSON metadata
   serialization on two Sage Integer literals.002 uses explicit int conversion;
   the failed001 source/logs/receipt remain intact.

No unfinished-proof markers remain in accepted source. No current unresolved
job/source failure. The final pair records every retained attempt, accepted
snapshot/product/raw stream and all dependency inputs. The full015–041 closure
is rechecked at preseal and by the new verifier. Pair/POSTSEAL hashes are in
the live checkpoint, avoiding circular self-hashes.

## 5. Remaining B1.06, in the unchanged plan order

1. **Forward source evaluations DONE.** At the next successful-path consumer,
   expose the actual suffix headers and h/g preservation across t's call at
   the common afterT seam; the current headline states exact afterH/afterT
   boundaries rather than hiding that remaining frame composition.
2. **Item3 NEXT:** SAME successful public path→all1536 nonzero f tests→actual
   pointwise division→actual inverse/normalization→canonical h. No assumed
   forward/inverse round-trip; no input nonzero premise replacing source tests.
3. **Item4 THEN:** construct fInv via nonzero evaluations and a proved
   evaluation isomorphism; conclude BOTH SAME f/g/h `mulRq` equations.

The new result closes the universal original-forward-value gap. The remaining
gap is a source proof of the successful suffix and inverse, not a code or
numerical counterexample. B1.06 Acceptance still requires both equations.
Full KeyGen/emitted-to-fiber,compiler,laws/PRG/security and independent review
are not consequences of this midpoint. Small local own main commits,foreign
changes/staging preserved; no push,review,delegation,relay,migration or import.
