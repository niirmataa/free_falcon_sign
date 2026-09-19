# FT1536 — audyt ciągłości klucza, uporządkowanej bazy i kompozycji T2C3

Data: **2026-09-17**. Przedmiot: **jedna konkretna instancja fixed-key** FT1536 full ternary secret, od lokalnego KeyGen do historycznej końcowej kompozycji T2C3 i research freeze.

## 1. Krótka odpowiedź

**Tak — zachowana publiczna dokumentacja pozwala odtworzyć spójny łańcuch tożsamości tej samej instancji.** Publiczny klucz, commitment zakodowanego klucza prywatnego, definicja uporządkowanej czwórki, algorytm redukcji, commitmenty wyniku redukcji, metryka i historyczne źródła są związane zgodnymi artefaktami. Nie znalazłem podmiany klucza na historyczny `key_1`, podmiany deterministycznie zredukowanej pary ani zmiany 17 plików implementacji pomiędzy bazą wygenerowania klucza i podpisaną integracją T2C3.

To **potwierdzenie ciągłości publicznych wiązań i rozróżnienie faktycznych zależności**, a nie ponowne wykonanie całego dowodu. Historyczne dokumenty eksportują wynik

\[
E_{h_*}^{Q}<2^{-89}
\]

dla jednego, niżej zidentyfikowanego klucza. Podpisany commit `b478ba359cfea7b18243c95a9705351491bb167b` rzeczywiście integruje ten wynik; późniejszy `d641ab1037c2fa1dd4a22c258854d79d67b9b46b` dodaje osobny T5 i research freeze. Pozostawione w niezmienianych pakietach wykonawców etykiety `PENDING_REVIEW` nie są same w sobie dowodem braku tej późniejszej integracji.

**Zastrzeżenie dotyczące kompletności dowodowej:** część historycznych recenzji zachowano tylko jako manifest-bound assertions, bez pierwotnych raportów recenzentów. Ponadto w kanonicznym D11E2 przejście od spektrum tej instancji i dokładnej bazy/metryki do globalnego oszacowania wszystkich częstotliwości i aliasów jest opisane skrótowo; bardziej szczegółowy wywód znajduje się w starszym dokumencie oznaczonym `comparison-only`. Weryfikator D11E2 sprawdza liczby i przedziały, ale nie zastępuje jawnego dowodu tego przejścia. To najmniejsze wskazane w §10 ogniwo do osobnego publicznego dopięcia. Nie jest to wykryta zmiana instancji ani kontrprzykład do T2C3.

### Najważniejsze bezpośrednie ustalenia

1. Hash publicznego klucza i hash publicznego `h` są zgodne z podanymi wskazówkami. Niezależne rozpakowanie 1536 słów 15-bitowych z klucza publicznego dało dokładnie zapisane publiczne `h`.
2. Źródła `build/` w commitach `8ffa1e…`, `72b7cd…`, `b478ba…`, `d641ab…` oraz obecne `H/build` odpowiadają temu samemu manifestowi **17/17**. Obecny kandydat `C/Extra/c` odpowiada mu tylko **8/17** i nie jest źródłem historycznego wykonania.
3. Publiczne zapisy zastosowania reduktora i skumulowanej koherencji zgadzają się co do `T`, `(F',G')` i `A0=448642`.
4. D2 faktycznie czyta certyfikat skumulowanej koherencji, a nie tylko przypina jego manifest.
5. D8 nie zastępuje swojego doubled-theta oszacowaniem D6. D10 jawnie odczytuje mocniejszy endpoint certyfikatu D9, zamiast arbitralnie zmienić etykietę `2^-80` na `2^-90`.
6. D11E2 zachowuje dokładny endpoint D7; jego publiczny zapis późniejszego replayu ma identyczny obiekt endpointu, model spektralny, walidację tożsamości i profil dla D8.
7. Sam fakt umieszczenia wszystkich 23 etapów w końcowym ledgerze nie oznacza, że wszystkie są niezbędnymi przesłankami liczbowymi końcowej ścieżki. W szczególności liczby D11E1 nie są dodawane do końcowego boundu D11E2.

## 2. Zakres, metody i korzenie

```text
H = /media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon
F = H/evidence/candidates/framework_d641
C = /home/footfalcon/free_falcon_sign
G = obiekty Git repozytorium H pod refs/archive/framework/candidate
```

`refs/archive/framework/candidate` wskazuje na:

```text
d641ab1037c2fa1dd4a22c258854d79d67b9b46b
```

Oznaczenie `G:<ścieżka>` w tym raporcie znaczy odczyt:

```text
GIT_OPTIONAL_LOCKS=0 git show refs/archive/framework/candidate:<ścieżka>
```

wykonany przez repozytorium `H`, bez checkoutu, ekstrakcji do nowego katalogu i bez modyfikacji indeksu. Ścieżki pakietów w `F` są relokowanymi odpowiednikami historycznych `evidence/_work/<nazwa-pakietu>/` w `G`. Nie interpretowano wszystkich starych manifestów względem jednej domyślnej bazy: występują wejścia lokalne, repozytoryjne, aliasy poprzedników i wpisy `git:<commit>:<path>`.

Poprzedni raport `/home/footfalcon/Dokumenty/FT1536_AUDYT_WZNOWIENIA_2026-09-17.md` był nawigacją, nie przesłanką ustaleń.

### Wykonane kontrole

- Odczyt oryginalnych publicznych dokumentów, kodu sprawdzającego, metadanych i certyfikatów.
- SHA-256 i porównania bajtowe z kontrolą symlinków.
- Porównanie 31 głównych manifestów pakietów z odpowiadającymi im bajtami w archiwalnym Git: **31/31 zgodnych**.
- W tych 31 manifestach było 1716 wpisów. Zastosowany jawnie ograniczony przegląd publicznych dokumentów, metadanych, manifestów, źródeł checkerów i certyfikatów sprawdził **1522 wpisy bez rozbieżności**. Pozostałych 194 wpisów nie włączono do tego zbiorczego hashowania — m.in. logów, plików o nieprzyjętym typie i ścieżek `private_extraction`. To nie jest deklaracja pełnego replayu ani pełnej walidacji pokrycia wszystkich pakietów.
- Publiczne, wiele-do-jednego certyfikaty zawierające słowo `PRIVATE` w nazwie czytano wyłącznie jako metadane/commitmenty w jawnie publicznych kopiach wejściowych, np. `CU/inputs/A2_PRIVATE_CERTIFICATE.json`. Ich deklarowane i zaobserwowane pola są agregatami, commitmentami i wynikami kontroli, nie surową czwórką ani seedem.
- Niezależne rozpakowanie kodowania publicznego klucza.
- Porównanie obiektów endpointu/profilu D7 i D11E2; odtworzenie ich hashy kanonicznego JSON.
- Kontrola dokładnego wymiernego/całkowitoliczbowego świadka ostatniej kompozycji, w pamięci, bez uruchamiania historycznego runnera.
- Offline `gpgv 2.4.7` nad publicznymi podpisami trzech commitów; każdy zakończył się kodem 0 i właściwym `VALIDSIG`.

Nie odczytano prywatnego klucza, seedów, surowych prywatnych współczynników ani `.private`. Nie odtwarzano prywatnej redukcji i nie generowano klucza. Nie uruchamiano historycznych runnerów zapisujących wyniki, nie regenerowano manifestów, nie zmieniano statusów, nie wykonywano commita, push ani podpisu. Jedynym nowym trwałym plikiem tej sesji jest ten raport.

## 3. Karta tożsamości instancji

### 3.1. Klucz i wejście implementacyjne

| Element | Dokładna tożsamość | Co zostało zweryfikowane |
|---|---|---|
| Base KeyGen | commit `8ffa1e011577cd877074888b8650ed521f8bb289`, tree `854a8e85176226ea82d36dde1005ef50b70b4d20` | Obiekt Git, tree i podpis; zgodność z `PRE_KEYGEN_BINDINGS.json`. |
| Manifest źródeł, dalej `S17` | `G:evidence/_work/PO-01-BASELINE-001-20260803-a1/source_hashes.sha256`; SHA-256 `03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589` | Oryginalny manifest zawiera 17 plików; hashe sprawdzono wobec czterech commitów i `H/build`. |
| Zakodowany PK, dalej `PK*` | `K/canonical_public_key.bin`; SHA-256 `57c49fb228013b0bfc4907c754d747dca93c1049d2945ccd6cd686e9f95afc6f` | 2881 bajtów, nagłówek `0x8a`, 1536 poprawnych reszt modulo 18433. |
| Publiczny wielomian, dalej `h*` | `K/canonical_public_h.txt`; SHA-256 `ce1aef69b5998e6f214bc6a45cf6abc36fb1753d595ef1d7b0e6c1cecd9d17f2` | 1536 liczb; zgodność z niezależnie rozpakowanym PK. |
| Commitment SK, dalej `SKC*` | `d073480ca8971c41719e855fef2d38a5271e4a5249a7764f236bef538bd4519c`, zadeklarowane 7681 bajtów | Wyłącznie zgodność wartości w publicznych metadanych. Prywatnych bajtów nie czytano ani nie hashowano. |
| Decoder uporządkowanej czwórki | `K/scripts/decode_validate_stream.c`; SHA-256 `36eb1515c5c3d48872f7cb383d606c68d004eaeda56bd6967b9a75ff724f836e` | Ta sama tożsamość źródła dekodera wraca w redukcji, D7 i D11E2. |
| Historyczny generator binarny | `565cfe459430dbb3f01b4cb7dfda2b5a1b6722ac239dc819e4e18871737db1bf` | Commitment w preflight i metadanych KeyGen; binarium nie było odtwarzane. |
| Historyczny decoder binarny KeyGen | `0ab605a8eb0555251785e8a962b7d7c23ab0a5b0d34e1354f923f7f0aa56b7d8` | Commitment w preflight i `KEY_VALIDATION.json`; późniejsze fresh buildy mają inne hashe binariów i zachowują pin źródeł. |
| Profil | `N=1536`, `q=18433`, `Phi=x^1536-x^768+1=Phi_4608`, `TRUE_TERNARY_SECRET_MODE_1` | Zgodny w KeyGen, foundation i dalszych etapach. Pełna ternarność f,g oraz relacje NTRU są historycznymi wynikami walidacji związanej z `SKC*`. |

