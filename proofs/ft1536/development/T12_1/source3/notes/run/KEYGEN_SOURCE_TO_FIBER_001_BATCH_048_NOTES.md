# BATCH_048 — complete readiness, both temporary lifetimes and SAME first samples

**B1.07: PARTIAL_PROOF / Acceptance NOT MET / NOT_REVIEWED.**
**Package: IN_PROGRESS / WORKING_NOT_FROZEN.**
2026-10-10, GPT-6.1 Sol Fast (`openai/gpt-6.1-sol-fast`).
**CLOSED_AT_RECOVERABLE_MIDPOINT.** One close this window, at COMPLETE RNG
READINESS/first sampling. B1.05/032 and B1.06/046 scopes are unchanged;
B1.08/B4/B5 are NOT entered. Historical runner/session labels are provenance.

## 1. Pin verification BEFORE edits/jobs

BATCH_015–047: **9257 distinct pins /706 literal source bindings**, no
supersession or active job. The dedicated048 organizer rechecks the SAME
unchanged predecessor bytes before sealing:

- Entry `.build/levels_048/ENTRY_PINS_048.json`:
  `f0864f27ce86fa1d1b3c81f8f8bc27f78cd1c1f43a3a1c77d5cc4b2731084256`.
- PRESEAL `.build/levels_048/PRESEAL.json`:
  `addf7e066c6a914b8cdb5d55ff6f2df1e8679c87b4064a0fbdd13d7af4031993`.
- Seal/verify organizer `tools/keygen_rng_batch.py`:
  `c818c86c6780f30c8c55193ec783135138ce8ecd873ecf36d7f4cad0651df0f5`.

The pair and POSTSEAL hashes/counts are recorded in the live checkpoint,
avoiding recursive self-hashes. All historical source/artifact/failure pins
remain byte-exact; no predecessor source or cache product is superseded.

## 2. Complete fixed source closure — not an arbitrary ready oracle

Eleven new proof modules cover this boundary:

- `ShakeSeedMemory`: explicit byte fill/read rules, unsigned-char promotion,
  the fixed dec64le expression and the actual xor_block loop. All word loads,
  bitwise xor, loop tests/increments and byte/word stores are operational.
- `ShakeSeedProgram` / `ShakeSeedReference`: complete parsed source bodies of
  shake_init, shake_inject and shake_flip, including the capacity arithmetic,
  complemented initial lanes, full/partial absorption blocks, actual
  xor_block/process_block calls, postincrement and both padding branches.
  process_block is the previously bound full word body, not a Keccak oracle.
- `KeygenEntropySource`: finite Linux urandom_get_seed/falcon_get_seed
  control with failed opens, read errors, EINTR, short/zero reads, pointer
  advance/unsigned subtraction, close and the actual return test. The
  external open/read/errno/close observations are explicit and chronological.
- `KeygenRngProgram` / `KeygenRngReference`: complete parsed set_seed and
  rng_ready bodies with fixed callees and actual arguments. Replace/nonreplace,
  seeded/unseeded, already-flipped/unflipped and failed seed acquisition are
  all represented. No input flag truth, initializer image or arbitrary heap
  transformer is used as a callee.
- `KeygenRngFrame`: executed Fresh automatic tmp32 allocation, restoration of
  its pre-allocation bytes/extent/permissions and its saved pointer name on
  every exit. This includes the OUTER entropy tmp and the DISTINCT INNER
  remix tmp in set_seed. Actual calls/stores derive the context subobject and
  live caller frames; the generic Safe condition is discharged INTERNALLY
  from source syntax/fresh allocation, not added to the exported call type.
- `KeygenReadyResult`: every finite ready call returns0 or1. On return1 BOTH
  signed flag words are nonzero as a CONCLUSION. An initially nonzero negative
  flag is treated as nonzero, not silently replaced by a positive flag.
- `KeygenMakeReady` / `KeygenMakeReadySampling`: the SAME enclosing declarations,
  counter assignment, dimension reads/MKN, full caller readiness gate, first
  cap/setup and actual f/g sampler calls. These remove047's fast-only subset.
- `KeygenRngAdequacy`: exact parsed dec64le tree/reference lowering, active
  Linux wrapper, physical member offsets and both tmp extents/disposal laws.

Both tmp lifetimes are part of the actual execution, including the early
failure return. This does NOT close the later disposal of all SIX enclosing
make automatic objects; that whole-call lifetime remains OPEN.

## 3. Precise checked interfaces and their REAL premises

The actual full call relation is:

