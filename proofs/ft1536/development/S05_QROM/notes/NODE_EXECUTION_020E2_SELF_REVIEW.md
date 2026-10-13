# Kontrola autora — bezpośrednie wykonanie węzłów020E2

2026-10-13. Baza21aabee4945d62da958c511a216f4d09ace2ee50.
Własna kontrola autora; NOT_REVIEWED, bez niezależnego odbioru Daybreak.
Werdykt dla wykonania w zadeklarowanym modelu: **proved as written**.
Pełny Q-RESC i bezpieczeństwo QROM pozostają OPEN.

## Dokładny zakres

`NodeExecute020E2.correct` dowodzi równości wyniku nowego wykonawcy ze
`ControlStack020E.execute` dla każdego fuel, wejścia i stanu, pod jawnymi
HeapValid oraz Related. Obejmuje również wyczerpanie fuel. Related jest
relacją dowodową; ramki runtime zawierają tylko adres oraz, dla kontynuacji
pętli, licznik Fin(2^511). Wykonawca nie otrzymuje Meaning ani Code.

`NodeProgram020E2.built_correct` wypełnia HeapValid i początkową relację
przez wcześniejszy dowód parsera, dla legalnego Code, dostatecznej pojemności
i fuel. `actual_correct` wypełnia te przesłanki dla oryginalnego programu,
areny877 oraz jawnego controlLimit=1106642201817. To bound przejść sterowania,
nie pełny czas. `on_actual_arena` dotyczy również już sparsowanej tablicy.

`every_state` zachowuje dokładne wyjście019 oraz zastaną flagę fault dla
każdego h, każdej taśmy i każdego stanu. `public_initial` daje brak fault
z publicznego initial. NodeDriver zachowuje jawne kopie wejścia, reset i
transfer020E; `run_eq` wyklucza jego Option fallback na każdej taśmie.

## Sprawdzone granice

- Odczyt tylko dla pc<used; sentinel capacity nie jest aktywnym węzłem.
- Rekurencja wyrażenia korzysta ze ścisłej wcześniejszości aktywnych dzieci.
  Fuel=used wystarcza; to dowód zakończenia, nie kosztu stosu rekurencji.
- Kolejność binary(left=second,right=first), branch(no,yes,guard) oraz
  loop(body,guard) wynika z rzeczywistego assemble i kształtu banku.
- Każdy atom jest związany z atomRun. Niepoprawny adres odczytu/zapisu
  zachowuje oryginalną semantykę fail; store/emit nie obliczają wartości
  po błędnym adresie. Dowód nie zakłada braku błędów dla dowolnego wejścia.
- Pętla z cap=0 kończy się bez ewaluacji guarda; guard=0 nie uruchamia body.
  Kontynuacja zmniejsza licznik i odwołuje się do tej samej oryginalnej pętli.
  Pozostały licznik≤oryginalny limit jest sprawdzany i dowodzony przez Rel.
- next_tail i related_append zachowują całą resztę stosu; poprawność nie
  ogranicza się do samotnej instrukcji ani happy-path.
- Bank kodu jest niemodyfikowanym argumentem evaluatora/dispatch/execute.
  Pętla nie dopisuje węzła Code. Nowa lista ramek nadal wymaga realizacji
  w skończonym banku; tego nie utożsamiamy z brakiem jakiejkolwiek alokacji.
- Actual nie woła dekodera odbudowującego Code ani starego interpretera.
  Parser korzysta z kanonicznego obrazu oryginalnej składni. Producent tego
  obrazu pozostaje częścią otwartego rachunku inicjalizacji.
- Publiczny driver zawsze resetuje do initial. Przenosi dokładnie to samo
  pełne prawo, łącznie z zakodowanymi porażkami samplera. Błędy interpretera
  nie są utożsamiane z tymi porażkami: dla konkretnego programu są wykluczone.
- NodeCertificate zachowuje J≪P dla każdego h, a moment≤1+2^-47 wyłącznie
  pod tym samym MassCondition014.MassCondition. same_key_law wymaga tego
  samego mu po obu stronach, Covered oraz M na pokrytej dziedzinie.
  Nie dodano przesłanki historii kwantowych zapytań ani nie wzmocniono M.

## Status modeli i obowiązków

Word512, idealna skończona taśma, funkcjonalne banki oraz lista ramek
są modelem. Wierność wykonania i instancje są obowiązkami dowodowymi
Q-RESC/Q-SAMPLER. A-QMT i primitive-bound Q-PRG są nadal założeniami
kryptograficznymi, nie zastępnikami brakujących dowodów źródłowych.
Certyfikat pozostaje w przypiętym środowisku legacy. Nie połączono go
z naprawioną grą wariantu A ani źródłowym prawem rzeczywistego Sign.

## Co nie zostało wykazane

Skończony bank ramek i wartości, jego pojemność i nadpisywanie martwych
slotów; realizacja rekurencji; pełny koszt instrukcji/dispatch/arytmetyki;
produkcja obrazu, bity, inicjalizacja, scratch i cała pamięć szczytowa.
Nie przenosimy≤32 z rozmiaru wyrażenia na głębokość ramek.5264 słowa nadal
opisują wyłącznie trwałą arenę parsera. Koszt kompilacji Lean w receipcie
nie jest kosztem samplera ani reduktora.

Źródłowe pokrycie(M) dla całego prawa KeyGen, source harmonic/Schur,
real Sign/PRG, nowa gra wariantu A oraz log/reprogramowanie, embedding,
kolizje i kompozycja QROM pozostają oddzielnymi obowiązkami. Wynik nie
upoważnia jeszcze do deklaracji bezpieczeństwa FT1536 w QROM.

## Zachowane niepowodzenia

Wszystkie próby mają osobne snapshoty i receipty. Odrzucono niezamknięte
cele, pomyłki elaboracji, zastrzeżone słowo repeat i ostrzeżenia deprecacji.
Preflight next001 nie uruchomił Lean przy niedostatecznym zapasie pamięci;
zapisano osobny receipt. Lżejszy runner zachowuje piny i ograniczenia,
z mniejszym limitem Lean4GiB/AS8GiB i progiem5GiB MemAvailable.

Driver001 przekroczył głębokość redukcji; driver002/003 limit pamięci przy
konwersji zawierającej zamknięty program. Driver004 używa ogólnego observe,
sprawdzonego przed podstawieniem programu. Zachowuje tę samą tezę przy
limicie4GiB. Nie są to kontrprzykłady matematyczne; żaden odrzucony artefakt
nie jest zależnością wyniku. Szczegółowe klasy, eksporty, aksjomaty i piny
zawierają CHECKS, CERTIFICATE_CLASSES_020E2 oraz manifesty.
