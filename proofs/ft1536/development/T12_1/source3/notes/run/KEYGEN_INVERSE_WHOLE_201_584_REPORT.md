# R1 generic whole inverse execution/image — checkpoint 584

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber owner
objective remains IN_PROGRESS; this is an intermediate local checkpoint.

The kernel constructs execution of the complete original modp_iNTT3_ext
body for every logn1..9/full0 and arbitrary valid stride. Its output image
contains exactly the executed intermediate butterfly words, final-pass
words and corrective scaling words on that same output heap. Inputs are
the actual scalar/pointer cells, capacities/writability/stride bounds,
separation, table reads and initial data image. A successful execution or
desired final image is not an input premise. This is a source execution
and word-image result, not a closed-form inverse-transform or root law.

The proof includes the original declarations, false logn0 return guard,
MKN n/hn assignments, skipped full-only triple pass, all logn-1 intermediate
rounds with composed images, degree-one final pass and source R/division
correction. The logn1 case executes zero intermediate rounds and keeps its
actual final/correction passes. Round domains use exactly n data/table cells,
not an artificial512-cell domain. Existing generic butterfly and scaling
loops are consumed through their unchanged pinned modules.

Canonical job keygen_inversewhole201_584:13/13 accepted, exit0, diagnostics0/0,
warningAsError, markers/suppressions0. Total Lean time47.609s; maximum
cumulative child RSS4004780 KiB. Original types and17 axiom results checked;
all dependencies are among propext, Classical.choice and Quot.sound.
Limits unchanged. Independent review NOT_RUN.

All13 local attempts are retained;9 failed. Failures are elaboration/import,
mechanical adapter and lexer errors (including repeated underspecified shift
constructors and the ≤i token trap), plus a clean-log failure from unused
fallback tactics. The final proof uses the specific decide/omega arguments
actually needed, retaining every linter. There is no counterexample or
limit increase, and no failed product entered the lane cache.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after, zero missing/changed. Predecessor583:
all106 evidence bindings verified before/after. No re-baseline, production
C change, migration, stage import, reviewer start, publication or push.

Next585: whole-inverse separated-read keeps, actual d=2 inverse call binding,
then the lower-size forward engine and concrete prime/product/multi-limb CRT
composition. Later d levels and enclosing root/certificate/codec remain open.
Full KeyGen/Sign/compiler/security and unconditional positivity/probability
claims remain outside this result. Old110/measured/five do_sign unchanged.
