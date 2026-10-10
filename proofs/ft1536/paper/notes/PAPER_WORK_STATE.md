# PAPER — live work state

Current: **ADDENDUM_3_COMPLETE / DOCUMENT_CHECK_PASS**, 2026-10-10.
Final handoff: **Batch 6 below**; 28-page PDF, 117 evidence pins,
21 claim groups. Immutable receipt: `notes/BENCHMARK_003_RECEIPT.json`.
Starting paper version: 0.3 at `4ac46f50`; mathematical/status snapshot:
`915178a1` (BATCH_048). Owned scope: `paper/**`, local exact-path commits,
no push. Title, mission and ePrint venue are decided; the form benchmark
is recorded in `notes/BENCHMARK_003.md`.

## ADDENDUM 3 — recoverable midpoint

- Both requested benchmarks read; PDF text and two rendered pages retained
  under `build/benchmark_003/`; exact benchmark hashes in BENCHMARK_003.md.
- Abstract, fixed/proved/open overview, common status macros, §11 evidence
  classes and Appendix A artifact bindings drafted. Signed mission retained.
- Existing source re-read to correct KeyGen gate order and terminal Sign
  emission semantics in the pseudocode. Also fixed partial tape-variable
  rename and B1.06 premise/conclusion phrasing; no new proof or changed code.
- In-PDF snapshot generator and document checks drafted; not yet accepted
  by a build. Intended inputs: 117, adding the existing BATCH_032/048 pairs
  and `sources/DOCUMENT_SNAPSHOT.json` to the previous 112.
- Remaining: verify/capture the added pins, run clean TeX/BibTeX checks,
  inspect rendered title/math/tables/algorithms/ledger/bindings, retain
  immutable receipt with source/PDF hashes, and commit reviewed exact paths.
- B1.05/B1.06 scopes and NOT_REVIEWED status retained; B1.07 partial,
  S06 uncertified, attempt-shape choice and A3/A4 open, no QROM claim.

