# FT1536 — teza publikacyjna, mapa dowodów i plan następcy REV5

Data: **2026-09-17**. Dokument roboczy dla autora: **Niirmata**. Wynik zadania redakcyjno-merytorycznego; nie nowy werdykt właścicielski ani publikacja.

## Decyzja redakcyjna w skrócie

**Rekomendacja: preprint o konstrukcji FT1536 i dwóch konkretnych wynikach analitycznych — fixed-key sharp-truncation T2C3 oraz odrębnym successful-key T5.** Najbliższa publikacja ma pokazać istniejące osiągnięcia wraz z pełnym zakresem przesłanek i odtwarzalności. Domknięcie produkcyjnego samplera i całej redukcji bezpieczeństwa jest dalszą pracą, a nie warunkiem opublikowania tych dwóch wyników.

Najpilniejsza czynność: **usunąć z aktywnego wywodu następcy REV5 pomieszanie danych starej instancji z K0**, zaczynając od `hyp:F0`, `hyp:F2`, `hyp:F1`, `hyp:F1b` i `hyp:far-bins`. Nie wystarczy dopisać poprawnych hashy na końcu paperu.

W sprawdzonym REV5 występują jednocześnie:

- poprawny końcowy wynik kanoniczny `E_(h*)^Q<2^-89` i właściwe manifesty;
- stare `Q(f,g)=2087`, normy wierszy `8348/3`, `1509877/3` oraz `lambda_max<9860`;
- opis `COMP_STATIC` jako skompresowanego formatu, lecz niepoprawnie przypisana mu dokładna domena dekodera i pomieszane rozmiary formatów;
- poprawny lemat projekcji dla **już znormalizowanego** profilu, który trzeba zachować obok osobnej poprawki raw-count normalization D11E1 V2.

To są zadania redakcji następcy manuskryptu i uzgodnienia jego przesłanek z istniejącym dorobkiem. Nie cofają historycznie obronionego T2C3 ani odrębnego T5.

## 0. Podstawa dokumentu i zakres pracy

### 0.1. Zamrożone wejścia

Przed analizą sprawdzono wszystkie pięć głównych pinów z polecenia, w tym końcowy raport D11E2. Wszystkie były zgodne; nie zmieniono przypięcia.

| Wejście | SHA-256 |
|---|---|
| REV5 TeX | `64127490a2793379e25582354387f7fd155de1fee434eee9f06833bdf7bd7a9f` |
| Suplement S20 REV3 TeX | `425d24ece7a0fe5de27aa10ea07ae54a85034a956554f06d78352a6e06dff28d` |
| Raport ciągłości K0 | `def738641b8072e723fc4f457a3eb4f60ad6c102fd7a7b371e27faa9a0ba081c` |
| Końcowy raport D11E2 | `b9b7231729908449986afc448aee9c256ec435668b403b8f3c25b0088eec9e9f` |
| D11E1 V2 THEOREM | `0c2c33efd0f1f655baf5d81b27ca73086d47fdd9aaa244d75eba87626188edb7` |

Oznaczenia ścieżek:

```text
H = /media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon
F = H/evidence/candidates/framework_d641
P = H/evidence/candidates/paper
DOC = /home/footfalcon/Dokumenty
G = obiekty Git w H pod d641ab1037c2fa1dd4a22c258854d79d67b9b46b
FC = F/T2C3-CANONICAL-FINAL-COMPOSITION-001-20260822-a1
T5 = F/T5-KEY-QUANTIFIER-DECOMPOSITION-001-20260822-a2
FR = F/FT1536-RESEARCH-FREEZE-T2C3-T5-001-20260822-a1
V2 = H/evidence/candidates/d11e1_v2/D11E1_V2
```

W tekście `R_K0` oznacza przypięty raport ciągłości, a `R_E2` przypięty końcowy raport D11E2. Pełne nazwy plików i wszystkie 47 faktycznie użytych wejść są w aneksie I.

### 0.2. Referencyjna implementacja i znaczenie COMP_STATIC

Referencją paperu jest **S17 / `H/build`**, z manifestem

```text
G:evidence/_work/PO-01-BASELINE-001-20260803-a1/source_hashes.sha256
SHA-256: 03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589
```

Zgodność historycznej ścieżki i `H/build` w 17/17 plikach pochodzi z przypiętego `R_K0`. W tej sesji dodatkowo odczytano i zahashowano trzy potrzebne pliki S17: `falcon-enc.c`, `falcon-sign.c`, `falcon.h`. Nie rozpoczęto ponownego ogólnego audytu repozytorium. Zgodnie z decyzją właściciela warning-clean `free_falcon_sign/Extra/c` jest wycofany jako propozycja domyślnej bazy tej publikacji; historyczne twierdzenia pozostają związane z S17.

Wyjaśnienie nazwy sprawdzone w kodzie:

- `H/build/falcon.h:53–54`: `FALCON_COMP_STATIC` oznacza „Compression with static codes (approximation of Huffman codes)”.
- `H/build/falcon.h:268–271`: długość podpisu z kompresją może się zmieniać.
- `compress_static` używa dla q=18433 `10+floor(|x|/256)` bitów na współczynnik.

**COMP_STATIC = stały schemat kodowania, zmienna długość skompresowanego podpisu.** Zachowujemy ten skompresowany profil w opisie konstrukcji. Nie utożsamiamy słowa „static” ze stałą długością ani z constant-time.

### 0.3. Co wykonano

Wykonano publiczne odczyty, hashowanie, odczyt dwóch obiektów Git i analizę tekstu/etykiet TeX oraz kontraktów wywołania publicznych checkerów. Nie wykonywano historycznych runnerów, nowych dowodów numerycznych, kompilacji TeX, KeyGen ani prywatnego replayu. Fragmenty do wstawienia poniżej są **propozycjami nowej redakcji**. Repozytoria, historyczne TeX-y, certyfikaty, manifesty i wcześniejsze raporty pozostają niezmienione.

# A. Jedna rekomendowana teza najbliższej publikacji

## A1. Teza po polsku

Najbliższy paper powinien przedstawić FT1536 jako rozwijaną przez Niirmatę konstrukcję podpisu hash-and-sign z pełnoternarną propozycją sekretu, jawnym predykatem KeyGen i metryką weryfikacji A2, opartą implementacyjnie na historycznym Falcon EXTRA, oraz udokumentować dwa różne osiągnięcia analityczne: dla konkretnej instancji K0 — ograniczenie energii obrazu idealnego Gaussa po ostrym obcięciu `Q<B`, `E_(h*)^Q<2^-89`, uzyskane z zachowaniem wszystkich częstotliwości publicznych i aliasów Poissona; dla każdego skutecznego wyjścia zamrożonego KeyGen — niezależne ograniczenie pure/untruncated graph-dual theta `rho(L_h)-1<2^-40`, z właściwym dla tego twierdzenia `delta_key=0`. Wkładem publikacji jest konkretna specyfikacja i adaptacja FT1536, konstrukcyjnie związane wyprowadzenia, certyfikaty i ich audytowalna kompozycja; klasyczne narzędzia NTRU, GPV, Falcon, Poissona, sum Gaussa i theta zachowują swoje przypisanie. Czytelnik otrzymuje precyzyjne twierdzenia, przesłanki i publiczny zakres replayu, a dalsze mosty do rzeczywistego samplera, serializacji i pełnej redukcji bezpieczeństwa są nazwane oddzielnie.

## A2. Proponowany tytuł

**FT1536: A Full-Ternary NTRU Signature Construction with Fixed-Key Sharp-Truncation and Successful-Key Theta Bounds**

Tytuł zachowuje konstrukcję jako główny przedmiot i eksponuje dwa kwantyfikatory. „Fixed-Key” zapobiega odczytaniu wyniku sharp-truncation jako twierdzenia o całej populacji kluczy.

## A3. Proponowany angielski abstract

194 słowa przy liczeniu tokenów rozdzielonych białymi znakami; mieści się w wymaganym zakresie 150–250.

<!-- ABSTRACT_BEGIN -->
We present FT1536, a developing full-ternary NTRU hash-and-sign construction over the degree-1536 cyclotomic ring with modulus 18433. Building on the historical Falcon EXTRA implementation and established NTRU and GPV-style sampling techniques, we specify the independent uniform coefficient-ternary proposal, the deterministic KeyGen acceptance predicate, and the offset-768 A2 verification metric. The paper establishes two distinct computer-assisted results. For one commitment-identified key, an analysis of the ideal Gaussian conditioned on the strict cutoff $Q<B$ retains every public Fourier frequency and integer Poisson alias, yielding $E_{h_\star}^{Q}<2^{-89}$. Independently, an integral coefficient-tower and block-LDL argument proves the pure, untruncated bound $\rho(L_h)-1<2^{-40}$ for the scaled graph-dual lattice of every public key emitted by successful source-bound KeyGen; its theorem-specific key-failure parameter is zero. The proofs combine exact lattice identities, shifted-theta bounds, rational comparisons, and outward numerical certificates. We identify the frozen implementation by file hashes and provide a public proof and replay map that distinguishes reproducible computations from key-dependent certificates produced using private inputs. These results establish concrete analytic properties of FT1536 without equating the implemented sampler with its ideal reference law. Production arithmetic, faithful serialization, and history-uniform security composition remain explicit interfaces for the continuing analysis of the signature scheme.
<!-- ABSTRACT_END -->

