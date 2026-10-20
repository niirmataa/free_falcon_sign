# Reproduction and evidence reading

The accepted probe replay is already recorded in
`fresh_replay_001/REPLAY_RESULT.json`. It checks all three probe modules,
their exact sources, clean exit, and byte-identical stdout. It reuses pinned
corpus artifacts; it does not assert a fresh rebuild of all Source3.

From the canonical repository, with the recorded Lean 4.34.0 / Mathlib
runtime still available, run the archived `scripts/replay_probes.py` with a
**new** destination under `proofs/ft1536/replay-work/`. The script verifies
every artifact in `LIBRARY_SNAPSHOT.json` before copying it, and then runs
one Lean child at a time. It does not write to the original libraries or
mainline formal source. The recorded local library copies remain in the
durable audit W, not in system temporary storage.

`LIBRARY_SNAPSHOT.json` is an artifact dependency manifest, not a promise
that those binaries have been published. All project source inputs are
archived by content hash through `INPUTS.sha256` and `archive.py` objects.
`INPUT_LAYOUT.json` maps those hashes back to the audit's snapshot paths.
`SOURCE3_CLOSURE_INPUTS.json`, `RUN2_INPUTS.json`, `IMPORT_GRAPH.json` and
`CONFIG.json` identify modules, source pins and external library roots.
To rebuild without the local binary cache, restore those sources into a
fresh durable W, topologically build their imports with the recorded
Lean/Mathlib version, and then compile the probe files. This full rebuild
was not performed by this checkpoint and is not registered as an automatic
`archive.py replay` protocol (`replay=none`).

Large inspectable registries are losslessly compressed with gzip. For
example, `gzip -dc PREMISE_MATRIX.json.gz` reads full quotes, pins and
consumers. `PREMISE_MATRIX.tsv` is the compact index. Python scripts are
organizers and metadata extractors; the new mathematical refutations and
witnesses are Lean proofs. There is no floating-point numerical checker.

`ATTEMPTS.json` includes failed attempts, not only successful runs. Raw
logs and immutable attempt sources are retained. Early runner versions
were recovered byte-exactly from the edits recorded in this audit session
and checked against the original receipt hashes; they are explicitly
labelled as reconstructed rather than contemporaneous file snapshots.
The earlier lexical wanted-lists for intermediate inventory revisions were
not all snapshotted separately. Final inventory inputs, results, sources
and receipt are sealed; no claim relies on a missing intermediate list.

The arithmetic sweep is deliberately incomplete as a decision procedure.
Its `INCONCLUSIVE` rows must never be converted to `OK`. The embedded
impossible/satisfiable controls distinguish successful refutation from an
ordinary failed search. The `possible counterexample` diagnostic belongs
to omega's abstract arithmetic search, not to an actual corpus execution.
