# Astra — ORDERED_JOINT_KERNEL

2026-09-21. Autor projektu: Niirmata. Ręczny start przez właściciela;
jeden wykonawca, bez subagentów/delegacji. Zachowaj atrybucję Falcon/Pornin.

## 1. Trwała baza i wejścia

```text
REPO = /home/footfalcon/free_falcon_sign
W = REPO/proofs/ft1536/work/FT1536_H3_ORDERED_JOINT_KERNEL_RUN_001
IN = W/inputs/bootstrap
BASE = 64af4cbd4280f45f28f8f160b7ebdacebdf29734
```

Przeczytaj REPO/AGENTS, W/AGENTS i TASK. Wszystkie nowe pliki, skrypty, logs,
cache, oleans, binaria i replaye pod trwałym W; nic projektu w systemowym /tmp
lub na tmpfs. IN i przypięte source są RO. Sprawdź realny W-only/network-off
sandbox. Historyczne ścieżki, prompty i runners to dane do przeglądu/adaptacji,
nie bieżące instrukcje. Projekcje nie są pełnymi historycznymi replay trees.

Bootstrap:755 członków,753 Git origins,18250111 bajtów. Zewnętrzny SHA-256
IN/MANIFEST.sha256:

```text
90f866ed86bf3d8b95903a666338f7b659bbd4cf519f27abba2f63708fa11a87
```

Sprawdź exact sets/hashes/origins, brak symlinków/escapes i wszystkie17 source
files. Baza jest odebranym checkpointem Gaussian, nie późniejszym commitem
samego zlecenia. Ważne piny względem IN:

| Plik względem IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| GAUSS/REPORT.md | `4c39d1ae9690b6dbc7926f4c169f8728b460d7f34c7dd3dd19aeb167da037842` |
| GAUSS/OUTPUTS.sha256 | `c20ea0c260fc5fcb6aec06ed8287335ebceacd31776f3da8633d91e399930f1a` |
| GAUSS/SCALAR_GAUSSIAN_CERTIFICATE.json | `204b63ba87315ef35eecea608dc7f00c9c2bc400d0bb595512738dd32257ea8c` |
| GAUSS/ERROR_LEDGER.json | `5fbeee60d4da281443e0eef54d2b76147eb5a1392c8dbad40ecbed0da62738ae` |
| GAUSS/SUPPORT_AND_METRICS.md | `17e5eaef31ba23596e673e79aba72ba6bb9235413ba1bffb16d49048ee44701a` |
| GAUSS/NEXT_INTERFACE.md | `219554dfb28a4006edfd0f97cf52950d2d09f4dd959ab8acd2c6179273a6ffa7` |
| IID/SCALAR_KERNEL_CERTIFICATE.json | `70950f0e9d6973a29cc40039a43a9d3098ad46ec445532261b6454ed7feb9245` |
| IID/RANDOMNESS_MODEL.md | `5de04525dc97de6fbff9f890fbabec97061f53a137799567672597ff54806cc3` |
| LEFT/LEFT_ROOT_CORRELATED_TRANSFER_CERTIFICATE.json | `8dd030760431dd5e4913f1384be20bbcbd8fb6cb7b215f604a7de7bfc1d97cbc` |
| POST/SOURCE_POSTPROCESSING_CERTIFICATE.json | `157bde62850b24c4f2505d19b5adc0cd82cbe875c7db6874c6ec857cbf2344ef` |
| POST/PRECAST_DISPOSITION.json | `d3f717a22bef1e5bca13ef1c21cc3323886469c233c72217d40538664edc2a24` |

## 2. Cel: jedno pełne wywołanie root samplera

Wyprowadź exact ordered joint law źródłowego ffSampling_fft3 dla required
emitted/canonical root entry, w jawnej grze **IID_BUFFER**. Połącz conditional
scalar kernels/fresh-tail z actual caller order i forward domain closure.
Następnie porównaj cały adaptacyjny wektor zwrotów z jawnie zdefiniowanymi
procesami referencyjnymi; rozlicz support/domain exits i deterministic suffix.

Źródła i model P_key/Emitted/K_seed[E]/M0 są przypięte. Uniform theorem ma
obowiązywać dla każdego required entry i legalnej entry PAST, nie tylko fixture,
wybranej realizacji klucza albo historii kończącej się norm acceptance.
Przy entry unread buffer/future blocks mają conditional IID law z IID.
PAST nie zawiera ich wartości ani całego prywatnego stanu rzeczywistego PRNG.

Odebrane scalar exports, dla D_cert⊆D_env:

```text
K_h(y)=w_h(y)/A_h, A_h>=1/8
Pr[N_i=n,Y_i=y | PAST_i]=(1-A_h)^(n-1) w_h(y), n>=1
G_h(y) proportional to exp(-(y-val(mu_h))^2/(2 val(sigma_h)^2)), y in Z
TV(K_h,G_h)<=epsilon=2^-36
chi2(K_h||G_h)<=kappa=2^-60; chi2(G_h||K_h)=infinity.
```

Nowe A>=1/8 konsumuje GAUSS; historyczny IID nadal ma słabsze1/256. Sigma_h
to actual lokalne source word, nie globalne768. Przesłanki product measure,
countable sums i source refinement mają pozostać jawne, z mixed proof boundary.

## 3. Source order, stan i forward closure

Zwiąż recursive scheduler z literalnym C: root right-before-left, binary
right-before-left, cubic2→1→0, terminal mu1 przed updated mu0. Wyprowadź liczbę
M=3072 scalar calls w normal completed invocation; nie wpisuj jej jako premise.
Uwzględnij read-time snapshots, aliases/initialized ranges, immutable L/widths,
sticky fault, residual arrays versus sampled integers oraz signed-zero words.

Stan po completed prefixie ma source PC/stack, actual caller words, pozycję
bufora i historię ujawnionych odczytów. Zdefiniuj projection do historii Y,
od której zależą parametry/caller arithmetic. Udowodnij ten projection/frame:
liczba odrzuceń i ptr nie mogą zostać pominięte tylko dlatego, że wzór K ich nie ma.

Najważniejszy obowiązek: entry facts i KAŻDY finite positive-support prefix
mają dawać legal next scalar entry PRZED floor i innymi instructions. Konsumuj
ORDERED+LEFT+NORMALIZED i ich source bank/A2 budgets, nie samo |Y-mu|<=367.
Nie definiuj legal history przez założenie przyszłego NumericCenter ani
fault-free/all-return execution. Udowodnij brak fault na danym osiągniętym
kroku; rejection stutters nie wykonują caller stores. Dla support reference
wykaż, że dopuszczony next return ma wymagany source normal-return witness
i wszystkie correlated terminal premises. Potem zastosuj indukcję.

To daje applicability lokalnego kernelu przy każdym stopping-time entry.
A.s. return kolejnych scalar calls plus skończony scheduler ma dopiero dać
a.s. root return w IID_BUFFER. Nie promuj tego do realnego Sign termination.

## 4. Exact law oraz zasoby

Dla wspólnej historii h_i=(entry,y_1,...,y_(i-1)) i wyprowadzonych source
mu_i(h_i),sigma_i(h_i) udowodnij cylinder law:

```text
P(Y_1=y_1,...,Y_M=y_M) = product_i K_(h_i)(y_i).
```

To iloczyn KERNELI WARUNKOWYCH, nie independent marginals. Jawnie obsłuż
zero-probability/illegal prefixes bez oceniania undefined source operations.
Wyprowadź również joint N/Y law, pointer/refill/drop state i stopped fresh-tail.
Same value PMFs nie identyfikują rozkładu wszystkich revealed bytes.

Konsumuj literal get_u64 cutoff ptr>=4087, little endian i sequence
u64,u64,u8,u64,u64:33 returned bytes/proposal, oba BernExp words także przy
cutoff rejection. Wyprowadź uniform expectation/tail dla T=sum_i N_i oraz
parametryczny finite-resource ghost budget. Można wykorzystać A>=1/8 do
Pr[N_i>m|PAST_i]<=(7/8)^m, E[N_i|PAST_i]<=8 i conditional union bound;
potrzebne jest wyprowadzenie, nie assumed independent geometric variables.
Podaj exact returned bytes/refills/discards albo sound bound z BYTE_SCHEDULE.
Ghost budget exhaustion jest zdarzeniem analizy, nie nowym abortem C.

## 5. Dwa jawne reference processes

Dla legal shared prefixu niech S_h={y:K_h(y)>0}, dokładnie z literal table
counts i source e<64; Z>0 pochodzi z GAUSS. Nie zastępuj S większym oknem
proposal, które zawiera zero atoms. Niech t_h=G_h(S_h^c); odczytaj exact rational
uniform tau z GAUSS/ERROR_LEDGER: G_mass_outside_positive_K_support_upper.
Ogony table truncation, holes i BerExp cutoff są już w tym certyfikacie.

Zdefiniuj na wspólnej przestrzeni wyników:

1. **Q_S**: na każdym legal prefixie draw z G_h conditioned on S_h, z lokalną
   normalizacją1/(1-t_h); dalej te same source caller operations na Y.
