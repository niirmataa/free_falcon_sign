# FT1536 H3_ORDERED_REACH — raport etapu

2026-09-20. Autor projektu: **Niirmata**.

## Wynik główny

**PARTIAL_PROOF.** Pełnego `ORDERED_REACH → NumericCenter` dla obu gałęzi
root nie domknięto. Nie zgłoszono błędu C ani required-domain/emitted
counterexample. Otwarty pozostał correlated/weighted transfer do lewej
gałęzi po aktualizacji root targetu.

Istotny fragment jest udowodniony: dla required emitted/canonical normalized
root entry i wszystkich legalnych finite source histories, każdy aktywny
pre-floor point2864 w **pierwszej wykonywanej, prawej gałęzi root** spełnia:

```
finite(mu), |val(mu)| <= 156276714
NumericCenter lower margin: 1991206569
NumericCenter upper margin: 1991206568.
```

Obejmuje1536 structural active-call positions tej gałęzi, z source
right-before-left order i pełnym normal-return supportem. Jeśli rejection
nie kończy się, następny caller step nie następuje. Jeśli fault stał się
sticky, następne calls omijają floor; nie użyto dla fault0 close residual.
Nie zakładano fault-free trace, typowych próbek lub przyszłego Q<B.

Proof kind: **MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PARTIAL_PROOF**.
Kernel supporting lemmas są pełne w swoim zakresie; analytical right-prefix
instancja jest jawna. `fully_kernelized=false`, `C_compiler_verified=false`.

## Baza, piny i write scope

BASE `99ceb981cb0ef76e9e72b59ce325485b1908412f` — odbiór TARGETS wskazany
przez właściciela. Commit przygotowania zadania1677960 nie zastępuje tej
bazy. W sesji nie wykonywano Git/index/branch/import/commit.

Sprawdzono bootstrap396 members/394 public origins/8324239 bytes, każdy
hash/rozmiar/exact set i brak symlinków/escapes. INPUTS obejmuje400 records
z TASK/AGENTS/manifestem. Źródła17 files to archived FLOOR_CT candidate,
nie zastany Extra/c.

```text
CANDIDATE.sha256
56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985
TASK SHA-256
f1852f4e8012033174a7d9d224ec7fca348a5bedb0d346fc61f33bb92290aeae
bootstrap MANIFEST SHA-256
28a57d2c8e1361a7bc035b56426563187cf3903e1aa1cd1fa3ac4eeb5e1a3edc
```

Realny W-only/network-off bwrap, bootstrap/source RO, mount/probe receipts.
HOME/TMP/DOT_SAGE/LEAN_PATH/cache/olean/bin lokalne. Jeden bounded worker,
normal8GiB, Lean4.34/Std-j1/-M2048, ASan osobno z shadow. GCC14.2.0-19/C99/LP64
i literalny Makefile profile. Bez sieci/instalacji/subagentów, KeyGen/private
loadera/pełnego do_sign/Sign, nowych kluczy/seeds/sekretów lub dudect.

## Co zostało rzeczywiście wyprowadzone

### Source scalar outcomes

Rozdzielono ACTIVE_PRE_FLOOR, NORMAL_RETURN, REJECTION_STUTTER/NONRETURN
i FAULT_RETURN. Source sticky flag daje: późniejszy aktywny floor wyklucza
wcześniejszy fault w tej samej invocation. Current NumericCenter jest
dowodzony przed ZERO, a nie zaszyty w definicji historii.

Normal source return ma formę floor_C(mu)+z z z∈[-365,366], po actual CDF/
selector i bit b. Bank supports wynoszą29/59/118/235/365. Po current-domain
proofie ZERO daje signed32 return i residual≤366+2^-20. Dla normal returned0
oraz fault returned0 tags pozostają różne. Raw−0 jest legalne w NumericCenter;
nie ogłoszono historycznej old CenterClass jako proved przez rename.

Local scalar-internal domains są rozliczone przy NumericCenter+normalized
width+legal context/word-read interface: dss<1,gap<2,r/delta∈[0,1],k²≤133225,
2k≤730,x<2^19,BerExp scaled floor argument<2^20,0≤s<2^20,safe_s0..63.
Source expm input product<2^85 i integer Horner/wrap są defined. Nie oparto
się na komentarzu0..393. To arithmetic/support scope, nie Bernoulli accuracy,
sampling law lub rejection termination. Legal PRNG byte-read interface jest
jawny; nie zakładano uniformity lub nieograniczonego source execution.

