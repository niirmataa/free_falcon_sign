# GPT-ASTRA — L_V: od akceptacji bajtów do krótkiego świadka

Data zlecenia: 2026-09-19. Autor projektu: Niirmata.
Kontynuacja po `L_NTT_PROVED_FOR_PINNED_MODEL`.

## 0. Cel i warunek końca

Domknij pozostały most **L_V dla przypiętego kandydata L_RHO**: rzeczywiste
dekodowanie, centrowanie C, dokładność normy, ścisły próg i ich kompozycję
z ukończonym L_NTT. Wynikiem ma być źródłowo związana implikacja od akceptacji
Verify do zdefiniowanego, kongruentnego i krótkiego ustalonego Ext0, albo
precyzyjny wynik częściowy/kontrprzykład. Wykonaj zadanie do raportu i freeze.

Kontynuuj w tej samej rozmowie Astry. Zachowaj użyteczny kontekst i konsumuj
domknięte twierdzenia, zamiast ponownie dowodzić forward/inverse NTT.
Sam brak nowego kontrprzykładu nie jest dodatnim rozstrzygnięciem L_V.

## 1. Korzenie i tożsamość wejść

```text
REPO = /home/footfalcon/free_falcon_sign
ARCH = REPO/proofs/ft1536
PREV = ARCH/stages/FT1536_L_NTT_FORWARD_RUN_001
RHO = ARCH/stages/FT1536_L_RHO_RUN_001
OLD = ARCH/stages/FT1536_LV_STATIC_RUN_001
W = ARCH/work/FT1536_L_V_BRIDGE_RUN_001
TASK = /home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_L_V_BRIDGE_2026-09-19.md
```

Wersjonowana kopia TASK jest w ARCH/documents/. Baza checkpointu:
`71bbb358ec59f0e5912b6c324332c1253cfcc7a2` na lokalnym main.
Przeczytaj REPO/AGENTS.md i lokalny W/AGENTS.md. Historyczne AGENTS w
archiwach opisują dawne wykonania; nie aktywują ponownie tamtych zadań.

Sprawdź te piny przed kopiowaniem i obliczeniami:

| Wejście | SHA-256 |
|---|---|
| PREV/REPORT.md | `ff172360348004527b7ef2a68c3f70967463619f039145d856f1969d69b866eb` |
| PREV/OUTPUTS.sha256 | `32147f114b448a1e1c2659b45ed3e69bfac02c44164ac380001df39c98fb498e` |
| PREV/CLAIM.md | `1c678a241df99c4127228e4149bef1c6a40d994d42fcbe54e8fdfc40c342e59e` |
| PREV/formal/Complete.lean | `67b8fd4c52dfe47cd8ed91a87ff8d1e66fdf6cad0811a881ce643ba8849e2fc4` |
| PREV/formal/Product.lean | `28d37d8cf99d2a09dbd18af3e0be3c5f7b99d4b40ea764d68e29a957176e4906` |
| PREV/formal/Rho.lean | `3fc6f1106bde82d3c5657da11e2c2a781486163491adf5617e6d39db43f15fd2` |
| PREV/SOURCE_MODEL_BINDING.md | `2365680a7cf0a7c9efd3d0b116b39571bc98408fd20bca9815cd4e6704202535` |
| PREV/source/falcon-vrfy.c | `3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42` |
| PREV/source/falcon-enc.c | `0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05` |
| PREV/source/internal.h | `512629d3b79fa5bd74131ed2ecde06e1d157f5ac58db3f758db96b19131f1ba5` |
| RHO/CANDIDATE.sha256 | `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a` |
| RHO/REPORT.md | `ca0e3fb23542656b16c61495506db5956b3d6043d5ef26fd56396502c0b444e3` |
| RHO/OUTPUTS.sha256 | `d5cabfdaf69f080bf31b9e1903bacc4a319f87cd38cb4b643ff5e98f1240f687` |
| OLD/REPORT.md | `c19cda58e928d585bed8c64745ea165b4dce0fbabee2e51edb40d6392a825cfd` |
| OLD/OUTPUTS.sha256 | `0223beb04591bd45908c1b167f4bda89b8666ef40901bde7d502f10088c23f87` |

Manifest RHO/CANDIDATE.sha256 ma ścieżki względem katalogu 17 źródeł.
Sprawdź wszystkie PREV/source/ wobec niego. Do W/source/ kopiuj dokładnie
te bajty. `Extra/c`, inny roboczy checkout i oryginalny S17 nie zastępują
badanej wersji. Oryginalny S17 ma znany kontrprzykład do L_V; nie zmieniaj
znaczenia historycznego wyniku przez późniejsze twierdzenie o kandydacie.

