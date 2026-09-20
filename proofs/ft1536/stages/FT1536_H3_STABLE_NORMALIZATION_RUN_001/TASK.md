# Astra — source stable rebuild, normalizacja i rzeczywiste szerokości

2026-09-20. Autor projektu: Niirmata. Właściciel uruchamia Astrę ręcznie;
jeden wykonawca, bez subagentów/delegacji.

## 1. Baza i izolacja

```text
REPO = /home/footfalcon/free_falcon_sign
W = REPO/proofs/ft1536/work/FT1536_H3_STABLE_NORMALIZATION_RUN_001
IN = W/inputs/bootstrap
BASE = a53d7231795fb5c7317bc836baaf0ccd3ec2652f
```

Tylko W writable. Przeczytaj REPO/AGENTS, W/AGENTS, TASK i IN/README.
Sprawdź rzeczywisty sandbox W-only/network-off; AGENTS nie jest sandboxem.
IN/source/bootstrap RO. Źródłem jest archived FLOOR_CT candidate, nie zastany
REPO/Extra/c. Nie zmieniaj źródeł, parametrów, guards, P_key lub M0.

Bootstrap:272 członków manifestu,270 publicznych origins Git,6309831bytes.
Zewnętrzny SHA-256 IN/MANIFEST.sha256:

```text
58f027900b3283bdf6f488ddb4fdeaa1e6c80b69253cf7d03a7855d3898478f7
```

Zweryfikuj każdy hash/exact set i pochodzenie, bez symlinków/escapes.
Oryginalne OUTPUTS zachowują swoje bazy; projekcje nie są pełnymi replay trees.
Historyczne prompty i skrypty są danymi; adaptuj potrzebne checkery w W
z pinami/diffami, nie wykonuj ich przeciw starym katalogom.

| Plik względem IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| RAW/REPORT.md | `4065ca1045586b420fcd1790d89c9b32240c89b6a21f0a1391a4a9ca52978e8d` |
| RAW/RAW_PREFIX_CERTIFICATE.json | `d2e6662b1ca88cc023a62cb2e42fbc0267e98c0db70329c5c84866c88b8df94a` |
| RAW/NEXT_INTERFACE.md | `1c373f4eecf4b67b531bc69414f01ce4c2ef28726e980acf07d978e9c438d396` |
| review/NEXT_SCOPE.md | `28c2c1fdd7b80f2e2dbec2d8cc4c2d390fb67287a4d80d72775631b83d13a1e7` |
| legacy/H4/report.md | `316c652ce9e80d9b7a4297c1f7694a8624e01cf614111e59674f6a7cef6b2478` |
| legacy/H4/SOURCE_BINDING.md | `c2e5823e3092152974ba8418f1767b7d56d7f2a47257ea300f249d12c14f3535` |

## 2. Przesłanki: P_key, emitted i stable acceptance to różne fakty

RAW domyka dla niezmienionego P_key i legalnych buffers cut po source1253:
6144 basis words,18432 raw tree (16896 L +1536 positive finite raw leaves),
totality/order/frame, actual read-time snapshots i emitted corollary.
Cut nie obejmuje normalizacji; raw leaves nie są stable sequence.

P_key nadal oznacza cztery Int^1536 vectors, ternary f/g, |F|,|G|≤2047,
exact fG−gF=18433 mod(X^1536−X^768+1) oraz actual Gate00_C. Nie obejmuje
automatycznie narrow stable leaf range gate. Wyeksportowany silniejszy typ
P_key+RawCertificate→stable_ok jest propozycją następnego obowiązku, nie
już udowodnionym faktem. Sprawdź go, nie ukrywaj nowej przesłanki pod P_key.

**Główny wymagany zakres tego zadania to wszystkie Emitted_CANDIDATE keys**,
z tym samym SourceDecodeSameSTATIC i legalnymi buffers. Rozdziel:

