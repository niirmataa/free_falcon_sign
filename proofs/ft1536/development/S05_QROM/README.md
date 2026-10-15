# S05_QROM — publiczny sampler i redukcja kwantowa

Status: **WARUNKOWY / DEVELOPMENT**, bez twierdzenia bezpieczeństwa FT1536
w QROM i bez niezależnego odbioru. Tor rozwija wpis S05 w ROADMAP.

**Kontynuacja020E13 — [liczniki wykonania rdzenia](notes/EXECUTION_COUNTS_020E13_CHECKPOINT.md), KERNEL_SCOPED_COUNTS / NOT_REVIEWED:**
Instrumentowane rzeczywiste wykonanie zachowuje wynik całego publicznego
wywołania i pełną odpowiedź dla każdej taśmy. **Dokładnie14733 cykle producentów
oraz32 przejścia konsumenta na rundę rdzenia**, z osobnym rachunkiem skanów,
zapisów i zatrzymania, także przy błędach.16 modułów,68 twierdzeń,
audyt93 eksportów; dokładne stałe Sage i Lean;37 prób zachowanych.
**Liczniki obejmują tylko wewnętrzny raw core. Pełny czas i peak nadal OPEN:**
ceny prymitywów, przygotowanie/startup/parser/readout, kopie i wspólne okresy
życia wymagają dowodu. Liczniki nie są certyfikatem alokacji.
(M), źródłowe pokrycie prawa kluczy i QROM bez zmian; bez niezależnego odbioru.
[Kontrola autora](notes/EXECUTION_COUNTS_020E13_SELF_REVIEW.md),
[klasy](notes/CERTIFICATE_CLASSES_020E13.json), [kolejka](notes/KERNEL_QUEUE_020E13.json).
Jedno okno, bez push; monitor ROM PAUSED. Poniżej historia wcześniejszych etapów.

**Kontynuacja020E12 — [pełne publiczne wywołanie i J/P](notes/PUBLIC_CALL_020E12_CHECKPOINT.md), KERNEL_SCOPED / CONDITIONAL_M / NOT_REVIEWED:**
Konkretne pętle E5 przygotowania/parsera, materializacja portów, nowy stały
startup w IR, raw core E11 i pełny odbiór tworzą jedno wywołanie. **EveryTape
oraz pełne prawo odpowiedzi są zgodne ze starą maszyną przy publicznym initial.**
AC dla wszystkich h; moment J/P≤1+2^-47 pod dokładnie tym samym(M), także dla
tego samego pokrytego prawa kluczy. Zakodowane aborty pozostają w prawie.
12 modułów,52 twierdzenia, audyt83 eksportów;39 prób zachowanych.
**OPEN:** pełny czas/peak, jednolity backend fill/parser, źródłowe pokrycie(M),
KeyGen/Sign/PRG i redukcja QROM. Bez niezależnego odbioru i push.
[Kontrola autora](notes/PUBLIC_CALL_020E12_SELF_REVIEW.md),
[klasy](notes/CERTIFICATE_CLASSES_020E12.json), [kolejka](notes/KERNEL_QUEUE_020E12.json).
Status QROM WARUNKOWY; monitor ROM PAUSED. Niżej zachowano historyczny zakres etapów.

**Kontynuacja020E11 — [konsument i driver surowej pamięci](notes/CONSUMER_DRIVER_020E11_CHECKPOINT.md), KERNEL_SCOPED / NOT_REVIEWED:**
Sprawdzany dekoder i konsument wykonują rzeczywiste96 słów producenta, bez
listy dostarczonych poleceń. **Driver przekazuje aktualną surową pamięć między
krokami i daje dokładnie stary CoreRun dla każdego paliwa i typowanego stanu.**
Zachowany pełny wynik reg/RAM/out/fault, None i oryginalny limit sterowania;
błąd konsumenta ma osobny poziom, wykluczony na kodowaniach objętych dowodem.
8 modułów,43 twierdzenia, audyt69 eksportów;16 prób Lean zachowanych.
**Następne: złożenie publicznego przygotowania, rdzenia i pełnej odpowiedzi**,
potem EveryTape/J/P pod tym samym(M). Pozostałe rodziny producenta, pełny
czas/peak, source binding i QROM nadal OPEN. Bez niezależnego odbioru i push.
[Kontrola autora](notes/CONSUMER_DRIVER_020E11_SELF_REVIEW.md),
[klasy](notes/CERTIFICATE_CLASSES_020E11.json), [kolejka](notes/KERNEL_QUEUE_020E11.json).
Status QROM WARUNKOWY; monitor ROM PAUSED. Niżej pozostaje historia checkpointów.

**Kontynuacja020E10 — [pełny dispatch act i wszystkie fazy kroku](notes/ACTION_EQUIVALENCE_020E10_CHECKPOINT.md), KERNEL_SCOPED / NOT_REVIEWED:**
Domknięte run/again, wszystkie modelowane tagi, Edit/Pending, sterowanie i
zapisy act, w tym odmowy, fault, brak danych i granice pętli/adresów.
**Całe96 słów rzeczywistego producenta koduje bufor dający dokładnie stary
CoreStep dla każdego typowanego stanu — bez ograniczenia fazy lub sukcesu.**
30 modułów,114 twierdzeń, audyt126 eksportów;46 prób zachowanych.
**Następne: konsument kodowanego wyjścia i driver kolejnych kroków**, potem
EveryTape/J/P pod tym samym(M). Pozostałe rodziny producenta, pełny czas/peak,
source binding i QROM nadal OPEN. Bufor kanoniczny jest świadkiem dowodowym,
nie nowym darmowym orakulum runtime. Bez niezależnego odbioru i push.
[Kontrola autora](notes/ACTION_EQUIVALENCE_020E10_SELF_REVIEW.md),
[klasy](notes/CERTIFICATE_CLASSES_020E10.json), [kolejka](notes/KERNEL_QUEUE_020E10.json).
Status QROM WARUNKOWY; monitor ROM PAUSED. Niżej pozostaje historia checkpointów.

**Kontynuacja020E9 — [aktywne zapisy clear/scan/push](notes/DATA_EQUIVALENCE_020E9_CHECKPOINT.md), KERNEL_SCOPED / NOT_REVIEWED:**
Domknięte tagi obecności, adresy i wartości wszystkich trzech slotów danych,
także dwa aktywne zapisy zer przy braku wyniku skanu, końcowy kursor, pusty
pending i pełny stos. **Całe 96 słów rzeczywistego producenta i efekt starego
CoreStep są zgodne we wszystkich sześciu fazach poza act.** Dowód idzie przez
jawny bufor o udowodnionym efekcie; nie deklaruje równości surowej starej listy.
11 modułów, 49 twierdzeń, audyt 55 eksportów; 19 prób zachowanych.
**Następne: pełny dispatch act**, potem złożenie wszystkich faz i EveryTape/J/P.
Pełny peak/czas, pozostałe rodziny producenta i QROM nadal OPEN. Bez zmiany(M),
niezależnego odbioru lub push; status WARUNKOWY.
[Kontrola autora](notes/DATA_EQUIVALENCE_020E9_SELF_REVIEW.md),
[klasy](notes/CERTIFICATE_CLASSES_020E9.json), [kolejka](notes/KERNEL_QUEUE_020E9.json).
Monitor ROM PAUSED; poniżej zachowano historyczny zakres wcześniejszych checkpointów.

