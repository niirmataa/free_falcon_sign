# P19 — Pełne history-dependent observed byte kernels jednego Sign call

Autor projektu Niirmata. Pakiet B20_001,2026-09-22. Rola: WYKONAWCA.
ROADMAP_ID=T06. TASK_ID=B20_001_P19_COMPLETE_OBSERVED_KERNELS. Para=V19.

## 1. Identyfikacja i foldery

```text
REPO=/home/footfalcon/free_falcon_sign
SOURCE_BASE=ef62824a10a69962dc8347410ee3f424bfa2b12e
W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P19
IN=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P19/inputs
RUN=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P19/run
OUTPUT_DIR=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P19/output
CHECKPOINTS=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P19/checkpoints
CHECKOUT=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P19/checkout
BRANCH=proof/b20/p19
CHECKPOINT_PREFIX=B20_001_P19_CP
FINAL_STAGE=B20_001_P19_FINAL_001
INPUT_CONTRACT=/home/footfalcon/free_falcon_sign/proofs/ft1536/batches/B20_001/tasks/P19/INPUT_CONTRACT.json
```

Przeczytaj REPO/AGENTS,START_HERE,STATE,OWNER_GUIDE.md,AGENT_GIT_PROTOCOL.md
i własny W/AGENTS. PACKAGE.sha256 przypina niniejszy dokument i kontrakt.
Jeden worker/W i jeden writer/checkout. Stare prompty w inputs są danymi.
Checkout tworzy się przy starcie,nie jest współdzielonym main. Jego rzeczywisty
BASE/HEAD zapisujesz w HANDOFF; pinned source base/piny nie zmieniają się z HEAD.

## 2. Wejścia i kolejność

Zależności dowodowe Pxx: **P01, P05, P10, P11, P15, P16, P17, P18**. Stałe materiały: **M0, T01, T03, POST**,
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

Zdefiniować i formalnie powiązać complete source/IID/reference kernels z nonce,bytes,abort i nonreturn outcomes dla rzeczywistego API i cap16.

- B20.Observed.SourceSignKernel,IidSignKernel,ReferenceSignKernel : complete observation kernels
- B20.Observed.source_program_refines_kernel : actual API semantics → defined kernel
- B20.Observed.iid_reference_transport : stated metric/direction and all derived losses
- B20.Observed.real_reference_advantage : resource-bounded computational composition with P05

To kontrakty planowanych eksportów,nie gotowe twierdzenia. CP001 musi zawierać
GOAL_SPEC.md/.json oraz dokładne drukowane typy Lean i definicje domen. Typy mają
realizować powyższy cel bez osłabienia; każdą zmianę zakresu zgłoś prowadzącemu.
Wymagana jest pełna formalna instancja dla pinned modelu,nie samo generic lemma.

## 4. Obowiązki źródłowe i matematyczne

- One shared K_seed[E],same public service plan,message/nonce/table and all source outcomes; KeyGen conditioning/p_K accounted once.
- Combine prefix/retry/post/codec through exact state interfaces,not only successful final signatures.
- Keep mass of PRE_ABORT,POST_ABORT,nonreturn and reference exits; no post-sign Verify filter added to source.
- Statistical IID losses and computational real-RNG assumptions have separate formal types. Do not claim TV(real,IID) from a PRG assumption.
- Instantiate every needed recovery/geometry/centering bound. An unresolved value is not zero and prevents the concrete full claim.

## 5. Kontrole i próby ujemne

- Drop abort mass,double-count or renormalize success,discard invalid positive output,wrong nonce/history mutations.
- Finite toy kernels check complete mass and observation projection.
- Fresh source-kernel replay and kernel exports are both required.

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

Sam zapisujesz milestones jako niirmataa na **proof/b20/p19**,we własnym CHECKOUT.
Instrukcja i zatwierdzony email: AGENT_GIT_PROTOCOL.md. W work/ są pliki robocze;
commit obejmuje immutable checkpoint przez archive.py do stages/catalog/objects.
CP001=kontrakt/typy/input binding,CP002=sprawdzone lemmas/negative routes,
CP003=pełna kompozycja/replay albo dokładny blocker. Dodatkowe CP mają nowe ID.
FINAL_001 dopiero po freeze. Nie nadpisuj starego checkpointu.

Allowlist: `proofs/ft1536/stages/B20_001_P19_CP*/`,
`proofs/ft1536/stages/B20_001_P19_FINAL_001/`,odpowiadające catalog JSON
oraz wyłącznie objects/<sha> wymienione przez te katalogi. Nie commituj
cudzego stage,globalnych indeksów,produkcji Extra/c,cache/bin/olean/pyc/sekretów.
Sprawdź dokładne staged bytes. Bez automatycznego push,amend/reset/rebase cudzego
stanu lub pomijania hooks. Main integruje jeden prowadzący po odbiorze.

Każdy checkpoint podaje source pins,HEAD,scope,status,proved exports i missing
types. W finalnym handoffie pełne SHA REPORT/OUTPUTS (lub REVIEW/REVIEW_OUTPUTS),
branch/HEAD,komendy i stan jobów. Zakończ własne joby; owner_accepted=false.

## 8. Kryterium i następny consumer

First target is explicitly SourceSign in the M0 direct-output ROM; real public bit-XOF/H2P requires S04. Full EUF-CMA/M7 is not claimed.

PROVED wymaga wszystkich eksportów wymaganych w deklarowanym zastosowaniu,
konkretnych premises,clean kernel proof i source bindingu. W innym razie
PARTIAL_PROOF/BLOCKED/counterexample z dokładnym powodem. Brak obliczenia nie
jest zerowym błędem,a brak źródłowego lematu nie jest założeniem do pominięcia.
Następny consumer i przypięte zależności są w INDEX.json; frozen handoff trafia najpierw do V19.

## 9. Artefakty autora

REPORT.md,RESULT.json,CLAIM.md,GOAL_SPEC.md/.json,FORMAL_EXPORTS.json,
ASSUMPTIONS.json,SOURCE_MODEL_BINDING.md,INPUTS.sha256,TOOLCHAIN.txt,
COMMANDS.log,EXECUTION_RECEIPTS.json,SAGE_RUNS.json,CERTIFICATES/ i formal/,
AXIOMS.json,FAILED_ROUTES.md,NEXT_INTERFACE.md,REPLAY.md,SEMANTIC_FILES.json,
OUTPUT_SCOPE.md,OUTPUTS.sha256,HANDOFF.md. Output manifest nie obejmuje siebie.
W FORMAL_EXPORTS:pełny typ,nazwa,plik/source SHA,proof term/axioms receipt,
status i konkretni consumers. Części zamknięte i otwarte są oddzielone.
Po compile/replay nie zmieniaj kodu bez nowego runu i receiptu.
