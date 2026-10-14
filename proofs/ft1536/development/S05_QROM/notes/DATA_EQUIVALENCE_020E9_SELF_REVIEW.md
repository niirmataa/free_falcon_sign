# TODO020E9 — kontrola autora

**Werdykt dla tezy E9: proved as written (kernel, scoped).** To kontrola
autora, nie niezależny odbiór. Teza całej kampanii QROM pozostaje niekompletna.

## Teza i źródła

Dla każdego `d : BoundaryPayload020E5.Data`, `fresh : Bool`, przy
`d.core.phase ≠ act`, rzeczywisty wynik `ProducerStored020E6.run d fresh`
jest kodowaniem konkretnego bufora, którego wykonanie na `image d.core`
daje `image (CoreStep.step d.parser.arena (input d) d.core)`.
Zakres clear/scan/push obejmuje wszystkie takie stany, a nie tylko osiągalne.
Autorytatywne typy: `ProducerNonact020E9.executed/script/reference_effect`,
`ProducerNonactConsumer020E9.unique/execute` oraz slotowe lematy E9.
Baza i piny: CHECKPOINT, CHECKS i manifesty E9; źródła przypięte w receiptach.

## Zależności

1. Niezmieniony kod E6 → rzeczywisty odczyt E7 → scalar env d.
2. Flagi E8 i skan E8 → E9 obecność/adres/wartość → wszystkie sloty danych.
3. Sloty danych + kontrola E8 + ogon E8 → pełna równość kodowania E9.
4. Poprawność prymitywnych patchy E5 + jawna lista E9 → CoreData.next.
5. Kontrola E5 + reconstruct → CoreStep; z E7 reference_effect także równość
   efektów z dawną referencją. Żadna z tych krawędzi nie zakłada wyniku E9.
6. Iniektywność kodeka → jednoznaczność bufora rzeczywistego wyjścia.

Liście: repozytoryjne dowody Lean oraz jawny model Word512/banków/instrukcji.
Nie dodano zewnętrznego twierdzenia, założenia kryptograficznego lub obliczenia
skończonego zastępującego dowód uniwersalny. Brak nowego rachunku numerycznego;
Sage nie był potrzebny do tych symbolicznych równości kernelowych.

## Kontrola obowiązków

| Sprawdzenie | Wynik i granica |
|---|---|
| Rzeczywisty kod kontra dowolny konstruktor warunkowy | Passed: wyjście run, proved E7 stored_output; świadek E9 zbudowany bez przesłanki zgodności |
| Kwantyfikatory | Passed: wszystkie typowane Data i oba fresh; bez Inv/reachability/success |
| Obecność vs zerowy payload | Passed: clear_zero/scan_absent mają some(pointer,0), a nie none |
| Koniec skanu i trzecia pozycja | Passed: cursor=877 brak danych; aktywny cache ma dokładnie dwa zapisy |
| Push one/two, kolejność | Passed: one f zapisuje f; two f g zapisuje g, sterowanie E8 zachowuje one f |
| Pełny stos i pusty pending | Passed: brak danych w obu; kontrola rozróżnia check dla none oraz bad dla one/two |
| Niepoprawne wejścia skanu | Passed przez uniwersalny skan E8; brak nowego zawężenia |
| Adresy i kodowanie | Passed: valuePointer/framePointer, adresy w Fin143922, pełne pola trzech słów |
| Równość efektów | Passed na image d.core; nie roszczenie równości surowych list ani dowolnych surowych banków |
| Placeholder act=[] w specyfikacji pomocniczej | Jawna granica: zgodność efektu i pełnego wyjścia wymaga phase≠act |
| Przesłanka kodowania w konsumencie | Passed: identyfikacja bufora; script niezależnie dowodzi istnienia, unique usuwa wybór świadka |
| Cały sampler, J/P, moment, publiczny initial | Not addressed: brak nowego transportu; stare(M) i zakres bez zmian |
| Native/pełny czas i peak/QROM | Out of scope, pozostają OPEN |

## Próby i walidacja

11 modułów + audyt, 49 twierdzeń, 55 sprawdzonych typów/zbiorów aksjomatów.
12 końcowych logów bez błędów/ostrzeżeń; tylko standardowe aksjomaty Lean.
Wszystkie 731 pinów źródeł/artefaktów sprawdzone; nowe źródła formal/ zgodne
SHA ze snapshotami zaakceptowanych uruchomień. Brak sorry/admit, nowych
aksjomatów, native_decide/bv_decide i wyciszania linterów w źródłach wyniku.
19 prób zachowanych; 7 nieudanych ma przyczyny w CHECKS. Kontrola nie promuje
ich do sukcesów. Resource receipt dotyczy kompilatora, nie samplera.

Uruchomienia: `python3 -B notes/BUILD_LOW_MEMORY_020E2.py data_equivalence_001
MODULE FRESH_LABEL` (ścieżka notes względem S05); świeży runtime, dziedziczone
piny E8, brak równoległych procesów Lean. Końcowy audyt: ProducerDataAudit020E9,
label audit001. Instalacja tylko po exit=warning=error=0. Bez replayów innych
wykonawców, restartu monitora ROM, niezależnego modelu lub push.

## Pozostała luka i samo-redakcja

Najmniejsza brakująca część pełnej zgodności rdzenia: semantyka act
(action/edits/pending i kontrola), następnie złożenie bez ograniczenia fazy.
Pozostałe rodziny producenta i cały cykl alokacji wymagają osobnych dowodów.

Przeczytano nowe twierdzenia, dowody, granice i zmienione dokumenty w trybie
self-review/proofread-math. Brak korekt historycznych plików lub matematycznych
zmian przedstawianych jako redakcyjne. Bez zmiany statusów T12.1/B20/paperu.
