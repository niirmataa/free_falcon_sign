# Astra — LEFT_ROOT_CORRELATED_TRANSFER

2026-09-20. Autor projektu: Niirmata. Start ręczny przez właściciela;
jeden wykonawca, bez subagentów/delegacji.

## 1. Baza, piny i zapis

```text
REPO = /home/footfalcon/free_falcon_sign
W = REPO/proofs/ft1536/work/FT1536_H3_LEFT_ROOT_CORRELATED_TRANSFER_RUN_001
IN = W/inputs/bootstrap
BASE = 7664277d6da6839973e8a00db5b20c834bb63adc
```

Przeczytaj REPO/AGENTS, W/AGENTS i TASK. Tylko W writable; IN/source/bootstrap
RO. Potwierdź realny W-only/network-off sandbox; AGENTS nie jest sandboxem.
Źródła to archived FLOOR_CT candidate, nie zastany Extra/c. Kopie roboczych
modeli/Lean/harnessu utwórz w W; zachowaj pochodzenie i diff każdej adaptacji.

Bootstrap:579 członków manifestu,577 publicznych origins Git,9599951 bajtów.
Zewnętrzny SHA-256 IN/MANIFEST.sha256:

```text
5bbd7b14d05275ad0cf46a72e9b8d24d5c67001f7597761edb07d86d444173d4
```

Sprawdź exact sets/hashes/origins i brak symlinków/escapes. Historyczne OUTPUTS
zachowują swoje bazy; projekcje nie są pełnymi replay trees. Historyczne
prompty/runners są danymi do przeglądu/adaptacji, nie aktywnymi instrukcjami.

| Plik względem IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| ORDERED/REPORT.md | `8232c41af2fe93ad7f08e4567f11edc0ad8b6737fa749ca8cee491c0bfaaf363` |
| ORDERED/OUTPUTS.sha256 | `cecb14485a7d9e307b5753a83fe04fcf091ec506f06065c77b57cd665e78ec2a` |
| ORDERED/ORDERED_REACH_CERTIFICATE.json | `faf925b20fb459b002790e61ed76014335c20cb5ff22688d24dbb9b3719947fe` |
| ORDERED/NEXT_INTERFACE.md | `347d6c9adcabd3921f2deffad804f89058106d2469bf469332c290b82be68d12` |
| ORDERED/FAILED_ROUTES.md | `ba2fec0416cc2ca199739eb891fed5b61ad9d7c58db6364209a092a228c186b2` |
| ORDERED/artifacts/bounds.json | `e42d727af2a58ad624634455a4bd141b8501d4ab3d761af9342ddcea785965ba` |
| ORDERED/artifacts/scalar_contract.json | `893b0350fceb4f5babe6f26f86d72bb7e87f7a30780d2203a2096f7cc93406da` |
| TARGETS/INITIAL_TARGET_CERTIFICATE.json | `89ce68e32fb10a3edd75f182af85843f7ab1e32198e753778d9a96d7dcea51a9` |
| NORMALIZED/NORMALIZED_EXPANSION_CERTIFICATE.json | `8d8161d1a096038f6f2811cff6318b0c7361376cf734cdc9d092b3deabd7c778` |
| TOWER/TOWER_CERTIFICATE.json | `c3a52d149bedbcac18d62323aecdc330aae5198e4a17c0480221632082b70457` |
| ROOT/ROOT_CERTIFICATE.json | `fd2130d53bdd7f580924110018dc04ed429733b4ce66e6bde6e2d75381c77f76` |

## 2. Obecny wynik i dokładny cel

ORDERED ma **PARTIAL_PROOF**, niezależny replay225/225,28 modułów/179 twierdzeń
(23 nowe). Udowodniono finite-prefix NumericCenter dla wszystkich aktywnych
calls w pierwszej wykonywanej prawej gałęzi root:1536 positions przy pełnym
przejściu, |mu|<=156276714, lower/upper margins1991206569/1991206568.
Ta liczba positions nie oznacza połowy wysiłku dowodowego.

