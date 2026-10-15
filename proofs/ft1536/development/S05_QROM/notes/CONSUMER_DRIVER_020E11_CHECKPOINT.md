# TODO020E11 — konsument i sterownik surowej pamięci rdzenia

**KERNEL_SCOPED / NOT_REVIEWED / WARUNKOWY.** Zlecony konsument kodowanego
wyjścia i sterownik kolejnych kroków rdzenia są domknięte. Pełne publiczne
wywołanie samplera, transport J/P, komplet zasobów i QROM nadal OPEN.

Baza main: `8d8614bc55a6d9bb7b14e4fb754cda6b9b8a20d9`.
Baza S05: `fadfca600ec9c852cd2ba9f7655b10f4f7b03423` (E10).
Źródła: `69166ed5f6826c2f15d15a7a4026a5321602c812`,
`201e049322f2221320e87e82cad39aabf7af8659`.
Runtime: `.build/pair_machine_020/consumer_driver_001/`.
Jedno okno, jeden ciężki proces; lokalny main, bez push. Monitor ROM PAUSED.

## Co mamy

`CommandDecode020E11` jest wykonywalnym, sprawdzanym dekoderem trzech słów.
Tag0 wymaga zerowego adresu i payloadu; tag1 wymaga poprawnego adresu signed
Word512. Pozostałe tagi, niezerowy padding i złe adresy są odrzucane.
Roundtrip, soundness i accepts_iff dowodzą, że akceptowane są dokładnie
kodowania dotychczasowego writeCodec, przy jego granicy adresowej.
**Pusty slot, aktywny zapis wartości0 i błąd dekodowania są odrębne.**

`CommandConsumer020E11` przechowuje surowy bufor, kursor, flagę błędu i bank
celu. Dekoduje jeden slot na przejście, bez budowania listy lub banku całego
zdekodowanego skryptu. `CommandConsumerRefinement020E11` dowodzi zgodności
każdego przejścia ze ScriptMachine i wykonania całego poprawnego bufora.
Wszystkie jego prefiksy zachowują bad=false. Dowody są ogólne względem
pojemności; obejmują też pojemność0 i niepełne paliwo.

Przy złym slocie błąd jest zatrzaskiwany: następne przejścia nie zmieniają
stanu, a finish zwraca None. Już wykonany prefiks zapisów pozostaje w stanie
konsumenta; **nie ma obietnicy rollbacku**. Konsument nie udaje sukcesu po
zbyt krótkim skanie. Producent rdzenia E10 emituje poprawne kodowanie, więc
te dodatkowe błędy są wykluczone dla wejść objętych twierdzeniem zgodności.

`ProducerRawCore020E11` oddziela sześć stałych portów od aktualnego surowego
banku rdzenia. Każde przejście uruchamia te same dwa kody producenta E6,
a następnie nowego konsumenta na rzeczywistych96 słowach wyjścia.
`ProducerRawDriver020E11.run` przekazuje wynikową pamięć do kolejnej iteracji.
**Nie wywołuje starego CoreStep/CoreRun, nie podstawia kanonicznej listy
zapisów i nie rekonstruuje typowanego Core między krokami.**

Główne eksporty:

- `ProducerRawDriver020E11.refines`: dla każdego typowanego Core, obu fresh
  i każdego paliwa raw driver zwraca `some (image (CoreRun.run ...))`.
  Brak przesłanki fazy, osiągalności, Inv lub sukcesu.
- `ProducerRawResult020E11.refines`: końcowy odczyt zachowuje pełny stary
  stan reg/RAM/out/fault oraz stary wynik None. Odczyt typowanego stanu
  następuje dopiero na końcu, poza pętlą.
- `ProducerCoreExecution020E11.execute_refines`: przy oryginalnym limicie
  sterowania i odziedziczonym budżecie przejść cały wynik rdzenia zgadza się
  z dawnym ArrayExecute.execute, także gdy stary wynik jest None.
- `halts/zero_fuel/stopped_done/stopped_bad`: zatrzymanie przy wystarczającym
  starym rank, paliwo0 oraz oba stany terminalne mają osobne dowody.

## Dwa poziomy wyniku i granice runtime

Wynik drivera/readoutu ma typ `Option (Option State)`: zewnętrzne None
reprezentuje błąd konsumenta; `some none` zachowuje stary wynik porażki lub
nieukończenia. Teza daje **some(stary wynik)** dla kodowania każdego
typowanego stanu. Nie utożsamiono nowego błędu transportowego ze starą
porażką i nie ukryto go przez totalizację. Done z fault=true zachowuje tę
flagę, zgodnie ze starą semantyką; bad pozostaje starym None.

