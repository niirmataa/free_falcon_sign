# TODO020E6 — producent: wykonanie i pamięć lokalna

**IN_PROGRESS / PARTIAL_KERNEL / WARUNKOWY / NOT_REVIEWED.**
Polecenie właściciela: domknąć producenta poleceń z policzoną pamięcią roboczą.
**Całego polecenia jeszcze nie zamknięto.** Poniższe wyniki są rzeczywistym
krokiem ku temu celowi, nie zastąpieniem zgodności źródłowej certyfikatem typów.
Baza S05: `3aed7cb57767886318625927252d4880ecc0c114`.
Pierwszy commit tej pracy: `6e677a8b4b7e8843df35e99b40fa3477928b93cb`.
Dalsze źródła i kontrole: `1ea98b3e393103922d54b642c70674f1dc655561`.
Runtime: `.build/pair_machine_020/producer_001/`. Jedno okno, jeden ciężki
proces naraz, bez push, zmian T12.1/B20 i niezależnego odbioru.

## Co wykazano

1. `ProducerMachine020E6.Instruction` jest zamkniętym zbiorem instrukcji:
   literal, copy, binary Word512, checked load, output i select. Nie zawiera
   dowolnej funkcji hosta, makra wywołującego stary generator ani konstruktora
   wielkich tablic. Operacje słowowe to ten sam jawny model `WordRAM020.op`.
2. `ProducerCompiler020E6.correct` wiąże wyrażenie skalarne z faktycznym
   wykonaniem skompilowanych instrukcji. `ProducerFrame020E6` dowodzi ochrony
   wcześniejszych rejestrów; `need` ogranicza zajęty zakres do 64 rejestrów.
   Nie jest to wniosek z długości listy wynikowej.
3. `ProducerEmit/Batch/Execution/Program` wiążą zapis wszystkich 96 słów
   wyjścia, odczyt skończonego banku instrukcji, licznik programu i zakończenie.
   Poprzednia zawartość wyjścia jest nadpisywana. Listy/AST służą przygotowaniu
   kodu i specyfikacji; wykonawca czyta zainstalowany kod po indeksie.
4. `ProducerFetch020E6` przechowuje również pobraną instrukcję i fazę
   fetch/execute. `ProducerFetchStore/Trace` dają rzeczywiste ślady zapisów
   wszystkich tych danych. Nie pomijamy rejestru instrukcji w rachunku.
5. `ProducerInitial020E6.allocated_image` wiąże cały początkowy obraz roboczy
   z `ALLOC_ZERO`, a nie tylko z deklarowaną liczbą komórek.
6. `ProducerMemory020E6.complete_peak` instancjonuje kontekst rzeczywistymi
   tablicami wejściowymi i zapisanym kodem. Dla r tablic o rozmiarach extent
   oraz programu długości n każdy stan śladu ma w modelu RegionRAM dokładnie
   `sum(extent) + 2*r + 22*n + 190` słów. Granice tego twierdzenia: pojedyncze
   wywołanie maszyny, dostarczone rezydentne źródła/kod, model in-place;
   brak twierdzenia o native Lean/C ani o całym samplerze.
7. Powstał konkretny kandydat producenta rdzenia: program odczytujący dane
   do okna oraz program zapisujący 32 stałe sloty. Sloty 0–2 to opcjonalne
   zapisy danych, 3–18 to 16 słów sterowania, reszta jest zerowym dopełnieniem.
   `ProducerStored020E6.invoke` przyjmuje już zapisany kod, bez kompilacji
   lub budowania tablicy kodu wewnątrz wywołania.
8. `ProducerStored020E6.run_words` i `ProducerPipeline020E6.run_words` dowodzą
   zgodności wykonania kandydata z **jego własnymi wyrażeniami**. Odczyty
   metadanych, ramek, wartości, rejestrów, RAM i parsera mają osobne kernelowe
   powiązania z zakodowanymi bankami. `ProducerCheckPhase020E6.phase` wiąże
   wybór fazy check. To części źródłowego mostu, nie cały most.

## Dokładne rozmiary

Sage 10.9 w standardowym trybie oraz `ProducerNumbers020E6` w kernelu:

| Element | Liczba |
|---|---:|
| Program odczytu okna | 3469 instrukcji |
| Program wytworzenia slotów | 11 264 instrukcje |
| Rejestry skalarne | 64 słowa |
| Wyjście: 32 sloty po 3 słowa | 96 słów |
| PC i flaga diagnostyczna odczytu | 2 słowa |
| Pobrana instrukcja z tagiem obecności | 23 słowa |
| Faza fetch/execute | 1 słowo |
| Payload roboczy pojedynczej maszyny | **186 słów = 11 904 bajty** |
| Zapisany kod odczytu okna | 76 318 słów |
| Zapisany kod wytworzenia slotów | 247 808 słów |

