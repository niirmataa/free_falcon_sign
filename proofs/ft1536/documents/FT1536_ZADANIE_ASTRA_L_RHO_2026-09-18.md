# Zadanie GPT-ASTRA — L_RHO: normalizacja int16 przed NTT

Data: 2026-09-18. Nowe zadanie po ukończonym niezależnym odbiorze Blue.

## 0. Karta zadania

- **Cel:** dowieść poprawności normalizacji każdego zdekodowanego int16
  do reszty modulo 18433 i związać dowód z minimalnym lokalnym kandydatem C.
- **Po co teraz:** potwierdzony kontrprzykład do Ext0 wykazał, że S17 nie
  zapewnia tej normalizacji. To pierwszy lokalny krok proponowany w §9
  raportu Astry przed ponownym badaniem mostu Verify → krótki świadek.
- **Odczyt:** przypięte raporty, źródła S17 i istniejące publiczne dane świadka.
- **Zapis:** wyłącznie `/home/footfalcon/Dokumenty/FT1536_L_RHO_RUN_001`.
- **Wynik:** dokładna teza L_RHO, dowód, kandydat z diffem i hashami,
  wyczerpująca kontrola realizacji skalarnej oraz ograniczone regresje Verify.
- **Warunek końca:** raport z rozstrzygnięciem L_RHO i listą pozostałych
  obowiązków pełnego L_V. Dodatni wynik nie jest z góry założony.

Wykonaj zadanie do uzyskania raportu; nie poprzestawaj na propozycji planu.
Zakres obejmuje opracowanie kandydata w nowym katalogu, nie integrację
zmiany z historycznym ani publikowanym kodem projektu.

## 1. Kontekst i korzenie

```text
DOC = /home/footfalcon/Dokumenty
R = DOC/FT1536_LV_STATIC_RUN_001
D = DOC/FT1536_LV_STATIC_ODBIOR_BLUE_001
W = DOC/FT1536_L_RHO_RUN_001
H = /media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon
S17 = H/build
```

Uruchom sesję z katalogiem roboczym W. Przeczytaj lokalny `W/AGENTS.md`,
nadrzędne instrukcje oraz:

1. `DOC/FT1536_PRZEKAZANIE_ASTRA_PO_BLUE_2026-09-18.md`;
2. `R/REPORT.md`, szczególnie §3, §4 i §9;
3. `D/DAYBREAK_REVIEW.md` i `D/DAYBREAK_RESULT.json`.

W jest przygotowany i zawiera instrukcję startową. Jeśli zastaniesz również
wyniki wcześniejszego wykonania, ustal ich stan i wznów bez nadpisywania
historii. W instrukcjach rodzica wartość W i etap „odbiór Blue” odnoszą się
do ukończonego zadania; niniejsze zlecenie oraz lokalny AGENTS.md je aktualizują.

Piny SHA-256:

```text
DOC/AGENTS.md
e5d9cc7b5120aad39da592f796eef44cc8a1c71bc6c43b311f48362d60fdd038

DOC/FT1536_PRZEKAZANIE_ASTRA_PO_BLUE_2026-09-18.md
a47fc84b0b366e4cbc12e01adc5ad08fa5de8164a46c25a463aec4a7b54c3643

R/REPORT.md
c19cda58e928d585bed8c64745ea165b4dce0fbabee2e51edb40d6392a825cfd

R/OUTPUTS.sha256
0223beb04591bd45908c1b167f4bda89b8666ef40901bde7d502f10088c23f87

D/DAYBREAK_REVIEW.md
d9f9559ffe29b84504a7ff58da88b419b0070b24fc101665bc49459605ef24cc

D/OUTPUTS.sha256
281d10aa5071b13a05c6178380909f55743da33469330a6d7463dd5517424771

D/inputs/source_hashes.sha256
03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589
```

Manifest S17 pochodzi z commita
`d641ab1037c2fa1dd4a22c258854d79d67b9b46b`, ścieżka Git:
`evidence/_work/PO-01-BASELINE-001-20260803-a1/source_hashes.sha256`.
Jego ścieżki są względem katalogu źródeł, nie katalogu manifestu.

Zweryfikuj piny i każdą konsumowaną kopię. Nie ponawiaj całego odbioru Blue
jako osobnego zadania. Referencję 17 plików możesz skopiować z `R/reference/`
po sprawdzeniu ich względem manifestu S17. Kandydat warning-clean z
`/home/footfalcon/free_falcon_sign/Extra/c` pozostaje poza tą bazą.

## 2. Niezmienne definicje i przedmiot kontraktu

