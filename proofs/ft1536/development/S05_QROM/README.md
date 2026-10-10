# S05_QROM — publiczny sampler i redukcja kwantowa

Status: **WARUNKOWY / DEVELOPMENT**, bez twierdzenia bezpieczeństwa FT1536
w QROM i bez niezależnego odbioru. Tor rozwija wpis S05 w ROADMAP.

**Cel końcowy właściciela: dowód bezpieczeństwa FT1536 w QROM z deklaracją
na takim samym poziomie rygoru jak cel ROM.**
[Kontrakt tezy, założeń i obowiązków](notes/TARGET_CONTRACT_001.tex)
oddziela założenia kryptograficzne od lematów, które musimy domknąć.
Główne twierdzenie dotyczy rzeczywistego prawa kluczy FT1536; jednolity
all-h certyfikat jest silniejszym celem pomocniczym, nadal OPEN.
Nie uznano h=0 ani warunkowego budżetu MARGINAL-006 za końcowy wynik.

[Przegląd drugiego okna](notes/REVIEW_006_001.tex): piny zgodne, świeży
replay skorygowanych 005 i 006 odtworzył certyfikaty 512-bitowe bajt w bajt;
230 dodatkowych dokładnych praw sprawdziło rachunek mieszanki capu.
Werdykt: **conditional on a named input**, bez statusu REVIEWED i bez
nowego kernela. Potwierdzono zakres wyniku, nie istnienie efektywnego S.

**Korekta numeryczna 005:** [erratum końców MPFR](notes/NORMALIZER_005_ERRATUM_001.tex)
zastępuje pierwotne numeryczne świadectwa normalizatora.
`QQ(endpoint)` mogło zaokrąglać do pobliskiego ułamka; nowe źródło używa
`endpoint.exact_rational()`. Ponowny rachunek zachował deklarowane granice.
Historyczne pliki i manifesty pozostają bez zmian; wiążące liczby są w
[skorygowanym certyfikacie](notes/NORMALIZER_005_CORRECTED_CERTIFICATE.json).

Właściciel uruchomił ten tor 2026-10-10: małe lokalne commity na main,
**bez push**, bez zmian statusów T12.1/B20, mainline, paperu i strony.
SAMPLER-004 przeniósł całą ówczesną pracę tutaj: źródła do `notes/` lub
`formal/`, runtime do `.build/`. **Bieżące polecenie okna i kontynuacji**
wyznacza próby w nowych podkatalogach
`work/FT1536_S05_QROM_001/{normalizer_005,marginal_006}/`, a wyniki,
źródła i receipty w tym development. Wcześniejsza
historia work i `.build/sampler_004/` pozostaje bez zmian.
Nie nadpisujemy prób. [Handoff 004](notes/SAMPLER_004_HANDOFF.json),
[lokalne zasady](AGENTS.md).

## Baza

- RECON-001: [źródło](notes/RECON_001.tex), baza `2d2cdf52304cee9cf513487d4296392262df22f4`.
- CONTINUATION-002: [źródło](notes/CONTINUATION_002.tex), tekstowy warunkowy
  lemat kompozycji z `D = (1+e)^q_s − 1`; kwantowe użycie wymaga jawnych
  przesłanek. Podstawienie `st := initial` wykorzystuje uniwersalny
  kwantyfikator `LocalJointCertificate`, nie odczytuje zapytań kwantowych.
- [Piny źródeł i oryginalnych pakietów](notes/BASELINE_PINS.json).

## Mapa murów

