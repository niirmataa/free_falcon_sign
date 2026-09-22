# P12 — Formalny scalar IID rejection kernel i fresh unread tail

Autor projektu Niirmata. Pakiet B20_001,2026-09-22. Rola: WYKONAWCA.
ROADMAP_ID=F07 formal debt; T05. TASK_ID=B20_001_P12_SCALAR_IID_KERNEL. Para=V12.

## 1. Identyfikacja i foldery

```text
REPO=/home/footfalcon/free_falcon_sign
SOURCE_BASE=ef62824a10a69962dc8347410ee3f424bfa2b12e
W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P12
IN=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P12/inputs
RUN=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P12/run
OUTPUT_DIR=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P12/output
CHECKPOINTS=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P12/checkpoints
CHECKOUT=/home/footfalcon/free_falcon_sign
BRANCH=main
FINAL_STAGE=B20_001_P12_FINAL_001
INPUT_CONTRACT=/home/footfalcon/free_falcon_sign/proofs/ft1536/batches/B20_001/tasks/P12/INPUT_CONTRACT.json
```

W nowej sesji przeczytaj REPO/AGENTS,START_HERE,STATE i AGENT_GIT_PROTOCOL.md
raz; potem własny TASK,kontrakt wejść i ostatni handoff. PACKAGE.sha256 przypina
ten dokument i kontrakt. Pracujesz w swoim W; Git to istniejący **main** w REPO.
Workflow: work → weryfikacja → zaakceptowane stages → lokalny commit.
W HANDOFF zapisujesz source HEAD; source base/piny są nadal stałe.

## 2. Wejścia i kolejność

Zależności dowodowe Pxx: **P01, P02, P03, P09**. Stałe materiały: **SCALAR, NORMALIZED, LEFT**,
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

Zbudować kompletny kernelowy dowód literalnego scalar sampler law w IID_BUFFER,z definicją zatrzymania,normalizacją i source-domain application.

- B20.Scalar.source_proposal_berexp_law : legal words/history → exact proposal/acceptance weights
- B20.Scalar.stopped_pmf : A>0 → Law(returnY)=wY/A and a.s. return
- B20.Scalar.uniform_acceptance_lower : required domain → A≥1/256
- B20.Scalar.fresh_tail_and_resources : stopped prefix → conditional unread iid tail and proved tail/mean bounds

To kontrakty planowanych eksportów,nie gotowe twierdzenia. Zapisz podczas pracy
GOAL_SPEC.md/.json oraz dokładne drukowane typy Lean i definicje domen. Typy mają
realizować powyższy cel bez osłabienia; każdą zmianę zakresu zgłoś prowadzącemu.
Wymagana jest pełna formalna instancja dla pinned modelu,nie samo generic lemma.

## 4. Obowiązki źródłowe i matematyczne

- Formalize actual table/CDF,Word thresholds,BerExp comparisons,getters and rejection loop.
- Instantiate legal μ/σ/domain from P09/P08 exports; no opaque claim Reach⇒Domain.
- Zdefiniuj finite/infinite tape probability space i stopping time w konkretnej bibliotece formalnej.
- Udowodnij normalizer positivity,geometric summation,a.s. termination i fresh-tail law bez future conditioning.
- Preserve literal floor(-0),signed zero,proposal support i actual counters; ideal Gaussian comparison jest osobnym P13.

## 5. Kontrole i próby ujemne

- CDF boundary,zero/nonzero normalizer,rare acceptance i getter-tail mutations.
- No-op versus meaningful BernExp threshold mutations.
- Formal checker rejects using real seeded tape as IID premise.

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

Allowlist po odbiorze: `proofs/ft1536/stages/B20_001_P12_FINAL_*/`,odpowiadające catalog JSON
oraz wyłącznie objects/<sha> wymienione przez te katalogi. Nie commituj
cudzego stage,globalnych indeksów,produkcji Extra/c,cache/bin/olean/pyc/sekretów.
Sprawdź dokładne staged bytes. Bez automatycznego push,amend/reset/rebase cudzego
stanu lub pomijania hooks. Prowadzący aktualizuje kolejkę i zaakceptowane piny.

Każdy handoff podaje source pins,HEAD,scope,status,proved exports i missing
types. W finalnym handoffie pełne SHA REPORT/OUTPUTS (lub REVIEW/REVIEW_OUTPUTS),
branch/HEAD,komendy i stan jobów. Zakończ własne joby; owner_accepted=false.

## 8. Kryterium i następny consumer

Scalar IID law nie jest real PRNG theorem ani whole Sign kernel.

PROVED wymaga wszystkich eksportów wymaganych w deklarowanym zastosowaniu,
konkretnych premises,clean kernel proof i source bindingu. W innym razie
PARTIAL_PROOF/BLOCKED/counterexample z dokładnym powodem. Brak obliczenia nie
jest zerowym błędem,a brak źródłowego lematu nie jest założeniem do pominięcia.
Następny consumer i przypięte zależności są w INDEX.json; frozen handoff trafia najpierw do V12.

## 9. Artefakty autora

REPORT.md,RESULT.json,CLAIM.md,GOAL_SPEC.md/.json,FORMAL_EXPORTS.json,
ASSUMPTIONS.json,SOURCE_MODEL_BINDING.md,INPUTS.sha256,TOOLCHAIN.txt,
COMMANDS.log,EXECUTION_RECEIPTS.json,SAGE_RUNS.json,CERTIFICATES/ i formal/,
AXIOMS.json,FAILED_ROUTES.md,NEXT_INTERFACE.md,REPLAY.md,SEMANTIC_FILES.json,
OUTPUT_SCOPE.md,OUTPUTS.sha256,HANDOFF.md. Output manifest nie obejmuje siebie.
W FORMAL_EXPORTS:pełny typ,nazwa,plik/source SHA,proof term/axioms receipt,
status i konkretni consumers. Części zamknięte i otwarte są oddzielone.
Po compile/replay nie zmieniaj kodu bez nowego runu i receiptu.
