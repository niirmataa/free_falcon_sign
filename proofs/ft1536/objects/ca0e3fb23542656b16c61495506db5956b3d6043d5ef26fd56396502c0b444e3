# FT1536 L_RHO — dowód lokalny i minimalny kandydat

**Rozstrzygnięcie: `L_RHO_PROVED_FOR_PINNED_MODEL`.**

W modelu GCC 14.2.0 / C99 / Linux x86_64 LP64 lokalny fragment C realizuje poprawną normalizację **każdego** signed int16 modulo 18433. Związano go z funkcją rzeczywiście wywoływaną przed NTT w kandydacie. Dowód modelu sprawdził kernel Lean; skompilowany helper sprawdzono wyczerpująco dla 65 536 wejść w buildach normalnym i ASan/UBSan przez ten sam niezależny checker Sage.

```text
source_integrated = false
owner_accepted = false
pełne L_V dla kandydata = OPEN_FOR_CANDIDATE
```

To nowy lokalny kandydat, nie nowy S17 i nie integracja. Zamknięty wynik ujemny L_V dla oryginalnego S17 pozostaje punktem odniesienia.

## 1. Zakres i piny

Jedyny katalog zapisu:

```text
/home/footfalcon/Dokumenty/FT1536_L_RHO_RUN_001
```

Przeczytano lokalny i nadrzędny AGENTS, nowe zlecenie, przekazanie po Blue oraz przypięte raporty. Zakończonego odbioru Blue nie wykonywano ponownie. R, D, H, USB i checkout projektu były tylko do odczytu. Kopiowano wskazane publiczne dane; nie uruchamiano KeyGen, nie czytano sekretów, nie instalowano narzędzi ani nie uruchamiano innych agentów.

Najważniejsze kotwice:

| Obiekt | SHA-256 |
|---|---|
| Historyczny manifest S17 | `03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589` |
| R/REPORT.md | `c19cda58e928d585bed8c64745ea165b4dce0fbabee2e51edb40d6392a825cfd` |
| R/OUTPUTS.sha256 | `0223beb04591bd45908c1b167f4bda89b8666ef40901bde7d502f10088c23f87` |
| D/DAYBREAK_REVIEW.md | `d9f9559ffe29b84504a7ff58da88b419b0070b24fc101665bc49459605ef24cc` |
| D/OUTPUTS.sha256 | `281d10aa5071b13a05c6178380909f55743da33469330a6d7463dd5517424771` |
| Referencyjny falcon-vrfy.c | `01c496e5626a37b9d29848c596f0e0efaa328bf9b328649eea4bd1a45fa47f78` |
| Kandydat falcon-vrfy.c | `3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42` |
| CANDIDATE.sha256 | `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a` |
| candidate.patch | `cb7833fce99eb68e671928b71ea28536acfc5f440babfc7b035196050a2c6060` |
| formal/Rho.lean | `daa68021e0f5bac53cf0384a5e10b0537eb6a8ca9d02f0f2970c6ff6eefc7fe8` |

S17 zweryfikowano względem obiektu Git `d641ab1037c2fa1dd4a22c258854d79d67b9b46b`, ścieżki `evidence/_work/PO-01-BASELINE-001-20260803-a1/source_hashes.sha256`. Wszystkie 17 plików H/build i R/reference były zgodne. `INPUTS.sha256` oraz `inputs/provenance.json` wiążą 34 skonsumowane oryginalne pliki z kopiami; nie są nowym manifestem R lub D.

## 2. Tezy i niezmienne obiekty

```text
N=1536, q=18433, Phi=X^1536-X^768+1, B=2093922385.
Q0(a)=sum_{i=0}^{767}(a_i^2+a_i*a_{i+768}+a_{i+768}^2).
Q(z1,z2)=Q0(z1)+Q0(z2).
Ext0(h,c,b)=(center_q(c-h*s(b)),s(b)).
```

s(b) jest faktycznym signed int16 po dekodowaniu. Zachowano COMP_STATIC uczciwego Sign oraz oba tryby rzeczywistego Verify. Nie zmieniono parsera, dziedziny przeciwnika, h, Phi, Q, B ani Ext0.

