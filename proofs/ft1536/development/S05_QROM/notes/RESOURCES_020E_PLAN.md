# TODO020E — jawne zasoby tej samej maszyny

Start2026-10-13 z ad59b07632fb05ae3d06441f44d9fc47cbad31a4. WARUNKOWY;
bez niezależnego odbioru i deklaracji QROM.54 piny wyników i420 runtime020D
sprawdzone. Runtime resources_001;489 przypiętych modułów, jeden proces.

Cel: konkretny driver i interpreter o jawnej reprezentacji sterowania,
wyrażeń, wejścia/wyjścia; dowód zgodności z020 i rozliczenie pełnych zasobów.
Żaden nowy rekord certyfikatu nie zastępuje brakującego świadka.

Wybrana trasa: pełna idealna taśma, jawne kopiowanie banków oraz evaluator
ze stosem. Koszt ładowania danych, przygotowania kodu i odebrania wyjścia
płatny. Modelem pozostaje RAM o słowie512bit i bankach bitowych; nie jest
to czas natywnego Lean/C. Kod i stos potrzebują skończonego kodowania oraz
powiązania jego rozmiaru z rzeczywistymi stanami ewaluatora.

Alternatywy: (a) streaming bitów — odroczony, wymaga osobnego dowodu
zgodności prawa/dostępu; (b) backend C/bitowy — odroczony, wymaga implementacji
operacji i pamięci. Nie są to wyczerpane ani niemożliwe trasy.

Pierwsze kroki: postfix wyrażeń i dokładny stos; następnie kontrola programu,
peak sterowania i instancja877 węzłów, driver kopiowania oraz kompozycja
zasobów z EveryTape/certyfikatem020D. Osobne receipty każdej próby;
bez zmian poprzednich źródeł, bez push. Pełne Q-RESC pozostaje OPEN, dopóki
wszystkie nazwane pola kosztu i pamięci nie mają konkretnego dowodu.
