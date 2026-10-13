# Kontynuacja020E — wykonawca komórkowy, bez zmiany samplera

PREPARED / OPEN / WARUNKOWY. Baza: RESOURCES_020E_CHECKPOINT i jego manifesty.
To dalsza część TODO020E, nie nowy cel zastępujący pełny koszt.

1. Zbudować parser na jawnej tablicy węzłów i stosie adresów, na wejściu
   legalne komórki SyntaxCells. Dla każdego rodzaju tokenu: odczyty/zapisy,
   dziecko wskazuje wcześniejszy węzeł, najwyżej jeden nowy węzeł, odkodowanie
   stosu po kroku równe SyntaxTape.push. To pierwsza rozstrzygająca próba.
2. Złożyć z program_roundtrip i osiągalną legalnością. Dodać rzeczywiste
   ramki kolejki i ich kodowanie; nie utożsamić dwóch słów/token z całym
   kosztem reprezentacji. Wybrać dwie ograniczone areny albo statyczne
   adresy podprogramów; udowodnić odzyskiwanie pamięci, nie założyć darmowego GC.
3. Powiązać wykonanie tych komórek z ControlStack.next i wartością ExprBackend.
   Przenieść sprawdzone granice32/1024 i28941/57882 dopiero po tej relacji.
4. Wypełnić źródło obrazu wejścia, koszt idealnych bitów i wersję płatnego
   dekodera, jeżeli caller potrzebuje pary zamiast bitów. CopyLoop daje
   gotową instancję transferu jednego banku, nie koszt jego producenta.
5. Dopiero po rzeczywistej realizacji wszystkich pól złożyć czas całkowity
   i pamięć szczytową z DriverCertificate. Zachować(M), full P i pokryte μ.

Alternatywy pozostają odroczone: streaming wymaga osobnego prawa dostępu;
backend C/bitowy — realizacji Word512 i pamięci. Nie ogłaszać ich niemożliwymi.
Nie wznawiać cudzych workerów ani monitora ROM. Jeden ciężki proces, świeże
etykiety, próby append-only, małe lokalne commity bez push.
