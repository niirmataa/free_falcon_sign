# TODO020E9 — aktywne zapisy clear/scan/push domknięte

**KERNEL_SCOPED / NOT_REVIEWED / WARUNKOWY.** Zlecony zakres clear/scan/push
jest domknięty. Pełna zgodność producenta we wszystkich fazach oraz cały
sampler/QROM nadal pozostają OPEN. Nie nadano niezależnego odbioru.

Baza: `8244a7185b61b0868b36ba4c39970d8aacf4d5e5` (E8).
Źródła: `c934dc4aca05bc05301e948c5adcad903e3cebdd`,
`861af54c080cff42e13994ce8a18551c5ac91d44`.
Runtime: `.build/pair_machine_020/data_equivalence_001/`.
Jedno okno, jeden ciężki proces naraz, lokalny main; bez push. Monitor ROM PAUSED.

## Co rzeczywiście wykazano

Dla **każdego typowanego Data, obu wartości fresh** i każdej fazy
clear/scan/push wszystkie trzy sloty danych rzeczywistego wyniku
`ProducerStored020E6.run` mają właściwy **tag obecności, adres i wartość**.
Bez założenia osiągalności, poprawności programu, sukcesu lub istnienia
wartości skanu. Dowód obejmuje wszystkie dziewięć słów tych slotów.

- `ProducerSweepSlots020E9.clear/scan`: przy cursor<877 są dwa aktywne
  zapisy cache i trzeci pusty slot; przy cursor=877 wszystkie trzy są puste.
  Poprawność pełnej decyzji skanu pochodzi z E8, w tym błędne tagi/opcode,
  rejestry i brakujące argumenty.
- `ProducerPushSlots020E9.data`: przy miejscu na stosie zapisuje trzy słowa
  właściwej ramki. Przy pending=one zapisuje tę ramkę; przy pending=two
  zapisuje drugą. Pusty pending lub pełny stos nie zapisują danych.
- `ProducerDataBoundary020E9.scan_absent/clear_zero`: nieobecna wartość
  oznacza **dwa aktywne zapisy zer**, z prawidłowymi adresami, a nie brak
  polecenia. `sweep_terminal/push_full/push_empty` osobno dowodzą pustych
  slotów. Przy pełnym stosie pending=none przechodzi do check; one/two do bad,
  zgodnie z istniejącym CoreStep i już domkniętym sterowaniem E8.

Złożenie z E8 sterowaniem i pustym ogonem daje więcej niż same pola danych:

`ProducerNonact020E9.executed` dowodzi, że **całe 96 słów** wyjścia
zainstalowanego producenta jest kodowaniem kanonicznego bufora dla każdego
stanu w fazach check/clear/scan/push/done/bad.
`script` konstruuje świadek bufora i dowodzi, że wykonanie tego bufora na
kodowaniu stanu daje dokładnie kodowanie starego `CoreStep.step`.
`ProducerNonactConsumer020E9.unique/execute` zapewniają ten sam efekt dla
każdego bufora, którego kodowanie jest rzeczywistym wyjściem producenta.
Przesłanka konsumenta identyfikuje bufor wejściowy; istnienie i poprawność
świadka zostały oddzielnie udowodnione, nie założone.

## Jawna zmiana drogi dowodu

E8 nie udało się wydobyć listy zapisów gałęzi clear przez redukcję
proof-generated `CoreDataPatch.program`: przeszkodą były transporty
Decidable.rec/Eq.mpr i koszt elaboracji. E9 zachowuje tę historię.

E9 definiuje **wyłącznie na potrzeby dowodu** jawną listę danych, złożoną
z zapisów `CoreFieldPatch.values/frames`. Dowodzi jej efektu i ograniczenia
do trzech zapisów, dołącza 16 zapisów sterowania, a następnie wiąże całe
kodowanie bufora z uruchomionym producentem. `reference_effect` dowodzi
równości efektów z pierwotną referencją E7 na kodowaniu wejściowego stanu.

