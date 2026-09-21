# Astra — SCALAR_KERNEL_IID: dokładne prawo scalar rejection w jawnej grze IID

2026-09-21. Autor projektu: Niirmata. Start ręczny przez właściciela;
jeden wykonawca, bez subagentów/delegacji.

## 1. Baza i wejścia

```text
REPO = /home/footfalcon/free_falcon_sign
W = REPO/proofs/ft1536/work/FT1536_H3_SCALAR_KERNEL_IID_RUN_001
IN = W/inputs/bootstrap
BASE = fe6f92af799dc11830998f8ddf9cf1dc591a448a
```

Przeczytaj REPO/AGENTS, W/AGENTS i TASK. Tylko W writable; IN/source/bootstrap
RO. Potwierdź rzeczywisty W-only/network-off sandbox. Source/ jest kopią
aktywnego main po integracji FLOOR_CT,17-file pin56974571…; nie używaj
zastanego checkoutu Extra/c jako automatycznej bazy obliczeń.

Bootstrap:340 członków manifestu,338 publicznych origins Git,5131076 bajtów.
Zewnętrzny SHA-256 IN/MANIFEST.sha256:

```text
eb890ea42dad55d397ebd6f71fad5457676d705e5443a5a672201a0ce6e553a8
```

Sprawdź exact sets/hashes/origins, brak symlinków/escapes. Historyczne OUTPUTS
zachowują własne bazy; projekcje nie są pełnymi replay trees. Historyczne
prompty/runners to dane do przeglądu/adaptacji w nowych kopiach W.

| Plik względem IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| POST/REPORT.md | `4cd7ab1a6f63256ed6c015f3ba9bbef97597d7a68bb948bfd8c9264bab307662` |
| POST/OUTPUTS.sha256 | `b860e5453a7a72716acd8636cc581ff57b1b9c00dff20baa907e4636344d1401` |
| POST/SOURCE_POSTPROCESSING_CERTIFICATE.json | `157bde62850b24c4f2505d19b5adc0cd82cbe875c7db6874c6ec857cbf2344ef` |
| POST/NEXT_INTERFACE.md | `2dd40096ff0b3f5153169ba824ada28619e36607188d3b612a9f90a095d44aca` |
| POST/PRECAST_DISPOSITION.json | `d3f717a22bef1e5bca13ef1c21cc3323886469c233c72217d40538664edc2a24` |
| LEFT/LEFT_ROOT_CORRELATED_TRANSFER_CERTIFICATE.json | `8dd030760431dd5e4913f1384be20bbcbd8fb6cb7b215f604a7de7bfc1d97cbc` |
| ORDERED/SCALAR_OUTCOMES.md | `b48dbaad7807f253467e79d4cdc00cd14e5a73efed357c331daae3b9a7918ed8` |
| NORMALIZED/WIDTH_BOUNDS.json | `bc9cc8f401f405ac1ba18e7aba96856a53a755aaf109edf0464ab9e6b06dbfe9` |
| M0/GAME.md | `91e6323c6c3a7be748b7f029d048c38700eab924bf139b804941c10968ba363c` |
| M0/SOURCE_MODEL_BINDING.md | `8bf8015d4574eaf3ed1bba181b794a732982eeb475860ccc6352e958a8eae8cc` |
| FPEMU/AUDIT_MATRIX.md | `16421168c8aa406ae3053a060cfae2fa127d257bdb81a5694aea0bcf0fd1c727` |

## 2. Cel: jeden dokładny kernel, z jawną granicą idealizacji

POST ma PARTIAL_PROOF: source suffix/iFFT/rint/narrowing/STATIC bytes są
związane, ale joint Safe16, BadPrecast probability, reference recovery i
Sign→Verify pozostają OPEN. Następny łańcuch to SOURCE_SAMPLER_LAW/H6P.
Ten etap zamyka jego pierwszą, wyraźnie ograniczoną część.

Wyprowadź DOKŁADNE prawo jednego wywołania oryginalnego sampler_large w grze,
w której **każdy refill dostarcza świeży niezależny blok4096 uniform bytes**,
natomiast source get_u64/get_u8, pointer/discard schedule, CDF, FPEMU exponent,
BerExp cutoff/comparator i rejection loop wykonują przypięty algorytm.
To nazwany IID_BUFFER game, nie twierdzenie, że realny ChaCha/SHAKE jest IID.

