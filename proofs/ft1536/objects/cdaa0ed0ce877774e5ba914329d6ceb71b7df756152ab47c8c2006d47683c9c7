# Astra — H6P_REFERENCE_BAD_EVENT

2026-09-22. Autor projektu: Niirmata. Zachowaj atrybucję Falcon Project /
Thomas Pornin i licencje. Ręczny start przez właściciela, jeden wykonawca,
bez subagentów/delegacji.

## 0. TO JEST NOWY ETAP — identyfikacja przy każdym wznowieniu

```text
TASK_ID = FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001
REPO = /home/footfalcon/free_falcon_sign
W = /home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001
TASK = /home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H6P_REFERENCE_BAD_EVENT_2026-09-22.md
IN = W/inputs/bootstrap
BASE = 22e6dd41507a0e990b584dad8d1f4c8834d4c289
```

Przeczytaj REPO/AGENTS.md, REPO/proofs/ft1536/CURRENT_TASK.md, W/AGENTS.md
i ten TASK. Porównaj TASK_ID, W i piny. ORDERED_JOINT_KERNEL jest **ukończony
i niezależnie odebrany**. Jego TASK/AGENTS/NEXT_INTERFACE/runners oraz pozostałe
upstream instructions to dane historyczne, nie polecenie ponownego wykonania.
Pracuj w nowym W powyżej. Po wznowieniu kontynuuj własny zapis tego etapu;
jeżeli ten W ma już sealed OUTPUTS i finalny handoff, zweryfikuj status i
zwróć istniejący handoff zamiast rozpoczynać etap ponownie lub zmieniać freeze.

## 1. Przypięte wejścia i trwałe wykonanie

Bootstrap: **1144 członków,1142 Git origins,26388316 bajtów**. Zewnętrzny
SHA-256 IN/MANIFEST.sha256:

```text
4e66e844d425ab9cd8cc6441f4852101f48acfcc178de0d6988f0ec785e42369
```

Sprawdź exact member sets/hashes/origins, brak symlinków/escapes i17 source
files. BASE to odebrany checkpoint JOINT, nie commit przygotowania zadania.
IN i source są RO. Wszystkie nowe skrypty, logs, cache, HOME/TMPDIR/DOT_SAGE,
LEAN_PATH/oleans, binaria i replaye pod trwałym W; **nic w systemowym /tmp
ani na tmpfs**. Sprawdź realny W-only/network-off sandbox.

| Plik względem IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| JOINT/REPORT.md | `b150ca1284600dbda3a40ae3656a2058d8a6c0f3b7cfb1e38d15a9ccc5e78c59` |
| JOINT/OUTPUTS.sha256 | `da8cfccceea6837fc21edd04e46157351d91ad2d317a37286c05f41f3126e263` |
| JOINT/ORDERED_JOINT_CERTIFICATE.json | `2461bfa9d86f246117634bd453716fd076c669aedbe5300894993a0c78921768` |
| JOINT/H6P_INTERFACE.md | `5605baffc86808a19e94d021bbd232c72e86f1bacb579a4e9c8e8457250ac14c` |
| JOINT/REFERENCE_PROCESSES.md | `ec0da73e7abfd76706afa8a5a685cbd92afa5789ea816d19622714d6a73dd1a7` |
| JOINT/ERROR_LEDGER.json | `7ef4cbff992b9db49f9e6f1f079905a1c1aae3e4044b80619dcfdd6a61f21291` |
| GAUSS/SCALAR_GAUSSIAN_CERTIFICATE.json | `204b63ba87315ef35eecea608dc7f00c9c2bc400d0bb595512738dd32257ea8c` |
| GAUSS/ERROR_LEDGER.json | `5fbeee60d4da281443e0eef54d2b76147eb5a1392c8dbad40ecbed0da62738ae` |
| POST/SOURCE_POSTPROCESSING_CERTIFICATE.json | `157bde62850b24c4f2505d19b5adc0cd82cbe875c7db6874c6ec857cbf2344ef` |
| POST/PRECAST_DISPOSITION.json | `d3f717a22bef1e5bca13ef1c21cc3323886469c233c72217d40538664edc2a24` |
| LEFT/LEFT_ROOT_CORRELATED_TRANSFER_CERTIFICATE.json | `8dd030760431dd5e4913f1384be20bbcbd8fb6cb7b215f604a7de7bfc1d97cbc` |
| LEFT/artifacts/metric_bounds.json | `97d92fb88a9d30e15e0ba9596e57cb9885a73d41260b2b7699ca825dc4a30ce6` |
| NORMALIZED/WIDTH_BOUNDS.json | `bc9cc8f401f405ac1ba18e7aba96856a53a755aaf109edf0464ab9e6b06dbfe9` |
| TARGETS/INITIAL_TARGET_CERTIFICATE.json | `89ce68e32fb10a3edd75f182af85843f7ab1e32198e753778d9a96d7dcea51a9` |