Nie deklarujemy równości surowych list/banków obu referencji. Nie dodano
nowego kodu do runtime E6, dekodera, list hosta ani niezliczonych alokacji.
Lista kanoniczna ma placeholder [] dla act, lecz **każda teza jej zgodności
ze starym krokiem jawnie wyklucza act**. Nie używać jej jako specyfikacji act.
Cel uniwersalny nadal wymaga tej fazy; dziedzina celu nie została ograniczona.

## Mapa murów i następny krok

| Obowiązek | Stan |
|---|---|
| Wszystkie 96 pól rzeczywistego czytnika | KERNEL, E7 |
| Sterowanie poza act i cała decyzja skanu | KERNEL, E8 |
| Obecność/adres/wartość danych clear/scan/push | **KERNEL, E9 — zakres zlecenia domknięty** |
| Cały wynik producenta i stary efekt w sześciu fazach poza act | **KERNEL, E9** |
| Act: actionOK, edit, pending, sterowanie, dane i odmowy | **OPEN — następny krok** |
| Usunięcie ograniczenia fazy, całe wykonanie, EveryTape/J/P | OPEN |
| Inne rodziny producenta: parser/fill/startup | OPEN |
| Pełny sterownik, życie obu kodów/buforów, czas i peak | OPEN |
| Pokrycie (M), źródłowe KeyGen/Sign/PRG i pozostała redukcja QROM | OPEN, bez zmian |

Następna praca: porównać `FixedAction020E5.action` z actionOK/editTag/
editAddress/editValue/actionPending obwodu E6, osobno dla run i again,
wszystkich modelowanych tokenów, błędnych odczytów, zerowego licznika i
odmowy akcji. Dopiero po tym rozszerzyć kanoniczny efekt o act i złożyć
siedem faz. Nie zastępować brakującej zgodności nową przesłanką.

## Kontrole i granice

**11 modułów wynikowych, 49 twierdzeń, audyt 55 eksportów.** Wszystkie końcowe
logi modułów i audytu są czyste. Sprawdzono 731 pinów źródeł/artefaktów.
Aksjomaty tylko propext/Classical.choice/Quot.sound; bez sorry/admit,
nowych aksjomatów, native_decide/bv_decide i wyciszania linterów.

Zachowano 19 uruchomień: 12 czystych, 7 nieudanych. Przyczyny i receipty
zawiera [CHECKS](DATA_EQUIVALENCE_020E9_CHECKS.json). Nieudana próba slots001
osiągnęła limit heartbeatów przez redukcję konkretnego wyrażenia; izolacja
równości wyjścia i składanie równości kodeka zamknęły slots002 bez zwiększania
limitu pamięci. Pozostałe błędy dotyczyły elaboracji, niejednoznacznych nazw,
składni i ostrzeżeń. Nie znaleziono kontrprzykładu. Nie instalowano błędnych
artefaktów. Limity kompilatora: Lean4096MiB, AS8GiB, jeden rdzeń. To zasoby
kompilacji dowodu, **nie rachunek wykonania samplera**.

[Kontrola autora](DATA_EQUIVALENCE_020E9_SELF_REVIEW.md),
[klasy warunków](CERTIFICATE_CLASSES_020E9.json),
[kolejka](KERNEL_QUEUE_020E9.json). Nie zmieniono J≪P, momentu ani(M),
publicznego initial lub dziedziny h. Nie uzyskano nowego transportu całego
prawa przez producenta, pełnego peak/czasu, source bindingu native ani
deklaracji bezpieczeństwa FT1536 w QROM.

OUTPUTS pomija żywy README. RUNTIME zamraża pliki istniejące przy freeze,
włącznie z próbami nieudanymi; plan/receipt końcowego commita dokumentów
oraz POSTCOMMIT są późniejszymi operacyjnymi dopiskami poza manifestem.
