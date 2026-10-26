# R1 complete actual second make_fg_step — checkpoint 595

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall B1 remains
IN_PROGRESS; continue after this intermediate local checkpoint.

The complete original second make_fg_step now executes from its actual
bound entry, following the constructed first step. All six product columns
share one final output: fd/gd, columns0/1/2,128 entries per column. The
flat exports contain384 words per array in the actual stride3 layout.
The actual step call and enclosing body return these same words to the
caller. The source d2-to3 increment and next true d<depth guard are built.
No successful source run or desired output is supplied as a premise of
the complete body/image/return exports. Their pinned concrete entry and
existing source-model boundary remain explicit.

The new additional-prime path binds PRIMES3[2] to the kernel-checked tuple
(2147309569,686923925,434763914), executes the original p/p0i/R2/Rx prefix,
constructs both generator tables, and performs both signed-reduction walks
into t1. The signed-call receiver is the actual t1[v] store, with no old
initialized destination read assumed. A generic counted signed-store walk
supports bounded lengths and coefficient counts with exact output words,
source preservation and separated-read keeps.

Each side composes the signed words, complete logn8/full0/stride1 forward
and128 actual nested Montgomery products. The second side preserves the
first side's new products. The actual false !out_ntt branch skips inverse
calls. Private locals/pointer are restored, u increments2-to3, and the
terminal3<3 guard is false. Earlier four product columns survive the same
execution, with byte-level separation proved in the concrete scratch layout.
Readonly PRIMES3/REV10 and table binding are derived from the actual full
d2 CRT prefix. The source chain composes cached syntax equations rather
than reparsing the complete source tree.

Executed:21 new modules, including the complete body/call/return and flat
images. Validated: canonical keygen_secondextra212_595 accepted21/21,
exit0,diagnostics0/0, warningAsError; six public interfaces and80 axiom
results using only propext/Classical.choice/Quot.sound. Lean time129.380s;
maximum cumulative child RSS5960992 KiB. Original limits and internal network
isolation unchanged. Independent review: NOT_RUN.

Sixteen immutable local attempts retain five failures:006 forward concrete
indices remained opaque;007/008 geometry aliases and byte offsets remained
opaque;012 exit next/size projections needed explicit bridges;014 unused
simp arguments were rejected with warningAsError and removed. These are
elaboration/linter failures, not mathematical counterexamples. No resource
failure, suppression or failed cache artifact occurred. All logs/snapshots
and inherited findings remain retained. The permanent195 bodyHeap/stepState
defect is unused; corrected bodyAt/stepAt remains the foundation.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all262 predecessor594 bindings verified.
Python handles scaffolding/jobs/hashes; all source arithmetic and execution
are checked by the Lean kernel. No re-baseline, production C change,
migration, stages import, reviewer start or push.

Next596: generic bigint multiply/add-multiply for arbitrary-width CRT,
then later d levels/root/certificate/codec/full B1. The next true d3 guard
does not execute the remaining parent loop. No mathematical NTT/root/table/
CRT/centering/Montgomery law, full KeyGen/Sign/compiler/security or
unconditional positivity/probability is claimed. Old110/measured/five
do_sign keep their previous scope.
