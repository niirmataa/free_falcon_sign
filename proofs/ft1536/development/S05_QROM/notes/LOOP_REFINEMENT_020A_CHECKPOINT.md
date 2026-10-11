# S05 / TODO020A — czytnik, CDF i pojedyncza próba

**PARTIAL_KERNEL / TODO020 IN_PROGRESS / NOT_REVIEWED / WARUNKOWY.**
Nowe75 nazwanych eksportów w17 modułach dowodowych;19 finalnych czystych
buildów wraz z dwoma audytami. Nie zamknięto cap80 ani EveryTape całego
samplera. Nie ma nowej deklaracji bezpieczeństwa QROM.

Wejście: main `a959f132846a25a02e375ffc5af0795e0e1ea344`;
poprzedni checkpoint S05 `27b72c9fec5e73e34cedb89fef893dc6eca08417`.
Commity źródeł: `0d832531` (czytnik/CDF,57 eksportów) i
`48d07c1c` (cała pojedyncza próba oraz zachowane próby cap80).
[CHECKS](LOOP_REFINEMENT_020A_CHECKS.json) oraz manifesty wiążą resztę źródeł,
wszystkie próby i receipty. Piny starego020 sprawdzono przed pracą.

## Dokładny wynik

Badamy niezmieniony `PairProgram020` w niezmienionej semantyce `WordRAM020`:
słowo512bit, skończone banki, jawny koszt instrukcji. To model, nie dowód
czasu C/CPU. `exec` jest udowodnionym rzutem pierwszej składowej istniejącego
`run`; nie zastępuje go tańszym interpreterem.

1. `ReadWordCorrect020A.readWord_correct` obejmuje każdą taśmę oraz
   szerokość0≤w≤384. Dla prawidłowego przedziału [b,b+w), przy bazie
   niezależnej od roboczych rejestrów4/5/6, wynik to dokładna wartość
   little-endian019. Indukcja dowodzi poprawności każdego adresu i granicy
   akumulatora. RAM, wyjście i fault są zachowane, a pozostałe rejestry
   nie zmieniają się. `ReadWordSites020A` wypełnia warunek składni bazy dla
   wszystkich form użytych w020: reg3 oraz reg3+offset. Wynik po odczytaniu
   słowa jako liczby ze znakiem również jest dokładny.
2. `CdfLoop020A.loop_correct` obejmuje oba kierunki wyszukiwania, dowolny
   pozostały fuel oraz wcześniejsze zatrzymanie na pustym przedziale.
   `CoordinateCorrect020A` składa rzeczywisty czytnik384bit, odczyt końca
   CDF, modulo, pętlę15 i clamp indeksu. Monotoniczność nie jest potrzebna
   do tej zgodności algorytmów; poprawność selekcji CDF została już
   udowodniona w017/018 i nie jest tu dowodzona drugi raz.
3. `ActualCoordinate020A.actual_coordinate` dostarcza instancję dla
   rzeczywistego obrazu `InputLayout020.encode h tape` i przypiętych tablic.
   Pola Image oraz szerokość tablic nie pozostają założeniami tego eksportu.
   Pozostają jawne warunki lokalnego wywołania: poprawny segment taśmy,
   zakodowana baza i jej niezależność od scratch. Odpowiednie warianty
   reg3/reg3+offset są dowiedzione, wraz z ramkami pamięci i rejestrów.
4. `TrialCorrect020A.trial_correct` składa CAŁĄ istniejącą procedurę
   `PairProgram020.trial`: adres, dwa CDF,256bit akceptacji, rzeczywisty
   próg, obie gałęzie i przesunięcie retry. Dla n<196,p<1536,k<80,
   reg0=n,reg1=p,reg2=k i reg15=0, obserwacja wyniku jest dokładnie
   zakodowanym `StandaloneRuntime019.pairTrial` na odpowiednim1024-bitowym
   fragmencie taśmy. Odrzucenie daje none, sukces obie współrzędne ze znakiem;
   reg2 staje się k+1. RAM/wyjście/fault oraz nadrzędne liczniki i akumulator
   normy są zachowane. Nie założono wyniku testu akceptacji.

Adres próby to b=((1536n+p)80+k)1024. Jego1024-bitowy przedział mieści się
w części retry, przed świeżym suffixem cube. `TrialAddress020A` dowodzi
zarówno rachunku adresu, jak i wykonania tego rachunku przez instrukcje.
Wynik obserwujemy jako parę słów512bit reprezentujących współrzędne
zdejmujące offset65535 z referencyjnego BoxBlock; to ten sam signed wynik,
nie nowy sampler ani nowa aproksymacja.

**Brak zmiany e, M, D albo liczby bitów nonce.** Nowe lematy są dokładnymi
równościami wykonania, więc nie wprowadzają błędu probabilistycznego.
Nie przenosimy jeszcze certyfikatu J≪P/momentu na CAŁĄ maszynę — do tego
nadal potrzeba `RefinementTarget020.EveryTape` i reszty łańcucha.

## Cap80: czego nie udało się jeszcze skernelizować

