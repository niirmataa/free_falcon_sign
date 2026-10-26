# R1 actual CRT coefficient engine — checkpoint 588

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. The overall source-to-fiber
route remains IN_PROGRESS; this is an intermediate local checkpoint.

The complete pinned zint_mul_small and zint_add_mul_small leaves now run
at length1 with arbitrary executed input words. The multiply preserves the
64-bit product/add, the cast back to32 bits, the31-bit limb mask and the
returned high carry. The addMul leaf performs both actual limb writes.
Both source engines export exact heap images without assuming successful
execution or desired output values. Image/frame corollaries preserve every
separated Load32 read at the same output.

The original CRT argument lists at u1 bind the unsigned reduction,
addMul and multiply callees, with the original xq receiver, discarded void
return, and tmp[u] carry store. Their actual fresh call frames and C return
conversions are constructed. The source-shape theorem binds the original
coBody to its declarations, prime reads, scalar setup, coefficient walk and
terminal multiplier. At one coefficient, the complete original scoped body
executes xp=x[u], unsigned reduction, Montgomery correction and addMul.
Both updated limb images, restored caller locals/arrays and arbitrary
separated read keeps belong to that same scoped output. The correction
and output limbs remain executed-word formulas.

Canonical keygen_crtcoefficient205_588 accepted14/14, exit0,
diagnostics0/0, warningAsError, markers/suppressions0. Lean time68.768s;
maximum cumulative child RSS5715732 KiB. Five actual interfaces and30 axiom
results checked; only propext, Classical.choice and Quot.sound or subsets.
The original limits are unchanged. Independent review NOT_RUN.

Fifteen local attempts retain eight failed attempts: unknown Bool theorem,
Int-vs-Nat literal binder, Load32 constructor/Allocated projection and
explicit alias/cast rewrites, an underdetermined state/word frame meta,
a malformed expression parenthesis, pointer-record geometry simplification,
call-entry cell inference across aliases, and coefficient-name membership
simplification with an unused simp argument. All raw logs/snapshots remain.
These are syntax/elaboration/clean-log failures, not arithmetic counterexamples.
No resource failure, linter suppression or failed cache product occurred.
CrtCoreProbe205 evaluated source ASTs only, not arithmetic proof evidence.
All inherited failures, the bodyHeap finding and31-bit-mask trap remain pinned.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after, zero missing/changed. All450 predecessor587
bindings verified before/after. Python organizes jobs/hashes only. No
re-baseline, production C change, migration, stages, reviewer start or push.

The full256-coefficient walk, prime-prefix composition, signed normalization
and both actual d2 CRT caller instantiations remain open. This narrower
coefficient checkpoint is recorded before continuing those obligations in589.
Remaining additional-prime/forward/products and full d2 return, later d
levels/root/certificate/codec and full B1 also remain open. No mathematical
CRT/normalization/NTT/root law, full KeyGen/Sign/compiler/security or
unconditional positivity/probability is claimed. Old110/measured/five do_sign
retain their previous scope.
