# FT1536 — cel dowodu bezpieczeństwa i pierwszy brakujący lemat

Opracowanie zewnętrzne, 2026-09-18; nazwa pliku zgodna z poleceniem z 2026-09-17. Stan źródeł i wejść opisuje inwentarz w §9. Dokument wykonuje główny prompt D00 wraz z doprecyzowaniem D01. Nie jest nowym historycznym werdyktem ani aktywacją zadania S20.

## 0. Rozstrzygnięcie

**Celem pozostaje FT1536 full ternary secret, z uczciwym podpisywaniem w `FALCON_COMP_STATIC`, na źródłach S17.** Weryfikator biblioteczny dopuszcza również payload NONE. Dlatego dowód nie może ograniczyć fałszerza do payloadów STATIC ani odziedziczyć centered-domain ze starego R4.

**Jedna rekomendowana następna praca matematyczna:** lemat `L_V-STATIC`, czyli dokładna ekstrakcja krótkiego świadka naturalnego MT-ISIS z **każdego** payloadu akceptowanego przez zamrożony Verify. Ścisła teza, minimalne wejścia, plan i dopuszczalny wynik negatywny są w §6. To nadal otwarty lemat, a nie twierdzenie niniejszego raportu.

Powody tej kolejności:

1. Właściciel ustalił STATIC; źródłowy język Verify jest szerszy od języka użytego w historycznym R4. Bez ustalenia ekstrakcji nie wiadomo, czy gra trudności obejmuje wszystkie wygrane rzeczywistego przeciwnika.
2. Problem wykracza poza samo kodowanie 9217: przygotowanie `s2` do NTT zawiera tylko jednorazowe dodanie q, nie ogólną redukcję dowolnego `int16_t` modulo q. §2 podaje dokładny świadek naruszenia deklarowanego zakresu.
3. H3 pozostaje pierwszym otwartym krokiem **gałęzi scalar/source → sampler**, ale jest niezależny od publicznej ekstrakcji. Zamknięcie H3 nie usunie rozbieżności domeny Verify. Nie wybieram zadania według numeru katalogu.
4. Późniejszy R5T zawiera już warunkowy argument do `T_h < 2^-138` i `E_acc,h < 2^-106`. Nie należy ponownie zlecać odkrycia tego samego sharp-tail argumentu. Jego bieżące pliki nie tworzą jednak spójnego finalnego freeze; szczegóły w §4.3.

**Nowe ustalenie o opakowaniu:** nieograniczony interfejs nonce w bibliotece/CLI nie wiąże jednoznacznie wiadomości, ponieważ haszuje samo `r || m`. Jest dokładny kontrprzykład polegający na przesunięciu granicy nonce/wiadomość (§2.4). Docelowy typ z nonce długości 40 bajtów musi być rzeczywiście egzekwowany przez opakowanie. Nie stwierdzam, że obecny `tool.c` to robi. To przeszkoda przed twierdzeniem o całym nieograniczonym CLI, niezależna od trudności kratowej.

T2C3 dla h* i T5 dla każdego udanego klucza pozostają zachowanymi, historycznie obronionymi wynikami o własnych kwantyfikatorach. Pełne EUF-CMA wymaga także niżej wymienionych, odrębnych mostów.

## 1. Dokładny obiekt docelowego twierdzenia

### 1.1. Źródła, arytmetyka, parametry

Skróty ścieżek:

```text
H = /media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon
F = H/evidence/candidates/framework_d641
P = H/evidence/candidates/paper
S = H/paper/tasks
DOC = /home/footfalcon/Dokumenty
G = obiekty Git H przy d641ab1037c2fa1dd4a22c258854d79d67b9b46b
S17 = H/build
```

Manifest `G:evidence/_work/PO-01-BASELINE-001-20260803-a1/source_hashes.sha256` ma SHA-256 `03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589`. W tej sesji sprawdzono **17/17** plików `H/build` względem manifestu. Zestaw obejmuje także Makefile, API i `tool.c`; pełna lista jest w §9.1.

Aktywne flagi z `S17/Makefile:35` obejmują:

```text
-O -DFPR_IMPL="fpr-emulated.h"
-DSAMPLER_CODF=0 -DSAMPLER_CDF=0 -DCT_BEREXP=1
-DFT_TERNARY_ADAPTIVE_CDF=1 -DFT1536_CANDIDATE_PROFILE=1
-DCLEANSE=1 -DTRUE_TERNARY_SECRET=1 -DTRUE_TERNARY_SECRET_MODE=1
-DTERNARY_KEYGEN_BOUND_SCALE_NUM=1250
-DTERNARY_KEYGEN_BOUND_SCALE_DEN=100
-DTERNARY_KEYGEN_MAX_ATTEMPTS=3000000 -DSIGN_MAX_ATTEMPTS=16
```

Nie wystarcza samo określenie „binary64”. Twierdzenie źródłowe należy odnosić do modelu LP64: 8-bitowy bajt, 16-bitowe `int16_t`/`uint16_t`, 32-bitowe `int`/`unsigned`, 64-bitowe `long` i typy 64-bitowe; backend FPEMU z przypiętych plików. Konwersje spoza zakresu signed wymagają jawnej semantyki wybranej platformy. W kontrolach z §2 stosuję reprezentację uzupełnień do dwóch i zawężenie modulo 2^16, zgodne z rozpatrywanym modelem GCC/LP64. Dowód nie może utożsamić tego automatycznie z przenośną semantyką dowolnej implementacji C ani uznać signed overflow za poprawne modulo.

Stałe i obiekty matematyczne:

\[
N=1536,\quad d=2N=3072,\quad q=18433,\quad
R=\mathbb Z[x]/(x^{1536}-x^{768}+1),\quad R_q=R/qR,
\]
\[
\sigma=768,\qquad B=2093922385,
\]
\[
Q_R(a)=\sum_{i=0}^{767}(a_i^2+a_i a_{i+768}+a_{i+768}^2),\qquad
Q(z_1,z_2)=Q_R(z_1)+Q_R(z_2).
\]

Każdy test normy jest **ścisły**: `Q < B`, równoważnie `Q <= B-1` dla wektorów całkowitych. M jest blokową macierzą tej formy A2. `center_q` działa współczynnikowo do `[-9216,9216]`; nie jest domyślnym dekoderem STATIC. Mapa publiczna to `A_h(z1,z2)=z1+h*z2` w R_q.

### 1.2. Rzeczywisty KeyGen i prawo klucza

Niech `KG_seed` oznacza jeden świeży kontekst `falcon_keygen_new(10,1)` i `falcon_keygen_make(..., FALCON_COMP_STATIC, ...)`, z buforami zadeklarowanymi przez funkcje maksymalnych rozmiarów API. Eksperyment modeluje świeże 32 bajty z systemowego RNG jako `S_K <- U({0,1}^256)`; późniejsze rozszerzenie jest **rzeczywistym deterministycznym kodem** S17. Jest to model źródła entropii, nie wynik pomiaru systemowego RNG.

`shake_init(...,512)` oznacza tu capacity 512 bitów, czyli SHAKE-256, jak wyjaśnia `falcon-vrfy.c:1360`. Historyczny zwrot „SHAKE-512” w F03 nie uprawnia do podmiany tej funkcji.

Próba KeyGen:

- współczynniki f,g powstają przez `sample_true_ternary_secret`; wartość 3 z 2-bitowego odczytu jest odrzucana, pozostałe oznaczają -1,0,1;
- następują oba testy resultant modulo 2, test normy surowej i ortogonalizowanej, obliczenie publicznego h z odrzuceniem przy nieodwracalnym f, NTRU solve/redukcja i obowiązkowy leaf certificate;
- po najwyżej 3 000 000 próbach funkcja albo koduje i zwraca klucz, albo zwraca 0; także błąd końcowego kodowania jest niepowodzeniem całego wywołania;
- końcowy zakres F,G w ścieżce solve wynosi `|F_i|,|G_i| <= 2047`; nie wolno utożsamiać tej populacji z całą populacją kluczy, które biblioteczny loader może przyjąć.

Kotwice: `falcon-keygen.c:4489–4505,4754ff,7782–8187`, `tool.c:707–719`, F03.

Niech E_K oznacza sukces całego tego wywołania, `p_K=Pr[E_K]`, a

\[
\mathcal K^{seed}_{sk,pk}=\mathcal L(KG_{seed}\mid E_K),\qquad
\mathcal K^{seed}_{pk}=\text{publiczny pushforward tego prawa}.
\]

Cel warunkowy zakłada `p_K>0`. Losuje się **jeden** klucz z tego prawa i używa go we wszystkich zapytaniach. Nie zastępuje się go h*. Nie warunkuje się następnie po cichu na wygodnym kluczu, poprawnym ładowaniu ani udanym podpisie.

Dla gry, która wykonuje jeden KeyGen i przy jego niepowodzeniu nie przyznaje wygranej, zachodzi dokładnie `Adv_uncond = p_K * Adv_cond`. Dzielenie przez prawdopodobieństwo udanego KeyGen, jeżeli jest potrzebne w innym dowodzie, występuje **raz dla wspólnego klucza**, nie Q_s razy.

Osobno istnieje idealne prawo `K_iid`: przy nieskończonej iid taśmie próby f,g są iid uniform ternary. Dla deterministycznego predykatu sukcesu pierwsza zaakceptowana próba, warunkowo na sukcesie przed limitem, ma prawo jednej próby warunkowanej tym predykatem. Geometryczny czynnik się skraca. Nie dowodzi to równości `K_seed = K_iid`. W celu poniżej zachowuję `K_seed`, także w instancji MT-ISIS. Użycie starego R4 z `K_iid` wymagałoby oddzielnego mostu rozkładów kluczy.

### 1.3. Sign, typ podpisu i Verify

**Docelowy typ protokołu:** para `sigma=(r,b)`, gdzie r ma dokładnie 40 bajtów, a b jest payloadem API zawierającym własny jednobajtowy nagłówek. Jednoznaczne transportowe spłaszczenie można określić jako `r[40] || b`; nonce nie jest elementem bufora przekazanego do `falcon_sign_generate`. To jawny kontrakt opakowania wymagany przez twierdzenie. Nie twierdzę, że nieograniczony `tool.c -nonce` egzekwuje ten kontrakt; §2.4 dowodzi, dlaczego zgodność musi być rozliczona.

