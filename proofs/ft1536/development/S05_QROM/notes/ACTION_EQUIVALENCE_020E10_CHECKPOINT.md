# TODO020E10 — dispatch act i wszystkie fazy starego kroku

**KERNEL_SCOPED / NOT_REVIEWED / WARUNKOWY.** Zlecony zakres jest domknięty:
pełny dispatch act oraz zgodność pojedynczego kroku producenta we wszystkich
siedmiu fazach. Cały driver samplera, pełne zasoby i QROM nadal OPEN.

Baza: `e8edf9f0b7115d92862c10b9c490d0d8acf1323d` (E9).
Źródła: `12601c3d7c24d330b184399bbea4f7e13032fc3d`,
`d85a08f9d858ee487ed86d7929675c93ac3cdf50`.
Runtime: `.build/pair_machine_020/action_equivalence_001/`.
Jedno okno, jeden ciężki proces naraz; lokalny main, bez push. Monitor ROM PAUSED.

## Główna teza

Dla **każdego typowanego Data i obu wartości fresh**, bez ograniczenia fazy,
bez Inv/reachability, poprawności programu lub sukcesu:

- `ProducerWholeStep020E10.executed`: całe96 słów wyniku zainstalowanego
  `ProducerStored020E6.run d fresh` jest kodowaniem konkretnego bufora.
- `script`: istnieje skonstruowany bufor o tym właśnie kodowaniu, którego
  wykonanie na `image d.core` daje dokładnie
  `image (CoreStep.step d.parser.arena (input d) d.core)`.
- `unique/execute`: każdy bufor o rzeczywistym kodowaniu wyjścia jest tym
  samym buforem i ma ten sam efekt. Przesłanka kodowania konsumenta tylko
  identyfikuje bufor; jego istnienia i poprawności nie przyjęto jako założeń.
- `reference_effect`: efekt zgadza się również z dawną referencją E7 na
  kodowaniu wejściowego stanu.

To usuwa ograniczenie `phase≠act` z E9. Nie jest to procent ukończenia QROM:
zamknięty został konkretny obowiązek zgodności pojedynczego kroku rdzenia.

## Co domknęło act

`ProducerActSource020E10.result` jest dokładnie dawną opcjonalną akcją
FixedAction.action, pobieraną ze szczytu stosu. `ProducerActDecision020E10.correct`
wiąże z nią actionOK, semantycznie aktywne pola Edit oraz wszystkie11 słów
Pending. Obejmuje:

- run i again; wszystkie16 modelowanych tagów i wszystkie payloady Word512;
- sekwencję i rozgałęzienie, w tym brak warunku;
- pętlę z licznikiem zero, brakującym/zerowym/niezerowym warunkiem, poprawnym
  zmniejszeniem licznika oraz odmowę again przekraczającego limit;
- setter, ROM/RAM/tape, store i emit; niepoprawny rejestr/adres i brak argumentu;
- brak ramki lub węzła, token wyrażenia w miejscu polecenia i nieobsługiwany tag.

`ProducerControlAct020E10.correct` domyka wszystkie16 słów sterowania.
`ProducerActSlots020E10.correct` domyka wszystkie trzy sloty danych.
Przy zapisie aktywny jest wyłącznie pierwszy slot, ze sprawdzonym adresem
rejestru/RAM/wyjścia i wartością; pozostałe dwa są puste. Prymitywne patche
E5 dają kernelowy efekt tej jawnej listy zapisów.

**Odmowa i fault pozostają różnymi ścieżkami.** `ProducerActBoundary020E10`
ma osobne eksporty: odmowa nie zapisuje danych, przechodzi do bad i zachowuje
stary fault; zaakceptowana akcja fault także nie zapisuje danych, ale
przechodzi do push i ustawia fault. Dowód store/emit zachowuje przypadek,
w którym błędny adres daje fault mimo braku wartości do zapisania.

## Dokładny poziom porównania

Kontynuujemy drogę efektu przyjętą jawnie w E9. Nowa kanoniczna lista
obejmuje już act oraz pozostałe fazy. Jest **obiektem dowodowym**, powiązanym
z rzeczywistym kodowaniem wyjścia; nie została podstawiona do runtime.
Nie zmieniano instrukcji/kodu producenta E6.

