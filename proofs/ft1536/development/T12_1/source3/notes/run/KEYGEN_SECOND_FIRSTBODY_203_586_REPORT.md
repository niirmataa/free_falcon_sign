# R1 d=2 first scoped prime iteration — checkpoint 586

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber owner goal
remains IN_PROGRESS. This is an intermediate local checkpoint; work continues.

The headline source theorem has no premises. Starting with the existing
constructed first make_fg_step execution, it binds the actual d=2 call,
executes its declarations/layout/memmove prefix, takes the u=0 prime body,
constructs both generator tables, copies each strided input column, skips
both !in_ntt branches, executes both128-product loops at output stride3,
and executes both logn8/full0 inverses at input stride2. It then skips
!out_ntt, restores the actual body scope, increments u0→1 and proves both
the initial0<2 and next1<2 guards. Both fd/gd128 product images and fs/gs256
inverse images hold on the same final output heap. Words retain their
executed-source meaning; no transform/root law is inferred from this image.

Supporting exports construct the original fs/gs inverse-call branches for
all lower sizes, generic copy/product loops with arbitrary per-cell read
keeps, the complete source-ordered four-statement column engine for either
side and u<2, and the full original nine-statement tail with both sides and
the false !out_ntt skip. The generator preserves both entire moved512-word
source arrays at the same output as its256-word gm/igm images. Actual heap,
pointer, scalar and table domains are discharged in the concrete first-body
export, including the body scope and caller counter update.

The old copy/product invariants retained an unused caller fs/fd binding
inside loops that read/store through x. New203 invariants remove only those
fields, enabling the original gs/gd initializers to use the same generic
loop proof. Each initializer still proves its actual caller array binding;
allocated/writable domains, source loads, separation and exact pointer walk
remain required and proved. Historical modules remain unchanged.

Canonical job keygen_secondfirstbody203_586:19/19 accepted, exit0, diagnostics
0/0, warningAsError, markers/suppressions0. Total Lean time57.515s; maximum
cumulative child RSS3775200 KiB. Original interfaces and26 axiom results
checked; dependencies use only propext, Classical.choice and Quot.sound.
Limits unchanged. Independent review NOT_RUN.

All21 local attempts are retained;9 failed. Seven failures are compiler,
parser, adapter or elaboration/clean-log failures: opaque pointer/side/list
aliases, misplaced product keep proof, a missing noncomputable annotation,
reserved scoped syntax and Bool-contains/Prop-membership normalization.
Two failures are distinct environment/resource failures: exit134 with
failed-to-create-thread, no Lean proof diagnostic. The post-failure resource
probe is retained; it does not establish the precise OS cause. Replacing
new parser-wide decide shape proofs with composition of already-pinned
source-shape equations repaired the issue at unchanged limits. Pair checking
fell from≈25s/5.7-million-KiB failures to3.071s/3739080 KiB locally; the final
canonical19-module job passed. No failed product entered the lane cache.
All old failures and the bodyHeap composition finding remain preserved.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after, zero missing/changed. All136 predecessor585
evidence bindings verified before/after. Local reuse checks unchanged accepted
workshop sources/products/receipts by hash; final canonical compilation
rebuilds all19 modules. Python orchestrates jobs and hashes only. No re-baseline,
production C change, migration, stage import, reviewer start or push.

Next587: preserve the untouched odd columns through this first iteration,
execute the actual u=1 iteration and close part2, then multi-limb CRT and the
remaining lower-size forward/additional-prime work. Later d levels and the
enclosing root/certificate/codec remain open. This checkpoint does not close
all d=2, full KeyGen/Sign/compiler/security, closed-form NTT/root laws, or
unconditional positivity/probability claims. Old110/measured/five do_sign
obligations retain their previous scope.
