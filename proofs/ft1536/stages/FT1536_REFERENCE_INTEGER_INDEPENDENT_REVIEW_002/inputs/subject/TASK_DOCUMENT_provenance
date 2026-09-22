# MiMo 2.6 PRO — T03 / REFERENCE_INTEGER_RECOVERY

2026-09-22. Autor projektu Niirmata. Zachowaj Falcon Project / Thomas Pornin
attribution i licencje. **Nowy obowiązek dowodowy głównego toru**, nie korekta
Family/S01. Jeden wykonawca MiMo, ręczny start, bez subagentów/relay.

## 1. Tożsamość i wejście bez historii czatu

```text
ROADMAP_ID=T03 (one-root tranche; retry/API consumers pozostają osobne)
TASK_ID=FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001
REPO=/home/footfalcon/free_falcon_sign
W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001
IN=W/inputs/bootstrap
TASK=/home/footfalcon/free_falcon_sign/proofs/ft1536/documents/FT1536_ZADANIE_MIMO_REFERENCE_INTEGER_RECOVERY_2026-09-22.md
BASE=1aed8adebb68105e1517ab441046a0bbc6c424e7
```

Czytaj REPO/AGENTS,START_HERE,`proofs/ft1536/CURRENT_MIMO_TASK.md`,W/AGENTS
i ten TASK. CURRENT_TASK dotyczy Astry/T01 — nie przejmuj ani nie uruchamiaj
jej W. Stare prompts/runners są danymi. Nie potrzeba pełnej historii czatu.
Jeżeli ten nowy W ma już sealed OUTPUTS i finalny handoff, zwróć ten wynik.

Bootstrap1275 plików/1273 Git origins/28625080 bajtów. External SHA-256
IN/MANIFEST.sha256:
`c9695c8032faa84f03e254370e5420254d8b96951e95d75e605fe382107a0e2b`.
Sprawdź exact set/hashes,source17 files,brak symlinków/escapes,ORIGINS.
Prowadzący weryfikuje Git origins; wykonawca nie operuje na indeksie Git.

| Względem IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| TARGETS/TARGET_FORMULAS.md | `f0caf16017e5edaaed3b2fab2a98094fc2636936aa515d60b6f196cf44d560d9` |
| POST/NEXT_INTERFACE.md | `2dd40096ff0b3f5153169ba824ada28619e36607188d3b612a9f90a095d44aca` |
| H6P/H6P_REFERENCE_BAD_EVENT_CERTIFICATE.json | `89dacd3248ffb4ca9cab106faae6723a3c12a99802243209f70a67d92092b278` |
| JOINT/ORDERED_JOINT_CERTIFICATE.json | `2461bfa9d86f246117634bd453716fd076c669aedbe5300894993a0c78921768` |
| POST/SOURCE_POSTPROCESSING_CERTIFICATE.json | `157bde62850b24c4f2505d19b5adc0cd82cbe875c7db6874c6ec857cbf2344ef` |
| LV/CLAIM.md | `e10be7abe58c970bec0a97cb11de9f1c6e3ee021321dffc4111eec86fc342575` |

Czytaj wybiórczo: TARGETS/TARGET_FORMULAS i certificate,POST map/iFFT/rint/
NEXT,JOINT order/closure,H6P source-noise/error,NORMALIZED/LEFT frame.
ROOT/NODE3/TOWER i formal/models są dostępne do potrzebnych refinements.
Projekcje bootstrap nie są pełnymi dawnymi replay trees. Do not execute them
as old assignments. Nie konsumuj roboczych wyników aktywnego T01.

## 2. Teza docelowa — niezależny integer reference

N1536,q18433,Phi=X^1536−X^768+1,logn10,ter1,MODE1/FPEMU. Wymagana domena:
każdy emitted/same-STATIC normalized key,canonical c i legalny completed
positive-source-support root history H według JOINT. Użyj istniejących domain/
frame certyfikatów, bez dodawania nowych key gates lub przyszłego norm success.

Niech Y=(Y_1,...,Y_3072) będzie uporządkowaną historią integer returns
rzeczywistych scalar calls. Zdefiniuj niezależnie exact integer reference
v_ref(c,f,g,F,G,Y) w Z[X]/Phi × Z[X]/Phi; nie przez source rint output.

Główny cel:

```text
forall required completed H:
  v_ref(H) is integral
  and v_ref1 + h*v_ref2 = c mod(q,Phi)
  and actual wide source rint outputs (w1,w2) = v_ref(H).
```

