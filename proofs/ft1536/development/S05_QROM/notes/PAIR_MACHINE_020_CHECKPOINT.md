# S05 / PAIR_MACHINE020 — warunkowy checkpoint częściowy

**PARTIAL_PROOF / TODO020 IN_PROGRESS / NOT_REVIEWED.**
Nie domknięto jeszcze pełnego kosztu samplera ani bezpieczeństwa FT1536 w QROM.
Baza:835dfc6bd7bbb7b5f43006a65ea3973d94030d39; pierwszy commit źródeł:
182990ac; granice i kontrole:0b2b07a0. Cel pozostaje w [TODO020](TODO_PAIR_MACHINE_020.md).

## Co rzeczywiście powstało

Jest konkretny, zamknięty program `PairProgram020.program`, a nie funkcja
samplera podana interpreterowi jako darmowy oracle. Ma877 węzłów składni,
głębokość32 i jawne instrukcje odczytów/zapisów. Wykonuje descendentne
czytanie bitów, binary CDF, cap80, zapis1536 par i normę, cap196, świeży
cube, scatter iloczynu oraz emisję całej pary challenge–odpowiedź.

`WordRAM020` określa model: słowo ze znakiem512bit, arytmetyka modulo2^512,
reszta euklidesowa,32 rejestry, rozdzielone skończone banki ROM/RAM/taśmy
oraz wyjścia. Zły adres ustawia trwały fault. Instrukcje są składnią danych;
nie zawierają funkcji użytkownika, nieograniczonego wywołania samplera ani
funkcji obliczającej tablice. Wejście jest publicznym h i prywatną taśmą;
stan startowy jest stałym publicznym `initial`.

**Model ma jednostkowe operacje na512bit i dostęp losowy.** Cena jest
zdefiniowana dla strukturalnej semantyki instrukcji, wyrażeń i sterowania.
Nie jest czasem C/CPU, ceną bramek ani czasem wykonania interpretera Lean.
Matematyczne `Function.update` reprezentuje pojedynczy zapis w modelu RAM;
nie dowiedziono stałokosztowości jego natywnej implementacji ani GC.
Odczyt/zapis pojedynczego bitu jest prymitywem osobnych banków bitowych.
Kompilacja składni do konkretnej reprezentacji kodu/stosu i kalibracja
spakowanego bitowego backendu pozostają otwarte.

## Kernel: dokładny zakres81 eksportów

| Moduł | Eksporty | Wykazany zakres |
|---|---:|---|
| WordRAM020 |8| Uniwersalny bound interpretera, zachowanie rejestrów, dokładność słowa i adresu pod zakresem |
| PairProgram020 |1| Bound dla faktycznego zamkniętego programu, dla każdego wejścia i stanu |
| ProgramCost020 |6| Dokładna wartość boundu,877 węzłów, głębokość32 i pojemność banków |
| InputLayout020 |9| Bezstratne tablice i to samo h, niezmieniona taśma, skończone adresy i świeży suffix |
| MemoryFrames020 |17| Równania przejść, ramki zapisów/odczytów, zachowanie pozostałych komórek i sticky fault |
| TapeLayout020 |13| Ogólne split/chunks i wszystkie10 adresowań słów z hierarchii seedEquiv019 |
| PairEncoding020 |9| Format pełnej pary50689bit, rozróżnienie none/some, dokładne16/17bit pola |
| PairEncodingInjective020 |6| Różnowartościowość kodowania całej pary, włącznie z none/some |
| WordArithmetic020 |11| Dokładne działania pod zakresem słowa, akumulator, reszta i lokalne granice scatter |
| RefinementTarget020 |1| Wyłącznie brak fault w publicznym stanie początkowym; EveryTape jest nadal niedowiedzioną propozycją |