**Kontynuacja020E8 — [sterowanie, skan i trzy pełne przypadki](notes/DECISION_EQUIVALENCE_020E8_CHECKPOINT.md), IN_PROGRESS / PARTIAL:**
Kernel domyka wszystkie 16 słów sterowania poza act i pełną decyzję skanu,
włącznie z błędnymi opcode/rejestrami oraz brakującymi argumentami. Wynik
uruchomionego producenta ma zgodne 16 slotów sterowania poza act i 13 pustych
slotów zawsze. **Pełna równość i efekt starego kroku są dowiedzione dla
check/done/bad.**26 modułów,81 twierdzeń, audyt 98 eksportów;55 prób zachowanych.
**Cały producent nadal OPEN:** aktywne trzy sloty danych clear/scan/push,
pełny dispatch act i złożenie wszystkich faz. Brak nowego transportu J/P,
pełnego peak, niezależnego odbioru i push; status QROM WARUNKOWY.
[Kontrola autora](notes/DECISION_EQUIVALENCE_020E8_SELF_REVIEW.md),
[klasy](notes/CERTIFICATE_CLASSES_020E8.json), [kolejka](notes/KERNEL_QUEUE_020E8.json).
Monitor ROM PAUSED; poniższe checkpointy zachowują zakres historyczny.

**Kontynuacja020E7 — [uniwersalny odczyt producenta i efekt układu slotów](notes/SOURCE_EQUIVALENCE_020E7_CHECKPOINT.md), IN_PROGRESS / PARTIAL:**
Kernel obejmuje wszystkie96 pól rzeczywistego odczytu dla każdego typowanego
stanu, także puste/błędne przypadki, oraz wykonanie zainstalowanego kodu.
Osobno dowiedziono, że referencyjny układ32 slotów ma dokładnie efekt starego
CoreStep.15 modułów,63 twierdzenia,audyt72 eksportów;41 prób zachowanych.
**Pełna zgodność producenta nadal OPEN:** brakuje dowodu, że konkretny
CoreCircuit/CoreSlots daje ten referencyjny efekt. Próby pełnego złożenia
i sterowania nie zamknęły celów; nie zastąpiono ich założeniem ani testami.
[Kontrola autora](notes/SOURCE_EQUIVALENCE_020E7_SELF_REVIEW.md),
[klasy](notes/CERTIFICATE_CLASSES_020E7.json), [kolejka](notes/KERNEL_QUEUE_020E7.json).
Bez nowego transportu J/P, pełnego peak, niezależnego odbioru lub push.
Status QROM WARUNKOWY; monitor ROM PAUSED. Poniższe E6 zachowuje stan historyczny.

**Kontynuacja020E6 — [producent: wykonanie i pamięć lokalna](notes/PRODUCER_020E6_CHECKPOINT.md), IN_PROGRESS / PARTIAL:**
Zamknięty zestaw instrukcji, kompilator z ochroną rejestrów, jawne przechowanie
pobranej instrukcji oraz kernelowy ślad pojedynczego wywołania. Payload roboczy
maszyny:186 słów512bit; kod i źródła liczone osobno. Kandydat ma programy
3469 i11 264 instrukcji.37 modułów,118 twierdzeń,audyt309 eksportów.
**Producent FT1536 nadal OPEN:** nie domknięto pełnej zgodności konkretnego
okna/circuitu ze starszym krokiem ani wspólnych okresów życia obu etapów.
4480 sprawdzonych snapshotów to diagnostyka, nie uniwersalny dowód.
[Kontrola autora](notes/PRODUCER_020E6_SELF_REVIEW.md), [klasy](notes/CERTIFICATE_CLASSES_020E6.json),
[kolejka](notes/KERNEL_QUEUE_020E6.json). Bez nowego transportu J/P, QROM claim,
niezależnego odbioru i push; monitor ROM PAUSED.

**Kontynuacja020E5 — [banki, granice wywołania i scratch](notes/PEAK_MEMORY_020E5_CHECKPOINT.md), IN_PROGRESS / PARTIAL:**
49 modułów wynikowych, 212 twierdzeń; audyt 418 eksportów. Kernel obejmuje
cały wynik wywołania, pełne J/P pod tym samym(M), rzeczywiste dane wejścia,
parsera i wyjścia, inicjalizację rdzenia oraz bufor poleceń z pełnym śladem
reset/wypełnianie/odczyt/zapis. **Pełny peak nadal OPEN:** brakuje pamięci
producenta poleceń i jednego sterownika całego cyklu alokacji/faz.
Rozmiar reprezentowanych danych z buforem wynosi 1 578 427 352 384 bajty
w modelu jednej komórki512bit na bit taśmy; to nie peak ani pomiar native.
Stare naliczenia czasu020E4 nie przenoszą się automatycznie na tę realizację.
[Kontrola autora](notes/PEAK_MEMORY_020E5_SELF_REVIEW.md),
[klasy](notes/CERTIFICATE_CLASSES_020E5.json), [kolejka](notes/KERNEL_QUEUE_020E5.json).
Bez niezależnego odbioru i bez push; monitor ROM pozostaje PAUSED.

**Kontynuacja020E4 — [Array, prymitywy i pełne naliczenia](notes/ARRAY_BACKEND_020E4_CHECKPOINT.md), PARTIAL:**
183 nowe twierdzenia: backend Array, jawne kopie, wszystkie fazy drivera,
EveryTape oraz pełne J/P pod tym samym(M). Kernel i Sage dają bound
11763954238966829723 dla modelowych ticks i skumulowanych naliczeń słów.
**Nie jest to jeszcze pełny peak.** Kernelowy CostSpaceGap pokazuje, dlaczego
sam typ liczników nie implikuje pokrycia przechowywanych danych. Brakuje
konkretnego śladu/układu alokacji, scratch i czasu życia. Pełne020E/Q-RESC
oraz QROM pozostają OPEN; bez deklaracji praktycznej wydajności.
38 modułów + końcowy audyt;110 prób zachowanych. [Kontrola autora](notes/ARRAY_BACKEND_020E4_SELF_REVIEW.md),
[kolejka020E4](notes/KERNEL_QUEUE_020E4.json), [klasy020E4](notes/CERTIFICATE_CLASSES_020E4.json).
[Następna część tego samego TODO: alokacja i peak](notes/RESOURCES_020E_CONTINUATION_005.md).
Bez niezależnego odbioru i bez push; monitor ROM pozostaje PAUSED.