```text
N = 1536
q = 18433
Phi = X^1536 - X^768 + 1
B = 2093922385
Q0(a) = sum_{i=0}^{767}(a_i^2 + a_i*a_{i+768} + a_{i+768}^2)
Q(z1,z2) = Q0(z1) + Q0(z2)
Ext0(h,c,b) = (center_q(c-h*s(b)), s(b))
```

`s(b)` to matematyczne wartości faktycznie zapisanych współczynników int16_t
po źródłowym dekodowaniu. Uczciwy profil jest COMP_STATIC, ale rzeczywisty
Verify obsługuje także NONE. Nie zmieniaj parsera ani dziedziny przeciwnika.

Stara mapa z `falcon-vrfy.c:1393–1399` dla FT1536:

```c
w = (uint32_t)s2[u];
w += q & -(w >> 31);
x[u] = (uint16_t)w;
```

Jej interpretacja matematyczna to
`iota(x) = (x + q*1[x<0]) mod 65536` dla signed int16 x.
Wyprowadź dokładnie jej dziedzinę poprawności; odróżnij poprawną kongruencję
od wymaganego przez NTT zakresu `[0,q-1]`.

Zdefiniuj `rho_Z(x)` jako jedyną liczbę całkowitą z `[0,q-1]`, kongruentną
z x modulo q. Wybierz i przypnij konkretny fragment C realizujący `rho_C`.

**L_RHO:** dla każdego `x in [-32768,32767]` wykonanie tego fragmentu
w jawnym modelu C kończy się, jest zdefiniowane i zwraca uint16_t o wartości:

```text
rho_C(x) = rho_Z(x),
0 <= rho_C(x) < 18433,
rho_C(x) == x (mod 18433).
```

Wersja wektorowa: zastosowanie tego samego fragmentu do 1536 współczynników
daje canonical residues kongruentne z s i nie zmienia bufora signed s.
Kontrakt dotyczy każdego int16, niezależnie od sposobu uzyskania go z bajtów.
Nie jest nowym twierdzeniem o wszystkich wykonaniach parsera.

## 3. Kandydat i związanie modelu ze źródłem

Przygotuj w W:

- `reference/` — kopię S17, dalej niezmienianą;
- `candidate/` — osobną kopię z minimalną zmianą normalizacji;
- `candidate.patch` i `CANDIDATE.sha256` — dokładny diff i manifest kandydata.

Dopuszczalna zmiana źródłowa dotyczy wyłącznie normalizacji przed NTT
w `falcon_vrfy_verify_raw` dla FT1536 (`ternary=1`, `logn=10`). Możesz dodać
lokalny helper w `falcon-vrfy.c`. Ponieważ funkcja jest współdzielona,
zachowaj dotychczasową ścieżkę innych parametrów; nie naprawiaj przy okazji
innych profili. Pozostałe pliki S17 mają pozostać bajtowo identyczne.

Model bazowy: GCC 14.2.0, C99, Linux x86_64 LP64, bajt 8-bitowy,
int/unsigned 32-bitowe, int16_t/uint16_t 16-bitowe, long/size_t 64-bitowe.
Potwierdź szerokości w kompilowanym harnessie. Zachowaj właściwe flagi
z S17/Makefile i jawne `-std=c99`; zapisz pełne polecenia obu buildów
oraz dodatkowe flagi sanitizera. Nie przenoś wyniku bez uzasadnienia
na inny model wykonania.

Zachowaj loader publicznego klucza, dekodery, HashToPoint, NTT/Montgomery,
centrowanie pierwszego komponentu, oryginalny signed s2 w normie, Q i B.
Nie zastępuj poprawnej normalizacji odrzucaniem niecentered współczynników.

Preferuj prostą realizację o czytelnej semantyce. Rozlicz rzeczywiste typy,
promocje C, konwersje, ujemne argumenty i wszystkie wartości pośrednie.
Jeśli używasz `%`, uwzględnij resztę C dla ujemnego argumentu; nie utożsamiaj
jej bez dowodu z nieujemnym modulo Sage/Lean. Nie opieraj rozwiązania na
signed overflow, przesunięciu ujemnej liczby o nieustalonej semantyce lub
zawężeniu signed poza zakresem.

Powiąż z formalnym modelem dokładnie fragment wywoływany w kandydacie.
Udowodnienie innej funkcji pomocniczej, która nie jest używana przez Verify,
nie spełnia zadania. Rozdziel formalny dowód modelu, uzasadnienie translacji
C → model oraz kontrolę skompilowanego kodu; podaj przesłanki każdego kroku.

## 4. Dowód i niezależna kontrola skalarna

1. Zapisz tezy L_RHO, poprawności starej mapy na jej właściwej dziedzinie
   oraz zgodności nowej mapy ze starą tam, gdzie stara daje canonical residue.
