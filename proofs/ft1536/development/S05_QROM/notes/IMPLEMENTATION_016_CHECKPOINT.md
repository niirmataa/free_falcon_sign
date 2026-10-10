# S05 — IMPLEMENTATION_016: kod, pełne prawa i konkretne AC

**PARTIAL_PROOF / WARUNKOWY / NOT_REVIEWED.** Praca10–11 października2026.
Baza `efce319823364df27ca2053478a1f6959f47e924`.
Commit źródeł: `a6f179a3cda533391696ba51d108907021e65fcb`.
Klasy: obowiązki Q-SAMPLER i osobno Q-RESC; model niezależnych uczciwych
bitów. Nie dodano założenia kryptograficznego ani deklaracji QROM.

## Co rzeczywiście wykazano

Istnieje **wykonywalny referencyjny `ActualTables016.actualSampler`**
na ustalonej taśmie bitów, z rzeczywistymi publicznymi literałami tablic.
Kernel dowodzi dla niego **J≪P dla każdego publicznego h**, każdego stanu,
wiadomości i nonce. Nie potrzeba do tego(M) ani H≥991. Każdy wynik ma Q<B
i emisję signed16; J(c,none)=0, natomiast wszystkie modelowane uczciwe
porażki pozostają w P.

Kernel wyprowadza pełne prawa z kodu: surowa propozycja, cap80 i zero,
iloczyn1536 par, norm gate, cap196 i świeży sześcian, następnie syndrom
oraz emisja. Prawo pełnego programu nie jest przyjęte jako przesłanka.
Prawa capu obejmują też cap0 i zerową masę akceptacji.

Od niżej nazwanych lokalnych pól i dokładnego(M)015 kernel wyprowadza
`J≤(1+2^-60)J⁰`, następnie **ΣJ²/P≤1+2^-47**. Kod ignoruje kontekst;
publiczne initial daje ten sam wynik, a certyfikat obejmuje wszystkie stany.
`ActualInterface016.key_law_if_local_leaves` zachowuje jeden i ten sam
μ_H pod jawnym pokryciem jego nośnika. Nie rekonstruuje historii kwantowej.

**96 sprawdzonych eksportów w17 modułach**, dodatkowo3 kernelowe twierdzenia
negatywnej kontroli świeżości fallbacku.13 modułów tablic zawiera odtwarzalne
literały; nie liczymy ich jako nowych twierdzeń analitycznych.

## Cztery pola, których instancji nadal nie mamy

Niech p_T będzie prawem pojedynczej surowej propozycji z1024 bitów,
r_T=p_T(none), g dokładnym prawem pary Gaussa na pełnym boxie,
a U prawem świeżego sześcianu. Wymagane pola to:

| Pole | Dokładny obowiązek | Status |
|---|---|---|
| PairLeaves.rejection | r_T≤7/16 | Dokładna akceptacja policzona ponownie w Sage; kernelowe powiązanie bitów/modulo/CDF/liczności OPEN |
| PairLeaves.raw | p_T(some b)≤(1−r_T)(1+2^-100)g(b), każde b | Rygorystyczny margines numeryczny; kernelowy most od tablic/zaokrągleń do Gaussa OPEN |
| PairLeaves.zero_mass | g(0,0)≥2^-23 | Wsparcie balls dla stałego normalizatora; instancja kernelowa OPEN |
| CubeLeaf | U(z)≤2^4630 G_B(z), każde z | Kod i normę sześcianu sprawdzono; pełna instancja gęstości/normalizatora OPEN |

Wszystkie są **obowiązkami dowodowymi**, nie założeniami kryptograficznymi.
Nie zadeklarowano wartości `PairLeaves ActualTables016.tables` ani `CubeLeaf`.
Gotowy konsument tych pól nie jest gotową instancją małego momentu.
Globalny ogon G(Q≥B)≤2^-24 wyprowadzono z już używanego(M), więc nie jest
piątym nowym założeniem.

## Ponowne użycie ROM i zakres implementacji

Reużyto MathSign.cap, istniejących twierdzeń o dodatnich uczciwych atomach,
uniform_equiv/uniform_joint, dokładnego iloczynu RawProductLaw i obliczalnego
PolynomialReference.multiply z dowodem zgodności z mulRq. Docelowy pełny
moment i rachunek jednego prawa kluczy pochodzą z015/011.

To referencja Lean z ustalonymi slotami taśmy. CDF przeszukuje liniowo;
Sage007 używa bisect. Mnożenie referencyjne oblicza współczynniki przez
osobne podwójne sumy. Nie dowiedziono identyczności całego runtime Python/C
ani kosztu zoptymalizowanego kodu. Sampler nie używa sekretnej bazy,
idealnej eksponenty runtime ani odczytu kwantowego logu.

Kernelowe liczby **logicznych pozycji/slotów**:

- taśma:24 662 538 240 bitów;
- sloty propozycji par:24 084 480;
- oddzielny sześcian:30 720 bitów.

Nie są to jeszcze granice liczby faktycznie wykonanych wywołań funkcji,
odczytów, operacji, pamięci lub prekomputacji. Referencja funkcyjna może
ponownie obliczać współrzędne. **Machine bit-cost certificate=false.**
Czasy kompilacji w receipcie również nie są kosztem samplera.