### Signed transfers, base0 i rzeczywista kolejność

Sampling zatrzymuje się na logn0, builder na1. Terminal SplitDeep1/MergeDeep1
otrzymały własny source-bound contract z IW1I/W1R/W1I i signed input domains,
half zero/subnormal behavior. Fresh RBF/QQ checker obejmuje511 użytych
twiddle pairs i25 independent terminal input comparisons.

Base: first mu1→normal residual r1→half rx→NOWY mu0→second residual→last
subtraction rx. Returned caps to |z0|<552,|z1|<367, nie dwa sampled integers
i nie dwa residuale o tym samym boundzie366. Invariant zachowuje ten porządek.

Root najpierw t1/branch1; cubic2,1,0; binary right,left. Current snapshots
i output initialization są prowadzone jawnie. Repeated products mają te
same operand words dzięki frame, co kontroluje się także w complete traces;
same add/sub errors nie są przez to automatycznie zerowe.

### Right-branch bound i memory/caller

Pierwsza próba z lower binary L<2 dawała cap1537123758. Refinement z actual
positive H i direct component division daje |L_C|<1+2^-40 bez nowego key
premise. Dokładna outward ordered recurrence z G=1+2^-32 i additive1 zamyka
wszystkie current centers pierwszej root branch do156276714. Per-path mu1/
mu0 records i returned caps są w ERROR_LEDGER/bounds.json.

Source frame na defined prefixes zachowuje normalized tree/key, root targets,
hm i zewnętrzne outputs. Sampling scratch peak8702 w capacity10752; nie
wymaga niezmienności martwych temporaries. Callback context jest oddzielnym
write footprint. Caller3357 rzeczywiście resetuje fault i wybiera sampler_large.
Legal retry entry po norm rejection nie potrzebuje future norm acceptance,
ale propagacja przez unproved sampling/postprocessing i pre-cast safety
pozostaje osobną przesłanką/obowiązkiem. Outer fault check jest dopiero po
do_sign, więc fault tail nie jest immediate stop.

## Co nie zostało domknięte — pierwszy konkretny brak

Po prawej gałęzi, przy faultNONE, source root mul/add1818–1820 ma proved
domain i coarse updated-target cap3864968087959271. Jest to bound ZA LUŹNY
do domknięcia następnych active scalar centers. Dalsza kandydacka recurrence
daje7729936365272004, ale nie jest full safety theorem — stosowanie ZERO
poza zamkniętym NumericCenter byłoby kołem.

Sprawdzono dalsze drogi: coefficient/inverse-eval transport TARGETS oraz
legacy ideal T5/A2 geometry i bank-specific weighted support. Ideal-scale
budget sugeruje correction cap275528238, ale **nie jest source boundem**.
Brakujące źródłowe ogniwa to raw-L/stable-D Gram distortion, actual root-gain
perturbation i ordered residual energy/roundoff transfer do KAŻDEGO left
pre-floor point. Nie wolno utożsamić raw L z idealnym LDL po stable rebuild.

Dokładny missing type i premises są w NEXT_INTERFACE. FAILED_ROUTES odróżnia
luźny bound, brak metric proofu i syntetyczny extended-domain witness od
required-domain/emitted counterexample. Nie zmieniono C/P_key/Emitted lub
goal, nie dodano clipping/probabilistic wyjątku/abortu/epsilon.

## Formalizacja i kontrole

Lean: **28 modułów,179 twierdzeń,23 nowe**,24 inherited modules byte-identical
i przebudowane. Czyste final logs i pełne nowe types/terms/all axioms,
tylko propext/Classical.choice/Quot.sound. Bez sorry/admit/native_decide/
Lean.ofReduceBool/aksjomatu celu/warning suppression.

```text
ReachAudit.stdout SHA-256
b4c03465ec708d1a58c7ecc8bd3b6c002a25b7a18ee18eb49a7ca87c70ea33bb
ReachTypes.stdout SHA-256
2e2d61039aafc8dec6604e11d540d3fd1cf41f7ac64a45253fe826825142d107
```