`CapLoop020A` nie ma zaakceptowanego builda. Zwykłe błędy elaboracji
poprzedzały serie przerwań `lean::memory_exception` przy limicieM4096;
nie uzyskano potwierdzonego dowodu pełnej pętli. Próby ochrony rekursji
przed rozwijaniem, rozdzielenia wejścia i zmiany aliasu specyfikacji nie
usunęły problemu. Diagnostyka nie uprawnia do wskazania jednej pewnej
przyczyny alokacji. Nie jest to kontrprzykład matematyczny ani błąd C.

[Zachowane szkice](attempts020A/README.md) zawierają CapLoop, niekompilowany
CapDraw oraz prefix-probe. Nie należą do finalnego audytu75 eksportów.
Próba prefix-probe001 przeszła; nie zaliczamy jej jako zamknięcia cap80.
Szkic CapDraw ma też do uzgodnienia interfejs po późniejszych zmianach
CapLoop. Nie jest gotowym konsumentem.

Tekstowa droga do cap80 pozostaje następująca: indukcja po pozostałej
liczbie prób, z niezmiennikiem k+remaining≤80. Gotowy `trial_correct`
obsługuje krok. Przy none zachowuje rodziców, zwiększa k i pozwala użyć
hipotezy indukcyjnej; przy some flaga zatrzymuje następny odczyt. Po
wyczerpaniu80 prób trzeba dodatkowo wykazać zero fallback, a następnie
zapis pary do RAM i aktualizację normy. Ten opis jest drogą dowodu,
nie brakującym certyfikatem kernelowym.

**Następna trasa B-CAP-LIGHT:** ogólny lemat ograniczonej pętli w lekkim
module importującym WordRAM020/ReadSemantics020A, bez rzeczywistych tablic
ani całego stosu probabilistycznego. Jawny warunek pojedynczego kroku
wypełnić udowodnionym TrialCorrect020A w osobnym konsumencie. Potem
cap80 i fallback, bez powtarzania niezmienionej ciężkiej próby011.
Trasa nie została jeszcze wykonana; pozostaje OPEN, nie „wyczerpana”.

## Kontrole i zasoby prac

- Audyt75 dokładnie nazwanych eksportów: standardowe aksjomaty
  `{propext, Classical.choice, Quot.sound}`; żadnych sorry/native_decide
  ani wyciszeń lintera w zaakceptowanych nowych źródłach.
- Zachowano52 próby Lean;32 zakończyły się błędem/timeoutem/ostrzeżeniem,
  w tym9 przerwań memory_exception.19 finalnych buildów jest czystych;
  dodatkowy czysty prefix-probe pozostaje diagnostyką.
- Początkowe obniżenie Lean do2GiB i przestrzeni adresowej do4GiB było
  nieudane: zimne odczyty/timeouty, błąd odczytu pliku biblioteki, następnie
  memory_exception. Niezależny odczyt pliku się powiódł; zależności nie
  były naprawiane ani zastępowane. ENVIRONMENT_001/002 zachowują przebieg.
- Powrócono do historycznych limitów020: M4096,AS8GiB,1rdzeń i110sCPU.
  Wall600s pozwala na wolny odczyt bibliotek. Po błędach cap80 limitu
  ponownie nie zwiększano. Koszty kompilatora nie są kosztami samplera.
- Jeden proces Lean naraz, bez dodatkowych modeli i obcych replayów.
  Jedna przedwczesna instalacja odmówiła pracy z powodu braku receiptu
  trwającego joba; nie rozpoczęła następnego Lean ani nie zmieniła biblioteki.
- Brak nowej numerycznej aproksymacji, więc nie powtarzano starego Sage.
  Poprzednie43 kontrole są zachowane jako historyczna diagnostyka; nowe
  twierdzenia są uniwersalnymi dowodami kernelowymi, nie testami skończonymi.

## Mapa murów po tym checkpointcie

| Obowiązek | Stan |
|---|---|
| Czytnik i rzeczywisty CDF | KERNEL_CLOSED_SCOPED dla lokalnych wywołań |
| Cała pojedyncza próba | KERNEL_CLOSED_SCOPED, wraz z odrzuceniem |
| Cap80, zero fallback, zapis/norma pary | OPEN_KERNEL |
| Wektory, cap196, świeży cube | OPEN_MACHINE_REFINEMENT |
| Scatter i pełna emisja | OPEN_MACHINE_REFINEMENT |
| EveryTape i pełne Q-RESC | OPEN; poprzedni bound rdzenia nie jest pełnym kosztem |
| Źródłowe prawo kluczy/M/Sign/PRG | OPEN_SOURCE, bez awansu przez nowe lematy |
| Kwantowa kompozycja/reprogramowanie/embedding/kolizje | OPEN |

Wszystkie nowe wyniki mają klasę OBOWIĄZEK DOWODOWY. Model pozostaje020,
a A-QMT i primitive-bound Q-PRG pozostają osobnymi założeniami kryptograficznymi.
Brak owner acceptance i niezależnego odbioru. Bez push, zmian T12.1/B20,
mainline, paperu i strony. Monitor ROM nadal PAUSED na decyzję właściciela.
