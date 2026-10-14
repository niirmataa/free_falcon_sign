# KeyGen law binding — exact boundary and stop-and-report

2026-10-14. **Owner objective NOT ACHIEVED: BLOCKED_SOURCE_LAW_BINDING /
NOT_REVIEWED.** Primary self-audit verdict for the requested actual byte-game
identification: **incomplete, with the smallest missing implication**.
The general D1 inference from first-success control flow is refuted below;
the corresponding identity for the particular pinned FT1536 generator is
still OPEN, not refuted. No security attack or production-code defect is
claimed. This window does not produce `AssemblyComp.KeyLawBinding`.

Base: `b9496334ad2c7993cf337f44140d3caf0bd63c1a`. Incoming POSTSEAL086
SHA256 `509ffbec8204a6db762d91fd4da4a1d0f31357473c15318e04267489a3c503b8`:
all 22,434 file pins matched before work. The 084–086 reports and source
proofs remain unchanged. This is one precise T12.1/B1 law-binding window,
not a migration, new source-to-fiber review, or new signing stage.

## 1. The existing modeling decision is not a proof

`END_TO_END_SCOPE.md` already records A2, uniform independent seed at the
entropy boundary. This window adds no entropy or cryptographic assumption.
An objection that the project has not specified *any* seed idealization
would therefore be incorrect. The external I/O relation in
`KeygenEntropySource` does not itself prove A2; that distinction is already
part of the model.

The decisive extra claim is D1 refinement (i), lines 65–72, repeated in
`run2/notes/S1_P_ACCEPT_FACTS.md`: a capped first-success loop supposedly
has the law of one attempt conditioned on acceptance, with cap affecting
only availability. That conclusion needs a distributional argument about
the attempts. A uniform initial seed, identical attempt marginals, and the
syntax of the retry loop are insufficient, even taken together.

There are two different targets:

- **D1 main target:** the distribution of actual returned key bytes,
  conditioned on a successful whole KeyGen invocation. Direct analysis of
  the seeded, stopped experiment can define this without IID attempts.
- **D1 refinement:** replace that stopped law by one attempt conditioned
  on the six acceptance gates, and replace availability by a geometric
  formula. These are additional equalities to prove, not definitions that
  can be imposed on the same real-generator experiment.

The earlier deterministic theorem remains useful and intact. It supplies
the same decoded material and fiber *after a defined return-1 execution*;
it neither constructs the distribution of those executions nor proves a
positive normalizer.

## 2. Kernel counterexample to the generic refinement

`Source3.KeygenLawBoundary087` uses the project's existing `FT1536.Law`.
A uniform seed in `Fin 4` selects a row of this deterministic experiment;
there is no additional random draw, serialization rejection or assumption.

| Seed | Attempt 0 | Attempt 1 | First success within two attempts |
| --- | --- | --- | --- |
| 0 | false | failure | false |
| 1 | true | true | true |
| 2 | failure | false | false |
| 3 | failure | failure | failure |

Both attempt marginals assign mass 1/4 to each key and 1/2 to failure.
Nevertheless:

```text
P(false | attempt 0 succeeds)       = 1/2
P(false | capped invocation succeeds) = 2/3
P(capped invocation succeeds)       = 3/4 = 1 - (1 - 1/2)^2
```

Thus even checking the geometric availability formula would not certify
the conditional key-law equality. Named exports:
`same_attempt_marginals`, `conditional_laws_differ`, and
`availability_does_not_certify_key_law`. This is a complete finite
counterexample to the generic inference. Its gates and generator are not
claimed to be FT1536's gates and SHAKE.

## 3. Exact finite-law algebra retained as a useful result

For an arbitrary finite call-result law `p : Law (Option K)`, the module
defines `successMass p := sum k, p.mass (some k)` and
`conditionSuccess p : Option (Law K)`. The constructor returns a law only
when the success mass is positive; otherwise it returns `none`.
No arbitrary fallback key is substituted for a zero normalizer.

The following are kernel-checked algebra, not a claimed source-law producer:

- `failure_success`: `p.mass none + successMass p = 1`.
- `condition_none_iff`: the conditional law is absent exactly when the
  success mass is zero.
- `condition_positive` and `condition_mass`: an actually constructed
  conditional law has positive normalizer and the exact normalized masses.
- `condition_equal_iff`: given two constructed conditional laws, they are
  equal exactly when their normalized successful-output masses agree
  pointwise. The hypotheses here are explicit algebraic inputs, not new
  premises attached to the requested implementation theorem.

This last result states a precise obligation for any proposed shortcut
from a stopped call to one attempt. It allows a source-specific argument
weaker than IID, but does not manufacture that argument.

## 4. Why exact fair-stream replacement cannot be used silently

`Source3.KeygenSeedSupport087` proves, for every deterministic output map
from a 32-byte seed, including a map with failures, that some full ternary
pair cannot be reached:

```text
Seed32    := Fin 32 -> Fin 256
Candidate := Fin 3072 -> Fin 3
Fintype.card Seed32 < Fintype.card Candidate
forall run : Seed32 -> Option Candidate,
  exists c, forall s, run s != some c
```

