# CLAIMS — ledger twierdzeń FT_FAMILY_SCALING (2026-09-22, RUN_003 / S01)

Klasy dowodowe (wymagany rozdział R7; żadna pozycja nie ma statusu „proved"
powyżej swojej klasy):

- `KERNEL` — Lean 4.34, czysty log, brak sorry/admit/native_decide/
  Lean.ofReduceBool/aksjomatu celu/wyciszania ostrzeżeń;
- `EXACT_INTEGER/RATIONAL` — arytmetyka całkowita lub dokładna
  (Sage ZZ/QQ, GAP, Fraction, liczniki);
- `RIGOROUS_INTERVAL` — arytmetyka przedziałowa z wychodzącymi zaokrągleniami
  i jawnymi granicami transcendentalnymi (udowodniony margines błędu);
- `FLOAT_DIAGNOSTIC` — kontrola numeryczna zmiennoprzecinkowa o podanej
  precyzji (binary64 / MPFR / complex balls) — **to nie jest arytmetyka
  dokładna ani dowód**;
- `ANALYTIC` — dowód lub szkic w tekście manuskryptu;
- `SOURCE_FACT` — dosłowny fakt przypiętych źródeł (manifest `56974571…`)
  albo, dla kodu własnego pakietu, fakt kodu z eksportem wykonywalnej kontroli;
- `PROPOSED` — proponowana granica/kryterium do dowiedzenia/zatwierdzenia;
- `OPEN` — otwarty obowiązek, brak dowodu;
- `NOT_RUN` — celowo niewykonane obliczenie (brak wyniku, nie wynik zerowy).

Granica kernela jest konsekwentna: np. `7*N = 10752` jest rachunkiem, **nie**
dowodem bezpieczeństwa alokatora C. **Kompilacja lokalnej arytmetyki nie
dowodzi poprawności ani bezpieczeństwa implementacji C** (patrz
`MODEL_BOUNDARIES.md`); pomosty trace/embedding i ich instancja w C mają
dodatkowe wiązanie analityczne/źródłowe.