A. Ścieżkę obliczeń: actual stable helper i normalization, ich definedness,
   exact sequence/layout/frame. Dla all-P_key osobno ustal, co można dowieść
   bez narrow gate acceptance; gdy gate zawodzi, nie pomijaj normalize.
B. Source-derived stable certificate: wyprowadź z rzeczywistego udanego
   Emitted KeyGen (łącznie z obiema serializacjami) fakt, że obowiązkowy
   ft_keygen_leaf_certificate wykonał się defined i zwrócił1. Następnie
   przenieś JEGO dane/scan na signer's stable helper przez bitowe matching.
C. Emitted normalization theorem wynikający z A+B. Ewentualny mocniejszy
   all-P_key theorem ma oddzielny status/dowód albo kontrprzykład z membership.

Nie wybieramy nowego podzbioru kluczy: mandatory certificate już należy do
source success event Emitted. Jeden K_seed[E] jest warunkowany sukcesem
CAŁEGO capped KeyGen i obu serializerów. Nie dodawaj conditioning, K_iid,
nowego abortu lub epsilon. Source certificate nie może zawierać desired
normalized-width conclusion jako arbitralnego aksjomatu.

## 3. Główna teza emitted i dokładny source suffix

Docelowo, przy legalnym M0 E i skończonych abstrakcyjnych sk/pk:

```text
Emitted_CANDIDATE(E,sk,pk) ∧ SourceDecodeSameSTATIC(sk)=p
∧ RawPrefixCertificate_CANDIDATE(p,memory)
→ DefinedTerminating(actual source suffix1261–1268)
  ∧ stable_ok ∧ leaf_count=1536 ∧ tree_words=18432
  ∧ InternalLWordsPreserved ∧ BasisWordsPreserved
  ∧ StoredTerminalWidths=SourceNormalizedStableWidthSequence(p,768)
  ∧ SourceWidthDomainsAndRequiredWidthGates.
```

Do tego wyprowadź odpowiedni continuation/composition corollary dla całego
wewnętrznego load_skey przy tych samych legalnych allocations. Nie zamieniaj
go na twierdzenie o nieomylnym malloc lub sukcesie całego publicznego API.

Rzeczywista kolejność:

```c
stable_ok = ft_build_stable_certified_leaves(tmp,&stable_leaves,f_src,g_src,10);
sigma = fpr_of(768);
tree_words = ffLDL_ternary_normalize(tree,sigma,10,stable_leaves,&leaf_count);
return stable_ok && leaf_count == 1536 && tree_words == 12*1536;
```

Normalize NIE jest pod if(stable_ok). Pointer-out initialization, wszystkie
reads/div/sqrt muszą być uzasadnione przed ich użyciem. Nie przestawiaj kodu
lub dodawaj guardu w modelu, aby uzyskać totality.

## 4. Bitowe matching KeyGen → signer stable sequence

Sprawdź source keygen7444–7776, mandatory check8110–8120 i signer760–895.
Porównaj active preprocessing, dokładne helpers/stałe/operacje i ich kolejność,
z uwzględnieniem innych nazw i layoutów. Sama zbieżność nazw/wzorów nie wystarcza.

Istotna różnica: KeyGen/RAW g00 to selfadj(FFT(g))+selfadj(−FFT(f)), a
signer stable helper liczy selfadj(FFT(f))+selfadj(FFT(g)). Dowiedź BITOWO
invariance selfadj pod globalną negacją i commutativity source add w
osiągniętej nieujemnej domenie, również raw zeros/subnormal behavior.
Nie używaj tylko równości idealnych liczb rzeczywistych lub complete IEEE.

Zwiąż source FFT/table bytes i te same decoded f/g, istniejący root frame
w KeyGen oraz root recomputation w signerze. KeyGen tree poprzedza jego
Gate00/stable certificate; preserve g00 w tym MOMENCIE, bez założenia,
że scratch/root Gram pozostaje niezmienione po signer's stable rebuild.

