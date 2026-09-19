# Publiczne wejścia H3_ROOT_LDL — 2026-09-19

Baza Git: `9a76ecfd72d83e131d79299f0249bca1efdf9468`, po niezależnym
odbiorze H3_ZERO_SCALAR. Nowy etap dotyczy źródłowego korzenia LDL:
FFT klucza, Gram i rzeczywista subtractive operacja 2x2.

- `source/`, `CANDIDATE.sha256`: 17 dokładnych źródeł aktywnego kandydata.
- `ZERO/`: lokalny zero-aware wynik, mieszany dowód of/sub, formalne źródła,
  audyty i wybrane kontrolery. E=2^-20 ma własną domenę exponent<=1054.
- `H3/`: operacyjna osiągalność, ledger braków, dokładne tożsamości
  Schur/NTRU i wcześniejszy świadek niewystarczalności samych liści.
- `M0/`: profil i interfejs gry z pełnym emitted-KeyGen support.
- `legacy/`: publiczny historyczny wycinek H3/H4/T5 z wcześniejszego
  zestawu H3_RANGE. Zachowuje własne dziedziny i statusy; dawnego założenia
  complete-IEEE nie przenosi się bez dowodu domeny do obecnego backendu.
- `review/`: niezależny odbiór ZERO i kotwica receipts.

ORIGINS zawiera ścieżki `git:<commit>:<path>`, rozmiary i hashe. Wszystkie
wybrane członki etapów sprawdzono wobec ich przypiętych OUTPUTS; historyczny
wycinek także wobec wcześniejszego MANIFEST. MANIFEST tego zestawu obejmuje
wszystkie pliki poza samym sobą. Oryginalne manifesty zachowują własne bazy.

To projekcja wejść, nie pełne stare replay tree. Skrypty są materiałem do
jawnej adaptacji w nowym W, z pinami/diffami. Kopii nie uruchamia się in-place.
Bootstrap nie wymaga dawnego W, Dokumenty/H/USB ani worktree prowadzącego.
Gotowa kopia znajduje się w:
`/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H3_ROOT_LDL_RUN_001/inputs/bootstrap/`.

Zadanie ma własny, ograniczony do korzenia zakres. Całe wewnętrzne drzewo,
initial targets i globalne Reach→NumericCenter mają dalsze obowiązki.
Autor projektu: Niirmata; atrybucje Falcon/Pornin pozostają zachowane.
