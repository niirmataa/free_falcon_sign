# Internal batch005 — entry fragments and complete conversion calls

Package status: **IN_PROGRESS / NOT_REVIEWED**.
Receipt `KEYGEN_SOURCE_TO_FIBER_001_BATCH_005.json`, SHA256
`225b5b435dc2606431fd5ecf2ed61a68b4cde6686958cc03a3c9cf20f92f613d`.
Fresh replay:19/19 clean,32 type/term/axiom audits,38.071s,
maxRSS2873544KiB. Axioms are standard Lean axioms or none.

## Checked scope

- CertificatePrologue, CertificateDeclarations and CertificateAliases bind
  source7695--7702 and7705--7716, including MKN, the actual guard and all
  eight pointer assignments. Their explicit scalar-entry model is retained
  in the export types; the general invocation entry is a following step.
- C99ArrayReference now has a typed16-bit load with the actual C integer
  promotion. The complete changed descendant closure passed26/26 in
  `keygen_narrow_array_closure_001`; its receipt pin is in WORK_STATE.
- SmallintsProgram binds the complete source body and signed16 header.
  SmallintsPrelude derives n, counter0 and the full1536 conversion loop
  from body execution. Callers no longer supply SmallintsConversion.Loop
  as an assumed callee contract.
- SmallintsInvocation executes that fixed body under the actual parameter
  binding and void return. Its caller frame and output-initialization
  results are kernel-derived. MknReference transports only the variables
  read by MKN, so additional globals do not become restrictions on entry.
- CertificateConversions binds the four calls at7717--7720 to that closed
  invocation relation and composes memory steps, initialization and frame.

## Remaining composition

The full function still needs one source-linked execution across its local
allocation/zero assignment, general entry, four calls, FFT/Gram/LDL prefix,
Gate00, suffix and teardown. General entry and exact final tree/t3 metadata
are being developed separately. The caller's final-attempt identity,
encodings, source modular/public/inverse equations and emitted-to-fiber
theorem remain open. No full B1 result or review is claimed.

All unsuccessful source/elaboration attempts and their raw logs remain
under `.build/jobs/`. The event-based waiter implements the owner's explicit
instruction to wait for an occupied proof slot and then continue. Sources
are checkpointed locally; publication requires an explicit owner signal.
