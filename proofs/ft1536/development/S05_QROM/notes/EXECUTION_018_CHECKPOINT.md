# EXECUTION018 — dokładny sampler, ślad i szerokości

**PARTIAL_PROOF / WARUNKOWY / NOT_REVIEWED; pakiet018 nadal IN_PROGRESS.**
Pierwszy checkpoint źródeł: `9d341afbc627e8e799cf58fbcd4026d9ab91fc69`.
Pełne zdanie dla czytelnika bez repo: [EXECUTION_018.tex](EXECUTION_018.tex).
Plan pozostaje [EXECUTION_018_PLAN.md](EXECUTION_018_PLAN.md); nie zmieniono
zamrożonego TODO z017. Brak deklaracji bezpieczeństwa QROM.

## Co rzeczywiście wykazano

- **39 eksportów rdzenia:** binarny pierwszy próg CDF (≤15 probes oraz
  osobny odczyt terminalny), zapisane wektory i wyjście, scatter mnożenia
  oraz równość całego samplera na każdej taśmie. Capy80/196, zerowa para
  i świeży cube są zachowane. Syndrom ma2359296 par i≤4718592 aktualizacji.
- **Pełny certyfikat:** `StoredInterface018` przenosi J≪P dla każdego h
  oraz moment≤1+2^-47 pod niezmienionym(M), także z publicznym initial
  i dla tego samego pokrytego prawa kluczy. Modelowane porażki nadal są
  częścią P. Nie wprowadzono dokładnej jednostajności challenge z taśmy.
- **34 kolejne eksporty:** ślad ważony wybranych zdarzeń ze wszystkimi
  gałęziami, jego rozwinięty budżet oraz szerokości. CDF<2^268,
  progi<2^257, adresy prywatnych bitów<2^35; na całym boxie, także dla
  odrzuconych propozycji, 0≤Q<2^45. Reszty pola przed mnożeniem/redukcją
  dają iloczyn<2^29 i sumę<2^16. Pięć eksportów to kontrole brzegowe.

Łącznie **73 eksporty w10 modułach**, z audytem wydrukowanych typów i
aksjomatów. Nowe logi wybranych prób są czyste; brak sorryAx i
native_decide. `decide +kernel` dla kontroli jest sprawdzane przez kernel.
Kompilacyjny audyt zależności nowego interfejsu:3 korzenie,151019 stałych,
0/14 zakazanych konsumentów F03/F04, brak nieznanych definicji. To wąska
kontrola metadanych, nie pełny audyt matematyczny ani audyt F05.

[CHECKS](EXECUTION_018_CHECKS.json) wiąże13 udanych buildów modułów/audytów,
351 zachowanych wejść i logi. Suma czasów tych procesów to43.364s;
**jest to koszt sprawdzania dowodów, nie wykonania samplera**.
Sage10.9 ze standardowym preparserem potwierdził11 liczników, rachunki
szerokości i4 małe kontrole zatrzymania. Wynik:
[EVENT_BOUNDS](EXECUTION_018_EVENT_BOUNDS.json). Sage nie zastępuje dowodów
uniwersalnych Lean. Natywny kompilator dokumentu LaTeX zwrócił success.

## Dokładna granica wyniku o kosztach

`SamplerTrace018` jest specyfikacją śladu wybranych wywołań/zdarzeń.
`run_bound` obowiązuje dla dowolnych nieujemnych wag; po ustawieniu wag
jednostkowych nie otrzymujemy kosztu instrukcji CPU. Instrumentacja może
odtwarzać obliczenia używane w licznikach; jej własny runtime nie jest
runtime'em docelowego samplera. Nie wykazano jeszcze refinamentu do
pełnej semantyki instrukcji ani boundu pamięci szczytowej.

Pełna taśma ma24662538240 bitów, czyli3082817280 bajtów przy materializacji.
Nie deklarujemy małej pamięci strumieniowej ani darmowego losowego dostępu.
Tablice wymagają osobnego przygotowania/reprezentacji; odczyt z literalnej
funkcji Lean nie staje się automatycznie stałokosztowym odczytem RAM.
Szerokości wybranych wartości nie dowodzą zakresu każdej instrukcji.

## Mapa murów i dokładny następny krok018

