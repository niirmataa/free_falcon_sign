# SBOM THRESHOLD_P2_001 — inwentarz zablokowanych zależności (WP-026)

## Co to jest

`sbom_v1.txt` jest wyprowadzany **wprost z `Cargo.lock`** (nie przez
`cargo metadata`, które przy `--frozen` offline chce pobierać manifesty
niewykorzystywanych wpisów, np. opcjonalnego backendu `fiat-crypto`).
Format: `name | version | source | checksum`, sortowanie po
(name, version) — plik jest deterministyczny i przypięty w repo.

## Zakres

- **W środku:** pełny zablokowany inwentarz (33 pakiety: 7 crate'ów
  workspace'u + zależności z checksumami rejestru).
- **Świadomie poza SBOM:** licencje (sprawdza je `cargo deny check
  --offline` — osobny krok CI) i wersje toolchaina (`rust-toolchain.toml`
  + dowód WP-026), bo one zmieniają się niezależnie od grafu zależności.

## Regeneracja / weryfikacja

```sh
cd proofs/ft1536/development/THRESHOLD_P2_001/impl
./ci/repro_build.sh            # podwójny build + cmp SBOM z pinem
./ci/repro_build.sh --update   # po świadomej zmianie Cargo.lock
```

Zmiana zależności bez `--update` = FAIL w CI (rozjazd SBOM z pinem).

## Granice

- SBOM z locka to inwentarz wersji, nie analiza pochodzenia
  (provenance) poza checksum rejestru — to poza zakresem G1.
- Reproducibility dotyczy podwójnego buildu w tym samym checkoucie
  (kryterium G1 „dwa buildy = ten sam hash"); odtwarzalność
  międzykomputerowa wymaga dodatkowo remap-path-prefix — patrz dowód
  WP-026, sekcja granic.
