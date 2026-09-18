# FT1536 — L_NTT PARTIAL_PROOF: sprawdzenie i zakres kontynuacji

Data: 2026-09-18.

## Karta dla autora

- **Cel:** sprawdzić ukończony etap L_NTT i wskazać dokładne dalsze obowiązki.
- **Wejście:** zamrożony `FT1536_L_NTT_RUN_001`, tylko do odczytu.
- **Zapis:** niniejsza nowa nota w Dokumenty.
- **Wynik:** potwierdzenie integralności, ponowne sprawdzenie czterech modułów
  Lean i rozpoznanie granicy lokalnych certyfikatów względem globalnej tezy.
- **Koniec:** przekazanie noty. Kontynuacji globalnego dowodu tu nie wykonano.

## 1. Rozstrzygnięcie

**`PARTIAL_PROOF` jest właściwym statusem tego pakietu.** Istnieją użyteczne
dowody lokalne i sprawdzona kompozycja warunkowa. Nie ma jeszcze zamkniętej
instancjacji globalnych forward/inverse dla rzeczywistych pętli in-place C.
Udane kontrole implementacji nie zastępują tej brakującej części.

Zachowano `source_integrated=false`, `owner_accepted=false`,
`full_L_V_proved=false`. Nie stwierdzono kontrprzykładu w wykonanych przez
Astrę kontrolach. Brak kontrprzykładu nie jest dodatnim dowodem L_NTT.

## 2. Kotwice ukończonego etapu

```text
P = /home/footfalcon/Dokumenty/FT1536_L_NTT_RUN_001

P/REPORT.md
b89d618d7c1d3992fa1a9ea0ae8c84dcc348448f035905b87a03c37e20dfd650

P/OUTPUTS.sha256
f23358ce0426f04196bbd8fd4e814afb2b14541c6df13854a67c994f6074771f

P/CLAIM.md
c8e62a9d55cb8922d6cc3c673c249452983879329f92ab4ab79ab1eeb07c65c6

P/DERIVATION.md
f91c0052528f84f85b2379dfc9c9c1df3c34f352836d2535ca88c25e7a9ab367

P/OBLIGATIONS.json
5467801aac9c25f3c1f757f3c640fefcbb6074524874da0312a6e97aaa163bd8

P/source/falcon-vrfy.c
3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42
```

To niezmieniony kandydat z L_RHO, związany z manifestem
`2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`.
L_RHO zachowuje swój wcześniej uzyskany wynik.

## 3. Własne sprawdzenie po otrzymaniu raportu

Potwierdzono:

- **708/708** wpisów OUTPUTS i dokładny zakres z OUTPUT_SCOPE;
- **31/31** oryginalnych wejść z INPUTS;
- **17/17** plików source względem manifestu kandydata L_RHO;
- brak duplikatów, niedozwolonych ścieżek i symlinków w sprawdzonym zakresie;
- zgodność 12 wycinków źródła z rzeczywistymi liniami całego pliku;
- odwracalność wstawki obserwatora do dokładnego źródła;
- powiązanie RESULT z raportem, modułami, źródłami i statusem macierzy;
- zachowanie zamrożonego prefiksu COMMANDS: **116406 bajtów, 131 rekordów**,
  SHA-256 `8f51748ba58712cf81743d18c671fd3e4fde13f0abb205b9c482235fa323435b`;
- hashe wszystkich strumieni wskazanych w tym prefiksie; żywy COMMANDS
  w chwili kontroli miał 120357 bajtów;
- zgodność 98 ścieżek znaczeniowych i **226** archiwalnych strumieni
  wskazanych przez receipt udanego replayu.

Ponownie uruchomiono wszystkie cztery końcowe pliki Lean w sandboxie bwrap
z rootem tylko do odczytu, odłączoną siecią, osobnym PID namespace i
wyczyszczonym środowiskiem. Użyto bezpośrednio Lean 4.34.0, limitu 240 sekund
na moduł, bez zapisu `.olean` i bez uruchamiania oryginalnych runnerów.

| Moduł | Exit | Odpowiedzi `#print axioms` | SHA-256 źródła |
|---|---:|---:|---|
| Words | 0 | 14 | `4630b8b49186ccbf49a074e7e684e8125bbf14e6aadfc5443be8e2cbedb7f52b` |
| Linear | 0 | 7 | `60b843d305f264d47b9411f479d83f647e747b9e9bd7763fa43f27d198336dd5` |
| Tables | 0 | 160 | `ee668bf1b63a8cb9a3192b39fee68347ed67481d4c73e948372ffc1db203821e` |
| Composition | 0 | 5 | `0ee19f21c9acdb4361d862905d7ab090ed3bb904066a22059cf7688948a34772` |

Łącznie **186** deklaracji. Zależności zawierają tylko standardowe
`propext`, `Classical.choice`, `Quot.sound`. Tables sprawdzał się około
17 sekund; pozostałe moduły poniżej sekundy każdy w tej kontroli.

Przeczytano formalne kontrakty słów, lokalne lematy liniowe, definicje
checkerów tablic, końcową kompozycję, DERIVATION i macierz obowiązków.
Nie wykonywano tu kolejnej kompilacji C, nowej kampanii Sage ani pełnego
replayu. Liczby 737/18432/28 oraz wynik 98-plikowego replayu są wynikami
Astry zapisanymi w zweryfikowanym pakiecie; własne nowe wykonanie dotyczyło
kernela Lean i kontroli integralności.

## 4. Co można przenieść do kontynuacji