`ofData` i `image` są mostami specyfikacji/inicjalizacji, nie operacjami
wewnętrznej pętli. Źródła stałe i kod są jawnymi wejściami/stałymi obrazami;
przygotowanie tych banków, ładowanie kodu, kopie readoutu i ich życie nadal
wymagają złożenia w całość oraz rachunku zasobów. Maszyna konsumenta jest
nowym, skończonym modelem przejść korzystającym z banków i prymitywów
odczytu/zapisu; nie deklarujemy jej kompilacji do native ani pełnego peak.

Twierdzenie rozpoczyna się od **kodowania typowanego stanu**. Nie jest
walidatorem całego dowolnie uszkodzonego surowego obrazu Core. Ścisła
walidacja dotyczy poleceń konsumenta. Ta granica nie ogranicza wcześniejszej
dziedziny typowanych stanów i obejmuje wszystkie jej modelowane porażki.

Budżet `1106642201817 * cycle 877 + 1` jest odziedziczonym budżetem przejść
rdzenia, nie liczbą instrukcji nowej realizacji ani jej czasem. Nie uruchamiano
tak długiego przebiegu ani ogromnej taśmy: dowody są symboliczne i kernelowe.

## Mapa murów

| Obowiązek | Stan |
|---|---|
| Rzeczywisty producent i zgodność siedmiu faz | KERNEL, E7–E10 |
| Sprawdzany dekoder i konsument kodowanego bufora | **KERNEL, E11** |
| Driver na surowej pamięci dla dowolnego paliwa | **KERNEL, E11** |
| Pełny stary wynik rdzenia, porażki i oryginalny limit | **KERNEL, E11 — zakres zlecenia domknięty** |
| Złożenie publicznego przygotowania, rdzenia i pełnej odpowiedzi | **OPEN — następny krok** |
| Transport całego wywołania / EveryTape / J/P pod tym samym(M) | OPEN |
| Pozostałe rodziny producenta: parser/fill/startup | OPEN |
| Pełny czas/peak: porty, dwa kody, bufor, dekoder, readout, życie danych | OPEN |
| Pokrycie(M), rzeczywiste KeyGen/Sign/PRG i redukcja QROM | OPEN, bez zmian |

Następna praca: spiąć rzeczywiste publiczne przygotowanie wejścia i parsera,
wywołanie nowego raw core oraz odbiór pełnej odpowiedzi. Po dowodzie całego
wywołania przenieść EveryTape i J/P, nie zmieniając publicznego initial,
prawa kluczy, dziedziny h ani(M). Pozostałe rodziny producenta i zasoby
zachowują własne obowiązki; specyfikacyjne ofData nie zastępuje ich realizacji.

## Kontrole i historia prób

**8 modułów wynikowych,43 twierdzenia, audyt69 eksportów,769 pinów.**
Wszystkie9 końcowych uruchomień mają czyste logi. Aksjomaty tylko
propext/Classical.choice/Quot.sound; bez sorry/admit, nowych aksjomatów,
native_decide/bv_decide i wyciszania linterów w wyniku.

Zachowano16 uruchomień Lean:9 czystych i7 nieudanych, oraz osobny błąd
argumentów runnera przed startem Lean. Przyczyny i receipty są w
[CHECKS](CONSUMER_DRIVER_020E11_CHECKS.json). Problemy dotyczyły zależnych
typów, koercji/transportów i elaboracji; nie są kontrprzykładami. Próba
rawcore001 osiągnęła limit heartbeatów przy niedookreślonej pojemności;
jawna pojemność i poprawny typ portu zamknęły dowód bez zwiększania pamięci.
Nie instalowano artefaktów błędnych lub z ostrzeżeniami.

Limity: Lean4096MiB, AS8GiB, jeden rdzeń. Receipty opisują kompilator,
nie wykonanie samplera. Brak nowego obliczenia numerycznego wymagającego Sage.
[Kontrola autora](CONSUMER_DRIVER_020E11_SELF_REVIEW.md),
[klasy](CERTIFICATE_CLASSES_020E11.json), [kolejka](KERNEL_QUEUE_020E11.json).
Brak niezależnego odbioru, nowego certyfikatu J/P, source bindingu native lub
deklaracji bezpieczeństwa FT1536 w QROM. Status nadal WARUNKOWY.

OUTPUTS pomija żywy README. RUNTIME zamraża pliki przy freeze, również
nieudane próby; późniejsze plany/receipty commita dokumentów i POSTCOMMIT
są operacyjnymi dopiskami poza manifestem.