2. Przygotuj sprawdzany przez kernel certyfikat Lean 4.34.0/Std dla
   wybranej realizacji słowowej. Pokaż zakresy pośrednie, zakończenie,
   brak niedozwolonych konwersji i wynik dla całej dziedziny int16.
   Podaj deklaracje, imports i `#print axioms`; bez `sorry`, `admit`,
   lokalnego aksjomatu pożądanego wyniku i `native_decide`.
3. Wywołaj rzeczywisty fragment kandydata C dla **wszystkich 65536 wartości**
   signed int16. Nie używaj jako przedmiotu testu osobno przepisanej formuły.
4. Niezależny checker Sage porówna każdy wynik C z dokładnym modulo w ZZ,
   sprawdzi zakres i pełne pokrycie wejść bez duplikatów. Zapisz tablicę
   wyników lub równoważny kompletny certyfikat z hashem, nie sam licznik PASS.
5. Uwzględnij jawnie końce typu, `-q-1`, `-q`, `-q+1`, `-1`, `0`, `1`,
   `q-1`, `q`, `q+1` i `-20000`. Błędy konwersji nie mogą zniknąć wskutek
   niepoprawnego przekazania wejścia przez sam harness.
6. Sprawdź normalny build oraz ASan/UBSan dla nowego fragmentu i regresji.
   Jeśli LSan blokuje ptrace, odnotuj tę samą granicę środowiska co Blue;
   kontrolę ASan/UBSan bez LSana oznacz precyzyjnie.

Pełna enumeracja realizacji jest kontrolą na skończonej dziedzinie, a nie
substytutem niewykazanego związku formalnego modelu z C. Nie przypisuj temu
certyfikatowi formalizacji kompilatora ani pełnego weryfikatora.

## 5. Regresje rzeczywistej ścieżki Verify

Użyj wyłącznie istniejącego publicznego klucza i świadka:

```text
R/inputs/key/canonical_public_key.bin
R/inputs/key/canonical_public_h.txt
R/artifacts/witness.bin
R/artifacts/witness_c.txt
R/artifacts/witness.json
```

Po hash-sprawdzeniu skopiuj potrzebne pliki do W. Nie szukaj wiadomości lub
nonce dla c; jawne c jest wejściem badanego kontraktu. W testowym harnessie
można zachować dotychczasowe podstawienie jawnego c za HashToPoint.

Wymagane kontrole:

- **Referencja S17, ten sam świadek:** pełne Verify zwraca 1, a rzeczywista
  norma C wynosi 400000000. To kontrola zachowania ujemnego punktu odniesienia.
- **Kandydat, identyczne h/c/b:** sprawdź oczekiwane słowo normalizacji
  16866 zamiast 63969, niezmienione s, normę 43058711057 i odrzucenie
  (`verify=0`, `raw=0`). Są to przewidywania do sprawdzenia, nie założenia.
- **Mały zestaw dodatni:** publiczne, syntetyczne przypadki STATIC i NONE
  z poprawnej dziedziny starej normalizacji. Oblicz c niezależnie dokładną
  arytmetyką, uwzględnij parę offset-768 z niezerowym składnikiem mieszanym Q.
  Sprawdź zgodność referencji i kandydata oraz poprawne przygotowanie h.

Korzystaj z prawdziwego `falcon_vrfy_set_public_key`; do raw Verify trafia
przygotowane NTT/Montgomery h. Zapisz rzeczywiste argumenty normy przez
obserwację wywołania, która następnie wykonuje niezmieniony `falcon_is_short`.
Osobny przebieg bez obserwatora ma potwierdzić tę samą decyzję.

**Istotna pułapka starego harnessu:** `R/scripts/harness.c` ma `lv_trace`
z osobno wpisaną starą mapą, a jego `main` uznaje wyłącznie akceptację za
sukces procesu. Nie używaj tego trace jako obserwacji poprawionego C.
Przygotuj nowy runner w W, rozdzielający wynik Verify od sukcesu testu:
oczekiwane odrzucenie kandydata jest poprawnym wynikiem regresji. Samo
`full_mod=1` w starym trace nie jest poprawką źródłowego Verify.

Dodaj rzeczywiste kontrole zmiany znaczenia na osobnych kopiach testowych:
stara mapa, rzutowanie do uint16 przed poprawnym modulo oraz niepoprawny
moduł lub pominięta korekta ujemnej reszty. Baseline musi przechodzić,
a każda policzona mutacja rzeczywiście zmieniać wynik i być wykryta przez
ten sam niezależny checker. No-op nie jest odrzuconą mutacją.

## 6. Co L_RHO daje dalej

