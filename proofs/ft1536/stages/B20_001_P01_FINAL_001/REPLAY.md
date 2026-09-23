# P01 v2 — REPLAY (odtworzenie do NOWEGO DEST; W autora tylko do odczytu)

Naprawia uwagi recenzenta do v1: (a) sterownik/configi/logi replayu są teraz
w pakiecie i pinowane w OUTPUTS.sha256; (b) replay **nie kasuje i nie
odtwarza produktów w W autora** — odtwarza pakiet w nowym katalogu DEST;
(c) snapshot źródeł obejmuje dokładnie pliki obecne w pakiecie, w tym
`aux/Debug.lean` i `aux/RedTest.lean` z opisanymi rolami (aux/README.md).

## Procedura recenzenta (sieć OFF)

```sh
cd /home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P01
python3 tools/restore_replay.py /bezwzględna/nowa/ścieżka/DO/DEST
```

Wymagania: Lean4.34.0 (`…/leanprover--lean4---v4.34.0/bin/lake`), SageMath10.9,
Mathlib4@`5ed2965…` + pakiety git z `build/lake-manifest.json` — immutable
pinned library build jest podpinany przez symlinki **za bramką provenance**
(rev = pin; `FT1536_LIB_ROOT` wskazuje ich lokalizację, domyślnie W autora;
TOOLCHAIN_PINS `library_reuse`). Cała reszta powstaje w DEST.

Skrypt wymaga **nieistniejącego** DEST (fresh); w W autora nic nie kasuje
i nie odtwarza. Weryfikuje to brama czystości: plik-markera przed jobami,
po jobach `find <lib_root> -newer <marker>` musi być puste (zero zapisów do
W autora, także przez symlinki) — wynik w `REPLAY_RESULT.json.pola
author_W_writes`.

## Joby (6, w DEST)

1. `sage run/certificates/gen_sqrt2_certificate.sage` (producer, 21/21)
2. `sage run/certificates/check_certificate.sage` (niezależny checker, 9/9)
   — wyjście przez ENV `FT1536_P01_OUT` (skrypty v2 nie mają wpisanej
   ścieżki W; v1 miał stałą — poprawione)
3. `lake build B20 B20.Foundation.Certificate … FT1536P01` (świeży rebuild
   własnego projektu; biblioteka z cache za bramką rev)
4. `lake env lean aux/RedTest.lean` (probe redukcji kernelowej — patrz
   aux/README.md; wymagany exit 0)
5. `lake env lean run/formal/PrintedTypes.lean` (drukowane typy)
6. `lake env lean run/formal/FT1536P01.lean` (skan aksjomatów)

Każdy job: real argv/cwd, start/stop/elapsed/exit, raw stdout/stderr z
hashami, hashi producentów — `REPLAY_RESULT.json` + `replay/logs/*`
(w pakiecie, pinowane).

## Porównanie semantyczne

`EXPECTED.json` (w pakiecie) pinuje hashe produktów i statystyki axiom scan.
Oczekiwanie: `semantic_match=true`, `sources_unchanged=true`,
`author_W_writes.clean=true`, 6/6 exit=0.

## Ostatnie replaye autora (potwierdzenie naprawy)

- `replay-work/B20_001_P01_RESTORE_A` — zbieranie produktów (tryb bez
  EXPECTED), 6/6 exit=0, author_W_clean; produkty **bajtowo identyczne
  z freeze v1** (`33cf2381…`, `a6c06215…`, `16d4ca49…`).
- `replay-work/B20_001_P01_RESTORE_B` — pełny tryb porównawczy z EXPECTED:
  **semantic_match=true**, 6/6 exit=0, author_W_clean=true. Ten replay jest
  pinowany w `replay/REPLAY_RESULT.json` + `replay/logs/`.

## Uwagi historyczne (v1 — zachowane w W)

- v1 replay_driver.py kasował produkty w W autora (FAILED_ROUTES#18); w v2
  zastąpiony przez `tools/restore_replay.py`; wersja v1 zostaje w
  `run/replay_driver.py` jako ślad historii, nieużywana.
- v1 skrypty `.sage` liczyły W z `__file__` (FAILED_ROUTES#17); v2 używa
  `FT1536_P01_OUT`.
- Surowe ℤ dla liczb certyfikatu (FAILED_ROUTES#15) — bez zmian.
