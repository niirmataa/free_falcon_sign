# TODO020E / continuation003 — skończone banki i ich pojemność

**KERNEL_SCOPED_FINITE_BANKS / PARENT020E_IN_PROGRESS / WARUNKOWY / NOT_REVIEWED.**
2026-10-13. Baza1236b53f237eb55bf4e685f721f7b9dfd5bf6751.
Rozwinięcie S05/ROADMAP. Domknięto banki, zgodność i pojemność w jawnym
modelu banków. Pełne Q-RESC i bezpieczeństwo FT1536 w QROM nadal OPEN.

## Co wykazano

**Stos sterowania mieści się w banku28941 ramek, a wartości w banku877
komórek Option Word.** Są to konkretne pojemności dla oryginalnego programu,
z dowodem wystarczalności dla każdego wejścia i stanu. Kontynuacja pętli
ma adres i ograniczony licznik. Bank kodu jest niezmienny.

BoundedStack dowodzi odczytu szczytu, pop, push i nadpisywania martwych
slotów. FrameReserve wyprowadza liczbę ramek z wcześniejszego reserve.
BankStep udowadnia miejsce na KAŻDY zapis kolejnego kroku; BankExecute
składa to w dokładną zgodność całego wykonania, również przy fuel exhaustion.
BankProgram.actual_correct wypełnia lokalne warunki dla rzeczywistych877
węzłów i28941 ramek. Nie zakładamy poprawności samplera ani pojemności
jako nowej przesłanki konkretnego końcowego wyniku.

**Wyrażenia nie potrzebują już rekurencyjnego stosu w obranym modelu.**
Bank wartości powstaje przebiegiem od niższych indeksów do wyższych.
Każde dziecko jest wcześniejsze; jego wartość jest już zapisana. Bank
jest przeliczany dla bieżącego State, więc nie ma niewykazanego cache
po zmianie rejestrów. Evaluator jest zgodny także dla code-node i adresów
poza used. Cena tego wyboru: pełne przeliczenie877 komórek zamiast tylko
wyrażeń potrzebnych danej gałęzi. To jawny kompromis, nie darmowa operacja.

Driver nadal resetuje do publicznego initial, daje to samo pełne wyjście
na każdej taśmie i nie dodaje porażki przepełnienia banków. BankCertificate
zachowuje pełne prawo wraz z modelowanymi porażkami: J≪P dla każdego h,
moment≤1+2^-47 pod tym samym(M), także dla tego samego pokrytego prawa kluczy.
Przypięte środowisko legacy nie zostało podmienione nową grą wariantu A.

## Konkretne rozmiary i ich znaczenie

| Wielkość | Kernelowy wynik | Zakres |
|---|---:|---|
| Bank ramek | 28941 slotów | Konserwatywna pojemność każdego osiągalnego stosu |
| Bank wartości | 877 slotów | Option Word dla każdego adresu tablicy kodu |
| Chwilowy prefiks nowych ramek | ≤2 | action dla każdej związanej ramki |
| Pełne przeliczenie wartości | 877 wywołań advance | Zapis komórki, bez pełnej ceny jej obliczenia |
| Kodowanie obu banków i sp | 88578 słów512bit | Wyłącznie trwałe kontrola/wartości |

Kodowanie jest iniektywne: wartość ma flagę i payload, ramka tag/adres/licznik,
a sp jedno słowo. Przesłanki szerokości są wypełnione dla877/28941.
88578 nie obejmuje areny kodu, wejścia/core State, indeksów skanu, tymczasowych
wartości, parsera ani całego szczytu pamięci. Historyczne5264 słowa nadal
opisują samą trwałą arenę parsera. Nie twierdzimy minimalności pojemności.

## Co pozostaje

Banki są modelem `Fin→payload` z `Function.update`. Dowód nie mówi, że
kompilator natywnego Lean realizuje te funkcje mutable/in-place albo że
nie przechowuje wcześniejszych domknięć. Powiązanie prymitywów z fizycznym
backendem i jego pamięcią jest nadal obowiązkiem.

Pozostaje pełny rachunek: odczyty/zapisy, arytmetyka Word512, dispatch,
pełny scan, początkowe banki, produkcja/ładowanie obrazu, idealne bity,
parser, reset/transfer, scratch i współistnienie stanów. Liczba877 to
wywołania advance, a controlLimit1106642201817 to przejścia sterowania.
Żadna z nich nie jest samodzielnie pełnym czasem samplera.

Źródłowe KeyGen/pokrycie(M), source harmonic/Schur, real Sign/PRG,
połączenie z wariantem A oraz mechanizmy QROM pozostają w kolejce.
Nie ogłaszamy jeszcze bezpieczeństwa schematu w QROM.

## Kontrola i historia

**55 nowych twierdzeń,14 modułów i jeden audyt.**15 końcowych czystych
buildów Lean.17 prób kompilacji; dwie odrzucone zachowane ze snapshotami,
receiptem i logami. Wszystkie55 eksportów ma wyłącznie standardowe zależności
aksjomatyczne:54 listy będące podzbiorami {propext, Classical.choice, Quot.sound}
i jeden wynik bez aksjomatów. Brak nowych axioms, sorry, native_decide/bv_decide
lub wyciszeń linterów w końcowych źródłach. To kontrola autora, bez
niezależnego odbioru Daybreak.

Sprawdzono25 pinów wyników i174 runtime020E2 oraz554 źródła/artefakty
końcowej biblioteki. Nowe twierdzenia są uniwersalne; rozmiar kodowania
sprawdził kernel. Nie wykonywano całej taśmy jako skończonego eksperymentu.
Koszt kompilacji jest zapisany w CHECKS/receipcie i nie jest kosztem samplera.
Runtime: `.build/pair_machine_020/finite_banks_001/`.

Commity źródeł: `ea8f83c4c58ae72ebbaecb40d3d02196e6603585` oraz
`f023dbacf48fda8cb5e06a59a9c05d3858ffa2e0`.
Dokładne piny: FINITE_BANKS_020E3_OUTPUTS.sha256 i RUNTIME.sha256.
Przesłanki/klasy: CERTIFICATE_CLASSES_020E3.json. Kontrola znaczenia:
FINITE_BANKS_020E3_SELF_REVIEW.md. Bez push/importu/tagu i bez zmian statusów
T12.1/B20/paperu przez tę pracę. Nowych wyników ROM nie konsumowano.

## Mapa murów

| Obowiązek lub założenie | Stan |
|---|---|
| Skończone banki sterowania i wartości, zgodność i pojemność | Q-RESC/Q-SAMPLER, KERNEL CLOSED scoped |
| Instancja877/28941, publiczny initial i to samo pełne J/P pod(M) | Obowiązek, KERNEL zachowany i wypełniony |
| Fizyczne/in-place prymitywy i pełny koszt czasu/peak | Q-RESC, OPEN — następny etap |
| Pełne źródłowe prawo kluczy/pokrycie(M), real Sign/PRG i wariant A | Obowiązki źródłowe i gry, OPEN |
| A-QMT i primitive-bound Q-PRG | Jawne założenia kryptograficzne, bez zmian |
| QROM: log/reprogramowanie, embedding, kolizje i kompozycja | Obowiązki kwantowe, OPEN |

Dalsza trasa: RESOURCES_020E_CONTINUATION_004.md i KERNEL_QUEUE_020E3.json.
Nonce320, kierunek J/P, e=2^-47 i D=(1+e)^q_s−1 pozostają bez zmian.
