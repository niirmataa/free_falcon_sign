# TODO020E / continuation001 — parser w skończonej arenie

IN_PROGRESS / WARUNKOWY / NOT_REVIEWED. Start2026-10-13.
Baza d2e192ec744d77e5e6dd8663bfbc59e5881c7e09;29 pinów wyników,
189 runtime i507 modułów sprawdzone. Bez zmiany samplera, M ani prawa J/P.

Zakres tego podetapu: skończona tablica węzłów i skończony stos adresów,
krok dla każdego tokenu, wskaźniki tylko do wcześniejszych węzłów,
zgodność z SyntaxTape.push/parse i odkodowanie całego programu877 tokenów.
Odczyty/zapisy mają konkretne adresy. Ghost denotation może być użyta
wyłącznie w dowodzie, nigdy przez wykonawcę. Błędny token/brak miejsca to
błąd parsera, nie nowy abort podpisu; legalny obraz programu ma przejść.

Kolejność: (1) bank/stos i lokalne lematy, (2) typy tokenów i relacja sterty,
(3) rzeczywisty krok/pętla, (4) odkodowanie i instancja877, (5) audyt/piny.
Pełny interpreter komórkowy, odzyskiwanie pamięci i całkowity Q-RESC
pozostają osobnymi, otwartymi częściami020E; parser sam ich nie zamyka.

Wybrana trasa: arena append-only dla pojedynczego parsowania; dwie areny
lub statyczne adresy dla późniejszego wykonawcy. Alternatywy streaming/C
pozostają odroczone. Jedno okno, jeden proces Lean, istniejące limity,
świeże etykiety prób, małe commity bez push. Daybreak jest planowanym
niezależnym recenzentem zgodnie z decyzją właściciela; odbioru nie uruchomiono.
