# Pamięć Lean020B — zmierzona przyczyna i nowy limit

Zakres: osiem własnych, kolejnych prób kompilatora na tym hoście. To pomiar
narzędzia dowodowego, **nie koszt wykonania samplera**, nie nowy bound Q-RESC.
Surowe polecenia, snapshoty źródeł, logi, statystyki i mapy procesu wiąże
[JSON](LEAN_MEMORY_020B.json) oraz manifest runtime020B.

Właściciel2026-10-11 polecił zwiększyć limit i zmapować zużycie. Nowy runner
[BUILD_LOOP_REFINEMENT_020B.py](BUILD_LOOP_REFINEMENT_020B.py) używa
Lean `-M6144`, AS10GiB, jednego rdzenia/procesu, CPU110s i wall600s.
Przed startem wymaga7GiB MemAvailable. Profiler dodatkowo kończy wyłącznie
własny proces, jeśli MemAvailable spadnie poniżej2GiB. Historyczny runner
020A i receipty4GiB pozostają niezmienione. Wszystkie przyjęte dowody020B
przeszły jeszcze przy4GiB; dodatkowy czysty audyt zweryfikował nowy runner6GiB.

| Próba | Szczyt RSS, GiB | Czas ścienny, s | Wynik |
|---|---:|---:|---|
| Sam `Init` | 0,44 | 0,60 | exit0 |
| Sam `Mathlib.Tactic` | 3,13 | 1,72 | exit0 |
| Sam `ReadSemantics020A` | 3,13 | 1,71 | exit0 |
| Sam `StandaloneRuntime019` | 2,32 | 1,50 | exit0 |
| Sam `PairCompose020B` | 3,74 | 1,93 | exit0 |
| Dawny szeroki `pair001`, teraz6GiB | 6,00 | 446,46 | kernel memory error |
| Obecny `PairCorrect020B` | 3,76 | 4,05 | exit0, czysty log |
| Rdzeń020 z zawężonymi importami | 1,61 | 11,88 | exit0, czysty log |

**Dwa odrębne źródła kosztu.** Szeroki zestaw taktyk kosztuje dużo jeszcze
przed naszym dowodem. Pełny konsument importuje według statystyk Lean26795
jednostek i4555667928 bajtów; bajty importów nie są tym samym co RSS ani
pamięcią prywatną. Mapy rozdzielają Mathlib, Lean/Init/Std, biblioteki,
artefakty projektu oraz pamięć anonimową. Wzrost w starej próbie pojawia się
także w pamięci anonimowej podczas sprawdzania dużego termu.

Profiler starej próby podał442s `type checking` (w tym440s przy deklaracji
`pair_correct`), a tylko53,7ms `tactic execution`; wynik to jawny błąd kernela
na linii27. W aktualnej wersji `type checking` zajęło2,01ms. Oba programy
mają praktycznie ten sam ciężar importów:4555524136 kontra4555667928 bajtów.
To mocna lokalna przesłanka, że wąskim gardłem był kształt sprawdzanego termu,
nie sama ilość tabel ani wykonywanie taktyk. Nie mamy śladu każdej redukcji
kernela, więc nie przypisujemy całego wzrostu jednej konkretnej redukcji.

Naprawa: lekki lemat pętli, osobne złożenie sufiksu oraz `pair_of_result`
z **nazwanym dowolnym wynikiem z**. Końcowy `pair_correct` wypełnia równość
tego wyniku przez `rfl`; nie dodaje założenia o poprawności rzeczywistego
samplera. Nie zmieniono modelu, algorytmu, capów, praw ani aksjomatów.
Podniesienie limitu samo nie uratowało starego termu; poprawiona wersja
została sprawdzona, a nie pozostawiona jako kolejna hipoteza.

**Mapa importów projektu.** Przejście po przypiętych źródłach konsumenta
obejmuje391 modułów projektu i dwa bezpośrednie `import Mathlib.Tactic`:

- `WordRAM020`: przez `ReadSemantics020A → PairProgram020`.
- `RootMoments014`: przez `ActualCoordinate020A → InputLayout020 →
  WordBounds018 → StoredInterface018`, dalej certyfikat017/016/015 i
  harmoniczną014. Pełna przykładowa ścieżka jest w JSON.

Same literały tabel nie wyjaśniają kilku GiB. Ich rozmiary plików nie są
jednak pomiarem wszystkich obiektów powstałych podczas sprawdzania termu.
`StandaloneRuntime019` ma inne importy niż pełny konsument: jego2,32GiB
nie wolno traktować jako przyrostu „ceny samych tabel”.

Kontrola zawężonych importów zastąpiła tylko `Mathlib.Tactic` w kopii
`WordRAM020` przez `Linarith`, `NormNum` i `Lean.Elab.Tactic.Omega`.
Generator sprawdza pin źródła oraz identyczność całego tekstu po importach.
Wszystkie oryginalne definicje i dowody rdzenia przeszły. Ta kopia jest
diagnostyką, **nie podmienioną zależnością**: stary rdzeń i closure zachowują
piny. Dalsze odchudzanie powinno objąć oba miejsca importów oraz wydzielenie
szerokości tabel od pełnego certyfikatu; wymaga osobnego kontrolowanego
sprawdzenia zależności. Nie zmieniamy przy tym źródeł T12.1.

Granice pomiaru: RSS zawiera strony plików, które mogą być współdzielone;
wybrane `smaps` są próbkami i nie muszą sumować się do szczytu RUSAGE.
Czasy obejmują I/O i stan cache, nie są benchmarkiem CPU. Najniższe
MemAvailable w szerokiej próbie wyniosło około7,28GiB; guard presji pamięci
nie zatrzymał żadnej próby. Nie podnosiliśmy limitu ponad6GiB.
