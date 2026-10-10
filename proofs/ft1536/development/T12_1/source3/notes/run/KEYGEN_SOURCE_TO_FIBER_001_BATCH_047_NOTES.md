# BATCH_047 — enclosing declarations, already-ready prefix and first sampling

**B1.07: PARTIAL_PROOF / Acceptance NOT MET / NOT_REVIEWED.**
**Package: IN_PROGRESS / WORKING_NOT_FROZEN.**
2026-10-10, GPT-6.1 Sol Fast (`openai/gpt-6.1-sol-fast`).
**CLOSED_AT_RECOVERABLE_MIDPOINT.** One close this window; no intermediate
close or B1.08/B4/B5 work. B1.05/032 and B1.06/046 scopes are unchanged.
Historical runner/session labels remain provenance, not this attribution.

## 1. Entry pin verification BEFORE edits/jobs

BATCH_015–046: **8965 distinct pins/700 literal source bindings**, no
supersession or active job. New durable entry receipt:

- `.build/levels_047/ENTRY_PINS_047.json`:
  `4418daa7485006b21aed48081e49da5939e10a53095edca72daee3b341822336`.
- Dedicated047 PRESEAL rechecks the SAME8965 predecessor bytes:
  `474e778d48efcd2c5825b572b5a378bb6c11049e5c6d712e12723e79afcd0e14`.
- Dedicated seal/verify organizer:
  `5a7c624b1ca6ed59cf81d634138494c1e91736cf36e22192b34e7209dcf350f8`.

The pair and POSTSEAL hashes are recorded in the live checkpoint, avoiding
recursive self-hashes. No predecessor source/artifact/failed-history pin is
weakened or superseded.

## 2. Automatic objects and the ORIGINAL caller boundary

`KeygenMakeObjects.Exec` executes SIX sequential Fresh allocations. The
source declarations give f/g/F/G/h count3072,width2 and ske count4,width8.
Each allocation has a new explicit block and uninitialized bytes. Separation,
extent/writability and legality are CONCLUSIONS; pairwise block separation is
not an input to this execution. Even the unused high coefficient cells remain
uninitialized; no arbitrary vector is manufactured by the declarations.

`KeygenMakeEntry.Original` contains only:

```text
actual fk slot and legal LP64 context object
M0 logn10/ternary1 member bytes
source PRIMES3/REV10 slots, read-only contents and static liveness
legal original scratch allocation and context/scratch/table separation
```

There is no incoming coefficient pointer/allocation, vector, Bound1, NTRU,
public/inverse equation, desired certificate, final legality or heap-frame
premise. `initial` DERIVES the previous `KeygenCallerEntry.Initial` from that
original boundary and the fresh allocations. Existing live objects and their
contents are retained block-locally: global size/writability maps DO change
when automatic blocks are allocated. Full-call arguments/output-buffer legal
memory and the eventual encoding/teardown still require later binding.

`dispose_object`/`dispose_other` prove disposal algebra, not an executed
whole-call teardown. The final caller return has not been bound to it.

## 3. CONTIGUOUS declarations/dimensions and the checked RNG path

`KeygenMakePrologue.prefix_tokens_source` binds the complete active token
stream7805–7838, including every declaration, local_attempts=0, both actual
member reads, MKN and the RNG failure gate. `Declarations` uses the actual
chronological Fresh snapshots: klen/skoff/skbuf declarations lie BETWEEN h
and ske; i/local_attempts follow ske. The allocation-only projection needed
by item2 is PROVED, not an assumed transition or reordering of source events.

Actual source counter assignment gives uint64 zero. Actual logn/ternary
loads and the existing MKN word theorem derive logn10/ter1/n1536. Unlike032,
the dimension fragment is not simply bridged over an omitted RNG gap.

**However, the implemented RNG path is explicitly restricted.**
`KeygenReadyFast.Body` consumes both actual SIGNED seeded/flipped member
loads, their executed false `!` guards and the actual return1. It derives
nonzero flags, return1 and unchanged state. `Call` also resolves the actual
fk argument and performs the return conversion. It uses no seed-uniformity,
SHAKE idealization, availability or arbitrary callee relation.

