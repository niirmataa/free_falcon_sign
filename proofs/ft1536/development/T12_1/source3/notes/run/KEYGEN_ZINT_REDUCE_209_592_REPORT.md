# R1 generic unsigned and signed bigint reduction — checkpoint 592

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber work
remains IN_PROGRESS; continue after this local checkpoint.

The original unsigned leaf now executes at any bounded limb length. Each
source iteration decrements the actual counter, reads that limb, performs
the Montgomery multiply, exact conditional word correction and modular-add
source call, and restores the local scope. The complete counted loop,
initial declarations/zero accumulator and final unsigned counter wrap and
return are constructed. Its returned word is the explicit executed fold;
the complete heap and arrays remain unchanged.

The complete signed callee includes both source paths. At positive length
it executes the unsigned call, reads the actual highest limb, applies the
exact Rx/sign-word mask and source subtraction, and returns the result.
At length zero it takes the original early branch: the body returns the
int32 literal0 and the uint32 conversion occurs at the C function return.
The API preserves this distinction. Generic original call adapters accept
source/length/receiver names, construct fresh argument frames and receivers,
and expose the same word at the caller with unchanged input memory. Input
word vectors/capacity/scalar bindings are ordinary source input premises;
no successful execution, expected output or arithmetic contract is assumed.

Executed: eight source modules and concrete generic source interfaces.
Validated: canonical keygen_zintreduce209_592 accepted8/8, exit0,
diagnostics0/0, warningAsError, markers/suppressions0; four interfaces and25
standard-only axiom results. Lean time52.077s; maximum cumulative child
RSS4165568 KiB. Original limits and inner network isolation unchanged.
Independent review: NOT_RUN.

Nine local attempts retain two failures.004 was an array-name alias rewrite
and unused simp-argument failure.007 failed before Lean startup after the
owner's app reset: the new outer sandbox blocked bwrap NETLINK_ROUTE socket
creation. The unchanged source succeeded in008 with permitted outer
escalation, retaining bwrap --unshare-net and all original limits; canonical
replay used that same inner profile. These are elaboration and environment
failures, respectively, not mathematical counterexamples. All raw snapshots,
logs and inherited findings remain; no failed artifact entered the cache.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before, on resume and after. All224 predecessor591
bindings verified at those boundaries. The owner's short reset pause and
resume are durably recorded. Python organizes jobs/hashes only. No
re-baseline, production C change, migration, stages, reviewer start or push.

Next593: actual bounded modp_Rx, then lower-size forward/additional-prime
products and full d2 return. Later d levels/root/certificate/codec and full
B1 stay open. The formulas are executed words, not mathematical modular
reduction, Montgomery, CRT, NTT or root laws. Full KeyGen/Sign/compiler/
security and unconditional positivity/probability remain open;
Old110/measured/five do_sign retain their previous scope.
