# Zadanie GPT-ASTRA — L_NTT: kanoniczna ścieżka NTT/Montgomery FT1536

Data: 2026-09-18. Następny etap po `L_RHO_PROVED_FOR_PINNED_MODEL`.

## 0. Karta zadania

- **Cel:** dowieść, że rzeczywista kanoniczna ścieżka NTT/Montgomery
  przypiętego kandydata oblicza iloczyn i różnicę w wymaganym pierścieniu,
  z poprawnymi zakresami i zdefiniowaną arytmetyką C.
- **Po co teraz:** L_RHO zapewniło poprawne wejście r do NTT. Teraz trzeba
  wykazać, co kod oblicza po tej normalizacji, zanim przeniesiemy normę Verify
  na matematyczny świadek Ext0.
- **Odczyt:** ukończony pakiet L_RHO, jego kandydat i potrzebne publiczne wejścia.
- **Zapis:** wyłącznie `/home/footfalcon/Dokumenty/FT1536_L_NTT_RUN_001`.
- **Wynik:** source-bound teza L_NTT, dowód z certyfikatami i dokładnym
  powiązaniem z kodem; niezależne kontrole Sage/C i jawna macierz obowiązków.
- **Warunek końca:** rozstrzygnięcie L_NTT z raportem. Dodatni wynik nie jest
  założony; konkretny kontrprzykład lub precyzyjny częściowy wynik są dopuszczalne.

Wykonaj zadanie do raportu, nie zatrzymuj się na samym planie. Jest to
sprawdzenie **istniejącego kandydata**, bez nowej poprawki źródłowej.

## 1. Start, źródła i piny

```text
DOC = /home/footfalcon/Dokumenty
P = DOC/FT1536_L_RHO_RUN_001
SRC = P/candidate
W = DOC/FT1536_L_NTT_RUN_001
```

Rozpocznij sesję z cwd=W. Przeczytaj lokalny AGENTS.md, nadrzędne instrukcje,
`DOC/FT1536_PODSUMOWANIE_L_RHO_2026-09-18.md`, `P/REPORT.md` i `P/RESULT.json`.
Lokalny AGENTS i niniejsze zlecenie zastępują historyczne wskazania etapu,
wykonawcy i W. Zakończonych prac L_RHO/L_V/Blue nie wznawiaj.

Przygotowany W zawiera AGENTS.md. Jeśli zastaniesz dalsze artefakty,
ustal ich stan i wznów bez nadpisywania historii.

Piny SHA-256:

```text
DOC/AGENTS.md
e5d9cc7b5120aad39da592f796eef44cc8a1c71bc6c43b311f48362d60fdd038

DOC/FT1536_PODSUMOWANIE_L_RHO_2026-09-18.md
a1fed7c8e428b4102447822b97c3717775e39c82a9da20291a72a50380857da5

P/REPORT.md
ca0e3fb23542656b16c61495506db5956b3d6043d5ef26fd56396502c0b444e3

P/OUTPUTS.sha256
d5cabfdaf69f080bf31b9e1903bacc4a319f87cd38cb4b643ff5e98f1240f687

P/CANDIDATE.sha256
2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a

P/candidate.patch
cb7833fce99eb68e671928b71ea28536acfc5f440babfc7b035196050a2c6060

SRC/falcon-vrfy.c
3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42

P/formal/Rho.lean
daa68021e0f5bac53cf0384a5e10b0537eb6a8ca9d02f0f2970c6ff6eefc7fe8
```

Zweryfikuj piny, a następnie skopiuj 17 plików SRC do `W/source/`, sprawdzając
każdy względem CANDIDATE.sha256 (ścieżki manifestu są względem SRC).
Kopia source/ pozostaje bajtowo niezmieniona. To kandydat po L_RHO, a nie
`P/reference/`, historyczny S17 ani wycofany checkout warning-clean.
Potrzebne dodatkowe wejścia wiąż z przypiętym OUTPUTS i własnym INPUTS.
Nie ponawiaj całego audytu 610 artefaktów jako osobnego zadania.

## 2. Dokładna teza L_NTT

