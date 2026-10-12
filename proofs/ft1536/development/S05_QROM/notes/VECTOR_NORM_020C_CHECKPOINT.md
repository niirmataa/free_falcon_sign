# TODO020 / continuation020C — cały select zgodny z019

Status: **KERNEL_SELECT_REFINEMENT__PARENT020_OPEN__WARUNKOWY__NOT_REVIEWED**.
Data:2026-10-12. Rozwinięcie S05/ROADMAP, z bazy a60fa2e1 i niezmienionych
wejść020B. Własna kontrola autora, bez niezależnego odbioru lub deklaracji
bezpieczeństwa FT1536 w QROM. Bez push/importu/tagu.

## Co domknięto

**115 nazwanych eksportów,28 modułów dowodowych i jeden audyt całości.**
Domknięta jest oryginalna instrukcja `PairProgram020.select`: cap80
w każdej parze,1536 par, ścisła norma, cap196 i świeży cube. Program020
oraz referencja019 pozostały niezmienione.

Dla dowolnego publicznego h, dowolnej taśmy24662538240 bitów i dowolnego
stanu s, wynik wykonania `select` na publicznym obrazie wejścia spełnia:

1. Wszystkie3072 słowa RAM tworzące1536 par są dokładnym obrazem wektora
   `StandaloneRuntime019.selected tables (seedEquiv tape)`.
2. Flaga błędu, wyjście i komórki RAM o indeksach≥3072 są zachowane.
3. Koszt tej samej instrukcji jest≤`WordRAM020.bound select` w jawnym
   modelu słowa512bit. To nie koszt CPU ani pełny bound pamięci/drivera.

Końcowe eksporty:

- `ActualSelect020C.select_correct` i `no_new_fault`;
- `SelectionBoundary020C.refinement_with_cost`;
- `SelectionBoundary020C.public_initial`: ten sam wynik, brak błędu
  i bound kosztu przy publicznym `initial`;
- `SelectionBoundary020C.fresh_cube_after_norm`: każdy bit cube leży
  ściśle za każdym bitem zarezerwowanym dla wszystkich prób normy.

Twierdzenia końcowe nie przyjmują poprawności kroku, zgodności układu taśmy,
normy ani cube jako wolnych przesłanek. Nie wymagają(M), bo są równościami
deterministycznego wykonania. **Nie wyprowadzają z tego(M) dla każdego h
ani bezwarunkowego momentu.** Certyfikat J/P017/019 nadal ma dokładnie
wcześniejsze założenia i odniesienie.

## Jak złożono dowód

| Warstwa | Wypełniony obowiązek |
|---|---|
| CountedLoop/VectorPrefix | Indukcja, prefix RAM i dokładna częściowa suma q2; niezmieniona reszta pamięci |
| VectorValues/VectorLoop | Każdy krok pochodzi z rzeczywistego pair020B; pełne1536 iteracji |
| TapeIndex/SeedSlices/MachineCoins | Faktyczna kolejność chunks,80 prób i podział768+768 zgodne z seedEquiv019 |
| VectorNorm/ActualVector/BoxImage | Akumulator jest dokładnie Q(decode(view vector)); RAM koduje ten sam wektor |
| NormFinish/NormResponse/ActualNormTrial | Ścisłe `< B`, akceptacja i odrzucenie, licznik i ramki stanu |
| NormSource/NormCap | Pierwsza zaakceptowana próba spośród196 lub pełne wyczerpanie |
| CubeRead/CubeStep/CubeLoop/CubeBinding | Dwa świeże10-bitowe odczyty na parę, przesunięcie−512,1536 par i właściwy suffix019 |
| SelectFinish/ActualSelect | Obie gałęzie oryginalnego select oraz publiczny initial |

Granica wyniku jest jawna: `BoxImage020C.readVec` odczytuje pary słów
z RAM, a `image` koduje dwie tablice po768 par referencji. Nie twierdzimy
jeszcze zgodności całego bitowego wyjścia samplera. Wewnętrzny `answer`
oparty na fladze20 służy do opisu cap196; po wykonaniu cube wynik całego
select opisuje `readVec`, nie ten wewnętrzny znacznik akceptacji normy.

Rozszerzenie `NormSource.source` poza indeks195 jest tylko całkowitą
specyfikacją pomocniczą. Budget n+count≤196 i `source_first` dowodzą,
że cap używa dokładnie prawidłowych indeksów0…195; nie zmienia to prawa
referencyjnego ani nie dodaje kolejnej próby.

## Weryfikacja i historia prób

