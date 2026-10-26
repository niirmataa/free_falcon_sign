# WP-023 — differential Rust vs silnik FT1536

Ten katalog zawiera **harness pomiarowy**, nie kod protokołu. Cel: wykazać
bajtową zgodność prymitywów Rust (`ft-threshold-core`) z silnikiem C
(`Extra/c`) dla profilu ternary, `logn = 10`, `q = 18433`, `N = 1536`.

## Pliki

| Plik | Rola |
|---|---|
| `probe_engine.c` | harness C: `#include "falcon-vrfy.c"` (dostęp do `static` NTT) + `falcon_hash_to_point` z `falcon-enc.c` |
| `run.py` | buduje C, uruchamia C i Rust, porównuje pliki bajt po bajcie, zapisuje `run_summary.txt` |
| `PIN_2026-10-26.txt` | pin wyniku i wejść (silnik + harness); ważny tylko dla podanych hashy |

Program Rust to
`impl/crates/ft-threshold-core/examples/engine_diff_probe.rs`.

## Uruchomienie

```sh
cd proofs/ft1536/development/THRESHOLD_P2_001/impl
python3 ci/engine_diff/run.py --cases 10000
```

Szybki dym: `python3 ci/engine_diff/run.py --cases 3`.

Wszystkie artefakty (binaria, `engine.bin`, `rust.bin`, `run_summary.txt`)
trafiają do `impl/.build/engine_diff/` (ignorowane przez Git). Skrypt nie
korzysta z sieci; Cargo działa z `--offline`. Wymagany kompilator C
(`cc`) i pełne źródła silnika w `Extra/c/` w tym samym checkoucie.

## Format pliku

```
offset 0   8 B   magic "FTDIF01\0"
offset 8   4 B   version = 1 (LE)
offset 12  4 B   n = 1536
offset 16  4 B   q = 18433
offset 20  4 B   cases per kind
offset 24  4 B   kinds = 4
offset 28  8 B   seed
offset 36  ...   32 B × kinds × cases: SHAKE256(output)
```

Kategorie (`kind`): `hash_to_point`, `ntt`, `intt`, `mul` (mnożenie w `R_q`
ścieżką NTT: NTT, `montymul`, ×`R²`, iNTT). Każdy wynik jest serializowany
jako `N` wartości `u16` little-endian i haszowany SHAKE256 (capacity 512,
czyli standardowy SHAKE256).

Wejścia są generowane deterministycznie przez xorshift64 o ziarnie
`0x9e3779b97f4a7c15`; każda kategoria ma własne ziarno
`seed ^ (0xd1b54a32d192ed03 · kind)`. Kolejność pobierania współczynników
jest identyczna w C i Rust: dla `mul` najpierw całe `a`, potem całe `b`.

## Pułapki (zachowane, bo kosztowały czas)

1. **SHAKE capacity.** `falcon_hash_to_point` w silniku jest wołany po
   `shake_init(&sc, 512)` (standardowy SHAKE256, rate 136 B). Inicjalizacja
   `shake_init(&sc, 256)` daje SHAKE128 i inne wektory — to błąd harnessu,
   nie rozjazd implementacji. Harness używa 512 i to jest zgodne z
   `falcon_vrfy_start`.
2. **Kolejność generowania wejść.** C początkowo przeplatał współczynniki
   `a` i `b` w kategorii `mul`, a Rust pobierał najpierw całe `a`. Ten sam
   generator, inna kolejność → różne wielomiany i fałszywy rozjazd.
   Harness ma teraz jawną kolejność i to jest część kontraktu formatu.
3. **`#include "falcon-vrfy.c"`.** Potrzebne, bo `mq_NTT_ternary` i
   `mq_mkgm3` są `static`. Linkowanie z `--gc-sections` odcina nieużywane
   funkcje i ich zależności (`fpr`, keygen, sign). Nie kopiujemy kodu
   silnika — kompilujemy jego rzeczywiste źródło.

## Zakres i granice

- Porównywane: `hash_to_point`, NTT ternarna, iNTT ternarna, mnożenie w
  `R_q` ścieżką NTT, dla `logn = 10`.
- Nieporównywane: FFT/`ffSampling`, sampler Kleina/Gaussa, keygen, sign,
  verify, norm check, wire/CBOR, ścieżki binarne `q = 12289`, inne `logn`.
- To nie jest dowód kryptograficzny ani niezależny odbiór. Zgodność
  bajtowa z silnikiem nie mówi, że silnik jest poprawny ani że protokół
  jest bezpieczny.
- Pin w `PIN_2026-10-26.txt` wiąże wynik z konkretnymi bajtami silnika
  i harnessu; zmiana któregokolwiek z nich wymaga nowego przebiegu i
  nowego pinu.