```text
KeygenRngReference.Call ctx before externalEvents after v
------------------------------------------------------
v = int32 0 OR v = int32 1

KeygenRngReference.Call ctx before externalEvents after (int32 1)
--------------------------------------------------------------
exists seeded flipped words loaded from after's ACTUAL member bytes,
  both signed words are nonzero
```

This relation contains the finite source execution, actual typed memory
reads/writes/argument binding, complete fixed body calls and explicit
external entropy observations. It contains no seed-availability, uniformity,
PRG law, desired flags or assumed caller-frame postcondition.

`KeygenRngFrame.call_frame` derives unchanged size/writability maps and each
byte outside the actual context interval **[object.offset+8,object.offset+432)**.
The RNG and flag bytes WITHIN that interval may change. It would be false
to retain047's whole-State equality on newly seeded/flip paths. Every caller
slot/table binding is retained by the actual call boundary. M0 profile fields,
scratch pointer bytes at432, static objects and all fresh coefficient arrays
are consequently retained by the enclosing prefix.

The expanded enclosing headline is:

```text
Original ctx before primes rev
Prefix ctx before blocks externalEvents (after, normal)
------------------------------------------------------
Count after 0
Initial ctx after (input blocks) (publicPointer blocks) primes rev
both actual readiness flag words nonzero
after.locals = (old contiguous ready-prefix state).locals
```

`Original` still contains only actual incoming context/profile/static/scratch
memory. NO coefficient allocation/value, Bound1, equation, certificate,
already-ready condition, changed-heap identity or final legality is an input.
The failure caller gate executes the actual return0; it is not conflated with
normal prefix completion or later output-capacity failure.

The SAME expanded first-sampling export is:

```text
Original ctx before primes rev
FirstSamples ctx before blocks externalEvents after
---------------------------------------------------
Count after 1
exists fv gv : Geometry.Vec,
  Represents after.heap (input blocks 0) fv and Bound fv 1
  Represents after.heap (input blocks 1) gv and Bound gv 1
```

The first cap domain follows from source counter0; no extra reachable-count
premise is introduced. Setup follows the cap and dimension execution is NOT
repeated. The subsequent global loop invariant/attempt chronology is still
OPEN. This export describes first stored material, not a six-gate accepted
attempt, an emitted key or a conditional probability law.

## 4. External-system and source/model boundary

The system-seed model is explicitly **Linux M0**, with active USE_URANDOM1,
USE_WIN32_RAND0, O_RDONLY0 and EINTR4. Native Sage hashes the actual Extra/c
frng.c and exact literal regions, checks the actual compiler macro values
and active falcon_get_seed wrapper, and checks LP64 struct/ssize_t layout.
Windows and platform/OS/compiler/machine refinements are NOT proved here.

Read observations obey an explicit POSIX-style bounded-byte-write interface.
They can fail, retry, supply short reads or return zero. Finite derivations
do NOT imply termination: repeated zero reads can continue indefinitely in
the real source loop. No real entropy bytes are acquired by this work.
This is not an entropy-quality theorem, uniform seed assumption, real-PRG
bridge or availability bound; those contracts remain separate in B4/B5.

Live reference C is read from `Extra/c`, never copied from a foreign W.
Keygen/frng/SHAKE and used project headers match M0; the inherited039 approved
FPR-header delta remains unchanged/rehashed. The controls are NOT a complete
historical M0 build and are not a proof about the compiler.

## 5. Internal audit and public finite controls

Eleven proofs+audit accepted guarded **0/0**, unchanged limits. Internal
audit: **231 entries =185 new+46 inherited**, **189 complete terms+42 kernel
inductives**, full constructor types, standard axioms only, zero elisions;
**718 literal source inputs**. Existing public046/solver/certificate interfaces
are inspected/pinned, NOT consumed as a whole-attempt theorem.

- Audit JSON `9874a2267305699c6a3409ecc295a97c7db3b33a016f601fc5c6d7c2f24f1697`.
- Audit receipt `e7692494a70a56157ffda001de9813c2e7b0c39a410e4ad85c38d7ded746786c`.
- Sage004 result `25af27d4cf55a18befdf20fa495273877a1ab8c218426af7c9ee4be9350655e3`.
- Sage004 receipt `dc91a734f9e64e41d88acfe946142f62d50935c46bb46ec3061e27f598af7f05`.
- Source/compiler binding `adaa9be39169d265324308acbfde074f038211ac40731e722d4b9d3ad662fa08`.
- Public fixture `c1f5c6e951ce026794d6845d56b649308c37010de9554a5e57dd57a716b35b11`.

