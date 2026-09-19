# Publiczne wejścia H3_NODE2 — 2026-09-19

Baza Git: `afa52d89be2f21208ac3135e74a1a60fc66d52c4`, po niezależnym
odbiorze H3_NODE3. Nowy etap dotyczy pierwszego split_deep(logn9), Adj
i LDL_dim2(logn8,full0) dla sześciu source diagonal branches, po128 slots.

- `source/`, `CANDIDATE.sha256`: dokładne 17 źródeł aktywnego kandydata.
- `NODE3/`: certyfikat c3, NEXT_INTERFACE, pełna analityczna kompozycja,
  dataflow/frame, formalne źródła, certyfikaty i wybrane kontrolery.
- `ROOT/`: powiązane determinantowe/Gram bounds i źródłowe fazy korzenia,
  przydatne do ewentualnego udowodnionego zaostrzenia imaginary envelope.
- `ZERO/`, `H3/`: poprzednie interfejsy i jawna diagnostyka FPEMU,
  w tym underflow/half; własne dziedziny nie są automatycznie rozszerzane.
- `M0/`: ten sam profil, emitted-KeyGen support i operacyjny kontrakt gry.
- `legacy/`: dokładny algebraiczny binary/ternary bridge jako materiał reuse.
- `review/`: niezależny odbiór NODE3 i kotwica receipts.

ORIGINS zawiera publiczne `git:<commit>:<path>`, rozmiary i hashe.
Wybrane członki etapów sprawdzono względem ich OUTPUTS; legacy także wobec
wcześniejszego MANIFEST. Bieżący MANIFEST obejmuje cały ten zestaw poza sobą.
Inne manifesty zachowują swoje pierwotne bazy.

To projekcja wejść, nie pełne stare replay tree. Kontrolery wymagające
starego layoutu adaptuje się w W z pinami/diffami. Oryginałów i bootstrapu
nie uruchamia się in-place. Gotowa identyczna kopia:
`/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H3_NODE2_RUN_001/inputs/bootstrap/`.

Należy zachować source-to-H oraz real/imag correlations między parowanymi
slots, rozliczyć faktyczny fpr_half i nowy pivot przed dalszą konsumpcją.
Ewentualne zaostrzenie upstream bounds jest nowym wynikiem w nowym W,
z zachowaniem historycznych certyfikatów. Ten etap nie jest dowodem całej
niższej rekurencji, initial targets, global Reach albo prawa samplera.

Autor projektu: Niirmata; zachowano atrybucje Falcon/Pornin.
