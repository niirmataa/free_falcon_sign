#140 continuation — instantiate the proved butterfly invariant in the source loop

The owner-directed compression is now established for one entire original
middle butterfly and its symbolic word-buffer invariant. See
FftButterflyClosed140.source and FftButterflyBuffer140.source_and_invariant.
These are parametric in the incoming state, all operand/twiddle words,
buffer length and selected indices. Ordinary source entry conditions remain
explicit: actual pointer evaluation, readable words, writable objects and
typed twiddle cells. No result/callee contract, ideal real FFT arithmetic,
IID hypothesis or empirical premise is introduced.

The compiled straight-line checker was a partial optimization (the same
four-iteration pilot fell from40.560s to10.288s). Its16-iteration continuation
from v=8 to v=24 remains accepted evidence, produced before the owner's
instruction to avoid a large concrete-prefix series. No such series was
launched afterward. The parametric source proof is the primary next route.

## Next141: actual inner loop by induction

1. Expose a precise caller invariant: root a pointer, n/hn/ht, group range,
   typed counter v and fixed v2, sr/si, and C99WordBuffer140.Represents for
   all words. Derive four source Pointer judgments for v,v+hn,v+ht,v+ht+hn
   from those natural bounds and the actual uint64 expression rules. Keep
   alignment, extent and no-wrap facts explicit and prove them at entry.
2. Instantiate the one body/invariant theorem, then prove the original v++
   and comparison v<v2. Induct using the existing original Prefix relation;
   discharge the final false guard. Do not interpret the complete AST anew
   for each numerical index. Exact FPEMU word functions retain C rounding.
3. Derive the actual starting buffer representation rather than assuming it.
   The known scratch block has initialized default bytes; generic initialized
   block/read lemmas can provide a word-vector image without enumerating all
   C executions. Use source frames to connect it to the actual caller.
4. Resume the accepted actual endpoint GeneratedFft140Middle16.after (v=24)
   or compose its8+16 source prefixes explicitly. The original first entry
   FftMiddleLoad139.initial (v=0) remains available for generic instantiation;
   do not rerun confirmed concrete jobs. Normalize endpoints only via proved
   complete-state equality, not by substituting a candidate heap.
5. Close the remaining group/outer passes and tripling, then rt2 FFT and the
   rest of the original KeyGen success witness. FftMiddleCompose139 supplies
   original scope composition; FftPinned139/FftTableWord139 provide source
   table transport and word access without full table expansion.

C99WordStore140 gives exact ordered byte updates and equality to finite heap
writes; C99WordRead140 and C99WordBuffer140 establish read preservation and
indexed word updates. C99FourWordBuffer140 composes four such updates, also
when indices alias. For a closed pointwise pass formula, derive disjointness
of actual FFT indices from the loop bounds; do not assume it.

Whole source KeyGen/positive Z/p_accept/p_K goals remain open. Law134 stays
current and frozen110's zero theorem stays unchanged. One job, original
limits,0/0, all failures retained, small local commits/no push, no workers or
schedules. Measured paper and exactly five do_sign items stay unchanged.