| Obowiązek | Obecny stan | Następny wymagany wynik |
|---|---|---|
| Q-SAMPLER, prawo zoptymalizowanego kodu | KERNEL: równość na tej samej taśmie, AC i moment pod(M) | Zachować ten kod jako punkt odniesienia dla maszyny |
| Q-RESC, wykonanie samplera | PARTIAL: ślad wybranych zdarzeń i szerokości | Jawne instrukcje pamięci/słów/adresowania, erasure do StoredInterface018, kalibracja wszystkich gałęzi, koszt tablic/taśmy/wyjścia i szczyt pamięci |
| Q-KEY / źródłowe(M) | OPEN | Pełny retry/codec/emission law, to samo h i prawo kluczy, źródłowe H≥991; konsumpcja nowych pinów po naprawach ROM |
| Q-BIND / Sign / Q-PRG hop | OPEN | Powiązać uczciwe P z grą wariantu A i rzeczywistym Sign/PRG; nie zakładać UniformChallengeAt |
| Q-HASH-LOG / Q-EMBED / Q-COLL / Q-COMPOSE | OPEN | Własne mechanizmy kwantowe, straty, reprogramowanie i zasoby reduktora |

Najbliższa trasa018: zamienić ledger zdarzeń na kompletny program w
jawnej maszynie pamięci/słów, z dowodem równości obserwacji. Najpierw
rozstrzygnąć reprezentację prywatnej taśmy i tablic; potem uzupełnić
adresowanie, arytmetykę normy i pola, przepływ sterowania oraz pamięć.
Przy wyborze streamingu potrzebny jest nowy most prawa, a nie ciche
usunięcie opuszczanych bitów. Alternatywa B (koszt dosłownej referencji)
nadal dostępna; alternatywa C (koszt C) czeka na source refinement.
To wykonalne kontynuacje, nie wyczerpane ani obalone trasy.

F04: właściciel wybrał **wariant A** — challenge rzeczywistego Sign
pochodzi z ROM poza prywatną taśmą. [Decyzja i scope](ROM_VARIANT_A_018.md).
Commit b92f79a9 zapisuje wybór modelu, nie świadków naprawy12 konsumentów.
S05 zachowuje publiczne wspólne losowanie (A_hz,some z2); jego powiązanie
z naprawioną grą wymaga osobnego dowodu. Poprawek ROM nie przejęto.
Nonce320 i warunkowe użycie D=(1+e)^q_s−1 pozostają bez zmiany.

## Zachowane próby i procedura odtworzenia

Runtime: `.build/execution_018/`, każdy label jest świeży.17 prób Lean
z błędem lub ostrzeżeniem zostało zachowanych z receptami, źródłem i raw
logs. Przyczyny: zależne przepisywanie/projekcje, zbyt duże rozwinięcie
referencji, składnia sum/typowanej pary, brakujące nazwy i unused simp.
Szczegóły prób i SHA zawiera CHECKS; nie są zaliczane do udanych proofów.
Próba trace001 wystartowała po odmowie instalacji ostrzegającego meter002;
jej brakująca zależność jest jawnym nieudanym uruchomieniem. Instalator
prawidłowo odrzucił moduł z ostrzeżeniem.

Sage exact001: wrapper mamba uruchomił inicjalizację R/Java, napotkał
błąd alokacji JVM i timeout120s. Pierwszy prosty wrapper nie zapisał
receipt po wyjątku; zachowano pliki i jawne RECOVERY_OBSERVATION.json
z wynikiem narzędzia. exact002: standardowy Sage wykonał asercje, lecz
serializacja metadanych Integer do JSON zawiodła. exact003: ten sam
rachunek, jawna konwersja metadanych do int, exit0 i pusty stderr.
Nie instalowano ani nie zmieniano środowiska. Korekta draftu liczby
eksportów rdzenia40→39 jest zapisana osobno; nie zmienia dowodów.

Odtworzenie wymaga przypiętej closure351 modułów017 i wskazanych bibliotek
Lean4.34.0/Mathlib z INPUTS, następnie BUILD_EXECUTION_018.py z nowymi
labelami w kolejności listy modułów CHECKS. Po każdym czystym buildzie
używa się `install NAME LABEL`. To nie uruchamia cudzych workerów ani
ich replayów. Sage: RUN_EXECUTION_CHECK_018.py z nowym labelem uruchamia
bezpośrednio istniejący `sage CHECK_EXECUTION_018.sage` ze standardowym
preparserem, bez mamba activation. Cache/tmp pozostają pod tym runtime.

Klasy i kolejka: [CERTIFICATE_CLASSES_018](CERTIFICATE_CLASSES_018.json),
[KERNEL_QUEUE_018](KERNEL_QUEUE_018.json). Wszystko jest wynikiem autora,
bez niezależnego odbioru, bez statusu REVIEWED i bez push.
