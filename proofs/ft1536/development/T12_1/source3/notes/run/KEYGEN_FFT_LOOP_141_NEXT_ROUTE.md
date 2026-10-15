#141 continuation — close group/outer controls, then reuse the loop theorem

The entire first inner loop and group body are source-proved. Existing8+16
iterations are composed with360 remaining iterations from one induction;
SelectedFftGroup141.source closes the group scope. The endpoint is a reference
State chosen from a proved execution, with an exact symbolic word-vector
image, not a newly checked literal numeric snapshot. This is standard
Classical.choice, already within the permitted axiom set.

Use SelectedFftGroup141.after for the actual group-body endpoint and
SelectedFftLoop141.finalValues for its word image. SelectedFftLoop141.frame
preserves all locals other than v, all arrays/globals/tables, object metadata
and bytes outside the1536-word span. Scope restoration then restores v/v2/
sr/si to the pre-group state. The incoming saved local snapshot has u1=0,
v1=0,t=768,ht=384,hm=1,m=2,hn=768.

Next142:
1. Recover those exact control cells from the loop frame and the group scope.
   Execute original group increment u1++,v1+=t; prove group guard1<1 false.
2. Execute t=ht, close the original outer scope (ht/hm/u1/v1), then m<<=1.
   Expose the first outer prefix at t=384,m=4. FftReferenceCompose141 gives
   scope composition directly for reference states; do not force the chosen
   endpoint into a compact heap without a complete equality proof.
3. Generalize the group-entry/table loads and reuse FftLoopInduction141 for
   later groups/passes. FftPinned139 and FftTableWord139 avoid full table
   expansion. Do not create hundreds of separate butterfly certificates.
4. Preserve exact vector recurrence through later passes and derive numeric
   images only when needed by a gate. A compiled/proposal evaluation is
   auxiliary until its equality to the symbolic image is kernel proved.
5. Finish tripling/rt2 FFT and remaining KeyGen gates/solver/certificate/codecs,
   then instantiate the positive-mass witness for corrected law134.

Actual buffer initialization is already proved at the v=24 checkpoint by
C99InitializedBlock141 and SelectedFftBuffer141. A default byte alone does
not suffice: the sparse tree must contain no Some none override. The kernel
valid-tree check discharges that fact for the actual captured block. Never
print generated dataBlock lines: one line can contain a megabyte.

No full FFT, complete KeyGen witness, positive Z/p_accept/p_K, independent
review or push is claimed. Old110zero and measured paper remain unchanged;
no IID/F04/new axioms, original limits, one proof job, five do_sign fixed.
