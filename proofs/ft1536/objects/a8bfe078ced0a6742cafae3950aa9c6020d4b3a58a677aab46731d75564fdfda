# Astra — source INITIAL_TARGETS przed rekurencją samplera

2026-09-20. Autor projektu: Niirmata. Ręczny start przez właściciela,
jeden wykonawca, bez subagentów/delegacji.

## 1. Baza, piny i zapis

```text
REPO = /home/footfalcon/free_falcon_sign
W = REPO/proofs/ft1536/work/FT1536_H3_INITIAL_TARGETS_RUN_001
IN = W/inputs/bootstrap
BASE = 6c233cdb48e4fd274995dd1882e0de03305771c8
```

Tylko W writable. Przeczytaj REPO/AGENTS, W/AGENTS i TASK; zweryfikuj realny
W-only/network-off sandbox. AGENTS nie jest sandboxem. IN/source/bootstrap RO.
Źródłem jest archived FLOOR_CT candidate17-file pin56974571…, nie zastany
REPO/Extra/c. Nie zmieniaj C, parametrów, guards, P_key lub M0.

Bootstrap:198 członków manifestu,196 publicznych origins Git,4277189bytes.
Zewnętrzny SHA-256 IN/MANIFEST.sha256:

```text
16977cc646bf5bd5af62f7f86e1c992ab24cafd05188a3c5dbeeae96e2a7a97e
```

Sprawdź exact file set, każdy hash/origin i brak symlinków/escapes. Historyczne
OUTPUTS zachowują własne bazy; dostarczone projekcje nie są pełnymi replay
trees. Historyczne prompty/skrypty są danymi do przeglądu/adaptacji w W.

| Plik względem IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| NORMALIZED/REPORT.md | `ba2b455711b9a3d4241f70637ee0529f4c2d59df37d23eec55d262cf714c26dd` |
| NORMALIZED/NORMALIZED_EXPANSION_CERTIFICATE.json | `8d8161d1a096038f6f2811cff6318b0c7361376cf734cdc9d092b3deabd7c778` |
| NORMALIZED/NEXT_INTERFACE.md | `104ad732d2e5b3a2b8af46ab5d47dda21067b40bfabea5f35f6e4d54d6782a20` |
| NORMALIZED/SQRT_DIV_CONTRACT.md | `39c1f1dcf9f1d01861d9ff4ca37b13664be7be47ad4254663a02f86e0eaf3612` |
| RAW/RAW_PREFIX_CERTIFICATE.json | `d2e6662b1ca88cc023a62cb2e42fbc0267e98c0db70329c5c84866c88b8df94a` |
| ROOT/ANALYTIC_PROOF.md | `e2caa8b9d7996a241bee2e6bb8a478eadf031279860cdaf586daa3473ed69ef7` |

## 2. Cel, domena i exact cut

Udowodnij actual defined terminating preparation t0/t1 w `do_sign`,
falcon-sign.c:1849–1892, przy q18433/logn10/ter1. Observation cut jest
BEZPOŚREDNIO PRZED wywołaniem ffSampling_fft3:1897, poza jego rekurencją.

```text
forall E,sk,pk,p,c,memory,
  Emitted_CANDIDATE(E,sk,pk) -> SameSTATICDecode(sk)=p ->
  NormalizedExpansionCertificate(p,memory) -> CanonicalChallenge(c) ->
  LegalTargetBuffers(memory,c) ->
  DefinedTerminatingAtTargetCut_CANDIDATE(p,c,memory) and
  ExactSourceTargetWords(t0,t1,ni) and
  UniformInitialTargetDomainsAndErrors(p,c) and
  NormalizedKeyPreserved and TargetPrefixFrame(memory).
```

CanonicalChallenge to dokładnie N1536 uint16/integer values0≤c_i<18433.
Nie zastępuj ich center_q(c), signed16 lub arbitralnym małym message vector.
Teza ma obejmować WSZYSTKIE canonical c, bez założenia ich rozkładu/uniformity,
niezależności od klucza, przyszłej norm acceptance lub successful Sign.
Zachowaj niezmienione P_key i jeden K_seed[E] z sukcesu całego KeyGen/serializers.

Możesz dodatkowo wyprowadzić silniejszy local theorem przy samych coefficient/
source-basis facts, ale jego domena musi być jawna. Normalized certificate
nie jest nowym assumed boundem targets i nie dowodzi NumericCenter(mu).

