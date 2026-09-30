# Bieżąca praca — normalne małe commity

Ten katalog zawiera żywe źródła nowych kroków badawczych. Źródła są
normalnie śledzone w Git od początku; po małym logicznym kroku commit
i push main, zgodnie z poleceniem właściciela2026-09-30.
Pełny schemat: `docs/onboarding/WORK_COMMITS.md`.

- Jeden wykonawca danego zakresu i jeden writer Git. Wykonawca z TASK
  „bez Git” przekazuje listę plików koordynatorowi.
- Aktywnego wykonawcy w starym W nie przełączamy w trakcie kroku.
  Najpierw handoff i kontrola dopisków od snapshotu; dopiero potem właściciel
  przekazuje mu nowe miejsce pracy. Przygotowanie katalogu nie startuje agenta.
- `T12_1` rozwija istniejący ROADMAP T12.1/T5. Nie jest nowym zadaniem dowodowym
  ani przyjęciem nieodebranego wyniku. Status przekazania w `T12_1/README.md`.
- `notes/` i `tools/original/` zawierają historyczne bajty z W jako proweniencję.
  Dawne prompty/AGENTS/komendy nie wybierają aktualnego zadania. Stare runnery
  trzeba jawnie podłączyć do nowego workspace przed użyciem.
- Modułów identycznych z `stages` nie commitujemy drugi raz. Manifest
  `ARCHIVED_DEPENDENCIES.json` wskazuje ich dokładne ścieżki i SHA256.
  Modyfikacja takiej zależności powstaje jako własny plik w `formal/`;
  frozen stage pozostaje źródłem wersji bazowej.
- Sage z preparserem, Lean4+Mathlib, czyste logi i dokładny scope jak w głównym
  AGENTS. Odbiór przez niezależnego recenzenta, później `archive.py` i tag.
- Build, HOME/TMPDIR/cache/job outputs pod ignorowanym `.build/` właściwego
  komponentu albo przydzielonym runtime W; duże wyniki przez pin/generator
  i trwałe bajty. Źródła/niewygodne wyniki zachowują normalną historię.