**Kontynuacja020E3 — [skończone banki, zgodność i pojemność](notes/FINITE_BANKS_020E3_CHECKPOINT.md):**
55 nowych twierdzeń domyka model banku28941 ramek i877 komórek wartości. Każdy
zapis stosu ma udowodnione miejsce; wartości powstają topologicznie po
stałej tablicy, bez stosu rekurencyjnych wyrażeń. Całe wykonanie instancji877
zachowuje oryginalny wynik i pełne J/P pod tym samym(M), z publicznym initial.
Pełny scan ma877 zapisów, chwilowy prefiks ramek≤2. Bezstratne kodowanie
obu banków wraz ze sp zajmuje88578 słów512bit — wyłącznie te banki.
**Banki CLOSED scoped w modelu Fin→payload; fizyczny backend/in-place,
pełny czas i peak oraz QROM OPEN.**14 modułów + audyt,15 czystych buildów,
17 prób zachowanych. [Kontrola autora](notes/FINITE_BANKS_020E3_SELF_REVIEW.md),
[kolejka020E3](notes/KERNEL_QUEUE_020E3.json), [klasy020E3](notes/CERTIFICATE_CLASSES_020E3.json).
[Następne: pełne ceny i prymitywy](notes/RESOURCES_020E_CONTINUATION_004.md).
Bez niezależnego odbioru; monitor ROM pozostaje PAUSED.

**Kontynuacja020E2 — [całe wykonanie z tablicy węzłów](notes/NODE_EXECUTION_020E2_CHECKPOINT.md):**
37 nowych twierdzeń domyka bezpośrednie wykonanie wyrażeń, atomów i całego
sterowania. Instancja877 daje dokładnie stan końcowy oryginalnego programu
dla każdego wejścia/stanu, a z publicznego initial pełne wyjście019 na każdej
taśmie. Driver zachowuje to samo pełne J/P: AC dla każdego h, moment≤1+2^-47
pod niezmienionym(M), również dla tego samego pokrytego prawa kluczy.
Tablica kodu jest niezmienna; w samym wykonawcy Code/Meaning występują
wyłącznie w dowodzie.
**Wykonanie CLOSED scoped; lista ramek i rekurencyjny evaluator wymagają
jeszcze realizacji w skończonych bankach. Pełne020E/Q-RESC i QROM OPEN.**
14 modułów + audyt,15 czystych końcowych buildów,29 prób kompilacji zachowanych.
[Kontrola autora](notes/NODE_EXECUTION_020E2_SELF_REVIEW.md), [kolejka020E2](notes/KERNEL_QUEUE_020E2.json),
[klasy020E2](notes/CERTIFICATE_CLASSES_020E2.json).
[Następne: banki wykonawcy i pełne zasoby](notes/RESOURCES_020E_CONTINUATION_003.md).
Bez niezależnego odbioru; monitor ROM pozostaje PAUSED.

**Kontynuacja020E1 — [parser w skończonej arenie](notes/ARENA_PARSER_020E1_CHECKPOINT.md):**
71 nowych twierdzeń domyka parser na stałym banku węzłów i banku adresów
stosu. Kanoniczny obraz FT1536 daje877 węzłów i jeden adres wyniku;
odkodowanie wyłącznie z banku odtwarza dokładnie oryginalny program.
Strażniki odrzucenia są jawne; pomocnicze Meaning występuje tylko w dowodzie.
Bezstratne kodowanie trwałego stanu areny ma5264 słowa512bit — nie jest to
pełny peak ani czas samplera.16 modułów + audyt,17 czystych końcowych buildów,
29 prób zachowanych. **Parser CLOSED scoped; cały020E/Q-RESC OPEN.**
Następny krok: [bezpośrednie wykonanie po adresach](notes/RESOURCES_020E_CONTINUATION_002.md).
[Kontrola autora](notes/ARENA_PARSER_020E1_SELF_REVIEW.md), [kolejka020E1](notes/KERNEL_QUEUE_020E1.json),
[klasy020E1](notes/CERTIFICATE_CLASSES_020E1.json). Daybreak jest planowanym
niezależnym recenzentem; odbioru jeszcze nie uruchomiono.

**Kontynuacja020E — [jawny driver i lokalne zasoby](notes/RESOURCES_020E_CHECKPOINT.md), PARTIAL:**
80 nowych twierdzeń wiąże evaluator wyrażeń i sterowanie na stosie z020,
bezstratne komórki składni, kopiowanie banków, reset initial i pełne wyjście.
Driver ma dokładnie prawo020D i odziedziczony certyfikat J/P pod tym samym(M).
Osiągalne wyrażenia mają≤32 węzły; kolejka≤28941, stara+nowa≤57882.
**To lokalne budżety, nie pełna alokacja ani czas. TODO020E i Q-RESC OPEN:**
pozostaje wykonawca na komórkach, ramki/scratch, producent wejścia i pełna cena.
17 modułów dowodowych + audyt;18 czystych końcowych buildów,31 prób zachowanych.
Bez niezależnego odbioru. [Kontrola autora](notes/RESOURCES_020E_SELF_REVIEW.md),
[kolejka020E](notes/KERNEL_QUEUE_020E.json), [klasy020E](notes/CERTIFICATE_CLASSES_020E.json).
[Następna część tego samego TODO](notes/RESOURCES_020E_CONTINUATION_001.md).

**Kontynuacja020D — [EveryTape i pełne J/P maszyny](notes/SCATTER_OUTPUT_020D_CHECKPOINT.md):**
Cały oryginalny program020 (select, multiply, emitPair) jest kernelowo
zgodny z019 dla każdego publicznego h, każdej taśmy i każdego stanu.
Z publicznego initial kończy bez błędu, z boundem tego samego rdzenia.
Bezstratne kodowanie pełnych praw obejmuje porażki: maszyna ma J≪P dla
każdego h, moment≤1+2^-47 pod niezmienionym(M), także dla tego samego
pokrytego prawa kluczy.186 eksportów,41 modułów dowodowych + audyt;
42 czyste końcowe buildy,72 próby zachowane. Bez niezależnego odbioru.
**EveryTape i transport J/P CLOSED w tym zakresie; pełne zasoby,
źródłowe pokrycie(M), Sign/PRG i QROM OPEN.** Certyfikat pozostaje
w przypiętym środowisku legacy, bez scalenia z nową grą wariantu A.
[Kolejka020D](notes/KERNEL_QUEUE_020D.json), [klasy020D](notes/CERTIFICATE_CLASSES_020D.json).
Następny duży krok: [TODO020E — pełny driver i zasoby](notes/TODO_RESOURCES_020E.md).

Poniższe wpisy opisują wcześniejsze checkpointy; aktualny stan wskazuje020E6.

**Kontynuacja020C — [cały select zgodny z019](notes/VECTOR_NORM_020C_CHECKPOINT.md):**
115 nowych eksportów kernelowych zamyka1536 par, dokładną normę Q,
cap196 i świeży cube na tej samej taśmie019. Końcowy select dla każdego
publicznego h, taśmy i stanu daje dokładny obraz wybranego wektora w RAM;
publiczny initial jest bez błędu. Ten sam program ma bound w modelu020.
Wszystkie przesłanki lokalnych kroków i układu taśmy są wypełnione.
Audyt115 eksportów: standardowe aksjomaty, czyste29 końcowych buildów;
41 prób zachowanych. **W020C EveryTape, scatter/wyjście i transport J/P pozostawały OPEN;
020D domyka je powyżej. Pełne zasoby pozostają OPEN.** Bez niezależnego odbioru.
[Kolejka020C](notes/KERNEL_QUEUE_020C.json), [klasy020C](notes/CERTIFICATE_CLASSES_020C.json).
Następny duży TODO020D opisano w checkpointcie.