Uczciwe Sign dla m:

1. Świeży kontekst signera, załadowanie prywatnych bajtów wyemitowanych przez `KG_seed`; błędy API pozostają obserwowalnym niepowodzeniem.
2. `falcon_sign_start` pobiera świeży 256-bitowy seed dla tego kontekstu, rozszerza go przez S17 SHAKE i pobiera 40-bajtowy r. Wybrana instancja gry nie udostępnia przeciwnikowi funkcji ustawiania prywatnego seedu ani zewnętrznego nonce signera.
3. `falcon_sign_update(m)`, następnie `falcon_sign_generate(..., FALCON_COMP_STATIC)`. `HashToPoint` jest opisane w §1.4.
4. Każda z co najwyżej 16 prób `do_sign` inicjalizuje ChaCha20 z 56 bajtów SHAKE. Sampler ma własne wewnętrzne pętle odrzucania; limit 16 nie jest limitem tych pętli. Jedna kompletna próba ma 3072 scalar calls.
5. Konwersje `fpr_rint -> int16_t` następują **przed** norm testem. Fault scalar samplera powoduje return 0. Norm rejection ponawia próbę. Po norm acceptance wykonywane jest jedno kodowanie; jego niepowodzenie zwraca 0, nie rozpoczyna siedemnastej ani dodatkowej próby.

Aby wariant miał dokładną pojemność bufora, w tym celu przyjmuję **2049 bajtów payloadu**, tak jak `tool.c:262,393–394`. To nie jest twierdzenie o maksymalnym rozmiarze STATIC. Błąd pojemności pozostaje częścią gry i wspólnego postprocessingu idealnego. Nie zwiększam bufora, aby usunąć abort. Wydrukowany przez CLI nonce poprzedza generowanie payloadu; odpowiadający mu oracle zwraca `(r,bot)` także przy późniejszym niepowodzeniu. Przy błędzie przed utworzeniem r zwraca osobny symbol braku odpowiedzi z nonce. Nie ujawnia częściowo zapisanego bufora po wyniku długości 0.

Stan fault `tsc` jest inicjalizowany w próbie, a wykryty fault kończy dane generowanie. Nie przypisuję S17 persistent fault latch z diagnostycznego H6G.

Uczciwy b ma nagłówek `0xAA`. Dla Verify przeciwnik może jednak podać **dowolny** skończony payload b, także dłuższy niż bufor uczciwego Sign. Po ustaleniu r przez opakowanie funkcja biblioteczna:

- wymaga zgodności logn=10, ternary=1 i wyzerowania reserved bit;
- wybiera kompresję z nagłówka: `0x8A` daje NONE, `0xAA` STATIC; tryby 2 i 3 dekoder odrzuca;
- wymaga, aby dekoder zużył cały payload;
- wylicza c i wykonuje dokładne źródłowe `falcon_vrfy_verify_raw`;
- akceptuje wyłącznie wynik 1; 0 i ujemne kody są odrzuceniem.

**Definicja Verify w grze jest funkcją C w ustalonym modelu maszynowym, nie zastąpieniem jej postulowaną kongruencją.** Równość z pożądanym predykatem kratowym jest właśnie obowiązkiem `L_V-STATIC`.

### 1.4. ROM, przeciwnik, świeżość, losowość

Główny cel jest klasyczny, w **direct-output ROM**:

\[
\mathcal H:\{0,1\}^*\longrightarrow R_q,
\]

z niezależną uniform wartością dla każdego nowego wejścia bajtowego. Sign i Verify używają `c=H(r || m)`. Przy stałej długości r kodowanie pary `(r,m)` jest injektywne. Oracle rozróżnia wejścia bajtowe, nie samo m.

`falcon_hash_to_point` w kodzie pobiera 16-bitowe słowa i akceptuje wartości mniejsze od `55299=3q`, po czym redukuje modulo q. Dla iid uniform słów daje dokładnie uniform R_q. To uzasadnia warstwę HashToPoint w idealnym XOF/ROM, **nie dowodzi**, że rzeczywisty SHAKE jest funkcją losową. Powrót z direct-output ROM do dostępnego przeciwnikowi bitowego XOF wymaga symulacji także odrzuconych słów i dalszych bajtów; nie jest bezpłatnym równaniem modeli.

Niech A będzie klasycznym probabilistycznym algorytmem o czasie własnym co najwyżej t, pamięci co najwyżej w bitów, łącznej długości przetwarzanych przez niego danych co najwyżej L, z co najwyżej Q_s zapytaniami Sign i Q_H zapytaniami H. Te zasoby nie oznaczają nieokreślonego „PPT” dla jednej stałej instancji N. Wyrocznia Sign jest adaptacyjna i pozostawia abort w transkrypcie. Do zbioru zapytanych wiadomości wpisuje się także zapytania zakończone abortem.

A zwraca `(m*,r*,b*)`. Wygrywa wtedy i tylko wtedy, gdy `m*` nie było zapytaniem Sign, r* spełnia rzeczywisty kontrakt opakowania i źródłowy Verify akceptuje. To EUF-CMA, nie strong EUF-CMA: inny zapis tego samego podpisu na wcześniej zapytanej wiadomości nie jest wygraną.

W `G_real^ROM` HashToPoint zastępuje się H, natomiast rzeczywiste rozszerzenia losowości KeyGen i Sign pozostają takie jak w §1.2–1.3. Potrzebny hop losowości Sign ma koszt `epsilon_rng`: różnicę prawdopodobieństw dowolnego zdarzenia transkryptu przy zamianie SHAKE/ChaCha20 signera na niezależne uniform coins, przy **niezmienionym** prawie klucza. Jest to most oparty na jawnych założeniach o prymitywach, nie statystyczna równość taśm.

Po ograniczeniu liczby odczytów w analizie można go sprowadzać do standardowego rozróżniania generatorów: dla nowego kontekstu na każde zapytanie, korzeń SHAKE dostarcza najwyżej `40+16*56=936` bajtów na zapytanie, a ChaCha20 ma najwyżej `16 Q_s` inicjalizacji. Schematycznie:

\[
\epsilon_{rng}\le Q_s\epsilon_{SHAKE\text{-}PRG}(256,936;t_1)
+16Q_s\epsilon_{ChaCha\text{-}PRG}(448,\ell;t_2).
\]

W tych grach rozróżnia się deterministyczne wyjście dokładnego generatora, z uniform seedem wskazanej długości, od uniform ciągu tej samej długości; `ell` jest maksymalną analizowaną liczbą bajtów jednej instancji ChaCha, a t1,t2 obejmują pracę rozróżniacza. Pomocniczy klucz schematu jest niezależny od seedów Sign. To definicje standardowych problemów rozróżniania ciągów, nie założenie o bezpieczeństwie całego FT1536. Dla wariantu współdzielonych orakli SHAKE trzeba dodatkowo dowieść zgodności domen; nie zakładam jej z nazwy funkcji.

Ponieważ inner rejection loops nie mają capu, ograniczenie pracy pomocniczych symulatorów jest operacją dowodową. `delta_budget` oznacza koszt zastąpienia nieograniczonego wykonania source/ideal-coins przez ustalone skończone budżety; trzeba podać zdarzenia przekroczenia i ich granice. Nie wolno przemilczeć tego kosztu ani twierdzić, że dodano taki cap do źródeł.

## 2. Konkretne granice zgodności STATIC

### 2.1. Długość i domena

`falcon-enc.c:289–379`: dla q=18433 kod współczynnika ma `10+floor(|x|/256)` bitów. Długość b to nagłówek plus zaokrąglenie łącznej liczby bitów do bajtów. STATIC nie znaczy stałej długości ani constant-time.

`uncompress_none:401–455` sprawdza centered-domain. `uncompress_static:462–544` odczytuje znak, 8 niskich bitów i unary quotient; sprawdza `ne > 255`, nie `|x| <= 9216`, a następnie konwertuje do `int16_t`. Dopuszcza m.in. 9217, -20000, negative zero oraz reprezentacje zależne od semantyki zawężania. Bardzo długie wejścia wymagają także uwzględnienia modulo arytmetyki licznika `unsigned ne`; nie wolno ukradkiem zakładać krótkich, kanonicznych kodów fałszerza.

W szczególności dla dowolnego h i `s2=9217*e_0`, cel `c=h*s2 mod(q,Phi)` daje w poprawnej domenie arytmetyki modularnej pierwszy komponent równy 0 i

\[
Q(0,s2)=9217^2=84953089<B.
\]

Ten wektor mieści się w dekoderze STATIC i narusza centered-domain starego R4. To świadek dotyczący uniwersalnego języka z zadanym c, nie algorytm znajdowania preimage losowego hasha.

Samo centrowanie współczynników nie jest automatyczną naprawą w metryce A2. Dla jednej pary offset-768:

```text
Q_A2( 9217, -4608) =  63714817
Q_A2(-9216, -4608) = 148635648
```

Redukcja pierwszej współrzędnej do congruent centered representative zwiększa formę. Każdy taki most potrzebuje rzeczywistego dowodu normy.

### 2.2. Przed NTT nie ma ogólnego modulo q

`falcon-vrfy.c:1393–1399` wykonuje:

```c
w = (uint32_t)s2[u];
w += q & -(w >> 31);
x[u] = (uint16_t)w;
```

Komentarz deklaruje zakres `[0,q-1]`, ale dla legalnego wyniku STATIC `s2[u]=-20000`:

```text
s2+q = -1567
x[u] = 63969
(-20000) mod 18433 = 16866
63969 mod 18433    = 8670
```

Różnica nie znika modulo q, bo 2^16 nie jest wielokrotnością q. Także dodatnie wartości większe lub równe q nie są tutaj ogólnie sprowadzane do `[0,q-1]`. Nie wolno zastosować lematu o NTT wymagającego canonical residues bez sprawdzenia przesłanki.

To jest dokładny kontrprzykład do deklarowanego **lokalnego zakresu/reprezentacji**. Sam w sobie nie dowodzi jeszcze fałszerstwa ani fałszywości ostatecznej nierówności `L_V-STATIC`: tam trzeba rozliczyć całą funkcję Verify, normę i dziedzinę klucza. Nie został wygenerowany żaden nowy klucz ani wykonana próba ataku na rzeczywisty podpis.

### 2.3. Czego nie naprawiają H6P/H6G