Niech `rho_Z(x)` będzie jedynym y spełniającym `0<=y<18433` i `y≡x mod18433`. Wybór standardowej nieujemnej reszty `x mod18433` zapewnia istnienie; różnica dwóch takich reprezentantów jest wielokrotnością q o module mniejszym niż q, więc musi być zerowa.

**L_RHO:** dla każdego `x in [-32768,32767]` przypięty fragment C kończy się, wszystkie jego operacje są zdefiniowane i zwraca uint16 o wartości `rho_Z(x)`. W szczególności wynik jest w `[0,18432]` i kongruentny z x.

**Wersja wektorowa:** dla s z 1536 takimi współczynnikami początkowa pętla w raw Verify zapisuje `rho_Z(s_i)` do lokalnego x[i], zachowując oryginalne signed s. Jest to kontrakt normalizacji legalnego bufora współczynników, nie nowe twierdzenie o poprawności wszystkich wykonań parsera.

## 3. Dokładna dziedzina starej mapy

Dla x signed int16 stary kod odpowiada

```text
iota(x)=(x+18433*1[x<0]) mod65536.
```

Uzasadnienie translacji: konwersja ujemnego x do uint32 dodaje 2^32; jego najwyższy bit wskazuje znak w całej domenie int16. `w>>31` jest przesunięciem unsigned. Negacja tego wyniku jest również unsigned i tworzy maskę 0 albo UINT32_MAX. Dodanie q i końcowy cast do uint16 daje powyższe modulo, ponieważ 2^32 jest wielokrotnością 65536. Nie używa się przesunięcia signed liczby ujemnej.

Dokładna postać:

```text
x < -18433       : iota(x)=x+83969, zatem 51201..65535
-18433 <= x < 0  : iota(x)=x+18433
0 <= x <= 32767  : iota(x)=x
```

Stąd, w całej domenie int16:

1. **Kongruencja jest poprawna wtedy i tylko wtedy, gdy `x>=-18433`.** To 51 201 wejść. W dolnej części różnica wynosi 83969, której reszta modulo q jest 10237, nie 0.
2. **Canonical residue otrzymujemy wtedy i tylko wtedy, gdy `-18433<=x<18433`.** To 36 866 wejść. W tym przedziale jest także poprawna kongruencja.
3. Dodatnie `x in [18433,32767]` zachowują kongruencję, ale nie wymagany zakres NTT. Tej różnicy nie pominięto.

Lean dowodzi obu równoważności, a checker Sage odtwarza ich liczności na całej domenie. Nowa mapa zgadza się ze starą na wszystkich 36 866 wejściach, na których stara była canonical.

## 4. Minimalny kandydat i dowód C → model

Jedyny zmieniony plik produkcyjnej kopii to `candidate/falcon-vrfy.c`. Pozostałe **16/16** plików są bajtowo identyczne z S17. Dodano helper:

```c
static uint16_t
ft1536_normalize_s2(int16_t x)
{
    int32_t t;

    t = (int32_t)x + 36866;
    return (uint16_t)(t % 18433);
}
```

Pętla przed NTT wywołuje go wyłącznie pod warunkiem:

```c
if (ternary == 1 && logn == 10) {
    x[u] = ft1536_normalize_s2(s2[u]);
} else {
    /* dokładnie dotychczasowa normalizacja z użyciem q */
}
```

Dla tej gałęzi kod już ustalił q=Qt=18433 i n=1536. Każda inna kombinacja parametrów zachowuje poprzednią ścieżkę. Helper jest lokalny i bez stanu; jego samo dodanie nie zmienia zachowania innych gałęzi. Nie odrzuca współczynników niecentered.

`scripts/bind.py` odtwarza oczekiwany kandydat z referencji przez dokładnie te dwie zmiany i wymaga pełnej zgodności bajtowej. Sprawdza jedno rzeczywiste wywołanie helpera w pętli i niezmienione przekazanie s2 do normy. Generuje diff, manifest i `artifacts/source_binding.json`. Dowód dotyczy **tego helpera**, a enumerator włącza właśnie plik kandydata i wywołuje tę samą statyczną funkcję.

