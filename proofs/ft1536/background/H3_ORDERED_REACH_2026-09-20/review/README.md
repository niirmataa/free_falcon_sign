# Niezależny odbiór INITIAL_TARGETS — 2026-09-20

**PASS: H3_INITIAL_TARGETS_PROVED_FOR_EMITTED_PINNED_MODEL**.
Baza odbioru:f120b86ce57639f3823af6b777b982261ab78d35.

REPORT: `cc44b63bd1c0ea747da2948dcf0487c1819bd25419c294af5a9c0c9ab2bd1a5f`.
OUTPUTS: `d133f9a352eb1cb8264a03dcee827e040eb9eba0647799d7c2c528d06cc6f6d6`.
INITIAL_TARGET_CERTIFICATE:
`89ce68e32fb10a3edd75f182af85843f7ab1e32198e753778d9a96d7dcea51a9`.
Import:798 outputs/202 public inputs,44088568bytes outputs.

```sh
python3 -B proofs/ft1536/tools/archive.py replay FT1536_H3_INITIAL_TARGETS_RUN_001 --run maintainer-replay-001 --timeout 1200 --hide-originals
```

Fresh seed/DEST, brak project cache/olean/bin, network-off, ukryte Dokumenty/H,
zapis tylko do kopii. **219/219 semantic matches, exit0,50.880s**,13 poprawnych
bounded drivers.21 modułów Lean,129 twierdzeń (30 nowych), czyste final logs.

## Co udało się wykazać

Actual target prefix do_sign1849–1892 kończy się defined przed ffSampling_fft3,
dla wszystkich canonical c0..18432 oraz emitted normalized key/legal entry.
Źródłowe t0/t1/ni, kolejność copy/mul/scale i zachowanie wszystkich24576
sk words są związane z literalnym C. Source pin56974571… pozostaje ten sam.

Przejrzano TARGET_FORMULAS, FFT_CHALLENGE_BOUNDS, ERROR_LEDGER, source/memory/
caller binding, TargetWords/Sequence, symbolic checker i kontrole. Parametryczna
FFT recurrence ma nową instancję18432, a nie reuse błędu dla2047. Physical
map1179648 weights i Phi2359296 monomial pairs są odtworzone. NI word
3f0c7161fb1566d0 i jego error403/(18433*2^63) są związane z literal div/of.

Niezależnie przeliczono dokładne Fraction formuły obu error layers:

| target | rounding-only norm/component error | ideal-reference error | source norm/component cap |
|---|---|---|---|
| t0 | <1/8192 | <1/4 | <4829216911 |
| t1 | <1/16777216 | <1/8192 | <2359169 |

Idealne references to eval(-cF/q),eval(cf/q), z exact coefficient NTRU,
bez mod-q/centered substitution lub exact determinant assumption dla rounded
basis. Gram/inverse-evaluation transport dotyczy matematycznej mapy, nie
uruchomienia source iFFT. Zero/cancellation mają absolute error coverage.

Normal C/ASan/UBSan:11 publicznych fixtures, dokładnie te same snapshots i
frame. Independent dyadic oracle8448 complex positions; direct polynomial/
RBF oracle7680 positions. No-op i8 wykonanych value/order mutations zgodnie
z oczekiwaniem,6 invalid preflight stops. Fixtures nie są emitted keys.

## Co nie przeszło i co pozostaje otwarte

Stare ograniczenie FFT1/32768 dla coefficient2047 nie wystarcza dla nowej
recurrence18432. Checker odrzucił tę drogę dowodu; nowy prawidłowy bound
wynosi1/8192. Nie jest to zaobserwowany błąd C.

Frequency majorant t0 przekracza2^31. Nie udało się i nie próbowano przez
samą tę majorantę dowieść NumericCenter późniejszych scalar mu. Nie jest
ona counterexample: initial frequency values i późniejsze centers są
różnymi obiektami. Actual ordered split/merge/residual/error propagation
pozostaje osobnym zadaniem, podobnie jak source iFFT, whole Sign termination
i sampler law. Caller binding jest warunkowy na legalny entry/defined prefix,
bez ukrytego założenia sukcesu wcześniejszych sampling/postprocessing attempts.

## Znaczenie dla projektu i następny krok

Mamy sprawdzone wejście do rekurencji samplera: konkretne source targets,
key/tree frame i użyteczne reference/coefficient-space errors. Następny
obowiązek to ORDERED_REACH→zero-aware NumericCenter przed source2864, przy
rzeczywistej kolejności, normal/fault outcomes i rejection histories.
ZERO_SCALAR może być konsumowany dopiero po ustaleniu jego premise.

Proof kind pozostaje mixed analytical/kernel. Nie zadeklarowano verified
GCC, full C heap, global Reach, law/security albo CT całego Sign. Source
nie zmienione, owner_accepted=false.

## Trwałe receipts

[execution.json](execution.json), [review_checks.json](review_checks.json),
[REPLAY_RESULT.json](REPLAY_RESULT.json) i wszystkie referenced streams.
[VALIDATION.sha256](VALIDATION.sha256):327 plików/35915729bytes, SHA:
`740776902f8f121d14f2a0b695ccf085c735eb1d2da01b4c605a16988051197d`.
README i sam manifest są poza wykazem. Frozen bytes/whitespace zachowano;
nową dokumentację sprawdzono oddzielnie.
