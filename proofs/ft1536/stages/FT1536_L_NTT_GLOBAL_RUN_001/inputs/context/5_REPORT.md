# FT1536 L_NTT — wynik częściowy z certyfikatami

**Rozstrzygnięcie: `PARTIAL_PROOF`.**

Uzyskano uniwersalne kontrakty prymitywów słowowych, certyfikat pierwszości,
source-bound certyfikat dynamicznych tablic logn=10, lokalne tożsamości
bloków forward/inverse oraz poprawnie sprawdzoną **warunkową** kompozycję.
Nie zamknięto globalnej instancjacji funkcji in-place C jako transformacji
wielomianowej dla wszystkich h,r,c. Nie znaleziono kontrprzykładu w
wykonanych kontrolach, ale ich sukces nie zastępuje tego dowodu.

```text
source_integrated = false
owner_accepted = false
full_L_V_proved = false
```

## 1. Przedmiot i granica zadania

Pracowano wyłącznie w:

```text
/home/footfalcon/Dokumenty/FT1536_L_NTT_RUN_001
```

Nowe zlecenie ma SHA-256
`773591f1f5f9f838c6a0f6dccd56c5bf477234aee75d1009ff4bda8a7e45c4d3`.
Przeczytano lokalny i nadrzędny AGENTS oraz wskazane zakończone wyniki L_RHO.
Narzędzia pozwoliły rzeczywiście ograniczyć zapis do nowego W; nie było
technicznej blokady wymagającej zmiany okna klienta.

Badano **kandydata po L_RHO**, nie pierwotny S17 ani warning-clean checkout:

```text
source/falcon-vrfy.c:
3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42

manifest 17 plików kandydata:
2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a
```

`INPUTS.sha256` i `inputs/provenance.json` identyfikują 31 skonsumowanych
oryginałów i kopii. Wszystkie 17 plików `source/` zachowano bajtowo.
L_RHO z wynikiem `L_RHO_PROVED_FOR_PINNED_MODEL` jest przypiętym wejściem.
Nie wykonywano ponownie całego odbioru L_RHO/Blue i nie uruchamiano ich
runnerów ani finalizerów.

Parametry i kwantyfikatory są w `CLAIM.md`: N=1536, q=18433,
Phi=X^1536-X^768+1, każdy canonical h,r,c, model GCC 14.2.0/C99/Linux x86_64
LP64 i legalne bufory. Cel to canonical p=h*r modPhi,q i d=h*r-c modPhi,q,
przy zdefiniowanym wykonaniu i poprawnych zakresach. H po tomonty ma znaczenie
Montgomery wartości transformacji h; p,d mają znaczenie ordinary coefficients.
Nie przeniesiono wyniku na inną platformę ani na pełny parser/Verify/EUF-CMA.

## 2. Co rzeczywiście sprawdził kernel

Łącznie sprawdzono **186 deklaracji**. Przypięte pliki końcowe:

| Plik | Deklaracje | SHA-256 |
|---|---:|---|
| `formal/Words.lean` | 14 | `4630b8b49186ccbf49a074e7e684e8125bbf14e6aadfc5443be8e2cbedb7f52b` |
| `formal/Linear.lean` | 7 | `60b843d305f264d47b9411f479d83f647e747b9e9bd7763fa43f27d198336dd5` |
| `formal/Tables.lean` | 160 | `ee668bf1b63a8cb9a3192b39fee68347ed67481d4c73e948372ffc1db203821e` |
| `formal/Composition.lean` | 5 | `0ee19f21c9acdb4361d862905d7ab090ed3bb904066a22059cf7688948a34772` |

Wszystkie importują Std, bez mathlib i bez instalacji. Dla każdej deklaracji
wykonano `#print axioms`. W zależnościach występują wyłącznie standardowe
`propext`, `Classical.choice`, `Quot.sound`; nie ma `sorry`, `admit`,
lokalnego aksjomatu wniosku, `unsafe` ani `native_decide` w końcowych plikach.
Początkowe nieudane szkice zachowano osobno jako historię i nie konsumowano
ich tymczasowych metavariables/sorryAx.

Liczba deklaracji nie jest werdyktem o całym L_NTT. O ich znaczeniu decydują
tezy i bindingi opisane niżej oraz w `DERIVATION.md`.

### 2.1. Słowa