```text
ternary = 1, logn = 10, N = 1536, q = 18433
Phi = X^1536 - X^768 + 1
R_q = (Z/qZ)[X]/(Phi)
canonical_q = współczynnikowy reprezentant w [0,q-1]
R_M = 65536                 — radix Montgomery
Rt = 10237                 — R_M mod q
R2t = 4564                 — R_M^2 mod q
Q0It = 18431                — parametr redukcji Montgomery
```

Tablica a długości N reprezentuje `sum_i a[i]*X^i`. Indeksy zaczynają się od 0.
Model wykonania: GCC 14.2.0 / C99 / Linux x86_64 LP64; bajt 8-bitowy,
int/unsigned/int32_t/uint32_t 32-bitowe, int16_t/uint16_t 16-bitowe,
long/size_t 64-bitowe. Bufory są poprawnie zaalokowane, wyrównane, dostatecznie
długie i rozłączne tam, gdzie wymaga tego kontrakt, w tym `restrict`.

Dla **każdych** `h,r,c in [0,q-1]^N` zdefiniuj wykonanie na osobnych kopiach
wejść, używając dokładnie funkcji z badanego falcon-vrfy.c:

```text
H := kopia h
mq_NTT(H, 10, 1)
mq_poly_tomonty(H, 10, 1)

a := kopia r
mq_NTT(a, 10, 1)
mq_poly_montymul_ntt(a, H, 10, 1)
mq_iNTT(a, 10, 1)
p := matematyczny snapshot a
mq_poly_sub(a, c, 10, 1)
d := matematyczny snapshot a
```

**Wymagany wniosek:** wykonanie kończy się i jest zdefiniowane w modelu;
wszystkie odczyty i zapisy są legalne, a zakresy są wystarczające dla
rzeczywiście wywoływanych prymitywów. H, p i d oraz zapisane współczynniki
poszczególnych etapów są canonical residues, z jawnym znaczeniem ich
reprezentacji. Zachodzą dokładne równości współczynników:

```text
p = canonical_q(h*r mod Phi)
d = canonical_q(h*r-c mod Phi).
```

Pomocnicze słowa pośrednie nie muszą być w `[0,q-1]`; mają mieć wyprowadzone
właściwe zakresy i semantykę. Nie narzucaj fałszywego zakazu zdefiniowanego
unsigned wrap. Rozlicz go tam, gdzie kod rzeczywiście go używa.

L_RHO daje następnie podstawienie `r[i]=rho_Z(s[i])` dla każdego signed
int16 s. Wyprowadź z L_NTT kongruencję `d=h*s-c` i canonical range d.
Ten etap kończy się **przed** źródłowym centrowaniem do int16 i normą.

Teza jest silniejsza od ograniczenia h do successful KeyGen support.
Nie wymaga nowego KeyGen. Kontrprzykład dla syntetycznego canonical h
obala tę tezę arytmetyczną; jego znaczenia dla dziedziny kluczy pełnego L_V
nie należy automatycznie rozszerzać.

## 3. Rzeczywista ścieżka do objęcia dowodem

Kotwice w przypiętym `SRC/falcon-vrfy.c`:

| Zakres | Obowiązek |
|---|---|
| 59–68 | Qt, Q0It, Rt, R2t, rozmiary tablic |
| 582–670 | mq_add, mq_sub, mq_rshift1, mq_montymul, mq_montysqr — według rzeczywistych zależności |
| 743–803 | mq_div_18433 i łańcuch potęgowania |
| 805–885 | rev10 i mq_mkgm3 |
| 980–1062 | mq_NTT_ternary |
| 1068–1159 | mq_iNTT_ternary i końcowe skalowanie |
| 1162–1243 | dispatchery oraz tomonty, iloczyn punktowy i odejmowanie |
| 1346–1347 | matematyczne przygotowanie h po dekodowaniu klucza |
| 1377–1384, 1406–1424 | konsumowany L_RHO i rzeczywista kompozycja raw Verify |

**Kluczowy fakt:** `logn=10` wybiera `mq_mkgm3`, ponieważ warunek użycia
statycznych GMt/iGMt to `logn<=9`. Nie zastępuj dynamicznego generatora
tablicami przeznaczonymi dla innej gałęzi.