Abstract nie obiecuje przyszłego wyniku EUF-CMA, nie opisuje T5 jako uogólnienia T2C3 i nie reklamuje zgodnego hasha jako matematycznego dowodu.

## A4. Wkład autora i przypisanie istniejących technik

| Element | Jak opisać wkład FT1536 | Właściwe przypisanie / granica nowości |
|---|---|---|
| Konstrukcja i kod | Adaptacja do profilu FT1536: stopień 1536, pełnoternarna propozycja współczynników, predykaty akceptacji, tree/leaf gates, parametry i adaptacyjny bank propozycji | Historyczna implementacja Falcon EXTRA; zachować nagłówki `Copyright (c) 2017 Falcon Project` i `@author Thomas Pornin` oraz istniejące warunki licencji. Nie przedstawiać całego kodu jako napisanego od zera. |
| Specyfikacja i rozkłady | Jawne rozdzielenie surowej propozycji, pełnej akceptacji KeyGen, idealnej taśmy i rzeczywistego seed-pushforward; opis konkretnego profilu FT1536 | Architektura NTRU i GPV-style hash-and-sign oraz fast Fourier sampling z Falcon. Odpowiednie istniejące klucze bibliograficzne REV5: `ntru`, `gpv`, `falconSpec`. |
| Fixed-key sharp truncation | Specyficzna dla FT1536 kompozycja graph-theta, pełnych aliasów, konturu i certyfikatów K0; końcowa liczba i jej dowodowa ścieżka | Poisson, sumy Gaussa, theta, circle method i ogony kratowe są znanymi narzędziami. Cytowania już obecne: `wwater`, `berndt`, `vaughan`, `hw`, `banaszczyk93`. |
| Successful-key T5 | Związanie źródłowego leaf gate z dokładną geometrią, całkowitym drzewem współczynników, reciprocal LDL i konkretnym boundem dla całego successful-output support | Nie ogłaszać nowości shifted-theta maximum ani samego LDL. Ewentualna nowość uniwersalnej kompozycji dla tego profilu wymaga porównania z literaturą Falcon/GPV i Gaussian sampling. |
| Certyfikaty i replay | Dokładne artefakty pozwalające skontrolować liczby, dane wejściowe i konsumpcję przesłanek | Sage/Arb i praktyka computer-assisted proofs mają własne źródła: `sagemath`, `johansson`, `tucker`. Liczba PASS jest wynikiem testów, nie wkładem matematycznym sama w sobie. |

Rekomendowane sformułowanie nowości: **„We derive and certify the following bounds for the FT1536 profile.”** Na tym etapie unikać „first”, „optimal”, „strongest” i twierdzeń o przewadze nad Falcon, których nie uzasadnia porównanie z literaturą. Nie dodano żadnych nowych cytowań ani DOI; istniejące rekordy bibliograficzne wymagają zwykłego sprawdzenia autora przed wysłaniem paperu.

# B. Mapa twierdzeń do pracy redakcyjnej

## B1. Wspólna karta obiektów

```text
N = 1536: stopień pierścienia
d = 3072 = 2N: wymiar kraty podpisu
q = 18433
R = Z[x]/(x^1536-x^768+1)
Q0(a) = sum_i (a_i^2+a_i*a_(i+768)+a_(i+768)^2)
Q(z1,z2) = Q0(z1)+Q0(z2)
sigma_sign = 768
B_sig = 2093922385; zdarzenie idealne A={Q<B_sig}
A_h(z1,z2) = z1+h*z2 mod q
Lambda_h = ker(A_h mod q)
```

Dual `Lambda_h*` należy zdefiniować względem standardowego iloczynu współrzędnych, a metrykę dualną stosować oddzielnie jako `Q*(w)=w^T M^-1 w`. Dodatni integralny graf `Gamma_h={(a,b):b=ha mod q}` i przeskalowana krata T5 `L_h=s M^-1/2 Lambda_h*` to różne obiekty.

## B2. Tabela: teza → kwantyfikator → prawo → dowód → odtwarzalność

| Teza | Kwantyfikator i prawo / metryka / obcięcie | Przesłanki i dowód analityczny | Certyfikat / checker / źródła | Co czytelnik odtwarza publicznie |
|---|---|---|---|---|
| **Konstrukcja i algebraiczna poprawność** | Dla poprawnej czwórki NTRU i integralnego wyniku spełniającego wskazane warunki reprezentacji; nie twierdzenie o wszystkich zachowaniach C | `fG-gF=q`, `h=g/f`, dokładne `A_h`, znak `w1=-z1`, niezmienniczość Q przy negacji całego pierwszego składnika, faithful decoding i warunki zakresów | REV5 §4: `eq:row-basis`, `eq:graph-basis-scheme`, `eq:coset-relation`, `thm:correctness`; S17 `falcon-enc.c`, `falcon-sign.c`, `falcon.h`; formalny model próby T5-a1 | Symboliczne relacje i odczyt źródeł. Nie wolno przedstawiać tej implikacji jako pełnego proof of implementation correctness albo twierdzenia o rozkładzie samplera. |
| **Fixed-key T2C3** | Dokładnie jeden `h=h*` z K0; `Z~mu0` o masie proporcjonalnej do `exp(-Q/(2 sigma²))`; obraz `A_h(Z)` po `Q<B_sig`; `E(P)=q^N sum P(c)^2-1` | Tożsamość K0 i bazy; poprawne metryki/Frobenius; kanoniczne D7/D9; all-frequency/all-alias D11E2; `E_h^0<2^-90`, `T_h<2^-99`, `p_T<2^-24`; Route C z mianownikiem `(1-p_T)^2` | REV5 §16 `thm:current-t2c3`; `FC/THEOREM.md`; certyfikat `a5b1b220a24670b40c6c79cb1c6469cb9f470c8cd8c1167ed0c6fa882094a7ff`; checker `51466e687c675f84bfb44b0f24b3e7e381d844bad4dc94a2ebc188a3ffa0516c`; R_K0, R_E2 | Publiczny argument, arytmetyka E2 przy zadanych endpointach i końcowy ułamek. Pierwotne uzyskanie danych prywatnej bazy/spektrum nie jest publicznym replayem bez prywatnego wejścia. |
| **Successful-key T5** | Dla **każdego** publicznego klucza wyemitowanego przez skuteczny S17 KeyGen; pure/untruncated graph-dual theta; `L_h=s M^-1/2 Lambda_h*`, `s=sqrt(2pi)*768` | NTRU i invertibility; obowiązkowy source leaf gate; model emulated-FPR, twiddle audit i most machine→exact; integralne podziały, block LDL, reciprocal reversal, shifted-theta induction | REV5 §17 `thm:t5`; `T5/GLOBAL_LEAF_A2_BRIDGE.md` — `6b71f8a1f3924575eb5acf43412ef834451754ec5a660bbff62ce9729fa9bf1a`; checker `2da5143e142e812a432605b9b17a8020fff01e2d84296eb551ad93ece69a7103`; certyfikat `380041add1b4a6f25aabce5d0c43b0ab9c545a9eea1cceec0a5a32113f21736f` | Publiczne źródła, twiddle certificate, dokładne recurrences, symbolic identities i końcowy product bound. Nie trzeba generować klucza ani używać kampanii kluczy. Indukcja dla pełnego N jest dowodem tekstowym; małe exact instances w checkerze go nie zastępują. |
| **Rzeczywisty sampler C** | Źródłowe kernele na osiągalnych centrach, szerokościach i historiach; finite CDF, 55-bit comparator, cutoff i jawne fault/abort | Oddzielne H1/H1R, H2, H3, H4; dokładna idealna rejection identity nie dowodzi równości prawa produkcyjnego; składanie warunkowe po 3072 scalar calls | S20 REV3 `lem:exact`, `lem:callgraph`, `lem:H4`, `prem:H1R`, `prem:H3`, `thm:R1`, `thm:R2`; mapa źródłowa S17 | Odczyt programu i publicznych certyfikatów poszczególnych warstw. Liczby R1/R2 przedstawiać z pełnymi przesłankami; żadnego automatycznego „sampler is Gaussian”. |
| **Pełna redukcja bezpieczeństwa** | R3 wymaga jednolitości po historii; R5 w suplemencie jest klasyczny ROM, averaged over accepted KeyGen law; inne kwantyfikatory niż T2C3 i T5 | H1R/H3, H6, exact public reference sampler, history/abort/nonce coupling, R4 jako założenie MT-ISIS; osobne programmable-XOF i QROM interfaces | REV5 §20 `sec:remaining`; S20 REV3 `thm:R3`, `ass:R4-mtisis`, `thm:R5-ROM`, `rem:QROM` | Czytelnik sprawdza warunkową strukturę argumentu i rachunki strat. Nie otrzymuje z tych danych bezwarunkowego EUF-CMA, hardness theorem ani liczby bitów bezpieczeństwa. |

