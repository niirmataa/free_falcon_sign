# Fresh replay RUN_002

`SEMANTIC_FILES.json` ustala10 semantic outputs przed replayem. Baseline:
`run/final_002`, z jawnym override drukowanych terms do `run/audit_001`;
fresh DEST: `replay/fresh_003` — przed wywołaniem nie istnieje.

```
python3 -B scripts/job.py final_002 full
python3 -B scripts/job.py ubsan_002 ubsan
python3 -B scripts/job.py asan_002 asan
python3 -B scripts/job.py audit_001 lean
python3 -B scripts/replay.py replay/fresh_003
```

Rzeczywiste receipty i finalna lista komend rozstrzygają o wykonaniu; ta
lista jest protokołem, nie deklaracją wykonania. Każdy job jest sekwencyjny,
network-off, inputs/źródła RO, writable DEST pod W, świeże build/HOME/cache/
TMPDIR/DOT_SAGE/XDG. `/tmp` w sandboxie wskazuje trwały podkatalog DEST/tmp,
nie systemowy tmp ani tmpfs. Limit1800s/krok, normalnie8GiB, Lean-j1/-M2048.
ASan osobno: bez limitu wirtualnego adresu z powodu shadow, runtime
hard_rss_limit_mb=2048, polityka zapisana w receipcie przed wykonaniem.

Reuse dotyczy jedynie przypiętej biblioteki Mathlib i runtime, po weryfikacji
pełnych źródeł/blob tree i cache manifestów. Własne Ledger/Audit budowane
świeżo. Provenance starszego toolchain gate jest pinowanym wejściem i nie
oznacza konsumpcji matematycznych eksportów P02.

Po freeze:

```
python3 -B scripts/replay.py replay/NOWY_ABSENT_DEST --outputs-sha256 <zewnętrzny OUTPUTS_SHA256>
```

Każdy match musi mieć rzeczywisty producer/log/exit w nowym DEST. Receipty
czasu i polecenia z nowymi ścieżkami nie są porównywane bajtowo jako semantyka.
Nieudane próby pozostają w `run/`; ich snapshotów/logów nie zastępuje się
nowymi. Replay nie ogłasza source boundu, niezależnego odbioru ani acceptance.
