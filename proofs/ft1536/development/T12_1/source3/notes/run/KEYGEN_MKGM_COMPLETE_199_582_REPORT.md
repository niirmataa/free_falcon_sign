# R1 generic generator completion — checkpoint 582

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber owner goal
remains IN_PROGRESS. This is an intermediate local checkpoint; work continues
without a handoff or push.

The kernel constructs an execution of the complete original
`KeygenMkgm3Program.code` for every logn from 1 through 9 with full=0.
Both output tables have exactly the required count=2^logn initialized and
readable words at the same execution output. Input requirements are scalar
bindings, actual writable/allocated table domains and the pinned readonly
REV10 source table. No previously initialized gm/igm word, transform image,
root law or successful execution is assumed by the whole-generator theorem.

The execution includes declarations; R/R2 and Montgomery conversion; the
full=0 cube and post-increment squaring loop (including its final increment);
source division for ig; the actual logn1 branch or higher-level REV10 row
loop; k=logn-1 and the false full branch; the complete descending square
loop; and both source top-element writes. The generic domains use the actual
table count, including logn1's two-cell tables. Words retain their executed
source meaning. Initialization/readability does not establish a closed-form
twiddle or NTT/root theorem.

Canonical job `keygen_mkgmcomplete199_582`: 14/14 accepted, exit0, diagnostics
0/0, warningAsError, no forbidden proof markers or linter suppressions.
Total Lean time 58.387s, maximum cumulative child RSS 4164024 KiB.
The original-type audit checks the scalar, row, descending-square and whole
interfaces; all 22 axiom results use only propext, Classical.choice and
Quot.sound (some use a subset). Limits are unchanged. Independent review
has not run.

The 17 local attempts retain 13 failures: unavailable/underspecified control
helpers; power-chain aliases and an avoidable duplicate; an unused square
helper premise; scalar sequence/indentation and row-store application parser
errors; one incomplete local import request; a surplus induction argument;
a Result/State metadata rewrite mismatch; and kernel-memory failures in the
initial scalar composition and concrete empty-scope conversion. Named
primitive proofs, explicit locals/size bridges and an abstract empty-scope
execution lemma repair the memory failures without raising limits. All failed
snapshots, raw logs and receipts remain pinned in the failure register.
No failed product entered the lane cache. Final canonical compilation rebuilds
all 14 sources rather than relying on the local nine-component reuse.

ENTRY_PINS remains `00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964`:
74673/74673 before/after, zero missing/changed. All 250 predecessor-581 evidence
bindings were verified before/after; the initial narrower check of its eight
canonical source/olean pairs is retained separately. No re-baseline,
production C edit, migration, stage import or publication occurred.

Next: bind this generator execution to the actual d=2 prime loop and later
levels, then close the remaining NTT/multi-limb reduction/CRT and enclosing
root/certificate/codec obligations. The full KeyGen/Sign/compiler/security
and unconditional Z>0, p_accept, p_K or Z>=2^-256 claims remain open. Old110,
measured wording and the five do_sign obligations retain their previous scope.
