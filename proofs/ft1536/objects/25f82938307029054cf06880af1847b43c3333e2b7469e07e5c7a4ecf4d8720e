# CORRECTIONS — odpowiedź na przegląd pakietu `ft_family_scaling`

Odpowiedź na `FT_family_MiMo_ocena_i_poprawki.md` (2026-09-21). Zasada
przeglądu zastosowana dosłownie: **nie usuwamy liczby bez usunięcia
zależnego wniosku** — sekcja 10 jest ledgerem wycofań wraz z wnioskami,
które wraz z nimi znikają. Wszystkie nowe liczby mają artefakty w
`results/` i/lub kernel Lean 4 (`lean/`).

## 1. Krytyczne: zmieszanie populacji kluczy i wersji dowodów — POPRAWIONE

- Nowa `SOURCE_MAP.md` zawiera wymaganą tabelę
  `stan / data / commit / f,g / KeyGen gates / sigma_sign / B / metryka /
  zakres twierdzenia / dokładny artefakt` z rozdzieleniem: wiersz A
  (pełnoternarny, bieżący), wiersz B (majowy Gaussian-like — kwarantanna),
  wiersz C (binarny, tło), wiersz D (FT768/FT3072 — planowane).
- Historyczne eksperymenty podciałowe i `1.70084` prób/klucz pozostają
  wyraźnie oddzielone (SOURCE_MAP §6); nie podstawia się ich do żadnego
  wniosku o bieżącej rodzinie.
- Wzór `1.7*(N/1536)^0.1`: **WYCOFANY** razem z wnioskiem o skalowaniu liczby
  prób (wykładnik 0,1 nigdy nie był wyprowadzony). W jego miejsce: jawne
  `NOT_RUN` dla oczekiwanej liczby prób w rodzinie FT oraz fakt źródłowy
  `SIGN_MAX_ATTEMPTS = 16`, `TERNARY_KEYGEN_MAX_ATTEMPTS = 3000000`.
- H3: rozdzielone historyczne ORDERED (`PARTIAL_PROOF`, zachowane) od
  LEFT_ROOT_CORRELATED_TRANSFER (kompozycja `H3_ORDERED_NUMERIC_CENTER_
  PROVED_FOR_EMITTED_PINNED_MODEL`) — SOURCE_MAP §3 wiąże twierdzenia z
  właściwymi artefaktami zamiast z majowym workflow.
- Zachowane zgodnie z uwagą przeglądu: sampler Gaussa, heurystyka Gaussa i
  porównania z Gaussianem jako pojęcia.

## 2. Krytyczne: tabele bezpieczeństwa nie są wynikami lattice-estimatora — WYCOFANE

- Wszystkie liczby z `0.265*d*log2(q/sigma) - 100` (1970 / 3633 / 6551 oraz
  każda ich pochodna) są **wycofane** — patrz ledger §10.
- Wycofane składniki: arbitralne `-100`, `discount = 0.1`, utożsamienie
  `sigma_sign` z parametrem sekretu oraz druga tabela „worst subfield"
  (z użytym przez pętlę `sigma ≈ 1086.116` — błąd sterowania, nie wynik).
- ADPS16: w modelu `estimator.reduction.ADPS16` koszt core-SVP to
  `2^(0.292 beta)` (classical) i `2^(0.265 beta)` (quantum), gdzie `beta`
  jest rozmiarem bloku z analizy ataku — zweryfikowane w dokumentacji
  estymatora (przykład `ADPS16(500,1024) = 2^146.0` = `2^(0.292*500)`).
  Samo `d*log2(q/sigma)` nie jest `beta`.
- Nowy stan: **każda komórka kosztu ataku = NOT_RUN**. Poprawne definicje
  trzech rozdzielonych problemów (P1 odzyskanie klucza / P2 MT-ISIS i bajty /
  P3 prawo akceptacji) są w `ATTACK_PROBLEMS.md`; szkielet przypiętej
  kampanii w `scripts/estimator_campaign/` (z jawnym `NOT_RUN` i listą
  warunków wstępnych). Key recovery używa prawa **ternarnego** (nigdy
  `sigma_sign`).