## Historical window-1 handoff (retained)

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
2. Mission paragraph: **SIGNED by the owner 2026-10-07** ("idealna
   wersja do paperu i do serca"). EN text in `sec_01_intro.tex`; PL
   original (the heart version):
   "FT1536 powsta\u0142 dlatego, \u017ce zaufanie do oprogramowania
   podpisowego powinno bra\u0107 si\u0119 z argumentu, kt\u00f3ry ka\u017cdy
   mo\u017ce sprawdzi\u0107 \u2014 nie z autorytetu tego, kto skompilowa\u0142
   binark\u0119. Rodzina ternarna w rodowodzie Falcona \u2014 wolna w wyborze,
   wolna w audycie, wolna w u\u017cyciu \u2014 dla ludzi, kt\u00f3rzy chc\u0105 sami
   wybiera\u0107 i ocenia\u0107 swoje narz\u0119dzia kryptograficzne."
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

## Batch 4 — window 2: publication-form pass + B1 stage-status update

Date: 2026-10-10. Window rule: one stage per window; this window is the
paper's editorial/status stage, closed at its own checkpoint below.
Owner brief: expand v0.1 to a professional publication form (abstract,
introduction, contributions, notation, theorem environments, coherent
editing of all sections and annexes), update statuses to the current
repository state, keep every sentence within the pinned claim boundaries.
Identity decisions (title, signed mission, venue ePrint, "Pornin in form,
us in substance") were already closed and were not altered. No logo.

### What was done

- **Abstract** rewritten in dry form: conditional reduction, computed
  $e=k^{32}-1<2^{-32}$ (unconditioned) and $e<2^{-17}$
  (acceptance-conditioned) with the shape named an open obligation,
  computational theorem with admitted test class and cost certificate,
  negative results as theorems, defects found by the verification
  process, in-flight honest hop/law bindings, two-level security
  accounting with system = minimum, no end-to-end and no QROM claim.
- **Introduction** restructured: motivation, why reduction for real code,
  an explicit four-item contribution list (computed-e reduction;
  source-binding method with kernel counterexamples; two-level security
  declaration; negative results as theorems), the owner-signed mission
  paragraph preserved byte-identical, a scope paragraph, and the section
  roadmap.
- **Notation** added as §3.1 (symbols, laws, advantages, error terms,
  status labels, source identifiers); theorem environments made
  consistent: theorem/proposition/lemma share one counter, definitions
  and target statements separated, remark style reserved for remarks.
  The directional second moment is now a definition; adaptive
  composition and stopping loss is now a lemma. No mathematical content
  was changed by these moves.
- **Statuses updated to the current repository state** (new claim group
  C21, section 7.3 "Stage status of the source-to-law campaign" and the
  section-11 ledger row):
  * B1.05 **closed** — `KeygenCallerSuccess.exact_integer_ntru`: caller
    entry through the complete root call gives $f,g,F,G$ with bounds
    1/1/2047/2047, the exact integer equation $f\cdot G-g\cdot F=q$
    (coefficient quotient), output-slot representations; modular check
    consumed with residual $37748737<2147355649$ (BATCH_032).
  * B1.06 **Acceptance met** — `KeygenPublicAccepted.source_same_material`:
    the successful fixed public computation on the same retained $f,g$
    bytes with $f\neq0$ gives canonical $h$ and mathematical
    $\mathrm{fInv}\in R_q$ with both equations $h\cdot f=g$ and
    $\mathrm{fInv}\cdot f=1$; no correctness/invertibility premise
    (BATCH_046).
  * B1.07 **in progress** — partial proof, Acceptance not met, not
    reviewed; RNG-readiness and first-sampling boundaries derived;
    enclosing invocation/control, loop chronology with the cap, the
    six-gate accepted attempt and the material-to-encoding transport
    remain (BATCH_047/048 checkpoint state).
  * Scope notes are explicit in the text: none of this is a claim about
    the whole KeyGen loop, termination or key/emitted laws; deterministic
    traces license no IID, $p_{\mathrm{accept}}$ or availability formula;
    every stage is NOT_REVIEWED. Arrows 1–2 stay open.
- **"The verification found bugs"** kept as section 7.2 with F-001 and
  the model/parser defects, extended by a "What the traps teach" lesson
  paragraph (names and comments masking different mathematical objects;
  executed calls versus intended calls; retained failed attempts).
- **Related work** (§10) declares itself a stub in bold: the bibliography
  contains only the three inspected primary sources; a real literature
  scan is an explicit obligation before ePrint; no citation is asserted
  in advance. No invented citations anywhere.
- Unchanged by design: S06 rows keep their uncertified/CHANGES_REQUIRED
  labels at text and numbers; the two attempt shapes keep their separate
  exponents and the B1-ATTEMPT-SHAPE todo; the A3/A4 byte bridge stays
  outside the proof and in the ledger; no QROM claim; the honesty ledger
  stays in the body; family profiles stay ALTERNATIVE_PROPOSAL.

### Verification performed in this window

- `make numbers` was not rerun: its pinned inputs are unchanged, so the
  existing `build/numbers/run_001/RECEIPT.json` remains the numerical
  evidence (checked by `make check`, which verifies those input hashes).
- Final `make check`: **PASS**, 112/112 pins, all 21 source IDs mapped,
  11 sections + 2 annexes, **21 pages**, clean TeX/BibTeX logs, no
  undefined references, no overfull/underfull boxes. Two overfull lines
  caused by unbreakable qualified identifiers were fixed by layout (break
  opportunities at the name dot), not by weakening any check.
- Pin drift since Batch 3 was handled explicitly: `KEYGEN_RESIDUE_CHECKPOINT.md`
  and `B4_SYNTHESIS.md` changed on disk; both diffs were read before
  repinning (SOURCES.md reconciliation items 12–13). The parallel B1 lane's
  BATCH_048 closing commit `915178a1` landed mid-window with byte-identical
  checkpoint content; all 112 pins were re-verified after it.

### Window receipts (SHA-256)

| Artifact, relative to paper/ | SHA-256 |
|---|---|
| `SOURCES.md` | `c8ed9ffcf335512f57c892eb28c38f3b81803559a7b946c359239187c5fd4f81` |
| `SOURCES.sha256` | `1a43c286d7a49b7e62c47228c62e154fb8decb8248c91520c79d6ad85a0ece66` |
| `build/main.pdf` | `2df28d2d5cd4661dbfd66559a78c1fc31962d5f1d3b3802f579dfee40e510a43` |
| `build/CHECK.json` | `8c4148a568d9265edba90f07226aa7b1641f90a0ebff9ac9100c7399a21e939e` |

PDF pin identifies this publication-form build (version 0.2,
10 October 2026). The source pins identify the cited evidence snapshot
(112 inputs, six of them new: `KeygenCallerSuccess.lean`,
`KeygenPublicAccepted.lean`, BATCH_046/047 pairs). Runtime products stay
under the ignored `paper/build/`.

### Ocena i przekazanie dla właściciela (PL)

Artykuł jest teraz w formie publikacyjnej: profesjonalny abstrakt,
wprowadzenie z jawną listą kontrybucji, sekcja notacji, spójne
środowiska teoremów i przejrzana redakcja wszystkich sekcji oraz
aneksów — bez żadnego nowego twierdzenia poza stanem pinów. Statusy
odzwierciedlają repozytorium: B1.05 zamknięte z dokładnym równaniem
całkowitym f·G−g·F=q, B1.06 z Acceptance (h = g·f⁻¹ plus oba równania,
fInv matematyczny), B1.07 w toku. Przy każdym statusie stoi nota
zakresu: to nie jest twierdzenie o całym KeyGen, terminacji ani rozkładzie
kluczy, i nic nie jest opisane jako niezależnie zrecenzowane. Wyniki
negatywne pozostają teoremami, deklaracja poziomów pozostaje podwójna
(kratka diagnostyczna + kapsel Grover, system = minimum) z etykietami
S06, e2 zależy od ksztaltu próby, most A3/A4 pozostaje poza dowodem, brak
roszczenia QROM, a related work jest jawnym TODO pod skan literatury.
Pod względem dowodowym okno nie zmieniło żadnej tezy: to redakcja i
wierny zapis statusów. Ryzyko „wygładzenia" ostrzeżnych zdań było
kontrolowane zdanie po zdaniu; wszystkie zachowano.

Jawnie otwarte: strzałki 1–2 (uczciwy hop + wiązania praw), realizacja
kształtu próby (e2), B1.07–B1.10, globalne A3/A4, S06 i kampania rodziny,
niezależny odbiór, skan literatury, materiał marcowego dysku do Annex B.
Własne źródła zapisane lokalnie na main małymi commitami z dokładnymi
pathspecami; brak push.

Następny krok: decyzja właściciela o odbiorze tej formy; po domknięciu
kolejnych etapów B1 aktualizacja §7/§11 i todo B1-FINAL, a przed ePrint
prawdziwy skan literatury i materiał pochodzenia do Annex B.

## Batch 5 — window 3: ADDENDUM form pass (classical crypto paper form)

Date: 2026-10-10. Owner addendum: professional crypto-paper form
("Pornin in form"), standard = Falcon paper / Fouque et al. Content and
statuses unchanged: scope notes, labels and number honesty preserved;
the form grows, the theorems do not. One stage per window; this window
is the form stage, closed at this checkpoint.

### Skeleton (now)

Abstract; 1 Introduction (contributions + full roadmap); 2 Preliminaries,
notation and threat model; 3 The FT scheme (parameters, algorithms,
encoding); 4 Main statement (end-to-end thesis + conditional theorem);
5 The classical reduction; 6 Sampler analysis and negative results;
7 Binding to the implementation; 8 Security accounting; 9 The
computational interface; 10 Related work; 11 Limitations, open work and
conclusion (honesty ledger); **References (BibTeX); then Appendices A/B**.
File layout kept (sec_03_model now typesets §2, sec_02_parameters §3);
section numbering follows the classical order in `main.tex`.

### What was added (form only)

- **Notation table (Table 1)** right after the preliminaries prose:
  f, g, F, G, h, fInv, q, n, N, NTT/evaluations, Q, B, A_h, reduce/
  center, mu_K/mu_H, beta, AC/second/chi2/TV, e, e2(k), k, eps_coll,
  delta_PRG, Phi, psi_D, advantages. Numeric instantiations point to
  Section 3 and the source map.
- **Family parameter table (Table 2)** in Falcon Table-1 style for
  768/1536/3072. Only pinned quantities are filled (FT1536: q=18433,
  bounds 1/2047, cap 16, measured p_accept 0.34671, B and KeyGen cap as
  labeled configuration values). Unpinned cells are dashes; **FT byte
  sizes are not invented** — the caption records that the only pinned
  size fact is the Falcon-512 PADDED 666-byte format.
- **Algorithms 1-3 (boxed):** KeyGen (ternary f,g, solver fG-gF=q,
  recorded acceptance gates, public computation h=g/f), Sign (challenge
  framing, cap-16 attempts, signed-16 emission), Verify (coefficient
  predicate). Each box restates pinned interfaces (C02/C03/C05) and is
  followed by its scope: derivation status = Section 7.3 ledger, realized
  attempt shape open, termination/emitted law/byte framing outside
  (Assumption A3/A4, Section 11).
- **Formal environments:** numbered Definition / Assumption / Theorem /
  Lemma / Corollary / Remark with a shared per-section counter and
  cross-references; every theorem-like statement now carries a label and
  is cited in the body (Prop. 2.2, Thms. 4.2/4.3/6.4-6.7, Lem. 5.1,
  Cor. 4.4, Props. 6.1/6.3, Thm. 9.x). A1-A5 became Assumption 2.4-2.7
  (verbatim content); ShortPreimage and the MT-ISIS experiment became
  definitions; the k=1 scope test became Corollary 4.4 (verbatim).
- **End-to-end thesis highlighted** (mdframed Target statement 4.1) and
  explicitly kept as a TARGET, not a theorem: the text in front of it
  states that the highlight marks centrality, not proof status.
- **Security table** became a numbered float (Table 3) with a caption
  keeping the proxy/no-certification labels.
- **BibTeX: only real, verified entries.** Added `falcon2018` (FALCON
  NIST submission; provenance note in EXTERNAL_REFERENCES.md: no separate
  2018 proceedings paper was identified, so the submission document is
  cited), `hps1998` (NTRU, ANTS 1998, LNCS 1423, 267-288), `gpv2008`
  (STOC 2008, 197-206), `lyu2012` (EUROCRYPT 2012, LNCS 7237, 738-755),
  `dilithium2018` (TCHES 2018(1), 238-268), `fktwy2020` (Gram-Schmidt
  key-recovery, EUROCRYPT 2020, LNCS 12107, 34-63). All six were checked
  against public bibliographic metadata on 2026-10-10 before citing.
  Related work stays a declared TODO stub; uncertain items (e.g. the
  full GPV-version history, verified-compiler comparisons) remain TODO,
  not citations.
- Notation coherence: the tape length is now $N=q_s\cdot S.\mathrm{bits}$
  so that $n$ is the ring dimension (the quantity is unchanged).
- Class/layout: `article` with the crypto-standard packages (amsthm,
  algorithm/algpseudocode floats, booktabs, hyperref); no logo.

### Discipline check (unchanged content)

No new mathematical statement; every pre-existing sentence kept its
scope. S06 rows keep CHANGES_REQUIRED/uncertified labels; the two e2
exponents stay shape-labeled with the B1-ATTEMPT-SHAPE todo; A3/A4 stays
outside the proof; no QROM claim; family profiles stay
ALTERNATIVE_PROPOSAL; the honesty ledger stays in the body; REVIEW_002
stays AUTHOR_RECHECK. All required todo keys (B1-HONEST-HOP, B1-LAWS,
B1-ATTEMPT-SHAPE, S06-CERTIFICATE, ORIGIN) remain in the text.

### Verification performed in this window

- Final `make check`: **PASS**, 112/112 pins, 21 source IDs, 11 sections
  + 2 annexes, **23 pages**, clean TeX/BibTeX logs, no overfull/underfull
  boxes, no undefined references/citations. One family-table overfull was
  fixed by tightening the float, not by weakening any check.
- `make numbers` not rerun: pinned numerical inputs unchanged;
  `build/numbers/run_001/RECEIPT.json` remains the numerical evidence.
- Bibliography check: `build/main.blg` clean; all nine entries real and
  metadata-verified; provenance in `sources/EXTERNAL_REFERENCES.md`
  (rehashed in this revision).

### Window receipts (SHA-256)

| Artifact, relative to paper/ | SHA-256 |
|---|---|
| `SOURCES.md` | `3741e4e8d9887db68b0e9984d647fca4c8beff37b488ac600437f3c000c54abd` |
| `SOURCES.sha256` | `35319f887a2365849eff00eba6c54ad81b5064d8172351e76e0a6a7a99322101` |
| `build/main.pdf` | `fa32447f9d3b00177b7d35d61461f67f775f2c9dbdd692e2352639b27986d8ce` |
| `build/CHECK.json` | `3b67eb8ca40ab5883b04cfa2cf69b6b2d2eb6d65dad78554221a106654fdbc02` |

PDF pin identifies the version 0.3 publication-form build
(10 October 2026). The 112-input evidence snapshot is unchanged except
the rehashes of `refs.bib` and `sources/EXTERNAL_REFERENCES.md`.

### Ocena i przekazanie dla właściciela (PL)

Paper wygląda teraz jak klasyczny kryptograficzny artykuł: kolejność
sekcji zgodna ze szkieletem, tabela notacji zaraz po preliminariach,
tabela parametrów rodziny w stylu Falcon Table 1, trzy algorytmy
w pudełkach, pełne środowiska formalne z numeracją i cytowaniami,
teza główna wyróżniona (ale wciąż jawnie jako cel, nie twierdzenie),
referencje przed aneksami. Bibliografia urosła wyłącznie o prawdziwe,
zweryfikowane pozycje (NTRU, GPV, Lyubashevsky, Dilithium, key-recovery,
FALCON); niepewne rzeczy zostają TODO pod skan przed ePrint — nic nie
zmyślono. Treść i statusy są dokładnie te same co po oknie 2: B1.05
zamknięte, B1.06 z Acceptance, B1.07 w toku, wszystkie etykiety i noty
zakresu nietknięte, S06 nadal niecertyfikowane, e2 nadal zależy od
kształtu próby, A3/A4 poza dowodem, brak QROM.

Czego świadomie nie zrobiłem: nie wypełniłem rozmiarami kluczy tabeli
parametrów (brak pinów — są kreski zamiast zmyślonych liczb), nie
dodałem „porównywalnych gwarancji" do cytowanej literatury i nie
zamieniłem tezy end-to-end w twierdzenie mimo sugestii „THEOREM" —
to byłoby naruszenie zakresu. Własne źródła zapisane lokalnie na main
małymi commitami; brak push.

Następny krok: odbiór formy przez właściciela; przed ePrint prawdziwy
skan literatury (TODO w §10) i materiał do Annex B; przy domknięciu
kolejnych etapów B1 — aktualizacja §7/§11 i todo B1-FINAL.

## Batch 6 — ADDENDUM 3: benchmark-form revision complete

Date: 2026-10-10. The recoverable midpoint above was committed as
`8bbe8c07`. Form benchmarks and their exact hashes are recorded in
`notes/BENCHMARK_003.md`. The server restart did not reset the task.

### Delivered

- Revised publication abstract, signed title/mission retained, ePrint
  preparation identified. The abstract now correctly separates the
  conditional reduction from the scoped source results.
- §1.2 **What is fixed, proved, and still being analyzed**; shared
  `\OPEN`, `\CLOSED`, `\INFLIGHT`, `\UNCERTIFIED`, `\NOTREVIEWED` and
  `\ALTP` macros; measured/computational checks explicitly marked
  **Validation (not a proof)**.
- §11 **Evidence and limitations**, evidence-class Table 4 and numbered
  honesty-ledger Table 5. The local B1 and global A3/A4 boundaries remain
  explicit; S06 is UNCERTIFIED beside the security table itself.
- Appendix A **Artifact bindings and reproducibility**: full Git
  identities, full manifest/source-map SHA-256 hashes, seven selected
  artifact hashes and paths, reader's map, exact root-relative check,
  and the local-runtime/public-release availability distinction.
- Full manifest identity on the first page. `make pdf` verifies the
  manifest before generating `build/snapshot.tex`; checking never
  refreshes pins. The completed receipt additionally verifies that all
  12 selected identifiers actually appear in the rendered PDF.
- Formal environments are numbered and cross-referenced; algorithm
  floats have actual boxes. The closed conditional theorem is highlighted,
  while the unfinished end-to-end statement retains its target label.
- Manuscript corrections against existing inputs are disclosed in the
  benchmark note and SOURCES reconciliation 15–17: KeyGen gate order,
  terminal Sign emission, partial `n`/`N` rename, B1.06 conclusions versus
  premises, budget notation and bibliography-inspection wording.

### Pins and checks

The original 112 input hashes were verified unchanged before capture.
Added only the existing BATCH_032/048 pairs (compared byte-for-byte with
commit `915178a1`) and the document-snapshot configuration: **117 inputs**.
No new theorem, Lean replay, C run or independent review was performed.
The pinned Sage run_001 remains the display-arithmetic evidence; its
inputs and outputs were rehashed by the document check.

Final build: `make check`, latexmk/pdflatex/BibTeX exit 0; **28 pages**,
11 sections, two appendices, 21 claim groups, all formal statements
referenced, no warnings, undefined references/citations, overfull or
underfull boxes. `build/benchmark_003/build_004.stderr.log` is empty.
The earlier build_001 failure (repeated longtable label and four
overfull lines) is retained. Builds 002–004 also retain the layout work:
complete theorem frames, heading spacing and a fresh appendix page.

Visual inspection covered title/abstract, notation, family table,
algorithms, main theorem, S06 table, evidence ledger and artifact hashes;
the final frame and appendix layout were inspected after the last change.
The mission paragraph was checked byte-identical to `4ac46f50`.

Sealing command, from `paper/`:

```sh
python3 -B tools/check_paper.py --receipt notes/BENCHMARK_003_RECEIPT.json
```

This immutable JSON contains hashes of **26 manuscript/build-source
files**, the PDF and retained logs. Its PDF/log/snapshot copies are in
`build/receipts/BENCHMARK_003_RECEIPT/`; later routine checks may update
`build/CHECK.json` but do not alter this receipt or those copies.

| Artifact, relative to paper/ | SHA-256 |
|---|---|
| `SOURCES.md` | `fba85f1b6c110c0645c96974529f6f098c2cdd27bb26273f03f3cc21acfcffbc` |
| `SOURCES.sha256` | `fcff384d354517f0a0b6929fd52b1523e43ae980aaba6be14d4453f617679331` |
| `build/main.pdf` | `c1c3497320e69d45195a50e168e6eb384cd4fcafc324fa88a9ad9c60e22a05ea` |
| `notes/BENCHMARK_003_RECEIPT.json` | `1f1761a544c1430c1a4bf42f58d322af780eeab23f68481c69944db013f0c847` |

Source commits: `c4b40b17` (snapshot machinery, scoped abstract and
artifact bindings), `b0ef2086` (manuscript, algorithms and checks),
following midpoint `8bbe8c07`. Exact paper-only pathspecs, author
niirmataa, local main; no push. Foreign staged/working changes were
preserved. The closing receipt commit follows this entry.

### Ocena i następny krok (PL)

Kryteria formy wskazanych benchmarków zostały wdrożone: tekst prowadzi
od ustalonych obiektów przez twierdzenia do jawnych braków, a sam PDF
identyfikuje snapshot i źródła. Istotna poprawa dotyczy także precyzji:
usunąłem nadmierne zdanie o pełnym code-bindingu i błędne skróty
pseudokodu. Były to błędy redakcyjne poprzedniej wersji, nie wyniki
przeciwko przypiętym dowodom. Zakres matematyczny nie urósł.

Otwarte pozostają: realizacja uczciwego Sign i kształtu próby, prawo
kluczy, końcowy most A3/A4, S06, literatura i materiał pochodzenia.
Następny krok publikacyjny to rzeczywisty skan źródeł literaturowych;
kolejne wyniki B1 wymagają osobnej, przypiętej aktualizacji statusu.
