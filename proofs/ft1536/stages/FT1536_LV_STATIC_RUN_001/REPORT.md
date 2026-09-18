# FT1536 L_V-STATIC — RUN_001: pełny kontrprzykład

**Rozstrzygnięcie: `COUNTEREXAMPLE_REQUIRED_DOMAIN`.**

Lemat L_V-STATIC jest fałszywy w zadeklarowanym modelu S17 / GCC 14.2.0 / C99 / LP64. Dla przypiętego publicznego h* ze successful-output support, poprawnego c i payloadu STATIC całe źródłowe Verify akceptuje, a ustalony ekstraktor Ext0 zwraca wektor o normie większej od B. Kongruencja ekstraktora pozostaje prawdziwa; sfalsyfikowano **krótkość**.

| Wielkość | Dokładny wynik |
|---|---:|
| `V_S17(h*,c,b)` | **1** |
| Norma pary rzeczywiście przekazanej do source `falcon_is_short` | **400 000 000** |
| `B` | **2 093 922 385** |
| `Q0(Ext0.first)` | **42 658 711 057** |
| `Q(Ext0)` | **43 058 711 057** |
| `Q(Ext0) − B` | **40 964 788 672** |

To pełny kontrprzykład do ustalonego Ext0/L_V, nie tylko przykład lokalnej konwersji. Nie stanowi znalezienia wiadomości/nonce dla c ani efektywnego fałszerstwa EUF-CMA.

## 1. Zakres, wznowienie i źródła

Praca została wznowiona 2026-09-18 w istniejącym:

```text
W = /home/footfalcon/Dokumenty/FT1536_LV_STATIC_RUN_001
H = /media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon
```

Polecenia: `FT1536_PROMPT_LV_STATIC_2026-09-17.md`, SHA-256 `9788680b76dafa32644ce8fefb5107383fbfc1ec7e87f768b5bf979c935ae386`, oraz kontynuacja `FT1536_KONTYNUACJA_GPT_ASTRA_LV_STATIC_2026-09-17.md`, SHA-256 `1251db3045a6c7c309be5f3d819a2a99233a8f480c71792e155dcca40583c302`. Wcześniejszy raport z tezą ma hash `5b1b0e3e15f14aca63fce9007cebb36c493aa2669ca6e8ad35dccd32023ac11e` i pozostał wejściem tylko do odczytu.

Przed pierwszym zapisem sprawdzono piny skryptów, INPUTS, 26 oryginalnych wejść, 26 kopii oraz **17/17** źródeł S17. Manifest historyczny:

```text
commit: d641ab1037c2fa1dd4a22c258854d79d67b9b46b
path: evidence/_work/PO-01-BASELINE-001-20260803-a1/source_hashes.sha256
SHA-256: 03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589
```

Zastany dziennik miał sześć wpisów. Hash pierwszych pięciu surowych linii z newline wynosił wymagane `7fd844fb21a9a549632d3bc307293948e11d4f3f6049dd26d6aa10b7c3591fc7`; hash całych sześciu linii: `2fad47dde79a1c135b91ae28f4b409845ff104ce072f36e28f2cb11e7e875f17`. Kopię dziennika, starych skryptów i binarium zachowano w `resume_001/snapshot/`. Inwentarz 1430 zastanych plików jest w `resume_001/INHERITED_STATE.json` i `INHERITED.sha256`.

Nie uruchamiano ponownie `scripts/prepare.py`. Skrypty poprzedniej próby, stare `bin/lv.so`, reference i wejścia zachowano. Sprawdzenie po obliczeniach potwierdziło 1429 niezmienionych zastanych plików oraz niezmieniony prefiks jedynego rosnącego pliku — COMMANDS.log. Nowe helpery są w `resume_001/`; źródeł w `reference/` nie poprawiano.

Uczciwy profil nadal jest **full ternary secret / COMP_STATIC**. L_V obejmuje pełny Verify, także NONE. Pojemność 2049 bufora CLI Sign i opakowanie nonce nie są przesłankami tego lematu.

## 2. Dokładna teza i model

