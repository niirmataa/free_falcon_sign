# FT_FAMILY_SCALING — niezależny odbiór pracy MiMo 2.6 PRO

2026-09-22. Autor projektu: Niirmata. Pakiet badawczy: MiMo; niniejszy
raport, izolowane sprawdzenia i opakowanie archiwalne: prowadzący odbiór.
Zachowana atrybucja źródeł Falcon Project / Thomas Pornin.

**Werdykt: RESEARCH_REVIEW_CHANGES_REQUIRED.**

Praca ma wartościowy, sprawdzony rdzeń algebraiczny i parametryczny.
Wymaga poprawek w definicjach problemów kryptograficznych, kierunkach redukcji
i spójności wniosków. Archiwizacja zachowuje rezultat wraz z tym werdyktem;
nie oznacza owner acceptance, gotowości FT768/FT3072 ani poziomu bezpieczeństwa.

## 1. Którą wersję odebrano

Właściciel zgłosił zakończenie pracy w
`proofs/ft1536/work/FT_FAMILY_SCALING_2026-09-21/`. Snapshot odczytano
2026-09-22T00:08:58.256677Z (02:08:58 CEST), na main
`8a0871999eed0ad93e755c0a9df331062e3785e4`.

- Oryginalny SHA256SUMS:
  `9a272b83e167c61e0b413ab35ab21352465f90d0fd04f897b0ffe9b9c7e4fefa`.
- PACKAGE.md:
  `1be5a789d2f56501fae6d5b954d57d9a00399bcdf8374cff6164e87fa4d0a610`.
- CLAIMS.md:
  `bbbcd9a37496f3ac30e8e32b25e77f3065bf5c173f68fdc61d793d7601037ba6`.
- main.tex:
  `d63c491a305f721421028e373272002155d69f5a494e7e761ca7177d959b6d44`.
- main.pdf:
  `b4090163231299842d662241f8baeb54a928b3070ab8e14b2823cfefdfb8ba8b`.
- Sprawdzono wszystkie43 pozycje manifestu; snapshot obejmuje je oraz sam
  SHA256SUMS. Nie odnotowano zmian w trakcie odczytu ani wykonania kontroli.
- Wszystkie17 źródeł jest zgodnych z manifestem56974571…; kopia w
  `inputs/source/`, pełny pin w `inputs/CANDIDATE.sha256`.

Oryginalne pliki autora, w tym manuskrypt, PDF, Lean, skrypty, wyniki i jego
ledger korekt, są zachowane bajtowo w głównym katalogu tego checkpointu.
Dodane pliki REPORT/RESULT/INPUTS/OUTPUTS, README/OUTPUT_SCOPE/REPLAY i
`review/` są opakowaniem prowadzącego. [PACKAGE.md](PACKAGE.md) nadal
dokumentuje pierwotne zlecenie, a [review/SNAPSHOT.json](review/SNAPSHOT.json)
przypina dokładny stan odczytu. Wcześniejsze uwagi z przeglądu aktywnej pracy
nie są automatycznie przeniesione na tę końcową wersję.

## 2. Co zostało niezależnie potwierdzone

### Warstwa kernelowa i źródłowa

- Świeżo skompilowano **4/4 moduły Lean4.34.0**: FTA2, FTLayout, FTRoots,
  FTBounds. Wszystkie stdout/stderr czyste. Osobno sprawdzono typy, termy
  i aksjomaty **14 nazwanych twierdzeń**; brak forbidden proof escapes.
- Poprawne są scalar A2 identities/inequalities, zamknięte postacie
  zadeklarowanych rekurencji drzewa i scratch oraz zamknięte rachunki progów
  i pierwiastków. Źródłowe shapes porównano z `falcon-keygen.c:7594–7681`.
  Source guards blokujące inne warianty są faktami obecnego profilu.
- Zakres kernela jest konkretny: np. `7*N = 10752` jest rachunkiem,
  nie pełnym dowodem bezpieczeństwa alokatora; trace/embedding bridge i jego
  instancja w C mają dodatkowy analityczny/source binding. Tę granicę należy
  konsekwentnie utrzymać także w CLAIMS i streszczeniu pracy.

### Obliczenia i niezależne kontrole

- Ponownie wykonano **3 skrypty Python**: geometry, layout, bounds_table.
  Wszystkie **5 wynikowych JSON/CSV** zgadza się bajtowo ze snapshotem.
  Sprawdzono też wartości logiczne kontroli, nie sam kod wyjścia.
- Niezależne Sage potwierdza pierwszość18433, tożsamości cyklotomiczne dla
  768/1536/3072, podane modular roots oraz spisy142/164/186 podgrup, po7
  podgrup rzędu2 i indeksu2. Współczynniki trace-form sprawdzono przez
  **sumy Newtona z wielomianu**, niezależnie od autorskiej implementacji
  sum Ramanujana. Daje to wszystkie potrzebne współczynniki formy dla tych N.
