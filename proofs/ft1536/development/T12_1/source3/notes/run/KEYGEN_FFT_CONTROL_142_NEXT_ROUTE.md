#142 continuation — generic group/pass composition

Start from SelectedFftOuterControl142.after, a reference State with a proved
exact symbolic buffer image. Do not require a compact literal snapshot or
launch another long per-butterfly certificate series. Source141 already
provides the generic original inner-loop theorem.

Verified endpoint facts:
- SelectedFftOuterControl142.source: original outer Prefix1 from
  reference SelectedFftMiddleStart139.setup, including m increment.
- t384,m4,hn768,n1536,tmin3; actual root array pointer remains
  SelectedFftBuffer141.base = block31/index0/count35840/width8.
- image: Represents after.heap base SelectedFftLoop141.finalValues.
- SelectedFftOuterContext142: arrays/globals/tables and heap metadata;
  outside-byte frame relative to SelectedFftBuffer141.before (the actual
  accepted v24 snapshot), not an unproved equality of all earlier heaps.
- pinned: original readonly FftGlobalMemory table contents at this endpoint.
- ht/hm/u1/v1 and group v/v2/sr/si have original lexical-scope restoration;
  do not reuse their temporary loop values after scope exit.

Next143 should derive a reusable group source theorem: declarations,
original square-table index/load, v2=v1+ht, v=v1, inner-loop induction,
scope restoration and u1/v1 increments. Inputs should be ordinary typed
control/buffer/table facts proved at the actual caller; no source-execution
or outcome premise. Use FftTableWord139/FftTableList139 and pinned memory
without normalizing the complete parsed table. Then induct over groups and
passes, preserving the exact symbolic vector recurrence and context.

The next pass has t384,m4,ht192,hm2. General constraints for this full1536
profile are m*t=1536,hn768,even t/m, group u1<hm and
v1=u1*t; v2+ht<=hn. Eight middle passes total end at t3,m512; only the first
is source-closed here. Sage141's eight-pass schedule is planning control,
not proof that the remaining seven source passes execute.

Potential later bottleneck: symbolic word images still need verified exact
comparisons at the Gram-Schmidt gate. Preserve the route to a source-equal
compact/numeric endpoint instead of assuming an abstract recurrence equals
a diagnostic C snapshot. Universal FprFastCalls137 handles mul/add/sub/
neg/sqr/half/double and ternary of; source-fast div is still outstanding.
Tripling and rt2 FFT are also open. Full goal remains law134 success and
three-point success-mass program; no positive-mass instantiation yet.

One job/Lean, fixed limits,0/0, all failure histories, exact current pins,
small main commits/no push, postseal, no workers/schedules, measured wording
and exactly five do_sign items unchanged. No mutation of sealed142 files.
