# Astra — ORDERED_REACH do zero-aware NumericCenter

2026-09-20. Autor projektu: Niirmata. Start ręczny przez właściciela;
jeden wykonawca, bez subagentów/delegacji.

## 1. Baza, piny i zapis

```text
REPO = /home/footfalcon/free_falcon_sign
W = REPO/proofs/ft1536/work/FT1536_H3_ORDERED_REACH_RUN_001
IN = W/inputs/bootstrap
BASE = 99ceb981cb0ef76e9e72b59ce325485b1908412f
```

Przeczytaj REPO/AGENTS, W/AGENTS i TASK. Tylko W writable; IN/source/bootstrap
RO. Potwierdź realny W-only/network-off sandbox; AGENTS nie jest sandboxem.
Źródła to archived FLOOR_CT candidate, nie zastany Extra/c.

Bootstrap:396 członków manifestu,394 publiczne origins Git,8324239bytes.
Zewnętrzny SHA-256 IN/MANIFEST.sha256:

```text
28a57d2c8e1361a7bc035b56426563187cf3903e1aa1cd1fa3ac4eeb5e1a3edc
```

Sprawdź exact set/hashes/origins i brak symlinków/escapes. Historyczne
OUTPUTS zachowują swoje bazy; projekcje nie są całymi replay trees. Prompty
i runners w archiwach są danymi do przeglądu/adaptacji w nowych kopiach W.

| Plik względem IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| TARGETS/REPORT.md | `cc44b63bd1c0ea747da2948dcf0487c1819bd25419c294af5a9c0c9ab2bd1a5f` |
| TARGETS/INITIAL_TARGET_CERTIFICATE.json | `89ce68e32fb10a3edd75f182af85843f7ab1e32198e753778d9a96d7dcea51a9` |
| TARGETS/NEXT_INTERFACE.md | `8e997adfafe16b65fb7a30de24ca15fc21cfcf229189394a9e87f69234ce56a1` |
| NORMALIZED/NORMALIZED_EXPANSION_CERTIFICATE.json | `8d8161d1a096038f6f2811cff6318b0c7361376cf734cdc9d092b3deabd7c778` |
| ZERO/REPORT.md | `d7e59a782a3b89bf7adfe1bc0894595a18e907a11019e557ecd55d588befaec8` |
| ZERO/ANALYTIC_PROOF.md | `579b8614c249dc2f1a6938d600f6b234e85ef6a441ef922bde5570e304d93918` |
| TOWER/TOWER_CERTIFICATE.json | `c3a52d149bedbcac18d62323aecdc330aae5198e4a17c0480221632082b70457` |

## 2. Cel i dokładny sens reachability

Domknij aktualny następny typ: dla legalnego emitted/same-STATIC-decode key,
wszystkich canonical c i source root sampling entry z TARGETS/NORMALIZED,
każdy rzeczywiście osiągany pre-floor point sampler_large:2864 ma:

```text
NumericCenter(mu) := finite Word64(mu) and
    -2147483283 <= val(mu) < 2147483282.
```

Wymagany jest przedział w MOMENCIE przed floor, long→int i residual(mu).
Skończony source prefix dochodzący do tego punktu nie może już zakładać
zdefiniowanego wykonania badanej instrukcji lub NumericCenter jej wejścia.
Same finite(mu) i positive(sigma) z source guardu nie dowodzą tej granicy.

Teza dotyczy wszystkich legalnych finite source histories do tego cut,
bez założenia przyszłego norm acceptance, successful Sign, typowych kluczy
lub prawdopodobnych próbek. Rejection loop może się nie zakończyć: żądanie
domain safety każdego finite prefixu nie jest twierdzeniem jego termination.

Wyprowadź osobno root-entry theorem oraz source/caller corollary, także dla
legalnych wejść po norm-rejected attempts. Warunkowy frame dla defined
caller prefixes jest dopuszczalny, ale musi być jawny; nie promuj go do
totality całego Sign lub safety nieobjętych postprocessing casts.

