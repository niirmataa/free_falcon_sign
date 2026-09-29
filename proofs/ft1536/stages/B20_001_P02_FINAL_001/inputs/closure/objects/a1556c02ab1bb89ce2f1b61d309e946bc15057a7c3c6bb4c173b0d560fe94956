# GPT-ASTRA — M0: dokładny profil, gra i parametryczny ledger redukcji

Data: 2026-09-19. Autor projektu: Niirmata.
Etap po ukończonym L_V, przed następnym dowodem źródłowym H3.

## 0. Cel i decyzje właściciela

Przygotuj spójny, źródłowo związany kontrakt M0 oraz jego sprawdzalny pakiet.
Ma on jednoznacznie określać obiekt dalszego twierdzenia: wersję źródeł,
prawo klucza, orakle, obserwacje, zasoby, pary porównywanych praw i otwarte
obowiązki. Wykonaj pracę do raportu, freeze i standardowego replayu.

**Właściciel wybrał w rozmowie:**

1. **4096 bajtów pojemności payloadu uczciwego Sign**, z jego nagłówkiem;
   nonce 40 bajtów jest osobno. Przesyła się faktyczną długość, bez paddingu
   do 4096. Jest to parametr docelowego wywołania/callera, nie nowa stała
   starego tool.c i nie ograniczenie payloadów fałszerza.
2. **Główny cel to bound parametryczny** zależny od Q_s, Q_H, czasu, pamięci
   i długości danych. Nie wybieraj samodzielnie konkretnego profilu zasobów
   ani nie deklaruj osiągniętego poziomu 128/256 bitów.

Pozostały ustalony profil: FT1536 full ternary secret, uczciwy COMP_STATIC,
strict Q<B, pojedynczy klucz z rzeczywistego successful-KeyGen law,
nonce r[40], klasyczny EUF-CMA w direct-output ROM jako pierwszy cel.
Zweryfikowany kandydat L_RHO jest przedmiotem dalszego twierdzenia.
Rozdziel zdefiniowanie kontraktu od udowodnienia całej redukcji i od
wdrożenia nowego opakowania w głównych źródłach.

## 1. Korzenie, źródła i piny

```text
REPO = /home/footfalcon/free_falcon_sign
ARCH = REPO/proofs/ft1536
PREV = ARCH/stages/FT1536_L_V_BRIDGE_RUN_001
RHO = ARCH/stages/FT1536_L_RHO_RUN_001
DOC = ARCH/documents
W = ARCH/work/FT1536_M0_CONTRACT_RUN_001
TASK = /home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_M0_CONTRACT_2026-09-19.md
```

Baza mapy/main: `b42a85dff3149c91fe2ecc9fc9b3fbf2d1804898`.
Kontynuuj w tej samej rozmowie Astry. Przeczytaj REPO/AGENTS.md i W/AGENTS.md.
Wersjonowana kopia TASK będzie w DOC. Historia w stages/ jest wejściem,
a nie upoważnieniem do ponownego uruchomienia dawnych zadań.

| Wejście | SHA-256 |
|---|---|
| PREV/REPORT.md | `81702fa89ee516f162a37db86e2abb03ae0bb57a49a5723ed63eab5a17a69296` |
| PREV/OUTPUTS.sha256 | `13fa5a9f706a962434c8ac479212af5ef33d91e1ececd6c948d68ed42871a74e` |
| PREV/CLAIM.md | `e10be7abe58c970bec0a97cb11de9f1c6e3ee021321dffc4111eec86fc342575` |
| PREV/formal/Norm64.lean | `d25a61941a86864cc9d34400e86d948124529b1e6765b0676c97cf41b4f92d5a` |
| PREV/formal/VerifyBytes.lean | `6c33ca86d82c72fd8421d7d52ce5e13ee6a0a2b17e767ca0c308d9a72ede28ac` |
| PREV/source/falcon-vrfy.c | `3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42` |
| PREV/source/falcon-sign.c | `eee8d7dc503e007cb76bcc157094b2a2de481075ac3f67426848f7a8cae6efd8` |
| PREV/source/falcon-enc.c | `0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05` |
| PREV/source/falcon-keygen.c | `0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf` |
| PREV/source/falcon.h | `657ad2b2d45b8932c3b9a703ac718c1f23dad78523036c1a934b8e21cf0f4519` |
| PREV/source/tool.c | `920ac2d8a96408c505670eb2f044cde763ca11945d90ec24d8c6f2a048377890` |
| PREV/source/Makefile | `25cd0345332882ccab4beea68d5139955c871499733ab9f5fa3cc8ef898d5049` |
| RHO/CANDIDATE.sha256 | `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a` |
| DOC/FT1536_MAPA_DALSZYCH_DZIALAN_PO_LV_2026-09-19.md | `b299acc13ec1bd1b2d5d9906fb403bbd9c35e8db1483eb9671247540731266a1` |
| DOC/FT1536_CEL_DOWODU_I_PIERWSZY_LEMAT_2026-09-17.md | `5b1b0e3e15f14aca63fce9007cebb36c493aa2669ca6e8ad35dccd32023ac11e` |

