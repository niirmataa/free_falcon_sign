# BATCH_072 — exact secret-codec lengths / partial NONE decoder midpoint

2026-10-13, Codex. **CLOSED_AT_RECOVERABLE_MIDPOINT / PARTIAL_PROOF /
NOT_REVIEWED. Exactly one close this window.** B1.07/B1.08 Acceptance NOT MET;
package WORKING_NOT_FROZEN. B1.05/032, B1.06/046 and full STATIC071 unchanged.

## Exact strongest conclusions

The source length contracts consume the actual complete pinned encoder Exec/
dispatcher Call, M0 q18433/logn10 and, for STATIC, original allocated/aligned/
initialized int16 Words of length1536 with input/output block separation.
No desired output bytes, encoded length, successful codec result or frame is
an input. All observed flows are unrestricted in the full source contracts.

- NONE: full body/dispatcher derives return3072 for NULL or sufficient
  capacity, otherwise actual pre-write return0. Inherited source theorem
  is exposed as none_source_length/none_call_length.
- STATIC: exact encoded length is
  `byteLength inputs = (sum_i (10 + floor(abs(x_i)/256)) + 7) / 8`.
  `KeygenCodecStaticLength.encoded_length` proves this for the actual071
  encoded stream; unary/coefficient/outer-fold bit conservation and actual
  independent padding supply the result. Arbitrary old accumulator high bits
  remain legal. All int16, including-32768, give1920..26496 bytes for1536 words.
  LowMagnitude (every magnitude<256) gives exactly1920 bytes.
- `static_source_length`/`static_call_length` conclude LengthOutcome: one
  exact ordered prefix of the same original physical-input encoded stream,
  and either actual return=ofNat64(byteLength), complete prefix, OR actual
  return0, non-NULL, strict prefix and exhausted capacity. NULL/adequate-capacity
  return is derived, not assumed. The bound26496 prevents return-word wrap.
- `KeygenCodecChainLengths.chain_lengths` consumes the actual normally
  completed four-segment source chain and SAME original physical arrays.
  It DERIVES each c.ret=ofNat64(byteLength(inputs c.index)); individual desired
  codec lengths/results are not premises. Mathematical-vector/WORD transport
  and the final caller length-store remain open.

## Decoder progress and exact boundary

The complete pinned `uncompress_none` body, both runtime branches, all source
comments/lines/delimiters and exact0x8000 token are bound by KeygenDecodeSource,
KeygenDecodeSyntax/Grammar and KeygenDecodeNoneBinding.source_bound. The new
parser copies the immutable encoder parser into its own namespace, adds ONLY
that literal and changes callee names to decoder names. `hexadecimal_value`
checks0x8000=8*16^3. The generator reproduces all7 new parser/binding files
byte-exactly from live pinned Extra/c/falcon-enc.c; no predecessor edited.

KeygenDecodeNoneScalar proves high/low byte reconstruction and source scalar
sign extension for ALL int16; its exact unsigned range gate and long
subtraction accept/recover coefficients on explicit Carrier[-9216,9216].
`pair_roundtrip` proves decodePair(high x)(low x)=some x on that carrier.
KeygenDecodeNonePairs.segment_roundtrip proves the PURE pair-stream adapter
`parse inputs.length (wire inputs ++ tail) = some (inputs,tail)` for arbitrary
tail and CarrierList. These are useful inverse lemmas, NOT complete decoder
source execution, actual encoder-to-pair binding or decoded-memory theorems.
No source decoding or output frame is silently assumed.

## Retained counterexamples / attempts

Two new limited kernel witnesses: independent_padding_required refutes sharing
padding on GENERAL list streams (four one-coefficient zeros, not M0 executions);
outside_carrier_rejected/unrestricted_pair_roundtrip_false refutes unrestricted
NONE scalar inverse at honest9217. The source scalar gate rejects that value;
this is a carrier restriction, not a production-code bug. Both065/066 previous
counterexamples stay unchanged. No new Sage/C/control/mutation campaign ran.

13 jobs/34 steps retained:7 wholly accepted jobs,6 failed jobs,28 accepted
steps. Mixed011 accepted the updated Scalar before Pair failed. All causes in
levels_072/CAUSES.json; raw streams/snapshots/receipts/waits/oleans retained.
Failures are proof-authoring/clean-log/normalization errors, not valid source
execution counterexamples. No limit, linter or guard was weakened.
Final013:13 modules+audit14 clean0/0, native child sum54.681s; max observed
RSS3677568KiB.305 entries=293 new+12 inherited,292 complete terms+13 kernel
inductives, standard axioms only/no elisions. Full audit41,855,762 bytes,
SHA25657dafc15133ecd5aa01c4e39341e71437da94000bc1ced93b93684ab481062e6;
ignored durable artifact bound by source/generator/pin. Supplemental schema1
manifest validated with its legacy limitations; native receipts are primary.

## Provenance and fixed remaining order

Entry BEFORE edits/jobs:15526 previous pins, levels_072/ENTRY_PINS_072.json
SHA256a1d9287c4fe6b2d180cd5f39da8828245cee69652bb73f76b8b240dfb79715c1.
Only recorded061/063 supersessions. Base e5038969; own source commits79200d72,
7ad36a55,7fbe263e. Shared main/approved identity and writer lock respected;
foreign root/onboarding/S05/objects/index/history preserved. PRESEAL.json was
recorded before the unsealed organizer gained decoder-generator reproduction;
that early receipt is kept/pinned, final PRESEAL_002 uses final verifier hash.
No predecessor repair, migration, import, push, relay, subagent or review.
Author proof-audit/proofread-math self-review only; not independent review.

1. **NEXT / OPEN:** complete NONE source decoder reference execution with real
   byte loads/int16 stores, actual n1536/len gate, range guard, loop/return3072
   and output physical Words; actual NONE encoder read/write trace must supply
   the SAME high/low adapter. Derive segment++tail/frame, never assume them.
2. **OPEN:** complete STATIC decoder source binding/execution, refill/sign/
   low/unary/ne<=255/final zero-padding, exact consumed length and segment++tail.
   Complete four independent segment paddings/header/cursor/final length store.
3. **OPEN / UNSTARTED072:** mathematical Vec/coefficient-WORD ↔ physical
   original/decoded int16 Words, in both directions, for SAME material.
4. **LAST / OPEN / UNSTARTED072:** public same h/canonical15-bit packing,
   payload2880/header0x8a/2881 and actual supplied-length decoder return.
5. Inherited B1.07/B1.10/call IDs/snapshots/LegalWorkspace status remain;
   B4/B5 laws/availability/PRG/security and compiler/ISO-C are outside this lane.

The first route is OPEN/executable; no impossibility or external blockage was
proved. Stop at this one recoverable midpoint, resume only on owner start.