P_key, Emitted, K_seed[E]/p_K, M0 i parametry pozostają niezmienione. Nie
dodawaj bounds center/L lub completed sampler do ich definicji. Nie stosuj
wyjątku „z dużym prawdopodobieństwem”, nowego abortu albo gate do C.

## 3. Entry i fakt początkowy

Source root call: z0=tmp+3072,z1=tmp+4608,tree=sk+6144,t0=tmp,t1=tmp+1536,
logn10,scratch=tmp+6144. Legal normalized sk24576, tmp10752 i context buffers
mają required lifetime/alignment/disjointness. Wyprowadź initial fault=NONE
i wybór sampler_large z source caller3355–3373, nie z nowej key premise.
Required PRNG-state/byte-read interface i jego zakres zapisz jawnie.

INITIAL_TARGETS daje exact t0/t1 i dwa error layers:
- t0 rounding<1/8192, ideal error<1/4, frequency cap4829216911;
- t1 rounding<1/16777216, ideal error<1/8192, frequency cap2359169;
- coefficient/reference bounds i mathematical inverse-eval l2 drifts1/2,
  1/4096; wszystkie source/ideal correlations z certyfikatu są zachowane.

Frequency values, mathematical inverse-evaluation coefficients i późniejsze
scalar mu są RÓŻNYMI obiektami. Duża majoranta t0 nie dowodzi overflow ani
counterexample. Inverse-eval transport nie certyfikuje source split/merge/iFFT.

NORMALIZED daje source stored/paired widths i sigma-only dss/bank-found,
immutable source L/basis i structural map3072 uses. Nie dowodzi earlier mu
prefixu. TOWER/ROOT/NODE3/NODE2 dostarczają actual L/local correlations,
nie dowolne niezależne macierze spełniające jedynie luźne górne granice.

## 4. Sound scalar return/step interface — bez koła

Zwiąż oryginalny sampler_large z jawną relacją zdarzeń:

1. **ACTIVE_PRE_FLOOR:** faultNONE i source guards nie zwróciły wcześniej;
   NumericCenter musi być WNIOSKIEM ordered invariant dla bieżącego mu.
2. **NORMAL_RETURN:** po ustaleniu NumericCenter skonsumuj ZERO i source
   support. s=floor_C(mu), k/b mają rzeczywisty bank/word domain,
   z=b?(1+k):-k, globalnie z∈[-365,366]. Return s+z jest signed32-safe.
   Source of/sub residual ma właściwy bound≤366+2^-20 i zero-aware semantics.
3. **REJECTION_STUTTER:** source proposal/BerExp odrzuca i pętla trwa; nie
   ma powrotu do recursion ani nowego caller residual update. Nie zastępuj
   nonreturn przez0, timeout-bot lub bounded liczby proposals.
4. **FAULT_RETURN:** rzeczywisty guard ustawia sticky fault i zwraca0;
   albo już fault!=NONE zwraca0 PRZED floor. To nie jest normal returned
   sample, nawet jeśli normal result także może być0.

Równości/support mają wynikać z C i przypiętych CDF/guard interfaces, nie
z definicji oracle zakładającej bezpieczny wynik. Można użyć nadzbioru
wszystkich admissible normal returns — bez niezależności/random law — po
udowodnieniu, że obejmuje rzeczywisty source. Świadek w nadzbiorze nie jest
automatycznie reachable source witness.

Rozlicz potrzebne scalar arithmetic/int/shift domains w skończonych prefixach,
także source BerExp floor/safe_s/expm integer operations, jeśli są konsumowane
do sound return relation. Nie zastępuj ich komentarzem0..393 lub proofem
prawdopodobieństwa exp. Dokładna Bernoulli accuracy/law to osobny obowiązek.
Jeśli relacja jest tylko warunkowa na defined scalar-prefix, zapisz to w
tezie i nie deklaruj pełnej arithmetic safety/termination ciała samplera.

