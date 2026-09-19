# FT1536 — GPT-ASTRA: pozostały most L_V

Bieżące zadanie:
`/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_L_V_BRIDGE_2026-09-19.md`.
Identyczna wersjonowana kopia jest w
`/home/footfalcon/free_falcon_sign/proofs/ft1536/documents/`.

Oczekiwany SHA-256 zadania:
`571aaab4ca8d1255bcb649b9e28fb5c3de60e98e9c30d4bb1fdef5a1a9bf4b65`.

Kontynuuj w tej samej rozmowie Astry. Jedyny katalog zapisu obliczeń:
`/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_L_V_BRIDGE_RUN_001`.

Przeczytaj `/home/footfalcon/free_falcon_sign/AGENTS.md` i całe bieżące zadanie.
Potwierdź cwd oraz rzeczywisty sandbox ograniczający zapis do W. Cache, HOME,
TMPDIR, DOT_SAGE, LEAN_PATH, nowe olean i binaria kieruj pod W.

## Przedmiot pracy

- Baza: `stages/FT1536_L_NTT_FORWARD_RUN_001`, commit
  `71bbb358ec59f0e5912b6c324332c1253cfcc7a2`.
- L_RHO i pełne L_NTT są już dowiedzione; konsumuj `L_NTT_rho` i jego
  źródłowe definicje. Nie wracaj do otwartego forward_product.
- `falcon-vrfy.c` kandydata:
  `3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`.
- Nowe obowiązki: centrowanie C i znak Ext0, dokładna norma int64, ścisły B,
  oba dekodery, guards/loader oraz kompozycja pełnego bajtowego L_V.
- `B=2093922385`, sigma=768, pełny ternary secret, uczciwy COMP_STATIC.
  Verify nadal obejmuje NONE i STATIC, bez limitu b do 2049 bajtów.

## Rygor wykonania

- Archiwa stages/, ukończone W, Dokumenty/H oraz Extra/c są read-only.
  Źródłem jest pin powyżej, nie zawartość roboczego Extra/c.
- Nie zmieniaj badanego C ani odziedziczonych modeli w celu ułatwienia tezy.
- Zwróć uwagę na uint32 wrap licznika unary, signed narrowing STATIC,
  rzeczywiste długości dekoderów i int64 akumulator gałęzi ternary.
- Nowe/edytowane Lean: czyste logi, pełne typy i `#print axioms`, bez
  sorry/admit/native_decide lub aksjomatu oczekiwanego wniosku.
- Lean4.34/Std: `-j1 -M2048`, sprawdzony limit pamięci, skończony czas per job.
  Sage10.9 uruchamiaj przez `sage plik.py ...`; zachowaj pełne receipts.
- Bez nowych kluczy, sekretów, instalacji, sieci badawczej i innych agentów.
- Standardowy replay po freeze ma wymagać zewnętrznego hasha OUTPUTS.
- Git/import/commit wykonuje prowadzący sesję po odbiorze. Zachowaj
  `source_integrated=false`, `owner_accepted=false`. `full_L_V_proved=true`
  wolno nadać tylko po domknięciu całego wskazanego celu dla tego kandydata.

Ten plik jest instrukcją startową, nie wynikiem ani akceptacją zadania.
