# FT1536 H3_LEFT_ROOT_CORRELATED_TRANSFER — raport końcowy

Zadanie z2026-09-20. Autor projektu: **Niirmata**.

## Wynik

**H3_LEFT_ROOT_CORRELATED_TRANSFER_PROVED_FOR_EMITTED_PINNED_MODEL**.

Domknięto source bank/paired weighting, raw-L/stable-D metric comparison,
weighted right residual i literal root transfer. Zamknięty forward invariant
obejmuje wszystkie aktywne pre-floor points lewej gałęzi, z current-domain
proofem PRZED konsumpcją ZERO.

Po kompozycji z odebranym right theorem uzyskano osobno:
**H3_ORDERED_NUMERIC_CENTER_PROVED_FOR_EMITTED_PINNED_MODEL**.

Dla każdego required emitted/same-STATIC/canonical normalized root entry
i legalnego actual finite source prefixu dochodzącego do sampler_large2864:

```
finite Word64(mu), |val(mu)| <=937866518,
NumericCenter lower margin =1209616765,
NumericCenter upper margin =1209616764.
```

Obejmuje raw−0. Nie zakłada future norm acceptance, typowych próbek,
niezależności normal returns, nowego key gate lub probabilistic wyjątku.
Conditional right-completion premise transferu nie jest theorem termination.

Proof kind: **MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF**.
Kernelowe algebra/order/frame/range lemmas mają pełne audyty; actual
real-matrix/source/error instancja jest szczegółowym dowodem analitycznym
z exact certificates. `fully_kernelized=false`, `C_compiler_verified=false`.

## Baza, piny i izolacja

BASE `7664277d6da6839973e8a00db5b20c834bb63adc`, odebrany ORDERED partial.
Source to archived FLOOR_CT candidate, nie zastany Extra/c. Zweryfikowano
579 members,577 public origins Git,9599951 bytes, exact set i wszystkie
17 source hashes. INPUTS ma583 public records z TASK/AGENTS/manifestem.

```text
CANDIDATE.sha256
56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985
TASK SHA-256
6e06bfd615178873a081c369ae8b89a4ab1203e73044a0cc8839d137f26ef72e
bootstrap MANIFEST SHA-256
5bbd7b14d05275ad0cf46a72e9b8d24d5c67001f7597761edb07d86d444173d4
```

Realny W-only/network-off bwrap, bootstrap/source RO i mount/probe receipts.
HOME/TMP/DOT_SAGE/LEAN_PATH/cache/olean/bin lokalne. Jeden bounded worker,
normal8GiB, Lean4.34/Std-j1/-M2048, ASan osobno z shadow. GCC14.2.0-19/C99/LP64
i literalny Makefile-O/profile. Bez Git/subagentów/sieci/instalacji, nowych
kluczy/seeds, KeyGen/private loadera/całego do_sign/Sign lub dudect.

## Nowy most — co zamknęło wcześniejszą lukę

### 1. Source banks i terminal A2

First successful source ge daje dss>=a_j i strict dss<a_(j-1) dla j>0.
Nowy dss relative enclosure2^-40 rozlicza sqr/mul/inv, a exact dyadic bank
coefficients wyznaczają rzeczywiste variance endpoints. Oba source width
classes są osobne: D*S0²≈768², D*S1²≈(4/3)*768², z własnymi source errors.

Returned terminal pair nie jest parą sampled integers. Po half i last sub
zachodzi `Q_A2(r0,r1)=(u0+delta)²+(3/4)r1²`, |delta|<2^-37. Czynnik3/4
konsumuje paired4/3; cross term i roundoff nie są pominięte. Wyprowadzony
uniform source bound to **849346588** na D-weighted terminal pair i
**652298179584** na768 right terminal pairs. Każde użycie residual boundu
ma wcześniej ustalony NumericCenter z ORDERED.

### 2. Raw factor versus actual Gram, potem stable weights

Zdefiniowano Q_Re(parent spectrum), actual Hermitian H, reconstructed
Hrec=L_C diag(real raw pivots)L_C* oraz pełny source-L congruence T_C.
Source signed/imaginary inputs nie zostały zastąpione realnymi w programie.