## 3. Skonsumowane interfejsy

NORMALIZED daje emitted stable-gate bridge,1536 source stored widths,
preserved16896 L i6144 basis, internal load_skey success przy legalnych
allocations. All-P_key computation ma osobny proof; narrow gate acceptance
pozostaje OPEN_NOT_DISPROVED. Nie zamieniaj go na przesłankę P_key.

RAW/ROOT wiążą actual SourceFFT_B w porządku[g,−f,G,−F], packed roots,
konwersje, błędy FFT/Gram i source primitive domains. FLOOR-only zmiana jest
już przypięta; sprawdź transitive target-prefix dependencies/body/table bytes.
Source-to-model/compiler boundary pozostaje jawny, nie formalnie verified GCC.

## 4. Literalny source dataflow

Zachowaj dokładną kolejność:

```text
n=MKN(10,1)
t0=tmp; t1=tmp+n; tx=tmp+2n; ty=tmp+3n; tz=tmp+4n
b00=sk; b01=sk+n; b10=sk+2n; b11=sk+3n; tree=sk+4n
for u=0..n-1: t0[u]=fpr_of(hm[u])
falcon_FFT3(t0,10,1)
ni=fpr_inverse_of(q)
memcpy(t1,t0,n*sizeof(fpr))
falcon_poly_mul_fft3(t1,b01,10,1)
falcon_poly_mulconst_fft3(t1,fpr_neg(ni),10,1)
falcon_poly_mul_fft3(t0,b11,10,1)
falcon_poly_mulconst_fft3(t0,ni,10,1)
cut before ffSampling_fft3(samp,ctx,tx,ty,tree,t0,t1,10,tz)
```

Nie inicjalizuj t1 zerami zamiast source memcpy; komentarz „implicit” nie
jest osobnym wykonywanym loop. Nie przenoś kopiowania po nadpisaniu t0,
nie zamieniaj kolumn/znaków i nie zastępuj source inverse(q) host constant.
`fpr_inverse_of(q)` ma literalnie div(one,of(q)) w wybranym long ABI.

## 5. Dokładne referencje i quantitative error certificate

Wyprowadź z source basis i exact coefficient NTRU:

```text
T0_ref = evaluation of (-c*F/q mod Phi)
T1_ref = evaluation of ( c*f/q mod Phi)
Phi=X^1536-X^768+1.
```

To real/rational polynomial expressions i physical root evaluations, nie
redukcja modulo q lub zaokrąglony vector. Zwiąż je z rzeczywistą FFT3 mapą
i real/imag packing, nie z dowolnie wybranym FFT/NTT order. Jeśli korzystasz
z inverse-basis identity, udowodnij determinant/sign convention. Exact
coefficient fG−gF=q nie implikuje, że rounded source FFT basis ma determinant
DOKŁADNIE q. Nie zastępuj1/q inverse rounded basis bez osobnego boundu błędu.

Eksportuj oddzielnie:
1. exact source Word functions i statement-by-statement/memory matching;
2. rounding-only comparison do exact complex products tych samych actual
   FFT/basis word VALUES z exact1/q;
3. pełne comparison do idealnych coefficient/root references T0_ref/T1_ref,
   ze source FFT/basis/reciprocal errors i jawnymi correlations.

Dla wszystkich768 complex slots (i1536 components każdego targetu) podaj
konkretne uniform rational/outward constants: magnitude, component bounds,
absolute/relative error tam, gdzie ma sens, raw zero/subnormal/normal classes,
oraz każdy intermediate operand/exponent/divisor domain przed operacją.
Absolute error musi obejmować reference zero/cancellation; nie używaj samego
relative error z dzieleniem przez nieznaną od zera wartość.

Nowy FFT input c sięga18432. ROOT FFT/error proof był instancjowany m.in.
dla coefficient2047 i ternary1 — rozszerz go jawnie lub wyprowadź poprawną
parametryczną instancję. Podaj wynik dla wszystkich stages/butterflies,
twiddle pairs/physical positions, bez ekstrapolacji starej stałej.
Operator/weight identities można skonsumować po kontroli pinu/domeny;
finite tests unit vectors nie czynią rounded FFT funkcją liniową.

