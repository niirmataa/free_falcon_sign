# R1 generic CRT coefficient and complete coefficient walk — checkpoint 597

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall B1 is IN_PROGRESS.
Owner decision2026-10-26: finish597, then stop for today and resume tomorrow.
The next unused suffix is598; no598 source/job was started.

The original CRT coefficient now executes for arbitrary bounded u-length
vectors. It declares the actual private words, reads xp=x[u], reduces the
first u limbs through the full unsigned source body, constructs the actual
Montgomery correction and invokes the complete generic add-multiply.
One output contains its exact u+1 words. Every private local is restored,
array bindings match the caller, and reads outside these writes survive.
No desired source execution/output or CRT law is supplied as a premise.

The complete original coefficient walk is built with the actual v/xstride
increment, counted guard, v0 initialization and x=xx binding. Its ordinary
domain exposes num/u/xstride cells and bounds, allocated initialized data,
modulus words, writable destination and separation. It permits arbitrary
stride satisfying u+1<=stride. The per-row pending/written invariant
preserves all modulus words and all other rows. The full flat export
contains every row: the rewritten u+1 words and every untouched later
residue at the same output. Only the actual walk controls v/x change;
all other caller locals/array bindings and outside reads are preserved.
This exports the source engine needed by a generic CRT prime round.

Executed:9 modules. Validated: canonical keygen_crtwalk214_597 accepted9/9,
exit0,diagnostics0/0, warningAsError; four public interfaces and25 axiom
results using only propext/Classical.choice/Quot.sound. Lean time33.055s;
maximum cumulative child RSS4005416 KiB. Original limits and internal network
isolation unchanged. Independent review: NOT_RUN.

Six local attempts retain one failure:004 accepted the complete counted
walk but rejected two rewrites crossing the214/208 row/point namespaces.
Explicit alias bridges repaired it. No mathematical counterexample,
resource failure, suppression or failed lane-cache artifact occurred.
Every raw snapshot/log and all inherited findings remain retained.
The permanent195 bodyHeap/stepState defect remains unused; sealed
predecessors and original syntax bindings are unchanged.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all190 predecessor596 bindings verified.
Fresh597 entry/predecessor checks completed before its first proof job.
Python handles scaffolding/jobs/hashes; all source arithmetic/execution
is kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. This checkpoint is a local source commit, not an
independent acceptance of the overall package.

Resume598 only after the owner resumes: indexed PRIMES3 prime prefix,
whole prime round using this walk and the generic multiply receiver,
outer u loop and the actual make_fg CRT/normalization composition. Later
d levels/root/certificate/codec/full B1 remain open. The coefficient walk
does not execute the prime/outer loop and does not prove a mathematical
CRT/centering/Montgomery/integer/NTT/root/table law. Full KeyGen/Sign/compiler/
security and unconditional positivity/probability remain open.
Old110/measured/five do_sign keep their previous scope. WORK_STATE records
the exact next proof route, runtime and pause decision.