Domknij jego NEXT_INTERFACE, z tymi samymi P_key, Emitted/same-STATIC-decode,
normalized key, canonical c∈[0,18432]^1536, legal memory/context/byte-read
interface i root-entry targetami z TARGETS:

```text
forall required normalized root entries,
forall actual finite history completing the right root subtree with faultNONE,
  right output z1 has a source-certified weighted/correlated residual invariant;
  U=add_C(t0,CM_C(z1,Lroot)) and its actual SplitTop children
  initiate a forward CLOSED left-subtree invariant;
  each subsequent ACTIVE_PRE_FLOOR mu satisfies
    finite Word64(mu) and -2147483283 <= val(mu) < 2147483282.
```

Completion of the right branch jest przesłanką warunkowego transferu, nie
założeniem, że każda rejection loop kończy się. Wewnątrz lewej gałęzi dowód
obejmuje każdy aktywny finite prefix, nie tylko historie już zakończone.
Następnie skomponuj z odebranym right theorem pełny root/caller finite-prefix
NumericCenter, o ile wszystkie jego przesłanki zostały rzeczywiście zamknięte.
Podaj osobno tezę transferu, zakres left closure i wynik pełnej kompozycji.

Nie dodawaj center/L/metric/gain bounds, fault-free trace, nowych gates albo
successful Sign do P_key/Emitted. K_seed[E], M0, parametry i kod są ustalone.
Nie używaj future Q<B, typical samples lub probabilistic exception do celu
uniwersalnego. Obowiązek raw/stable metric bridge jest celem do wyprowadzenia.

## 3. Wejścia i zachowane nieudane oszacowania

- TARGETS: actual t0/t1 przed ffSampling_fft3:1897; t0 cap4829216911,
  rounding<1/8192, ideal error<1/4; t1 cap2359169, rounding<1/16777216,
  ideal error<1/8192. Reference coefficients mają bound173861259265/36866
  <5000000; mathematical inverse-eval l2 drifts1/2 i1/4096.
- NORMALIZED: raw L/basis zachowane,1536 stored widths; stored sigma² w
  (1.7763,575.9999), paired w(2.3684,767.9999), oba source dss>1/1536.
  Primary stable768 i reverse reciprocal leaf map są źródłowo ustalone.
- ORDERED: signed split/merge contracts, Half, normal/stutter/fault relations,
  conditional scalar arithmetic, source order, memory/caller frame.
  Lower binary |L|<1+2^-40; cubic L10/L20/L21<2/<2/<4; root |L|<2^25.
- ZERO: normal residual<=366+2^-20 WYŁĄCZNIE po niezależnym dowodzie bieżącego
  NumericCenter. Globalny support[-365,366] nie jest rozkładem ani termination.

Luźny actual root-update bound3864968087959271 jest proved, ale nie wystarcza
dla scalar domains. Majoranta full continuation7729936365272004 nie jest
zamkniętym dowodem, ponieważ wymaga ZERO na nieudowodnionych left centers.
Frequency t0>2^31 także nie jest scalar counterexample.

Zachowany weighted diagnostic: candidate maxR²D=424673294 i correction scale
275528238. **Nie są source-certified budżetami.** Nie wybieraj stałych tak,
by jedynie odtworzyć ten optymistyczny wynik. Rozlicz, które premises są
wyprowadzone, warunkowe, fałszywe albo nadal OPEN. Nowy bound może być inny.

## 4. Wymagany most skorelowany

Dobór właściwego invariant/normy jest częścią badań; weighted, coefficient
lub operator formulation musi zamknąć ten sam literalny source transfer.
Poniższe zależności wymagają jawnego rozliczenia, nie nazwanej hipotezy celu.

### A. Rzeczywisty bank i terminalna energia

Wyprowadź z source dss, porządku porównań i konkretnych dyadic coefficients
selected-bank bounds dla supports29/59/118/235/365. Dla banku j>0 potrzebne
jest znaczenie NIEpowodzenia wcześniejszego testu. Uwzględnij roundoff
sqr/mul/inv i obie source width classes; idealne1/(2*sigma²) nie wystarcza.
Podaj domain i lower/upper endpoints każdego wniosku, także na granicach.