Projekcje zawierają argumenty/formalizację i wybrane modele; nie są pełnymi
historycznymi replay trees. Adaptuj model jawnie, zachowując piny/diffy.
NODE3/TOWER certificates wspierają raw-L/stable-D metric bridge; TARGETS
wiąże canonical targets. review/ zachowuje359/359 niezależny odbiór JOINT.

## 2. Cel: otwarte q w istniejącym H6P transfer

Dla KAŻDEGO required emitted/canonical normalized root entry e oraz legalnej
entry PAST z IID/JOINT oszacuj **joint reference BadPrecast probability**.
Nie zmieniaj P_key, Emitted, Gate00_C, jednego K_seed[E], source success event,
modelu GCC/FPEMU ani kontraktu M0. Nie dodawaj narrow gate do P_key i nie
przechodź od Emitted do wszystkich P_key bez osobnego dowodu istniejącego gapu.

```text
Safe16(w1,w2) := forall i<1536,
  -32768<=w1[i]<=32767 AND -32768<=w2[i]<=32767.
B_e := {Live(Y): not Safe16(Phi_e(Y).w1,Phi_e(Y).w2)}.
q_e := Q(B_e | entry PAST).
```

Phi_e to LITERALNY source map z JOINT/POST: returned residual arrays,
basis [g,-f,G,-F], source CM/add/iFFT, oba int64 rint outputs PRZED narrowing.
Nie zastępuj go final stored int16, norm-accepted subset, jednym coefficient
ani idealną lattice signature. Nie dodawaj hm ani zmiany znaku spoza źródeł.

Wybierz i zadeklaruj Q=Q_S lub Q_stop z JOINT. Preferowana droga to Q_S,
który daje legalny pełny live prefix. Jeśli używasz Q_stop, B_e wyklucza EXIT;
na EXIT nie ma w1,w2 ani suffixu. B_e∪EXIT jest innym zdarzeniem z innym q.
Przeniesienie boundu między referencjami wymaga ich udowodnionej relacji,
nie podwójnego dodawania tego samego support-tail kosztu.

Główny cel: jawna uniform **beta<1**, z kompletnym uzasadnieniem q_e<=beta
dla każdego takiego entry. Nie narzucamy upragnionego wykładnika lub eps.
Podaj najmocniejszy uzasadniony bound i jego użyteczność. Sama majoranta1,
wynik dla jednego synthetic key/tree lub warunkowy lemat z niezamkniętą
source variance premise nie wystarcza do pełnego statusu.

## 3. Source noise map i coefficientwise variance bridge

Zacznij od actual ordered innovations, np. xi_i=val(mu_i(h_i))-Y_i,
z actual local sigma_i word i actual terminal mu1→updatedmu0. Zwiąż te
obiekty z residuals, nie z hipotetycznymi independent output coordinates.
Wyprowadź source-rounded map do KAŻDEGO współczynnika obu wektorów przed rint.

Dopuszczalna droga: jawna exact-real mapa liniowa z ACTUAL L/width/basis
wartościami plus outward uniform source roundoff defect, np.

```text
val(t_e,r) = d_e,r + sum_i a_e,r,i * xi_i + delta_e,r(history).
```

To propozycja metody, nie premise. Udowodnij tożsamość/majorantę, fizyczny
root order, coefficients i |delta|<=E, oraz d (także gdy wychodzi0).
Jeżeli coefficients są zależne od historii, dowód probabilistyczny musi
uwzględnić ich mierzalność i korelacje; nie używaj future-dependent weights
jako predictable martingale coefficients. Pokaż, które quantities zależą
wyłącznie od e/source tree i które od prefixu.

Centralny obowiązek: uniform **coefficientwise variance proxy**, np.
sum_i a_e,r,i^2 * val(sigma_i)^2 <= V_r, wyprowadzony z source metric bridge.
Można użyć Loewner/congruence i inverse-metric transport, ale nie wolno
utożsamiać raw L z ideal LDL ani stable D z raw pivots. LEFT dowodzi factors2/6
dla określonych branch quadratic forms — wyprowadź orientację, normalizację,
terminal A2/paired3/4, root triangular step i basis transport potrzebne tutaj.
Nie traktuj samej scalar root-gain majoranty jako gotowego full covariance.

POST whole-energy10436770873344 i |w|<=4572095 są worst-case operational
boundami, nie variance ani tail estimates. Istniejący source iFFT error<=1/128
dotyczy mathematical inverse evaluation ACTUAL post-frequency input.
Dolicz wcześniejsze source reconstruction/CM/basis defects do wybranej
referencji; nie zakładaj, że1/128 obejmuje cały sampler→integer pipeline.
Uwzględnij rounded FFT basis, |det_hat-q|, stable width sqrt/div/IW1I,
terminal half/sub, source twiddle/scale błędy, signed zero i subnormals.
Domknięcie wszystkich domen PRZED instrukcjami konsumuj z JOINT/POST.