| Obowiązek | Stan |
|---|---|
| Algebra pojedynczej ekstrakcji, rachunek pełnego Sign, kierunkowy moment J/P | Zachowane w dokładnym dotychczasowym zakresie |
| Wspólna kontynuacja i kompozycja w grach programowanych | Dowód tekstowy warunkowy, CONTINUATION-002 |
| Wykonalny publiczny sampler pełnej odpowiedzi, również porażek | SAMPLER-003 wykonany; TV do modelowego publicJoint <2^-90, dowód transferu tekstowy |
| Absolutna ciągłość J względem uczciwego P | Tekstowy argument nośnika, także dla terminalnego none; formal source binding OPEN |
| Certyfikat `ΣJ²/P≤1+e`, z użytecznym e | SAMPLER-004 naprawia h=0: tekstowy dowód pełnego momentu e<2^-50. Cel dla wszystkich h nadal OPEN; ograniczenie e>1/8 dotyczy starego kandydata 003 |
| Kernelizacja h=0: `J≪P` i moment | **OPEN, obowiązek jawny:** przenieść SAMPLER-004 do Lean z czystymi logami; etykieta **textual** pozostaje. Szkic DyadicObstruction również nie ma potwierdzonego kernela |
| Normalizator reszty `Z₁(r)` i odwrotność, także `r=c−hz₂` | NORMALIZER-005: textual, jednolity względny przedział <2^-356; błąd TV samych kategorii przez cap16 <2^-236. Nie jest to TV do uczciwego P |
| Pełny normalizator `Z_h,c`, odwrotność i błędy uproszczeń | NORMALIZER-005: h=1,c=0, balls512/768; względne szerokości <2^-180 i TV zerowego aliasu przez cap16 <2^-180. Efektywna kontrakcja dla wszystkich h,c **OPEN** |
| Naturalne rozszerzenie sekwencyjne 004 do h≠0 | Dla h=1,c=0 moment **przed normą >2^1536**; sama precyzja nie naprawia zmienności normalizatora. Nie jest to dolna granica końcowego Q-JOINT |
| Ważony marginal `w(z₂)Z₁(c−hz₂)` i nowe capy | MARGINAL-006: nowy **warunkowy** certyfikat pełnego prawa z `e<2^-119`; wymagane nowe certyfikaty propozycji, monety i kosztu. Nie jest to świadek all-h Q-JOINT |
| Koszt odrzucania całych wektorów z propozycji `w/G` | h=1,c=0: akceptacja <2^-767 nawet z idealną monetą; potrzebna adaptowana propozycja lub faktoryzacja. Nie jest to ograniczenie wszystkich samplerów |
| Dokładny UniformChallengeAt z ustalonej taśmy uczciwych bitów | Niemożliwy: masy dyadyczne, moduł 18433 nie dzieli 2^bits; nie zmieniono przesłanek głównej linii |
| Klasyczny log hasza | Wymaga nowej semantyki QROM |
| Osadzenie `q_H+1` celów | Wymaga nowej konstrukcji Q-TARGET i straty |
| Klasyczna strata kolizyjna | Wymaga osobnego rachunku reprogramowania |
| Rzeczywiste prawo Sign i wszystkie wyjścia API | Otwarty bridge źródłowy |
| Kwantowy PRG/seed, publiczny SHAKE/H2P (S04), zasoby reduktora | Osobne otwarte przesłanki |

Trzy przebudowy mechanizmów ROM nie są pełną listą wymagań QROM.
Mały błąd TV również nie zastępuje certyfikatu kierunkowego momentu.

## Struktura

- `notes/`: dokumenty wynikowe, piny, receipty i źródła rachunku Sage;
- `formal/`: nowe moduły Lean z jawnym zakresem weryfikacji;
- `obstructions/`: wspólna kolekcja zakresów, dowodów i pinów; materiał do ewentualnego Aneksu B;
- runtime i zachowana historia SAMPLER-004: `.build/sampler_004/`;
- nowe próby okna: `work/FT1536_S05_QROM_001/normalizer_005/` i `marginal_006/`;
- wcześniejsze podkatalogi work są niezmienionymi wejściami historycznymi.

Pierwszy commit jest zapisem źródeł rozpoznania, nie akceptacją dowodu.

## Checkpoint SAMPLER-003

[Wynik i pełne argumenty](notes/SAMPLER_003.tex),
[wykonywalne źródło Sage](notes/PUBLIC_SAMPLER.sage),
[certyfikat rachunku](notes/SAMPLER_003_CERTIFICATE.json),
[koszt, próby i receipty](notes/SAMPLER_003_RECEIPT.json),
[duże tablice przez generator/pin](notes/LARGE_ARTIFACTS.json).