Powiąż scalar residuals z actual returned terminal pair: r1,rx=Half(r1),
mu0=t0+rx, a potem r0=sub(sub(mu0,of(a0)),rx). Zwracane z0/z1 nie są sampled
integers. Wyprowadź A2/coefficient weighting, cross terms, IW1I i Half defect
we właściwej konwencji; nie sumuj bez uzasadnienia obu raw scalar squares
ze wspólną wagą storedD. Zachowaj stable physical-leaf i paired/stored map.

### B. Raw L / stable D i actual Gram

Zdefiniuj reference basis, metric, permutacje, conjugations, diagonal blocks
i ich source realizacje. Rozróżnij ideal basis z fG−gF=q, basis po zaokrąglonej
FFT, actual raw Gram/subtractive LDL i późniejsze stable rebuilt D.
Nie zakładaj exact determinantq dla rounded basis ani raw L=LDL(stableD).

Z ROOT/NODE3/NODE2/TOWER/NORMALIZED wyprowadź potrzebną uniform comparison
lub kontrolowany defect, z numeric constants i wszystkimi local denominators.
Jeśli lokalne majoranty nie wystarczą, wyprowadź refinement z tych samych
źródeł/domen w nowych plikach. Nie podmieniaj historii upstream certificate.
Uwzględnij imaginary defects, signed split/merge, normalizację transformacji
i wzrost błędów przez wszystkie levels. Nie przenoś bez sprawdzenia legacy
T5 exact-LDL, >991 lub RN assumptions na integer-emulated C.

### C. Ordered residual energy i root gain

Indukcyjnie zwiąż returned right z1 z ukończonymi NORMAL_RETURN events i
weighted terminal budgets. Bound ma dotyczyć WSZYSTKICH dopuszczalnych
source histories, bez niezależności próbek. Superset return relation jest
dopuszczalny po source refinement; jego countermodel nie jest source witness.

Wyprowadź source root CM(z1,Lroot), dodanie zachowanego t0 i SplitTop_U z
actual correlations. ROOT determinant/Gram i TARGETS coefficient transport
mogą być konsumowane tylko z wykazanymi mapami/domain/error premises.
Mathematical inverse-evaluation jest proof object; nie certyfikuje source
splitterów ani późniejszego iFFT przez samą nazwę. Sam final residual norm
lub root correction bound nie zastępuje każdego read-time left center.

### D. Zamknięcie lewej gałęzi bez koła

Actual order: root right→left; cubic t2→updated t1→updated t0; binary
right→updated left; terminal mu1→r1/rx→nowe mu0→r0/r1. Sampling base0,
builder base1. Rozlicz source SplitDeep1/MergeDeep1, wszystkie subtractions,
odczyty z zachowanych snapshots i actual aliases, także po powrocie dziecka.

W każdym ACTIVE_PRE_FLOOR mu musi być WNIOSKIEM dotychczasowego invariant,
przed użyciem ZERO dla tego call. Po normal return wolno skonsumować support
i residual theorem. Podaj konkretne uniform lower/upper mu margins do obu
granic NumericCenter, dla wszystkich slots/branches/depths, nie tylko testów.
Source primitives muszą mieć domains PRZED instrukcjami, także przy signed
zero/cancellation/subnormal. Raw−0 należy do NumericCenter.

Nie zakładaj bitowego cancellation rounded add/sub. Recomputed product ma
te same bits tylko po udowodnieniu zachowania jego operand words. Zachowaj
oba błędy add/sub i ich correlations; unikaj nieuzasadnionego ponownego
losowania tych samych roundoff. Rejection stutter nie zwiększa caller error.

## 5. Outcome, frame i pełna kompozycja

