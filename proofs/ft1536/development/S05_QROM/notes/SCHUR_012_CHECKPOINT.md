# S05 / SCHUR-012 — warunkowy kernel masy Gaussa

Baza: `ff5d03ee62d17eb514f94d6d63123f6e8bf4f0fd`.
Status: **WARUNKOWY / KERNEL_CHECKED_CONDITIONAL_MASS_NOT_FT1536_INSTANCE**.
Klasa: **obowiązek dowodowy Q-SAMPLER**. Bez nowego założenia
kryptograficznego, bez niezależnego odbioru i bez deklaracji bezpieczeństwa.

## Co wykazano

**47 twierdzeń w sześciu modułach**, ze świeżymi czystymi logami Lean4.34.0:

| Moduł | Twierdzenia | Zakres |
|---|---:|---|
| SchurGeometry012 | 17 | Dokładna energia, Schur, dodatniość, pivotsy i pełne przesunięcia |
| SpectralDiagonal012 | 6 | Przekątna widmowa, harmoniczna i granica q²/H |
| GaussianFromSchur012 | 10 | Rzeczywisty atom w całkowitych współrzędnych, wieża, masa i zbieżność |
| BlockGaussian012 | 5 | Dwa bloki, zależne przesunięcie wewnętrzne i sumowanie |
| TemperatureScale012 | 6 | Jedna dodatnia skala i dokładny czynnik t^-1536 |
| HarmonicMass012 | 3 | Parametry q=18433, σ=768, H≥991 i wspólny lemat końcowy |

Przy **jawnej dokładnej tożsamości widmowej Schura**, dodatniej określoności
i przekątnej bloku pierwotnego≤4608, kernel daje dla każdej pary przesunięć
i każdego `0<t≤1`:

`(1−2^-34) C t^-1536 ≤ M_t ≤ (1+2^-34) C t^-1536`, z jednym `C>0`.

M_t to pełna **nieskończona** suma po całkowitych współrzędnych bazy.
Małych przekątnych wymaga tylko blok A oraz jego Schur S; duże wpisy
drugiego bloku D są dopuszczalne. Dowód zachowuje zależność przesunięcia
od zewnętrznej współrzędnej. Nie zamienia rzeczywistego shear w bijekcję
kraty i nie potrzebuje niemożliwego `ldl_shape` z008.

`2^-34` jest błędem względnym masy — **nie** nowym e momentu J/P ani
upoważnieniem do użycia lematu wymagającego `2^-40`.

## Mapa murów po012

| Obowiązek | Stan |
|---|---|
| Ogólny Schur i dokładny atom | **KERNEL_CHECKED** w podanych hipotezach |
| Zbieżność, jednolita masa, ta sama skala i wszystkie temperatury≤1 | **KERNEL_CHECKED** |
| Harmoniczna≥991 + dokładna reprezentacja widmowa → mass bound | **KERNEL_CHECKED_CONDITIONAL** |
| Rzeczywista baza: coefficient Gram, Parseval, reciprocal Schur | **OPEN_INSTANCE**; następny krok |
| Source harmonic ROOT/STABLE dla wszystkich emitted kluczy | Odziedziczony mixed/source argument010; pełny kernel OPEN |
| Całe włókno011 = masa012 dla tej samej bazy i publicznego h | Równoważność włókna jest dostępna; konkretne sklejenie OPEN |
| Skończony box, wykonywalny007, wszystkie porażki, koszt i pełny J/P | Tekst/Sage007 zachowane; kernelowy certyfikat OPEN |
| Cały emitted KeyGen i source Sign | Instancje Q-KEY/Q-BIND OPEN |
| Q-HASH-LOG / Q-EMBED / Q-COLL / Q-COMPOSE / Q-RESC | OPEN w dotychczasowym zakresie |
| All-h, h=0 i Dyadic | Osobne zakresy/statusy zachowane; bez awansu |

## Piny, wykonanie i historia

- `SCHUR_012_INPUTS.json`: źródła, biblioteki, toolchain i snapshot zależności.
- `SCHUR_012_RECEIPT.json`: 47 druków aksjomatów, 6 końcowych runów,
  5 świeżo zbudowanych zależności Gaussa/T5, manifest Sage i rzeczywiste czasy.
- `SCHUR_012_ATTEMPTS.json`: 12 wcześniejszych wersji, także 2 czyste
  pośrednie, oraz błąd loadera zatrzymany przez guard przed Lean.
- `SCHUR_012_CHECKS.json`: 24 macierze QQ (wymiary0–7),108 podziałów
  blokowych i3 widmowe przypadki cyklotomiczne (stopnie2,6,12).
- `CERTIFICATE_CLASSES_012.json`, `KERNEL_QUEUE_012.json`: aktualne klasy
  i kolejka. Archiwalne011 pozostają niezmienione.
- `SCHUR_012_OUTPUTS.sha256`: manifest wyników, bez żywego README.

Wszystkie47 deklaracji używa wyłącznie standardowych aksjomatów Lean.
Zweryfikowano dostępny snapshot700 starszych modułów011; nie jest to
nowy rebuild ani odbiór700 modułów. Skończone kontrole Sage nie są
dowodem rzeczywistej instancji1536. Koszt kompilacji nie jest kosztem samplera.
LaTeX skompilowany w edytorze. Zachowane nieudane elaboracje nie liczą się
do dowodu, nawet gdy drukowały `sorryAx` po błędzie. Nie nadpisano runów
ani starszych produktów. Nie zmieniano statusów ani źródeł T12.1/B20.

Odtworzenie pojedynczego modułu na przypiętych bibliotekach lokalnych:
`python3 -B notes/BUILD_MASS_012.py module HarmonicMass012 NOWA_ETYKIETA`.
Pierwsze dwa moduły można budować przez `RUN_SCHUR_012.py` z nowym katalogiem.
Sage: `sage notes/SCHUR_012.sage NOWY_KATALOG`. Zawsze świeża ścieżka;
biblioteki i konkretne komendy historyczne są w receiptach.

## Ocena i kolejny krok

Usunęliśmy istotną lukę między granicą pivotsów a rzeczywistą masą:
kernel sprawdza teraz pełne przesunięcia, zbieżność i wspólną skalę.
Pozostała konkretna identyfikacja tych obiektów z bazą FT1536; nie wolno
jej ukryć jako gotowego świadectwa samplera. **Następny krok: kernelowe
Gram/Parseval i tożsamość widmowa Schura dla tej samej bazy NTRU co011.**
Kontynuujemy obserwację commitów ROM; eksportów równoległego wykonawcy
używamy dopiero po odczycie dokładnego typu i pinów.