## B3. Właściwa ścieżka T2C3 dla K0

Karta K0 do umieszczenia w paperze lub jego aneksie:

| Element | Wartość / identyfikator |
|---|---|
| Publiczny klucz | `F/T2C3-CANONICAL-KEYGEN-001-20260819-a1/canonical_public_key.bin`; `57c49fb228013b0bfc4907c754d747dca93c1049d2945ccd6cd686e9f95afc6f` |
| Publiczne h | `canonical_public_h.txt` w tym samym pakiecie; `ce1aef69b5998e6f214bc6a45cf6abc36fb1753d595ef1d7b0e6c1cecd9d17f2` |
| Baza surowa | Literalna czwórka z commitmentu SK i przypiętego dekodera; `Q(f,g)=2044`, `Q(F,G)=552238` |
| Baza pomocnicza zredukowana | `F'=F-Tf`, `G'=G-Tg`, algorytm `NormalizeOrderedCompanionA2BCD`; `E_comp=448642` |
| Commitment T | `9135c32e42dcff7d70c9e0f8f72eec8769e4f52d61d74c0cc38eb04dbf0de2c2` |
| Commitment (F',G') | `80c6cb150959a80b89f50f9303af89e255f2354900e10cbf7cd1e6aa4a5580f2` |
| D7 endpoint object | `d44d47fb0d12d4df5a5373af72fffecf93b9d78f249232c96be76bd857fa3b1d`; konserwatywnie `lambda_min>113`, `lambda_max<9923` |
| D11E2 manifest | `45429b457e216286cecab310c63169b63d116dbfe17f07653219ea389da4df76` |
| Końcowy FC manifest | `852659713bc97c881606ee8fe53cb14f39b5e5351c1ec0cc028c4fafab41cd9c` |
| Integracja / freeze | `b478ba359cfea7b18243c95a9705351491bb167b` / `d641ab1037c2fa1dd4a22c258854d79d67b9b46b` |

Tożsamości tej karty pochodzą z przypiętych R_K0/R_E2 i odpowiadających im map artefaktów; nie czytano prywatnej bazy. Zredukowany companion jest narzędziem dowodu dla tej samej kraty, nie stwierdzeniem, że signer produkcyjny został przełączony na inną bazę.

Mapa matematyczna do figury w paperze:

```text
K0 + uporządkowana baza + deterministyczna redukcja
  -> skumulowana koherencja -> D2 przy tilt beta

K0 + kanoniczny D7 + D5
  -> support bounds D8 -> doubled theta D9 -> E_h*^0 < 2^-90

A/B/C3 + kanoniczny D7 + D9 + D11D1 + D3
  -> pełny cover D11E2 -> mean_E < 2^-79 -> T_h* < 2^-99

E_h*^0 + T_h* + p_T + dokładne Route C
  -> E_h*^Q < 4489/[2^54 (2^24-1)^2] < 2^-89
```

D2 przy beta i D9 przy skali sigma to różne obiekty. Tabela/figura ma pokazywać faktyczną konsumpcję, nie tylko kolejność nazw etapów. D11E1 V2 nie jest nową wersją D11E2; jego naprawa q-local normalization nie jest przesłanką liczbową globalnej drogi E2. Nie potrzeba ponownego „wynalezienia” mostu D7→E2.

## B4. Właściwa ścieżka T5 i zakres delta_key=0

```text
S17: pełna deterministyczna akceptacja KeyGen i obowiązkowy leaf gate
  + publiczny twiddle audit i model arytmetyki
  -> exact leaves > 991
  -> Lambda_h = B_basis Z^(2N)
  -> integralny tower, exact block LDL, reciprocal reversal
  -> 1536 inverse-A2 factors + shifted-theta induction
  -> rho(L_h)-1 <= (1+6*2^-65/(1-2^-65)^2)^1536-1 < 2^-40
```

T5-a2 zachowuje zaakceptowane podwyniki a1 dotyczące prawa KeyGen i numerical leaf bridge, a naprawia globalny krok, który a1 miał tylko zadeklarowany. `A1_MATH_REVIEW_ASSERTION.json` dokumentuje ten historyczny REJECT wraz z listą zachowanych podwyników; późniejszy FR zapisuje osobne ACCEPT dla **manifestu a2**. Nie przenosi się całej oceny a1 na a2 ani nie interpretuje starego REJECT jako odrzucenia poprawionej wersji.

`delta_key=0` dotyczy zbioru dobrych kluczy **wewnątrz successful-output support**. Nie znaczy, że KeyGen nigdy nie kończy się błędem, że f,g po akceptacji są iid, ani że seed-pushforward jest informacyjnie równy idealnej nieskończonej taśmie. T5 nie korzysta z kampanii ani z konkretnego K0 jako dowodu populacyjnego.

## B5. Rola suplementu S20 REV3

Zachować jako **oddzielny dokument warunkowych interfejsów produkcyjnego samplera i dalszej redukcji**, z krótkim odsyłaczem w §20 paperu. Nie dołączać go do wniosku głównych twierdzeń przez samą obecność obok REV5.

Suplement dostarcza istotnych szczegółów: 1536 terminali × 2 = 3072 scalar kernels, oddzielenie H1 absolute error od high-order likelihood, zakresy H4, conditional R1–R3 i klasyczny R5. Równocześnie sam nazywa H1R/H3/H6 i exact reference sampler otwartymi przesłankami. Jego `COMP_NONE` w opisie gry G0 oraz nazwy `n=1536, N=3072` wymagają jawnego mapowania do profilu i notacji nowego paperu. Liczb ani gwarancji bajtowych nie wolno przepisać do COMP_STATIC bez tego sprawdzenia.

# C. Minimalny plan redakcji REV5 — dokładnie pięć poprawek

Numery sekcji poniżej wynikają z poleceń `\section` REV5. Etykiety i numery linii odnoszą się do wejścia o SHA-256 `64127490a2793379e25582354387f7fd155de1fee434eee9f06833bdf7bd7a9f`. Poprawki są planem **nowego manuskryptu**, bez edycji tego historycznego pliku.

### P1. Jedna kanoniczna instancja w całym wywodzie fixed-key i jawne D11E2

**Miejsca:** §5 `hyp:F0`, `hyp:F2`, `hyp:F4` (749–779); §12 `thm:floor`, `rmk:floor-quant` (2066–2163); §13 `hyp:F1`, `lem:single`, `hyp:F1b`, `thm:theta2` (2205–2433); §15 `lem:central`, `lem:tilted`, `lem:alias`, `hyp:far-bins`, `thm:global-energy` (2666–3005); §16 `thm:current-t2c3`.

**Problem:** końcowe twierdzenie jest kanoniczne, lecz części przesłanek i przykładów numerycznych są dla starej instancji. Wprost występują `Q(f,g)=2087`, `lambda_max<9860`, stare profile i stare fingerprinty support sum. `FC/THEOREM.md` wyklucza 9860 jako przesłankę kanonicznej kompozycji.

**Poprawa:** przepisać aktywną ścieżkę tych sekcji według karty K0 i istniejących kanonicznych D5/D7/D8/D9/E2. Zachować historyczne nieudane lub zastąpione drogi jedynie w krótkiej nocie historycznej/diagnostycznej, poza przesłankami głównego twierdzenia.

| Stary zapis REV5 | Docelowy zapis / źródło |
|---|---|
| `Q(f,g)=2087`, `8348=4Q(f,g)` | K0: `Q(f,g)=2044`, `8176=4Q(f,g)` |
| `1509877/3` dla wierszy reduced companion | Jawnie B1: `4E_comp/3=1794568/3`, przy `E_comp=448642`; nie mylić z raw companion `4*552238/3` |
| `lambda_min>63.5`, `lambda_max<9860` | Kanoniczny D7: konserwatywnie `lambda_min>113`, `lambda_max<9923`; dokładne racjonalne endpointy z przypiętego certyfikatu |
| Stary fingerprint support sum `348c80...` i `Lambda_1=2087` | Kanoniczny D8: `Lambda_1=2044`, właściwy profil D7 i certyfikat `180c34a018f00b23e6ad5b9f6dd1e312308326d4e6d68e32e83373d287674254` |
| Centralny zapis `E(t)<=tau_2` jako nierozwinięty certificate premise | Jawny wariant kanoniczny z `epsilon=7/100`, `E(t)<(3/2)2^-80<2^-79`, opisany w R_E2 §8.2 |
| Near-minor / 33 biny / large jako niepowiązane hypotheses | Mapa lematu graph-theta i all-alias do konkretnych funkcji checkera, binów i certyfikatu E2 |