H6P dowodzi poprawnej semantyki STATIC na good event: oba komponenty przed castem są centered, zachodzi relacja i ścisła norma. Wtedy dekodowanie oddaje s2, a Verify rekonstruuje **-W1**, nie W1. To jest użyteczne dla uczciwego oracle, ale nie ogranicza payloadów fałszerza do good event.

H6G jest `DIAGNOSTIC_NOT_CANDIDATE_READY`, `source_integrated=false`: jego staging `int64_t`, range guards, relation guards, post-encode verification i persistent latch istnieją w disposable patch. Nie są zachowaniem zamrożonego S17. H3G analogicznie nie dostarcza źródłowego center gate.

### 2.4. Wiązanie nonce i wiadomości — wynik negatywny dla nieograniczonego API/CLI

Kotwice: `falcon-vrfy.c:1357–1371`, `shake.c:532–558`, `tool.c:532,551,574`; API `falcon.h:237–245` zaleca 40 bajtów dla external nonce, ale dopuszcza parametr rlen. Żadne z tych wywołań nie wstawia separatora ani długości między r i m. `tool.c` nie sprawdza `nonce_len==40`.

Niech `r=u||a`, gdzie u ma 39 bajtów, a jest jednym bajtem, i niech b będzie payloadem akceptowanym dla `(r,m)`. Zdefiniuj:

\[
r'=u,\qquad m'=a\mathbin{\|}m,\qquad b'=b.
\]

Wtedy `r'||m'=r||m`, ale `m' != m` (długość rośnie o 1). Wszystkie dalsze wartości SHAKE/HashToPoint, dekodowanie b i decyzja Verify są identyczne. Zatem nieograniczony API/CLI akceptuje podpis dla innej wiadomości.

Przeciwnik z jednym zapytaniem o pustą wiadomość wygrywa z prawdopodobieństwem co najmniej `p_valid`, gdzie `p_valid` to prawdopodobieństwo uzyskania w tym zapytaniu rzeczywiście akceptującego uczciwego podpisu. Nie nadaję `p_valid` niezmierzonej wartości: przy abort lub błędzie poprawności ta konkretna próba nie wygrywa. Warunkowo na akceptującym podpisie transformacja działa deterministycznie. Nie wymaga kolizji hasha, poznania sekretu ani rozwiązania MT-ISIS. W symulacji forgery używa punktu już zaprogramowanego przy Sign, mimo świeżości m'.

To obala przenoszenie standardowego argumentu świeżego punktu ROM na **nieograniczoną zmienną długość nonce**. Dla jednoznacznego typu `r[40]` transformacja nie jest poprawnym podpisem protokołu. Przed przypisaniem takiego twierdzenia wdrożeniu trzeba wskazać i zweryfikować opakowanie, które naprawdę wymusza ten typ. Sam zapis r w `{0,1}^320` w paperze nie wystarcza. Nie zmieniam w tej pracy kodu ani definicji wiadomości na klasę równoważności, aby ukryć problem.

Małe sprawdzenie Lean 4.34.0/Std z §8 formalizuje wyłącznie tę tożsamość wejścia i świeżość wiadomości. Nie jest formalizacją C ani całego eksperymentu EUF-CMA.

## 3. Twierdzenie docelowe i jawne założenia

### 3.1. Naturalne MT-ISIS dla właściwego rozkładu

Definiuję proponowaną, naturalną grę `MT-ISIS_seed,rel(U,T,B)`:

1. Challenger losuje niezależnie U kluczy `h_i <- K_pk^seed` z §1.2.
2. Niezależnie od kluczy losuje z powtórzeniami T uniform celów `c_ij <- R_q` dla każdego i. Cała lista jest statyczna i indeksowana.
3. Algorytm B dostaje wyłącznie klucze publiczne i cele. Zwraca `(i,j,z1,z2)`.
4. Wygrywa dokładnie, gdy indeksy są poprawne, `z1,z2 in R`, `z1+h_i*z2=c_ij` w R_q i `Q(z1,z2)<B`.

**Nie wymagam tu centered z2.** Jest to zwykła kongruencja i krótkość, a nie predykat „C Verify akceptuje” ani gra z wyrocznią podpisu. Dlatego założenie nie jest równoważnym przeformułowaniem bezpieczeństwa FT1536. Usunięcie centered restriction jest jawnym poszerzeniem historycznej relacji; może uczynić problem łatwiejszym. Trudność tego poszerzenia nie wynika z trudności starej gry constrained R4. Parametry q, Phi, sigma i B konstrukcji nie są zmieniane.

Niech `epsilon_MT^seed,rel(U,T;t_B,w_B)` będzie supremum wygranej po klasycznych algorytmach z tymi zasobami. **Jawne założenie kryptograficzne** ma dostarczyć odpowiednio małej konkretnej górnej granicy tej funkcji. Raport jej nie dowodzi ani nie ustala z estymatora. Zero targets, powtórzenia kluczy i celów są legalne. Przykładowo skan zerowych celów daje nieusuwalny floor `1-(1-q^-N)^(UT)`.

Historyczne R4/S09 jest inne w dwóch miejscach: używa `K_iid`, nie `K_seed`, i wymaga centered z2. Jego argument zgadywania indeksu daje czynnik U*T dla **tych samych** praw i relacji. Ten argument można udowodnić także dla nowej gry, lecz nie przenosi on automatycznie jej trudności. Dla głównego celu U=1 i `T=Q_H+1`; pozostawiam funkcję MT, bez dodatkowego zgadywania indeksu i bez drugiego mnożnika T.

### 3.2. Dokładne idealne prawa i interfejsy

Niech `D` będzie ambient discrete Gaussian na `R^2 ≅ Z^3072` z masą proporcjonalną do `exp(-Q(z)/(2 sigma^2))`. Niech `D^B=D | {Q<B}`, a

\[
P_h^B(c)=\Pr_{Z\leftarrow D^B}[A_h(Z)=c],\quad
E_h^B=q^N\sum_c P_h^B(c)^2-1.
\]

Dla dodatniej masy c niech `K_h,c = D^B | {A_h(Z)=c}`. Jeżeli dana masa wynosi zero, idealny interfejs oznacza to osobnym bot; usunięcie tego zdarzenia wymaga dodatniej, jednolitej norm-acceptance premise, nie samego L2 image boundu.

`G_16` oznacza idealny signer, który dla c próbuje co najwyżej 16 niezależnych próbek z pełnego coset Gaussian `D | A_h=c`, testuje `Q<B` i zachowuje terminal bot. `G_acc` używa K_h,c bez terminalnego norm abortu. Oba stosują tę samą mapę bajtową: sprawdzenie wymaganej relacji/good event, STATIC, pojemność 2049 i zachowanie encoding bot. Usuwanie błędu pojemności nie jest potrzebne do redukcji i nie jest bezpłatnie założone.

P, M, Q oznaczają kolejno history-uniform prawa matematycznego transkryptu z S07: finite proposal z produkcyjną akceptacją, finite proposal z exact acceptance oraz infinite proposal z exact acceptance, ze wspólnym stopping i bot. Ich identyfikacja z konkretnymi warstwami źródłowymi musi obejmować te same targety, widths, historie i błędy. Nazwa „ideal” nie uprawnia do zidentyfikowania Q z G_16.

W szczególności H1R używa **dokładnej dyadycznej wartości obliczonego `dss`**, nie automatycznie dokładnej szerokości idealnego ffLDL przy sigma=768. Błędy FFT/LDL, center/width, residuum, iFFT i reprezentacji wymagają własnego mostu. W interfejsach source/sampler kwantyfikator obejmuje każdą wyemitowaną parę **(sk,pk)** i każdą osiągalną historię, nie tylko wybrane publiczne h lub jeden reprezentant sekretnej bazy. Definiuję:

- `epsilon_byte`: jednolitą po kluczu i historii per-query granicę TV pomiędzy źródłowymi bajtami z idealnymi coins a odpowiednio serializowanym P; obejmuje casts, decyzje stopping, rzeczywiste faults, ładowanie i wszystkie niezgodne bajty. Nie wolno relabelować niepoprawnie wyemitowanych bajtów jako źródłowego bot.
- `xi_geom`: jednolitą per-query granicę TV pomiędzy odpowiednio serializowanym Q a G_16. To obowiązek prawa pełnego samplera/FFO, nie nowa nazwa dla H1R.
- `a_abort`: jednolitą po h, c i historii górną granicę prawdopodobieństwa terminalnego norm exhaustion w G_16. `delta_retry=Q_s*a_abort` jest kosztem przejścia do G_acc. `2^-383.8` z S07 jest **warunkowym interfejsem**, którego przesłanek S07 nie zamyka.
- `e_img`: jednolitą górną granicę E_h^B na pełnym successful support. Kandydacka wartość R5T wynosi `2^-106`, warunkowo na jego interfejsach; §4.3 wyjaśnia stan konsumpcji.

Wartości epsilon_byte i xi_geom nie są wyznaczone w obecnych materiałach. Te nierówności są **własnymi obowiązkami dowodowymi**, nie dodatkowymi założeniami kryptograficznymi. Trzeba wybrać rzeczywiste pary praw; nie można policzyć tego samego source-to-ideal coupling dwukrotnie pod dwiema nazwami. Alternatywny bezpośredni coupling H6P do idealnego Z zastępowałby odpowiednie hopy, a nie automatycznie dodawał swój cały koszt do R3G.

Dla jednorodnego uniform per-history TV error x definiuję `g(Q_s,x)=1-(1-x)^Q_s`, gdzie `0<=x<=1`. Nie potrzeba niezależności zapytań, tylko warunkowego coupling po każdej zgodnej historii.

### 3.3. Postać docelowego boundu

Niech `gamma3=16*3072*ln(C3)` z S07/S08, gdzie

\[
C3=\frac{1+r_3}{1-D_3/(9/20)}.
\]

Tutaj r3 jest atomwise relative defect H3 na produkcyjnym dodatnim support, a D3 jego pełnym accepted-submeasure L1 defect; to **nie** nazwa etapu konturowego T2C3-D3. S08 zapisuje dokładne racjonalne endpointy tych dwóch liczb. Warunkowo:

\[
\gamma_3<4.704837\cdot10^{-9}\quad\text{nats na signing query},\qquad
\epsilon_1<2^{-104.3821}.
\]

epsilon1 jest H1R outer-with-bot TV dla 16 prób, a nie dywergencją Rényiego.

