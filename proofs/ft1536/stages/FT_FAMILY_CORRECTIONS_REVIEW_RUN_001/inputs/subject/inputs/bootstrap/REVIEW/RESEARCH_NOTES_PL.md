# RESEARCH_NOTES_PL — notatki badawcze rodziny FT (2026-09-21)

## 1. Najważniejsze ustalenia tego cyklu

1. **Metryka Verify jest metryką śladu znormalizowanego.** Forma liczbowa
   `Q_A2(x,y) = x²+xy+y²` po parach offsetu N/2 to dokładnie
   `(1/N)Tr(a·ā) = (2/N)Σ|σ_j(a)|²`. To spina „metrykę współczynnikową"
   zanurzenia z warunkiem `Q < B` w Verify — brakujący most z poprzedniej
   wersji. Konsekwencje: stałe równoważności `(1/2)‖a‖² ≤ Q_A2 ≤ (3/2)‖a‖²`
   (ciasne), a pojedyncze zanurzenie wymaga czynnika `N/2`
   (`|σ_j(a)|² ≤ (N/2)Q_A2(a)`).
2. **Pierwiastki i pierścień są domknięte dokładnie.** `X^N − X^{N/2} + 1 =
   Φ_{3N}` dla N = 3·2^k (sprawdzone nad ZZ); poprawne pierwiastki NTT to
   3532/625/25, a wcześniejsze 8/27/13 mają rząd N i dają `Φ = 3 mod q`.
   Kernel Lean 4 potwierdza te fakty liczbowe (`lean/FTRoots.lean`).
3. **Wynik parametryczny: layout drzewa.** `T = (logn+2)N`, `sk = (logn+6)N`,
   liście `= N`, `tmp = 7N` — dowiedzione w kernelu, z instancjami
   8448/18432/39936 (drzewo) i 11520/24576/52224 (rozwinięty klucz) dla
   768/1536/3072. Kod źródłowy ma `treesize = 12n` na sztywno dla logn = 10 —
   to samo w sobie jest dowodem, że FT768/FT3072 nie są zaimplementowane.
4. **Poprawna rekurencja błędu FFT3 ma czynnik ‖a‖₁.** Proponowana granica
   `γ_{c·ℓ}(1+ε_tw)^{ℓ+1}‖a‖₁` (zamiast `ε√N log N` bez normy wejścia;
   status: do dowiedzenia — stała c i budżet ε_tw nieustalone); walidacja na
   przypiętych stałych `fpr_gm3_*` z oraclem MPFR 256-bit daje
   `c_emp ≤ 0,209` (maks. 0,20850) przy wygodnej granicy 8. Kontrprzykład „wszystkie jedynki" (dokładnie
   1270.261873 przy N=1536 vs wycofane `√N` = 39,19) jest zachowany jako
   trwałe ostrzeżenie przed granicami opartymi tylko na `max|coeff|`.
5. **Podpola: liczby są raz na zawsze policzone.** 7 podgrup rzędu 2 (= 7
   podpól indeksu 2) i 7 podpól kwadratowych dla każdego przewodnika, oraz
   pełne spisy 142/164/186 podgrup (GAP). „26/29/32" to były dzielniki
   przewodnika — więcej nie wracają.
6. **Bezpieczeństwo: wiemy dokładnie, czego nie wiemy.** Estymator nie był
   uruchamiany; problemy P1 (odzyskanie klucza — prawo TERNARNE), P2
   (MT-ISIS/bajty, próg B) i P3 (prawo akceptacji) są rozdzielone i
   zdefiniowane; kampania ma gotowy szkielet i listę warunków wstępnych.

## 2. Nowe hipotezy (wyraźnie NIEDOWIEDZIONE)

- **H-A (próg geometryczny FT768).** Przy stałym q = 18433 stosunek
  RMS/GH wektora kluczowego jest asymptotycznie N-niezależny
  (`sqrt(4 pi e/(3q))`), ale dla małych N wartość dokładna rośnie
  (0.024785 → 0.024834 w naszej tabeli). Hipoteza: dla każdego N z rodziny
  relacja „klucz o rząd wielkości krótszy od GH" jest zachowana, więc
  powierzchnia ataku uSVP na odzyskanie klucza maleje łagodnie i nie tworzy
  osobnego progu przy 768. Sposób sprawdzenia: kampania estymatora P1
  (NTRU.estimate z ternarnym Xs/Xe) + analiza podciałowa ABD dla każdego z
  7 podpól indeksu 2.
- **H-B (σ_N i margines).** Wybór `sigma = 768` i `1.075` (SIG-001) da się
  wyprowadzić z kryterium „masa akceptacji ≥ 1 − 2^−40 przy χ²_{2N}" — ale
  tylko jeśli prawo po castach jest bliskie iid kanonicznym Gaussom; tego nie
  wiemy (prawo samplera otwarte). Sposób sprawdzenia: (i) symulacja prawa
  Sign po castach dla N=1536, (ii) wyprowadzenie warunku akceptacji z
  rzeczywistego prawa, (iii) wtedy dopiero `sigma_N ∝ sqrt(N)` dla
  scenariusza B.
- **H-C (stała błędu FFT3).** Empiryczne `c_emp ≤ 0,209` (orakel MPFR
  256-bit) sugeruje margines rzędu 40× wobec prostej granicy `8ℓ`; hipoteza:
  prawdziwa stała to `c ≈ 2–3` na poziom. Sposób sprawdzenia: dowód
  krok-po-kroku po grafie operacji `falcon_FFT3` z kontraktami FPEMU
  (zależność od ℓ jest liniowa — to już wiadomo).
