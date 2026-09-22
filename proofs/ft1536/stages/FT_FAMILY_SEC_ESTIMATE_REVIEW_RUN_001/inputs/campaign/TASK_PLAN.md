# TASK_PLAN — przebieg kampanii (odtwarzalny)

Kolejność wykonania (każdy krok po poprzednim; wypisy w `COMMANDS.log`):

1. **Wiązanie buildu**: `python3 scripts/extract_build_inputs.py` →
   `inputs/family/build_inputs.json` (manifest 17/17, 14 wiązań file:line).
   `scripts/verify_vendor.py [--upstream …]` → weryfikacja vendor
   lattice-estimator (63 pliki, hash drzewa) i zgodność bajtowa ze świeżym
   clone upstream w przypiętym commicie.
2. **Model deterministyczny** (jak S20 a1): `sec_estimate.sage` — pętle
   Falcon v1.2 eq. (2.3)/(2.4) w Decimal(110); walidacja kotwic
   Falcon-1024 `keyrec=936, forgery=952` (assert); transport A2 dla wierszy
   FT forgery; wiersze wariantów = `ALTERNATIVE_PROPOSAL`.
3. **Kontrole SIS** (jak c1, wiersze odrzucone): `sis_models.sage` —
   jednorodny SIS na promieniu sqrt(B_N - 1); wyniki znakowane
   `REJECTED_FOR_P2` z powodem trywialnych wektorów `q*e_i`.
4. **Podpola ABD**: `subfield_normdown.sage` — dokładne E[Q_A2(N_u(f))]
   (moment czwartego rzędu ternary + sumy Ramanujana), 7 podgrup × 3 stopnie,
   pętla eq. (2.3) na instancji podciałowej; status lift = OPEN heuristic.
5. **Koperta wroga**: `hostile_envelope.py` — tau ∈ {1.075, 1.1, 1.2} ×
   warianty sigma × miara (A2 vs wycofany proxy euklidesowy).
6. **Pełna siatka NTRU** (jak c1 „max"): `ntru_models.sage` —
   `NTRU.estimate` dla FT×3 + Falcon-512/1024, 5 ataków × 12 RC × 2 kształty;
   zapis przyrostowy `artifacts/ntru_grid.ndjson`.
7. **Agregacja**: `aggregate.py` → `comparative_summary.json`,
   `comparative.csv` (minima per atak + komplet etykiet statusów).
8. **Raport i pieczęcie**: `report.md`, `INPUTS.sha256`, `OUTPUTS.sha256`.

Środowisko: SageMath 10.9 (env conda `sage`, python3.14) + fpylll 0.6.4;
skrypty kampanii uruchamiane przez
`/home/footfalcon/miniforge3/envs/sage/bin/python scripts/PLIK`
(bez preparsera Sage — odpowiednik dawnego `sage -python`; `sage plik.sage`
w Sage 10.9 włącza preparser i NIE jest poprawnym wejściem dla tych skryptów).

Kryterium odbioru: zgodność definicji problemów (P1/P2/P3) z naprawionymi
grami, kompletność siatki, poprawne etykiety statusów, komplet pinów — nie
liczba wierszy ani estetyka tekstu.
