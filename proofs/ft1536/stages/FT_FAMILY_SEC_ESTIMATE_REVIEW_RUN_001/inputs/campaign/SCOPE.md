# SCOPE — co liczymy, czego nie

## Liczymy (model-dependent concrete costs)

1. **P1 key recovery** (short-vector recovery, Falcon eq. 2.3 target):
   - model deterministyczny eq. (2.3) dla FT768/FT1536/FT3072 (RAW iid
     ternary, `sigma_fg = sqrt(2/3)`, metryka współczynnikowa) i kotwic
     Falcon-512/1024 (oficjalne stałe v1.2);
   - pełna siatka `NTRU.estimate`: ataki usvp/dsd/bdd/bdd_hybrid/
     bdd_mitm_hybrid × 12 modeli kosztu redukcji × 2 modele kształtu.
2. **P2 forgery** (niejednorodny cel kosetu, eq. 2.4 + transport A2):
   - model eq. (2.4) z dokładnym transportem metryki A2
     (`root_det = (3/4)^(1/4) sqrt(q)`, promień `sqrt(B_N - 1)`),
   - powierzchnia kosztów RC dla każdego wiersza (beta-2/beta/beta+2),
   - warianty `ALTERNATIVE_PROPOSAL` dla FT768/FT3072 (szerokość stała vs
     skalowana sqrt(N)); FT1536 = próg przypięty z `Extra/c`.
3. **Subpola (ABD, indeks 2)**: dokładne momenty drugie norm względnych
   ternary secrets (sumy Ramanujana) + pętla eq. (2.3) dla instancji
   podciałowej dla wszystkich 7 podgrup rzędu 2 na stopień.
4. **Kontrole**: jednorodny SIS (wiersze REJECTED), koperta wroga
   (tau/miara/warianty), walidacja kotwic Falcon-1024 (936/952).

## Nie liczymy / poza zakresem

- pełna redukcja M7 (symulacja ROM/Sign, świeżość, budżety) — OPEN;
- krok lift dla ataków podciałowych (warunek „rozwiązanie jest normą
  względną") — OPEN heuristic (ABD 2016/127);
- conditioning populacji EMITTED (accepted-KeyGen) — OPEN;
- równanie modelu circulant vs pierścień Phi_{3N} — OPEN (jawne zastrzeżenie);
- hybryda MITM poza estymatorem, ataki kanałów bocznych, QROM;
- deklaracje poziomu bezpieczeństwa — **niedokonywane**.

## Wiązanie z buildem

Wszystkie parametry (q, B, sigma, capy) pochodzą z kodu `Extra/c`
(aktywny build, manifest `56974571…`): `inputs/family/build_inputs.json`
z file:line i dosłownymi liniami; każdy skrypt przy starcie ponownie
weryfikuje manifest 17 plików, hashe plików źródłowych i obecność literalnych
staych (`scripts/build_binding.py`). Rozbieżność przerywa run.
