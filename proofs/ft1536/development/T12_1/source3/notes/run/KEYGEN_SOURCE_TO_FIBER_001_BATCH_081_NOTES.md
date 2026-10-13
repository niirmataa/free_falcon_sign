# BATCH081 — complete observed secret key, including G

PROVED_KERNEL_SCOPED / NOT_REVIEWED. B1.08 Acceptance in the pinned reference
model is met. B1.09 whole-root public observation remains next in the owner's
continuous task; this is not the final task report.

Primary exports: `KeygenSecretComplete081.observed_secret` and
`actual_observed_decode`. They derive the full secret packet after public
serialization AND outer teardown. Independently observed bytes decode to
the SAME f/g/F/G, including G, with header0xaa. The source certificate call,
its invocation-local counter, argument cells, source snapshots and the same
integer NTRU/public/inverse equations are retained in `Output` and
`SameCertificate`. No dead coefficient array or bad flag is read.

`KeygenSecretBits081.word` parses the sign, low8 bits and unary counter,
including uint32 counter wrap and the actual ne>255 rejection.
`KeygenSecretSegment081.segment_honest` derives consumed bytes and each
segment's independent zero padding while retaining arbitrary following bytes.
`KeygenSecretPacket081.DecodeSecret` parses all four1536-word segments and
rejects a leftover suffix. Exact mathematical transport uses the existing
768+768 paired-vector layout, not interleaved coordinates.

`KeygenSecretChain081.source_trace` joins the actual four source write
histories and derives the caller cursor. `KeygenSecretPrelude081.prelude`
derives header0xaa/cursor1 and their survival through ske stores. The real
private length store, public body/suffix frame and local block teardown
frames yield the final observation. `KeygenPublicForeign081` proves its
frame for arbitrary public source outcomes, without a public length,
capacity or result premise. The source f/g/F/G bounds imply an exact length
formula with independent padding and the final7681–10369-byte range;
f/g consume1920 bytes each, F/G consume1920–3264 each. These are conclusions.

`KeygenSecretDecodeSource081.source_decoder_at_return` constructs the actual
complete C STATIC dispatcher/body for ANY of the four segments read from the
final observed packet, derives its consumed return and recovers the same
mathematical vector. It needs only ordinary decoder destination allocation,
writability and separation from the input blob. No decoder outcome is given.
This is not a proof of later signer validation, allocation or load_skey.

Exact domain: pinned C99/GCC LP64 little-endian reference execution, M0 and
STATIC comp1, legal initial context/scratch memory, live output objects and
the required block separation. The root source relation retains the finite
VirtualLegal domain at the ACTUAL private-pointer reads, already explicit
in batch076. It does not assert global injectivity on all Nat blocks.
Tail decomposition and reassembly are checked, as is projection to080;
return0 paths are retained. The source relation contains no mathematical
material, acceptance postcondition, codec result, encoded length, write
frame or round-trip assertion. No compiler pointer-representation claim is
made for arbitrary machine memories or unconstrained legacy pointer records.

Sixteen proof modules,98 named declarations,68 named theorems. Final026:
17 modules, clean0 errors/0 warnings; full audit107 entries,99 terms and8
kernel inductives, standard axioms only. Twenty-six jobs retained:13 wholly
accepted,13 failed/mixed authoring attempts with causes;47 native steps,
34 accepted. No new mathematical counterexample; all inherited unfavorable
results and failed sources/logs remain preserved. No linter suppression,
resource-limit increase, production-C change, independent reviewer or push.

ENTRY081 verified21,223 pins after080 postseal; SHA256
e79a6d4ef30f2b04ef5789e4a610424d3f01a688e37092280b6191563bb4fe57.
All earlier proofs and seals remain unchanged. Next: B1.09 actual public
observation joined to this same root material and certificate.

Git's generic `*secret*` ignore rule matched the two public Python proof-tool
filenames. The exact scripts are explicitly included; no secret key material
is generated or committed. The partial-add refusal is retained. Shared main
also received three independent S05 commits6e677a8b/1ea98b3e/8ed5e9e9 after
ENTRY081; their scope is outside source3 and they are not this task's work.
