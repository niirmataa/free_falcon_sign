# TODO020E / continuation005 — ślad alokacji i przechowywana pamięć

PREPARED / OPEN / WARUNKOWY. Dalsza część tego samego020E/S05.
Wejście: ARRAY_BACKEND_020E4_CHECKPOINT/CHECKS/OUTPUTS/RUNTIME i kolejka020E4.
Nie zamieniać już dowiedzionych naliczeń na pełny peak przez zmianę nazwy.

1. Zdefiniować operacyjną semantykę alokacji odpowiadającą konkretnym
   CostBank/CostFrames/CostValues/CostParse/CostDriver. Ślad lub arena musi
   wiązać rozmiary payloadów i ich reprezentacje z rzeczywistymi krokami.
   Dowolny Run/pure/map nie jest automatycznie certyfikatem przechowywania;
   kernelowy CostSpaceGap jest obowiązkowym negatywnym testem takiej reguły.
2. Dać konkretne świadki dla KAŻDEGO prymitywu i miejsca konstrukcji wartości:
   kopie Array, inicjalizatory tabulate, krótkie listy, rekordy stanu, scratch,
   kontynuacje skanu/parsera/wykonawcy i struktury producenta wejścia. Funkcje
   proof-only model/read/load w tezie nie mogą stać się darmowym wykonawcą.
3. Wyprowadzić pełny globalny peak z kolejności życia danych. Konserwatywny
   allocator bez zwalniania jest dopuszczalnym modelem, ale wymaga realnego
   powiązania wszystkich zdarzeń z naliczeniami, nie założenia tego powiązania
   w polu końcowego rekordu. Uwzględnić publiczny klucz i wbudowane stałe.
4. Rozróżnić model słów od adresów/bitów i natywnego Lean/C. Jeśli optymalizuje
   się pełną taśmę lub używa reuse/in-place, dodać refinement i odpowiednie
   sprzężenie monet. Nie zmieniać programu, prawa, M, e ani porażek po cichu.
5. Podłączyć instancję do CostDriver.every_tape/CostCertificate, dopiero potem
   zmienić status pełnego Q-RESC w wybranym modelu. Sage + kernel dla liczb,
   czyste logi, zachowane próby i samodzielny checkpoint z mapą murów.

183 eksporty020E4 są obecnymi materiałami, nie niezależnie odebranym wynikiem.
Nie uruchamiać recenzenta/monitora, obcego wykonawcy ani replayów ROM.
Jedno okno i jeden ciężki proces; trwały nowy runtime, małe commity bez push.
