# Checkpoint191: first-prime pair-product loop s2 at the copy output

Base190 at bc8f9c1f (resume from the live registers
KEYGEN_R1_TAIL_TODO.md / KEYGEN_FULL0_TABLES_189_NEXT_ROUTE.md /
KEYGEN_STEP_COPY_190_REPORT.md; the owner prompt matches them, no new
prompt/register discrepancy). Whole goal ACTIVE / NOT_COMPLETE. Verified
70613 inherited paths into fresh ENTRY_PINS191 (PASS_INTEGRITY) and
inspected active processes before any new proof work.

Construct the original remaining pair-product statement MakeFgTailShape190.s2
of the make_fg_step first-prime tail at the SelectedStepCopy190 copy output:
productInit (v:=0, x:=fd+u), the 256-iteration product loop with the exact
walked x pointer, the two source loads t1[(v<<1)+0], t1[(v<<1)+1], the
nested Montgomery product through the source R2 written at *x, and the
two-clause increment v++, x+=tlen. Values are only the executed loads and
Montgomery products; no image law, transform property or step/root
completion is assumed.

Acceptance: exact source statement checked against the parser (decide),
generic product-loop induction with an explicit invariant (stable t1 reads,
separated destinations, written prefix as executed words), selected
instantiation from the preserved copy image, full kernel audit, logs 0/0,
retained failures with causes (including one receipt-less ENOSPC setup
abort recorded after the owner freed space), postseal, small local commits
without push. No C/reference/limit change, new premise, IID/D1/F04,
empirical promotion or change to the five do_sign items.

The modp_iNTT3_ext inverse body (statement s3) is deliberately out of this
checkpoint and is split into prologue/passes/correction like the forward
182-185; the gs path s4-s7, the false !out_ntt s8, the outer loop tail,
CRT/additional prime, later levels/root/encoding follow before any
complete emitted witness for KeygenProbability134.