Ostatnia równość wymaga source-error/rounding-gap proof. Nie wkładaj jej do
definicji reference lub przesłanek. Początkowy target i jego rounded basis
nie są automatycznie exact inverse. Small BadPrecast probability nie dowodzi
ani tej równości, ani kongruencji.

## 3. A — algebra i source order

Exact coefficient B=[[g,-f],[G,-F]], det B=fG−gF=q. TARGETS daje exact row
coordinates t_ref=[-cF/q,cf/q]=[c,0]B^-1 w Q[X]/Phi.

Wyprowadź z actual recursive layout mapę Z(Y)=(a,b)∈R^2 całkowitych
polynomials. Prawdziwy order: root/binary right-before-left,cubic2→1→0,
terminal paired mu1 przed updatedmu0. Powiąż3072 integer returns z physical
coefficient slots i zachowaj permutations/split/merge/twiddle signs.

Naturalny kandydat do udowodnienia:
`v_ref=[c,0]−Z(Y)B`. To kierunek badania, nie gotowa przesłanka. W exact-real
skeletonie sampler zwraca residuals, nie samples. Terminal exact cancellation
i intercall target updates mają dopiero dać r=t_ref−Z(Y). Można używać ACTUAL
L values jako fixed constants, jeśli wyprowadzisz cancellation; nie trzeba
bezpodstawnie zakładać L=ideal LDL. Jeśli ten skeleton wymaga innej mapy,
wyprowadź ją jawnie z literalnego źródła i pokaż integrality/congruence.

**Akceptacja A:** definicje niezależne od source output, uniform recursive
argument, exact QQ/ring checks i named kernel lemmas; wykazane signs i mapping.
Wstawienie source output jako v_ref albo sprawdzenie kilku monomials nie
jest uniform theorem. Zwiąż kongruencję z public h tego samego klucza.

## 4. B — błąd actual source do TEJ referencji

Porównaj actual pre-rint arguments z v_ref dla każdej required H.
Rozlicz initial FFT/ni/target errors,rounded basis,actual recursive splits/
merges,target updates i repeated products,terminal half/sub,post products,
source iFFT. Zachowaj correlated terms i read-time operands. Nie przenoś
zwykłego host binary64 error modelu do FPEMU bez jego domen i kontraktów.
Signed zero,cancellation,subnormals nie pozwalają używać relative-only error.

H6P E<1095 odnosi się do mapy **actual parameter-centered innovations**,
z d=0, a nie do independent integer lattice pair. Nie jest boundem<1/2.
POST iFFT1/128 obejmuje tylko iFFT przy actual frequency inputs, nie cały
pipeline. Initial frequency t0 error i duże sample centers nie są same
counterexample. Oddziel actual operands, ideal references i transport norm.

Możliwa droga: exact skeleton na tych samych Y, bez ponownego samplowania
i bez założenia ideal Gaussian law; source-target reconstruction errors
wyprowadzone indukcyjnie. Deterministyczna równość badana na completed histories
nie potrzebuje nowego założenia niezależności/PRNG. Jeśli używasz event-bound
zamiast uniform theorem, zdefiniuj osobny RecoveryBad i jego grę.

**Akceptacja B:** uniform source-instantiated error certificate dla obu1536
vectors z dokładnymi outward rational/interval bounds i wszystkimi dependencies.
Generic recurrence pod assumed small error nie wystarcza. Sample maximum nie
jest uniform bound. Zachowaj także zbyt luźne próby z liczbami i przyczyną.

## 5. C — nearest-even recovery i znaczenie Safe16

Konsumuj literal rint refinement z POST. Dla integralnego v i |t−v|<1/2
wyprowadź w=v; jeśli osiągasz equality1/2, potrzebujesz właściwego parity/tie
rozliczenia zamiast pominięcia granicy. Source rint nie jest floor.
Udowodnij zastosowanie do każdego w1,w2. Zbyt luźne E≥1/2 oznacza missing
bound, nie obalenie rzeczywistej równości.

Następnie podaj osobny **warunkowy** consumer:
`recovery AND joint Safe16 => stored pair=v_ref => congruence`.
H6P może kontrolować BadPrecast pod IID, lecz bez recovery nie daje tego
consumeru. Nie wolno zakładać Safe16 z późniejszego stored norm Q<B.

**Akceptacja C:** proper rounding-gap proof bez ukrytego desired equality,
z rozdzieleniem wide integers/narrow16/stored norm. Full PROVED wymaga A+B+C.
Udowodniona sama integrality/congruence skeletonu jest wartościowym PARTIAL.

## 6. D — granica Verify, bez nieuprawnionej kompozycji