Główne kotwice KeyGen:

```text
K/KEY_COMMITMENT.json
014358887337670f599c442bb3b838aa6084931efeba17a00eb72fda014e9523

K/PRE_KEYGEN_BINDINGS.json
b74fe3ed1b6ec51e2368993d24ede8a3fb68fb4b4019db1060bf34273a9e4c55

K/KEY_VALIDATION.json
17b386ac028467f31b09e69f1a740124ae8a911c47a0c69b9090874747381fb6

K/OUTPUTS.sha256
51107bef5786b102d1b6a2ac8d35926fe7d47eeb9cfd3dd7d647cb679bbc5d15
```

`KEY_COMMITMENT.json` eksportuje zamrożenie przed walidacją matematyczną, a `report.md` jedną lokalną inwokację CLI, bez zewnętrznego retry i bez zapisania seedu. Są to zachowane deklaracje wykonania, a nie zdarzenia ponownie zaobserwowane podczas tego audytu.

### 3.2. Surowa uporządkowana baza

Tożsamość surowej czwórki jest określona przez **`SKC*` + źródło dekodera + literalny porządek `(f,g,F,G)`**. W sprawdzonym publicznym interfejsie nie ma osobnego, niezależnie odtwarzanego hasha pełnej prywatnej macierzy bazy. Samo `h*` nie wystarcza do wyznaczenia tej bazy.

Historyczny `KEY_VALIDATION.json` deklaruje dokładnie:

```text
fG-gF=q w R,
hf=g oraz hF=G modulo (q,Phi),
f,g pełnoternarne,
Q0(f)=1000, Q0(g)=1044, Q(f,g)=2044,
Q0(F)=260802, Q0(G)=291436, Q(F,G)=552238.
```

Należy zachować dwie reprezentacje:

1. **Baza signera:** `H/build/falcon-sign.c`, hash `eee8d7dc503e007cb76bcc157094b2a2de481075ac3f67426848f7a8cae6efd8`, funkcja `load_skey`, linie 1177–1200, ładuje w konwencji wierszowej

   \[
   B_{\rm sign}^{\rm row}=\begin{pmatrix}g&-f\\G&-F\end{pmatrix}.
   \]

   W konwencji kolumn bloków współczynnikowych jest to

   \[
   B_{\rm sign}^{\rm col}=
   \begin{pmatrix}M(g)&M(G)\\-M(f)&-M(F)\end{pmatrix}.
   \]

2. **Dodatni moduł grafowy używany w analizie dualnej:**

   \[
   \Gamma_{h_*}=\{(a,b)\in R^2:b=h_*a\pmod q\},\qquad
   S(r,t)=(rf+tF,rg+tG).
   \]

   Jego uporządkowana baza kolumnowa to

   \[
   B_{\Gamma,0}=\begin{pmatrix}M(f)&M(F)\\M(g)&M(G)\end{pmatrix}.
   \]

Nie utożsamiam tych macierzy literalnie. Zamiana `(a,b) -> (b,-a)` łączy równanie dodatniego grafu z jądrem mapy signera, zaś przejście do kraty dualnej ma osobny, jawny most Frobeniusa z foundation, opisany w §3.4.

### 3.3. Konkretna deterministyczna redukcja

Algorytm: **`NormalizeOrderedCompanionA2BCD`**.

| Definicja / wynik | Publiczna kotwica i pełny SHA-256 |
|---|---|
| Definicja | `RD/DEFINITION.md` — `79b210a6a51f77afa5914cdee4153d0fb1be42c57a7cea460a8fdc86acf35a39` |
| Pseudokod | `RD/PSEUDOCODE.md` — `9133a3ecdb4ab03995b37492121975f8bf6df153c0b64bbbed6ec759884fb4b0` |
| Implementacja zastosowania | `AP/scripts/extract_reduced_companion.sage` — `c9c924651ea47dfa944b8c261c681a8d0169166ba3e27c33dfee86bb90ea70b4` |
| Publiczny wynik zastosowania | `AP/public_normal/public_verification.json` — `d7a8d4efa36a810fe61662ac60e7531d9561e5c40d78e94352062f6aa0b087ca` |
| Publiczna kopia certyfikatu agregatów | `CU/inputs/A2_PRIVATE_CERTIFICATE.json` — `c22f9e22db489d1b8e8704245eb8dcc5bc791d6cdf0704818fe1e8aa618095e2` |

Odczyt implementacji potwierdza zgodność opisanej konstrukcji: start `T=0`, blok `i=0..767`, dokładne `ZZ/QQ`, zaokrąglenie `floor(z+1/2)`, pełne lokalne 3×3 plus `(0,0)`, porządek minimum `(Delta,u,v)`, aktualizacja wyłącznie dla `Delta<0`, przeliczenie korelacji po wcześniejszych aktualizacjach oraz zatrzymanie po niezmieniającym przebiegu. Skrypt sprawdza również niezmiennik `F'=F-Tf`, `G'=G-Tg`. Nie wykonywano go.

Publiczne zapisy zastosowania podają i wzajemnie zgodnie wiążą:

```text
energia wejściowa Q(F,G) = 552238
energia wyjściowa Q(F',G') = A0 = 448642
zaakceptowane aktualizacje = 300
przebiegi, wliczając końcowy niezmieniający = 11

commitment T:
9135c32e42dcff7d70c9e0f8f72eec8769e4f52d61d74c0cc38eb04dbf0de2c2

commitment (F',G'):
80c6cb150959a80b89f50f9303af89e255f2354900e10cbf7cd1e6aa4a5580f2
```

Format commitmentów jest jawny w skrypcie: `T` to SHA-256 współczynników w naturalnym porządku, zapisanych dziesiętnie i rozdzielonych przecinkami, bez końcowego LF; para używa prefiksu `FT1536_REDUCED_COMPANION_PAIR_V1`, separatorów NUL oraz analogicznych list `F'` i `G'`. Sprawdzono definicję formatu i zgodność zapisanych hashy, **nie przeliczano hashy z prywatnych współczynników**.

Nowa baza dodatniego grafu jest

\[
B_{\Gamma,1}=B_{\Gamma,0}
\begin{pmatrix}I&-M(T)\\0&I\end{pmatrix}.
\]

Dlatego jest to ta sama krata z inną, konkretnie związaną bazą. Współrzędne spełniają

\[
S_{F,G}(r,t)=S_{F',G'}(r+tT,t),
\]

co zachowuje `t`, determinant NTRU i krotność parametryzacji. Analogiczna redukcja w konwencji wierszowej signera odejmuje `T` razy pierwszy wiersz od drugiego. Nie wynika z tego, że produkcyjny signer został przełączony na tę zredukowaną bazę; jest to zidentyfikowana baza pomocnicza dowodu.

„Canonical” oznacza deterministyczność dla literalnej uporządkowanej czwórki. Nie oznacza globalnego minimum CVP, minimum `A0` w całej klasie, niezmienniczości względem innego początkowego companion ani względem automorfizmów cyklotomicznych.

### 3.4. Metryka, kolejność i znaki

Używam `m=768` dla połowy stopnia, żeby nie mylić go z publicznym `h*`:

\[
Q_0(a)=\sum_{i=0}^{767}(a_i^2+a_i a_{i+768}+a_{i+768}^2),\qquad
Q(a,b)=Q_0(a)+Q_0(b).
\]

Współczynniki mają porządek `1,x,...,x^1535`, a bloki to `(i,i+768)`, nie kolejne sąsiednie współrzędne. Macierz jednego bloku to

\[
P_2=\begin{pmatrix}1&1/2\\1/2&1\end{pmatrix}.
\]

Foundation wiąże

\[
P_0=\begin{pmatrix}I&R_0\\R_0&I\end{pmatrix},\quad R_0=\tfrac12 I,
\qquad P=\operatorname{diag}(P_0,P_0),
\]

oraz macierz Frobeniusa `J=[[0,R_L],[R_L,R_L]]`, gdzie `R_L` odwraca kolejność 768 współrzędnych. Jej dokładne interfejsy to

\[
J^T P_0^{-1}J=\tfrac43 P_0,\qquad H_{h_*}^TJ=JH_{h_*},
\]

\[
\Gamma_{h_*}=\mathcal J^{-1}(q\Lambda_{h_*}^*),\qquad
Q^*(\mathcal J(a,b)/q)=\frac4{3q^2}Q(a,b).
\]

Kotwica: `FD/THEOREM.md`, SHA-256 `c2ec9a1110c2837e8f9789197063bcf8748e5f84c0f8ad1ef0abdedf2fc35142`; odpowiadający certyfikat `FD/certificates/foundation_certificate.json`, SHA-256 `81b20dae8600b84bf3c40dba6a9bac224402f0437530b61ab9034314d5042e53`.

Przejście do publicznej mapy implementacji jest jawne w C3:

```text
s1_code = s2*h* - c0,
z = (-s1_code,s2),
A_h*(z) = z1+h*z2 = c0,
xi_u = -(u_tilde,H_h*^T*u_tilde)/q mod Z^3072.
```

