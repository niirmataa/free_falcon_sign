# 095 — actual public computation with local arrays

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**; whole owner task
**ACTIVE / NOT COMPLETE**. Parent POSTSEAL094:
`527dea7a71d61ae2352e57fae94bc88116498e12242a20f22271f18b9601d591`.

The generic modular determinism lemma is instantiated with the actual
closed mq scalar strata: leaves, squaring and binary/ternary division.
Their bodies start in the existing fixed empty state with actual parameter
conversion. No arbitrary modular-call determinism is assumed. Public
scalar, expression, address and argument-binding uniqueness follows.

The full public language is transported under renaming of abstract memory
blocks, including local uint16 arrays, pointer aliases, all source calls,
branch/loop control, stores, scope restoration and actual disposal.
Source declarations and argument bindings derive live pointers where
needed; source execution preserves allocation metadata and readonly bytes.

Local aliases can remain in internal pointer environments after an array
is disposed. We do NOT assume that every such environment stays live or
that arbitrary public-language execution has identical local pointers.
`tailArrays` checks that arrays enclose the remaining function tail;
sequence heads and branch/loop bodies have no local array disposal.
All eight actual public functions satisfy that kernel-checked syntax
property. Calls restore the caller pointer environment. The inverse NTT
check reuses the previously pinned source-partition equalities, preserving
the complete actual body without reparsing it as one large reduction.

`KeygenPublicDeterminism095.execution` proves equality of returned heap,
scalar locals and flow in this checked domain; it additionally proves
full Result equality for continuations without local array disposal.
Its array case relocates the second fresh workspace, applies induction
at the SAME entry state and proves that the actual disposal eliminates
the heap difference. The visible-result distinction is internal to the
proof; the final `KeygenPublicCall095.call_unique` proves BOTH full
restored caller-state equality and scalar-return equality.

`compute_spec` is a both-direction characterization of an exact partial
`KeygenPublicSource.Call`, including source return-zero results. The
public gate is also unique on both control branches. Its bound-state
live inputs are derived from actual argument binding and input-memory
legality. `KeygenPublicDomain095` derives the h-workspace's liveness from
the actual prefix allocation, and transports the existing caller Initial
facts and h liveness through the prepared ternary source segment to the
public call boundary; the previous cap theorem identifies that prepared
entry. These are memory facts, not source-success
or distribution premises.

Final coherent `keygen_public095_015`: **11/11**, stdout/stderr **0/0**;
ten mathematical modules and full type/term-DAG/axiom audit of **63
declarations**, standard axioms only. Fifteen immutable job directories
retain six failed/mixed jobs; causes are listed in
`KEYGEN_PUBLIC_095_FAILURES.json`. The heartbeat-limit and kernel-memory
failures were repaired by explicit source inversion and existing source
partitions, without increasing limits. Deprecated/unused syntax and
scope-elimination issues were corrected without disabling warnings.
The attempted stop of job002 sent no signal: the process had already
finished naturally; that race is separately recorded and pinned.

Author self-review checked the local-alias lifetime issue, source coverage,
actual call restoration, return-zero preservation and input-domain
derivation. Earlier progress notes remain as chronological evidence.
This is not independent acceptance or a totality/success-mass theorem.
No numerical experiment was needed.

Next: NTRU solver source determinism, certificate and codecs, then the
entire capped attempt loop and actual seed-law/model binding. Fixed caller
construction, explicit seed versus automatic entropy, source nonreturn,
normalization and positive success where required remain open. Five do_sign
items unchanged; no push, production C edit, migration, independent review,
stages import or actual-C e2 result is claimed.