Wymagana domena wejścia: NumericCenter(mu) i certified stored/paired sigma
z NORMALIZED, legal typed context, faultNONE, niezmienne argumenty i tables.
Konsumuj LEFT jako source corollary dla osiąganych mu (bound937866518) i
guard exclusion. Dokładny local contract może być szerszy, lecz quantifiers
muszą być jawne i derived required entries muszą do niego należeć.

Oczekiwany export, dla każdego takiego wejścia i legalnej PAST history:

```text
exact CDF atom masses p_j(k);
exact source one-iteration accepted-output weights w(mu,sigma,y);
A(mu,sigma)=sum_y w(mu,sigma,y), with proved uniform rational A>=a_min>0;
Pr_IID[return y at proposal n]=(1-A)^(n-1)*w(mu,sigma,y), n>=1;
Pr_IID[return y]=w(mu,sigma,y)/A;
Pr_IID[N>m]=(1-A)^m <=(1-a_min)^m;
Pr_IID[N=infinity]=0, E_IID[N]=1/A <=1/a_min.
```

Udowodnij prawidłowy stan pozostałego bufora/strumienia po powrocie i dokładny
API/byte resource interface. Sam unconditional marginal PMF bez interfejsu
do adaptacyjnego następnego call nie wystarcza do przyszłej kompozycji.

## 3. IID buffer i właściwe warunkowanie historii

Source internal.h767–778 ma buf4096,ptr,state,type. get_u64:814–851 sprawdza
`ptr>=sizeof(buf)-9`, refills, potem czyta8 little-endian bytes i dodaje8.
Rozlicz literalną równość ptr4087: komentarz o liczbie pozostałych bajtów
nie zastępuje predykatu. get_u8:857–866 czyta jeden byte i może refillować
PO odczycie ostatniego byte. Nie zastępuj obu getters przez get_bytes.

Zdefiniuj coupling buforowanych IID blocks z ujawnianym/discardowanym prefiksem
strumienia. Wykaż distinct positions, legal read/write ranges, brak reuse,
wpływ suffix drops i fresh unread tail przy kolejnych calls/stopping times.
Źródłowa kolejność zawartości bytes i words pozostaje bez zmian.

Historia probabilistyczna obejmuje dotychczasowe odczyty/outcomes i deterministyczny
stan z nich wyliczony. **Nie warunkuj na pełnej wartości nieprzeczytanego bufora
ani przyszłego tape, a potem nie deklaruj świeżej uniformity.** Bufor może być
wygenerowany wcześniej; ujawniana filtracja/lazy coupling musi to wyjaśniać.
Adaptacyjne mu/sigma mogą zależeć od PAST, nie od jeszcze nieodczytanych bytes.
Legalność kontekstu określa layout/type/ptr; dla probability theorem bufor jest
zmienną losową o wyprowadzonym conditional law, nie dowolnym z góry ustalonym
ciągiem bytes traktowanym równocześnie jako świeży IID.

Oddziel deterministic source state refinement od probabilistic fresh-block
assumption. Realny frng.c282–339/type0→CHACHA20/56-byte initialization i
refill schedule mają osobny PRNG_REAL_TO_IID_BUFFER interface. Nie dowódź
cryptographic uniformity testami PRNG, nie traktuj56 bytes jako automatycznej
standardowej448-bit-key gry. Zachowaj single K_seed[E]/p_K i M0 scope.

## 4. Dokładne masy CDF i bank selection

Source sign2733–2828 i literal adaptive table header. U128=(hi<<64)|lo,
hi i lo pobrane w tej kolejności. K_j=sum_u [U128<T_j,u], z strict unsigned
comparison i512 entries. Wszystkie banki czytają TEN SAM U128; nie są niezależne.
Wybrany j jest pierwszym source ge(dss,coefficient_j), deterministycznym dla
niezmiennego dss; uzasadnij tę niezależność od nowego U128.

Sprawdź rzeczywiste128-bit thresholds, monotonicity, duplicates/zero tails
i supports29/59/118/235/365. Przykładowa postać liczników przy malejących T:
n_j,0=2^128-T_j,0, n_j,k=T_j,k-1-T_j,k (z właściwymi endpoints).
Wyprowadź tę formułę, masy>=0, sumę2^128 i pełne boundary cases. Nie utożsamiaj
zaokrąglonego table PMF z exact exp(-a*k²)/normalizer z komentarza generatora.

