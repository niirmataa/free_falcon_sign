# Paper v0.1 — window 1

Status: IN_PROGRESS. Date: 2026-10-06.
Owner instruction: `development/T12_1/run2/notes/PROMPT_PAPER.md`.
Binding outline: `documents/FT1536_PAPER_OUTLINE_2026-10-06.md`.
All paths in this paragraph are relative to `proofs/ft1536/`.
Owned output: `proofs/ft1536/paper/**`; other lanes are read-only.
Small exact-path local commits on main; publication requires owner signal.

## Batch 1

- Created the article scaffold: 11 sections, Annexes A/B, bibliography,
  visible status/TODO macros and a build confined to `paper/build/`.
- Initial repository HEAD: `29e6372b`. Existing foreign changes and empty
  staging were inspected. `/home/footfalcon/free_falcon_sign` resolves to
  the current NVMe checkout, on `main`.
- Source-location correction: the scope document is
  `development/T12_1/END_TO_END_SCOPE.md`, not `run2/notes/END_TO_END_SCOPE.md`.
- Scope reconciliation: `AssemblyComp`'s corrected exports concern public
  simulation. The real/honest Sign bridge remains open. `REVIEW_002` and
  its supplement explicitly report AUTHOR_RECHECK, not independent review.
- Next: full first drafts and exact source/claim pins, followed by PDF checks.
- Scaffold build: `make pdf`, latexmk/pdflatex/BibTeX exit 0, three pages.
  The initial long status line was shortened after an overfull-box report.

## Owner decisions needed

1. Title (current title is a conservative working title).
2. Mission paragraph / author's voice.
3. Venue target and associated formatting/bibliography requirements.
