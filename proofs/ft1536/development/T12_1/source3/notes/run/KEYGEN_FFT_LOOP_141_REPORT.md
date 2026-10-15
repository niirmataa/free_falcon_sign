#141 — original inner-loop induction and the actual first FFT group

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. The owner success-mass program
remains ACTIVE / NOT COMPLETE. No C/reference/law134 definition changed;
frozen110 and its zero-mass result are unchanged.

## Proven source result

FftLoopInduction141.prefix_source/source derives any bounded prefix and the
entire original inner loop, including its final false guard, from the proved
parametric butterfly. The theorem carries the exact pure word-vector
recurrence and a complete frame: all locals except v, arrays/globals/tables,
object metadata and bytes outside the logical buffer span are preserved.

C99NatWord141 and C99LoopScalar141 prove the actual uint64 addition,
comparison and v++ rules. FftLoopIndices141 derives the four ORIGINAL source
pointer judgments from natural range/capacity bounds; sums do not wrap in
the caller domain. FftLoopInvariant141.Fixed is preserved through both the
body and increment. The advance fallback lies outside the loop domain and
is not used by the source proof.

The actual input is the accepted GeneratedFft140Middle16.after endpoint,
with v=24, hn=768, ht=384, v2=384 and source twiddle words
0x3febb67ae8584cab /0x3fdfffffffffffff. SelectedFftBuffer141.represented derives
the full1536-word image from its ACTUAL checked captured block. A generic
sparse-tree predicate excludes Some none overrides; its kernel check and
the initialized default byte establish every read. A default byte alone is
not assumed sufficient. Metadata and whole-block identity are source-bound.

SelectedFftLoop141.exists_source/source instantiates the generic theorem for
the remaining360 iterations. It passed in13.752s, with no360-job or per-index
statement-interpretation series. SelectedFftGroup141.prior composes the
existing8+16 prefix, loop_source closes all384 butterflies including the
original false guard, and source closes the original group-body scope.

The endpoint SelectedFftLoop141.after is a standard Classical.choose of the
proved source execution; finalValues is an EXACT symbolic word recurrence.
SelectedFftGroup141.after applies the original group scope restoration.
This is not a new literal numerical memory snapshot. The inner endpoint has
v=384; the group endpoint restores v/v2/sr/si according to the original scope.
Group increments u1++,v1+=t and outer t=ht,m<<=1 are NOT closed here.

## Evidence

ENTRY141 d31e85e71a7a967f3c78cfe507f48d110ed5e441c6aba0969423994642de1213
verified41819 inherited pins from140postseal
e4fad5e82e6f2f04f03a4b6ce7f86c372458ab18631c87903d6aaedef0a8d185.
Source commits9bf41847 and484a6bcc. Small local commits only; no push,
independent review or owner acceptance.

Final audit015 covers14 mathematical modules plus14 isolated audits,
74 named declarations. The collector requires28 accepted module records,
0/0 logs, full expression DAG roundtrip and fresh kernel safe-definition
checking at the original types/options, with only propext/Classical.choice/
Quot.sound. This is self-audit. Exact collection and receipt pins are in
KEYGEN_FFT_LOOP_141.json and the external PINS note.

Standard-preparser Sage014 checks the exact index schedule in ZZ:
24 prior plus360 remaining iterations cover1536 word positions once in this
first group, all in range. Its optional eight-pass schedule check is only
finite planning consistency; it does NOT certify the other source passes.
No numerical final-word image or probability bound follows from this control.

All15jobs are retained; five failed/mixed003/006/008/011/012 have explicit
causes. They were index-rewrite/let-reduction/name-resolution/Decidable/
noncomputable-annotation failures, fixed without new assumptions, warning
suppression or raised limits. Compiler recovery placeholders in008 were
rejected and were never added to the proof source.

## Remaining work

Close the actual group/outer control statements, then reuse the generic loop
for subsequent groups/passes and tripling/rt2 FFT. The exact continuation is
KEYGEN_FFT_LOOP_141_NEXT_ROUTE.md. Full KeyGen source success, positive Z,
a numerical p_accept bound and the conditional coding/p_K bound remain open.
No IID/F04/D1 shortcut, empirical premise or hidden do_sign obligation was
introduced. The measured paper and exactly five do_sign items are unchanged.
