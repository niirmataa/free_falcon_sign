# S05 / SAMPLER-007 — checkpoint warunkowy

Baza: `a3c1181bb212e97aa43c3b8281aa33625f0396b2`.
Status: **EXECUTABLE / CONDITIONAL TEXTUAL MOMENT / DEVELOPMENT**.
Nie jest to REVIEWED, kernelowy certyfikat ani deklaracja bezpieczeństwa.
Piny wyników: `SAMPLER_007_OUTPUTS.sha256`; dane wejściowe: `SAMPLER_007_INPUTS.json`.

## Co wykazano

Wykonalny publiczny sampler losuje wektor, potem wyznacza wyzwanie.
Wyczerpanie 80 propozycji pary daje parę zerową, a wyczerpanie 196 wektorów
świeży jednostajny sześcian o gwarantowanej normie. Każdą gałąź rozliczono
punktowo. `J(none)=0` jest jawną cechą tego samplera; uczciwe porażki normy
i emisji pozostają w pełnym prawie P i w rachunku momentu.

Tekstowo: J≪P dla każdego h, a pod warunkiem masy włókien (M)
`ΣJ²/P ≤ 1+e`, `e<2^-44`. (M) wynika tekstowo z istnienia dokładnej bazy
całego jądra A_h, której pivotsy LDL w metryce Q należą do `(0,q²/991]`.
Most używa przesuniętych sum gaussowskich przy trzech temperaturach;
nie utożsamia stałych wieży T5 z masą włókna bez tożsamości atomów.

Sage512/768 potwierdził granice; dokładny crosscheck sprawdził końce QQ.
Trzy wykonania syntetyczne, obie gałęzie capów przy rzeczywistych limitach
oraz 27 małych praw pełnych zakończyły się poprawnie. Te testy nie dowodzą
(M) dla h=0, h=1, gęstego klucza ani rzeczywistego KeyGen.
Koszt: najwyżej 24 084 480 propozycji par i 24 662 538 240 bitów,
czytanych leniwie, plus jawna prekomputacja i arytmetyka syndromu.

Tabela ROM↔QROM rozdziela znaczenia A2 na granicy seedu i orakulum,
wiąże CompPRGBound z obowiązkiem nowej kwantowej klasy testów i zachowuje
OPEN pełnego uczciwego hopu PRG. Sprawdzono 40-bajtowy nonce oraz dokładny
wzór klasycznej straty z mianownikiem 2^320. Nie przeniesiono tej straty
na kwantowe reprogramowanie. Deklaracja EUF-CMA w QROM nadal dotyczy wyłącznie
przyszłego twierdzenia po domknięciu świadków.

## Czego nie wykazano i mapa murów

| Obowiązek | Stan po 007 |
|---|---|
| Algorytm z pełnym rachunkiem wewnętrznych limitów | Wykonany; nowy dowód tekstowy dominacji |
| J≪P | Tekstowo dla każdego h w modelu współczynnikowym |
| Mały pełny moment | Tekstowo pod (M), nowy budżet e<2^-44 |
| Dokładna baza/LDL → (M) | Nowy dowód tekstowy; bez kernela |
| Source KeyGen → baza, atomy i dokładne LDL | **OPEN**, konieczne pokrycie całego właściwego nośnika μ_H |
| All-h mały moment | **OPEN**, mocny cel pomocniczy nie został osłabiony |
| Kernelizacja samplera/mostu/momentu | **OPEN**, nie ponawiano niezmienionych wcześniejszych importów Lean |
| Q-BIND, realny PRG i wszystkie wyjścia API | **OPEN** |
| Q-HASH-LOG i Q-COMPOSE | **OPEN**, wcześniejsza warunkowa kompozycja zachowana |
| Q-COLL i Q-EMBED | **OPEN**, nonce spójny, strata i liczba celów nieprzeniesione z ROM |
| Q-RESC całego reduktora | **OPEN**, receipt 007 dostarcza lokalny limit operacji/bitów |
| Deklaracja bezpieczeństwa FT1536 w QROM | **NIEDOSTĘPNA przed świadkami** |

## Nieudane próby i zachowana historia

Pierwsza poprawna wersja miała capy192/256; zapisano ją przed ograniczeniem
kosztu do80/196. Oba wyniki pozostają w historii; nowy budżet momentu
jest policzony od nowa. Pliki prób i ich SHA są w receipcie.

Pierwsze uruchomienie porównania precyzji przeszło asercje, lecz poległo
na serializacji `Sage Integer` do JSON. Zachowano źródło i stderr; poprawka
`default=int` zmienia zapis wyniku, nie nierówności. Oddzielne uruchomienie
zakończyło się sukcesem. Jedno wywołanie runnera odrzuciło absolutny pathspec
wyjścia przed uruchomieniem Sage; poprawiono go na ścieżkę względem root,
bez osłabiania walidacji. Żadnej historii 003–006 nie nadpisano.

## Następny krok

Wyeksportować i udowodnić **dla rzeczywistych emitted keys** dokładną
identyfikację bazy jądra, całego atomu gaussowskiego i pivotsów LDL,
z błędem źródłowych liści objętym właściwym kontraktem. Zestawienie nazw
`perKey_fiber_reindex`, `perKey_mass_bounds` i `CertificateAcceptedScan`
nie zastępuje tego dowodu. Sampler pozostaje publiczny i nie używa bazy
sekretnej w wykonaniu. Potem kernelizacja oraz wpięcie do redukcji QROM.

Własna ocena: wykonaliśmy konkretny krok od warunkowego interfejsu do
algorytmu z policzonymi gałęziami i kosztem. Najbliższy mur stał się
ściśle algebraiczno-źródłowy. Nie ma podstaw do ogłoszenia, że został
już spełniony przez FT1536, ani do podania poziomu bezpieczeństwa.