**Kontynuacja020B — [cap80 i cała instrukcja pair](notes/CAP_REFINEMENT_020B_CHECKPOINT.md):**
42 nowe eksporty kernelowe domykają rzeczywisty cap80 z wyczerpaniem prób,
zerowy fallback, oba zapisy RAM, normę x²+xy+y², dokładny akumulator,
licznik i ramki stanu. Ogólne przesłanki kroku są wypełnione przez020A;
końcowy konsument nie przyjmuje poprawności samplera jako założenia.
Własny audyt wszystkich42 eksportów: standardowe aksjomaty, czysty log;
bez niezależnego odbioru. EveryTape całej maszyny i pełne zasoby OPEN.
Następne: pętla1536, norma wektora, cap196 i świeży cube, później scatter/wyjście.
[Kolejka020B](notes/KERNEL_QUEUE_020B.json), [klasy020B](notes/CERTIFICATE_CLASSES_020B.json).
Na późniejsze polecenie właściciela limit kolejnych prób podniesiony do6GiB
Lean/10GiB AS, nadal jeden proces; [mapowanie pamięci](notes/LEAN_MEMORY_020B.md).
Przyjęte dowody020B przeszły jeszcze przy4GiB. Monitor ROM nadal PAUSED.

**Kontynuacja020A — [czytnik, CDF i pojedyncza próba](notes/LOOP_REFINEMENT_020A_CHECKPOINT.md):**
75 nowych eksportów kernelowych dowodzi zgodności rzeczywistych instrukcji
z019 na każdym prawidłowym segmencie taśmy: pełny readWord, coordinate
z rzeczywistymi tablicami oraz cała pojedyncza próba z obiema gałęziami.
**Cap80 nie jest jeszcze skernelizowane:** próby kompilacji przekroczyły
M4096; szkice/logi zachowano, limitu nie zwiększono. Następna trasa to lekki
ogólny lemat pętli, z krokiem wypełnionym przez TrialCorrect020A.
EveryTape całego samplera i pełne zasoby nadal OPEN.
[Kolejka020A](notes/KERNEL_QUEUE_020A.json), [klasy020A](notes/CERTIFICATE_CLASSES_020A.json).
Praca pojedynczym oknem; monitor ROM pozostaje PAUSED.

**Bieżący TODO020 — [PAIR_MACHINE020](notes/PAIR_MACHINE_020_CHECKPOINT.md), IN_PROGRESS:**
Jest zamknięty program w modelu512bit RAM: oba retry, świeży cube, scatter
oraz pełna para na wyjściu.81 eksportów kernelowych obejmuje bound rdzenia
**1106642201817** operacji modelu, bezstratny obraz tablic/h, wszystkie
adresowania taśmy, ramki pamięci i format50689bit z rozróżnieniem porażki.
43 skończone kontrole Sage przeszły; to nie dowód każdej taśmy.
**EveryTape refinement do019 i certyfikat momentu maszyny domknięto w020D.
Driver wejścia/wyjścia i pełny szczyt pamięci pozostają OPEN.**
Model nie podaje czasu CPU/C ani ceny bitowej; pełna taśma ma3082817280
bajtów. [Kolejka020](notes/KERNEL_QUEUE_020.json) i [klasy020](notes/CERTIFICATE_CLASSES_020.json).

**Poprzedni podetap — [MODEL_BRIDGE019](notes/MODEL_BRIDGE_019_CHECKPOINT.md):**
Publiczny generator wspólnej pary i sampler odpowiedzi dla challenge z ROM
mają osobne interfejsy. Niezależny wykonywalny rdzeń kompiluje się w obu
środowiskach;21 równości kernelowych wiąże go z018, zachowując J≪P oraz
moment≤1+2^-47 pod niezmienionym(M) i to samo pokryte prawo kluczy.
[Dopisek po odbiorze F04 R1/R2](notes/MODEL_BRIDGE_019_TRUST_SCOPE_001.md)
potwierdza, że wskazane moduły nie wchodzą do importów naszych audytów.
84 eksporty obejmują też kontrakcję przy skończonej klasycznej obserwacji,
przeszkodę dokładnego adaptera oraz jawny koszt zmiany odniesienia:
e'=kappa(1+e)-1 przy obowiązku P≤kappa R na nośniku J.
**Brak źródłowego kappa, scalonego dowodu nowej gry i pełnego kosztu maszyny.**
Dowód konkretnego certyfikatu pozostaje w przypiętym środowisku legacy;
nowy konsument przyjmuje go jawnie. Nie mieszamy wersji Run2.Games.
[Źródło pełnego zdania](notes/MODEL_BRIDGE_019.tex); podgląd PDF niezweryfikowany
z powodu timeoutów środowiska edytora. [Następny duży TODO020](notes/TODO_PAIR_MACHINE_020.md)
kontynuuje otwarty Q-RESC018 dla całej pary, nie reply-only API.

**Otwarty pakiet kosztu — [EXECUTION018](notes/EXECUTION_018_CHECKPOINT.md), IN_PROGRESS:**
73 nowe eksporty kernelowe obejmują dokładną równość zoptymalizowanego
samplera na każdej taśmie, przeniesienie pełnego J/P z017, granice śladu
zdarzeń i wybrane szerokości. Binary CDF, zapisane wektory/wyjście i scatter
zachowują capy i świeży fallback. **Pełny koszt maszyny oraz pamięci nadal
OPEN** — liczniki zdarzeń go nie zastępują. Pod(M) pozostaje e=2^-47;
źródłowe pokrycie kluczy, Sign/PRG i QROM nadal OPEN.
[Pełne zdanie](notes/EXECUTION_018.tex), [aktywny plan](notes/EXECUTION_018_PLAN.md).
F04: [wariant A](notes/ROM_VARIANT_A_018.md) został wybrany przez właściciela;
challenge rzeczywistego Sign pochodzi z ROM poza jego prywatną taśmą.
Nowe typy/świadki ROM trzeba sprawdzić przed konsumpcją. Ta decyzja nie
ustanawia jeszcze powiązania gry z publicznym symulatorem S05.

**Poprzedni pakiet — [LOCAL_LEAVES017](notes/LOCAL_LEAVES_017_CHECKPOINT.md):**
Wszystkie cztery lokalne pola 016 mają kernelowe instancje dla rzeczywistych
tablic i kodu. Sprawdzono 61 441 wierszy; dokładne CDF/modulo i prawo pary
nie są założeniami. `ActualInterface017` daje pełne **J≪P i moment≤1+2^-47
pod dokładnym (M)**, dla każdego stanu/publicznego initial i tego samego
pokrytego prawa kluczy. Źródłowe pokrycie M, Sign/PRG, koszt wykonania oraz
mechanizmy QROM pozostają OPEN. [Pełne zdanie](notes/LOCAL_LEAVES_017.tex),
[następny duży TODO018](notes/TODO_COST_AND_SOURCE_018.md).
Osobno kernelowo wykryto dwie niemożliwe przesłanki pinu ROM 18a3ffe3:
[VirtualLegal](notes/ROM_INVOCATION_AUDIT_017.md) i
[Dimensions](notes/ROM_INVOCATION_AUDIT_017_SUPPLEMENT_001.md).

