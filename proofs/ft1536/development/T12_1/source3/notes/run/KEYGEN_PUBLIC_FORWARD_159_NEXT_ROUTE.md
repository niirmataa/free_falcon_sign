# Continue the public computation after159

Resume at the two open callee regions of the forward body. Entry state:
SelectedPublicConvert158.after; each mq_NTT_ternary body execution must
start at `PublicForwardBody159.generateEntry (PublicForwardEntry159.entryT
s a) gBlock iBlock` (for mq_mkgm3) and at
`PublicForwardBody159.aliasesBound ...` (for the tail), with the two Fresh
block premises and capacities supplied for concrete blocks (for example 33
and 34 on the converted heap; verify absence first).

1. PublicForwardGenerate159: bind the complete mq_mkgm3 body (falcon-vrfy.c
   lines 823-885). With logn10 the first `while (k ++ < TERNARY_LOGN_MAX)`
   loop runs zero iterations; the logn==1 branch is skipped; the main loop
   is 256 iterations (u += 2) with two rev10 helper calls and four stores
   per iteration; then the 256-iteration upper loop, the 255-iteration
   descending loop, gm[0]=gm[1] and the final mq_div_18433 store.
   All helper calls are constructible through PublicLeafSource157
   (add/sub/mul/conv/half/div) and PublicRevSource157 (rev10).
2. PublicForwardPasses159: the tail (fragment 1001 61). Use initialized
   cells, not values: the a[0..1536) image and gm[0..1024) cells are enough
   to execute loads; stores need only legal writes (Word16Memory158.source
   from window158). Reuse the fold shapes of KeygenPublicFirstFold,
   KeygenPublicUpperLoops and KeygenPublicTripleFold as invariants; do not
   assume an evaluation or twiddle property.
3. Then the two-call composition and the suffix (fragment 1537 10):
   t[u]==0 tests, mq_div_18433 stores, mq_iNTT call, return 1. The inverse
   call layers already exist as consumers (KeygenPublicInverseCalls/
   KeygenPublicReverseCalls); construct their executions the same way.
4. Only after the public call returns nonzero: root solver
   (SelectedAttemptPrefix156.continue_search), certificate gate and codec
   encoding tail; then G(seed*) and Z >= 2^-256 through
   KeygenSuccessMass134. These remain open and were not assumed anywhere.

Discipline unchanged: one guarded job at a time (tools/job111.py, unique
labels keygen_publicforward159_*), small local commits without push,
retained failures with causes, 0/0 accepted logs, postseal at the next
recoverable checkpoint, no IID/D1/F04 or empirical premises, corrected134
and frozen110 history, measured wording and five do_sign unchanged.