Nie wykonywać mechanicznej zamiany `lambda_floor` na `1/448642` w `lem:tilted`: **dolna granica normy niezerowego wektora i dolna granica formy przez normę jego współrzędnych to różne twierdzenia**. Najmniejszą poprawą jest zastąpienie tej niepotrzebnej dla aktywnego E2 starej drogi przez istniejące kanoniczne interfejsy D2/D9 i centralną argumentację R_E2.

Wprowadzić do tekstu: dokładny completion of squares przy całkowitym parametrze; realny shear obsługiwany shifted-theta maximum; mapę `(u,m)->m-c xi_u`; pełny mianownik theta i krotności; właściwe endpointy; pięć części coveru. Punkt `K²=9` należy do binu z `d_c=3`; rozdzielić `E_comp` i `A_ratio=a0/beta`.

**Rodzaj:** korekta matematycznego zapisu przesłanek i redakcyjne związanie **istniejącej** ścieżki; nie nowe badanie D7→D11E2. Krótkie rozwinięcie centralne i własność końców binów z R_E2 oznaczyć jako obecną redakcję autora, nie treść dawnych recenzji.

**Proponowany akapit do nowej wersji (EN):**

> All fixed-instance estimates in this section refer to the same commitment-identified key and ordered NTRU basis. The deterministic companion reduction preserves the graph lattice while fixing the auxiliary basis used by the certificates. We use the canonical spectral bounds \(\lambda_{\min}>113\) and \(\lambda_{\max}<9923\). The graph-theta completion and all-alias Poisson argument apply with these endpoints; numerical bounds from the earlier key are not premises. The central, near-minor, moderate and large ranges are tied explicitly to the canonical D11E2 certificate. The expanded central-arc argument is given here as part of the present exposition, rather than attributed to an unavailable historical review report.

**Kontrola redakcji:** żadne aktywne odwołanie `hyp:F0` nie prowadzi do 2087/9860; stare wartości, jeśli zachowane, są oznaczone historycznie. Wszystkie aktualne liczby mają przypięty artefakt i właściwy obiekt matematyczny.

### P2. D11E1 V2: normalizacja liczności, bez psucia poprawnego lematu projekcji

**Miejsca:** §14 `sec:shell-fiber`, `thm:shell`, `rmk:shell-budget` (2441–2592); §15 `lem:projection` (2947–2978), `thm:global-energy` (2983–3005).

**Poprawa główna:** zachować `lem:projection` dla `P_c=M^-1(1+epsilon_c)`, `sum epsilon_c=0`, także w jego poprawnej wersji zespolonej. Dodać osobny lemat dla rzeczywistych surowych liczności i odsyłać do niego tylko tam, gdzie takie liczności są normalizowane.

**Proponowany fragment (EN):**

> The projection identity above concerns an already normalized zero-mean relative error. For raw counts \(N_c=A_{\mathrm{raw}}(1+e_c)\), with \(|e_c|\le\delta<1\), put \(\mu=M^{-1}\sum_c e_c\). Normalization gives
> \[
> P_c=M^{-1}\left(1+\frac{e_c-\mu}{1+\mu}\right),\qquad
> M\sum_cP_c^2-1=\frac{\operatorname{Var}(e)}{(1+\mu)^2}
> \le\frac{\delta^2}{1-\delta^2}.
> \]
> We use this corrected raw-count interface for the q-local estimate. For \(\delta_q=(18433-1)/18433^{768}\), its upper envelope remains below \(2^{-21736}\). This normalization repair is D11E1 V2. The canonical D11E2 global contour argument does not consume the D11E1 energy values.

Przedział `2^-21737 < delta_q²/(1-delta_q²) < 2^-21736` dotyczy **górnej obwiedni**, nie dolnego ograniczenia rzeczywistej energii. Status pakietu V2 to `PROVED_CANDIDATE_PENDING_DUAL_REVIEW`; nie kopiować na niego starszych ACCEPT V1. Zarazem brak zakończonego cyklu V2 nie jest nową przesłanką main theorem T2C3, skoro E2 nie konsumuje jego liczb.

W tej samej korekcie interfejsu finite-field usunąć dwa konkretne przekłamania zapisu: w 2457–2460 mianownik przy `h=g/f` powinien być `f(zeta)f(zeta^-1)`, nie `|g(zeta)|²`; nad F_q używać iloczynów w parach wzajemnie odwrotnych, nie zespolonego modułu. W `lem:qgauss` rozliczyć wyraz u=0 w rzeczywistej ekspansji shell: wewnętrzna suma ma q^N, a czynnik 1/q daje q^(N-1). Nie potrzeba twierdzenia, że faza sumy Gaussa jest niezależna od współczynników diagonalnych; używany jest jej moduł.

**Rodzaj:** lokalna korekta matematyczna w oparciu o istniejący V2 oraz korekta błędów zapisu finite-field. To nie globalna zamiana wszystkich `delta²`.

**Kontrola redakcji:** każde wystąpienie `delta²` jest opisane jako normalized-profile bound albo zastąpione właściwą raw-count normalizacją; D11E1→D11E2 jest oznaczone provenance-only, a nie jako brakująca przesłanka liczbowa E2.

### P3. COMP_STATIC, domeny kodera/dekodera i rozmiary

**Miejsca:** §4 `tab:parameters` (284–304), początek profilu (278–282), `alg:sign`, `alg:verify`, `thm:correctness` (618–689); §19 `sec:source-map` (3361–3369). W suplemencie: `prem:H6` oraz opis G0 przy `thm:R5-ROM`.

**Poprawa:** zachować **skompresowany COMP_STATIC**. Zastąpić nieścisłą „canonical size” dokładnym opisem zmiennej długości i oddzielić format od zakresu matematycznego. W S17 stałe są kody, nie liczba bajtów.

**Proponowany akapit (EN):**

> The implementation profile uses COMP_STATIC, a variable-length encoding with fixed coding rules. For q=18433, a coefficient x contributes \(10+\lfloor|x|/256\rfloor\) bits before final byte padding; this does not define a fixed-size signature. The nonce is supplied separately to the signing API. The ideal truncation event \(Q<B\), the decoder's admissible byte language, and faithful serialization are distinct interfaces. In particular, the centered interval required by a mathematical witness argument is not asserted merely from the name of the compression mode.

Dla wektora z2 przekazanego koderowi:

\[
L_{\mathrm{STATIC,payload}}=1+\left\lceil
\frac{\sum_{i=0}^{1535}(10+\lfloor|z_{2,i}|/256\rfloor)}8
\right\rceil.
\]

40 bajtów nonce liczyć osobno; jeśli format publikacji dołącza nonce, podać sumę i dokładny sposób opakowania. Dla porównania `COMP_NONE` ma `2N+1=3073` bajty payloadu. **Nie przenosić tej stałej długości na COMP_STATIC.**

Dokładne miejsca niezgodności z kodem:

- REV5 641–648 mówi, że dekoder Huffmana akceptuje dokładnie `[-9216,9216]`. `H/build/falcon-enc.c:462–545` takiego sprawdzenia nie zawiera; np. pole kodujące 9217 przechodzi tę część dekodera bez naruszenia zakresu int16. Kontrolę centered-domain widać w `uncompress_none`, linie 401–455.
- Wiersz klucza prywatnego `12289` w tabeli oznaczonej COMP_STATIC jest długością **czterech nieskompresowanych** wielomianów 16-bitowych z nagłówkiem. Dla compressed SK długość zależy od danych. Metadane K0 zapisują 7681 bajtów, co nie jest rozmiarem wszystkich kluczy.
- Średnie 2289/2329 nie mają w tej tabeli jawnego przypięcia do pomiaru i jego warunkowania. Rekomendacja: zastąpić je w tabeli głównej formułą długości; wartości empiryczne wracają dopiero do osobnej, przypiętej tabeli pomiarowej.
- W §19 wpisać, że `falcon-enc.c` zawiera HashToPoint, norm test i **oba** tryby małych wektorów; wybrany profil paperu pozostaje STATIC.

