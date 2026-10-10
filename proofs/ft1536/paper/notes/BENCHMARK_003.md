# ADDENDUM 3 — benchmark comparison

Date: 2026-10-10. Scope: editorial form of the code-bound reduction paper.
Starting paper commit: `4ac46f50fa321d6e774dafc23f8f275d0ff8e5d2`.

## Exact benchmarks read

1. `/home/footfalcon/Pobrane/FT1536_specyfikacja_v0.2.pdf`
   (*FT1536: Full-Ternary-Secret Signatures over a Degree-1536 NTRU Ring*,
   Draft 0.2, 19 September 2026; 33 pages).
   SHA-256: `9f225d3d7ba2465d65c90a81f7f5a6417262ddf1334460c57485e1d672e15494`.
   Read via pdftotext; title/abstract pages rendered with pdftoppm.
   Relevant sections: 1.5, 3.1–3.7, 6.7, 7, Appendix B.
2. `proofs/ft1536/background/MIMO_FAMILY_CORRECTIONS_RUN_003_2026-09-22/CANDIDATE_R2/paper/main.tex`.
   SHA-256: `37d373395e1da1ed37d00ea4612b74405f56fa34bbb3ecc284a04f7da8551537`.
   Byte-identical archived copy:
   `proofs/ft1536/stages/FT_FAMILY_CORRECTIONS_REVIEW_RUN_001/inputs/subject/inputs/bootstrap/CANDIDATE_R2/paper/main.tex`.
   Read in full; relevant features: status macros, the explicit
   “Validation (not a proof)” paragraph, evidence classes, artifact paths.

These are form benchmarks. Neither supplies a new theorem, number, source
binding, reference or status to this reduction paper. Historical source
commits printed in the specification are not the current paper snapshot.

## Acceptance matrix

| Benchmark property | Application in this revision | Check |
|---|---|---|
| Publication title and abstract | Signed Free FT title; concise abstract distinguishing conditional mathematics from local source binding | Read text + title-page render |
| Snapshot in the document | Full evidence-manifest hash on first page; full base/package/status commits and selected artifact hashes in Appendix A | Generate from verified manifest; check extracted PDF |
| Fixed/proved/open distinction | §1.2 “What is fixed, proved, and still being analyzed” | Existing C01–C21 scope map |
| Evidence and limitations | §11 evidence-class table and honesty ledger | Cross-reference and scope review |
| Artifact bindings | Appendix A identity, reader map, exact root-relative commands, release boundary | Hash checks + clean build |
| Consistent typography | Shared status macros; bounded floats; numbered tables and formal environments | Log diagnostics + visual inspection |
| Validation language | Explicit “Validation (not a proof)” at measurement, evidence and reproduction paragraphs | PDF-text presence check |
| Algorithms and laws | Source-order KeyGen synopsis; reference Sign with terminal emission failure; coefficient Verify | Read C gates and pinned PublicSimulation definitions |
| Bibliographic restraint | No additions; metadata checking distinguished from the pending primary-source survey | §10 and source map |

## Corrections disclosed during the comparison

- The previous abstract said every mathematical statement was already
  code-bound. That overstates the open realization; corrected to conditional
  reduction plus scoped source results.
- The KeyGen box placed solving before the public-key computation and
  duplicated gates. The existing `Extra/c/falcon-keygen.c` order is now
  respected, including terminal serialization failure.
- The Sign box did not specify terminal failure of `emit`; the pinned
  reference law emits once after the capped trial, without retrying emission.
- A partial tape-variable rename left `N` in the bound but `n` in the law
  and uniform space. Both are now `N`; no theorem is strengthened.
- B1.06 nonzero evaluations are a conclusion, not an incoming `f != 0`
  premise; explicit entry assumptions are retained in the description.
- A budget record has more fields than `(q_s,q_h)`; the notation table now
  names these as its query-count fields.
- The earlier notes overstated the bibliography work as primary-source
  inspection. The text now accurately calls it metadata/context work.

These were manuscript defects, not counterexamples to the pinned proofs.
No C or Lean source is edited in this lane.

## Verification

Pending at midpoint: manifest capture of four existing B1 batch files and
the document-snapshot configuration; clean build; PDF visual checks;
immutable final receipt and exact-path local commits. Final outcome will
be appended below, preserving this recoverable midpoint.

## Final outcome

**DOCUMENT_CHECK_PASS**, 2026-10-10. All matrix features are present in
the 28-page revised draft. `make check`: 117/117 source pins, 21 claim
groups, 12 rendered snapshot identities, all formal environments numbered
and referenced; clean TeX/BibTeX logs. Visual comparison and spot-checks
are recorded in PAPER_WORK_STATE, Batch 6. The preserved failed build
exposed layout/label issues, which were corrected without suppressing
diagnostics. The original 112 evidence pins remain byte-identical.

Immutable receipt: `notes/BENCHMARK_003_RECEIPT.json`, SHA-256
`1f1761a544c1430c1a4bf42f58d322af780eeab23f68481c69944db013f0c847`.
It binds 26 manuscript/build-source files and retains the final PDF and
logs under `build/receipts/BENCHMARK_003_RECEIPT/`.
PDF SHA-256: `c1c3497320e69d45195a50e168e6eb384cd4fcafc324fa88a9ad9c60e22a05ea`.
No publication or mathematical acceptance follows from this form check.