Generator zaczyna od 25 wprowadzanego do Montgomery, korzysta z
`TERNARY_LOGN_MAX=11`, odwracania przez `mq_div_18433`, permutacji rev10
i dopełniania niższych poziomów. Inverse NTT oblicza czynnik przez
`mq_div_18433(Rt,n)`, zamiast używać starego INVNQt[logn].
Dowód ma obejmować oba te wywołania generowania tablic i wszystkie użyte
dzielniki. Rozlicz tylko elementy rzeczywiście zainicjalizowane i odczytywane;
nie eksportuj ani nie haszuj niezainicjalizowanej reszty buforów gm/igm.

Komentarze źródła są wskazówkami, nie przesłankami dowodu. W szczególności
wyprowadź rzeczywiste granice z, w, `z*q0i`, `z+w`, korekt i przesunięć
w mq_montymul. Mnożenie uint32 przed maską może zawijać się zgodnie z C;
trzeba wykazać poprawność wybranych niskich bitów, a nie zastąpić po cichu
całej funkcji arytmetyką nieograniczonych liczb całkowitych.

## 4. Obowiązki dowodowe i kolejność

Zapisz macierz obowiązków i realizuj ją w tej kolejności:

1. **Arytmetyka słów.** Dla canonical operands udowodnij zakres, kongruencję
   i zdefiniowanie mq_add/sub/montymul oraz użytych helperów. Zweryfikuj
   stałe, w tym `q*Q0It == -1 mod 65536`. Rozróżnij R_M od Rt i zwykłe
   współczynniki od ich reprezentacji Montgomery.
2. **Dzielenie modularne.** Rozlicz rzeczywisty łańcuch mq_div_18433,
   reprezentacje wejść/wyjść i niezerowość mianowników użytych w tej ścieżce.
   Jeśli korzystasz z pierwszości q lub rzędu elementu 25, dostarcz dowód
   lub kompletny sprawdzalny certyfikat, a nie sam komentarz lub test losowy.
3. **Generator dla logn=10.** Wyprowadź wartości, reprezentacje i kolejność
   potrzebnych gm/igm, własności pierwiastków, kompletność inicjalizacji,
   poprawność rev10 i zakresy indeksów. Nie jest wymagane twierdzenie dla
   wszystkich innych logn. Dopuszczalny jest certyfikat całego ustalonego
   przebiegu generatora, z rozliczoną zgodnością z C.
4. **Forward/inverse.** Ustal dokładną specyfikację kolejności węzłów
   i transformacji dla Phi. Dowiedź etapów stopnia 2 i 3, inwariantów
   buforów, skalowania odwrotnego, zakończenia i legalności indeksów.
   Jednocześnie propaguj canonical range przez wszystkie zapisy.
5. **Iloczyn i kompozycja.** Udowodnij, że przygotowanie h, mnożenie punktowe
   i inverse dają iloczyn modulo Phi,q, z właściwymi czynnikami Montgomery.
   Zakończ dowodem odejmowania c, dokładnej tezy L_NTT oraz podstawienia z L_RHO.

Dowód samego `iNTT(NTT(a))=a` nie wystarcza do poprawności iloczynu w tym
konkretnym pierścieniu. Wzajemnie odwrotne, błędnie zinterpretowane
transformacje mogą spełniać tę równość.

Możesz użyć dowodu etapowego lub dokładnego certyfikatu liniowo-algebraicznego.
W drugim przypadku najpierw uzasadnij liniowość/biliniowość rzeczywistych
funkcji słowowych po przeniesieniu do pola, dzięki udowodnionym zakresom
i kontraktom prymitywów. Dopiero wtedy wyjaśnij, dlaczego wybrany skończony
zbiór tożsamości dowodzi tezy dla wszystkich h,r,c. Nie przedstawiaj samych
testów wektorów bazowych jako uniwersalnego dowodu.

## 5. Lean, certyfikaty i source binding