**Docelowa teza redukcyjna, dotąd nieudowodniona dla S17:** po udowodnieniu zgodności opakowania, `L_V-STATIC`, H3 reachability, obu source/ideal liftów, interfejsu norm abort, image theorem i symulacji publicznej, dla każdego A z §1.4 istnieje B w grze z §3.1, z U=1, T=Q_H+1, takie że

\[
\begin{aligned}
\operatorname{Adv}^{EUF}_{real\text{-}ROM}(A\mid E_K)
\le \min\{1,\;&\epsilon_{rng}+\delta_{budget}
+g(Q_s,\epsilon_{byte})\\
&+e^{Q_s\gamma_3}\,[
\epsilon_{MT}^{seed,rel}(1,Q_H+1;t_B,w_B)
+g(Q_s,\epsilon_1)+g(Q_s,\xi_{geom})\\
&\hspace{34mm}+g(Q_s,\tfrac12\sqrt{e_{img}})
+\delta_{nonce}+\delta_{pre}+\delta_{retry}
+\delta_{pub}+\delta_{time}]\}.
\end{aligned}
\tag{TARGET}
\]

Każdy argument g jest obcięty do 1, jeżeli dostępny surowy upper bound jest większy. Dla `0<=Q_s<2^320`, po przejściu do iid uniform nonce:

\[
\delta_{nonce}=Q_s(Q_s-1)/2^{321},\qquad
\delta_{pre}=Q_H\sum_{i=0}^{Q_s-1}(2^{320}-i)^{-1}
\le\frac{Q_sQ_H}{2^{320}-Q_s+1}.
\]

Pierwszy składnik płaci za przejście do gry z distinct nonce. Drugi dotyczy wcześniejszego klasycznego zapytania przeciwnika o programowany punkt. `delta_pub` oznacza całkowity błąd aproksymacji publicznego reverse samplera D^B w Q_s wywołaniach; dla per-call bound epsilon_pub można wziąć `g(Q_s,epsilon_pub)`. `delta_time` jest dodatkowym prawdopodobieństwem abort symulatora po przekroczeniu **jawnego** budżetu czasu, jeżeli epsilon_pub nie obejmuje już tego abortu. Tych samych zdarzeń nie liczy się drugi raz. `delta_budget` dotyczy wcześniejszej, źródłowej warstwy analizy ograniczonych odczytów, stąd jest poza mnożnikiem.

Nierówność TARGET jest planem konkretnego dowodu, **nie twierdzeniem z założonymi za darmo nieznanymi małymi błędami**. Nie dotyczy nieograniczonego CLI z §2.4. Dla niego pojawia się dodatkowe zdarzenie aliasowania świeżej wiadomości z już programowanym wejściem; kontrprzykład nie pozwala pominąć tego zdarzenia ani nazwać go kryptograficznie małym.

#### Wyprowadzenie i kierunek metryk

1. Zmiana prymitywów losowości i source-to-P byte coupling daje składniki poza mnożnikiem.
2. S07 daje `P(E)<=exp(Q_s gamma3) M(E)` oraz `TV(M,Q)<=g(Q_s,epsilon1)`. Dlatego epsilon1 stoi **wewnątrz** mnożnika.
3. Q→G_16 ma koszt g(Q_s,xi_geom); G_16→G_acc płaci terminal norm abort, nie znika przez conditioning. Przy nonce collision można zmienić grę za delta_nonce.
4. Reverse sampling losuje Z z D^B, ustawia c=A_h(Z), a następnie używa tego samego warunkowego prawa K_h,c i tej samej serializacji. Idealna gra bierze uniform c, a potem K_h,c. Dla joint law różnica TV wynosi dokładnie `TV(P_h^B,U_Rq)`, a po bajtowym postprocessingu może tylko zmaleć. Cauchy–Schwarz daje `TV(P_h^B,U)<=sqrt(E_h^B)/2`. Jednolitość po h pozwala na coupling adaptacyjny; jeden losowy klucz pozostaje wspólny.
5. Classical lazy sampling programuje świeże punkty Sign. Nieprogramowane zapytania A i końcowy nowy punkt forgery korzystają z co najwyżej Q_H+1 niezależnych uniform celów challenge. Przy stałym 40-bajtowym r świeża wiadomość nie może być identycznym wejściem bajtowym co zapytanie Sign. `L_V-STATIC` zamienia akceptującą odpowiedź w świadka MT-ISIS. Nie ma forking loss, osobnego target-collision loss ani dodatkowego czynnika `Q_H/q^N`; cele są losowane z powtórzeniami, a końcowy niepytany punkt zajmuje ostatni slot.

To wyprowadzenie wybiera **kierunkowe D_infinity + TV**, nie dodawanie D2, D128 i TV. Definicje w nats:

\[
D_\alpha(P\|Q)=\frac{1}{\alpha-1}\ln\sum_x P(x)^\alpha Q(x)^{1-\alpha},\qquad
D_\infty(P\|Q)=\ln\operatorname{ess\,sup}\frac{P}{Q}.
\]

Dla innej poprawnie udowodnionej trasy Rényiego należałoby zachować Höldera:

\[
P(E)\le \exp((\alpha-1)D_\alpha(P\|Q)/\alpha)\,Q(E)^{1-1/\alpha}.
\]

`E_h^B` daje `D2(P_h^B || U)=ln(1+E_h^B)`, nie odwrotny kierunek, nie D128 i nie atomwise lower bound P_h^B. Także TV H1R nie dowodzi małego reverse Rényi przy brakujących atomach. Starsza formuła S10 z alpha=2^60 nie może zostać przepisana ze zmienionymi nazwami profili i liczbami.

#### Zasoby redukcji

Należy dostarczyć publiczny sampler D^B o zadanym budżecie pracy C_pub i błędzie epsilon_pub. Jego wydajność jest obowiązkiem konstrukcyjnym, nie skutkiem nazwania rozkładu. B potrzebuje co najwyżej Q_s takich wywołań, Q_s publicznych mnożeń A_h i jednego końcowego ekstraktora. Przy kosztach C_A dla mnożenia w ustalonym R_q, C_enc dla wiernej serializacji i C_ext dla ekstrakcji:

```text
t_B <= t + Q_s*(C_pub + C_A + C_enc) + C_ext + C_table
w_B <= w + (Q_H+1)*N*ceil(log2(q)) + W_table + W_pub.
```

C_table/W_table są kosztami rzeczywistej tablicy co najwyżej Q_H+Q_s+1 wejść i ich ciągów bajtowych; muszą uwzględniać łączną długość danych L. C_A można zrealizować choćby dokładnym mnożeniem O(N^2) i redukcją modulo Phi,q. C_ext obejmuje tę samą dokładną arytmetykę i dekodowanie całego b*. Budżety C_pub i W_pub wymagają jawnej implementacji/checkera; ich brak nie jest ukryty w notacji „polynomial overhead”. Zdefiniowany koszt nie zawiera samplowania dodatkowych secret keys, bo główna gra ma U=1. W redukcji U*T→1 innego celu trzeba byłoby doliczyć koszt uzyskania dodatkowych kluczy z tego samego conditional law oraz ewentualny cap/rejection abort.

#### Konkretność i nietrywialność

TARGET nie daje jeszcze liczbowego poziomu bezpieczeństwa: epsilon_byte, xi_geom, budżety, ekstrakcja i założenia trudności pozostają niezamknięte. Nawet po hipotetycznym wyzerowaniu tych niewiadomych wybrana konserwatywna TV image route ma zauważalny koszt. Dla kandydackiego `e_img=2^-106` sam składnik `exp(Q_s gamma3)*Q_s*2^-54` ma następujący rozmiar:

| log2 Q_s | Strata mnożnika w bitach | log2 tego składnika, capped at 1 |
|---:|---:|---:|
| 0 | 0.000000007 | -53.999999993 |
| 20 | 0.007117360 | -33.992882640 |
| 30 | 7.288176958 | -16.711823042 |
| 40 | 7463.093205264 | 0 |

To kontrola wielkości jednej straty redukcji, nie estymacja ataku ani dolna granica realnego advantage. Wartość 0 w ostatniej kolumnie oznacza bound 1, nie zerowe prawdopodobieństwo. Nie deklaruję 128 bitów ani pełnego konkretnego celu na podstawie formalnej nierówności, która po podstawieniu budżetów staje się trywialna. Mocniejsza, poprawnie skierowana image/reduction inequality wymaga odrębnego dowodu, jeżeli będzie potrzebna do żądanego poziomu.

### 3.4. QROM — osobny cel

QROM nie wynika z TARGET. Potrzebne są: QPT resource class, quantum oracle z dokładną dziedziną bajtową, cq/channel lift dla sampler/FFO i history-dependent stopping, twierdzenie quantum reprogramming uwzględniające retry i abort oraz odpowiednia quantum MT-ISIS assumption dla tego samego prawa klucza i relacji. Należy określić także klasyczny czy koherentny dostęp do Sign. Klasyczna tablica Q_H+1, prequery union bound i indeksowanie zapytań nie przenoszą się na superpozycje. Nie podaję fikcyjnego liczbowego boundu QROM.

## 4. Zachowane osiągnięcia i aktualizacja późniejszych S20

### 4.1. T2C3, T5, D11E1 V2 i D11E2

- **T2C3:** F01 i F04 zachowują dla jednego kanonicznego h* `E_h^0<2^-90`, `T_h<2^-99`, `p_T<2^-24` i końcowe
  `E_h^B < 4489/[2^54*(2^24-1)^2] < 2^-89`. Jest to accepted-image theorem idealnego prawa, nie źródłowych bajtów STATIC i nie wszystkich kluczy.
- **T5:** F02/F04 zachowują `rho(s M^-1/2 Lambda_h*)-1<2^-40`, `s=sqrt(2*pi)*768`, punktowo dla każdego successful emitted key. `delta_key=0` dotyczy tego twierdzenia supportowego. Nie mówi, że KeyGen nigdy nie zawodzi, ani że sampler i Verify są poprawne dla wszystkich stanów.
- **G1/D11E2:** końcowe opracowanie D04 ustaliło istnienie ogólnego graph-theta/all-alias argumentu i jego zastosowanie do kanonicznych endpointów. Starszej sugestii z D03 nie używam jako nowego braku matematycznego.
- **D11E1 V2:** V01 zapisuje `mathematical_consumption=false` dla krawędzi D11E1→D11E2. Naprawa raw-count normalization nie jest „D11E2 V2” i nie unieważnia przez samą proweniencję numerycznego argumentu kanonicznego E2.

