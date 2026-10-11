# S05 / TODO020 — wykonanie maszyny pary

Status: IN_PROGRESS, WARUNKOWY, NOT_REVIEWED. Cel i kryteria pozostają
w TODO_PAIR_MACHINE_020.md. Baza wejścia835dfc6b; kod019 przypięty przez
PAIR_MACHINE_020_INPUTS.json. Jedyny wykonawca tego kroku: bieżąca sesja.
Własny runtime `.build/pair_machine_020`, bez cudzych workerów/replayów.

Trasy rozważone:

1. Zamknięty program w RAM o słowie512bit. Rozdzielone skończone banki,
   jawna składnia instrukcji, płatne wyrażenia i sterowanie. Najpierw
   interpreter i uniwersalny bound, następnie konkretne pętle samplera,
   następnie refinement. Dyskryminator: instrukcje nie przyjmują dowolnej
   funkcji matematycznej jako darmowego oracle, a koszt wynika ze składni.
   Wybrana trasa; granica modelu RAM musi pozostać jawna.
2. Kompilacja przez istniejące bitowe procedury ROM. BitArithmetic,
   WordEncoding, NormMachine i PolynomialMachine dostarczają lokalnych
   dowodów; ten ostatni realizuje jednak inne, znacznie wolniejsze pętle.
   Samo przyłożenie jego ceny do scatter019 byłoby błędem. Pozostaje
   alternatywą kalibracji pojedynczych operacji512bit, bez importu Games.
3. Pełne drzewo LocalBitCode dla skończonej funkcji. Daje formalną
   realizowalność, lecz rozwinięcie po24662538240bitach nie daje użytecznego
   samplera ani uczciwego boundu pamięci. Odrzucone jako świadek tego celu;
   nie jest to dowód niemożliwości efektywnej implementacji.

MODEL: jednostkowe512bit operacje arytmetyczne i losowy dostęp do RAM/ROM
oraz prywatnej, niezmiennej taśmy bitowej. Nie utożsamiać z czasem C/CPU,
liczbą bramek ani bezpieczeństwem PRG. Ładowanie obrazu i taśmy osobno.
OBOWIĄZKI: program, każda taśma, brak błędu adresowania/overflow w stanach
osiągalnych, encoder/decoder, pełny koszt i późniejsze source binding.

Sekwencja pracy: semantyka → rzeczywisty program → bound całego programu
→ lokalne lematy danych/refinement → pełne sklejenie do019 → audyt.
Nie oznaczać celu020 jako zamkniętego na podstawie pierwszych czterech
kroków. Zachowywać każde nieudane podejście z jego source snapshotem.

## Checkpoint020

81 eksportów kernelowych,43 kontrole Sage, konkretny program i bound rdzenia.
Szczegóły: PAIR_MACHINE_020_CHECKPOINT.md. Status pozostaje IN_PROGRESS;
EveryTape, driver i pełna pamięć OPEN. Następna trasa jest nadal punktami
5–6 TODO020, bez przeskoku do nowego numeru. Próby i porażki zachowane.