## Sprawdzenia i zachowane ograniczenia

- Świeża closure:17 modułów dowodowych i13 modułów danych, **64.756s**,
  zero błędów/ostrzeżeń.74 wcześniejsze moduły projektu użyto z pinami;
  nie uruchamiano cudzych workerów ani pełnego replayu ROM.
- 96 audytów aksjomatów: tylko propext/Classical.choice/Quot.sound lub brak
  aksjomatów. Finalne i świeże logi zgodne bajtowo. Osobna kontrola ma3
  analogicznie czyste dowody.
- Sage: ponowne dokładne liczenie akceptacji przez liczności i konwolucję,
 48 pełnych praw cap/fallback, próby cap0 i akceptacji0/1.
- Oddzielny parser odczytał **wszystkie92 162 liczby** wygenerowanego CDF
 i progów oraz kolejność362 chunków; zgodność z przypiętymi danymi.
- Generator daje13 modułów, łącznie4 502 546 bajtów źródeł. Generator,
 wejście i hashe są w `LARGE_ARTIFACTS_016.json`; duże literały poza Git.
- Balls512 potwierdzają cztery lokalne marginesy, używając jawnie
 odziedziczonego przedziału normalizatora007. To wsparcie numeryczne.
- Natywny LaTeX: success, bez napraw. Dokument ma pełne przesłanki dla
 czytelnika bez repo. Kontrola była samoprzeglądem autora, nie review.

Zachowane niewygodne wyniki:

1. Próba `zeta^196*2^4630<2^-70` dla zeta=65/2^30 była fałszywa.
   Kernel dowodzi właściwego przedziału **(2^-70,2^-69)** i nadal
   końcowego budżetu1+2^-60. Nie jest to błąd samplera ani jego dolna granica.
2. Fallback zależny od odrzuconej monety nie ma prawa świeżego fallbacku.
   Dla próby akceptującej przy b=1 i zwracającej1−b po odrzuceniu,
   prawdopodobieństwo wyniku1 wynosi1; dla świeżego niezależnego bitu3/4.
   Dowód kernelowy i kompletna enumeracja2/4 przypadków. Wcześniejszy
   komentarz pomijał dopełnienie bitu; poprawkę i wcześniejszą wersję zachowano.
3. Zachowano nieudane elaboracje, w tym przepełnienia stosu/pamięci pod
   limitami, konflikt reprezentacji Fintype i nieprawidłowe przepisywanie
   zależnego DecidablePred. Błędne logi z sorryAx nie są dowodami.
4. Próba Sage002 przeszła rachunek, ale nie serializację Sage Integer.
   Poprawiono jawny zapis int; żadnego wcześniejszego wyniku nie nadpisano.

Pełna historia:65 runów Lean i7 runów Sage w
`IMPLEMENTATION_016_ATTEMPTS.json`. Piny i koszty:
`IMPLEMENTATION_016_RECEIPT.json`, `IMPLEMENTATION_016_INPUTS.json`.

## Mapa murów i następny duży pakiet017

| Obowiązek | Stan po016 |
|---|---|
| Wykonywalna referencja na publicznych bitach/tablicach | KERNEL code + literal instance |
| Pełne prawo cap80/zero,1536 par, cap196/świeży sześcian | KERNEL z kodu |
| J≪P dla wszystkich h | KERNEL dla konkretnej referencji |
| Mały pełny moment | KERNEL pod(M) i czterema jawnymi polami; instancje pól OPEN |
| Operacyjny koszt/źródłowa zgodność zoptymalizowanego samplera | Q-RESC/Q-BIND OPEN |
| Emitted KeyGen→właściwe h,μ_H i kanoniczne H≥991 | OPEN; nie zastępuje go konstruktor OnKeys |
| Rzeczywiste Sign/PRG i mechanizmy kwantowe | OPEN; brak deklaracji bezpieczeństwa |
| Stare h=0/Dyadic/all-h mały moment | Statusy zachowane, bez awansu |

017 ma domknąć lokalny problem numeryczno-analityczny:

1. Kernelowe liczenie słów modulo i przedziałów CDF, powiązane z konkretnymi
   tablicami; połączyć dokładną konwolucję z prawem p_T.
2. Kernelowe nierówności zaokrągleń W/V i punktowa granica L-RAW.
3. Stały normalizator pojedynczej pary oraz pełna gęstość sześcianu.
4. Dostarczyć faktyczne PairLeaves/CubeLeaf, dopiero wtedy zastosować gotowy
   konsument015/016 bez tych pustych pól. Koszt maszyny prowadzić osobno.

To otwarta kontynuacja z konkretnymi twierdzeniami do wykonania, nie wynik
niemożliwości ani zakończenie całego programu QROM. Osiągnięciem016 jest
formalny kod i transport jego pełnego prawa; najbliższa luka jest teraz
lokalna, z wyszczególnionymi polami i przypiętym wsparciem numerycznym.

Piny zamknięcia: receipt SHA256 `b4093d3baf38ba51c85251c1fe4573ff336110a38969640fae77f1d557cb6cb6`;
wejścia SHA256 `80e002c4a13469c7ec9c9a112a9db56d17d572d1192cbe0896a16093491a4e93`.
Źródła i zamknięcie zapisano lokalnie na main, bez push; zakres wyłącznie S05.
