# BATCH_063 tooling continuation — immutable seal supplement

2026-10-11, Codex. Audit and controls complete; §43R.2 seal is BLOCKED before any codec edits.
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

## Integrity stop discovered at preseal

The strict recursive check stopped on the original pair's internal notes
pin: expected `2c06bc865cc145f62334ce0f06c219b488ffebc66957f19b00a1576cea38b3a2`
(8212 bytes), current
`e71f8140c2d33af404309b6b9e26f57b1a57d22329add6e61378265dbe29a2fb`
(8330 bytes). Commit `835dfc6b` added the own-commit provenance to notes
and JSON.proof_head_note without updating JSON.notes. The exact historical
notes from `2d6735bc` match the old pin and remain recoverable in Git; a
byte-exact runtime copy and the concrete repair proposal are stored under
`.build/levels_063/INTEGRITY_STOP_001/`. All other original 063 recursive
pins match. This is evidence about artifact integrity, not a C or
mathematical counterexample. No seal or ENTRY_PINS_064 was written.

Per §43R.2, no silent correction or further codec edit is permitted.
The proposed repair records only this provenance-driven notes supersession
in a new tooling supplement/verifier, authenticates both Git versions, and
preserves the original pair. It remains unapplied pending owner decision.
The failed preseal/seal checks made no receipt or pair. The earlier local
commit `7f862f94` saves the actual audit/control tooling, not a sealed result.

## Owner-authorized resolution (before codec edits)

The owner explicitly replied: "Zatwierdzam korektę w suplemencie i
kontynuację". The new verifier authenticates historical notes at 2d6735bc
against the original JSON.notes hash/size, and current notes at 835dfc6b
against the explicitly fixed current hash/size. Only that original notes
record is replaced in the recursive walk's in-memory projection. The
original JSON and notes are unchanged. The supplement records the explicit
supersession and authorization; all other checks remain strict. The entry
incident is resolved and does not constitute a window midpoint close.
