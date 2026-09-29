# FT1536 H3_INITIAL_TARGETS — raport końcowy

2026-09-20. Autor projektu: **Niirmata**.

## Wynik i zakres

**H3_INITIAL_TARGETS_PROVED_FOR_EMITTED_PINNED_MODEL**.

Domknięto actual defined terminating preparation `t0/t1/ni` w do_sign
1849–1892, z cut bezpośrednio przed ffSampling_fft3:1897. Domena obejmuje
wszystkie emitted/same-STATIC-decode normalized keys i **WSZYSTKIE canonical
c∈[0,18432]^1536**, przy legalnych entry buffers. Nie założono uniform c,
niezależności od klucza, future norm acceptance lub successful Sign.

Wynik zawiera exact source words, nowy FFT/error certificate dla cap18432,
oba quantitative reference layers, preservation całego normalized sk i
caller/H2P binding we właściwym zakresie. Proof kind:
**MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF**;
initial_targets_fully_kernelized=false,C_compiler_verified=false.

## Baza, piny i sandbox

BASE `6c233cdb48e4fd274995dd1882e0de03305771c8`. Źródło to archived FLOOR_CT
candidate, nie zastany Extra/c. Exact bootstrap198 members/196 origins,
4277189 bytes i wszystkie17 source hashes zweryfikowano. INPUTS ma202
publiczne records z TASK/AGENTS/manifestem. Brak symlinków/escapes.

```text
CANDIDATE.sha256
56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985
TASK SHA-256
a8bfe078ced0a6742cafae3950aa9c6020d4b3a58a677aab46731d75564fdfda
bootstrap MANIFEST SHA-256
16977cc646bf5bd5af62f7f86e1c992ab24cafd05188a3c5dbeeae96e2a7a97e
```

Faktyczny W-only/network-off bwrap, bootstrap/source RO, namespace/probe
receipts. HOME/TMP/DOT_SAGE/LEAN_PATH/cache/olean/bin lokalne. Jeden bounded
worker; normal8GiB, Lean4.34/Std-j1/-M2048, ASan osobno z shadow. GCC14.2.0-19,
C99/LP64 i literalny Makefile -O/profile. Bez Git, sieci/instalacji, nowych
kluczy/seeds, private loadera, KeyGen, do_sign w całości, ffSampling, Sign,
PRNG lub dudect. Źródła/profil/P_key/M0 nie zostały zmienione.

## Source flow i referencje

Rzeczywista kolejność: map of(hm) do t0, FFT3(t0), inverse(q), memcpy t1=t0,
mul t1*b01, scale t1*(-ni), mul t0*b11, scale t0*ni. Implicit-zero komentarz
nie jest loop; copy nie zostało przeniesione po overwriting t0. Cut nie
wywołuje nawet fikcyjnego samplera. Literalny slice ma source spans/diff,
observers wywołują oryginalne primitives raz.

Normalized certificate zachowuje SourceFFT_B=[g,−f,G,−F]. Exact coefficient
determinant g(-F)−(-f)G=fG−gF=q i row-vector inverse convention dają
ideal references **eval((-cF/q) mod Phi)** oraz **eval((cf/q) mod Phi)**.
To rational polynomial expressions, bez mod-q reduction, center_q lub1/N.
Rounded FFT basis nie ma założonego exact determinant q.

Rounding-only references to exact complex VALUES tych samych actual FFT/
basis words: R0=Ĉ*B11/q,R1=−Ĉ*B01/q. Target error jest rozliczony najpierw
do tych R, a potem do ideal coefficient/root values; FFT/basis errors są
dodawane jeden raz. Zero/cancellation używa absolute bounds, nie dzielenia
przez nieznaną nonzero reference.

NI source word: **3f0c7161fb1566d0**, exact value
500372811634285/9223372036854775808. Error od1/18433 jest dokładnie
403/170014416755344082468864; NI jest positive normal między2^-15 i2^-14.
Literal divC/ofC word/value są kernel-checked i zgadzają się z C. Nie użyto
host reciprocal; negacja jest raw sign XOR.

## Nowe FFT bounds i domains

Nowa instancja parameterized source recurrence dla **18432** daje component
FFT error **<1/8192**, ideal modulus≤28311552 i domains wszystkich FFT
intermediates<2^28. First fold768, osiem square stages po384 butterflies,
final cubic256 triples: każdy stage/branch ma exact QQ error/domain record.
Stary coefficient2047 bound1/32768 nie został przeniesiony na challenge.

Fresh RBF256 sprawdził255 square pairs,256 cubic pairs i6 fixed components;
każdy component twiddle error<2^-50. Sprawdzono **1179648 symbolic weights**
dla wszystkich1536 coefficient variables i768 physical complex slots.
Root map r_(3v+k)=1+6*rev8(v)+1536k, real i/imag i+768, unscaled evaluation.
Linearity jest własnością ideal shadow map; rounded source FFT ma osobny
uniwersalny error induction. Nie wnioskowano jej z unit-vector tests.

Canonical of jest exact. Source primitive cap2^100 obejmuje nowo wyprowadzone
FFT bounds, actual basis caps i wszystkie CM/scale intermediates<2^49.
Divisor q18433 ma wcześniejszy proved domain. Finite loops, initialized
reads i te domains wyprowadzają actual termination PRZED sampling.

## Quantitative target certificate

| Target | Rounding-only norm/component error | Ideal-reference norm/component error | Source norm/component upper |
|---|---:|---:|---:|
|t0|**<1/8192**|**<1/4**|**<4829216911**|
|t1|**<1/16777216**|**<1/8192**|**<2359169**|

