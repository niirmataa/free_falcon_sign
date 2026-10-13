# TODO020E — driver, stosy i lokalne zasoby

**PARTIAL_PROOF / TODO020E IN_PROGRESS / WARUNKOWY / NOT_REVIEWED.**
Data2026-10-13; baza ad59b07632fb05ae3d06441f44d9fc47cbad31a4.
Kontynuacja S05/ROADMAP. Nie zamknięto jeszcze pełnego Q-RESC.

## Wynik dla właściciela

Powstał jawny driver, który materializuje banki, zeruje dowolny zastany
stan do publicznego initial, wykonuje interpreter na stosie i kopiuje całe
50689-bitowe wyjście. Kernel dowodzi zgodności tego drivera z020D dla
każdego h i każdej taśmy. Jego wewnętrzny fallback Option jest nieosiągalny.

Pełne prawo drivera jest równe prawu020D(initial). Mamy all-h J≪P oraz
moment≤1+2^-47 pod dokładnym wcześniejszym(M), również dla tego samego
pokrytego prawa kluczy. Nie zmieniono odniesienia, porażek ani kierunku J/P.
To wynik w przypiętym środowisku legacy; nie składa jeszcze gry wariantu A.

**Wartość etapu:** zasoby dotyczą już konkretnego drivera i konkretnego
sterowania, a nie tylko rekurencyjnego zapisu samplera. **Granica:** rozmiary
składni i stosów nie są jeszcze pełnym dowodem alokacji komórek pamięci.
Nie podpisujemy całego Q-RESC na podstawie tych lokalnych ograniczeń.

## Dokładny zakres80 nowych twierdzeń

| Warstwa | Wynik kernelowy |
|---|---|
| ExprStack/ExprBackend | Postfix liczy dokładnie eval; atomy zachowują semantykę020; brak podpełnienia dla skompilowanego Expr |
| ExprMeter | Każdy stan/Expr: wykonane opcody i stos wartości≤exprNodes |
| ControlStack | Każdy Input/Code/State: skończona lista zadań kończy z dokładnym stanem WordRAM020.run |
| ControlSpace/ControlMeter | Granica objętości oczekującej składni, zachowanie capów i rozliczenie starej/nowej kolejki |
| SyntaxTape/SyntaxCells/SyntaxLegal | Parser odtwarza AST; dwa słowa512bit na legalny token; legalność zachowana w wykonaniu |
| CopyBank/CopyLoop | Dokładne kopiowanie n komórek, n transferów, brak błędu i8n+4 w jawnym modelu kopiowania |
| PublicDriver | Pełne wejście, reset initial, wykonanie, transfer wyjścia i dokładna równość prawa020D |
| DriverCertificate | Konkretny certyfikat J/P pod(M) i to samo pokryte μ; bez wolnego pola poprawności drivera |
| ProgramResources/ReachableExpr | Instancje dla rzeczywistego877-węzłowego programu; ograniczenia we wszystkich osiągalnych stanach |

Dla programu FT1536 udowodniono:

- cap≤1536;
- objętość każdej osiągalnej kolejki≤28941 węzłów składni;
- stara i nowa kolejka podczas przejścia razem≤57882 węzłów;
- każde wyrażenie użyte przez osiągalną instrukcję ma≤32 węzły;
- evaluator takiego wyrażenia wykonuje≤32 opcody i ma stos wartości≤32;
- głębokość kompilatora≤32, syntaktyczny budżet kopiowania≤1024;
- liczba przejść sterowania≤1106642201817, z tego samego boundu020.

Ostatnia liczba **nie jest nowym pełnym czasem drivera**. Jedno przejście
zawiera ewaluację i operacje na reprezentacji. Cena transferów jest jawnie
osobna:8·(tapeSize+romSize+32+ramSize+2·outputSize)+25 w modelu CopyLoop.
Nie dodajemy tych dwóch liczb i nie ogłaszamy całkowitego czasu.
Cena prymitywu kopiowania dotyczy komórek modelu; instancje drivera używają
Bool i Word512. Ogólny parametr A w lemacie nie przyznaje jednostkowej ceny
kopiowania dowolnego obiektu w natywnym programie.

## Gdzie kończy się dowód zasobów

Nadal trzeba zrealizować parser/sterowanie na skończonych komórkach,
przypisać adresy, ramki i bufor scratch, a następnie udowodnić zgodność
z obecnym modelem AST/list. Cena producerów obrazu wejścia, źródła losowości,
pełny szczyt pamięci i wszystkie koszty alokacji/zwalniania pozostają otwarte.
Wariant API wymagający strukturalnej pary potrzebuje także płatnego dekodera;
obecny driver dostarcza pełne, bezstratne kodowanie bitowe.