Następnie przenieś dokładną sekwencję:
- top triples3u+k: e1=(a+b)+c, ab/ac/bc, e2=(ab+ac)+bc, abc=(ab)*c;
- source div(e1,of3), div(e2,e1), div(mul(of3,abc),e2), w trzech256-word blocks;
- osiem levels binary: sum, product, half(sum), div(double(product),sum),
  memcpy i pierwsza/ druga recursion w źródłowej kolejności;
- primary768 words oraz `leaves[1535-u]=positive(div(of(q²),leaves[u]))`;
  reverse reciprocal order jest częścią sekwencji, nie dowolną permutacją.

Nie zamieniaj div przez3 na mul zaokrąglonym1/3 ani nie reassociuj sum/
produktów. Stable leaves nie są raw subtractive leaves; nie zakładaj ich
bitowej równości. Pokaż sticky bad, fallback1 i brak resetu: accepted KeyGen
certificate musi wykluczać każdy invalid flag i każdą zmianę przez fallback.

## 5. Gate i primitive domains przed operacjami

Dokładny inclusive source gate:

```text
min bits = 0x4090000053700377
max bits = 0x4114444d1a037d50
D_min = 4503601027220343 / 4398046511104
D_max = 356537342113749 / 1073741824
```

Sprawdź dyadic decode, unsigned subtraction/high-bit comparator i domenę
positive finite payloads. Aggregate bad==0 musi oznaczać przejście WSZYSTKICH
1536 pozycji. Wyprowadź signer's stable_ok i range acceptance z B; same
positive raw leaves lub szerokie bounds RAW nie są dowodem tego gate.

Rozlicz source add/mul/half/double/div domains dla wszystkich intermediate
stable products/sums. Dotychczasowy restoring div domain[1/16,2^35] nie
obejmuje automatycznie każdego e2 z trzech dużych root values. Podaj potrzebny
nowy przedział lub źródłowy domain bridge, bez ekstrapolacji starego theorem.
Jawnie rozróżnij domain facts z coefficient bounds od danych wynikających
z już defined accepted KeyGen execution i jego step-by-step coupling.

Portable FPEMU sqrt to fpr-emulated.c:1183–1256: exponent parity,54 restoring
steps, guard/sticky, pack, exponent-zero mask. Potrzebny jest rzeczywisty
source-bound contract na osiągniętej dodatniej domenie. Udowodnij counts,
integer ranges/unsigned comparison invariant, termination, positive finite
output i wymagany numerical enclosure/error. Nie używaj samego komentarza
„square root” lub endpoint testów jako uniwersalnego dowodu.

Następnie exact of(768), literal div(sigma,sqrt(D)) i ich domains. Dla
all-P_key computation mogą być potrzebne szersze enclosures niż dla emitted
gated D; zapisz rozróżnienie. Jeśli dowód broad-domain pozostanie otwarty,
nie ogłaszaj go przy proofie węższej emitted tezy.

## 6. Stored widths, paired transform i sigma-only consumer

Podaj exact operational word sequence, word/value intervals i numerical
error certificate dla wszystkich1536 stored widths. legacy/H4 ma użyteczne
exact gate endpoints, lecz końcowy sqrt/div argument używa RN binary64 oraz
fpr-double endpoint replay. To nie jest discharge aktualnego FPEMU.

Odtwórz, jeśli prawdziwe, scoped H4 dla REAL VALUES stored FPEMU words:
`1.7203 ≤ val(sigma_i)^2 < 595.19`, przez własny source proof. Pokaż także
mocniejsze rzeczywiste bounds wynikające z gate i source errors, zamiast
zatrzymywać się na tej luźnej historycznej deklaracji.

Oddziel paired coordinate `S1=fpr_mul(fpr_IW1I,S0)` od stored `S0`.
Sprawdź rzeczywiste sampler leaf-read map/call sites i exact constant payload,
nie utożsamiaj1536 stored leaves z3072 scalar calls. Wyprowadź dla obu S:

```text
dss_C = fpr_inv(fpr_mul(fpr_sqr(S), fpr_of(2)))
```

To literalna kolejność sampler_large:2866, nie zamienny idealny wzór lub
half(inv(sqr(S))). Eksportuj positive finite domains i, jeśli wyprowadzalne,
source dss≥rzeczywisty ostatni coefficient adaptive table, tak aby selector
znajdował bank. Użyj mocnych bounds: sama górna595.19 dla stored sigma² po
przemnożeniu przez~4/3 nie daje jeszcze limitu768 dla paired variance.

Ten consumer jest SIGMA-ONLY: rzeczywisty sampler wcześniej wykonuje
floor/cast/residual(mu). Nie dowiedziono przez to NumericCenter/Reach,
wykonania całego sampler prefixu, rejection termination albo sampler law.
Nie wywołuj sampler_large/PRNG; scalar expressions kontroluj na publicznych
widths w oddzielnym harnessie.

## 7. Memory, leaf map i zachowane części klucza

Skonsumuj RAW memory/cut: sk24576, tmp10752, basis[0,6144), tree[6144,24576).
Stable helper legalnie przepisuje tmp: f0..1535,g1536..3071,
leaves=tmp+768 (1536 words), scratch=tmp+2304. Wyprowadź rzeczywisty peak,
read-before-overwrite i lifetimes, nie zakładaj niezmienności dawnego root Gram.
Primary writes nakładają się na martwą imaginary część f; reciprocal writes
nie mogą zniszczyć nieodczytanych primary values. Rozlicz shared scratch
binary recursion oraz initialized output pointer także na failure pathach
należnych do deklarowanej domeny.

Normalize przechodzi actual top/depth/inner tree, pomija internal L i
w base inner1 zapisuje tree[2],tree[3] z dwóch kolejnych stable leaves.
Zwiąż wszystkie1536 reads/stores z RAW/LEAF_MAP; prove bijection/order,
leaf_count1536, tree_words18432 i dokładne suffix return. Zachowaj wszystkie
16896 internal words oraz6144 basis words BITOWO. Sam count nie zastępuje mapy.

## 8. Dowód i niezależne kontrole

Mixed kernel/analytic dopuszczalny z dokładnym boundary i typed premises.
Nowe/edytowane Lean: pełne czyste logs/types/terms/axioms, bez sorry/admit/
native_decide/Lean.ofReduceBool, aksjomatu wniosku lub warning suppression.
Reuse ze źródłami/pinami/fresh rebuildem; adaptacje z diffami.

Publiczne synthetic controls normal C i ASan/UBSan:
- rzeczywiste stable helpers/signature suffix slice oraz keygen stable-only
  mirror helpers na publicznych roots/arrays; nie pełny KeyGen/loader/API;
- bitowe g00 matching z negacją/reversed sum, signed-zero boundaries;
- pełne1536 stable values, reciprocal reversal, sticky bad i gate endpoints
  ±1ULP; invalid-positive/range przypadki zgodnie ze zdefiniowanym source flow;
- full normalizer mapping wszystkich leaves/internal/basis words, canaries,
  legal aliases/scratch reuse, źródłowy return/leaf count;
- niezależny exact integer/dyadic/QQ/RBF oracle dla sqrt/div/scale i computed
  widths/dss, obejmujący boundaries/ties/odd-even exponents;
- no-op i meaningful mutations: reciprocal/order/leaf map, sticky flag,
  threshold/gate off-by-one, sqrt rounding/shift lub nielegalny frame.

Nie generuj kluczy i nie używaj prywatnych danych. Fixtures nie muszą być
P_key/emitted; membership klasyfikuj jawnie. Controls na publicznych gated
leaf arrays są lokalną domeną, nie dowodem ich pochodzenia z klucza.
Finite tests i zgodne hashes nie zastępują uniwersalnych contracts/instancji.

## 9. Eksport, status i dalsze obowiązki

