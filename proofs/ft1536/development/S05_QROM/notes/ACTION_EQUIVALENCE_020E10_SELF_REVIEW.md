# TODO020E10 — kontrola autora

**Werdykt: proved as written dla tezy pojedynczego kroku E10.** Kernelowy,
ściśle określony zakres; to kontrola autora, nie niezależny odbiór.
Nie jest to werdykt dla całego samplera lub tezy bezpieczeństwa QROM.

## Karta tezy

Obiekty: każdy typowany `BoundaryPayload020E5.Data`, oba `fresh : Bool`;
żadnych przesłanek Inv, reachability, poprawności programu, fazy lub sukcesu.
Źródło: niezmieniony zainstalowany producent E6, czytnik E7. Cel: istnienie
bufora o rzeczywistym96-słowowym kodowaniu wyjścia, którego wykonanie na
kodowaniu d.core jest dokładnie kodowaniem starego CoreStep. Iniektywność
kodeka daje jednoznaczność i twierdzenie dla każdego tak zidentyfikowanego
bufora. Dokładne typy: `ProducerWholeStep020E10.executed/script/unique/execute`.
Piny źródeł i obiektów: CHECKS i manifesty E10; baza i commity w CHECKPOINT.

## Łańcuch dowodowy

1. `ProducerActSource.result` = top.bind starej FixedAction.action. run_node
   i again_node rozwijają tylko to samo źródło, bez zastępczego tokenowego
   orakulum. Wartości pamięci pochodzą z tego samego d.tape/d.rom/core.
2. Czytnik E7 → snapshot → małe lematy odczytu/tagów/skalarnych warunków.
3. Wszystkie rodziny tokenów i run/again → `ProducerActDecision.correct`.
   Nieobsługiwane tagi i brak węzła są jawnie odrzucone, nie odfiltrowane.
4. Decyzja + Edit/Pending →16 słów sterowania i trzy sloty danych act.
5. Prymitywne patche E5 → efekt listy Edit; lista E9 daje pozostałe fazy.
   Sterowanie i reconstruct E5 zamykają kanoniczny efekt CoreStep.
6. Act + E9 + ogon E8 → pełne kodowanie rzeczywistego wyjścia bez ograniczenia
   fazy. Iniektywność kodeka usuwa dowolność świadczącego bufora.

Liście są repozytoryjnymi dowodami kernelowymi i jawnym modelem
Word512/banków/instrukcji. Brak nowego zewnętrznego twierdzenia lub założenia
kryptograficznego. Dowód nie zależy od swojej tezy ani od testu skończonego.

## Kontrola zakresu i trudnych przypadków

| Obowiązek | Wynik |
|---|---|
| Wszystkie16 tagów, dowolny payload Word512 | Passed: decyzja dzieli run na3–11 i pozostałe, again na11 i pozostałe |
| Niedopuszczalne rejestry i ujemne payloady | Passed: dokładnie stara semantyka regOf/toInt.toNat; bez zastępowania walidacją native |
| Brak top/node/argumentu | Passed: pełna Option-semantyka; brak założenia sukcesu |
| Sekwencja/branch | Passed: właściwa kolejność dwóch ramek i wybór pierwszej/drugiej przy wartości0/≠0 |
| Pętla0, brak guard, guard0/≠0, again ponad limitem | Passed: osobne przypadki; count(k−1) ma wykazany zakres; brak wymogu dodatniego licznika |
| ROM/RAM/tape: dobry i zły adres | Passed: exact address/isSome i rzeczywiste odczyty snapshotu, nie dowolna dostarczona wartość |
| Store/emit: zły adres i brak wartości | Passed: stara akcja fault jest zachowana przed odczytem wartości; dobry adres wymaga wartości |
| Odmowa vs fault | Passed: osobne kernelowe eksporty Boundary; bad/stary fault kontra push/fault=true |
| Aktywny zapis z wartością0 | Passed: obecność wynika z rodzaju Edit, a nie z niezerowej wartości |
| Pozostałe pola keep/fault | Passed: surowy nieaktywny adres/payload nie jest porównywany do sztucznego zera; slot obecności jest0 |
| Pełny bufor96 słów | Passed: sloty danych, sterowanie i padding; bez pozostawionej przesłanki fazy |
| Stary krok i porównanie referencji | Passed na kodowaniu typowanego stanu; bez roszczenia surowej równości starych/nowych list |
| Bufor istnieje czy jest tylko założony | Passed: script konstruuje go; unique/execute używają tylko identyfikacji kodowania |
| Runtime decoder/driver/pełny przebieg | Not addressed: semantyczny świadek nie zastępuje wykonywalnego konsumenta kodowanych słów |
| Pełny czas/peak, EveryTape/J/P, source/QROM | Out of scope; OPEN, niezmienione(M), initial i domena |

## Walidacja i niepowodzenia

30 modułów wynikowych + końcowy audyt. 114 twierdzeń i126 sprawdzonych
zestawów typ/aksjomaty. Wszystkie31 przyjętych uruchomień bez błędów lub
ostrzeżeń. Aksjomaty tylko propext/Classical.choice/Quot.sound; brak sorryAx,
nowych aksjomatów, native_decide/bv_decide i wyciszania linterów.

Zweryfikowano761 pinów źródeł i artefaktów, zgodność formal/ ze snapshotami,
logi i zakres własnych commitów.46 uruchomień zachowanych:14 z błędami,
jedno warning-only nieprzyjęte,31 czystych. CHECKS opisuje każde niepowodzenie.
W szczególności brak zależności control001 i diagnostyka po błędzie typu
layout001 nie zostały ukryte ani dopuszczone do biblioteki. Nie znaleziono
kontrprzykładu; problemy dotyczyły konstrukcji/elaboracji dowodów.

Komendy: `python3 -B notes/BUILD_LOW_MEMORY_020E2.py action_equivalence_001
MODULE FRESH_LABEL` (notes względem S05). Serial runner uruchamia jeden Lean
naraz i instaluje tylko exit=warning=error=0. Audyt: ProducerActAudit020E10,
audit001. Nie zwiększano limitów pamięci. Statystyki receiptów dotyczą
kompilacji dowodu, nie czasu/pamięci samplera. Sage nie był wymagany dla
nowego rachunku, ponieważ nie dodano obliczenia numerycznego.

## Pozostała luka i samo-redakcja

Najbliższe brakujące połączenie: konkretny konsument kodowanych96 słów oraz
sterownik wielokrotnego uruchomienia producenta/kroku, z pełnym wynikiem
przy porażkach i wyczerpaniu paliwa. Potem transport EveryTape/J/P pod tym
samym(M), pozostałe rodziny producenta i pełny rachunek zasobów.

Przeczytano nowe definicje/twierdzenia, dowody i dokumenty w trybie kontroli
autora oraz proofread-math. Brak matematycznych zmian przedstawionych jako
redakcyjne, brak zmian historycznych pakietów/T12.1/B20/paperu. Bez nowego
reviewera, wznowienia monitora ROM lub push.
