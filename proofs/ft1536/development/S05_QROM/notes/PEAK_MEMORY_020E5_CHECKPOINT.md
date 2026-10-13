# TODO020E5 — checkpoint banków, granic wywołania i scratch

**IN_PROGRESS / PARTIAL_KERNEL / WARUNKOWY / NOT_REVIEWED.**
Cel właściciela — pełny peak całego samplera — pozostaje otwarty.
Ten checkpoint zachowuje wyniki dalszej pracy; nie oznacza zamknięcia TODO.
Źródła bieżącej partii: `9b64552fc49f9faa9f50371ba38bbc30c6f61be9`.
Baza: `dd041b73228c59fc14ff80dc56ea46780974db79`; rdzeń zapisano wcześniej
w `2d19cd693064a380a93ba3e0be394cb930f0f0c1`. Runtime:
`.build/pair_machine_020/peak_memory_001/`. Bez push; jedno okno i jeden ciężki
proces naraz. Bez przejmowania ROM, zmian T12.1/B20 i niezależnego odbioru.

## Co rzeczywiście wykazano

- `CoreRun020E5.execute_refines`: kończąca się maszyna faz clear/scan/act/push
  zachowuje wynik backendu Array dla dowolnych wejść i stanów. Pełny rdzeń ma
  bezstratne kodowanie; `CoreStore020E5` realizuje krok przez najwyżej 19 zapisów.
- `FillMachine020E5.fills` oraz `FillStore020E5.realizes/fill_trace` wiążą pętlę
  wypełniania z treścią banku i zapisami do istniejących komórek. Dotyczy to
  taśmy, ROM i kopii wyniku; dla Bool/Word krok potrzebuje najwyżej 2 zapisów.
- `ParserDecision020E5.cell_refines`, `ParserStore020E5.run_trace` i
  `IndexedParser020E5.executes/run_trace`: parser czyta stały bank kodu przez
  skończony licznik. Krok zapisuje najwyżej 10 słów. Odrzucenia są zachowane;
  nie trzymamy listy historii ani stosu rekurencyjnego parsera jako danych RAM.
- `PublicData020E5` jawnie reprezentuje ten sam publiczny klucz, tablice i 877
  komórek kodu. `romCell_eq`, `code_eq`, `filledROM_eq` wiążą odczyty z poprzednim
  programem. Obraz jest bezstratny i ma 95 452 słowa. Tablice to publiczne dane
  przygotowane wcześniej, a nie darmowe obliczanie CDF podczas wywołania.
- `StartupImage020E5.core_zero/parser_zero/zero_cells` wiążą początkowe dane
  z rzeczywistymi zerowymi komórkami. `CoreStartup020E5` instaluje ramkę wejścia,
  limit i wskaźniki przez 19 zapisów. Nie zastępujemy inicjalizacji liczbą pojemności.
- `ScriptBuffer020E5` przechowuje tag, adres i wartość każdego polecenia.
  `ScratchRound020E5.round_trace` obejmuje reset kursora, wypełnienie wszystkich
  32 slotów (w tym pustego dopełnienia), drugi reset i wykonanie przez odczyty
  bufora. `round_target` daje dokładnie `WordPatch.apply` przy długości ≤32.
  `ScratchConsumers020E5` ma konkretne instancje dla rdzenia, parsera,
  wypełniania i inicjalizacji. Protokół działa także z dowolną poprzednią
  zawartością bufora; stare polecenia nie przechodzą do następnej rundy.
- `ResidentCall020E5.every_tape` składa wejście, parser, rdzeń i wyjście **jako
  dowód wyniku**. `law_eq/all_h_ac/certificate/same_key_law` zachowują pełne
  prawo odpowiedzi, w tym porażki, to samo publiczne initial, h, prawo kluczy
  i dokładnie ten sam warunek (M). AC dla każdego h; moment ≤1+2^-47 pod (M).
  Pokrycie (M) przez źródłowe KeyGen nadal jest obowiązkiem dowodowym.

## Rachunek z danymi, bez awansu do pełnego peak

`BoundaryPayload020E5.heap` zawiera rzeczywiste obrazy sześciu banków,
`withScratch` dokłada rzeczywisty obraz bufora. Sage 10.9 i kernel
`BoundaryNumbers020E5` potwierdzają:

| Składnik | Słowa 512-bitowe |
|---|---:|
| Publiczne klucz, tablice, kod | 95 452 |
| Taśma z kursorem | 24 662 538 241 |
| ROM z kursorem | 93 699 |
| Parser z kursorem i flagą porażki | 5 266 |
| Pełny stan rdzenia | 143 922 |
| Oddzielne wyjście z kursorem | 50 690 |
| Bufor 32 poleceń z kursorem | 97 |
| Nagłówki siedmiu regionów w modelu | 14 |
| Razem reprezentowane dane | **24 662 927 381** |

To **1 578 427 352 384 bajty** przy zadeklarowanym jednym słowie512 na komórkę.
Nie jest to taśma pakowana bitowo, pomiar native Lean/C ani pełny peak procesu.
Taśma dominuje w tej konserwatywnej reprezentacji. Dużej tablicy nie wykonywano
na komputerze: dowody są symboliczne, rachunek liczbowy jest dokładny.

## Mapa murów i następne zobowiązania

| Obowiązek | Stan i dokładny następny krok |
|---|---|
| Q-RESC: dane rdzenia, wejście/parser/wyjście, bufor zapisów | Kernelowe reprezentacje i lokalne ślady istnieją; zakres opisany wyżej. |
| Q-RESC: producent poleceń | **OPEN.** Trzeba zrealizować odczyty, obliczenia skalarne, lokalne wartości i konstrukcję poleceń w policzonym workspace. `p.code.length≤32` nie ogranicza pamięci obliczenia `p.code`. Nie polegamy na nieudowodnionym usuwaniu argumentów przez kompilator. |
| Q-RESC: cały cykl życia | **OPEN.** Jeden sterownik musi powiązać przygotowanie/alokację regionów, wszystkie fazy i producentów z tą samą pamięcią, uwzględniając sterowanie oraz deskryptory globalne. `ResidentCall.every_tape` składa wyniki, nie ślady pamięci. |
| Q-RESC: czas tej realizacji | **OPEN.** Stary bound 020E4 dotyczy kopiującego backendu; nie przenosi się automatycznie na nową realizację regionową. |
| Źródłowe (M), KeyGen, Sign, PRG, wariant A | Bez awansu. Nadal potrzeba odpowiednich source bindings, pokrycia prawa kluczy i późniejszej integracji. |
| QROM: hash, osadzenie, kolizje/reprogramowanie i reszta TARGET_CONTRACT | Nadal OPEN; ten checkpoint nie dostarcza redukcji QROM ani deklaracji bezpieczeństwa. |

`RegionRam020E5`/`ZeroAllocate020E5` to jawny **MODEL** zapisów in-place i
ALLOC_ZERO. Native Lean/C oraz bitowy koszt prymitywów są osobnym zakresem.
Nie wprowadzono założenia kryptograficznego zastępującego brakujący dowód pamięci.
Następna praca pozostaje tym samym TODO020E5: producent na skończonym workspace,
sterownik całego śladu i dopiero potem pełne twierdzenie peak.

## Dowody, piny i zachowane porażki

49 modułów wynikowych020E5, 212 twierdzeń oraz audyt 418 eksportów (definicje,
abbreviacje i twierdzenia). Końcowe logi mają zero błędów i ostrzeżeń.
Audyt aksjomatów obejmuje standardowe `propext`, `Classical.choice`,
`Quot.sound`; nie wprowadza `sorryAx`, nowych aksjomatów ani native_decide.
To kontrola autora, nie niezależny odbiór Daybreak.

Rejestr wyników/receipty: `PEAK_MEMORY_020E5_CHECKS.json`; manifest źródeł:
`PEAK_MEMORY_020E5_OUTPUTS.sha256`; zamrożona lista plików runtime:
`PEAK_MEMORY_020E5_RUNTIME.sha256`. Wszystkie nieudane buildy mają osobne
snapshoty i logi, także próby przekraczające pamięć przy rozwijaniu konkretnej
pętli taśmy. Zastąpiono to użyciem lematu przy abstrakcyjnym rozmiarze;
końcowy `boundary006` działa przy limicie4GiB. Próby arytmetyczne norm_num
przekraczały głębokość; bezpośrednie rfl sprawdza identyczną równość w kernelu.
Nie zmieniono liczby, modelu ani przesłanek w celu uzyskania pozytywnego wyniku.