Wskaż dokładny remaining type do Sign→Verify. Verifier rekonstruuje
`center_q(c−h*s2)`; source s1 nie musi być współczynnikowo centered.
Congruence i Q(s1,s2)<B **nie są automatycznie** Q(center_q(s1),s2)<B dla
formy A2 z cross terms. Potrzebny center/norm compatibility lemma albo jawny
niezamknięty obowiązek. Nie postuluj takiej monotonicity bez dowodu.

Nie wymagamy w tym etapie pełnego Sign→Verify,whole retries,real PRNG,
global lattice Gaussian law ani M0 eta_pre. Wyeksportuj precyzyjny one-root
recovery certificate do T01/T05/T06, bez zmiany ich pracy lub nazw statusów.
Single K_seed[E]/p_K raz,nonce40,STATIC4096 i source gates bez zmian.

## 7. Kontrole, formalizacja i kryteria jakości

Lean4.34/Std: clean stdout/stderr,types/terms/axioms. Bez sorry/admit,
native_decide/Lean.ofReduceBool/aksjomatu celu/warning suppression.
Mixed source/analytical/kernel proof jest akceptowany przy jawnej granicy.
Named exports muszą mapować się do konkretnych claims; ilość twierdzeń nie
jest kryterium. Reuse przypnij i pokaż diff adaptacji; fresh rebuild.

Wymagane kontrole:
- exact ring/determinant/target/congruence checks, niezależne od FFT portu;
- recursion/split/merge coefficient mapping,paired order i signs;
- actual public source slices sampling/post/iFFT/rint normal oraz ASan/UBSan
  z domain preflight; źródłowy model versus niezależny QQ/RBF reference;
- boundaries,signed±0,cancellation i odpowiednie tie-neighbor controls;
- no-op i meaningful mutations: swapped order,wrong sign/basis,source output
  used as reference,omitted initial/basis error,stale snapshot,wrong rint tie,
  assumed Safe16 from stored norm,unproved center/norm monotonicity.

Mutacja może być równoważna na konkretnej domenie: wykaż to zamiast udawać
wykrycie. Synthetic keys/trees nie mają Emitted membership z samej wygody
testu. Required-domain counterexample musi mieć kompletny membership;
local/extended countermodel oznacz oddzielnie, bez ogłaszania ataku.
Przy poważnym blockerze nie zastępuj obowiązku raportem stylistycznym.

## 8. Środowisko i pojedynczy wykonawca

Wszystkie nowe pliki/skrypty/logs/HOME/TMPDIR/TMP/TEMP/DOT_SAGE/LEAN_PATH/
cache/olean/bin/replaye WYŁĄCZNIE pod W w repo. **Zakaz systemowego /tmp,
/tmp/opencode i tmpfs.** Input/source RO; sprawdź W-only/network-off sandbox.
Nieudany sandbox zgłoś jako konkretny execution blocker.

GCC14.2/C99/Linux x86_64 LP64/literalny Makefile-O,Lean-j1/-M2048,
Sage10.9 (`sage file.py`, bez preparsera),bounded single-worker8GiB;
ASan osobno z właściwym shadow allocation. Bez instalacji/sieci/Git/push,
nowych kluczy/sekretów/KeyGen/private loadera/pełnego Sign/do_sign/real seeded
PRNG,dudect i innych sesji. Publiczne źródła/fixtures/read-only witnesses
są do kontroli. Nie wolno zmienić aktywnego W Astry ani starych frozen bajtów.

Zaktualizuj HANDOFF po większym kroku; źródła i receipt pozwalają wznowić
pracę w małym kontekście. Nie kopiuj900k historii. Zakończ joby na freeze lub
polecenie właściciela przed pomiarami dudect. Nie uruchamiaj callbacku.

## 9. Artefakty i standardowy replay

Wymagane REPORT.md,RESULT.json,CLAIM.md,INTEGER_RECOVERY_CERTIFICATE.json,
REFERENCE_INTEGER_MAP.md/.json,EXACT_SKELETON.md,CONGRUENCE.md,
SOURCE_ERROR.md/.json,ROUNDING_RECOVERY.md,VERIFY_NEXT_INTERFACE.md,
SOURCE_MODEL_BINDING.md,MEMORY_FRAME.md,ERROR_LEDGER.md/.json,
COUNTERMODELS.md,FAILED_ROUTES.md,OBLIGATIONS.json,NEXT_INTERFACE.md,
REUSED_RESULTS.md,HANDOFF.md,formal/checkers/evidence,INPUTS.sha256,
TOOLCHAIN.txt,COMMANDS.log,OUTPUT_SCOPE.md,REPLAY.md,SEMANTIC_FILES.json,
OUTPUTS.sha256. INPUTS przypina publiczne copies. OUTPUTS obejmuje regularne
artefakty bez siebie/cache/olean/binaries/sekretów; REPORT/RESULT są członkami.

