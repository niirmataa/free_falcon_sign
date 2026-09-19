# FT1536 — mapa dalszych działań po domknięciu L_V

Data: 2026-09-19. Autor projektu: Niirmata.
**Status: mapa do omówienia przed wyborem następnego zadania Astry.**
Oznaczenia M0–M7 i P1–P2 poniżej są etykietami tej mapy, nie aktywacją
historycznych rejestrów ani nowymi zleceniami wykonawczymi.

## 1. Punkt wyjścia

Opublikowany punkt kontrolny: `17f8f8b3f942c2afef98ab09399a4f2ccf01f63a`.
Push objął pełne L_NTT, zlecenie L_V i ukończone L_V. Archiwum zawiera
siedem zweryfikowanych checkpointów; dwa najnowsze mają świeże replaye
217/217 i 402/402 zgodnych plików znaczeniowych.

### Wyniki zachowane w ich dokładnych zakresach

| Wynik | Zakres i fakt |
|---|---|
| L_RHO | Wszystkie signed int16 są poprawnie normalizowane modulo 18433 w kandydacie. |
| L_NTT | Pełne forward/product/inverse/subtract, zakresy i podstawienie rho. |
| L_V | Dla wszystkich canonical h,c i legalnych b, akceptacja kandydata daje zdefiniowany Ext0, kongruencję i Q<B; NONE oraz STATIC, bez capu 2049. |
| T2C3 | Jedna kanoniczna instancja h*: idealny obraz po ostrym obcięciu, E_h*^Q < 4489/[2^54(2^24-1)^2] < 2^-89. |
| T5 | Każdy skutecznie wyemitowany klucz S17: pure/untruncated graph-dual theta <2^-40; delta_key=0 dla tego twierdzenia. |

Parametry pozostają N=1536, q=18433, Phi=X^1536-X^768+1, sigma=768,
B=2093922385, metryka offset-768 A2 i uczciwe COMP_STATIC.
Progi około 2.13 miliarda z dawnych przeglądów dotyczyły innych kandydatów.

L_V dotyczy verifiera `3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`
z manifestem 17 plików `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`.
Oryginalny S17 ma odrębny, zachowany kontrprzykład. `full_L_V_proved=true`
jest przypisane do kandydata; `source_integrated=false`, `owner_accepted=false`.
Pozostałe 16 plików kandydata, w tym Sign, KeyGen i FPEMU, są zgodne z S17;
przeniesienie konkretnego starego certyfikatu nadal wymaga związania jego
rzeczywistych przesłanek i profilu, nie samej zamiany pinu całego pakietu.

## 2. Jawna mapa historycznych T2C3 i T5

Pełne nazwy pakietów, manifesty i typy zależności są w publicznych kopiach:

- [audyt ciągłości instancji, uporządkowanej bazy i etapów T2C3](FT1536_AUDYT_CIAGLOSCI_KLUCZA_BAZY_T2C3_2026-09-17.md);
- [późniejsza weryfikacja argumentu D11E2](FT1536_WERYFIKACJA_UZASADNIENIA_D11E2_2026-09-17.md);
- [mapa twierdzeń T2C3/T5 i pakietu publikacyjnego](FT1536_PAPER_TEZA_MAPA_DOWODOW_2026-09-17.md).

Są to dokumenty historyczne z zachowanymi datami i pinami. Późniejsza
weryfikacja D11E2 rozlicza wskazane wcześniej pytanie o most analityczny;
stare zdania o otwartym L_V odnoszą się do oryginalnego S17, a aktualny
wynik dla kandydata jest w nowym checkpointcie L_V_BRIDGE.

### T2C3: rzeczywiste zależności, nie sama kolejność katalogów

