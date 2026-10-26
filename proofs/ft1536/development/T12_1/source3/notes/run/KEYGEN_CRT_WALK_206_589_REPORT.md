# R1 full two-limb CRT co-reduction loop — checkpoint 589

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. The overall source-to-fiber
route remains IN_PROGRESS; work continues after this local checkpoint.

The original coefficient walk now runs for an arbitrary bounded count at
stride2, preserving unprocessed input rows, previously written rows and the
temporary modulus word. Its source v++ and x+=xstride, final counter/pointer
and false terminal guard are executed. The actual PRIMES3[1].p/s reads and
ninv31/R2 setup are constructed from the pinned readonly source object,
followed by the original v0/x=xx initialization. The complete original
coBody composes that prefix, full coefficient walk and terminal multiplier
that writes both tmp limbs. The enclosing xlen2 co-loop executes the one
u1 round, increments u to2 and exits at the false2<2 guard.

The num256 specialization consumes one full512-word input image and exports
its full512-word executed output image together with both new modulus limbs
at the same output. Generic source results also retain caller metadata and
arbitrary reads separated from both data limbs of every row and both tmp
limbs. Input domains/read images are premises of these generic source
engines; they are not assumed successful executions or desired output
postconditions. The actual587 fs/gs caller discharge remains downstream.

Canonical keygen_crtwalk206_589 accepted11/11, exit0, diagnostics0/0,
warningAsError, markers/suppressions0. Lean time76.132s; maximum cumulative
child RSS5182616 KiB. Four original interfaces and26 axiom results checked;
only propext, Classical.choice and Quot.sound or subsets. Original limits
unchanged. Independent review NOT_RUN.

Thirteen local attempts retain five failed attempts: reserved at helper name
with parser-recovery cascades, pointer-record congrArg inference, an
under-reduced Fin self-bound in omega, incomplete terminal-boolean
simplification, and reserved initialize theorem name. Actual draft sources
contained no admission; recovery diagnostics did not yield accepted products.
These are syntax/elaboration failures, not mathematical counterexamples or
resource failures. No linter suppression or failed cache product occurred.
The initial entry hash scan overlapped the first adapter check and completed
unchanged before retry;588's complete postcheck remains pinned. Every raw
log/snapshot and inherited failure is retained. Cached shape equations are
used in composition; the new increment shape is checked once per replay.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after, zero missing/changed. All250 predecessor588
bindings verified before/after. Python organizes jobs/hashes only. No
re-baseline, production C change, migration, stages, reviewer start or push.

Next590: generic source subtraction and two-limb signed normalization,
actual CRT declarations/initial tmp[0] source store and both fs/gs callers.
Remaining additional-prime/forward/products and full d2 return, later d
levels/root/certificate/codec and full B1 stay open. Output formulas are
executed words, not mathematical CRT/normalization/NTT/root laws. Full
KeyGen/Sign/compiler/security and unconditional positivity/probability
claims remain open. Old110/measured/five do_sign retain their scope.