`conditioned_not_full_uniform` consequently proves that any constructed
conditional candidate law from such a map is unequal to the uniform law
on all candidates, for *every* seed distribution. The proof uses a
symbolic monotonicity lemma, not a raised exponentiation limit.

This is a pre-gate support result: 3072 coordinates represent two ternary
vectors of length 1536. It says nothing about the cardinality or law of
the accepted-key subset; conditioning may make that subset much smaller.
It is not a proof of an attack, an accepted-key distribution mismatch, or
source termination. Source interpretation is restricted to a fresh context
with one 32-byte entropy input and all other inputs fixed. Arbitrarily
pre-seeded or externally mixed contexts need their own sample space.

## 5. Actual pinned source and byte-game obligations

`KEYGEN_LAW_087_SOURCE_MAP.json` verifies the 17-file candidate manifest
`56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`
and records eight exact lexical function regions from **live `Extra/c`**.
These are source observations, not new kernel source-adequacy theorems:

1. `falcon_keygen_new` initializes the SHAKE context; `rng_ready` obtains
   32 bytes only when unseeded, then flips the context for extraction.
2. `get_rng_u64` calls `shake_extract`. MODE1 rejection sampling consumes
   two-bit chunks, discards 3, and emits a ternary coordinate for 0, 1, 2.
   KeyGen uses SHAKE here; it is not the signer's ChaCha20 stream.
3. The outer attempt loop retains and advances that same context. It does
   not independently reseed every attempt. Its cap is 3,000,000; the inner
   two-bit rejection loop is not bounded by that attempt cap.
4. After all six gates accept, private and public encoding run outside
   the attempt loop. Buffer/encoding failures return 0. Consequently the
   event `return 1` is not definitionally the event that the six gates
   accepted. Eliminating that distinction requires adequate caller-domain
   and encoding-success proofs, not just conditional bounds on the length
   of an already successful output.
5. The CLI at `Extra/c/tool.c:718` makes one KeyGen invocation and reports
   failure; it does not implement the mathematical repeat-until-success
   completion. No wrapper or production C has been changed here.

The exact missing construction is a seed-indexed execution/outcome model
for the fixed legal caller and pinned source, accounting for source
nontermination and all return-0 paths. For each seed it must identify the
actual observed packet outcome, with proved uniqueness/adequacy; an
existential successful execution or arbitrary `Classical.choose` over such
executions does not supply this. Proving only success support is insufficient.

After that construction, the next source-specific obligations are:

- derive the successful byte-packet weights from the uniform seed law;
- prove positive successful mass, rather than add it as a premise;
- transport the same packets through the proved decoders into the joint
  secret/public model law and `SigmaMath.muH`;
- prove the required stopped-law/per-attempt equality if D1 refinement is
  retained, including capacity and retry-completion effects.

The proposed names `seededOutcome`, `muCall`, and `muEmitted` are not exported
as actual implementation laws by this window. The existing abstract
`muKey` can be instantiated with a correctly constructed real law, but
renaming an arbitrary law or taking both sides of the desired equality to
be the same undefined source law would not discharge these obligations.

## 6. The do_sign slot remains exactly five items

1. Transport of the same key material and certificate.
2. Actual `AttemptShape` and `ReplyShapeAt`.
3. The four `PointwiseStageRoad` conditions: tower, machine, wrapper, box.
4. Rounding, physical int16 interpretation, and syndrome.
5. The scalar sampler loop and the honest-signing PRG hybrid.

KeyGen's SHAKE law, its conditional normalizer, D1 renewal/conditioning,
and non-signing byte-game interfaces stay outside this slot. No new KeyGen
PRG hypothesis is placed inside the signing hybrid. The optional actual-C
bound `e2 = k^32 - 1` remains OPEN: the already settled outer control-flow
choice does not prove the unresolved source weight, fault and cast facts.

## 7. Stop-and-report and recovery

The unqualified D1 shortcut cannot be used as a proof step. The concrete
KeyGen binding remains incomplete; no scoped PASS is assigned to it.
The direct actual seeded/stopped-law route remains mathematically viable
and open. A source-specific normalized-mass argument could alternatively
justify the refinement, but none is available from the current contract.
An ideal-generator comparison would require a separately justified KeyGen
SHAKE hop; neither the signer's ChaCha20 hop nor A2 supplies it.

The owner must resolve the D1 scope before an implementation theorem is
claimed under that refinement: retain it as a source-specific proof
obligation, or authorize the direct stopped-law formulation. Historical
scope documents are preserved, with this finding linked from live state.
This is a recoverable stop, not a claim that the desired real-law theorem
is impossible or that the open direct route has been exhausted.

Verification, preserved failed jobs, full-term audit format, receipt and
postseal procedure are in `KEYGEN_SOURCE_TO_FIBER_001_BATCH_087_NOTES.md`.
The mathematical audit is author self-review, not independent acceptance.
Conservative proofreading covers only these new files and live additions;
no historical theorem or modeling decision was rewritten.
