# 112 — success mass, first-attempt monotonicity and the exact remaining bound

2026-10-14. **PARTIAL_PROOF / NOT_REVIEWED.** Owner targets: (1) a source
seed-success witness implies mass at least2^-256; (2) a NEW unconditional
positive lower bound on S1 per-attempt p_accept, with a useful proposed
value1/4; then a separate first-attempt/coding corollary for p_K.
Target1 and the source monotonicity/factorization are kernel-proved.
Target2 is **OPEN**. No numeric population bound or concrete successful
source-seed witness is claimed. The previous whole-law result remains sealed.

## Reused authoritative inputs

[INPUTS](KEYGEN_SUCCESS_112_INPUTS.json) pins20 records. These include
S1_P_ACCEPT_FACTS.md, the original primary/control CSVs and probe receipt,
public synthetic-input derivation, digest observations, M0 GAME, the H3
emitted binding and actual StableOutcome kernel exports, law110, F04's
actual definitions/theorem, the STATIC length method and the paper text.
Original M0/H3 OUTPUTS hashes and the recorded probe driver hash were
checked. Frozen inputs and the paper were not edited.

S1 records8192/23628 and control256/739. Exact counters and reject accounting
are retained; no KeyGen experiment was rerun. The paper still explicitly
says **Measured**, finite synthetic-seed observations, not a rigorous lower
bound or uniform-seed theorem (`paper/sec_02_parameters.tex:131–141`).
The new bounds below are new declarations, not a relabelling of that paper.

## New kernel results

`Source3.KeygenSuccessMass112` consumes110's existing exact count law:

- `success_lower_of_witness`: `evaluate env input seed = some (inr packet)`
  implies `1/2^256 <= successMass env input`.
- `source_lower` takes the corresponding actual `Execution` and successful
  outcome. It does not take an empirical counter or external return-code claim.
- `positive_iff_witness`: positive whole-call mass iff some seed emits a packet.
- `certified_set_lower`: a finite set of distinct seeds with actual proved
  source success gives its cardinality divided by2^256 as a lower bound.

The first implication is closed as requested. Its premise has NOT been
instantiated by a closed concrete source execution. Therefore this checkpoint
does not yet assert `Z>0` for a particular caller merely from the probe report.
The existing109/110 construction retains the zero-success case exactly.

`Source3.KeygenFirstAttempt112` defines acceptance from the actual seeding,
readiness prefix and **first** source Attempt, with no retries in between.
Its encoding evidence runs the actual tail from that SAME accepted state.
`first_emitted_success` constructs the actual singleton accepted Loop and
whole Trace, then uses109's established source observation. It proves:

`{first attempt accepts AND its encoding returns1} subset {whole call emits}`.

`Source3.KeygenFirstMass112` consequently proves, with one actual seed law:

`p_K >= p_1 * c_1`,

where `p_1` is actual first-attempt acceptance mass and, when `p_1>0`,
`c_1 = P(first encoding succeeds | first acceptance)`.
The zero-denominator branch is treated explicitly; the total real quotient
at zero is not described as a normalized conditional law.
`quantitative` transports separately PROVED lower bounds on `p_1` and `c_1`.
It is a consumer of those bounds, not their proof. No IID, identical retry
marginals, renewal or geometric cap formula is used.

This establishes the valid part of the owner's proposal. Extra attempts
can increase whole-call success; the required fact is that they do not erase
an already completed first-attempt success in this source control flow.

`Source3.KeygenCountTarget112.quarter_iff_count` pins the exact outstanding
counting target for any event of the actual32-byte input law:

`1/4 <= P(event) iff 2^254 <= #{seed : event(seed)}`.

This is an exact equivalence, NOT a proof of the right-hand side. An analytic
counting proof could establish it; exhaustive enumeration is not prescribed.
The separate `measured_primary`, `measured_control` and `measured_accounting`
are exact arithmetic facts about the recorded ratios only.
`probe_subset_below_quarter` proves8192/2^256<1/4: even kernel certification
of all8192 observed seeds alone would not prove a quarter population bound.

## Why the proposed F04 input does not close p_accept

The exact inspected and audited theorem is:

```lean
JointDecomp.samplerLaw_marginal_uniform
  (S : Run2.Sampler) (h : Relation.Rq)
  (st : Run2.State) (m : Run2.Bytes) (r : Run2.Nonce) :
  marginal (Run2.samplerLaw S h st m r) = (Law.uniform : Law Relation.Rq)
```

Its source is `Law (Rq x Option BoxVec)`, the **signing** joint law. The
first coordinate is the ROM challenge, drawn outside the sampler tape;
`h` is a fixed input. `replyLaw ... c` may depend on that challenge, so the
construction is a dependent joint law, not an independence claim about
reply and challenge. No KeyGen `f,g`, source first-attempt distribution or
acceptance gate occurs in this theorem. Its proof is `marginal_joint`.

