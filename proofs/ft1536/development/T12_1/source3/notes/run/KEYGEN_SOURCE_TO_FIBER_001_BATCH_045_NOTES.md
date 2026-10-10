# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_045: SAME quotients through reverse reconstruction

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
2026-10-10, GPT-6.1 Sol Fast (`openai/gpt-6.1-sol-fast`).
**CLOSED_AT_RECOVERABLE_MIDPOINT. B1.06 Acceptance NOT MET.**
One midpoint this window, after ALL eight actual reverse-radix stages and
their ORIGINAL physical block-polynomial reconstruction, BEFORE the actual
first-root inverse at1140. B1.05 stays BATCH_032; B1.07 is not entered.
Owner-started checkpoint24R: reverse radix → first-root → normalization/final
h → fInv → BOTH SAME-material equations. The order is unchanged. The first
part is complete; later parts wait at this recoverable boundary.
Historical runner model/session labels remain provenance, not this worker's
identity. No B3 transform export is consumed by this midpoint.

## 1. Complete checked SAME-material headline and actual premises

`KeygenPublicReverseMaterial.source_same_material` has this exact boundary:

```text
s : State; out : Result; f,g,h : ArrayPointer; fv,gv : Geometry.Vec
Slot s "logn" 10; Ternary s
s.arrays "f" = some f; s.arrays "g" = some g; s.arrays "h" = some h
Legal s.heap f; Legal s.heap g; Legal s.heap h
Represents s.heap f fv; Represents s.heap g gv
Bound fv 1; Bound gv 1
h.block != f.block; h.block != g.block
LiveTables s; KeygenPublicFrame.Tables s h.block
Success out (=out.flow=returned (some (int32 1)))
Exec fixedPublicProgram ["f","g"] (code compute) s out
--------------------------------------------------------------
Front s out f g h fv gv
```

These are the SAME043 legal/profile/material/bounds1/static-liveness and
static-table/output-nonaliasing premises; **no premise has been added**.
Enclosing KeyGen must still derive them. Initial canonical h, generated
tables, transform images, nonzero f, quotient input, inverse correctness,
normalization, source round-trip or either desired equation are NOT premises.

`Front` selects the SAME fresh3072-cell t block, afterT and inner result.
It retains both ORIGINAL evaluation arrays at that common state, the
derived actual header, all1536 nonzero f evaluations, the successful source
test/division pass, the SAME actual inverse execution and caller t disposal:

```text
out.flow=inner.flow
out.state.heap=disposed s.heap inner.state.heap block
```

Its `Run` selects beforeInverse/afterInverse from that execution and derives
`KeygenPublicReverseInvocation.Outcome (quotients fv gv) h <afterInverse,normal>`.
Here `quotients f g j = values g j * (values f j)^-1`, with `values` the
ORIGINAL CoefficientQuotient polynomial at physical `KeygenPublicRoots.point`.
The actual input cells are derived from043's successful tests/divisions,
not introduced as a new complete-headline premise.

## 2. Exact first-root seam and remaining-source boundary

The LOCAL `KeygenPublicReverseInvocation.source_reverse` takes arbitrary
`a : Nat → ZMod18433`, logn10, the actual array binding, canonical ordinary
`Cells s.heap p 1536 a`, and the SAME complete `code inverseT` execution.
Those local cells become derived ORIGINAL g/f quotients in the headline.
It concludes `Outcome a p out`, selecting `inner` with:

```text
ThroughReverse a p inner
out.flow=inner.flow
Block inner.state.heap out.state.heap p.block
```

`ThroughReverse` selects the actual generated igm and after state:

```text
Header p igm after
USlot after "m" 1; USlot after "t" 1536; USlot after "u" 1536
Declared after "v" (=exists old, locals "v"=some (uint64,old))
Cells after.heap p 1536 (reverseImage a)
Exec fixedPublicProgram [] remaining_1140_1159 after inner
```

The Header includes pointer width2, p/igm block separation, the actual a
binding, BOTH igm_square/igm_cubic aliases, the full generated inverse Table
(including exceptional0), n1536, hn768, logn10, and the actual uint32 r/ni
declaration types. Counter/slot values and generated table are conclusions.
The old044 Run did not export t/m/r/ni types; the new complete invocation
derives and carries the needed types, without modifying any old module.

`reverseImage a = ReverseStages.image (InverseFold.value a) 8` is the
explicit UNNORMALIZED linear image of the actual input. The source uses
t=6*2^k and m=256/2^k for k0..7. Every stage has m rows of ht=t/2 pairs:

```text
base = j*t; z = root^(-tableExponent(m+j))
at base+i:    x+y
at base+ht+i: (x-y)*z
```

The twiddle WORD is radix*z, while x/y and the stored results are ordinary
field values. Both chronological uint16 stores are canonical<18433.
The eight stages derive terminal t1536/m1, preserving every untouched
cell, the writable generated igm object and the actual enclosing headers.

Block connects the remaining suffix's **FINAL** inner heap to the observed
inverse output. It does NOT preserve the reverse seam through that suffix.
The final h coefficients/evaluations, first-root/normalization correctness
and either public equation are NOT yet conclusions. No live t image is
falsely asserted after its caller disposal.

## 3. Universal ORIGINAL physical reconstruction, not a final inverse

The mathematical statements apply to the explicit source-derived image,
in q18433 and the SAME physical root order. No inverse oracle or assumed
forward/inverse round-trip is consumed:

- `InverseTriplePolynomial.block_eval`: the actual inverse triple's degree<3
  polynomial evaluates to **3*a(3*j+k)** at physical point3*j+k.
- `ReversePolynomial.reconstruction`: adjacent child blocks L/H become
  `L+H + X^ht*z*(L-H)`, with z the actual inverse twiddle. At a child root
  this evaluates to **2*L** or **2*H** respectively.
- `ReverseReconstruction.point_power`: the physical point's source-index
  root ancestry is proved backward through all eight natural stage sizes.
- `stages_invariant`: each completed stage retains every ORIGINAL physical
  input evaluation with factor `3*2^k`. Row images/offsets are derived in
  actual order, not permuted to make an equation hold.

The exact terminal theorem `KeygenPublicReverseReconstruction.original_block`
has **no premises** beyond its arbitrary a and i arguments:

```text
a : Nat → ZMod18433; i : Fin1536
--------------------------------------------------------------
eval (point i)
  (polynomial (reverseImage a) ((i.val/768)*768) 768)
  = 768*a i.val
```

The SAME complete public headline derives the image for `a=quotients fv gv`.
This is TWO separate degree<768 blocks, BEFORE the first-root inverse.
Factor768 is not1 and not1536. The next actual first-root pass must prove its
additional factor2; the live ni computation and normalization must remove
factor1536. No final canonical h, full inverse law or mulRq equation is
inferred from these unnormalized block equalities.

## 4. Internal audit, pins and finite source controls

BEFORE edits/jobs, BATCH_015–044 verified: **8306 distinct pins/669 literal
source bindings**, no supersession or active job. Entry receipt:
`.build/levels_045/ENTRY_PINS_045.json`, SHA256
`57ba27fc87101f488d2de0bd1fcae0fcba3ff45b2f8daee2cb7f1c913e47d2d0`.
Dedicated045 PRESEAL rechecked the identical8306 predecessor bytes:
`885995b877f2cf773be73548c1639114e225671fd09601f358471c1afd50991b`.
Exact committed045 organizer:
`252a4fc6aa9c27b4978220e9e09dccea0b9bb5431d5640299bbff5aa59fa9fd1`.

Thirteen proof modules and audit producer accepted guarded **0/0** streams.
Audit: **900 entries=146 new+754 inherited;834 complete terms+66 kernel
inductives with constructor types;zero elisions;only propext/Classical.choice/
Quot.sound**. Literal source inventory683. Complete types/terms are retained
in the durable23474621-byte generated audit, not replaced by a summary.
This is an internal audit, NOT independent mathematical review.

- Audit JSON `bcda560847ae262c04a75c0c9763f614af850917c3c904bfbb7be086ec135be8`.
- Audit receipt `e2089a2ab1734984483c639f7c1c5855a3647ef8363fa4d0c586ad35eea7b0fb`.
- Audit generator `2285b666a5ed23d563eb44e59f4724219dadb08c4896e1aae9c9b3f9b317d8f2`.

Sage `keygen_public_reverse_checks_045_001`, standard preparser, accepted0/0:
**12 new normal/UBSan C runs**, ten public synthetic inputs including seven
SAME public g/f quotients inherited from043/044. Each baseline mode checks
**5100 reverse rows/61440 butterflies/122880 canonical stage cells**, all
actual t/m stage headers, the incoming triple image and boundary canaries.
Sage independently checks **122880 ORIGINAL block evaluations** through all
eight stages, with final factor768. Five targeted mutations per mode are
detected: wrong inverse alias, wrong reverse subtraction sign, wrong twiddle
scale, skipped first row and skipped last stage. No secret/random KeyGen is run.