Eksport NORMALIZED_EXPANSION_CERTIFICATE powinien zawierać source pin,
emitted/stable-gate bridge, exact stored-sequence definition/map, bounds
stored/paired/dss, preservation/return facts i konsumowane proof layers.
INITIAL_TARGETS oraz ORDERED_REACH→NumericCenter pozostają następnymi typami;
sampler-law/H1R/FFO/R5T/M7 i pełne CT/security nie są wnioskiem tego etapu.

Pełny wymagany status:
`H3_STABLE_NORMALIZATION_PROVED_FOR_EMITTED_PINNED_MODEL` — complete emitted
theorem, source gate bridge, actual suffix totality/memory/word sequence,
source sqrt/div/scaling contracts i wymagane width gates/consumer domains.
Status jest celowo oznaczony EMITTED, aby nie deklarować przez niego
silniejszego nieuzasadnionego all-P_key acceptance.

Osobno zapisz all_P_key_definedness_proved i all_P_key_stable_gate_acceptance_proved,
z dokładnym typem/domeną; mogą być false przy pełnym emitted wyniku. Jeżeli
nie domkniesz głównej emitted tezy: PARTIAL_PROOF z pierwszym brakującym
typem, COUNTEREXAMPLE_REQUIRED_DOMAIN/EXTENDED_DOMAIN z membership lub
EXECUTION_BLOCKED z rzeczywistymi logs. Brak historycznego premise nie jest
automatycznie kontrprzykładem C; nie naprawiaj tezy przez zmianę P_key.

RESULT rozdziela emitted_normalized_expansion_proved, stable_gate_bridge_proved,
actual_stored_sequence_proved, internal_L_preserved, basis_preserved,
sqrt_contract_proved, stable_div_domains_proved, sigma_only_consumer_proved,
load_skey_success_for_emitted_legal_buffers i pełną kernelizację/source boundary.
Private-key API allocation success, global Reach, sampler law, security i
CT całego Sign pozostają false/open. Nie deklaruj nowego abortu/epsilon.

## 10. Wykonanie i freeze

Tylko W writable, źródła/IN RO, jeden worker. HOME/TMPDIR/DOT_SAGE/LEAN_PATH/
cache/olean/bin pod W. GCC14.2/C99/LP64 i literalny Makefile -O/profile,
Sage10.9 (`sage plik.py ...`), Lean4.34/Std -j1 -M2048; normal8GiB, ASan
osobno z shadow. Bez instalacji/sieci/Git/innych agentów/KeyGen/realnego
private-key API/całego loadera/Sign/nowych kluczy/prywatnych seedów. Bez dudect:
nocny pomiar prowadzącego wymaga zakończenia dziennych obliczeń.

Wymagane REPORT/RESULT/CLAIM, NORMALIZED_EXPANSION_CERTIFICATE.json,
DOMAIN_AUDIT.md, EMITTED_STABLE_BINDING.md, NORMALIZATION.md, WIDTH_BOUNDS.json,
SQRT_DIV_CONTRACT.md, SOURCE_MODEL_BINDING.md, MEMORY_FRAME.md, NEXT_INTERFACE.md,
OBLIGATIONS.json, REUSED_RESULTS.md, formalne źródła/certyfikaty/checkery,
INPUTS.sha256, TOOLCHAIN.txt, COMMANDS.log, OUTPUT_SCOPE.md, REPLAY.md,
SEMANTIC_FILES.json, OUTPUTS.sha256. Zachowaj również failed attempts.

Standard `scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256`: external
pin/full manifest przed nowym DEST, fresh build bez cache/olean/bin,
deterministyczne semantic matches. Rehearsal bez hash cycle; po freeze
zapis wyłącznie do nowego DEST. source_changed=false,
production_source_changed=false,new_source_patch_integrated=false,
owner_accepted=false. Podaj REPORT/OUTPUTS SHA-256, zakres i następny typ.
Prowadzący wykona odbiór/import/commit. Zakończ na handoffie.