Sprawdź wszystkie piny i 17 plików PREV/source/ względem CANDIDATE.sha256
(jego ścieżki są względem katalogu źródeł). Potrzebne pliki przenieś do W.
Pozostałe konsumowane zależności wiąż z OUTPUTS/sidecar hashami.
Nie używaj roboczego Extra/c jako domniemanej bazy.

## 2. Kontrakt źródeł i typów

W PROFILE.json i SOURCE_MODEL_BINDING.md zapisz:

- N=1536, q=18433, Phi=X^1536-X^768+1, sigma=768, B=2093922385;
- Q0(a)=sum(i=0..767,a_i^2+a_i*a_(i+768)+a_(i+768)^2), Q=Q0+Q0;
- logn=10, ternary=1, aktywne flagi przypiętego Makefile, backend FPEMU;
- GCC14.2.0/C99/Linux x86_64 LP64 i jawne signed/unsigned conventions;
- uczciwe STATIC i oba akceptowane tryby Verify, NONE/STATIC;
- r[40], sig_capacity=4096, faktyczna zmienna długość b, transport r||b;
- 3000000 prób KeyGen i 16 prób Sign; uncapped scalar rejection loops.

Oddziel: źródła rdzenia, argumenty wywołań protokołu oraz historyczny CLI.
Stary tool.c ma sig[2049] i zmienne rlen; nie jest przez samą deklarację
nowym opakowaniem. Normatywny kontrakt ma wymuszać dokładnie 40 bajtów nonce
przed biblioteką Verify lub przez jednoznaczny parser transportu.
Ewentualny prototyp opakowania w W jest artefaktem zadania, nie integracją.

## 3. Pojemność — dowód analityczny i sprawdzenie rzeczywistego kodera

Sprawdź poniższą propozycję niezależnie; jej rachunek został wykonany w
przygotowaniu zadania, ale nie wykonano jeszcze kontroli kodera C.

Dla signed int16 s1,s2 spełniających Q(s1,s2)<B:

```text
Q0(s1)>=0, Q0(s2)<=B-1
sum_i s2_i^2 <= 2*Q0(s2)
(sum_i |s2_i|)^2 <= N*sum_i s2_i^2 <= 2*N*(B-1)
floor(sqrt(2*N*(B-1))) = 2536243
sum_i floor(|s2_i|/256) <= 9907
STATIC bits <= 10*1536 + 9907 = 25267
payload including header <= 1+ceil(25267/8) = 3160 bytes < 4096.
```

Wyprowadź długość z faktycznej pętli compress_static, z uwzględnieniem
znaku, j=8, unary terminatora, paddingu i nagłówka dodawanego przez Sign.
Bound dotyczy kodowania s2 po rzeczywistym norm acceptance, nie wszystkich
dowolnych int16 bez ograniczenia normy. Nie obejmuje nonce. Nie deklaruj,
że 3160 jest optimum. Dopuszczalny jest prostszy ścisły dowód tej samej
bezpiecznej granicy; np. integer quadratic majorant zamiast biblioteki Real.

Formalizuj nowy ograniczony argument w Lean/Std, gdzie jest to wykonalne;
nie zamieniaj brakującej części w aksjomat. W raporcie oddziel zakres dowodu
analitycznego, kernelowego i jego związania z C.

Sprawdź publiczny syntetyczny świadek długości, bez KeyGen i sekretów:

```text
s1=0
s2=(x,-x), x ma 768 współczynników:
  pierwsze 330 równe 1792, pozostałe 438 równe 1536
Q(s1,s2)=2093088768 < B
STATIC payload z nagłówkiem: 3156 bajtów.
```

