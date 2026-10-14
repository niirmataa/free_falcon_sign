# Pre-do_sign self-review and quantifier check

Primary verdict: **incomplete, with the smallest missing implication** for
the owner's real-code single-slot target. B1.10's deterministic theorem and
086's conditional model theorem are proved as written in their stated
domains. This is author self-review, not independent acceptance.

| Obligation | Result |
| --- | --- |
| Same B1.10 material, packets, certificate, equations and fiber | Passed by kernel composition from unchanged 082/083 |
| Source/return/legal-memory conditions remain visible | Passed; no theorem of success existence is claimed |
| New pointwise consumer uses all three named fields | Passed; road -> AttemptWeights -> AttemptPointwise, reply -> joint certificate -> reduction |
| Uniform challenge premise removed | Passed in F04's ROM construction; not a literal SHAKE uniformity theorem |
| Arbitrary `keyIdent` closes source-to-law | Failed as an inference; the actual equality producer is missing |
| Public simulation computational hop is honest Sign hop | Failed as an inference; different computations and winning tests |
| Real source weights satisfy PointwiseStageGoal | Not addressed by a proof; intentionally the prepared open goal |
| Actual-code e2 is already below 2^-32 | Not established; only the conditional analytic bound is proved |

Additional quantifier caution for the next executor: `Sampler.code` and
`HacGlue.AttemptFamily` take h/history/message/nonce/challenge, with **no
secret key argument**. `PointwiseStageGoal` consequently quantifies over
every such public signing point. Real `do_sign` consumes the expanded
secret basis/tree. A proof must distinguish the public simulator from the
secret-key signer, and justify the required comparison uniformly over the
admitted keys or through the specified key mixture. It must not equate
them merely because both have an h argument, nor prove the obligation only
for one emitted key while the consumer quantifies over every h.

The desired source-defined conditional key law also needs a well-defined
normalization/conditioning event. The B1 review explicitly excludes
existence/probability of successful real KeyGen. Adding positive success
mass as an ordinary assumption would violate the current single-slot
request; proving it or specifying a different fallible experiment is work
outside the do_sign body. No impossibility theorem is asserted here.

Routes inspected: direct substitution into Assembly's keyIdent gate does
not perform a law rewrite; corrected AssemblyComp rewrites laws but only
for public simulation; defining the actual conditional experiment requires
the missing source probabilistic construction. That third route is OPEN,
deferred at this explicit wall, not exhausted or refuted. Its next target
is the exact source-output pushforward equality and admitted conditioning
domain, before any claim that do_sign is the sole remaining obligation.

Final proof streams: 4/4 selected modules have empty stdout and stderr.
Four failed/mixed Lean jobs are preserved. An additional static-check
attempt mistakenly matched the word `axiom` inside the audit's diagnostic
string `Unexpected axiom`; `STATIC_CHECK_ATTEMPT_001.json` preserves this
checker false positive. The declaration-aware, string/comment-stripped
check in `STATIC_CHECK_002.json` passes for all four new Lean files. No
source proof was changed to pass that check. This is not an integrity
mismatch. Kernel transitive-axiom audits are the load-bearing purity check.

Proofreading scope: the task's new Lean interfaces, report, receipt notes
and live status additions. Routine checks: references, source line ranges,
counts and status wording. No mathematical-token correction was made by
proofreading. Remaining substantive gaps are those above and in the main
report; historical mathematics was not re-audited by this self-review.