`C3/THEOREM.md` ma SHA-256 `3cf4f39af462a28a4f871d16ffbac18f77ca65523dffd72627bfc94e583a2be0`. Negacja całego pierwszego składnika zachowuje jego `Q0`; nie wolno zastępować jej zmianą znaku pojedynczej współrzędnej wewnątrz bloku A2.

D11B używa zapisu `A_h(a,b)=b-ha`. Nie jest to literalnie ta sama macierz co `[I|H]`, lecz po `z=(b,-a)` dostajemy dokładnie `A_h(z)=b-ha` i zachowanie `Q`. W raporcie rozróżniam tę izometrię/przestawienie od mostu dualnego Frobeniusa.

Skumulowana koherencja zachowuje również wrap `x^768=omega`: `U:(u,v)->(-v,u+v)`, `U^T P2 U=P2`, a poprawna relacja odwrócenia przesunięcia to `B_(768-s)=B_s^T U`, nie zwykła transpozycja. Odrzuconą próbę bez `U` zachowano w dokumentacji.

### 3.5. Źródła i późniejsze commity

| Stan | Drzewo / rola | Zgodność z S17 |
|---|---|---|
| `8ffa1e011577cd877074888b8650ed521f8bb289` | `854a8e85176226ea82d36dde1005ef50b70b4d20`; baza KeyGen | 17/17 |
| `72b7cd4fdb756b077a8ca228584c28385ee107e4` | `166a2d36aa5756728ad41d6cc615b3d6f635dd2d`; późniejsza baza D10/D11 | 17/17 |
| `b478ba359cfea7b18243c95a9705351491bb167b` | `a7db139ad8ec6d78ee8f742f869f1bad6179d003`; integracja T2C3 | 17/17 |
| `d641ab1037c2fa1dd4a22c258854d79d67b9b46b` | `f431732995ce46d658299117f3acbd0a919d0ac3`; T5 i freeze | 17/17 |
| `H/build` | odzyskane pliki robocze | 17/17 |
| `C/Extra/c` | obecny warning-clean | 8/17 |

Sprawdzono relację przodka `8ffa1e… -> b478ba… -> d641ab…`; `b478ba…` jest bezpośrednim rodzicem `d641ab…`. Późniejszy commit jest integracją zachowanych wyników, nie nowym wygenerowaniem klucza.

Dziewięć różnic obecnego `C` dotyczy `falcon-enc.c`, `falcon-fft.c`, `falcon-keygen.c`, `falcon-sign.c`, `falcon-vrfy.c`, `frng.c`, `internal.h`, `test_falcon.c`, `tool.c`. W tym audycie nie analizowano ich ponownie jako zadania implementacyjnego i nie przenoszono na nie historycznego twierdzenia.

## 4. Słownik pakietów i pełne hashe manifestów

Alias w kolejnych tabelach oznacza dokładną ścieżkę z tej tabeli. Domyślnie manifest to `output_hashes.sha256`; dla K jest to `OUTPUTS.sha256`.

| Alias | Lokalizacja | SHA-256 manifestu |
|---|---|---|
| K | `F/T2C3-CANONICAL-KEYGEN-001-20260819-a1` | `51107bef5786b102d1b6a2ac8d35926fe7d47eeb9cfd3dd7d647cb679bbc5d15` |
| FD | `G:evidence/_work/T2C3-CANONICAL-FIXED-KEY-FOUNDATION-001-20260819-a2` | `95f71b2b9509e682f523b4ef5f7d0dcf8befbd01150c540dee659293921a90e2` |
| RC | `F/T2C3-CANONICAL-RAW-BLOCK-COHERENCE-001-20260819-a1` | `5bf8be28c5ed1789e0a7ac09a0ff431ffd477b4810937abb0ee5ea758780feb1` |
| RD | `F/T2C3-CANONICAL-NTRU-COMPANION-REDUCTION-DEFINITION-001-20260819-a1` | `23e11d5cc6522fcb254976ab5886dce82ef46f75547734d1080d978f4866dd7d` |
| AP | `F/T2C3-CANONICAL-REDUCED-COMPANION-APPLICATION-001-20260820-a2` | `2f5899fb10d347a63942e8a81155fbfbf2e2394b4f4a31c53eabc96e0447345c` |
| CU | `F/T2C3-CANONICAL-REDUCED-CUMULATIVE-COHERENCE-001-20260820-a1` | `b60f1451205c2dd6c6042cccdbb5f943eadcf39ab8553199fba0c32151e91f8e` |
| A | `F/T2C3-REVALIDATE-A-001-20260815-a1` | `449fb56a7e96e6c6979c86c78596b303797830c21a65b1241130fb5325ca0b0f` |
| B | `F/T2C3-REVALIDATE-B-001-20260816-a2` | `6b99e14010ef6c4b23e6df93f5f520bf437f564bc66e01beebfda8add8e0d170` |
| C1 | `F/T2C3-REVALIDATE-C1-INTEGRATION-001-20260817-a1` | `a7781f73f0937b9d863c34bf03ae6ee6568a7cbf9a8fecc0cde73de69710269b` |
| C2 | `F/T2C3-REVALIDATE-C2-INTEGRATION-001-20260817-a1` | `e42422c6871dc1252f0ce08a694f8b9e8bf952b92deaeaba0d95673bf3d0aa8a` |
| C3 | `F/T2C3-REVALIDATE-C3-INTEGRATION-002-20260819-a1` | `5cd9b72feae4d1b93a326f7bd3651b21773ce1d02fb40f37f3efd53f6e6e8a90` |
| D1 | `F/T2C3-REVALIDATE-D1-001-20260819-a1` | `28436e6e339a049830f017cd0329b0b745d8c378f401aef336b08e0ec470b77b` |
| D1I | `G:evidence/_work/T2C3-REVALIDATE-D1-INTEGRATION-001-20260819-a1` | `98f92148da442d3d5a7f951ffe562ca376f55aa2db04ff288e0cc9df67037146` |
| D2 | `F/T2C3-REVALIDATE-D2-CANONICAL-CLOSURE-001-20260820-a1` | `e999dad7cb8c6050c7775ce670b84b07f78956bfdc30569138032b6807234e28` |
| D3 | `F/T2C3-REVALIDATE-D3-001-20260820-a1` | `6a78150afb6f5975b0922155fb46d0458c2bfbb210a57d2a98743148b12eef3f` |
| D4 | `F/T2C3-REVALIDATE-D4-001-20260820-a1` | `8a253e8d7ccbf5e639f0c09f9695d50326c840dd60f39a3cb3d4741b8b1a13d2` |
| D5 | `F/T2C3-REVALIDATE-D5-001-20260820-a2-CANONICAL` | `bf23500df7ab5f9625d2960c36edc141d60fc2cba12b0c03538284eafef21250` |
| D6 | `F/T2C3-REVALIDATE-D6-001-20260820-a1-CANONICAL` | `7ab3069f85211e9e4485a6d6d86e1b9d79a37e8f7b979d79ffc0607d4942356d` |
| D7 | `F/T2C3-REVALIDATE-D7-001-20260820-a5-CANONICAL-ENDPOINT` | `f986c7f563816ff1f60aaaa5391e8d144d29798ebc9dc6bc2f15f5d687de96be` |
| D8 | `F/T2C3-REVALIDATE-D8-001-20260820-a2-DOCUMENTATION-REFREEZE` | `01f6e9f973bcc0b50c4f6e24c85ea1c7703a82e5009ab767b7d9761863a53f1a` |
| D9 | `F/T2C3-REVALIDATE-D9-001-20260820-a1-CANONICAL` | `c16e4c2fb3415c835ff835444262eb0a7a7b1adb30d5e8f63e7bcf6b3fdb591e` |
| D10 | `F/T2C3-REVALIDATE-D10-001-20260821-a1-CANONICAL` | `ed325b116352a93fe97bd77a64654937bfc88a16a8564e899fb084cd3e93684c` |
| D11A | `F/T2C3-REVALIDATE-D11A-001-20260821-a5-CANONICAL` | `1e6076ea7d9b684c9835665142ecd55c3f69519e944a2d158fc74805c7594103` |
| D11B | `F/T2C3-REVALIDATE-D11B-001-20260821-a2-DOCUMENTATION-REFREEZE` | `ab0e69f05a61f3002282a8d1961e5e3e89558b204bd51cba72c0951db7a3677f` |
| D11D1 | `F/T2C3-REVALIDATE-D11D1-001-20260821-a1-CANONICAL` | `f41e6264c5e3e67a497387aaca9c7deac3aee2eba22733f28bc50f7ccdd0d7fd` |
| D11D2 | `F/T2C3-REVALIDATE-D11D2-001-20260821-a1-CANONICAL` | `5da458c31af183c78475eb59110d9d8fe16358447842c57dde5db5040ac01ea2` |
| D11D3 | `F/T2C3-REVALIDATE-D11D3-001-20260821-a1-CANONICAL` | `5ce9287ebc9e03ea20698e891b9581efef925331fc7b77e647ddc83187d9ed1c` |
| D11D4 | `F/T2C3-REVALIDATE-D11D4-001-20260821-a1-CANONICAL` | `de08a2411901ab1858cd324f87c998fbbaea88d01e7125af7074309d134527a5` |
| D11E1 | `F/T2C3-REVALIDATE-D11E1-001-20260821-a1-CANONICAL` | `7e05526efc7485af3f37cd14d0f277aff870a3f19b2bc7fb4b60cbf6f5a4c462` |
| D11E2 | `F/T2C3-REVALIDATE-D11E2-001-20260822-a1-CANONICAL` | `45429b457e216286cecab310c63169b63d116dbfe17f07653219ea389da4df76` |
| FC | `F/T2C3-CANONICAL-FINAL-COMPOSITION-001-20260822-a1` | `852659713bc97c881606ee8fe53cb14f39b5e5351c1ec0cc028c4fafab41cd9c` |
| RV | `F/T2C3-CANONICAL-INDEPENDENT-SAGE-REVIEW-001-20260822-a1` | `3dff71e7ccddb3be17da1cd0db7d2024d4bd04b44ff355a060b92bc960ebd852` |
| FR | `F/FT1536-RESEARCH-FREEZE-T2C3-T5-001-20260822-a1` | `c921f6a6edf00c7925882e76b10d0a5781079f67f9656d48d8aad861661cd757` |

