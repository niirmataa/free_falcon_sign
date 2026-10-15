# TODO020E12 — pełne publiczne wywołanie, EveryTape i J/P

Baza: `1557890a252d137842a5da81a133111e07e99406` (E11).
Runtime: `.build/pair_machine_020/public_call_001/`.
Jedno okno, jeden ciężki proces; lokalny main, bez push. Monitor ROM PAUSED.

Cel: konkretny publiczny pipeline przygotowania/parsera/startu, gotowego
surowego rdzenia E11 i pełnego odbioru odpowiedzi. Wykazać równość z dawnym
wywołaniem dla każdego rezydentnego publicznego Data i taśmy, następnie
EveryTape dla przypiętego programu/prepared key oraz pełne J/P pod dokładnie
tym samym MassCondition(M), z publicznym initial i tym samym prawem kluczy.
Bez założenia zgodności wywołania i bez zawężenia do udanych odpowiedzi.

Wybrana droga modelowa jest jawna: wykorzystywane są konkretne, skończone
pętle E5 FillMachine i IndexedParser, z przypiętymi dowodami; ich wykonanie
nie jest dostarczanym orakulum. Kodowania portów powstają przez jawny fill.
Nowy stały producent startowy w IR E6 i sprawdzany konsument E11 ustawiają
ramkę wejściową oraz limit na wyzerowanym rdzeniu. Następnie runtime E11
pracuje na surowej pamięci; końcowe wyjście jest materializowane pętlą.

To domknięcie publicznego wywołania w tym złożonym modelu. Jednolita kompilacja
fill/parser do backendu poleceń, wspólny ślad alokacji, pełny czas/peak i native
pozostają osobnymi zadaniami; nie oznaczać ich jako wykazane przez sam transport
prawa. Publiczne tabele/kod nadal są przypiętymi rezydentnymi wejściami.

1. Materializacja i konkretne porty przygotowania; cursor/parse failures.
2. Publiczny reset, stały producent startowy, uruchomienie i zgodność initial.
3. Całe wywołanie, dwa poziomy porażek i pełna odpowiedź; EveryTape.
4. Prawo dla tego samego h i joint dla tego samego mu; AC i drugi moment
   pod starym(M), bez poprawiania nierówności lub pokrycia kluczy założeniem.
5. Kontrola autora/aksjomatów/pinów/logów, checkpoint i mapa murów.
