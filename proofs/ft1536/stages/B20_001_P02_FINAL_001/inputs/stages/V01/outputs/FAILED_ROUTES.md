# V01 — FAILED_ROUTES (nieudane trasy recenzenta + zachowane trasy autora)

Autor zachował 18 tras (FAILED_ROUTES.md + failed_attempts/ + aux/RedTestStringFailures).
Recenzent nie ukrywa własnych nieudanych prób; trasy autora zweryfikowane
wyrywkowo (kluczowe #8, #15, #17, #18).

## Trasy autora (potwierdzone przez V01)

- #3 `elan` self-update przez sieć — build wyłącznie bezpośrednią ścieżką
  toolchainu; replay V01 tą samą ścieżką, exit 0 bez sieciowej instalacji.
- #8 `decide` na `String.*` nie redukuje kernelowo — potwierdzone niezależnie:
  `lake env lean aux/RedTestStringFailures.lean` daje błędy `rfl`
  (`toNat?`, `drop`→`Slice`, `dropRight` typ `Slice`), ostrzeżenia
  `String.data/dropRight` deprecated. Pozytywny probe `RedTest.lean` exit 0
  w replayu (podstawa `List Char`).
- #15 `QQ.numerator()` redukuje GCD=5 — potwierdzone: surowe ℤ w Lean
  (`CertificateInput`) i Sage (`ZZ`), cyfry zgodne; kontrtest `+2ulp`
  pokazuje czułość ℤ-warunku.
- #17 `__file__` w preparsowanym `.sage` — naprawione przez `FT1536_P01_OUT`;
  replay V01 odtwarza do DEST bez tego błędu (certyfikaty identyczne).
- #18 destrukcyjny replay v1 — naprawione przez `restore_replay.py`
  (fresh DEST, brama `find -newer` czysta w replayu V01).

## Własne trasy V01 (jawne)

- F-V01-1: pierwsze odczytanie `REPLAY.md` sugerowało `cd P01/output_v2`
  z `python3 tools/…` — niedokładne `cd` (brak `tools/` pod `P01/`,
  jest pod `output_v2/`). Użyto przypiętego entry z kopii V01
  (`inputs/producer_v2/tools/restore_replay.py` → `run/replay_DEST_001`).
  Bez edycji frozen; odnotowane w REVIEW jako benign diff dokumentacji.
- F-V01-2: `RedTestStringFailures.lean` — próba `lake env lean` poza DEST
  (cwd V01) dałaby ten sam błąd, ale receipt wymaga cwd DEST/run;
  powtórzono z właściwym cwd (błędy identyczne, exit lean ≠ 0).
  Plik celowo nie budowany w replayu (jak u autora).
- F-V01-3: `v01_numeric_check.sage` v1 pisał raport do `output/` root
  zamiast `output/sage/` (duplikat po `cp`). Usunięto root-kopię,
  ujednolicono na `sage/v01_numeric_report.txt` + `raw_logs/v01_numeric.*`.
  Ponowny run 22/22 przed freeze.
- F-V01-4: `lean_rebuild_all.stdout` V01 vs autora różni się licznikami
  (`[1974/2550]` vs `[2028/2618]`) — nie jest to niepowodzenie;
  wyjaśnione jako świeża kompilacja (olean nowsze od markera).

Brak ukrytych tras; luźny bound `rad<2^-200` i missing types jak u autora.
