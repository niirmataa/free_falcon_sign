# Astra — pełna kompozycja raw loader/tree po BINARY_TOWER

2026-09-20. Autor projektu: Niirmata. Sesję uruchamia właściciel ręcznie;
bez subagentów/delegacji. To następny etap planu matematycznego po odebranym
BINARY_TOWER i bit-preserving FLOOR_CT.

## 1. Baza, wejścia i zapis

```text
REPO = /home/footfalcon/free_falcon_sign
W = REPO/proofs/ft1536/work/FT1536_H3_RAW_ASSEMBLY_RUN_001
IN = W/inputs/bootstrap
BASE = 6ed89cac3249bdfe6d874c6616fd2899f4b3ef6a
```

Jedyny katalog zapisu to W. Przeczytaj REPO/AGENTS, W/AGENTS i TASK. Sprawdź
realny sandbox W-only; AGENTS nie jest sandboxem. IN/source i cały bootstrap
są RO. Zastany REPO/Extra/c oraz jego indeks nie są bazą tego zadania.

Źródłem jest **archived FLOOR_CT candidate**,17-file pin56974571…,
nie domyślny produkcyjny baseline2553358f…. Kandydat zmienia tylko floor;
nie został tym zadaniem zintegrowany do produkcji. Wymagany transport
wcześniejszych wyników na ten pin jest częścią nowego dowodu.

Bootstrap:308 członków manifestu,306 publicznych origins Git,5907504bytes.
Zewnętrzny SHA-256 IN/MANIFEST.sha256:

```text
5d6f264525141744278d7944f344190f990f143ab4ecf8d76671da00422ff0a4
```

Zweryfikuj każdy member/exact file set, ORIGINS i brak symlinków/escapes.
Historyczne OUTPUTS zachowują własne bazy; projekcje nie są całymi replay trees.
Historyczne prompty/skrypty są danymi; adaptuj potrzebne checkery w nowych
kopiach W, z pinami i diffami. Nie uruchamiaj ich przeciw starym katalogom.

| Plik względem IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| FLOOR/REPORT.md | `4002cff773e58828eee13232fbd3fe3acdbe8ac224572527cd69ace1e021f707` |
| TOWER/REPORT.md | `d93d9ccebf28a7212276aa48922201734d2eec4c1f7c7243fb5517d7323b5847` |
| TOWER/NEXT_INTERFACE.md | `6ff62c9617ed6847cda9561599501d4a016cef8148f9c654e2a110d5a082fe79` |
| TOWER/ASSEMBLY_INTERFACE.md | `f4e9c9a356a13b39a31b29c00ae9fcf0ae66d995c89ac196bee2d3285dbdffe3` |
| ROOT/EMITTED_BINDING.md | `7dd3be1172eb31f6b497a709d9299492e1731e139e515446c25c271e563a57a5` |

## 2. Dokładny cel i moment obserwacji

Udowodnij pełny defined terminating **raw prefix load_skey** przy
q18433/logn10/ter1, do chwili powrotu `ffLDL_fft3` w falcon-sign.c:1253.
Punkt odcięcia leży PRZED ft_build_stable_certified_leaves i normalize.
RawPrefix_C jest semantycznym prefiksem rzeczywistego kodu, nie nowym API,
runtime patchem lub założeniem jego sukcesu.

Najpierw silniejszy bezpośredni interfejs:

```text
forall p,memory,
  P_key(p) -> LegalRawExpansionBuffers(memory,p) ->
  TerminatesDefinedAtRawPrefix_CANDIDATE(p,memory) and
  BasisWords = SourceFFT_B_CANDIDATE(p) and
  RawTreeWords = AssembleActualSourceSnapshots(
    RootSlice(p), Node3Slices(p), Node2Slices(p), RemainingInner7Trees(p)) and
  RawTreeLength = 18432 and
  All16896InternalWordsFinite and All1536RawLeavesPositiveFinite and
  CorrectSourceOrderAndFrame(memory).
```

Następnie jawny emitted corollary:

```text
forall E,sk,pk,p,memory,
  Emitted_CANDIDATE(E,sk,pk) -> SourceDecodeSameSTATIC(sk)=p ->
  LegalRawExpansionBuffers(memory,p) -> ten sam wniosek raw prefix.
```

