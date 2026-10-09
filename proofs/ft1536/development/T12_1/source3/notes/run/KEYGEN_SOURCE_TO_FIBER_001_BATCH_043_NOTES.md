# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_043: successful source tests and division

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
2026-10-09, GPT-6.1 Sol Fast (`openai/gpt-6.1-sol-fast`).
**CLOSED_AT_RECOVERABLE_MIDPOINT. B1.06 Acceptance NOT MET.**
One midpoint this window,at the actual inverse-call entry. B1.05 stays
BATCH_032;B1.07 is not entered. The owner started checkpoint22R with the
fixed order: common afterT→successful nonzero tests→division→inverse→both
SAME-material equations. Historical runner model/session constants are
provenance,not the identity of this window's worker.

## 1. Complete checked SAME-material headline and real premises

`KeygenPublicSuccessfulSuffix.source_same_material` has exactly this boundary:

```text
s : State; out : Result; f,g,h : ArrayPointer; fv,gv : Geometry.Vec
Slot s "logn" 10; Ternary s
s.arrays "f" = some f; s.arrays "g" = some g; s.arrays "h" = some h
Legal s.heap f; Legal s.heap g; Legal s.heap h
Represents s.heap f fv; Represents s.heap g gv
Bound fv 1; Bound gv 1
h.block != f.block; h.block != g.block
LiveTables s; KeygenPublicFrame.Tables s h.block
out.flow = returned (some (int32 1))
Exec fixedPublicProgram ["f","g"] (code compute) s out
--------------------------------------------------------------
Front s out f g h fv gv
```

`Front` selects the SAME fresh3072-cell t block,afterT state,inner result
and actual complete suffix execution. It concludes:

1. Actual f/g/t/h bindings and n1536/q18433/u1536/logn10/ternary1 at afterT.
2. ALL1536 ORIGINAL gv evaluations in h and fv evaluations in t at **the
   SAME afterT state**,not at separate return points.
3. ALL1536 ORIGINAL fv evaluations are nonzero.
4. A `Run` witness for the actual successful pass and subsequent inverse
   Call/return syntax,with the actual quotient entry described below.
5. The observed flow agrees with the inner result,and the actual final t
   disposal is `out.state.heap = disposed s.heap inner.state.heap block`.

Legal entry/profile/material/bounds1/liveness remain obligations of the
later enclosing KeyGen. There is **one newly explicit legal-memory frame
premise** relative to042: every static-table binding has a block different
from h. It supplies the generic callee-footprint frame across t's forward
call. It is not a g image,transform-correctness,nonzero,round-trip or equation
premise. Enclosing KeyGen must derive it from its actual static/output layout.
Do not hide it or advertise the current theorem as whole KeyGen.

No initial converted array,generated twiddle table,forward result,nonzero
or quotient image is a premise of the complete public headline. No inverse
correctness or desired mulRq equation is a premise or conclusion here.

## 2. Exact successful-suffix/inverse-entry boundary

Define `values v j` as evaluation of the ORIGINAL
`CoefficientQuotient.polynomial (Relation.reduceVec v)` at
`KeygenPublicRoots.point (j mod 1536)`. `values_physical` proves that for
`i : Fin1536` this is exactly the physical point i,using equality of the
complete Fin index rather than rewriting inside a dependent bound proof.

`KeygenPublicSuccessfulSuffix.Run afterT inner p fv gv` selects
`beforeInverse` and `afterInverse` with:

```text
Exec fixedPublicProgram signed pass afterT <beforeInverse,normal>
Header p beforeInverse
forall i : Fin1536, values fv i.val != 0
Cells beforeInverse.heap p.t 1536 (values fv)
Cells beforeInverse.heap p.h 1536 (fun j => values gv j * (values fv j)^-1)
Exec fixedPublicProgram signed inverse beforeInverse <afterInverse,normal>
Exec fixedPublicProgram signed (seq success skip) afterInverse inner
```

Every `Cell` includes the actual unsigned16 load,canonical value<18433
and ordinary field equality. Thus canonicality and the quotient value are
both proved at inverse entry. **This is not final canonical h.**

The actual inverse execution is retained as a source witness to be refined
next;it is not an oracle or an assumption of mathematical correctness.
Final t disposal remains linked to that same result;do not assert a live
t transform array after disposal or unchanged h quotients after inverse.

### Source composition

