#144 — source outer setup, pass composition and actual remaining middle FFT

Previous goal turn made verified progress: sealed143 proves the original
whole group loop by induction. Base HEAD112b09e2,42651 inherited pins to
ENTRY144. Same source3 worker; no active Lean at entry.

Derive the original outer declarations/right shifts and group initializers
from typed control cells; compose143's group-loop theorem, t=ht, scope
restoration and m<<=1. Prefer one parametric outer step plus induction (or
source-justified finite schedule fold) over the remaining seven passes.
Actual input is SelectedFftOuterControl142.after with t384,m4,hn768/n1536,
exact symbolic buffer and source table pins. No later pass is pre-assumed.

Keep the exact word recurrence and full frame; never identify it with a
native snapshot without proof. No repeated per-group/butterfly executions,
new semantics/axioms, IID/F04/D1, probability premise or hidden do_sign item.
Whole three-point goal remains ACTIVE under corrected134; frozen110zero,
measured paper and five do_sign items unchanged. One job, fixed limits,0/0,
all failures, small local main commits/no push, postseal, no workers/schedules.