- 41 wywołań Lean zachowanych;29 końcowych czystych buildów, w tym audyt.
- 12 nieudanych/nieczystych prób pozostaje w runtime z osobnymi snapshotami
  i receiptami. Trzy trafiły w limit pamięci kernela podczas składania
  termów; pozostałe ujawniły błędy zapisu lub elaboracji.
- `image001` miał błąd parsera oraz wtórne komunikaty o wygenerowanym
  przez elaborator `sorry`. Nie był instalowany ani używany jako dowód.
  Przyjęty `image002` i cały końcowy audyt są czyste.
- Wszystkie115 eksportów objęto `#check` i `#print axioms`:113 list
  standard-only {propext,Classical.choice,Quot.sound},2 axiom-free.
- Nie dodano aksjomatów, `sorry`, native_decide/bv_decide ani wyciszeń
  linterów do przyjętych źródeł. Zapisany audyt nie jest niezależną recenzją.
- Nowych przybliżeń ani tabel probabilistycznych nie ma. Nie wykonywano
  nowych skończonych testów Sage: nowe tożsamości i nierówności są dowodami
  kernelowymi dla wszystkich wskazanych argumentów.
- 31 pinów wyników i237 runtime020B sprawdzono na wejściu; poprzednie
  manifesty i zaakceptowane źródła pozostają nienaruszone.

Ważna naprawa konstrukcji termu: zamknięcie resetu i pętli wykonano dla
symbolicznej liczby iteracji, a dopiero potem podstawiono1536. Kompozycję
sekwencji oparto na ogólnym `seqs_append`, zamiast wymuszać rozwinięcie
dużego interpretera. Nie zmieniono semantyki programu ani limitu kompilatora.

Małe commity: `ded2b9ac` (wektor/prefix), `e1906521` (019/norma/cap196),
`9f319a27` (cube/select/audyt). Receipty i piny końcowe: CHECKS, OUTPUTS
i RUNTIME020C. Źródła kompilowane pojedynczo z przypiętymi zależnościami.

## Mapa murów i klasy

| Warunek | Klasa i stan |
|---|---|
| Q-SAMPLER: moment i pełne J≪P017/019 | Obowiązek, kernel pod niezmienionym(M), e=2^-47 |
| Q-SAMPLER/Q-RESC: część select maszyny020 | Obowiązek, kernel020C z wypełnionymi instancjami |
| Q-SAMPLER/Q-RESC: scatter i wyjście | Obowiązek, OPEN; następny020D |
| EveryTape całego programu i transport pełnego J/P | Obowiązek, OPEN; wynik select nie zamyka całego programu |
| Pełny driver, koszt wejścia/wyjścia i szczyt pamięci | Obowiązek Q-RESC, OPEN |
| Słowo512bit, banki i jednostkowe ceny instrukcji | MODEL, jawnie zachowany |
| Emitted KeyGen, to samo h/prawo kluczy oraz źródłowe(M) | Obowiązki Q-KEY/Q-BIND, OPEN |
| Rzeczywiste Sign, wariant A i konkretny hop PRG | Obowiązki Q-BIND/Q-PRG, OPEN |
| A-QMT oraz primitive-bound Q-PRG | Założenia kryptograficzne, bez zmian |
| Log/reprogramowanie, embedding, kolizje i kompozycja QROM | Obowiązki kwantowe, OPEN; nie jest to pełna lista kontraktu |

Nie zmieniono nonce320, capów, kierunku J/P, D=(1+e)^q_s−1 ani warunków
kwantowego użycia kompozycji. Statusy T12.1/B20 oraz paper/mainline są
nienaruszone. Nowych wyników ROM nie konsumowano w tym kroku.

## Następny duży TODO020D

1. Powiązać interleaved RAM i funkcję exponent z indeksami referencji;
   dokładnie odkodować słowa podpisane oraz reszty modulo18433.
2. Skernelizować czyszczenie bufora, pojedynczy scatterTerm i obie pętle
   mnożenia, z wszystkimi trzema gałęziami redukcji wykładnika.
3. Skernelizować emitWord i pełne emitPair50689bit, z rozliczeniem
   obecności odpowiedzi, kolejności współczynników i signed+65535.
4. Złożyć select→multiply→emitPair w EveryTape do publicCode019 oraz
   brak błędnego adresowania; dopiero wtedy transportować pełne prawo J/P.
5. Zachować osobno otwarty driver i pełne zasoby; nie zamieniać boundu
   instrukcji rdzenia na pełny koszt wykonania ani deklarację QROM.