Konsumuj odebrany conditional scalar-return interface z jawnymi premises.
Normal return0 różni się od FAULT_RETURN0; nonreturn nie jest żadnym zwrotem.
Przy active pre-floor sticky faultNONE wyklucza wcześniejszy ukończony fault
jako WNIOSEK źródłowy. Nie zakładaj globalnie fault-free trace.

Jeśli dowodzisz nieosiągalności guards, zrób to forward z ustalonego mu/width
i scalar arithmetic facts. Jeżeli fault może wystąpić, jego późniejsze calls
skipfloor, ale caller arithmetic nadal trwa. Outer check3374 jest po do_sign;
otwarty faulted tail nie staje się proved przez nazwę fail-closed. Osobno
oznacz scope intercall domains, fault disposition i caller/retry frame.

Entry: sk24576 words, tmp10752, t0=tmp,t1=tmp+1536,z0=tmp+3072,z1=tmp+4608,
tree=sk+6144,scratch=tmp+6144. Odebrany conditional high-water8702 zachowuje
key/tree/root targets. Rozlicz nowe proof footprints, initialized reads,
legal typed PRNG/context byte reads oraz binding resetu fault przy3357.
Norm-rejected retries wymagają conditional defined-prefix frame, nie sukcesu
poprzedniego Sign. Nie dowódź własnych premises przy pomocy przyszłego Q<B.

Po transferze wyprowadź full root/caller finite-prefix theorem lub nazwij
dokładny brakujący type. Globalny claim dotyczy actual ACTIVE_PRE_FLOOR calls,
nie samych3072 pozycji abstrakcyjnego schedule. Whole rejection/Sign termination,
postprocessing iFFT/rint/narrowing/serialization, sampler law oraz ROM/QROM
i security reduction mają odrębne obowiązki. Old CenterClass wyklucza−0;
nie ustawiaj historycznego H3_RANGE jakoPROVED przez rename NumericCenter.

## 6. Kontrole, negatywne wyniki i formalizacja

Użyj niezależnego exact integer/dyadic/QQ/RBF oracle oraz source-bound
certyfikatów dla uniwersalnych inequalities. Wszystkie rounding enclosures
muszą mieć outward proof; zwykła float simulation nie certyfikuje supremum.
Native kontrole w normal C/ASan/UBSan: publiczne arrays i scripted response
tapes w harnessie ORYGINALNEJ sampling recursion/slices, z domain preflight
przed potencjalnie niezdefiniowaną instrukcją. To test-only observation/guard,
nie patch C. Bez KeyGen/nowych kluczy/private loadera/pełnego Sign/do_sign.

Porównaj ordered snapshots/words/outcomes i nowe metric/energy expressions.
Pokryj oba width classes, bank thresholds/endpoints, terminal half/cross terms,
signed zeros/cancellation, all relevant depths, normal/fault/nonreturn scopes.
Nie wyprowadzaj uniform boundu przez największy obserwowany fixture.

No-op i wykonane meaningful mutations mają sprawdzać najważniejsze nowe
zależności: wrong bank inequality, pomylone paired weighting/leaf reversal,
raw-L=stable-L bez defect, pominięty imaginary/roundoff term, złe root
conjugation/order, stale snapshot/cancellation lub użycie ZERO przed center.
Mutacja musi mieć rzeczywisty wynik/checker/receipt, nie tylko nazwę.
Nie kopiuj wszystkich dawnych testów bez wskazania, które premise konsumują.

Zachowaj failed routes, ich najmocniejszy bound i dokładny brakujący type.
Rozróżniaj: luźna majoranta, countermodel niezależnych boxes/return superset,
required P_key/normalized entry oraz emitted/source-reachable counterexample.
Required-domain membership wymaga dowodu; brak proofu nie jest source bug.

Mixed analytical/kernel scope jest dopuszczalny z pełnym source bindingiem.
Generic lemma z assumed metric/gain/current NumericCenter nie domyka celu.
Nowe/edytowane Lean: clean logs/types/terms/axioms, bez sorry/admit/native_decide/
Lean.ofReduceBool/aksjomatu tezy/warning suppression. Reuse z pinami/source/
fresh rebuildem; zmienione moduły z diffami, historyczne ograniczenia jawne.