Nie deklarujemy równości surowych list/banków dawnej i nowej referencji ani
poprawności na dowolnej niekodującej nic pamięci. Wynik dotyczy dokładnego
kodowania typowanego wejściowego stanu. Nie skonstruowano tu wykonywalnego
dekodera wyjścia, sterownika całego przebiegu ani nowego śladu alokacji.
Bez dopisania ich dowodów nie awansować tego wyniku do pełnego wykonania
samplera, EveryTape/J/P lub pełnego peak/czasu.

## Mapa murów

| Obowiązek | Stan |
|---|---|
| Rzeczywisty czytnik wszystkich96 pól | KERNEL, E7 |
| Pełna decyzja skanu i sterowanie poza act | KERNEL, E8 |
| Clear/scan/push i pozostałe fazy poza act | KERNEL, E9 |
| Pełny dispatch act, sterowanie, dane i porażki | **KERNEL, E10** |
| Wszystkie siedem faz: rzeczywisty wynik i stary efekt kroku | **KERNEL, E10 — zakres zlecenia domknięty** |
| Wykonanie kodowanego wyjścia i driver kolejnych kroków | **OPEN — następny krok** |
| Transport całego wykonania / EveryTape / J/P pod tym samym(M) | OPEN |
| Inne rodziny producenta: parser/fill/startup | OPEN |
| Życie obu kodów i buforów, ładowanie, pełny czas/peak | OPEN |
| Pokrycie(M), rzeczywiste KeyGen/Sign/PRG i redukcja QROM | OPEN, bez zmian |

Następne zlecenie: podpiąć rzeczywiste96 słów wyjścia do sprawdzanego
odczytu bufora/ScriptMachine i sterownika kolejnych kroków, uwzględnić
porażki oraz zerowe/końcowe paliwo. Wtedy transportować całe wykonanie i J/P
pod niezmienionym(M), zamiast traktować listę dowodową jako darmowe orakulum.
Pozostałe rodziny producenta i pełne zasoby zachowują osobne obowiązki.

## Walidacja, próby i granice

**30 modułów wynikowych, 114 twierdzeń, audyt126 eksportów; 761 pinów.**
Wszystkie31 końcowych uruchomień modułów i audytu mają czyste logi.
Aksjomaty: wyłącznie propext/Classical.choice/Quot.sound. Bez sorry/admit,
nowych aksjomatów, native_decide/bv_decide i wyciszania linterów w wyniku.

Zachowano46 prób:31 czystych,14 zakończonych błędem i jedną z ostrzeżeniem,
której również nie instalowano. Przyczyny są w [CHECKS](ACTION_EQUIVALENCE_020E10_CHECKS.json).
Problemy dotyczyły elaboracji/normalizacji, typów rozmiaru, transportów i
jednej przedwczesnej próby z niegotową zależnością. Limity heartbeatów
napotkano przy zbyt wczesnym rozwijaniu konkretnych wyrażeń; rozwiązaniem
były małe lematy skalarne i uproszczenie przed składaniem, bez zwiększania
limitu pamięci. Nie są to kontrprzykłady. Diagnostyka `sorry` po błędzie typu
w layout001 nie weszła do biblioteki; końcowy audyt nie zawiera sorryAx.

Limity kompilacji: Lean4096MiB, AS8GiB, jeden rdzeń. Receipty odnoszą się do
kompilatora, nie do kosztu wykonania samplera. Nie wykonano nowego rachunku
numerycznego wymagającego Sage; wynik jest symbolicznym dowodem kernelowym.

[Kontrola autora](ACTION_EQUIVALENCE_020E10_SELF_REVIEW.md),
[klasy warunków](CERTIFICATE_CLASSES_020E10.json),
[kolejka](KERNEL_QUEUE_020E10.json). Brak niezależnego odbioru, nowego source
bindingu native, nowego transportu J/P lub deklaracji bezpieczeństwa FT1536
w QROM. Publiczny initial, dziedzina h, J≪P i moment(M) bez zmian.

OUTPUTS pomija żywy README. RUNTIME zamraża pliki przy freeze, włącznie ze
wszystkimi próbami; plan/receipt końcowego commita dokumentów i POSTCOMMIT
są późniejszymi operacyjnymi dopiskami poza manifestem.
