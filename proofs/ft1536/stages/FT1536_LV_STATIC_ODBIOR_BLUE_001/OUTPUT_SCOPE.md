# Zakres DAYBREAK OUTPUTS.sha256

Bazą ścieżek jest katalog `FT1536_LV_STATIC_ODBIOR_BLUE_001`. Manifest
obejmuje zwykłe, niesymlinkowane pliki:

- `DAYBREAK_REVIEW.md`, `DAYBREAK_RESULT.json`, `INPUTS.sha256`,
  `TOOLCHAIN.txt`, `OUTPUT_SCOPE.md`, `computation-contract.json`;
- wszystkie pliki w `checkers/`, `computations/independent-001/`, `formal/`,
  `inputs/`, `reference/` i `logs/`;
- wszystkie zwykłe pliki w `replay/` poza binariami `lv-normal` i
  `lv-sanitize`;
- `COMMANDS.frozen.log`, będący dokładnym snapshotem żywego `COMMANDS.log`
  wykonanym po zakończeniu kontroli.

Manifest nie obejmuje samego siebie, żywego `COMMANDS.log`, `.git/`, `.agents/`,
`.codex/`, `work/`, cache, plików tymczasowych ani binariów. Żywy dziennik
pozostaje dostępny jako wymagany artefakt sesji, a jego zamrożona kopia jest
przedmiotem hashowania. Kopie wejść są publiczne i zostały wykonane dopiero po
sprawdzeniu manifestu RUN_001. Nie ma symlinków ani ścieżek wychodzących poza
bazę manifestu.