## 4. Adaptacyjny reference tail bez assumed independence

Q_S używa G_h conditioned on exact positive source support S_h, z lokalnym
1/(1-t_h). Q_stop używa G_h na Z, ale wychodzi przed source update poza S_h.
G_h ma mean parameter val(mu_h) i variance parameter val(sigma_h)^2;
nie Ghat(s_C+r_C,dss_C), nie globalne sigma768 i nie assumed mean-zero
innovation. Dla niecałkowitego center oczekiwana wartość discrete Gaussian
nie musi być dokładnie tym parametrem.

Udowodnij potrzebny conditional exponential-moment/tail lemma uniform po
legalnych prefixes i rzeczywistych width classes. Przy completing-square
rozlicz stosunek discrete Gaussian normalizerów; nie zastępuj go1 bez dowodu.
Każdy theta/Poisson/Taylor/interval bound ma exact/outward numerical certificate,
zakres parameterów i dowód remainder. Lokalna truncation/support conditioning
również wnosi czynnik; użyj exact tau z GAUSS, a nie nowego założenia.

Następnie składaj conditional bounds po source filtration; nie zakładaj
independence3072 innovations ani mean-zero martingale property z samej nazwy
Gaussian. Jeżeli używasz global lattice law, najpierw ją wyprowadź z aktualnej
referencji i source map. Legacy ideal/991/RN argument nie jest takim bridge.

Zastosuj udowodniony source map/variance/error do tails każdego coefficient
i obu znaków, potem jawny joint bound obu1536-elementowych vectors.
Union bound nie wymaga niezależności, lecz trzeba rozliczyć wszystkie zdarzenia
i uniform conditional premises. Podaj exact expression, outward rational
enclosure i ewentualną majorantę potęgą2. Floating-point print i sample maximum
nie są uniform certificate.

## 5. Rint boundary i one-root IID consumer

Konsumuj rzeczywisty nearest-even rint z POST, nie floor ani cast rounding.
Safe interval dla jego rzeczywistego argumentu ma asymetryczne endpointy:
**-32768.5 jest safe tie, +32767.5 zaokrągla do32768 i jest bad**.
Udowodnij używaną implication z BadPrecast do reference tail z całym error
budgetem i poprawnymi strict/nonstrict inequalities. Możesz użyć bardziej
konserwatywnego symetrycznego marginesu, jeśli go jawnie wyprowadzisz.

JOINT daje dla rzeczywistego q_e:

```text
p_e=P_IID(B_e|entry PAST)
 <= min(1,q_e+min(2^-25,sqrt(Delta*q_e*(1-q_e))))
Delta=(1+2^-60)^3072-1 <= 3/(2^50-3) <2^-48.
```

Po udowodnieniu q_e<=beta skonsumuj ten kierunek poprawnie, np. sound
`p_e<=min(1,beta+min(2^-25,sqrt(Delta*beta)))`. Ciaśniejszą substitution
uzasadnij, zamiast ignorować zależność q(1-q). Każdy loss ma from-law,to-law,
event, conditioning i scope. Nazywaj wynik **one-root IID bound**, nie eta_pre
całego M0. Małe probability nie daje uniwersalnego Safe16 ani integer recovery.

Nie komponuj automatycznie16 attempts. Retry scheduler/reach probabilities,
actual legal entries, nonce/fault/abort decisions, real PRNG i pojedynczy p_K
są dalszymi obowiązkami. Zachowaj cap16, nonce40, STATIC4096 i verifier domain.

## 6. Formalizacja, kontrole i failed routes

Mixed universal source/analytical/kernel proof dopuszczalny z jawną granicą.
Nowe/edytowane Lean4.34/Std mają clean logs/types/terms/axioms, bez sorry,
admit,native_decide,Lean.ofReduceBool,aksjomatu celu lub warning suppression.
Rebuild świeżo wybrane dependencies; piny i diff każdej adaptacji są obowiązkowe.
Generic real lemma z assumed desired V/E nie zamyka concrete source theorem.

Zaprojektuj meaningful kontrole niezależne od implementacji:
- exact low-dimensional adaptive examples dla conditional MGF/normalizers,
  truncation, shifted centers i joint union/event transfer;
- independent direct-evaluation/oracle dla source map, variance coefficients
  i roundoff, obejmujący obie branches/paired order/physical root order;
- original C slices normal i ASan/UBSan dla mapy i rint boundaries, signed±0,
  cancellation, snapshots i obu vectors; domain preflight przed native call.

