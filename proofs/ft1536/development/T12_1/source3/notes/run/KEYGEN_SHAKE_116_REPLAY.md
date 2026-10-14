# Reproduce the local SHAKE source witness

Use the same persistent source3 workspace, the pinned job111 runtime and
one proof/computation job at a time. Never reuse an existing job label.

1. Run `job111.py sage NEW_FIXTURE_LABEL keygen_shake116.sage` using the
   ordinary Sage preparser. The input is the immutable113_005 event record,
   checked by its retained manifest. The result is `ShakeBlockFixture116.lean`
   and `FIXTURE116.json`; copy the checked module to `formal/Source3/`.
2. Compile the116 generic modules in dependency order: ComputeRead, Compute,
   ProcessCompute, Fixture, Chunks. Full names are in the116 receipt.
3. Compile `Source3.ShakeTrace116Generator`. It writes13 Lean source files
   under that immutable job's `generated/` directory. Copy those exact bytes
   to `formal/Source3/`: Start and Round00 through Round11. The generator is
   untrusted: its native evaluation is not accepted as a theorem premise.
4. Compile Start and the12 Round modules sequentially, using job111. Each
   round has49 independently kernel-checked source fragments, a computed
   increment and a computed guard. Preserve any failed run and its cause.
5. Compile `Source3.ShakeBlockReplay116` and `Source3.ShakeBlock116Audit`.
   The final source-call theorem consumes all24 rounds and the readonly RC
   proof; the audit checks full term/type serialization and standard axioms.

The source generator, proof composition and hashes are versioned. The
byte-derived synthetic fixture and generated state certificates are kept
as persistent pinned artifacts, not committed seed/private-key material.
Current copies under formal are ignored generated inputs; immutable per-job
snapshots are included in the116 receipt and postseal. Regeneration is exact,
including every input/output byte tree and typed local cell represented by
each state; mismatches must be investigated, not silently repinned.

Whole-block reduction was attempted in006 and exceeded6144MiB; its snapshot,
logs and failure remain. The successful route uses the same source execution
semantics, kernel reduction and resource limits, divided at finite-state
boundaries. A kernel source proof for this local A-array input does not yet
prove that actual seed initialization reaches it, or that whole KeyGen succeeds.
