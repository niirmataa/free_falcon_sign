# 112 — kernel success mass and acceptance-bound window

Owner request2026-10-14, base99bf4a13. Reuse S1_P_ACCEPT_FACTS.md,
whole law110 and H3/M0 K_seed[E]; do not rerun the acceptance campaign.
Small local commits without push, one Lean process, accepted logs0/0,
all failures retained, postseal, unchanged five do_sign items.

Targets:
1. Prove actual seed success implies whole-call mass at least2^-256,
   by consuming110's exact count formula. Also expose the exact witness/
   positive-mass equivalence and finite certified-seed-set extension.
2. Prove a NEW positive numerical lower bound for the intended acceptance
   law; empirical counts are controls, never premises. S1 uses p_accept
   for one attempt, whereas110 uses p_K for whole-call emitted bytes.
   Clarification was requested; independent work on target1 continues.

S1 includes a historical D1 equality/geometric availability formula that is
not valid for arbitrary correlated attempts. Do not reintroduce it from a
prose input. Preserve the original file and measured paper statement; an
additive claim/evidence map must distinguish exact empirical arithmetic,
a kernel source witness and a population probability theorem.

H3/M0 retains one K_seed[E], actual SHAKE, cap/coding, no IID identification,
zero-mass undefined conditioning, and possible nonreturn/STUCK. The existing
111 A2 replacement boundary remains explicit. No new OS-law premise.

First checks: pin S1/probe summaries/receipt and relevant H3/M0 originals;
read their actual theorem types; inspect whether any kernel seed-success
witness already exists. Known probe artifacts retain digests/counters, not
source derivations. A native successful run is not automatically a Lean
Execution witness. Any gap must be named, not closed by a supplied field.

Controls use standard Sage, exact ZZ/QQ and the existing STATIC methodology:
independent arithmetic controls support a universal Lean theorem. No new
large KeyGen campaign, production C change, frozen edit, reviewer or worker.

## Owner clarification and exact-type check

The owner selected S1 per-attempt p_accept, with a useful proposed target
p_accept>=1/4, and a separate first-attempt/coding monotonicity corollary
for p_K. JointDecomp.samplerLaw_marginal_uniform was inspected: its source
is Law(Rq x Option BoxVec), and it proves the signing ROM challenge marginal
for fixed h/st/m/r. It contains no KeyGen f,g marginal or acceptance theorem.
Therefore this reference cannot discharge the per-attempt source-law bridge.
A correct first-encoded-attempt subset theorem will be built directly from
the existing source loop, without a geometric formula. A positive numerical
p_accept bound still needs a real proof of its intended law/event mass.
