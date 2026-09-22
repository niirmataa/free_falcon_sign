# Source/model binding STABLE_NORMALIZATION

Źródła są dokładnym17-file candidate pin56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985,
BASEa53d7231795fb5c7317bc836baaf0ccd3ec2652f. No source modifications.
GCC14.2.0-19/C99/LP64, literalne Makefile -O/macros; portable FPEMU i disabled
FT_SAMPLER_ADAPTIVE_PROBE potwierdzone active preprocessing.

| Source | Binding |
|---|---|
|fpr-emulated.c449–553|source add sort prefix i residual body; sign0 bit commutativity|
|fpr-emulated.c mul / div portable bodies|ROOT integer limb25/restoring55 models; nowy exponent/domain bridge|
|fpr-emulated.c1183–1256|sqrt54, parity, unsigned trial, guard/sticky/zero-mask/pack|
|fpr-emulated.h161–194|neg/half/double/sqr/inv literal operations|
|falcon-sign.c760–895 / keygen7479–7542,7746–7776|stable helper/scans, token equality po mapowaniu nazw|
|keygen8110–8186|mandatory failure-continue, final accepted break, obie serializacje|
|sign1261–1268|unconditional stable helper → of768 → normalize → return conjunction|
|sign963–1040|actual normalizer leaf read/write map i counts|
|sign1633–1645,2866,2804–2828|paired/stored sigma reads, literal dss, sigma-only selector|

Dziedziny primitive i numerical instancja są w SQRT_DIV_CONTRACT/NORMALIZATION.
Model source bytes używa integer transducers, nie hardware FP oracle.
Sqrt runBits i source b mask są związane przez cały loop invariant/ranges;
pack_value_extended dowiedziono ponownie dla szerszego bias range. Signed
shift e>>1 jest jawnym arithmetic shift wybranego GCC; unsigned wrap/masks
nie są utożsamiane z nieograniczonymi Int bez range argumentu.

StableBits modeluje sign flip/fields i square raw bits, source signzero
sorting oraz sticky scan/inclusive gate. Nat branch flip odpowiada XOR63
po rozkładzie Word64 na low63/sign. Conditional all-ones mask/XOR swap jest
identity albo zamianą obu oryginalnych words. Remaining add body jest tą
samą deterministic source funkcją, a nie idealnym dodawaniem.

Control slices są wygenerowane z podanych spans z pełnym diffem:
- keygen_stable.inc to same helpers/constants7444–7542;
- keygen_tail.inc kopiuje7746–7776 na jawne publiczne root/output buffers;
- signer_tail.inc kopiuje860–894, z zachowanym alias/lifetime layout;
- suffix.inc kopiuje1261–1268, z local declarations/sk offset dla testu.
Nie wykonują full KeyGen, raw/private loader API, całego load_skey lub Sign.
Nie dodano if(stable_ok). Main harness wywołuje realne helpers; callbacks
obserwują add/mul/div/half/double/sqrt pojedynczo, z oryginalnym wynikiem.
Osobny wrapper odczytuje rzeczywiste normalizer tree_words/leaf_count, także
gdy stable gate odrzuca. Nie narzuca tych wartości jako wyniku suffixu.

Checks/stable.c rezerwuje publiczne arrays, inicjalizuje marker words,
porównuje wszystkie1536 stable/24576 sk words, frame/canaries i tmp tail.
KeyGen-only mirror i signer's helper mają to samo g00 w publicznych coefficient
controls; neg/reversed-sum i signed-zero cases mają osobne scalar checks.
Nie tworzy to P_key/emitted membership. C linker GC jest jawny w argv i służy
odłączeniu unused API, nie zmianie badanych arithmetic bodies.

Independent dyadic/isqrt oracle sprawdza scalar sqrt/div/error i width/dss
enclosures. Python stable_model ma actual call/order/flags, oddzielny from-C
flat leaf placement i exact UInt transducers. Cały arithmetic trace i final
words są porównywane, nie tylko końcowe bounds. Source-model errors/mutations
są zachowane. Formal generic bridge jest instancjowany argumentem źródłowym,
nie arbitralnym aksjomatem normalized conclusion. GCC i cały C heap nie są
kernel verified; proof_kind i fully_kernelized są jawne.
