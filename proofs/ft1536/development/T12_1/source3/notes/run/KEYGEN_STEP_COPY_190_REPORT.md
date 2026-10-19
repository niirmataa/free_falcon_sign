# Actual first-prime fs-to-t1 copy loop and skip branch190

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Whole owner goal ACTIVE / NOT_COMPLETE.
Sources: see KEYGEN_STEP_COPY_190_PINS.md (commits listed there).

State reconciliation at resume: the owner resume prompt
PROMPT_R1_RESUME_003.md described the checkpoint state as "mid-suffix NTT"
with regions 2-3 of the R1 map open; the live records show regions 2 and 3
already closed at checkpoints160-174 and the actual work at checkpoint189
(make_fg first step, full0 generator call closed). The live records
(KEYGEN_R1_TAIL_TODO.md, KEYGEN_FULL0_TABLES_189_NEXT_ROUTE.md) were treated
as authoritative and the exact189 resume obligation was followed. This is
recorded here rather than silently reconciled.

MakeFgTailShape190 names all nine original statements of the make_fg_step
first-prime tail after the full0 generator call as projections of the parsed
syntax, each checked by decide: the fs copy loop, the skipped forward
branch, the pair-product loop, the active inverse-call branch, the gs
copies/products/inverse and the !out_ntt block. The copy statement is also
transcribed explicitly and checked equal to the parser output.

StepCopyBody190 executes one original copy iteration and its two-clause
increment on generic buffers: the t1 store of the word loaded through the
walked x pointer, the v++ counter update and the x+=slen pointer step, with
exact PointerAdd walks (addr_step) and the canonical write memory.
StepCopyFixed190 carries the loop invariant: stable source reads of the fs
image, the exact walked pointer, the copied t1 prefix, and the buffer
capacities; preservation uses only the executed store and its frame.
StepCopyLoop190 proves the 512-iteration induction and exports the copied
image together with locals/arrays preservation outside v/x.

SelectedStepCopy190 instantiates this at the actual selected first-prime
state (block31 scratch, fs=1694, t1=3742, n=512, slen=1, u=0): the source
words are exactly the preserved fs reads of SelectedGen0Frame189.f_read
(SelectedStepCopy190.fv), the t1 image equals those words as executed
loads, v=512 and x=fs+512 after the loop, and the original false !in_ntt
branch then runs and returns the same state. All facts are read from the
executed bodies; no image law, NTT property or transform identity is
assumed.

Five mathematical modules / 105 named declarations passed the full
expression DAG roundtrip and fresh safe kernel checks with only
propext/Classical.choice/Quot.sound and empty accepted logs (0/0). Job
numbers, retained failures and the receipt/postseal hashes are in
KEYGEN_STEP_COPY_190_PINS.md; the failed/mixed jobs and one receipt-less
preflight abort are explained in KEYGEN_STEP_COPY_190_FAILURES.json.

OPEN: the pair-product loop, the active modp_iNTT3_ext inverse body, the
whole gs path, the !out_ntt block, the outer u-loop tail, CRT and the
additional-prime part, then the remaining d-levels, root solver, certificate
and codecs, and finally the complete emitted witness for
KeygenProbability134. Old110 remains frozen; no unconditional Z>0, numerical
p_accept, coding or p_K bound is claimed. No IID/D1/F04 or measured-rate
premise was used. The paper remains measured; exactly five do_sign items
remain unchanged. No independent review, duplicate worker or push.

This checkpoint supplies no new positive probability bound; it closes the
first concrete data movement of the first make_fg_step iteration at source
level.