Wspólny audyt `AuditPairMachine020` sprawdził81 nazwanych eksportów:
wyłącznie standardowe aksjomaty Lean/Mathlib.13 finalnych buildów modułów
w świecie `legacy_v2` ma czyste logi. Graf tego audytu liczy376 lokalnych
modułów i nie zawiera `SelectBitPreserve` ani `ThetaBox`. Nie jest to
nowy audyt wszystkich historycznych deklaracji tych zależności.

Dla każdego wejścia i każdego stanu interpreter **tego konkretnego programu**
ma koszt rdzenia nie większy niż **1106642201817** jednostek modelu.
To cena najgorszej ścieżki w zamkniętej składni, obejmująca wyrażenia,
pętle, odczyty, zapisy i emisję. Jest bardzo duża — około1,107 biliona
operacji słowowych. Nie ogłaszamy praktycznej szybkości.

Pojemność samych banków danych to **24712937985bit**:
24662538240bit taśmy,93698 słów ROM,4608 słów RAM,32 rejestry
oraz50689bit wyjścia. Taśma sama ma3082817280 bajtów.
**To nie jest jeszcze pełna szczytowa pamięć:** nie doliczono implementacji
kodu, stosu sterowania/wyrażeń, flagi fault, wyrównania i buforów drivera.
Podobnie rdzeń nie obejmuje materializacji/ładowania wejścia ani przekazania
wyniku do wywołującego. Nie dodajemy im arbitralnej liczby bez programu.

## Czego nie wolno jeszcze składać

`RefinementTarget020.EveryTape` brzmi dosłownie: dla każdego publicznego h
oraz każdej24662538240-bitowej taśmy, po uruchomieniu programu od initial
fault jest false, a lista bitów wyjścia jest równa `PairEncoding020.encode`
zastosowanemu do wyniku `StandaloneRuntime019.publicCode h` na tej taśmie.
**Nie ma dowodu tego zdania.** Lokalna dokładność obrazu i adresów oraz
kontrole skończone nie zastępują niezmienników wszystkich pętli.

Dlatego020 nie przenosi jeszcze J≪P ani momentu≤1+2^-47 na maszynę.
Te wyniki nadal dotyczą kodu019 pod jego dokładnym(M). EveryTape wraz
z poprawną realizacją/decoderem pozwoli zachować ten sam wynik i prawo;
nie ma tu nowego e ani nowego wariantu samplera. `Fits` i bound wartości
nie zostały pomylone z dowodem, że wszystkie osiągalne stany je spełniają.

Pełne odpowiedzi referencji nadal obejmują porażki. Encoder ma także
jawny wariant none; kernel dowodzi też różnowartościowości całego encodera.
Wykonywalny decoder i jego cena należą jeszcze do drivera. Program publiczny ma zwracać some jak019. Koszt26113bit
z reply-only API wariantu A nie jest używany zamiast50689bit całej pary.

## Sprawdzenia i nieudane podejścia

[Sage](CHECK_PAIR_MACHINE_020.sage) odczytuje JSON zamkniętej składni
wyeksportowany przez Lean. Używa standardowego preparsera i ZZ.
43 kontrole obejmują384bit, granice CDF/modulo, akceptację w pierwszej
oraz80. próbie, wyczerpanie cap80, trzy przypadki scatter i znaki aktualizacji,
16/17bit emisję i niepoprawne adresy. Są diagnostyką skończoną,
bez pełnego wykonania programu FT1536 i bez uniwersalnego refinement.

Zachowano40 prób Lean, w tym20 prób z błędem lub ostrzeżeniem.
Najistotniejszy problem narzędziowy: automatyczna generacja równań
`atomRun.eq_1` wywoływała problem dużych potęg/rekursji. Zwiększenie limitów
nie wystarczyło. Rozwiązaniem są jawne równania przejść dowiedzione przez
rfl; nie zmieniono instrukcji i nie wyciszono ostrzeżeń. Probe jest w
`notes/attempts020`, a source snapshoty każdej próby w runtime.

