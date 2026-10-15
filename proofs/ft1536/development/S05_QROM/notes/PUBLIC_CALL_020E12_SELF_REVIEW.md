# TODO020E12 — kontrola autora

**Werdykt główny: conditional on a named input — niezmienione(M).**
Równość wywołania/EveryTape i AC są dowiedzione bez(M); moment jest dowiedziony
pod dokładnie starą MassCondition. Kontrola autora, nie niezależny odbiór.
Werdykt nie obejmuje native, pełnych zasobów lub bezpieczeństwa QROM.

## Karta tezy i źródło

Dla każdego rezydentnego PublicData i coins nowe wywołanie jest some(stary wynik).
Dla konkretnego prepared k i każdej taśmy jest some(some pełnej odpowiedzi
MachineLaw przy publicznym initial)). Po załadowaniu tego samego h nowe prawo
jest dokładnie MachineLaw.law h initial. Względem tego samego P: AC dla wszystkich h,
a drugi moment≤1+2^-47 pod SamplerMassCondition014.MassCondition h. Joint używa
tego samego mu i jawnego Covered/mass, zachowując h.

Autorytatywne typy: PublicCall020E12.run_eq/every_tape/full_response oraz
PublicCallLaw020E12.law_eq/all_h_ac/certificate/same_key_law. Dokładne piny
aktualnych i odziedziczonych źródeł/artefaktów są w CHECKS i manifestach E12.

## Ścieżki wykonania i zależności

Runtime przygotowania: konkretne E5 FillMachine i IndexedParser, następnie
materialize na skończonych, przypiętych kodekach portów. Nie ma swobodnego
samplera/lookupu dostarczonego jako przesłanka certyfikatu. Publiczne tabele
są rezydentnymi wejściami, nadal przypiętymi do wcześniejszej definicji.

Runtime startu: zeroed bank → stały IR E6 odczytujący publiczny root → kodowany
bufor → konsument E11. PublicStartupSpec.reference/program_code występują w
dowodzie, nie w runtime. Początek daje dokładnie publiczny initial i dawny ready.

Runtime rdzenia: zapisany producent E6 i raw driver/consumer E11, następnie
skończony readout i kopiowanie pełnego wyjścia. Ani witness/ofData, ani stary
CoreRun nie są implementacją nowego rdzenia. Pętla nie rekonstruuje historii.

Dowód: materializacja/porty + startup output/effect + E11 execute_refines →
fromRoot/fromArena → fromParser/run_eq → stary EveryTape → równość całego prawa
→ stary AC/moment. Główna równość nie jest przesłanką żadnego z tych etapów.
Liście: repozytoryjne dowody i jawny model; bez nowej zewnętrznej tezy lub
skończonego eksperymentu zastępującego dowód uniwersalny.

## Kontrola obowiązków

| Obowiązek | Wynik |
|---|---|
| Konkretny publiczny sampler kontra konstruktor warunkowy | Passed w wybranym modelu: faktyczne pętle przygotowania i kod startup/core; brak premise „sampler zgodny” |
| Wypełnienie banków i parser | Passed przez konkretne wykonania E5 i piny; koniec kursorów, parse failure i porty z pełnych stanów |
| Publiczny initial | Passed: reset banku i startup nie przyjmują prywatnego Core; tylko root z publicznego parsera |
| Nowy startup | Passed: stały kod, workspace, rzeczywiste96 słów, komplet slotów i sprawdzany konsument; stara lista tylko jako świadek |
| Root/push/limit | Passed: sp=1 kontrolowany, root pochodzi z parsera, limit i ramka są stare, pusty/niepoprawny root daje stary wynik |
| Wszystkie dane/taśmy a prepared program | Passed: run_eq dla dowolnego Data; EveryTape dla jawnie konkretnego prepared k, bez twierdzenia o dowolnym zmienionym programie |
| Wrapper errors kontra algorytmiczny abort | Passed: None i some none odrębne; canonical fallback nieosiągalny, abort(c,none) pozostaje pełną odpowiedzią |
| Utrata informacji/kondycjonowanie | Passed: WireFormat.wire_injective dla Rq×Option BoxVec, pełne prawo mapowane bez success filter lub renormalizacji |
| Ten sam h i mu | Passed: CostInput.same_key i identyczne mu po obu stronach joint; bez nowego źródłowego świadka KeyGen |
| Kierunek momentu | Passed: Divergence.second(J,P), AC(J,P); P to ten sam MachineCertificate.reference |
| To samo(M) | Conditional: dokładna MassCondition014 z trzema temperaturami, pełną masą i K>0; nie zmieniono żadnego zakresu/stałej |
| Stanowe/kwantowe zastosowanie momentu | Not addressed: to transport klasycznego pełnego prawa, nie nowa kompozycja QROM |
| Jednolity backend i pełny czas/peak | Out of scope: E12 używa bezpośrednich maszyn fill/parser E5; ich lowering i wszystkie koszty pozostają jawnie OPEN |
| Native, źródłowe(M), rzeczywiste KeyGen/Sign/PRG | Out of scope i OPEN, bez awansu z formalnego modelu |

