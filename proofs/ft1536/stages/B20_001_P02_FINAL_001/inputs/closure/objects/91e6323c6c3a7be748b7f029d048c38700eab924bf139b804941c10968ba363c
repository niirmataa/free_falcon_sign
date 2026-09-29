# M0 — dokładna rodzina gier

Identyfikator: FT1536-M0-r40-static4096-parametric-v1. Stałe i piny:
PROFILE.json. Bitowe ciągi oznaczają tu skończone ciągi bajtów; każdy bajt
ma256 wartości. R_q jest reprezentowane przez1536 canonical współczynników.

## 1. Otoczenie E, stan i częściowe wykonania

E jest **ustalonym przed eksperymentem, publicznym, obliczalnym planem usług**,
indeksowanym przez fazę, numer zapytania i publiczne miejsce wywołania:
alokacje caller/context/tmp/sk i żądania32 bajtów entropy. Plan zwraca
success albo failure i nie zależy od sekretów, wartości seedów ani przyszłych
coins. Przy success entropy zwraca świeże, niezależne U({0,1}^256); przy failure
nie dostarcza bajtów. Alokacja success daje poprawnie wyrównany, legalny obiekt
żądanego rozmiaru; stack i wskaźniki/lifecycle są legalne. E0=plan all-success
jest wyróżnioną instancją, nie tezą, że rzeczywisty OS nigdy nie zawodzi.
Twierdzenie docelowe jest parametryczne również w zadanym E. Ten sam E jest
używany we wszystkich porównywanych grach; implementacja/przeniesienie
innego środowiska wymaga osobnego bindingu.

To jawny model usług, nie uruchomienie/odczyt prywatnego seedu. Dla source
KeyGen i Sign ekspansja jest rzeczywistym deterministycznym SHAKE/Falcon PRNG.
Bufory są wyłącznie wewnętrzne; źródłowe null/return0/error branches zachowano.

Inner rejection loops nie mają limitu. Semantyka operacyjna dopuszcza brak
powrotu: gra wtedy nie produkuje końcowego fałszerstwa i nie wygrywa; nie
zwraca dodatkowego timeout-bot do A. Obowiązek zdefiniowania arytmetyki na
wszystkich potrzebnych osiągalnych ścieżkach, w szczególności przed floor/s+z,
jest otwartym H3. W modelu proof tracing nieokreślona operacja ma wewnętrzny
znacznik STUCK, nie źródłowy return0. Wygrana wymaga zwykłego ukończonego
przebiegu. Instancja twierdzenia o programie wymaga wyeliminowania STUCK lub
jawnego konserwatywnego bad-event comparison; nie relabeluje się go po cichu
jako dopuszczonego abortu. M0 definiuje obiekt i ten obowiązek, nie dowodzi go.

## 2. Jeden KeyGen i K_seed[E]

1. Utwórz jeden falcon_keygen_new(10,1), z jego scratch. Po sukcesie odczytaj
   API max_privkey_size=12289 i max_pubkey_size=2881 i zarezerwuj caller buffers.
2. Wykonaj dokładnie jeden falcon_keygen_make(...,FALCON_COMP_STATIC,...).
   Początkowe seed32 jest uniform na sukcesie usługi E; kod rng_ready
   wstrzykuje je do capacity512 SHAKE (SHAKE-256).
3. Capped outer KeyGen ma co najwyżej3000000 prób. f,g są w pełnym trybie
   ternary MODE1 przez2-bit rejection, potem source resultant/norm/GS/public/
   solve/leaf gates. Inner rejection jest uncapped. Końcowe kodowanie sk
   i pk należy do TEGO wywołania; ich błąd oznacza niepowodzenie.
4. E_K = zdarzenie skończonego zwrotu sukcesu całej procedury, łącznie
   z usługami i obiema serializacjami. p_K=Pr_E[E_K]. Jeśli p_K=0, gra
   uncond ma advantage0, a warunkowe K_seed nie jest definiowane.

Dla p_K>0:

```
K_seed[E] = Law((sk_bytes,pk_bytes,decoded secret/public objects) | E_K).
```

