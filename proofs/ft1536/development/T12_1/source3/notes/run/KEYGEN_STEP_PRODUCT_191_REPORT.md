# Actual first-prime pair-product loop s2 at the copy output191

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Whole owner goal ACTIVE / NOT_COMPLETE.
Sources: see KEYGEN_STEP_PRODUCT_191_PINS.md (commits listed there).

Resume basis: the live registers KEYGEN_R1_TAIL_TODO.md,
KEYGEN_FULL0_TABLES_189_NEXT_ROUTE.md and KEYGEN_STEP_COPY_190_REPORT.md
agree with the owner prompt (checkpoint190 closed, s2 next at job suffix
363). Fresh entry verification re-checked all 70613 inherited pin paths
(0 missing, 0 changed) into ENTRY_PINS191 before any new proof work, and
active processes/job directories were inspected.

MakeFgProductShape191 transcribes the original pair-product statement s2 of
the make_fg_step first-prime tail as projections of the parsed syntax and
checks the full statement by decide against MakeFgTailShape190.s2: the
productInit (v:=0 and x:=fd+u), the loop guard v<hn, the scoped body with
declared block locals w0/w1, the two source loads t1[(v<<1)+0] and
t1[(v<<1)+1], the store *x = modp_montymul(modp_montymul(w0,w1,p,p0i),
R2,p,p0i), and the two-clause increment v++, x+=tlen.

StepProductBody191 executes one product iteration and its increment on
generic buffers: the declared block locals with their scope restore (whose
net effect is exactly the single heap write), the two executed loads, the
nested Montgomery product through the walked x pointer, and the exact
PointerAdd walks of the increment. StepProductFixed191 carries the loop
invariant: stable t1 source reads, separated destination addresses, the
exact walked pointer and the written prefix as executed product words;
preservation uses only the executed store and its frame.
StepProductLoop191 proves the 256-iteration induction and exports the
written image together with locals/arrays preservation outside v/x.

SelectedStepProduct191 instantiates this at the actual selected first-prime
state at the SelectedStepCopy190 copy output (block31 scratch,
fd index670, t1 index3742, hn=256, tlen=2, u=0): the source words are the
preserved t1 copy image of SelectedStepCopy190, the destination walk is
fd+u with stride tlen, the executed product words are exactly
montgomery(montgomery(w0,w1,p,p0i),R2,p,p0i) with the source cells
p/p0i/R2 of SelectedGen0Ready189, and the loop end state has v=256 and
x=fd+512. All facts are read from the executed bodies; no image law, NTT
property or transform identity is assumed.

One infrastructure event is recorded honestly: job365 was a receipt-less
setup abort caused by the data volume being 100 percent full (ENOSPC before
any Lean process). The stop-and-report rule was followed, no pinned or
archived bytes were touched by the worker, the owner freed space, and a
full read-only recheck confirmed the entry pin chain intact.

OPEN: the active modp_iNTT3_ext inverse body (statement s3, to be split
into prologue/passes/correction like the forward 182-185), the whole gs
path s4-s7, the false !out_ntt block s8, the outer u-loop tail, CRT and
the additional-prime part, then the remaining d-levels, root solver,
certificate and codecs, and finally the complete emitted witness for
KeygenProbability134. Old110 remains frozen; no unconditional Z>0,
numerical p_accept, coding or p_K bound is claimed. No IID/D1/F04 or
measured-rate premise was used. The paper remains measured; exactly five
do_sign items remain unchanged. No independent review, duplicate worker
or push.

This checkpoint supplies no new positive probability bound; it closes the
original data-movement/product phase of the first make_fg_step iteration at
source level.