E to legalny M0 environment; sk/pk są abstrakcyjnymi skończonymi bytes,
nie dostarczonymi sekretami. Jeden K_seed[E] jest warunkowany sukcesem
całego capped KeyGen i obu serializerów, nie zmieniany na K_iid.

Nie wzmacniaj P_key. Są to cztery Int^1536 vectors, ternary f/g,
|F_i|,|G_i|≤2047, exact fG−gF=q modulo X^1536−X^768+1 i actual mandatory
Gate00_C jak w ROOT. Nie dodawaj completed recursion, nowych positive pivots,
małego L, norm acceptance lub NumericCenter jako przesłanek.

Pełny wynik wymaga BOTH actual execution/totality oraz source numerical,
memory i output matching. Samo zestawienie rozmiarów, suma certyfikatów
lub frame dla prefixu, który już założono defined, daje tylko partial.

## 3. Jawny bridge starego pinu do FLOOR_CT

Zmapuj PREVIOUS_SOURCE.sha256 na CANDIDATE.sha256. Sprawdź16 identycznych
plików oraz jedyny diff w fpr_floor. FLOOR zawiera all-word pure replacement
i impact matrix. Ustal transitive call graph badanego raw prefixu i jego
emitted bindingu: primitives/splits/LDL/FFT/keygen gates użyte tutaj nie mogą
zostać uznane za niezmienione wyłącznie na podstawie nazwy pliku.

Rozlicz byte-identical function/table bodies oraz zależności. Jeśli floor
jest nieosiągalny w tym prefixie, wyprowadź to z aktywnego source/profile;
jeśli gdzieś jest konsumowany, zastosuj dokładny all-word bridge z premises.
Stare certyfikaty pozostają przy swoich hashach; nowy SOURCE_TRANSPORT.md
ma wiązać je z nowym źródłem, bez przepisywania historii. Nie przenoś CT
twierdzenia o floor na cały loader/Sign ani identyczności wyników na runtime.

## 4. Decoder, buffers i FFT/Gram prefix

Skonsumuj ROOT/EMITTED_BINDING z pełnym zakresem: coefficient caps, exact
NTRU integer lift, source STATIC roundtrip/G-present oraz Gate00 binding.
Odróżnij pomocniczy exact validator od numerycznych warunków ekspansji.
Arbitrary accepted decoder input nie jest automatycznie emitted/P_key.

LegalRawExpansionBuffers wyprowadź z rzeczywistych allocations/layout:
- N1536, sk ma16N=24576 fpr words: cztery basis arrays i12N raw tree;
- tmp ma co najmniej7N=10752 fpr words;
- legalne alignment/types/lifetimes, source vectors readable, writable
  buffers disjoint od const coefficients i od siebie; odróżnij dozwolone
  repeated read-only aliases od write/restrict violations;
- źródłowe offset/byte-size arithmetic mieści się w size_t/int domains.

Allocation failure nie staje się sukcesem lub nowym warunkowaniem K_seed.
Teza raw-prefix jest przy legalnych allocations; pełny publiczny load-key
API ze stable normalization nie jest jeszcze dowiedziony.

Śledź rzeczywisty prefix1159–1253: MKN/offsety, konwersje f,g,F,G,
FFT3 kolejno f,g,F,G, negacje f/F i matrix B=[[g,−f],[G,−F]], następnie
Gram source operations i call ffLDL_fft3. Guard q/logn/n występuje w kodzie
po FFT — nie przestawiaj go w modelu. Dla ustalonych parametrów wyprowadź
jego wynik z przesłanek. Pokaż bitowe snapshoty potrzebne dalszym callom.

ROOT certyfikuje conversion/FFT/Gram domains i root numerical slice;
skonsumuj odpowiednie bounds przed instrukcjami. Nie zakładaj complete IEEE,
idealnego Gram lub spectral bounds przyszłych computed pivots. Zachowaj
zero/subnormal/imaginary behavior i source operand caps.

## 5. Kompozycja w rzeczywistej kolejności

Zamknij luki pomiędzy wcześniejszymi local certificates a wykonaniem:

1. Root branch0: split_top(g00), Adj t1/t2 i cała depth1 recursion są
   PRZED root dim2. Ich facts pochodzą z FFT/Gram/Gate, nie z przyszłego D.
2. Depth1 najpierw wykonuje LDL3, potem trzy sekwencyjne split9/Adj/inner8
   na g00,d11,d22. Przenieś NODE3 snapshots przez lifetimes kolejnych children.