Wykorzystaj dostępny Lean 4.34.0/Std. Nie zakładaj dostępności mathlib
i nie instaluj zależności. Możliwe są własne definicje dokładnej arytmetyki
modularnej, modeli etapów i małe sprawdzane przez kernel checkery certyfikatów.

- Formalne tezy mają jawnie pokazywać kwantyfikatory, reprezentacje,
  dziedziny i dokładny model badanej funkcji.
- Pokaż imports i `#print axioms` dla końcowej tezy i kluczowych lematów;
  bez `sorry`, `admit`, `native_decide` lub lokalnego aksjomatu pożądanego wyniku.
- Certyfikat wygenerowany przez Sage musi być rzeczywiście sprawdzony przez
  dowiedziony checker lub odpowiednie tezy. Wczytanie liczby jako hypothesis
  nie zamyka jej prawdziwości ani związku z kodem.
- Przypnij źródła, stałe, tablice wygenerowane, modele i świadectwa. Wykaż
  zgodność użytych wycinków z całym przypiętym plikiem, bez ukrytej podmiany
  NTT na model referencyjny.
- Jawnie rozdziel kernel proof modelu, translację C → model, semantykę
  buforów oraz wykonania skompilowanej implementacji. Nie deklaruj formalizacji
  GCC lub całego C, jeśli jej rzeczywiście nie wykonano.

Założenia w rodzaju „NTT jest poprawne”, „tablice są właściwe”, „nie ma
przepełnień” albo „wszystkie współczynniki zostają canonical” są tutaj
obowiązkami. Jeśli pozostają przesłankami końcowej implikacji, wynik jest
częściowy, nawet gdy Lean poprawnie sprawdzi tę warunkową implikację.

## 6. Niezależne kontrole implementacji

Przygotuj w W własny harness wywołujący dokładnie funkcje z `source/`.
Testy i jawne kopie obserwacyjne nie mogą zmienić badanej implementacji;
po usunięciu instrumentacji kopia musi wracać bajtowo do pinu.

Niezależny checker Sage ma używać dokładnych ZZ/GF(q) i arytmetyki
wielomianów modulo Phi, bez badanego NTT jako oracle. Kontrole powinny objąć:

- stałe i rzeczywiste użyte tablice generatora wraz z interpretacją Montgomery;
- brzegi domen prymitywów i sytuacje powodujące źródłowe korekty/maski;
- wektory zero, jednostkowe, wysokie monomiany zawijające się przez Phi,
  wartości q-1 oraz deterministyczne przypadki gęste;
- forward/inverse oraz **iloczyn i odejmowanie**, z pełnym porównaniem
  współczynników, przygotowania h i zakresów etapów;
- publiczne dane istniejącego świadka L_RHO z `r=rho(s)`, jako jedną
  regresję integracji, bez ponownego szukania świadka lub preimage HashToPoint.

Teza obejmuje wszystkie canonical h, więc do kontroli arytmetycznych wolno
używać syntetycznych publicznych wektorów h. Nie przypisuj im przez to
przynależności do successful KeyGen support. Nie generuj nowych kluczy.

Sprawdź build normalny i ASan/UBSan z flagami z badanego Makefile oraz C99;
potwierdź model maszynowy w harnessie. Zakres sanitizera opisz zgodnie z
faktycznym wykonaniem. W L_RHO LSan działał, więc nie wyłączaj go automatycznie
na podstawie wcześniejszej sesji Blue.

Dodaj mały zestaw rzeczywistych mutacji w osobnych kopiach testowych,
np. zły czynnik Montgomery, pominięte tomonty(h), inny etap/permutacja
generatora, pominięte inverse scaling lub błędna Phi. Każda liczona mutacja
ma zmieniać wynik i zostać wykryta przez ten sam niezależny walidator;
baseline i no-op muszą przejść. Wybierz mutacje pokrywające różne obowiązki.

Nie próbuj enumerować wszystkich wektorów długości 1536. Przed cięższym
certyfikatem oszacuj czas i pamięć; użyj struktury dowodu i podziału na
sprawdzalne etapy. Kontrole empiryczne wzmacniają binding, ale nie zastępują
uniwersalnego argumentu.

