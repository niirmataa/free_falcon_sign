# Paper v0.1 — window 1

Status: WINDOW_1_COMPLETE / DRAFT_V0_1_FOR_OWNER_REVIEW. Date: 2026-10-06.
Current handoff: **Batch 3 below**, incorporating the late independent
REVIEW_003; it supersedes Batch 2's input/PDF pins and pending-review status.
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

## Owner decisions

1. **Title: DECIDED 2026-10-07** — "Free FT: Ternary Lattice Signatures
   with a Code-Bound Security Reduction" (owner: "będzie sztosowe").
   Applied to `main.tex` title + `pdftitle`; the OWNER-TITLE todo is
   resolved and removed.
2. Mission paragraph: **DRAFTED 2026-10-07** from the owner's framing
   ("po co powsta\u0142 FT1536?" = the paragraph answers why FT1536
   exists). Awaiting the owner's signature or rewrite (OWNER-SIGN todo).
3. **Venue: ePrint DECIDED 2026-10-07** by the owner. Follow-up venue
   (TCHES/CHES vs Eurocrypt) left open until closure.

## Batch 2 — completed draft and checks

- **18-page English article**, `build/main.pdf`; exactly 11 sections and
  Annexes A/B, with bibliography and visible CLOSED/IN-FLIGHT/OPEN labels.
- Full first drafts: sections 2–6, 8–9 and Annex A. Section 1 has the draft
  introduction and one restrained mission paragraph; section 7 has the
  method, C/model findings and a pinned REV10 snapshot, with final B1 stub.
- Section 10 has a literature-review stub with explicit follow-up items;
  section 11 contains the full draft honesty ledger and conclusion.
  Annex B is an origin-material stub without unverified historical dates.
- `SOURCES.md`: C01–C20, exact paths/declarations/receipt names and scope
  reconciliations. `SOURCES.sha256`: **97 input pins**. This includes the
  corrected computational package, archived dependencies, S06 review,
  original runtime evidence and the paper's display-calculation receipt.
- B1 source snapshot: REV10 certificate `29e6372b` plus its batch record
  `d5ced420`. Later source3 work on shared main is not silently promoted
  into this snapshot's paper claims; final progress remains a named stub.

### Verification actually performed

- `make numbers`: standard preparser invocation of a byte-identical runtime
  copy of `tools/check_numbers.sage`; exact `QQ`/`ZZ`; exit 0. Receipt:
  `build/numbers/run_001/RECEIPT.json`; result `numbers.json` in that directory.
  Reproduces S06 table displays/minima, probe counts/rounding, the separately
  archived Falcon padded-size macro, and the displayed geometric witness.
- Final `make check`: **PASS**, 97/97 pins, all 20 source IDs mapped,
  section/annex structure correct, display rows matched, corrected review's
  input hashes/role flags matched, final TeX/BibTeX logs clean. No undefined
  references/citations, warnings, overfull or underfull boxes.
- Results: `build/CHECK.json`, `build/final_001.stdout.log`,
  `build/final_001.stderr.log` (empty). Visual spot-check of title,
  mathematics, security table and ledger pages completed.
- Retained typesetting attempts: `build/draft_002..006.*.log`. Attempts
  003/004 exposed a URL-macro/math-mode incompatibility; restored the
  ordinary code macro and fixed line layout. These are document-build
  failures, not mathematical counterexamples. The final build is clean.
- No new Lean replay or independent mathematical review is claimed by this
  paper task. Sage here verifies display arithmetic, not S06 hardness.

### Batch 2 pins (SHA-256; superseded by Batch 3 below)

| Artifact, relative to paper/ | SHA-256 |
|---|---|
| `SOURCES.md` | `d9ce3fcb82a5c9fad4197610625679d43e4699fd7be21a71c9226f6505e62c0a` |
| `SOURCES.sha256` | `2ccfcefaac6338106983dfa9b9fccf237161de153db8e33a3595dbbe7bf88e93` |
| `build/main.pdf` | `dacbcd55e212ba4a1b5f81418e98084b12cda02057ebff80f1a616c56d7123ab` |
| `build/numbers/run_001/RECEIPT.json` | `df95a4f9aa56c05e9c28aaea919a61564eb6ecc2f3f7234caaa10dc0e8e8c714` |

