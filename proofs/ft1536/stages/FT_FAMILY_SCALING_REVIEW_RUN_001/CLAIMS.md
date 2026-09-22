# CLAIMS — ledger twierdzeń pakietu FT_FAMILY_SCALING (2026-09-21)

Klasy weryfikacji: `KERNEL` (Lean 4, czysty log), `EXACT_COMPUTATION`
(Sage/Python arytmetyka dokładna lub kontrola w binary64), `ANALYTIC`
(dowód w tekście manuskryptu), `SOURCE_FACT` (dosłowny fakt przypiętych
źródeł), `NOT_RUN`, `OPEN`. Żadna pozycja nie ma statusu „proved" powyżej
swojej klasy. Zakres = dokładny model/populacja, której dotyczy.

| # | twierdzenie | klasa | zakres | artefakt |
|---|---|---|---|---|
| C1 | `X^N − X^(N/2) + 1 = Phi_{3N}(X)` dla N = 3·2^k (768/1536/3072) | EXACT_COMPUTATION (+ ANALYTIC) | wielomiany nad ZZ | `results/sage_exact.json` SA1; paper Lemat 1 |
| C2 | `3N \| q−1`, q = 18433 pierwsze; poprawne pierwiastki NTT 3532/625/25 (rząd 3N, `Phi_N = 0 mod q`); 8/27/13 mają rząd N i `Phi_N = 3 mod q` | KERNEL + EXACT | arytmetyka mod q | `lean/FTRoots.lean`, `results/sage_exact.json` |
| C3 | `(1/N)Tr(a*conj a) = sum_{i<N/2} A2(a_i, a_{i+N/2}) = Q_A2(a)`; `Q_A2` = forma liczona przez `falcon_is_short` | ANALYTIC + EXACT + SOURCE_FACT | a ∈ R_N; model kodu = `falcon-enc.c` ter | `lean/FTA2.lean`, SA2/SA3, paper Lemat 2 |
| C4 | `(1/2)||a||^2 <= Q_A2(a) <= (3/2)||a||^2`, równości osiągalne; `|sigma_j(a)|^2 <= (N/2) Q_A2(a)` | KERNEL + EXACT | a ∈ Z^N | `lean/FTA2.lean`, SA6, paper Lemat 3 |
| C5 | `B_1536 = floor((43/40)^2 · 2N · 768^2) = 2093922385`; `2N*768^2 = 1811939328` (bez marginesu) | KERNEL | arytmetyka całkowita | `lean/FTBounds.lean` |
| C6 | `T = (logn+2)N` słów drzewa, `sk = (logn+6)N`, liście `= N`, `tmp = 7N`; instancje 8448/18432/39936 i 11520/24576/52224 | KERNEL (+ SOURCE_FACT dla zgodności N=1536) | layout strukturalnie niezmienionych źródeł | `lean/FTLayout.lean`, `results/layout.json`, RAW_ASSEMBLY |
| C7 | `det(Lambda_h) = q^N` (metryka współczynnikowa); `det G = (3/4)^N` (Gram metryki Q_A2 na `(z1,z2)`), `covol_Q(Lambda) = (3/4)^(N/2) q^N`, `covol^(1/2N) = (3/4)^(1/4) sqrt(q)` | ANALYTIC | kraty NTRU stopnia N | paper sekcja geometry |
| C8 | `E||f||^2 = 2N/3`, `E||(g,−f)||^2 = 4N/3` dla surowych iid ternary; RMS/GH → `sqrt(4 pi e/(3 q)) = 0.0248538421` | ANALYTIC + EXACT | surowa propozycja (NIE populacja po KeyGen) | `results/geometry.csv` |
| C9 | Skalowanie GH: `GH ∝ sqrt(N)` przy stałym q (`GH(2N)/GH(N) → sqrt(2)`) | EXACT | konwencja dokładna GH | `results/geometry.csv` |
| C10 | Kontrprzykład: `|a(zeta)| = sqrt(3)/(2 sin(pi/(3N))) = 1270.261873…` (N=1536) łamie `sqrt(N) max|coeff|` (32,4×) | EXACT | a = 1+X+…+X^(N−1) | `results/sage_exact.json` SA5, `results/fft3_error.json` |
| C11 | Rekurencja błędu FFT3: `|fl(a)_j − a(zeta_j)| <= gamma_{c ell} (1+eps_tw)^(ell+1) ||a||_1` | **PROPOSED_BOUND (do dowiedzenia)** — stała c, domeny operacji i eps_tw nieustalone; model: binary64, 1 zaokrąglenie/operację | source-order `falcon_FFT3(full=1)` | paper sekcja stabilności |
| C12 | Nieprzeczenie C11: `max|err| <= 8 ell u ||a||_1`, `c_emp <= 0.209` (maks. 0.20850) dla 4 klas wejść × 3 stopnie | EXACT_COMPUTATION (kontrola, nie dowód; oracle MPFR 256-bit; port nie jest dowiedziono równoważny FPEMU) | port na przypiętych bitach `fpr_gm3_*` | `results/fft3_error.json` |
| C13 | Podgrupy Galois: 8 rozwiązań `u^2=1`, 7 podgrup rzędu 2 (= 7 podpól indeksu 2), 7 indeksu 2 (= kwadratowe), suma podgrup 142/164/186 | EXACT_COMPUTATION (GAP) | `(Z/m)^*`, m = 2304/4608/9216 | `results/sage_exact.json` SA4 |
| C14 | FT768/FT3072: brak implementacji w przypiętych źródłach (twarde `logn != 10` w `load_skey` i `ft_keygen_leaf_certificate`, `treesize = 12n`) | SOURCE_FACT | manifest `56974571…` | SOURCE_MAP §4 |
| C15 | Koszty ataków dla P1/P2/P3 | NOT_RUN | — | `ATTACK_PROBLEMS.md`, `scripts/estimator_campaign/` |
| C16 | Czasy KeyGen/Sign/Verify, wydajność, przepustowość | NOT_RUN | — | brak pomiaru (tabela „cykli" wycofana) |
| C17 | Wystarczalność precyzji dla FT3072; bezpieczeństwo rzutowania `Q<B → int16`; prawo samplera / realny PRNG; η_pre i straty kompozycji | OPEN | — | CORRECTIONS §5 |
| C18 | Poprawność, bezpieczeństwo i przydatność wdrożeniowa rodzin FT768/FT3072 | OPEN (poza zakresem) | — | — |

Uwaga metodyczna: C1–C6, C10 i C13 mają kontrolę maszynową (kernel lub
arytmetyka dokładna); C7–C9, C11 mają dowody analityczne w manuskrypcie;
C12 jest wyłącznie walidacją. Nic z powyższego nie jest deklaracją poziomu
bezpieczeństwa ani certyfikatem wdrożenia.