## 3. Istotne: pierwiastki i podciała — POPRAWIONE (kernel Lean + Sage)

- **Tożsamość cyklotomiczna.** Dla N = 3·2^k zachodzi dokładnie
  `X^N − X^(N/2) + 1 = Phi_{3N}(X)` — porównanie współczynników nad ZZ dla
  768/1536/3072 (`results/sage_exact.json` SA1: True/True/True). Dowód w
  tekście: `X^N − X^(N/2) + 1 = Phi_6(X^(N/2))`, a pierwiastek `zeta^u`
  spełnia `zeta^(uN/2)` rząd 6 wtedy i tylko wtedy, gdy `u` jest względnie
  pierwsze z `3N`; stopień obu stron = `phi(3N) = N`. Zdanie o „N potędze
  dwójki" zastąpione tożsamością dla właściwej rodziny.
- **Mapa pierwiastków** (kernel: `lean/FTRoots.lean`, wszystkie fakty przez
  `decide`): poprawne pierwiastki rzędu 3N to **3532 (N=768), 625 (1536),
  25 (3072)** — `Phi_N(w) = 0 mod q`, `w^(3N) = 1`, `w^(3N/p) != 1` dla
  p = 2,3. Podane wcześniej **8, 27, 13 mają rząd N, nie 3N**, i
  `Phi_N(w) = 3 mod q` — nie są pierwiastkami badanego wielomianu. Mechanizm:
  dla `ord(w) = N` ma `w^(N/2) = −1`, więc `Phi_N(w) = 1 − (−1) + 1 = 3`
  (dokładnie wartość z tabeli przeglądu). Jako punkty ewaluacji nadają się
  tylko z jawnym twistem/mapowaniem — w portach przeliczeń używamy mapy
  slotów `r_j = 1 + 6*rev_{logn-2}(j/3) + N*(j%3)` (zweryfikowanej na
  jednomianach; dla N=1536 zgadza się z `rev8` z POSTPROCESSING_MAP).
- **Podgrupy.** Dokładna enumeracja rozwiązań `u^2 = 1 mod m` daje 8
  rozwiązań (7 nieidentycznościowych) dla każdego z m = 2304/4608/9216 —
  jawne listy w `results/sage_exact.json` SA4. GAP (dokładny spis): liczba
  WSZYSTKICH podgrup `(Z/m)^*` = **142 / 164 / 186**, podgrup rzędu 2 = 7
  (⇔ 7 podpól indeksu 2), podgrup indeksu 2 = 7 (⇔ 7 podpól kwadratowych).
  Liczby 26/29/32 z wycofanej tabeli to były liczniki dzielników przewodnika —
  wycofane jako „liczby podgrup" (ledger §10).
