# TODO020 / continuation020E — pełny koszt wykonania

Status: PREPARED / WARUNKOWY, rozwinięcie S05/ROADMAP i otwartego Q-RESC020.
Wejście: SCATTER_OUTPUT_020D_CHECKPOINT, CHECKS, OUTPUTS i RUNTIME.
EveryTape oraz pełne kodowane J/P pod(M) są już kernelowe. Nie otwieramy
ich ponownie ani nie zastępujemy oryginalnego programu innym samplerem.

1. Ustalić jawny driver: reprezentacja h, ładowanie przypiętych tablic,
   stan initial, dostarczanie idealnej taśmy i przekazanie50689 bitów
   wyjścia. Wybrać pełną taśmę albo udowodniony dostęp do jej segmentów;
   nie przyznawać darmowego źródła bitów lub darmowej prekomputacji.
2. Zdefiniować reprezentację i koszt ewaluatora: instrukcje, wyrażenia,
   adresy, liczniki, stos sterowania i alokacja. Oddzielić ślad logiczny
   od pamięci, którą wykonawca rzeczywiście przechowuje.
3. Udowodnić zasoby drivera i ewaluatora oraz zachowanie semantyki020.
   Zsumować koszt wejścia, rdzenia i wyjścia; wyprowadzić pamięć szczytową
   dla tej samej implementacji. W razie rachunku liczbowego: Sage ze
   standardowym preparserem i dokładnymi dziedzinami; końcowe lematy Lean.
4. Złożyć konkretny certyfikat kosztu z `every_tape` i
   `MachineCertificate020D.public_initial`. Każde pole obowiązku musi mieć
   świadek; sam rekord/constructor nie kończy zadania.
5. Zachować audyt eksportów, snapshoty niepowodzeń, piny/receipty i małe
   lokalne commity. Jedno okno, jeden ciężki proces; bez push.

Kryterium zakresu: kompletne wykonanie w wybranym, jawnym modelu zasobów.
Koszt bitowy/C wymaga osobnej implementacji operacji512bit; nie wynika
z ceny jednostkowej. Nie zmieniać(M), e, porażek, capów, kierunku J/P ani
prawa kluczy w celu uzyskania łatwiejszego boundu.

Źródłowy Sign/PRG, rzeczywista emisja kluczy i(M), osobna naprawiona gra
wariantu A, QROM oraz pełny koszt reduktora pozostają odrębnymi obowiązkami.
Nie konsumować nowego ROM bez sprawdzenia rzeczywistych typów i pinów.
Każdy wynik ma klasę: obowiązek dowodowy, model albo założenie kryptograficzne.