- `KeygenPublicCommonCalls.both` transports h/g through t's actual forward
  Call using the checked fixed-program footprint,table nonaliasing and live
  h loads. Both caller bindings preserve the actual locals/arrays/tables.
- `KeygenPublicCommonMaterial.source_same_material` derives the common
  header from the actual declaration/allocation/setup/conversion/Call chain.
  Neither header nor evaluation image is imported as a new final premise.
- `KeygenPublicSuffixProgram.source_complete` binds the actual1537–1546
  test/division loop,inverse Call and return1 to the complete source suffix.
- The actual unsigned16 t load is promoted to int32 before comparison with
  zero. The canonical cell makes that word-zero test equivalent to zero of
  the ordinary field value. A normal test selects the nonzero branch.
- `KeygenPublicSuffixAtoms.quotient_value` normalizes the two actual uint16
  promotions to uint32 helper parameters and consumes the already checked
  source `mq_div_18433` addition-chain/Fermat contract. Its output is both
  canonical and equal to the actual g value divided by the tested f value.
- One normal body performs the chronological h store and preserves all other
  h cells and EVERY t/f cell. Its failure can return only source int32 zero.
- The complete finite loop has the dichotomy **failure0 OR normal with all
  1536 tests/quotients completed**. Initialization derives u0 from the actual
  declared u1536 slot;increment derives i+1 with unchanged bounded word rules.
- The complete compute's observed return1 excludes the failure case and
  selects the actual inverse Call AFTER the whole pass. No input nonzero
  premise or assumed inverse/forward round-trip substitutes for this argument.

## 3. Audit,pins and finite source controls

BEFORE any proof edit/job,the exact BATCH_015–042 closure was verified:
**7747 distinct pins/652 literal source bindings**,no supersession/job.
Entry `.build/levels_043/ENTRY_PINS_043.json`:
`c18dc2c83083d0cd3b9d26a5600c09c2c0ee957138fade852b1816430675f8ab`.
The dedicated043 PRESEAL rechecks the identical7747 predecessor bytes:
`675e455c07c47b5d2a01320dbb5d9170a4e61611985e3dd40135c99245be4043`.

Seven proof modules and the audit producer accepted guarded **0/0** streams,
unchanged limits. Internal audit: **658 entries =51 new+607 inherited;605
complete terms +53 kernel inductives with constructors;zero elisions;only
propext/Classical.choice/Quot.sound**. Current literal inventory660.
This is a complete internal type/term/axiom audit,not independent review.

- Common-state source: `2efa56581b524f11b8bc49ae1e4484415096efe3ea0abce75f6ac1067b4f60f2`.
- Complete common-material source: `f50f2a83056abe3804c41bbc2a208c1d847e735d6dd3957f0ad301c112aacfbf`.
- Successful headline source: `c29f5efe9fdf0681e53532845764d65ff7be4c44b7594dfa29175fb73ec592e0`.
- Full loop source: `f6af6831fddc010d6389c330c58f09d8c2373a3fed60d1701d2428b6a6c37ce1`.
- Audit JSON: `35b5714330f5c25d1455055ab70ba1154853b01698be586901cbe53b878c4c61`.
- Audit receipt: `2451a8d570558d3a1095f0508533148af884cac89bad8b38dc2224b4fcd13374`.

Sage `keygen_public_suffix_checks_043_001`,standard preparser,accepted0/0:
**12 new normal/UBSan C runs**,eight public synthetic f/g pairs,seven
successes/one rejection in each baseline mode. Each mode checks **10753
chronological tests and10752 quotients**,complete original afterT evaluations,
all canonical quotient stores,t preservation at inverse entry and boundary
canaries. Five mutations per mode are all detected: wrong denominator,
wrong Montgomery/division scale,wrong initial counter,skipped zero rejection,
corrupted g at the common seam. Exact QQ/ZZ/finite-field calculations are
diagnostics supplementing the universal Lean proofs,not replacing them.

- Sage source: `7ffb1c5cc82a0809b7a1a1b97f53f65afda95e429e89fe38caad11856656ac7f`.
- Result: `a200e8e63f5e6cfe53fbabb99a3535f2a962b70d83de1b9424a5d9ea6ae16aa9`.
- Receipt: `19629795138e5ecfef4a1dc851a2a6085311aa2a5fceb06e781ddd780f0dbd9f`.
- Explicit include/header manifest: `44b349d2126a32f29e70951e268614b7266d8f6d7d334555de15304c1b951628`.
- Fixture: `93a70e0d703883a7a4e4212afe3d4a03745ba4142ca26dd22a98997cd202c9f8`.

