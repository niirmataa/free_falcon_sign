# Archiwum danych dudect RUN_001 — przeniesienie 2026-10-19

Powód: wolumin FT1536_DATA (NVMe 232G) osiągnął 100% zajętości
(ENOSPC) — blokada pracy dowodowej (stop-and-report joba 365).
Decyzja właściciela: „trzeba coś zrobić z dudect".

- Źródło (usunięte po weryfikacji): proofs/ft1536/work/
  FT1536_FPEMU_DUDECT_RUN_001/ (katalog ignorowany przez Git,
  historyczny przebieg kampanii dudect RUN_001).
- Nowa lokalizacja (dysk systemowy NVMe 477G):
  /home/footfalcon/archiwum/FT1536_FPEMU_DUDECT_RUN_001/
- Weryfikacja: pełny manifest SHA-256 przed kopią i po kopii —
  751/751 plików zgodnych (rsync -a + porównanie manifestów).
- Manifest: MANIFEST_SOURCE.sha256 w katalogu archiwum,
  SHA-256 manifestu: 4c11635d7645d2d0798d81ec35dfc9e7f9c8bfa07f9bbd7502b6b08dec633567
- Rozmiar archiwum: 60380174700 bajtów.
- Zawartość merytoryczna (RUN.json, RESULT.json, machine_*.json,
  campaign/round-0..3 wraz z kontrolami) zachowana bajt w bajcie.
- Historyczne odwołania w stages/ (np. ORIGINS.json) pozostają
  nietknięte jako proweniencja; niniejszy dokument wskazuje
  aktualną lokalizację danych.
- RUN_002 (zatwierdzony magazyn NVMe w FT1536_DATA) — NIETKNIĘTY.

Wykonał: Główny Koordynator (na polecenie właściciela), 2026-10-19.