b=get_u8&1, z=b?(1+k):-k, output=floor_C(mu)+z. Zachowaj raw−0 i source
r=sub_C(mu,of_C(floor_C(mu))); mu−mathematical_floor(mu) nie jest zamiennikiem.
r/delta mogą mieć endpoint1. Czytaj właściwe float WORDS, nie host approximations.

## 5. BerExp jako integer acceptance count, nie założone exp(-x)

Literal x_C(k,b) z sign2931–2944: gap=sub_C(dss,selected_coefficient),
delta=b?sub_C(one,r):r, kk=k², osobne mul/add w source order. W required
domain ORDERED daje defined scalar arithmetic/guard exclusion, x>=0,<2^19,
BerExp exponent0<=e<2^20 i finite coarse remainder abs<2^21. To NIE dowodzi
0<=remainder<log2 ani prawdopodobieństwa exp(-x); komentarz s<=393 nie jest premise.

Source BerExp:2469–2513:
e=floor_C(mul_C(x,inv_ln2)), rB=sub_C(x,mul_C(of_C(e),log2));
safe_s/over z literal cutoff; pierwszy U64 testuje zero low safe_s bits,
po czym over maskuje acceptance do0 dla e>=64. Drugi U64 jest pobierany
TAKŻE wtedy, gdy pierwszy test lub over dał0. Brak short-circuit return.

Próg Z=expm_scaled_C(rB)>>8, drugi W=U64 & (2^55-1), predicate
`((W-Z) mod2^64)>>63`. Wyprowadź jego dokładną liczbę akceptujących words
w source range Z (z samego uint64 shift Z<2^56). Nie zastępuj tego przez
Z/2^55 bez sprawdzenia zakresu: uwzględnij saturation, endpoints i strictness.
Możliwa postać do UDOWODNIENIA:

```text
Beta_C(x)=0                                      if e>=64;
Beta_C(x)=2^(-e) * min(Z,2^55)/2^55              if 0<=e<=63.
```

Wszystkie FPR/log2/remainder/expm/high-word/trunc operations w tej formule
są faktycznymi word algorithms. fpr_mul_high_u64 wymaga source limb/carry
refinement do high product, jeśli je konsumujesz; same skończone testy audytu
tego nie zapewniają. fpr_trunc outside mathematical truncation domain zachowuje
swój raw transform; nie podstawiaj semantyki, której nie udowodniono.

Exact law jest dopuszczalna także dla źródłowych remainder words spoza
zakresu przyszłego exp-accuracy theorem. Oddziel zero acceptance wynikające
z cutoff/kwantyzacji od positive proposal mass. Nie deklaruj pełnego supportu
returned law na podstawie samego proposal supportu.

## 6. Rejection normalization i dodatni uniform floor

W required nonfault domain jedna proposal iteration pobiera literalnie
u64,u64,u8,u64,u64:33 zwrócone bytes, plus rzeczywiste buffer suffix drops.
Wyprowadź counts/refill bounds dla każdego valid ptr, zamiast zakładać33
fizycznie wygenerowane bytes lub nową inicjalizację PRNG co proposal.

Przy fixed mu/sigma source weights wynikają z p_j(k), bit mass1/2 i Beta_C(x).
Uzasadnij independence wyłącznie przez disjoint/fresh byte theorem. Reject
zmienia PRNG/local state, ale nie mu/sigma, j ani caller target. Z tego wyprowadź
geometric finite-prefix identity, normalizer i outcome law, nie przez definicję
modelu, która już zakłada desired PMF. Fault0 i normal0 pozostają osobnymi tagami.

Znajdź konkretny uniform rational a_min>0 dla wszystkich required raw inputs.
Nie jest wymagane ostre optimum ani dawne9/20. Możliwy kierunek: dodatni
source atom k=0, wybór mniejszego delta i maszynowy dolny bound progu expm
w odpowiednio MAŁEJ wyprowadzonej domenie. Sama dodatniość idealnego exp
nie dowodzi dodatniości integer threshold. Dokładny integer/QQ certificate
ma rozliczać source rounding, coefficients i cały użyty przedział.