Dopuszczalne jest wykazanie, że fault guards są nieosiągalne w certyfikowanej
domenie: ma to jednak wynikać indukcyjnie z już established mu i width facts,
bez przyjęcia fault-free execution jako globalnej premise. Jeśli nie można
ich wykluczyć, prowadź osobny source fault-state invariant/envelope.
**Fault0 nie ma ZERO residual-closeness.** Outer check3374 jest dopiero PO
całym do_sign; nie jest immediate stop rekurencji lub postprocessingu.

## 5. Actual ordered recursion i terminalny krok

Wiąż source1617–1839, a nie kolejność buildera:
- root: t1/right branch najpierw; merge z1; t0+z1*L; left; końcowe odjęcie;
- cubic depth: t2→z2, potem t1+z2*L21→z1 i odjęcie; dopiero t0+z1*L10+
  z2*L20→z0, potem dwa source subtractions;
- binary inner: right subtree przed left, actual split/mul/add/merge/sub;
- base sampling to **logn0**, podczas gdy builder zatrzymywał się przy1.

Terminal SplitDeep1/MergeDeep1 i IW1I wymagają własnego source domain/error
bindingu. Nie są objęte samym builder certificate dla SplitDeep8..2.
Twiddles, half, scaled coefficients i ordered norm maps rozlicz dla signed
targets/residuals, nie przez reuse positive-only diagonal bounds.

Base source1633–1648 wykonuje:

```text
mu1 = current *t1
a1 = samp(mu1,mul(IW1I,sigma))
r1 = sub(mu1,of(a1)); rx=half(r1)
mu0 = add(current *t0,rx)
a0 = samp(mu0,sigma)
r0 = sub(sub(mu0,of(a0)),rx)
store z0=r0,z1=r1
```

Dowiedź NumericCenter(mu1), dopiero wtedy normal residual/interface dla a1,
następnie bound NOWEGO mu0, a dopiero potem consumer dla a0. Nie używaj
boundu drugiego środka do dowodu pierwszego. Half może zmieniać raw zero/
subnormal behavior; nie zakładaj identity/RN poza jego kontraktem.
Zwrócone z0/z1 to residual arrays; nie są sampled integers, a końcowe r0
po odjęciu rx nie ma automatycznie tego samego boundu co scalar residual.

## 6. Domknięty invariant i accumulation

Zdefiniuj formalnie current targets, read-time snapshots, normal-return
history, fault state i accumulated source errors. Invariant ma wynikać z
root entry i być zachowany przez KAŻDY kolejny source krok. Musi dać
konkretne uniform mu lower/upper margins do obu granic NumericCenter.

Dobór przestrzeni/norm jest częścią badań: można użyć coefficient, weighted,
operator lub geometrycznych/correlated bounds. Nie wystarczy pomnożyć
wszystkich luźnych L majorants i uznać niezamknięty bound za C failure.
Jeśli potrzebne są silniejsze lemmas/refinements, wyprowadź je z tych samych
P_key/emitted/source inputs w nowych kopiach, bez nowych założeń o kluczu.

Nie utożsamiaj source L z idealnym LDL lub macierzą zbudowaną z później
zastąpionych stable leaves. Przy użyciu geometrii GSO/LDL zwiąż odpowiednią
reference basis, raw L, stable widths i ich źródłowe błędy. Legacy ideal
lemmas można konsumować tylko po sprawdzeniu ich quantifiers/domains/bridge.

Repeated mul/sub source products mogą mieć te same wejścia dzięki frame;
udowodnij ten fakt i wykorzystaj correlations. Matematyczne cancellation
nie jest automatycznie bitowym cancellation rounded add/sub. Wszystkie
source primitive operands/exponents muszą mieć domains przed instrukcją.
Absolute error ma obsłużyć zero/cancellation i obie reprezentacje zera.

Rejection count nie może zwiększać caller target error, gdy caller jeszcze
nie otrzymał wyniku; uzasadnij to source state/footprint. Liczba outer
attempts16 nie ogranicza liczby inner rejection iterations. Nie korzystaj
z future Q<B, typowej próbki, clipping lub nieudowodnionej probabilistycznej
straty do zamknięcia uniwersalnego celu.

## 7. Memory, caller/retry i granice twierdzenia

