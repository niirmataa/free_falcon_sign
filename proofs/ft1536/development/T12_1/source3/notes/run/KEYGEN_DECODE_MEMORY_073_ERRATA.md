# 073 memory-step provenance refusal — append-only erratum

The sealed `KEYGEN_DECODE_MEMORY_073_STEP.json` has SHA256
`acf532c5c2ee03e4d7afc70c477f1e42c69632d73b0c8fb98375e7c131f9bd07`.
It is preserved byte-exactly. **It has NOT passed postseal verification.**
Its notes are also preserved; their source-proof statements do not imply
that this receipt is an accepted integrity checkpoint.

The organizer collected the eight current proof-module results from mixed
job010, whose final audit step failed. It collected the corrected accepted
audit from011. The full `SOURCE_INPUTS.json` of010 includes the earlier,
unaccepted audit source among its selected inputs. Its snapshot matches
that historical manifest, while the current accepted audit source differs:

- Manifest/snapshot expected:
  `d818dd129d1b8aee439b4f3f12307d0b3a614cc6d236ba28f40ff4e433085301`.
- Current accepted audit:
  `dc2f54399f781ec25842eea26f5cc7adfa7955d348470443c16d63b2ad9d7cc0`.

The step verifier correctly refused that mixed provenance at its existing
live-input check. `MEMORY_POSTSEAL.json` was not created. The raw failing
stdout/stderr, both source versions, native receipts and exact command remain
under `.build/levels_073/` and the010/011 job directories.

This is an organizer/provenance error introduced in073, not a changed
predecessor, mathematical contradiction, production-code counterexample or
auto-review rejection. No seal, manifest, snapshot, verifier or predecessor
was rewritten to hide it. No postseal PASS or B1 Acceptance is asserted.

Work stops as instructed. A future owner decision can authorize a new clean
native rebuild and a distinct superseding receipt, retaining this failure.
The final whole-TODO status and all evidence are in BATCH_073 JSON/notes.
