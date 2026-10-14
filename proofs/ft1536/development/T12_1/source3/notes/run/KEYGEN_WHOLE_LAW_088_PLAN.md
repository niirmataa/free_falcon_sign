# Whole-call KeyGen law — owner route decision and construction

2026-10-14, base `9d78eb3fe73d928a1324c7b5d11e273ee97f28b2`.
Owner instruction: build the law of the whole actual KeyGen, including its
attempt cap and encoding failures, without the D1 per-attempt shortcut or
an independence premise. This resolves the scope decision in 087. The old
scope document and all 087 evidence are preserved; its per-attempt equality
is no longer a target of this construction.

Later owner continuation: keep the [whole-task TODO](KEYGEN_WHOLE_LAW_TODO.md)
active until this objective is completed. Stage checkpoints do not close
the task; the historical single-stage/window rule is superseded here.

## Target and acceptance

Construct the seeded source experiment with the SAME state passed through
all attempts and encoding. Keep readiness failure, attempt exhaustion and
encoding failure as whole-call outcomes; do not renormalize at a gate.
Distinguish absence of a finite defined execution from observed return 0;
do not infer termination merely from the outer attempt cap. Identify the
successful observed byte law and its decoded model pushforward, with the
normalizer and zero-success case explicit. A hypothetical execution law,
arbitrary callee, IID assumption, chosen successful trace or source-law
equality supplied as a premise does not satisfy acceptance.

The existing A2 seed boundary is retained, not newly assumed. The first
concrete seed interface is a fresh legal context with 32 seed bytes and
fixed caller inputs; mixed or resumed contexts require their own input law.
No system-call success probability is invented. Input-memory/profile scope
is the existing source contract's scope, not an assertion about arbitrary C.

## Ordered dependencies and checkpoints

1. Whole-call finite source observation: classify all return paths, retain
   the actual capped loop, derive same observed packets and decoding from
   the existing source contract, and prove uniqueness at a fixed final heap.
2. Source-seed connection: bind seed bytes and external events to the SAME
   source execution; construct the stopped experiment with failure and
   possible nonreturn. Prove any required observational determinism rather
   than selecting a successful source trace by fiat.
3. Probability: push forward the fixed seed law through that experiment,
   account for complete failure mass, and condition only at whole-call
   success. A zero normalizer yields no successful-key law, not a fabricated
   fallback or a new positivity assumption.
4. Model binding: transport the actual observed packets through their SAME
   decoders and identify the model's joint key law/public marginal. Record
   any remaining success-existence obligation separately.

These are dependencies of one authorized objective, not alternative weakened
goals. Internal checkpoints preserve work while the objective remains active.
The active route is direct source/stopped-law construction. Generic IID
renewal is excluded by the owner. A real-generator/fair-stream hybrid for
KeyGen is not introduced. A source-specific termination or determinism
obstruction must be recorded with its exact missing implication.

## Fixed execution boundaries

Five do_sign items remain exactly: (1) key/certificate transport;
(2) AttemptShape/ReplyShapeAt; (3) four PointwiseStageRoad conditions;
(4) rounding/int16/syndrome; (5) scalar sampler loop and honest-signing PRG
hybrid. KeyGen work stays outside them. Actual-C e2 is not promoted.

One proof job at a time, unchanged limits, clean 0/0 accepted logs, full
proof/type/axiom audit, preserved failed jobs with causes, postseal after
checkpoints, small local main commits without push. No subagents, relays,
reviewers, frozen-file edits, production C changes or migration.
