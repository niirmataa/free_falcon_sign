# TODO020E / continuation002 — całe wykonanie z tablicy węzłów

**KERNEL_SCOPED_DIRECT_EXECUTION / PARENT020E_IN_PROGRESS / WARUNKOWY / NOT_REVIEWED.**
Data2026-10-13. Baza21aabee4945d62da958c511a216f4d09ace2ee50.
Rozwinięcie S05/ROADMAP. Domknięto semantykę całego wykonania z tablicy;
pełne Q-RESC i bezpieczeństwo FT1536 w QROM pozostają OPEN.

## Co mamy

**Nowy wykonawca korzysta bezpośrednio z tablicy węzłów.** Odczytuje adresy
dzieci, wykonuje atomy, sekwencje, rozgałęzienia i pętle. Tablica kodu pozostaje
niezmienna. Kontynuacja pętli zawiera adres i licznik, bez tworzenia nowych
węzłów Code. Pomocnicze Meaning i źródłowy AST występują w dowodzie zgodności.

`NodeExecute020E2.correct` daje dokładną równość ze starym interpreterem
dla każdego wejścia, stanu i limitu kroków, również przy wyczerpaniu limitu.
`NodeProgram020E2.built_correct` wiąże to z rzeczywistym parserem.
**Instancja877 jest wypełniona:** `actual_correct` oraz `on_actual_arena`
dowodzą wykonania oryginalnego PairProgram020.program do dokładnie tego samego
stanu końcowego. Jawny limit1106642201817 wystarcza na przejścia sterowania.
Nie jest to nowy pełny bound czasu samplera.

`every_state` obejmuje każde publiczne h, każdą pełną taśmę i każdy stan.
Z publicznego initial wynik nie ma fault, a pełne wyjście jest dokładnie019.
`NodeDriver020E2` zachowuje jawne kopie wejścia/reset/transfer020E. Jego
Option fallback jest nieosiągalny, co wykazano dla każdej taśmy.

**Pełne prawo i porażki samplera są zachowane.** `NodeCertificate020E2`
przenosi J≪P dla każdego h, moment≤1+2^-47 pod dokładnie tym samym(M),
a także wynik dla tego samego pokrytego prawa kluczy. Nie podmieniono P,
nie pominięto porażek, nie dodano historii kwantowych zapytań. Błędy
interpretera i porażki zakodowane w prawie samplera są odrębnymi pojęciami.

## Granica tego checkpointu

Sterowanie używa jeszcze **listy ramek**, a evaluator wyrażeń jest
rekurencyjny. Pojedyncza ramka ma skończone pola adres/licznik; to samo
nie dowodzi realizacji całego stosu w banku o ustalonej pojemności.
Skończone banki ramek/wartości i ich zasoby pozostają kolejnym krokiem.

Brakuje pełnej ceny odczytów, zapisów, dispatch, arytmetyki, producenta
obrazu/losowości, inicjalizacji, scratch i współistniejącej pamięci.
Historyczne5264 słowa opisują tylko trwałą arenę parsera. Czas/RSS w nowych
receipcie opisują kompilację Lean; nie są pomiarem wykonania samplera.

Pozostają źródłowe pokrycie(M) całym prawem KeyGen, powiązanie rzeczywistego
Sign/PRG, kompozycja z naprawioną grą wariantu A oraz mechanizmy kwantowe.
Ten checkpoint zachowuje przypięte środowisko legacy i nie konsumuje
nowych wyników ROM. Nie jest jeszcze deklaracją bezpieczeństwa w QROM.

## Weryfikacja i piny

**37 nowych twierdzeń;14 modułów i jeden audyt.**15 końcowych czystych
buildów Lean,29 prób kompilacji,14 nieczystych/nieudanych zachowanych.
Osobno zachowany preflight odrzucony przed uruchomieniem Lean. Wszystkie37
list zależności aksjomatycznych są podzbiorami {propext, Classical.choice,
Quot.sound}. Brak nowych aksjomatów, sorry, native_decide/bv_decide lub
wyciszeń linterów w przyjętych źródłach. To kontrola autora, bez niezależnego
odbioru Daybreak.

Ponownie sprawdzono28 pinów wyników i173 runtime020E1, a także539 źródeł
oraz artefaktów końcowej biblioteki. Każda próba ma snapshot i stdout/stderr.
Driver002/003 osiągnęły limit pamięci przy redukcji zamkniętego programu;
ogólny lemat observe umożliwił czysty driver004 przy tym samym limicie4GiB.
Nie była to zmiana tezy ani kontrprzykład. Pozostałe szczegóły i koszty
kompilacji: NODE_EXECUTION_020E2_CHECKS.json i SELF_REVIEW.

Commity źródeł: `a824f625def20e6a9fe038b9d1509a4114b4e5a2` oraz
`ecdac3d01e7fbad042e156be27b9e98df60293c2`.
Manifesty NODE_EXECUTION_020E2_OUTPUTS.sha256 i RUNTIME.sha256 pinują wyniki
oraz historię runtime `.build/pair_machine_020/node_execution_001/`.
Bez push/importu/tagu i bez zmiany statusów T12.1/B20/paperu przez tę pracę.

## Mapa murów

| Warunek | Klasa i stan |
|---|---|
| Bezpośrednie wyrażenia/atomy/seq/branch/loop | Obowiązek Q-RESC, KERNEL CLOSED scoped |
| Całe wykonanie i rzeczywista instancja877 | Obowiązek Q-RESC/Q-SAMPLER, KERNEL CLOSED scoped |
| Publiczny initial, pełne wyjście, J/P pod tym samym(M) | Obowiązek, KERNEL zachowany i przeniesiony |
| Skończony bank ramek/wartości i realizacja rekurencji | Obowiązek Q-RESC, OPEN — następny krok |
| Pełny czas, inicjalizacja, scratch i peak | Obowiązek Q-RESC, OPEN |
| Emisja kluczy/pokrycie(M), source Sign/PRG, wariant A | Obowiązki źródłowe i gry, OPEN |
| A-QMT i primitive-bound Q-PRG | Założenia kryptograficzne, bez zmian |
| Log/reprogramowanie, embedding, kolizje i kompozycja QROM | Obowiązki kwantowe, OPEN |

Następny zakres: RESOURCES_020E_CONTINUATION_003.md. Kolejka i klasy:
KERNEL_QUEUE_020E2.json oraz CERTIFICATE_CLASSES_020E2.json.
Nonce320, e=2^-47 i D=(1+e)^q_s−1 pozostają bez zmian.
