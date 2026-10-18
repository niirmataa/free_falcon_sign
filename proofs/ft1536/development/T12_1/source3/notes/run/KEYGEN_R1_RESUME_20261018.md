# R1 resume inspection — 2026-10-18

Status: PARTIAL_PROOF / STOP_AND_REPORT_INTEGRITY / NOT_REVIEWED.
Entry HEAD: `85a40d911561291e31086d4344d106612ddd1c99`, branch `main`.
No Lean, Sage or Lake process was present at inspection. No proof job,
source edit, push or worker was started during this inspection.

## Current mathematical state

| Owner objective | Established | Still open |
|---|---|---|
| Successful seed witness and positive whole-KeyGen mass | Source seeding/sampling, resultant and both norm gates; public conversion; constructive generator suffix; first NTT butterfly body and two invariant transport lemmas | Full first-loop execution, middle/triple NTT passes, public suffix/nonzero tests/inverse call, root solver, certificate and codecs; no full `G(seed*)` witness |
| Numerical first-attempt acceptance bound | MODE1 chunk/coefficient definitions and conditional law identities; count and first-attempt consumers | Actual SHAKE pushforward law and positive numerical acceptance bound; `8192/23628` remains measured |
| Conditional encoding and numerical whole-call bound | `KeygenFirstMass134.factorization`, `quantitative` and the model-package consumption chain | Instantiated conditional coding bound and concrete positive product |

`KeygenSuccessMass134.success_lower_of_witness` supplies `Z >= 2^-256`
once a complete emitted-packet witness exists; the premise is still open.
`KeygenModelUnlock134.package_of_witness` consumes that same witness.
The target is the corrected law134; frozen law110 and its coverage-defect
diagnosis remain historical. Five do_sign obligations and paper wording
remain unchanged.

The equivalence between positive finite-seed mass and witness existence
does not itself refute analytic proofs or compare their difficulty. The
recorded analytic route is incomplete; no impossibility result is asserted
by this resume report.

## Latest accepted, uncommitted source

`PublicTailFirst159.lean` in the working tree is byte-identical to the
snapshot accepted by `keygen_publicforward159_108`:

- Source SHA256: `e86304c894e1bfc07ca57b4937f1809f721ed6b7e439e7972b3d9e3fbf83a7b0`.
- Receipt SHA256: `7c853d608cf4edb0300ffe26563a339c6bd607d412daaf947accb2154e61dead`.
- Accepted, exit 0, clean log; stdout and stderr are both empty.
- Relative to commit `566b82d0`, the working change adds
  `firstInv_after_body` and `firstInv_next`; these are accepted transport
  lemmas, not yet a theorem that the executed body preserves all inputs
  needed for 768 successive iterations.

The live tail TODO predates jobs071-108. Its unchecked body tasks therefore
understate the implemented work. No new audit/postseal of the complete
region2 is claimed. All previous jobs remain on disk.

## Integrity result and exact cause

Saved check: `.build/public159/resume_20261018_integrity.json`.

| Manifest | Checked paths | Mismatches |
|---|---:|---:|
| public158/ENTRY_PINS.json | 55659 | 0 |
| public159/POSTSEAL_159.json | 24 | 2 |
| public159b/POSTSEAL_159B.json | 31 | 0 |
| zlower134/POSTSEAL_Z134.json | 8 | 0 |

The old159 manifest refers to earlier versions of two subsequently changed
documents. Both original byte sequences are recoverable exactly from
commit `3e735378`; their Git blob contents reproduce the expected hashes.

| Document | Old159 expected SHA256 | Current SHA256 | Change recorded in |
|---|---|---|---|
| KEYGEN_PUBLIC_FORWARD_159_REPORT.md | `3e0321c86ca71ae83909d348d1b3c799017526a170509e8cf13c035de9673bb8` | `cf8c90a0a298452d2c449dcba26fdb229b40cd528e191949ee866bcdd694dee8` | `343bf01c` |
| KEYGEN_PUBLIC_FORWARD_159_FAILURES.json | `5a9d9594c8033ec38a4fc3311a3388da42b825196fa27cf0b8cc62c383b40a52` | `8a15ee15b67abb37ce29c5d7c601e949ed7fcb58f67251e9c9eac3aa536e64b3` | `e40477f9` |

This inspection found a documentary seal mismatch, not a mismatch in the
Lean sources checked by these manifests. It does not certify every later
unsealed module. Historical manifests and documents were left untouched.

## Prepared repair, pending owner decision

1. Recover the two old byte sequences from the exact Git revision
   `3e735378` into a new durable, versioned snapshot directory, and check
   their hashes against the unchanged old159 manifest.
2. Add an explicit reconciliation receipt mapping the two old paths to
   those historical snapshots, with both old and current hashes and the
   two intervening commits; verify all other old159 paths as before.
   Do not relabel the original live-path verification as PASS.
3. Create a fresh resume checkpoint referring to that reconciliation,
   the passing158/159B/Z134 sets and accepted108 source/receipt. Preserve
   old manifests, reports, failed jobs and the uncommitted proof change.
4. Resume with the missing body-to-invariant implication, then the768-step
   induction. Use the normal guarded runner with a fresh job label; retain
   one process, clean logs, small local commits and no push.

The pause follows the repository's explicit hash-mismatch stop-and-report
rule. This is not an automatic approval rejection or a new usage-limit
failure. No repair has been applied and no full-region completion claimed.