Rzeczywiste falcon_is_short ma akceptować tę parę. Sprawdź
falcon_encode_small dla pomiaru długości i pojemności payloadu 2049,
3073 i 4096: pamiętaj, że sam encoder dostaje capacity-1. Przy sukcesie
sprawdź round-trip dekodera i canaries/sanitizer. Nie twierdź, że wektor
został wylosowany przez źródłowy Sign lub jest kontrprzykładem EUF-CMA.
To kontrola tezy, że mały bufor wystarcza dla wszystkich short vectors.

**Wniosek do kontraktu:** jeśli dowód i binding potwierdzą bound, przy
legalnym buforze 4096 brak miejsca nie powoduje niepowodzenia kodowania
STATIC po źródłowym norm acceptance. Pozostałe przyczyny abortów zostają.
Nie przenoś historycznego H6P wymagającego >=3073 przez samą zmianę liczby;
jego inne przesłanki i byte map nadal wymagają osobnego rozliczenia.

## 4. Dokładna gra i obserwacje

Zapisz pełną definicję w GAME.md, a nie samą nazwę EUF-CMA.

### KeyGen

Jeden świeży kontekst FT1536, bufory według max_privkey_size i max_pubkey_size,
STATIC dla klucza prywatnego, jeden capped call. Model źródła entropii ma
być jawny: 32 uniform bajty seedu i faktyczne deterministyczne rozszerzenie
wskazanego programu. Zdefiniuj E_K jako sukces całego wywołania, także kodowania,
p_K i K_seed=L(KG_seed | E_K), przy p_K>0. Wyjaśnij dokładny model otoczenia
API/entropii/alokacji oraz obserwowalne błędy; nie usuwaj ich po cichu.

Jeden wynik (sk,pk) jest wspólny dla wszystkich zapytań. Pokaż relację
Adv_uncond=p_K*Adv_cond dla eksperymentu bez wygranej po nieudanym KeyGen.
K_iid, raw ternary proposal i K_seed są różnymi prawami. Nie dodawaj
powtórnego warunkowania klucza przy każdym Sign.

### Sign

Zachowaj przyjęty wcześniej model świeżego kontekstu na zapytanie i ładowania
tego samego wyemitowanego sk; wywołania external seed/nonce nie są dostępne
przeciwnikowi poprzez to oracle. start generuje r[40], update przyjmuje m,
generate używa STATIC i sig_max_len=4096.

Opisz źródłową kolejność: nowa próba -> do_sign -> fault -> norm test ->
ewentualne retry; po norm acceptance jedno kodowanie, bez dodatkowej próby
na błąd kodowania. Rozlicz casty przed normą i faktyczne kody powrotu.

Jawnie określ odpowiedzi i obserwacje: sukces (r,b), niepowodzenie przed
utworzeniem nonce, niepowodzenie po utworzeniu nonce (r,bot).
Wewnętrzne przyczyny fault/retry/encoding mogą być etykietami ledgera,
lecz nie dodawaj przeciwnikowi informacji o przyczynie, której kontrakt
nie ujawnia. Nie ujawniaj częściowo zapisanego bufora po return 0.
Podaj, czy model obserwacji obejmuje czas; sam bound EUF-CMA nie jest
deklaracją ochrony przed wszystkimi kanałami bocznymi.

### Verify, świeżość i orakle

Docelowe Verify sprawdza framing r[40], a następnie dokładną bibliotekę
kandydata z obu dopuszczanymi kompresjami. Przyjmuje tylko return 1.
Fałszerz może podać dowolne legalne b w swoim budżecie danych, także dłuższe
niż 4096. Pojemność uczciwego Sign nie jest ograniczeniem tezy L_V.

Wygrana: świeże m*, poprawny format r*, akceptacja (r*,b*) dla m*.
Do zapytanych wiadomości wpisuj również zapytania Sign zakończone abortem.
To zwykłe EUF-CMA, nie strong EUF-CMA.

Pierwsza gra: klasyczny direct-output ROM H:{0,1}* -> R_q, świeże wartości
uniform. Sign i Verify używają H(r||m). Udowodnij injektywność kodowania
(r,m) przy stałej długości r, nie injektywność samego hasha. Zachowaj kontrolę
r40->r39: surowe r||m może zostać zachowane przez repartition, a właściwy
kontrakt ma tę zmianę odrzucić z powodu długości nonce.

