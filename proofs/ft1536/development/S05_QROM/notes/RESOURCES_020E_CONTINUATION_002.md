# TODO020E / continuation002 — wykonanie po adresach stałej tablicy

PREPARED / OPEN / WARUNKOWY. Wejście: ARENA_PARSER_020E1_CHECKPOINT,
CHECKS, OUTPUTS i RUNTIME; oryginalne EveryTape/J/P020D/020E zachowane.
To dalsza część020E, bez ogłoszenia pełnego Q-RESC.

Wybrana trasa: parsed node bank pozostaje niezmienny podczas wykonania.
Nowy wykonawca przechowuje adres instrukcji, licznik pozostałych iteracji
pętli i osobny skończony stos ramek. Alternatywa dwóch aren rekonstrukcji
pozostaje odroczona; nie jest obalona. Wybór statycznych adresów pozwala
uniknąć dopisywania węzłów przy każdym obrocie pętli, jeśli invariant to potwierdzi.

1. Zdefiniować ramki run/repeat z adresem i licznikiem. Związać je ze
   starym Code przez bank-only decode, wypełniając typ i zakres każdego pola.
   Pierwszy test: jeden krok seq/branch/loop odpowiada ControlStack.next,
   włącznie z guard=false i cap=0, bez modyfikacji tablicy kodu.
2. Dodać wykonanie wyrażeń po adresach dzieci. Zachować rhs/lhs oraz kolejność
   dzieci branch(no,yes,guard) i loop(body,guard); powiązać z ExprBackend.
3. Udowodnić pojemność banku ramek i stosu wartości, właściwe nadpisywanie
   martwych slotów i brak potrzeby nowej alokacji w pętli. Przenieść lokalne
   bounds≤32 dopiero po wykazaniu relacji, nie przez podobieństwo nazw.
4. Przypisać rzeczywiste kroki/ceny odczytów, zapisów, dispatch i arytmetyki
   w tym samym modelu. Doliczyć produkcję/ładowanie obrazu, idealne bity,
   parser oraz dekoder/transfer API w potrzebnym wariancie. Zsumować czas
   i współistniejącą pamięć;5264 słowa areny nie są pełnym peak.
5. Połączyć z driverem/EveryTape/J/P, audytować eksporty i wszystkie pola
   konkretnego certyfikatu. Żaden niewypełniony konstruktor nie zamyka celu.

Jedno okno i jeden ciężki proces, istniejące limity Lean, świeże etykiety,
próby append-only, małe lokalne commity bez push. Niezależny odbiór Daybreak
pozostaje osobną czynnością właściciela; ten plan nie startuje recenzenta.
