# STATIC codec research — development guidance, not a proof

The read-only development subagent started before the adapted B1 instruction
completed in session `ses_f0bb00eabffeGsecKMltV2U016`. It performed no edits,
proof jobs, Git operations or review. No new delegation is authorized by the
current B1 prompt. The following proposed invariants remain to be proved and
bound to memory executions; none is a final B1 export.

Source directory: the pinned RUN_003 `inputs/source/`, not Extra/c.
`falcon-enc.c`: `0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05`.
`falcon-keygen.c`: `0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf`.

## Proposed segment invariant

At q18433/logn10, STATIC encodes x as its sign, eight low magnitude bits,
`floor(abs(x)/256)` zero bits and one terminator. The bit length is
`10 + floor(abs(x)/256)`. The encoder's post-decrement at enc355--368 tests
the old value: the last body iteration observes ne=-1 and appends one;
the failing condition subsequently leaves **ne=-2**.

The uint32 accumulator retains stale emitted bits. It is not bounded by
`2^acc_len`. With appended bit string P, emitted-byte count u and r buffered
bits, use `acc = value(P) mod 2^32`, `length(P)=8*u+r` and the low-r-bit
suffix equation. At most16 low bits affect prefix extraction; unary byte
extraction uses8. Prove wrap/extract preservation instead of no wrapping.

For a 1536-coefficient vector, let Q be the sum of magnitude quotients by256.
The exact length target is `1920 + ceil(Q/8)`. Each call pads independently
with zero bits. A prefix-decoding theorem must return this exact consumed
length for `encode(x) ++ tail`, without consuming tail. Decoder arbitrary
inputs may wrap its unsigned unary counter; bounded encoder-output
completeness must not be promoted to a range theorem for arbitrary decoding.

## Same-material caller composition

Keygen8147--8155 encodes **f, g, F, G**, each from a fresh accumulator.
Header0xaa includes G. With source-derived ternary f/g and |F|,|G|<=2047,
the target private length is `7681 + ceil(Q(F)/8) + ceil(Q(G)/8)`.
The two ceilings cannot be merged. Preserve material and preceding output
segments through each call, output-length store and public encoding.

Public encoding uses15 bits per canonical coefficient h<18433:1536*15
bits =2880 payload bytes, header0x8a, total2881. The public decoder at
enc250 returns the supplied `len`, although it reads2880 bytes. Therefore
an exact-emitted-length theorem is required; arbitrary trailing-byte
rejection is not a property of that source decoder.

## Candidate read-only dependencies (pins checked during research)

All four files below are in
`proofs/ft1536/stages/FT1536_IID_RETRY_COMPOSITION_RUN_001/formal/`.

| File | SHA256 | Relevant scope |
|---|---|---|
| SourceBytes.lean | ae7be3a8c33e35f8651ea0ab6c2205451e36dfd0918daa5a23a71daae4ab0315 | Postprocess.unsigned_wrap_preserves_suffix |
| EncoderCount.lean | 0078c0033176ed65a1b43b8f092e260e785762c0075a06da40d2558fae2bdad4 | FT1536M0.encoder_count_exact, terminal_bit, post_decrement_count |
| ByteCursor.lean | 76e426fc152543026996dd1db8ad5ac68f23095d038854617aa70ad8f22acce7 | FT1536Bridge.fill_source, unary_source, unary_wrap |
| DecodeStatic.lean | 4c982438f1baf0425c42bba0ec00269718f3c057a15585aa11924e4ba054abd | FT1536Bridge.static_head_shifts and DECODE_STATIC |

These exports establish counts/cursor properties, not bytewise round-trip.
Before importing them, pin their complete dependency graph and inspect their
exact types. Geometry.Vec serialization is all first components followed by
all second components. KeygenMaterial.Represents requires a boundedness
premise for integer uniqueness: BitVec.ofInt16 alone is not injective.