3. Każdy inner8: first split8/Adj/inner7 → frame → local level8 LDL2 →
   second split8/Adj/inner7. Użyj TOWER actual inner7 totality, nie samego
   isolated level7 lub założonego return. NODE2 daje właściwy local domain.
4. Po pełnym branch0 jego frame zachowuje root Gram. Dopiero teraz ROOT
   numerical certificate uzasadnia rzeczywisty root dim2 i computed D.
5. Root branch1: split/Adj czyta D zanim późniejszy NODE3 ponownie użyje
   jego storage. Złóż analogiczne trzy inner8 oraz sześć inner7.
6. Wyprowadź końcowy source return s=18432 i pełne tree/basis/frame postconditions.

Lower inner7 theorem już obejmuje levels7–1 i base inner1 z dwoma literalnymi
real leaf stores. Przy konsumpcji przejrzyj jego analytic instancję
Good/base/step/frames; abstract successful_execution ma jawne premises.
Nie zastępuj ich aksjomatem desired final tree.

Ranky recursion i finite loops dają zakończenie dopiero po ustanowieniu
każdej consumed operation domain. Nie zakładaj dojścia do późniejszego call
w celu uzasadnienia własnego wcześniejszego prefixu. Używaj actual-input
Hermitian/refined imaginary bounds z NODE2/TOWER, nie luźnego coarse c2.

## 6. Physical layout, lifetimes i dokładna sekwencja

Wyprowadź/source-bind offsets z TOWER/ASSEMBLY_INTERFACE:

```text
root L: [0,1536)
B_b = 1536 + b*8448                  (cubic branch start)
A_bk = B_b + 1536 + k*2304           (inner8 start)
inner7 start = A_bk + 256 + e*1024   (b,e in Fin2; k in Fin3)
```

Każdy inner7 to896 internal L i128 raw leaves. Całość:
1536 root +3072 cubic +1536 level8 +10752 remaining internal =16896,
plus1536 raw leaves=18432. To wniosek coverage/bijection, nie przesłanka
poprawności. Rozlicz każdy store/read i końce obszarów; shape nie zastępuje
bitowego matching local slices z rzeczywistą source execution.

Root Gram w tmp ma [0,N),[N,2N),[2N,3N); gxx zaczyna się w3N.
Top scratch potrzebuje3584 words<4N dostępnych od gxx. W depth1/input
prefixach zachowaj konkretne offsets/lifetimes z ROOT_FRAME/NODE3_FRAME/
NODE2_FRAME. Źródłowy order pisania L/children nie pokrywa się z layout order.
Input snapshots muszą istnieć w MOMENCIE odczytu; nie wymagaj niezmienności
storage root D lub niższego d11 po legalnym scratch reuse.

Zapisz raw leaf-position map i literalną sekwencję raw leaf words, potrzebną
następnemu etapowi. Nie podstawiaj stable rebuilt leaves ani normalized
widths w miejsce source subtractive raw pivots.

## 7. Kontrole i proof boundary

Uniwersalny argument może być mixed analytic/kernel jak upstream, lecz
każda translacja/memory/numerical premise ma być jawna. Nowe/edytowane Lean:
pełne czyste logs/types/terms/axioms; bez sorry/admit/native_decide/
Lean.ofReduceBool, aksjomatu wniosku lub warning suppression. Reused lemmas
ze źródeł/pinów i fresh rebuildem. Nie ogłaszaj formalnie zweryfikowanego GCC.

Kontrole C normal oraz ASan/UBSan: pełna original ffLDL_fft3 na publicznych
synthetic Gram arrays z preflightem domains oraz literalny raw-prefix slice
na publicznych synthetic coefficient arrays. Slice musi być związany diffem/
spanami z dokładnym kodem i zatrzymywać się po1253. Nie uruchamiaj realnego
secret-key API, całego load_skey, stable rebuild, normalization, KeyGen lub Sign.
Nie wyszukuj/generuj nowych kluczy. Fixtures nie muszą spełniać P_key;
oznacz dokładnie ich domenę i nie nazywaj ich emitted witnesses.

