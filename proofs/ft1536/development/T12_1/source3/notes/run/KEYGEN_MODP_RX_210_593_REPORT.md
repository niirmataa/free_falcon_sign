# R1 bounded source modp_Rx — checkpoint 593

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber work
remains IN_PROGRESS; continue after this intermediate local checkpoint.

The complete original modp_Rx body executes for each positive input length
from1 through1024. The source parameter frame, x decrement, R2/R setup,
actual conditional z multiplication, unconditional r square, signed i
increment, loop guards and return are constructed. The word formula follows
the executed bit rounds and stops at the actual false guard. The signed
counter stays within0..10, and every evaluated shift is below32. No source
execution or expected output is a premise. Heap/arrays and other caller
cells are preserved across the loop.

Both the uint32 parameter shape and the original uint64 slen call shape
are covered; their parameter conversion is checked. The original Rx
assignment of the additional-prime section now constructs the full source
call. Length1 agrees with the prior R(p) empty-loop word. Length2 exports
exactly the executed montgomery(R(p),R2,p,p0i), without replacing it by an
unproved arithmetic value. This scope does not assert modp_Rx totality at
zero or arbitrary uint32 length.

Executed: eight source modules and the bounded original section interface.
Validated: canonical keygen_modprx210_593 accepted8/8, exit0,
diagnostics0/0, warningAsError, markers/suppressions0; five interfaces and45
standard-only axiom results. Lean time23.971s; maximum cumulative child
RSS4189740 KiB. Original limits and inner network isolation unchanged.
Independent review: NOT_RUN.

Seven local attempts retain two elaboration failures.002 simplified a
negative zero-mask hypothesis after BitVec.toNat_and expansion; rewriting
the proved decide boolean directly repaired it.004 transported an equality
into a by-decide list-membership goal with a free name; the explicit list
constructor repaired it. No mathematical counterexample, resource failure,
warning suppression or failed cache product occurred. All snapshots/raw
logs and inherited findings remain pinned.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all142 predecessor592 bindings verified.
Python organizes jobs/hashes only. No re-baseline, production C change,
migration, stages, reviewer start or push.

Next594: lower-size forward source/image, then the actual extra-prime
prologue/conversion/forward/products and full d2 return. Later d levels,
root/certificate/codec and full B1 remain open. No mathematical power,
residue, Montgomery, NTT or root law is claimed. Full KeyGen/Sign/compiler/
security and unconditional positivity/probability remain open;
Old110/measured/five do_sign retain their previous scope.
