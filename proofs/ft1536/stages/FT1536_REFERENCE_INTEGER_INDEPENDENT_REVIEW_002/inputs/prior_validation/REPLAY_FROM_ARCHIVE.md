# T03 — odtworzenie przypiętego wejścia replayu

To opis transportu danych, nie zapis nowego wykonania. Prowadzący nie
uruchamiał replayu przy archiwizacji. Etap:
`proofs/ft1536/stages/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001`.

1. Odczytaj catalog i sprawdź zewnętrzne piny REPORT/OUTPUTS oraz85 członków.
   Utwórz NOWY seed pod własnym trwałym W w repo. Skopiuj sealed outputs
   i OUTPUTS bez zmian, w tym COMMANDS.log.
2. Zweryfikuj `INPUT_CLOSURE.json` przez VALIDATION.sha256. Każdy rekord
   `repository_path` rozwiąż względem repo, sprawdź SHA/regular file/no symlink,
   a bajty skopiuj pod `seed_path`. Zawiera1276 plików bootstrapu oraz POLICY
   i kopię TASK pod aliasem. To kompletne mapowanie wejść bez czytania W autora.
3. Sprawdź ponownie wszystkie29 INPUTS,1275 bootstrap members i source17.
   TASK alias jest jawną kopią transportową dokumentu o właściwym hash.
   Nie regeneruj manifestów lub certyfikatów. Fresh project/cache/build są
   późniejszym wynikiem runnera, nie wejściem skopiowanym z archiwum.
4. W uprawnionym niezależnym runie zastosuj trwały W-only/network-off sandbox,
   oryginały RO/ukryte,HOME/TMPDIR/TMP/TEMP/XDG/DOT_SAGE lokalnie pod własnym W.
   Uruchom z tego seed właściwy entrypoint autora:

```text
python3 -B scripts/replay.py ABSOLUTE_SEED/tmp/NEW_DEST 0cafdbb2c746043380081052951cb6438643f6a1765a98028a065fa57b7df6de
```

DEST musi być nieistniejący. Rachunek runner wykonuje jako `sage … .sage`.
Expected11 plików pochodzi z sealed SEMANTIC_FILES i OUTPUTS; nowe pliki
powstają pod `DEST/project`. Zachowaj wszystkie raw logs i failed attempts.

`catalog.replay=standard` identyfikuje dwuargumentowy entrypoint autora.
Ogólny `archive.py replay` nie materializuje tej transitive INPUTS closure,
zeruje COMMANDS.log i oczekuje innego rozmieszczenia/schema child result;
nie jest samodzielnym transportem tego pakietu. Użyj powyższego jawnego
odtworzenia i oryginalnego runnera. Nie zmieniaj frozen kodu,aby dopasować
go do ogólnego launchera. Zapisany niezależny replay zachowano w replay/.
