# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_046: SAME final h, fInv and BOTH equations

**B1.06: PROVED_KERNEL_SCOPED / Acceptance MET / NOT_REVIEWED.**
**Package: PARTIAL_PROOF / IN_PROGRESS / WORKING_NOT_FROZEN.**
2026-10-10, GPT-6.1 Sol Fast (`openai/gpt-6.1-sol-fast`).
**CLOSED_AT_ACCEPTANCE.** One close this window, no intermediate midpoint.
B1.05 stays BATCH_032; B1.07 is NOT entered or started.
Owner-started checkpoint25R: first-root → normalization/final h → fInv →
BOTH SAME-material equations. Every part is now complete in that order.
Historical runner model/session labels remain provenance, not this worker's
identity. No B3 transform export is consumed by this result.

## 1. Complete checked headline and actual premises

`KeygenPublicAccepted.source_same_material` has this exact boundary:

```text
s : State; out : Result; f,g,h : ArrayPointer; fv,gv : Geometry.Vec
Slot s "logn" 10; Ternary s
s.arrays "f"=some f; s.arrays "g"=some g; s.arrays "h"=some h
Legal s.heap f; Legal s.heap g; Legal s.heap h
Represents s.heap f fv; Represents s.heap g gv
Bound fv 1; Bound gv 1
h.block != f.block; h.block != g.block
LiveTables s; KeygenPublicFrame.Tables s h.block
Success out (=out.flow=returned (some (int32 1)))
Exec fixedPublicProgram ["f","g"] (code compute) s out
--------------------------------------------------------------
KeygenPublicAccepted.Material out f g h fv gv
```

The complete `Material` conclusion is:

```text
KeygenMaterial.Represents out.state.heap f fv
KeygenMaterial.Represents out.state.heap g gv
exists hv,fInv : Relation.Rq,
  KeygenPublicNormalizePolynomial.Represents out.state.heap h hv
  KeygenPublicSuccessfulSuffix.Nonzero fv
  mulRq hv   (reduceVec fv) = reduceVec gv
  mulRq fInv (reduceVec fv) = constantCoeffs (1 : ZMod18433)
```

The h representation contains actual unsigned16 loads, canonical range
`<18433`, and the ordinary field value of BOTH paired halves at every
`i : Fin768`. The f/g conclusion preserves the SAME signed input bytes,
not only abstract names. The witnesses are the explicitly defined
`publicVector fv gv` and `fInverse fv`; fInv is mathematical and need not
be an additional serialized source array.

These are the SAME043 legal/profile/material/bounds1/static-liveness and
static-table/output-nonaliasing entry premises. **No premise is added.**
Initial h canonicality, generated tables, transform images, nonzero f,
pointwise quotients, inverse correctness, normalization, source round-trip
or either desired equation are NOT inputs. Enclosing KeyGen must still
derive these entry facts in the later stage; that obligation is not hidden.
Complete literal types, terms and axiom closures are retained in the audit.

## 2. SAME actual first-root source and ORIGINAL factor2 reconstruction

`RootInverseProgram` literally partitions1140–1159 into the exceptional r
load, first-root pass and remaining normalization. The source-derived045
Header supplies the actual a binding, BOTH generated igm aliases, table,
n1536/hn768/logn10 and r/ni declaration types;045 supplies u1536 and the
canonical unnormalized reverseImage of the SAME original g/f quotients.

`RootInverseEntry.source_remaining` consumes that SAME retained execution:

- Exceptional igm[0] derives `r = radix*(2*firstRoot-1)^-1`.
- Actual u initialization and ALL768 bodies are executed in the model.
- For incoming ordinary x/y, `b=z*(x-y)`, low=`x+y-b`, high=`b+b`.
- Both chronological stores are canonical, all other cells are preserved,
  and the generated table/header/type frames survive to normalization.
- Both actual inverse Call/Bind layers and both table disposals remain the
  SAME045 invocation; no new image/correctness premise replaces them.

`RootInversePolynomial` proves the exceptional denominator nonzero from
the already proved first-root relation, without raising any exponent or
proof limit. The two physical degree<768 blocks reconstruct as:

```text
L+H-z*(L-H) + X^768*(2*z)*(L-H)
```

At ORIGINAL low/high physical roots this evaluates to2*L or2*H respectively.
The source-index ancestry from045 selects the correct physical half, so its
factor768 block reconstruction becomes **1536 times each ORIGINAL input**.
This remains explicitly unnormalized until the NEXT part.

