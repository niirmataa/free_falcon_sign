# Batch073 seal supplement001 — owner-authorized audit-pin correction

The owner explicitly authorized this new supplement, preserving the frozen010
manifest, both historical audit states and the original postseal refusal.
No existing batch, manifest, receipt, erratum or failed log is rewritten.

The organizer combined the eight accepted proof results of
`keygen_decode_none_073_010` with the corrected accepted audit of
`keygen_decode_none_073_011`. The sole overlay for live-input reconciliation
is `/sources/8/sha256` of010 SOURCE_INPUTS:

- Old failed-audit source pin:
  `d818dd129d1b8aee439b4f3f12307d0b3a614cc6d236ba28f40ff4e433085301`.
- New accepted011 audit source pin:
  `dc2f54399f781ec25842eea26f5cc7adfa7955d348470443c16d63b2ad9d7cc0`.

The historical audit correction added exactly the explicit import
`Source3.KeygenDecodeNonePairs`; its old/new snapshots and exact diff hash
are pinned in the supplement. This correction already existed in011 and
commit06392f4f. This operation changes no Lean/Sage/C source or theorem bytes
and does not relabel the failed010 audit as accepted or replay010 with011.

The new verifier permits only that exact leaf, old hash, new hash and frozen
manifest hash. Every other input remains subject to ordinary exact hash
checking. The supplement records the fresh scan of all15815 entry pins and
an unchanged-source scan. Postseal includes the supplement in its closure;
ENTRY_PINS_074 may be created only after that postseal succeeds.

The mathematical status remains PARTIAL_PROOF / NOT_REVIEWED. B1.07/B1.08
Acceptance NOT MET, B1.09 OPEN; this provenance correction proves no new
round-trip or source theorem. The owner resumed the full ordered TODO after
postseal and074 entry: NONE, STATIC, same mathematical/physical transport,
public codec LAST, with one final whole-TODO report.