### 4.1. Typy i wartości pośrednie

Model: GCC 14.2.0, C99, Linux x86_64 LP64; bajt 8-bitowy, int/unsigned i int32_t 32-bitowe, int16_t/uint16_t 16-bitowe, long/size_t 64-bitowe. Harnessy potwierdzają szerokości i granice stałymi asercjami kompilacji. Flagi pochodzą z S17/Makefile, z jawnym `-std=c99`; pełne argv obu buildów są w receipts.

| Etap | Uzasadnienie dla każdego int16 x |
|---|---|
| Wejście `int16_t x` | matematyczna wartość x jest w `[-32768,32767]` |
| `(int32_t)x` | rozszerzenie dokładne; cały ten zakres mieści się w int32 |
| Literały 36866 i 18433 | mieszczą się w signed int w tym modelu; `36866=2*q` |
| Dodawanie | oba operandy po promocjach mają signed 32-bitowy zakres; `t=x+36866 in [4098,69633]`, więc brak signed overflow |
| `% 18433` | dodatni dzielnik, dodatni dividend; nie ma dzielenia przez zero ani wyjątku INT_MIN/-1 |
| Iloraz C99 | truncation toward zero jest tu dokładnie podłogą; iloraz należy do `[0,3]` |
| Reszta | `r=t-floor(t/q)*q` należy do `[0,18432]` |
| `(uint16_t)r` | konwersja dokładna, ponieważ `r<18433<65536` |
| Zakończenie/purity | prostoliniowa funkcja, bez pętli, pamięci dynamicznej i efektów ubocznych |

Nie utożsamia się reszty C dla ujemnego argumentu z nieujemnym modulo Sage/Lean. Strategia `x+2q` sprawia, że `%` w kandydacie **nigdy nie otrzymuje ujemnego argumentu**. Ponieważ dodano wielokrotność q, wynik jest `rho_Z(x)`.

### 4.2. Model formalny i jego powiązanie

W `formal/Rho.lean`:

```text
InInt16(x) := -32768 <= x <= 32767
shifted(x) := x+36866
cPositiveRem(t) := t-(t/18433)*18433
u16(r) := r mod65536
rhoWord(x) := u16(cPositiveRem(shifted(x)))
rhoZ(x) := x mod18433
```

`/` w modelu jest dzieleniem euklidesowym. Jego zgodność z C uzasadnia wyżej udowodniona dodatniość t. `rho_contract` kwantyfikuje po **dowolnym** x spełniającym InInt16, a nie po kilku świadkach lub zaimportowanej tabeli. Dowodzi równości rhoWord=rhoZ, zakresu i kongruencji. `result_cast_exact` osobno rozlicza cast do uint16; `intermediate_ranges` podaje granice argumentu, sumy i ilorazu.

Jest to dowód modelu arytmetycznego wraz z jawną translacją tego małego fragmentu według semantyki C99 i przypięciem tekstu. Nie jest formalizacją parsera C, kompilatora GCC ani całego verifiera. Kontrola skompilowanego kodu pozostaje osobnym ogniwem opisanym w §6.

### 4.3. Pętla i zachowanie s

Helper bierze wartość, nie wskaźnik. Pętla czyta `s2[u]` i zapisuje wyłącznie lokalne `x[u]`; NTT później działa na x, a norma nadal otrzymuje **oryginalne signed s2**.

Dla legalnego wejściowego bufora s o długości co najmniej 1536 i świeżej lokalnej tablicy x[3072] inwariant prefiksu to: `0<=u<=1536`, s niezmienione i `x[i]=rho_Z(s[i])` dla i<u. Krok wynika z kontraktu skalarnego; indeks mieści się w tablicy. Wariant `1536-u` maleje. `loop_progress` sprawdza też `u+1<=1536<2^64`, więc size_t nie zawija się. Pętla kończy się po 1536 krokach.

