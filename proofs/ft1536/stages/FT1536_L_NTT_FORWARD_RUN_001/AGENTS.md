# FT1536 — GPT-ASTRA: FORWARD_CRT i domknięcie L_NTT

Aktualne zlecenie:

`/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_L_NTT_FORWARD_2026-09-18.md`.

Jego identyczna, wersjonowana kopia jest w
`/home/footfalcon/free_falcon_sign/proofs/ft1536/documents/`.

## Bieżący etap

Kontynuuj w tej samej rozmowie Astry. Nowy i jedyny katalog zapisu obliczeń:

`/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_L_NTT_FORWARD_RUN_001`.

Przeczytaj `/home/footfalcon/free_falcon_sign/AGENTS.md`. Ustaw rzeczywisty
sandbox i cwd na powyższy W, nie na całe repo. Cache, HOME, TMPDIR, DOT_SAGE,
LEAN_PATH i nowe wyjścia kompilacji kieruj pod W.

Baza to zamrożony checkpoint:

`/home/footfalcon/free_falcon_sign/proofs/ft1536/stages/FT1536_L_NTT_GLOBAL_RUN_001`.

Źródło falcon-vrfy.c ma hash
`3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`.
Globalny inverse, prefiksy pętli, canonical range i lift są już dowiedzione.
Konsumuj te wyniki. Otwarty cel to interpretacja forward przez CRT,
forward_product i zastosowanie istniejącego Pipeline.L_NTT_pending_forward.

## Zasady

- `Extra/c` pozostaje ścieżką źródeł projektu, FT1536 profilem/buildem.
  Badana wersja tego zadania jest jednak wskazana pinem checkpointu.
- Archiwa stages/, obiekty wejściowe, dawne Dokumenty/H i inne katalogi
  wykonawców są tylko do odczytu. Kopię source/ w W zachowaj bajtowo.
- Nie zmieniaj definicji forwardC/inverseC/pipelineC w celu ułatwienia tezy.
  Modele źródłowe i udowodniony inverse mają pozostać konsumowanymi obiektami.
- Nowe i edytowane pliki Lean mają budować się z czystym logiem, bez
  wyciszania ostrzeżeń. Pokaż pełne typy tez i `#print axioms`.
- Korzystaj z Lean4.34/Std i Sage10.9 przez `sage plik.py ...`.
  Zachowaj sprawdzony tryb Lean `-j1 -M2048` i wystarczający budżet
  address space (8GiB w poprzednim zadaniu).
- Bez nowych kluczy, sekretów, instalacji, sieci badawczej i innych agentów.
- Git obsługuje obecnie prowadzący sesję: po Twoim freeze i raporcie
  zaimportuje checkpoint, sprawdzi go i zrobi osobny commit na docelowy main.
  Nie wykonuj równoległych zapisów do indeksu lub archiwów repo.

Ten plik jest instrukcją startową, nie wynikiem zadania.
