# 107 — complete private source dispatcher

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**; whole owner task
**ACTIVE / NOT COMPLETE**. Parent POSTSEAL106:
`265176eba4d8653988fd2cd963ab5dbd8e7b6528d8bd73a3467b6f4145cdb5a6`.

Both actual private leaf bodies are checked to avoid the synthetic comp
activation slot. Cross-activation expression and execution proofs compare
all real cells, pointer state, heap and buf while allowing that one unused
slot to differ. Actual CallArgs derives equality of out/capacity/q/x/logn;
therefore the actual terminal calls produce equal complete heaps and
returned lengths. No assumption of ignored metadata or callee behavior
remains in the terminal theorem.

The full dispatcher keeps complete State equality on normal fallthrough,
and complete heap/return equality after return. Terminal callee activations
cannot feed later statements. All source declarations preserve the actual
reserved-name invariant, including nested fixed calls. Concrete source
checks are discharged for both leaves and the dispatcher. The final
KeygenCodecExecution.Call theorem has only its two actual executions as
premises for fixed arguments/initial heap; encode/spec is an exact partial
denotation preserving every error return and partial byte write.

Final keygen_dispatch107_007:7/7, six mathematical modules and full audit
of35declarations, logs0/0, standard axioms only. Seven jobs include four
failed/mixed elaborations: redundant simplification, a missing normalized
local-set agreement step, string/character-list normalization and a final
reflexive conditional equality. All source/log versions and causes retained;
global resource limits unchanged. Author self-review only.

The whole encoding caller is NOT closed. In particular, raw pointer
word decoding on failed paths still needs a source-faithful construction
or derived full memory domain;106's scoped interface counterexample remains.
It is not an actual-C or whole-KeyGen counterexample. Next: caller argument
and tail construction, fixed seeded whole producer, actual law/SAME-model
binding and explicit zero-success/nonreturn cases. Five do_sign items
unchanged; no push, migration, reviewer, stages import or actual-C e2 claim.