Istotne rozróżnienie: końcowy ledger dla C1/C2/C3 podaje manifesty kandydatów zagnieżdżonych, a nie manifesty opakowań integracyjnych z powyższej tabeli. Sprawdzono:

```text
C1/candidate_a6/OUTPUTS.sha256
686501855184cea4e5c2d7ef0854e391b53d2c9b76d1e8ffbd461a70346e3f49
C2/candidate_a1/OUTPUTS.sha256
4a323c353635b7a5d3cca54eb48dabb2a96f543450aa59009f0158c9aa0514a0
C3/candidate_a5/output_hashes.sha256
e41609d1118a243bcc98e7e17ec607eda34ffa10f2d7614c1e10d98649f41365
```

To wyjaśnione różne poziomy wiązania, nie rozbieżność treści.

## 5. Tabela rzeczywistych przejść

Typy zależności: **M** — matematyczna/numeryczna, **I** — implementacyjna, **H** — hash/proweniencja/recenzja, **Q** — kolejka lub chronologia. `K0` oznacza tę samą instancję `(PK*,h*,SKC*,S17)`. `B0` to surowa baza, `B1` to baza z konkretnym `T` i `(F',G')`. „Uniwersalny” znaczy lemat bez zależności od wyboru tego klucza, później stosowany do K0; nie oznacza uogólnienia końcowego T2C3.

### 5.1. Od źródeł do skumulowanej koherencji

| Etap | Wejście i SHA-256 | Wyjście i SHA-256 | Tożsamość instancji | Faktycznie użyta zależność i ustalenie |
|---|---|---|---|---|
| KeyGen | `K/PRE_KEYGEN_BINDINGS.json` — `b74fe3ed1b6ec51e2368993d24ede8a3fb68fb4b4019db1060bf34273a9e4c55`; źródła S17 | `K/KEY_VALIDATION.json` — `17b386ac028467f31b09e69f1a740124ae8a911c47a0c69b9090874747381fb6`; PK* i h* z karty | Ustanawia K0/B0 | I/H. Źródła i publiczne kodowanie sprawdzone; poprawność prywatnej czwórki pozostaje wynikiem zadeklarowanej historycznej walidacji. |
| Foundation | K/manifest `51107bef5786b102d1b6a2ac8d35926fe7d47eeb9cfd3dd7d647cb679bbc5d15`; `KEY_VALIDATION.json` jak wyżej | `FD/certificates/foundation_certificate.json` — `81b20dae8600b84bf3c40dba6a9bac224402f0437530b61ab9034314d5042e53` | K0/B0, naturalna baza, A2 | M/H. Dodatni graf, Frobenius, dokładne normy 2044/552238; pierwotny pakiet odzyskany przez G, jego kopie w D2 są zgodne. |
| Raw coherence | K/manifest i `RC/inputs/KEY_COMMITMENT.json` — `014358887337670f599c442bb3b838aa6084931efeba17a00eb72fda014e9523` | `RC/public_normal/public_verification.json` — `ddc1a287dda86eb3310f503aaeffe5db41b3d2cbc875ec2fb12021d82a8315a8` | K0/B0 | M/I/H. `36379<delta_raw<36380`; wystarczający próg 22409 nie przechodzi. Zachowany wynik negatywny dotyczy majorantu. |
| Definicja reduktora | Uporządkowana czwórka jako kontrakt algebraiczny; `RD/DEFINITION.md` — `79b210a6a51f77afa5914cdee4153d0fb1be42c57a7cea460a8fdc86acf35a39` | `RD/THEOREM.md` — `bccd153f118a47a62264e56c3615408bea811947430c538bb64bbe45690727f4` | Uniwersalny dla literalnej czwórki | M. Dokładna deterministyczna normalizacja; ten etap nie oblicza prywatnego T ani B1. |
| Zastosowanie reduktora | K0/B0; RD/manifest `23e11d5cc6522fcb254976ab5886dce82ef46f75547734d1080d978f4866dd7d` | `AP/public_normal/public_verification.json` — `d7a8d4efa36a810fe61662ac60e7531d9561e5c40d78e94352062f6aa0b087ca` | K0/B0 → konkretne B1 | M/I/H. 552238→448642, 300/11, commitmenty T i pary zgodne. Skalarne 30675 nadal przekracza nowy próg 22569. |
| Cumulative/Babel | `CU/inputs/A2_PRIVATE_CERTIFICATE.json` — `c22f9e22db489d1b8e8704245eb8dcc5bc791d6cdf0704818fe1e8aa618095e2`; kopia AP/public — `d7a8d4efa36a810fe61662ac60e7531d9561e5c40d78e94352062f6aa0b087ca` | `CU/public_normal/public_cumulative_verification.json` — `0329b7845c9add0bb0f5dea29773e1c305460cbfbab7b10c6df570d2080a0952` | K0/B1, to samo T i ta sama para | M/I. 767 anonimowych bounds, 768 klas wsparcia; wynik zmienia metodę majorowania, nie klucz ani redukcję. |

### 5.2. D2–D10

| Etap | Wejście i SHA-256 | Wyjście i SHA-256 | Tożsamość instancji | Faktycznie użyta zależność i ustalenie |
|---|---|---|---|---|
| D2 | `D2/inputs/CUMULATIVE_PUBLIC_CERTIFICATE.json` — `0329b7845c9add0bb0f5dea29773e1c305460cbfbab7b10c6df570d2080a0952`; foundation — `81b20dae8600b84bf3c40dba6a9bac224402f0437530b61ab9034314d5042e53` | `D2/certificates/normal/certificate.json` — `065b127bd9b4cf0f4e8b716ab8ab2f85dc4eeafd54b8e4f062e5546cdf6325b1` | K0/B1, beta=N/B | M. Weryfikator odczytuje wszystkie 768 support rows, ogony i sumę CU. Składa pełne t=0, separację t≠0, Banaszczyka i prefaktor do `E_beta<2^-64`. |
| D3 | `D1I/THEOREM.md` — `78d7cdde474943e5535c3147b74be61063f11446f2d1c894791517c809a2e29d`; D2/manifest — `e999dad7cb8c6050c7775ce670b84b07f78956bfdc30569138032b6807234e28` | `D3/certificates/normal/certificate.json` — `b20602f10d6cf0e038260d5b93f211ddb9bf4b6714f5fbf0853b72cc18305708` | Uniwersalny w h; przy użyciu K0 ta sama mapa i metryka | M z D1; D2 także H/Q, nie konieczny nowy fixed-key parametr wzoru D3. `T_h <= K_D3*mean_E_h`, bez dodatkowego q^N. |
| D4 | D3/certificate — `b20602f10d6cf0e038260d5b93f211ddb9bf4b6714f5fbf0853b72cc18305708` | `D4/certificates/normal/certificate.json` — `7df08e4878ead7d1fa66bc69b47cac733e2a78b4fef9a56a3cd7deb116e3958e` | Uniwersalny, ten sam A2 i beta | M. `mean_E=sum w_n^2 chi_n <= eta J`; samo J pozostaje obowiązkiem tej drogi. Nie jest to automatyczna konsekwencja D2. |
| D5-a2 | K/validation — `17b386ac028467f31b09e69f1a740124ae8a911c47a0c69b9090874747381fb6`; AP/public — `d7a8d4efa36a810fe61662ac60e7531d9561e5c40d78e94352062f6aa0b087ca`; safe AP cert — `c22f9e22db489d1b8e8704245eb8dcc5bc791d6cdf0704818fe1e8aa618095e2` | `D5/normal/certificates/d5_certificate.json` — `53d4e67dc9d55257a0f64d1e0078c25b2fc6c6b24e4cdf623776f61c608480c7` | K0/B1 | M/H. Dokładna bijekcja S', `Qstar>=1/448642`, krótka domena Q≤21387 leży w t=0. D4 jest jawnie `queue_predecessor_d4`, nie źródłem tych norm. |
| D6 | D5/certificate — `53d4e67dc9d55257a0f64d1e0078c25b2fc6c6b24e4cdf623776f61c608480c7`; CU/certificate — `0329b7845c9add0bb0f5dea29773e1c305460cbfbab7b10c6df570d2080a0952` | `D6/normal/certificates/d6_certificate.json` — `d812d1ea64d60c17f3e913d3dd3fd4b40aa6faa870eab375f312f44e80949c8f` | K0, główna gałąź r(f,g), wsparcie A2 | M. Krótka masa jest podsumą pełnej masy CU; 4608 elementów orbity jednostkowej, energia 2044. |
| D7-a5 | `D7/inputs/a3/canonical_endpoint_certificate.json` — `fa5989576606d2a7a32edd8178ddfcb5066840feade57f630c385c6037b2832d` | `D7/certificates/canonical_endpoint_interface.json` — `fd37fe024c97b7f0f2d6310dea7ec4d27112bc363db971e2f4f90f328e01ff97` | K0; widmo zależy od tego samego f,g, nie od wyboru F'G' | M/H. a5 zachowuje dane a3, naprawia dopuszczenie i znaczenie etykiet. Nie wykonuje nowego prywatnego widma. |
| D8-a2 | D7/a3 certificate — `fa5989576606d2a7a32edd8178ddfcb5066840feade57f630c385c6037b2832d`; profil JSON — `e308a211ead98f15a425423f9c9fd3b06cb7a06361935933c20f35b7edb19206`; D5 cert — `53d4e67dc9d55257a0f64d1e0078c25b2fc6c6b24e4cdf623776f61c608480c7` | `D8/certificates/normal/d8_certificate.json` — `180c34a018f00b23e6ad5b9f6dd1e312308326d4e6d68e32e83373d287674254` | K0, r(f,g), doubled theta przy sigma=768 | M. 384 zapisane dolne bounds rozszerzane jawnie do 768 supportów. Jądro `16*pi²*sigma²/(3q²)`, nie jądro D6. a2 to refreeze dokumentacji a1. |
| D9 | D8/certificate — `180c34a018f00b23e6ad5b9f6dd1e312308326d4e6d68e32e83373d287674254`; D5/certificate — `53d4e67dc9d55257a0f64d1e0078c25b2fc6c6b24e4cdf623776f61c608480c7` | `D9/certificates/normal/d9_certificate.json` — `7fcb29213f2a39cf942e011bd1c4ec3a0d843e5347ed82370b9ba9c06270c1fb` | K0, całe Lambda_h* | M. Dopełnienie poza kulą c=1 i dodatnia redukcja Route C. Etykieta `<2^-80`, zapisany log2 upper około −90.217091. |
| D10 | D9/certificate — `7fcb29213f2a39cf942e011bd1c4ec3a0d843e5347ed82370b9ba9c06270c1fb`; D3/certificate — `b20602f10d6cf0e038260d5b93f211ddb9bf4b6714f5fbf0853b72cc18305708`; Route C — `17cbde88c1db5bcef392d5c08b6f827741ecf6025a935490ee9defa0b8b84ee9` | `D10/certificates/normal/d10_certificate.json` — `46eff64586aef6a2845e8abbb04ad31307a4363a92cd87aa35a51f332bd9f4ad` | K0, E_h^0 przy a0 i sharp tail | M. Kod sprawdza log2 upper D9 < −90; stąd jawnie wyprowadza bezpieczne E0<2^-90. D4 służy dodatkowo do frontiera J, nie dowodzi J. |

