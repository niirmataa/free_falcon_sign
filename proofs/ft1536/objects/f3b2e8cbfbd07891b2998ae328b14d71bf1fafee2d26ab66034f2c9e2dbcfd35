# SECURITY_CONVENTION — konwencja raportowania bezpieczeństwa rodziny FT

Wersja 1. Decyzja właściciela: 2026-09-22.

## 0. Pozycjonowanie

`free_falcon_sign` — niezależna rodzina badawcza: **FT768 / FT1536 /
FT3072**. Żadnych kategorii ciał normalizacyjnych, żadnego mapowania na
standardy, żadnych „równoważników AES-x". Falcon-512/1024 występuje wyłącznie
jako **punkt badawczy** mierzony tą samą linijką. Nazewnictwo FT jest naszą
własną marką rodziny.

## 1. Jednostki raportowania

Każda liczba bezpieczeństwa podaje **model obok wartości**:

- geometria ataku: **β** (rozmiar bloku BKZ) — licznik niezależny od modelu
  kosztu;
- koszty: para **Core-SVP classical / Core-SVP quantum** w konwencji stałych
  `0,292·β / 0,265·β` (nazwy modeli: BDGL16-classical / ADPS16-quantum),
  z wariantem `[Duc18] dimensions-for-free` w nawiasach;
- pełna drabina modeli (BDGL16, LaaMosPol14, MATZOV cl/q, ADPS16 cl/q,
  GJ21, ChaLoy21, ABFKSW20, ABLR21, CheNgu12, ADPS16_paranoid) wyłącznie
  jako **zakres wrażliwości min–max**; modele ekstremalne (paranoid) nigdy
  w liczbie głównej;
- model enumeracyjny (CN12) jako uzupełnienie, jawnie spoza konwencji głównej.

Zabronione: pojedyncza liczba-bitowa bez nazwy modelu; mieszanie linijek
w jednym minimum; mapowanie na kategorie zewnętrzne.

## 2. Format „dossier profilu FTxxx"

Dla każdego profilu raportujemy trzy rozdzielone problemy (definicje:
`ATTACK_PROBLEMS.md`):

| problem | pytanie | format wiersza |
|---|---|---|
| **P1** key recovery | odzyskanie kluczowej pary/trapdooru | β, para Core-SVP (d4f w nawiasie), prawo sekretu, status warunkowania |
| **P2** produkcja akceptowanych bajtów | fałszerstwo dla losowego celu ROM | β, para Core-SVP (d4f), próg B z podaniem pochodzenia, wariant(y) scenariusza |
| **P3** prawo samplera | rozkład wyjść uczciwych | nie jest liczbą kosztu; status obowiązków |

Reguły składania:
1. **Najsłabsze ogniwo** profilu = minimum po P1/P2 na tej samej linijce
   kosztowej (Core-SVP cl/q osobno).
2. **Wielocelowość P2**: koszt per-cel × liczba celów (`targets = Q_H+1`),
   union bound po nazwach rozłącznych; nigdy `(1−p)^Q` bez niezależności.
3. **Status kompozycji**: koszty pojedynczej instancji; pełna redukcja
   (gry M0/M7: symulacja ROM/Sign, świeżość, budżety `(Q_s,Q_H,t,w,L)`)
   ma status jawny (obecnie OPEN) i nigdy nie jest pomijana milczeniem.
4. **Rozbieżność modeli** podajemy obok minimum (np. FT1536: 314,5/285,4
   przy stałych głównych; zakres 7 modeli 225–348).

## 3. Wzorzec wiersza (FT1536, dane kampanii 2026-09-22)

> **FT1536** — P1 key recovery: β=1077, Core-SVP **314,5 cl / 285,4 q**
> *(d4f: 292,6 / 265,5)*, prawo RAW ternary (conditioning EMITTED: OPEN).
> P2 produkcja bajtów (próg przypięty `Extra/c`): β=1082,
> **315,9 cl / 286,7 q** *(d4f: 293,9 / 266,9)*; cele z tabeli ROM,
> `targets = Q_H+1`, union bound.
> Najsłabsze ogniwo: P2. Rozbieżność modeli redukcji: 225–348 bitów
> (7 modeli; dane w artefaktach). Kompozycja M0/M7: OPEN.
> Żadnych kategorii zewnętrznych — nie deklarujemy poziomu certyfikowanego.

## 4. Czego nie publikujemy

- kategorii/mapowań ciał normalizacyjnych, „równoważników" i porównań
  marketingowych;
- liczb zbiorczych bez rozdzielenia P1/P2 i modeli;
- wyników `REJECTED` (jednorodny SIS) i `WITHDRAWN` (proxy euklidesowy)
  w zbiorzeniach głównych — pozostają w `NEGATIVE_RESULTS.md`.