```text
N = 1536
q = 18433
Phi = X^1536 - X^768 + 1
B = 2093922385
Q0(a) = sum_{i=0}^{767} (a_i^2 + a_i*a_{i+768} + a_{i+768}^2)
Q(z1,z2) = Q0(z1) + Q0(z2)
Ext0(h,c,b) = (center_q(c - h*s(b)), s(b))
```

`s(b)` oznacza wartości int16 rzeczywiście zapisane przez dekoder. W ekstraktorze iloczyn jest dokładnym iloczynem modulo `(q,Phi)`. `center_q` daje współczynniki w `[-9216,9216]`.

Badana implikacja ma kwantyfikatory po h w successful-output support rzeczywistego S17 KeyGen, wszystkich `c in [0,q-1]^1536` i wszystkich skończonych reprezentowalnych payloadach b:

```text
V_S17(h,c,b)=1 => Ext0 jest zdefiniowany, spełnia kongruencję i Q(Ext0)<B.
```

Model wykonania: Linux x86_64, LP64, `CHAR_BIT=8`, int/unsigned 32-bit, long/size_t 64-bit, int16/uint16 16-bit, int64 64-bit. Szerokości sprawdzają statyczne asercje standalone harnessu. Użyto GCC 14.2.0 (Debian 14.2.0-19), flag S17/Makefile oraz jawnego `-std=c99`. Dokładne argv i hashe binariów są w `artifacts/build-*.json`; wariant sanitizer dodaje `-fsanitize=address,undefined -fno-sanitize-recover=all -g`.

Unsigned arytmetyka i konwersje mają redukcję modulo rozmiar słowa. Nie traktowano signed overflow jako poprawnego modulo. Kontrole dekodera odnotowują zachowanie GCC dla signed narrowing poza zakresem. **Główny świadek nie wymaga takiego narrowing:** magnitude 20000 i wynik -20000 mieszczą się w int16. Kluczowy błąd dotyczy zdefiniowanego zawężenia unsigned do uint16 przed NTT.

## 3. Publiczny świadek i jego dziedzina

### 3.1. Klucz

Użyto istniejącego kanonicznego publicznego klucza:

```text
inputs/key/canonical_public_key.bin
SHA-256: 57c49fb228013b0bfc4907c754d747dca93c1049d2945ccd6cd686e9f95afc6f

inputs/key/canonical_public_h.txt
SHA-256: ce1aef69b5998e6f214bc6a45cf6abc36fb1753d595ef1d7b0e6c1cecd9d17f2
```

To h*, nie zabawkowe h. Przynależność do required support opiera się na przypiętym publicznym historycznym zapisie pojedynczego udanego S17 KeyGen:

- `inputs/key/KEY_COMMITMENT.json`, SHA-256 `014358887337670f599c442bb3b838aa6084931efeba17a00eb72fda014e9523`: public hash, manifest S17 i ścieżka 32-bajtowego OS RNG;
- `inputs/resume_001/KEYGEN_ATTEMPT.json`, SHA-256 `e357d32d0aa91e6b80af2a83674965fbad776699c6c6f999fa71376ec52a7370`: exit code 0, `KEYGEN_GENERATED_AND_VALIDATED`, jedno wywołanie;
- `inputs/resume_001/report.md`, SHA-256 `98eeeac23886fb678a491eab4ee796ebbaf2900e0ab0f2043cf53a7d01f50637`: historyczna walidacja i powiązanie publicznych wartości;
- oryginalny manifest KeyGen `inputs/key/OUTPUTS.sha256`, SHA-256 `51107bef5786b102d1b6a2ac8d35926fe7d47eeb9cfd3dd7d647cb679bbc5d15`.

Oba nowe checkery potwierdzają zgodność tekstowego h z dekodowanym 15-bitowym publicznym PK. Nie wykonywano nowego KeyGen ani prywatnego replayu; historyczny publiczny zapis support jest jawnym wejściem wyniku.

### 3.2. Zwarta specyfikacja całego świadka

Współczynniki są indeksowane od 0. Ustal:

```text
s(b) = (-20000, 0, ..., 0)
c_i = (8670*h_i) mod 18433, dla i=0,...,1535
b = nagłówek 0xAA || kodowanie STATIC powyższego s(b)
```

