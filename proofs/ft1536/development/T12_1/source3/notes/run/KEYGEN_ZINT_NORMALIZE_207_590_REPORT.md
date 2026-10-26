# R1 generic source subtraction and signed-normalization engine — checkpoint 590

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber work
remains IN_PROGRESS and continues after this local checkpoint.

The complete pinned zint_sub leaf now executes for any bounded length. Its
per-limb difference includes the incoming borrow, the actual31-bit store
mask and the outgoing shifted borrow. The counted loop, declarations,
initial zero borrow/counter and returned final borrow all belong to the
original parsed body. Every limb image and separated read keep is attached
to the same actual output. The original normalization sub-call binds the
fresh frame, checks the actual uint32 return conversion and restores caller
locals/arrays.

The complete pinned zint_norm_zero body now executes for any bounded length.
The descending source comparison uses the exact shifted modulus word and
carry bit. Less returns immediately; equal descends; greater executes the
full source subtraction. Complete ties include the source's final unsigned
counter decrement0→2^64−1 and normal void fall-through. Both early void
returns and fall-through are checked. The operational branch choice and
word image are explicit, with no desired-output or successful-execution
premise. Input reads, allocation/bounds and separation are ordinary source
domains. The original x/tmp/xlen CRT call adapter and explicit xlen2 export
retain both limb images, all caller locals/arrays and separated reads at
the same output.

Canonical keygen_zintnormalize207_590 accepted15/15, exit0, diagnostics0/0,
warningAsError, markers/suppressions0. Lean time58.774s; maximum cumulative
child RSS4182864 KiB. Five original interfaces and35 axiom results checked;
only propext, Classical.choice and Quot.sound or subsets. Original limits
unchanged. Independent review NOT_RUN.

Fifteen local attempts retain five failures: restored cc-name alias rewrite;
indexed Load32 dependent elimination; mistyped shared namespace plus implicit
Result witness; explicit Binary/literal conversion plus phantom state
transport inference; deprecated conditional lemma names plus an opaque state
alias in simpa. All are elaboration/clean-log failures, not mathematical
counterexamples or resource failures. No suppression or failed cache product.
All raw logs/snapshots and inherited failures, including the31-bit-mask and
bodyHeap findings, remain pinned.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after, zero missing/changed. All237 predecessor589
bindings verified before/after. Python organizes jobs/hashes only. No
re-baseline, production C change, migration, stages, reviewer start or push.

Next591: the full signed-normalization walk, CRT declarations/initial tmp[0]
source store and both fs/gs caller instantiations from587. The generic
normalizer also supports later limb lengths. Remaining additional-prime/
forward/products/full d2 return, later d levels/root/certificate/codec and
full B1 stay open. These are executed-word images, not mathematical CRT,
centered-representative, NTT or root laws. Full KeyGen/Sign/compiler/security
and unconditional positivity/probability remain open. Old110/measured/five
do_sign retain their previous scope.
