# 090 — actual SHAKE extraction and fresh temporary relocation

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**; whole owner TODO
**ACTIVE / NOT COMPLETE**. Parent is the additive 089 tracking postseal
`d460b99b748afbfe760d641ca1a5e80b718fb6ebe10feecb9b6c7df462d9d37e`.
The previous proofs, ignored historical organizer and public copy remain
unchanged. No independent random-word oracle or ideal permutation is used.

## Result

`ShakeExtractDeterminism090` proves uniqueness of the actual extraction
body and encoder for a fixed before-state and output object. The renaming
modules then transport the byte-memory reads/writes, scalar call semantics,
states, actual SHAKE block body, encoder and complete extractor through a
permutation of abstract block identifiers. Offsets and integer values are
unchanged. The table pointers are transported with their actual source
states; no new arbitrary callee is substituted.

`RngTemporarySwap090` proves the relevant swap leaves a heap unchanged when
both blocks were fresh, moves the real eight-byte allocation to the other
block, fixes live context/table objects, and commutes with disposal.
The source extractor's frame preserves the other unused fresh block.

`KeygenRngDeterminism090.call_unique` therefore concludes BOTH the same
returned uint64 and the same restored caller state for two finite
`KeygenRngSource.Call` executions, even if they choose different fresh
temporary blocks. Its input-memory domain is a live RNG context and live
table objects (`TablesLive`); these are the kinds of legal-memory facts
already present in the caller domain, not probability or correctness
assumptions. Their transport to every eventual sampler call site remains
part of the next source composition step.

`KeygenRngFunction090.draw` is the exact mathematical partial source draw,
with a membership iff source-call theorem. It chooses a result only after
source uniqueness is proved. It also derives unchanged allocation sizes,
permissions and tables, preserves the live input domain, and constructs a
legal successor input from a source return. Partiality is explicit: this is
not a termination theorem or an ideal/uniform/independent word law.

## Checks and retained failures

Final coherent job `keygen_extract090_014`: **11/11**, empty stdout/stderr;
10 mathematical modules and a full type/term-DAG/axiom audit of **78 named
declarations**, standard axioms only. Resource limits, no-network bwrap,
warningAsError, single-job lock and immutable products are unchanged.

14 job directories; all raw streams, source snapshots and receipts are
retained. Seven failed/mixed jobs and exact causes are listed in
`KEYGEN_EXTRACT_090_FAILURES.json`. They include offset/state projection
normalization, normalized source names, an ambiguous helper name and a
reserved identifier. Job010 was an organizer mistake: the dependent module
was attempted after its dependency failed, and the missing generated
object prevented compilation; it is not a failure of a pinned historical
artifact or accepted mathematical evidence. Job011 compiled the corrected
dependency first and then the RNG theorem successfully.

No new numerical experiment was needed. Python only organizes artifacts,
inventories, receipts and hashes. Large proof DAGs and binaries remain in
durable job directories, referred to by exact pins.

## Scope and continuation

Self-review checked the arbitrary-fresh-object case, caller-slot restoration,
live-table condition, return-word identity, and the difference between
unique completed execution and totality. The renaming applies to the
source language used by SHAKE, whose pointers are not converted to numeric
address-dependent outputs. This is author self-review, not independent
acceptance. Conservative proofreading covers only new files and notes.

Next: seeded `rng_ready`, the MODE1 rejection sampler and the remaining
whole-KeyGen source closure. The resulting partial draw is not yet the
whole seed-to-key producer, and the actual whole-call/key-model law is not
identified. Source-defined nonreturn, legal caller construction, success
normalization/existence and the final model pushforward stay explicit.
All five do_sign items remain unchanged; no actual-C e2, push, reviewer,
relay, migration, production edit, tag or stages import is claimed.
