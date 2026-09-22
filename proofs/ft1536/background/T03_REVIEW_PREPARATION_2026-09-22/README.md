# T03 — przygotowanie niezależnego odbioru handoffu autora

2026-09-22. **FROZEN_AWAITING_REVIEW**, author status `PARTIAL_PROOF`.
To kontrola bajtów/ścieżek i kopia zapisanych receiptów, bez wykonania nowego
rachunku, replayu lub odbioru matematycznego przez prowadzącego.

SOURCE_W: `proofs/ft1536/work/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001`.
Zewnętrzne piny przekazane przez właściciela:

- REPORT: `e01a09789091c9c9322f9727263503063c94441a68ff5f30af952bcc4417785c`.
- OUTPUTS: `0cafdbb2c746043380081052951cb6438643f6a1765a98028a065fa57b7df6de`.

`PREPARATION.json` zapisuje kontrolę wszystkich85 członków OUTPUTS,
1275 członków bootstrapu,17 źródeł i byte-binding11 wyników zapisanych
w autorskim `tmp/postfreeze-003`. `author_postfreeze_receipts/` zachowuje
trzy oryginalne receipty z tego DEST; nie należą do głównego OUTPUTS autora.
Ich nowe piny dokumentują kopię prowadzącego, nie niezależne wykonanie.

## Punkty wymagające rozliczenia przez recenzenta

1. INPUTS ma29 wpisów:28 istniejących ścieżek jest zgodnych; nazwa
   `TASK_DOCUMENT_provenance` nie wskazuje istniejącego pliku w SOURCE_W.
   Zgodny hash ma kanoniczne zlecenie w documents/. Wymagane jawne mapowanie
   pochodzenia; nie poprawiono manifestu autora ani nie wykonano importu etapu.
2. Porównanie manifestów v3 i v4 wskazuje17 dawnych ścieżek o zmienionym
   hashu lub bez tej samej ścieżki w v4 (w tym przeniesione skrypty).
   Wszystkie pięć regenerowanych wyników checks było w v3 i zmieniło hash.
   Cztery zachowane py_crosscheck JSON mają zgodne piny v3. Nie potwierdza to
   zachowania całego starego freeze. Zachowany receipt v3 dotyczy dawnej wersji.
3. `checks/z_map_full.json` ma inny hash w v3 i v4. Autor deklaruje zgodność
   wierszy tabeli; zgodność całego pliku bajtowo wymaga odrębnego rozliczenia.
4. Receipt SAGE_RUNS zapisuje cztery argv `sage checks/sage/*.sage`,exit0,
   wersję10.9 i zgodne hashe skryptów. Ocena treści rachunku i własny fresh
   replay należą do niezależnego recenzenta.

Prowadzący zachował także własny błąd rozwiązywania ścieżki CANDIDATE podczas
pierwszej kontroli odczytowej; poprawiona baza to `inputs/bootstrap/source`.
Nie był to failure kodu autora. Szczegóły w PREPARATION.json.

`MANIFEST.sha256` przypina tę notatkę, kontrolę i trzy kopie receiptów.
Te materiały nie podnoszą A/C do REVIEWED i nie domykają otwartego B-gap.