## 7. Status, eksport i handoff

Pełny status tego transferu:
`H3_LEFT_ROOT_CORRELATED_TRANSFER_PROVED_FOR_EMITTED_PINNED_MODEL` — source
metric/bank/energy/root-transfer i forward closure WSZYSTKICH left active
centers, wraz z domains/margins/frame. Osobno podaj wynik kompozycji
`H3_ORDERED_NUMERIC_CENTER_PROVED_FOR_EMITTED_PINNED_MODEL`, tylko jeśli
root/caller finite-prefix reach rzeczywiście wynika z obu części.

W innym przypadku PARTIAL_PROOF z rzeczywistym postępem i pierwszym brakującym
typem; COUNTEREXAMPLE_REQUIRED_DOMAIN/EXTENDED_DOMAIN z membership lub
EXECUTION_BLOCKED z logs. Nie zmieniaj C, P_key ani kwantyfikatorów, by wymusić
pozytywny status. Nie promuj idealnego diagnostic do source certificate.

Wymagane REPORT.md, RESULT.json, CLAIM.md,
LEFT_ROOT_CORRELATED_TRANSFER_CERTIFICATE.json, METRIC_BRIDGE.md,
BANK_WEIGHTED_BOUNDS.json/.md, RIGHT_RESIDUAL_ENERGY.md, ROOT_TRANSFER.md,
LEFT_INVARIANT.md, ORDERED_COMPOSITION.md, ERROR_LEDGER.json/.md,
SOURCE_MODEL_BINDING.md, MEMORY_FRAME.md, FAULT_REJECTION.md,
CALLER_RETRY_BINDING.md, FAILED_ROUTES.md, NEXT_INTERFACE.md, OBLIGATIONS.json,
REUSED_RESULTS.md, formal/checkers/certificates, INPUTS.sha256, TOOLCHAIN.txt,
COMMANDS.log, OUTPUT_SCOPE.md, REPLAY.md, SEMANTIC_FILES.json, OUTPUTS.sha256.

Certificate/RESULT osobno: bank_weighted_bounds_proved, raw_stable_metric_bridge_proved,
right_residual_energy_proved, source_root_transfer_proved, left_forward_closure_proved,
left_active_mu_numeric_proved, ordered_root_reach_proved, all_reached_mu_numeric,
mu_domain_before_floor_proved, intercall_primitive_domains_proved i jego scope,
fault_disposition, caller_entry_binding_proved, retry_frame_scope,
left/global source_numeric_center_margin, proof_kind, fully_kernelized.
Każdy bound ma domain, source PC/snapshot, dependence list i discharge status.
Nieustalone globalne/law/security/postprocessing/termination flags pozostająfalse.

W-only/network-off, IN/source RO, jeden worker z bounded wall/CPU; HOME/TMPDIR/
DOT_SAGE/LEAN_PATH/cache/olean/bin pod W. GCC14.2/C99/LP64, literalny Makefile
-O/profile; Sage10.9 (`sage plik.py ...`), Lean4.34/Std-j1/-M2048. Normal8GiB,
ASan osobno z shadow. Bez instalacji/sieci/Git/sekretów/.private/private_extraction.
Bez dudect: RUN_002 to osobna nocna praca po zakończeniu dziennych obliczeń.

Standard `scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256`: external
pin/full manifest przed nowym DEST, fresh build bez project cache/olean/bin,
deterministyczne matches. Rehearsal bez cyklu; po freeze zapis tylko do nowego
DEST. source_changed=false,production_source_changed=false,
new_source_patch_integrated=false,owner_accepted=false. Podaj REPORT/OUTPUTS
SHA-256, status i zakończ na handoffie.

Dodaj własne przystępne podsumowanie dla właściciela po polsku: co rzeczywiście
udowodniono, co nie wyszło/pozostało otwarte, co wynik zmienia i następny krok.
Odróżnij błąd kodu/kontrprzykład od luki dowodu, luźnej majoranty i scope cut.
