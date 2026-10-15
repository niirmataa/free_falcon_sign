#143 — reusable source group setup and group-loop composition

Previous goal turn made verified progress: sealed142 closes the actual first
middle-FFT outer iteration, with64 audited declarations and postseal. Begin
from HEADad61b582 and verify all42368 inherited pins into ENTRY143.

Derive a parametric group setup from typed control cells, actual array/table
bindings and pinned readonly memory: original declarations, table indices,
two table loads, v2=v1+ht and v=v1. Connect this to FftLoopInduction141.source,
restore the original group scope and preserve buffer/context. Avoid separate
concrete butterfly executions or expanding the entire parsed table.

Carry the exact symbolic word recurrence and prove source preconditions at
call sites. Next actual pass is t384,m4,ht192,hm2; longer group/pass induction
is the route toward the remaining seven middle passes. Full KeyGen witness
and three success-mass obligations remain ACTIVE. Corrected law134 is the
explicit target; frozen110zero unchanged. No IID/F04/D1, empirical premise,
new axiom, hidden do_sign obligation, push, parallel jobs, workers or schedule.
Fixed runner limits,0/0, all failures retained, small commits and postseal.
