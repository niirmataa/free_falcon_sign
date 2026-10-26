# R1 d=2 generator binding — checkpoint 583

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED; overall owner goal IN_PROGRESS.
This is an intermediate local checkpoint, followed by continued proof work.

The complete generator from582 is bound to the exact seven source arguments
of the make_fg_step prime-loop call for every logn1..9/full0. Allocation
supplies pointer-add bounds; symbolic uint32 parameter conversions are
proved explicitly. The call and taken ter branch return both full readable
tables on one caller output, preserving all caller locals and array bindings.
No raw initialized-table or desired generator-output premise is used.

The concrete specialization starts with the actual first-step execution
and the established d=2 layout/memmove prefix. Readonly PRIMES3 and REV10
objects are transported across that execution and copy. It executes u=0,
its taken 0<2 guard, first-prime local declarations and actual p/p0i/R2
assignments, then the logn8/full0 generator branch. Both256-word gm/igm
images use that same output heap. The original inner-body continuation
and a composed entry-to-generator source fragment are exported. The full
d=2 prime iteration/part2 is not yet closed: copying, inverse transforms,
products and subsequent iterations remain downstream. For clarity, the
previous compact notation t12974 means the pointer named t1 at index2974;
the kernel pointer/layout statement is unchanged.

Canonical job `keygen_secondgenerator200_583`:6/6 accepted, exit0, diagnostics
0/0, warningAsError, no forbidden proof markers or linter suppressions.
Lean time19.037s; maximum cumulative child RSS4178852 KiB. Original-type
checks and13 axiom results use only the three standard allowed axioms.
Limits unchanged; independent review NOT_RUN.

One failed local attempt among4 is retained: the generic call adapter first
used decide for free pointer bounds and rfl for symbolic uint32 conversions.
Those are repaired from allocation and explicit conversion simplification.
This was an elaboration failure, not a counterexample; all logs/snapshots
are retained, and no failed product entered the lane cache.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964
remains74673/74673 before/after, zero missing/changed. All542 predecessor582
evidence bindings are verified before/after. No re-baseline, production C
change, migration, stage import, review claim or push.

Next: generic lower-size inverse/forward NTT, actual prime iterations and
multi-limb reduction/CRT, later d levels and the enclosing root/certificate/
codec source-to-fiber theorem. Full KeyGen/Sign/compiler/security, closed-form
NTT/root/table laws and unconditional positivity/probability claims remain
open. Old110/measured wording/five do_sign obligations retain their scope.