Nie mnożymy57882 przez rozmiar tokenu i nie nazywamy wyniku pełną pamięcią:
taki skrót pomija ramki, wskaźniki, parser i współistniejące reprezentacje.
Również syntaktyczna rekurencja allocations nie jest licznikiem fizycznego
alokatora. Nowy wynik unbounded_expression_work dowodzi ogólnie, dlaczego
sama liczba przejść sterowania nie wystarcza do rozliczenia wyrażeń.

Wybrana trasa pełnej taśmy pozostaje OPEN. Streaming oraz backend bitowy/C
są odroczone, nie obalone. Dokładna następna próba jest w
RESOURCES_020E_CONTINUATION_001.md. Nie przeskakujemy do innego TODO,
pozostawiając Q-RESC jako rzekomo zamknięty.

## Weryfikacja i historia

80 twierdzeń,17 modułów dowodowych i audyt.18 końcowych czystych buildów.
31 prób Lean zachowanych:20 czystych, w tym2 wcześniejsze buildy zastąpione
po korekcie komentarza, oraz11 nieczystych/nieudanych. Audyt wszystkich80
nazw:78 list standard-only {propext, Classical.choice, Quot.sound},2 bez
aksjomatów. Bez sorry, nowych aksjomatów, native_decide/bv_decide i wyciszeń
linterów w przyjętych plikach.

Pierwszy komentarz ExprCompileBudget sugerował dokładny rachunek alokacji.
Zawężono go do syntaktycznego budżetu; definicja i dowody nie zmieniły się.
Próba association001 dla prawej łączności append nie przeszła rfl;
association002 sprawdza faktyczną lewą łączność. Stare źródło/artefakty są
w resources_001, nowy komentarz i odbudowany konsument w resources_002.
To korekta zakresu opisu, nie zmiana programu ani przesłanek dowodu.

Pozostałe niepowodzenia obejmują ostrzeżenia, zależne indeksy, zastrzeżone
słowo prefix oraz rekurencję przy podstawieniu dużej instancji. Żaden
nieczysty wynik nie został przyjęty jako końcowy dowód. Sterowanie i duże
kopiowania składano przez lematy ogólne, bez wykonywania całej taśmy.

54 piny wyników i420 runtime020D sprawdzono przed pracą i przy zamknięciu.
489 modułów bazowych zachowano; biblioteka końcowa ma507 pinów. Wszystkie
nowe twierdzenia są uniwersalne, liczby dotyczące składni sprawdził kernel.
Nie zmieniono tabel probabilistycznych ani przybliżeń; nowych testów Sage
nie uruchamiano. Własna kontrola autora nie jest niezależnym odbiorem.

Commity źródeł:82cc931d oraz ab0fe21e. Manifesty RESOURCES_020E_OUTPUTS
oraz RESOURCES_020E_RUNTIME, receipty i CHECKS wiążą źródła, wszystkie próby
i SHA. Historyczne źródła020D oraz starsze manifesty pozostają nienaruszone.
Bez push, importu stages i tagu; bez zmian T12.1/B20/paperu/mainline.

## Mapa murów i klasy warunków

| Warunek | Klasa / stan |
|---|---|
| EveryTape020D | Obowiązek, KERNEL CLOSED w dotychczasowym zakresie |
| Nowy logiczny driver i jego pełne J/P | Obowiązek, kernel; moment pod dokładnym(M) |
| Stosy, kodowanie i lokalne budżety | Obowiązek Q-RESC, kernel scoped020E |
| Wykonawca komórkowy i całkowite zasoby | Obowiązek Q-RESC, OPEN |
| Word512, banki, prymitywy i ceny CopyLoop | MODEL, bez deklaracji czasu CPU/C |
| Źródłowa emisja h i pokrycie(M) | Obowiązki Q-KEY/Q-BIND, OPEN |
| Real Sign, PRG hop, połączenie wariantu A | Obowiązki Q-BIND/Q-PRG, OPEN |
| A-QMT / primitive-bound Q-PRG | Założenia kryptograficzne, bez zmian |
| Kompozycja/log/reprogramowanie/embedding/kolizje QROM | Obowiązki kwantowe, OPEN |

Nonce320, e, D=(1+e)^q_s−1 i warunki kwantowego użycia kompozycji bez zmian.
Nowych wyników ROM nie konsumowano; monitor pozostaje wstrzymany.
