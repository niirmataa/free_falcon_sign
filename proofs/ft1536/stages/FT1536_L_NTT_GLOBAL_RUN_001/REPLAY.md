# Świeży replay GLOBAL

Wynik: **PASS**, 103/103 pliki znaczeniowe bajtowo identyczne.
Receipt i pełna lista: `artifacts/replay_result.json`.

Przed replayem zamrożono `artifacts/replay_baseline.sha256`:
`bb827f23045c98387681befe2853445a250910c6a4a7c581917b1e3536a991ce`.
`artifacts/replay_prefix.json` przypina długość i hash ówczesnego prefiksu COMMANDS.log.

`scripts/replay.py` utworzył świeży `replay/`. Skopiowano wyłącznie potrzebne
źródła formalne/skrypty, publiczne przypięte wejścia i źródło C. Nie kopiowano
olean, binariów ani cache. Ponownie wygenerowano Twiddles/BlockChecks/Audit,
sprawdzono wszystkie18 modułów, skompilowano baseline/plain/mutanty,
wykonano oba przypadki trace C/Lean i niezależne Sage controls.
Wewnętrzny runner miał osobny sandbox zapisu `replay/` i read-only source/.

Równość103 plików obejmuje aktywne Lean sources, wszystkie17 C inputs,
generowane kopie C/harnessy, wejścia kontroli, pełne trace buffers,
czyste stdout/stderr finalnych kompilacji i pięć znaczeniowych certyfikatów JSON.
Różne cwd, czasy, dzienniki runnera i receipts zachowano osobno. Binariów/cache
nie uznano za kryterium semantycznej równości.

Pełne komendy: nadrzędny COMMANDS.log oraz `replay/COMMANDS.log`;
szczegółowe kompilacje `replay/artifacts/kernel_receipts.json`, wykonania
kontroli `replay/checks/commands.json`. Budżety: runner240s, pojedyncze
kompilacje Lean120s/heap2048MiB, RLIMIT_AS8GiB; limity osobnych zadań są w receipts.

Nie uruchamiać ponownie `scripts/replay.py` w zamrożonym W: chroni przed
nadpisaniem istniejącego replay/. Kolejne odtworzenie należy wykonać w nowym,
osobno autoryzowanym katalogu z kopiami przypiętych wejść i skryptów.
Replay sprawdza odtwarzalność **PARTIAL_PROOF**, nie uzupełnia brakującego forward_product.