**Checkpoint — [IMPLEMENTATION-016](notes/IMPLEMENTATION_016_CHECKPOINT.md):**
Wykonywalna referencja Lean z rzeczywistymi publicznymi literałami tablic
ma **kernelowe J≪P dla każdego h**, poprawną normę i pełne prawa obu capów
oraz świeżego fallbacku.96 eksportów,17 modułów dowodowych i13 odtwarzalnych
modułów danych przeszło świeży czysty build. Dołączono3 kernelowe kontrole
korelacji. Pod(M) i **czterema jawnymi lokalnymi polami** wyprowadzono moment
`≤1+2^-47` dla tego kodu. **W016 PairLeaves/CubeLeaf nie miały kernelowych
instancji;017 dostarcza je dla rzeczywistych tablic.** Koszt operacyjny, zgodność całego
Python/C runtime i źródłowe pokrycie kluczy pozostają OPEN.
[Pełne zdanie i ograniczenia](notes/IMPLEMENTATION_016.tex),
[TODO016 i kontynuacja017](notes/TODO_IMPLEMENTATION_016.md).

**Checkpoint — [BOX_MOMENT-015](notes/BOX_MOMENT_015_CHECKPOINT.md):**
47 nowych twierdzeń Lean domyka dokładne(M) → skończony box → flatness
→ odrzucenie normy → marginal → **pełny moment z abortami**.
Pod jawną dominacją `J≤(1+2^-60)J⁰` kernel daje `J≪P` oraz
`ΣJ²/P≤1+2^-47`, mocniej od historycznego007. Dołączono konsument014
z rzeczywistej harmonicznej oraz wrapper publicznego initial obejmujący
każdy stan i to samo pokryte prawo kluczy. **To konstruktory warunkowe:**
Instancję dominacji konkretnego kodu dostarcza017; koszt maszyny i źródłowe pokrycie kluczy nadal OPEN.
[Pełne zdanie](notes/BOX_MOMENT_015.tex), [zamknięty TODO](notes/TODO_BOX_MOMENT_015.md).

**Checkpoint — [ACTUAL_HARMONIC-014](notes/ACTUAL_HARMONIC_014_CHECKPOINT.md):**
Kernelowo domknięto izometrię monomianów, primary cap4608, kanoniczny
Parseval, widmowe A/C/D, reciprocal Schur i dokładne(M)007.
Z rzeczywistych równań NTRU/public/inverse, ternarności i **jawnego H≥991**
wynika jedna dodatnia skala dla wszystkich challenge i temperatur0<t≤1,
z błędem masy2^-34. Gram/Parseval/widmo nie są już wejściowymi certyfikatami.
**Source → H≥991 dla emitted kluczy nadal OPEN.** Pełne prawa referencji
i AC rozwija016, a instancje lokalnych pól momentu domyka017; koszt operacyjny pozostaje OPEN.
[Pełne zdanie](notes/ACTUAL_HARMONIC_014.tex),
[większy TODO](notes/TODO_QUANTITATIVE_GEOMETRY_014.md).

**Checkpoint — [COEFFICIENT_GRAM-013](notes/COEFFICIENT_GRAM_013_CHECKPOINT.md):**
Z rzeczywistego `ActualNTRUFiber.coefficientBasis` wyprowadzono dokładną
macierz bazy, jej Gram w metryce Q, odwrotność z NTRU, dodatniość i energię
afiniczną. Istniejący eksport ROM daje teraz pełną reindeksację włókna przez
ten Gram, bez przyjmowania `gramEq` jako wejścia. 27 deklaracji Lean ma czyste
logi. Pozostałe wtedy granice przekątnych/widmo i ilościowy most zamyka014
pod jawnym boundem harmonicznym.
[Mapa ponownego użycia](notes/REUSE_MAP_013.md) wskazuje gotowe T5/ROM/H3
i pokrycie części012; nie powtarzamy ogólnej probabilistyki.

**Checkpoint — [SCHUR-012](notes/SCHUR_012_CHECKPOINT.md):**
47 nowych twierdzeń Lean domyka ogólny łańcuch: dokładny Schur → pełny
przesunięty atom → zbieżna masa Gaussa → jedna dodatnia skala dla wszystkich
przesunięć i temperatur. Przy jawnej tożsamości widmowej i harmonicznej≥991
kernel daje błąd względny `2^-34` oraz czynnik `t^-1536` dla `0<t≤1`.
W012 instancja Grama/Parsevala rzeczywistej bazy była OPEN;013 domyka
konkretną energię i dodatniość, a014 Parsevala i widmo. Cały certyfikat007 pozostaje OPEN.
[Pełne przesłanki i zakres](notes/SCHUR_012.tex); nie jest to deklaracja QROM.

**Checkpoint — [KEY_SUPPORT-011](notes/KEY_SUPPORT_011_CHECKPOINT.md):**
29 nowych twierdzeń Lean o tym samym materiale/publicznym h, właściwym
prawie kluczy po emisji, pokryciu nośnika, publicznym initial i pełnym J/P.
To **kernelowe konstruktory warunkowe**.017 dostarcza certyfikat samplera pod(M);
rzeczywisty `EmissionView` i źródłowe pokrycie prawa kluczy nadal wymagają instancji. Stary all-h typ
pozostaje niezmieniony. [Dokładny zakres](notes/KEY_SUPPORT_011.tex).

Decyzja właściciela: **kernel przed użyciem wyniku w ostatecznej tezie**.
[Klasy warunków](notes/CERTIFICATE_CLASSES_019.json) rozdzielają obowiązki,
założenia kryptograficzne i model; [kolejka kernela](notes/KERNEL_QUEUE_019.json)
ma priorytety według zależności tezy, również jawne wpisy h=0 i Dyadic.

**Checkpoint — [ponowne użycie ROM010](notes/ROM_REUSE_010_CHECKPOINT.md):**
H3 ROOT/STABLE już dostarczają silniejszego g00<1/1024, dziedzin stable
oraz emitted gate. Nowe sklejenie daje harmoniczną>1022>991 dla emitted f/g
**na odziedziczonym poziomie źródłowo-analitycznym**. Nie trzeba dowodzić
tej numeryki od zera. Pełny source kernel i wspólne powiązanie końcowego h/μ_H
pozostają osobnymi obowiązkami. [Mapa gotowych eksportów i granic](notes/ROM_REUSE_010.tex).
674+1119 pinów archiwów zgodnych; 3 nowe scalar lemmas mają czysty Lean.

