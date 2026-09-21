# Astra — SCALAR_GAUSSIAN_COMPARISON

2026-09-21. Autor projektu: Niirmata. Start ręczny przez właściciela;
jeden wykonawca, bez subagentów/delegacji.

## 1. Trwała baza i piny

```text
REPO = /home/footfalcon/free_falcon_sign
W = REPO/proofs/ft1536/work/FT1536_H3_SCALAR_GAUSSIAN_COMPARISON_RUN_001
IN = W/inputs/bootstrap
BASE = 6f1f34cb63ad34315fb306f1f4117fec48cfd7cc
```

Przeczytaj REPO/AGENTS, W/AGENTS i TASK. Kanoniczny main jest w REPO, a wszystkie
nowe pliki/logs/cache/replaye wyłącznie pod trwałym W. Nic projektu w systemowym
/tmp lub tmpfs. IN/source/bootstrap RO; sprawdź rzeczywisty W-only/network-off
sandbox. Historyczne ścieżki w zamrożonych danych pozostają proweniencją.

Bootstrap:489 członków,487 publicznych origins Git,12621645 bajtów.
Zewnętrzny SHA-256 IN/MANIFEST.sha256:

```text
30721120fb8ed7721aa4fe14f960fe90a0614221e58cbb3d7bd523fedc25de27
```

Sprawdź exact sets/hashes/origins, brak symlinków/escapes. Wybrane projekcje
zachowują swoje OUTPUTS i nie są całymi replay trees. Stare prompty/runners
są danymi do przeglądu/adaptacji w nowych kopiach, nie aktywnymi poleceniami.

| Plik względem IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| IID/REPORT.md | `28a46ed15039e7cb8fc610874ce64cc87436eeeba4ba110beb9ba3152033d903` |
| IID/OUTPUTS.sha256 | `0923f85b0290b4b1e57b4f7af356bd58e327cac68d235805e6a8c78d4e622a8f` |
| IID/SCALAR_KERNEL_CERTIFICATE.json | `70950f0e9d6973a29cc40039a43a9d3098ad46ec445532261b6454ed7feb9245` |
| IID/CDF_MASS.json | `c7d58f8c7599844b418c98b051cb12e62860f60cc0cdf9a15b7f6a2d9482a3b4` |
| IID/ACCEPTANCE_FLOOR.json | `8c966263c7b48e0c687f03fe44ddd6c60b32665fed22da541dce8b93bf8047e8` |
| IID/NEXT_INTERFACE.md | `7a108495b225e209227d470b44278139c63fea7ea8f84b1bb5aabef5d7741cfd` |
| IID/PRNG_GAP_INTERFACE.md | `39c61c676d49eab5af15bc96acdaf056252d16f99868e520c472a291f4e3b9d3` |
| NORMALIZED/WIDTH_BOUNDS.json | `bc9cc8f401f405ac1ba18e7aba96856a53a755aaf109edf0464ab9e6b06dbfe9` |
| ZERO/ANALYTIC_PROOF.md | `579b8614c249dc2f1a6938d600f6b234e85ef6a441ef922bde5570e304d93918` |
| POST/PRECAST_DISPOSITION.json | `d3f717a22bef1e5bca13ef1c21cc3323886469c233c72217d40538664edc2a24` |

## 2. Cel i zakres probabilistyczny

Odebrany IID kernel daje exact K_C(mu_word,sigma_word)=w_y/A, A>=1/256,
conditional fresh-tail, scalar a.s./resource bounds w jawnej grze IID_BUFFER.
To nie twierdzenie Gaussian closeness, realnego PRNG lub Sign→Verify.

Wyprowadź ilościowe, source-bound porównanie K_C z NIEZALEŻNIE zdefiniowaną
scalar reference law. Główna reference na WSZYSTKICH y∈Z:

```text
m = val(mu_word), v = val(sigma_word)^2
G_(m,v)(y) = exp(-(y-m)^2/(2v)) / sum_(z in Z) exp(-(z-m)^2/(2v)).
```

To lokalna sigma danego wywołania, nie globalne sigma_sign768 ani nominalna
variance proposal banku. Definicja G nie korzysta z computed K_C/acceptance
weights. Jeżeli używasz intermediate machine-parameter Gaussian, zdefiniuj
osobno m_hat=floor_C(mu)+val(r_C), d_hat=val(dss_C),
G_hat(y)∝exp(-d_hat*(y-m_hat)^2), a potem rozlicz G_hat→G. Nie zamieniaj
tych dwóch celów bez jawnego transportu.