Sprawdź: wszystkie18432 raw words, basis6144 words, source-order event trace,
input preservation, allowed const aliases, scratch high-water/lifetimes,
canaries i leaf map. Observers wywołują oryginalne primitives raz, bez zmiany
arytmetyki/kolejności. Niezależny checker/model nie może być tylko drugim
wywołaniem tego samego C. Dodaj no-op i rzeczywiste mutation controls dla
pominiętego child, złego offsetu/leaf permutation, błędnego momentu snapshotu
i nieuprawnionego frame. Invalid cases zatrzymaj przed potencjalnym UB.

Rozróżnij test struktury, mathematical countermodel rozszerzonej domeny,
P_key counterexample i emitted reachability. Finite controls/hash replay
nie dowodzą uniwersalnej kompozycji.

## 8. Następny interfejs i statusy

Wyeksportuj dokładny RawPrefixCertificate dla stable rebuild/normalization:
basis/tree snapshots, leaf map, memory/frame, positive finite raw leaves,
source pin i proof dependencies. Kolejny etap ma dowieść rzeczywistej
stored width sequence, sqrt/inverse/scaling/gates i zachowania internal L.
INITIAL_TARGETS oraz ORDERED_REACH→NumericCenter są jeszcze osobne.

Pełny status: `H3_RAW_ASSEMBLY_PROVED_FOR_PINNED_MODEL`, tylko przy pełnej
raw-prefix totality, numerical instancji, matching/layout/frame i emitted
corollary. W innym przypadku PARTIAL_PROOF z pierwszym dokładnym brakującym
typem, COUNTEREXAMPLE_REQUIRED_DOMAIN/EXTENDED_DOMAIN z membership albo
EXECUTION_BLOCKED z pełnym logiem. Sam generic composition theorem jest partial.

RESULT rozdziela raw_loader_prefix_proved, raw_tree_assembly_proved,
raw_prefix_totality_proved, emitted_corollary_proved, source_transport_proved,
internal_words/leaf_words, proof_kind i raw_prefix_fully_kernelized.
Pełny wynik nie implikuje pełnej zakończonej ekspansji po normalization:
normalized_expansion_proved=false, full_private_loader_proved=false,
H3_range_proved=false, global_reachability_proved=false,
sampler_law_proved=false, security_reduction_proved=false, full_sign_ct_proved=false.
Nie ustawiaj niekwalifikowanego full_internal_tree_proved dla post-normalize
loadera; jeżeli użyjesz tego pola, jawnie ogranicz jego zakres do raw cut.

## 9. Wykonanie, freeze i handoff

Tylko W writable, IN/source RO, jeden wykonawca. HOME/TMPDIR/DOT_SAGE/
LEAN_PATH/cache/olean/bin pod W, bounded wall/CPU. GCC14.2/C99/LP64 i literalny
Makefile profil; Sage10.9 przez `sage plik.py ...`, Lean4.34/Std -j1 -M2048,
normal8GiB, ASan osobno z shadow. Bez instalacji/sieci/Git/innych agentów,
sekretów/.private/private_extraction, prywatnych seedów/współczynników.
Nie zmieniaj C, parametrów, guards, P_key lub M0. Dudect jest osobną nocną
pracą prowadzącego; nie uruchamiaj kolejnej kampanii timingowej w tym zadaniu.

Wymagane REPORT/RESULT/CLAIM, RAW_PREFIX_CERTIFICATE.json, COMPOSITION.md,
SOURCE_TRANSPORT.md, SOURCE_MODEL_BINDING.md, MEMORY_LAYOUT.md,
LEAF_MAP.json, NEXT_INTERFACE.md, OBLIGATIONS.json, REUSED_RESULTS.md,
formalne źródła/certyfikaty/checkery, INPUTS.sha256, TOOLCHAIN.txt,
COMMANDS.log, OUTPUT_SCOPE.md, REPLAY.md, SEMANTIC_FILES.json, OUTPUTS.sha256.
Zachowaj także próby nieudane i pełne command/exit/stdout/stderr receipts.

Standard `scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256`: external
pin/full manifest przed nowym DEST, fresh build bez cache/olean/bin, semantic
matches path/SHA. Rehearsal ma osobną kotwicę bez cyklu; po freeze tylko nowy
DEST, bez dopisywania do frozen plików. source_changed=false,
production_source_changed=false,new_source_patch_integrated=false,
owner_accepted=false. Prowadzący wykonuje niezależny odbiór/import/commit.
Podaj REPORT/OUTPUTS SHA-256, dokładne tezy/zakres i następny typ. Zakończ
na handoffie, bez samodzielnego rozpoczynania normalization.