```text
K0: publiczne h*/PK, commitment uporządkowanej bazy, źródła S17
  -> foundation: graf, Frobenius, metryka, znaki
  -> definicja reduktora -> konkretna redukcja companion
  -> cumulative coherence -> D2 przy tilt beta

A/B/C1/C2/C3 + D1: interfejsy Gaussa, Poissona, mapy i konturu
D5 + kanoniczny D7 -> D8 -> D9/D10 -> E_h*^0 < 2^-90
D3 + A/B/C3 + D7/D9 + D11D1 -> globalny D11E2
  -> mean energy < 2^-79 -> T_h* < 2^-99

E_h*^0 + T_h* + p_T < 2^-24 + dokładne Route C
  -> final composition -> E_h*^Q < 2^-89
  -> niezależny odbiór / integracja b478ba3 -> research freeze d641ab1
```

Szczegółowy ledger obejmuje także D4, D6, D11A/B/D2/D3/D4/E1 i ich
rzeczywiste role. Starszy frontier J z D4 i selected-major z D11E1 nie są
automatycznie otwartymi przesłankami końcowej drogi D11E2. D11E1 V2 poprawia
osobny raw-count interface; nie jest nową wersją D11E2. Kanoniczny wynik
używa K0 i endpointów 113/9923, nie starego 9860.

### T5: oddzielny kwantyfikator

```text
S17 KeyGen + obowiązkowy leaf gate
  -> numerical soundness FPEMU/FFT + publiczny twiddle audit
  -> exact leaves + baza kraty grafowej
  -> integralny tower, block LDL, reciprocal reversal
  -> shifted-theta induction, 1536 czynników A2
  -> rho(L_h)-1 < 2^-40 dla każdego successful output
  -> poprawiona wersja a2 -> odrębna akceptacja / freeze d641ab1
```

T5 nie zamienia fixed-key T2C3 w populacyjne twierdzenie po ostrym obcięciu.
Pełny samodzielny eksport publicznych certyfikatów i runnerów obu dawnych
ścieżek jest pracą P1; publikowane tu audyty stanowią już czytelną mapę.

## 3. Mapa zależności dalszego dowodu

```text
M0: dokładny profil, prawo klucza, gra, nonce, bajty i budżety
 |
 +-- candidate Verify -> RHO -> NTT -> L_V [DOMKNIĘTE] -> ekstrakcja MT-ISIS
 |
 +-- source Sign -> M1 H3 range -> M2 scalar i pełne prawo wektora
 |                                  -> M3 pre-cast/bajty/retry/abort
 |
 +-- KeyGen/T5 -> M4 nowy spójny pakiet istniejącego R5T -> image bound e
 |
 +-- idealne gry + wspólne jądra -> M5 transfer chi-square / Phi_Delta
 |
 +-- framing + publiczny sampler + M5 -> M6 symulacja klasycznego ROM
 |
 +-- M3, M4, M6, L_V, losowość, założenie MT-ISIS, koszty
                                      -> M7 konkretna warunkowa kompozycja
```

M4 i ogólny lemat M5 są logicznie niezależne od dowodu H3. Można je
przygotowywać obok gałęzi samplera, z odrębnymi wejściami i wykonawcami.
Ta mapa nie uruchamia takich prac ani subagentów.

## 4. Pakiety pracy i kryteria zakończenia

### M0 — jeden dokładny obiekt końcowego twierdzenia

Wskazać źródła kandydata, model GCC/C99/LP64, populację kluczy, interfejs
oracle i parametry zasobów (t,w,L,Q_s,Q_H oraz docelowe lambda).

- Zachować prawo rzeczywistego capped KeyGen z seedem, warunkowane sukcesem;
  nie utożsamiać go z idealnym iid-ternary proposal ani pojedynczym h*.
- Jeden klucz jest wspólny dla całego transkryptu. Ewentualny koszt
  warunkowania KeyGen dotyczy tego losowania, nie każdego zapytania Sign.
- Kontrakt protokołu ma naprawdę wiązać parę (r,m): docelowy r[40] i jego
  egzekwowanie w opakowaniu. Nieograniczony rlen przy hashowaniu r||m ma
  znany problem przesuwania granicy nonce/wiadomość.
- Uczciwy Sign: STATIC, 16 prób, jawne fault/retry/encoding/loader outcomes.
  Domena przeciwnika pozostaje pełnym językiem Verify dowiedzionym w L_V.
