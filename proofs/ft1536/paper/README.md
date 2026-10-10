# Free FT — code-bound reduction paper

English `article`, revised draft 0.3 for ePrint preparation. The title,
mission paragraph and venue are owner-approved. The 11-section argument
distinguishes the conditional classical reduction, source-bound fragments,
public-game computational theorem and open honest-Sign/byte interfaces.

From this directory:

```sh
make check
```

Output: `build/main.pdf`. The build verifies all **117 selected input pins**
and generates their in-document identity before running latexmk/pdflatex.
The checker verifies **21 claim groups**, section order, formal-statement
cross-references, rendered snapshot pins, numeric displays and clean
TeX/BibTeX logs. All runtime writes stay in persistent, ignored `build/`.
These are document checks, not a new Lean replay or mathematical review.

`make numbers` separately runs `sage check_numbers.sage` with the standard
preparser and exact QQ/ZZ arithmetic. Its pinned run_001 receipt remains
the cited display evidence; repeating arithmetic is not S06 certification.
From the repository root, check the manifest with:

```sh
sha256sum -c proofs/ft1536/paper/SOURCES.sha256
```

`SOURCES.md` maps claims to declarations and receipts. The first page and
Appendix A print full snapshot hashes; `sources/DOCUMENT_SNAPSHOT.json`
selects the displayed entries. Ordinary builds never repin changed inputs.
`notes/PAPER_WORK_STATE.md` is the live checkpoint;
`notes/BENCHMARK_003.md` records comparison with the owner's two form
benchmarks. Final immutable receipts under `notes/` include manuscript
source and PDF hashes; retained PDF/log copies are under `build/receipts/`.

B1.05 and B1.06 retain their local Acceptance scopes and NOT_REVIEWED
status; B1.07 remains partial. The actual attempt shape, honest-Sign hop,
emitted-key law, global A3/A4 and S06 certification remain open. Related
work explicitly awaits a primary-source scan; Appendix B awaits the
owner's historical material. Some cited runtime evidence is local only;
public-release archival availability is an open obligation in Appendix A.
