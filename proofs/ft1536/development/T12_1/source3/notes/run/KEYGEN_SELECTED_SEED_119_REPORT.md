# 119 — selected seed through actual source SHAKE initialization and padding

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**. The continuous three-point
program remains ACTIVE / NOT COMPLETE. Full law110 KeyGen success, Z>0,
numerical acceptance and conditional coding remain OPEN.

The previously selected public synthetic counter9 seed now has a closed local
source SHAKE chain: `SelectedSeedFlip119.source_chain` supplies actual
`ShakeSeedReference.Init`, `Inject` and `Flip` in sequence. Initialization uses
capacity512, injection supplies exactly32 bytes, and padding performs the
actual source byte stores and17 dec64le/xor/store iterations. Computation
equations are checked by decide +kernel and consumed by118 source soundness.
No native return, SHAKE idealization or probability premise is used.

The literal-state generator checks immutable113_005 evidence and independently
computes the initialization, injection and padding images in Sage ZZ. All416
RNG bytes match rng_new, rng_seeded and the first shake_before. These values
are untrusted candidates for the Lean checks. The generator emits literal
finite byte tries, avoiding repeated word-to-byte heap reconstruction.

`SelectedSeedBytes119.seed` names the exact32-byte kernel input.
`input_image` proves the source heap contains those bytes; `new_image`,
`initialized_image`, `injected_image` and `flipped_image` check every byte of
the416-byte images. Lengths are kernel checked, as is the readonly24-word RC
table. Thus the trie encoding is not silently treated as an authenticated
interpretation of the byte lists. The native/file correspondence is retained
through generators, exact input/output hashes and the separate Sage controls.

Scope is deliberately exact: this local caller contains the32-byte seed
object, an448-byte context and RC. Unused context bytes are fixed zero. The
complete law110 canonical caller/domain, public set_seed replace1 wrapper,
readiness prefix, extraction/MODE1 sampling, gates/solver and final emitted
packet remain separate obligations. This result does not turn116's local
process_block theorem into a complete KeyGen success witness.

Final keygen_seed119_005:5/5, logs0/0, full26-declaration term/type DAG and
standard-axiom audit. The selected initialization/injection module passed in
3.122s, flip in3.322s, byte images in19.264s. Five jobs, no failures.004/005
intentionally add and check explicit byte images; earlier001/002/003 are
retained, not overwritten. This demonstrates the literal representation for
these seed phases; it is not a benchmark of whole process_block or KeyGen.

Reproduction: run job111 in Sage mode on `keygen_selected_seed119.sage`, copy
the exact GeneratedSeed119Fixture.lean result into formal/Source3, then compile
Fixture, SelectedSeedInit119, SelectedSeedFlip119, SelectedSeedBytes119 and
SelectedSeed119Audit in order. Use fresh job labels, persistent paths and one
job at a time. The generated seed-derived module stays outside Git; immutable
job snapshots and hashes are in the receipt/postseal. Generators and proofs
are versioned. The version1 computation record retains its stated legacy
provenance limits; canonical job receipts supply actual resource/argv pins.

Entry verified all29087 pins of118. Parent postseal:
dc2cedbbcf2bb782dec14897d0db85b78eb035dc925f785f5f00843411838b2b.
119 ENTRY_PINS:e36c1396dc9c69b86daf4b59324a3329bace9236a16b666778d5ae38671fb85c.
Continue exact caller/seed API binding and source extraction. No new
assumptions, IID, F04 substitution, measured-paper change, production edit,
push, schedule, migration or independent review claim; five do_sign items
remain unchanged.
