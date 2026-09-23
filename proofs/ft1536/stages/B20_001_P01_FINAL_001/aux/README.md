# aux/ — pliki pomocnicze (role)

Te pliki NIE wchodzą do żadnego twierdzenia (nie są importowane przez żaden
eksport) i NIE są budowane przez `lake build` (leżą poza `run/formal/`).
Są w pakiecie, bo są częścią śladu decyzji projektowych i snapshotu źródeł
(uwaga recenzenta: snapshot nie może obejmować plików nieobecnych w pakiecie
— tu wszystko jest i ma opisaną rolę).

## Debug.lean — inspektora pipeline'u checkera

Pomocniczy moduł `#eval` do oglądania pośrednich kroków wiązania źródła:
tokeny fragmentu, `encodeStmt`, `decodeStmt`, `checkSource`, `translateStmt`.
Używany ręcznie podczas rozwoju (diagnostyka FAILED_ROUTES#8–10); nie jest
dowodem ani kontrolą — same widoki `#eval`.

## RedTest.lean — probe redukcji kernelowej (dowód wyboru List Char)

Pozytywny probe: które prymitywy **redukuje kernel** pod `decide`/`rfl`
(String.eq, wzorce literałów w `match`, `String.toList`). Przeszedł czysto —
to jest podstawą wyboru `List Char` dla `translateStmt` (decyzja FAILED_ROUTES
#8). Odtwarzany w replayu jako job `lean_probe_reduction` (wymagany exit 0).

## RedTestStringFailures.lean — negatywny probe (zachowany ślad)

Wersja pierwotna: test redukcji na `String.startsWith/endsWith/trim/drop/
dropRight/toNat?` — **nie redukują kernelowo** w tym Lean (a `trim/dropRight`
zwracają tu `String.Slice`). Przykłady celowo nie przechodzą `decide` —
to jest materiał dowodowy FAILED_ROUTES#8 (dokładne komunikaty tamże).
UWAGA: ten plik NIE kompiluje się celowo; nie jest budowany ani skanowany
w replayu (leży tylko w aux/). Zachowany jako źródło błędu, nie tylko hash.
