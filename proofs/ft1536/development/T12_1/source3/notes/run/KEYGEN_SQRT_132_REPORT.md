#132 — source-bound sqrt and versioned scalar-call extension

2026-10-15. PROVED_KERNEL_SCOPED / NOT_REVIEWED. Whole owner program ACTIVE.
This is the first repair component for131's missing callee. Frozen110 remains
unchanged and still has its proved zero success mass; no revised whole law,
full seed witness, positive Z, p_accept or p_K bound is claimed here.

FprSqrtSyntax132 binds the active M0 body Extra/c/fpr-emulated.c1182–1257,
including the C99 for-declared int i, its for scope, the round-local t/b scope,
54 true guards, final false guard, and FPR return conversion. The finite fuel
55 bounds only the checker; soundness targets unbounded source semantics.
GeneratedSqrt132.source proves exact parsed/literal AST equality; function_source
binds the complete lowered source function. Generated source SHA
425ba9257e5899d2091b3ed113648ed793cd61eb798fd5cb062bd203812a9683;
reproduce with FprSqrt132Generator in job006. Earlier005 serialization was
rejected for indentation and is retained, never used as a source binding.

FprSqrtCompute132.execute_sound proves any successful checked computation
executes that function with existing guarded C99 arithmetic and header calls.
FprSqrtEight132.source/ exact prove execution on 0x4020000000000000
returns exactly 0x4006a09e667f3bcd; unique proves source-call determinism.
FprOfEight132.source proves the actual fpr_of(8) input conversion separately.
No mathematical square-root oracle, native-output premise or new axiom.
FprSqrtClosure132.only_pack/pack_no_callees/pack_lookup close every callee
of THIS sqrt body and its FPR dependency; no whole-KeyGen coverage claim.

FprScalarClosure132.calls is an explicit NEW relation: pinned sqrt execution
for the missing name, frozen Search scalar calls otherwise. previous embeds
every old call; deterministic is proved; strict_extension has an actual new
sqrt call and proves the old relation cannot execute it. Thus old/new relations
are not identified. The downstream search/norm/attempt/whole-law spine still
needs explicit versioning and source/frame/determinism proofs.

Final job011:7 isolated audit processes,7 mathematical modules,52 named
declarations,14/14 coherent clean modules, full DAG roundtrip and kernel-safe
rechecking at original declared types, allowed propext/Classical.choice/
Quot.sound only. Audit collection
58bb4d593062f9666a279670d7287fd1e51b7d1045cf3d8346512a49717e05e1.
Eleven jobs:001/003 syntax elaboration,005 serialization and009 setup failure
retained with causes (four failed attempts).009 never launched Sage and has
no invented computation receipt; three setup files and separate diagnosis
are preserved. Corrected010 Sage passes0/0 using ZZ/QQ, exact54 rounds and
strict squared midpoint check. Its output is auxiliary, never a proof premise.

Source commit1dbd49de. Entry8841001e1e9eaa3f065387fbfa6f121f90328eff6de1535d0d2423cb72e67a9e
verified36274parent pins. No frozen input change, no production C edit, no push,
review,worker or new schedule. Paper remains measured and five do_sign items
unchanged. Continue explicit new search/norm semantics; do not report the
original three-point success-mass program complete at this helper milestone.