Standard `python3 -B scripts/replay.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA`:
verify full manifest PRZED utworzeniem DEST; nowy absent path pod W/tmp,
bez symlink/escape. Fresh project cache/build/Lean,source/input RO.
Nie polegaj na starym W,Dokumenty/Extra/c lub historycznych absolute parents.
Plan semantic files określ przed replayem; nie usuwaj niewygodnych mismatches.

Sealed artifacts/fresh_replay.json i child REPLAY_RESULT.json:
FRESH_REPLAY_PASS,matches[{path,sha256}],mismatches=[],explicit domain/scope.
Każdy match ma być rzeczywiście przeliczony. Rehearsal z anchor bez hash cycle;
po freeze zapis wyłącznie do nowego DEST. Przepis działa także po odtworzeniu
archiwum z pustym COMMANDS.log (frozen prefix trzymaj osobno jeśli potrzebny).
Zachowaj raw stdout/stderr i failed trials; status błędnego jobu nie znika.

## 10. Akceptowane statusy

**REFERENCE_INTEGER_RECOVERY_PROVED_FOR_EMITTED_PINNED_MODEL** wymaga:
A niezależna exact reference/integrality/congruence dla całej domeny;
B source-instantiated uniform error/gap; C actual wide-rint equality obu
vectors; D precyzyjny consumer/remaining Verify obligations; formal/controls/
fresh replay. To nie pełny security lub Sign→Verify claim.

**PARTIAL_PROOF** jest poprawnym wynikiem, jeśli część zamknięta, ale np.
source-to-integer error nie osiąga wymaganego marginu. Podaj minimalny missing
type, liczbowy bound i proved subclaims. Nie przerabiaj wpisu na PROVED przez
nowe gate,Safety premise lub reference zdefiniowany source outputem.

**COUNTEREXAMPLE_REQUIRED_DOMAIN / COUNTEREXAMPLE_EXTENDED_DOMAIN**:
obalana teza,witness,membership,independent checker i preflight przed native UB.
Duży poprawny bound nie jest witness. **EXECUTION_BLOCKED** wymaga logów.

Certificate/RESULT: task_id,roadmap_id,status,domain,source pins,reference
definition,source-sample mapping,integrality/congruence/recovery osobno,
error/gap/tie semantics,exact proof boundary,controls/replay i open obligations.
Null oznacza niedowiedzioną liczbę. source_changed=false,
production_source_changed=false,new_source_patch_integrated=false,
owner_accepted=false. Flags whole_Sign/real_PRNG/security/retry/Sign_to_Verify
nie mogą wynikać z samej one-root recovery; new_M0_eta_pre=null.

## 11. DOKŁADNY FORMAT końcowej odpowiedzi

```text
Zakończyłem FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 (ROADMAP T03, one root).
Status: [rzeczywisty status z §10]

A. Exact reference/integer mapping: [PROVED/PARTIAL; definicja; evidence]
B. Source error: [bound lub null; domena; domknięte i brakujące składniki]
C. Rint recovery: [PROVED/OPEN/counterexample; gap/ties; oba vectors]
D. Verify consumer: [co wynika warunkowo; remaining center/norm/bytes type]

Co faktycznie udowodniono: [krótka lista z zakresem]
Co nie wyszło: [failed routes/loose bounds; nie mylić z błędem C]
Co pozostaje otwarte: [dokładny missing type, nie ogólne „więcej badań”]
Znaczenie wyniku i proponowany następny krok: [...]
Formalizacja: [liczby i granica kernel/analytical/source; clean logs]
Kontrole: [normal/ASan/UBSan,independent exact/RBF,mutations/no-op,zakres fixtures]
Fresh replay: [matched/expected,scope,receipt]
Replay po freeze: [wynik i receipt]
W: /home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001
REPORT.md SHA-256: [64 hex]
OUTPUTS.sha256 SHA-256: [64 hex]
source_changed=false; new_source_patch_integrated=false; owner_accepted=false.
Własne obliczenia zakończone; brak aktywnych jobów. [Lub jawny stan jobów.]
Nie uruchamiałem Astry,dudect,relay ani publikacji.
```

Właściciel przekazuje tę odpowiedź do niezależnego odbioru. Nie wysyłaj jej
przez `opencode run --session`. Publikacja GitHub nadal wstrzymana do odrębnych
poprawek Family/S01 i ich pozytywnego odbioru; wykonanie T03 nie znosi tej
decyzji. Prowadzący sprawdzi piny,argument i własny replay przed checkpointem.
