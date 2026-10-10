# S05 / COEFFICIENT_GRAM-013 — rzeczywista baza i jej energia

Baza: `75ae62d660c28aba862c33cee5d9477aa0da0dd2`.
Status: **KERNEL_CHECKED_ALGEBRAIC_BINDING / QROM WARUNKOWY**.
Klasa: **obowiązek dowodowy Q-SAMPLER**. Bez niezależnego odbioru,
nowych założeń kryptograficznych i bez deklaracji bezpieczeństwa.

## Wynik

Z istniejącej `ActualNTRUFiber.coefficientBasis`, korzystającej z dokładnego
mnożenia modulo `X^1536−X^768+1`, zbudowano całkowitą macierz M i rzeczywisty
Gram `Γ=MᵀHM` w niezmienionej metryce `Geometry.Q`.

Kernel wyprowadza:

- dokładny obraz współrzędnych oraz `uᵀΓu=Q(Bu)`;
- z równania NTRU `fG−gF=18433`: całkowitą tożsamość z macierzą dopełniającą,
  rzeczywistą odwrotność M i dodatnią określoność Γ;
- dla każdego przesunięcia z: `(pack u+s_z)ᵀΓ(pack u+s_z)=Q(z+Bu)`,
  gdzie `s_z=M⁻¹ pack z` jest jawnie skonstruowane;
- przez **istniejącą bijekcję ROM**, całą masę włókna `A_h z=c` jako sumę
  po tych współrzędnych i tym Gramie, ze zwykłymi równaniami h/fInv.

Nie założono docelowej równości energii jako pola `gramEq`.
27 twierdzeń w module obejmuje pomocnicze identyfikacje i końcowe eksporty;
nie oznacza27 odrębnych nowości matematycznych. Dodatniość wymaga NTRU;
sama definicja bazy nie wystarcza (zerowa baza jest kontrolą negatywną).

## Ponowne użycie

[REUSE_MAP_013.md](REUSE_MAP_013.md) wiąże potrzeby S05 z gotowymi eksportami
ROM/T5/H3, zaznacza pokrycie części012 i różnicę budżetów991/1023.
Nie powtarzano Poissona, wieży, ogólnych wyników Cholesky'ego/temperatury
ani ogonów. Nowe pakowanie dotyczy rzeczywistego `Vec×Vec`, a nie starego
typu zagnieżdżonych `Points`.

BATCH058 dostarcza warunkowy transport wejścia retry i powiązania scratch
pointer. Właściwy status pozostaje `PARTIAL_PROOF / Acceptance NOT MET /
NOT_REVIEWED`; nie jest używany tutaj jako gotowa instancja emitted law.
Przegląd i kandydatura nie zmieniają statusów source3.

## Mapa pozostałych obowiązków

| Ogniwo | Stan po013 |
|---|---|
| Konkretna macierz `coefficientBasis` i metryka Q | **Kernel, bez dodatkowego certyfikatu energii** |
| Odwracalność i dodatniość Grama | **Kernel z dokładnego równania NTRU** |
| Pełna energia afiniczna i reindeksacja całego włókna | **Kernel z istniejącym eksportem ROM** |
| Wybrany porządek dwóch bloków; primary cap; widmowy Schur/Parseval | **OPEN**; następny krok ilościowy |
| Konkretne kontrolowane dane Cholesky/T5 albo instancja012 | **OPEN**; równość energii macierzy nie jest jeszcze `GForm d L` |
| Source harmonic i cały emitted KeyGen | Zachowane mixed/source010 oraz warunkowe source3; instancja/kernel OPEN |
| Skończony box, wykonywalny007, pełne porażki, moment i koszt | Gotowe komponenty ROM do konsumpcji; pełny certyfikat007 OPEN |
| QROM hash/reprogramowanie/cele/PRG/zasoby | Status bez zmian, OPEN |

Macierz używa jawnego porządku `(half, component, pair)`. Nie twierdzimy,
że to `GramLDL.unitCoeff` lub stable leaf schedule. Dodatniość już przenosi
się przez dowolną równoważność indeksów `Fin3072≃Coord`. Świadek sekretnej
bazy jest narzędziem dowodu, nie wejściem wykonawczym publicznego samplera.
Równość `tsum` nie jest tu nowym twierdzeniem o zbieżności dla dowolnej
temperatury ani o małym błędzie masy.

## Sprawdzenie i historia

Finalny `gram_011`: czysty Lean4.34.0,27 twierdzeń, standardowe aksjomaty.
Użyto9 istniejących modułów projektu z pinami; bez nowego odbioru całego ROM.
Sage QQ/ZZ:9 przypadków (stopnie2/6/12, wymiary4/12/24), niezależne obliczenie
macierzy z iloczynów wielomianów, energii, przesunięć i odwrotności.
Trzy kontrole negatywne: zła metryka, zły znak bazy, zerowa baza.
Przykłady są syntetyczne, nie należą automatycznie do emitted profilu FT1536.

Wszystkie10 poprzednich runów zachowano, w tym czysty pośredni `gram_005`.
Pierwszy ujawnił przesłanianie niepełnego katalogu biblioteki `Run2`;
izolowany zestaw013 rozwiązuje to bez zmiany012. Pozostałe poprawki dotyczyły
elaboracji, koercji, rekurencji i uproszczeń; nie były kontrprzykładami.
Failed `sorryAx` nie są przyjętymi dowodami. Dokument LaTeX skompilowany.

Piny: `COEFFICIENT_GRAM_013_INPUTS.json`, `COEFFICIENT_GRAM_013_OUTPUTS.sha256`.
Wykonanie i koszty dowodzenia: `COEFFICIENT_GRAM_013_RECEIPT.json`.
Próby: `COEFFICIENT_GRAM_013_ATTEMPTS.json`. Koszty te nie zastępują
certyfikatu czasu/pamięci wykonywalnego samplera.

Następny krok: ilościowa geometria **tego konkretnego Grama**, z adapterem
do gotowych konsumentów T5/012. To kontynuacja istniejącego dowodu;
ogólna probabilistyka pozostaje do ponownego użycia.
