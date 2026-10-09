# BATCH_033 — B1.06 public scalar algebra / transform-entry midpoint

2026-10-09, GPT-6.1 Sol Fast (`openai/gpt-6.1-sol-fast`).
**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
**B1.06 Acceptance NOT MET.** The window closes at an expanded recoverable
midpoint under `run2/notes/B1_STAGED_ROADMAP.md`; B1.07 is not entered.
B1.05 remains closed at the exact BATCH_032 boundary, not re-proved here.

## 1. Actual entry and source/model scope

BEFORE edits/jobs, `tools/keygen_caller_batch.py verify` checked the complete
BATCH_015–032 closure: **5019 distinct pins,561 current inputs,no supersession,
no active job**. Entry receipt `.build/levels_033/ENTRY_PINS_033.json`, SHA256
`0173a014e06b217e3e47053148de2fe410749a0d29d929c2e0d46b7fb0249ba5`.
Sources are the pinned M0 `inputs/source`, not live `Extra/c`. No predecessor
source/report/pair was modified. Existing public operational execution was
consumed through its existing `KeygenPublicScalar.Body/Leaf/Square/Call`.

The inspected B3 `FftBind.NttSem` exports the big-prime solver's source
inventory/prime values/dimensions, NOT a q18433 public-transform refinement.
It is not imported as a replacement for the missing public source theorem.
Pure physical-index facts from B1.03 are reused through the pinned closure;
they are independent of the modulus. They do not identify executed public
`rev10` results or generated gm/igm memory by themselves.

## 2. Checked source helpers and explicit premises

Nine new proof modules are currently accepted with clean streams:

- `KeygenPublicLinear`: proved scalar lowering of the modular reference's
  actual straight-line executions; parameter/return semantics are retained.
- `KeygenPublicLeafWords`: complete parsed conv/add/sub/half/montymul bodies
  produce exact word results. Source equalities cover the real body, not
  an invented outer scope. Local parameter-binding witnesses are proved.
- `KeygenPublicMontgomery`: UINT32 throughout,radix2^16,wrapping z*q0i LOW16,
  separately proved no-wrap numerator and canonical reduction/congruence.
- `KeygenPublicAlgebra`: canonical field laws from the SAME fixed public
  Call,including signed conversion,addition/subtraction,half and explicit
  Montgomery scale. Prime18433 and radix invertibility are kernel facts.
- `KeygenPublicArguments`: a proved equality of actual parameter binding
  accounts for signed int constants passed to unsigned32 parameters.
- `KeygenPublicSquare`: complete square Body/actual nested leaf and return
  conversion yield the exact word result and the field square law.
- `KeygenPublicDivisionWords`: complete parsed `mq_div_18433`,both declaration
  groups,the19 assignments and the final multiplication. Ready allows
  uninitialized locals but an executed read cannot use one. Every actual
  assignment derives the next word environment; the return formula is a
  conclusion,not a constructor field or arithmetic oracle.
- `KeygenPublicDivisionAlgebra`: every node's canonical range and scale is
  proved,including y0 conversion,R*y^18431 at y18,and the ordinary final x
  multiplication. Fermat gives division for the actual nonzero divisor.
- `KeygenPublicRoots`: source literal25,orders9216/4608,1536 distinct Phi
  roots in physical triple order,and coefficient-polynomial injectivity.
  This is mathematical geometry,NOT a source table/transform theorem.

The source-call division boundary is exactly:

```text
x,y,out : BitVec32
x.toNat < 18433; y.toNat < 18433; y.toNat != 0
source : KeygenPublicScalar.Call (name divT) [uint32 x,uint32 y] (uint32 out)
-------------------------------------------------------------------------
out.toNat < 18433
value out * value y = value x
value out = value x * (value y)^(-1)        in ZMod18433
```

`source_division_arguments` also handles actual pre-conversion argument
values via explicitly proved U32 bindings. The modulus/prime/scale/addition
chain are NOT premises. Canonical input and nonzero divisor are explicit
local domains; the SAME successful public transform/test execution must
derive them before final B1.06 composition. Signed conversion's proved
domain is `-18433 < x.toInt < 18433`; sampler bounds will supply it.

The geometry boundary is unconditional in its mathematical model,with
`point i = (25^2)^(tableExponent(512+i/3)+1536*(i%3))` in ZMod18433.
It does not supply a memory image or an evaluated source forward transform.
The two required Relation.mulRq equations and an fInv witness remain OPEN.