Nie dodawać do pseudokodu źródłowego fikcyjnego centered guard, którego kod nie wykonuje. `thm:correctness` ma jawnie wymagać faithful decoding i właściwych warunków domeny reprezentacji; jego implikacja algebraiczna nie dowodzi, że każdy przebieg produkcyjny spełnia te warunki. Suplement z COMP_NONE wymaga osobnego mapowania zanim jego byte-level stwierdzenia zostaną użyte dla STATIC.

**Rodzaj:** korekta specyfikacji i opisu source correspondence; H6 pozostaje osobnym obowiązkiem matematyczno-implementacyjnym. Nie jest to propozycja zmiany zamrożonego kodu.

### P4. Jedna notacja oraz jawna granica pseudokod–source–sampler

**Miejsca:** §4.2 i algorytmy samplera (348–372, 489–631); §12 `def:graph` (1994–2020); §13 `sec:spectral-embed`, `lem:uncertainty` (2182–2202, 2273–2286); §17 `eq:Bbasis`, `eq:Lh`; suplement `lem:callgraph`, `prem:H3`, `prem:H6`.

Wprowadzić jedną tabelę i używać jej w obu dokumentach:

| Symbol / nazwa | Znaczenie |
|---|---|
| N, d, m | 1536, 3072, 768 |
| Q0, Q | single-ring A2 form oraz suma dwóch takich form; nie współczynnikowa norma euklidesowa |
| Lambda_h | jądro `[I|H_h]` |
| Gamma_h | dodatni integralny graf `b=ha mod q` |
| Lambda_h* | standardowa dualna krata współrzędnych; M^-1 pojawia się jawnie w metryce |
| L_h albo calL_h | tylko przeskalowana graph-dual lattice w T5 |
| B_sig, B_basis | próg 2093922385 oraz macierz bazy — osobne symbole |
| E_comp, A_ratio | energia reduced companion 448642 oraz iloraz a0/beta |
| d_scalar | 1/(2 sigma_i²), nie wymiar globalny d |
| stored leaf, exact leaf | wartość maszynowa gate oraz dokładna wielkość po numerical bridge |
| terminal A2 block, scalar call | 1536 terminalnych bloków/par, **3072** wywołania skalarne na pełną próbę |

Poprawić 2182–2183: 1536 osadzeń daje **768 par sprzężonych**. W 2186–2192 i 2276–2278 normy w tożsamości śladowej zastąpić właściwym `Q0`: dla `r=1+x^768` mamy `Q0(r)=3`, a `||r||_2²=2`. To nie jest wyłącznie kosmetyka notacyjna. Użyć istniejącego kanonicznego D8 argumentu A2, zamiast przenosić równanie Parsevala dla niewłaściwej normy.

W `def:graph` rozdzielić Gamma od Lambda i usunąć utożsamienie dualności względem Q z odrębnie stosowanym M^-1. W `lem:alias` zachować znak `xi_u=-A_h^T u/q` spójny z konwencją conjugate character. Uzasadnić surjekcję/bijekcję całych klas, nie tylko samo słowo „injective”.

**Proponowany akapit o samplerze (EN):**

> The sampler pseudocode describes the mathematical decision structure. The S17 source additionally fixes finite CDF probabilities, binary64 operations, integer conversions, random-bit consumption, cutoff handling and fault propagation. A terminal A2 block invokes two history-dependent scalar kernels, giving 3072 scalar calls per complete residual sample. Exact real identities for the exponent do not identify the rounded source computation with that identity. The production comparison therefore retains H3, while the conversion from mathematical vectors to signature bytes retains H6.

Nie wyprowadzać production-width range z samego konserwatywnego T5 floor 991: `(4/3)*768²/991 > 768`. Suplement ma osobny bezpośredni H4 width certificate. Podobnie idealne `r=mu-floor(mu)` i przechowywane FPR `r_hat` należy rozróżnić. Pseudokod BerExp z wczesnym return nie jest automatycznie bit-exact opisem zużycia losowości ścieżki CT. W KeyGen odróżnić trial rejection od końcowych błędów kodowania opisanych w `FORMAL_ATTEMPT_MODEL.md`.

**Rodzaj:** redakcja nazw i interfejsów, z istotną korektą matematycznej definicji normy/dualności. Nie dopisywać przy tej okazji nieudowodnionej równoważności samplera C z idealnym Gaussem.

### P5. Wyeksponowanie wkładu, źródeł i rzeczywistej odtwarzalności

**Miejsca:** tytuł/abstract, §1 Contributions, §2 Related work, §18–§23 (`sec:verification`, `sec:source-map`, `sec:remaining`, `sec:repro`, `sec:transparency`, Conclusion).

Zastąpić front matter propozycją z części A. Dodać jednozdaniowe przypisanie historycznej implementacji Falcon EXTRA i tabelę wkładu autora. W §18 odwołać oba główne twierdzenia do ich oddzielnych manifestów i jawnej karty K0/S17. W §21 zastąpić ogólne zalecenie „run the package” rozdzieleniem publicznych checkerów od prywatnych producentów, opisanym w D.

**Proponowane akapity (EN):**

> The reference implementation is the 17-file S17 snapshot, identified by SHA-256, and derived from the historical Falcon EXTRA code. The original Falcon Project and Thomas Pornin attributions are retained. FT1536-specific choices, modifications and certificate interfaces are identified separately. The implementation identity used by the theorems is the frozen source snapshot rather than an unqualified current branch name.

> The two main results have different quantifiers. The sharp-truncation image-energy bound concerns the single canonical key, whereas the pure dual-theta bound applies pointwise to every successful output of the specified KeyGen predicate. Neither result identifies the production signature distribution with the ideal reference law. Numerical source correspondence, faithful serialization and adaptive transcript composition are continuing interfaces, not unstated premises silently added to the main claims.

> Public replay reproduces the stated arithmetic and symbolic certificates from their declared inputs. It does not reproduce a private producer merely by checking its commitment or a preserved review assertion. Historical internal acceptance records establish the recorded research lineage; independent mathematical assessment of this manuscript and its public evidence remains necessary.

W §22 ujawnić wykorzystanie nowych rozwinięć z raportu 2026-09-17 jako wsparcia redakcyjno-analitycznego i odpowiedzialność autora za włączony dowód. Nie przypisywać ich historycznym recenzentom ani traktować modelu jako źródła autorytetu matematycznego.

**Rodzaj:** redakcja tezy, przypisania i data-availability statement. Nie nowy rezultat kryptograficzny.

# D. Najmniejszy kompletny pakiet publiczny dla czytelnika

## D1. Zawartość rekomendowana

Rekomenduję **samowystarczalny podgraf publicznej weryfikacji obu głównych twierdzeń**, a nie eksport całego odzyskanego workspace. Zachować ścieżki potrzebne przez niezmienione checkery. Publiczny pakiet powinien zawierać:

| Część | Minimalna zawartość i rola |
|---|---|
| Paper | Nowy TeX i wygenerowany z niego PDF, jawne oznaczenie wersji, krótki changelog P1–P5. REV5 nie ma zewnętrznych `input/include/includegraphics`; bibliografia jest w pliku. |
| Specyfikacja | Parametry, algorytmy i notacja z B1/P4; profil COMP_STATIC, format nonce/payloadu, opis zakresów i warunkowego correctness. |
| Źródło | `build/` z dokładnie 17 plikami S17, oryginalny `source_hashes.sha256` oraz publiczny `tools/verify_build_baseline.py`. Zachować atrybucję i licencję. |
| Instancja K0 | Publiczne PK i h, karta tożsamości oraz publiczne commitment/validation metadata. Bez prywatnego SK, T ani współczynników F/G. |
| T2C3 | Analityczne FD/D5/D7/D8/D9/D3/E2 interfejsy potrzebne przez nowy tekst, właściwe publiczne certyfikaty i source pins; główny publiczny checker E2 i końcowy FC. Bez fałszywej obietnicy prywatnego endpoint replayu. |
| T5 | `THEOREM.md`, `GLOBAL_LEAF_A2_BRIDGE.md`, a1 law/numerical-soundness documents, twiddle audit i jego publiczny producent, a2 checker, expected certificate, potrzebne trzy dokumenty T1 i source bindings. |
| Normalizacja | D11E1 V2 jako jawna poprawka lokalnego raw-count interface i tabela provenance-only edge. Nie jako „D11E2 V2”. |
| Warunkowe dalsze interfejsy | Krótka mapa H1R/H3/H6/R3/R4/R5 w paperze oraz suplement z wyraźnym statusem warunkowym. Nie przedstawiać jego dołączenia jako dodatkowego main theorem. |
| Odtwarzalność | `REPLAY.md`, `ENVIRONMENT.md`, publiczne expected outputs i hashe, nowy manifest wydania obejmujący dokładnie faktycznie dołączone pliki, lista pominiętych historycznych elementów i ich ról. |
| Proweniencja | Identyfikatory b478ba/d641ab, oryginalne manifesty jako świadectwa pochodzenia oraz rozróżnione zapisy recenzji. Podpis/Git służy identyfikacji i autentyczności, nie rozstrzygnięciu dowodu. |