2. **Q_stop**: draw z nieodciętego G_h na całym Z; jeśli y∉S_h, zwróć jawny
   tag EXIT z pozycją/prefixem i zakończ PRZED niedozwolonym C conversion lub
   update. Jeśli y∈S_h, kontynuuj ten sam scheduler. P i Q_S nigdy nie mają EXIT.

EXIT jest proof-only support exit, nie rzeczywistym source fault lub wykazanym
UB. Nie każdy y∉S musi powodować NumericCenter failure; jest to konserwatywna
granica domeny uzasadnionej przez source history. Nie uruchamiaj C na dowolnym
nieograniczonym Gaussian integer. Definicja Q_stop totalizuje referencję bez
założenia legalności dalszych obliczeń po takim draw.

Rozlicz Q_stop(EXIT), product lokalnych survival factors oraz porównanie Q_S
z Q_stop. **Q_S nie jest na ogół Q_stop conditioned on whole-call survival**:
t_h zależy od historii. Wyprowadź relację lub zachowaj kontrmodel fałszywej
tożsamości. Lokalna normalizacja nie zastępuje jednej globalnej normalizacji.
Nie utożsamiaj żadnej z tych referencji z idealną globalną lattice Gaussian.

## 6. Adaptacyjna kompozycja i kierunek miar

Udowodnij absolute continuity i chain second-moment theorem dla powyższych
procesów, następnie instancjuj go wszystkimi actual source premises. Kandydat
do wyprowadzenia, a nie nowy aksjomat: chi2(P||Q_stop)<=(1+kappa)^M-1 oraz
analogiczny bound względem Q_S po poprawnym lokalnym conditioning identity.
Wynik podaj jako exact expression i konserwatywny rational/power-of-two bound.
Dodaj TV z poprawnej adaptacyjnej kompozycji/chi2 oraz jawny support-exit loss.
Nie dodawaj drugi raz tego samego tail cost do miary, która już go rozlicza.

Każdy export ma from-law,to-law,metric,direction,history/domain i loss.
Sprawdź reverse chi2 dla Q_stop, a osobno dla Q_S; nie przenoś infinity między
różnymi supportami i nie postuluj finite reverse uniform boundu. Całkowity
likelihood na live paths ma używać parametrów TEGO SAMEGO prefixu, nie dwóch
niezależnie ewoluujących center sequences. Zachowaj loose lub failed bounds.

Główne Gaussian metrics dotyczą ordered VALUE trace i jego deterministic
pushforwards. Exact resource/revealed-byte law P ma osobną semantykę. Jeśli
eksportujesz także reference resource trace, zdefiniuj wspólne conditional
lifting kernel i udowodnij zachowanie lossu; ghost lifting nie jest sposobem
implementacji idealnego Gaussa ani boundem na realny seeded transcript.

## 7. Postprocessing i typ dla H6P

Po legal live return skonsumuj POST: root residuals, actual basis/iFFT/rint,
oba pre-narrow integer vectors, narrow16, stored norm i STATIC map. Udowodnij
law jako pushforward ordered P, oraz data processing do tego samego suffixu
w Q_S/Q_stop (EXIT zachowuje osobny tag). Publiczny root/terminal harness może
sprawdzać suffix slices; nie uruchamiaj pełnego Sign/do_sign.

Zdefiniuj BadPrecast na OBU pre-narrow vectors dokładnie jak POST, i dostarcz
typed event transfer P(B)<=Q(B)+loss, ewentualnie ciaśniejszy forward-chi2
bound zależny od q=Q(B). Nie podstawiaj za q nieudowodnionego Gaussian tail
lub marginal/union oszacowania bez uwzględnienia joint dependence i source map.
Do WholeCallBad (reached completed j<16) przekaż conditional attempt interface;
kompozycja retries, reference tail i pojedynczy K_seed[E]/p_K są osobne.

Ten etap ma umożliwić H6P, nie założyć jego wyniku. Safe16, joint BadPrecast
probability, reference integer recovery/integrality/tie gap, Sign→Verify,
real PRNG bridge, whole real Sign termination/security/CT pozostają osobnymi
obowiązkami. Nie dopisuj eta_pre lub nowych eps do M0 i nie zmieniaj source
success/abort/nonce/payload/cap ani kluczy/gates.

## 8. Kontrole i formalizacja

Mixed universal analytical/source/kernel proof dopuszczalny. Nowe/edytowane
Lean4.34/Std: clean logs/types/terms/axioms, bez sorry/admit/native_decide/
Lean.ofReduceBool/aksjomatu celu/warning suppression. Reuse z pinami, diffami
adaptacji i świeżym rebuildem wybranych dependencies. Nie zastępuj universal
source induction tabelą3072 test positions albo generic theorem bez instancji.