`Words.lean` dowodzi dla całych właściwych dziedzin canonical operands:
poprawności i zakresów mq_add, mq_sub, pomocniczego mq_rshift1, Montgomery
multiplication i square. Jawnie modeluje uint32 wrap, low16 i korektę bitu
znaku słowa unsigned. Dla iloczynu z=x*y:

```text
0 <= z <= 339738624
0 <= k <= 65535
0 <= w=k*q <= 1208006655
0 <= z+w <= 1547745279 < 2^31
0 <= (z+w)/65536 <= 23616 < 2q
```

`z*q0i` może przekroczyć 2^32 i w C zawija się. Kernel dowodzi zachowania
właściwych niskich 16 bitów; nie zakłada braku tego wrap. Sprawdza również
podzielność z+kq przez 65536 i końcową kongruencję oraz canonical range.

Komentarz źródłowy o z<q i granicy 29-bitowej nie stanowi przesłanki i nie
jest poprawnym uzasadnieniem. Właściwa granica sumy jest 31-bitowa i nadal
wystarcza. Nie ujawnia to kontrprzykładu do kodu; naprawiono argument,
nie źródło.

### 2.2. Stałe, dzielenie i generator

Sprawdzono `q*18431+1=65536*5184`, Rt=10237, R2t=4564 i Rinv=5184.
Pierwszość q ma kompletny certyfikat: brak dzielników 2..135 oraz uniwersalny
argument o faktorach z 136^2>q, nie tylko wywołanie `is_prime`.

Rzeczywisty łańcuch y0..y18 odczytano z instrukcji mq_div_18433. Ma końcowy
wykładnik 18431. **60** rekordów sprawdzonych w kernelu opisuje wszystkie
operacje trzech potrzebnych stałych wywołań, wraz z niezerowością i
tożsamościami odwrotności:

```text
mq_div_18433(4564,1874) = 7714
mq_div_18433(4564,8479) = 3318
mq_div_18433(10237,1536) = 6187
```

Dla logn=10 start 25 jest wprowadzany do Montgomery i raz podnoszony do
kwadratu. Ordinary g=625, jego word to 1874. Wartości istotne dla dowodu:

```text
a = gm[1]/R_M = 14649
omega = a^2 = 14648
(2*a-1)^(-1) = 2523
ni = 6187,  ni/R_M = 18421 = 1536^(-1) mod q.
```

Nie użyto statycznych tablic gałęzi logn<=9. W aktywnej ścieżce oba NTT
wywołują mq_mkgm3, a inverse scaling wywołuje mq_div_18433. Obserwator
potwierdził tę ścieżkę również wewnątrz rzeczywistych przebiegów.

`Tables.lean` sprawdza następujące pełne rodziny rekordów:

| Rodzina | Liczba | Znaczenie |
|---|---:|---|
| units | 1024 | canonical gm/igm; pary odwrotne dla indeksów >=1 |
| sequence | 256 | postęp liści x/g4/g2 i odwrotności, adresy rev10 |
| parents | 511 | źródłowe cube/square przy tworzeniu niższych poziomów |
| tree | 510 | właściwe relacje parzystych i nieparzystych dzieci |
| rows2 | 1022 | tożsamości macierzy stopnia 2, także pierwszego/szczególnego bloku |
| rows3 | 1536 | tożsamości wszystkich wierszy bloków stopnia 3 |
| chain | 60 | konkretne operacje potrzebnych wywołań mq_div |

Sprawdzono rev10 dla całej potrzebnej dziedziny Fin512, w tym zakres i
inwolucję u↦rev10(2u). Ustalony przebieg generatora inicjalizuje dokładnie
0..1023. **Nie eksportowano ani nie haszowano niezainicjalizowanej reszty
1024..2047** buforów gm/igm. `igm[0]` traktowano jako specjalną odwrotność
2a-1, nie jako zwykły odpowiednik gm[0].

Sage porównał cały prefiks C z niezależnymi zamkniętymi formułami potęg i
sprawdził 1536 różnych pierwiastków Phi. Potęgi dotyczące rzędu 25 są
zapisane jako kontrole diagnostyczne; zamknięte lokalne kontrakty konsumują
sprawdzone konkretne relacje pierwiastków i jednostek, nie ukryte założenie
„25 ma właściwy rząd”.

### 2.3. Lokalne bloki a globalny algorytm

`Linear.lean` ma symboliczne tezy dla dowolnych wejściowych wartości bloków:
złożenie wierszy stopnia 2/3 odpowiada mnożeniu ich współczynników.
Związanie z literalnymi certyfikatami daje lokalne równania inverse*forward
równe 2*Id lub 3*Id. Sprawdzono również końcowy czynnik 1536.