### 4.2. Sampler i bajty

S01/H1R dostarcza direct-TV replacement finite→infinite przy exact kernel, uwzględniając rare/zero/missing-support atoms. Acceptance floor 9/20 oraz 3072 i 16 są częścią dowodu. Nie ma potrzeby przywracać fałszywej globalnej high-order Rényi premise.

S02/H3 obejmuje conditional exponent/BerExp arithmetic, ale wymaga dla każdego aktywnego scalar call:

```text
-2147483283 <= floor(mu) <= 2147483281
```

Równoważny pre-floor interval to `[-2147483283,2147483282)`. Wynika z support `z in [-365,366]`. H3G ma tylko niewdrożony prototyp. S03 rozróżnia population KeyGen (`|F_i|,|G_i|<=2047`) od broader loader population, dla której shear `(F,G)->(F+kf,G+kg)` zachowuje NTRU i liście, a zmienia absolutne centra. H4 leaf bounds same nie zamykają center reachability.

Obliczony `rhat` może wynosić 1: `mu=-2^-1074`, `floor(mu)=-1`, a rounded subtraction daje 1. S02 już obejmuje ten przypadek. Nie należy powtórnie zlecać „naprawy” przez fałszywe założenie `rhat<1`.

S05/H6P pokazuje, że scalar bounds nie identyfikują rzeczywistej pary pre-cast z idealnym wektorem. Jego warunkowa granica

```text
epsilon_byte <= 1-(1-eta_pre)^16 + 16*p_cast + p_box
p_cast < 2^-972, p_box < 2^-65.3374
```

wymaga **tej samej** law po każdym kluczu, historii i retry prefix, coupling eta_pre, MGF dla obu komponentów i osobnej norm-acceptance premise. H5B o z2 nie dostarcza sam z siebie MGF dla W1. H6P zachowuje countermodel z pre-cast bad-event probability 0 lub 1 przy identycznych scalar summaries. Powyższych liczb nie podstawiam do TARGET bez instancjacji właściwych par praw i mapy bajtowej, w tym pojemności 2049.

### 4.3. R5T — wynik matematyczny, aktualne pliki i freeze

S12/S13 zawierają po odpowiedzi na recenzję warunkowy pointwise argument:

```text
mean contour energy < 2^-118
T_h                 < 2^-138
E_acc,h             < 2^-106
```

Argument używa T5, reciprocal LDL pairs, complex L2 przed completion of squares, D3/D10/R5I, D11D1/A/B/C3 i pełnego Dirichlet/all-alias cover. Nie jest automatycznym lift kanonicznego h*. W tej sesji sprawdzono **18/18** hashy obiektów w `ANALYTIC_INTERFACES.json` i cztery dokładne relacje endpointów; nie wykonano pełnego replayu analitycznego.

Niezależna recenzja S15 zachowała conditional numerical core, lecz zgłosiła F01–F04: nieprzypięte interfejsy, label-only mutations, niewłaściwe granice freeze/replay i niekonsumowany endpoint D3. S16 opisuje naprawy i pozostawia final freeze/replay jako operację otwartą.

**Sprawdzenie oryginalnych plików potwierdza, że bieżący `OUTPUTS.sha256` nadal jest starym manifestem**, SHA-256 `279dce6690f9f2d9edbe2f2f625f44d8b783fc4311131ea5e41bca4fbad6d74d`:

| Obiekt | Hash wpisany w OUTPUTS.sha256 | Hash bieżącego pliku |
|---|---|---|
| artifacts/r5t_uniform_tail.json | b8bc27b0041c7f7ca18d7e5dfe460fe47708f4d4c3c2592e3094dddcd3d385e8 | 0c987fbd11bd534a6e23262b00e62881b71862771cd89616cbbd80d55a61592e |
| r5t_theorem.tex | 3f3f29db80f5ca8760069962aeec2c9010b12aac19ec73e281f5d971a667e695 | c91233eaaf0473fb2be635441192da765bb936aaf8223249b7af98fd9d0cab24 |
| scripts/check_r5t_independent.py | 60c3069139dcb1a8ba1000cd05e8f9fc19891f3a6cf66593973c280621d45f71 | 3278835c1b51e642b12d13201176f62fde176cb1293e2ae569f9e66ed19c5360 |
| INPUTS.sha256 | b200f0486dc246042d4d15bcd6809a873db76028ee19b8aa00d3f4c6b811e5a8 | 48e0e5be85a1bc11c0a357e301efaab73c6bf4ab2560a195cb1689776087c1c5 |

Aktualne INPUTS.sha256 ma 38/39 zgodnych pozycji. Jedyny wykryty mismatch dotyczy `paper/tasks/AGENTS.md`: oczekiwano `e44558fd26a9ac0396d12228470914718b8adb7df9dddd456305f17f641437a3`, zastano `5226308db833467be7da02eebce848b8b70f6c5043cd39d544b40456ceccf51f`. Jest to plik organizacyjny, nie obiekt matematyczny spośród 18 interfejsów. Nie wyprowadzam stąd kontrprzykładu do numeryki.

Wniosek: sharp-tail argument już istnieje i trzeba go zachować, lecz `e_img=2^-106` nie może być przedstawione jako bezwarunkowo skonsumowany, spójnie zamrożony nowy scheme input. W TARGET jest parametrem z **kandydacką, warunkową instancjacją**. W tej pracy nie regenerowano manifestów ani nie wykonywano finalizacji historycznego zadania.

## 5. Minimalny łańcuch dowodu i stan R1–R7

W poniższej tabeli „stan” jest opisem merytorycznym na potrzeby tego raportu, nie zmianą rejestru. Kotwice z numerami są rozpisane z hashami w §9.

| Krok | Wejściowe prawo i kwantyfikator | Twierdzenie | Przesłanki | Publiczna kotwica | Stan dowodu | Dokładny brak |
|---|---|---|---|---|---|---|
| Opakowanie / świeżość | wszystkie bajty przeciwnika, r z transportu | świeże m oznacza inne wejście niż Sign | naprawdę stałe 40 bajtów r | falcon.h; tool.c; shake.c; §2.4 | Dla nieograniczonego API wynik negatywny | Rzeczywista zgodność opakowania, nie dodatkowe założenie o hashu |
| Verify → relacja | każde h w successful support, każde c i zaakceptowane b, także NONE | L_V-STATIC | dokładna semantyka decoder/NTT/norm | falcon-enc.c; falcon-vrfy.c; S09 | **Otwarty wybrany lemat** | Ekstrakcja spoza centered-domain historycznego R4 |
| Rzeczywisty KeyGen | jeden seed 256-bit, jeden capped call, potem conditioning E_K | K_seed i pointwise support | komplet source predicates | F03; falcon-keygen.c | Prawo jest zdefiniowane | Nie ma identyczności z K_iid ani liczbowego p_K z samych prób; TARGET zachowuje K_seed |
| R1/T1, C3 | matematyczny A_h, R, M i Fourier conventions | właściwa graph lattice / public image | stałe znaki, metryka, standard dual, normalizacja | F01/F02; interfejsy S14 | Zachowane interfejsy matematyczne | Ich dziedzina nie zastępuje lematu pełnej machine-domain Verify |
| R2/T2C3 | jedna przypięta instancja h* | accepted-image energy <2^-89 | kanoniczny Route C chain | F01,F04,D04 | Historycznie domknięte w tym zakresie | Brak nowej luki w tym fixed-key twierdzeniu; nie ponawiać jako brak ogólny |
| R3/T5 | każdy successful emitted key | pure/untruncated theta <2^-40 | machine-to-exact leaf bridge i exact LDL | F02,F03,F04 | Historycznie obronione | Sharp truncation i production bytes pozostają odrębne; delta_key=0 tylko dla tezy T5 |
| Accepted image dla losowego klucza | pointwise h, D^B | R5T: E_acc,h<2^-106 | T5 + wszystkie universal analytic interfaces | S12–S18,S23 | Warunkowy argument istnieje | Aktualny freeze niespójny; brak finalnej konsumpcji, nie brakuje ponownie odkrycia sharp-tail argumentu |
| Randomness Sign | źródłowe seed/XOF/ChaCha → iid coins, przy K_seed | computational game hop | dokładne PRG games, budżety i auxiliary inputs | frng.c; falcon-sign.c | Otwarta redukcja prymitywów | Konkretne epsilon_rng i koszty; nie statystyczna równość taśm |
| H3 reachability | każdy aktywny scalar call, wszystkie odpowiednie historie | bezpieczne floor i s+z | source-uniform center interval | S02–S04 | Otwarty | Gate H3G nie jest w S17; H4 sam nie ogranicza internal multipliers |
| H3 arithmetic | finite proposal, dodatnie produkcyjne atomy | directional likelihood / normalization | H3 center, H4 widths, exact computed dss | S02,S07,S08 | Warunkowo opracowane | Instancjacja center premise; rhat=1 jest już uwzględnione |
| H1R | finite-exact → infinite-exact, history-uniform | direct TV i common at-most-16 | floor 9/20, wspólne stopping | S01 | Warunkowy użyteczny składnik | Instancjacja source bytes i idealnej geometrii |
| R4/FFO w starym rejestrze | Q z exact scalar kernels → G_16 | pełne prawo coset Gaussian / xi_geom | FFT/LDL, centers, widths, residual, roundings | S01–S03,S05,G01 | Otwarty własny most | Computed dss nie jest automatycznie exact sigma geometry |
| H6 i serializacja | źródłowe W1,W2 → bajty, każdy key/history/retry | epsilon_byte, zgodność fault/norm/cast/buffer | rzeczywisty pre-cast lift, zgodne prawa joint | S05,S06; falcon-sign.c | Otwarty; H6P zawiera no-go dla summaries | Własny joint lift i instancjacja bajtowa; H6G to patch diagnostic |
| R3G | P→M→Q, adaptive queries jednego klucza | exp(Q_s gamma3)[P_Q(E)+g(Q_s,epsilon1)] | atomwise premise i jednolite kernel laws | S07,S08 | Conditional mathematical transcript | Instancjacja źródłowa i kolejne hopy do ROM/bytes |
| Reverse signer / ROM | uniform targets + K_h,c ↔ Z←D^B | image TV, programming, Q_H+1 targets | public sampler, injective framing, wszystkie aborty | S09,S10,S19; §3 | R5F jest PLANNED | Kompletny dowód dla nowego dokładnego profilu i zasobów |
| R6 hardness | MT-ISIS_seed,rel, static iid targets | epsilon_MT upper bound | jawne założenie obliczeniowe | S09 jako punkt odniesienia; §3.1 | Jawne założenie, nie udowodniona trudność | Stary constrained/iid assumption jest inny; estymator nie dostarcza dowodu |
| R7 composition | źródłowa gra EUF-CMA z właściwym kluczem i bajtami | TARGET z zasobami | wszystkie powyższe prawidłowo skierowane hopy | G01,S07,S19 | Otwarty końcowy dowód | Instancjacja wszystkich przesłanek i nietrywialny konkretny bound |