Native Sage/ZZ004: **14 normal/UBSan C runs**. Each run checks **one LP64
layout +35 readiness +18 set_seed +10 entropy cases**. Public deterministic
SHAKE bytes are independently computed, including prior flipped-state remix,
replace/nonreplace, empty/full/multiple absorb blocks and padding boundaries.
Actual source prefix counter0/MKN/extents/separation and context retention
are checked. Scripted syscalls cover failed open, error, partial failure,
EINTR, zero read and successful completion, without touching real entropy.

All SIX mutations are detected in BOTH modes: missing seeded store, missing
flipped store, forced seed failure, wrong tmp extent, wrong replace argument
and wrong boundary padding. Successful003 is retained as a PRE-layout run;
004 adds physical layout checks without weakening any existing assertion.
No complete KeyGen, full attempt, private material or emitted key is generated.
Finite controls support but do not substitute for the kernel source proofs.

## 6. Retained history and traps267–280

All **31 directories /32 completed steps** remain: **15 accepted+17 rejected
steps**, **14 wholly accepted+17 failed directories**. Max recorded cumulative
RSS **3561684KiB**. No interruption, missing engine receipt or active job;
no proof/process/print limit was raised. Source snapshots, all raw streams,
runner/execution snapshots, WAIT/PREFLIGHT and earlier products are pinned.
The failed combined sampling001 includes an accepted MakeReady step; it is
not erased merely because its second module was rejected.

267. Comparison whitespace and record-field indentation require exact syntax;
     fill frames must explicitly expand the pointer's physical offset.
268. Use the actual modular scalar assign constructor for its read-only frame
     theorem, not a base-array assignment of a different statement type.
269. The syntax type is B20.C.Ty. Preserve the rejected cascading elaboration
     errors without introducing a proof marker or relaxing the guard.
270. Indexed events/values can be eliminated by cases; use actual remaining
     binders rather than guessed constructor argument counts.
271. Multiline grouped alternatives need correct Lean syntax; splitting cases
     changes neither source coverage nor theorem premises.
272. Parenthesize boolean-and before equality. Unfold the precise TmpOutside
     predicate and normalize the projected State array equality.
273. tmp32 scope elimination needs a raw-result inversion, then the actual
     normal-flow equality; never assume a desired post-disposal flag.
274. Normalize a projected Result.flow equality before dependent substitution.
275. Give the counted-State profile explicitly, so inference cannot silently
     choose the pre-counter State despite their identical heaps.
276. Use a typed locals equality for the opaque ready/count projection.
277. `prefix` is a reserved Lean keyword; rename the local facts binder.
278. Decide equality on the parsed CLogic tree, then prove exact reference
     lowering. The reference Expr has no DecidableEq; no new axiom is needed.
279. Native Sage ZZ metadata requires explicit JSON integer conversion.
280. Preserve -Werror: observe the diagnostic's ACTUAL n instead of hiding an
     unused-but-set warning. Added LP64 checks preserve the successful003 run.

Own source/evidence commits: `35e37c4f`, `1ac37361`, `49f4854e`; the closing
pair/checkpoint commit is separate. Foreign changes/staging are preserved.
No push/review/delegation/relay/migration/stages import or broad replay.

## 7. Remaining B1.07, in plan order — no Acceptance claim

Resume from checkpoint **28R**, SAME stage, not B1.08:

1. Complete enclosing make syntax/scopes/ternary branch/fixed destinations,
   legal argument/scratch/layout frames and actual lifetime of all SIX make
   automatic objects through every whole-call return.
2. Derive the global reachable counter invariant and chronological attempted
   body list from the actual for(;;), including all earlier rejects, no normal
   attempt fallthrough, final successful break and length<=3000000. The
   AttemptExecution/Accepted/Rejected, LoopExecution/Succeeded and
   successful_loop_last_attempt names remain TARGETS, not048 exports.
3. Bind ALL six gates on that SAME actual attempt: resultants f/g, raw and
   orthogonal FPEMU norms,046 public equations/material,032 solver and complete
   mandatory certificate. Derive local entry facts, common call ID, snapshots,
   retained material and bad lifetime; no desired equation/certificate input.
4. Tie accepted f/g/F/G/h to ACTUAL later encoding-input memory and complete
   enclosing teardown. Keep per-attempt acceptance distinct from output
   capacity failure/call-level return1. Codecs remain B1.08/09.

These are missing source/composition proofs, not code/numerical counterexamples
or an insufficient arithmetic estimate. Whole KeyGen/emitted-to-fiber, laws,
seed availability/uniformity/PRG, security/CT, compiler/machine/OS/Windows
refinements and independent review do not follow from this scoped midpoint.
