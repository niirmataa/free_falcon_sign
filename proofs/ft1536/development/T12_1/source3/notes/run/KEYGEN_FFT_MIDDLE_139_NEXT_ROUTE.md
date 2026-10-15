#139 route checkpoint and next computational bottleneck

The original whole-owner objective is ACTIVE. This is an internal partial
checkpoint, not completion of the planned whole middle/tripling FFT.
Actual first middle-group entry and eight butterflies are kernel proved;
the first group still has376 iterations, then seven further outer passes,
tripling and the second FFT. All downstream KeyGen and mass goals remain.

Evidence changed the route: direct4 iterations took40.560s; cached4 took
40.104s, while cached12 and direct definitional equality of that12-iteration
capture failed to establish the result under the fixed limits. The cache
itself is sound (78 initial events, later30 used by the accepted4 fragment).
Thus arithmetic lookup caching did not remove the dominant full-state/AST
reduction cost. The accepted fragments and all failures stay preserved.

Next priority: derive a reusable, source-exact butterfly execution theorem,
parameterized by the four input words and the original pointers/local
indices, with source-proved137 arithmetic and exact four writes. The
expanded FPC macro scopes and every C arithmetic/address guard must remain.
Then use that proved rule to check larger loop prefixes without interpreting
the same long AST for each butterfly. This is checker refinement only;
C/reference/law134 must remain unchanged. Also retain the feasible slow
route of4-iteration prefixes; it is deferred for efficiency, not disproved.

For later readonly table loads, FftTableWord139 pair_from_row/even/odd and
FftPinned139 provide an exact source route avoiding full table expansion.
A source-validated literal/chunk table reader plus an invariant-preserving
checker is a possible further optimization; NOT yet implemented or proved.

Boundary to carry forward: NormalizedFftMiddle139.after (after8 iterations),
NormalizedFftMiddle139.source/continue_loop, and FftMiddleCompose139 group/
outer scope rules. Current immutable previous seal remains138 until139audit
and postseal succeed. No final positive mass claim, no IID/F04, no added
assumption, no resource-limit increase, no push or independent review.