A.s. termination dotyczy wyłącznie IID_BUFFER game. Nie jest termination
wszystkich tapes: infinite rejection pozostaje source nonreturn, nie return0
i nie timeout-bot. Z tail/mean wyprowadź typed budget dla zwróconych/discardowanych
bytes i refill blocks, przydatny do przyszłego finite-resource PRNG hop.
Ewentualne analityczne ucięcie liczby proposals jest ghost eventem z kosztem,
nie nowym source cap/abortem.

## 7. Co dokładnie dostaje następny etap

Wyeksportuj conditional scalar kernel dla każdej certyfikowanej PAST history,
z mu/sigma WORDS, aktualnym ptr, return value/outcome, used-byte schedule i
post-call fresh-tail property. Ten typ ma nadawać się do actual right-before-left
kompozycji, gdzie przyszłe mu zależą od wcześniejszych returns. Nie zastępuj
tej kompozycji iloczynem nieudowodnionych niezależnych scalar marginals.

Osobno określ:
- PRNG_REAL_TO_IID_BUFFER: jaki source/state/output-access game i resource
  budget trzeba porównać z IID, gdzie pojawia się computational loss;
- SCALAR_GAUSSIAN_COMPARISON: jeszcze otwarte porównanie dokładnego K_C z
  właściwą reference law, z cutoff/finite-support i kierunkiem miary;
- ORDERED_JOINT_KERNEL/H6P: dalszy consumer exact scalar kernels i joint
  WholeCallBad z POST, obejmujący oba wektory i actual completed attempts.

Nie przypisuj η_pre, zero BadPrecast probability, ideal Gaussian law,
Sign→Verify, full Sign termination lub security przez samo domknięcie tego
lokalnego modelu. Historyczny POST pozostaje PARTIAL_PROOF. Nie zmieniaj
P_key, key conditioning, parametrów, source aborts, tables lub programu.

## 8. Weryfikacja i falsyfikowalność

Native controls tylko na publicznych deterministic byte/refill fixtures,
synthetic mu/sigma words i oryginalnych scalar/getter slices. Dozwolony jest
sam sampler_large z jawnie podstawionym TEST byte/refill providerem, bounded
finite-prefix observation i przygotowanymi tapes kończącymi się acceptance.
Nie uruchamiaj rzeczywistego seedowanego PRNG jako dowodu IID; bez nowych
keys/seeds/KeyGen/private loadera/pełnego Sign/do_sign. Exhausted fixture
zatrzymuje harness, nie zmienia source nonreturn w abort/0.

Normal C/ASan/UBSan porównuj z niezależnym integer/dyadic/rational oracle:
CDF threshold±1 i uint64 carry boundaries, wszystkie banki i shared-U outputs,
source x/e/rB/expm/Z, cutoff63/64 i e0, low55 comparator endpoints, wszystkie
valid start pointers0..4095 i refill boundaries, actual consumed/dropped bytes,
normal/rejected/fault/finite-stutter traces, raw±0 i delta endpoints.
Domain preflight ma poprzedzać potencjalnie niezdefiniowaną native instrukcję.

Nie enumeruj2^128 inputs; dowiedź exact interval atom counts. Finite reduced-width
enumerations i selected full-word controls sprawdzają proof/model binding,
nie zastępują general lemmas. Dla publicznych mu/sigma examples odtwórz exact
normalized PMF i mass conservation; empirical histograms nie są dowodem law.

No-op i wykonane meaningful mutations: <→<= w CDF, first-bank błąd, niezależne
U dla każdego banku, reuse Bernoulli word, pominięcie saturation/cutoff,
early return w BerExp zmieniający trace, off-by-one ptr4087, błędny endian,
brak suffix drop, warunkowanie na unread buffer, replacement nonreturn→0 lub
normalization bez A>0. Zachowaj rzeczywiste receipts, failed routes i scopes.

Mixed analytical/kernel proof dopuszczalny. Lean4.34/Std: nowe/edytowane
moduły mają czyste logs/types/terms/axioms, bez sorry/admit/native_decide/
Lean.ofReduceBool/aksjomatu celu/warning suppression. Finite rational/order
kernel plus jawny analityczny geometric/stopping-time argument jest dopuszczalny;
nie instaluj nowej biblioteki i nie ukrywaj measure-theoretic premises.
Reuse z pinami/source/fresh rebuildem; adaptacje z diffami. Generic theorem
z assumed IID/A>0 jest tylko consumerem do czasu wykazania opisanej instancji.