W raporcie wyprowadź krótki **warunkowy** most algebraiczny:

```text
Jeżeli źródłowe operacje na canonical residues obliczają h*s-c w R_q,
a ich końcowe centrowanie daje v = center_q(h*s-c), to:

    v = -center_q(c-h*s),
    Q(v,s) = Q(Ext0(h,c,b)).
```

Rozlicz nieparzystość q, zakres center i niezmienniczość całej formy Q0
przy zanegowaniu całego pierwszego komponentu. Nie zakładaj monotoniczności
Q przy współczynnikowym centrowaniu s — taka własność nie zachodzi ogólnie.

Jawnie wypisz pozostałe przesłanki: poprawność i zakresy NTT/Montgomery,
przygotowanie h, dekodowanie pełnego języka, centrowanie, dokładność normy
C i ścisły próg. Nie zamykaj ich samym sukcesem regresji jednego świadka.
Pełny dowód tych interfejsów jest następnym, osobnym zadaniem.

## 7. Środowisko i wykonanie

Przed obliczeniami potwierdź rzeczywistą izolację zapisu do W. Wszystkie
kompilacje, cache, TMPDIR, DOT_SAGE i XDG_CACHE_HOME mają używać W. W razie
braku narzędzia lub blokady zapisz niewykonaną kontrolę; nie wyłączaj sandboxa.

Zaobserwowane narzędzia:

```text
Sage: /home/footfalcon/.local/bin/sage                 (10.9)
Lean: /home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean
GCC:  /usr/bin/gcc                                   (14.2.0)
```

Własny checker `.py` uruchamiaj przez Sage, np. `sage -python ...`,
z rzeczywistym importem `sage.all`. Zapisz osobno `sage.version.version`
i `sys.version`; nazwa pliku `.py` nie zmniejsza poprawności użycia Sage.
Nie instaluj mathlib ani innych zależności. Jeśli wersje się różnią, zapisz
różnicę i oceń możliwość tego nowego wykonania bez zmiany historycznych pinów.

Polecenia, cwd, wersje, kody wyjścia, surowe stdout/stderr i hashe zapisuj
w W. Ustaw jawne, rozsądne limity procesów; timeout lub przerwanie pozostają
wynikiem technicznym. Nie kontynuuj pozostawionego procesu w tle równolegle
z nową próbą. R, D, H i dotychczasowe checkouty są tylko do odczytu.

## 8. Wymagane wyjścia i rozstrzygnięcie

Zapisz co najmniej:

- `REPORT.md` — teza, kandydat, dowody i granice; jedna następna rekomendacja;
- `RESULT.json` — status L_RHO i osobne statusy modelu, związku z C,
  enumeracji, regresji i pozostałych obowiązków;
- `candidate.patch`, `CANDIDATE.sha256`, `reference/`, `candidate/`;
- certyfikat Lean, checker Sage, nowe harnessy i komplet wyników;
- `INPUTS.sha256`, `TOOLCHAIN.txt`, `COMMANDS.log`, logi;
- `REPLAY.md`, `OUTPUT_SCOPE.md`, `OUTPUTS.sha256`.

Możliwe statusy główne:

- `L_RHO_PROVED_FOR_PINNED_MODEL` — teza lokalna dowiedziona, związek
  z przypiętym fragmentem C rozliczony, wymagane kontrole wykonane;
- `COUNTEREXAMPLE_TO_CANDIDATE` — konkretny przypadek obalający wybraną tezę;
- `PARTIAL_PROOF` — jawnie wskazane brakujące obowiązki lub regresje;
- `EXECUTION_BLOCKED` — problem wykonania bez matematycznego rozstrzygnięcia.

W RESULT.json zachowaj `source_integrated=false`, `owner_accepted=false`
i osobny stan pełnego L_V, którego to zadanie nie dowodzi. Ewentualna
rozbieżność dalszej ścieżki NTT/Verify wymaga jawnego wpisu nawet wtedy,
gdy lokalny dowód normalizacji jest poprawny.

Manifest ma obejmować raport, tezy, źródła obu wersji, diff, checkery,
certyfikaty, użyte wejścia i receipts. Opisz wyłączenia cache/bin i zamrożoną
kopię dziennika. Replay musi używać świeżego katalogu docelowego, nie
nadpisywać ukończonego pakietu. Nie regeneruj manifestów R lub D.

Na końcu podaj użytkownikowi po polsku rozstrzygnięcie, dokładny zakres
uzyskanego dowodu, pozostałe obowiązki, pełną ścieżkę REPORT.md oraz SHA-256
raportu i OUTPUTS.sha256. Zakończ tę pracę przed integracją kandydata
lub rozpoczęciem dowodu całego L_V.