**Checkpoint — [008/009](notes/BRIDGE_008_009_CHECKPOINT.md):**
wykryto niemożliwą kolejność pivotsów w odziedziczonym `ldl_shape`
([dokładny finding](notes/KEY_BASIS_008.tex)). Nie zmieniono źródeł/statusów T12.
[Nowy most harmoniczny](notes/HARMONIC_BRIDGE_009.tex) wyprowadza potrzebny
bound LDL z jednej średniej harmonicznej, omijając tę równość list.
Pierwotny pełny most009 jest tekstowy; 12 małych lematów008/009 przeszło Lean
z czystymi logami. Następnie012 skernelizował ogólną geometrię i masę,
a013/014 konkretny Gram i widmo. Pozostaje źródłowe powiązanie H≥991.
Jawny świadek1536 z ternarnymi f/g i dokładnym NTRU przeszedł też funkcję
certyfikatu C. **To jedna instancja, nie dowód o całym emitted KeyGen.**
Numeryczne przesłanki wskazane w009 zostały następnie powiązane z eksportami
ROM w010; historyczne źródła009 zachowują swoje pierwotne granice.

**Cel końcowy właściciela: dowód bezpieczeństwa FT1536 w QROM z deklaracją
na takim samym poziomie rygoru jak cel ROM.**
[Kontrakt tezy, założeń i obowiązków](notes/TARGET_CONTRACT_001.tex)
oddziela założenia kryptograficzne od lematów, które musimy domknąć.
Główne twierdzenie dotyczy rzeczywistego prawa kluczy FT1536; jednolity
all-h certyfikat jest silniejszym celem pomocniczym, nadal OPEN.
Nie uznano h=0 ani warunkowego budżetu MARGINAL-006 za końcowy wynik.

**Checkpoint samplera: [SAMPLER-007](notes/SAMPLER_007.tex).** Wykonalny sampler
„wektor przed wyzwaniem”, z zerową parą po cap80 i świeżym sześcianem po
cap196. Każda gałąź jest rozliczona w dominacji punktowej. Tekstowo `J≪P`
dla każdego h; pełny moment `e<2^-44` **pod jawnym warunkiem masy włókien (M)**.
Podano wystarczający warunek dokładnej bazy/LDL i dowód tekstowy (M).
**Świadek dla rzeczywistego emitted KeyGen pozostaje OPEN**, podobnie all-h.
Sage512/768 i dokładny crosscheck zakończone; brak nowego kernela.

[Tabela nazw ROM↔QROM i nonce](notes/ROM_QROM_ASSUMPTIONS_001.tex)
wiąże A1/A2/CompPRGBound z Q-MODEL/A-QMT/Q-PRG bez zmiany statusów ROM.
Nonce pozostaje 40-bajtowy (`2^320`); klasyczny wzór kolizyjny jest zgodny,
a koszt reprogramowania QROM nadal wymaga osobnego dowodu. Docelowa deklaracja
EUF-CMA w QROM pozostaje brzmieniem **po domknięciu świadków**, nie wynikiem 007.

[Przegląd drugiego okna](notes/REVIEW_006_001.tex): piny zgodne, świeży
replay skorygowanych 005 i 006 odtworzył certyfikaty 512-bitowe bajt w bajt;
230 dodatkowych dokładnych praw sprawdziło rachunek mieszanki capu.
Werdykt: **conditional on a named input**, bez statusu REVIEWED i bez
nowego kernela. Potwierdzono zakres wyniku, nie istnienie efektywnego S.

**Korekta numeryczna 005:** [erratum końców MPFR](notes/NORMALIZER_005_ERRATUM_001.tex)
zastępuje pierwotne numeryczne świadectwa normalizatora.
`QQ(endpoint)` mogło zaokrąglać do pobliskiego ułamka; nowe źródło używa
`endpoint.exact_rational()`. Ponowny rachunek zachował deklarowane granice.
Historyczne pliki i manifesty pozostają bez zmian; wiążące liczby są w
[skorygowanym certyfikacie](notes/NORMALIZER_005_CORRECTED_CERTIFICATE.json).

Właściciel uruchomił ten tor 2026-10-10: małe lokalne commity na main,
**bez push**, bez zmian statusów T12.1/B20, mainline, paperu i strony.
SAMPLER-004 przeniósł całą ówczesną pracę tutaj: źródła do `notes/` lub
`formal/`, runtime do `.build/`. **Bieżące polecenie okna i kontynuacji**
wyznacza próby w nowych podkatalogach
`work/FT1536_S05_QROM_001/{normalizer_005,marginal_006}/`, a wyniki,
źródła i receipty w tym development. Wcześniejsza
historia work i `.build/sampler_004/` pozostaje bez zmian.
Nie nadpisujemy prób. [Handoff 004](notes/SAMPLER_004_HANDOFF.json),
[lokalne zasady](AGENTS.md).

## Baza

- RECON-001: [źródło](notes/RECON_001.tex), baza `2d2cdf52304cee9cf513487d4296392262df22f4`.
- CONTINUATION-002: [źródło](notes/CONTINUATION_002.tex), tekstowy warunkowy
  lemat kompozycji z `D = (1+e)^q_s − 1`; kwantowe użycie wymaga jawnych
  przesłanek. Podstawienie `st := initial` wykorzystuje uniwersalny
  kwantyfikator `LocalJointCertificate`, nie odczytuje zapytań kwantowych.
- [Piny źródeł i oryginalnych pakietów](notes/BASELINE_PINS.json).

## Mapa murów