- Poprawiona geometria rozdziela `det G=(3/4)^N` od
  `covol_Q=q^N*(3/4)^(N/2)` i pierwiastka `(3/4)^(1/4)*sqrt(q)`.
  Wcześniejsza rozbieżność tego wzoru jest zamknięta w końcowym manuskrypcie.
- **12/12 przypadków portu FFT**, wszystkie sloty, przeszło niezależny
  ComplexBallField256 oracle: bezpośrednie sumy z modularną tablicą faz,
  a dla all-ones/alternating dokładna tożsamość szeregu geometrycznego.
  Enclosures potwierdzają badane nierówności; centra maksymalnych błędów
  zgadzają się z autorskimi MPFR wynikami w opisanej tolerancji.
  Maksymalna zapisana stała empiryczna wynosi0.20849541742003128.
  To kontrola skończonych przypadków portu, nie uniwersalny theorem FPEMU.

Kontrole działały pojedynczo w bwrap/network-off, z zapisem tylko do
trwałego katalogu odbioru, osobnym HOME/TMPDIR/cache i limitem8GiB
(Lean-j1/-M2048). Pakiet autora pozostawał odczytywany, bez edycji.
Nie uruchamiano kampanii estymatora ani KeyGen/Sign. Oryginalnego monolitycznego
Sage SA1–SA6 nie powtórzono w całości: użyto opisanych niezależnych kontroli.
Nie deklarujemy jednego pełnego standardowego replayu całego pakietu.

## 3. Poprawki wymagane przed uznaniem opracowania za domknięte

### R1 — wysoki priorytet: kierunek redukcji jest odwrócony

[ATTACK_PROBLEMS.md:106–109](ATTACK_PROBLEMS.md) twierdzi, że solver MT-ISIS
daje fałszerstwa przez `(forged bytes => witness)`, a kierunek
`hardness of MT-ISIS => hardness of forging` wymaga odwrotnego kodowania.
To zamiana kierunków.

Znany L_V daje **akceptowane bajty → wyekstrahowany krótki świadek**.
Zatem przy zgodnych wejściach i eksperymentach algorytm fałszujący można
złożyć z ekstraktorem, otrzymując solver relacji. To jest kierunek używany
do wniosku o trudności fałszowania z trudności relacji. Aby z solvera relacji
zbudować atak bajtowy, potrzebny jest przeciwny most.
Pełna redukcja M0 nadal wymaga właściwej symulacji ROM/Sign, rozkładów,
świeżości i rachunku zasobów; punktowa własność L_V sama ich nie domyka.
Naprawić strzałki i dokładnie rozdzielić te dwa zastosowania.

### R2 — wysoki priorytet: gra MT-ISIS i niezależność celów

[ATTACK_PROBLEMS.md:69–77](ATTACK_PROBLEMS.md) daje przeciwnikowi wybór
wartości `c_i`. Przy takim dosłownym wyborze problem ma rozwiązanie trywialne:
`c=0,z1=z2=0`, dla każdego h, z Q=0<B. To kontrmodel definicji zadania,
**nie fałszerstwo w ROM**. W M0 przeciwnik wybiera nazwy zapytań, a nowa
wartość H jest losowana; ponowne zapytanie zwraca tę samą wartość.

Wzór `1-(1-p)^Q_target` wymaga dodatkowych warunków niezależności/jednakowego
p. Dla powtórzonych lub adaptacyjnych celów nie wynika z samego ich zliczenia.
Prosty kontrmodel: dwa identyczne zdarzenia o p=1/2 mają unię1/2, nie3/4.
Trzeba podać grę i właściwe warunkowe oszacowanie lub union bound.
Budżety M0 są parametryczne `(Q_s,Q_H,t,w,L)`; obca konwencja2^64 nie
zastępuje ich definicji. Binding: M0/GAME.md §3 i TARGET_TYPE.md.

### R3 — wysoki priorytet: krótki wektor nie dostarcza wejścia F

[ATTACK_PROBLEMS.md:43–49](ATTACK_PROBLEMS.md) odwołuje się do
`falcon_complete_private` jako uzupełnienia trapdooru przy odwracalnym f.
Sygnatura źródłowa `falcon-vrfy.c:1551–1553` wymaga **f,g,F** i wylicza G.
Sam solver P1a dostarcza co najwyżej parę; nie dostarcza brakującego F.
Ta funkcja nie jest rozwiązaniem całego równania NTRU z samych f,g.
Potrzebny jest osobny krok uzyskania F,G, jego warunki, długości i koszt.
Również próg P1a ma być zdefiniowany dla wskazanej populacji, a nie zastąpiony
oczekiwaniem4N/3 surowych propozycji bez jawnego marginesu.

### R4 — wysoki priorytet przed kampanią: szkielet nadal liczy odrzucone SIS

Dokument P2 poprawnie odrzuca homogeneous SIS jako cel. Tymczasem
[run_campaign.sage:58–67](scripts/estimator_campaign/run_campaign.sage)
nadal wywołuje `SIS.estimate` i oznacza wynik jako P2. Ponadto
`ESTIMATOR_COMMIT=None`, więc „pinned campaign” jest na razie szkieletem
z przyszłym obowiązkiem przypięcia wersji. NOT_RUN zachowano uczciwie:
nie ma błędnie ogłoszonego pomiaru bezpieczeństwa. Przed uruchomieniem
trzeba jednak naprawić sam program/etykiety, nie tylko wypełnić SHA.

