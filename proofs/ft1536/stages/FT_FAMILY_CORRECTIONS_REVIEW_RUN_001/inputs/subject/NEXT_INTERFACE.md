# NEXT_INTERFACE.md — następny interfejs prac po RUN_003 (S01)

Kolejność sugerowana; zależności i kryteria odbioru do rozwinięcia przez
prowadzącego w ROADMAP (Txx/Sxx). Wszystko poniżej jest osobnym obowiązkiem
— nic nie wynika automatycznie z COMPLETE_FOR_REVIEW.

## 1. Natychmiast po tym pakiecie

1. **Niezależny odbiór RUN_003** (inny model wskazany przez właściciela;
   prompt przygotowuje prowadzący): weryfikacja R1–R7 wiersz po wierszu
   z `CORRECTION_MATRIX`, wykonanie `scripts/replay.py` w świeżym DEST,
   kontrola klas dowodowych w `CLAIMS.md/.json` i wyników negatywnych.
   Pozytywny odbiór = spełnienie warunku publikacji; push nadal wymaga
   osobnego polecenia właściciela.
2. **Import/freeze archiwizacyjny** (prowadzący, po odbiorze): `archive.py
   import` z zewnętrznymi hashami REPORT/OUTPUTS, osobny commit lokalny.

## 2. Tor bezpieczeństwa (kampania estymatora — wymaga decyzji)

- Zamknięcie warunków wstępnych `scripts/estimator_campaign/README.md`:
  (a) mapping circulant ↔ Φ_{3N}, (b) semantyka P2 (coset search przy B_N,
  union bound), (c) pin SHY estymatora + premises record (mapping_sha per
  komórka). Dopiero potem run z guarded runnerem (`--allow-backend`),
  pełne logi i dopuszczenie komórek z NOT_RUN wyłącznie na zmierzone dane.
- Osobno: analiza podcięć ABD dla 7×3 podpól (normowany rozkład + warunki
  podniesienia) oraz wariant overstretched (Ducas–van Woerden) dla każdego N.

## 3. Tor prawa samplera i PRNG

- Prawo samplera po castach/rint→int16/retry dla N=1536 (symulacja
  3072-call adaptive joint law → rzeczywisty stosunek akceptacji; weryfikacja
  hipotezy H-B w prawdziwym modelu); straty kompozycji (Rényi/χ², wspólne
  historie, η_pre).
- Most real PRNG (SHAKE/ChaCha) ↔ IID_BUFFER; H2P full composition.

## 4. Tor formalny/numeryczny

- Dowód rekurencji błędu FFT3 związany z kontraktami FPEMU (krok w stronę
  kernela C11): osobne wyprowadzenie perturbacji twiddles (mnożnik
  `(1+ε_tw)^(ℓ+1)` to placeholder), ustalenie c i domen operacji.
- Bezpieczeństwo `Q<B → int16` (świadomie nieuzasadnione dotąd).
- Certyfikaty domen numerycznych H3 dla FT768/FT3072 (per-instance).

## 5. Tora równoległe (nie ruszać bez właściciela)

- **T03** integer recovery (W `FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001`,
  pauza po błędzie kroku 04: synthetic f nieodwracalne mod (q,Phi)).
- **T02.1** małe zadanie (`CURRENT_SMALL_TASK.md`) — osobny W/wykonawca.
- Kampania FT_FAMILY_SEC_ESTIMATE (jeśli żywa): jej STATUS
  `DIAGNOSTIC_NOT_CANDIDATE_READY` pozostaje diagnostyką, nie wynikiem.

## 6. Format obliczeń

Nowy autorytatywny rachunek i checkery: `.sage` przez `sage lemma.sage`
(zasada `FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22`); `.py` = organizacja/
runnery; Lean = kernel; C harness = oryginalne C. Receipty: argv, wersja
Sage, hash `.sage`, exit, stdout/stderr, powiązanie certyfikatów z runem.