Te wyniki nie są samymi testami pojedynczych wektorów. Nie stanowią jednak
jeszcze globalnego source-level twierdzenia o wszystkich stanach buforów
po kolejnych pętlach. Nie wywnioskowano uniwersalnego iloczynu z samego
roundtrip ani z kontroli wektorów bazowych.

## 3. Dokładna luka do pełnego L_NTT

Pozostają trzy powiązane pozycje macierzy `OBLIGATIONS.json`:

1. **FORWARD_GLOBAL:** dla każdego canonical v udowodnić, że wynik rzeczywistego
   forward w pozycji 3i+j jest `sum_k v[k]*(alpha_i*omega^j)^k modq`, z
   dokładnie tą kolejnością etykiet i stanów source buffers.
2. **INVERSE_GLOBAL:** związać reverse traversal i wszystkie lokalne
   tożsamości z globalnym `G(F(v))=v` dla każdego canonical v.
3. **PRODUCT:** zinstancjować globalną interpretację modulo Phi i zamknąć
   końcową kompozycję. Ta pozycja zależy od dwóch poprzednich.

Konkretny kandydat inwariantu, harmonogramy pętli, etykiety bloków i kroki
potrzebnego dowodu są rozpisane w `DERIVATION.md`, szczególnie D5–D6.
Obecnie nie ma zamkniętej instancjacji tych interfejsów dla C. Nie zamieniono
ich na założenia kryptograficzne ani nie nazwano domkniętymi na podstawie
wartości certyfikatów lokalnych.

Końcowa sprawdzona teza formalna ma uczciwą nazwę
`L_NTT_after_global_interfaces`. W `formal/Composition.lean` definiuje
coefficient product modulo Phi przez rzeczywistą redukcję monomianów, ale
wymaga nadal:

```text
forward_product : forall h r, F(product h r)=pointMul(F h,F r)
inverse_forward : forall a, G(F a)=canonical a.
```

Przy tych przesłankach kernel dowodzi właściwego p i d. Ponieważ przesłanki
nie zostały zinstancjowane jako globalne twierdzenia badanego źródła,
**nie nadaję statusu L_NTT_PROVED_FOR_PINNED_MODEL**. To dokładna przyczyna
`PARTIAL_PROOF`, a nie błąd narzędzia, kontrprzykład lub zmiana parametrów.

Z L_RHO można już zachować `r≡s modq` i canonical r. Wniosek
`d=canonical_q(h*s-c modPhi)` pozostaje tutaj warunkowy na domknięcie L_NTT.
Centrowanie do int16, pełny parser, norma i ścisły B należą do dalszego L_V.

## 4. Source binding i legalność danych

`artifacts/source_binding.json` przypina cały plik, zakresy funkcji i ich
bajtowe wycinki. Testowy harness wywołuje funkcje z niezmienionego source/.
Kopia observed/ dodaje wyłącznie wrapper generatora: wywołuje prawdziwe
mq_mkgm3, odczytuje tylko użyty prefiks i oddaje sterowanie. Usunięcie
wstawki przywraca pin bajtowo. Drugi build nie ma obserwatora.

Macierz w OBLIGATIONS podaje dla każdej pozycji tezę, zakres źródła/hash,
przesłanki, dowód/certyfikat, polecenie, status i lukę. Mapa indeksów
generatora sprawdza initialization-before-read. Harmonogramy par/trójek
sprawdzają rozłączność i pełne pokrycie 0..1535. Bufory, `restrict`,
promocje i unsigned wrap są jawnie rozliczane w DERIVATION, z granicą
nieukończonego globalnego modelu stanów.

Literalne rekordy Lean są odczytywane ponownie przez `scripts/audit.py` i
porównywane z pełnym dumpem C oraz z właściwymi pozycjami macierzy/modelu.
Samo zapisanie hashu lub wpisanie endpointu jako hypothesis nie jest tu
uznawane za sprawdzenie certyfikatu.

## 5. Kontrole implementacji

Niezależny Sage używa ZZ, GF(18433) i wielomianów modulo Phi; badany NTT
nie jest oracle dla prawidłowego iloczynu. Sprawdzono:

- **737** par prymitywów, oba warianty korekty Montgomery oraz **605**
  przypadków zawijania z*q0i. Również pomocniczy trace używa uint32,
  a jego wynik jest porównany z prawdziwym mq_montymul;
