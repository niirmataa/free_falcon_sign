# R1 d=3 body: first slen=3 prime loop, generator and product layers — checkpoint 601

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall B1 is IN_PROGRESS.
Owner decision 2026-10-27: Source3 modules are produced with real proofs,
zero markers, or not at all. Window 601 opens the d=3 make_fg_step BODY
of the window-600 plan: the marches of the first slen=3 prime loop
(n = 128, hn = 64), the modp_mkgm3 generator, the Montgomery product
marches (iloczyny), and — still OPEN — the CRT transition, the
additional primes u=3..5 loop and the part-2/3/4 body composition.

The first slen=3 loop now executes completely with real proofs at the
d=3 geometry (fd@670, gd@1054, fs@1438, gs@1822, gm@2206, igm@2334,
t1@2462). The generic per-row prime prefix reads p = primes[u].p from
the actual PRIMES3 object and executes p0i = modp_ninv31(p),
R2 = modp_R2(p, p0i) through the actual source bodies (executed words
pVal/iVal/rVal of CrtPrimePrefix214). One complete iteration composes
that prefix, the modp_mkgm3 generator branch at Level 6 (logn 7,
128-word gm/igm reads), both march sides (copy marches at slen = 3 over
128 words, the false !in_ntt skips, the fd/gd Montgomery product
marches at tlen = 6 / hn = 64, and the taken modp_iNTT3_ext column
visits at stride 3 with exact scaledWord images), and the false
!out_ntt skip. The three counted iterations run over the PRIMES3 rows
0..2 from the u = 0 initializer to the false u < slen guard, producing
all six fd/gd product columns with exact words, the six iNTT column
visits, the flat 384-word moved-row images (the fs/gs images moved by
checkpoint 600 are now CONSUMED by the body, as intended) and the
readonly PRIMES3/REV10 facts at the loop exit.

Executed: five new modules with real proofs — ThirdStepGenerator215
(PRIMES3 rows 0..5 executed word layer, d=3 Outer/Basic invariants,
both modp_mkgm3 generator branches at Level 6), ThirdStepProduct215
(the Montgomery product marches at tlen=6/hn=64), ThirdStepMarch215
(the complete march layers: copy marches, skipped !in_ntt branches,
product marches, iNTT3_ext column visits, the two-sided pair and the
cross-side keep/separation glue), ThirdStepLoop215 (per-row prime
prefix, complete iteration, the three counted loop iterations and the
loop export) and ThirdStepLoopAudit215 (ten checked interfaces and ten
axiom results using only propext/Classical.choice/Quot.sound).
Validated: the aggregate replay keygen_body601_final accepted 4/4,
exit 0, diagnostics 0/0, warningAsError, 30.832s total Lean time,
maxRSS 4244160 KiB; the march module itself carries its own accepted
receipt (keygen_body601_007, 36.800s, 0/0) and is reused byte-identical
in the aggregate replay. Independent review: NOT_RUN.

Eighteen immutable local attempts retain fourteen failures, all with
reasons recorded in the failure register: 001 a wrong namespace for the
row-0 facts and an rw through an opaque def; 004-006 projection/Nat-
binder/missing-bound defects in the march layer glue; 008-010 the
pinned runner's memory ceiling — the march module alone elaborates at
5.84GB RSS against the -M6144 (6 GiB) limit, and stacking the
prefix/iteration content onto it (or replaying it when the system's
free memory is low) aborts with "failed to create thread"; the forced
engineering split into ThirdStepMarch215 + ThirdStepLoop215 is a
deviation from the requested six-module pattern (the body now needs
seven files) and is recorded openly here and in WORK_STATE; 011-014
scaffolding defects in the loop module (undefined glue lemmas, addr/elem
pointer association needing congrArg bridges, by decide/omega on free
variables, implicit-state elaboration order, seq nesting and unused
simp arguments under warningAsError). No mathematical counterexample,
resource-race, suppression or failed cache artifact occurred. Every raw
snapshot/log remains retained under .build/jobs/keygen_body601_*; the
permanent 195 bodyHeap/stepState defect remains unused; sealed
predecessors and original syntax bindings are unchanged.

Traps recorded for later windows: (1) ThirdStepMarch215 elaborates
within ~3% of the pinned 6 GiB ceiling — stacked or aggregate rebuilds
of it can tip over the cap under system memory pressure; prefer lean
imports and expect to split further march-like layers; (2) addr root u j
stride and elem root (u+j*stride) are NOT defeq (index association) —
bridge with the congrArg/omega pattern of StepCopyBody190.source_address;
(3) by decide/omega on free Name/Nat binders is refused — bind the
specific names/bounds; (4) element/USlot/Cell/Slot64 are defeq-friendly
but transports across distinct state records need named implicits
(state equality is not unification); (5) row-0 table facts live in
KeygenStaticReads (first/first_source/first_value), not KeygenStaticTables;
(6) rw cannot see through opaque statement defs — bridge with explicit
by decide equation theorems.

ENTRY_PINS 00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; predecessor 600 evidence 168/168,
599 113/113 and 597 133/133 bindings verified before and after the
first and the last 601 proof job. Python handles scaffolding/jobs/
hashes; all source arithmetic/execution is kernel checked. No
re-baseline, production C change, migration, stages, reviewer start or
push (seven commits were waiting at entry). This checkpoint is a local
source commit, not an independent acceptance of the overall package.

Not proved and not implied: the d=3 body is NOT complete — the CRT
transition (part 3, the zint_rebuild_CRT pair), the additional primes
u=3..5 loop (part 4), the part-2/3/4 composition, the step call/return
and a full-body audit remain open. No mathematical CRT/centering/
Montgomery/integer/NTT/root/table law, no desired output, certificate
or equation claim. Levels d=4..9, root/certificate/codec and full B1
remain open. Full KeyGen/Sign/compiler/security and unconditional
positivity/probability remain open. Old110/measured/five do_sign keep
their previous scope. WORK_STATE records the exact next route
(ThirdStepCrt215 then ThirdStepExtra215 then ThirdStepBody215); no push
was made.