Pełna integralność **wycinka publicznego** i pełne odtworzenie **historycznego workflow całego repozytorium** to dwa zakresy. W minimalnym eksporcie nowy manifest wydania musi dokładnie wskazywać dołączone pliki. Jeśli nie dołącza się wszystkich członków starego manifestu, zachować go jako oryginalne wejście/proweniencję i opisać projekcję — nie ogłaszać, że niepełny pakiet przeszedł jego pełną walidację. Historyczne manifesty nie są przepisywane.

Praktyczna reguła domknięcia minimalnego podgrafu: E2 dostaje swój verifier, publiczny certyfikat i wszystkie 28 plików wymienionych w jego literalnym `EXPECTED_SHA256`; FC dodatkowo swój `SOURCE_BINDINGS.json` z wszystkimi jego rekordami, stage ledger i review assertions czytane przez checker; T5 dostaje wejścia repo/run z checkera, a1 twiddle audit, publiczny producent twiddles i dokumenty dowodu globalnego oraz numerical bridge. Dokumentacja matematyczna K0 obejmuje ponadto canonical foundation i publiczną część drogi redukcja → cumulative → D2 oraz D5/D7/D8/D9. Tak zdefiniowane domknięcie jest mniejsze od całego workspace i nie zastępuje brakujących plików pustymi stubami. Wytworzenie nowego spisu eksportu następuje dopiero przy przygotowaniu publikacji.

## D2. Publiczny replay a prywatny producent

| Obiekt | Publiczne sprawdzenie | Czego publiczny odbiorca nie uzyskuje automatycznie |
|---|---|---|
| Hash PK i zapis h | Porównanie bajtów, zgodność kodowania publicznego | Prywatnej czwórki ani zgodności jej commitmentu z nieudostępnionymi bajtami |
| Reduced companion / cumulative certificate K0 | Sprawdzenie metadanych, commitmentów, formalnej zmiany bazy i publicznego majorantu | Ponownego obliczenia T/F'/G' i prywatnych korelacji z samego publicznego h |
| D7 i E2 | Publiczne użycie endpointów, wszystkie biny/case bounds, prefaktor, full alias argument | Ponownego wytworzenia widma f,g bez prywatnych współczynników |
| FC | Dokładna kompozycja E0/T/p_T i porównanie z targetem | Świeżego dowodu wszystkich upstream przesłanek tylko z faktu, że FC zwrócił PASS |
| T5 | Publiczny source-bound numerical bridge, twiddle audit, exact symbolic checks i product bound; bez prywatnego klucza | Formalnego kernel-check całego dowodu tekstowego; testy małych stopni nie zastępują indukcji w paperze |
| Historyczne reviews | Odczyt manifest-bound assertions i ich dokładnego zakresu | Pierwotnych raportów recenzji, jeśli `artifact_persisted=false`; nowego zewnętrznego werdyktu |

**Rekomendacja dla pierwszego preprintu:** opublikować pełny jawny zakres publicznej weryfikacji i nazwać fixed-key private-producer boundary. Nie używać bez kwalifikacji hasła „fully reproducible from public data”. Osobną decyzją autora jest sposób umożliwienia niezależnej kontroli prywatnego producenta krytycznych danych K0; nie zakładam ujawnienia klucza ani nie uzależniam od tego redakcji obecnego twierdzenia z jawnymi certificate premises.

## D3. Środowisko i komendy planowanego replayu

Poniższe komendy są **planem dla przyszłego publicznego scratch**, nie zostały wykonane w tej sesji. Autor przygotowuje wcześniej kompletny wycinek wejść, sprawdza jego nowy manifest i kopiuje go do świeżego katalogu roboczego. `$ROOT` poniżej jest kopią roboczą pakietu, nie H, F ani oryginalnym podpisanym checkoutem.

Źródła historyczne podają **SageMath 9.5**, Sage Python **3.10.12**, dokładne `ZZ/QQ` i RBF. FC używa arytmetyki dokładnej; T5 używa również RBF512, a twiddle audit RBF256. Wersję systemu, bibliotek i toolchainu PDF należy zapisać z rzeczywiście przygotowanego środowiska publikacyjnego. Nie wymyślono pinu obrazu kontenera ani wersji TeX, których nie dostarczają wejścia. Nowe środowisko ma odtworzyć podane expected outputs przed opisaniem go jako reprodukcji.

Definicje dla poniższych wywołań:

```bash
ROOT=/absolute/path/to/fresh-public-scratch
E="$ROOT/evidence/_work/T2C3-REVALIDATE-D11E2-001-20260822-a1-CANONICAL"
FC="$ROOT/evidence/_work/T2C3-CANONICAL-FINAL-COMPOSITION-001-20260822-a1"
T5="$ROOT/evidence/_work/T5-KEY-QUANTIFIER-DECOMPOSITION-001-20260822-a2"
```

1. **Integralność eksportu:** `sha256sum -c MANIFEST.sha256`, przy `cwd=$ROOT`. Ten manifest jest przyszłym manifestem przygotowanego wydania, nie obecnie istniejącym artefaktem.
2. **S17 bez kompilacji:**

   ```bash
   GIT_OPTIONAL_LOCKS=0 python3 -B "$ROOT/tools/verify_build_baseline.py" --root "$ROOT" --working-tree
   ```

3. **Publiczny twiddle producer T5:**

   ```bash
   sage "$T5/inputs/a1/scripts/audit_fft_twiddles.sage" "$ROOT" > "$ROOT/reader-twiddles.json"
   cmp "$ROOT/reader-twiddles.json" "$T5/inputs/a1/FFT_TWIDDLE_AUDIT.json"
   ```

   Skrypt otrzymuje jeden argument — repo root — i drukuje JSON. Oczekiwany hash: `0b19e2944a7c698a09a058f01ccdf94697985a3e88dbbaa56a3075fbddcfd3a8`.

4. **T5-a2:**

   ```bash
   sage "$T5/scripts/verify_t5_uniform_a2.sage" "$ROOT" "$T5" "$T5/scripts/reader-normal.json"
   PYTHONOPTIMIZE=1 sage "$T5/scripts/verify_t5_uniform_a2.sage" "$ROOT" "$T5" "$T5/scripts/reader-optimized.json"
   cmp "$T5/scripts/reader-normal.json" "$T5/certificates/normal/certificate.json"
   cmp "$T5/scripts/reader-normal.json" "$T5/scripts/reader-optimized.json"
   ```

   To rzeczywisty kontrakt trzech argumentów pozycyjnych checkera. Jego output musi leżeć obok uruchamianego skryptu i nie istnieć przed startem. Ścieżka `evidence/_work/<T5>` zachowuje wymaganą relację do repo root. Oczekiwany hash certyfikatu: `380041add1b4a6f25aabce5d0c43b0ab9c545a9eea1cceec0a5a32113f21736f`.

5. **Publiczne E2 i końcowe FC:**

   ```bash
   sage "$E/scripts/verify_d11e2.sage" --run-root "$E" --output "$E/certificates/reader/d11e2.json"
   cmp "$E/certificates/reader/d11e2.json" "$E/certificates/public/d11e2_certificate.json"
   sage "$FC/verify_t2c3_final.sage" --run-root "$FC" --output "$FC/certificates/reader/final.json"
   cmp "$FC/certificates/reader/final.json" "$FC/certificates/normal/t2c3_final_certificate.json"
   ```

   Oczekiwane hashe: E2 `7cfc366d65415711c67486d82de21cb6b2d8e76a577935e11128324d5a2c1538`; FC `a5b1b220a24670b40c6c79cb1c6469cb9f470c8cd8c1167ed0c6fa882094a7ff`. E2 wymaga swoich 28 przypiętych wejść, w tym historycznych D11E1 plików do hashowania; V2 nie jest ich zamiennikiem. To wywołanie E2 nie uruchamia prywatnego endpoint producer.

Przed każdym wariantem używać świeżych, nieistniejących plików wyjściowych. Sage może tworzyć preparser transients, dlatego wszystko odbywa się w scratch. Nowy pakiet ma opisać kontrolę mutantów osobno: rzeczywiste zmiany formuły/parametru/manifestu oraz oczekiwany powód odrzucenia. Bezwarunkowy `require(False,...)` nie jest dowodem wykrycia usunięcia aliasów.

Planowany build nowego paperu, po przygotowaniu `paper/ft1536-preprint.tex` i zapisaniu faktycznej wersji środowiska TeX:

```bash
latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir="$ROOT/paper/build" "$ROOT/paper/ft1536-preprint.tex"
```

To przepis dla przyszłej kopii publikacyjnej, nie deklaracja istniejącego PDF ani polecenie wykonane obecnie. Następnie autor wiąże hashe PDF, TeX i pozostałych faktycznie użytych plików.

Nie proponuję uruchamiania `tools/verify_t2c3_paper.py` z dawnymi stałymi jako oracle kanonicznego paperu. Nie proponuję odtwarzania całości oryginalnego repozytorium w celu wykonania powyższego minimalnego podgrafu.

## D4. Bazy manifestów i wymagane wejścia do pakietu

- S17 `source_hashes.sha256`: wiersze typu `falcon-sign.c` są względne wobec **`build/`**, nie wobec folderu przechowującego manifest.
- `FC/output_hashes.sha256`, `T5/output_hashes.sha256`, `FR/output_hashes.sha256`: baza to właściwy katalog pakietu.
- `T5/SOURCE_BINDINGS.json` oraz repozytoryjna część `DEPENDENCY_BINDINGS.json`: baza to korzeń historycznego układu repozytorium, z `build/` i `source_of_truth/`.
- `FR/SOURCE_PACKET_BINDINGS.json`: `evidence/_work/...` jest względem repo root, nie FR.
- Nowy `MANIFEST.sha256` eksportu: jawna baza `$ROOT` i dokładne pokrycie faktycznie dołączonych plików.

T5 wymaga m.in. trzech publicznych plików T1 wskazanych w jego metadanych:

```text
source_of_truth/v2.3/Results/T1-POISSON-IMAGE-LEMMA-001/DEFINITIONS.md
21dcee91b39365e1c7c10fbe8882f497fd55ea62f109d5002bb73f44ba76c6b9
source_of_truth/v2.3/Results/T1-POISSON-IMAGE-LEMMA-001/PROOF.md
5390147026cc1f3c8ada01d20d3ba9ae4359cc6f51436359cc913f92bd8ba1ce
source_of_truth/v2.3/Results/T1-POISSON-IMAGE-LEMMA-001/T1A_POISSON.md
46d32c73fe6882bdbf58069a74296ba649ac915902090260f3f8d06a97339271
```

To wymagane składniki planowanego eksportu z G według `T5/DEPENDENCY_BINDINGS.json`; nie deklaruję ich ponownego pełnego audytu w tej sesji. Analogicznie autor ma domknąć listę rzeczywiście konsumowanych wejść E2/FC i potrzebnych dla tekstu dowodów, zamiast zakładać kompletność na podstawie nazw katalogów.

# E. Pytania do specjalistów i dalsza matematyka

## E1. Trzy konkretne pytania recenzenckie

1. **Do specjalisty od analizy harmonicznej / geometrii liczb:** w poprawionych `lem:alias`, graph-theta completion i `thm:global-energy`, czy podane metryki, rzeczywiste przesunięcia, krotności wszystkich cosetów oraz wyłączenie u=0 uzasadniają dokładnie bound checkera z potęgą 768 i pełny cover Q_D=1000? Proszę sprawdzić szczególnie centralny krok z epsilon=7/100, punkt K²=9 i determinant cancellation w large range dla kanonicznych endpointów 113/9923.
2. **Do specjalisty od Gaussian sampling / zweryfikowanej numeryki:** czy `thm:t5` wraz z `GLOBAL_LEAF_A2_BRIDGE.md` i source-bound numerical soundness uzasadnia przejście od maszynowego leaf gate S17 do dokładnych reciprocal A2 blocks i końcowego product boundu dla każdego skutecznego wyjścia? Proszę oddzielić indukcję parametryczną od testów małych stopni oraz wskazać, czy wszystkie przesłanki modelu FPR/twiddles są jawne i wystarczające.
3. **Do specjalisty od implementacji kratowych i redukcji bezpieczeństwa:** w `thm:correctness`, algorytmach COMP_STATIC i interfejsach `prem:H3`/`prem:H6`, czy opis precyzyjnie oddziela reprezentację int16, domenę dekodera, centered mathematical witness i norm rejection? Proszę wskazać dokładny dodatkowy kontrakt potrzebny do przeniesienia dowodu o wektorach na rzeczywiste bajty i history-uniform signer, bez traktowania T2C3/T5 jako gotowej redukcji EUF-CMA.

To pytania o oznaczone kroki, nie o ogólne zapewnienie „schemat jest bezpieczny”. Nie wysłano ich do nikogo.

## E2. Co wystarczy dopracować przed preprintem

1. Zrealizować pięć poprawek P1–P5 w **nowym** TeX-ie, ze szczególnym pierwszeństwem dla kanonicznych przesłanek i poprawnej metryki. Główne liczby T2C3/T5 zachować z ich dowodową ścieżką.
2. Włączyć pełne istotne argumenty do tekstu/aneksu i przygotować mapę main theorem → premises → certyfikaty. Autor sprawdza nowe rozwinięcia centralne; nie przypisuje ich do dawnych recenzji.
3. Przygotować minimalny publiczny pakiet D, sprawdzić jego wejścia i wybrane publiczne replaye w przypiętym środowisku oraz opisać prywatny producer boundary i brakujące raw review reports. To przygotowanie konkretnego artykułu, nie przebudowa T01–T20.
4. Wygenerować PDF z nowego TeX-a; sprawdzić etykiety, odsyłacze między paperem i suplementem, tabele, cytowania i renderowanie wzorów. Zapisać TeX/PDF hashes i faktyczne narzędzia. W obecnej sesji tego nie wykonywano.

Domknięcie H1R/H3/H6, pełnego ROM/QROM i estymatora nie jest warunkiem przedstawienia w preprincie dwóch już uzyskanych twierdzeń o dokładnie nazwanym zakresie.

## E3. Jeden następny obowiązek matematyczny dla rzeczywistego schematu

**Rekomenduję źródłowy lemat osiągalności centrum H3 dla S17 i wszystkich successful-KeyGen outputs.** Jest to wąski następny krok prowadzący do produkcyjnego scalar bridge, a nie powtórzenie T2C3.

Dokładny cel: dla każdej prywatnej czwórki wyemitowanej przez skuteczny S17 KeyGen i każdej osiągalnej historii wewnątrz rzeczywistego Sign, wykazać kontrakt zakresu maszynowego centrum przed `fpr_floor -> int` i końcowym `s+z` w `sampler_large`. Nie zakładać, że samo `finite(mu)` zapewnia taki zakres.

Niech `k_max` będzie największym dopuszczonym k z dokładnej implementacji banku CDF; wtedy `z` jest w `[-k_max,k_max+1]`. Wystarczająca część kontraktu ma postać

\[
\mathrm{INT}_{\min}+k_{\max}\le\lfloor\mu\rfloor
\le\mathrm{INT}_{\max}-(k_{\max}+1),
\]

z uzasadnieniem poprawności poprzedzających obliczeń FPR i bez zakładania dokładności przechowywanego `r_hat=RN(mu-s)`. Jeżeli kontrakt nie zachodzi, właściwym wynikiem jest dokładny świadek dla zadanego kwantyfikatora i osobna decyzja autora o obsłudze tego zdarzenia, a nie przemilczenie go lub zmiana klucza referencyjnego.

Zależności: S17, rzeczywisty call graph, accepted-key predicate/leaf gate i dokładne wsparcia CDF. Zakres to klucze wyemitowane przez KeyGen, nie automatycznie wszystkie dowolnie załadowane encoded secret keys. Dopiero na takim osiągalnym domain można bez ukrytej przesłanki zamykać production-exponent error, normalizowaną scalar law i warunkową kompozycję 3072 wywołań. H1R pozostaje odrębnym wejściem rozkładowym, a H6 odrębnym mostem pre-cast/bytes. To zachowuje zależności i nie obiecuje całej redukcji w jednym kroku.

## E4. Czego ta publikacja jeszcze nie twierdzi

Zapisać zwięźle na końcu abstract, po dwóch main theorems, w §20 i w data-availability statement:

- fixed-key `2^-89` nie jest boundem dla wszystkich kluczy ani „89 bitami bezpieczeństwa”;
- T5 nie dowodzi tego samego sharply truncated image boundu dla wszystkich kluczy;
- `delta_key=0` nie oznacza zerowej szansy niepowodzenia KeyGen;
- CDF accuracy, ideal rejection identity i deklaracje kodu nie są dowodem dokładnego idealnego prawa produkcyjnego samplera;
- source-level correctness, faithful compression i H3/H6 nie są zamknięte przez sam algebraiczny argument NTRU;
- nie ma tu pełnej EUF-CMA, dowodu hardness MT-ISIS ani automatycznego QROM;
- podpis Git, historyczne internal ACCEPT, liczba PASS i opinia modelu nie zastępują zewnętrznej recenzji matematycznej.