Thus F04 cannot provide the proposed KeyGen marginal premise. If S1's
proposal means ideal full uniform ternary `f,g`, it also cannot silently be
identified with the actual32-byte seeded candidate: the existing087
`KeygenSeedSupport087.conditioned_not_full_uniform` records the finite-support
obstruction. A lower bound for an ideal proposal and a lower bound for the
actual first source attempt are distinct theorems until related by proof.

S1's estimate aggregates attempts in stopped runs. It does not prove the
actual first-attempt event mass, nor does merely having a marginal theorem
prove that its six acceptance gates retain at least one quarter of that law.
Its historical D1 equality and `1-(1-p_accept)^cap` paragraph are not imported
as facts. The latter requires an appropriate renewal/product argument;
our first-attempt subset route does not.

H3/M0 preserves one K_seed[E], full-call success including coding, and a
zero-mass branch. H3's emitted stable transport starts from an already
successful source execution; `mandatory_before_break` projects its mandatory
gate. It does not prove that any seed succeeds or give an acceptance frequency.
A targeted search of606 own H3 formal files found no named p_accept,
successMass or109 seed-witness exports; this is a search record, not a global
nonexistence theorem. The actual relevant StableOutcome types were read.

## Exact unresolved implications and honest stopping point

1. Specify and prove the intended S1 per-attempt law/event binding to the
   actual first-attempt object. F04 is not that binding. No `p_accept=p_1`
   assumption has been inserted as a purported completed result.
2. Prove a numerical retained-mass bound for all acceptance gates under that
   law (for the actual A2 event, a quarter requires the above count bound).
   S1 empirical observations are auxiliary evidence, not this premise.
3. For unconditional `Z>0` from the cheap route, certify one concrete successful
   source seed in the109 relation. Old digest/native-success observations
   are candidate selectors, not kernel derivations. The inspected seeding,
   solver and whole denotations are noncomputable exact partial specifications;
   `decide` cannot turn their existential domains into a concrete execution.
4. For a quantitative p_K bound, prove the coding bound at the SAME first
   accepted state and the actual caller.110 permits failure mass and does
   not impose a sufficiently large writable private buffer on every caller.
   STATIC length theorems support this step but do not silently prove all
   caller/progress premises. General M0 E may fail services; positivity cannot
   be asserted uniformly over failing service plans.

The first failed implication in the proposed completion is the use of F04
as a KeyGen marginal theorem. This checkpoint stops and reports that mismatch
rather than inventing a numerical assumption or quietly changing the law.
The strongest safe result is the source witness bound and source first-attempt
monotonicity above. The cheapest next discriminator is a kernel certificate
for one known public synthetic probe seed; that would close positivity only,
not a useful quarter bound. A quarter bound needs new acceptance-mass work.
No claimed counterexample to actual FT1536 security or actual p_accept>=1/4.

## Checks and preservation

Final job `keygen_success112_008`: **5/5**, logs0/0. Four new mathematical
modules with31 named declarations; full audit34 includes the three exact
F04 exports discussed above. Full term/type DAG roundtrips, standard axioms
only. Eight jobs: two failed, recorded in
[FAILURES](KEYGEN_SUCCESS_112_FAILURES.json): noncomputable real constant
annotation; Sage JSON serialization of exact Integer metadata. Neither
changed the mathematical target or disabled a warning.

Sage controls: exact ZZ/QQ, original S1 ratios/reject sums/digest control,
seed-space/quarter arithmetic, all6561 accepted/encoded subset cases on an
8-point domain, and two correlated examples rejecting a geometric formula
from marginals alone. **Zero new KeyGen runs.** The output explicitly says
no population bound or source witness was proved. Supplemental computation
manifest validation retains its version1 provenance limits; canonical job
receipts additionally pin actual argv, source hashes, isolation and limits.

Self-review and mathematical proofreading only; NOT_REVIEWED. The finite
controls play the same supporting role as STATIC controls, while the new
universal implications are kernel proofs. No paper promotion, production C
change, push, migration, new worker/reviewer or expansion of the five do_sign
items. The whole two-target owner request is NOT COMPLETE.

The prior final checkpoint pinned live WORK_STATE/checkpoint views at its
committed head. This authorized successor updates those two views, so the
entry check verifies their historical bytes from that Git commit and all
other27,070 prior paths in place. It does not repin historical evidence.
The immutable proof-chain parent remains POSTSEAL111; ENTRY.json records
the explicit live-view transition. No unexpected proof-pin mismatch occurred.