Pozostałe konsumowane pliki wiąż z odpowiednimi OUTPUTS. Potrzebne wejścia:

- PREV/RESULT.json, OBLIGATIONS.json, REUSED_RESULTS.md, formalne zależności
  Complete/Product/Rho i odziedziczony C/model binding;
- RHO/RESULT.json i potrzebne publiczne fixtures/ oraz regression receipts;
- OLD/artifacts/decoder_controls.json, norm_boundaries.json, witness.bin,
  witness_c.txt, publiczne inputs/key/ i potrzebny harness/model/checker;
- ARCH/documents/FT1536_PROMPT_LV_STATIC_2026-09-17.md oraz
  FT1536_CEL_DOWODU_I_PIERWSZY_LEMAT_2026-09-17.md tylko jako kontekst definicji;
- ARCH/documents/FT1536_ZASADA_CZYSTEGO_LOGU_LEAN_2026-09-18.md.

Nie traktuj dawnych testów dekodera ani normy jako istniejących uniwersalnych
dowodów. PREV/formal/Rho.lean jest już czystą, ponownie sprawdzoną adaptacją.

## 2. Dokładna teza

```text
N=1536, q=18433, ternary=1, logn=10
Phi=X^1536-X^768+1
B=2093922385, sigma_sign=768
Q0(a)=sum(i=0..767, a_i^2+a_i*a_(i+768)+a_(i+768)^2)
Q(a,b)=Q0(a)+Q0(b)
center_q(t)=u if u<=9216, else u-q, where u=t mod q in [0,q-1]
Ext0(h,c,b)=(center_q(c-h*s(b)), s(b)).
```

Iloczyn ekstraktora to niezależny iloczyn współczynnikowy modulo Phi i q;
`s(b)` oznacza signed int16 faktycznie zapisane przez dekoder.
Nie zastępuj go centered reprezentantem lub unsigned słowem sprzed NTT.

`V_CAND(h,c,b)` obejmuje rzeczywiste kontrole nagłówka podpisu, wybór NONE
albo STATIC, dekodowanie, kontrolę zwróconej długości i cały raw Verify dla
przypiętego źródła. Kontekst klucza jest poprawnie przygotowany przez loader
(NTT i tomonty). HashToPoint zastępuje tutaj jawne canonical c, zgodnie z
dziedziną L_V; nie jest to zmiana badanego dekodera ani raw Verify.

Cel podstawowy zachowuje kwantyfikator po h ze successful-output support
historycznego KeyGen, wszystkich canonical c i wszystkich skończonych b
reprezentowalnych w modelu API. Zalecana mocniejsza teza obejmuje **wszystkie
canonical h,c**, z wykazanym związkiem h z loaderem. Nie potrzeba wówczas
nowego argumentu o rozkładzie KeyGen.

```text
V_CAND(h,c,b)=1 =>
  s(b) i Ext0 są zdefiniowane,
  z1+h*z2=c modulo (q,Phi),
  Q(z1,z2)<B, gdzie (z1,z2)=Ext0(h,c,b).
```

Domena zakłada legalne obiekty pamięci, zakresy długości i lifecycle API
zgodne z przypiętym modelem. Nie dodawaj przesłanek o poprawnym kodowaniu b,
uczciwym Sign, centered s(b), poprawności parsera/normy ani zakończonej
akceptacji innego modelu. Te fakty mają wynikać z źródłowego `V_CAND=1`.
Nie ograniczaj b do 2049 bajtów. Profil uczciwego Sign pozostaje COMP_STATIC,
lecz lemat obejmuje obie gałęzie obsługiwane przez Verify.

Próg `2137772974` odnaleziony w dawnych raportach dotyczy innego wariantu
sigma=776. W tym zadaniu B i sigma pozostają powyższymi przypiętymi stałymi.

## 3. Kolejność pracy i obowiązki

### A. Domknięty rdzeń do ponownego użycia

Konsumuj pełne typy i dowody z PREV:

```text
L_NTT_rho:
  CanonVec h -> (forall i, InInt16(s_i)) -> CanonVec c ->
  pipelineC h (rhoVec s) c = (product h s, subtract(product h s)c).
```

Zachowaj definicje product, remMonomial, pipelineC i rhoVec. Dziedziczysz
canonical wynik przed centrowaniem i poprawne przygotowanie H. Do raw Verify
trafia przygotowane H, nie surowy wielomian h. Ponownie sprawdź konsumowane
źródła Lean, bez wykorzystania starego cache jako zastępstwa dowodu.

