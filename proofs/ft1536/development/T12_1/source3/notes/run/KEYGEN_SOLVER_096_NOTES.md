# 096 — proper-arity modular dependencies for the solver

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**; whole owner task
**ACTIVE / NOT COMPLETE**. Parent POSTSEAL095:
`b9cc36819c43d89dfe1c4fd771e1f6697ba7f677fd9e0653ea62daa4ab7a53b6`.

This is a solver prerequisite checkpoint, not full solver determinism.
The old `r2Body` and `divBody` relations existentially permit a base state;
an unqualified determinism assumption for arbitrary malformed calls would
be unjustified. This checkpoint closes the source cases with their actual
two/five argument lists and exposes the syntactic arity obligation.

`KeygenModularLeaf096` proves the fixed scalar leaf calls deterministic.
Actual parameter conversion normalizes any two R2 arguments to uint32;
the pinned R2 source result then proves uniqueness independently of the
arbitrary base. No new arithmetic R2 specification is postulated.

The scalar/modular agreement modules prove that finite pure executions
depend on the source variables they read. The first checker uses a fixed
tracked name set; the declaration module proves that actual declarations
overwrite old local contents. `C99ModularLocalAgreement096` follows the
source sequence and expands the tracked set at each declaration, then
projects back at scope/tail boundaries. It includes actual branches,
loops, returns and fixed scalar/modular call relations. Memory-reading or
writing forms outside that pure fragment are rejected by its checker.

The complete literal `divCode`, including the scoped z2 declaration in
every iteration, passes that kernel check starting with only its five
parameter names. Two proper calls bind those names equally despite
different base heaps/environments; the source comparison therefore proves
the SAME returned value. It requires no prime/modular-division identity,
guessed source postcondition or termination premise.

`KeygenProperModular096.Call` is the original ModCall restricted by the
actual R2/div arities. Both source inclusion directions are explicit and
the restricted call relation is proved deterministic. The modular-language
checker lifts existing source evaluations/executions to that relation;
the word-language checker derives uniqueness directly using the same
source calls and checked one-to-five argument forms. Concrete remaining
solver bodies must still pass these syntax checks. They are not accepted
on the strength of a generic checker or an assumed callee property.

Final coherent `keygen_solver096_016`: **10/10**, stdout/stderr **0/0**,
nine mathematical modules and full type/term-DAG/axiom audit of **61
declarations**, standard axioms only. Sixteen immutable job directories
retain ten failed/mixed jobs with exact causes in
`KEYGEN_SOLVER_096_FAILURES.json`: explicit conversion inference, reserved
and ambiguous names, rejected unused simp arguments, eliminated indices,
list-shape proofs, a missing constructive Decidable instance, and arity
pattern instantiation. No warnings were suppressed or limits increased.

Author self-review checked arbitrary base states, lexical declarations,
original return values, the proper-arity restriction and source lifting.
This is not independent review or a claim that source execution exists.
No numerical computation was needed.

Next: apply the checked modular/word semantics to actual NTT/level/bigint
source bodies and compose the complete NTRU solver, then certificate,
codecs, capped loop and actual law/model binding. Fixed caller and entropy
boundary, source nonreturn, normalization and positive success where
required remain open. The five do_sign items remain unchanged; no push,
production edit, migration, reviewer, stages import or actual-C e2 claim.
