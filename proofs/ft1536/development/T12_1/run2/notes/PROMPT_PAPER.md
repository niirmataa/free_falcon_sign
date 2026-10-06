# PROMPT — new window: paper v0.1 (the reduction paper, LaTeX from day one)

Workspace: `proofs/ft1536/`. OWN FILES ONLY: create `paper/**`
(`main.tex`, `sec_*.tex`, `refs.bib`, `SOURCES.md`,
`notes/PAPER_WORK_STATE.md` under `paper/`). Everything else READ-ONLY.
Small local commits via `git commit --only -- paper/...`; NO push (owner
signal); one Git writer at a time (parallel lanes: B1 in
`development/T12_1/source3/`, reviews in `work/`). Compile to PDF with
`pdflatex`/`latexmk` in `paper/build/` (gitignored artifacts).

**Binding contract:** `documents/FT1536_PAPER_OUTLINE_2026-10-06.md` —
the 11 sections + 2 annexes, with CLOSED/IN-FLIGHT/OPEN tags. The outline
is the structure; this prompt is the style.

## Style — "Pornin in form, us in substance"

- **Form (crypto-academic, dry):** English, `article` class, ePrint-ready.
  Every mathematical claim mirrors a theorem/statement EXACTLY as it
  exists in the code — no aspirational strengthening. Every number is
  traceable via `SOURCES.md` (mapping: paper statement -> repo path +
  lemma/receipt name). Adjectives only when they carry information.
- **Substance (our signature — this is what sells the paper):**
  (1) the honesty ledger IN THE BODY (section 11), not footnotes;
  (2) negative results AS THEOREMS (section 6: `bulkOnly_*`,
  `massSandwich_not_pointwise`, `additiveError_no_machineStage`,
  `route_a_closed`); (3) the double security declaration (section 8:
  lattice numbers AND symmetric caps for everyone — ChaCha20/SHAKE
  Grover — "we do not sell the lattice number as the system level");
  (4) "the verification found bugs" (section 7: F-001 upstream
  `falcon_prng_get_bytes`, the dead REV10 parser layer, the duplicated
  xor in divSelect — the proof as a bug-finding process).
- **Mission:** ONE restrained paragraph in the intro + ONE line in the
  conclusion ("for every free person" class). Facts over emotion. The
  padding-666 critique is FACTUAL and B3-based; colorful language stays
  out of the paper entirely.

## Sources inventory (pin everything)

- Modules (statements verbatim): `development/T12_1/run2/formal/` —
  `Assembly.lean`, `AssemblyComp.lean`, `CompPrg.lean`, `AdvPrg.lean`,
  `SignLayerSupport.lean`, `AttemptWeights.lean`, `AttemptPointwise.lean`,
  `T5Pointwise.lean`, `HacGlue.lean`, `JointDecomp.lean`,
  `ONoneGeometry.lean`, `Run2/T5ScalarMass` (row budgets),
  `development/T12_1/source3/formal/Source3/KeygenGeneratorOrder.lean`
  (9216/4608), `KeygenMkgm3Program.lean` (source_bound).
- Notes: `run2/notes/END_TO_END_SCOPE.md` (D1-D3, A1-A5),
  `B4_SYNTHESIS.md` (the closing list + assembly map),
  `B5_WORK_STATE.md`, `B2_ADVPRG_WORK_STATE.md`,
  `B2B5_COMPUTATIONAL_WORK_STATE.md`, `B4_ATTEMPT_WEIGHTS_WORK_STATE.md`,
  `T5_POINTWISE_WORK_STATE.md`.
- Reviews (cite as verification methodology, not authority):
  `work/FT1536_B2B5_COMPUTATIONAL_REVIEW_001/REVIEW.md`,
  `..._REVIEW_002/REVIEW.md` + `SUPPLEMENT_K1_E4.md` (psi_D piecewise).
- Findings: `documents/FT1536_C_CODE_FINDINGS_2026-10-02.md` (F-001).
- Numbers: `p_accept = 0.34671` (receipt
  `work/FT1536_FG_PROBE_P_ACCEPT_001/out/RECEIPT.json`); estimator
  numbers beta/0.292/0.265 from
  `validation/2026-09-22-family-estimator-independent/README.md` +
  `stages/FT_FAMILY_SEC_ESTIMATE_REVIEW_RUN_001/REVIEW.md` — mark as
  CHANGES_REQUIRED-pending (S06 uncertified!).
- QROM stance: `stages/FT1536_POST_M0_FREEZE_RUN_001/inputs/.../
  FT1536_CEL_DOWODU_I_PIERWSZY_LEMAT_2026-09-17.md` ("no fictitious QROM
  bound") — the paper claims CLASSICAL only, stated in section 3 and 11.

## Honesty rules (violations = rewrite)

- The main theorem is written in the TARGET four-arrow shape, but arrows
  1-2 (honest-Sign bridge + law bindings) carry explicit \todo markers
  keyed to B1 deliverables — the draft NEVER states them as done.
- `e2` shape remark: `2^-32` (unconditioned) vs `2^-17`
  (acceptance-conditioned) as a named remark — the realized shape is a
  B1 deliverable.
- No QROM claim. No statistical-PRG claim (route (a) is dead BY THEOREM —
  say so). No byte-level (A3/A4) coverage claim — in the ledger.
- Family FT768/FT3072 marked ALTERNATIVE_PROPOSAL (uncertified until the
  family campaign closes).

## Window-1 scope (this is one stage)

1. Full LaTeX skeleton — all 11 sections + 2 annexes, compiles to PDF.
2. FULL first drafts of the CLOSED sections: 2-6, 8-9, Annex A.
   Section 1: draft intro + mission paragraph (mark for owner's voice
   review). Section 7: draft the METHOD + bugs-found subsections now
   (material is closed), stub the B1-progress part.
3. Stubs with \todo for OPEN/IN-FLIGHT parts (sections 10, 11 draftable
   from existing ledger text — do it), Annex B stub.
4. `SOURCES.md` traceability map for every drafted claim.

Polish handoff summary per batch: what is drafted, which claims are
marked in-flight, and the exact list of owner decisions needed (title,
mission paragraph, venue target).
