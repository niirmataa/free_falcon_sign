# 107 — private dispatcher and unused activation metadata (next)

Continuation of the same whole-KeyGen task, following scoped codec106.
No new assumptions, production/frozen edits, or independent acceptance.

The private terminal CallArgs binds out/capacity/q/x/logn, not comp: the
none/static C headers do not take comp. The shared Args/initialLocals model
nevertheless installs a synthetic comp scalar in the leaf activation.
Different terminal call witnesses may therefore differ in unused comp;
full activation equality is too strong, while heap and return must agree.
The106 fixed-argument leaf theorem does not discharge this seam.

Concrete proof route:
1. Define Locals agreement on x and all scalar names except comp; extend
   to equal heap/buf with that locals agreement. Expr only reads Args.out
   directly; other parameters are activation locals. Prove expression
   agreement under equal Args.out, equal heap/buf, clean reserved names,
   and a source checker excluding comp reads/updates.
2. Preserve that agreement through declarations, local sets, scope exit,
   stores and control. Check both actual none/static bodies for absence of
   comp reads/writes and terminal calls. Prove their cross-activation
   result agreement and equal flow. This is derived unused-metadata
   independence, not a callee correctness premise.
3. Actual CallArgs fixes all physical arguments except comp. Derive
   agreement of initial leaf states, then unique returned heap/length
   across the two actual leaf executions.
4. For the complete dispatcher use outcome equality: equal flow and heap;
   full State equality is required only on normal fallthrough. A terminal
   call always returns, so its private unused comp slot cannot feed a later
   statement. Derive reserved-name invariants for all actual bodies and
   discharge their concrete source checkers. Export actual private Call
   uniqueness and an exact partial denotation retaining return0 writes.
5. Replay/audit/postseal with all failures, small local commits, no push.

The separate caller pointer-word issue remains in CODEC_106_PLAN and the
kernel-local KeygenPointerReadBoundary106.incomplete_live_set example.
That example is not two full KeyGen executions and not lawful C pointer
semantics. Full tail binding must construct/derive the real fixed caller
memory/decoding domain on failure paths too; do not assume old unrestricted
ReadPointer uniqueness, silently strengthen frozen source, or move this
obligation into do_sign. The whole-law task remains active throughout.

Checkpoint107 outcome: the above private-dispatch route is closed by
kernel proofs, including source-checked no-comp leaves, terminal byte/
length uniqueness, full normal-continuation equality and exact partial
private encode/spec. Caller pointer-memory binding remains the separate
next obligation; the whole owner task is still ACTIVE / NOT COMPLETE.