- Rozstrzygnąć dokładną pojemność oracle. Cel z 17 IX przyjął 2049 bajtów,
  a historyczne twierdzenie H6P zakłada bufor co najmniej 3073; jego wniosku
  nie wolno bezpośrednio przenieść. Błąd pojemności może pozostać wspólnym,
  obserwowalnym wynikiem, zamiast być bezpodstawnie usuwany.
  Liczba 3073 z tego kontraktu nie jest tutaj certyfikowana jako maksymalna
  długość STATIC; długość zmienna i zachowanie kodera wymagają własnego związania.

**Koniec:** jednoznaczna definicja gry i ledger par porównywanych praw.
Już tutaj wyznaczyć wymagane budżety błędów, aby nie budować końcowej
deklaracji na nierówności, która po podstawieniu zasobów daje tylko 1.

### M1 — osiągalność centrum H3: rekomendowany następny wąski dowód źródłowy

Dla par (sk,pk) faktycznie wyemitowanych przez KeyGen i wszystkich właściwych
osiągalnych historii Sign wykazać zakres przed floor/conversion i s+z:

```text
-2147483283 <= floor(mu) <= 2147483281
proposal z in [-365,366].
```

Trzeba rozliczyć rzeczywiste FFT/LDL, wewnętrzne multipliers, residua i błędy
FPEMU. Same finite(mu), końcowe liście H4/T5 lub kampania kluczy nie dowodzą
tego zakresu. Klucze wyemitowane przez KeyGen mają |F_i|,|G_i|<=2047;
szerszy zbiór akceptowany przez loader nie ma tej samej własności.

Istnieją dokładne tożsamości NTRU/Schur i obiecująca droga przez końcową
redukcję Babai, lecz wymagają związania z faktycznym obliczeniem maszynowym.
Nie ponawiać nieudanego niezależnego majorowania, które gubi korelacje.

**Koniec:** dowód osiągalności albo dokładny wynik negatywny/luka.
Wynik wymagający nowego guardu prowadzi do osobnego kandydata poprawki
z rozliczonym wpływem na aborty i rozkład; prototyp H3G nie jest przesłanką
obecnych źródeł. Przypadek rounded rhat=1 jest już uwzględniony w H3.

### M2 — od kernełów skalarnych do pełnego prawa próby

Podzielić na dwa rzeczywiste zadania:

1. Z M1 i H4 związać conditional H3 arithmetic/likelihood oraz istniejący
   H1R dla finite-exact -> infinite-exact. Zachować dyadyczną wartość
   computed dss i właściwą obsługę brakujących/zerowych atomów.
2. Związać pełny FFT/LDL/ffSampling/residual/iFFT/rounding z joint law pary
   przed int16 castami. Computed dss nie jest automatycznie parametrem
   idealnej geometrii przy sigma=768.

**Koniec:** jawny source-to-ideal interface dla całej próby, z kwantyfikatorami
po kluczu, historii i retry prefix oraz udowodnionym kosztem porównania.
3072 scalar calls to liczba wyjść w jednej pełnej próbie, a nie liczba
wewnętrznych rejection draws. Dawny R3G pozostaje użyteczną kompozycją
warunkową, nie automatycznym dowodem prawa źródłowych bajtów.

### M3 — pre-cast, kodowanie, stopping i poprawność uczciwego podpisu

Połączyć M2 z rzeczywistymi rzutowaniami, normą, STATIC, pojemnością,
16 próbami i pełnym obserwowalnym wynikiem. L_V pomaga po stronie odbiorcy,
ale nie dowodzi, że każdy dodatni wynik Sign jest akceptowany ani że Sign
ma właściwy rozkład.

H6P zawiera no-go: same scalar summaries i marginalny bound Z2 nie wyznaczają
joint pre-cast coupling eta_pre. Potrzebny jest prawdziwy most do (W1,W2),
nie przemianowanie starej stałej. Nie relabelować niepoprawnych emitowanych
bajtów jako bot. Sprawdzić, czy dawne centered-box ograniczenia są konieczne
w nowym interfejsie; pełny L_V obejmuje szersze signed s2, ale nie znosi
automatycznie wszystkich obowiązków po stronie Sign.