- **18432** niezerowe mianowniki dla źródłowego mq_div_18433(1,y);
- kompletny użyty prefiks dynamicznych tablic oraz jego interpretację;
- **7** przypadków pipeline: zero, jednostki, zawijający wysoki monomian,
  kwadrat wysokiego monomianu, same q-1, deterministyczny gęsty oraz
  istniejący publiczny świadek L_RHO z r=rho(s);
- **28** przebiegów: każdy przypadek w buildzie normalnym i ASan/UBSan,
  z obserwatorem i bez niego. Pełne współczynniki h_ntt, H_mont, r_ntt,
  point_product, p, d i roundtrip odpowiadają dokładnemu oracle;
- obserwowane wywołania dynamicznego generatora: pięć na pipeline z
  dodatkowym roundtrip, zawsze z tym samym kompletnym prefiksem tabel.

Wszystkie kontrole baseline przeszły. ASan/UBSan z `detect_leaks=1`
zakończył się bez zgłoszenia; nie wyłączano LSan na podstawie starej sesji.
To nie jest uniwersalny dowód braku UB.

Rzeczywiste mutacje w osobnych kopiach zmieniały R2t, konwersję tomonty(h),
krok generatora g4/ig4 oraz inverse scaling. Ten sam checker wykrył
każdą z czterech mutacji. Mutacja generatora przechodziła przypadek
jednostkowy, lecz została wykryta na wrap i dense — kolejny powód, aby nie
traktować samej kontroli jednostek jako dowodu. No-op przeszedł wszystkie
trzy swoje kontrole i nie został policzony jako odrzucona mutacja.

Nie znaleziono `COUNTEREXAMPLE_CANONICAL_DOMAIN`. Syntetycznych h nie
przypisano do successful KeyGen support; to dozwolone wejścia silniejszej
tezy arytmetycznej. Nie wykonano nowego KeyGen ani szukania HashToPoint preimage.

## 6. Środowisko i przebieg

Rzeczywisty sandbox został sprawdzony: zapis do W działał, otwarcie oryginałów
do zapisu bez O_TRUNC zwracało EROFS, bez zapisania do nich bajtów.
Root jest read-only, W jest jedynym writable bind, source/ po skopiowaniu
ma dodatkowy read-only bind. Sieć i namespace PID są odseparowane.
HOME/cache/TMPDIR/DOT_SAGE/XDG_CACHE_HOME wskazują W.

Narzędzia: GCC 14.2.0/C99, Sage 10.9, jego Python 3.14.7, Lean 4.34.0/Std.
Sage uruchamiano obsługiwanym `sage plik.py ...`; zapisano osobne wersje
Sage i Pythona. Komendy mają wall/CPU budgets, cwd, exit codes i strumienie
z hashami. Nie instalowano zależności, nie uruchamiano innych agentów i
nie wykonywano operacji Git zmieniających repozytoria.

Zachowano nieudane szkice dowodów Words/Linear: pierwsze wymagały dodatkowych
granic i właściwej normalizacji rzutowań/simplifikacji. Nie były
kontrprzykładami; tylko końcowe exit-0 certyfikaty są konsumowane.
Kompilator zgłaszał ostrzeżenia o układzie średników w pomocniczym harnessie;
pełny stderr jest zachowany, a źródła badane nie były poprawiane.

Pierwsza świeża kopia replayu zatrzymała się na istniejącym katalogu
pochodnych slices. Zachowano ją i wersję skryptu. Druga kopia odtwarza
slices oraz Tables od nowa; zakończyła cały przebieg poprawnie.
**98 plików znaczeniowych odtworzono identycznie bajtowo.** Był to replay
przed finalnym freeze, bez nadpisania oryginalnego W. Późniejszy replay
wymaga zewnętrznego digestu OUTPUTS. Błędy techniczne nie nadały żadnego
werdyktu matematycznego.

## 7. Jedna następna rekomendacja

**Zamknąć globalny source/CRT inwariant dla in-place forward i inverse**,
korzystając z obecnych kontraktów słów i certyfikatów tablic/bloków.
Wynikiem powinny być instancje FORWARD_GLOBAL i INVERSE_GLOBAL dla dokładnego
źródła, które usuwają przesłanki końcowej kompozycji. Nie jest potrzebna
kolejna kampania przypadków jako substytut tego dowodu.

Ten etap kończy się na raportowanym wyniku częściowym. Pełne L_V,
bezpieczeństwo schematu i integracja kodu nie zostały ogłoszone ani rozpoczęte.
