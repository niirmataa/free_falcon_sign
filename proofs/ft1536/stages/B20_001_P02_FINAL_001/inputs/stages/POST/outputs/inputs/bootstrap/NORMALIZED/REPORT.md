# FT1536 H3_STABLE_NORMALIZATION — raport końcowy

2026-09-20. Autor projektu: **Niirmata**.

## Wynik i rozdzielenie domen

**H3_STABLE_NORMALIZATION_PROVED_FOR_EMITTED_PINNED_MODEL**.

Dla wszystkich legalnych M0 Emitted_CANDIDATE keys, same-STATIC-decode p,
RawPrefixCertificate i legalnych buffers domknięto rzeczywisty source suffix
1261–1268: stable helper, exact of768, unconditional normalize i source return.
Wynik obejmuje:
- stable_ok=true, leaf_count1536 i tree_words18432;
- **1536 rzeczywistych stored width words** w dokładnym RAW leaf order;
- bitowe zachowanie **16896 internal L i6144 basis words**;
- source-bound sqrt54/div/skalowanie i sigma-only paired/dss domains/gates;
- continuation: internal load_skey return1 dla Emitted/legal allocations.

**Narrow stable acceptance wyprowadzono z mandatory check w udanym KeyGen.**
Same positive raw leaves ani szerokie P_key bounds nie zostały użyte jako
dowód inclusive stable scan. P_key nie wzmocniono i nie dodano conditioning.

Osobno `all_P_key_definedness_proved=true`: actual computations, exact
sequence/frame i return=gate Boolean. **`all_P_key_stable_gate_acceptance_proved=false`**,
status **OPEN_NOT_DISPROVED**. Nie ogłoszono kontrprzykładu P_key ani nowego
podzbioru kluczy. Dokładne typy rozdziela DOMAIN_AUDIT.md.

Proof kind: **MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF**.
Sqrt54 integer invariant jest kernelized; pełna source normalization/heap/GCC
nie jest w całości kernelized. Numerical/source/control-flow instancję
rozliczają dokumenty, nie sama zgodność testów lub generic theorem.

## Baza, piny i izolacja

BASE `a53d7231795fb5c7317bc836baaf0ccd3ec2652f`.
Źródła17-file candidate56974571… pozostają identyczne; nie użyto zastanego
Extra/c jako bazy. Zweryfikowano exact bootstrap272 members/270 origins,
6309831 bytes, każdy hash, source set i brak symlinków/escapes. INPUTS ma276
publicznych records z TASK/AGENTS/manifestem.

```text
CANDIDATE.sha256
56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985
TASK SHA-256
feba3eed88442f7259f1be6283b2964c19065c7984611df2ea1af054da5cab7d
bootstrap MANIFEST SHA-256
58f027900b3283bdf6f488ddb4fdeaa1e6c80b69253cf7d03a7855d3898478f7
```

W-only/network-off bwrap, bootstrap/source RO, mount/probe receipts. HOME,
TMP,DOT_SAGE,LEAN_PATH/cache/olean/bin lokalne. Jeden bounded worker, normal
8GiB, Lean4.34/Std-j1/-M2048, ASan oddzielnie z shadow. GCC14.2.0-19/C99/LP64
i literalny Makefile -O/profile. Bez Git, sieci/instalacji, KeyGen/realnego
private-key API/całego loadera/Sign, nowych kluczy/prywatnych danych i dudect.

## Dlaczego emitted gate przechodzi

Fixed legal profile spełnia warunek mandatory certificate8110. Jego failure
prowadzi do continue przed break8134; final successful attempt oraz obie
serializacje8145–8181/return1:8186 wymagają certificate return1. Same decoded
vectors są zachowane. To istniejący success event, nie nowy p_K lub K_iid.

KeyGen g00=selfadj(FFT(g))+selfadj(−FFT(f)); signer recomputes
selfadj(FFT(f))+selfadj(FFT(g)). Nowy bitowy bridge wykazuje:
1. XOR sign flip zachowuje exponent/fraction, square source mul ma sign XOR0;
   oba norm terms mają identyczne payloads także przy zerach/subnormals;