| Obowiązek | Stan |
|---|---|
| Algebra pojedynczej ekstrakcji, rachunek pełnego Sign, kierunkowy moment J/P | Zachowane w dokładnym dotychczasowym zakresie |
| Wspólna kontynuacja i kompozycja w grach programowanych | Dowód tekstowy warunkowy, CONTINUATION-002 |
| Wykonalny publiczny sampler pełnej odpowiedzi, również porażek | 016: konkretna referencja Lean i publiczne literały tablic; pełne prawa capów80/196 oraz zero/świeży sześcian kernelowe. J(none)=0 jawnie; uczciwe porażki pozostają w P. Pełny koszt maszyny OPEN |
| Absolutna ciągłość J względem uczciwego P | 016: KERNEL dla konkretnego actualSampler i każdego h, bez(M). Osobno source/API binding OPEN |
| Certyfikat `ΣJ²/P≤1+e`, z użytecznym e | 007: tekstowe `e<2^-44` pod (M). 014: kernelowe(M) z rzeczywistej bazy i H≥991;015: pełny kernelowy moment≤1+2^-47 pod jawną dominacją kodu. 017: rzeczywiste PairLeaves/CubeLeaf wypełnione i cały kod → moment≤1+2^-47 pod dokładnym(M). Emitted prawo i pokrycie(M) OPEN. 004 zachowuje h=0 `e<2^-50`; cel all-h OPEN |
| Dokładna baza/LDL → masa wszystkich włókien przy trzech temperaturach | **Kernel014**: konkretne współczynniki → monomiany/primary cap → kanoniczny Parseval → widmowy Schur →(M)007. Jawne wejścia: NTRU/public/inverse, ternarność i kanoniczna H≥991. Source harmonic nadal mixed, bez awansu całego C-KeyGen |
| Odziedziczone `BasisLeafAlgebra.ldl_shape` | 008: przeszkoda pierwszych dwóch pivotsów; tej instancji nie można użyć w obecnej postaci |
| Średnia harmoniczna i źródłowy liść767 | 010: H3 ROOT/STABLE +009 dają >1022 w emitted source model, tekstowo/mixed. 3 nowe marginesy kernelowe; full source kernel i typed key-law assembly OPEN |
| Kernelizacja h=0: `J≪P` i moment | **OPEN, obowiązek jawny:** przenieść SAMPLER-004 do Lean z czystymi logami; etykieta **textual** pozostaje. Szkic DyadicObstruction również nie ma potwierdzonego kernela |
| Normalizator reszty `Z₁(r)` i odwrotność, także `r=c−hz₂` | NORMALIZER-005: textual, jednolity względny przedział <2^-356; błąd TV samych kategorii przez cap16 <2^-236. Nie jest to TV do uczciwego P |
| Pełny normalizator `Z_h,c`, odwrotność i błędy uproszczeń | NORMALIZER-005: h=1,c=0, balls512/768; względne szerokości <2^-180 i TV zerowego aliasu przez cap16 <2^-180. Efektywna kontrakcja dla wszystkich h,c **OPEN** |
| Naturalne rozszerzenie sekwencyjne 004 do h≠0 | Dla h=1,c=0 moment **przed normą >2^1536**; sama precyzja nie naprawia zmienności normalizatora. Nie jest to dolna granica końcowego Q-JOINT |
| Ważony marginal `w(z₂)Z₁(c−hz₂)` i nowe capy | MARGINAL-006: nowy **warunkowy** certyfikat pełnego prawa z `e<2^-119`; wymagane nowe certyfikaty propozycji, monety i kosztu. Nie jest to świadek all-h Q-JOINT |
| Koszt odrzucania całych wektorów z propozycji `w/G` | h=1,c=0: akceptacja <2^-767 nawet z idealną monetą; potrzebna adaptowana propozycja lub faktoryzacja. Nie jest to ograniczenie wszystkich samplerów |
| Dokładny UniformChallengeAt z ustalonej taśmy uczciwych bitów | Niemożliwy: masy dyadyczne, moduł 18433 nie dzieli 2^bits; nie zmieniono przesłanek głównej linii |
| Klasyczny log hasza | Wymaga nowej semantyki QROM |
| Osadzenie `q_H+1` celów | Wymaga nowej konstrukcji Q-TARGET i straty |
| Klasyczna strata kolizyjna | Zgodna przestrzeń nonce `256^40=2^320` i wzór ROM; nowy rachunek reprogramowania QROM OPEN |
| To samo źródłowe h i prawo kluczy | 011: kernelowe interfejsy, pełna source/codec instancja OPEN.017: dwie kernelowe przeszkody w pinie18a3ffe3 (globalne VirtualLegal/Dimensions), wymagające naprawionego pinu i lokalnych świadków |
| Rzeczywiste prawo Sign i wszystkie wyjścia API | Q-BIND pozostaje OPEN; 011 nie zamienia modelowego P w cały program |
| Kwantowy PRG/seed, publiczny SHAKE/H2P (S04), zasoby reduktora | Osobne otwarte przesłanki |

Trzy przebudowy mechanizmów ROM nie są pełną listą wymagań QROM.
Mały błąd TV również nie zastępuje certyfikatu kierunkowego momentu.

## Struktura

- `notes/`: dokumenty wynikowe, piny, receipty i źródła rachunku Sage;
- `formal/`: nowe moduły Lean z jawnym zakresem weryfikacji;
- `obstructions/`: wspólna kolekcja zakresów, dowodów i pinów; materiał do ewentualnego Aneksu B;
- runtime i zachowana historia SAMPLER-004: `.build/sampler_004/`;
- nowe próby okna: `work/FT1536_S05_QROM_001/normalizer_005/` i `marginal_006/`;
- wcześniejsze podkatalogi work są niezmienionymi wejściami historycznymi.

Pierwszy commit jest zapisem źródeł rozpoznania, nie akceptacją dowodu.

## Checkpoint SAMPLER-003

[Wynik i pełne argumenty](notes/SAMPLER_003.tex),
[wykonywalne źródło Sage](notes/PUBLIC_SAMPLER.sage),
[certyfikat rachunku](notes/SAMPLER_003_CERTIFICATE.json),
[koszt, próby i receipty](notes/SAMPLER_003_RECEIPT.json),
[duże tablice przez generator/pin](notes/LARGE_ARTIFACTS.json).

Trzy syntetyczne wykonania sprawdziły kongruencję, normę i signed16;
obie gałęzie cap-failure sprawdzono również przy faktycznych limitach.
Limit to 150994944 prób par i 18 GiB zużytych bitów, czytanych leniwie,
bez takiej alokacji pamięci. Obserwowane wykonania po przygotowaniu tablic
zużyły 2625–2710 prób par; nie jest to benchmark produkcyjny.

Sage 10.9: rachunek ZZ/QQ i balls512 zakończony. Lean: 120 s timeout
pierwszego modułu i 60 s timeout samego importu. Drafty Lean zachowano
w kuźni; **niczego nowego nie oznaczono jako kernelowo sprawdzone**.

Wynik h=0 wyklucza konstrukcję 003 z małym e na całym Rq,
nie inne samplery. Poniższy krok 004 zachowuje ten niewygodny wynik
i buduje osobną poprawioną gałąź.

## Checkpoint — SAMPLER-004

[Pełny dowód tekstowy i następny interfejs](notes/SAMPLER_004.tex),
[wykonywalny sampler h=0](notes/HZERO_SAMPLER.sage),
[certyfikat rachunku](notes/SAMPLER_004_CERTIFICATE.json),
[koszt, receipty i zachowane próby](notes/SAMPLER_004_RECEIPT.json).

Dla **h=0 i każdego wyzwania** nowy sampler odtwarza prawo włókna
z kontrolowaną dominacją punktową. Obejmuje sukces, cap16, porażkę
modelowej emisji oraz rozliczony fallback pary. Łącznie z dyadycznym
wyzwaniem daje `J≪P` i `ΣJ²/P≤1+e`, `e<2^-50` (około 4.6840e-17).
To dowód tekstowy z rygorystycznym rachunkiem Sage, bez nowego kernela.

Koszt ograniczono do 2359296 propozycji par i 2419187712 bitów na odpowiedź,
czytanych leniwie; prekomputacja kategorii ma jawny limit 49152 przedziałów
wag. Sprawdzono cztery przypadki warunkowe oraz faktyczny fallback przy cap192.

**Cel S05-Q-JOINT-INSTANCE dla wszystkich h pozostaje OPEN.** Dla naturalnego
rozszerzenia wyprowadzono dokładny moment przed normą:
`E[Z_res] * E[1/Z_res]`. Dla h=0 jest równy 1; dla pozostałych h brak
użytecznego oszacowania. [34 dokładne testy tożsamości](notes/SAMPLER_004_RESIDUAL_CHECKS.json)
są małymi modelami kontrolnymi, nie dowodem dla parametrów FT1536.
Nie osłabiono końcowego kwantyfikatora ani nierówności momentu.

