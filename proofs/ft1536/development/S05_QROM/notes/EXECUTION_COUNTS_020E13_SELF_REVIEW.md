# E13 — kontrola autora

**Werdykt dla dokładnie poniższej tezy: proved as written, KERNEL_SCOPED.**
To self-review autora przy użyciu procedur mathbox:proof-audit,
mathbox:computation-audit i mathbox:proofread-math. Nie jest niezależnym
odbiorem, statusem REVIEWED ani dowodem pełnego czasu/peak.

## Teza i zależności

Dla dowolnego rezydentnego kodu i źródeł instrumentacja fetch/execute
zachowuje stan. Z initial daje dokładnie codeSize cykli. Dla dowolnego stanu
sprawdzanego konsumenta zachowuje stan i wiąże liczbę przejść/skanów/zapisów
z rzeczywiście wybraną gałęzią. Dla dowolnego Context, Memory i paliwa F
surowy driver zachowuje wynik i spełnia Valid: cycles=14733*rounds,
slots=32*rounds, writes≤scans≤slots, rounds/tests≤F. PublicCallCount
wykonuje pełną ścieżkę E12, zachowując wynik, i udostępnia te liczniki
**samego rdzenia**. Dla kanonicznego prepared programu wynik jest wcześniejszą
pełną odpowiedzią dla każdej taśmy, z publicznym initial.

Graf: ProducerMachine.execute_pc → Fetch.cycle_vm/phase → ProducerCount
→ ProducerExactCount → ProducerPairCount; CommandDecode/Consumer →
ConsumerCount i granice; obie gałęzie → CoreStepCount → CountedLoop
→ CoreDriverCount → CoreResultCount → PublicCoreCount/PublicCallCount.
E12 dostarcza wcześniejszą zgodność pełnego publicznego wykonania.
Sage wylicza liczby ze źródeł definicji; ExecutionCountNumbers sprawdza je
ponownie w kernelu. Nie ma krawędzi od testów do uniwersalnej indukcji.

## Sprawdzone obowiązki

| Obowiązek | Wynik |
|---|---|
| Quantifiers obejmują każdą taśmę/Data, bez success conditioning | PASSED |
| Stan producenta i konsumenta po erasure jest rzeczywistym wcześniejszym stanem | PASSED |
| Drugi producent używa output pierwszego, nie dostarczonej poprawnej listy | PASSED |
| Exact producer count ma jawną przesłankę fazy fetch; initial ją spełnia | PASSED |
| Load fault nadal przesuwa pc; ogólny bound nie zakłada poprawności load | PASSED |
| Capacity0/fuel0/terminal i malformed są objęte definicjami i indukcjami | PASSED |
| Po błędzie konsumenta dalsze przejścia nie znikają z rachunku | PASSED |
| Zero writes daje niezmieniony target; store tej samej wartości nadal liczy | PASSED |
| Przesłanka ogólnego CountedLoop.valid ma konkretny dowód CoreStepCount.counts | PASSED |
| Modelowy parser/root failure ma zero tylko zdarzeń rdzenia | PASSED, zakres jawny |
| Pełny wynik wraz z abortami jest zachowany | PASSED przez E12 + erasure |
|(M), kierunek J/P i prawo referencyjne | UNCHANGED; E13 ich nie zmienia |
| Pełny czas, koszty bitowe, alokacja liczników, peak | NOT ADDRESSED / OPEN |
| Source KeyGen/Sign/PRG, źródłowe pokrycie(M), QROM reduction | OUT OF SCOPE / OPEN |

Najbardziej ryzykowne nadinterpretacje odrzucone:16 modułów nie oznacza
zamknięcia Q-RESC; dwa Fetch.step na cykl nie oznaczają dwóch elementarnych
operacji; mapowanie readout nie zostało wycenione; Valid to wyprowadzona
własność liczb, a nie dowód ich przechowywania w Word512. Żadnego z tych
wniosków nie ma w certyfikacie końcowym.

## Kontrole techniczne

17 finalnych logów bez błędów i ostrzeżeń;93 eksporty mają tylko standardowe
aksjomaty Lean. Piny i snapshoty każdego accepted module są zgodne z formal/.
Osiem memory abortów zachowano jako FAILED, mimo error_count=0 w receipcie:
ujemny exit rozstrzyga. Sześć czystych prefiksów jest diagnostyką, nie pełnym
modułem. Nie zainstalowano żadnej porażki/probe. Limity nie zostały podniesione.

Sage10.9 uruchomiono `sage ...sage` ze standardowym preparserem i ZZ; snapshot
jest identyczny ze śledzonym skryptem. Manifest runnera zapisuje command,
wersję, wejścia przed/po, wyniki, limity i zakończenie; walidator potwierdził
spójność. Niezależność tego przeliczenia jest ograniczona: stałe pochodzą ze
wspólnych źródeł. Kernelowy numbers module daje oddzielną kontrolę równości
stałych i specjalizacji udowodnionego boundu. Nie wykonywano samplera.

Korekta matematycznej prozy: zakres E13 i nowe dokumenty; zgodność nazw,
jednostek, quantifiers, kierunku nierówności i odwołań sprawdzona. Brak
zamiany symbolu/przesłanki w wyniku proofreading. Ograniczenia zasobów są
zapisane w checkpointcie; historycznych plików nie poprawiano.

Najtańszy następny krok: ceny prymitywów rzeczywistego fetch/execute i
konsumenta, z policzonym scratch i spójnym modelem regionów. Pełny peak
wymaga połączenia wszystkich faz E12; liczby E13 same go nie zapewniają.