The complete literal rng_ready body5273–5286 and caller failure gate7836–7838
are retained, but the unseeded and seeded/unflipped source paths are NOT
implemented by this fast-path relation. `AlreadyReadyPrefix` is consequently
an honest subset of source paths, NOT the final all-legal-entry contract.
No final theorem is allowed to require this subset as an extra premise.

The exact checked boundary is:

```text
Original ctx before primes rev
AlreadyReadyPrefix ctx before blocks after
------------------------------------------------------
after = ready before blocks
Count after 0
Initial ctx after (input blocks) (publicPointer blocks) primes rev
```

The two restricted guards belong to the execution derivation, not Original.
Nevertheless, full source adequacy for ALL RNG paths remains a missing proof.

## 4. Cap BEFORE setup/sampling; SAME first sampled material

`KeygenMakeSampling.CappedSetup` composes the source-bound cap execution
with actual7876–7881 local declaration/tmp/rt setup only AFTER normal cap
completion. It does not repeat dimension reads at the loop entry. Abort is
retained as a separate source outcome. From the LOCAL premises:

```text
Count before i; i <= 3000000; n1536; CappedSetup ctx before out
```

`cap_before_setup` derives either:

- i=3000000, increment to3000001 and return0 BEFORE even rt setup; or
- i<3000000, increment to i+1, actual setup, normal flow and Count i+1.

`no_counter_wrap` derives exact uint64 meaning on this local domain. The
global reachable-count invariant over the full loop is still OPEN; the bound
is not silently promoted to a final input or an all-execution theorem.

`FirstSamples` consumes the SAME chronological enclosing prefix, cap/setup,
then actual resolved f and g sampler calls. Its exact exported boundary is:

```text
Original ctx before primes rev
FirstSamples ctx before blocks after
------------------------------------------------------
Count after 1
exists fv gv : Geometry.Vec,
  Represents after.heap (input blocks 0) fv and Bound fv 1
  Represents after.heap (input blocks 1) gv and Bound gv 1
```

Sampler entry/protection facts come from the fresh objects, derived tmp/rt
layout and actual retained slots. The SAME resulting f/g bytes are used;
neither representation nor Bound1 is an input. This is the FIRST sampling
prefix, not a six-gate attempt or the successful-loop-last-attempt theorem.

## 5. Audit and finite source controls

Five proof modules and the audit producer are guarded **0/0**. Internal
audit: **141 entries=111 new+30 inspected inherited interfaces**, **118
complete terms+23 inductives with full constructor types**, standard axioms
only, zero elisions; **706 literal source inputs**. The public046 export is
inspected/pinned by the audit, not consumed in a whole-attempt proof.

- Audit JSON `980f1a1bbc6087dee12f48eec7f1cce90d0db2c5e7df5125a41c6b00de537050`.
- Audit receipt `5a52619f6890a825d61a06cefd0bd118647d4b8eed8f0269f3718b144f863d4a`.
- Sage result `62c62321a55630bb32b454869f9b9c64de3abea8fffae2e55b32f54b51bd77af`.
- Sage receipt `4b7f03d5aafdc08ac02fc6613dd297623da0d33fc86438537328187cb36a782e`.

Native Sage/ZZ controls: **10 normal/UBSan runs**, each with20 public
selected-prefix/cap cases (four deterministic labels, five injected boundary
counters) and6 readiness diagnostics. Actual source declaration extents and
distinct addresses, counter0/member/MKN reads, cap BEFORE sampling, rt offsets,
SAME exact MODE1 f/g bytes and SHAKE cursor are checked independently. Four
mutations per mode are detected: wrong initial zero, early >= cap, missing
increment and wrong automatic-array extent.

The boundary counters are explicitly injected diagnostics, NOT production
reachable histories or3M-step traces. Readiness diagnostics include actual
SHAKE flip and a controlled external falcon_get_seed FAILURE stub; they are
not a model/proof of the successful system-entropy path. All inputs are
PUBLIC deterministic synthetic helper inputs. No private KeyGen, complete
attempt, serialized key or probability measurement is run or claimed.