## Midpoint — NORMALIZER-005

[Dowód i dokładny zakres](notes/NORMALIZER_005.tex),
[skorygowany rachunek Sage](notes/FIBER_NORMALIZER_005_CORRECTED.sage),
[skorygowany certyfikat](notes/NORMALIZER_005_CORRECTED_CERTIFICATE.json),
[receipty i zachowane niepowodzenie](notes/NORMALIZER_005_RECEIPT.json),
[skorygowane porównanie precyzji](notes/NORMALIZER_005_CORRECTED_CROSSCHECK.json).
Pierwotne receipty są historią; korektę i jej nowe uruchomienia wiąże
[receipt MARGINAL-006](notes/MARGINAL_006_RECEIPT.json).

Odejmowanie minimalnej energii daje stabilny **względny** przedział
normalizatora każdej reszty i jego odwrotności. Dla pełnego włókna h=1,c=0
osobno obudowano ogony theta, zmianę kraty na box i niezerowe aliasy modulo q.
TV po cap16 obejmuje sukces oraz porażki normy i modelowej emisji;
nie warunkujemy prawa na sukces. Zapisano też dokładne prawo odpowiedzi
jako wielomian w prawdopodobieństwie akceptacji, bez dzielenia przez małą masę.

**Ograniczenie:** certyfikowany TV dla h=1,c=0 porównuje uczciwe prawo
z idealnym prawem zerowego aliasu. Nie skonstruowano jego nowego samplera
bitowego ani pełnego samplera Q-JOINT dla wszystkich h. Certyfikat kategorii
porównuje z kolei ten sam idealny sampler sekwencyjny, nie z uczciwym P.

Sage 10.9, balls512 i balls768: udane rachunki i dokładne porównanie
przedziałów; tekstowy dowód jednolity nie jest ekstrapolacją 16 fixture'ów.
Pierwszą nieudaną próbę (zbyt mocny próg momentu bloku >8) zachowano;
poprawny certyfikat daje >4, a dla 768 bloków >2^1536 przed normą.
Dokument skompilowano w edytorze. Nie ma nowego Lean ani niezależnego review.

Następny krok: kontrolować lub losować marginalne prawo
`w(z₂) Z₁(c−hz₂)`, z wykonalnym kosztem, albo zbudować inną konstrukcję
samplera włókna. **Q-JOINT-INSTANCE dla wszystkich h pozostaje OPEN**;
kernelizacja h=0 jest osobnym, nadal otwartym obowiązkiem.

## Checkpoint — MARGINAL-006 i kolekcja obstructions

[Nowy dowód prawa capów i momentu](notes/MARGINAL_006.tex),
[rachunek Sage](notes/MARGINAL_006.sage),
[certyfikat](notes/MARGINAL_006_CERTIFICATE.json),
[receipty](notes/MARGINAL_006_RECEIPT.json),
[kolekcja przeszkód](obstructions/OBSTRUCTIONS_001.tex),
[indeks z pinami i statusami](obstructions/INDEX.json).

Ważenie marginalu korzysta z tych samych certyfikowanych `Z₁`.
Nowa konstrukcja przygotowuje 16 par, każdą z własnym capem odrzucania;
wyczerpanie dowolnego capu daje pełne `none`. Jej dokładne prawo to
`J=(1−δ)Q+δ·none`. Świeży dowód obejmuje nośnik i koszt momentu
zależny od `δ²/P(none)`; dla `P(none)=0` dodatkowy abort narusza `J≪P`.

**Warunkowy** budżet daje `e<2^-119` dla pełnej pary wyzwanie–odpowiedź.
Nie przeniesiono certyfikatu h=0. Wymagane są osobno: propozycja na pełnym
boxie z kontrolą dwustronną, względnie dokładna skończona moneta i użyteczny
koszt. Obecny sampler 004 nie spełnia pierwszej przesłanki przez sam fakt
posiadania jednostronnej dominacji. Nie ogłaszamy implementacji all-h.

Przeszkoda kosztowa dla konkretnej próby jest rygorystyczna: przy h=1,c=0
propozycja `w/G` z odrzucaniem całego wektora ma akceptację <2^-767.
Nawet 2^128 propozycji daje prawdopodobieństwo jakiejkolwiek akceptacji
<2^-639. To nie wyklucza faktoryzacji blokowej ani innych propozycji.
Sage512/768 sprawdził też 102 dokładne małe prawa, wszystkie rodzaje porażek
w modelu testowym i kontrolę negatywną nośnika.

Kolekcja `obstructions` zawiera **DyadicObstruction**, moment przed normą
oraz nowy wynik kosztowy. Przy każdym wpisie są jawne kwantyfikatory,
non-claims i status kernela. DyadicObstruction ma tekstowy dowód i historyczny
szkic Lean; jego modułu nie uruchomiono po wcześniejszym timeout innego modułu.
Kolekcja nie zmienia paperu ani strony.

Następny krok: adaptowana propozycja lub kontrolowana faktoryzacja marginalu,
z nowymi certyfikatami oraz rzeczywistym kosztem. Kernelizacja h=0 i lematów
capu pozostaje **OPEN / textual**.

README jest żywym stanem. Historyczne manifesty, które pinowały README,
weryfikujemy względem ich commitów (003: `0a6999d7`). Nowe manifesty
pinują wyłącznie pliki wynikowe checkpointu.

## Checkpoint — SAMPLER-007 i tabela założeń

[Dowód](notes/SAMPLER_007.tex), [algorytm Sage](notes/VECTOR_FIRST_007.sage),
[certyfikat512](notes/SAMPLER_007_CERTIFICATE.json),
[certyfikat768](notes/SAMPLER_007_CERTIFICATE_768.json),
[porównanie dokładne](notes/SAMPLER_007_CROSSCHECK.json),
[koszt i historia prób](notes/SAMPLER_007_RECEIPT.json),
[checkpoint z mapą murów](notes/SAMPLER_007_CHECKPOINT.md).

Najwyżej 24 084 480 propozycji par i 24 662 538 240 bitów na odpowiedź,
z czytaniem leniwym i skończoną prekomputacją tablic. To jawny limit algorytmu,
nie certyfikat czasu maszynowego reduktora. Trzy syntetyczne wykonania,
rzeczywiste capy, 27 dokładnych małych praw i dwie precyzje nie zastępują
warunku o prawie kluczy. Źródła pierwszej wersji capów i nieudanego zapisu
JSON checkera zachowano wraz z przyczynami; runtime jest w `.build/sampler_007/`.

**Co dalej:** wykazać źródłowy świadek dokładnej bazy/atomów/LDL dla całego
wymaganego nośnika emitted KeyGen, potem kernelizować (M) i pełny moment.
Pozostałe mury QROM nie zmieniły statusu. W szczególności 007 nie zamyka
Q-SAMPLER dla FT1536, Q-BIND, Q-COLL ani całej deklaracji bezpieczeństwa.
