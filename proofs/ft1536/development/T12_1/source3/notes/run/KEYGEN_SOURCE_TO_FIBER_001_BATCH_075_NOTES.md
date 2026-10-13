# BATCH075 — complete source STATIC physical-memory round-trip

PROVED_KERNEL_SCOPED_PHYSICAL_INPUT / NOT_REVIEWED. Owner TODO item2
complete; WHOLE TODO ACTIVE. This is not a midpoint close or final report.
NEXT: SAME mathematical-vector/physical-int16 transport in BOTH directions,
public codec LAST. B1.07/B1.08 Acceptance NOT MET;B1.09 OPEN; inherited whole
KeyGen/B1.10/root-call-ID/LegalWorkspace and compiler/security scope unchanged.

## Exact completed contract

For q18433/logn10/compSTATIC1,1536 SAME initialized physical int16 input words,
non-null encoded-output pointer, legal capacity/writable destination and
non-aliasing, consume an ACTUAL complete encoder source dispatcher call with
an unrestricted observed return. Supply input extent covering that ACTUAL
return. The complete source decoder dispatcher then derives:

- KeygenCodecStaticCallRoundtrip.source_call_roundtrip: every original physical
  word recovered; decoder return=ACTUAL encoder return; exact3072-byte decoded
  write frame, all outside bytes and allocation metadata preserved.
- call_roundtrip_exists: honest finite COMPLETE decoder source/dispatcher
  execution, with arbitrary old destination contents and arbitrary tail data.
- KeygenCodecStaticMemoryIdentity.source_in_place_identity: when decoding back
  into the original coefficient array, decoder heap=encoded heap and every
  byte of the original coefficient block equals its pre-encoding byte.
- in_place_exists: that identity is inhabited by a complete honest decoder
  dispatcher call. The encoder's output buffer remains encoded; whole
  PRE-ENCODER heap identity is not claimed.

No desired codec result, encoded bytes, encoded length, frame, success flag or
complete decoder execution is a premise. The encoder execution is the actual
source premise. The existence claim constructs the decoder; no unconditional
compiler/encoder execution is implied outside legal source input domains.

Capacity is an explicit numeric legal-buffer domain, defined by the independently
source-proved mathematical bit budget: ceil(sum(10+floor(abs(word)/256))/8).
It does NOT assert an observed codec length. The body proves encoded_length
and the actual source return. uniform_capacity derives sufficient26496-byte
capacity for ANY1536 int16 array. Actual KeyGen narrower bounds/capacities and
SAME mathematical values belong to the next transport item. No fixed STATIC
frame size is assumed: source-proved honest encoded lengths lie1920..26496.
Supplied decoder extent is compared with the observed return, not a desired
byte count. Its additional tail values are unrestricted.

## Complete source proof chain

The full uncompress_static syntax retains every branch, refill, early return,
break, prologue, store and padding check from LIVE pinned falcon-enc.c SHA256
0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05.
The source binding is reproduced byte-exactly from its committed producer.

The actual prologue derives n1536/j8/mask255, data/x bindings and fresh zero
u/v/db/db_len cells. Prefix refill reaches9..16 pending bits; a zero initial
pending count correctly needs TWO bytes. Pending-suffix invariants retain
arbitrary old emitted high bits, with no invalid whole-accumulator bound.
Sign and low8 derive from real shifted/masked db. The complete actual unary
for-loop includes ne=0, each source ne++, physical refills/v++/db_len--,
terminal-one break through scopes and innermost-loop absorption. It derives
ne<=128, passes the actual ne>255 guard, reconstructs magnitude and stores
the SAME original word. The source casts to int16 BEFORE promoted unary
minus; -32768 is covered with safe int32 negation and the final int16 store.

The outer loop composes exactly1536 chronological stores, actual ++u reaches
1536 without wrap, and the last iteration checks its OWN zero padding then
returns real v. Byte-count conservation derives encoded-byte exhaustion and
that consumed return. Generic Store16 trace lemmas give all physical readback
and exact3072-byte destination frame. Typed reader seams are derived from the
actual prologue, not retained as whole-codec assumptions.