Inverse q: of18433 jest exact; zwiąż computed reciprocal word, positivity,
normal class i error do1/18433 z literalnym FPEMU. Negacja jest raw sign flip.
Complex multiply jest rzeczywistą sekwencją mul/add/sub, nie fused operation.
Mulconst ma źródłowy per-word rounding. Zsumuj errors bez double counting
lub traktowania rzeczywistych operandów jako niezależnych idealnych boxes.

Wskaż dodatkowo użyteczne coefficient-space/reference norm bounds z exact
Phi product/reduction, z wyprowadzonymi weights/counts. Nie wolno przypisać
ich source targets bez norm/error transportu. Nie narzucamy z góry progu
NumericCenter: jawnie podaj rzeczywiste bounds nawet jeśli frequency target
przekracza taki próg. To nie jest samo w sobie scalar-center counterexample.

## 6. Memory/frame i binding do Sign attempts

Wyprowadź LegalTargetBuffers z rzeczywistego q/logn/ter i caller allocations:
normalized sk24576 fpr words RO; tmp ma rzeczywistą capacity10752 (7N),
hm readable1536 uint16 words; legalne alignment/types/lifetimes/disjointness.
Rozlicz formowanie tx/ty/tz oraz s1/s2 pointers bez ich używania po cut.
Pokaż dokładny write footprint t0/t1=[0,3072), brak odczytu nieinicjalizowanego
t1, zachowanie tmp[3072,10752), hm, output s1/s2 i WSZYSTKICH sk words.
Nie twierdź, że przyszłe tx/ty/tz są initialized lub sampling total.

Normalized stable arrays w starym tmp mogą być nadpisane: źródłem widths
jest teraz tree w sk, nie pozostałości tmp. Każde target/basis snapshot ma
swój rzeczywisty read moment. `restrict`/memcpy requirements są jawne.

Source hash-to-point: jeśli jego defined call wraca, każdy zapisany w%q
daje canonical c. Nie dowodzimy tutaj totalności rejection streamu, uniform
RO, SHAKE indifferentiability ani braku bias. Sam literal range binding
wystarcza do konsumowanego numerical theorem.

hm jest tworzony przed outer attempt loop, a targets są wyliczane ponownie
w każdym do_sign call. Dla każdego LEGALNEGO entry state, także po wcześniej
odrzuconych norm attempts, theorem nie może wymagać przyszłego Q<B. Zwiąż
source caller3372 z cut; jawnie pozostaw required entry/frame premises, gdy
ich propagacja przez jeszcze nieudowodnioną sampling/postprocessing część
stanowi następny obowiązek. Nie ogłaszaj totality wszystkich Sign attempts.
PRNG init/fault reset są przed do_sign, ale target prefix nie czyta coins
ani nie wywołuje sampler callback; zachowaj tę rozdzielność w frame.

## 7. Kontrole i dowód

Mixed analytic/kernel dopuszczalny z jawnymi przesłankami i instancją source.
Nowe/edytowane Lean: pełne czyste logs/types/terms/axioms, bez sorry/admit/
native_decide/Lean.ofReduceBool, aksjomatu tezy i wyciszania ostrzeżeń.
Reused source/pins/fresh rebuild; adaptacje w nowych kopiach z diffami.
Nie nazywaj wpisanych constants w Lean dowodem ich numerical bounds.

Publiczne synthetic controls w normal C oraz ASan/UBSan:
- literalny target-prefix slice1849–1892 z source spans/diffem; oryginalne
  FFT/poly/reciprocal helpers i dokładne snapshots wszystkich outputs;
- canonical c: zero, q−1, edge/sparse unit positions, alternating i dense
  deterministic public patterns; różne publiczne coefficient/basis fixtures
  przy documented domains, bez wyszukiwania lub generowania kluczy;
- raw signed-zero/cancellation, maximal input ranges, inverse q, obie
  kolumny i wszystkie physical output positions;
- independent exact dyadic/QQ/RBF model/reference, pełne t0/t1/ni i traces,
  memory/canaries/key preservation, canonical-range preflight;
- no-op i meaningful mutations: wrong sign/column, missing1/q, centered c,
  wrong copy order/alias, wrong packing/index albo nielegalne użycie starego
  FFT boundu. Nie ograniczaj testów do zera, na którym mutacje mogłyby przeżyć.