Wymagany output: uniform quantified total-variation bound i directional
chi-square/likelihood information w dokładnie wskazanej domenie, albo konkretna
przeszkoda/countermodel. **Mały błąd nie jest założeniem ani narzuconym wynikiem.**
Nie ma zatwierdzonej liczby epsilon do osiągnięcia; podaj wynik nawet gdy jest
duży i kryptograficznie nieprzydatny. Sam TV<=1 lub najwyższy observed grid error
nie stanowią domknięcia ilościowego source argumentu.

Każda probability i conditional law dotyczy IID_BUFFER i legalnej PAST z
IID/RANDOMNESS_MODEL, bez conditioning na unread buffer/future tape, przyszłym
norm acceptance lub Sign success. real_prng_to_iid_bridge_proved pozostajefalse.

## 3. Domena i source identities

Rozróżnij D_cert: required scalar entries odebranego IID/LEFT/NORMALIZED, od
ewentualnego D_env: jawnego nadzbioru raw words spełniających wybrane numeric/
width/selector envelopes. Udowodnij D_cert⊆D_env, jeśli na nim liczysz uniform
bounds. Counterpoint D_env nie jest automatycznie emitted/source-reachable
witness. P_key, Emitted, K_seed[E], M0 i source success event pozostają ustalone.

Konsumuj literalne CDF masses n_j,k/2^128 oraz fixed source first-bank selection.
Source correction x_C(k,b) ma actual delta_b (r lub sub_C(1,r)), gap, k²,
mul/add order. BerExp export:

```text
e=floor_C(mul_C(x,inv_ln2)), rB=sub_C(x,mul_C(of_C(e),log2)),
Z=expm_scaled_C(rB)>>8,
Beta_C=0 if e>=64, else min(Z,2^55)/2^(e+55).
```

Nie zakładaj Beta_C=exp(-x), source remainder∈[0,log2] albo e<=393 na podstawie
komentarza. Dotychczasowy ogólny domain proof dawał jedynie e<2^20 i |rB|<2^21.
Wykorzystaj first-bank bounds/couplings, aby wyprowadzić potrzebne ciaśniejsze
envelopes w NOWYM certyfikacie. Raw−0 ma floor_C=-1,r_C=1; endpoint1 i subnormals
mu nie mogą zniknąć przez zastąpienie source floor matematycznym floor.

## 4. Kolejność analizy: najpierw reduction/expm domains

Najpierw sprawdź każdą przesłankę potrzebną do probability-accuracy argumentu:

1. Actual k/dss/selected-coefficient/delta constraints per bank i obu width
   classes, source x bounds przed instructions. Luźny product box nie może
   zastąpić zachowanych selector correlations.
2. e/rB powstałe przez source FPEMU. Sprawdź granice wokół wielokrotności ln2,
   actual rounded multiplication/of/sub, e0 i cutoff63/64. Ustal, czy i gdzie
   rB jest ujemne lub przekracza binary64(log2); nie zakładaj odpowiedzi.
3. Dla wszystkich osiągalnych klas rB rozlicz actual fpr_trunc/mul_high/Horner
   uint64 recurrence. Podany w komentarzu proof expm[0,log2] nie jest dostarczonym
   certyfikatem dla szerszej domeny. Jeśli rB<0, unsigned conversion/shift może
   zmienić argument word polynomial; nie podstawiaj idealnej exp continuation.
4. Źródłowe Z>>8, low55 comparison, saturation i e>=64 cutoff. Część wspólna
   z IID jest bit-exact; nowa jest ilościowa relacja do funkcji rzeczywistej.

Ewentualny błąd przesłanki albo duża source-vs-exp różnica jest wynikiem do
zachowania. Nie clampuj remainder, nie koryguj e, nie zmieniaj coefficients,
cutoff lub programu, aby dopasować proof. Nowy kandydat C wymaga osobnego etapu.

## 5. Ledger porównania i normalizacji

Wyprowadź oddzielnie, z poprawnymi dependencies/domains:

- Literal table PMF vs q_j(k)∝exp(-a_j*k²), k>=0, gdzie a_j jest EXACT DYADIC
  coefficient word używanym przez correction. Nominalne5/20/80/320/768 nie
  zastępują jego wartości. Certyfikuj truncation/threshold quantization i
  normalizer half-line; komentarz generatora nie jest proofem exact equality.
- x_C vs właściwy exact quadratic expression, z r/delta errors i przeliczeniem
  m_hat/d_hat na m/v. Generic ZERO error może być luźny: refinement jest dozwolony
  wyłącznie z tych samych źródeł/premises, w nowych kopiach z diffami.