Rozlicz rzeczywiste alias/lifetime/write footprints root/cubic/inner,
initialized outputs przed reads, tmp high-water i immutable normalized tree/
basis. Source scalar callback może modyfikować PRNG/fault context, nie tree.
Nie wymagaj zachowania martwych targets/scratch po legalnym reuse.

Wyprowadź root entry z do_sign/TARGETS i aktualnego context reset. Dla
norm-rejected attempts udowodnij potrzebny conditional frame sk/hm i nowe
overwrites targets; nie zakładaj sukcesu poprzedniego do_sign. Odróżnij
memory frame na defined prefixes od dowodu zdefiniowania całego sampling/
postprocessingu, source iFFT/rint/narrowing i pełnego Sign.

Jeśli fault pozostaje reachable, pokaż dokładnie które późniejsze scalar
calls omijają floor i co nadal wykonuje się przed outer fault check. Nie
nadawaj faulted tail ani pre-cast safety przez samą nazwę fail-closed.
Open postprocessing obligations muszą pozostać jawne i nie mogą być użyte
jako przesłanka aktualnie dowodzonego samego floor-domain theorem.

## 8. Kontrole i negatywne wyniki

Publiczne synthetic trees/targets/arrays oraz scripted scalar response tapes
są dozwolone w izolowanym harnessie samej oryginalnej ffSampling recursion.
To control source transfers przy jawnej abstrakcyjnej relacji callbacku,
NIE wykonanie prawdziwego Sign/KeyGen ani proof rzeczywistej sampling law.
Nie używaj fake callbacku do wykonania reszty do_sign. Publiczne scalar
prefix/proposal slices mogą sprawdzać source support/flags/integers; bez
prywatnych danych, nowych kluczy lub nieograniczonego rejection runu.

Przed native run model/domain preflight chroni przed UB. Jeśli test napotyka
nieudowodniony center/domain, zatrzymaj go przed instrukcją i zapisz dokładny
stan; ten test guard nie jest nowym guardem źródłowego C. Nonreturn/stutter
kontroluj jako prefix observation, nie jako zwrócony0.

Normal C/ASan/UBSan oraz niezależny exact integer/dyadic/QQ/RBF model mają
porównywać ordered centers, actual returned tags/values, residual updates,
pełne relevant words/snapshots i memory frames. Zróżnicuj normal support
endpoints, signed zeros, cancellation, długie rejection prefixes oraz fault
przed/między/po scalar calls. All3072 structural positions przy completed
traversal nie zastępują uniwersalnego boundu dla wszystkich histories.

No-op i meaningful mutations: wrong right/left order, użycie starego mu0,
fault0 jako close residual, pominięcie końcowego subtraction/rounding,
pominięcie terminal Split1, błędny moment snapshotu, hidden NumericCenter
premise lub typowa-próbka zamiast pełnego supportu. Zachowaj rzeczywiste
nieudane strategie/bounds/model mutations, nie tylko listę nazw.

Ściśle rozróżniaj: loose-bound failure, countermodel niezależnych interval
boxes, witness nadzbioru return tapes, P_key/normalized entry oraz faktycznie
emitted/source-reachable counterexample. Duży bound lub losowany test nie
dowodzą takiego membership. Nie wyszukuj/generuj kluczy; wymagane-domain
kontrprzykłady muszą mieć dopuszczalny publiczny/symboliczny dowód pochodzenia.

## 9. Formalizacja, status i eksport

Mixed analytical/kernel dopuszczalny, z pełną instancją source numerical/
memory premises. Generic invariant z assumed safe centers nie jest pełnym
wynikiem. Nowe/edytowane Lean: czyste logs/types/terms/axioms, bez sorry/admit/
native_decide/Lean.ofReduceBool, aksjomatu tezy i warning suppression.
Reuse z pinami/source/fresh rebuildem; adaptacje z diffami.

Pełny status:
`H3_ORDERED_NUMERIC_CENTER_PROVED_FOR_EMITTED_PINNED_MODEL` — wszystkie
wymagane source pre-floor points z root entry, rzeczywiste order/history/
frame/domain instancje, jawny caller/retry binding i numeric margins.
Zakres finite-prefix safety nie implikuje whole sampler/Sign termination.

