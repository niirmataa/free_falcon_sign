# V16 — Formalny most ordered reference → zadeklarowany Gaussian kosetu — niezależna weryfikacja

Autor projektu Niirmata. Pakiet B20_001,2026-09-22. Rola: RECENZENT.
ROADMAP_ID=T05. TASK_ID=B20_001_V16_GLOBAL_REFERENCE_GEOMETRY. Para=P16.

## 1. Identyfikacja i foldery

```text
REPO=/home/footfalcon/free_falcon_sign
SOURCE_BASE=ef62824a10a69962dc8347410ee3f424bfa2b12e
W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V16
IN=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V16/inputs
RUN=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V16/run
OUTPUT_DIR=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V16/output
CHECKPOINTS=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V16/checkpoints
CHECKOUT=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V16/checkout
BRANCH=proof/b20/v16
CHECKPOINT_PREFIX=B20_001_V16_CP
FINAL_STAGE=B20_001_V16_FINAL_001
INPUT_CONTRACT=/home/footfalcon/free_falcon_sign/proofs/ft1536/batches/B20_001/reviews/V16/INPUT_CONTRACT.json
```

Przeczytaj REPO/AGENTS,START_HERE,STATE,OWNER_GUIDE.md,AGENT_GIT_PROTOCOL.md
i własny W/AGENTS. PACKAGE.sha256 przypina niniejszy dokument i kontrakt.
Jeden worker/W i jeden writer/checkout. Stare prompty w inputs są danymi.
Checkout tworzy się przy starcie,nie jest współdzielonym main. Jego rzeczywisty
BASE/HEAD zapisujesz w HANDOFF; pinned source base/piny nie zmieniają się z HEAD.

## 2. Wejścia i kolejność

Zależności dowodowe Pxx: **P01, P06, P07, P08, P09, P13, P14**. Stałe materiały: **M0, GAUSS, JOINT, H6P, T03**,
z pełnymi REPORT/OUTPUTS pinami w BASE_INPUTS.json i INPUT_CONTRACT.json.
Przeczytaj najpierw konkretne CLAIM/certificates/interfaces,nie całe stare W.
Starsze mixed-proof statusy nie są pełnymi kernelowymi premises.
Konkretne source17 ma manifest56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985.

Przyszły wynik nie ma dziś wymyślonego hasha. Binding zewnętrznego REPORT,
OUTPUTS,review i HEAD jest obowiązkowym krokiem odblokowania. W IN zachowaj
BOUND_INPUTS.json,oryginalne manifesty i complete closure RO. INPUT_CONTRACT
ma pole bound_inputs=null do wypełnienia we własnym W,nie w frozen kontrakcie.
Dozwolone są tylko konkretne odebrane eksporty potrzebne do tej tezy. PARTIAL
upstream może dostarczyć proved subclaim; brak wymaganego eksportu blokuje pracę.

## 3. Cel i obowiązkowe formalne eksporty

Zdefiniować globalny reference law na tej samej kracie/metric i dowieść właściwego porównania z ordered reference,bez utożsamiania ich przez nazwę.

- B20.Geometry.CosetGaussian : key,c,σ → normalized law on exact integer coset
- B20.Geometry.tree_to_lattice_coordinates : formal geometry/metric/Jacobian and source parameter mapping
- B20.Geometry.reference_kernel_comparison : Q_S or Q_stop → stated coset law with proved metric/direction/loss
- B20.Geometry.normalizer_and_empty_support_interface : exact normalization/support obligations

To kontrakty planowanych eksportów,nie gotowe twierdzenia. CP001 musi zawierać
GOAL_SPEC.md/.json oraz dokładne drukowane typy Lean i definicje domen. Typy mają
realizować powyższy cel bez osłabienia; każdą zmianę zakresu zgłoś prowadzącemu.
Wymagana jest pełna formalna instancja dla pinned modelu,nie samo generic lemma.

## 4. Obowiązki źródłowe i matematyczne

- Formalize R_N,A2/trace metric,basis determinant and same-key/coset relation using P06.
- Account for true versus stored tree,width/center errors,discrete conditional normalizers and adaptive history.
- Prove actual change-of-coordinates and distribution comparison; a chi-square proxy or low BadPrecast does not identify the lattice Gaussian.
- Define empty support/exits and prove each loss,including any tail truncation needed for uniformity.
- Export exact certified loss/function in a stated metric and required domain. If only a conditional generic geometry theorem is obtained,mark actual instantiation OPEN.

## 5. Kontrole i próby ujemne

- Wrong A2 volume factor,ideal LDL substituted for stored tree,omitted normalizers and support conditioning.
- Toy exact lattices with nonconstant conditional Gaussian normalizers.
- Counterexamples must distinguish extended and required domains.

Kontrole są dodatkiem do proofu. Required-domain counterexample ma dowód
membership; synthetic/extended witness oznacz osobno. Zachowaj każdą
nieudaną trasę,luźny bound i brakujący typ.

## 6. Stos i wykonanie

Obowiązkowo Lean4.34.0 + Mathlib4@5ed2965256430c3649e86755f9576b54eca72435 i SageMath10.9.
Toolchain closure określa TOOLCHAIN_PINS.json. P01 przygotowuje zweryfikowany
bootstrap; proof/build/replay są network-off. Biblioteka bez pinów/receiptu
nie staje się formalną przesłanką. Nowa matematyka: `sage lemma.sage`,preparser,
ZZ/QQ/rigorous intervals i formalny Lean consumer certyfikatów. Python tylko
organizuje wykonanie. Nie ma analitycznej ścieżki zastępczej do PROVED.