Jedna para jest losowana raz i wspólna dla CAŁEGO eksperymentu. A otrzymuje
wyłącznie pk_bytes; nie otrzymuje seedu, sk, powodów odrzuceń ani numeru
udanej próby. K_seed ma skończone źródło seedu i rzeczywistą ekspansję.
K_iid jest innym prawem (iid infinite tape), a raw uniform ternary proposal
jest jeszcze innym prawem przed gates. Żadnej równości tych praw nie zakłada się.

Gra uncond najpierw robi ten pojedynczy call i przy niepowodzeniu kończy
bez wygranej. Dla tej samej dalszej gry i tego samego E:

`Adv_uncond = Pr(E_K and Win) = p_K * Pr(Win | E_K) = p_K*Adv_cond`.

To dokładna definicja warunkowego prawdopodobieństwa, nie założenie o małym
abort. Warunkowanie/p_K dotyczy wspólnego klucza RAZ. Nie warunkuje się
klucza ponownie na sukcesie Sign ani na powodzeniu loadera.

## 3. Oracle H i wspólny transkrypt

Pierwszy cel: **klasyczny direct-output ROM** H:Bytes*→R_q. Tablica T jest
pusta; każda nowa nazwa x dostaje niezależne uniform1536 współczynników
mod18433. Powtórzenia zwracają tę samą wartość. A może pytać o dowolne x.
Sign i finalne Verify używają TEJ SAMEJ T pod nazwą r||m.
Q_H liczy jawne zapytania A (także powtórzone), Q_s liczy wszystkie Sign calls.
Wewnętrzne wywołania H Sign i finalnego Verify są osobno ujęte w kosztach.

Publiczny transkrypt: pk, wszystkie wejścia i odpowiedzi H/Sign oraz
końcowe (m*,r*,b*). Historia lematu może dodatkowo zawierać wspólny latent
klucz i stan symulatora; nie czyni ich to obserwacją A. Wskaż zawsze,
czy kwantyfikator jest po pełnej czy publicznej historii.

## 4. Oracle Sign(m)

Najpierw zwiększ licznik i wpisz CAŁE m do SeenSign, także gdy query później
abortuje. Zapytania są sekwencyjne; m jest ustalone przed start i przed
poznaniem r. Streaming jest tylko transportem tego m, bez adaptacyjnego
dopisania po publikacji nonce. Nie ma pośredniej odpowiedzi z r ani innych
zapytań A w trakcie jednego Sign. Następnie:

1. Nowy falcon_sign context według E; ustaw dokładnie te same wyemitowane
   sk_bytes. Błąd alokacji/loadera daje PRE_ABORT. Brak dodatkowego wyboru klucza.
2. Wywołaj falcon_sign_start z lokalnym buforem40. W świeżym kontekście
   rng_ready pobiera32 uniform bytes albo fail. Fail daje PRE_ABORT. Na sukcesie
   rzeczywista root ekspansja pobiera40 bajtów r. Nie udostępnia się A
   set_seed ani start_external_nonce.
3. Wstrzyknij m przez update (jedno lub więcej chunków, konkatenacja to m).
   W grze ROM c=H(r||m) zastępuje wyłącznie H2P. W programie rzeczywistym
   SHAKE-sc/H2P to osobny obiekt przyszłego hopu, nie idealne H.
4. generate(...,4096,FALCON_COMP_STATIC): sprawdzenie klucza/rng/bufora,
   następnie do16 prób w source order. Każda inicjuje type0→PRNG_CHACHA20
   z kolejnych56 bajtów tego samego root SHAKE, zeruje fault na tę próbę,
   wykonuje do_sign, następnie fault check, następnie dokładny norm check.
   Fault kończy call. Norm reject przechodzi do następnej próby; wyczerpanie16
   kończy call. Scalar rejection wewnątrz do_sign jest bez capu.
5. W ternary do_sign oba fpr_rint→int16 casts są PRZED normą. Ich wpływ na
   rozkład/relację jest otwartym M3; nie zmienia się ich definicją gry.
6. Po norm acceptance jest JEDNO encode_small(s2,capacity4095). Failure0
   kończy call, nie ponawia próby. M0 dowodzi, że przy legalnym buforze,
   tym profilu i rzeczywistym norm acceptance brak miejsca już nie powoduje
   tego failure. Header0xAA dopisuje source dopiero po sukcesie kodera.

Odpowiedzi to dokładnie:

- PRE_ABORT: brak nonce; przyczyny przed jego utworzeniem pozostają ukryte;
- (r,POST_ABORT): nonce już istnieje, generate zwrócił0;
- (r,b): generate zwrócił dodatnią długość, dokładnie tyle bajtów b.

Nie ujawnia się przyczyny fault/retry/encoding, liczby prób ani częściowego
bufora. Dodatniego wyniku Sign NIE zamienia się w bot, nawet jeśli przyszły
test Verify by go odrzucił. Poprawność wszystkich takich wyjść jest osobnym
obowiązkiem M3. Nie dodano post-sign Verify do źródła.

Obserwacja jest funkcyjna, bez zegara, czasu odpowiedzi, liczby instrukcji,
cache/EM itp. t ogranicza własną pracę A, nie daje oracle pomiaru czasu.
To nie jest twierdzenie o ochronie przed wszystkimi kanałami bocznymi.

## 5. Verify, transport i wygrana

Normatywne wejście Verify to (m,r,b). Najpierw wrapper wymaga |r|=40;
inaczej odrzuca PRZED biblioteką. Dalej przygotowuje kontekst z tym pk,
używa c=H(r||m) i dokładnego kandydata, wraz z NONE/STATIC, paddingiem,
całkowitą długością payloadu i signed narrowing. Tylko return1 akceptuje.
Return0,−1,−2 są odrzuceniem; błędy usług podczas przygotowania Verify też
nie dają wygranej. Bufory i lifecycle są legalne w E.

Transport podpisu: r[40]||b z zewnętrznie znaną długością rekordu. Parser
bierze pierwsze40 bajtów i cały pozostały payload; nie stosuje cap4096 do
przeciwnika. Dla interfejsu z oddzielnymi polami sprawdza rlen==40.
Gdy sam transport jest jedną tablicą, inny zamysł nadawcy o granicy r/b
nie zmienia jednoznacznego parsowania pierwszych40 bajtów.

A kończy pojedynczym (m*,r*,b*). Win zachodzi wtedy i tylko wtedy, gdy:
`m* not in SeenSign`, `|r*|=40`, input lengths/objects legalne i Verify=1.
To ordinary EUF-CMA, nie strong: nowe b dla już zapytanego m nie wygrywa.
Także wiadomość query zakończonego PRE/POST_ABORT jest nieswieża.

Framing.framing_injective dowodzi injektywności (r,m)↦r||m przy |r|=40.
Nie dowodzi injektywności H. r40=u||a, r39=u, m'=a||m daje identyczne surowe
wejście H, lecz r39 nie spełnia nowego kontraktu i jest odrzucone. Stare
external-rlen API/CLI nie staje się tym wrapperem przez zmianę dokumentacji.

## 6. Obiekty referencyjne używane tylko w ledgerze

D(z)∝exp(−Q(z)/(2*768²)) na Z^3072, D^B=D|{Q<B},
A_h(z)=z1+h*z2, P_h^B=Law(A_h(Z)), Z←D^B. Dla P_h^B(c)>0:
K_h,c=D^B|{A_h(Z)=c}; dla pustego supportu jawny POST_ABORT kernel.
Nie usuwa się go z samego małego L2 image boundu.

Wspólny idealny byte map T4096: jeżeli z2 jest signed16, koduj z2 STATIC
bez centrowania do legalnej capacity4096; inaczej jawny idealny POST_ABORT.
Nie testuj Verify i nie przepisuj niepoprawnego wyemitowanego payloadu na bot.
Różnice względem SOURCE casts-before-norm i loader/fault outcomes są otwartym
pre-cast/byte coupling M3. Centered-box H6P nie jest tu cicho założony.
G16 próbuje do16 coset-Gaussian próbek i strict norm test, zachowując terminal
abort. Gacc używa K_h,c (lub pustego-support bot). R i S z image hop stosują
identyczny T4096 i pełny history-dependent wrapper; wspólność tych jąder
jako instancji FT1536 jest otwartym M5, nie skutkiem ich nazw.

Real SHAKE/ChaCha nie stały się ROM lub iid przez tę definicję. Root936 bytes,
exact PRNG56, bitowy XOF/H2P, budgets i ich założenia są oddzielnymi wierszami
HOP_LEDGER. Nie ogłoszono dowodu source Sign law, jego terminacji ani EUF-CMA.
