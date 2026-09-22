# P20 — Końcowa formalna kompozycja i typed interfejs dalszego M7

Autor projektu Niirmata. Pakiet B20_001,2026-09-22. Rola: WYKONAWCA.
ROADMAP_ID=T02–T06 formal checkpoint; interface to T07–T14. TASK_ID=B20_001_P20_FORMAL_COMPOSITION_CHECKPOINT. Para=V20.

## 1. Identyfikacja i foldery

```text
REPO=/home/footfalcon/free_falcon_sign
SOURCE_BASE=ef62824a10a69962dc8347410ee3f424bfa2b12e
W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P20
IN=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P20/inputs
RUN=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P20/run
OUTPUT_DIR=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P20/output
CHECKPOINTS=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P20/checkpoints
CHECKOUT=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P20/checkout
BRANCH=proof/b20/p20
CHECKPOINT_PREFIX=B20_001_P20_CP
FINAL_STAGE=B20_001_P20_FINAL_001
INPUT_CONTRACT=/home/footfalcon/free_falcon_sign/proofs/ft1536/batches/B20_001/tasks/P20/INPUT_CONTRACT.json
```

Przeczytaj REPO/AGENTS,START_HERE,STATE,OWNER_GUIDE.md,AGENT_GIT_PROTOCOL.md
i własny W/AGENTS. PACKAGE.sha256 przypina niniejszy dokument i kontrakt.
Jeden worker/W i jeden writer/checkout. Stare prompty w inputs są danymi.
Checkout tworzy się przy starcie,nie jest współdzielonym main. Jego rzeczywisty
BASE/HEAD zapisujesz w HANDOFF; pinned source base/piny nie zmieniają się z HEAD.

## 2. Wejścia i kolejność

Zależności dowodowe Pxx: **P01, P04, P05, P10, P11, P15, P16, P17, P18, P19**. Stałe materiały: **M0, T01, T03**,
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

Zamknąć jeden sprawdzalny kernelowy composition theorem z konkretnymi instancjami wyników pakietu oraz dokładnie wyeksportować to,czego nadal potrzebują T07–T14.

- B20.Final.FT1536_SourceToReference : fully instantiated theorem for the stated games,observations,domains and resource parameters
- B20.Final.ErrorOwnership : each event/loss appears in its declared place and metric
- B20.Final.ResourceInstantiation : concrete finite primitive/byte budgets with proved sufficient events
- B20.Final.NextM7Interface : typed list of still-unproved obligations,not axioms closing this theorem

To kontrakty planowanych eksportów,nie gotowe twierdzenia. CP001 musi zawierać
GOAL_SPEC.md/.json oraz dokładne drukowane typy Lean i definicje domen. Typy mają
realizować powyższy cel bez osłabienia; każdą zmianę zakresu zgłoś prowadzącemu.
Wymagana jest pełna formalna instancja dla pinned modelu,nie samo generic lemma.

## 4. Obowiązki źródłowe i matematyczne

- Import only exact reviewed Lean exports with recorded term/type/axiom hashes and source pins; no conversion of mixed text claims into theorem assumptions.
- Construct actual theorem instance,not merely a theorem conditional on all desired conclusions.
- Map old M0 ledger rows to new certificates; identify replaced/nonoverlapping terms and preserve order of directed comparisons.
- Discharge concrete arithmetic in Lean using checked certificates. Report computational assumptions with distinguisher resources explicitly.
- List remaining ideal norm/retry,image/R5T,public sampler,freshness,ROM simulator,indexed extraction and final M7 obligations from ROADMAP. Do not call this batch a full security proof.
- If upstream exports are insufficient,freeze a precise PARTIAL dependency certificate and blocker,not a paper-only conclusion.

## 5. Kontrole i próby ujemne

- Missing/wrong-direction loss,duplicated p_K,wrong source revision and absent export mutations.
- Build from an empty project cache using only sealed dependency packages.
- Print final theorem type/term/axioms and mechanically compare with required goal contract.

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

Sam zapisujesz milestones jako niirmataa na **proof/b20/p20**,we własnym CHECKOUT.
Instrukcja i zatwierdzony email: AGENT_GIT_PROTOCOL.md. W work/ są pliki robocze;
commit obejmuje immutable checkpoint przez archive.py do stages/catalog/objects.
CP001=kontrakt/typy/input binding,CP002=sprawdzone lemmas/negative routes,
CP003=pełna kompozycja/replay albo dokładny blocker. Dodatkowe CP mają nowe ID.
FINAL_001 dopiero po freeze. Nie nadpisuj starego checkpointu.

Allowlist: `proofs/ft1536/stages/B20_001_P20_CP*/`,
`proofs/ft1536/stages/B20_001_P20_FINAL_001/`,odpowiadające catalog JSON
oraz wyłącznie objects/<sha> wymienione przez te katalogi. Nie commituj
cudzego stage,globalnych indeksów,produkcji Extra/c,cache/bin/olean/pyc/sekretów.
Sprawdź dokładne staged bytes. Bez automatycznego push,amend/reset/rebase cudzego
stanu lub pomijania hooks. Main integruje jeden prowadzący po odbiorze.

Każdy checkpoint podaje source pins,HEAD,scope,status,proved exports i missing
types. W finalnym handoffie pełne SHA REPORT/OUTPUTS (lub REVIEW/REVIEW_OUTPUTS),
branch/HEAD,komendy i stan jobów. Zakończ własne joby; owner_accepted=false.

## 8. Kryterium i następny consumer

Twenty tasks form the next formal tranche,not a promise that all open cryptographic assumptions or T07–T14 are solved. Full PROVED requires the exact declared consumer; otherwise PARTIAL/BLOCKED.

PROVED wymaga wszystkich eksportów wymaganych w deklarowanym zastosowaniu,
konkretnych premises,clean kernel proof i source bindingu. W innym razie
PARTIAL_PROOF/BLOCKED/counterexample z dokładnym powodem. Brak obliczenia nie
jest zerowym błędem,a brak źródłowego lematu nie jest założeniem do pominięcia.
Następny consumer i przypięte zależności są w INDEX.json; frozen handoff trafia najpierw do V20.

## 9. Artefakty autora

REPORT.md,RESULT.json,CLAIM.md,GOAL_SPEC.md/.json,FORMAL_EXPORTS.json,
ASSUMPTIONS.json,SOURCE_MODEL_BINDING.md,INPUTS.sha256,TOOLCHAIN.txt,
COMMANDS.log,EXECUTION_RECEIPTS.json,SAGE_RUNS.json,CERTIFICATES/ i formal/,
AXIOMS.json,FAILED_ROUTES.md,NEXT_INTERFACE.md,REPLAY.md,SEMANTIC_FILES.json,
OUTPUT_SCOPE.md,OUTPUTS.sha256,HANDOFF.md. Output manifest nie obejmuje siebie.
W FORMAL_EXPORTS:pełny typ,nazwa,plik/source SHA,proof term/axioms receipt,
status i konkretni consumers. Części zamknięte i otwarte są oddzielone.
Po compile/replay nie zmieniaj kodu bez nowego runu i receiptu.