- Source BerExp acceptance vs reference weight, w tym reduction/Horner/count
  errors, forced zero atoms i finite support. Nie wymagaj dodatniości wszystkich
  proposal atoms w returned law: IID jawnie dopuszcza zero acceptance.
- Związek accepted unnormalized weights i normalizerów. A>=1/256 można
  konsumować; jeśli trzeba ciaśniej, wyprowadź nowy bound, nie postuluj9/20.
- Final normalized K_C vs G_hat oraz G. Nie sumuj różnych miar bez poprawnego
  twierdzenia transportu i nie zgub kosztu normalization/conditioning.

Wszystkie real bounds muszą mieć outward rational/interval enclosure i jawny
infinite-tail proof. Exact-RBF/QQ/root certificate może wspierać argument;
float sampling albo interpolacja punktów nie dowodzą uniform supremum.
Uwzględnij endpoints bank selection i raw-word boundaries, nie tylko wnętrza
ciągłych interval boxes. Zachowaj oba zero words i rzeczywisty shift s_C.

## 6. Support, kierunek miary i strata odcięcia

K_C ma finite positive support, a untruncated G ma dodatnią masę na Z.
Zdefiniuj używane miary i sprawdź absolute continuity PRZED obliczeniem lossu:

```text
TV(P,Q) = (1/2) sum_y |P(y)-Q(y)|
chi2(P||Q) = sum_y (P(y)-Q(y))^2 / Q(y)
```

Jeśli Q(y)=0<P(y), odpowiednia chi-square jest∞. Nie eksportuj finite boundu
w kierunku G||K bez rozliczenia tego faktu. Możesz użyć jawnej reference G_S
warunkowanej na zadeklarowanym support S, ale podaj t=G(S^c), koszt G_S→G
i dokładny zakres obu directional comparisons. S może uwzględniać rzeczywiste
zero atoms po cutoff; nie zmieniaj definicji głównego G, aby ukryć ogon.

Nie stosuj nieograniczonego high-order Rényi/likelihood-ratio theorem ponad
luką supportu. Każdy export do przyszłej kompozycji ma from-law,to-law,
metric/direction, domain, conditioning i numeric/symbolic loss. Wyprowadź
to, co rzeczywiście jest skończone, i zachowaj wyniki negatywne.

## 7. Kontrole, świadkowie i klasyfikacja

Użyj exact kernel IID jako niezależnie odebranego source transducer/PMF i
nowego reference Gaussian evaluator z rygorystycznym infinite-tail boundem.
Kontrole normal C/ASan/UBSan w samych oryginalnych scalar/BerExp/primitive
slices na publicznych words/tapes; bez real seeded PRNG, keys/KeyGen/private
loadera/pełnego Sign/do_sign. Domain preflight PRZED potencjalnym UB.

Obejmij bank boundaries, obie width classes, raw±0,r/delta0/1, zmiany e,
okolice source m*ln2, cutoff63/64, threshold0/2^55/saturation oraz source
fixed-point boundaries. Wybrany WORD x może być tylko extended BernExp input:
jeśli nazywasz go scalar-derived, pokaż actual mu/sigma/k/b i identyczne x_C.
Jeśli nazywasz go emitted/reachable, udowodnij także tę silniejszą przynależność.

54 stare PMFs to kontrola wiązania, nie coverage nowego uniform theorem.
Celowane wyszukiwanie publicznych scalar words może ujawnić przeszkodę;
każdy świadek musi mieć dokładne source bits/native confirmation i certified
reference/divergence interval. Nie generuj kluczy. Rozróżnij: kernel input,
local envelope, normalizer-derived standalone leaf i rzeczywisty Emitted entry.

No-op i meaningful wykonane mutations: pominięcie signed-zero shift,
nominalny zamiast dyadic coefficient, ignorowanie table quantization,
ideal exp zamiast exact BerExp, zły remainder-domain transfer, usunięcie
cutoff/saturation, pominięcie normalizera/tail mass i odwrócony kierunek chi2.
Zachowaj rzeczywiste baseline/changed evidence i wszystkie failed routes.

## 8. Formalizacja, status i interfejs

Mixed kernel/universal analytical source proof dopuszczalny. Nowe/edytowane
Lean4.34/Std: clean logs/types/terms/axioms, bez sorry/admit/native_decide/
Lean.ofReduceBool/aksjomatu celu/warning suppression. Reuse z pinami/source/
fresh rebuildem, adaptacje z diffami. Każdy symbolic accuracy consumer ma
otrzymać actual source numerical instance; nie założenie desired epsilon.