Fresh direct source expansion daje opnorm defect **128U*h** binary oraz
**2048U*h** cubic. Kluczowy krok: reconstructed H22 porównuje source norm
tego SAMEGO L21_C, zamiast mnożyć luźny L21 error przez condition number.
Zachowano source norm/CM/add/sub errors, włącznie z U² cross term.

Imaginary/split opnorm defects d(I+delta) oraz source LDL defects dają
local relative Loewner factors. Congruence i Schur-minimum monotonicity
transportują metrykę i real raw pivots przez cubic+8 binary stages.
Wszystkie6 S8 i1524 lower records mają sprawdzone m/I/denominators/factors.

Root real D porównano z q²/A0, uwzględniając determinant error zaokrąglonej
FFT basis: ratio około(0.7502305014…,1.2497694994…). Exact positive pivots
i source stable relative errors/reverse reciprocal map dają finalnie:

```
Q_Re(Droot_C) <=6*S_stable,
```

gdzie S_stable używa ACTUAL raw L w swoim congruence, a nie idealnego stable
LDL. Factor6 jest outward ceil exact product, nie dopasowaniem do goal.
Form inequalities są nieostre przy zero vector; strict operator margins
dotyczą nonzero vectors. Legacy>991/RN assumptions nie są konsumowane.

### 3. Right energy, actual root gain i source roundoff

Exact reconstruction Z* z actual returned terminal words i actual L ma
weighted Gram energy<=3913789077504. Source merge/CM/sub reconstruction
error jest jawny:
`max|z1_C−Z*|<=20102235062439/562949953421312<0.036`.

W szczególności dla ACTUAL z1, przy tym samym right-completion scope:
`Q_Re(Droot)(z1_C)<=2*3913789077504+2*2^31*(0.036)^2<8000000000000`.
Wynika to z quadratic triangle bound, root real-spectrum upper2^31 i
pointwise reconstruction defect. Root transfer używa ciaśniejszego rozdziału
Z*+defect zamiast tej dodatkowej, luźniejszej scalar energy majoranty.

ROOT correlations dają **|Lroot_C|²/Re(Droot_C)<77565**, bez assumption
rounded determinant=q. Source root CM/add errors są doliczone osobno.
Wyjściowy U ma frequency cap **20099472117** oraz mathematical inverse-eval
coefficient cap **786308210**. Mathematical inverse-eval nie jest source iFFT.

### 4. Closed left invariant

Current target rozdzielono na exact coefficient-grouping SIGNAL z U i
HISTORY/ROUNDING deviation. Źródłowe split/merge mają ponownie sprawdzony
allowance Γ=2^-36,tau=2^-800, z outward rounding na2^-50. W aktualnej
kolejności2→1→0/right→left każdy mu1 jest ograniczony przed pierwszym ZERO;
rx/updated mu0 są liczone dopiero po prawidłowym normal return i drugi bound
jest sprawdzany przed drugim ZERO. Returned arrays pozostają residualami.

768 per-terminal records lewej gałęzi dają **|mu|<=937866518**. Domains
wszystkich consumed primitives są ustalone przed instrukcjami; cancellation,
signed zeros i subnormals nie znikają z modelu. Repeated products mają te
same input words dzięki frame, lecz add/sub errors nie są uznane za zerowe.

## Kompozycja, fault i scope caller

Odebrany ORDERED right bound156276714 pozostaje przy historycznym partial
statusie. W nowym checkpointcie każdy active floor jest albo w prawej
gałęzi, albo ma poprzedzające actual right completion z faultNONE (sticky
flag wyklucza wcześniejszy fault). W drugim przypadku działa nowy transfer.
To daje pełny root finite-prefix wniosek z globalnym boundem937866518.

Po current mu proofie normalized-width i scalar arithmetic facts forward
wykluczają source fault guards w certified legal context/byte interface.
Outside-domain/test faults mają osobny scope: return0 nie jest close residual,
caller nadal wykonuje arithmetic przed checkiem3374. Stutter/nonreturn nie
tworzy caller update i nie jest returned0. Nie dowiedziono whole rejection
lub Sign termination. Caller/retry frame dotyczy legal defined prefixes,
także norm-rejected entries, bez futureQ<B. P_key/Emitted/K_seed/M0 bez zmian.

## Weryfikacja

Lean: **31 modułów,206 twierdzeń,27 nowych**,26 inherited byte-identical
i fresh rebuilt. Czyste final logs, pełne types/terms/axioms, tylko standardowe
propext/Classical.choice/Quot.sound. Bez sorry/admit/native_decide/
Lean.ofReduceBool, aksjomatu celu lub warning suppression.