Zachować istniejące tezy wraz z ich dokładnymi przesłankami i bindingiem:

1. `Words.lean`: kontrakty dodawania, odejmowania, Montgomery i zakresów
   dla całych właściwych dziedzin, w tym zdefiniowany uint32 wrap przed low16.
2. Pierwszość 18433 i sprawdzone trzy stałe instancje źródłowego dzielenia
   używane przez generator/scaling. Dodatkowa kontrola wszystkich mianowników
   nie jest potrzebna jako zastępnik tych certyfikatów.
3. `Tables.lean`: literalne rekordy dynamicznego mq_mkgm3(logn=10), rev10,
   jednostki, postęp liści, rodzice, relacje drzewa i tożsamości wierszy.
4. `Linear.lean`: symboliczne prawa działania/złożenia lokalnych bloków
   dla dowolnych ich danych wejściowych i końcowe skalowanie.
5. `Composition.lean`: matematyczny iloczyn z redukcją monomianów modulo Phi,
   konwersję Montgomery i prawidłową **warunkową** kompozycję końcową.

Argumenty translacji do C i ustalone harmonogramy są w DERIVATION.
Nie należy utożsamiać ich ze skończoną już formalizacją wszystkich stanów
globalnych buforów. Macierz wyraźnie rozróżnia te poziomy.

## 5. Dokładne zadanie kontynuacji

Najważniejsze miejsca: `DERIVATION.md:D5–D6`,
`formal/Composition.lean:47–59` oraz pozycje
`FORWARD_GLOBAL`, `INVERSE_GLOBAL`, `PRODUCT` w OBLIGATIONS.

Potrzebne jest związanie każdego prefiksu pętli in-place ze stanem
matematycznym. Inwariant forward ma przenosić:

```text
współczynniki f
  -> reszty modulo X^768-a oraz X^768-(1-a)
  -> osiem poziomów rozszczepienia A+sB / A-sB
  -> 512 bloków stopnia 3
  -> ewaluacje w alpha_i*omega^j, dokładnie na pozycjach 3i+j.
```

W inverse trzeba związać odwrotny harmonogram z tymi samymi fizycznymi
adresami, wykorzystać lokalne tożsamości i rozliczyć łączne skalowanie
`3*2^8*2=1536` oraz źródłowy czynnik odwrotny. Dowód ma obejmować również
legalność kolejnych odczytów/zapisów i propagację canonical range.

Dopiero te źródłowe twierdzenia mają dostarczyć dowodów przesłanek:

```text
forward_product : forall h r, F(product h r)=pointMul(F h,F r)
inverse_forward : forall a, G(F a)=canonical a.
```

`F` i `G` w obecnej kompozycji są parametrami. Trzeba je zinstancjować
konkretnymi modelami source forward/inverse i dostarczyć powyższe dowody;
samo usunięcie przesłanek z opisu nie zamyka obowiązku.

### Ważne dopasowanie dziedzin

`Composition.lean` używa `Vec := Fin 1536 -> Int`, a jej dwa interfejsy
kwantyfikują po wszystkich takich wektorach, bez przesłanki Canon.
Rzeczywiste kontrakty wejściowe C dotyczą canonical współczynników.

Kontynuacja musi jawnie połączyć te dziedziny: np. przez formalne podniesienie
funkcji źródłowej do wszystkich wektorów całkowitych za pomocą wejściowego
canonical, z dowodem zgodności; albo przez odpowiednio ograniczoną wersję
lematu kompozycji i dowód jej zastosowania do dokładnej tezy L_NTT.
Jest to dopasowanie interfejsu matematycznego, nie polecenie zmiany kodu C.
Nie wolno po cichu zastąpić kwantyfikatora ani przyjąć globalnego interfejsu
jako nowego aksjomatu.

Pełny wynik ma następnie dać p=canonical(h*r modPhi) i d=canonical(h*r-c),
a przez L_RHO podstawienie r=rho(s). Centrowanie C, parser, norma i ścisły B
pozostają kolejnymi obowiązkami pełnego L_V.

## 6. Czysty log i zachowanie stanu

Obowiązuje reguła dla następnych zleceń:

```text
/home/footfalcon/Dokumenty/FT1536_ZASADA_CZYSTEGO_LOGU_LEAN_2026-09-18.md
SHA-256: 9f6b0731263853867914f5d1227ba62dd1059e8a79623d987204c3f4aa3d5da1
```

W ponownym wykonaniu tylko Words zgłosił ostrzeżenie:
`Int.ofNat_nonneg` jest przestarzałe; zalecane `Int.natCast_nonneg`
(`formal/Words.lean:99`). To uwaga porządkowa, nie przyczyna PARTIAL_PROOF.
Pozostałe trzy finalne moduły miały czyste wyjście poza `#print axioms`.
W przyszłej edytowanej kopii stosować aktualną nazwę, ponownie sprawdzić
certyfikat i przypiąć jej nowy hash; ostrzeżenia ze starych niezmienianych
wejść raportować jawnie. Nie poprawiać kosmetyki w zamrożonym pakiecie.

Kontynuacja powinna zachować kontekst rozmowy, jeśli pozwala na to klient,
oraz mieć osobny katalog zapisu i aktualny sandbox. Wszystkie obecne źródła,
certyfikaty, manifesty i instrukcje ukończonych etapów są wejściami do odczytu.
Nie potrzeba ponownego odkrywania lokalnych faktów ani kolejnej szerokiej
kampanii testów jako substytutu globalnego dowodu.