`vector_contract` formalizuje wersję punktową na `Fin 1536` oraz zachowanie drugiej, signed składowej wyniku. Powyższy argument o obiektach pamięci łączy ją z konkretną pętlą C; wymaga zwykłych przesłanek legalności buforów i wykonania C, nie twierdzenia o każdym możliwym błędnym wskaźniku.

## 5. Lean i rzeczywisty zakres dowodu

Sprawdzono Lean 4.34.0 / Std, commit `293d5d0c0c3f3dded4688b3ccd6a33939ac5102b`. Nie instalowano mathlib. Kernel zakończył się exit 0 i sprawdził 12 deklaracji:

```text
intermediate_ranges, positive_remainder, rho_contract, result_cast_exact,
canonical_unique, old_piecewise, old_congruence_domain,
old_canonical_domain, agree_on_old_canonical, vector_contract,
loop_progress, center_antisymmetric.
```

Każda ma `#print axioms`. Zależności zawierają tylko standardowe `propext`, `Classical.choice`, `Quot.sound`. W sprawdzonym źródle nie ma `sorry`, `admit`, lokalnych aksjomatów pożądanego wyniku, `unsafe` ani `native_decide`.

Pierwszy szkic miał błędy taktyk rozbijających warunki starej mapy i zakończył się exit 1. Zachowano go w `formal/attempts/Rho_initial.lean` wraz z logiem; automatyczne metavariables/sorryAx z tego **nieudanego** sprawdzenia nie są przesłankami wyniku. Poprawiono organizację dowodu, nie definicje kandydata ani dziedzinę. Końcowa wersja przechodzi; ostrzeżenia o przestarzałych nazwach aliasów `if_pos/if_neg` nie są dodatkowymi aksjomatami i pozostają w logu.

## 6. Pełna kontrola skompilowanego fragmentu

`scripts/enumerate.c` bezpośrednio włącza wybraną kopię falcon-vrfy.c i wywołuje `ft1536_normalize_s2`. Pętla używa int32 od -32768 do 32767; cast wejścia do int16 jest zawsze reprezentowalny, a round-trip do int32 jest dodatkowo sprawdzany. Nie ma pętli w int16, która zawijałaby się na końcu typu, ani benchmarku innej przepisanej formuły.

Każdy build zapisuje pełną tablicę CSV z 65 536 parami x,rho. Niezmieniony checker `scripts/check_sage.py scalar ...` importuje `sage.all.ZZ`, porównuje każdy wynik z dokładnym `ZZ(x)%ZZ(18433)`, sprawdza zakres, kongruencję, kolejność i kompletność bez duplikatów. Zapisuje również brzegi i pierwsze błędy mutantów.

**Normalny i ASan/UBSan build: 65 536/65 536 poprawnych wyników, 0 naruszeń.** Tablice są identyczne bajtowo:

```text
artifacts/scalar-candidate-normal.csv
artifacts/scalar-candidate-asan.csv
SHA-256: 7e1a00e898153e561ec8b0c4dcaa8ca19bc9343fe9f6c59cf99390632546217c
```

| x | Stara iota(x) | Kandydat rho(x) |
|---:|---:|---:|
| -32768 | 51201 | 4098 |
| -20000 | 63969 | 16866 |
| -18434 | 65535 | 18432 |
| -18433 | 0 | 0 |
| -18432 | 1 | 1 |
| -1 | 18432 | 18432 |
| 0 | 0 | 0 |
| 1 | 1 | 1 |
| 18432 | 18432 | 18432 |
| 18433 | 18433 | 0 |
| 18434 | 18434 | 1 |
| 32767 | 32767 | 14334 |

W osobnych kopiach zmieniono rzeczywisty helper C, skompilowano go i ponownie zebrano pełne tablice. **Ten sam checker** wykrył:

| Mutacja | Naruszenia spośród 65 536 |
|---|---:|
| Stara mapa | 28670 |
| Cast sumy x+2q do uint16 przed modulo | 4098 |
| Moduł 18432 zamiast 18433 | 51202 |
| Ujemna reszta `x % 18433` bez korekty | 32767 |
| No-op `x+36866+0` | **0 — poprawna kontrola, nie odrzucona mutacja** |

