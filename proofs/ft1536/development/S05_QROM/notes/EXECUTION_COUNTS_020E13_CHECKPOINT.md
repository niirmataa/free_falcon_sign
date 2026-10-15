# TODO020E13 — liczniki rdzenia powiązane z publicznym wywołaniem

**KERNEL_SCOPED_COUNTS / NOT_REVIEWED / WARUNKOWY.** Zamknięto dokładny
rachunek zdarzeń rdzenia i jego zgodność z pełnym publicznym wywołaniem.
**Pełny czas oraz peak samplera pozostają OPEN.** Ten etap nie nadaje
licznikom ceny prymitywów ani nie dowodzi ich fizycznej alokacji.

Baza robocza: `2234c715c3db7aaf38e310e303c48b012a9bd606`.
Poprzedni checkpoint S05: `5f36087c31f6878590135cbbf95d3ef27aa32951`.
Commity źródeł: `f246feae85071d97fb4bafd5fa8f39a9dfd851ac`,
`e6c5678f73dbd54eaa13f3f8aa5d6872bdacdb15`.
Runtime: `.build/pair_machine_020/execution_counts_001/`.
Jedno okno i jeden ciężki proces. Monitor ROM PAUSED; bez push.
Obce przyrosty main sprawdzono wyłącznie pod kątem zakresu ścieżek T12_1,
bez wznawiania ich prac, audytu matematycznego lub zmian ich statusów.

## Co wykazano

Instrumentowane wykonanie uruchamia te same instrukcje i ten sam dekoder,
a drugi producent otrzymuje rzeczywisty wynik pierwszego. Po usunięciu
liczników wynik jest równy E11/E12 dla każdego badanego argumentu — to dowód
uniwersalny, nie porównanie wybranych uruchomień. Liczniki są pomocniczymi
danymi dowodu, a nie nową przesłanką o koszcie.

- `ProducerCount020E13.value`: zgodność całego stanu fetch/execute dla
  dowolnego kodu, źródeł, paliwa i stanu. Ograniczenie cykli działa także
  bez założenia fazy startowej.
- `ProducerExactCount020E13.exact_cycles`: przy fazie fetch liczba cykli
  wynosi `min(fuel, codeSize−pc)`. Każda instrukcja przesuwa pc, także
  nieudany load. Od initial wywołanie zużywa dokładnie codeSize cykli.
- `core_cycles`: para stałych producentów zużywa **14 733 cykle** na rundę.
  Cykl składa się z dwóch przejść Fetch.step, a nie z jednej operacji CPU.
- `ConsumerCount020E13.value/consume_bound`: wynik konsumenta jest ten sam;
  pełne consume wykonuje dokładnie capacity przejść, dekoduje co najwyżej
  capacity slotów, wykonuje nie więcej zapisów niż dekodowań.
- `ConsumerCountBoundary020E13.bad/completed/malformed`: po błędzie lub
  osiągnięciu końca kolejne przejścia pętli pozostają policzone, lecz nie
  skanują i nie zapisują. Pierwszy malformed daje jedno dekodowanie i zero
  zapisów, a wcześniejszych zapisów nie cofa.
- `step_no_write/run_no_write`: zero naliczonych zapisów implikuje równość
  rzeczywistego banku target. Counter writes odpowiada aktywnemu poleceniu
  store, nie liczbie zmienionych wartości — zapis tej samej wartości też liczy.
- `CoreDriverCount020E13.value/valid`: zgodność całego surowego sterownika,
  również na błędnej pamięci, przy zerowym paliwie i wcześniejszym zatrzymaniu.
  Ogólny konstruktor CountedLoop.valid jest tutaj zainstancjonowany
  dowiedzionymi CoreStepCount.counts; nie pozostaje założeniem o producencie.
- `PublicCallCount020E13.value/every_tape/full_response`: instrumentacja
  rdzenia w pełnym wywołaniu publicznym zachowuje wynik E12, publiczny initial
  i odpowiedź wraz z algorytmicznymi abortami. Przy odrzuceniu parsera/rootu
  liczba zdarzeń rdzenia wynosi zero; nie znaczy to zerowego kosztu parsera.

Dla faktycznie wykonanych `r` rund rdzenia i paliwa `F`:

```
cycles = 14733*r
slots  = 32*r
writes ≤ scans ≤ slots
r ≤ F, tests ≤ F
```

`tests` liczy sprawdzenia terminalności przy dodatnim paliwie. `slots` liczy
przejścia konsumenta, także absorbujące po błędzie. `scans` liczy wywołania
dekodera, a nie odczyty pojedynczych słów. To sześć rozróżnionych zdarzeń,
nie jeden wspólny licznik czasu.

Dla publicznego wywołania `F = 1106642201817*(2*877+8)+1`.
Sage10.9 w ZZ oraz osobny wygenerowany i sprawdzony kernelowo moduł
`ExecutionCountNumbers020E13` potwierdzają:

| Zdarzenie wewnętrznego rdzenia | Górna granica |
|---|---:|
| Rundy / testy terminalności | 1 949 903 559 601 555 |
| Cykle producentów | 28 727 929 143 609 709 815 |
| Przejścia konsumenta / zapisy target | 62 396 913 907 249 760 |