Normal C oraz ASan/UBSan: **PASS**. Kontrole obejmują8 publicznych cases
samej original ffSampling recursion, full3072 positions przy completed top,
signed zero, support endpoints,4096 stutters przed return/nonreturn,
fault na początku/między paired calls/na końcu oraz duży fault residual.
Pełne ordered centers/sigmas/tags, arithmetic/poly snapshots,10752-word
memory, frames/canaries są bitowo zgodne z niezależnym integer/dyadic modelem.
504 scalar slices porównały actual CDF/u128/cutoff/expm integer computations.
LSan nie jest deklarowany. Publiczne tapes nie są secret seeds, probabilistic
law lub emitted witnesses.

No-op i9 negatywnych kontroli: wrong root order, omitted Split1, stale mu0,
omitted last subtraction, late snapshot, fault-as-close, nonreturn-as-zero,
hidden NumericCenter i typical-support cap. Pełne mutation states/traces
zachowano. Unsafe synthetic2^40 center zatrzymano przed floor, bez nadania
mu required-domain membership. Skończone kontrole nie dowodzą głównej tezy.

## Replay, freeze i dziennik

Fresh pre-freeze **FRESH_REPLAY_PASS,225/225** semantic matches,76.073 s,
494 seed members, bez project olean/bin/cache. Ponownie wykonano exact bounds,
transfer/scalar contracts,kernel,C/model/ASan,mutations i partial certificate.
**Replay PASS nie zmienia PARTIAL_PROOF na pełny dowód.**

```text
Rehearsal anchor SHA-256
c1b333c63fc94ff27d37f11e5eab8acd99981461317f403a6835f77f8d10dde1
artifacts/fresh_replay.json SHA-256
8cf96ae414f86d3b55ee9521d6ac34879878054a7db1a5235765f0f57bc47e69
ORDERED_REACH_CERTIFICATE.json SHA-256
faf925b20fb459b002790e61ed76014335c20cb5ff22688d24dbb9b3719947fe
```

Zachowano dwie failed setup/resume próby (Half w innym miejscu projekcji,
ponowny copy na RO source) wraz z receipts; późniejsze piny/sandbox checks
przeszły. OUTPUT_SCOPE/REPLAY opisują exact manifest, frozen completed
COMMANDS prefix i standard external pin przed fresh DEST. Rehearsal anchor
nie tworzy cyklu. Po freeze standard check zapisuje tylko nowy tmp DEST;
external REPORT/OUTPUTS piny i rezultat są w handoffie.

## Podsumowanie dla właściciela

**Udało się:** uporządkować source outcomes bez koła, zamknąć NumericCenter
całej pierwszej root branch, terminalny source bridge i istotne frame/scalar
domains; odtworzyć pełne kontrolne traversals i zachować wszystkie receipts.

**Nie wyszło:** pełny transfer do lewej gałęzi. To obecnie brak wystarczającego
skorelowanego dowodu, a nie potwierdzony błąd kodu. Sam duży bound nie
rozstrzyga realnego overflow lub reachable counterexample.

**Znaczenie:** pozostała luka H3 została zawężona do konkretnego source
weighted-energy/left-prefix interface. Dotychczasowe accepted RAW/NORMALIZED/
TARGETS zachowują swoje zakresy; nie ogłoszono globalnego Reach, sampler law
lub bezpieczeństwa całego Sign.

**Następny krok:** osobny LEFT_ROOT_CORRELATED_TRANSFER — raw-L/stable-weight
metric/error bridge, bank-specific support i complete left-prefix invariant,
potem kompozycja obu halves. Postprocessing/pre-cast/serialization, whole
termination/law/ROM-QROM/security/CT pozostają osobnymi obowiązkami.

source_changed=false,production_source_changed=false,new_source_patch_integrated=false,
owner_accepted=false. Odbiór/import/commit należy do prowadzącego. Obliczenia
tego etapu mają finite jobs i kończą się na handoffie; nocny RUN_002 jest
oddzielnym zadaniem prowadzącego, którego ta sesja nie uruchamiała.
