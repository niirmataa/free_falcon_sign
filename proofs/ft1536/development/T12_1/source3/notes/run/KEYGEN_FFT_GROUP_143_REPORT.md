#143 — source group bodies and the group-loop induction

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Whole owner task ACTIVE / NOT
COMPLETE. No production C, reference semantics or law134 definition changed;
frozen110 and its zero-mass theorem remain unchanged.

## Source results

FftGroupTwiddle143 obtains either word of any legal source square-table pair
from the existing parsed-table theorem and actual pinned memory. Its generic
lookup lemma avoids normalizing the full table during kernel checking.
FftGroupIndex143 derives both ORIGINAL uint64 index expressions and pointer
judgments from m+u<1024 and typed m/u1 cells; no table-read result is assumed.

FftGroupExec143.prologue and initial_source execute the original declarations,
two table loads, v2=v1+ht and v=v1 from typed control and table facts. The
source uses the correct distinct assignment wrappers for statements and for
initializers. FftGroupSource143.source composes these steps with the already
proved FftLoopInduction141.source and original lexical-scope restoration.
It proves the complete original group body for arbitrary legal controls and
input words, with an exact pure word-vector result and full frame, including
ALL caller locals restored. Group-body temporaries do not leak out of scope.

FftGroupsInvariant143.Fixed states the natural bounds and source context:
t=ht+ht,hm*t<=hn,m+hm<=1024,2*hn<=n,n<2^64, buffer capacity/width, typed
m/t/ht/hm/hn, actual array/table bindings, write permission and readonly pins.
The caller provides u1=u and v1=u*t. From u<hm, the step theorem derives
all group/word-index bounds, executes the body and original u1++,v1+=t,
and preserves the invariant. No group execution/outcome premise is used.

FftGroupsInduction143.prefix_source/source then proves any bounded prefix
and the ENTIRE ORIGINAL group loop, including its final false guard. It
retains exact nested pure word recurrence, final u1=hm,v1=hm*t, and frame
outside the logical buffer; other locals, arrays/globals/tables and metadata
are preserved. Both butterfly count and group count are handled by universal
induction, without separate C-AST executions for individual indices.

This is a generic theorem. The latest actual execution endpoint remains
SelectedFftOuterControl142.after (t384,m4). No later actual outer pass is
claimed in143. Their caller/outer-prologue instantiation is the next step.
Symbolic word recurrence is not promoted to an unverified numeric snapshot.

## Evidence

ENTRY143 bd059b8ec532cb2e159628989a4b0586ca4205b9f646487f78c1b09ad17310b0
verified42368 inherited pins from142postseal
f1186fe58723e6ababba8d82d6fd0bd31510fbccf915d96e3db5d87a4ca6a0c6.
Small local source commits d9d5e280,57eec111,8dc4af50; no push.

Final audit013 covers11 mathematical modules plus11 isolated audit modules,
67 named declarations, with accepted0/0 records, full expression DAG
roundtrip and a fresh kernel safe definition at the original declared type
and unchanged options. Only propext/Classical.choice/Quot.sound are allowed.
This is self-audit, not independent review or owner acceptance.

Standard-preparser Sage012 uses ZZ to check all1024 source table pairs and
255 planned group-index/control instances across eight passes. These are
auxiliary consistency controls only; they do not execute the later source
passes or support any probability claim. The kernel proof does not depend
on their output.

All13jobs are retained. Failed/mixed001/002/005/006/007/009/010 have explicit
causes: large-table normalization hit the kernel memory limit; base-index
zero addition; list-membership simplification; String.toList simplification;
heap/recurrence aliases; an implicitly used binder; and a local state alias.
They were resolved without new assumptions, warning suppression or raised
limits. The table proof improved from a rejected31.194s memory-limit run to
an accepted1.769s abstract-lemma instantiation.

## Open obligations

Derive the original outer prologue and initialization from current typed
controls, instantiate the group-loop theorem, close t update/scope/m shift,
and induct over remaining passes. Tripling, the second FFT, later KeyGen
arithmetic and complete emitted-packet witness remain open. So do concrete
positive Z/p_accept and coding/p_K bounds. No IID/D1/F04 shortcut, empirical
premise or hidden do_sign obligation was introduced; paper measured wording
and exactly five do_sign items remain unchanged.