**Koniec:** porównanie kompletnych odpowiedzi oracle, również abortów,
z jednym kosztem każdego zdarzenia i właściwym miejscem w dalszej nierówności.

### M4 — istniejący R5T jako poprawnie konsumowany image theorem

Warunkowy argument już istnieje: pointwise po successful-key support,
mean energy <2^-118, rejected-image T_h<2^-138, accepted-image E<2^-106.
Nie potrzeba ponownie odkrywać sharp-tail metody.

Potrzeba nowego, spójnego pakietu: dokładne uniwersalne interfejsy i ich
kwantyfikatory, weryfikacja konsumpcji endpointów, rzeczywiste mutacje,
freeze i replay z zewnętrznym pinem. Zachować stare pakiety, w tym wadliwy
freeze, jako historię. Nie naprawiać ich manifestów w miejscu.

Kanoniczne liczbowe endpointy D7/D9/D11E2 dla h* nie zastępują nowych
boundów populacyjnych. Konsumowane mogą być właściwe uniwersalne interfejsy.

**Koniec:** odtwarzalny wynik z dokładną definicją prawa obrazu (obcięcie Q,
ewentualny box, normalizacja), kwantyfikatorem po h i zamkniętą listą
rzeczywistych przesłanek. Dopiero taki interfejs dostarcza e do M5/M6.

### M5 — transfer bez przedwczesnego przejścia do TV

Utrwalić i sprawdzić ogólny lemat z §5 oraz jego instancjację dla dokładnych
gier. Dla fresh uniform c i wspólnego jądra K_h,c, z tym samym postprocessingiem:

```text
R_i(c,z)=U(c) K_h,c(z)
S_i(c,z)=P_h^B(c) K_h,c(z)
chi2(S_i || R_i)=E_h^B.
```

Weryfikacji wymaga wspólność pełnych odpowiedzi po każdej historii, także
serializacji/bot oraz obsługi pustego supportu. Warunkowanie na brak kolizji,
udany podpis lub świeży punkt może zmienić jądro; trzeba to rozliczyć.
Ogólny lemat może powstać przed M1–M4, ale jego zastosowanie do realnego
schematu potrzebuje odpowiednich połączeń tych gałęzi.

**Koniec:** poprawnie skierowany bound zdarzenia sukcesu wraz z jawnymi
przesłankami, bez automatycznego utożsamienia R z całym realnym Sign.

### M6 — symulator ROM, publiczny sampler i właściwa relacja trudności

- Zbudować/rozliczyć publiczny sampler idealnej referencji D^B: błąd,
  czas, pamięć i ewentualny abort po ograniczeniu pracy.
- Dowieść klasycznego lazy sampling/programming dla opakowania z M0:
  nonce collisions, prequeries i najwyżej Q_H+1 uniform celów.
- Użyć L_V do ekstrakcji z każdego akceptowanego b. Naturalna relacja
  MT-ISIS nie narzuca starego centered z2 i używa właściwego K_seed.
- Oddzielnie związać rzeczywiste SHAKE/ChaCha z modelami losowości;
  direct-output ROM i bitowy XOF/H2P wymagają własnego połączenia.
- Nie naliczać drugi raz target guessing, jeżeli używana gra MT już
  udostępnia całą indeksowaną listę celów.

**Koniec:** kompletny symulator i redukcja z policzonymi zasobami, przy
jawnych założeniach prymitywów i MT-ISIS. Estymator jest diagnostyką
trudności, nie dowodem tej hipotezy.

### M7 — złożenie, konkretne budżety i zakres publikacji

