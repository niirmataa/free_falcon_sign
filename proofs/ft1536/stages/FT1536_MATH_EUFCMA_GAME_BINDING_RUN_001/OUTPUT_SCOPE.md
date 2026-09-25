# OUTPUT_SCOPE — zakres plików pakietu

- **formal/FT1536/**: 15 odziedziczonych modułów (bajtowo = piny poprzednika,
  `INHERITED_SOURCES.sha256`; zamrożone oryginały nietknięte) + 5 nowych
  (GameByte, GameNames, GameMach, PaidSteps, GameCertificate — ten ostatni
  generuje Sage i kernel go przelicza). **formal/Audit.lean**: audyt 201
  eksportów (101+100) — jedyna autorytatywna lista typów/aksjomatów.
- **sage/check_games.sage**: dokładne małe modele trzech interpreterów,
  bijekcja bajtowa, jednostajność celów, licznik płatnych, suma konfliktów,
  instancjacja realnych parametrów, 8 kontroli negatywnych + no-op.
  `REFERENCE_certificates.json` = wynik referencyjny (identyczny jak produkt
  replayu; EXPECTED go piny).
- **GAME_SEMANTICS, MAIN_THEOREM, GOAL_SPEC, MODEL, CLAIM, BRIDGE_LEDGER,
  NEXT_INTERFACE, RESOURCE_BOUND(.json), ASSUMPTIONS, REPORT**: wiążący scope,
  dowód na papierze, dokładne brakujące typy.
- **inputs/bootstrap/**: niezmienione 5 plików zlecenia + MANIFEST oraz
  PREV_VERIFICATION.json (protokół weryfikacji poprzednika).
- **LIBRARY_CLOSURE.json**: kopia bajtowa closure poprzednika (3456 modułów
  bibliotek, 17280 pinów artefaktów) — RO cache współdzielony; w replayu
  źródła weryfikowane względem `library-source/` pakietu poprzednika.
  Własne moduły NIE pochodzą z żadnego cache — przebudowane od zera.
- **tools/replay.py, BUILD.json, EXPECTED.json, TOOLCHAIN.json,
  REPLAY_SEED.sha256, REPLAY.md**: odtwarzalny build i porównania semantyczne
  (produkty zadeklarowane PRZED replayem). OUTPUTS obejmuje pełny pakiet.
- **replay/**: świeży własny replay (REPLAY_RESULT, EXECUTION_RECEIPTS,
  SAGE_RUNS, COMMANDS, guard_controls) — kontrola autora, nie review.
- **history/**: surowe logi 13 prób Lean i 7 przebiegów Sage; FAILED_ROUTES
  je opisuje. Nie są eksportami.
- **INPUTS/OUTPUTS.sha256, HANDOFF.md, RESULT.json, EXECUTION_RECEIPTS.json,
  SEMANTIC_FILES.json, FORMAL_EXPORTS.json, formal_types.txt, AXIOMS.json**:
  piny i statusy.

Nie importowano projektu C; nie uruchamiano KeyGen/source Sign; nie czytano
sekretów. Dane wejściowe to publiczne/syntetyczne wartości (kontrprzykład
centrowania — jawne liczby). W tym wykonaniu **RUN leży poza repo**
(`/home/footfalcon/Obrazy/…`, decyzja właściciela 2026-09-23); repo było
wyłącznie źródłem RO (poprzednik + biblioteki) i nie zawiera żadnych zapisów.
Koszty replayu nie są dowodem kosztów reduktora.