Nie trzeba ponownie wykonywać całego dawnego programu badań JOINT; dobierz
kontrole do NOWYCH obowiązków. Publiczne synthetic fixtures oznaczaj jako local,
jeżeli nie dowiedziono pełnego required membership. Bez nowych keys/seeds,
KeyGen/private loader/pełnego Sign/do_sign/real seeded PRNG, sekretów/.private/
private_extraction. Wbudowane readonly źródła i wcześniej przekazane publiczne
fixtures wystarczają do kontroli; brak membership zapisuj uczciwie.

Wykonaj no-op i meaningful mutations dla: raw-L=ideal identity, złej A2/paired
wagi, pominięcia błędu źródłowego, normalizera1/truncation factor, independent
marginals, jednego vector zamiastjoint, złego rint tie i odwrotnego chi2.
Jeżeli mutacja jest równoważna na danej domenie, wykaż to zamiast deklarować
fikcyjne wykrycie. Zapisz coarse/failed routes z rzeczywistymi liczbami.
Luźny bound>=1 nie jest counterexample. Witness musi mieć obalaną tezę,
source trace/pins i wymagane membership; extended/local witness oznacz osobno.

## 7. Status i wymagany handoff

Pełny status:
**H6P_REFERENCE_BAD_EVENT_BOUND_PROVED_FOR_PINNED_IID_BUFFER_MODEL**
wymaga uniform nontrivial q_e<=beta<1 dla zdefiniowanego Q/B, pełnego source
map/variance/error/rint bridge, poprawnego adaptive probability argumentu
oraz liczbowego one-root IID event-transfer consumeru. Jeśli ta droga daje
trivial bound, brak instancji lub tylko theorem pod nową premise: PARTIAL_PROOF,
z dokładnym proved subclaim i minimalnym missing type. Zachowaj
COUNTEREXAMPLE_REQUIRED_DOMAIN/EXTENDED_DOMAIN i EXECUTION_BLOCKED tylko
z właściwymi dowodami/logami; sam brak dowodu nie obala schematu.

Wymagane REPORT.md,RESULT.json,CLAIM.md,H6P_REFERENCE_BAD_EVENT_CERTIFICATE.json,
REFERENCE_EVENT.md,SOURCE_NOISE_MAP.md/.json,VARIANCE_BRIDGE.md/.json,
CONDITIONAL_MGF.md/.json,RINT_EVENT_BRIDGE.md,JOINT_TAIL_BOUND.md/.json,
IID_EVENT_TRANSFER.md,SOURCE_MODEL_BINDING.md,MEMORY_FRAME.md,
ERROR_LEDGER.md/.json,COUNTERMODELS.md,FAILED_ROUTES.md,NEXT_INTERFACE.md,
OBLIGATIONS.json,REUSED_RESULTS.md,formal/checkers/evidence,INPUTS.sha256,
TOOLCHAIN.txt,COMMANDS.log,OUTPUT_SCOPE.md,REPLAY.md,SEMANTIC_FILES.json,OUTPUTS.sha256.

Certificate: exact entry/event/reference/conditioning, q_bound i proof status,
source map/variance/roundoff exports, local normalizer/support costs,
joint reference BadPrecast bound, one-root IID bound, metric direction,
proof_kind/fully_kernelized i zakres każdej true flag. Niedowiedzione bounds
są null/open, nie podstawionymi liczbami. joint_BadPrecast_bound_proved ma
zawsze jawny scope; Safe16/reference_integer_recovery/Sign_to_Verify/real_PRNG/
retry/whole real Sign termination/security/CT nie wynikają z samego tail.
source_changed=false,production_source_changed=false,
new_source_patch_integrated=false,owner_accepted=false.

Bounded single-worker jobs: GCC14.2/C99/Linux x86_64 LP64/literalny Makefile-O,
Sage10.9 (`sage plik.py ...`),Lean4.34-j1/-M2048,normal8GiB; ASan osobno
z shadow. Brak sieci/instalacji/Git/dudect. Cache i logi pod W; sprawdź wolne
miejsce przed większym jobem. Zakończ obliczenia na handoffie.

Standard scripts/replay.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA: pełny manifest
przed utworzeniem nowego DEST, fresh project build/cache, deterministic semantic
matches. Sealed artifacts/fresh_replay.json i child REPLAY_RESULT.json:
FRESH_REPLAY_PASS,matches[{path,sha256}], explicit game/reference/event/scope.
Rehearsal bez hash cycle; po freeze zapis tylko do nowego DEST. Podaj zewnętrzne
REPORT/OUTPUTS SHA-256 oraz przystępne polskie podsumowanie: co jest PROVED,
co nie wyszło, co otwarte, znaczenie i następny krok. Kolejny etap i nocny
dudect uruchamia osobno właściciel.