- Result `1b68f0cbd1561c4f09bcba42d9b73879b6c759e062106b7a4e6b37e8952afc74`.
- Receipt `262a0e09726ee5b6a2167154708434dcddcc96c166eee528488f9eb1663eaf81`.
- Fixture `17557e6f7309ffdc147bd826ce468a96f43340bf64ce39a819770f896df501a4`.
- Header manifest `44b349d2126a32f29e70951e268614b7266d8f6d7d334555de15304c1b951628`.

C is read from live `Extra/c`. The inherited039 owner-approved FPR-header
difference is unchanged and rehashed; **NOT a complete historical M0 build**.
The first-root/normalization suffix actually runs in these C diagnostics,
but final output, normalization, round-trip and both public equations are
NOT checked/promoted. Finite controls supplement, not replace, the universal
source/mathematical reconstruction proofs.

## 5. Retained attempts and traps248–252

All **11 directories/20 completed receipt steps** remain: six wholly accepted
directories, five failed directories;15 accepted/five rejected steps. No
interrupted attempt or unresolved job. Max recorded cumulative RSS
**4431268KiB**. No proof/resource limit has been raised. The pair pins every
attempted source snapshot, raw stream, guard/engine receipt, wait record,
accepted product and diagnostic artifact.

1. **248:** cast Ty is uint64, not the scalar-parser u64 name. The actual
   standalone `t <<= 1` is a scalar-update AST; the for-clause `m >>= 1` is
   an assignment AST. The first literal equality failed until this genuine
   grammar distinction was respected. Parser/old pins were not changed.
2. **249:** the scalar t-shift's expression constructor is `shift`, not
   `arithmetic`; derive the bounded unsigned conversion/update explicitly.
3. **250:** the old assign64 helper expects a raw existential local type.
   Rewriting Declared in an already unfolded goal fails; use the exact slot
   frame. r/ni declaration types must be carried to the actual remaining seam,
   not added as a full public-call premise.
4. **251:** a noncomputable field inverse cannot be reduced by `decide`.
   The accepted unity-inverse theorem uses its proved cube identity. Keep the
   correct cube/fourth-power contributions in the triple reconstruction and
   unfold the inverse-unity alias; the field simplifier already closes unscale.
5. **252:** Polynomial.C of a sum is not automatically exposed to ring.
   Use its map-add law before proving low-row reconstruction. Both rejected
   algebra attempts remain with their exact snapshots and raw diagnostics.

Accepted sources contain zero unfinished-proof markers. Failed snapshots
and raw diagnostics remain historical bytes, including generated errors.
Own source/evidence commits: `ff410718`, `9a1e4842`, `7613f1d8`, `91d4b179`;
proof HEAD `91d4b17996be5d172d7f0ce66bac58a4e1978478`. The later closing
pair/checkpoint commit is separate. Foreign work/staging is preserved. No
push, review, delegation, relay, migration, stages import or broad replay.
Pair/POSTSEAL pins live in the checkpoint to avoid recursive self-hashes.

## 6. Remaining B1.06, unchanged16.1 order

1. **Item3 NEXT:** consume the SAME retained1140–1159 execution at the actual
   `ThroughReverse` after state, its Header/types and explicit reverseImage.
   Load r from exceptional igm[0]=radix/(2*firstRoot-1); compose the768 actual
   first-root bodies and prove the additional factor2 reconstruction in
   original physical order. No new output-image/correctness premise.
2. **Item3 THEN:** derive the actual live logn10 branch
   `mq_div_18433(Rt,(uint32_t)n)` = radix/1536, execute all1536 normalization
   stores, and conclude canonical final h cells of some `hv : Relation.Rq`
   with every ORIGINAL physical evaluation equal to
   `values gv i * (values fv i)^-1`. Preserve both table disposals, both
   actual Call/Bind layers and caller t disposal. Current r/ni types are
   derived, but their loaded/computed values are still to be proved.
3. **Item4 ONLY THEN:** construct fInv from the already derived nonzero
   original f evaluations and a PROVED evaluation isomorphism; BOTH SAME
   f/g/h mulRq equations. Inspect exact B3/export types and complete pins
   before any reuse. No equation is concluded at this midpoint.

The complete reverse-source/reconstruction gap is closed. Remaining
first-root/normalization/final-output and equation gaps are missing
source/mathematical proofs, NOT detected code/numerical counterexamples.
B1.06 Acceptance NOT MET; B1.07 waits. Whole KeyGen/emitted-to-fiber, compiler,
probability laws/PRG/security and independent review remain outside. Resume
checkpoint **25R**, one midpoint or Acceptance in the next owner-started
window, not an automatic restart.
