# REUSED_RESULTS — wyniki przejęte, z pinami i zakresem

Zasada: reuse oznaczam pinem; dane poprzedniego autora/recenzenta **nie są**
nowym niezależnym wynikiem tej pracy (RUN_003). Nowe wyniki RUN_003 to
wyłącznie: guarded runner + testy (R4), rygorystyczny rachunek χ² (R5),
kontrole semantyczne N1–N7, generator tabeli, audyt aksjomatów, diffy,
reprodukcje bajtowe i ten pakiet dokumentacyjny.

## 1. CANDIDATE_R2 (FT_FAMILY_SCALING_2026-09-22_RUN_002) — UNREVIEWED_WORK_SNAPSHOT

- Pin manifestu: `5ee71952862a0395e9c3d14873f953a9f9a61985d3ff24f2ccf4f34f0dfccd16`
  (42 pliki + oryginalny SHA256SUMS z prefiksami `./`; walidacja exact-set/
  hashów/normalizacji: `proof/checks/00_verify_inputs.log` PASS).
- **REUSED bez zmian (bajtowo):** `lean/FTA2.lean`, `FTLayout.lean`,
  `FTRoots.lean`, `FTBounds.lean`; `scripts/check_geometry.py`,
  `check_layout.py`, `check_bounds_table.py`, `check_fft3_error.py`,
  `sage_exact.sage`; `paper/references.bib`; `SOURCE_MAP.md`;
  `scripts/historical/INVALID_FOR_P2_run_campaign.sage` +
  `README_invalid_original.md` (kopia wadliwego runnera — etykieta obok).
- **REUSED z edycjami (diffy w `proof/diffs/`):** `ATTACK_PROBLEMS.md`
  (diagram R1), `CLAIMS.md` (przepisany: 9 klas, C1–C21),
  `RESEARCH_NOTES_PL.md` (H-B: wyprowadzenie + PROPOSED), `paper/main.tex`
  (twiddles placeholder, 12 przypadków, próg PROPOSED),
  `PARAMETRIC_TASK_LAYOUT.md` (tabela z markerów), `CORRECTIONS.md` (§12),
  `PACKAGE.md` (RUN_003).
- **Wyniki przejęte i TU reprodukowane bajtowo** (REUSED + replay w trybie
  historycznych runnerów): `results/fft3_error.json` + log (12 przypadków
  portu, MPFR 256-bit) oraz `results/sage_exact.json` + log — wszystkie
  **identyczne z pinami** (szczegóły: `proof/receipts/reproduction_receipt.json`;
  epizod z `__name__` CLI Sage i fałszywą reprodukcją tamże i w
  `FAILED_ROUTES.md`). Reprodukcje bajtowe geometry/layout/bounds: **PASS**
  (odtworzone na nowo, identyczne z pinami).

## 2. FT_FAMILY_SCALING_REVIEW_RUN_001 (recenzja, prowadzący)

- `REVIEW/REPORT.md` pin `3b4160dc…`; `REVIEW/OUTPUTS.sha256` pin
  `0319da97…`. Ustalenia R1–R7 = źródło wymagań (`CORRECTION_MATRIX`).
- **REUSED (wynik niezależny recenzenta):** certyfikat ogona χ²
  `[2.9925420736…e−9 ± 2.32e−82]` (porównanie cyfr z moim rachunkiem —
  zgodność; patrz `results/chi_tail.json` pole `cross`/notatki R5) oraz
  niezależne kontrolne 12 przypadków FFT (ComplexBallField) — historia
  w `REVIEW` i `FAILED_ROUTES.md` (failed route Hornera).

## 3. Odebrane certyfikaty torów głównych (stages)

REUSED w granicach z `MODEL_BOUNDARIES.md` §3 (piny w `INPUTS.sha256`):

- **M0** (`FT1536_M0_CONTRACT_RUN_001`): GAME.md, PROFILE.json,
  TARGET_TYPE.md — kontrakt gry dla P1–P3;
- **L_V** (`FT1536_L_V_BRIDGE_RUN_001`): jednostronny Extract (bajty→świadczenie);
- **RAW_ASSEMBLY** (`FT1536_H3_RAW_ASSEMBLY_RUN_001`): layout N=1536
  (6144/18432/…/8192) — punkt kontrolny C6;
- **T01** (`IID_RETRY_CERTIFICATE.json` pin `2a91dd43…`, REVIEWED):
  **wyłącznie** post-H2P cap16 `G_retry_IID` w modelu IID_BUFFER;
- **JOINT / H6P** (kopie w bootstrap `JOINT/`, `H6P/`): certyfikaty
  referencyjne odebrane; konsumpcja wg zakresu z NEXT_INTERFACE.

Żaden z powyższych nie dowodzi: real PRNG, H2P, integer recovery, Sign→Verify,
całego real Sign, security/CT (patrz MODEL_BOUNDARIES.md §3).

## 4. Inne przejęcia

- Zasada rachunku SageMath: kopia decyzji właściciela w `supplements/`
  (SHA `b6afcdca…`) — obowiązuje jako uzupełnienie TASK.
- Szkice `.py` (moje własne, wcześniejsze w tej samej pracy) zachowane w
  `proof/drafts/`; przejście na tryb `.sage` rozliczone diffem/replayem/
  zgodnością certyfikatów w `proof/receipts/port_py_to_sage.json`.
