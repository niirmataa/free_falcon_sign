# R1 generic bigint multiply/add-multiply source — checkpoint 596

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall B1 remains IN_PROGRESS;
continue after this intermediate local checkpoint.

The complete original zint_mul_small and zint_add_mul_small now execute at
arbitrary lengths n<2^64 under ordinary source memory/scalar domains.
The generic limb steps accept arbitrary input carry and retain the actual
uint64 multiply/add, narrowing,31-bit mask and right-shift operations.
Counted loop invariants track pending source limbs, exact written limbs
and recursively composed carry. No desired source run/output is a premise.

Multiply returns its final uint32 carry and exact n written limbs.
Add-multiply executes its final carry store and exposes the full n+1 word
image. Both support n0: multiply returns zero; add-multiply stores zero at
the valid destination. The latter needs explicit tail allocation but no
initialized old tail word. Source-array separation keeps pending reads
valid; array bindings, other locals and arbitrary reads outside writes
survive at the same output.

Both original CRT call frames are built from these full bodies with the
actual argument lists and discard/store receiver forms. The multiply
receiver stores the returned carry in tmp[u]; both wrappers expose complete
n+1 data images and restore every caller local/array binding. This removes
the old one-limb restriction for the CRT leaf interfaces. The generic CRT
coefficient/prime/outer-loop composition itself is next597.

Executed:13 modules. Validated: canonical keygen_zintarith213_596 accepted
13/13,exit0,diagnostics0/0, warningAsError; four public interfaces and25
axiom results using only propext/Classical.choice/Quot.sound. Lean time
39.231s; maximum cumulative child RSS3947676 KiB. All original limits and
internal network isolation unchanged. Independent review: NOT_RUN.

Nine local attempts retain two elaboration failures:001 omitted the
phantom wide-word argument in carry preservation;007 required an explicit
Cell/Slot64 entry bridge. No mathematical counterexample, resource failure,
suppression or failed lane-cache artifact occurred. All raw logs/snapshots
and inherited findings remain. The permanent195 bodyHeap/stepState defect
is unused and all sealed predecessors are unchanged.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after canonical replay; all307 predecessor595
bindings verified. The fresh596 startup scan completed after local001
launched; the same immutable595 post-entry pin had already been verified,
and both596 scans completed successfully before sealing. This sequencing
slip is retained explicitly; no re-baseline or mismatch occurred.
Python handles scaffolding/jobs/hashes; source arithmetic/execution is
kernel checked. No production C change, migration, stages, reviewer or push.

Next597: generic CRT coefficient/stride walk/prime rounds/outer loop, then
later d levels/root/certificate/codec/full B1. These are exact executed-word
images, without an integer multiplication/add-multiplication/CRT/centering/
Montgomery law. Full KeyGen/Sign/compiler/security and unconditional
positivity/probability remain open. Old110/measured/five do_sign unchanged.