### B. CENTER_C i SIGN_BRIDGE

Źródło: falcon-vrfy.c:1429–1435. Rozlicz dokładnie uint32 odejmowanie,
shift, maskę, int32 cast i końcowy int16 store dla każdego d w [0,18432].
Wykaż, że zapisane signed wartości to center_q(d), w [-9216,9216], oraz
brak signed overflow i utraty wartości przy tym końcowym zawężeniu.

Uwzględnij sekwencyjne stores i reinterpretację x przez odpowiadający typ
signed: po przetworzeniu prefiksu pozostałe odczyty x[u] nadal pochodzą z
canonical wyniku pipeline. Podaj uzasadnienie dostępu przez int16_t do
bufora uint16_t w wybranym modelu C, wraz z wyrównaniem i granicami.

C liczy center_q(h*s-c), a Ext0 używa center_q(c-h*s). Wykorzystaj lub
dowiedź antysymetrię centrowania dla nieparzystego q i Q0(-a)=Q0(a).
Negacja obejmuje cały pierwszy wektor; nie zmienia samego znaku jednego
czynnika składnika mieszanego A2. Wyprowadź kongruencję ekstraktora.

### C. NORM64_EXACT i STRICT_B

Źródło: falcon-enc.c:597–666 i internal.h:159–163. Aktywna gałąź ternary
używa **int64_t s**, dwóch pętli i porównań signed. Nie importuj modelu
32-bitowej saturacji z gałęzi binary.

Dla dwóch dowolnych wektorów signed int16 wykaż:

1. Każdy iloczyn jest wykonywany w int32 i mieści się w tym typie; następnie
   trafia do akumulatora int64. Nie zmieniaj kolejności promocji C.
2. Każdy prefiks obu pętli mieści się w int64. Wystarczający konserwatywny
   bound sumy modułów składników to 3*N*2^30=4947802324992<2^63; uzasadnij
   go dla rzeczywistej liczby operacji i także ujemnych cross terms.
3. Końcowy akumulator jest dokładnie Q(s1,s2), z offsetem 768.
4. Dla logn=10 wybór makra daje dokładnie B=2093922385 i return jest
   równoważny Q(s1,s2)<B. Równość z B oznacza odrzucenie.

Złóż B i C z L_NTT_rho najpierw w uniwersalny raw-verifier soundness theorem
dla canonical h,c i dowolnego signed s. Jest to użyteczny samodzielny
checkpoint, ale bez D–E nie nazywaj go pełnym bajtowym L_V.

### D. DECODE_BYTES i VERIFY_GUARDS

Źródła: falcon-enc.c:401–560 i falcon-vrfy.c:1446–1517.
Modeluj rzeczywisty parser jako funkcję słów/maszynę stanów, nie jako
założenie „akceptacja dostarcza prawidłowy wektor”. Wykaż inicjalizację
wszystkich 1536 wyników oraz związek modelu z kontrolami źródła.

- NONE: rozlicz big-endian, rozszerzenie znaku, uint32 wrap i test centered
  domain; zwracane 3072 bajty i zewnętrzne porównanie długości.
- STATIC: j=8, db/db_len, sign, lo, **unsigned 32-bit ne**, maski i stores.
  Dla k zer unary licznik ma wartość k mod 2^32. Test ne>255 występuje
  dopiero po terminatorze. Nie zastępuj go testem k>255 ani wczesnym capem.
- Rozlicz implementacyjnie określone signed narrowing GCC dla magnitude
  32768..65535, promocję przy negacji i ponowny zapis do int16. Opisz jawnie
  konwencję modelu; nie nazywaj jej przenośną gwarancją wszystkich C99.
- Zachowaj dopuszczane negative zero, faktyczne padding checks, zwracane v
  i odrzucenie trailing bytes podpisu. Nie zakładaj kanoniczności kodowania,
  która nie wynika ze źródła.
- Uwzględnij len<=2, reserved bit, zgodność logn/ternary, reserved compression,
  dodatnią długość przekazaną dekoderowi i rozróżnienie return 0 od sukcesu.
- Dla wszystkich legalnych długości uzasadnij granice odczytów/zapisów,
  shift counts, liczniki i zakończenie. Długi unary rozlicz indukcyjnie,
  z matematycznym miernikiem pozostających bitów; nie materializuj setek MiB
  tylko po to, aby zilustrować wrap. Skończone testy nie zastępują tego kroku.

### E. PK_PREPARATION i FINAL_COMPOSITION