PDF pin identifies this completed build; later typesetting may change PDF
metadata. The source pins identify the cited mathematical/evidence snapshot.
Runtime products are intentionally under the ignored persistent build/.
Annex A records the outstanding public-release archival availability of
ignored work/.build receipts instead of asserting that a Git clone has them.

### Ocena i przekazanie dla właściciela (PL)

Powstał kompletny szkic v0.1 do czytania: matematyczny rdzeń, negatywne
twierdzenia, metoda wiązania kodu, znalezione błędy oraz podwójna deklaracja
liczb są opisane z identyfikatorami źródeł. Księga ograniczeń jest w treści.
Najważniejszy wynik redakcyjny: artykuł wyraźnie rozdziela udowodnioną
warunkową redukcję i publiczną grę obliczeniową od jeszcze niezamkniętego
mostu do realnego Sign. Zapisanie artykułu nie zmienia statusu dowodów.

Jawnie w locie/otwarte: strzałki 1–2, rzeczywisty AttemptShape i cztery
PointwiseStageRoad, B1.10, globalne A3/A4, konkretny koszt/klasa testów,
S06, niezależny odbiór poprawionego pakietu, literatura i materiał pochodzenia.
Nie ukryto wariantu e2<2^-17 ani faktu, że REVIEW_002 jest AUTHOR_RECHECK.
Pozostałości te są brakami dowodowymi/zakresowymi, nie wynikiem kompilacji PDF.

Następny krok: decyzje właściciela o **tytule, akapicie misji i docelowym
miejscu publikacji**, potem aktualizacja konkretnych TODO po dostarczeniu
odpowiednich wyników B1/S06. Materiał marcowego dysku do Annex B pozostaje
oczekującym wejściem. Własne źródła zapisane lokalnie na main; brak push.

## Batch 3 — explicit late review update

Immediately after commit `8b98cd39`, the final source check detected a
concurrent change in the pinned `B4_SYNTHESIS.md`:
`d59399c6a31c09e008dd25322bd87ace86f6554c097d8b5b39a275210aafa04a`
became `c296da9787f19ab5de2fc740a0e0f4adc7a4f6843eb0a72fd03f362239b69437`
in commit `9b12f04e`. The earlier snapshot remains in the paper commit.

Read the newly delivered REVIEW_003 and its machine result. It is an
independent fresh-context PASS_SCOPED for the corrected public-simulation
package, with the same source pins; REVIEW_002 remains AUTHOR_RECHECK.
Section 9, Annex A and source map were updated explicitly. Added nine
evidence pins; total **106**. No theorem or remaining honest-Sign premise
was strengthened. The synthesis heading's 2026-10-07 date differs from
the review/result and commit dated 2026-10-06; original bytes are preserved.

The subsequent synthesis clarification `be610737` pins the final one-time
archive import/tag decision; its final source hash is
`700b447eab357ad560b4b94eb59bbb5c91f567da0606e9bb9b978f6cb27f0193`.
The source3 live checkpoint also changed to its completed stage-(b) account
(`a83e83c659b90eb73c8867560c4de9cbf801bc0c473ce8affcaa1ba2a734818b`).
Both diffs were read: the quoted REV10 facts are carried in §5, row/layout
laws remain open, and no new R2 theorem is claimed by the paper.

Final rerun: **PASS**, 106/106 pins, 20 source groups, **19 pages**,
clean TeX/BibTeX logs. Logs: `build/final_002.stdout.log` and empty
`build/final_002.stderr.log`; updated `build/CHECK.json`.
The already-passed numerical calculator inputs did not change; its original
run_001 receipt remains the numerical evidence.

Current manifest SHA-256:
`c28edbd00cb630e6c58f0e20f7ebbbbc042eee097725851ae165f8bb3308dfb4`.
Current PDF SHA-256:
`2d794bb2b5576c2023293af206e7201035c1ccf456651733867ebdac0cf86789`.

Aktualizacja dla właściciela: niezależny odbiór poprawionego B2/B5 jest już
odnotowany w artykule. Nadal dotyczy gry publicznego symulatora; strzałki
1–2, konkretna realizacja i końcowy montaż pozostają otwarte. Lista trzech
decyzji redakcyjnych właściciela nie zmieniła się.