### 5.3. D11 i zakończenie

| Etap | Wejście i SHA-256 | Wyjście i SHA-256 | Tożsamość instancji | Faktycznie użyta zależność i ustalenie |
|---|---|---|---|---|
| D11A-a5 | K/commitment — `014358887337670f599c442bb3b838aa6084931efeba17a00eb72fda014e9523`; h*; safe private bridge — `0db3313586980e4aa56827a0f0a6650d6cbed0275d8afedbeb2920d851eeddb1` | `D11A/certificates/public/modq_gauss_certificate.json` — `210e49cf1a03aaf60fd8d8a3395f6c10b2c822bb9abccf540e67d21822540303`; `A5_CERTIFICATE_CONTEXT_BINDING.json` — `459555601b5dcaaca39e5a09f81ab2fe1fb1b25f03da8d3d97476088f902902d` | K0, dodatni graf modulo q | M/I/H. 1536 osadzeń, 768 par, zerowe liczniki degeneracji. Wewnętrzna etykieta run_id=a2 ma jawny binding do A5, bez zmiany certyfikatu. |
| D11B-a2 | D11A/public cert — `210e49cf1a03aaf60fd8d8a3395f6c10b2c822bb9abccf540e67d21822540303`; safe bridge — `0db3313586980e4aa56827a0f0a6650d6cbed0275d8afedbeb2920d851eeddb1` | `D11B/certificates/d11b_certificate.json` — `62218ca6c5e2b98a34343ff5670ba4aa8678e10bc4f73608a377c14663cf86ee` | K0; mapa b−ha po opisanej zmianie współrzędnych | M. CRT i q-local discrepancy; nie archimedean L2. a2 poprawia dokumentację poleceń, zachowując matematykę a1. |
| D11D1 | D9/certificate — `7fcb29213f2a39cf942e011bd1c4ec3a0d843e5347ed82370b9ba9c06270c1fb`; D3/certificate — `b20602f10d6cf0e038260d5b93f211ddb9bf4b6714f5fbf0853b72cc18305708` | `D11D1/certificates/normal/d11d1_certificate.json` — `a5bf2c1e210a3af3c9c5c824838c4090b148f5a62ca314617a852595b74f55a8` | K0; kompleksowy kontur tej samej mapy | M. Dopasowanie skal do D9 i całe near-minor `<2^-133`. Przypięcie D11B nie oznacza użycia jego q-local liczby w tej nierówności. |
| D11D2 | Ogólna konwencja Gaussa z A/B: `A/THEOREM.md` — `27c4cdeb092eb01a649654c606ef93b54031c21d0dd3e7d2cc51ef52a4bb4cc8`; `B/THEOREM.md` — `4ed6753f563c03be562e0b8edf16df0eb49814b1e91dbc401d1ce99fa3270366` | `D11D2/certificates/normal/d11d2_certificate.json` — `b6a50c07b95c69290136f288123eb9e610bae3177c5e06dd03408c59aa53e014` | Uniwersalny w c,a; bez nowego klucza | M. Wsparcie c²/gcd(c,3), amplituda sqrt(gcd(c,3))/c, całkowita masa kwadratowa 1. |
| D11D3 | D11D2/certificate — `b6a50c07b95c69290136f288123eb9e610bae3177c5e06dd03408c59aa53e014` | `D11D3/certificates/normal/d11d3_certificate.json` — `32c254fec9cb305872e49ec8f77dd108d59f57051fe7516cb390b82bd233c5bc` | Uniwersalny lemat lokalny, ta sama A2 | M. Ważona suma Poissona, dokładna objętość i dualne podobieństwo A2. Lokalny wynik nie jest jeszcze globalną energią obrazu. |
| D11D4 | D11D3/certificate — `32c254fec9cb305872e49ec8f77dd108d59f57051fe7516cb390b82bd233c5bc` | `D11D4/certificates/normal/d11d4_certificate.json` — `e5ce21f6ac463312097e85bea52e66a1184cb4047f3aff97d26c755626445d0d` | Uniwersalny far-remainder, Q_D=235 | M. Poza wybranymi otoczeniami względna korekta produktu <2^-33; nie dowodzi całego L2. |
| D11E1 | D11B/certificate — `62218ca6c5e2b98a34343ff5670ba4aa8678e10bc4f73608a377c14663cf86ee`; D11D4/certificate — `e5ce21f6ac463312097e85bea52e66a1184cb4047f3aff97d26c755626445d0d`; D11D1 cert jak wyżej | `D11E1/certificates/normal/d11e1_certificate.json` — `342ae631b0d924db1d56576b10f7ddf1406e606f19989f0cfaada62fdc358de8` | K0 po zastosowaniu ogólnych interfejsów | M dla częściowej drogi. Deklaruje `E_closed<2^-65`, jawnie pozostawia selected-major. Nie jest samodzielnym zamknięciem tail. |
| D11E2 | D7/a3 cert — `fa5989576606d2a7a32edd8178ddfcb5066840feade57f630c385c6037b2832d`; D9 cert — `7fcb29213f2a39cf942e011bd1c4ec3a0d843e5347ed82370b9ba9c06270c1fb`; D10 cert — `46eff64586aef6a2845e8abbb04ad31307a4363a92cd87aa35a51f332bd9f4ad`; D11D1 cert — `a5bf2c1e210a3af3c9c5c824838c4090b148f5a62ca314617a852595b74f55a8` | `D11E2/certificates/public/d11e2_certificate.json` — `7cfc366d65415711c67486d82de21cb6b2d8e76a577935e11128324d5a2c1538`; endpoint replay metadata — `2f3cda9556747dc741f10033c8aae64148f9704dd3dd5f5f97be009a79a88f5b` | K0, to samo f,g i dokładny endpoint; bez podmiany na 9860 | M dla D7/D9/D10 i ogólnych interfejsów, H/Q dla D11E1. Nowy globalny cover Q_D=1000, 33 biny, mean<2^-79 i T_h<2^-99. Zakres niezależnej kontroli mostu analitycznego opisano w §8–10. |
| Final composition | D9, D10, D11E2 certyfikaty z powyższych wierszy; `FC/SOURCE_BINDINGS.json` — `a9faa2ef445abb120f125a7d782b5d43103d722d8155a7955be3576ac4338b91` | `FC/certificates/normal/t2c3_final_certificate.json` — `a5b1b220a24670b40c6c79cb1c6469cb9f470c8cd8c1167ed0c6fa882094a7ff` | Wyłącznie K0 | M: E0<2^-90, T_h<2^-99, p_T<2^-24, Route C. H: 23-stage ledger i assertions. Ostatnia arytmetyka zgodna z kontrolą dokładną tego audytu. |
| Independent Sage review | FC/manifest — `852659713bc97c881606ee8fe53cb14f39b5e5351c1ec0cc028c4fafab41cd9c`; `RV/FINAL_REVIEW_ASSERTIONS.json` — `42e40d78873682a878c8b75decb375e7e9004d766da655a5393c36d8aed2fb4f` | `RV/certificates/normal/reviewer_certificate.json` — `df227ca09dab6214e587b9c970be65ba8d12c4906f40e6dac9ec5a5dcbc5cd2f` | Wyłącznie K0 | M dla końcowej arytmetyki i targetu; H dla 23 manifestów i poprzednich werdyktów. Nie jest niezależnym powtórzeniem wszystkich upstream obliczeń. |
| Research freeze | FC i RV manifesty; `FR/SOURCE_PACKET_BINDINGS.json` — `16dd66ae418ba02a2230d069a1b09f2e2b827b591609de118ba1e107099d3d27` | `FR/CLAIM_BOUNDARIES.md` — `29591e1b37eabd3413a20be780d2dc17b6cd6fcf9dc4fb4d3fa0825bb8f5e450`; FR/manifest — `c921f6a6edf00c7925882e76b10d0a5781079f67f9656d48d8aad861661cd757` | T2C3 nadal K0; T5 osobna gałąź | H/Q. Freeze zapisuje dwa różne kwantyfikatory, nie dowodzi przejścia fixed-key→all-successful-keys. |