Starsze R1–R7 z G01 nie są automatycznie tożsame z numeracją późniejszych S20-R1…R5. Stan „OPEN — first in order” z historycznego R1 nie unieważnia później zintegrowanego T2C3. Analogicznie zachowane T5 nie zamyka całego starego R3 w sensie dowolnego rozkładu produkcyjnych podpisów.

Minimalne zależności można zapisać bez nowej kolejki organizacyjnej:

```text
S17 KeyGen -> T5 -> [R5T + spójna konsumpcja] -> image reverse sampler
S17 scalar -> H3 reachability -> H3 likelihood + H1R -> R3G
S17 FFT/LDL/pre-cast + H6 + zgodna serializacja -> byte/coset lifts
S17 pełny Verify -> L_V-STATIC ----------------------> MT-ISIS extraction
opakowanie r[40] -> świeży punkt ROM ----------------> Q_H+1 targets
wszystkie powyższe + jawne prymitywy/trudność + zasoby -> TARGET
```

Większa kampania kluczy ma rolę falsyfikacyjną i implementacyjną oraz może dostarczać kolejnych **indywidualnie** certyfikowanych instancji. Liczba poprawnych próbek nie zastępuje kwantyfikatora po całym successful support ani kryptograficznie małego bad-key probability.

## 6. Jeden następny lemat: L_V-STATIC

### 6.1. Ścisła teza do rozstrzygnięcia

Niech `V_S17(h,c,b)` będzie dokładnie następującą funkcją w modelu maszynowym §1.1:

1. h jest poprawnym publicznym wielomianem z `Supp(K_pk^seed)`; przygotowanie NTT/Montgomery odbywa się jak w `falcon_vrfy_set_public_key`.
2. c należy do `[0,q-1]^N`; zamiast wykonywać HashToPoint przekazuje się ten wektor do dokładnej ścieżki raw verification.
3. Dla b wykonuje się dokładne kontrole nagłówka, oba obsługiwane tryby dekodera, pełne zużycie długości i `falcon_vrfy_verify_raw` jak w §1.3. Wynik jest 1 wyłącznie przy źródłowej akceptacji.

Jeśli dekodowanie powiedzie się, niech `s(b)` oznacza **matematyczne wartości całkowite** faktycznie zapisanych `int16_t` coefficients. Zdefiniuj jednoznaczny kandydat ekstraktora:

\[
\operatorname{Ext}_0(h,c,b)=
\bigl(\operatorname{center}_q(c-hs(b)),\;s(b)\bigr),
\]

gdzie mnożenie i center w tym wzorze są dokładną arytmetyką R_q, nie kopią potencjalnie niepoprawnego zakresowo NTT.

**Lemat L_V-STATIC (otwarta teza):** dla każdego powyższego h, każdego c i każdego skończonego b reprezentowalnego w modelu API, o ile `V_S17(h,c,b)=1`, ekstraktor jest zdefiniowany i zwraca `(z1,z2)` spełniające

\[
z1+h z2=c\pmod{(q,\Phi)},\qquad Q(z1,z2)<2093922385.
\tag{L_V}
\]

Nie ma przesłanek „b pochodzi od uczciwego Sign”, „b ma nagłówek STATIC”, „z2 jest centered”, „wejścia NTT już są residues” ani „source machine norm równa się pożądanej normie”. Nie ma zmiany B ani definicji Q. Teza obejmuje wszystkie akceptowane payloady, również niekanoniczne i NONE. Jeśli do powiązania kodu C z tą funkcją potrzeba dowodu braku UB, jest on częścią zadania.

Kongruencja Ext0 jest algebraicznie natychmiastowa. **Treścią problemu jest przeniesienie źródłowej decyzji normy na ten dokładny witness**, po wszystkich konwersjach i NTT. R4 dowodzi tego pod centered-decoder premise; nie dowodzi L_V.

### 6.2. Minimalne wejścia

| Wejście | SHA-256 | Rola |
|---|---|---|
| S17/falcon-enc.c | 0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05 | wszystkie decode branches, padding, cast i int64 norm |
| S17/falcon-vrfy.c | 01c496e5626a37b9d29848c596f0e0efaa328bf9b328649eea4bd1a45fa47f78 | header, public prepare, reduction, NTT/Montgomery, raw decision |
| S17/internal.h | 512629d3b79fa5bd74131ed2ecde06e1d157f5ac58db3f758db96b19131f1ba5 | B i deklaracje/przesłanki arytmetyczne |
| S17/falcon.h | 657ad2b2d45b8932c3b9a703ac718c1f23dad78523036c1a934b8e21cf0f4519 | kontrakt API i kompresji |
| S17/Makefile | 25cd0345332882ccab4beea68d5139955c871499733ab9f5fa3cc8ef898d5049 | profil kompilacji |
| S17/falcon-keygen.c | 0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf | definicja required successful public-key support |
| F03 / KEYGEN_LAW.md | 6ddab78425cf23a086d60bc63cadd9e534ea713966b764b64fb31177603ae174 | rozróżnienie support i praw seed/iid |
| S09 / assumption_mtisis.tex | 684335cfbedcd80e46177847344b4ab779050dca2261687dde2c3c739235ee32 | stary poprawny argument pod centered premise; granica transferu |

Pełny manifest S17 przypina pozostałe zależności. R5T, H3, H6, prywatna baza i nowy KeyGen nie są potrzebne do samego lematu publicznego Verify. Dowód dla wszystkich poprawnie zakodowanych h byłby silniejszy; kontrprzykład wyłącznie dla h spoza required successful support musi być oznaczony jako kontrprzykład do tej **silniejszej** wersji.

### 6.3. Konkretny plan matematyczny

1. **Wyprowadzić decoder jako funkcję na słowach.** Uwzględnić `ne`, `lo`, znak, cast w obu gałęziach, negative zero, padding i zwracaną długość. W modelu LP64 store odpowiada `wrap16(lo)` lub `wrap16(-lo)`, nie nieograniczonej liczbie lo ze znakiem. Zbadać także przepełnienie unsigned counter na bardzo długim wejściu. To skończony dowód na automacie parsera, nie enumeracja wszystkich ciągów.
2. **Sformalizować mapę do wejścia NTT:** `iota(x)=(x+q*1[x<0]) mod 2^16`, dokładnie jak w źródle. Rozdzielić zakresy x, w których odpowiada poprawnemu residue, od pozostałych. Świadek -20000 z §2.2 musi zostać zachowany jako kontrola negatywna; nie może zniknąć przez założenie centred.
3. **Udowodnić modular arithmetic z rzeczywistymi zakresami.** Dla `mq_add`, `mq_sub`, Montgomery, forward i inverse NTT ustalić warunki niezbędne dla przeniesienia do R_q. Propagować zakresy, a nie używać samego komentarza `[0..q-1]`. Arytmetyka słów może nie być liniowa po przepełnieniach; test na samych wektorach bazowych nie dowodzi liniowości całej funkcji.
4. **Porównać dokładny witness z machine pair.** Odczytana norma C jest dokładną formą na zapisanych int16: maksymalna suma modułów składników `4608*32768^2=4947802324992<2^63`, a każdy iloczyn mieści się w int32. Pozostaje wykazać, że source acceptance implikuje `Q(Ext0)<B`. Jeśli nie ma równości pierwszego komponentu, potrzebna jest prawdziwa nierówność, nie deklaracja. Centering s2 nie jest monotone dla Q (§2.1).
5. **Równolegle do dowodu szukać falsyfikatora jego dokładnej tezy.** Wykorzystać publiczne h z już certyfikowanej instancji, publiczne c i syntetyczne bajty; nie potrzeba prywatnego klucza ani nowego KeyGen. Dla świadków wyprowadzić ścieżkę C i obie dokładne normy, a nie tylko wynik testu PASS/FAIL. Losowy target może mieć taki c z dodatnim prawdopodobieństwem; znalezienie takiego c nie oznacza jeszcze efektywnego EUF-CMA forgery.
6. **Eksportować tylko rzeczywiście uzyskany wynik.** Pozytywny L_V daje koszt C_ext i deterministyczną ekstrakcję dla pełnego Verify. Wynik negatywny pozostaje negatywny dla ustalonego Ext0/B/domeny. Inny ekstraktor lub poprawka implementacji wymagałaby osobnego, jawnego zakresu, nie cichego przesunięcia tezy.

Ta praca nie wymaga najpierw pełnego probabilistycznego dowodu samplera. Jest małym, publicznym i logicznie wcześniejszym interfejsem gry: ustala, czy naturalna relacja MT-ISIS rzeczywiście obejmuje każdą akceptowaną odpowiedź.

### 6.4. SageMath, Lean 4 i kontrole zmian znaczenia