Źródła: falcon-enc.c:216–250 i falcon-vrfy.c:1284–1352.
Zwiąż zaakceptowany kontekst FT1536 z canonical h i rzeczywistym
NTT/tomonty. Publiczny decoder zwraca **len**, nie u; nie przypisuj mu
odrzucania wszystkich końcowych bajtów tylko na podstawie porównania
zwróconej długości w loaderze. Do L_V potrzeba poprawnej interpretacji h,
a nie silniejszej, nieobecnej w kodzie kanoniczności całego PK.

Złóż parser/guards, przygotowanie klucza, L_NTT_rho, CENTER_C, NORM64_EXACT
i STRICT_B. Końcowy formalny lemat ma dotyczyć źródłowo związanego V_CAND,
a nie definicji Verify skonstruowanej wprost jako Q(Ext0)<B.

Pokaż `#check @...`, pełny typ/term (`#print`) i `#print axioms` dla raw
i końcowego L_V. Sprawdź także implicit/typeclass arguments. Pozostawiona
przesłanka poprawności parsera, centrowania, normy lub ich translacji oznacza
wynik częściowy. Jawny model platformy i legalność obiektów są zachowanym
zakresem, nie twierdzeniem o zweryfikowanym kompilatorze C.

## 4. Kontrole związania modeli ze źródłami

Dobierz małe kontrole do nowych obowiązków, z niezmienionym C oraz dokładnym
Sage/oracle niezależnym od badanego NTT. W szczególności:

- center dla 0, 9216, 9217, 18432; unsigned mask i signed reprezentacje;
- norm dla krańców int16, ujemnego cross term i par z offsetem 768;
- istniejące rzeczywiste wektory B-1/B/B+1 z OLD/artifacts/norm_boundaries.json,
  sprawdzone na nowym kandydacie; nie podstawiaj B jako sztucznego akumulatora;
- legalne STATIC poza centered domain, skrajne narrowing, negative zero,
  ne=255/256, truncation/padding/trailing bytes, obie kompresje i nagłówki;
- symboliczny wrap długiego unary oraz rzeczywiste małe granice;
- istniejący publiczny świadek OLD: kandydat ma go odrzucać, jak w L_RHO.

Nowe checkery sprawdź rzeczywistymi mutacjami istotnych reguł, np. granicy
centrowania, offsetu/cross term, < versus <= lub pominięcia signed narrowing,
oraz dodatnią kontrolą no-op. Sam wykaz nazw odrzuconych trybów nie wystarcza.
W kontrolach natywnych użyj ograniczonego normal i ASan/UBSan. Nie powtarzaj
pełnej kampanii NTT ani enumeracji rho, jeśli nie zmieniły się ich wejścia.

Harness może podać jawne c zamiast HashToPoint. Każda instrumentacja ma mieć
czytelny, odwracalny diff i binding; decyzję Verify potwierdź też bez obserwatora.

## 5. Środowisko i zakres zapisu

W jest jedynym katalogiem zapisu Astry. Jest przygotowany z AGENTS.md;
przed dalszym zapisem sprawdź jego zawartość i brak innego wykonawcy.
Archiwa, oryginalny S17, Extra/c i ukończone katalogi robocze są read-only.
Nie zmieniaj źródeł kandydata ani odziedziczonych definicji, by uzyskać PASS.

Ustaw rzeczywisty sandbox z zapisem wyłącznie pod W. Sprawdź tę konfigurację;
AGENTS sam nie egzekwuje uprawnień. HOME/TMPDIR/DOT_SAGE/LEAN_PATH, cache,
olean i binaria kieruj do W. Nie uruchamiaj runnerów w zamrożonych katalogach.

Używaj istniejących Lean 4.34.0/Std, Sage 10.9 (`sage plik.py ...`) i GCC
14.2.0/C99/Linux x86_64 LP64. Lean: `-j1 -M2048`, skończone limity czasu
per job, address space 8 GiB lub jawnie uzasadniony sprawdzony limit.
Nowe/edytowane Lean muszą mieć czyste pełne logi, bez wyciszania ostrzeżeń,
sorry/admit/native_decide i lokalnych aksjomatów pożądanego wniosku.
Adaptacja historycznej kopii wymaga zachowania oryginału, diffu, hashy
i ponownego sprawdzenia. Nie instaluj bibliotek ani narzędzi.

