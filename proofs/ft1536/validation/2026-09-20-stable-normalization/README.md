# Niezależny odbiór STABLE_NORMALIZATION — 2026-09-20

**PASS: H3_STABLE_NORMALIZATION_PROVED_FOR_EMITTED_PINNED_MODEL**.
Baza odbioru:e52fffc5b4a92658a6740428d1e228adf3d0893f.

REPORT: `ba2b455711b9a3d4241f70637ee0529f4c2d59df37d23eec55d262cf714c26dd`.
OUTPUTS: `c383e4bb9a8acf045c39aa1e3114ce5da95f4fef0c08c6630012c4e42db6a333`.
NORMALIZED_EXPANSION_CERTIFICATE:
`8d8161d1a096038f6f2811cff6318b0c7361376cf734cdc9d092b3deabd7c778`.
Import:1119 outputs/276 public inputs,74573541bytes outputs.

```sh
python3 -B proofs/ft1536/tools/archive.py replay FT1536_H3_STABLE_NORMALIZATION_RUN_001 --run maintainer-replay-001 --timeout 1200 --hide-originals
```

Fresh seed/DEST, bez dawnych binaries/olean/cache, sieć wyłączona, Dokumenty/H
ukryte, zapis tylko do kopii. **262/262 semantic matches, exit0,55.531s**.
Wszystkie13 bounded drivers zakończyły się poprawnie.

## Odbiór argumentu i zakres

Przejrzano DOMAIN_AUDIT, EMITTED_STABLE_BINDING, NORMALIZATION,
SQRT_DIV_CONTRACT, SOURCE_MODEL_BINDING i MEMORY_FRAME oraz nowe StableBits,
Sqrt54/SqrtPack, source/width/map/mutation checkery. Source add wyciąga znaki
i mantissy po swap; jego sign0 residual rzeczywiście dostaje tę samą ordered
pair. Neg/square invariance obejmuje payload fields/zero cases. Siedem source
helpers/scans jest związanych po zmianie nazw, nie tylko idealnym wzorem.

Mandatory certificate finalnego successful KeyGen attemptu jest wymagany
przed break i obiema serializacjami. Sticky bad i inclusive bit gate pozwalają
przenieść tę już istniejącą akceptację do signera. P_key i K_seed conditioning
nie zostały wzmocnione.

- All-P_key computation/definedness, sequence/frame i source return=gate
  Boolean: proved w zadeklarowanym mixed modelu.
- **All-P_key narrow gate acceptance: OPEN_NOT_DISPROVED**.
- Dla Emitted/same-STATIC-decode/legal buffers: actual stable_ok,1536 stored
  widths, count1536/18432 i internal load_skey return1. Publiczne API/malloc
  nie stają się nieomylne.

Sqrt54: bracket/remainder, integer ranges/unsigned trial i final54th bit
sprawdzono kernelowo; pack-value lemma ponownie dowiedziono dla nowego zakresu.
Error≤2^-52 dotyczy positive NORMAL inputs, nie całego IEEE/subnormals.
Nowy div domain finite |x|≤2^100,y positive normal[2^-16,2^80] ma osobny
exponent/underflow bridge. Normalize pozostaje unconditional także po false gate.

Niezależnie przeliczono exact Fraction formuły z gate endpoints i source
error budgets: stored sigma²∈(1.7763,575.9999), paired∈(2.3684,767.9999),
literal dss obu klas>1/1536>actual last coefficient. Nie wykorzystano starego
legacy-H4 RN/fpr-double założenia jako proofu FPEMU. Sigma-only consumer nie
dowodzi wcześniejszego floor/cast/residual(mu), globalnego Reach lub prawa samplera.

## Kontrole odtworzone

-40 modułów Lean,230 twierdzeń,50 nowych;31 inherited modules, czyste final logs.
-40930 sqrt words,4096 Lean q/remainder checks,117 div pairs,196 bit-identity
  pairs,24 gate cases i1033 width/dss cases.
- Normal C i ASan/UBSan: dokładnie te same outputs;8 pełnych publicznych
  pipelines, w tym3 rejected stable scans nadal wykonujące normalization.
- Wszystkie1536 stored leaves,16896 internal L i6144 basis words; normalizer
  bijection i structural3072 width uses, reverse physical leaf order,
  paired-first/stored-second. Legal tmp reuse/high-water3072 jest rozliczony.
- No-op i8 model/scalar mutations zgodnie z oczekiwaniem;4 invalid-domain
  preflight stops. LSan nie deklarowano. Fixtures nie są emitted keys.

Proof jest mieszany analityczno-kernelowy: source normalization/heap/GCC nie
są w całości kernelized. Źródła pin56974571… nie zmieniły się; nie wykonano
nowej integracji do Extra/c, a owner_accepted=false.

## Receipts i następne typy

[execution.json](execution.json), [review_checks.json](review_checks.json),
[REPLAY_RESULT.json](REPLAY_RESULT.json) i wszystkie referenced streams.
[VALIDATION.sha256](VALIDATION.sha256):409 plików/62145386bytes, SHA:
`5c3b97d4beac2c276e02e9c955d9de78b82addec3223d9b3a7ef27c34deef4ff`.
README i sam manifest są poza wykazem. Historyczne bytes/whitespace zachowano.

Najbliższy osobny cel to INITIAL_TARGETS: canonical c, actual FFT3/basis/
inverse(q), bitowe targets i uniform domains/errors przed ffSampling_fft3.
ORDERED_REACH→NumericCenter, sampler law i pełne bezpieczeństwo pozostają
odrębne; initial frequency bounds nie mogą zostać utożsamione z scalar mu.
