# KAT — piny z rzeczywistego silnika FT1536 (WP-024)

## Pliki

| Plik | Rola |
|---|---|
| `falcon_ternary_logn10_v1.txt` | wektor KAT: seed/nonce/msg → `pkey`, `sig`, `c0` (ternary, `logn = 10`, `q = 18433`) |
| `MANIFEST.txt` | hash `sha256` + `shake256` pliku KAT i 13 pinów `Extra/c` |

## Pochodzenie

Generator `impl/ci/kat/gen_falcon_kat.c` używa publicznego API silnika
(`falcon_keygen`/`falcon_sign`/`falcon_vrfy`) z flagami 1:1 z
`Extra/c/Makefile`. Wejścia są **syntetyczne i publiczne**:

- `keygen_seed = 00…1f` (32 B, `falcon_keygen_set_seed(..., replace=1)`),
- `sign_seed   = 20…3f` (32 B, `falcon_sign_set_seed(..., replace=1)`),
- `nonce       = 40…67` (40 B, `falcon_sign_start_external_nonce`),
- `msg         = 68…87` (32 B).

Systemowe RNG nie jest używane w ogóle; wyjście jest deterministyczne.
Klucz prywatny NIE jest zapisywany — tylko `skey_shake256`.

## Regeneracja / weryfikacja

```sh
cd proofs/ft1536/development/THRESHOLD_P2_001/impl
./ci/kat/run_falcon_kat.sh            # weryfikacja (cmp bajtów + piny silnika)
./ci/kat/run_falcon_kat.sh --update   # tylko po świadomej zmianie silnika/wejść
```

Tryb weryfikacji przebudowuje generator, generuje KAT od zera, porównuje
bajt po bajcie z plikiem w repo i sprawdza wszystkie piny silnika z
`MANIFEST.txt`. Artefakty pośrednie: `impl/.build/kat/` (ignorowane).

## Kto konsumuje piny

- test Rust `crates/ft-threshold-core/tests/kat_pins.rs`:
  integralność KAT, reprodukcja `c0` przez `shake::hash_to_point`,
  digesty/długości/nagłówki pól;
- WP-027 (wire/CBOR): zakotwiczenie formatu `pkey`/`sig` (nagłówki
  `0x8A`/`0xAA`, `FALCON_COMP_STATIC`);
- port sign/verify (WP-040/041): pełny wektor jako oracle różnicowy.

## Granice

- To wektor silnika, nie dowód poprawności silnika ani bezpieczeństwa
  protokołu; silnik jest przypięty hashami, jego status opisują osobne
  etapy (Gate A5, T12.1).
- Wejścia testowe są jawne w repo; nigdy nie podmieniać ich na dane
  operacyjne. Zmiana wejść = nowy plik KAT (wersja `FT-KAT-0x`).
- Zakres: wyłącznie ternary `logn = 10`; inne profile poza pinem.