Inaczej PARTIAL_PROOF z pierwszym dokładnym brakującym typem i najmocniejszym
boundem; COUNTEREXAMPLE_REQUIRED_DOMAIN/EXTENDED_DOMAIN z membership albo
EXECUTION_BLOCKED z rzeczywistymi logs. Nie zmieniaj C/P_key/parametrów lub
tezy, by wymusić pozytywny status. Nowa probabilistyczna alternatywa nie może
zostać ukryta pod uniwersalnym wynikiem.

Eksport ORDERED_REACH_CERTIFICATE ma zawierać entry/trace domain, source PC,
per-node/call invariants i margin constants, scalar outcome refinement,
fault/rejection disposition, memory/frame i wszystkie proof dependencies.
NEXT_INTERFACE wiąże wynik z ZERO consumerem i dokładnie nazywa dalsze
sampler-law, pre-cast/serialization, retry/kernel, ROM/QROM obligations.

RESULT osobno: ordered_root_reach_proved, all_reached_mu_numeric,
mu_domain_before_floor_proved, scalar_return_interface_proved,
intercall_primitive_domains_proved, fault_handling_scope,
fault_unreachable_for_certified_entries (tylko jeśli dowiedzione),
caller_entry_binding_proved, retry_frame_scope, source_numeric_center_margin,
proof_kind i fully_kernelized. Zapisz zakres scalar-internal definedness.

Historyczny CenterClass wykluczał raw−0, a bieżący NumericCenter je dopuszcza.
Nie ustawiaj starego H3_RANGE jako PROVED przez zmianę nazwy: zero-aware
ordered claim i ewentualna old-CenterClass reachability mają oddzielne flags.
Whole sampler/Sign termination, pre-cast safety poza wykazanym zakresem,
sampler law, security reduction i full Sign CT pozostają false/open.

## 10. Wykonanie i handoff

W-only/network-off, IN/source RO, jeden worker, bounded wall/CPU.
HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache/olean/bin pod W. GCC14.2/C99/LP64 i
literalny Makefile -O/profile; Sage10.9 (`sage plik.py ...`), Lean4.34/Std
-j1 -M2048; normal8GiB, ASan osobno z shadow. Bez instalacji/sieci/Git,
sekretów/.private/private_extraction/KeyGen/private loadera/pełnego Sign.
Bez dudect: nocne pomiary prowadzącego wymagają zakończenia dziennych obliczeń.

Wymagane REPORT/RESULT/CLAIM, ORDERED_REACH_CERTIFICATE.json,
INVARIANT.md, SCALAR_OUTCOMES.md, FAULT_REJECTION.md, ERROR_LEDGER.json/.md,
SOURCE_MODEL_BINDING.md, MEMORY_FRAME.md, CALLER_RETRY_BINDING.md,
FAILED_ROUTES.md, NEXT_INTERFACE.md, OBLIGATIONS.json, REUSED_RESULTS.md,
formalne źródła/checkery/certyfikaty, INPUTS.sha256, TOOLCHAIN.txt,
COMMANDS.log, OUTPUT_SCOPE.md, REPLAY.md, SEMANTIC_FILES.json, OUTPUTS.sha256.
Publiczne response tapes/logs oznacz jako test data, nie sekretne seedy.

Standard `scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256`: external
pin/full manifest przed nowym DEST, fresh build bez project cache/olean/bin,
deterministyczne matches. Rehearsal bez cyklu; po freeze wyłącznie nowy DEST.
source_changed=false,production_source_changed=false,
new_source_patch_integrated=false,owner_accepted=false. Podaj REPORT/OUTPUTS
SHA-256 i zakończ na handoffie.

Końcowo dodaj zrozumiałe podsumowanie dla właściciela: co rzeczywiście
udowodniono, co nie wyszło/pozostało otwarte, znaczenie dla projektu i następny
krok. Odróżnij błąd kodu, brak dowodu, za luźną majorantę i świadomy scope cut.