Rzeczywiste SHAKE/ChaCha i bitowy XOF/H2P nie stają się przez tę definicję
idealnymi oraklami. Ich hopy wpisz jawnie do ledgera. Capacity 512 w shake_init
oznacza tutaj SHAKE-256. 56 bajtów inicjalizacji PRNG nie jest 448-bitowym
kluczem ChaCha. Zweryfikuj źródłowy budżet 40+16*56=936 bajtów nadrzędnego
SHAKE na świeże Sign i oddziel go od nieograniczonych wewnętrznych losowań.

## 5. Zasoby i naturalny problem trudności

Zdefiniuj dziedziny parametrów i mierzone jednostki:

```text
Q_s, Q_H : maksymalne liczby zapytań
t        : praca własna przeciwnika w zadanym modelu kosztu
w        : pamięć przeciwnika w zadanych jednostkach
L        : łączny budżet danych przeciwnika (dokładnie wyszczególnij składniki)
```

Wyjaśnij koszty orakli, końcowego fałszerstwa, długich payloadów, tablicy ROM
i streamowanych wiadomości. Parsing/ekstrakcja może kosztować O(|b*|), więc
nie ukrywaj dowolnie długiego unary w rzekomo stałym C_ext.

Zachowaj naturalną relację MT-ISIS_seed,rel: klucz z K_seed, indeksowane
uniform cele, świadek z1+h*z2=c modulo(q,Phi), Q(z1,z2)<B, bez centered
restriction na z2. L_V dostarcza ekstrakcji; nie dowodzi trudności tej gry.
Zachowaj rozróżnienie 1 klucza i Q_H+1 celów oraz ewentualnej późniejszej
redukcji do jednego celu. Nie licz target guessing dwa razy.

Nie podstawiaj estymatora za theorem hardness. Parametryczny cel ma
wykorzystywać jawne epsilon_MT oraz założenia prymitywów z ich zasobami.
Przybliżone scenariusze liczbowe, jeśli użyte diagnostycznie, mają być
oznaczone jako przykłady, nie wybory właściciela lub osiągnięty poziom.

Inner rejection loops i publiczny sampler wymagają budżetu analitycznego.
Jeśli wprowadzasz grę z limitem pracy, rozróżnij ją od źródła bez tego limitu
i przypisz osobny delta_budget/delta_time. Nie dodawaj takiego capu do kodu
przez definicję i nie zakładaj nieudowodnionego zakończenia wszystkich ścieżek.

## 6. Ledger metryk, błędów i zależności

HOP_LEDGER.json i czytelny HOP_LEDGER.md mają dla każdego przejścia określać:
parę praw/gier, kierunek, metrykę, prawo klucza, kwantyfikator po historii,
conditioning, koszt per call i transkryptowy, obserwowalne aborty, koszt
obliczeń, dokładne wejścia i status każdej przesłanki.

Uwzględnij co najmniej: framing, randomness hop, H3 range/arithmetic, H1R,
pełną geometrię/pre-cast, serializację, norm/retry, image R5T, publiczny sampler,
programowanie ROM, L_V extraction, MT-ISIS i końcową kompozycję.
Rozróżnij fakt dowiedziony, użyteczny wynik warunkowy, założenie kryptograficzne
i własny otwarty obowiązek. M0 nie zamyka H3/H6/R5T/ROM przez wpis w tabeli.

Dla image hop zachowaj właściwy kierunek z aktualnej mapy:

```text
R = idealna gra z uniform celami; S = reverse sampling
chi2(S_i(.|tau)||R_i(.|tau))<=e
Delta=(1+e)^n-1
p=R(win), r=S(win)
p <= [2r+Delta+sqrt(Delta^2+4*Delta*r*(1-r))]/[2*(1+Delta)].
```

Powiązanie pełnych jąder po historii jest osobnym obowiązkiem M5.
Nie podmieniaj go na odwrotny D2 lub globalny high-order Rényi. H1R direct-TV
o innych prawach i brakujących atomach nie dziedziczy tego lematu bez dowodu.
Nie przenoś składników przez mnożniki albo nieliniową Phi_Delta bez uzasadnienia.
Ten sam abort nie może wystąpić w dwóch epsilon pod innymi nazwami.

Eksportuj dokładny typ docelowej parametrycznej redukcji oraz otwarte
przesłanki jej przyszłego dowodu, bez deklarowania gotowego RHS dla schematu.
Przy symbolicznym celu nie potrzeba wymyślonego t=2^128 ani lambda=128.
Zachowaj granice fixed-key T2C3, successful-key T5 i niespójnego starego freeze
R5T wskazanego w mapie. QROM pozostaje osobnym etapem.

