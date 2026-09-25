# Sigma_math w tym pakiecie

**Wariant: E0, coefficient-valued finite-box G16, klasyczny direct-output ROM.**
To jawna węższa instancja matematyczna. Nie identyfikuję jej z source Sign,
nieograniczonym coset-Gaussian G16 M0 ani z modelem usług ogólnego E.

## Obiekty i Verify

`Geometry.Vec = Fin 768 → ℤ×ℤ` paruje współczynniki i oraz i+768.
`block(x,y)=x²+xy+y²`, Q jest sumą bloków obu wektorów. B=2093922385;
test jest ścisły. `Relation.Rq` przechowuje 1536 współczynników w ZMod18433.
`poly` układa je w bazie potęg X; `mulRq` bierze współczynniki reszty
iloczynu modulo X^1536−X^768+1. Nie używa nieudowodnionego NTT.
`A(h,z)=reduce(z1)+mulRq(h,reduce(z2))`.

Centrowanie całkowite: `(x+9216)%18433−9216`. `reduce_center` jest dowodem
zachowania klasy modulo q. `extract(h,c,s)=(centerRq(c−h*s),s)`.
`Verify` wymaga signed16(s) oraz Q(extract)<B. Transport podpisu jest tu
**wektorem współczynników**, nie parserem NONE/STATIC. W naturalnej relacji
MT `ShortPreimage` nie ma ograniczenia signed16; jest A(z)=c i Q(z)<B.
Nie formalizowano izomorfizmu tej reprezentacji z abstrakcyjnym ilorazem
pierścienia ani z kodem mnożenia. Definicja iloczynu przez resztę jest jawna.

## Prawo pojedynczej próby i całego Sign

BoxVec koduje współczynniki −65535,…,65535. `all_coord_bounds` i
`full_norm_support_in_box` wykazują, że żaden całkowity wektor Q<B nie
wypada poza ten box. Box **nie jest** centered box ±q/2.

`g(z)=exp(−Q(z)/(2*768²))` na BoxPair. Dla ustalonego h,c:

1. jeśli `sum_{A_h(z)=c} g(z)>0`, proposal jest dokładnie znormalizowanym
   g na tym skończonym włóknie;
2. jeśli suma jest zerowa, trial zawsze daje wewnętrzny norm-reject;
3. proposal z Q<B daje `some z`; pozostały daje `none` (wewnętrzny retry);
4. `cap trial 16` losuje IID z TEGO SAMEGO trial przy stałym c. Pierwsze
   `some z` kończy retry; po 16 rejectach wynik to exhaustion;
5. dopiero potem Emit: jeśli z2 signed16, wyemituj dokładnie z2; w przeciwnym
   razie POST_ABORT. Nie centrować z2; nie wykonać dodatkowego Verify;
   encoding/Emit failure nie ponawia próby.

Przy f=trial(none) pełne prawo cap(n) ma masę f^n przy exhaustion i
`(sum i<n f^i)*trial(some z)` przy z. Jest znormalizowane także dla n=0,
f=0, f=1. Jeśli trial(some z)=(1−f)L(z), prawo ma postać
`p_n L+(1−p_n)δ_bot`, p_n=1−f^n. `cap_mixture` dowodzi tej równości mas,
`success_vs_capped_second` dowodzi drugiego momentu 1/p dla p>0,
a p=0 z dodatnią masą L daje chi²=∞. To twierdzenie o jawnych IID próbach,
nie założenie IID dla implementacji FT1536.

`SigmaMath.sign` używa jednej ustalonej wiadomości m, uniform nonce
`Fin(2^320)` i body dla H(r,m). E0 nie ma PRE_ABORT. Szersza funkcja
`MathSign.observe` oraz kod `simSign` zawierają publiczną gałąź PRE_ABORT.
Obserwacja ma typ `Option (Nonce × Option Sig)`:
`none` = PRE_ABORT, `some(r,none)` = POST_ABORT, `some(r,some s)` = sukces.
Norm-reject i licznik prób nie są obserwacjami. Miara skończona nie dopuszcza
STUCK/nonreturn; ich wyeliminowanie w M0 jest osobnym obowiązkiem, a nie
przemianowaniem na abort. Nonce jako Fin odpowiada 320 bitom specyfikacji;
kodowanie tej liczby do 40 bajtów pozostaje interfejsem.