## 3. LIVE ni, all1536 normalization stores and canonical final h

`NormalizeProgram` binds the real conditional ni assignment and the whole
normalization loop. At logn10, `NormalizeAtoms.source_ni` excludes the table
lookup branch and consumes the LIVE call:

```text
mq_div_18433(Rt,(uint32_t)n)
```

Rt10237, actual n1536 and both argument conversions yield canonical ni with
ordinary field meaning **radix/1536**. This is not an INVNQt table assumption
or an ordinary unscaled inverse substituted for the source word.

`NormalizeFold.source_loop` derives every chronological store and every
untouched cell. `NormalizeEntry.complete_output` consumes the remaining
suffix's actual result and the retained block equality through BOTH table
disposals. `NormalizeMaterial.source_same_material` consumes the actual
return syntax and caller t disposal as well. It concludes a concrete
`hv : Relation.Rq` represented by the final h heap, whose ALL1536 ORIGINAL
physical evaluations equal the source-derived ORIGINAL g/f quotients.

The factor1536 is cancelled by the PROVED scaled ni meaning, not by an
assumed forward/inverse round-trip. No t image is asserted after disposal.

## 4. ONLY THEN fInv, both equations and retained f/g

`EvaluationIso` exposes the complete checked type:

```text
evaluationEquiv : Relation.Rq ≃ (Fin1536 → ZMod18433)
```

The right inverse is the PROVED normalized image on arbitrary public-field
inputs. Its left inverse follows from the already proved distinct physical
points and coefficient injectivity. No B3 transform from another model is
used. The existing pinned `CoefficientQuotient`/`QuotientOperations` types
were inspected; polynomial multiplication modulo Phi and constant binding
are rechecked at the PUBLIC physical roots, not taken from the solver field.

`fInverse fv` reconstructs reciprocals of the ORIGINAL f evaluations. The
SAME successful source tests already derived their nonzero property. Then
the public-field multiplication/evaluation laws give:

```text
mulRq (publicVector fv gv) (reduceVec fv) = reduceVec gv
mulRq (fInverse fv)        (reduceVec fv) = constantCoeffs 1
```

`ParameterFrames.permissions_covered` proves every writable callee name is
an actual pointer parameter. Its Bind/Exec induction derives nonaliasing
from actual arguments and Fresh local objects, preserving f/g through the
complete compute. This requires NO extra static-table/f or table/g
nonaliasing premise. The new proof does not rewrite any old frame module.

`Accepted.source_same_material` combines these results for the SAME initial
fv/gv, now also represented by the SAME final retained f/g bytes, and the
actual canonical final h. **B1.06 Acceptance MET**, in its source/model scope.

## 5. Internal audit, pins and finite source controls

BEFORE edits/jobs, BATCH_015–045 verified: **8604 distinct pins/683 literal
source bindings**, no supersession or active job. Entry receipt:
`.build/levels_046/ENTRY_PINS_046.json`, SHA256
`a2890d06e8132a7f67a3be86519d276394f0407faaf0b3dd7bd5846005f8732b`.
Dedicated046 PRESEAL rechecked the identical8604 predecessor bytes:
`49be9a71e70d11e3771e739263f280d5c048b25918476120aa2c303fcde63b3e`.
Exact committed046 organizer:
`15c980f1463b838d7800d78eda2ddebb4fb1c1f203b69d7115157a8252a89d05`.

Sixteen proof modules and audit producer accepted guarded **0/0** streams.
Audit: **1035 entries=135 new+900 inherited;965 complete terms+70 kernel
inductives with constructor types;zero elisions;only propext/Classical.choice/
Quot.sound**. Literal source inventory700. Complete types/terms are retained
in the durable24916716-byte generated audit, not replaced by a summary.
This is an internal audit, NOT independent mathematical review.

- Audit JSON `1510110aa194e6a193e86d927bb2f118c4d6aba4c849f5aebf9a60362c2e1eb2`.
- Audit receipt `3b2ae8bf4827d2a71b5aaddc6179eee4bce19ee9b0cac4e6171699979da96271`.
- Audit generator `b2c7b5920bff0b487c5fe53c3e79bc59ad7caab14a44206680e3bd6a4f6b96a2`.