Przy przygotowaniu drugiego świata filtr nazw przypadkowo pominął dwa
historyczne chunki017 kończące się `_020`; build odmówił importu. Dodano
zweryfikowane oryginały, bez zamiany źródeł ani nadpisania artefaktów.
Receipt `RESTORED_DEPENDENCY_001.json` zachowuje przyczynę. Nowy preparer
kopiuje pełną jawną listę pinów, bez takiego filtra.

Sage exact001 zakończył się timeoutem120s bez wyniku; przyczyna tej próby
nie została ustalona. exact002 z diagnostyką wykazał wolny import środowiska
i zakończył się PASS. exact003 ma identyczny wynik, pusty stderr, PASS43;
33,070s dotyczy procesu Sage, nie samplera. Wszystkie receipty zachowane.
[CHECKS](PAIR_MACHINE_020_CHECKS.json) i manifest wiążą źródła, logi oraz SHA.

## Mapa murów i następny wykonywalny krok

1. **Q-RESC / Q-SAMPLER: IN_PROGRESS.** Składnia i bound rdzenia kernelowe.
   Następny krok: Hoare/refinement dla `readWord`, binary CDF i cap80,
   potem oba wektory/norma/cap196/cube, scatter i końcowa emisja. Nie
   przechodzić do nowego TODO omijającego `EveryTape`.
2. **Driver i pełna pamięć: OPEN.** Jawne źródło bitów, ładowanie obrazu,
   reprezentacja programu/stosu i buforowania, transfer wyjścia; następnie
   suma kosztów i szczyt pamięci. Streaming wymaga osobnego prawa.
3. **Q-KEY/Q-BIND/(M): OPEN_SOURCE.** To samo rzeczywiste prawo emitted
   KeyGen i pełne źródłowe pokrycie harmonicznego/M nie wynikają z020.
4. **Źródłowe Sign/PRG i wariant A: OPEN.** Przy zmianie P na R nadal
   potrzeba P≤kappa R na nośniku J i e'=kappa(1+e)-1. Nie ustawiono kappa=1.
5. **QROM: OPEN.** Kwantowa kompozycja D=(1+e)^q_s−1 wymaga jawnych
   przesłanek operatorowych; log/embedding/kolizje/reprogramowanie,
   budżet reduktora i powiązanie z grą pozostają osobnymi obowiązkami.
   Nonce320bit i założenia A-QMT/Q-PRG pozostają bez zmian.

Maszyna i fair-bit source to MODEL. Program/refinement/koszty/source
binding to OBOWIĄZKI DOWODOWE. Nie dodano założeń kryptograficznych.
Self-review autora nie nadaje statusu REVIEWED. Brak push i zmian T12.1/B20.

## Odtworzenie własnych buildów

`PREPARE_PAIR_MACHINE_020.py NEW_WORLD` najpierw sprawdza wszystkie piny,
następnie kopiuje381 zależności do nowego własnego runtime. Nie wykonuje
cudzych replayów; brak pliku lub rozjazd SHA zatrzymuje przygotowanie.
Zależności wymagają istniejących przypiętych artefaktów poprzednich etapów.
To nie jest samowystarczalny download/bootstrap całej historii projektu.

`BUILD_PAIR_MACHINE_020.py NEW_WORLD MODULE FRESH_LABEL` kompiluje snapshot;
`... NEW_WORLD install MODULE FRESH_LABEL` instaluje wyłącznie czysty wynik.
Kolejność: WordRAM020, PairProgram020, ProgramCost020, InputLayout020,
MemoryFrames020, TapeLayout020, PairEncoding020, PairEncodingInjective020, WordArithmetic020,
RefinementTarget020, potem audyty/eksporter. Każdy moduł używany przez
kolejny trzeba najpierw zainstalować. Do dokładnych kontroli służy
`RUN_PAIR_MACHINE_CHECK_020.py FRESH_LABEL`; wywołuje `sage file.sage`.