Bez nowych kluczy, sekretów, seedów, .private/private_extraction, sieci
badawczej i innych agentów. Dozwolone są przypięte publiczne PK/h oraz
syntetyczne payloady. Zapisuj komendy, cwd, wersje, limity, exit codes,
stdout/stderr i hashe. Zachowuj nieudane próby i rozróżniaj timeout od
kontrprzykładu. Nie zostawiaj starego procesu podczas nowej próby.

## 6. Raport i odtwarzalność

Zapisz: REPORT.md, RESULT.json, CLAIM.md, OBLIGATIONS.json, REUSED_RESULTS.md,
SOURCE_MODEL_BINDING.md, źródła formalne i kontrolne, INPUTS.sha256,
TOOLCHAIN.txt, COMMANDS.log, REPLAY.md, OUTPUT_SCOPE.md i OUTPUTS.sha256.

Macierz obowiązków ma rozdzielać odziedziczone RHO/NTT od CENTER_C,
SIGN_BRIDGE, NORM64_EXACT, STRICT_B, DECODE_NONE, DECODE_STATIC,
VERIFY_GUARDS, PK_PREPARATION i FINAL_COMPOSITION. Przy wyniku częściowym
podaj konkretne pozostałe typy lematów oraz brakujący source binding.

Zachowaj standardowy interfejs odtwarzania:

```text
python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256
```

Przed wykonaniem sprawdź zewnętrzny pin, wszystkich członków OUTPUTS i
bezpieczne ścieżki. DEST jest nowym podkatalogiem tmp świeżej kopii. Replay
ma odtwarzać wyniki tylko z zarchiwizowanych wejść i przypiętego toolchainu,
bez starych olean/binariów/cache i bez zależności od Dokumenty/H.

Przed freeze wolno wykonać jawny rehearsal z osobną kotwicą. Jego
`artifacts/fresh_replay.json` ma listę matches (względne path i sha256),
wszystkie te pliki i receipt należą do OUTPUTS. Nie twórz cyklu hashowania.
Po freeze wykonaj standardowy replay z finalnym, zewnętrznie przekazanym
pinem; zapisze DEST/REPLAY_RESULT.json, FRESH_REPLAY_PASS i tę samą listę
matches bez zmiany zamrożonego pakietu. Nie myl pinu rehearsal z OUTPUTS.

## 7. Status, granice i przekazanie

- `L_V_PROVED_FOR_PINNED_MODEL`: cały bajtowy cel z §2 domknięty dla kandydata,
  z jawnym modelem C i bez otwartych przesłanek mostu. Wtedy
  `full_L_V_proved=true`, jawnie przypisane do source SHA kandydata.
- `PARTIAL_PROOF`: np. raw verifier domknięty, lecz pozostaje parser; wtedy
  `full_L_V_proved=false` i dokładna lista luk.
- `COUNTEREXAMPLE_REQUIRED_DOMAIN`: pełne publiczne (h,c,b), rzeczywista
  akceptacja i naruszenie tezy dla required support. Użyj istniejącego h*,
  jeżeli potrzebujesz udokumentowanego successful-KeyGen witness.
- `COUNTEREXAMPLE_EXTENDED_DOMAIN`: świadek tylko dla mocniejszej domeny
  canonical h, bez wykazanego support; nie nazywaj go obaleniem required-domain L_V.
- `EXECUTION_BLOCKED`: konkretna przeszkoda techniczna, bez fałszywego PASS.

`source_integrated=false` i `owner_accepted=false` we wszystkich wariantach.
Nawet pełne L_V nie jest twierdzeniem o samplerze, EUF-CMA, trudności MT-ISIS,
rozkładzie kluczy lub preimage HashToPoint. Zachowaj obronione zakresy
historycznych T2C3 i T5 oraz kontrprzykład dla oryginalnego S17.

Kontekst dalszej redukcji: wcześniejsza tabela strat przez TV jest wynikiem
konserwatywnej techniki, nie granicą bezpieczeństwa konstrukcji. Rozważany
transfer przez warunkowe chi-square i zdarzenie sukcesu ma własne obowiązki
po historiach, abortach, serializacji i programowaniu wyroczni. Nie traktuj
domknięcia L_V jako ich dowodu ani warunkowego przykładu poprawy o 52 bity
jako wyniku dla całego schematu. W tym zadaniu wykonujesz most weryfikatora.

Po freeze podaj werdykt, rzeczywistą tezę, pozostałe obowiązki, ścieżkę
W/REPORT.md oraz SHA-256 REPORT i OUTPUTS. Prowadzący sesję sprawdzi pakiet,
zaimportuje go z `--replay standard` i wykona osobny commit na main.
Astra nie operuje na indeksie Git ani nie rozpoczyna następnego zadania.