## 6. Jak dokładnie negatywne etapy przechodzą w D2

### 6.1. Nieudane majoranty pozostają zachowane

- Raw companion: najmniejszy całkowity PSD upper dla `delta_raw` to 36380; próg wystarczający 22409 nie przechodzi.
- Po **tej samej konkretnej** normalizacji: najmniejszy całkowity upper to 30675, przy `A0=448642`; przeliczony próg wystarczający to 22569. Nie użyto starego raw progu 22409.
- Zredukowany skalar daje majorant około `8.077e161`, czyli log2 około `537.844`. Jest to bezużyteczna górna granica, **nie dolna granica rzeczywistej masy**.

Nie ma tu sprzeczności z późniejszym małym upper. Zmieniono stopień ostrości majorantu, nie tożsamość instancji.

### 6.2. Skumulowana koherencja

CU wykorzystuje posortowane, nieoznaczone górne końce 767 norm operatorowych i ich sumy `B_j`. Dla `k` aktywnych bloków:

\[
Q(rF',rG')\le(A_0+B_{k-1})Q_0(r).
\]

Dokładny krok determinant/Cauchy prowadzi do

\[
Q(rf,rg)\ge\frac{q^2}{A_0+B_{k-1}}Q_0(r).
\]

Zachowano współczynnik dwa w wyrazach mieszanych. Bound jest bezpiecznym sorted/Babel upper, nie twierdzeniem o jednoczesnej realizacji wszystkich największych korelacji na jednym support subset.

Publiczny certyfikat CU zawiera dokładnie supporty 1..768 i w każdym polu `theta_upper` oraz `theta_tail_upper`. Sprawdzono to przez parsowanie. Jego wyeksportowana pełna suma wynosi około `1.0187501003469042e-58`, log2 około `−192.6450293020`.

Właściwym końcowym publicznym checkerem tego wyniku jest:

```text
CU/scripts/verify_cumulative_majorant.sage
a0e3d552921d48847ac0663b1e2475fcab14db69b1004572c5c5b73b88dba909
```

Zachowany `verify_cumulative_public.sage` jest wcześniejszym, niewykonanym placeholderem. Wyjaśnia to `CU/POST_PRIVATE_SOURCE_LAYOUT.md`, hash `2b3567c8651164d7e2831cd008fd1f7a43e1dae8ff6a2abab4f25b8dea662526`. Nie pomylono ich ról.

### 6.3. Konsumpcja w D2

`D2/verify_d2.sage`, hash `ca299a37d024c462cdf9d69e26c90fe97d05a762acc27c08e6ec5e97399352d7`, w liniach 98–101 odczytuje foundation i CU, a w liniach 172–186 sprawdza kompletność 768 klas, ogony, cross factor i sumę. Kopia CU konsumowana przez D2 jest bajtowo identyczna z `CU/public_normal/public_cumulative_verification.json`.

D2 bierze dokładną obwiednię

\[
S_0=\frac{10187501003469042}{10^{74}}<2^{-192},
\]

zachowuje

\[
\kappa=\frac{8\pi^2}{3\beta q^2},\quad\beta=\frac{1536}{2093922385},
\]

oraz gap `t!=0 => Q >= 1019326467/8176`. Kula Banaszczyka przy `c=1` mieści się w `t=0`; reszta jest pokrywana rozwiązaną nierównością względnego ogona `(S0+a)/(1-a)`. Zachowany jest też prefaktor ambient theta, zamiast ukrytej zamiany na jeden.

**D2 dotyczy energii przy tilt beta. Nie jest tym samym obiektem co późniejsze E_h^0 przy a0 ani jakąkolwiek liczbą pochodzącą od samplera produkcyjnego.**

## 7. D7–D11E2: ciągłość danych i zmiany metody

### 7.1. Endpoint i profil D7

Dokładny obiekt endpointu z D7 ma hash kanonicznego JSON:

```text
d44d47fb0d12d4df5a5373af72fffecf93b9d78f249232c96be76bd857fa3b1d
```

Hash ten został niezależnie odtworzony z zachowanego publicznego obiektu. Obejmuje racjonalne enclosures i ich metadane; nie jest hashem klucza. Wartości przybliżone są orientacyjne:

```text
lambda_min ≈ 113.575856684673
lambda_max ≈ 9922.952822293812
trace = 3139584 = 1536*2044
```

Zewnętrzne „lambda_max<9860” zostało zachowane jako **refuted historical comparison**, nie użyte jako przesłanka. D11E2 używa konserwatywnych `lambda_min>113`, `lambda_max<9923` oraz `q²/9923`.

Profil D8 zawiera 384 rekordy, jego hash kanonicznego JSON jest dokładnie:

```text
e308a211ead98f15a425423f9c9fd3b06cb7a06361935933c20f35b7edb19206
```

Sprawdzono ten hash. Próg końcowy to `4543/40`; reguła dla większego wsparcia zachowuje ten sam dolny bound. Profil pochodzi z tego samego f,g co K0. Operacja `(F,G)->(F-Tf,G-Tg)` nie zmienia f,g, więc przejście z danych reduktora do spektrum f,g nie jest zmianą klucza ani nieuprawnionym utożsamieniem B0 z B1.

D11E2 posiada `certificates/canonical_endpoint_certificate.json`, hash `3535846553bd9af52c5f2ddcb281a8e76f6c867a1167a5e7f09ee57adc3a4d91`. Porównanie z D7 potwierdziło dokładną równość pól `endpoint`, `identity_validation`, `spectral_model`, `d8_support_interface`. Różnica całych hashy certyfikatów jest spodziewana: metadane i commitmenty pokrycia wiążą również konkretne wykonanie. `PRIVATE_ENDPOINT_REPLAY.json` jawnie to opisuje.

### 7.2. Silniejsza liczba D9 nie została wymyślona przez D10

D9 deklaruje formalny target `2^-80`, lecz jego certyfikat zawiera outward `log2_upper_RBF512≈−90.217091...`. `D10/verify_d10.sage`, hash `4a1941c4b7ec2abae3c3e0f0e93f37018dc08270023b79dfb6affb798eb9784f`, linie 207–209, parsuje to pole i wymaga `<−90`.

Dlatego `E_h^0<2^-90` w D10/FC jest jawnym zużyciem mocniejszego certyfikowanego endpointu. Nie jest zmianą klucza, skali ani dowolną zamianą etykiety wyniku.

D8 jednocześnie wyraźnie odrzuca wykorzystanie jądra D6: przy doubled theta stosuje `gamma=16*pi²*sigma²/(3q²)`. Tę granicę potwierdzają `D8/THEOREM.md` i `report.md` oraz kod konsumenta.

### 7.3. D11E2 nie jest prostym dodaniem do D11E1

`D11E2/scripts/verify_d11e2.sage`, hash `36f28793cffa915733b854270cde7b6acc98c32cb50aadcc91e5433e3e292059`, przypina D11E1 w `EXPECTED_SHA256`, ale nie parsuje jego `E_closed` ani nie dodaje go do wyniku końcowego.

Rzeczywiście parsowanymi certyfikatami liczbowymi są D7, D9 i D10; dodatkowo kod korzysta z zadeklarowanych ogólnych interfejsów A/B/C3/D3/D11D1. W nowej trasie:

- cover ma `Q_D=1000`, a nie 235;
- przedział centralny korzysta z D9 i jawnego współczynnika korekty;
- near-minor korzysta z D11D1;
- moderate/large outer mają osobne bounds wszystkich częstotliwości i aliasów;
- wynik globalny `<2^-79` z prefaktorem `<2^-20` daje `<2^-99`.

Wobec tego otwarty selected-major w D11E1 i otwarty J w D4 nie są automatycznie niezamkniętymi przesłankami **tej nowej** deklarowanej drogi. Jednocześnie sam nowy certyfikat nie zwalnia z kontroli analitycznego mostu opisanego dalej.

## 8. Potwierdzone zgodności, rozbieżności i rzeczywiste braki

### 8.1. Potwierdzone zgodności

- K0 pozostaje związane tymi samymi `PK*`, `h*`, `SKC*` w K, kopiach wejściowych RC/AP/CU, D7, D11A i D11E2.
- Reducer ma tę samą definicję i reguły tie-breaking; AP i CU mają te same commitmenty wyjścia. CU dokumentuje ponowne historyczne uzyskanie 300/11 i sprawdzenie A2-result; w tym audycie porównano tylko zachowane metadane.
- Metryka offset-768, `Q(f,g)=2044`, `Q(F,G)=552238`, `A0=448642` są spójne. Naturalny porządek współczynników, znaki mapy i wrap A2 mają jawne interfejsy.
- D2 konsumuje właściwy skumulowany certyfikat; D5 nie importuje historycznej innej podstawy; D6 zachowuje orbitę 4608, nie starą liczbę 3072.
- D7/D11E2 nie używają starej granicy 9860; to samo dotyczy starego commitmentu klucza `21976554870b3813d53e71650a76a7ea1ff5c3ba50b4fb80066af0252e96ef7a`, który występuje wyłącznie jako historyczny/superseded.
- Ostatnia dokładna arytmetyka FC odpowiada zapisanym certyfikatom i niezależnej kontroli wymiernej wykonanej w tym audycie.
- Wszystkie 31 badanych głównych manifestów ma identyczne bajty w F i G; podpisane commity są dostępne i poprawnie podpisane.

