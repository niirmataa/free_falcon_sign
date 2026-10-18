# First public NTT pass160

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
The whole success-mass task remains ACTIVE / NOT_COMPLETE.

The owner-approved historical seal repair is recorded separately in
KEYGEN_POSTSEAL_159_RECONCILIATION_001.json (commit a121ee46); the old
manifest and both historical documents are preserved. Source commit
d70e6c9d records the unchanged invariant transports accepted in job108.

## Exact result

`PublicTailFrame160.body_trace` extracts the two actual Store16 transitions
from the existing first-butterfly execution, without canonical residue,
twiddle, polynomial, or success-value assumptions. `written_after_store`
and `body_invariant` prove that all1536 initialized input cells, allocation,
writability, pointer bindings and needed scalar slots survive the body.
`body_source` combines this with the already accepted constructive body.

`PublicTailLoop160.loop_source` constructs the original loop by induction
on count, with u+count=768 and FirstInv at entry. It performs exactly the
remaining iterations, including the real guard and increment, and reaches
the false guard at u=768. `seed_firstPass_source` additionally executes the
original r=gm_square[1] load and u=0 assignment from TailEntry.

This is a general source theorem with explicit initialized-memory and
caller-layout premises. Those premises have NOT yet been instantiated for
the complete selected forward NTT invocation. It proves no full public
call, no successful KeyGen packet, and no unconditional positive mass.

## Verification

Three modules /38 declarations audited: PublicTailFirst159 (including the
accepted108 changes), PublicTailFrame160 and PublicTailLoop160. Full
expression-DAG roundtrip and fresh safe kernel definitions at original
types; permitted axioms only propext, Classical.choice, Quot.sound.
Accepted compilation jobs108/109/111 and all three sequential audit steps
in112 have empty stdout/stderr, 0 errors and0 warnings. Failed110 is
retained with its elaboration cause in KEYGEN_PUBLIC_TAIL_160_FAILURES.json.
Source commit b50e8b56 adds the two new modules. No push or independent
review; no changed production C, reference semantics or resource limits.
New modules use maxRecDepth32768 and maxHeartbeats2000000; existing159
source and its historical settings were preserved. No new numeric
certificate was required: this result uses structural execution and
kernel-proved finite counter arithmetic, with no probabilistic claim.

Audit collection SHA256:
3fda41a872ae44793c09764860f37c62268bfe7df27923692763b66b3b7903fd.
Resume ENTRY SHA256:
1a547dbddcfa8b65da7061ca4cee4c6b3c98fb2504a601c66a0a1abd061531d7.
Postseal is produced by tools/keygen_tail160_seal.py; exact artifact pins
are in KEYGEN_PUBLIC_TAIL_160.json and .build/tail160/POSTSEAL_160.json.

## Remaining obligations

Middle rounds, tripling and actual call composition; second forward call,
public nonzero tests/division/inverse/return; root solver, certificate,
encoding; then G(seed*) and its atom lower bound under corrected law134.
The acceptance/coding numerical bounds remain open. The paper remains
measured and the five do_sign obligations remain unchanged.

The first768-iteration public NTT loop is now constructively executable
from its stated source-domain invariant. The nearest missing part is the
middle-round execution and its actual caller composition. This scoped
result neither supplies G(seed*) nor promotes the measured success rate
to a theorem.
