# Niezależny odbiór H3_ZERO_SCALAR — 2026-09-19

**PASS: H3_ZERO_SCALAR_PROVED_FOR_PINNED_MODEL**, z zachowaniem mieszanego
zakresu: Lean oraz uniwersalny analityczny dowód związany ze źródłem.

Baza odbioru: `c6ed7808fe2f1305eac2a6a3c6ab4109e9615ea3`.
REPORT: `d7e59a782a3b89bf7adfe1bc0894595a18e907a11019e557ecd55d588befaec8`.
OUTPUTS: `599b33ccaefb5109cf1ce25c2cd4cc639abb4330ea05e89f3537cf86d57900ab`.
Import sprawdził 510 członków OUTPUTS i 77 publicznych wejść INPUTS.

## Niezależne wykonanie

```sh
python3 -B proofs/ft1536/tools/archive.py replay FT1536_H3_ZERO_SCALAR_RUN_001 --run maintainer-replay-001 --timeout 1200 --hide-originals
```

Świeża kopia, brak odziedziczonych olean/bin/cache, Dokumenty/H ukryte,
sieć odłączona, zapis tylko w kopii roboczej. Exit0, 28.077 s, **95/95
zgodnych plików znaczeniowych**. Powiązanie sprawdzono z zamrożonym receipt.

- 17 modułów Lean4.34/Std, 97 twierdzeń, w tym 48 nowych; czyste finalne logi.
- Sześć odziedziczonych modułów identycznych z H3_RANGE, przebudowanych.
- C normal i ASan/UBSan: 246 słów, 1160 par w domenie; 70 par spoza domeny
  zatrzymanych przed potencjalnie nielegalnym sumowaniem.
- 3480 kontroli faz dodawania, w tym 28 underflow i 383 zero-mantissa branches.
- Niezależny exact-dyadic oracle, literalny model i wartości Lean zgodne.
- Certyfikat: 64 rangi normalizera, 8 klas rounding, 32 rangi signed32
  oraz 60135 klas exponent/shift; ułamki objęte uniwersalnymi nierównościami.

[Execution](execution.json), [review checks](review_checks.json),
[formal audit](artifacts/formal_audit.json), [replay result](REPLAY_RESULT.json).
Wszystkie strumienie wskazane przez receipts i drivery są sprawdzone
hashami i zachowane pod względnymi ścieżkami; toolchain ma streams inline.
[VALIDATION.sha256](VALIDATION.sha256) obejmuje 101 plików, SHA-256:
`d919df88c7d74bf57175ac4dd8b2bbe9303ebffe9266f70defd25d861a90f87a`.

## Sprawdzony zakres matematyczny

Przejrzano [ANALYTIC_PROOF](../../stages/FT1536_H3_ZERO_SCALAR_RUN_001/ANALYTIC_PROOF.md),
SHA-256 `579b8614c249dc2f1a6938d600f6b234e85ef6a441ef922bde5570e304d93918`,
literalny/source-normalized model i aktywne C of/add/sub/pack.

1. `NumericCenter` używa niezależnego val finite słowa, także obu zer
   i subnormals. Exponent<=1053 wyprowadzono przed konsumpcją starego floor.
2. Kernelowe floor/cast/s+z obejmuje wyjątek eps0 dokładnie dla raw -0.
   Dokładna konwersja `fpr_of` dotyczy wszystkich odpowiednich signed32.
3. W dowodzie add wejścia mają encoded exponents<=1054. Wewnętrzny decode
   subnormal ma połowę jego wartości; ten błąd jest jawnie policzony.
   Alignment <=lambda, shrink <=4lambda, pack <=8lambda lub jawny underflow;
   lambda<=2^-24. Dokładnie `13*2^-24+2^-1021 < 2^-20`.
4. Finiteness wyniku i przypadki r/delta są rozliczone osobno. Sam mały
   błąd nie implikuje [0,1]. Case split obejmuje cancellation, oba zera,
   normal/subnormal oraz endpoint1 także dla małego ujemnego niezerowego x.
5. Zamknięte rho∈[0,1] nadal daje exact residual<=366. Po source-error
   bridge rzeczywiste residuum ma moduł <=366+2^-20.

**Pełna kompozycja SOURCE_ADD_ERROR oraz analiza r/delta są analityczne.**
Lean `CONSUME_SUB_RESIDUAL` jawnie przyjmuje kontrakt rozliczony w tym
analitycznym dowodzie; nie jest samodzielnym kernelowym dowodem całego add.
Reprodukowanie tekstu dowodu i skończonych kontroli nie zastępuje analizy
uniwersalnej. Kernel/model/analytical/source binding zachowują własne zakresy.

Globalne `Reach_call_C -> NumericCenter`, wewnętrzne LDL, FFT/split/merge
i konsumpcja prawa samplera pozostają otwarte. Historyczne H3_RANGE z
mathematical-floor equality ma własną tezę. `H3_range_proved=false`,
`global_reachability_proved=false`, `sampler_law_proved=false`,
`security_reduction_proved=false`; odbiór nie nadaje owner acceptance.

Źródła aktywnego kandydata zachowują manifest `2553358f…`.
Historyczny whitespace w przypiętych kopiach i końcowe puste wiersze logów
pozostają bajtowo zachowane; nowa dokumentacja jest sprawdzana osobno.