| # | twierdzenie | klasa | zakres | eksport / przesłanki |
|---|---|---|---|---|
| C1 | `X^N − X^(N/2) + 1 = Phi_{3N}(X)` dla N = 3·2^k (768/1536/3072) | EXACT_INTEGER/RATIONAL + ANALYTIC | wielomiany nad ZZ | `results/sage_exact.json` SA1; paper Lemat 1; przesłanki: definicja Φ₆ |
| C2 | `3N \| q−1`, q = 18433 pierwsze; pierwiastki 3532/625/25 (rząd 3N, `Phi_N = 0 mod q`); 8/27/13 mają rząd N i `Phi_N = 3 mod q` | KERNEL + EXACT_INTEGER/RATIONAL | arytmetyka mod q | `lean/FTRoots.lean` (build: `results/lean_FTRoots.log`), `sage_exact.json`; przesłanki: (Z/q)\* cykliczna |
| C3 | `(1/N)Tr(a*conj a) = Q_A2(a) = Σ_{i<N/2} A2(a_i,a_{i+N/2})`; `Q_A2` = forma liczona przez `falcon_is_short` | ANALYTIC + EXACT_INTEGER/RATIONAL + SOURCE_FACT | a ∈ R_N; model = ter branch `falcon-enc.c` | `lean/FTA2.lean`, `sage_exact.json` SA2/SA3, paper Lemat 2, `Extra/c` (pin `56974571…`) |
| C4 | `(1/2)\|\|a\|\|² ≤ Q_A2(a) ≤ (3/2)\|\|a\|\|²`, równości osiągalne; `\|σ_j(a)\|² ≤ (N/2) Q_A2(a)` | KERNEL + EXACT_INTEGER/RATIONAL | a ∈ Z^N | `lean/FTA2.lean` (9 nazwanych twierdzeń), `sage_exact.json` SA6 |
| C5 | `B_1536 = floor((43/40)²·2N·768²) = 2093922385`; `2N·768² = 1811939328` (bez marginesu); reszta 1472/1600 | KERNEL | arytmetyka całkowita | `lean/FTBounds.lean`; przesłanki: komentarz `falcon-enc.c:632` (SIG-001 OPEN) |
| C6 | Layout: `T=(logn+2)N`, `sk=(logn+6)N`, liście `=N`, `tmp=7N`, scratch `W(r)=max(2^r+W(r-1),2^(r+1))`, `W_top=7·2^(ell-1)`; instancje 8448/18432/39936, 11520/24576/52224, 1792/3584/7168, high-water 4096/8192/**16384** | KERNEL (+ SOURCE_FACT dla zgodności N=1536) | layout strukturalnie niezmienionych źródeł | `lean/FTLayout.lean`, `results/layout.json`, tabela z `scripts/gen_layout_table.py` (jedno źródło), RAW_ASSEMBLY (REUSED z pinem) |
| C7 | `det(Lambda_h)=q^N` (wsp.); `det G=(3/4)^N`, `covol_Q=(3/4)^(N/2) q^N`, `covol^(1/2N)=(3/4)^(1/4) sqrt(q)` | ANALYTIC | kraty NTRU stopnia N | paper sekcja geometry; `results/geometry.json` G3 |
| C8 | `E\|\|f\|\|²=2N/3`, `E\|\|(g,−f)\|\|²=4N/3` (surowe iid ternary); RMS/GH → `sqrt(4πe/(3q))=0.0248538421` | ANALYTIC + EXACT_INTEGER/RATIONAL + FLOAT_DIAGNOSTIC (stałe) | surowa propozycja (NIE populacja po KeyGen) | `results/geometry.csv/.json` G2/G5 |
| C9 | Skalowanie GH przy stałym q: `GH ∝ sqrt(N)` (`GH(2N)/GH(N) → sqrt(2)`); konwencja dokładna GH | ANALYTIC + FLOAT_DIAGNOSTIC | binary64/Decimal 50 | `results/geometry.csv` G4/G6 |
| C10 | Kontrprzykład: `\|a(ζ)\| = sqrt(3)/(2 sin(π/(3N))) = 1270.261873…` (N=1536) łamie `sqrt(N)·max\|coeff\|` (32,4×) | ANALYTIC + FLOAT_DIAGNOSTIC (MPFR 256-bit) | a = 1+X+…+X^(N−1) | `sage_exact.json` SA5, `results/fft3_error.json` |
| C11 | Granica błędu FFT3: `\|fl(a)_j − a(ζ_{r_j})\| ≤ γ_{cℓ}(1+ε_tw)^(ℓ+1)\|\|a\|\|₁` | **PROPOSED** (do dowiedzenia) | model binary64, 1 zaokrąglenie/operację, source-order `falcon_FFT3(full=1)` | paper Prop. `prop:fft3` (szkic, jawna uwaga o osobnym dowodzie perturbacji twiddles); stała c, domeny i ε_tw **nieustalone** |
| C12 | Nieprzeczenie C11: `max\|err\| ≤ 8ℓu\|\|a\|\|₁`, `c_emp ≤ 0.209` (maks. 0.20850) dla 4 klas wejść × 3 stopnie (12 przypadków) | FLOAT_DIAGNOSTIC (MPFR 256-bit; kontrola, nie dowód) | port na przypiętych bitach `fpr_gm3_*`; port NIE jest dowiedziono równoważny FPEMU | `results/fft3_error.json` |
| C13 | Podgrupy Galois: 8 rozwiązań `u²=1`, 7 podgrup rzędu 2 (= 7 podpól indeksu 2), 7 indeksu 2 (= kwadratowe), suma 142/164/186 | EXACT_INTEGER/RATIONAL (GAP) | `(Z/m)*`, m = 2304/4608/9216 | `sage_exact.json` SA4 |
| C14 | FT768/FT3072: brak implementacji w przypiętych źródłach (twarde `logn != 10`, `treesize = 12n`) | SOURCE_FACT | manifest `56974571…` | SOURCE_MAP §4; kontrola N4 (`results/controls.json`) |
| C15 | Koszty ataków P1/P2/P3 | NOT_RUN | — | `ATTACK_PROBLEMS.md`; `scripts/estimator_campaign/` (guarded; `results/r4_tests.json`) |
| C16 | Czasy KeyGen/Sign/Verify, wydajność | NOT_RUN | — | brak pomiaru |
| C17 | Wystarczalność precyzji FT3072; bezpieczeństwo `Q<B → int16`; prawo samplera/realny PRNG; η_pre i straty kompozycji | OPEN | — | MODEL_BOUNDARIES.md |
| C18 | Poprawność/bezpieczeństwo/wdrożenie FT768/FT3072; poziom bezpieczeństwa rodziny | OPEN (poza zakresem) | — | — |
| C19 | Ogon MODEL_CHI2_IDEAL: `x = B/(2·768²) = 2093922385/1179648`, `Pr[Q≥B] = e^{−x}Σ_{k=0}^{1535} x^k/k! ∈ [2.992542073603248197…e−9 ± ~10^−305]`; **certyfikowane** `ogon > 2^−40` (obala dawne kryterium „≥1−2^−40" w tym modelu) i `ogon < 2^−28`; to ujemny test idealnego modelu ciągłego, **nie** prawo Sign po castach, **nie** prawdopodobieństwo ataku, **nie** poziom bezpieczeństwa | RIGOROUS_INTERVAL | MODEL_CHI2_IDEAL, σ=768, iid Gauss w ortonormalnych współrzędnych Q_A2, PRZED castami/retry | `results/chi_tail.json` (dokładne sumy + obudowy M1/M2 z wychodzącymi granicami); niezależne cyfry recenzji: `FT_FAMILY_SCALING_REVIEW_RUN_001/RESULT.json` (REUSED); przesłanki: postać Erlanga/Poissona (paper/notatki) |
| C20 | Kontrmodele definicji P2: N1 (przeciwnik wybiera c ⇒ trywiał `c=0,z=0`, stopień wygranej 1 vs 1/q dla celów z tabeli ROM) i N2 (powtórzone nazwy ⇒ zależne cele; `(1−p)^Q` nieuprawnione — unia 1/2 zamiast 3/4); poprawne strzałki redukcji (Extract∘Forge = Solve_rel działa; Solver→Forge wymaga nieistniejącego mostu `Enc`) | ANALYTIC + wykonawcze kontrole | gra M0 na modelach zabawkowych | `results/controls.json` N1/N2/N3; `ATTACK_PROBLEMS.md` §0–§2 |
| C21 | Naprawiony interfejs kampanii estymatora: bez premises rekord `NOT_RUN_MODEL_UNRESOLVED` **przed** backendem (backend nie jest nawet importowany); brak mappingu/SHA/premises blokuje backend; routing SIS→P2 (po nazwie modelu lub symbolu) odrzucany zanim backend wystartuje; historyczny runner oznaczony INVALID_FOR_P2/NOT_RUN | SOURCE_FACT (kod pakietu) + wykonawcze kontrole | kod tego pakietu; mock backend, nie estymator | `results/r4_tests.json` (T1–T8), `scripts/estimator_campaign/run_campaign.sage`, `scripts/historical/INVALID_FOR_P2.md` |

Uwaga metodyczna: C1–C6, C13 mają kontrolę dokładną (kernel/całkowitą);
C7–C10 mają warstwę analityczną z kontrolami wskazanymi w klasie; C11 to
**proponowana** granica z nieprzeczeniem C12; C19 to wynik ujemny
z certyfikatem przedziałowym; C20/C21 to kontrmodele i kontrole wykonywalne.
Propozycja poziomu odrzuceń `2^−28` z C19 jest oznaczona jako **PROPOSED**
model-level target — **nie jest zatwierdzonym celem projektu ani poziomem
bezpieczeństwa** (wymóg TASK R5). Nic z powyższego nie jest deklaracją
poziomu bezpieczeństwa ani certyfikatem wdrożenia.
