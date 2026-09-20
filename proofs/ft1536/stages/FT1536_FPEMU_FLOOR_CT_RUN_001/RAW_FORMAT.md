# Format i odtwarzanie pełnych strumieni

Każdy `timing/r{r}_c{case}_{variant}/STREAMS.json` opisuje stdout, stderr oraz
gzip surowych timingów: całkowite bytes/SHA-256 i uporządkowane `parts` z
relatywnymi nazwami, rozmiarami i hashami. Część ma najwyżej33554432 bytes.
Konkatenacja części w zadanej kolejności daje dokładny oryginalny strumień;
nie ma subsamplingu. `scripts/streams.py:open_stream` sprawdza każdą część
i pełny hash przy dojściu do EOF, bez materializowania dużego pliku.
`evidence_integrity.py` odczytuje wszystkie strumienie do EOF.

Po gzip: `FTDUD01\n` (8 bytes), potem kolejne frames w little-endian LP64
przypiętego x86_64. Frame zawiera trzy uint64: batch_size=100000, batch ordinal
rosnący od1, public generator state przed batch. Następnie100000 bajtów klas
oraz100000 int64 timing deltas. Ostatni delta slot jest0, upstream go pomija.
Pierwszy batch wyznacza percentiles; następne wywołują niezmienione oficjalne
update_statistics/report. Public order per trial i stan per frame zachowano.
Pełna definicja jest w przypiętym `harness/benchmark.c:133–153,191–204`.

`scripts/raw_replay.py` przekazuje zdekompresowany strumień do świeżo zbudowanego
oficjalnego executable `--replay`. Dla KAŻDEGO batch porównuje całe JSON
FT1536_BATCH: ordinal, state, max_index/max_t, n, percentiles i102 test tuples
(n0,n1,mean0,mean1,m2_0,m2_1,t). Canonical aggregate state hash oraz pełne
replay stdout/stderr/receipt zachowano. Rekalkulacja nie wywołuje timed target.
Równość statystyk to ten sam silnik, nie niezależna metoda statystyczna.

Nowe A/B:30 trials,90 strumieni,105 części,948531594 bytes,9771 batches.
Bootstrap:12 dostępnych historycznych raw streams/24 batches. Zewnętrzne raw
negative controls i27 pozostałych historycznych prób nie są częścią pakietu.
Raw/state arrays, stop reasons, public orders, machine snapshots i failed
attempts pozostają w OUTPUTS. Robocze niesplitowane kopie w tmp są wyłączone,
ponieważ wszystkie ich bajty są reprezentowane przez sprawdzone parts.
