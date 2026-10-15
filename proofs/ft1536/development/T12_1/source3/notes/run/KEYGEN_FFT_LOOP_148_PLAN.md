#148 — original256-step tripling loop and first FFT

Previous turn made verified progress: sealed147 proves the entire generic
tripling body with exact six-write vector and full frame. Base HEAD32e8b415;
verify44573 inherited pins to ENTRY148. No active Lean at entry.

Carry a loop invariant with buffer/table/constant facts and u=3*k,
v=2*(512+k). Derive the body context for k<256, execute original increments,
and prove prefix/full loop including final false guard. Derive actual full
branch, v declaration and u0/v1024 initialization, instantiate the loop and
restore the branch scope. Compose the existing FFT continuation and actual
call binding/receive where available. No256-body numerical replay.

Full three-point success-mass goal ACTIVE under corrected134; frozen110zero,
measured wording and exactly five do_sign unchanged. No IID/F04/D1, native
image premise, new axioms or increased limits. One job/Lean,0/0, all failures,
small local main commits/no push, postseal, no workers/schedules. Audit may
partition declarations to preserve fixed per-process budgets and exact coverage.