- Dla każdego rozważanego zejścia nadal brakuje zdefiniowanego rozkładu
  normowanego i warunków podniesienia — to jest właśnie zawartość `NOT_RUN`
  w `ATTACK_PROBLEMS.md` (odsyłacz ABD 2016/127 zamiast „arbitralnego
  procenta").

## 4. Istotne: geometria i norma — POPRAWIONE + nowy transport A2/śladu

Potwierdzone przeliczenia przeglądu (do cyfry): `det(Lambda_h) = q^N`,
`E||f||^2 = 2N/3` dla surowych propozycji iid ternary, RMS/GH współczynnikowe
`= sqrt(4 pi e/(3 q)) = 0.0248538421` (nasza stała dokł. zgadza się co do
cyfry), a `0.0176` = `sqrt(2 pi e/(3 q)) = 0.0175743203` (pojedyncze f vs
promień kraty par) — przyjmujemy objaśnienie przeglądu.

- Wektor kluczowy w kratce `(g, −f)`, `E||(g,−f)||^2 = 4N/3` (surowe) —
  przyjęte; poprzednie użycie samego `f` dla RMS/GH pary wycofane.
- Konwencja promienia GH: przyjęta **dokładna**
  `Gamma(d/2+1)^(1/d)/sqrt(pi) * det^(1/d)`; `sqrt(d/(2 pi e))` występuje
  wyłącznie jako jawne przybliżenie asymptotyczne (obydwa w
  `results/geometry.csv`).
- Skalowanie: przy stałym q promień GH rośnie jak `sqrt(N)` — zmierzone
  stosunki `GH(2N)/GH(N) = 1.4124 / 1.4132` vs `sqrt(2) = 1.4142…`
  (wartości dokładne maleją wraz z Gamma); `log GH = (1/2) log N + c`.
  Poprzednie zamieszanie log/sqrt usunięte także z odpowiednika Prop. 3.6.
- **Nowy transport (brakujący w manuskrypcie v1).** Lemat 2
  (paper, sekcja geometry; kernel `lean/FTA2.lean`, instancje Sage SA3):

  `Q_A2(a) = (1/N) Tr_{K/Q}(a*conj(a)) = (2/N) sum_par |sigma_j(a)|^2
   = sum_{i<N/2} (a_i^2 + a_i a_{i+N/2} + a_{i+N/2}^2)`,

  i to jest dokładnie forma liczona przez `falcon_is_short` („Q offset768
  A2"); pełne wyprowadzenie Ramanujana w paperze, Lemat 2. Stałe równoważności: `(1/2)||a||^2 <= Q_A2(a) <= (3/2)||a||^2`
  z ekstremalnymi osiągalnymi przypadkami (kernel + Sage SA6). Pojedyncze
  zanurzenie: `|sigma_j(a)|^2 <= (N/2) Q_A2(a)` — „single embedding" jest
  więc kontrolowane z jawnym czynnikiem N/2, a nie „na oko".
- Transport wyznacznika do metryki Q_A2: `det G = (3/4)^N` (wyznacznik
  macierzy Grama formy na `(z1,z2)`), stąd `covol_Q(Lambda) = (3/4)^(N/2)
  q^N` i `covol_Q^(1/2N) = (3/4)^(1/4) sqrt(q)`; promienie GH w obu metrykach policzone
  (`results/geometry.csv`). Dopiero to pozwala odnieść wnioski o metryce
  współczynnikowej do warunku `Q < B` Verify — połączenie wykonane w paperze
  (sekcja geometry).

## 5. Krytyczne: brak dowodu wystarczalności FPEMU — WYCOFANE + jedna właściwa rekurencja

- Deklaracje „binary64 wystarcza", „≥ 32 bitów zapasu (Proved)" oraz
  „FT3072 wykonalne numerycznie" — **wycofane** wraz ze statusem (ledger §10).
  `CLAIMS.md` nie ma już pozycji PROVED dla tych wniosków.
- Kontrprzykład przeglądu **potwierdzony dokładnie** (Sage SA5 + port): dla
  `a = 1 + X + ... + X^(N−1)` i pierwiastka rzędu 3N
  `|a(zeta)| = sqrt(3)/(2 sin(pi/(3N)))`; przy N = 1536 dokładnie
  **1270.261873…** (wartość z przeglądu 1270.26 poprawna; forma
  asymptotyczna `(3 sqrt3/(2 pi)) N = 1270.261775…`) vs wycofana granica
  `sqrt(N) max|coeff| = 39.19` — naruszenie 32,4×. Poprawna granica:
  `max_j |sigma_j(a)| <= sqrt((N/2) Q_A2(a)) <= sqrt(3N/4) ||a||_2`.
- **Dostarczony parametr rekurencji zależnej od N** (wymóg: „co najmniej
  jeden właściwy"): dla source-order `falcon_FFT3(., logn, 1)` w modelu
  binary64 z jednym zaokrągleniem na operację FPEMU:

  `|fl(a)_j − a(zeta_j)| <= gamma_{c*ell} * (1 + eps_tw)^(ell+1) * ||a||_1`,
  `gamma_k = k u/(1 − k u)`, `u = 2^−53`, `ell = logn`,

  zamiast wycofanego `epsilon sqrt(N) log2(N)` bez normy wejścia. Czynnik
  **`||a||_1` wraca do lematu** (recenzja: „Lemma 5.1 zawiera normę wejścia";
  tabela jej nie liczyła). Szkic wyprowadzenia podano na tle dokładnej
  struktury źródła (1 + log2(t/3) + 1 poziomów, motylki z
  `fpr_gm3_square/cubic`); **status: proponowana granica (do dowiedzenia)** —
  konkretna stała `c`, pełne domeny operacji i budżet błędu twiddles
  `eps_tw` nie są ustalone.
- Walidacja numeryczna (`results/fft3_error.json`): port wierny źródłu na
  **przypiętych bitach** `fpr_gm3_*`/`fpr_W*` z `fpr-emulated.h`, mapa slotów
  `r_j` zweryfikowana na jednomianach, a referencja liczona oraclem
  **MPFR 256-bit** (`sage.all.RealField(256)`, poprawnie zaokrąglane cos/suma,
  dokładne wejścia całkowite — nie binary64 `math.cos/fsum` jak w poprzedniej
  wersji tej kontroli); dla klas wejść (ternary/gauss/all-ones/alternating)
  i N = 768/1536/3072: `max|err| <= 7.8e-13`, granica `8*ell*u*||a||_1`
  spełniona, empiryczna stała `c_emp <= 0.209` (maks. 0.20850…). To kontrola,
  nie dowód; port nie jest dowiedziono bitowo równoważny makrom FPEMU
  (kolejność `FPC_SQR` może się różnić w ostatnim ulp).
- **Co pozostaje otwarte (bez eufemizmów):** dowiązanie tej rekurencji do
  bit-dokładnych kontraktów FPEMU (model = binary64; kolejność `FPC_SQR` może
  się różnić w ostatnim ulp), składniki błędu twiddles z jawnymi `eps_tw`,
  propagacja przez LDL/stabilizację/sampler (drugie ramię pytania §4.2), oraz
  bezpieczeństwo przed przyszłym rzutowaniem `Q < B` → int16 — **nie
  uzasadniamy go** (zgodnie z przeglądem). Technika korelacji raw-L/stable-D:
  struktura parametryczna (rekurencje §2), ale certyfikowane domeny i marginesy
  (`div[1/16, 2^35]`, `|Im D_C| < 32/1`, `factor < 6`, bank `849346588`,
  marginesy `1209616765/1209616764`) są instancjami N=1536 i dla FT768/FT3072
  oznaczamy je **„wymaga nowego certyfikatu"**.
- Zachowane (wymóg przeglądu): sprawdzone domeny FPEMU, signed zero/subnormal
  (audyty FPEMU/H3_ZERO_SCALAR), zależności raw-L/stable-D, actual source order.

## 6. Istotne: pamięć i czas — POPRAWIONE + wynik parametryczny

- Wycofane: tabela „Total ~59 KB" i wszystkie wnioski o paśmie/pojemności z
  niej wynikające (48 KiB = `4*N*8` nie odpowiada layoutowi). Zależne wnioski
  usunięte wraz z liczbą (ledger §10).
- Zastąpione dokładnym layoutem: `sk` 24576 słów × 8 B = **192 KiB**, `tmp`
  10752 × 8 B = **84 KiB** (razem 276 KiB samych tych buforów) — plus pełna
  tabela bloków (basis 6144, tree 18432, liście 1536, L wewnętrzne 16896,
  gxx przy 4608, scratch 3584, high-water 8192).
- Wycofana tabela „cykli" (`N log N·10`, `N^2·10/1.7`, Sign `×10`) — **w
  całości**, wraz z wnioskami wydajnościowymi; współczynników nigdy nie
  kalibrowano. Zastąpiona: dokładnymi licznikami/rekurencjami słów i liczbą
  wywołań samplera (2N = 3072/próbę, ≤ 16 prób); **czasy = NOT_RUN**
  (nawet modelowany koszt nie jest podany — porządek przeglądu: najpierw
  liczniki, potem ewentualnie model/benchmark).
- **Wynik parametryczny (przyjęty kandydat przeglądu, wzmocniony):**
  `T = (logn+2)N` słów drzewa i `sk = (logn+6)N` — nie tylko „rachunek", ale
  **dowód kernelowy** (`lean/FTLayout.lean`) + kontrola instancji. Dla
  768/1536/3072: drzewo **8448 / 18432 / 39936** słów (zgoda z przeglądem),
  `sk` 11520/24576/52224 (90/192/408 KiB), `tmp` 7N = 5376/10752/21504
  (42/84/168 KiB). **Rekurencja scratch skorygowana po recenzji** (poprzedni
  model `W(r) = 2^r + W(r-1)` z „2-słowową różnicą konwencji" był błędem
  modelu — nie uwzględniał własnego zapisu `d11` przez `t2`, 2^r słów):
  poprawnie `W(r) = max(2^r + W(r-1), 2^(r+1))`, z warstwami
  `D(j) = 3*2^j + max(2^j, W(j-1))` i `W_top = 3*2^(ell-1) +
  max(3*2^(ell-1), D(ell-1))`; kernel (`FTLayout.wrec_closed`) i instancje
  **1792 / 3584 / 7168**, a wskazany zasięg FT1536 dokładnie **8192** =
  certyfikat RAW_ASSEMBLY. Kontrola jest teraz ścisła (`scratch_exact`),
  bez tolerancji.
  To analiza warunkowa tego samego layoutu — **nie** dowód istnienia
  implementacji FT768/FT3072.
- Tabela sekretu teraz rozdziela kodowanie / współczynniki w pamięci /
  rozwinięty trapdoor (`f,g,F,G` 4N vs basis 4N vs sk (logn+6)N) — w paperze.

## 7. Istotne: scenariusze niedostrojone — POPRAWIONE

- FT1536 w scenariuszu B używa **B = 2093922385** (kernel `FTBounds`).
  Liczba 1811939328, której użyła wycofana tabela, to `2N*sigma^2` bez
  marginesu (wartość oczekiwana Q przy iid kanonicznych Gaussach) — teraz
  opisana, nie używana jako próg.
- Czynnik 1,1 ze scenariusza A: **usunięty** (ani w skrypcie, ani w dowodzie —
  nie ma już rozjazdu, bo nie ma czynnika). Scenariusze zaczynają się od
  definicji mierzalnego kryterium porównania, dopiero potem dobierają
  `sigma_N / B_N / q_N`; kryteria i wynikające warunki są w paperze
  (reżimy skalowania), a wszystkie warianty alternatywne wobec istniejącego
  FT1536 są oznaczone `ALTERNATIVE_PROPOSAL`.
- Relacja `B ∝ N^2` pozostaje prawdziwa **wyłącznie jako algebra warunkowa**
  po narzuceniu `sigma ∝ sqrt(N)` i `B = floor(1.075^2 * 2N sigma^2)`; nie
  twierdzimy, że te wybory zachowują KeyGen, smoothing, prawdopodobieństwo
  akceptacji ani dokładność prawa podpisu — te punkty mają status OPEN.

## 8. Istotne: literatura i LaTeX — POPRAWIONE

- FIPS 204 = **ML-DSA** (sierpień 2024, final); FN-DSA = Falcon w **FIPS 206**
  (w przygotowaniu; w dniu pozyskania źródeł brak strony IPD — podajemy
  status, nie fikcyjny URL). Zmiana nazewnictwa w tekście i bibliografii.
- „Nicolas Prest" → **Thomas Prest**; autorzy specyfikacji Falcona podani
  wg listy z falcon-sign.info (10 autorów: Fouque, Hoffstein, Kirchner,
  Lyubashevsky, Pornin, Prest, Ricosset, Seiler, Whyte, Zhang).
- **Nie zweryfikowane wpisy ePrint 2023/1234 i 2021/567 usunięte** (nie
  „poprawione kosmetycznie") — po sprawdzeniu nie odpowiadają żadnym pracom;
  w ich miejsce wyłącznie pozycje zweryfikowane (lista w `references.bib`,
  każda z adnotacją źródła weryfikacji w `RESEARCH_NOTES_PL.md`). Uwaga
  kontrolna: ePrint **2020/1433 to NIE jest praca o Falconie** (sprawdzone —
  „Interactive Proofs for Social Graphs"), dlatego specyfikacja Falcona jest
  cytowana jako raport techniczny NITP/submission, nie jako ePrint.
- Punkt startowy ataków podciałowych: **Albrecht–Bai–Ducas, ePrint 2016/127**
  (CRYPTO 2016) — dokładny tytuł i autorzy zweryfikowani. Dodatkowo
  Kirchner–Fouque (EUROCRYPT 2017) i Ducas–van Woerden (ASIACRYPT 2021) za
  referencjami estymatora.
- Jedna bibliografia (`references.bib`, jedno `\bibliography`), ścieżki
  względne, log kompilacji dołączony (`paper/compile.log`).
- Instrukcje odtwarzania: wyłącznie ścieżki względne do `scripts/` i `lean/`
  (`PACKAGE.md`); wyniki JSON/CSV dołączone (`results/`); ledger dowodów =
  `CLAIMS.md` (każde twierdzenie: zakres, przesłanki, rodzaj weryfikacji).

## 9. Co zachowujemy (zgodnie z punktem 9 przeglądu)

- szkielet narracji i motywację rodziny;
- pierwszość `q = 18433` i podzielność `3N | q−1` (teraz kernel + Sage);
- tożsamości cyklotomiczne dla trzech stopni — z pełnym uzasadnieniem (SA1);
- `det(Lambda_h) = q^N` w metryce współczynnikowej;
- `E||f||^2 = 2N/3` dla surowych iid ternary z rozróżnieniem RMS / wartość
  oczekiwana;
- warunkowe zależności skalowania po jawnie zadanym wyborze parametrów.

Zastrzeżenie przeglądu przyjęte: nie zachowujemy błędnych tabel liczbowych
nawet oznaczonych jako heuristic.

## 10. Ledger wycofań (liczba → usunięte zależne wnioski)

| wycofana liczba / twierdzenie | usunięte z nią wnioski |
|---|---|
| 1970 / 3633 / 6551 (wzór `0.265 d log2(q/sigma) − 100`) | cały rozdział wniosków o poziomach bezpieczeństwa rodzin; rekomendacja „FT3072 = n-bitowe bezpieczeństwo"; porównania bezpieczeństwa Falcon-512/1024 na tych liczbach |
| `-100`, `discount = 0.1`, tabela „worst subfield" (σ ≈ 1086.116) | wniosek „podciała dają ≥ 10% zniżki"; druga kolumna tabeli ataków |
| `1.7*(N/1536)^0.1` | wniosek o oczekiwanej liczbie prób KeyGen w rodzinie |
| 26/29/32 (dzielniki przewodnika jako „podgrupy") | tabela podgrup i wynikające z niej stwierdzenia o powierzchni ataku podciałowego |
| `sqrt(N)*max|coeff|` jako granica ewaluacji | Lemma 5.1 w tej postaci, tabela „max value" i pochodne „zapas ≥ 32 bitów (Proved)" |
| „binary64 wystarcza", „FT3072 wykonalne numerycznie" | status Proved wniosków o wystarczalności precyzji; sekcja stabilności w wersji v1 |
| 48 KiB / „Total ~59 KB" | wnioski o pamięci, paśmie i „mały klucz" |
| tabela „cykli" (10, 1.7, ×10) | wszystkie wnioski wydajnościowe i porównania czasów Sign/Verify/KeyGen |
| B = 1811939328 w scenariuszu B | wnioski o prawdopodobieństwie akceptacji na tej wartości |
| czynnik 1,1 scenariusza A | wniosek o „10% zapasu" scenariusza A |
| ePrint 2023/1234, 2021/567 | wszystkie powołania się na nie w tekście |
| `2^446.2` (worksheet majowy) w kontekście FT | jakiekolwiek użycie tej wartości przy ternarnych sekretach |

### Pozycjonowanie (decyzja właściciela, 2026-09-22 — po tej sekcji)

Rodzina `free_falcon_sign` (FT768/FT1536/FT3072) jest **niezależną rodziną
badawczą** i nie jest kojarzona z jakimkolwiek ciałem normalizacyjnym. Wobec
tego: usunięto z tekstu i bibliografii pozycje FIPS i wszelkie mapowanie na
kategorie zewnętrzne; liczby bezpieczeństwa raportujemy wyłącznie w konwencji
`SECURITY_CONVENTION.md` (para Core-SVP classical/quantum + nazwa modelu +
wariant d4f), nigdy jako „równoważnik" czegokolwiek. Punkty odniesienia
Falcon-512/1024 pozostają w roli referencji badawczych mierzonych tą samą
linijką. Powyższy zapis korekty §8 (FIPS 204 ≠ FN-DSA itd.) zostaje w tym
ledgerze jako historia audytu bibliograficznego — to jedyne miejsce, w którym
te nazwy występują.

## 11. Odpowiedź na niezależny odbiór R1–R7 (checkpoint `FT_FAMILY_SCALING_REVIEW_RUN_001`, 2026-09-22)

Poniżej mapowanie wiersz po wierszu. Wersja z 2026-09-21 zachowana jest
bajtowo w archiwum odbioru; niniejszy pakiet (RUN_002) jest poprawioną
wersją roboczą.

| # | ustalenie odbioru | status | gdzie naprawione |
|---|---|---|---|
| R1 | odwrócony kierunek redukcji | **naprawiony** | `ATTACK_PROBLEMS.md` §1: `Solve o Extract o Forge` (kierunek dowiedziony przez L_V) vs `Solve → Forge` (wymaga mapy kodowania — OPEN) vs pełna redukcja M7 (symulacja ROM/Sign — OPEN) |
| R2 | trywiał `c=0` i nieuprawnione `(1−p)^Q` | **naprawiony** | `ATTACK_PROBLEMS.md` §0/§2: typ `Solve_rel` z celami `c_i = T[x_i]` z tabeli ROM M0 §3, budżety `(Q_s,Q_H,t,w,L)`, `targets = Q_H+1`; kontrola N1 (trywiał wycofanej definicji), N2 (union bound po nazwach rozłącznych; `(1−1/p)^Q` tylko przy jawnych założeniach niezależności) |
| R3 | brak F w uzupełnieniu trapdooru; próg P1a bez populacji | **naprawiony** | `ATTACK_PROBLEMS.md` §3: `falcon_complete_private` liczy G z **(f,g,F)**; P1a→P1b wymaga osobnego kroku NTRU-solving na (F,G) z warunkami/długościami/kosztem; próg `B_KR` jawny per populacja (RAW: 4N/3 + margines/ogon; EMITTED: OPEN) |
| R4 | szkielet kampanii liczy odrzucone SIS | **ODROCZONY decyzją właściciela** (2026-09-22: „nie ruszaj estymatora") | `scripts/estimator_campaign/` **bez zmian**; sprzeczność szkieletu z definicjami pozostaje OPEN i musi być zamknięta przed jakimkolwiek runem; NOT_RUN utrzymane |
| R5 | H-B nie przechodzi testu χ² | **naprawiony (wynik ujemny zachowany)** | `RESEARCH_NOTES_PL.md` H-B: MODEL_CHI2_IDEAL dokładnie zdefiniowany; certyfikowany ogon `[2.9925…e−9 ± 2.32e−82] = 2^−28.32 > 2^−40`; kryterium przyjęte „zgodne z modelem" (≤ 2^−28, zapas 0.3 bitu w modelu, prawo po castach OPEN); jawna uwaga: ogon ≠ bity bezpieczeństwa; `CLAIMS.md` C19; paper §reżimy (i) |
| R6 | status PROPOSED_BOUND niekonsekwentny | **naprawiony** | abstract, wnioski i nota końcowa `CLAIMS.md` zsynchronizowane z C11 = PROPOSED_BOUND; jawny punkt: perturbacja twiddles wymaga osobnego wyprowadzenia (nie mnożnik `(1+ε_tw)^L`); 12 przypadków nie ustala c ani domen |
| R7 | wiersz tabeli 15360 i klasy dowodowe | **naprawiony** | `PARAMETRIC_TASK_LAYOUT.md`: `3N+scratch` FT3072 = **16384**, wiersze generowane/sprawdzane z `results/layout.json` (pole `scratch_high_water` dodane do `check_layout.py`); `CLAIMS.md`: nowa taksonomia `EXACT_INTEGER` / `FLOAT_CHECK` (MPFR/balls nie są „arytmetyką dokładną") / `PROPOSED_BOUND`, nota o granicy kernela (`7N=10752` = rachunek, nie dowód alokatora) |

Dodatkowo (porządek): usunięto plik-debug `.probe_py.py` z pakietu (został
w archiwum odbioru jako ślad wersji 09-21).

## 12. RUN_003 (S01) — domknięcie R1–R7 po odbiorze RUN_002

Wersja robocza RUN_002 (CANDIDATE_R2, `UNREVIEWED_WORK_SNAPSHOT`) jest tu
materiałem wejściowym (REUSED z pinem `5ee71952…`), nie wynikiem tej pracy.
Poniżej wyłącznie bilans RUN_003; szczegóły w `CORRECTION_MATRIX.md/.json`.

| # | disposition RUN_003 | co nowego |
|---|---|---|
| R1 | REUSED (weryfikacja) + nowe kontrole | diagram strzałek w `ATTACK_PROBLEMS.md` §1 zgodny z CLAIMS/paper; wykonawcza kontrola N3 (kierunek dowiedziony działa; odwrotny most wymaga nieistniejącego `Enc`) |
| R2 | REUSED (weryfikacja) + nowe kontrole | N1 (trywiał wycofanej definicji: stopień wygranej 1 vs 1/q dla celów ROM) i N2 (unia 1/2 vs 3/4) jako wykonawcze modele; union bound po nazwach rozłącznych |
| R3 | REUSED (weryfikacja) + nowa kontrola źródła | N4 parsuje sygnaturę `falcon_complete_private(G,f,g,F,…)` wprost z przypiętych źródeł; kontr-claim „z (f,g)" obalony sygnaturą |
| R4 | **NAPRAWIONE (wycofanie w zakresie TASK)** | aktywny interfejs `scripts/estimator_campaign/run_campaign.sage`: jawny `NOT_RUN_MODEL_UNRESOLVED` przed backendem, blokada brak mappingu/SHA/premises, odrzucenie SIS→P2 przed importem backendu; historyczna kopia bajtowa z etykietą `INVALID_FOR_P2/NOT_RUN`; testy mock T1–T8 (brak wywołań + wykrycie mutacji) |
| R5 | **NAPRAWIONE (rygorystyczny rachunek + jawny charakter progu)** | `scripts/lemma_chi_tail.sage` (ZZ/QQ + RealBallField(256), tryb `.sage`): wyprowadzenie postaci Erlanga/Poissona, `x = 2093922385/1179648`, certyfikowane `ogon > 2^−40` (obalenie dawnej hipotezy zachowane) i `ogon < 2^−28`; próg `2^−28` jawno oznaczony **PROPOSED** (nie cel projektu, nie poziom bezpieczeństwa) |
| R6 | REUSED (weryfikacja) + wzmocnienie | jawne zdanie w szkicu dowodu: perturbacja faz/twiddles wymaga osobnego wyprowadzenia, mnożnik `(1+ε_tw)^(ℓ+1)` to założony placeholder; 12 przypadków nie ustala c/domenu/FPEMU (jawny dopisek); spójność statusu kontrolą N6 |
| R7 | REUSED (16384) + jedno źródło tabeli | `scripts/gen_layout_table.py` renderuje wiersze z `results/layout.json` (markery + `--check`); niezależne przeliczenie rekurencji scratch kontrolą N7 (wykrycie mutacji 15360); nowa taksonomia 9 klas w `CLAIMS.md/.json` z eksportami/przesłankami |

Zależne wnioski wycofań (§10) pozostają wycofane; wyniki negatywne
(trywiał definicji, obalone kryterium 2^−40, kontrprzykład all-ones,
REJECTED SIS-row) są zachowane jako trwałe. Wszystkie komórki kosztów nadal
`NOT_RUN`.
