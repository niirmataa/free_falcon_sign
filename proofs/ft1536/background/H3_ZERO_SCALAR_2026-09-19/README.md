# Publiczne wejścia H3_ZERO_SCALAR — 2026-09-19

Przypięta projekcja wejść do lokalnego mostu skalarnego uwzględniającego -0.
Baza Git: `cb99e67ae6f7cfa1c79be23d70c8fbfbe6874f13`, po niezależnym odbiorze
H3_RANGE jako `PARTIAL_PROOF`. Źródła mają nadal manifest `2553358f…`.

- `source/`, `CANDIDATE.sha256`: dokładne 17 plików aktywnego kandydata.
- `H3/`: wybrane dokumenty, osiem modułów Lean, audyty i publiczne kontrole
  poprzednika. Jego REPORT/OUTPUTS zachowują zewnętrzne piny. Pozostałe
  skopiowane pliki sprawdzono także jako członków tamtego OUTPUTS.
- `M0/`: kontrakt, interfejs H3 i ledger w historycznej postaci.
- `review/`: niezależny odbiór, execution/review receipts i manifest walidacji.
- `ORIGINS.json`: dokładne ścieżki Git, rozmiary i hashe oryginałów.
- `MANIFEST.sha256`: hash każdego członka tego zestawu, poza samym manifestem.

To wybrane wejścia, **nie pełny snapshot do ponownego uruchamiania starego
replayu**. Historyczne OUTPUTS i VALIDATION zachowują pierwotne bazy.
Przeniesione skrypty są materiałem do jawnej adaptacji w nowym W; stare
założenia dotyczące layoutu należy rozliczyć. Rebuild odziedziczonych Lean
odbywa się ze źródeł. Cały H3_RANGE jest osobno w `stages/` repozytorium.

Byte-identical bootstrap został przygotowany w:
`/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H3_ZERO_SCALAR_RUN_001/inputs/bootstrap/`.
Oryginały i bootstrap pozostają read-only. Nowy wynik ma osobne modele,
raport, manifest i replay. Nie ma zależności wykonawczej od starego W,
Dokumenty/H ani tymczasowego worktree prowadzącego.

Nowe zadanie nie zmienia zamrożonej tezy H3_RANGE ani kontraktu M0. Rozlicza
lokalny zero-aware interfejs i jawne przesłanki przyszłego globalnego użycia.
Autor projektu: Niirmata; zachowano atrybucję źródeł Falcon/Pornin.