Trzy syntetyczne wykonania sprawdziły kongruencję, normę i signed16;
obie gałęzie cap-failure sprawdzono również przy faktycznych limitach.
Limit to 150994944 prób par i 18 GiB zużytych bitów, czytanych leniwie,
bez takiej alokacji pamięci. Obserwowane wykonania po przygotowaniu tablic
zużyły 2625–2710 prób par; nie jest to benchmark produkcyjny.

Sage 10.9: rachunek ZZ/QQ i balls512 zakończony. Lean: 120 s timeout
pierwszego modułu i 60 s timeout samego importu. Drafty Lean zachowano
w kuźni; **niczego nowego nie oznaczono jako kernelowo sprawdzone**.

Wynik h=0 wyklucza konstrukcję 003 z małym e na całym Rq,
nie inne samplery. Poniższy krok 004 zachowuje ten niewygodny wynik
i buduje osobną poprawioną gałąź.

## Checkpoint — SAMPLER-004

[Pełny dowód tekstowy i następny interfejs](notes/SAMPLER_004.tex),
[wykonywalny sampler h=0](notes/HZERO_SAMPLER.sage),
[certyfikat rachunku](notes/SAMPLER_004_CERTIFICATE.json),
[koszt, receipty i zachowane próby](notes/SAMPLER_004_RECEIPT.json).

Dla **h=0 i każdego wyzwania** nowy sampler odtwarza prawo włókna
z kontrolowaną dominacją punktową. Obejmuje sukces, cap16, porażkę
modelowej emisji oraz rozliczony fallback pary. Łącznie z dyadycznym
wyzwaniem daje `J≪P` i `ΣJ²/P≤1+e`, `e<2^-50` (około 4.6840e-17).
To dowód tekstowy z rygorystycznym rachunkiem Sage, bez nowego kernela.

Koszt ograniczono do 2359296 propozycji par i 2419187712 bitów na odpowiedź,
czytanych leniwie; prekomputacja kategorii ma jawny limit 49152 przedziałów
wag. Sprawdzono cztery przypadki warunkowe oraz faktyczny fallback przy cap192.

**Cel S05-Q-JOINT-INSTANCE dla wszystkich h pozostaje OPEN.** Dla naturalnego
rozszerzenia wyprowadzono dokładny moment przed normą:
`E[Z_res] * E[1/Z_res]`. Dla h=0 jest równy 1; dla pozostałych h brak
użytecznego oszacowania. [34 dokładne testy tożsamości](notes/SAMPLER_004_RESIDUAL_CHECKS.json)
są małymi modelami kontrolnymi, nie dowodem dla parametrów FT1536.
Nie osłabiono końcowego kwantyfikatora ani nierówności momentu.

## Midpoint — NORMALIZER-005

[Dowód i dokładny zakres](notes/NORMALIZER_005.tex),
[skorygowany rachunek Sage](notes/FIBER_NORMALIZER_005_CORRECTED.sage),
[skorygowany certyfikat](notes/NORMALIZER_005_CORRECTED_CERTIFICATE.json),
[receipty i zachowane niepowodzenie](notes/NORMALIZER_005_RECEIPT.json),
[skorygowane porównanie precyzji](notes/NORMALIZER_005_CORRECTED_CROSSCHECK.json).
Pierwotne receipty są historią; korektę i jej nowe uruchomienia wiąże
[receipt MARGINAL-006](notes/MARGINAL_006_RECEIPT.json).

Odejmowanie minimalnej energii daje stabilny **względny** przedział
normalizatora każdej reszty i jego odwrotności. Dla pełnego włókna h=1,c=0
osobno obudowano ogony theta, zmianę kraty na box i niezerowe aliasy modulo q.
TV po cap16 obejmuje sukces oraz porażki normy i modelowej emisji;
nie warunkujemy prawa na sukces. Zapisano też dokładne prawo odpowiedzi
jako wielomian w prawdopodobieństwie akceptacji, bez dzielenia przez małą masę.