Złożyć udowodnione interfejsy. Dla każdego hopu podać: parę praw, kierunek,
metrykę, zakres kluczy/historii, zależność od Q_s/Q_H, aborty, zasoby i
przypięte twierdzenie. Koszty muszą trafić po właściwej stronie mnożników
i nieliniowej Phi_Delta; nie dodawać mechanicznie wszystkich historycznych
epsilon. Wybrać na podstawie dowodu ostrzejszą dopuszczalną trasę.

**Koniec:** warunkowy klasyczny wynik EUF-CMA oraz nietrywialny bound dla
uzgodnionego profilu zasobów. QROM jest późniejszym, osobnym zadaniem z
właściwym quantum reprogramming i interfejsem stanów; nie wynika z samego
klasycznego transkryptu lub kwantowej kolumny estymatora kratowego.

## 5. Sprawdzony rachunek chi-square i granice jego użycia

Dla wspólnego prawa początkowego i warunkowych jąder S_i << R_i, z
chi2(S_i(.|tau)||R_i(.|tau))<=e po wszystkich wymaganych historiach:

```text
L_i=dS_(<=i)/dR_(<=i)
E_R[L_i^2 | history] <= (1+e) L_(i-1)^2
chi2(S||R) <= Delta=(1+e)^n-1.
```

Dla p=R(win), r=S(win), Cauchy–Schwarz z centrowanym wskaźnikiem daje
(p-r)^2<=Delta*p*(1-p), a zatem

```text
p <= Phi_Delta(r)
  = [2r+Delta+sqrt(Delta^2+4*Delta*r*(1-r))]/[2*(1+Delta)]
  <= min(1,(sqrt(r)+sqrt(Delta))^2).
```

To rachunek matematyczny przedstawiony i sprawdzony w rozmowie, jeszcze
nie nowy źródłowo zinstancjowany checkpoint FT1536. Dla warunkowego
e=2^-106, n=2^20, r<=2^-128 daje około 2^-86 zamiast liniowego składnika
TV 2^-34. Różnica około 52 bitów opisuje jedno przejście, nie cały schemat.

W tym kierunku D2(S||R) zwykły Hölder daje **r<=sqrt(1+Delta)*sqrt(p)**,
a nie odwrotną nierówność na p. Historyczny mały logarytm mnożnika D2
nie wystarcza więc jako opis całej potrzebnej straty redukcji.
Dla r=0 granica p<=Delta/(1+Delta) jest osiągalna przez ogólne prawa
Bernoulliego. Aby z samego tego interfejsu certyfikować poziom lambda,
Delta musi mieć odpowiednio mały budżet; orientacyjnie e musi być rzędu
2^(-lambda)/n lub mniejsze, z zapasem na r i inne hopy. To wymaganie
konkretnej techniki dowodowej, nie wykazany atak ani bariera konstrukcji.

Nie przenosić tego lematu bez nowego dowodu na H1R: tam inne prawa,
brakujące atomy i orientacja metryki są częścią istniejącego argumentu.

## 6. Co potwierdzono przy przygotowaniu tej mapy

Przejrzano istniejące raporty i kontrakty; nie wykonywano ich dawnych runnerów.
Ponownie sprawdzono wskazane hashe. R5T nadal ma stare OUTPUTS o SHA-256
`279dce6690f9f2d9edbe2f2f625f44d8b783fc4311131ea5e41bca4fbad6d74d`,
którego wpisy dla czterech odczytanych plików nie odpowiadają bieżącym bajtom.
To konkretna potrzeba nowego freeze, nie samodzielne obalenie analizy.

Poniższe ścieżki są względem historycznego H/paper/tasks, gdzie
H=`/media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon`.

