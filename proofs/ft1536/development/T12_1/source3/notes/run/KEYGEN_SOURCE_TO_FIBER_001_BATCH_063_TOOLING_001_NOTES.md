# BATCH_063 tooling continuation — immutable seal supplement

2026-10-11, Codex. This completes §43R.2 before any codec edits.
The original BATCH_063 pair remains byte-exact (JSON `7dfeaccf…`, notes
`e71f8140…`). This supplement is its tooling seal, not a second midpoint
or Acceptance. B1.07 remains PARTIAL_PROOF / NOT_REVIEWED.

- Complete generated audit: `KeygenMakeSkeChainAudit`, accepted guarded
  job `keygen_make_ske_chain_audit_063_007`, clean diagnostic streams;
  87 entries = 12 new declarations + 75 inherited interfaces;
  57 complete terms + 30 kernel inductives, standard axioms only,
  zero elisions. Producer reproduction is byte-exact.
- Native Sage: `keygen_make_ske_chain_sage_063_009`, accepted;
  PUBLIC synthetic little-endian byte-memory controls over ZZ,
  three baseline families and twelve detected mutations; reference
  transcription reads `Extra/c/falcon-keygen.c`. No real codec/KeyGen,
  private key, universal computation proof or probability law is claimed.
- Retained new failures: audit 006 was blocked before Lean by the outer
  sandbox (`bwrap` NETLINK_ROUTE denial); unchanged runner retried with
  the required host permission as 007. Sage 008 failed when serializing
  a preparsed Sage Integer in a JSON metadata field; conversion to
  Python int only, then 009. Snapshots, partial output and raw logs remain.
- Original 063 attempts 001–004, accepted 005 and prior pin history are
  recursively pinned. Historical runner identity labels are provenance;
  the tooling author is Codex. No proof source in the original pair changed.

Ceremony, from source3:

```sh
python3 -B tools/keygen_make_ske_chain_audit.py
python3 -B tools/job_when_available.py lean keygen_make_ske_chain_audit_063_007 Source3.KeygenMakeSkeChainAudit
python3 -B tools/job_when_available.py sage keygen_make_ske_chain_sage_063_009 check_keygen_make_ske_chain.sage Extra/c/falcon-keygen.c
python3 -B tools/keygen_make_ske_chain_batch.py generator
python3 -B tools/keygen_make_ske_chain_batch.py predecessor .build/levels_063/TOOLING_PRESEAL.json
python3 -B tools/keygen_make_ske_chain_batch.py seal
python3 -B tools/keygen_make_ske_chain_batch.py verify TOOLING_JSON_SHA TOOLING_NOTES_SHA .build/levels_064/ENTRY_PINS_064.json
```

The audit producer's first generation and reproduction ran once; do not
rerun them onto existing files. The verifier checks both original 063 pins
and this supplement, plus the predecessor closure and current audit inputs.
Process guards/seal/verify must observe the host process namespace.
Local exact-path commits only; no push, review, delegation, relay, migration
or archive import. Remaining work is the body-derived codec frame and
SkeCellWord survival of segments 1–3, then the planned codec round-trips.
