# RESUME_STATE — stan prac MiMo (zapis kontrolowany 2026-09-22, 08:51)

Przerwane na prośbę właściciela; wznowienie w nocy. Stan jobów i prac:

## 1. Job: siatka estymatora (TEN katalog) — PRZERWANY, wznawialny

- **70/120 komórek** zapisanych w `artifacts/ntru_grid.ndjson` (przyrostowo,
  integralność potwierdzona po zabiciu procesu; ostatni rekord:
  `FT3072/LaaMosPol14/zgsa/OK`).
- Zrobione: FT768 24/24, FT1536 24/24, **FT3072 22/24**.
- Zostało **50 komórek**: FT3072 × {CheNgu12 × 2 kształty} (2),
  Falcon-512 × 24, Falcon-1024 × 24 (małe N — szybkie).
- Utracone w locie: 1 komórka (FT3072 CheNgu12/GSA) — policzy się wznowieniem.

### Wznowienie (jedna komenda, tryb RESUME — nie kasuje logu!)

```sh
cd /home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT_FAMILY_SEC_ESTIMATE_2026-09-22_RUN_001
export HOME=$PWD/.home2 TMPDIR=$PWD/.tmp2 DOT_SAGE=$PWD/.home2/.sage
/home/footfalcon/miniforge3/envs/sage/bin/python scripts/ntru_models.sage \
  >> results_ntru.log 2>&1
```

`ntru_models.sage` ma tryb RESUME: pomija gotowe komórki (drukuje
`SKIP (resume)`), dopisuje brakujące; `load_done()` czyta klucze
`(scheme, cost_model, shape_model)` z istniejącego ndjson.

### Plan domknięcia po 120/120

1. `scripts/repair_cells.sage` — 10 komórek `MATZOV(nn="classical")`
   (zastąpienie mojego błędnego klucza `nn="ListDecoding"`; rekordy z flagą
   `repair:true`).
2. `scripts/aggregate.py` — `comparative_summary.json`, `comparative.csv`
   (minima/max per schemat–atak–model; wiersze `inf` = `NO_SOLUTION_WITHIN_MODEL`).
3. `report.md` — pełne tabele **w konwencji `SECURITY_CONVENTION.md`**
   (β + 0,292β/0,265β (d4f) jako liczby główne; drabina modeli = zakres
   wrażliwości; bez kategorii zewnętrznych; P1/P2/P3 rozdzielone).
4. `INPUTS.sha256`, `OUTPUTS.sha256`; STATUS = `DIAGNOSTIC_NOT_CANDIDATE_READY`.

Uwaga AGENTS (decyzja 2026-09-22): nowe przeliczenia kontrolne/kontrolery
w kroku domknięcia — już w wymaganym stylu `.sage` + preparser
(`sage plik.sage`), ZZ/QQ + balls/intervals; historyczne piny uruchomionych
obliczeń bez zmian (TOOLCHAIN.txt dokumentuje użycie env-python dla runnerów
estymatora — runner ≠ autorytatywny rachunek).

## 2. Praca: kampania — kompletne artefakty (poza siatką)

- `artifacts/model_eq234.json/csv` — model eq. 2.3/2.4, walidacja kotwic
  Falcon-1024 936/952; FT1536 = 1077/1082 (zgodne z S01-owym pinem).
- `artifacts/subfield_normdown.json` — 21 wierszy, wynik ujemny (brak
  przewagi podpola).
- `artifacts/sis_controls.json` + `results_sis.log` — 15/15 REJECTED
  (komunikat narzędzia utrwalony).
- `artifacts/hostile_envelope.*`, `artifacts/rc_cost_surface.json`,
  `artifacts/vendor_verification.json` (vendor↔upstream 25/25),
  `inputs/family/build_inputs.json` (17/17 manifest Extra/c, 14 wiązań).

## 3. Praca: FT_FAMILY_SCALING_2026-09-22_RUN_002 (snapshot nieodebrany)

- Piny: `SHA256SUMS = 5ee71952…`, `paper/main.pdf = 0dfb207b…` (9 str.,
  0 ostrzeżeń). Mapowanie R1–R7 w `CORRECTIONS.md` §11.
- **R4 nadal OPEN** (szkielet kampanii niezmieniony — decyzja
  „nie ruszaj estymatora" z 2026-09-22); materiał do S01/RUN_003.
- Pozycjonowanie: zero NIST/FIPS w tekście/bibliografii (decyzja właściciela).

## 4. Tropy nie ruszane

- T03 `FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001` — osobny W/wykonawca,
  start ręczny właściciela.
- Astra/T01 (H6P) — obcy W, nieczytany.
- S01 `FT_FAMILY_SCALING_CORRECTIONS_RUN_003` — start po handoffie tego
  stanu; drugi worker nie uruchamiany.