KeygenCodecStaticWire.source_bytes/physical_reads/original_preserved derive
readable decoder bytes and preserved original material from the SAME actual
encoder. Both actual dispatchers retain all five source argument identities,
including x/data pointers. comp is unused callee reference metadata, not an
extra C argument. STATIC uses its fixed COMPLETE source callee; NONE has its
already checked profile, with no arbitrary or assumed-correct alternate callee.

## Quantitative results and retained evidence

075 adds68 proof modules,771 named declarations/376 named theorems. Counts
include source syntax definitions/witnesses and semantic proofs; they are not
completion percentages. Eight full audits cover480/95/41/16/38/33/7/61 NEW
declarations. Final086 rebuilds11 final proof modules+audit12 clean0/0 in ONE
current source manifest. Final audit66=61 new+5 inherited,64 full terms+
2 kernel inductives, standard axioms/no elisions. SHA256
`5c55b6aaf4a98a4b25da04631ba2a763e32b541390bcbcd312484b9ba0f30df7`.

All86 proof jobs/205 native steps retained:44 wholly accepted/42 failed jobs,
163 accepted steps. Max observed RSS3835356KiB; native child times sum388.521s,
including failed attempts. Failures are proof-authoring/type/normalization/
linter/import/build-list issues; every mixed job and exact cause is pinned.
There is no newly found production-code counterexample in075. Inherited
whole-word-bound/shared-padding/NONE9217 counterexamples and failures remain.
The stronger prefix byte-conservation theorem is NEW; its frozen predecessor
was not edited. No limits, warningAsError or inner isolation were weakened.
No new C/Sage/mutation campaign or finite tests are promoted to universal proof.

The reader organizer's first metadata-only seal refused because a foreign
proof job appeared at the final idle guard. No receipt/postseal was written;
before-tool/refusal/first reproduction are retained. All17607 prior pins were
rechecked; idle retry with fresh reproduction passed. This is slot availability,
not a hidden hash mismatch or frozen repair. Original073 integrity refusal,
owner-authorized sole audit-pin supplement and both historical states remain.

Internal075 postseal pins:
- foundation17293:acd0588af3664591c29ea2613fe8c32574d1659c97c26a66ac5a49550b9958b8
- bits17607:69bf29ffc7957f5cb6196d13dd8ac99f9f2818c1430501333538c7c9ce11ed57
- reader17821:1ffff6bb11a5bb9887a648931a909d370ebdafb72380e574a916fc42c56e9a74
- prefix17951:a71c4d47cdfb7ec8eb3f6f1793f17750d73a4cb7c9d0e810e92b572c6633d0d9
- unary18221:d32a4a14909aca06b4266459a20f35f3ce94a42d68f33d347f9406a5eaa21d2c
- coefficient18418:cbfbf8ea486e877cf34955137c4335cdc20a44ea4f332aac4cc9957ca8c79808
- loop18481:2e233d0593be13437f0a7ce3dec77cdacf5754003eb7d9b351bd59339412268d

All18481 preceding pins are rechecked before final seal. Own075 commits:
f028483f/cf93bc73,85d68993/fb3b3b34,4240c75f/25cb5ab8,
f3becc95/be81e9d4,64086a35/292b68c2,58ae4e6c/69b6eb81,
50dd1f09/e074100a,b02e8a0e. Final metadata commit/postseal/ENTRY076 are recorded
next in the result receipt/live state, avoiding circular self-pins. NONE074 and
authorized073 supplement remain immutable. Foreign shared-main files/index/
history preserved; no push, amend, force, hooks bypass, subagent/reviewer/relay,
migration, production-C edit or automatic publication.

Author proof-audit/proofread self-review is pinned, primary verdict proved as
written within the explicit C99/GCC LP64/little-endian reference-source domain.
It is not independent review, REVIEWED, stages import or owner acceptance.
No mathematical-vector equality, public codec, ISO-C/compiler/hardware,
probability/PRG/security or B4/B5 completion is silently supplied.

After final075 postseal, create ENTRY076 and continue directly to SAME
mathematical-vector/physical-int16 transport BOTH ways, public codec LAST.
Do not stop at this item boundary. The one final owner report covers the whole
TODO (or a true hard obstruction) and includes three sentences of assessment.