## Kontrola(M) i statusów

Sprawdzono definicję źródłową: ∃K>0, dla każdego c i t w trzech temperaturach,
pełna nieskończona masa przy t/1179648 jest w przedziale względnym1±2^-34
wokół (t^-1)^1536 K. E12 nie dostarcza świadka dla rzeczywistego nośnika kluczy.
W certificate przekazuje to samo mass do MachineCertificate.public_initial.
W same_key_law przekazuje te same cover i mass do poprzedniego twierdzenia.

(M) zachowuje klasę obowiązku matematycznego, a nie nowego założenia
kryptograficznego. A-QMT i Q-PRG pozostają oddzielne i nie są instancjonowane.
Nie podano poziomu bezpieczeństwa ani deklaracji EUF-CMA w QROM.

## Walidacja i niepowodzenia

12 modułów wynikowych + audyt,52 twierdzenia,83 eksporty (w tym nieobliczalna
definicja prawa, ale obliczalny code/run).781 pinów zweryfikowanych; źródła
formal/ zgodne SHA ze snapshotami przyjętych buildów.13 końcowych logów czystych.
Aksjomaty tylko propext/Classical.choice/Quot.sound, bez sorryAx, nowych
aksjomatów, native_decide/bv_decide lub wyciszenia linterów.

39 prób zachowanych:13 końcowych,3 czyste sondy/częściowe proofy i23 błędne.
Sondy nie są liczone jako ukończone moduły wyniku.7 błędów to kontrolowane
przerwania Lean przy limicie4GiB; ujemny exit code wykluczył instalację mimo
error_count=0 w parserze niektórych logów. Przejście przez równość funkcji,
generic fuel i jawne kodeki pozwoliło uzyskać czyste dowody przy tych samych
limitach. Pozostałe błędy to typy/nazwy/koercje i jedna niegotowa zależność.
Wszystko jest opisane w CHECKS; brak stwierdzonego kontrprzykładu.

Komenda: `python3 -B notes/BUILD_LOW_MEMORY_020E2.py public_call_001 MODULE
FRESH_LABEL` (notes względem S05). Audyt: PublicCallAudit020E12/audit001.
Jeden Lean naraz, instalacja tylko exit=warning=error=0. Receipty są kosztami
kompilacji, nie ceną samplera. Brak benchmarku ogromnej taśmy i nowego rachunku
numerycznego/Sage; nierówność przeniesiono przez równość praw.

## Pozostała praca i redakcja

Domknąć pełny czas/peak całego pipeline'u, źródłowe pokrycie(M) i pozostałe
obowiązki source/QROM. Jednolite obniżenie fill/parser do backendu zachowuje
osobny zakres. Nie przenosić starych kosztów bez rachunku nowych kopii/portów.

Przeczytano nowe definicje, twierdzenia, warunki i dokumenty w kontroli autora
oraz proofread-math. Nie ma zmian matematycznych ukrytych jako redakcyjne ani
zmian dawnych pakietów/T12.1/B20/paperu. Bez dodatkowego reviewera, restartu
monitora ROM lub push.
