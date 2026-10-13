# STATIC075 exact bit history and inverse — whole TODO continues

Internal PROVED_KERNEL_SCOPED / NOT_REVIEWED step; full source STATIC
round-trip remains OPEN. No midpoint close or final owner report.

KeygenCodecStaticBitStream.encoded_bits derives the exact complete bit stream
of the SAME source-defined encoder history, including its independent final
zero padding. Pending-suffix invariants allow arbitrary old high uint32 bits;
no invalid whole-accumulator bound or coefficient byte alignment is assumed.
KeygenCodecStaticBitInverse.decode_coefficient recovers every int16 with
arbitrary following bits. many_stream/encoded_inverse compose all original
words and retain exactly the derived padding. This is a value-level bit
parser, not yet the execution of the complete source decoder.

KeygenDecodeStaticSigned.negative_calculation/negative_store retain the source
cast-to-int16 BEFORE promoted unary minus. They cover -32768 with a safe int32
negation and the final int16 store, rather than assuming positive magnitude
fits int16. Generic C99/GCC LP64/little-endian reference boundaries remain.
KeygenDecodeStaticRead.source_append/source_single construct and invert the
actual physical buf[v++] RHSs. uint64 v update, allocated initialized byte
load and promoted-byte/unsigned addition are explicit; no source byte value
or codec outcome is guessed. KeygenDecodeStaticBitRead.refill_bits/high_bit/
consume_bit prove their exact pending-bit interpretation.

Checked execution certificates contain BOTH an actual finite source Exec
and uniqueness; generic sequence/scope/branch/while/for/break/return rules
compose these real executions. They are internal proof devices. The final
whole-codec statement must derive them from legal input, not assume one.
The physical store certificate constructs the overwrite from allocation and
writability, with arbitrary old destination contents; store uniqueness is
proved pointwise on actual bytes and metadata.

Final026 rebuilds12 proof modules+audit13 selected clean0/0 in ONE current
manifest. Audit101 entries=95 new+6 inherited,100 full terms+1 kernel
inductive, standard axioms/no elisions. SHA256
`c04065f72657aa6d0c0b2205bc105f0695195c4162c8646785644d67cb003b4c`.
Source commit85d68993. The producer is reproduced byte-for-byte in the seal.

All011–026 jobs retained with exact raw snapshots/logs/receipts/waits and
causes. Failed jobs concern proof normalization, unused-simp warnings and
operand-tag/width elaboration; all mixed jobs are recorded. No mathematical
counterexample to STATIC or production-C changes. The inherited counterexamples
and NONE carrier restriction remain. No limits/warnings/isolation weakened.

Foundation postseal17293 pins rechecked. NEXT: actual prologue/reader seams,
prefix refill and sign/low, unary loop, same-value1536 stores, exact consumed
return, honest complete source/dispatcher calls. Local read availability is
an internal guard condition; a whole-codec theorem must derive it from the
actual encoded stream/observed encoder return. Then SAME vector/int16
transport in both directions, public codec LAST. B1.07/B1.08 Acceptance
NOT MET;B1.09 OPEN. No push, review, subagent, relay or migration.
