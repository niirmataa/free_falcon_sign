# Proweniencja wykonania i historia prób

- Zapis wyników i nowych plików wyłącznie w W tego audytu. Wszystkie
  obliczenia C/Sage/Lean wykonano przez sprawdzony `scripts/run.py`: bwrap
  root read-only, bootstrap read-only, tylko W writable, unshare-net/pid,
  finite wall/CPU; normal8GiB; ASan odrębnie bez limitu wirtualnego adresowania
  dla shadow memory. Mount/route receipts są w logs i artifacts/platform.json.
- Zanim odczytano lokalne AGENTS, wykonano początkowy **odczytowy**
  `git status --short && git diff --stat && git diff --cached --stat && git log --oneline -10`
  w repo. Pokazał zastany staged zestaw36 plików oraz HEAD95f8015. Nie był
  źródłem audytu; źródłem jest wyłącznie bootstrap BASEb5805bab… . Nie było
  późniejszych poleceń Git, zapisów indeksu, commitów ani zmian źródeł.
- Początkowy glob nazw AGENTS w nadrzędnym work zwrócił też nazwę
  `FT1536_H3_NODE2_RUN_001/AGENTS.md`. Nie odczytano tego pliku, treści
  aktywnego katalogu, logów ani procesów NODE2; nie uruchamiano jego testów.
- Do znalezienia dozwolonych lokalizacji narzędzi odczytano listy nazw
  katalogów home/Dokumenty/repo/media/mnt oraz publicznego starego drzewa
  FALCON_FPEMU. Próba listy `/media/root` zwróciła EACCES. Nie czytano
  prywatnych plików wskazanych przez same nazwy katalogów. Ostateczny
  ograniczony search nazw narzędzi ma osobny receipt `timing_tools.json`.
- `scripts/run.py` był dostarczonym helperem i został przeczytany przed
  użyciem. `scripts/verify.py` rozszerzono o task hash, długości i spójność
 124 ORIGINS, piny wszystkich17 źródeł i membership projekcji w starych
 OUTPUTS. Oryginalne dane bootstrap i wcześniejsze manifesty pozostały
 niezmienione. Provenance jest sprawdzone w hash-bound records; nie wykonano
 ponownej ekstrakcji Git, zgodnie z izolacją.
- Dwie nieudane pierwsze próby Sage są zachowane w COMMANDS i pełnych
  stdout/stderr: (1) Sage CLI nie dodaje scripts do import path — jawnie
  dodano lokalne scripts; (2) porównanie MPFR upper endpoint z RBF zamiast
  exact QQ — zastąpiono granicę przez QQ. Były to błędy harnessu, nie
  kontrprzykłady FPEMU. Trzecia próba przeszła; progi liczbowe nie zmieniły się.
- Kontrole C obu trybów, oddzielne negative/no-op oracle controls, RBF i
 29 historycznych Lean modules zakończyły się sukcesem. Nie dodawano
 nowych plików Lean. Historyczne kopie są byte-identical, logs czyste,
 bez sorry/admit/native_decide albo wyciszania ostrzeżeń.
- KeyGen, Sign z kluczem, prywatny loader i full test_falcon nie zostały
 uruchomione. Kompilacja oryginalnych TU do analizy assembly nie jest
 wykonaniem tych funkcji. Publiczny SHA256(counter) generator tworzy
 syntetyczne operands; nie korzysta z seeda kryptograficznego programu.
- `COMMANDS.log` rejestruje wywołania bounded executora; `logs/jobs/*.json`
 rejestruje wszystkie jego child argv/cwd/limits/exit oraz hashe stdin i
 pełnych streams. Build receipts wiążą source/binary/compiler hashes.
 Chronologiczne próby i ich błędy nie są usuwane przy freeze.