### 8.2. Wyjaśnione różnice — nie traktować jako podmiany instancji

| Różnica | Rozstrzygnięcie |
|---|---|
| K0/B0 i K0/B1 mają różne companion | Jawna unipotentna zmiana bazy z konkretnym T. Ta sama krata nie oznacza literalnie tej samej macierzy. |
| Raw/reduced skalar FAIL, cumulative PASS | Zmieniona metoda majorowania, nie niższy bound rzeczywistej masy ani nowy klucz. |
| D7-a3 `REFUTED`, D7-a5 dopuszczony endpoint | Refutacja dotyczy starej granicy 9860; a5 zachowuje endpoint, zmienia jego prawidłowe znaczenie i packaging. |
| D11A: `run_id=a2` w certyfikacie pakietu a5 | Jawny `A5_CERTIFICATE_CONTEXT_BINDING.json` wiąże te same bajty certyfikatu z a5. Nie zakładano nowego prywatnego obliczenia. |
| D8-a2 i D11B-a2 | Documentation refreeze; zachowane certyfikaty i verifiery a1. Nie nowe wyniki matematyczne. |
| D9 target 2^-80 versus D10 2^-90 | Mocniejszy, odczytywany endpoint certyfikatu D9. |
| D11E1 2^-65 versus D11E2 2^-79 | Inny globalny sposób pokrycia konturu; nie sumowanie tych dwóch bounds. |
| Manifest C1/C2/C3 w ledgerze różny od manifestu integracji | Kandydat zagnieżdżony versus opakowanie integracyjne; wszystkie odpowiednie hashe zweryfikowane. |
| PENDING_REVIEW w zachowanych pakietach versus późniejsze PROVEN_ACCEPTED | Rozdzielenie niezmienianych bajtów wykonawcy od późniejszych recordów recenzji i podpisanej integracji. |
| C/Extra/c ma dziewięć różnic | Inna obecna tożsamość implementacji. Nie utożsamiono jej z historycznym S17. |

### 8.3. Braki i granice weryfikacji

**G1 — publiczny most analityczny D7/ordered graph → globalny all-alias bound D11E2 wymaga jawnego dopięcia.**

Kanoniczny `D11E2/DERIVATION_PRE_HISTORY.md`, hash `6b08d19150b3e0feae486d42b7e77410dc688ee0e1676604f45f6900d37693c0`, sam zaznacza, że pointwise LDL nie może być utożsamione z coefficient-basis Gram–Schmidt i że trzeba uzasadnić shifted-theta/lattice step. W kanonicznym pakiecie są deklaracja theorem, szkic wymaganej drogi, sprawdzenia liczb i flags `all_public_frequencies_retained`/`all_integer_aliases_retained`. Nie znalazłem osobnego, jawnie konsumowanego artefaktu, który rozwija całe przejście od uporządkowanej parametryzacji grafu przez completion of squares i alias map do wzoru stosowanego przy binach.

Szczegółowy starszy wywód istnieje pod:

```text
G:source_of_truth/v2.3/Results/T2C3-DISCRETE-TAIL-IMAGE-ENERGY-001/
Stages/T2C3D11E2_FINAL_GLOBAL_L2_CLOSURE_20260813/
T2C3-D11E2-FINAL-GLOBAL-L2-CLOSURE-001.md

SHA-256:
13091d1425684fcaa30684ee1d18d434ab607080564fc48b7ce1a0504c3e0ab8
```

Zawiera on ogólny schemat graph-theta completion i all-alias Route C, ale także liczby dla starszego klucza, w tym `lambda_max<9860`. Kanoniczne `HISTORICAL_COMPARISON.md` i `HISTORICAL_COMPARISON_BINDINGS.json` deklarują `history_used_as_premise=false`. Nie można więc bez jawnego mostu uznać całego starego dokumentu za aktualną przesłankę. Ustalenie G1 jest **granicą samowystarczalności publicznego uzasadnienia**, nie twierdzeniem, że podany bound jest fałszywy.

W szczególności kodowe mutacje `drop-alias` i `tail-shortcut` w D11E2 zawierają bezwarunkowe `require(False, ...)`. Dokumentują odrzucenie nazwanych trybów, lecz same nie dowodzą wykrywania rzeczywistego usunięcia aliasów z modelu. To dodatkowy powód, by w wąskim następnym zadaniu sprawdzić semantyczny most, zamiast opierać się wyłącznie na liczbie „controls passed”.

**G2 — nie zachowano pełnych pierwotnych raportów części recenzji.**

`G:evidence/_work/T2C3-CANONICAL-D2-D3-INTEGRATION-001-20260820-a1/REVIEW_GATE.md`, hash `639981892dc12ff475047714b28c3b06e6b920024d41deb44dcac4d08e9e8595`, wprost mówi o braku osobno utrwalonych verdict artifacts dla siedmiu wczesnych kandydatów oraz o braku raw verdict artifacts D2/D3. Analogiczne `artifact_persisted=false` występuje w checkpointach D4–D9. Zapisane acceptance assertions i podpisana integracja są faktem; nie są pełnymi raportami tych recenzji.

**G3 — prywatna część ciągłości pozostaje certyfikatowa.**

Zgodne commitmenty i publiczne receipts wiążą jeden prywatny obiekt i jedną redukcję. Nie są ponownym dowodem, że prywatne bajty rzeczywiście realizują wszystkie deklarowane relacje. Brak prywatnego replayu w tym audycie jest zamierzonym ograniczeniem zakresu i nie obala publicznego wyniku.

**G4 — pakiet F sam nie zawiera wszystkich korzeni dokumentacyjnych.**

Foundation, integracje D2/D3 i A–D9, D1 integration, oryginalny manifest S17 oraz część Route C odtworzono przez G. To rozwiązuje brak lokalnej ścieżki jako problem lokalizacji; nie „naprawiano” starych manifestów ani nie traktowano roboczego H jako zamiennika starego repo-root.

## 9. Dokładny zakres końcowego T2C3 i jego przesłanki

Niech `h*` będzie publicznym kluczem z karty. Niech idealne `mu0` na `Z^3072` ma masę proporcjonalną do

\[
\exp(-a_0Q(z)),\qquad a_0=\frac1{2\cdot768^2},
\]

z metryką offset-768 i publiczną mapą `A_h*(z)=z1+h*z2 mod q`. Niech `muQ` będzie `mu0` warunkowanym przez **`Q(z)<B`**, `B=2093922385`. Tail to `Q(z)>=B`.

Definicje z konsumowanego Route-C certificate:

\[
E_h^0=\sum_{u\ne0}|b_u^0|^2,
\quad E_h^Q=\sum_{u\ne0}|b_u^Q|^2,
\quad T_h=\sum_{u\ne0}|t_u|^2=q^N\sum_cR_h(c)^2-p_T^2.
\]

To równoważnie energia kolizyjna obrazu, np. `E_h^Q=q^N sum_c P_h^Q(c)^2-1`; nie prawdopodobieństwo samego tail i nie twierdzenie o produkcyjnych bajtach podpisu.

Końcowa kompozycja konsumuje:

1. **D9/D10:** `E_h*^0 < 2^-90` dla K0, przy skali `a0`; D10 kontroluje mocniejszy endpoint D9.
2. **D11E2:** `T_h* < 2^-99` dla K0, z globalnym mean-energy `<2^-79` i prefaktorem `<2^-20`.
3. **Uniwersalne obcięcie normy:** `p_T < 2^-24`. W konsumowanym `route_c_theorem_certificate.json`, hash `17cbde88c1db5bcef392d5c08b6f827741ecf6025a935490ee9defa0b8b84ee9`, jest to jawnie importowany bound. Jego wskazany oryginał odzyskano jako `G:source_of_truth/v2.3/Results/T2C2-Q-TRUNCATED-FIXED-H-KERNEL-AGGREGATION-001/certificates/input_certified_bounds.json`, SHA-256 `3460aa9ccb74c9441f96e0557304484b10d385c1e5e83e3852e8031900f3eebc`. Dotyczy on prawa idealnego i zamrożonych parametrów; nie nowego prywatnego klucza.
4. **Dokładne Route C:**

   \[
   E_h^Q=\frac{E_h^0+T_h-2\Re\sum_{u\ne0}b_u^0\overline{t_u}}{(1-p_T)^2}
   \le\frac{(\sqrt{E_h^0}+\sqrt{T_h})^2}{(1-p_T)^2}.
   \]

5. Zachowanie tego samego pierścienia, metryki, częstotliwości, znaków, skali i kwantyfikatora fixed-key oraz przyjętych analitycznych interfejsów opisanych w poprzednich sekcjach.

Używając `sqrt(2)<3/2`, ostatnia arytmetyka daje

\[
E_{h_*}^Q
<\frac{4489}{2^{54}(2^{24}-1)^2}
=\left(\frac{67}{2^{27}(2^{24}-1)}\right)^2
<2^{-89}.
\]

Niezależna kontrola dokładna tego audytu potwierdziła zgodność tego ułamka z certyfikatem i dodatni całkowitoliczbowy gap

