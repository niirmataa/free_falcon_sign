# 113 — public first-attempt native witness and reproducible byte evidence

2026-10-14. **NATIVE_WITNESS_WITH_EXACT_CONTROLS / KERNEL_SOURCE_WITNESS_OPEN**.
This is a checkpoint of point1 in the continuous three-point program, not
completion of that point or of the owner task. No new probability bound.

Incoming112 receipt95a063206b2f99676de9c3b51dade92ebc955c94e56e823ec7aba364bab0dcf5
and postseale387fe7824253fa149e10bbc93fa707aa039df10de2e58b90aea2ad7933e29c3
were verified against all27803pins. ENTRY_PINS:
272ea532d91b350bea7273d996e496fb9683c118575809c2abf0175e45782401.

## Selected public fixture

Reuse S1's synthetic tag `meas1`, counter9:
`6d65617331000000000000000000000000000000000000000000000000000009`.
No production credential or user secret is used. The prescribed call is
`falcon_keygen_new(10,1)`, then `falcon_keygen_set_seed(seed,32,1)` and
`falcon_keygen_make(...,FALCON_COMP_STATIC,...)` with API maximum capacities:
private12289, public2881. A fixed service allocator supplies fresh zeroed
objects. This fixes otherwise unspecified initial memory for reproducibility;
it is not a theorem about arbitrary native address layouts or heaps.

Native source returns1 after exactly ONE attempted candidate. Output:
private7681bytes, public2881bytes; four private segments each1920bytes.
Observed bounds are |f|,|g|<=1, |F|<=50, |G|<=62. Mandatory certificate
returns1, as do public computation and solver; both resultants are nonzero.
The actual stream consumed is1032bytes, with the residual2-bit buffer
correctly discarded/reset at the f/g call boundary exactly as in C.

Final job:`keygen_witness113_005`, explicit counter9, three executions of
that fixture (observed source, original control, observed repeat). The
original source is read from Extra/c; a generated COPY receives only logged
boundary observations. Production sources are unchanged. Both builds use
exact Makefile flags and the same fixed allocator; the SHAKE wrapper calls
the original extract once and returns its bytes unchanged. The original
control and observed execution emit byte-identical packets and streams;
the observed repeat has byte-identical event records. This is per-fixture
transparency evidence, not a universal instrumentation theorem.

`WITNESS113.json` SHA256:
dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf.
Artifacts live under `.build/jobs/keygen_witness113_005/`, including:
`candidate_009/seed.bin`, `private.bin`, `public.bin`, `STREAM.bin`,
`DECODED.json`, `events.bin`, original/repeat evidence, generated observation
source and transformation record, actual argv/executable hashes and logs.
The public synthetic private packet/seed are retained as generated evidence,
not committed key material; source generators and hashes are committed.

## What the controls establish

Standard Sage, exact ZZ/ZZ[x], independently checks:
- native SHAKE output against SHAKE256(seed), and exact MODE1 2-bit rejection
  replay against both native f/g vectors;
- STATIC decode, negative-zero exclusion, each segment's padding and exact
  length, full packet consumption and public15-bit canonical decode;
- every coefficient bound and exact polynomial equation
  `fG-gF=18433 mod (X^1536-X^768+1)`;
- `f*h=g mod (18433, X^1536-X^768+1)` for the SAME public packet;
- original/observed/repeated packet equality and repeated event-byte equality.

Separate `keygen_witness113_006` recomputes the exact FNV1a digest of the
retained bytes and matches the historical S1 record for counter9, without
running C again. The selected fixture is therefore tied to the old control,
but neither digest equality nor a native successful return is a Lean proof.

## Evidence coverage and next kernel step

The current event format records SHAKE extraction before/after states and
all extracted bytes; each attempted f/g; resultant/public/solver/certificate
returns; full norm/solver/certificate scratch boundaries; codec segments
and final packets. Zero-initialized service objects avoid recording unknown
heap bytes. Native pointer addresses are not dumped as a purported canonical
reference representation. The final metadata records actual LP64 offsets.

This is **boundary evidence, not every internal scalar/store transition**.
Additional checked execution evidence must be derived as the kernel checker
is built. The same109 `Execution` relation remains the target: actual seed
initialization, prefix, source first Attempt, full encoding and final packet.
No arbitrary material/callee postcondition, native_decide, return-code axiom,
ideal SHAKE premise or source-realization field may substitute for that proof.

114 has begun reusable computable finite-memory infrastructure with proofs
of read/write behavior. Existing C99 expression/body/header soundness and
primitive existence lemmas will support a proof-producing execution checker.
This is new work towards the missing concrete source witness; algebraically
valid decoded vectors alone do not close it. Point2/3 stay active and the
paper stays measured; the best source bound may be much smaller than1/4.

## Runs, failures and status

Six Sage jobs:001 failed only at final JSON serialization after native and
exact checks;002 passed the bounded selector and controls;003 passed the
selected-only replay with executable hashes;004 passed the historical digest
comparison;005 passed the owner-authorized repaired manifest replay;006
passed the historical digest AND byte identity with003 for all seven
semantic products. All accepted outer logs0/0, all native command logs0/0. Failure
cause retained in KEYGEN_WITNESS_113_FAILURES.json. Initial selection examined
counters0..9, not a probability-estimation campaign. Across001/002/003/005 there
were30 public native calls, of which the final replay has3;004/006 have none.
No empirical rate or confidence bound is produced.

No kernel witness, Z>0, unconditional first-attempt acceptance bound or
conditional coding bound is claimed yet. No push, production edit, migration,
reviewer, second worker or change to the five do_sign points. Continue the
active program; this native evidence checkpoint is not a stopping condition.

## Integrity stop before seal

The first seal attempt failed: recursive artifact discovery included the
ephemeral `cache/mamba/proc/632586.json`, which no longer exists after Sage
exits. The original manifest remains unchanged. Diagnostic inspection found
46 matching entries, exactly that one missing runtime file, and zero hash
mismatches. That failed attempt created no113receipt or postseal. This is an artifact-closure
packaging failure; the finite controls remain recorded and that first seal attempt did not complete. See `.build/success113/INTEGRITY_STOP_001.json`.

In accordance with the owner's integrity stop-and-report rule, no further
proof job or repair was started. A concrete proposed patch is saved at
`.build/success113/PROPOSED_REPAIR_001.patch` (SHA256
cab2372b0d4b548f253414ed8fde32f55032cf5f033ff389317c3ce3e1a60442):
replace recursive discovery by an explicit list of scientific outputs, then
perform a fresh replay of only counter9 and a new seal. Owner approval was
requested at that stop; no old pins were rewritten.

## Owner-authorized recovery

The owner explicitly approved the prepared patch and continuation of all
three points. The generator now declares scientific result files instead
of recursively collecting runtime cache. Fresh005 has22 declared artifacts,
all present and hash-matching.006 proves seven semantic products byte-equal
to003 and rechecks the old S1 digest; no scientific value was changed.
The old incomplete manifest, incident, pre-repair report/manifest and exact
patch are preserved. New witness manifest:
dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf.
REPAIR_AUTHORIZATION_001.json records approval; PRIOR113.json records the
semantic comparison. The stop is resolved by this authorized fresh replay;
the three-point program continues.