2. squares/norms są sign0 w reached domain. Source add sorting dla sign0
   daje identyczną parę(max,min) po zamianie operands; residual body dostaje
   te same raw words. To bit equality, nie tylko idealna tożsamość norm.
3. Active preprocessing i comparison siedmiu helpers wykazały token equality
   po mapowaniu nazw; Gate00, literal top/binary/reverse reciprocal i pełny
   range scan mają te same operacje i kolejność.
4. bad jest sticky OR z0/1, bez resetu; bad==0 wyklucza każdy invalid check
   i każdą zmianę przez fallback1. Kernel scan_clear/inclusive_gate oraz
   source domains/memory zamykają wszystkie1536 pozycji.

Własny proof korzysta z actual KeyGen root frame w momencie przed scan;
nie wymaga zachowania starego tmp po stable recomputation signera.
Szczegóły: EMITTED_STABLE_BINDING.md i SOURCE_MODEL_BINDING.md.

## Primitive contracts i mocne bounds

Sqrt: actual portable loop54. Kernel dowodzi
`N=q²+r*xu`, bracket `q²≤N<(q+2r)²`, trial equivalence, integer ranges,
indukcji, końcowego `q²≤N<(q+1)²` i `xu=2(N−q²)`. Guard/sticky i pack
dają dla dodatnich NORMALNYCH inputs source relative error≤2^-52,
positive finite output. SqrtPack dowodzi extended pack-value range ponownie;
nie ekstrapoluje dawnego ograniczonego lemma. Exponent-zero behavior ma
osobny zakres; nie ogłoszono complete IEEE na subnormals.

Div: nowy source domain finite |x|≤2^100, positive normal y∈[2^-16,2^80],
error≤2^-48|x/y|+2^-900. Reuse restoring55 jest niezależny od exponentów;
nowe exponent/underflow/cast bounds rozliczono jawnie. Stable e2 może sięgać
2^48, więc stary[1/16,2^35] nie wystarczał. Broad positive computation daje
primary∈(1/4,2^24), pełne stable D∈(1/4,2^31), operands<2^72 i initialized
leaves pointer także przy narrow-gate failure. Normalize wykonuje się wtedy
zgodnie z kodem, bez dodanego if(stable_ok).

Exact gate endpoints:
D_min=4503601027220343/4398046511104,
D_max=356537342113749/1073741824. Na emitted gated sequence własny
source-error certificate daje:

| Rzeczywista wartość | Wyprowadzony przedział |
|---|---|
|Stored S0²|**(1.7763,575.9999)**|
|Paired S1², S1=mul_C(IW1I,S0)|**(2.3684,767.9999)**|
|dss_C obu klas|positive finite, **>1/1536**, więc≥actual last coefficient|

Dokładniejsze source square endpoints wynoszą około1.7763039737838013… /
575.9998209624986462… oraz2.3684052983783846… /767.9997612833368963….
Pełne rational/word intervals i error budgets są w WIDTH_BOUNDS.json.
Stored word enclosure3ff55311b09aeb62..4037ffffc16bfe8c;
paired3ff89f970c34eba2..403bb67aa015fd9f.

Scoped H4 **1.7203≤val(S0)²<595.19** odtworzono dla actual FPEMU words.
Legacy H4 RN/fpr-double premise nie jest dowodem tego etapu. Actual IW1I
payload3ff279a74590331c i last coefficient3f45555555555555 są sprawdzone.
Dss zachowuje literalne inv(mul(sqr(S),of2)), nie idealną zamienną kolejność.
Mocny paired bound<768 zamyka selector ge/found dla tej sigma-only domeny.

## Sequence, memory i ograniczenie consumerów

Primary tworzą trzy256-word blocks; reciprocal zapisuje index1535-u.
Stored S0[i]=div_C(of768,sqrt_C(D[i])) trafia dokładnie do RAW_LEAF_MAP[i].
Normalizer omija internal L, zapisuje dwa leaves w base inner1; map/bijection/
counts i frame obejmują wszystkie18432 tree words oraz basis. Tmp peak3072
przy capacity10752, leaves768..2304,scratch2304..2560; overlap dotyczy martwych
f-imag/g danych. Dawny root Gram może zostać legalnie nadpisany.

