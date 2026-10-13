# TODO020E / continuation004 — Array, prymitywy i pełne naliczenia

**PARTIAL_KERNEL_BACKEND_AND_CHARGES / PARENT020E_IN_PROGRESS /
WARUNKOWY / NOT_REVIEWED.** 2026-10-13.
Baza7eee9439f94a80d279e9b7c84fa31e1dbf123dce. Małe checkpointy pracy:
2507e5e42a7c96710f304009615970c3b250d9f1 (Array),
f62d7e9063d588509658853631697e6a19542551 (prymitywy/pętla).
S05/ROADMAP; jedno okno, bez push i bez niezależnego odbioru.

## Co wykazano

38 modułów,183 nowe twierdzenia i czysty końcowy audyt aksjomatów.
Gęste banki Array realizują dotychczasowe banki funkcyjne: odczyt, zapis,
stos, parser, wartości, atomy i całe wykonanie. Wariant kosztowany używa
jawnych kopii banków; nie zakłada natywnego in-place ani darmowego callbacku.

CostDriver020E4.run obejmuje publiczny klucz jako Array768 par, wszystkie
idealne bity taśmy, ładowanie publicznych tablic, kopię obrazu877 komórek,
parser, początkowe banki i ramki, każdy pełny scan wartości, sterowanie,
reset initial i kopię50689 bitów odpowiedzi. Obraz kodu jest literalny,
z kernelowym PublicImage020E4.binding; nie ma darmowej rekonstrukcji AST.
TableData016 to przypięte tablice publiczne, odczytywane przez dwa indeksy;
nie obliczamy wartości CDF przy uruchomieniu samplera.

Każdy etap ma udowodnioną zgodność wartości i granicę jawnie naliczanych
kosztów. Driver daje tę samą pełną odpowiedź na KAŻDEJ taśmie, a CostCertificate
zachowuje J≪P dla każdego klucza i drugi moment≤1+2^-47 pod dokładnym(M).
Transport tego samego pokrytego prawa kluczy pozostaje kernelowy. Publiczne
initial jest faktycznie tworzone przez driver. Nie zmieniono porażek,
capów, kierunku J/P ani legacy środowiska na grę wariantu A.

## Pełny licznik modelu, nie pełny peak

**MODEL**: operacje Word512 i jawne taryfy odczytu/kopii/sterowania oraz
idealnych bitów. Instrumentacja opisuje zasoby modelowanego algorytmu;
nie jest pomiarem kosztu uruchomienia samej instrumentacji w Lean.
**OBOWIĄZEK spełniony**: zgodność tego konkretnego drivera i nierówności
jego liczników dla wszystkich publicznych kluczy i taśm. Nie pozostała
swobodna przesłanka „ten callback jest tani” w końcowym CostDriver.bound.

Sage(ZZ, standardowy preparser) i niezależna równość kernelowa CostNumbers.total:

| Składnik | Górna granica modelowych ticks / skumulowanych naliczeń słów |
|---|---:|
| Wejście: klucz, idealne bity, ROM | 147977571902 |
| Publiczny stan początkowy | 276661 |
| Program wraz z parserem i ramkami | 11763954090988575643 |
| Rozgałęzienie wyniku | 1 |
| Kopia odpowiedzi | 405516 |
| Całe wywołanie | **11763954238966829723** |

To bardzo luźny bound: pełny scan877 komórek na krok, kopiowanie całych
banków i maksymalny controlLimit. Nie jest to deklaracja praktycznej
wydajności ani poziomu bezpieczeństwa. Pełna taśma ma24662538240 komórek
Bool; przy przyjętym do naliczeń jednym słowie512bit na komórkę sam jej
payload to1578402447360 bajtów. Nie wolno nazywać tego spakowaną taśmą3GB.
Nie uruchamiano tej gigantycznej instancji natywnie; dowody są uniwersalne.

**Q-RESC/020E nadal OPEN.** Skumulowane naliczenia nie są jeszcze dowodem
szczytu pamięci przechowywanej przez wykonawcę. Potrzebny jest most:
rzeczywiste zdarzenia alokacji i współistniejące wartości → naliczenia,
z obsługą scratch, ramek wywołań, publicznych stałych i reprezentacji wejścia.
Natywny Lean/C i koszt bitowy pozostają dodatkowymi mostami.

To nie kosmetyczna uwaga. CostSpaceGap020E4.counterexample i
no_universal_storage_rule dowodzą w kernelu, że sam typ Run z licznikami
nie implikuje nawet pokrycia rozmiaru wartości wyniku: pure potrafi
nie naliczyć istniejącego banku. Nie jest to kontrprzykład dla konkretnego
samplera, lecz obalenie nieuprawnionego ogólnego kroku dowodowego.
Z tej przyczyny żaden dokument tego checkpointu nie promuje liczby powyżej
do twierdzenia o pełnym peak. Celu continuation004 nie ogłasza się wykonanego
w całości; dalszy krok zachowuje ten sam otwarty obowiązek.

## Klasy, historia i następny krok

(M) jest jawną przesłanką lematów, której źródłowe pokrycie jest
**obowiązkiem dowodowym**, nie nowym założeniem kryptograficznym.
Sformułowanie „ASSUMPTION/ZAŁOŻENIE M” w częściowym PHASE2 odnosiło się
wyłącznie do przesłanki typu; klasyfikację doprecyzowuje niniejszy wpis
bez przepisywania historycznego commita. A-QMT i Q-PRG bez zmian.

Wszystkie110 prób Lean, w tym błędy, ostrzeżenia, OOM i diagnostyka,
pozostają w runtime array_backend_001. Pierwszy eksport zakończył się
exit0, ale nie wygenerował danych — zapisano go jako odrzucony, nie PASS.
Eksport redukcją, generatory Sage i wiązanie kernelowe są rozdzielone.
Czysty audit183 eksportów używa wyłącznie standardowych aksjomatów
propext/Classical.choice/Quot.sound (część twierdzeń nie wymaga żadnych).

Złożenie drivera przez ogólny CostPipeline usunęło kosztowne rozwijanie
zamkniętego interpretera; końcowy driver sprawdzono w1,97s. Wiązanie obrazu
i inicjalizacja potrzebowały wcześniej zatwierdzonego limitu6GiB Lean;
pozostałe finalne dowody mają wskazany własny limit w receipcie. Pamięć
kompilatora nie jest pamięcią samplera. Niezależny odbiór nadal nie odbył się.

Dalej: [continuation005 — ślad alokacji i peak](RESOURCES_020E_CONTINUATION_005.md).
Mapa murów: [kolejka](KERNEL_QUEUE_020E4.json), [klasy](CERTIFICATE_CLASSES_020E4.json).
Źródłowe KeyGen/M, real Sign/PRG, połączenie z wariantem A i mechanizmy
kwantowe pozostają odrębnie otwarte. Monitor ROM pozostaje PAUSED;
nowych commitów ROM nie konsumowano jako zależności.