Pełny status:
**H3_SCALAR_GAUSSIAN_COMPARISON_BOUND_PROVED_FOR_PINNED_IID_BUFFER_MODEL**
tylko dla jawnego nontrivial uniform TV boundu i poprawnie rozliczonej directional
chi-square/support informacji, wraz z source error/normalizer/tail instancją.
Wartość boundu i jego użyteczność są osobnymi facts; PROVED nie oznacza
automatycznie kryptograficznie małego lossu. Trivial TV<=1 lub same sample maxima
to PARTIAL_PROOF, podobnie jak niedomknięta wymagana domain/error premise.

COUNTEREXAMPLE_REQUIRED_DOMAIN/EXTENDED_DOMAIN wymaga wskazania obalanej
nierówności i membership. Dopuszczalny jest quantitatively certified obstruction
do małego boundu w D_env z otwartym D_cert scope; nie nazywaj tego atakiem na
schemat. EXECUTION_BLOCKED wymaga pełnych logs. Nie modyfikuj C/parametrów/P_key.

Certificate/RESULT: reference_definition, domain_cert, domain_envelope,
cert_to_envelope_inclusion_proved, source_reduction_domain_proved,
source_expm_accuracy_scope, CDF_quantization_bound, correction_error_bound,
normalizer_bound, cutoff_tail_bound, positive_support_definition,
TV_bound_proved/value, chi2_from/to/bound_or_infinite, conditioning_losses,
bound_cryptographic_utility_assessment, proof_kind, fully_kernelized.
Pozostająfalse/open: real_prng_to_iid_bridge_proved, full_ordered_joint_law_proved,
joint_BadPrecast_bound_proved, Safe16_proved, reference_integer_recovery_proved,
Sign_to_Verify_proved, whole_Sign_termination_proved, security_reduction_proved,
full_Sign_CT_proved. Nie dopisuj η_pre do POST lub nowych eps do M0.

NEXT_INTERFACE ma typed consumer dla ORDERED_JOINT_KERNEL/H6P i osobny
PRNG_REAL_TO_IID_BUFFER. Adaptacyjne mu/sigma zależą od PAST; scalar bound
nie jest automatycznie joint product law, whole-call boundem lub poprawnością
reference lattice pair. Single K_seed[E]/p_K i istniejące abort/bytes bez zmian.

## 9. Artefakty i wykonanie

Wymagane REPORT.md, RESULT.json, CLAIM.md, SCALAR_GAUSSIAN_CERTIFICATE.json,
REFERENCE_LAWS.md, REDUCTION_DOMAIN.md/.json, EXPM_ACCURACY.md/.json,
CDF_COMPARISON.md/.json, ERROR_LEDGER.md/.json, SUPPORT_AND_METRICS.md,
NORMALIZATION_BOUND.md, SOURCE_MODEL_BINDING.md, COUNTERMODELS.md,
FAILED_ROUTES.md, NEXT_INTERFACE.md, OBLIGATIONS.json, REUSED_RESULTS.md,
formal/checkers/certificates, INPUTS.sha256, TOOLCHAIN.txt, COMMANDS.log,
OUTPUT_SCOPE.md, REPLAY.md, SEMANTIC_FILES.json, OUTPUTS.sha256.

HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache/olean/bin pod trwałym W. Network-off,
source/IN RO, bounded single-worker jobs; GCC14.2/C99/LP64/literalny Makefile-O,
Sage10.9 (`sage plik.py ...`), Lean4.34-j1/-M2048; normal8GiB, ASan osobno
z shadow. Brak sieci/instalacji/Git/sekretów/.private/private_extraction/dudect.
Nocny RUN_002 wymaga zakończenia obliczeń przed osobnym startem prowadzącego.

Standard scripts/replay.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA: pełny manifest
przed nowym DEST, fresh project build, deterministyczne semantic matches.
Sealed artifacts/fresh_replay.json oraz child REPLAY_RESULT.json:
FRESH_REPLAY_PASS i matches[{path,sha256}]. Rehearsal bez cyklu; po freeze
zapis wyłącznie do nowego DEST. source_changed=false,production_source_changed=false,
new_source_patch_integrated=false,owner_accepted=false. Podaj REPORT/OUTPUTS
SHA-256 i zakończ na handoffie. Podsumuj po polsku osiągnięcia, niewygodne wyniki,
otwarte kwestie, znaczenie i następny krok, z widocznym zakresem IID_BUFFER.