- **H-D (próg „overstretched").** Przy q = 18433 i N ≤ 3072 reżim
  overstretched (ataki podciałowe z normowaniem w dół) nie powinien się
  zaczynać; warunek jakościowy z literatury (Ducas–van Woerden) dotyczy
  wykładniczo rosnących q. Do sprawdzenia liczbowo dla każdego z 7 podpól.

## 3. Nierozstrzygnięte pytania (bez eufemizmów)

- Prawo samplera po rzutowaniach, realny PRNG i straty kompozycji
  (Rényi/χ², wspólne historie) — otwarte w NEXT_INTERFACE etapów repo i tutaj.
- Wystarczalność precyzji dla FT3072 — otwarte; dla FT1536 mamy jedynie
  rekurencję FFT3 i walidację, nie pełny dowód algorytmu.
- Bezpieczeństwo `Q < B → int16` przed rzutowaniem — świadomie poza zakresem.
- Dlaczego tabela progów `falcon_is_short` dla logn 3–9 ma krok ≈ 1608.2 w
  `bound/(2N)` — brak wyprowadzenia w źródłach (SIG-001); archeologia
  w `results/bounds_table.json` łączy to z majowym `160982450`.
- Czy model „circulant" estymatora przenosi się na pierścień `Φ_{3N}` bez
  straty/ubytku — warunek wstępny kampanii.
- Niezależne sprawdzenie: proponujemy, żeby recenzent przeliczył SA1–SA6
  (skrypty są samodzielne) i sprawdził pliki Lean w czystym środowisku
  (`lean plik.lean`, czysty log).

## 4. Zadania na następne cykle

1. **Kampania estymatora P1/P2** (właściciel + wykonawca): zamknąć warunki
   wstępne `estimator_campaign/README.md`, uruchomić z przypiętym SHĄ
   estymatora, zapisać pełne wejścia/wyjścia; w tabeli najpierw NOT_RUN.
2. **Prawo samplera po castach dla N=1536** (wykonawca + niezależny replay):
   symulacja 3072-call adaptive joint law → rzeczywisty stosunek akceptacji i
   weryfikacja hipotezy H-B.
3. **Dowód rekurencji błędu z kontraktami FPEMU** (wykonawca): formalizacja
   poziomów FFT3 w stylu modułów H3 (krok w stronę kernela dla C11).
4. **Analiza podciałowa ABD dla 7×3 podpół** (wykonawca): dla każdego
   podciała zdefiniować normowany rozkład i warunki podniesienia (to jest
   brak, który recenzent wskazał wprost).
5. **Scenariusz B: kryterium → parametry** (decyzja właściciela): przyjąć
   kryterium porównania (akceptacja/geometria/koszt), wtedy dobrać
   `sigma_N/B_N/q_N` dla FT768/FT3072 jako `ALTERNATIVE_PROPOSAL`.
6. **Benchmarki** dopiero po powyższych: KeyGen/Sign/Verify dla 768/1536 —
   z rozdzieleniem najgorszy/oczekiwany/mierzony.

## 5. Weryfikacja bibliografii (ślad) i środowisko

**Sage w tym środowisku (SageMath 10.9, nowy CLI):** `sage plik.py` uruchamia
zwykły Pythona z importowalnym `sage.all` i **bez preparsera** (to odpowiednik
używanego w kampanii S20 `sage -python`, którego w tej wersji CLI już nie ma);
`sage plik.sage`, `sage -c` i REPL używają preparsera (literały →
Integer/Rational); równoważnie: `/home/footfalcon/miniforge3/envs/sage/bin/python
plik`. Przy odtwarzaniu skryptów z kampanii S20 (celowo pythonowych, z
`Decimal`) komendę `sage -python scripts/x.sage` tłumaczymy na
`miniforge3/envs/sage/bin/python scripts/x.sage`, nigdy na `sage x.sage`.

Sprawdzone bezpośrednio w źródłach w dniu 2026-09-21: lista autorów Falcona
(falcon-sign.info), publikacje T. Presta (tprest.github.io: ASIACRYPT 2017
Rényi = ePrint 2017/480, ISSAC 2016 z L. Ducasem, EUROCRYPT 2015 z
V. Lyubashevskym, PKC 2019 z T. Porninem, PQCrypto 2020 z Howe/Ricosset/Rossi,
praca CRYPTO 2026 o implementacji fixed-point Falcona z De Almeida Bragą,
Fouque i Lachguelem, praca doktorska 2015), Albrecht–Bai–Ducas ePrint
2016/127 (tytuł/autorzy z ePrint), ADPS16 = Alkim–Ducas–Pöppelmann–Schwabe,
USENIX Security 2016 (referencje estymatora), Albrecht–Player–Scott JMC 9(3)
2015 / ePrint 2015/046 (README estymatora), Kirchner–Fouque EUROCRYPT 2017 i
Ducas–van Woerden ASIACRYPT 2021 (referencje estymatora), Howgrave-Graham
CRYPTO 2007 i Wunderer JMC 2019 (referencje estymatora), FIPS 204 = ML-DSA
(status NIST). **Nie znaleziono** potwierdzenia dla ePrint 2023/1234 i
2021/567 (usunięte); ePrint 2020/1433 to inna praca (sprawdzone!) — dlatego
specyfikacja Falcona cytowana jako raport techniczny submissionu NIST.
Status FIPS 206: w dniu pozyskania brak strony IPD na csrc.nist.gov —
podany jako „draft w przygotowaniu" bez wymyślonego URL.