```text
LeftAudit.stdout SHA-256
6bbcb7c9405aebbf7b4059a533502ce1f4e3ae5eee16111a0efdd6af8166aa4f
LeftTypes.stdout SHA-256
2dfaabb12c6918f6e65283cfa905126d7c8c86670484a86ffbfeb56251b1b51a
```

Normal C i ASan/UBSan: **PASS** (LSan nie deklarowany). Nowe kontrole:
-3 publiczne source-built Gram/raw/stable/normalized trees,5 ordered
  sampling cases z normal/fault/nonreturn i pełnymi source words/frames;
-700 terminal/bank cases na140 D words, oba width classes, wszystkie banki,
  progi±8ULP, zero/Half/cross terms i actual updated mu0;
-19968 exact local Hermitian comparisons na wszystkich levels/cubic;
  independent RBF256 whole right reconstruction/energy/root-product oracle;
-no-op i10 wykonanych negative mutations bank/paired/A2/reversal/metric/
  imaginary/conjugation/snapshot/cancellation/current-center dependencies.

Fixtures są publicznymi local-domain arrays/tapes, nie generated keys,
P_key/emitted witnesses lub probabilistic law. Countermodels błędnych
silniejszych identities nie są bug reports dla required source domain.
Uniform inequalities pochodzą z derivation, nie największego fixture.

Zachowano także failed drafts: brak U² w początkowym normC allowance został
naprawiony przez3U*16+128eta; final factor6/margins pozostały te same.
Initial Lean normalization/redundant-hypothesis attempts także są zachowane.

## Replay i freeze

Świeży **FRESH_REPLAY_PASS,228/228** semantic matches,70.908 s,689 seed members,
bez project olean/bin/cache. Odtworzono wszystkie nowe boundy/proofs/controls/
oracles/mutations i certificate. Pełne receipts/streams zostały zachowane.

```text
Rehearsal anchor SHA-256
cbf153c46a403351bc9b26ed0bf3424f7095d96a9174620dbca509f413a9afe2
artifacts/fresh_replay.json SHA-256
10ae868cbd29a7050928aab7a826b20d14c03f2ad2945989513aea448be4c69e
LEFT_ROOT_CORRELATED_TRANSFER_CERTIFICATE.json SHA-256
8dd030760431dd5e4913f1384be20bbcbd8fb6cb7b215f604a7de7bfc1d97cbc
```

OUTPUT_SCOPE/REPLAY definiują exact manifest, frozen completed COMMANDS
prefix i external pin przed fresh DEST. Rehearsal ma kotwicę bez cyklu.
Kontrola po freeze zapisuje wyłącznie nowy DEST przy pakiecie RO; jej wynik
i external REPORT/OUTPUTS hashes są przekazane w handoffie.

## Podsumowanie dla właściciela

**Udało się zamknąć wcześniejszą lukę lewej gałęzi** i skomponować pełny
zero-aware NumericCenter przed floor dla certyfikowanych root/caller finite
prefixes. Nowy wynik opiera się na source bank/metryka/error bridge, nie
na awansowaniu dawnego idealnego diagnostyku lub zgodnych hashy.

**Otwarte:** whole sampler/Sign termination, source postprocessing iFFT/rint/
narrowing/serialization, sampler law, retry/ROM-QROM/reduction/security i
pełne CT. Old CenterClass/H3_RANGE zachowują odrębny status. Nie ma twierdzenia
o bezpieczeństwie całego schematu lub nieomylnym publicznym API.

**Znaczenie:** ZERO ma teraz właściwą, forward-udowodnioną przesłankę dla
obu gałęzi; usuwa to konkretną blokadę H3 bez zmian kodu lub domeny kluczy.
**Następny krok:** SOURCE_POSTPROCESSING_AND_PRECAST oraz SOURCE_SAMPLER_LAW,
z nowym exact interface z NEXT_INTERFACE.md, potem dalsza kompozycja.

source_changed=false,production_source_changed=false,new_source_patch_integrated=false,
owner_accepted=false. Odbiór/import/commit należą do prowadzącego. Ta sesja
kończy własne bounded jobs na handoffie; nocny RUN_002 pozostaje osobną pracą.