Pierwszy kod współczynnika ma znak 1, low byte 32 i 78 zer unary, po których stoi terminator 1. Pozostałe 1535 współczynników to kody zera. Łącznie są 15438 bitów danych, dwa zerowe padding bits, 1930 bajtów po nagłówku i **1931 bajtów payloadu**. C zużywa dokładnie wszystkie 1930 bajtów po nagłówku.

Wszystkie współczynniki c są w `[0,18432]`. Wybór c jest legalny w tezie L_V. Podanie c nie jest znalezieniem jego preimage w HashToPoint.

Pliki zawierają pełne dane, także wszystkie etapy C:

| Plik | SHA-256 |
|---|---|
| `artifacts/witness.json` — h,c,s,Ext0, rzeczywista para normy i pięć etapów C | `2b9ea42771316eaef3cc394462b51f6a4df4e5b6e08630c5eaab0ca052da603b` |
| `artifacts/witness.bin` — dokładne b | `50468530f25ff63fe5680331d2f2591120a15aae0ba0f63f0b0364fc78289b74` |
| `artifacts/witness_c.txt` — dokładne c | `f715b6c92f574054a52230cbcc337d2b16f5260469788872eb59234d27d1f4fd` |

### 3.3. Wyprowadzenie błędu i norm

Źródłowa mapa przed NTT (`falcon-vrfy.c:1393–1399`) nie wykonuje ogólnej redukcji signed s2 modulo q:

```c
w = (uint32_t)s2[u];
w += q & -(w >> 31);
x[u] = (uint16_t)w;
```

Dla pierwszego współczynnika:

```text
s2[0] = -20000
s2[0] + q = -1567
wartość uint32 po dodaniu = 4294965729
wartość uint16            = 63969
63969 mod q              = 8670
(-20000) mod q           = 16866
```

Różnica odpowiada 65536 modulo q, czyli 10237. Wszystkie pozostałe słowa wejścia NTT są zerowe. Dla tego świadka przebieg C daje po inverse NTT dokładnie c, co niezależny Sage potwierdza jako iloczyn h przez zapisane słowo 63969 modulo `(q,Phi)`, równy `8670*h`. Po odjęciu c źródłowy pierwszy komponent jest zerowy. Obserwator **rzeczywistych argumentów** normy potwierdza parę `(0,s(b))`.

Stąd source norm wynosi `(-20000)^2=400000000<B` i pełne Verify zwraca 1.

Natomiast ustalony Ext0 korzysta z rzeczywistego signed s(b), zatem:

\[
z_1=\operatorname{center}_q(c-h(-20000))
   =\operatorname{center}_q(10237h),\qquad z_2=-20000.
\]

Dokładny rachunek daje:

\[
Q_0(z_1)=42658711057,\quad Q_0(z_2)=400000000,
\]
\[
Q(z_1,z_2)=43058711057>2093922385.
\]

Kongruencja `z1+h*z2=c mod(q,Phi)` jest prawdziwa i sprawdzona. **Fałszywy jest wniosek o krótkości, nie definicja ekstraktora lub jego kongruencja.**

## 4. Wierność harnessu i rozdzielenie oracle od matematyki

Zastany `scripts/harness.c` pozostał bajtowo niezmieniony, SHA-256 `d9addfa1ddea67a2fa689b0963755758426cd3ae04df4115b39ff6877af4bd79`. Został przejrzany jako kod testowy, a nie przyjęty jako dowód.

- Włącza niezmieniony `reference/falcon-vrfy.c`. Jedyną podmianą w pełnym verifierze jest nazwa funkcji HashToPoint, która kopiuje jawne c zgodnie z dziedziną lematu.
- `lv_init` wywołuje prawdziwe `falcon_vrfy_new` i `falcon_vrfy_set_public_key`. Przygotowanie h przez NTT i Montgomery wykonują oryginalne linie 1346–1347. Do raw Verify trafia `ctx->h`, **nie surowy h**.
- `lv_eval` wywołuje cały `falcon_vrfy_verify`: kontrole nagłówka, dekodowanie, pełne zużycie długości i raw verification pozostały w kodzie źródłowym.
- Dodany `resume_001/harness_observed.c` jedynie kopiuje argumenty faktycznego wywołania normy, po czym wywołuje niezmienione `falcon_is_short`. Pozwoliło to porównać rzeczywistą parę z duplikowanym pomocniczym trace.
- Zbudowano także osobny standalone bez obserwatora. Potwierdza tę samą akceptację w świeżym procesie. Obserwator nie jest jedyną podstawą faktu `V=1`.