**Granica pozytywna:** publikacja dostarcza konstrukcji FT1536 i dwóch odrębnych, źródłowo zidentyfikowanych wyników analitycznych z istniejącym materiałem dowodowym. Ta treść ma własną wartość naukową niezależnie od dalszego programu bezpieczeństwa całego schematu.

# Aneks I. Inwentarz faktycznie użytych wejść

Pełne SHA-256, z bazami z §0.1. `G:` oznacza odczyt `git show d641ab1037c2fa1dd4a22c258854d79d67b9b46b:<path>` w repozytorium H, z `GIT_OPTIONAL_LOCKS=0`. Odczytane manifesty FC/T5/FR mają bazę właściwego pakietu; S17 ma bazę `build/`. Nie wszystkie pliki poniżej były analizowane w całości: część certyfikatów i narzędzi służyła identyfikacji, odczytowi kontraktu CLI lub ustaleniu zakresu replayu, bez ich wykonywania.

```text
e911a92c8ec1b57f270c82c2072ad26dfa3501357dd0dc6ddec45fde26954a99  DOC:FT1536_PROMPT_PAPER_TEZA_MAPA_DOWODOW_2026-09-17.md
def738641b8072e723fc4f457a3eb4f60ad6c102fd7a7b371e27faa9a0ba081c  DOC:FT1536_AUDYT_CIAGLOSCI_KLUCZA_BAZY_T2C3_2026-09-17.md
b9b7231729908449986afc448aee9c256ec435668b403b8f3c25b0088eec9e9f  DOC:FT1536_WERYFIKACJA_UZASADNIENIA_D11E2_2026-09-17.md
64127490a2793379e25582354387f7fd155de1fee434eee9f06833bdf7bd7a9f  P:FT1536_FALCON_STYLE_FULL_ACADEMIC_PAPER_REV5.tex
425d24ece7a0fe5de27aa10ea07ae54a85034a956554f06d78352a6e06dff28d  P:FT1536_SEC20_SOURCE_BOUND_SAMPLER_BRIDGE_R1_R5_REV3.tex
0e9263488e81d91e79260060d2bf6715f3a3e6f9b40d091d3244dbfe1f2fd15b  V2:README.md
0c2c33efd0f1f655baf5d81b27ca73086d47fdd9aaa244d75eba87626188edb7  V2:THEOREM.md
02f761d77528c201a5de3df5051ca6cb3fd3c808aaffdf8811e51bfe45ac233a  V2:DEPENDENCY_GRAPH_CORRECTION.json
0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05  H:build/falcon-enc.c
eee8d7dc503e007cb76bcc157094b2a2de481075ac3f67426848f7a8cae6efd8  H:build/falcon-sign.c
657ad2b2d45b8932c3b9a703ac718c1f23dad78523036c1a934b8e21cf0f4519  H:build/falcon.h
4b1dc3aa48d4738b3d4ca854691e633371769bf73ec6777ca26d1c67ea728bbc  FC:THEOREM.md
51466e687c675f84bfb44b0f24b3e7e381d844bad4dc94a2ebc188a3ffa0516c  FC:verify_t2c3_final.sage
9cafd76918bcf009e0f4a1526de02829d87b4c65c9ba8ecb8cf926ccbcfffdb2  FC:REPLAY_RESULTS.json
852659713bc97c881606ee8fe53cb14f39b5e5351c1ec0cc028c4fafab41cd9c  FC:output_hashes.sha256
725fdbf5a39b58795029b077461541a0a86600c51b68b81f36231372e6567a70  FC:TOOL_VERSIONS.json
a5b1b220a24670b40c6c79cb1c6469cb9f470c8cd8c1167ed0c6fa882094a7ff  FC:certificates/normal/t2c3_final_certificate.json
21b7e453a3a9529c463f492234d078a3e737105cb539e553adce5e103a6c5784  T5:THEOREM.md
6b71f8a1f3924575eb5acf43412ef834451754ec5a660bbff62ce9729fa9bf1a  T5:GLOBAL_LEAF_A2_BRIDGE.md
225924b13ab511b58619f718a4bb3c8aae9fb2376f955286bd8a0d344fdb0e07  T5:DEPENDENCY_BINDINGS.json
c730ec93c4c125ed62c4a648695f020387ff77ad63924976b0f908dacbbcf09c  T5:SOURCE_BINDINGS.json
e133309e10aa326508bbbb58a76af2155805fbce391b886824884af9c151e72d  T5:REPLAY_RESULTS.json
4d8e6fca6138181bb084d8bd81f4cd68e59a43a0948cf8f443b385516810bd3e  T5:report.md
4dc5051289736004f5729c645c194beeb983a9203a3f79e38a0465d395dd0819  T5:output_hashes.sha256
49189f1adc7f4daf6b9b16bc9f67bcfba03ce25bc256f22793b0b36e9fc4225f  T5:TOOL_VERSIONS.md
2da5143e142e812a432605b9b17a8020fff01e2d84296eb551ad93ece69a7103  T5:scripts/verify_t5_uniform_a2.sage
380041add1b4a6f25aabce5d0c43b0ab9c545a9eea1cceec0a5a32113f21736f  T5:certificates/normal/certificate.json
af280642cf497f8dfef18a1a651008a0256a95d4bb78039a5b3c6b2c7cb1ccdf  T5:inputs/a1/NUMERICAL_SOUNDNESS.md
6ddab78425cf23a086d60bc63cadd9e534ea713966b764b64fb31177603ae174  T5:inputs/a1/KEYGEN_LAW.md
291dbd44f60e30835ccbf184d2f931ced3bef578b6c29983cc07d2fb02442ae9  T5:inputs/a1/FORMAL_ATTEMPT_MODEL.md
71d13d5a34badea7414c14d07e53c2c11a76ea5bbc01f2f482538be58678bedf  T5:inputs/a1/output_hashes.sha256
f023c1294f147b16f9f995273df600556cb711a6eef681bc31b62f813e7bc09f  T5:inputs/a1/scripts/verify_t5_uniform.sage
9d9ee5ca4522ba6278a9bb19f3d5f53f083371e442ac9e43d66f6b3208055a79  T5:inputs/a1/scripts/audit_fft_twiddles.sage
0b19e2944a7c698a09a058f01ccdf94697985a3e88dbbaa56a3075fbddcfd3a8  T5:inputs/a1/FFT_TWIDDLE_AUDIT.json
4d2d128ced1ec8a1d8ca2e7ba16e58b69e523e2615ad3c300bc3e22b741da48e  T5:A1_MATH_REVIEW_ASSERTION.json
29591e1b37eabd3413a20be780d2dc17b6cd6fcf9dc4fb4d3fa0825bb8f5e450  FR:CLAIM_BOUNDARIES.md
e7a88c88d756157166afc06145d56ee7e0018a7c7cc1a43b7e523c0ffbf3e059  FR:REVIEW_ASSERTIONS.json
bf1d74da69ccb88135f7503941ff4c5bc48e38b5d31449c500085a32fe39ae3d  FR:REPRODUCTION.md
b88a82afc8cfadd707c0eccd66afe2af4cb7c94bc760062f45ba70f309cbe042  FR:AUDIT_PROTOCOL.md
7fda42d9da99a590f32cd5479dc698995f386d24b734e2d40fdbdd336d111295  FR:README_REVIEWER.md
20b9c4b8ce70cd9b6bae5083cac58c1c115b98a4e9389cd9e850ac927d1a2c6c  FR:VERDICT_MATRIX.json
16dd66ae418ba02a2230d069a1b09f2e2b827b591609de118ba1e107099d3d27  FR:SOURCE_PACKET_BINDINGS.json
bd4ba684f7c55c2be7a846d1c69628893160c0c8939a0b8c3fcc111bcc786f1e  FR:INPUT_INVENTORY.json
c921f6a6edf00c7925882e76b10d0a5781079f67f9656d48d8aad861661cd757  FR:output_hashes.sha256
bac093edb19f0736c3111ef27154eb6a16396025b50fad68ce5dfe99b9890c77  FR:TOOL_VERSIONS.md
03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589  G:evidence/_work/PO-01-BASELINE-001-20260803-a1/source_hashes.sha256
5b44e91775de260da3f7c7ec6bd32cfacee28548a39c25440b01b7e1dd94921c  G:tools/verify_build_baseline.py
```

Pozostałe kotwice wymienione w mapie planowanego pakietu są referencjami z tych wejść, w szczególności z R_K0, R_E2 i manifestów. Nie przedstawiono ich jako nowej walidacji całego historycznego workspace. W tej sesji powstał wyłącznie niniejszy plan publikacyjny.
