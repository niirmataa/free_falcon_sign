# Niezależny odbiór audytu FPEMU — 2026-09-20

**Replay i odbiór PASS; wynik audytu: CONFIRMED_ISSUE w zadeklarowanym
wąskim zakresie F01/F02.** Potwierdzono generic numeric comparison issue
i operand-dependent compiled floor branch. Nie zmierzono timing leakage
i nie wykazano required emitted-domain counterexample.

Baza odbioru: `24f925ef63e5f9eede54c4d12d3c1f695678640a`.
REPORT: `420aedb41ad7a7bdf09c7af161e82fdaaa567fd339a25dac61d2ef6c833c5ede`.
OUTPUTS: `a20122da1d1bcca66f3c76d3590d14d46cc2342753691e544cebfd50bc930e41`.
Import sprawdził 647 członków OUTPUTS i 128 publicznych records INPUTS.

## Niezależny replay

```sh
python3 -B proofs/ft1536/tools/archive.py replay FT1536_FPEMU_AUDIT_RUN_001 --run maintainer-replay-001 --timeout 1200 --hide-originals
```

Świeża kopia, bez wcześniejszych binariów/olean/cache, ukryte Dokumenty/H,
sieć odłączona, zapis tylko w kopii roboczej. Exit0, 41.250 s,
**29/29 plików znaczeniowych zgodnych** z zamrożonym receipt; 12 bounded
steps i 61 nested jobs. Kompilacje C/ASan/Lean i assembly wykonano ponownie.

- 140225 scalar cases i 250 actual-delta cases na każdy tryb normal/ASan+UBSan;
  pełne wyniki bajtowo identyczne, z jawną klasyfikacją znalezionego F01.
- 12 smoke checks na tryb, 8192 słowa tablic, 1022 niezależne pary RBF,
  11 fixed constants, 7 oracle anchors i 4 changed-value controls.
- 29 historycznych modułów Lean przebudowano czysto; bez nowych plików Lean
  i bez deklarowania pełnego replayu poprzednich etapów lub nowego full proof.
- 4 oryginalne translation units oraz wrappers skompilowano do analizy;
  KeyGen/private loader/Sign nie były wykonywane.
- Dudect/ctgrind **NOT_RUN**; rzeczywistych timing samples: **0**.

[Execution](execution.json), [review checks](review_checks.json),
[replay result](REPLAY_RESULT.json). Wszystkie streams wskazane przez
bounded/nested/driver receipts sprawdzono SHA-256 i zachowano. Binaries
sprawdzono według fresh build receipts; roboczych binariów nie archiwizuje
się tutaj. ASan binary hash może różnić się przy relokacji debug paths.

[VALIDATION.sha256](VALIDATION.sha256) obejmuje 272 pliki, w tym
[CURRENT_IMPACT](CURRENT_IMPACT.md). SHA-256 manifestu:
`20ab597ddc08348da8ada248fc8f7995538e514c6f352509637c37fe14378e59`.

## F01 — dokładne signed-zero porównanie

Sprawdzono source `internal.h:281-282`, `fpr-emulated.h:195-206` i
[odtworzony reproducer](artifacts/oracle_controls.json). Dla raw x=-0,
y=+0: sx=-2^63, sy=0, cc0=1, cc1=0, wspólny sign bit=0, więc wynik C to1,
podczas gdy val(x)=val(y)=0. Normal i sanitizer reproducer dają ten sam wynik.

To naruszenie ogólnego liczbowego odczytania kontraktu `<`. Nie wykazano
takiej pary w lokalnych porównaniach Gate00/selector, gdzie druga strona
jest dodatnią niezerową stałą. Nie jest to obalenie ZERO/ROOT/NODE3 lub
świadectwo forgery. Szczegóły zachowuje [FINDINGS](FINDINGS.json).

## F02 — gałąź istnieje także w oryginalnym Sign TU

Przejrzano odtworzony [objdump](artifacts/disassembly.txt), nie tylko opis
w raporcie. Audit_floor wyciąga exponent przez shift52/mask2047, odejmuje
1022 i wykonuje `js`. Dla finite words jest to test |x|<1/2.

Ten sam dataflow potwierdzono w oryginalnych BerExp oraz sampler_large:
[production assembly receipt](artifacts/production_asm.json),
[pełny falcon-sign.s](artifacts/falcon-sign.s). W sampler_large instrukcje
`subl $1022`/`js` są związane z source floor bezpośrednio przed sign:2864.
GCC14.2 i faktyczne Makefile `-O` są związane build receipts i hashami.

To dowód zmiennego branch trace dla legalnych scalar operands, a nie pomiar
rozmiaru wycieku, dowód dwóch emitted histories lub ataku odzyskania klucza.
Komentarz „CT-safe” i CT_BEREXP nie dają ogólnej gwarancji fixed trace.

## Konsumpcja i otwarte obowiązki

Nowa [ocena bieżącego wpływu](CURRENT_IMPACT.md) rozlicza późniejszy NODE2
i przygotowane BINARY_TOWER. Nie wskazano naruszonego konsumowanego kontraktu
arytmetycznego, które wymagałoby zatrzymania tej pracy. NODE2 ma już własny
finite-word half proof; div/caller domains kolejnych poziomów pozostają
obowiązkami indukcji. Audyt zachowuje swój starszy snapshot bez przepisywania.

F06 dotyczy braku whole-domain exponential certificate w wybranej projekcji
audytu, nie stwierdzenia nieistnienia historycznego dowodu. Sqrt/rint, full
caller reachability, Sign-law i CT mają własne dalsze obowiązki.

Źródła aktywnego kandydata są identyczne z audytowanymi 17 plikami.
source_changed=false, owner_accepted=false, global_FPEMU_proved=false,
global_CT_proved=false, security_reduction_proved=false. Ten checkpoint
zapisuje findings i odbiór; nie integruje poprawki implementacji.

Przypięte pliki/slices i raw logs zachowano bajtowo. Nową dokumentację
sprawdzono osobno od whitespace w zamrożonych artefaktach.