- **SageMath:** ZZ/QQ, quotient ring `Z[x]/Phi`, ring modulo q, dokładne A2 normy i model słów. Tu nie trzeba przybliżeń RBF do samych wielomianów i casts. Dostępne SageMath 10.9 można przypiąć do **nowego** checkera L_V; nie jest ono replayem dawnych certyfikatów Sage 9.5. Nie zmienia się historycznych pinów. Symbole pi/Gaussian nie są potrzebne do L_V.
- **Lean:** nowy, ograniczony proof nad parserem, słowami i implikacją normy można zacząć od dostępnego Lean 4.34.0/Std. Jeśli użyje się algebraicznych bibliotek mathlib, potrzebny jest osobno przypięty kompatybilny revision; nie założono jego lokalnej dostępności. Istniejący generic S20-FV używa Lean 4.30.0 i mathlib `c5ea00351c28e24afc9f0f84379aa41082b1188f`; nie wolno uznać build na 4.34 za jego historyczny replay.
- **Granica certyfikatu:** Sage endpoint wprowadzony do Lean jako hypothesis nadal jest hypothesis. L_V ma wyeksportować dowód zachowania parsera i arytmetyki, a nie aksjomat „Verify implies witness”. Trzeba obejrzeć statement, imports, `#print axioms`, brak `sorry` i źródłowy związek modelu z C.
- **Rzeczywiste mutations:** ograniczenie przeciwnika tylko do STATIC; przepisanie decode_NONE do STATIC; usunięcie cast; zastąpienie jednego dodania q pełnym modulo; pominięcie unsigned wrap; założenie centered z2; zmiana `Q<B` na `Q<=B`; błędny znak pierwszego komponentu; inna Phi lub offset; błędne padding/consumed length. Każda kontrola musi faktycznie zmienić wejście/formułę i zostać odrzucona przez niezmieniony walidator.
- **Boundary vectors:** ±9216, ±9217, ±18433, -20000, ±32767, -32768, magnitudes 32768 i 65535, ne=255/256, nonzero padding, reserved headers oraz dokładne normy B-1/B/B+1. Kontrola opakowania musi zachować kontrprzykład r40→r39 dla nieograniczonego API; typ r40 powinien odrzucić taką zmianę z rzeczywistego powodu długości, nie przez inny błąd.

### 6.5. Ukończenie, wynik negatywny i przekazanie

**Ukończenie pozytywne:** dowód L_V dla required successful support i wszystkich akceptowanych payloadów, z udowodnionymi przesłankami machine arithmetic i kosztem ekstraktora. Ograniczony fuzzing, poprawne uczciwe podpisy, albo twierdzenie zakładające pożądaną równość NTT nie spełniają kryterium.

**Ukończenie negatywne:** publiczny `(h,c,b)` w dokładnej dziedzinie, dla którego source Verify akceptuje, lecz Ext0 nie jest krótkim świadkiem, albo precyzyjny dowód, że wymaganej semantyki C nie dostarczają wskazane warunki platformy. Trzeba podać dekodowane współczynniki, przebieg krytycznych operacji, obie normy i źródło przynależności h do support. Świadki lokalne §2.1–2.2 nie zastępują tego pełnego warunku. Nie zwiększać B ani nie wycinać trudnych bajtów, aby uzyskać PASS.

**Przekazanie dalej:** pozytywny wynik daje deterministyczny most do `MT-ISIS_seed,rel` z tym samym B i bez kosztu bad-event ekstrakcji. Nie daje trudności MT-ISIS, poprawności signera, epsilon_byte, xi_geom ani ROM programming. Ujemny wynik precyzuje obowiązek zgodności implementacji i profilu przed kontynuowaniem końcowej redukcji. Znany wynik negatywny o nonce z §2.4 już teraz wyklucza bezpośrednie przeniesienie twierdzenia na nieograniczony CLI.

## 7. Co musi zostać wykazane przed publikacją pełnego wyniku

Deklaracja pełnego bezpieczeństwa wymaga równocześnie:

1. Rzeczywistego, jednoznacznego opakowania 40-bajtowego nonce i sprawdzonej relacji tego opakowania do biblioteki/CLI. Otwarty typ external nonce nie może być objęty twierdzeniem przez samą deklarację w tekście.
2. Rozstrzygnięcia L_V oraz pełnego języka MT-ISIS; obecny R4 nie pokrywa automatycznie STATIC ani real seed key law.
3. H3 center reachability dla populacji wyemitowanej przez KeyGen, bez importowania niewdrożonego gate. Następnie source/geometry/pre-cast/byte lifts z prawidłowymi kwantyfikatorami po histories, retry i obu komponentach.
4. Wiernego rozliczenia norm retry, scalar faults, loader errors, encoding/capacity abort, ewentualnego ograniczania czasu i praw losowości. H6G nie jest wdrożoną przesłanką.
5. Spójnej, sprawdzalnej konsumpcji image result dla losowego klucza: zachowane T5 samo nie wystarcza; R5T dostarcza conditional analytic route, lecz obecne freeze nie jest gotowe do finalnego importu.
6. Kompletnej klasycznej redukcji z publicznym samplerem, właściwym ROM modelem, zasobami oraz poprawnym boundem metrycznym. Dla konkretnie deklarowanego poziomu lambda trzeba rzeczywiście wykazać `RHS(TARGET)<=2^-lambda` przy zadanych t,w,Q_s,Q_H,L. Sama nierówność ograniczona przez 1 nie spełnia tego kryterium.
7. Jawnych, odrębnych założeń trudności MT-ISIS i niezbędnych prymitywów losowości. Nieudowodnione własne hopy nie mogą być ukryte w tych założeniach. QROM wymaga osobnego dowodu z §3.4.

Nie jest to warunek ponownego dowodzenia historycznych T2C3/T5. To warunek szerszej deklaracji o całym schemacie i jego konkretnym interfejsie.

## 8. Faktycznie wykonane kontrole i zakres narzędzi

W tej pracy wykonano odczyty oryginalnych publicznych twierdzeń i źródeł, weryfikacje SHA-256, kontrolę 17-plikiowego S17, 18 interfejsów R5T, 39 pozycji aktualnego INPUTS R5T i wskazanych pozycji jego OUTPUTS. Pierwsza ścisła kontrola INPUTS zatrzymała się na mismatch; diagnostyczne dokończenie wskazało jedyną pozycję AGENTS.md. Niezgodności pozostawiono i opisano, nie naprawiano manifestów.

Dokładnym Python/Fraction sprawdzono z bieżącego R5T JSON: endpoint central energy `<2^-118`, endpoint accepted energy `<2^-106`, moderate maximum `<17/20` i exact leaf `>992`. To kontrola zapisanych racjonalnych endpointów, nie ponowne wyprowadzenie konturu ani pełny replay Sage. Osobno dokładnymi liczbami całkowitymi sprawdzono przykłady decoder/pre-NTT, centering A2 i nagłówki z §2. Tablica wielkości mnożnika jest orientacyjnym rachunkiem Decimal na zapisanym upper endpoint gamma3.

Bezpośrednio uruchomiono Lean ze ścieżki:

```text
/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean --stdin
Lean 4.34.0, commit 293d5d0c0c3f3dded4688b3ccd6a33939ac5102b
```

Kod podany przez stdin:

```lean
import Std

theorem nonce_repartition (u : List UInt8) (a : UInt8) (m : List UInt8) :
    (u ++ [a]) ++ m = u ++ (a :: m) := by
  simp only [List.append_assoc, List.singleton_append]

theorem message_changes (a : UInt8) (m : List UInt8) : a :: m ≠ m := by
  intro h
  have hlen := congrArg List.length h
  simp only [List.length_cons] at hlen
  omega

theorem verification_preserved (V : List UInt8 → List UInt8 → Bool)
    (u : List UInt8) (a : UInt8) (m b : List UInt8)
    (h : V ((u ++ [a]) ++ m) b = true) :
    V (u ++ (a :: m)) b = true := by
  simpa only [nonce_repartition] using h

#print axioms nonce_repartition
#print axioms message_changes
#print axioms verification_preserved
```

Exit code 0. Zależności kernelowe: odpowiednio `[propext]`, `[propext, Quot.sound]`, `[propext]`. To mały formalny dowód własności list i deterministycznego V zależnego od złączonego wejścia. Źródłowe stwierdzenie, że C haszuje takie wejście, sprawdzono przez odczyt funkcji; nie sformalizowano całego C w Lean. Nie użyto `sorry`, nowego aksjomatu „C jest poprawne”, `native_decide` ani prywatnych danych.

Informacja o działającym SageMath 10.9 pochodzi z D02; w tej sesji nie wykonywano Sage ani lake build. Historyczne T2C3/D11E2 przypinają Sage 9.5/ZZ/QQ/RBF512, R5T Sage 9.5/RBF1024 (S22), a generic S20-FV inne, wskazane w §6 piny. S20-FV zachowuje conditional numerics/common-part premises; jego theorem count i udany build nie formalizują źródłowej instancjacji H1R. Objętego kwarantanną `S20-H1-FV-LEAN4-FULL-COVERAGE-001-20260827-a1` nie konsumowano.

Jedynym nowym trwałym plikiem tego zadania jest niniejszy raport. Nie zmieniano źródeł, parametrów, rejestrów, historycznych manifestów ani Git; nie generowano kluczy i nie wykonywano historycznych runnerów zapisujących artefakty.

## 9. Inwentarz hashy użytych wejść

Ścieżki rozwijają się według §1.1. Hashe odnoszą się do bajtów odczytanych w tej sesji, nie do domniemanych wersji po finalizacji. D03–D05 są nawigacją/poprzednimi opracowaniami; podstawowe twierdzenia bieżącego raportu zakotwiczono również w źródłach i oryginalnych artefaktach.

### 9.1. Pełne S17

```text
25cd0345332882ccab4beea68d5139955c871499733ab9f5fa3cc8ef898d5049  H/build/Makefile
0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05  H/build/falcon-enc.c
06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063  H/build/falcon-fft.c
0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf  H/build/falcon-keygen.c
eee8d7dc503e007cb76bcc157094b2a2de481075ac3f67426848f7a8cae6efd8  H/build/falcon-sign.c
01c496e5626a37b9d29848c596f0e0efaa328bf9b328649eea4bd1a45fa47f78  H/build/falcon-vrfy.c
657ad2b2d45b8932c3b9a703ac718c1f23dad78523036c1a934b8e21cf0f4519  H/build/falcon.h
5dd9110dd4e77c96e19263488bd0937cea0032623f40cacb289da7e3e1256d56  H/build/fpr-double.h
7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f  H/build/fpr-emulated.c
242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa  H/build/fpr-emulated.h
4b1289adf0c902abe9408d989b4eb8d292cbb6ea86b92e1325a10fd9c5dfc644  H/build/frng.c
c16f041a64aba25991b5473111675f1c046ebc38285fca6c052124cf3b7fdf4f  H/build/ft1536-adaptive-cdf-tables.h
512629d3b79fa5bd74131ed2ecde06e1d157f5ac58db3f758db96b19131f1ba5  H/build/internal.h
c3e7864bf4139264f8c287053214bf869e242757bf555235da81454e40ea316a  H/build/shake.c
2373a37e09907c8e57a6b1adc05e26499d9cf2752518267a80291de931c2d8df  H/build/shake.h
ecd22c8f0ac8c24df0692c94ebb293b5944fe42fc57d97f2e06f01e5ecc44b4c  H/build/test_falcon.c
920ac2d8a96408c505670eb2f044cde763ca11945d90ec24d8c6f2a048377890  H/build/tool.c
```

