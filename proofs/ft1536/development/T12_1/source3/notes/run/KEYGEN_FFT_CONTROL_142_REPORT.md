#142 — complete first middle-FFT outer iteration

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. The owner success-mass program
remains ACTIVE / NOT COMPLETE. No production C, reference semantics or
law134 definition changed; frozen110 and its zero-mass theorem are unchanged.

## Proven source result

SelectedFftGroupControl142.source closes the original group loop from the
actual SelectedFftMiddleStart139.groupInit state. It composes the sealed141
384-butterfly group body with u1++,v1+=t and the final false guard u1<hm.
All relevant cells are recovered from the actual prior snapshot through
the proved inner-loop frame and original group-scope restoration.

SelectedFftOuterControl142.source is a Prefix of length1 of the ORIGINAL
outer loop, from reference SelectedFftMiddleStart139.setup. It includes
the original true guard, outer declarations, group initialization, complete
group loop, t=ht assignment, outer scope restoration and m<<=1 increment.
The exact endpoint is SelectedFftOuterControl142.after with t384 and m4.
The source parser represents t=ht as an array-language assignment of a
scalar expression; the statement is not silently replaced with a different
AST wrapper. C99ControlShift142 proves unsigned shifts, including the
modulo2^64 output, without a no-overflow premise that the C operation lacks.

SelectedFftOuterContext142 carries unchanged n1536,hn768,tmin3, the actual
array binding, globals/tables, object sizes/permissions and bytes outside
the logical1536-word buffer. Its pinned theorem transports the original
readonly FFT tables through actual source executions. The output buffer
still represents exactly SelectedFftLoop141.finalValues. This is a symbolic
word recurrence at a proved reference-state endpoint, not a newly computed
literal numeric snapshot. No claim is made that subsequent passes ran.

## Evidence

ENTRY142 6e88f0f4edde1f897ee53a1949b9b2ec5448f60a9d968f03c4cbb68a6ee5e0c9
verified42155 inherited pins from141postseal
747168573920c137a6271de138fd744ee4bc337aed8ccf77c63b929c3e2326fb.
Small local source commits f0845d25 and d79a01b7; no push or independent review.

Final audit010 covers8 mathematical modules plus8 isolated audit modules,
64 named declarations. Accepted records must have0/0 logs, the full expression
DAG roundtrip and a fresh safe kernel definition at the original type/options,
with only propext/Classical.choice/Quot.sound. The collector and sealer verify
all source/artifact hashes and exact declaration coverage. This is self-audit.

Standard-preparser Sage009 checks the exact first-pass control values and
40 uint64 shift boundary cases in ZZ. It is an auxiliary consistency control,
not a source-execution or probability premise. Its raw controls are pinned
through the immutable job evidence. No acceptance estimate is promoted.

Ten jobs are retained; failed/mixed001/002/003/005/008 have explicit causes:
wrong AST wrapper, bwrap socket denial before Lean startup, hidden record
projection in a rewrite, syntactically hidden constant width, and Sage JSON
serialization. Corrections preserve source semantics, bounds and limits.
No proof placeholder, warning suppression or resource-limit increase.

## Remaining work

Reuse the generic inner-loop theorem through general group/pass invariants,
deriving table loads and source entry conditions. Seven further middle
passes, tripling and the second FFT remain open, as do the rest of KeyGen,
its concrete emitted-packet witness, Z>0, p_accept and coding/p_K bounds.
The exact next route is KEYGEN_FFT_CONTROL_142_NEXT_ROUTE.md. No IID/D1/F04
shortcut, empirical premise or hidden do_sign obligation; the paper remains
measured and the do_sign slot retains exactly its five original items.