Wyjście 1 checkera dla czterech mutantów oznacza zapisane konkretne naruszenia przy kompletnym pokryciu, nie błąd importu lub same etykiety. No-op daje identyczną tablicę jak baseline i został poprawnie zaakceptowany. Pełna enumeracja kontroluje realizację skończoną; nie zastępuje translacji C→model ani dowodu kompilatora.

## 7. Regresje prawdziwej ścieżki Verify

Użyto istniejących, hash-sprawdzonych publicznych PK/h oraz **identycznych** c i b ze świadka R. Nie szukano preimage HashToPoint. Testowy harness podstawia jawne c, zgodnie z kontraktem, pozostawiając pozostałe operacje źródłowe.

Nowy `scripts/verify_driver.c` używa prawdziwego `falcon_vrfy_set_public_key`; do raw Verify trafia h przygotowane przez NTT/Montgomery. Nie używa starego `lv_trace`. Oddzielne testowe kopie w `observed/` wstawiają tylko obserwator wejścia do rzeczywistego NTT: kopiuje słowa i deleguje do oryginalnego mq_NTT. Wstawka jest po definicji NTT i loaderze, przed raw Verify. Po jej usunięciu plik musi być bajtowo równy właściwej referencji/kandydatowi.

Obserwator normy kopiuje rzeczywiste argumenty, po czym wywołuje niezmienione `falcon_is_short`. Osobne buildy **bez obserwatorów**, z oryginalnych plików reference/candidate, potwierdzają decyzję. Runner rozdziela exit code testu od bool Verify: prawidłowe oczekiwane odrzucenie ma exit 0.

| Ten sam świadek | S17 reference | Lokalny kandydat |
|---|---:|---:|
| s[0] po dekodowaniu i w normie | -20000 | -20000 |
| Rzeczywiste słowo przed NTT | 63969 | **16866** |
| Norma pary badanej przez C | 400000000 | **43058711057** |
| Pełne Verify / raw | 1 / 1 | **0 / 0** |
| B | 2093922385 | 2093922385 |

Przewidywania zostały sprawdzone, nie wpisane jako założenia. Sage wylicza poprawny iloczyn modulo `(q,Phi)`, centrowanie i normę w dokładnej arytmetyce, porównując całe wektory. Dla kandydata rzeczywisty pierwszy komponent jest `center_q(h*s-c)=-Ext0.first`, a Signed s pozostało niezmienione.

Mały zestaw dodatni obejmuje trzy wektory w poprawnej dziedzinie starej normalizacji, każdy w STATIC i NONE: zero, zawijający wysoki monomian i parę offset-768 ze składnikiem mieszanym. c obliczono niezależnie w Sage nad `GF(q)[X]/Phi`, nie przez badany NTT. Normy dodatnich par wynoszą odpowiednio 7, 296 i 80. Referencja i kandydat akceptują je identycznie.

Łącznie: 7 przypadków × 2 wersje × 2 buildy × obserwator/bez obserwatora = **56 poprawnych wykonań**. ASan/UBSan nie zgłosiły błędu; tutaj także `detect_leaks=1` działało. Nie przeniesiono automatycznie na tę sesję blokady LSan/ptrace z Blue. Są to ograniczone regresje, nie dowód całego Verify.

## 8. Warunkowy most do pełnego L_V

L_RHO daje początkowe canonical residues r i `r≡s modq`, zachowując oryginalne Signed s. Załóżmy teraz dodatkowo, że źródłowa arytmetyka NTT/Montgomery na tych reprezentantach oblicza `h*s-c` w R_q, a końcowe centrowanie daje rzeczywiście

```text
v = center_q(h*s-c).
```

Ponieważ q=18433 jest nieparzyste, przedział `[-9216,9216]` jest symetryczny, zawiera dokładnie jednego reprezentanta każdej klasy, a zanegowanie reprezentanta pozostaje w nim. Zatem

```text
v = center_q(-(c-h*s)) = -center_q(c-h*s).
```