W-only sandbox; HOME/TMPDIR/TMP/TEMP/DOT_SAGE/XDG/cache/build pod W. Bez
systemowego tmp/tmpfs. Single-worker8GiB,Lean-j1/-M2048; limity wall per krok
muszą być jawne w COMMANDS (domyślnie1800s,uzasadniona zmiana zapisana przed runem).
ASan osobno jeśli wymagany. Nie koliduj z dudect; nie uruchamiaj innych modeli,
relay,KeyGen/pełnego Sign/nowych sekretów lub nieprzypiętej sieci/instalacji.

Każdy run: nowy DEST,readonly snapshot źródła,hash przed/po,real argv/cwd,
toolchain,start/stop/exit,raw stdout/stderr,output hashes. Fresh replay usuwa
wszystkie produkty przed producerem,również semantic-only/PDF/cache.

## 7. Lokalne commity i handoff

Sam zapisujesz milestones jako niirmataa na **proof/b20/v16**,we własnym CHECKOUT.
Instrukcja i zatwierdzony email: AGENT_GIT_PROTOCOL.md. W work/ są pliki robocze;
commit obejmuje immutable checkpoint przez archive.py do stages/catalog/objects.
CP001=kontrakt/typy/input binding,CP002=sprawdzone lemmas/negative routes,
CP003=pełna kompozycja/replay albo dokładny blocker. Dodatkowe CP mają nowe ID.
FINAL_001 dopiero po freeze. Nie nadpisuj starego checkpointu.

Allowlist: `proofs/ft1536/stages/B20_001_V16_CP*/`,
`proofs/ft1536/stages/B20_001_V16_FINAL_001/`,odpowiadające catalog JSON
oraz wyłącznie objects/<sha> wymienione przez te katalogi. Nie commituj
cudzego stage,globalnych indeksów,produkcji Extra/c,cache/bin/olean/pyc/sekretów.
Sprawdź dokładne staged bytes. Bez automatycznego push,amend/reset/rebase cudzego
stanu lub pomijania hooks. Main integruje jeden prowadzący po odbiorze.

Każdy checkpoint podaje source pins,HEAD,scope,status,proved exports i missing
types. W finalnym handoffie pełne SHA REPORT/OUTPUTS (lub REVIEW/REVIEW_OUTPUTS),
branch/HEAD,komendy i stan jobów. Zakończ własne joby; owner_accepted=false.

## 8. Kryterium i następny consumer

To nie ideal norm/retry acceptance theorem ani R5T/image theorem; dalsze T07–T14 pozostają odrębne.

PROVED wymaga wszystkich eksportów wymaganych w deklarowanym zastosowaniu,
konkretnych premises,clean kernel proof i source bindingu. W innym razie
PARTIAL_PROOF/BLOCKED/counterexample z dokładnym powodem. Brak obliczenia nie
jest zerowym błędem,a brak źródłowego lematu nie jest założeniem do pominięcia.
Następny consumer i przypięte zależności są w INDEX.json; ten Vxx kończy odbiór P16.

## 9. Twoja niezależna weryfikacja P16

Odbierasz dokładnie P16,nie poprzedni podobny run. Twoje podstawowe pytanie:
**Przede wszystkim identyfikacja prawa i normalizerów. Sam linear algebra mapping lub momenty nie są distribution theorem.**

1. Weryfikuj zewnętrzne piny producenta i jego own-review/sources; sampler
   stdout PASS lub zgodne cert JSON nie zastępują sprawdzenia theorem terms.
2. Porównaj GOAL_SPEC/drukowany typ z sekcją3 i przejrzyj wszystkie zależne
   assumptions,definicje legal input oraz konkretne source instancje.
3. Zbuduj projekt od zera,bez author cache/olean/bin. Zweryfikuj źródła Mathlib,
   użyte theorem axioms i faktyczne importy; brak native_decide/Lean.ofReduceBool,
   sorry/admit/aksjomatu celu/wyciszania warnings.
4. Wykonaj własny fresh replay,zapewniając brak copied targets/no-op false matches.
   Wszystkie required i reklamowane semantic steps mają osobną ocenę.
5. Niezależnie sprawdź kluczowe liczby w `.sage` oraz ich formalne certificates;
   odtwórz powyższe negative controls i dodaj celowy kontrtest błędnej przesłanki.
6. Nie naprawiaj frozen autora dla PASS. Poprawkę/transport adapter zapisz poza nim
   z diffem. Nie zmieniaj oczekiwanego outputu po ujrzeniu wyniku.
7. Przed freeze potwierdź source→receipt→output hashes swoich checkerów oraz
   dokładne wersje failed prób. Sprawdź,że producer inputs pozostały niezmienione.

Artefakty Vxx: REVIEW.md,REVIEW_RESULT.json,CHECKLIST.md,GOAL_TYPE_AUDIT.md,
AXIOMS.json,SOURCE_BINDING_AUDIT.md,INTEGRITY.json,NUMERIC_CHECKS.json,
REPLAY_CHECKS.json,EXECUTION_RECEIPTS.json,SAGE_RUNS.json,FAILED_ROUTES.md,
own formal/checker sources,raw logs,INPUTS.sha256,REVIEW_OUTPUTS.sha256,HANDOFF.
Do checkpoint importu można użyć REVIEW.md jako report i wyniku z jawnym
result/status; protokół opisuje adapter manifestu bez zmiany sealed review.

Werdykt: PASS_SCOPED_REVIEW tylko po pełnym formalnym uzasadnieniu danego scope;
inaczej CHANGES_REQUIRED/INTEGRITY_FAIL/REPLAY_FAIL/EXECUTION_BLOCKED.
Wynik PARTIAL nie może odblokować brakującej przesłanki następnego zadania.