## 7. Kontrole i wykonanie

- Wszystkie nowe obliczenia, pliki, cache i narzędzia pomocnicze tylko w W.
  Sprawdź rzeczywisty sandbox i cwd. Source/ zachowaj bajtowo, read-only.
- Kontrole M0 dotyczą nowych twierdzeń długości, framingu i spójności
  kontraktu. Nie ponawiaj całego L_NTT/L_V ani starej kampanii samplera.
- Używaj dostępnych GCC14.2/C99, Sage10.9 (`sage plik.py`) i Lean4.34/Std.
  Nowe i edytowane Lean: czyste pełne logi, pełne typy/axioms, bez
  sorry/admit/native_decide/aksjomatu oczekiwanego wyniku.
- Zapisz źródłowe spans i hashe, komendy, limity, exit codes i strumienie.
  Native checks normal/ASan/UBSan prowadź na publicznych syntetycznych
  wektorach. No-op musi przejść; odrzucenia mają wynikać z rzeczywistej
  zmiany długości/framingu lub kontraktu, a nie z etykiety mutacji.
- Bez KeyGen, nowych kluczy, odczytu sekretów/seedów, .private/private_extraction,
  instalacji, sieci badawczej i innych agentów. Seed w definicji gry jest
  obiektem matematycznym, nie poleceniem odczytania prywatnego wejścia.
- Nie modyfikuj archiwów, Extra/c, starego CLI, historycznych manifestów
  ani indeksu Git. H3 jest dalszą pracą; nie uruchamiaj jej automatycznie.

## 8. Wyjścia i standardowy replay

Wymagane: REPORT.md, RESULT.json, PROFILE.json, DECISIONS.md, GAME.md,
RESOURCE_MODEL.md, HOP_LEDGER.json/.md, SOURCE_MODEL_BINDING.md,
CAPACITY.md z dokładnym dowodem i kontrolą C, REUSED_RESULTS.md,
źródła/formalne certyfikaty/checkery, INPUTS.sha256, TOOLCHAIN.txt,
COMMANDS.log, REPLAY.md, OUTPUT_SCOPE.md, OUTPUTS.sha256.

Przygotuj standardowy interfejs:

```text
python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256
```

Pin OUTPUTS i wszystkie członki muszą zostać sprawdzone przed wykonaniem.
Nowy DEST pod tmp kopii, własny sandbox/cache, brak zależności od oryginalnych
Dokumenty/H. Odtwarzaj kontrole i certyfikaty M0 z przypiętych lokalnych wejść.
Dokumentów specyfikacji nie przedstawiaj jako automatycznie odkrytych dowodów
tylko dlatego, że skopiowano je ze zgodnym hashem.

Przed freeze dopuszczalny jawny rehearsal z osobną kotwicą. Zamrożony
artifacts/fresh_replay.json zawiera matches(path,sha256), związane z OUTPUTS.
Po freeze standardowy replay z finalnym zewnętrznym pinem zapisuje
DEST/REPLAY_RESULT.json i FRESH_REPLAY_PASS, bez nadpisywania checkpointu
i bez cyklu hashowania. Kopiowanie starego cache/binarium nie jest replayem.

## 9. Status i przekazanie

- `M0_CONTRACT_DEFINED_FOR_PINNED_CANDIDATE`: profil, gra, obserwacje, zasoby
  i ledger są spójne; wybrane decyzje zachowane; status boundu pojemności
  i jego C bindingu jest jawny; otwarte przyszłe obowiązki są nazwane.
- `PARTIAL_CONTRACT`: pozostała konkretna niejednoznaczność lub luka w
  wymaganej kontroli. Wskaż dokładny brak, nie maskuj go dowolnym wyborem.
- `EXECUTION_BLOCKED`: konkretna przeszkoda techniczna.

Oddzielnie zapisz status dowodu pojemności. Nie nazywaj zdefiniowanego M0
dowodem bezpieczeństwa; `security_reduction_proved=false`.
`source_integrated=false`, `protocol_wrapper_integrated=false`,
`owner_accepted=false` dotyczą wyniku wykonawcy i integracji. Nie cofają
dwóch jawnych decyzji właściciela z §0 ani ukończonego L_V kandydata.

Po freeze podaj REPORT/OUTPUTS SHA-256, rzeczywisty zakres M0, status
nowych lematów i dokładny gotowy interfejs dla przyszłego H3.
Prowadzący sesję wykona odbiór, import i osobny commit. Astra kończy na M0.