### 9.2. Dokumenty i twierdzenia

| ID | Ścieżka | SHA-256 |
|---|---|---|
| G01 | G:source_of_truth/v2.3/OBLIGATIONS.md | f79efa5368f7d51eab8af80b85aa7978323220f2c0561811a9e8b7d5dd50bb40 |
| D00 | DOC/FT1536_PROMPT_CEL_DOWODU_BEZPIECZENSTWA_2026-09-17.md | e780cd64166d1d2bdf9ca440ec6260dbea316dc863bf0f117847492f009d447d |
| D01 | DOC/FT1536_DOPRECYZOWANIE_PROFILU_COMP_STATIC_2026-09-17.md | ab16d3ad322d8da1bda7c5563008b0b79fedf916d85f5b7411873492d66f2794 |
| D02 | DOC/FT1536_SRODOWISKO_SAGE_LEAN_2026-09-17.md | 6bef38e9173fcd33cd31ede9fab019699521722bdac6249abca9404cfb106511 |
| D03 | DOC/FT1536_AUDYT_CIAGLOSCI_KLUCZA_BAZY_T2C3_2026-09-17.md | def738641b8072e723fc4f457a3eb4f60ad6c102fd7a7b371e27faa9a0ba081c |
| D04 | DOC/FT1536_WERYFIKACJA_UZASADNIENIA_D11E2_2026-09-17.md | b9b7231729908449986afc448aee9c256ec435668b403b8f3c25b0088eec9e9f |
| D05 | DOC/FT1536_PAPER_TEZA_MAPA_DOWODOW_2026-09-17.md | 02f9acf2ead10901455c9b9d8cef78a4c1eb7616b3c8b2bf1509d7fc552a8134 |
| P01 | P/FT1536_FALCON_STYLE_FULL_ACADEMIC_PAPER_REV5.tex | 64127490a2793379e25582354387f7fd155de1fee434eee9f06833bdf7bd7a9f |
| P02 | P/FT1536_SEC20_SOURCE_BOUND_SAMPLER_BRIDGE_R1_R5_REV3.tex | 425d24ece7a0fe5de27aa10ea07ae54a85034a956554f06d78352a6e06dff28d |
| F01 | F/T2C3-CANONICAL-FINAL-COMPOSITION-001-20260822-a1/THEOREM.md | 4b1dc3aa48d4738b3d4ca854691e633371769bf73ec6777ca26d1c67ea728bbc |
| F02 | F/T5-KEY-QUANTIFIER-DECOMPOSITION-001-20260822-a2/THEOREM.md | 21b7e453a3a9529c463f492234d078a3e737105cb539e553adce5e103a6c5784 |
| F03 | F/T5-KEY-QUANTIFIER-DECOMPOSITION-001-20260822-a2/inputs/a1/KEYGEN_LAW.md | 6ddab78425cf23a086d60bc63cadd9e534ea713966b764b64fb31177603ae174 |
| F04 | F/FT1536-RESEARCH-FREEZE-T2C3-T5-001-20260822-a1/CLAIM_BOUNDARIES.md | 29591e1b37eabd3413a20be780d2dc17b6cd6fcf9dc4fb4d3fa0825bb8f5e450 |
| V01 | H/evidence/candidates/d11e1_v2/D11E1_V2/DEPENDENCY_GRAPH_CORRECTION.json | 02f761d77528c201a5de3df5051ca6cb3fd3c808aaffdf8811e51bfe45ac233a |
| S00 | S/QUARANTINE.json | e8ed0f04908cc7ddf591d61ce7063653f7312cd3dd7098a27ef35db3d04dfe26 |
| S01 | S/S20-H1R-RARE-ATOM-HYBRID-001-20260827-a1/h1r_theorem.tex | 2861699ec727a3f6f9504e144d4920553402353cceb97551c5bc5bd19b31dac9 |
| S02 | S/S20-H3-REACHABLE-EXPONENT-BRIDGE-001-20260827-a1/h3_theorem.tex | 52a896019a704afd3b5eb63139b0809c4b479dede27cd3bdd2b4219c2bf6f5ea |
| S03 | S/S20-H3-REACHABLE-EXPONENT-BRIDGE-001-20260827-a1/CENTER_BOUND_AUDIT.md | 75ccf272d0574ccc39c9f16e811411e302784ead465896e67ae39e13b1055675 |
| S04 | S/S20-H3G-CENTER-RANGE-GATE-001-20260827-a1/report.md | 801052b5a88b3acb18e84cb95707c5c8f7c2595bc276e51989c1286b05c5419f |
| S05 | S/S20-H6P-PRECAST-BAD-EVENT-001-20260827-a1/h6p_theorem.tex | 2f86cc9b3b11ba96ae87057d4d5a6f5e67ec670fab1600ed37e92aa36802f2ae |
| S06 | S/S20-H6G-FAIL-CLOSED-SERIALIZATION-001-20260827-a1/report.md | 4d1078de2b6fa2babe6ae1cf8055e935487749445b100a5f13acb5c6be529227 |
| S07 | S/S20-R3G-GLOBAL-TRANSCRIPT-COUPLING-001-20260827-a1/r3g_theorem.tex | 12f7a0c5e1e8561487d95f70590990160458937f514563328a708d4516bed00a |
| S08 | S/S20-R3G-GLOBAL-TRANSCRIPT-COUPLING-001-20260827-a1/artifacts/r3g_directional.json | 076b3543d8bf9d0e1ed7e1982375ff796ec54c375e942512a734c1b744547b05 |
| S09 | S/S20-R4-MT-ISIS-FORMULATION-001-20260826-a1/assumption_mtisis.tex | 684335cfbedcd80e46177847344b4ab779050dca2261687dde2c3c739235ee32 |
| S10 | S/S20-R5-ROM-QROM-COMPOSITION-001-20260826-a1/report.md | b7bb70864da9059af0ca6d5a7143ace4aacc7250d6a14567ed49786649fa29aa |
| S11 | S/S20-R5I-SUCCESSFUL-KEY-IMAGE-ENERGY-001-20260827-a1/report.md | 244ca20d2fe734e9036607bdebf6b23bab4ce2c8bb9e5493b44ad2aceea51802 |
| S12 | S/S20-R5T-SUCCESSFUL-KEY-SHARP-TAIL-001-20260827-a1/r5t_theorem.tex | c91233eaaf0473fb2be635441192da765bb936aaf8223249b7af98fd9d0cab24 |
| S13 | S/S20-R5T-SUCCESSFUL-KEY-SHARP-TAIL-001-20260827-a1/artifacts/r5t_uniform_tail.json | 0c987fbd11bd534a6e23262b00e62881b71862771cd89616cbbd80d55a61592e |
| S14 | S/S20-R5T-SUCCESSFUL-KEY-SHARP-TAIL-001-20260827-a1/ANALYTIC_INTERFACES.json | 53a2ba9cf26726af1f4153170c90e2a9f94bb23356e04c360010672ff9b02855 |
| S15 | S/S20-R5T-SUCCESSFUL-KEY-SHARP-TAIL-REVIEW-001-20260827-a1/report.md | daf02ebebebc6a5122087ab0114fe5a936aa43bacd1ca63da22a6f7a8cbde1aa |
| S16 | S/S20-R5T-SUCCESSFUL-KEY-SHARP-TAIL-001-20260827-a1/REVIEW_RESPONSE.md | f476e2afa9a869a48c270681e114df9b989e8fcda0e32baf71d2a898affe5d24 |
| S17 | S/S20-R5T-SUCCESSFUL-KEY-SHARP-TAIL-001-20260827-a1/scripts/check_r5t_independent.py | 3278835c1b51e642b12d13201176f62fde176cb1293e2ae569f9e66ed19c5360 |
| S18 | S/S20-R5T-SUCCESSFUL-KEY-SHARP-TAIL-001-20260827-a1/OUTPUTS.sha256 | 279dce6690f9f2d9edbe2f2f625f44d8b783fc4311131ea5e41bca4fbad6d74d |
| S19 | S/S20-R5F-CLASSICAL-ROM-EUF-CMA-001-PLANNED/SCOPE.md | bbf55164e6f088bb626e353fc98fe7b054605bcc134b8d48bb34df3b1ed30ecc |
| S20 | S/S20-FV-LEAN4-SAMPLER-HYBRID-001-20260827-a1/report.md | a8f2e3ab01ccd428f7043e9d9fac81a2c3fda3690a9437e1d1747f929ef47f3a |
| S21 | S/S20-R5T-SUCCESSFUL-KEY-SHARP-TAIL-001-20260827-a1/report.md | f409909f8505be3cf195b2846fba17b1d630b13740abd4c5b276fea6c22747d5 |
| S22 | S/S20-R5T-SUCCESSFUL-KEY-SHARP-TAIL-001-20260827-a1/TOOLCHAIN.txt | 54703d951bedc2e82e561fc11c5573e947ac93838a14f12f7523bc20d7425dab |
| S23 | S/S20-R5T-SUCCESSFUL-KEY-SHARP-TAIL-001-20260827-a1/INPUTS.sha256 | 48e0e5be85a1bc11c0a357e301efaab73c6bf4ab2560a195cb1689776087c1c5 |

S14 zawiera pełną listę ścieżek i SHA-256 18 sprawdzonych interfejsów analitycznych; S23 zawiera ścieżki/hash-piny pozostałych sprawdzonych zależności. Wynik ich weryfikacji, w tym pojedynczy mismatch, zapisano w §4.3. Są to przypięte, jawne manifesty wejściowe, a nie odwołanie do ruchomego katalogu bez identyfikacji bajtów.

**Końcowa rekomendacja pozostaje jedna: rozstrzygnąć L_V-STATIC z §6.** Równolegle znany kontrprzykład do nieograniczonego nonce musi pozostać jawną granicą deklaracji o wdrożeniu; nie wolno go usunąć przez zmianę nazwy profilu.