### R5 — średni priorytet: H-B nie przechodzi swojego idealnego testu

[RESEARCH_NOTES_PL.md:48–54](RESEARCH_NOTES_PL.md) sugeruje uzasadnienie
768/1.075 przez akceptację≥1−2^-40 w modelu chi-square. Dla dokładnie
określonej interpretacji **Q/768² ~ chi-square(3072)** niezależny rachunek
przedziałowy256bit daje:

```text
x = 2093922385 / 1179648
Pr[Q >= B] = exp(-x) * sum(k=0..1535) x^k/k!
           = [2.992542073603248197283145861087467110114156925931201337023408118515964188e-9
              +/- 2.32e-82]
           > 2^-40.
```

To ujemny wynik dla tej hipotezy w podanym modelu ciągłym, nie obliczenie
rzeczywistego prawa podpisów po castach, błąd implementacji ani atak.
Wycofać uzasadnienie tego konkretnego kryterium dla obecnego marginesu albo
precyzyjnie zdefiniować inny model. Zmiana parametrów schematu pozostaje
odrębną decyzją; ten odbiór ich nie zmienia.

### R6 — średni priorytet: status granicy FFT nie jest spójny w całym tekście

C11 i główna sekcja zostały poprawione na **PROPOSED_BOUND** — to właściwy
kierunek. Jednak abstract `paper/main.tex:48–50`, wnioski:501–511 i końcowa
uwaga `CLAIMS.md:30–32` nadal sugerują wyprowadzony/ustalony wynik analityczny.
Wszystkie zależne deklaracje muszą odpowiadać temu samemu statusowi.
Przy przyszłym dowodzie trzeba osobno rozliczyć perturbację twiddles;
samo mnożenie błędu operacji przez `(1+eps_tw)^L` nie zastępuje wyprowadzenia
błędu do idealnych faz. Obserwacja12 przypadków nie ustala stałej c ani
domen, a model binary64 portu nie jest pełnym kontraktem FPEMU.

### R7 — lokalna korekta tabeli i opisów

[PARAMETRIC_TASK_LAYOUT.md:80](PARAMETRIC_TASK_LAYOUT.md) podaje15360 jako
`3N+scratch` dla FT3072. Prawidłowo **3*3072+7168=16384**. Rekurencja i
Lean scratch7168 są poprawne; to błąd tabeli, nie obalenie layout theorem.
Zalecane generowanie tego wiersza z kontrolowanego JSON. Doprecyzować także
zakresy „kernel” versus analytic/source binding i nie nazywać binary64/MPFR
liczb zmiennoprzecinkowych arytmetyką dokładną. Pierwotne EXACT_COMPUTATION
obejmuje w tym pakiecie obie kategorie i wymaga czytelniejszego rozdzielenia.

## 4. Kontrola własnej metody odbioru

Pierwsza dodatkowa kontrola FFT używała wielomianu nad prostokątnymi balls
i ewaluacji Hornera. Jej enclosures rozrosły się przez interval wrapping;
nie pozwalały potwierdzić boundu już dla N768/ternary. Zachowano skrypt
`review/fft_oracle_horner_failed.py` oraz logi `independent-fft.*`.
Zastąpiono wyłącznie oracle prowadzącego bezpośrednimi modular-phase sums.
Ten sam przypadek i wszystkie12 kontroli przeszły; witness wrapping jest
w EXTRA_CHECKS. Jest to failed route odbioru, nie błąd wyniku MiMo.

## 5. Ocena i sensowny pilot

**Warto tę pracę zachować i wykorzystać.** Potwierdzone rekurencje, dane
geometryczne i konkretne Lean lemmas mają wartość niezależnie od braków
w części kryptograficznej. Poprawione determinanty, bit-reversal i empirical
FFT data pokazują rzeczywistą poprawę względem roboczej wersji.

MiMo nadaje się do próby na ograniczonym, sprawdzalnym zadaniu. Proponowany
pierwszy pilot: **FT_FAMILY_GAME_INTERFACE_REPAIR** — naprawić P1/P2/P3 na
przypiętym M0/L_V, dostarczyć jawne typy wejść/wyjść oraz strzałki redukcji,
kontrole c=0/powtórzonego celu i zgodny skeleton NOT_RUN. Kryterium odbioru
ma być poprawność konkretnych definicji i kontrole negatywne, nie styl tekstu
ani liczba nowych twierdzeń. To odrębne zadanie od trwającego H6P Astry.

Następny odbiór powinien zachować tę wersję i porównać poprawiony pakiet
wiersz po wierszu z R1–R7. Koszty ataków, pełne source security i FT768/3072
implementation readiness pozostają otwarte. Kompilacja oraz hash match
nie podnoszą ich statusu do PROVED.
