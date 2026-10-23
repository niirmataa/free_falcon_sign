# Migracja spiku T-THRESHOLD do development (2026-10-23)

**Źródło (zamrożone, nietknięte):** `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/`
**Cel (trackowany):** `proofs/ft1536/development/THRESHOLD_SPIKE_001/`
**Decyzja:** właściciela, 2026-10-23 („przenosimy i uruchamiamy machine dla
spika do development, bo trzeba kommitować").

## Co przeniesiono (93 pliki, ~2,0 MB)
- `spike/` — kompletne źródła: `src/`, `tests/`, `Cargo.toml`(+lock),
  notatki pakietów (MPS_*, Y*, X*, P*, U*, W*, BOUNDARY_*, TESTS.md itd.)
- dokumenty W: INVENTORY, DESIGN, RESEARCH, REPORT, FAILURES, TODO,
  PACKAGE_INDEX

## Czego NIE przeniesiono (zostaje w W jako artefakty robocze)
- `spike/target/` (1,3 GB), `spike/iso-tmp/` (4,4 GB),
  `spike/.cargo-home/` (27 MB), `.mimocode/` — build cache i eksperymenty
  procesowe; odtwarzalne przez `cargo`, nie są materiałem źródłowym.

## Zasady od teraz
- Rozwój spiku (SEC-FIX, G2/T6, MPS) prowadzi się TU, małymi commitami
  z dokładnymi pathspecami; W źródłowe jest proweniencją (read-only).
- Statusy pozostają: SPIKE/PROTOTYP — nie threshold FT, nie produkt.
- Retained findings (z wewnętrznego audytu bezpieczeństwa i z akt) idą
  do `FAILURES.md` / rejestru — naprawy jako jasne commity, suplementy
  zamiast nadpisywać. Audyt wewnętrzny pozostaje materiałem wewnętrznym.