Jedna instrukcja jest bezstratnie zakodowana w 22 słowach; układ jest
konserwatywny i przechowuje także nieaktywne części wariantów. Dwa nagłówki
regionów (kod + stan roboczy) dodają 4 słowa. Przyrost ponad już rezydentne
źródła wynosi więc 76 508 słów dla programu okna i 247 998 dla programu
slotów. **11 904 bajty nie obejmują kodu, wejścia ani czasu życia drugiego
etapu. Nie jest to pełny peak dwufazowego producenta.** Osobny bound dla
programu slotów z własnym 96-słowowym wejściem to 248 096 słów.

Wyrażenia/kod są publicznym, stałym przygotowaniem niezależnym od h i taśmy;
obrazy kodu pozostają policzonymi danymi. Koszt przygotowania/ładowania oraz
sterownik obu etapów muszą zostać włączone do całościowego rachunku.

## Porażki i semantyka odczytu

Niepoprawny adres w instrukcji checked load zapisuje zero i ustawia trwałą
flagę diagnostyczną producenta. Nie jest to abort. `select` może obliczać
obie gałęzie; wybrana wartość ma dowiedzioną semantykę wyrażenia, a flaga
pozostaje zapisana i policzona. To odrębna flaga od `d.core.state.fault`
samplera. Nie wolno dodać abortu zależnego od tej flagi podczas integracji
bez nowego dowodu zgodności. Wszystkie operacje i ta granica są jawne.

## Kontrola skończona, nie awans do dowodu

`ProducerCoreExport020E6` wyeksportował faktyczny kod kandydata. Niezależna
implementacja rachunku w `.sage` porównała go z osobno zapisanymi regułami
stanów w 4480 syntetycznych oknach. Uwzględniono siedem faz, 16 tagów,
ramki run/again, braki wartości, granice adresów i słów signed512.
Wynik: `FINITE_DIAGNOSTIC_PASS_NOT_UNIVERSAL_PROOF`. To nie jest wyczerpujący
przegląd przestrzeni wejść ani dowód, że każde okno odpowiada rzeczywistemu
stanowi źródłowemu. Nie znaleziono kontrprzykładu w tym zakresie.

## Dokładna pozostała luka

Brakuje uniwersalnego połączenia:

`wykonanie zapisanych programów = wyrażenia kandydata`

z:

`wytworzony bufor realizuje ten sam krok co CoreStore020E5/CoreStep020E5`.

Do tego potrzeba obu konkretnych świadków:

- `eval(sources d fresh, ProducerWindow.cells j) = ProducerSnapshot.fields d j`
  dla wszystkich d, fresh i j; mamy część odczytów, nie cały 96-słowowy most;
- zgodności obliczeń `ProducerCoreCircuit/Slots` z poprzednią decyzją danych
  i sterowania, także dla wszystkich odrzuceń. Kontrola 4480 okien nie jest
  świadkiem tego lematu. Inactive padding może różnić kolejność slotów;
  wymagana jest równość efektu, nie sztucznie identyczna lista.

Następnie trzeba zamknąć producentów pozostałych rodzin (parser,
wypełnianie, inicjalizacja), powiązać oba wywołania i okres życia zachowanego
okna w jednym sterowniku oraz policzyć przygotowanie/kod. Dopiero taki
wynik zamknie pozycję producenta E5-5. Pełny peak/czas samplera, źródłowe
pokrycie (M), Sign/PRG i QROM nadal są osobnymi otwartymi zobowiązaniami.

Nie przeniesiono certyfikatu J/P z 020E5 na niepowiązanego kandydata020E6.
Wcześniejsze dowody J/P pod tym samym (M) pozostają nienaruszone.

## Walidacja i proweniencja

37 modułów wynikowych, 118 twierdzeń, audyt 309 eksportów. Końcowe logi
wynikowe są czyste; audyt jest kontrolą autora, nie niezależnym odbiorem.
Dwa moduły eksportu z #eval są diagnostyką i nie są częścią liczby modułów
wynikowych ani świadkiem uniwersalnej poprawności.
Receipty/piny: `PRODUCER_020E6_CHECKS.json`, manifesty
`PRODUCER_020E6_OUTPUTS.sha256` i `PRODUCER_020E6_RUNTIME.sha256`.
Wszystkie nieudane próby zachowano osobno. Obejmują błędny początkowy układ
katalogów importów, limity rozwijania konkretnych definicji, błędy prób
Lean oraz dwa błędy harnessu Sage (typ seeda i serializacja Integer).
Naprawy nie zmieniły matematycznych przesłanek; wyniki nieudane nie są PASS.
