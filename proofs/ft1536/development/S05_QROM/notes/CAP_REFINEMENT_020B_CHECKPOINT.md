# TODO020 / continuation020B — kernelowy cap80 i cała instrukcja pair

Status: **PARTIAL_KERNEL_WHOLE_PAIR__WARUNKOWY__NOT_REVIEWED**.
To zamknięty podetap TODO020, nie zakończenie EveryTape ani dowód
bezpieczeństwa FT1536 w QROM. Źródła na main, bez push/importu/tagu.
Początkowy HEAD51ddda5e. Małe commity:07f1d9c9 (cap/fallback),
9fe4664b (pełny pair i audyt). Piny końcowych plików: manifest020B.

## Co rzeczywiście wykazano

**42 nazwane eksporty,11 modułów dowodowych i pełny audyt eksportów.**
Nowy ogólny lemat pierwszego sukcesu nie importuje tabel019. Jego przesłankę
kroku wypełnia `ActualCap020B.actual_step` z istniejącego
`TrialCorrect020A.trial_correct`, dla rzeczywistych tablic i bitów taśmy.
`CapDraw020B.draw_correct` obejmuje80 odrzuceń, zatrzymanie po sukcesie
oraz zerowy fallback, a jego wynik jest dokładnie zakodowaną parą019.

Końcowe zdanie `PairCorrect020B.pair_correct` jest samodzielnym konsumentem:
dla dowolnego publicznego h, taśmy wymaganej długości, stanu s, indeksu
zewnętrznego n<196, indeksu pary p<1536 oraz liczby całkowitej a, jeśli

- rejestry0/1 zawierają n/p, a rejestr16 zawiera dokładnie a;
- 0≤a≤p·(3·65535²),

to **rzeczywista instrukcja `PairProgram020.pair`**:

- daje tę samą parę co019 na segmencie `((n·1536+p)·80+k)·1024`;
- zapisuje obie podpisane współrzędne do RAM[2p] i RAM[2p+1], zachowując
  wszystkie pozostałe komórki;
- zwiększa akumulator dokładnie o x²+xy+y² i licznik pary o1;
- zachowuje wyjście, flagę błędu i wskazane rejestry zewnętrznej pętli.

Podstawowy przedział współrzędnych wynika z typu Fin131071. Osobny
`accumulated_bound` dowodzi nieujemności, następnego liniowego boundu
i reprezentowalności sumy. Dowód arytmetyki obejmuje wszystkie iloczyny
i sumy pośrednie, w tym wyraz mieszany; brak przepełnienia nie jest
dodatkowym założeniem. Porażka wszystkich prób nie zostaje pominięta.
Nie zakładamy, że początkowa flaga błędu jest false: dowodzimy jej zachowania.

Nazwanie wyniku przez z w `pair_of_result` jest techniką budowy termu.
Końcowy `pair_correct` wypełnia jego równość przez refleksywność; żaden
certyfikat rzeczywistej próby ani poprawność sufiksu nie pozostają wejściem.

## Kontrola i zachowana historia

Własny audyt wszystkich42 eksportów jest czysty:41 list aksjomatów
zawiera wyłącznie propext/Classical.choice/Quot.sound, jeden eksport
nie zależy od aksjomatów. To kontrola autora, nie niezależny odbiór.
Nie dodano `sorry`, aksjomatów, natywnych decyzji ani wyciszania linterów.
Nie powtarzano obcych replayów ani skończonych kontroli Sage: nowe zdania
są dowodami kernelowymi; stałe i rachunek probabilistyczny nie zmieniły się.

Zachowano wszystkie świeże snapshoty, logi i receipty, w tym poprawki
elaboracji, ostrzeżenia oraz trzy nieudane szerokie próby `pair` przy4GiB.
Po poleceniu właściciela zwiększono limit do6GiB i wykonano osiem
diagnostyk: stary szeroki term nie przeszedł także przy6GiB; obecny
przeszedł. [Mapa pamięci i ograniczenia pomiarów](LEAN_MEMORY_020B.md).
Dokładne etykiety i liczniki podaje CHECKS.json; niczego nie usunięto
z wcześniejszego020A. Każdy build i profiler działał pojedynczo.

## Mapa murów po tym kroku

| Obowiązek / klasa | Stan |
|---|---|
| Q-SAMPLER: matematyczne J≪P, moment pod(M) | Kernelowy certyfikat017/019 zachowany, e=2^-47 |
| Q-SAMPLER/Q-RESC: czytnik, CDF, pojedyncza próba | Kernel020A, rzeczywiste tablice i oba wyniki |
| Q-SAMPLER/Q-RESC: cap80/fallback/cały pair | Kernel020B, jawny niezmiennik wejściowy licznika i sumy |
| Q-SAMPLER/Q-RESC: wektor1536, cap196, cube | OPEN; następny podetap020C |
| Q-SAMPLER/Q-RESC: scatter, serializacja, EveryTape | OPEN; moment nie został jeszcze przeniesiony na całą maszynę |
| Q-RESC: driver, pełna pamięć/czas | OPEN; bound rdzenia020 i pomiar Lean nie wystarczają |
| Q-KEY/Q-BIND: to samo emitowane h/prawo kluczy, źródłowe(M) | OPEN; nie konsumowano nowych commitów ROM w tym kroku |
| Q-BIND/Q-PRG: rzeczywiste Sign, wariant A, PRG | OPEN; rozdział obowiązku hopu i założenia primitive-bound zachowany |
| Q-HASH-LOG/Q-EMBED/Q-COLL/Q-COMPOSE | OPEN; quantum reprogramming i pełna kompozycja strat osobno |

Model słowa512bit i cen instrukcji pozostaje jawnie MODELEM; A-QMT oraz
Q-PRG primitive-bound pozostają założeniami kryptograficznymi. Nowe lematy
są OBOWIĄZKAMI DOWODOWYMI, nie nowymi założeniami. Nie zmieniono(M),
kierunku J/P, nonce320, prawa porażek ani D=(1+e)^q_s−1. Kwantowe użycie
D nadal wymaga jawnych przesłanek kompozycji.

## Następny duży TODO020C

1. Lekka indukcja po1536 parach, z RAM-prefix i dokładną sumą q2; krok
   wypełniony przez `pair_correct`, nie przez nowy wolny certyfikat.
2. Jawna zgodność segmentów z `vectorSeedEquiv`019 i kolejnością768+768;
   następnie suma q2 = Q(decode(view vector)).
3. Rzeczywisty `normTrial`, gałąź przy B=2093922385 i licznik zewnętrzny.
4. Cap196 z tą samą regułą zatrzymania i świeży cube z suffixu taśmy;
   oba wyniki i no-fault pod pierwotnym initial.
5. Osobna kontrolowana optymalizacja importów tam, gdzie jest potrzebna;
   domyślny limit6GiB, jeden proces. Nie podmieniamy starych pinów w ciszy.

Monitor ROM pozostaje PAUSED. Statusy T12.1/B20, paper, strona i główny
kod C są poza zakresem i nie zostały zmienione.