```text
(2^24-1)^2 - 4489*2^35 = 127234077622273 > 0.
```

Potwierdzono też dokładne porównanie z zapisanym dolnym endpointem D10:

\[
2^{-89}<
\frac{127756985432600134759330667313}
{500000000000000000000000000000000000000000000000}.
\]

Historyczny reviewer dalej porównuje ten endpoint z targetem `2^(17/(5*2^63))-1`. Szerszy kontekst budżetu zawiera heurystyczny input hardness i nie staje się przez to dowodem bezpieczeństwa schematu.

**Zakres końcowy:** jedna idealna, sharply truncated fixed-key image-energy statement dla K0. Nie wynika z niego automatycznie: wszystkie klucze, prawdziwy rozkład samplera C, pełny Sign–Verify/encoding bridge, output Rényi, FFO, ROM/QROM, MT-ISIS hardness ani EUF-CMA.

### Rozdzielenie od T5

FR jawnie rozdziela:

- T2C3: jeden canonical fixed key, accepted/truncated image energy;
- T5: pure/untruncated T1 graph-dual theta dla każdego successfully emitted key, `tau_h<2^-40`, `delta_key=0`.

T5 nie jest przesłanką końcowego fixed-key FC. Jest osobną później zintegrowaną gałęzią. Wspólny freeze nie zmienia kwantyfikatora T2C3.

## 10. Jedno najmniejsze następne zadanie

**Publiczne dopięcie i niezależna kontrola lematu transportowego D7 → globalny bound D11E2 dla K0.** To zadanie wynika z G1, nie z braku dostępu do prywatnego klucza.

Zakres:

1. Przyjąć jako jawne, hash-bound przesłanki K0, dokładny graf/metrykę z FD/D5, zachowany endpoint D7 i wskazane uniwersalne interfejsy A/B/C3/D3/D11D1.
2. Zapisać dokładnie przejście

   ```text
   S'(r,t)=r(f,g)+t(F',G')
       -> realne completion of squares przy ustalonym całkowitym t
       -> shifted-theta maximum na całej kracie współczynnikowej
       -> bounds przez lambda_min i q^2/lambda_max
       -> all-frequency/all-integer-alias inequality używana w D11E2.
   ```

3. Wykazać, dlaczego całkowita transformacja `r -> r+tT` pozwala użyć tej samej kraty i tego samego boundu przy B0/B1, bez twierdzenia o literalnej równości baz ani o coefficient-basis GS z pointwise LDL.
4. Jawnie rozliczyć, które ogólne kroki starszego dokumentu `13091d14…` są ponownie wyprowadzone/dopuszczone i dlaczego jego stary klucz oraz liczby 63.5/9860 nie są używane.
5. Związać otrzymaną nierówność z dokładnym wyrażeniem `b2=(dc*AMB/lo)^2*theta1*theta2` i pokryciem stosowanym przez obecny kanoniczny checker. Kontrola usunięcia aliasu ma zmieniać model, nie tylko wybierać tryb kończący się bezwarunkowym FAIL.

Warunek zakończenia: samowystarczalny publiczny lemat i tabela konsumpcji jego przesłanek albo dokładnie wskazana przesłanka nadal otwarta. Bez prywatnego replayu, nowego klucza, zmiany źródeł, ponownej redukcji bazy, zmiany historycznych manifestów i statusów. Nie jest to przebudowa repozytorium, T01 ani zadanie estymatora. Zatwierdzenie/wykonanie tego zadania nie nastąpiło w bieżącym audycie.

## 11. Rozdzielenie klas ustaleń

### A. Fakty zweryfikowane z plików i obiektów

- PK*/h*, rozmiar i publiczne kodowanie; hashe i zgodność 17 źródeł.
- Zgodność publicznych commitmentów K0/B1 w wymienionych certyfikatach.
- Równość bajtów konsumowanego CU w D2, liczba 768 support rows i obecność pól nieskończonych ogonów.
- Równość publicznych obiektów endpointu D7/D11E2 oraz odtworzone hashe endpointu i profilu.
- Rzeczywiste operacje odczytu/parsing poszczególnych checkerów, odróżnione od samego hashowania.
- Manifesty lokalne versus archiwalny Git, podpisy commitów i dokładna ostatnia arytmetyka wymierna.

### B. Twierdzenia deklarowane przez artefakty

- Historyczna poprawność prywatnej czwórki i zaakceptowanych filtrów KeyGen.
- Faktyczne wykonanie redukcji i prywatnych replayów, exact PSD/coherence extraction oraz direct spectral enclosures.
- Wyniki RBF/CBF/Sage D2–D11E2, w tym ich całe przesłanki analityczne.
- `E_h*^Q<2^-89` jako historyczny wynik fixed-key z przyjętych interfejsów; dzisiejsza kontrola końcowego ułamka nie odtwarza wszystkich poprzedników.

### C. Historyczne werdykty recenzji i integracji

- `FC/STAGE_ACCEPTANCE_LEDGER.json`, SHA-256 `f15caec284185941d9ff8df33d332ed74255a4315debe79ea69b5cb9db6a1211`, zapisuje 23-stage dual-accept chain.
- `RV/FINAL_REVIEW_ASSERTIONS.json`, SHA-256 `42e40d78873682a878c8b75decb375e7e9004d766da655a5393c36d8aed2fb4f`, wiąże oba końcowe `ACCEPT` z manifestem FC `852659713bc97c881606ee8fe53cb14f39b5e5351c1ec0cc028c4fafab41cd9c`.
- `RV/THEOREM_CHAIN.md` eksportuje `PROVEN_ACCEPTED` wyłącznie dla `ONE_CANONICAL_FIXED_KEY`.
- Podpisany `b478ba…` integruje ten wynik, a `FR/REVIEW_ASSERTIONS.json`, SHA-256 `e7a88c88d756157166afc06145d56ee7e0018a7c7cc1a43b7e523c0ffbf3e059`, zachowuje odrębne werdykty T2C3 i T5.
- Brak raw review artifacts w części etapów pozostaje jawny. Obecny audyt nie dopisuje ani nie zmienia żadnego werdyktu.

### D. Elementy wymagające osobnego wykonania lub kontroli

- Jeśli celem będzie świeża walidacja numeryczna: publiczne checkery właściwych etapów w przypiętym środowisku, z zachowaniem granicy między replayem i rekonstrukcją dowodu. Nie uruchomiono ich w tym audycie.
- Dla pełnej aktualnej oceny matematycznej: publiczny most G1 i jego semantyczna kontrola, zamiast uznania samych flag certyfikatu za dowód.
- Prywatny replay K0/B1/spektrum nie należy do minimalnego następnego zadania i nie jest tu wymagany do potwierdzenia publicznej ciągłości. Ewentualne osobne wykonanie wymagałoby innego jawnego zakresu właściciela.
- Przeniesienie wyniku na C/Extra/c lub uogólnienie na inne klucze to odrębne prace, których nie podjęto.

## 12. Kotwice weryfikacji podpisów

Użyto wyłącznie publicznego keyringu:

```text
H/paper/tasks/owner-auth/public/CBF0DB45F28455CBAC112EC840DA562FF0CDAEF6.gpg
SHA-256: a708bc871313e1112992735ec2476e60decbdcbe44f73de2ecce0d0a7fdd70db
```

Weryfikator: `gpgv (GnuPG) 2.4.7`, offline. Podpis i podpisany payload commitów wyodrębniono z obiektów Git w pamięci; nie zapisywano pomocniczych plików. Dla wszystkich trzech: exit 0, `VALIDSIG CBF0DB45F28455CBAC112EC840DA562FF0CDAEF6`.

| Commit | SHA-256 podpisanego payloadu bez nagłówka gpgsig | SHA-256 wyodrębnionego podpisu |
|---|---|---|
| `8ffa1e011577cd877074888b8650ed521f8bb289` | `6be33cae78737eae27c2d625ac2b5fbb44069e9fbdc0e44c368b63f5174364fb` | `d978c1bd38a95620c9f131fd25e0d5dc4f1399748690bdcd446df88764829770` |
| `b478ba359cfea7b18243c95a9705351491bb167b` | `dfb53cd9a5cb8673690b82a41883988935acb6afcafe2687ee96123b29056566` | `015d11fe0322eb93e68e2abadb6fedd504eb59833328769f7defbf96eed05733` |
| `d641ab1037c2fa1dd4a22c258854d79d67b9b46b` | `7275c1b0f571071a6501671bf69072214d2bfa465eb40ea0a68b8962ad931002` | `863ef973319d2a1a5f58f0401400cb05027838a89b1f101ad34db7274c601804` |

Podpis potwierdza autentyczność podpisanych bajtów i związanie drzewa. Nie dowodzi poprawności twierdzeń ani nie stanowi nowej autoryzacji zmiany repozytorium.

## Konkluzja

**To jest jedna identyfikowalna instancja badawcza, a nie niejawna mieszanina różnych kluczy.** Surowy companion, deterministycznie zredukowany companion i późniejsze intrinsic/graph-theta argumenty mają rozróżnione role. Niepowodzenia majorantów skalarnych nie obalają późniejszej skumulowanej drogi. Historyczny wynik fixed-key ma zachowaną podpisaną integrację i jasno odrębny kwantyfikator od T5.

Zakres dzisiejszego potwierdzenia kończy się na publicznej ciągłości, kontroli konsumpcji, tożsamości źródeł i dokładnej końcowej arytmetyce. Najmniejszym następnym krokiem jest jawne publiczne dopięcie mostu analitycznego D7/ordered graph → D11E2, nie nowe generowanie klucza ani przebudowa projektu.