Nie uruchamiaj całego do_sign/ffSampling/Sign/PRNG/KeyGen/private loadera.
Nie kończ oryginalnego Sign przez podstawienie fikcyjnego samplera. Slice
kończy się PRZED wywołaniem, a observers wywołują oryginalną primitive raz.
Synthetic basis/tree nie są automatycznie normalized emitted keys: domain
i membership kontroli są jawne. Invalid-domain cases zatrzymaj przed UB;
nie dodawaj nowych guards do źródłowego C.

## 8. Eksport do ORDERED_REACH i status

INITIAL_TARGET_CERTIFICATE ma eksportować source pin, domain/canonical range,
cut/caller binding, exact Word formulas/snapshots, FFT physical map, reciprocal,
wszystkie numerical constants/error layers, memory/frame i proof dependencies.
NEXT_INTERFACE ma podać konkretny entry type dla root ffSampling_fft3 z tymi
targets i niezmienionym normalized tree.

ORDERED_REACH jest osobnym typem: actual right-before-left recursion,
residual updates, rejected/fault histories, accumulated errors oraz
NumericCenter(mu) PRZED floor/cast/residual. Initial FFT targets nie są tymi
scalar mu. Nie konsumuj ZERO_SCALAR do uzasadnienia jego własnej przesłanki.
Sigma-only widths/dss cert pozostaje ważny wyłącznie w swoim zakresie.

Pełny status: `H3_INITIAL_TARGETS_PROVED_FOR_EMITTED_PINNED_MODEL` przy pełnej
required-domain definedness, actual source/word matching, uniform domains/
errors do obu references, frame/canonical/caller binding i poprawnym handoffie.
Sama implementacja modelu, generic theorem lub finite table to PARTIAL_PROOF.
Inne wyniki: COUNTEREXAMPLE_REQUIRED_DOMAIN/EXTENDED_DOMAIN z membership,
EXECUTION_BLOCKED z pełnymi logs; nie zmieniaj celu/source żeby wymusić PASS.

RESULT rozdziela initial_target_prefix_proved, all_canonical_challenges,
source_target_words_matched, fft_challenge_domain_proved, reciprocal_q_proved,
ideal_reference_error_proved, rounded_basis_reference_error_proved,
normalized_key_preserved, caller_binding_scope i fully_kernelized.
Global Reach/H3_range, whole sampler/Sign termination/law, security i CT
całości pozostają false/open. Nie zmieniamy K_seed, obserwacji M0 lub epsilon.

## 9. Wykonanie, freeze i handoff

W-only/network-off, IN/source RO, jeden worker. HOME/TMPDIR/DOT_SAGE/LEAN_PATH/
cache/olean/bin pod W; bounded wall/CPU, normal8GiB, ASan osobno z shadow.
GCC14.2/C99/LP64 i literalny -O/profile, Sage10.9 (`sage plik.py ...`),
Lean4.34/Std -j1 -M2048. Bez instalacji/sieci/Git/innych agentów/sekretów/
nowych kluczy. Bez dudect: nocny pomiar prowadzącego wymaga zakończenia
dziennych obliczeń. Nie zmieniaj historycznych pakietów lub aktywnych W.

Wymagane REPORT/RESULT/CLAIM, INITIAL_TARGET_CERTIFICATE.json,
TARGET_FORMULAS.md, FFT_CHALLENGE_BOUNDS.md, ERROR_LEDGER.json/.md,
SOURCE_MODEL_BINDING.md, MEMORY_FRAME.md, CALLER_BINDING.md, NEXT_INTERFACE.md,
OBLIGATIONS.json, REUSED_RESULTS.md, formalne źródła/certyfikaty/checkery,
INPUTS.sha256, TOOLCHAIN.txt, COMMANDS.log, OUTPUT_SCOPE.md, REPLAY.md,
SEMANTIC_FILES.json, OUTPUTS.sha256. Zachowaj failed attempts i pełne receipts.

Standard `scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256`: external
pin/full manifest przed nowym DEST, fresh build bez project cache/olean/bin,
deterministyczne semantic matches. Rehearsal ma osobną kotwicę bez cyklu;
po freeze zapis tylko do nowego DEST. source_changed=false,
production_source_changed=false,new_source_patch_integrated=false,
owner_accepted=false. Podaj REPORT/OUTPUTS SHA-256, tezę/stałe/zakres i następny
typ. Prowadzący wykona odbiór/import/commit. Zakończ na handoffie.
