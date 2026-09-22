# V03 — Kernelowy kontrakt init/refill/layout/counter rzeczywistego frng.c — niezależna weryfikacja

Autor projektu Niirmata. Pakiet B20_001,2026-09-22. Rola: RECENZENT.
ROADMAP_ID=T02.1 → T02. TASK_ID=B20_001_V03_PRNG_LAYOUT_KERNEL. Para=P03.

## 1. Identyfikacja i foldery

```text
REPO=/home/footfalcon/free_falcon_sign
SOURCE_BASE=ef62824a10a69962dc8347410ee3f424bfa2b12e
W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V03
IN=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V03/inputs
RUN=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V03/run
OUTPUT_DIR=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V03/output
CHECKPOINTS=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V03/checkpoints
CHECKOUT=/home/footfalcon/free_falcon_sign
BRANCH=main
FINAL_STAGE=B20_001_V03_FINAL_001
INPUT_CONTRACT=/home/footfalcon/free_falcon_sign/proofs/ft1536/batches/B20_001/reviews/V03/INPUT_CONTRACT.json
```

W nowej sesji przeczytaj REPO/AGENTS,START_HERE,STATE i AGENT_GIT_PROTOCOL.md
raz; potem własny TASK,kontrakt wejść i ostatni handoff. PACKAGE.sha256 przypina
ten dokument i kontrakt. Pracujesz w swoim W; Git to istniejący **main** w REPO.
Workflow: work → weryfikacja → zaakceptowane stages → lokalny commit.
W HANDOFF zapisujesz source HEAD; source base/piny są nadal stałe.

## 2. Wejścia i kolejność

Zależności dowodowe Pxx: **P01, P02**. Stałe materiały: **T01, SCALAR**,
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

Sformalizować deterministyczny kontrakt PRNG z rzeczywistym układem słów i licznikiem; skonsumować odbiór T02.1 dopiero po otrzymaniu jego zewnętrznych pinów.

- B20.Prng.init56_refines : ∀ state56, source init = specified state followed by initial refill
- B20.Prng.refill4096_refines : ∀ legal state, source output/state = block specification and counter update
- B20.Prng.counter_frame : modification set,counter wrap and repeat conditions
- B20.Prng.block_input_identity : dokładny warunek równości wejść block primitive

To kontrakty planowanych eksportów,nie gotowe twierdzenia. Zapisz podczas pracy
GOAL_SPEC.md/.json oraz dokładne drukowane typy Lean i definicje domen. Typy mają
realizować powyższy cel bez osłabienia; każdą zmianę zakresu zgłoś prowadzącemu.
Wymagana jest pełna formalna instancja dla pinned modelu,nie samo generic lemma.

## 4. Obowiązki źródłowe i matematyczne

- Przypnij frng.c,typy i przekazany T02.1; zgłoszona gotowość bez REPORT/OUTPUTS/review pins daje BLOCKED_INPUTS.
- Udowodnij literalne lanes,XOR,round order,rotations,feed-forward i serialization,łącznie z initial refill.
- Zidentyfikuj i formalnie policz wszystkie block evaluations na refill. Counter modulo2^64,przepełnienie i modyfikowane pola są częścią tezy.
- Nie zastępuj XOR-lane injection standardowym nonce/counter concatenation. Collision/injectivity theorem musi odnosić się do faktycznego input tuple.
- Pokaż actual source instancję generic BitVec lemmas oraz preservation pozostałych pól/pamięci.

## 5. Kontrole i próby ujemne

- Known fixed inputs,two refills,near-wrap i XOR-versus-add mutation.
- Mutacje lane/endianness/feed-forward oraz pominięcie initial refill.
- C harness i formal theorem na tych samych publicznych fixtures.

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

Źródła,próby i handoff zapisujesz w W. Frozen wynik przekazujesz do review.
Po zaakceptowaniu prowadzący importuje odebrany zakres przez archive.py do
stages/catalog/objects i zapisuje lokalny commit na **main** jako niirmataa.
Może przekazać ten krok autorowi/recenzentowi; jeden writer wspólnego CHECKOUT.
Wystarczy commit odebranej pary. Nie ma obowiązkowych checkpointów pośrednich,
osobnej gałęzi/worktree ani importu nieodebranego postępu do stages.

Allowlist po odbiorze: `proofs/ft1536/stages/B20_001_V03_FINAL_*/`,odpowiadające catalog JSON
oraz wyłącznie objects/<sha> wymienione przez te katalogi. Nie commituj
cudzego stage,globalnych indeksów,produkcji Extra/c,cache/bin/olean/pyc/sekretów.
Sprawdź dokładne staged bytes. Bez automatycznego push,amend/reset/rebase cudzego
stanu lub pomijania hooks. Prowadzący aktualizuje kolejkę i zaakceptowane piny.

Każdy handoff podaje source pins,HEAD,scope,status,proved exports i missing
types. W finalnym handoffie pełne SHA REPORT/OUTPUTS (lub REVIEW/REVIEW_OUTPUTS),
branch/HEAD,komendy i stan jobów. Zakończ własne joby; owner_accepted=false.

## 8. Kryterium i następny consumer

Brak claimu o uniformności init bytes,bezpieczeństwie SHAKE/ChaCha lub równości real PRNG z IID.

PROVED wymaga wszystkich eksportów wymaganych w deklarowanym zastosowaniu,
konkretnych premises,clean kernel proof i source bindingu. W innym razie
PARTIAL_PROOF/BLOCKED/counterexample z dokładnym powodem. Brak obliczenia nie
jest zerowym błędem,a brak źródłowego lematu nie jest założeniem do pominięcia.
Następny consumer i przypięte zależności są w INDEX.json; ten Vxx kończy odbiór P03.

## 9. Twoja niezależna weryfikacja P03

Odbierasz dokładnie P03,nie poprzedni podobny run. Twoje podstawowe pytanie:
**Pełny source refinement i counter/frame,nie tylko zgodność block samples. Odbiór T02.1 nie jest automatycznie kernelizacją nowego twierdzenia.**

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