## 7. Wykonanie i granice

Potwierdź sandbox ograniczający zapis do W; source/ po skopiowaniu traktuj
jako tylko do odczytu. Cache, HOME, TMPDIR, DOT_SAGE i XDG_CACHE_HOME kieruj
pod W. Nie uruchamiaj starych runnerów w ich ukończonych katalogach.

```text
Sage: /home/footfalcon/.local/bin/sage
Lean: /home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean
GCC:  /usr/bin/gcc
```

Potwierdź wersje: Sage 10.9, jego Python 3.14.7, Lean 4.34.0, GCC 14.2.0
były użyte w L_RHO. Uruchamiaj `sage plik.py ...`, nie nieobsługiwane przez
ten frontend `sage -python`. Zapisuj osobno wersję Sage i Pythona.

Zapisuj komendy, cwd, stdout/stderr, kody wyjścia, hashe, czas i limity.
Używaj skończonych budżetów dla poszczególnych obliczeń; po przerwaniu
zachowaj checkpoint i jawny status. Nie pozostawiaj poprzednich procesów
obliczeniowych działających podczas nowej próby. Jedna sesja, bez innych agentów.

Ta praca nie obejmuje całego parsera bajtowego, domeny successful KeyGen,
źródłowego centrowania i normy ani EUF-CMA. Obejmuje matematyczne przygotowanie
h przez NTT/tomonty po podaniu canonical współczynników, nie cały dowód
zgodności loadera publicznych bajtów. Q, B, Phi, N i profil pozostają ustalone.

## 8. Artefakty, werdykt i warunek zakończenia

Zapisz co najmniej:

- `REPORT.md`, `RESULT.json`;
- `CLAIM.md` z dokładną tezą i `OBLIGATIONS.json` z macierzą domknięcia;
- hash-sprawdzone `source/`, publiczne `inputs/`, własne `scripts/` i `formal/`;
- binding źródło/model/tabele oraz pełne certyfikaty i wyniki kontroli;
- `INPUTS.sha256`, `TOOLCHAIN.txt`, `COMMANDS.log` i logi;
- `REPLAY.md`, `OUTPUT_SCOPE.md`, `OUTPUTS.sha256`.

Każdy obowiązek w macierzy ma podawać: dokładną tezę, zakres źródła i hash,
przesłanki, dowód lub certyfikat, komendę sprawdzenia, status i ewentualną lukę.

Statusy:

- `L_NTT_PROVED_FOR_PINNED_MODEL` — kompletna teza z §2 i wszystkie jej
  zależności domknięte; jawna translacja źródła i wykonane wymagane kontrole;
- `COUNTEREXAMPLE_CANONICAL_DOMAIN` — pełny, odtwarzalny przypadek w dokładnej
  dziedzinie tezy, ze wskazaniem pierwszej rozbieżności lub naruszonego zakresu;
- `PARTIAL_PROOF` — użyteczny wynik z wymienionymi niedomkniętymi obowiązkami;
- `EXECUTION_BLOCKED` — blokada wykonania, bez fikcyjnego wyniku matematycznego.

W RESULT zachowaj `source_integrated=false`, `owner_accepted=false`,
`full_L_V_proved=false`, identyfikację konsumowanego L_RHO i hash badanego
kandydata. Wyniku negatywnego nie naprawiaj zmianą źródła w tym samym zleceniu.

Manifest ma obejmować raport, tezy, macierz, źródła, checkery, certyfikaty,
wejścia i receipts. Zamroź opisany prefiks dziennika; wyłącz jawnie cache/tmp.
Replay ma działać w świeżym katalogu bez nadpisania pakietu i zweryfikować
przypięte pliki znaczeniowe. Nie regeneruj manifestów poprzednich zadań.

Zakończ polskim podsumowaniem: rozstrzygnięcie, rzeczywisty zakres dowodu,
pozostałe obowiązki, jedna następna rekomendacja, pełna ścieżka REPORT.md
oraz SHA-256 raportu i OUTPUTS.sha256. Nie zaczynaj automatycznie kolejnego
zadania ani integracji kodu.