| Publiczne wejście odczytowe | Bieżący SHA-256 |
|---|---|
| S20-H3-REACHABLE-EXPONENT-BRIDGE-001-20260827-a1/CENTER_BOUND_AUDIT.md | `75ccf272d0574ccc39c9f16e811411e302784ead465896e67ae39e13b1055675` |
| S20-H6P-PRECAST-BAD-EVENT-001-20260827-a1/h6p_theorem.tex | `2f86cc9b3b11ba96ae87057d4d5a6f5e67ec670fab1600ed37e92aa36802f2ae` |
| S20-H1R-RARE-ATOM-HYBRID-001-20260827-a1/report.md | `7361b716d50b70a83b64d4dddc49c6ec164c1f68fbc0a41d5748162d869f307a` |
| S20-R3G-GLOBAL-TRANSCRIPT-COUPLING-001-20260827-a1/report.md | `cf319d893480046dab8f4390291c6a5a8ef63cb231c01e337e18c0ca41ad74ee` |
| S20-R5T-SUCCESSFUL-KEY-SHARP-TAIL-001-20260827-a1/REVIEW_RESPONSE.md | `f476e2afa9a869a48c270681e114df9b989e8fcda0e32baf71d2a898affe5d24` |
| S20-R5T-SUCCESSFUL-KEY-SHARP-TAIL-001-20260827-a1/r5t_theorem.tex | `c91233eaaf0473fb2be635441192da765bb936aaf8223249b7af98fd9d0cab24` |
| S20-R5T-SUCCESSFUL-KEY-SHARP-TAIL-001-20260827-a1/artifacts/r5t_uniform_tail.json | `0c987fbd11bd534a6e23262b00e62881b71862771cd89616cbbd80d55a61592e` |
| S20-R5T-SUCCESSFUL-KEY-SHARP-TAIL-001-20260827-a1/scripts/check_r5t_independent.py | `3278835c1b51e642b12d13201176f62fde176cb1293e2ae569f9e66ed19c5360` |
| S20-R5T-SUCCESSFUL-KEY-SHARP-TAIL-001-20260827-a1/INPUTS.sha256 | `48e0e5be85a1bc11c0a357e301efaab73c6bf4ab2560a195cb1689776087c1c5` |

Szczegółowy wcześniejszy cel i mapa interfejsów są w
[opracowaniu z 17 IX](FT1536_CEL_DOWODU_I_PIERWSZY_LEMAT_2026-09-17.md).
Nowe L_V aktualizuje jego dawny otwarty wiersz dla kandydata, a §5 niniejszej
mapy rozróżnia jego konserwatywną trasę TV od dalszej analizy chi-square.

## 7. Kolejność robocza i prace repozytoryjne

**Rekomendacja do omówienia:** najpierw M0 (profil i budżety), następnie
M1/H3 jako wąski następny dowód źródłowy Astry. M4/R5T i ogólny M5 można
prowadzić niezależnie; M2 i M3 wymagają rozliczenia źródłowych przesłanek,
a M6/M7 są miejscem rzeczywistego połączenia gałęzi.

Po M1 nie zlecać od razu „całego bezpieczeństwa”. Każdy kolejny pakiet ma
wyeksportować konkretny interfejs potrzebny następnemu, z kryterium sukcesu
opisanym powyżej. Gdy wynik wykaże potrzebę zmiany kodu lub prawa, aktualizuje
się tę zależność i wersję źródeł, zamiast przemycać poprawkę w stare piny.

Równolegle prowadzący sesję ma prace publikacyjne:

- **P1:** pełny publiczny podgraf T2C3/T5: twierdzenia, certyfikaty,
  konsumowane wejścia, review records i odtwarzalność. Audyty/mapa są już
  czytelne; prywatny producent danych K0 ma pozostać jawnie odróżniony
  od publicznego replayu. Nie trzeba ponownie dowodzić T2C3/T5 od początku.
- **P2:** dokończyć roboczą integrację wybranego S17/FPEMU, build FT1536
  w Extra/c i główny README. W opisie rozróżnić historyczny S17 od
  kandydata L_RHO z dowiedzionym L_V; integracja tego kandydata jest osobnym
  wyborem wersji, nie skutkiem samego opublikowania checkpointu.
- Przy każdej gotowej pracy: spójny pakiet, odbiór, osobny commit i jawna
  publikacja. Aktualna mapa nie nadaje owner acceptance starym kandydatom.

Następne zlecenie Astry powstaje po omówieniu tej mapy. Żaden nowy etap
matematyczny nie został uruchomiony przez jej zapisanie.