C/reference bytes are read from live `Extra/c`, not foreign W source copies.
All used live bytes are hashed against the pinned profile; the inherited039
owner-approved FPR-header difference is unchanged/rehashed. This is NOT a
complete historical M0 build. Finite controls supplement the kernel proof;
they do not close the missing universal RNG/loop source binding.

## 6. Retained history and traps260–266

All **19 directories** remain: **18 completed steps=8 accepted/10 rejected**,
plus **one interrupted directory without an engine receipt**. Max RECORDED
cumulative RSS **4896912KiB**. No proof/process/print limit was raised.
The interruption has no fabricated completed exit, elapsed time or RSS.
Source snapshots/raw streams/PREFLIGHT/runner snapshots remain; the recovery
observation found no active job. The interrupted wrapper did not produce a
completed WAIT record; the pair records its absence, not invented evidence.

260. Explicit Fin4/Fin6 projections and reflexive index bounds avoid inferred
     equalities of the wrong Fin domain; never relax allocation separation.
261. Use the exact indexed constructor argument list and quoted variable
     constructor; give the stored member cell its explicit type.
262. Record-update congr produced a large unreduced State diagnostic. Prove
     the arrays equality directly. A later nested allocation proof hit the
     unchanged2M heartbeat limit; bounded typed heap equalities resolved it.
263. Structure predicates need their actual fields; a simp mentioning the
     structure name does not rewrite its index/state dependence.
264. Deprecated if_pos/if_neg and unnecessary sequence focus are errors in
     clean source logs. Use standard ite laws; no warning suppression.
265. Keep whitespace before i at comparison-token boundaries. Syntax fixes
     do not change the arithmetic/cap domain.
266. Dependent substitution can eliminate a State alias; consume the exact
     remaining after State, not a guessed sampled binder.

Own source/evidence commits: `12cc16b4`, `91a7b77c`, `c8b613ee`; the closing
pair/checkpoint commit is separate. Foreign work/staging is preserved. No
push, review, delegation, relay, migration, stages import or broad replay.

## 7. Exact remaining B1.07 obligations — no Acceptance claim

Resume from checkpoint27R, in this SAME stage, not B1.08:

1. Replace the fast-only readiness subset by complete source-derived
   rng_ready/set_seed/SHAKE-injection/flip and system-seed-control paths.
   Preserve every failure edge, local tmp32 allocation/disposal, actual member
   bytes, argument binding and external entropy boundary. No PRG/uniformity
   claim is needed or licensed for these deterministic source facts.
2. Bind the complete enclosing source syntax/scopes/branch and fixed actual
   call destinations. The allocation/disposal algebra must become the actual
   full invocation; do not substitute abstract name equality for memory.
3. Derive the reachable counter invariant and chronological attempted-body
   list from the full for(;;) execution, with no normal fallthrough. Extract
   every preceding rejection, final successful break and length<=3000000.
   AttemptAccepted/Rejected, LoopSucceeded and successful_loop_last_attempt
   remain target interfaces, NOT declarations available from047.
4. On the SAME actual attempt, consume resultant f/g, raw/orthogonal FPEMU
   gates,046 public material,032 solver and complete mandatory certificate.
   Derive all local entry facts, shared call ID, snapshots and material
   retention. Never add public/NTRU/certificate correctness as a premise.
5. Bind that final material to the actual later encoding-input memory and
   full caller teardown. Keep attempt acceptance distinct from later output
   capacity failure and call-level return1. Codec round-trips remain B1.08/09.

This is a recoverable ENTRY/FIRST-SAMPLING result, not an accepted full B1.07
stage, whole KeyGen, emitted-to-fiber, termination, IID/probability/PRG,
compiler/machine/CT/security or independent-review claim. No code/numerical
counterexample or insufficient arithmetic budget was found; the remaining
gaps are explicit source/model/composition proofs.