Actual sampler leaf map jest reverse physical order, paired width przed
stored width w każdym terminal case:1536 stored widths,3072 scalar uses.
To structural/sigma-only result. Nie dowodzi wcześniejszego floor/cast/
residual(mu), NumericCenter/Reach lub PRNG/rejection/sampler law.

## Kernel, niezależne kontrole i mutacje

**40 modułów,230 twierdzeń,50 nowych**,31 inherited modules unchanged i fresh
rebuilt. Final logs/types/terms/axioms są czyste, tylko standardowe
propext/Classical.choice/Quot.sound. Bez sorry/admit/native_decide/
Lean.ofReduceBool, aksjomatu wniosku lub warning suppression.

```text
StableAudit.stdout SHA-256
1469cfd6e067b6eed13fe7929fdb02510d883e298c38d704124acefa367ec357
StableTypes.stdout SHA-256
e2bab1ea3ffe83d1433728999351dcaec1a723b3b14a6bc5ff53a3b277b8f2f9
```

Normal C i ASan/UBSan: **PASS**. LSan nie deklarowany. Kontrole obejmują:
-40930 sqrt words, wszystkie2046 normal exponents i8192 public random words,
  niezależny exact dyadic/isqrt oracle, odd/even/ties/boundaries/±0;
-4096 Lean q/final remainder comparisons z literalnym source loop;
-117 div pairs w rozszerzonej domenie,196 bit identity pairs,24 gate cases
  z endpoints±1ULP i sticky bad,1033 width/dss cases;
-8 pełnych publicznych helper/suffix pipelines z całymi1536 stable values,
 24576 sk words,22272 arithmetic events każdy, reverse order, pointer/counts,
 canaries/read aliases i frame; trzy odrzucone stable scans nadal normalizują;
-no-op i8 wykrytych mutations: reciprocal order, leaf placement, basis/internal
  frame, sticky reset, inclusive threshold, sqrt sticky oraz exponent parity.

Fixtures są lokalnymi publicznymi roots/coefficients/leaves, bez P_key/emitted
membership claim. Source C pozostaje niezmienione. Model nie jest drugim
wywołaniem C; bad-domain inputs zatrzymano przed native call. Finite tests
i zgodne hashes nie zastępują uniwersalnego source proofu.

## Replay, historia i handoff

Pre-freeze **FRESH_REPLAY_PASS,262/262** semantic matches,61.766 s,378 seed
members, bez project olean/bin/cache. Odtworzono source binding, exact bounds,
cały kernel, fixtures/oracles, normal/sanitizers, maps, mutations i certificate.
Zachowano pełne receipts oraz nieudane extraction/elaborations/type-printer
attempts; redundant domain warning usunięto przez usunięcie zbędnej przesłanki.

```text
Rehearsal anchor SHA-256
4f996ecae24c1d0514ddd16dc0ba4c55014f419824655ccd474deb7792d6bfcd
artifacts/fresh_replay.json SHA-256
97e41285e6263b8606d715f1463af3db16f6d60ebe680980bb079876f5e936cc
NORMALIZED_EXPANSION_CERTIFICATE.json SHA-256
8d8161d1a096038f6f2811cff6318b0c7361376cf734cdc9d092b3deabd7c778
```

OUTPUT_SCOPE/REPLAY definiują exact manifest, completed COMMANDS prefix,
fresh standard protocol i osobną kotwicę bez cyklu. Kontrola po freeze ma
pakiet RO i zapisuje wyłącznie nowy DEST; jej wynik oraz external REPORT/
OUTPUTS hashes są w handoffie bez dopisywania do frozen bajtów.

NEXT_INTERFACE eksportuje normalized certificate do osobnych INITIAL_TARGETS
i ORDERED_REACH→NumericCenter. Private-key API allocation success, global
Reach/H3 range, sampler-law/security reduction i całe Sign CT pozostają open.
source_changed=false,production_source_changed=false,
new_source_patch_integrated=false,owner_accepted=false. Odbiór/import/commit
należą do prowadzącego; dalszego etapu nie rozpoczęto.
