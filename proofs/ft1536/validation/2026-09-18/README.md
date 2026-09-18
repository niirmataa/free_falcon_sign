# Odtworzenie checkpointów z Git — 2026-09-18

Sprawdzony commit: `341d9f7ec0111dfa3d360b378de8f50cd9dcb857`.
Czysty checkout utworzono przez `git worktree add --detach` pod
`/tmp/opencode/ft1536-proof-checkout`.

- `archive.py verify`: pięć checkpointów, wszystkie hashe zgodne;
- osiem testów jednostkowych narzędzia archiwizacji: PASS;
- wszystkie cztery zadeklarowane pełne replaye: PASS.

| Etap | Zachowany werdykt matematyczny | Identyczne pliki znaczeniowe |
|---|---|---:|
| FT1536_LV_STATIC_RUN_001 | COUNTEREXAMPLE_REQUIRED_DOMAIN | 10 |
| FT1536_L_RHO_RUN_001 | L_RHO_PROVED_FOR_PINNED_MODEL | 64 |
| FT1536_L_NTT_RUN_001 | PARTIAL_PROOF | 98 |
| FT1536_L_NTT_GLOBAL_RUN_001 | PARTIAL_PROOF | 103 |

Każdy replay wykonano poleceniem:

```sh
python3 -B proofs/ft1536/tools/archive.py replay ID --run git-replay-001 --hide-originals
```

W sandboxach root był tylko do odczytu, zapis obejmował jedynie świeży seed,
a sieć była odłączona. Oryginalne `/home/footfalcon/Dokumenty` i historyczne H
zastąpiono w namespace procesu pustymi tmpfs. Wyniki pochodzą więc z kopii
zapisanych w Git oraz z zainstalowanego, opisanego toolchainu. Nie są testem
innych wersji GCC/Sage/Lean ani nowym dowodem brakującego forward_product.

Pełne receipts wykonania, wyniki porównania oraz surowe stdout/stderr są
w podkatalogach o nazwach etapów. `VALIDATION.sha256` przypina ich bajty.
Obliczenia/caches pozostały w ignorowanym replay-work czystego checkoutu;
nie stanowią nowych wersjonowanych źródeł dowodu.

Blue pozostaje przypiętą recenzją z zapisanymi kontrolami, bez zadeklarowanego
jednego pełnego runnera. Jego 98 artefaktów i 37 wejść przeszło verify.
