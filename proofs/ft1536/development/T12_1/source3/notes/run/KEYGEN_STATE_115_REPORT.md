# 115 — finite typed state, scalar execution and argument binding

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**. Continuous three-point
program ACTIVE / NOT COMPLETE. This is the next concrete-execution building
block; no complete KeyGen source witness or probability bound is asserted.

Computable allocation has exactly the original automatic-object memory;
freshness is decidable and equivalent to the original Fresh relation.
Restoring a saved block gives the original get_rng_u64 disposal semantics.
Finite name tables have exact lookup/update/erase/scope-restoration proofs.

Typed local cells retain signedness, width and initialization. Their decoded
B20/C99 environments are well typed by construction; assignment conversion
uses the existing C99ValueBridge cast proof. No uninitialized value is read
as zero. Computed pure expressions, declarations, assignments, compound
assignments and normal scalar sequences produce the ORIGINAL C99ScalarReference
execution. This is the normal scalar fragment; function return/control is
handled by enclosing statement interpreters, not silently discarded.

The compact state represents all five original fields: heap, locals, arrays,
globals and static tables. Source equalities cover typed value/pointer binding,
heap/local replacement, scope restoration, the original caller base and the
SHAKE empty-local entry. Checked pointer arithmetic proves nonnegativity and
PointerAdd with one-past behavior. Both expression-argument Bind and the
public API's evaluated-argument Bind are constructed from successful finite
computations, with arguments evaluated in the caller before binding.

Generic expression/argument metatheorems retain a named CallsSound input.
It is NOT a new KeyGen assumption or an arbitrary callee field closing the
goal: every concrete interpreter must instantiate it from pinned source
bodies/read rules.116 begins this with actual A/RC memory reads for the
pinned SHAKE process_block body. The no-call instance is proved directly.

Ten closed controls cover uninitialized reads, declared-width conversion,
shadowed type/value restoration, legal one-past and rejected out-of-range/
negative pointers, caller-before-parameter evaluation, external API argument
binding, and a computed scalar sequence with its actual source Exec proof.
They supplement the universal bridges rather than replace them.

Final keygen_state115_012: **9/9, logs0/0**, eight mathematical modules and
full audit of91 named declarations. Full term/type DAG roundtrips and only
standard propext/Classical.choice/Quot.sound. Twelve jobs, seven failed/mixed
retained with causes: name/unfolding choices, abstract empty-key reduction,
query generalization, cast bridge reuse, record layout/import, unspaced ≤i
notation, and implicit nil constructor arguments. No linter or limit weakened.
No numerical/Sage experiment was needed for these exact structural proofs.

Parent114 receipt43e0bfda0a2bbf42f4f373df5e03e77dae12bd2c82e1002c0f4fd3fb117f56b9,
postseal0e88cebf270167a227edc1bad5e562fd78e02187343dac64dccbdffce8fbeeb4
(28438pins). Next: actual-source SHAKE read/statement interpreter and concrete
initial caller, then initialization, sampling, gates and encoding for the
selected public seed9. Allocation extensions for nested local flags and
other source grammars remain separate needed components.

No new assumptions, native execution axiom, IID, F04 substitution, paper
promotion, production edit, push, migration or independent review. The five
do_sign items remain unchanged. Continue the owner program after postseal.