Full internal audit: **220 entries =197 named new declarations +23 inherited
interfaces;205 complete terms +15 inductives/structures with constructor
types,standard axioms only,zero elisions**. Artifact5029668 bytes,retained
under `.build/jobs/keygen_public_audit_033_001/PUBLIC_AUDIT.json`,SHA256
`ffd9038c052406edb31f62320beeca0abfebf50de5cb48fece0b8dcc12048bd1`.
Audit receipt SHA256
`2490db6370d34fe6f027da6f888079169c00336f390efecaef72a243067df9f0`.
All ten current accepted Lean modules (nine proofs +audit) have0/0 streams.
Maximum accepted cumulative RSS5034220KiB; process/kernel/print limits
unchanged. Final audit input closure571 sources. The predecessor closure
was rechecked unchanged at preseal:no supersession/no active job,receipt
`.build/levels_033/PRESEAL_PREDECESSOR.json`,SHA256
`06c2c283b56f44adf8ddbd98be2975dccbad3e399983507a4db99ddc1e5c9856`.

## 3. Finite controls — supplementary, not the missing kernel bridge

Standard `sage check_keygen_public.sage`,exact ZZ/residue-polynomial rings:
**14 runs** (baseline + six mutations,in normal and UBSan modes). Each run:
18433 paired scalar rows,18433 signed-conversion rows,2048 table rows,
seven synthetic forward/inverse transforms and four public-call fixtures.
All baseline outputs match exact arithmetic,evaluation order,inverse and
material/sentinel frames. Three synthetic public fixtures return1;zero f
returns0. These are NOT accepted complete KeyGen attempts or private keys.

Mutations detected in both modes: low mask,q0i,division-chain operand,source
root,inverse normalization and omitted nonzero test. Full raw compile/run
streams,C harnesses/results and public fixtures are retained and pinned.
The successful job is `keygen_public_checks_033_002`. No production C is
modified. Passing finite controls does NOT establish the remaining universal
source table/transform/caller propositions or any probability law.

## 4. Traps166–174 and all failed attempts

166. Do not substitute solver radix2^31/uint64 for public radix2^16/uint32.
167. z*q0i may wrap; only LOW16 is needed. Prove the actual numerator fits32
bits; the C comment's suggested29-bit reasoning is not an arithmetic premise.
168. Scalar Body parsing starts inside the body: it is the chain,not a new
outer scope. The first false binding draft failed and remains preserved.
169. Int literal arguments are not already uint32. Normalize the actual
parameter conversions by a binding theorem,including R2t/Qt/Q0It.
170. Generalize callee-name indices before elimination. Direct dependent
elimination of UTF8-backed names caused the unchanged heartbeat exhaustion;
typed/generalized inversion resolved it,without raising limits.
171. The old source REV10 table certificate is not an execution theorem for
the public helper's ten-iteration `rev10` function. Its value bridge is open.
172. Geometry/injectivity is not generated gm/igm memory or source evaluation.
173. Division at y=0 is not evidence of successful public computation. The
actual zero tests still must be extracted before applying nonzero division.
174. The first chain mutation left y18 unused and failed unchanged -Werror.
The accepted mutation changes y18's operand while preserving all local uses.

Every attempted `keygen_public_*_033_*` directory is inventoried by the pair.
The first division shell invocation was interrupted externally after120s,
without RECEIPTS.json. Its snapshot/raw bytes and separate interruption
record remain; no engine receipt/exit code is invented. Later calls remove
only that extra shell timeout; the original guarded1800s step limit remains.
Proof/linter/parser errors and the failed mutation compiler run remain raw.
No unfinished Lean source is accepted as evidence. No warnings are suppressed.

## 5. Remaining B1.06 — exact seams,in plan order

1. Prove actual public `rev10` result equals bitrev10 on the source indices.
   Derive both dynamic mq_mkgm3 table images,canonical ranges,scaled row/root
   laws and allocation/material frames from its SAME stores and logn10 path.
2. Bind actual signed f/g conversions and the forward NTT's first,radix2 and
   triple passes to `CoefficientQuotient.polynomial` and `KeygenPublicRoots.point`.
   Desired type: legal original arrays/profile + source forward execution
   imply canonical unsigned16 output AND these evaluations for every cell.
   Neither a generated table image nor an evaluation may be assumed in the
   complete public-call theorem.
3. Extract all1536 successful nonzero tests; apply checked division to the
   SAME h/t images. Prove the actual inverse transform and its n1536 scale
   from the source code/table generation,not from finite round-trip controls.
4. Construct fInv from the nonzero evaluations and the proven evaluation
   isomorphism; derive canonical h and BOTH equations for SAME retained f/g/h:
   `mulRq h (reduceVec f) = reduceVec g` and
   `mulRq fInv (reduceVec f) = constantCoeffs (1 : ZMod18433)`.
   Compose at the existing caller/material seam without changing the B1.05
   result or advancing into chronological whole-loop B1.07.

This is a missing enclosing source proof,not a numerical/code counterexample.
The new scalar algebra and root geometry remove real dependencies but do not
satisfy B1.06 Acceptance. The window's final audit/pins/receipt details are
in BATCH_033 JSON and checkpoint13/13R. Small local commits use main as
niirmataa under archive.lock. No push,subagent,worker/session/relay,review,
migration,stages import or security/owner-acceptance claim.