C is read from live `Extra/c`. The inherited039 owner-approved FPR-header
difference is unchanged and explicitly rehashed;this is NOT a complete
historical M0 build. The inverse actually runs in these finite diagnostics,
but its output is deliberately not checked/promoted to an inverse theorem.
No private KeyGen generation or secret/random material is used.

## 4. Retained attempts and traps233–242

All **15 directories/20 completed receipt steps** remain:four wholly accepted,
11 failed directories;nine accepted steps/11 rejected steps. No interrupted
attempt or unresolved job. Recorded max cumulative RSS **3232764KiB**.
No proof/resource limit was raised. The pair pins every source snapshot,
accepted product,raw stream,guard receipt,wait record and diagnostic artifact.

1. **233:** Bool false needs its equality lemma;explicit unsigned-promotion
   arguments and removal of unused simp arguments preserve clean logs.
2. **234:** the generic `convert_self` pattern does not match reduced numeric
   zero;two retained attempts precede the precisely typed numeric equality.
3. **235:** after conversions,use an exact typed zero comparison instead of
   overbroad simplification involving a BitVec integer expression.
4. **236:** whitespace around `< i` prevents its variable-dependent lexical
   collision. The failed parse/elaboration stream is retained.
5. **237:** scoped Result dependent elimination needs a generalized result
   and its normal-flow equation;do not force elimination against a projection.
6. **238:** skip elimination substitutes the last-state binder;use the actual
   remaining `after` variable,not the eliminated name.
7. **239:** variable-dependent empty-write goals use the exact footprint lemma;
   dependent `if` comparison transport uses `simp`,not a bad-motive rewrite.
8. **240:** initialize opaque `Cells` pointwise,not by simplifying its function
   argument. The already accepted body remains pinned in that failed job.
9. **241:** original-polynomial names require the explicit `FT1536.Run2`
   namespace. The failed elaboration,including its generated error term,is
   preserved and never counted as an accepted proof.
10. **242:** original quotient-polynomial evaluation is noncomputable;rewrite
    equality of the whole Fin index,not a natural value inside its bound proof.

No unfinished-proof markers occur in accepted source. Historical failed
snapshots/logs remain unchanged. The committed dedicated043 verifier is
`791dec3cd76bcee6bbeeae0a3e0ebd38b72ac208f748eb2a2b56c96d40a37d0f`.
Pair/POSTSEAL hashes are recorded in the live checkpoint to avoid self-hashes.
Own source/evidence commits: `bebaa1fb`,`bd28a330`,`73ba45aa`,plus final pair/
checkpoint commit. Foreign work/staging preserved. No push,review,delegation,
relay,migration,stages import or broad replay.

## 5. Remaining B1.06,in unchanged16.1 order

1. **Common afterT DONE. Successful nonzero/tests/division DONE.** Consume
   `Run`'s derived beforeInverse cells/header and the SAME actual inverse Exec.
2. **Item3 NEXT:** source inverse/normalization and final canonical h. The
   local refinement target takes logn10,actual a/h binding,derived quotient
   input cells and actual inverse execution,and concludes canonical output
   cells of some `hv : Relation.Rq` plus every ORIGINAL physical evaluation
   of `hv` equal to `values gv i * (values fv i)^-1`. Tables/aliases/seeds/
   counters/round-trip are not final premises. Bind actual1067–1159: generated
   igm words,512 inverse triples,eight reverse radix stages,768 first-root
   inverse bodies and1536 normalization stores. The live ni branch computes
   `mq_div_18433(Rt,(uint32_t)n)` at logn10;prove its scaled radix/n meaning.
   Preserve both automatic-array disposals and then the caller's t disposal.
3. **Item4 THEN:** fInv from the derived nonzero evaluations and a proved
   evaluation isomorphism;BOTH SAME f/g/h `mulRq` equations. Inspect exact
   B3/dependency types/pins before reuse. No assumed source inverse round-trip.

The new result closes the common-state and successful pointwise-division
gaps. The remaining inverse/equation gap is a missing source/mathematical
proof,not a detected numerical/code counterexample. B1.06 Acceptance still
requires both equations;B1.07 waits. Full KeyGen/emitted-to-fiber,compiler,
probability laws/PRG/security and independent review remain outside this
midpoint's claims. Resume checkpoint **23R**,one midpoint or Acceptance in
the next owner-started window,not an automatic restart.