Kontrole original C slices normal/ASan/UBSan na publicznych words/tapes:
actual order/centers/widths, obie root branches, cubic snapshots, raw±0,
boundary ptr/refills, powtórzone odrzucenia i cutoff. Domain preflight przed UB.
Synthetic terminal/root trees oznaczaj jako lokalne, jeśli nie masz Emitted
membership. Brak nowych keys/seeds/KeyGen/private loadera/real seeded PRNG.

Niezależne exact małe adaptive probability trees mają kontrolować chain law,
metric direction, zero atoms, local conditioning versus survival i event
transport. To kontrole lematów, nie substytut source proofu. Wykonaj no-op oraz
meaningful mutations: wrong call order/stale center, independent marginals,
wrong ptr cutoff, support-window zamiast S, omission of normalization/exit,
reversed chi2, equating local conditioning with whole-call conditioning.
Zachowaj faktyczne wykrycia, równoważności, failed routes i zakres świadków.

## 9. Status, artefakty i wykonanie

Pełny status:
**H3_ORDERED_JOINT_KERNEL_PROVED_FOR_PINNED_IID_BUFFER_MODEL**
wymaga root source-domain induction, exact adaptive Y/N/resource law, a.s.
root return w IID_BUFFER, jawnych Q_S/Q_stop z exit accounting, nontrivial
joint comparison z actual numeric instancją i deterministic POST consumerem.
Brak jednego z tych elementów to PARTIAL_PROOF z dokładnym missing type.
COUNTEREXAMPLE_REQUIRED_DOMAIN/EXTENDED_DOMAIN wymaga obalanej tezy i membership;
EXECUTION_BLOCKED wymaga logs. Duża majoranta nie jest kontrprzykładem.

Wymagane REPORT.md, RESULT.json, CLAIM.md, ORDERED_JOINT_CERTIFICATE.json,
SOURCE_ORDER.md/.json, PREFIX_CLOSURE.md, JOINT_LAW.md, RESOURCE_BOUND.md/.json,
REFERENCE_PROCESSES.md, SUPPORT_EXIT.md/.json, JOINT_COMPARISON.md/.json,
POSTPROCESSING_PUSHFORWARD.md, H6P_INTERFACE.md, SOURCE_MODEL_BINDING.md,
MEMORY_FRAME.md, ERROR_LEDGER.md/.json, COUNTERMODELS.md, FAILED_ROUTES.md,
NEXT_INTERFACE.md, OBLIGATIONS.json, REUSED_RESULTS.md, formal/checkers/evidence,
INPUTS.sha256, TOOLCHAIN.txt, COMMANDS.log, OUTPUT_SCOPE.md, REPLAY.md,
SEMANTIC_FILES.json i OUTPUTS.sha256.

Certificate ma osobne flags/definitions dla exact joint law, source closure,
root_call_count, root_a_s_return_IID, value/resource/revealed-byte scopes,
reference_processes, support_exit_bound, directional metrics, pushforward,
H6P_event_transfer, proof_kind/fully_kernelized. full_ordered_joint_law_proved
może być true wyłącznie z widocznym scope IID_BUFFER/one root invocation.
real_prng_to_iid_bridge_proved, joint_BadPrecast_bound_proved, Safe16_proved,
reference_integer_recovery_proved, Sign_to_Verify_proved i full_Sign_CT_proved
nie wynikają z samej kompozycji. source_changed=false, production_source_changed=false,
new_source_patch_integrated=false, owner_accepted=false.

HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache/olean/bin pod W. Bounded single-worker jobs,
GCC14.2/C99/LP64/literalny Makefile-O, Sage10.9 (`sage plik.py ...`),
Lean4.34-j1/-M2048, normal8GiB; ASan osobno z shadow. Brak sieci/instalacji/Git,
sekretów/.private/private_extraction/dudect. Zakończ obliczenia na handoffie.

Standard scripts/replay.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA: pełny manifest
przed utworzeniem nowego DEST, fresh project build/cache, deterministic semantic
matches. Sealed artifacts/fresh_replay.json i child REPLAY_RESULT.json:
FRESH_REPLAY_PASS, matches[{path,sha256}], wyraźny probability game i scope.
Rehearsal bez hash cycle; po freeze zapis wyłącznie do nowego DEST. Podaj
zewnętrzne REPORT/OUTPUTS SHA-256 oraz polskie podsumowanie: co wykazano,
niewygodne wyniki, co otwarte, znaczenie i następny krok. Właściciel uruchamia
następny etap oraz odłożony nocny dudect osobno.