Odpowiednią antysymetrię dowodzi także `center_antisymmetric` w Lean. Dla każdej pary A2:

```text
(-a)^2 + (-a)*(-b) + (-b)^2 = a^2 + a*b + b^2.
```

Po zsumowaniu wszystkich 768 par i zachowaniu drugiego komponentu s:

```text
Q(v,s)=Q(center_q(c-h*s),s)=Q(Ext0(h,c,b)).
```

Nie użyto monotoniczności Q przy współczynnikowym centrowaniu s; taka własność nie zachodzi ogólnie. Dopiero po wykazaniu dokładności źródłowej normy i ścisłego testu `<B` powyższa równość przenosi akceptację na krótkość Ext0.

Pozostałe obowiązki pełnego L_V obejmują:

1. poprawność i wszystkie zakresy pośrednie NTT/Montgomery oraz odejmowania w R_q dla canonical inputs;
2. poprawność przygotowania h przez loader dla pełnej wymaganej dziedziny kluczy;
3. dekodowanie pełnego języka bajtowego, konwersje i legalność wykonania parsera;
4. zgodność końcowego source centering z matematycznym center_q i jego zakresem;
5. dokładność Q w C, legalność działań/pamięci i ścisły próg dla całej dziedziny, nie tylko regresji.

**Jedna następna rekomendacja:** osobne source-bound twierdzenie poprawności i zakresów kanonicznej ścieżki NTT/Montgomery FT1536, konsumujące L_RHO tego przypiętego kandydata. Nie rozpoczęto go w tym zadaniu.

## 9. Środowisko, błędy techniczne i odtwarzalność

Przed obliczeniami potwierdzono rzeczywisty sandbox: zapis w W działa, a próby uzyskania write descriptor bez O_TRUNC do przypiętych oryginałów R, D, H i nadrzędnego AGENTS zwróciły **EROFS**. Żadnych bajtów do nich nie zapisano. Bwrap ma root tylko do odczytu, jedyny zapisowy bind W, sieć odłączoną; po przygotowaniu reference jest dodatkowo montowane tylko do odczytu. Cache, HOME, TMPDIR, DOT_SAGE i XDG_CACHE_HOME wskazują W.

Sage uruchamiano przez `/home/footfalcon/.local/bin/sage`, z rzeczywistym importem sage.all. `sage.version.version` dało **10.9**, a `sys.version` osobno Python **3.14.7**. Pierwsza próba argumentu `-python` została odrzucona przez zainstalowany frontend (exit 2); zastosowano obsługiwane `sage plik.py ...`. Nie instalowano innego narzędzia, nie wyłączano sandboxa i nie uznano błędu CLI za błąd matematyczny.

Wersje, pełne polecenia, cwd, limity, kody wyjścia, stdout/stderr i hashe znajdują się w TOOLCHAIN, COMMANDS/logs i receipts. Procesy mają jawne limity czasu; nie wystąpił timeout obliczeń. Zachowano log błędnego pierwszego szkicu Lean. Dalsze sprawdzenia korzystają wyłącznie z finalnej udanej deklaracji, nie z jego tymczasowych metavariables.

Świeży replay w `tmp/replay_001` ponownie wykonał binding, Lean, kompilacje, pełną enumerację, mutacje i regresje. **64 pliki znaczeniowe były identyczne bajtowo**, w tym diff, manifest kandydata, formalny certyfikat, pełna tablica skalarna i wszystkie 56 wyników Verify. Był to replay przed finalnym freeze; instrukcja późniejszego replayu wymaga zewnętrznego SHA-256 OUTPUTS. Nie odtwarzano całego odbioru Blue.

Końcowy audyt sprawdza 34 oryginalne wejścia i kopie, H/S17, referencję, kandydata, binding formalny, tablice, receipts i zakresy. `OUTPUT_SCOPE.md` opisuje zamrożony prefiks dziennika i wyłączenia cache/tmp/bin. Wynik kończy się na tym lokalnym dowodzie i kandydacie, przed integracją lub dowodzeniem całego L_V.