Ideal modulus bounds:89016955305984/18433 i43486543872/18433.
Pointwise rounding-relative coefficient jest<2^-44 z absolute tail<3eta,
eta=2^-900. Actual outputs są finite normal lub signed zero. Pełne rational
records/formuły i każda domain premise są w ERROR_LEDGER/FFT_CHALLENGE_BOUNDS.

Φ reduction sprawdzono dla **2359296 monomial pairs**. Row absolute counts
to2303−k dla k<768 i2304 dla k≥768. Exact coefficient/reference linf bounds:
86930620416/18433 dla t0 i42467328/18433 dla t1; także l2/Phi norm bounds.
Orthogonality root differences0,±768 daje evaluation Gram eigenvalues768,
2304 i inverse-eval norm transport. Mathematical inverse evaluation source
target ma coefficient l2 drift≤1/2 albo1/4096 wobec ideal reference. To nie
source iFFT3 proof i nie jeszcze bound późniejszych scalar mu.

Frequency t0 majorant przekracza2^31. Zapisano ją jawnie; nie stanowi to
samo w sobie scalar-center lub emitted counterexample. ORDERED_REACH musi
prowadzić actual recursive transformations/residual updates oddzielnie.

## Memory i caller

Write footprint to wyłącznie tmp[0,3072), w capacity10752. Chronione są
całe **24576 normalized sk words**, hm, output s1/s2, context/coins i tmp
suffix[3072,10752). Tx/ty/tz są formed pointers, bez twierdzenia initialized
future outputs. Stare stable arrays w tmp mogą zostać nadpisane; width source
to tree w sk. Restrict/memcpy/lifetimes i byte offsets są jawne.

Hash-to-point jeśli defined call wraca, zapisuje1536 canonical residues
w%18433 (limit55299); nie dowiedziono rejection termination lub uniform RO.
HM powstaje przed outer attempts. Dla każdego legalnego do_sign entry,
również po norm rejection, bieżący theorem nie potrzebuje future Q<B.
Propagacja entry/frame przez jeszcze nieudowodniony sampler/postprocessing
pozostaje osobna. Prefix nie czyta PRNG i nie wywołuje callbacku.

## Kernel i niezależne kontrole

Lean: **21 modułów,129 twierdzeń,30 nowych**,15 inherited modules przebudowane
byte-identical. Czyste final logs, pełne nowe types/terms i wszystkie axioms.
Tylko propext/Classical.choice/Quot.sound; bez sorry/admit/native_decide/
Lean.ofReduceBool, aksjomatu wniosku lub warning suppression. Numerical
FFT/error instancja pozostaje jawnym uniwersalnym proofem analitycznym z
exact certificates, nie samymi constants w Lean.

```text
TargetAudit.stdout SHA-256
8ec6de78d3199e32b318a0034700674ee2dfa59b6b499f2e1254de7cee110662
TargetTypes.stdout SHA-256
8b3f11b1cdee755d2ce0cd4be42c7987d1cdc72c00d46c125e2310590bc5442c
```

Normal C i ASan/UBSan: **PASS** dla11 publicznych fixtures. Canonical zero,
max18432, alternating,dense deterministic,sparse edges/units0/767/768/1535,
cancellation i raw signed zeros. Pełne source snapshots t0/t1/ni i operacji,
basis/key/hm/outputs/context frame, canaries i copy read moment są zgodne.
LSan nie jest deklarowany.

Independent exact QQ oracle sprawdził8448 complex positions rounding layer;
direct RBF256 polynomial/root/Phi-remainder oracle także7680 ideal-reference
positions w coefficient fixtures. Raw word fixture nie ma coefficient
provenance. W coefficient fixtures g=G=0→det0≠q: nie są emitted keys.
Nie generowano ani nie wyszukiwano kluczy.

No-op i8 wykonanych model mutations: sign,column,missing1/q,centered input,
zero/late copy,alias,packing — wyniki odróżniono na nonzero dense case.
Odrzucono też użycie starego2047 FFT constant jako new-domain certificate;
to proof-domain failure, nie zaobserwowany błąd C. Sześć invalid cases
zatrzymano przed native call. Finite controls nie zastępują uniwersalnego
quantified theorem.

## Replay, freeze i handoff

Świeży **FRESH_REPLAY_PASS,219/219**,54.781 s,285 seed members, bez project
olean/bin/cache. Odtworzono source binding, wszystkie symbolic/numeric
certificates, kernel, C/model/oracle/ASan, mutations i finalny certificate.
Zachowano także wcześniejsze syntax/elaboration attempts i pełne receipts.

```text
Rehearsal anchor SHA-256
f5b50b4d21043f515859ed18863a4abbc1d90168a2979eea9d67062503c1352c
artifacts/fresh_replay.json SHA-256
b6f171c70d6642c974ba6f2836ff1c2365cf93fda6ac14771778ecfa44bbbfeb
INITIAL_TARGET_CERTIFICATE.json SHA-256
89ce68e32fb10a3edd75f182af85843f7ab1e32198e753778d9a96d7dcea51a9
```

OUTPUT_SCOPE/REPLAY definiują exact manifest/frozen command prefix i standard
external pin→fresh DEST→semantic matches. Rehearsal ma niezależną kotwicę
bez cyklu. Po freeze kontrola readonly pakietu zapisuje tylko do nowego DEST;
external REPORT/OUTPUTS hashes i rezultat standardu są w handoffie.

NEXT_INTERFACE przekazuje konkretne root ffSampling arguments/targets/tree
do osobnego **ORDERED_REACH→NumericCenter**, z required entry premises i
right-before-left/fault/rejection history. Global Reach/H3 range, whole
sampler/Sign termination/law, security i CT całości pozostają open.
source_changed=false,production_source_changed=false,
new_source_patch_integrated=false,owner_accepted=false. Odbiór/import/commit
należą do prowadzącego; następnego etapu nie rozpoczęto.