## Publiczny joint law i kod

`boundedGaussian` ma wagi g(z)*1[Q<B]. Jego normalizer jest ściśle dodatni
(wektor zerowy), law jest znormalizowany, a support to dokładnie Q<B na
BoxPair. `publicJoint` jest pushforward przez `(A_h(z),Emit(z))`.
`freshHonest` to **U_Rq(c)*signBody(h,c)(o)**; nie zastępuję K przez samo L.

To są specyfikacje miar nieobliczalne w Lean. Samo ich istnienie nie
dostarcza efektywnego samplera ani metody wyliczania normalizera.
`PublicSampler.run` jest odrębnym interfejsem kodu na skończonej uniform
taśmie, z argumentami tylko h/public_history/m/r/coins. `simSign` naprawdę
używa tego interfejsu: najpierw SeenSign, potem publiczny prefix, sprawdzenie
konfliktu nazwy, jeden call samplera, programowanie i pełna odpowiedź.
Nie przyjmuje sekretu ani listy przyszłych celów. Konflikt kończy grę bez
wygranej, nie powtarza nonce. Zewnętrzny `none` wyniku simSign jest stopem
gry, odmiennym od obserwowalnego PRE_ABORT.

Nie dostarczono instancji `run` realizującej publicJoint lub bliski mu law
z certyfikowanym kosztem. Nie dowiedziono też małych e_img/e_sign ani
identyfikacji conditional accepted law finite-box G16 z warunkowym D^B po
Emit. Te przesłanki pozostają OPEN, nie mają wartości zero.

## Klucze, historie, cel bezpieczeństwa

`muH` jest wyłącznie marginalem parametrycznego wspólnego `muKey(sk,h)`;
nie jest uniform. Brakuje instancjacji jako K_seed[E]|success KeyGen i
semantycznego włączenia jednorazowego losowania klucza do gry. Rachunek
`p_K*Adv_cond` ma osobny przypadek p_K=0; nie warunkujemy każdego Sign.

Hist(n+1)=Hist(n)×obserwacja zachowuje CAŁĄ historię. Kernel przejścia może
zależeć dowolnie od tej historii. Dowód adaptacyjny mnoży drugie momenty
warunkowych likelihood ratios, nie zakłada niezależności odpowiedzi.
Warunki są obecnie wymagane dla wszystkich historii danego typu, co jest
silniejsze niż tylko osiągalne historie. Nie ma jednak jeszcze formalnego
identyfikowania tych kernels z interaktywną grą A/ROM/Sign.

`ROM.State` rozróżnia Sign-origin od konkretnego challenge index. Good,
Unique i reachable_invariants zachowują własność tabeli i licznik celów;
cached H nie zużywa celu, final fresh H zużywa najwyżej jeden dodatkowy.
SeenSign obejmuje aborty, a świeże m* wyklucza Sign-origin finalnego wpisu.
Ekstrakcja nie zgaduje celu i dopuszcza powtórzenia/zera jego wartości.
Tablica w kodzie używa nazw par (nonce,message); osobny lemat framingu
dowodzi injektywności konkatenacji dla równych długości nonce. Pełny front-end
H:Bytes* (w tym zbyt krótkie nazwy) nie został jeszcze dołączony.

Cel projektu pozostaje ordinary EUF-CMA, nie SUF-CMA/QROM. W tym pakiecie
nie ma pełnego interpretera przeciwnika ani związanego z nim twierdzenia
`euf_cma_to_mt_isis`. Jest formalny bound dla skończonych praw transkryptów.