To bardzo luźne ograniczenia strukturalne; nie są pomiarem, sekundami,
liczbą wszystkich operacji bitowych ani deklaracją praktycznej wydajności.
Nawet liczba dwóch przejść na cykl nie wycenia arytmetyki Word512 wewnątrz
execute. Żaden ogromny pełny przebieg ani taśma nie były uruchamiane.

## Granica rachunku i mapa murów

PublicCallCount wykonuje przygotowanie/parser, startup i odbiór wyjścia,
lecz **jego counts obejmuje wyłącznie wewnętrzny raw core**. W szczególności
nie obejmuje startowego producenta, zerowania/ładowania kodów i portów,
materializacji, finalnego readout ani kopiowania odpowiedzi. Nie wolno
odczytywać `public_bounds` jako boundu całego czasu wywołania.

| Obowiązek | Stan po E13 |
|---|---|
| Pełne publiczne wywołanie / EveryTape / pełne J/P | Poprzedni E12; bez zmiany(M) i referencji |
| Liczniki rzeczywistego producenta i konsumenta | **KERNEL**, z erasure i porażkami |
| Złożenie liczników rdzenia do całego publicznego wywołania | **KERNEL**, dokładny zakres inner core |
| Cena każdej instrukcji/dekodowania/sterowania w modelu prymitywów | **OPEN — następny krok rachunku czasu** |
| Ładowanie kodów, preparation, startup, parser, readout/kopie | OPEN, w tym wariancie niewycenione |
| Wspólne regiony, scratch, okresy życia i pełny peak | **OPEN**, licznik nie jest certyfikatem alokacji |
| Jednolity backend fill/parser | OPEN, wybrany E12 pozostaje modelem mieszanym |
| Źródłowe(M) na prawie kluczy, KeyGen/Sign/PRG, redukcja QROM | OPEN, bez zmian |

(M) nie jest użyte w dowodach liczników. E13 nie dodaje nowego certyfikatu
J/P: zachowuje punktowo wynik E12. Historyczny moment `1+2^-47` pozostaje
pod dokładnie wcześniejszym(M); nie zastępujemy tego warunku ceną wykonania,
TV lub testem skończonym. Nie ma nowej deklaracji bezpieczeństwa.

Następna kontynuacja E6-FULL-RESOURCES: przypisać ceny odczytom, zapisom,
arytmetyce, dekodowaniu i sterowaniu **tego samego wykonania**, z jawnie
przechowywanym scratch. Następnie złożyć wspólne okresy życia obu producentów
i konsumenta oraz wszystkie pozostałe fazy E12. Można konserwatywnie liczyć
kopie; nie wolno zakładać bez dowodu współdzielenia pamięci lub darmowego load.
Alternatywa śladów regionów pozostaje otwarta dla części pamięciowej.
Nie uznano pełnego programu zasobów za ukończony.

## Kontrole i historia prób

**16 modułów wynikowych,68 twierdzeń, audyt93 eksportów,797 pinów.**
17 końcowych logów Lean (moduły i audyt) jest czystych: exit/warning/error=0.
Aksjomaty: wyłącznie propext, Classical.choice, Quot.sound. Bez sorry/admit,
nowych aksjomatów, native_decide/bv_decide lub wyciszania linterów.

Zachowano **37 uruchomień Lean**:17 końcowych czystych,6 czystych diagnostycznych
prefiksów i14 nieudanych. Osiem nieudanych to kontrolowane przerwania
interpretera na limicie4096MiB. Bezpośrednia specjalizacja/redukcja dużych
wyrażeń w sterowniku i wrapperze wymagała ogólnych lematów funkcji/gałęzi.
Zmniejszanie prefiksu lokalizowało miejsce problemu; te próby nie były
instalowane ani przedstawiane jako kompletny dowód. Pozostałe błędy dotyczyły
składni, typów zależnych i simplifikacji. Jeden nieudany run miał dodatkowo
ostrzeżenie o zbędnym argumencie simp; końcowy plik ma czysty log.
Nie wykryto kontrprzykładu matematycznego.

Sage: jedno świeże uruchomienie przez standardowy preparser, exact ZZ,
manifest v2 sprawdzony walidatorem. Wynik dotyczy wyłącznie skończonego
rachunku stałych; uniwersalna indukcja pochodzi z Lean. Limity: jeden rdzeń,
Sage2GiB/CPU60s/wall120s; Lean4GiB/AS8GiB jak wcześniej. Kompilacja i Sage
działały kolejno. RSS kompilatora nie jest pamięcią samplera.

[CHECKS](EXECUTION_COUNTS_020E13_CHECKS.json),
[self-review autora](EXECUTION_COUNTS_020E13_SELF_REVIEW.md),
[klasy warunków](CERTIFICATE_CLASSES_020E13.json),
[kolejka](KERNEL_QUEUE_020E13.json).
Brak niezależnego odbioru. OUTPUTS pomija żywy README; RUNTIME zamraża stan
przy freeze. Późniejszy plan/receipt commita dokumentów i POSTCOMMIT są
operacyjnymi dopiskami poza manifestem. Próby historyczne pozostają nienaruszone.