Sage `keygen_public_normalize_checks_046_001`, standard preparser, accepted0/0:
**12 new normal/UBSan C runs**, ten public synthetic inputs including seven
SAME public g/f quotients inherited from043–045. Each baseline mode checks
**7680 chronological first-root butterflies/15360 normalization stores**,
all canonical pair/store outputs, exceptional r, LIVE ni, incoming reverse
image, final h and boundary canaries. Sage independently checks **30720
ORIGINAL physical evaluations**, before normalization with factor1536 and
after normalization with factor1.

Five targeted mutations per mode are detected: wrong exceptional seed,
wrong first-root subtraction, missing first-root factor2, unscaled ni,
and skipped last normalization store. No secret/random KeyGen is run.

- Result `ce1240f9423cb02df13d6e9f252f34ff4e7d0b62f83523d6ac469eb6ec45928a`.
- Receipt `d57ecaaa65b93efc19e24bbcc329a8e4a381d86fd7ccf58f16a67720d5c16244`.
- Fixture `7b767d9a3824b86e5f8c6f3e384bcdf563d5c2d7d48bbfa59d8f4e614e9acb0a`.
- Header manifest `44b349d2126a32f29e70951e268614b7266d8f6d7d334555de15304c1b951628`.
- Sage source `c112505d33452bd10bfaded33078e71795e592d39462692204536a6daabde11a`.

C is read from live `Extra/c`. The inherited039 owner-approved FPR-header
difference is unchanged and rehashed; **NOT a complete historical M0 build**.
These finite diagnostics do not replace or broaden the universal kernel
source/evaluation/equation results. Pair/POSTSEAL pins live in the checkpoint
to avoid recursive self-hashes.

## 6. Retained attempts and traps253–259

All **15 directories/26 completed receipt steps** remain: seven wholly
accepted directories, eight failed directories;18 accepted/eight rejected
steps. No interrupted attempt or unresolved job. Max recorded cumulative
RSS **3779996KiB**. No proof/resource/exponent limit was raised. The pair
pins every attempted snapshot, raw stream, guard/engine receipt, wait
record, accepted product and diagnostic artifact.

1. **253:** a space before variable i is necessary at the `≤ i` Lean token
   boundary. Parenthesizing the separate negation did not repair that token.
   Both rejected fold snapshots/streams remain; no grammar was weakened.
2. **254:** direct reduction of a large power hit the unchanged exponent
   threshold. The accepted denominator proof instead uses the first-root
   relation algebraically. The same attempt also retained a redundant
   high-polynomial index rewrite; the already normalized index needs none.
3. **255:** expose Polynomial.C of numeral2 with its map-of-numeral law
   before ring. The failed algebra output remains, without a limit change.
4. **256:** projected heap equalities did not match after bindValue. The
   accepted entry proof uses both actual assignment heap equalities directly.
5. **257:** Canonical is opaque to automatic Decidable synthesis. Expose
   exactly10237<18433 and1536<18433; do not weaken the arithmetic domain.
6. **258:** TableControl.seq_inv does not take a program argument, unlike
   ForwardControl.seq_inv. Consume the exact interface, not a guessed one.
7. **259:** public is a Lean keyword. The checked definition is publicVector.
   EvaluationIso had already succeeded in that retained failed directory.

Accepted sources contain zero unfinished-proof markers. Failed snapshots
and raw diagnostics remain historical bytes, including generated errors.
Own source/evidence commits: `cb4344be`, `19e05247`, `53eafe86`, `8dde5b74`;
proof HEAD `8dde5b74dd711d904c0801880a1acfb4dec9dccc`. The later closing pair/
checkpoint commit is separate. Foreign work/staging is preserved. No push,
review, delegation, relay, migration, stages import or broad replay.

## 7. Remaining in the unchanged plan order

B1.06 has **no remaining local obligation** at its stated Acceptance block.
This window closes here. B1.05's032 scope stays unchanged. B1.07 is next in
the EXECUTION_PLAN, but must wait for its own owner-started window:
derive enclosing legal/profile/material/bounds1/static-layout facts, actual
attempt gates/cap/control and the SAME material passed to later encoding.
Do not silently advance to B1.07/B4/B5 or consume an uninspected export.

Whole KeyGen/emitted-to-fiber, compiler/machine refinement, probability
laws/PRG/security and independent review remain outside this result. There
is no new code/numerical counterexample or arithmetic-budget failure here.
The source public/inverse/equation gap is closed; the remaining gap is the
explicit enclosing execution/assembly and independent acceptance work.
