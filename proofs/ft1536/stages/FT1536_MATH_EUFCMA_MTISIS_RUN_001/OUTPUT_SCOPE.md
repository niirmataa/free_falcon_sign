# Zakres plików

- **formal/**: 15 własnych modułów matematycznych + Audit.lean. To jedyna
  autorytatywna formalizacja eksportów. Certificate.lean regeneruje Sage,
  lecz każdy zawarty w nim wniosek sprawdza Lean.
- **sage/**, certificates.json: dokładne QQ/ZZ i RBF256, kontrola preparsera,
  konkretne dodatnie/ujemne przypadki. Skończone kontrole nie zastępują
  ogólnych lemmas Lean ani gry bezpieczeństwa.
- **FORMAL_EXPORTS / formal_types / AXIOMS / GOAL_SPEC**: typy i granice
  rzeczywiście sprawdzonych eksportów. Główny eksport EUF-CMA pozostaje OPEN.
- **MODEL, CLAIM, BRIDGE_LEDGER, NEXT_INTERFACE, RESOURCE_BOUND, ASSUMPTIONS**:
  wiążący scope, konkretna matematyczna instancja i brakujące obowiązki.
- **inputs/bootstrap/**: niezmienione25 przypiętych wejść + ich oryginalny
  MANIFEST. Zagnieżdżone OUTPUTS dawnych stages są kotwicami proweniencji,
  nie listą brakujących plików wybranego bootstrapu.
- **library-source/** i **LIBRARY_CLOSURE**: komplet źródeł rzeczywiście
  importowanych bibliotek oraz piny shared RO build cache. To zależności
  Lean/Mathlib, bez używania nieodebranych wyników P02.
- **history/**: rzeczywiste próby źródeł, stdout/stderr/receipty; nie są
  dodatkowymi aktualnymi eksportami. Pozostałe cache/binary artifacts i HOME
  pozostają w W/run i nie są materiałem pakietu.
- **tools/replay.py, BUILD.json, EXPECTED.json, REPLAY_SEED**: odtwarzalny
  build i semantyczne porównania. OUTPUTS obejmuje końcowy pełny pakiet.
- **replay/**: świeży własny replay, pełne raw logs i receipty; nie review.

Nie importowano projektu C, nie uruchamiano KeyGen/source Sign i nie
tworzono sekretów. Wektory kontrprzykładu są publicznymi syntetycznymi liczbami.
Własne koszty replayu nie są dowodem kosztów reduktora kryptograficznego.