Najważniejsze zakresy źródła:

| Plik | Zakres | Rola |
|---|---|---|
| `falcon-vrfy.c` | 1284–1348 | rzeczywisty loader i przygotowanie h |
| `falcon-vrfy.c` | 1375–1424 | pre-NTT map, iloczyn, center i source norm |
| `falcon-vrfy.c` | 1429–1500 | pełna domena nagłówka i payloadu |
| `falcon-enc.c` | 401–455 | NONE, z centered-domain |
| `falcon-enc.c` | 462–544 | STATIC jako funkcja słów |
| `falcon-enc.c` | 597–666 | dokładna offset-768 forma i ścisły B |

`model.py` liczy poprawny iloczyn przez całkowitoliczbowy splot i redukcję stopni według Phi; decoder jest gramatyką bitową. Niezależny `check_sage.py` nie importuje tego modułu ani probe: używa strumieniowego czytnika bitów i `GF(18433)[X]` z dokładną resztą modulo Phi. Badany NTT służy wyłącznie obserwacji C, nie referencji dla matematycznego `h*s` lub Ext0.

Pierwsze konstruowanie c odczytało source product; później niezależnie ustalono i sprawdzono zwartą specyfikację `c_i=(8670*h_i) mod q`. Reprodukcja świadka nie musi ufać NTT w celu określenia c.

## 5. Decoder i pełna dziedzina słów

STATIC czyta sign, 8 bitów low i ciąg zer zakończony jedynką. Licznik `unsigned ne` jest 32-bitowy. Dla k zer jego stan przy terminatorze to `k mod 2^32`; dopiero wtedy wykonywany jest test `ne>255`. Następnie `lo += ne<<8`, signed narrowing i ewentualna negacja. W modelu GCC zapis jest równoważny signed wrap16 odpowiednio magnitude lub jego przeciwności. Negative zero jest dopuszczalne.

Nie wolno w tej charakterystyce zastąpić unsigned counter nieograniczoną liczbą naturalną albo założyć globalnego capu długości. Przykładowo k=2^32 daje ne=0, k=2^32+255 daje ne=255, a k=2^32+256 daje ne=256 i odrzucenie. Wynika to z indukcji po kolejnych inkrementacjach modulo 2^32; Lean sprawdza konkretne granice wrap/accept/reject. Nie wykonano materializacji ponad 512 MiB unary input i nie przedstawia się tych faktów jako takiego wykonania C. Główny kontrprzykład używa tylko 78 zer.

Po N współczynnikach C sprawdza pozostające bity w ostatnim pobranym bajcie, a pełny Verify wymaga zużycia całej długości. Dopisany nawet zerowy bajt jest odrzucany. NONE z kolei akceptuje dokładnie centered signed coefficients i właściwą długość. Wnioski z NONE nie zostały wstawione jako przesłanki STATIC.

## 6. Kontrole i ich wynik

Przed oceną pełnego kandydata przeszły:

- **10 dodatnich kontroli** pełnego Verify: obie kompresje, rzadkie i gęsty wektor, znak pierwszego komponentu, zawijanie wysokiego monomianu przez Phi, poprawne przygotowanie publicznego klucza; source product porównany z niezależnym splotem.
- **6 kontroli `B−1/B/B+1`** przez pełne Verify, po jednej dla każdej kompresji i granicy. Użyte s2 były centered, c liczone dokładnie jako h*s2, a rzeczywisty pierwszy komponent wynosił 0. Zatem sprawdzano właściwy obiekt normy, nie obcy zakres. `B−1` akceptuje, B i `B+1` odrzucają.
- **35 kontroli dekodera:** ±9216, ±9217, ±18433, -20000, ±32767, -32768, magnitudes 32768/65535 w obu znakach, negative zero, ne=255/256, padding, trailing bytes, truncation i nagłówki reserved/wrong degree/wrong ring. Wyniki źródłowe i niezależny od C model bitowy są zgodne.

Pełny świadek ponownie wykonano standalone C w wariancie normal i ASan/UBSan. Oba dają:

```json
{"loader":1,"payload_bytes":1931,"decoded_bytes":1930,"point_calls":1,"verify":1,"raw":1,"machine_norm":400000000,"s0":-20000,"preNTT0":63969,"cast65535":-1,"cast32768":-32768}
```

Oba wykonania mają exit code 0 i pusty stderr. Sanitizer nie zgłosił problemu dla tego wykonania; nie jest to uniwersalny dowód braku UB. Kompilacja standalone zachowała ostrzeżenie `-Wmisleading-indentation` w zastanym helperze `scripts/harness.c:80`; nie dotyczy ono źródła S17, nie zatrzymało kompilacji i nie zostało ukryte przez zmianę starego pliku.

Wykonano **11 rzeczywistych zmian znaczenia**, z odrzuceniem przez porównanie do niezmienionych źródłowych obserwacji lub dokładnej relacji:

| Zmiana | Powód wykrycia |
|---|---|
| Pełne modulo q zamiast source map | norm zmienia się na 43058711057; hipotetyczny model odrzuca, a oryginalny Verify akceptuje |
| Pominięcie unsigned wrap | -1567 zamiast rzeczywistego słowa 63969 |
| Pominięcie signed narrowing STATIC | magnitude 65535 daje błędnie 65535 zamiast zapisanego -1 |
| Centered-domain narzucone STATIC | odrzuca rzeczywiście akceptowane s2[0]=9217 |
| Zły offset A2 | dla rzeczywistej pary 3,-2 daje 13 zamiast 7 |
| Zły znak Ext0 | narusza dokładną kongruencję; sama norma tego błędu nie wykrywa |
| `Q<=B` zamiast `Q<B` | odwraca source decision przy dokładnie B |
| Zła Phi | nie zgadza się z source product dla zawijającego monomianu |
| Verify tylko STATIC | usuwa akceptowane payloady NONE |
| Cap 2049 narzucony przeciwnikowi | usuwa akceptowany payload 3073-bajtowy |
| Ignorowanie nonzero padding | przyjmuje gramatykę odrzuconą przez source |

Mutacje liczą zmienione wartości/werdykty; nie są samymi nazwami odrzuceń. Baseline każdego walidatora przechodzi; identyczna/no-op wartość nie może być policzona jako odrzucona mutacja. Ich kod współdzieli binding C i pomocniczy model z probe — nie przedstawia się go jako drugiego niezależnego checkera. Niezależnym rachunkiem matematycznym jest Sage.

Przełącznik `full_mod=1` istnieje tylko w pomocniczym trace użytym do mutation control. `lv_eval`, source reference i główny świadek nadal używają oryginalnej mapy. Nie uzyskano PASS dla zmodyfikowanego L_V ani nie wdrożono poprawki.

## 7. Lean: rzeczywisty zakres formalizacji

Sprawdzony plik:

```text
formal/WitnessBlocks.lean
SHA-256: f166ae8569868ec8eda7a816e7ffdaa1ebacfa4c98acafde565f869b75da7215
Lean 4.34.0 / Std, commit 293d5d0c0c3f3dded4688b3ccd6a33939ac5102b
```

Kernel sprawdził **26 deklaracji twierdzeń**. Dwanaście bloków po 64 rzeczywiste pary `(z1[i],z1[i+768])` daje komplet 768 par. Każda suma bloku jest obliczona i dowiedziona przez `by decide`, a ogólny lemat `energy_append` uzasadnia złożenie. Liczby z Sage nie zostały wprowadzone jako aksjomaty.

Sprawdzono m.in. dokładną normę pierwszego komponentu, pełne `43058711057`, ścisłą krótkość rzeczywistej machine pair, brak krótkości pary Ext0, excess `40964788672` oraz pomocnicze arytmetyczne tożsamości słów i licznika unary. `verify_bundle.py` parsuje wszystkie literały par z Lean i porównuje je z dokładnym z1 w `witness.json`; nie wystarcza samo powodzenie kompilacji.

Wyjście `#print axioms` zawiera wyłącznie standardowe `propext` tam, gdzie występuje zależność; twierdzenia o pojedynczych blokach nie zależą od żadnych aksjomatów. Nie ma `sorry`, `admit`, lokalnego `axiom`, `unsafe` ani `native_decide`.

