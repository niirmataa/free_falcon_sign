# Wejścia zadania FPEMU_FLOOR_CT — 2026-09-20

Baza Git: `20ed84a86d9374b026e2ea9ab78f7656a6650a8c`. Autor projektu: Niirmata.
Pakiet przygotowuje ręcznie uruchamianą Astrę do lokalnej poprawki floor,
z zachowaniem wyników bitowych i walidacją dla przypiętej kompilacji.

- source/: pełne17 plików niezmienionego baseline; CANDIDATE.sha256 ma hash
  `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`.
- AUDIT/: projekcja potwierdzonych ustaleń FPEMU, rzeczywiste call sites,
  source/assembly analysis i materiały do kontroli; ZERO/:17 źródeł Lean,
  aktualny raw-floor model, zero-aware kontrakt i jawny proof boundary.
- NODE2/TOWER/ROOT/NODE3/M0/LV/: interfejsy i raporty do analizy wpływu,
  bez deklarowania pełnego replayu tych wcześniejszych etapów.
- harness/ i vendor/: dokładny protokół/źródła dudect z przygotowania20ed84a;
  oficjalny silnik, licencje i wszystkie piny. Stare prepare/launch scripts
  są materiałem wejściowym, nie poleceniem uruchomienia starej kampanii.
- DUD/: wynik zakończonych trzech rund/36 prób i6 kontroli, wszystkie42
  receipts oraz ich snapshots. Wynik9/9 dla floor; brak wykrycia w pozostałych
  27 próbach. NO_LEAKAGE_EVIDENCE_YET nie oznacza proof CT.

Dla9 floor probes i6 controls zachowano pełne stdout/stderr i ponownie
przeliczono wszystkie per-batch stany102 testów z surowych danych, używając
hash-sprawdzonego przypiętego executable w trybie --replay. To odtworzenie
statystyk tym samym silnikiem, nie nowa fizyczna kampania ani drugi oracle.
Świeże receipts/streams są w review/, podsumowanie w DUD/RECEIPT_REVIEW.json.

Bootstrap zawiera pełne raw gzip dziewięciu floor probes i trzech positive
controls. Duże raw negative controls oraz raw/stdout pozostałych27 prób
pozostają w ukończonym oryginalnym W; ich referencje, rozmiary i zakres
hash-check/recalculation są jawne w DUD/RAW_INVENTORY.json. Nie przedstawiać
tej projekcji jako pełnego archiwum wszystkich danych nocnej kampanii.
Pliki źródłowe oryginalnego W pozostają tylko do odczytu.

ORIGINS.json rozróżnia publiczne wejścia Git, dane ukończonej kampanii i
nowe receipts prowadzącego. MANIFEST.sha256 obejmuje dokładny zestaw członków
pakietu, z wyłączeniem samego manifestu. Oryginalne OUTPUTS zachowują swoje
bazy; nie oznaczają, że projekcja zawiera wszystkie historyczne outputs.

Brak nowego kandydata C, jego walidacji lub owner acceptance na tym etapie.
Kopia tego pakietu znajduje się w nowym W/inputs/bootstrap; pracę uruchamia
właściciel. Historyczne zadania/skrypty są danymi, nie aktywnymi instrukcjami.