## 9. Status i przekazanie

Pełny status tego etapu:
**H3_SCALAR_KERNEL_PROVED_FOR_PINNED_IID_BUFFER_MODEL** — wszystkie required
entries, source getter coupling, exact CDF/BerExp weights, uniform a_min>0,
normalized rejection kernel, conditional IID a.s./tail/resource results.
Inaczej PARTIAL_PROOF z pierwszym brakującym typem; counterexamples z dokładnym
domain/game membership albo EXECUTION_BLOCKED z logs. Nie nadaj temu wynikowi
nazwy pełnego prawa source Sign pod rzeczywistym PRNG.

Certificate/RESULT osobno: iid_buffer_game_defined, source_byte_schedule_proved,
past_conditioning_scope, proposal_exact_mass_proved, berexp_exact_probability_proved,
source_uniform_acceptance_lower_bound, iid_rejection_kernel_proved,
iid_scalar_as_termination_proved, iid_tail_resource_bounds_proved,
post_call_fresh_tail_proved, proof_kind, fully_kernelized, C_compiler_verified.
Pozostająfalse/open: all_tapes_termination_proved, real_prng_to_iid_bridge_proved,
full_real_source_sampler_law_proved, full_ordered_joint_law_proved,
Gaussian_comparison_proved, joint_BadPrecast_bound_proved, Safe16_proved,
Sign_to_Verify_proved, whole_Sign_termination_proved, security_reduction_proved,
full_Sign_CT_proved. Nazwa gry i conditioning są częścią każdej probability claim.

Wymagane REPORT.md, RESULT.json, CLAIM.md, SCALAR_KERNEL_CERTIFICATE.json,
RANDOMNESS_MODEL.md, BYTE_SCHEDULE.md/.json, CDF_MASS.md/.json,
BEREXP_INTEGER_KERNEL.md, ACCEPTANCE_FLOOR.md/.json, REJECTION_LAW.md,
PRNG_GAP_INTERFACE.md, SOURCE_MODEL_BINDING.md, MEMORY_FRAME.md,
FAILED_ROUTES.md, NEXT_INTERFACE.md, OBLIGATIONS.json, REUSED_RESULTS.md,
formal/checkers/certificates, INPUTS.sha256, TOOLCHAIN.txt, COMMANDS.log,
OUTPUT_SCOPE.md, REPLAY.md, SEMANTIC_FILES.json, OUTPUTS.sha256.

W-only/network-off, IN/source RO, jeden bounded worker. HOME/TMPDIR/DOT_SAGE/
LEAN_PATH/cache/olean/bin pod W. GCC14.2/C99/LP64/literalny Makefile-O/profile,
Sage10.9 (`sage plik.py ...`), Lean4.34/Std-j1/-M2048; normal8GiB, ASan osobno
z shadow. Bez Git/sieci/instalacji/sekretów/.private/private_extraction/dudect.
Nocna kampania prowadzącego wymaga zakończenia tych obliczeń przed startem.

Standard `scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256`: external
pin/full manifest PRZED nowym DEST, fresh build bez project cache/olean/bin,
deterministyczne matches. Dla prostego importu zapisz sealed historyczny receipt
`artifacts/fresh_replay.json`, z niepustymi matches[{path,sha256}] i statusem
FRESH_REPLAY_PASS; świeży child zapisuje REPLAY_RESULT.json w tym samym formacie.
Rehearsal bez cyklu; po freeze zapisy tylko do nowego DEST.
source_changed=false,production_source_changed=false,
new_source_patch_integrated=false,owner_accepted=false. Podaj REPORT/OUTPUTS
SHA-256, status i zakończ na handoffie. Jawnie napisz, że nowy kernel dotyczy
IID_BUFFER, a przejście z rzeczywistego PRNG jest jeszcze osobnym obowiązkiem.

Na końcu własne przystępne podsumowanie dla właściciela po polsku: co wykazano,
co nie wyszło/pozostało otwarte, znaczenie i następny krok; błąd C vs brak dowodu,
założenie gry, luźny bound i świadomy scope cut.