**Granica:** sprawdzony fragment formalizuje arytmetykę tych konkretnych wektorów i pomocnicze fakty słowowe. Nie formalizuje całego C, kompilatora, historycznej przynależności h do support ani całego EUF-CMA. Tożsamość ekstraktora i kongruencję sprawdza odrębnie dokładny Sage; akceptację źródłową potwierdzają opisane wykonania C.

Zachowano wcześniejszą próbę `formal/Witness.lean`, SHA-256 `37d87c8085bdca49f46c42a69d855312329ccdd3de6d1cc8dc0d879db3fefa96`. Obliczanie na dużych tablicach przekroczyło zewnętrzny limit 240 s. Nie nadano jej matematycznego werdyktu. Przerwanie nastąpiło przed zapisaniem receipt przez logger: strumienie i child exit code są jawnie oznaczone jako niedostępne w `artifacts/lean_array_timeout.json`, nie jako puste/0. Po przerwaniu nie pozostał proces Lean. Wersja blokowa zachowuje te same współczynniki, offset i B; zmienia organizację sprawdzania, nie tezę.

## 8. Odtwarzalność, logi i integralność

`resume_001/replay_fresh.py` wykonał pełny replay w nowej kopii `tmp/replay_001`, bez nadpisania wyniku i bez powtórnego prepare/KeyGen. Ponownie zbudowano oba shared oracle i oba standalone, wykonano kontrole, Sage, C normal/sanitize, mutacje i Lean. **Dziesięć plików matematycznych było identycznych bajtowo**, w tym b, c, pełny witness JSON, kontrolne certyfikaty i sprawdzony Lean. Receipt i zarchiwizowane strumienie są w `artifacts/fresh_replay.json`, `fresh_replay_COMMANDS.log` i `fresh_replay_logs/`.

To wykonany replay przed końcowym freeze. Instrukcja późniejszego replayu wymaga zewnętrznie podanego SHA-256 finalnego OUTPUTS i odmawia istniejącego destination. Binaria z `-g` mogą różnić się z powodu ścieżki nowej kopii; sprawdzono semantyczne pliki i nowe source/build bindingi, nie ogłoszono bitowej identyczności wszystkich ELF.

Polecenia obliczeniowe mają zapisane argv, cwd, exit code, stdout/stderr i hashe w COMMANDS/logs oraz receipts. Wstępne odczytowe sprawdzenie przed pierwszym zapisem poprzedzało logger; jego piny powtórzono w logowanym bootstrap. Jedyną utratę strumieni nowego obliczenia — timeout pierwszego Lean — opisano jawnie wyżej. Stary `rg: command not found` i przerwanie wcześniejszej próby przez usługę nie są wynikiem matematycznym.

Nowe procesy działały w sandboxie z zapisem tylko do W i cache/TMPDIR pod W. Oryginały H/USB i lokalny checkout były wejściami tylko do odczytu. Końcowy checker ponownie sprawdza 30 oryginalnych wejść, kopie, źródła i zachowanie zastanych plików. Pełny zakres finalnego manifestu, snapshotu append-only dziennika oraz wyłączenia cache/tmp/bin opisuje `OUTPUT_SCOPE.md`.

## 9. Granice wyniku i jeden następny krok

Ujemny wynik dotyczy **dokładnie** tego Ext0, Q, B, modelu i required key support. Nie dowodzi nieistnienia innego ekstraktora, nie znajduje HashToPoint preimage i nie stanowi efektywnego EUF-CMA forgery. Nie zmienia statusu T2C3, T5 ani projektu. Nie wykonywano poprawki źródeł, parametrów, opakowania nonce lub bufora Sign.

**Jedna następna praca:** oddzielny source-bound kontrakt normalizacji zdekodowanego int16 do reprezentanta `rho(x)` spełniającego `0<=rho(x)<q` i `rho(x)≡x mod q`, dla przyszłej jawnie przypiętej wersji Verify. Należy dowieść realizacji tego kontraktu przed użyciem lematu o NTT na canonical residues i zachować niniejszy świadek jako regression case. Obecna wersja S17 nie otrzymuje przez tę rekomendację ani poprawki, ani dodatniego werdyktu L_V.