**Ograniczenie:** certyfikowany TV dla h=1,c=0 porównuje uczciwe prawo
z idealnym prawem zerowego aliasu. Nie skonstruowano jego nowego samplera
bitowego ani pełnego samplera Q-JOINT dla wszystkich h. Certyfikat kategorii
porównuje z kolei ten sam idealny sampler sekwencyjny, nie z uczciwym P.

Sage 10.9, balls512 i balls768: udane rachunki i dokładne porównanie
przedziałów; tekstowy dowód jednolity nie jest ekstrapolacją 16 fixture'ów.
Pierwszą nieudaną próbę (zbyt mocny próg momentu bloku >8) zachowano;
poprawny certyfikat daje >4, a dla 768 bloków >2^1536 przed normą.
Dokument skompilowano w edytorze. Nie ma nowego Lean ani niezależnego review.

Następny krok: kontrolować lub losować marginalne prawo
`w(z₂) Z₁(c−hz₂)`, z wykonalnym kosztem, albo zbudować inną konstrukcję
samplera włókna. **Q-JOINT-INSTANCE dla wszystkich h pozostaje OPEN**;
kernelizacja h=0 jest osobnym, nadal otwartym obowiązkiem.

## Najnowszy krok — MARGINAL-006 i kolekcja obstructions

[Nowy dowód prawa capów i momentu](notes/MARGINAL_006.tex),
[rachunek Sage](notes/MARGINAL_006.sage),
[certyfikat](notes/MARGINAL_006_CERTIFICATE.json),
[receipty](notes/MARGINAL_006_RECEIPT.json),
[kolekcja przeszkód](obstructions/OBSTRUCTIONS_001.tex),
[indeks z pinami i statusami](obstructions/INDEX.json).

Ważenie marginalu korzysta z tych samych certyfikowanych `Z₁`.
Nowa konstrukcja przygotowuje 16 par, każdą z własnym capem odrzucania;
wyczerpanie dowolnego capu daje pełne `none`. Jej dokładne prawo to
`J=(1−δ)Q+δ·none`. Świeży dowód obejmuje nośnik i koszt momentu
zależny od `δ²/P(none)`; dla `P(none)=0` dodatkowy abort narusza `J≪P`.

**Warunkowy** budżet daje `e<2^-119` dla pełnej pary wyzwanie–odpowiedź.
Nie przeniesiono certyfikatu h=0. Wymagane są osobno: propozycja na pełnym
boxie z kontrolą dwustronną, względnie dokładna skończona moneta i użyteczny
koszt. Obecny sampler 004 nie spełnia pierwszej przesłanki przez sam fakt
posiadania jednostronnej dominacji. Nie ogłaszamy implementacji all-h.

Przeszkoda kosztowa dla konkretnej próby jest rygorystyczna: przy h=1,c=0
propozycja `w/G` z odrzucaniem całego wektora ma akceptację <2^-767.
Nawet 2^128 propozycji daje prawdopodobieństwo jakiejkolwiek akceptacji
<2^-639. To nie wyklucza faktoryzacji blokowej ani innych propozycji.
Sage512/768 sprawdził też 102 dokładne małe prawa, wszystkie rodzaje porażek
w modelu testowym i kontrolę negatywną nośnika.

Kolekcja `obstructions` zawiera **DyadicObstruction**, moment przed normą
oraz nowy wynik kosztowy. Przy każdym wpisie są jawne kwantyfikatory,
non-claims i status kernela. DyadicObstruction ma tekstowy dowód i historyczny
szkic Lean; jego modułu nie uruchomiono po wcześniejszym timeout innego modułu.
Kolekcja nie zmienia paperu ani strony.

Następny krok: adaptowana propozycja lub kontrolowana faktoryzacja marginalu,
z nowymi certyfikatami oraz rzeczywistym kosztem. Kernelizacja h=0 i lematów
capu pozostaje **OPEN / textual**.

README jest żywym stanem. Historyczne manifesty, które pinowały README,
weryfikujemy względem ich commitów (003: `0a6999d7`). Nowe manifesty
pinują wyłącznie pliki wynikowe checkpointu.
