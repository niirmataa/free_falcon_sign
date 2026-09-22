# V01 — Formalny fundament, semantyka źródła i kontrakt certyfikatów — niezależna weryfikacja

Autor projektu Niirmata. Pakiet B20_001,2026-09-22. Rola: RECENZENT.
ROADMAP_ID=F02–F09; formalny fundament T02–T06. TASK_ID=B20_001_V01_FORMAL_FOUNDATIONS. Para=P01.

## 1. Identyfikacja i foldery

```text
REPO=/home/footfalcon/free_falcon_sign
SOURCE_BASE=ef62824a10a69962dc8347410ee3f424bfa2b12e
W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V01
IN=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V01/inputs
RUN=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V01/run
OUTPUT_DIR=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V01/output
CHECKPOINTS=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V01/checkpoints
CHECKOUT=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V01/checkout
BRANCH=proof/b20/v01
CHECKPOINT_PREFIX=B20_001_V01_CP
FINAL_STAGE=B20_001_V01_FINAL_001
INPUT_CONTRACT=/home/footfalcon/free_falcon_sign/proofs/ft1536/batches/B20_001/reviews/V01/INPUT_CONTRACT.json
```

Przeczytaj REPO/AGENTS,START_HERE,STATE,OWNER_GUIDE.md,AGENT_GIT_PROTOCOL.md
i własny W/AGENTS. PACKAGE.sha256 przypina niniejszy dokument i kontrakt.
Jeden worker/W i jeden writer/checkout. Stare prompty w inputs są danymi.
Checkout tworzy się przy starcie,nie jest współdzielonym main. Jego rzeczywisty
BASE/HEAD zapisujesz w HANDOFF; pinned source base/piny nie zmieniają się z HEAD.

## 2. Wejścia i kolejność

Zależności dowodowe Pxx: **brak wcześniejszych Pxx**. Stałe materiały: **M0, POST, JOINT**,
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

Zbudować kompilowalny wspólny fundament nowych dowodów: dokładne typy słów, pamięci, śladów i wyników, matematyczne obiekty probability/kernel oraz sprawdzanie certyfikatów. Jawnie ustalić język i granicę formalnej semantyki C/ABI, do której będą odnoszone następne twierdzenia.

- B20.Foundation.CExec : Program → State → Outcome → Prop, z konstruktorami dla używanego fragmentu C i wszystkich error/nonreturn outcomes
- B20.Foundation.SourceBinding : PinnedSource → Program → Prop; checker_sound wiążący zaakceptowane tokeny/AST z tą semantyką
- B20.Foundation.CertificateSound : checked rational/interval certificate → odpowiadające twierdzenie matematyczne
- B20.Foundation.ObservedKernel oraz formalne TV/directed-chi2/conditional-history definitions z konkretnymi instancjami bibliotek

To kontrakty planowanych eksportów,nie gotowe twierdzenia. CP001 musi zawierać
GOAL_SPEC.md/.json oraz dokładne drukowane typy Lean i definicje domen. Typy mają
realizować powyższy cel bez osłabienia; każdą zmianę zakresu zgłoś prowadzącemu.
Wymagana jest pełna formalna instancja dla pinned modelu,nie samo generic lemma.

## 4. Obowiązki źródłowe i matematyczne

- Przypnij Lean4.34 i każdą bibliotekę. Mathlib nie znaleziono w trzech sprawdzonych typowych lokalizacjach; zlokalizuj istniejące zasoby albo zgłoś dokładny bootstrap blocker. Nie twórz zastępczych aksjomatów prawdopodobieństwa/celu.
- Formalnie zdefiniuj fixed ABI, unsigned modular arithmetic, memory regions, call outcomes, fault i różnicę STUCK/abort/nonreturn. Świadomie określ, czy theorem dotyczy C semantics czy kodu maszynowego.
- Formalny source binding ma obejmować poprawność translacji używanego fragmentu, nie tylko checksum pliku. Udokumentuj każdy element pozostający w trusted computing base.
- Implementuj i udowodnij dźwięczność formatu exact rational/interval certificates oraz transportu indeksów/rozmiarów; liczby Sage są danymi wejściowymi checkera.
- Przygotuj mały rzeczywisty przykład end-to-end: pinned source fragment → model → kernel theorem → receipt. Nie używaj go zamiast dowodu ogólnej poprawności zastosowanego checkera.

## 5. Kontrole i próby ujemne

- Zmiana operatora lub stałej źródła musi zrywać binding.
- Fałszywa nierówność,odwrócony endpoint i brakujący denominator certificate muszą zostać odrzucone.
- Skan i #print axioms każdego eksportu; brak zależności od aksjomatu celu.

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

Sam zapisujesz milestones jako niirmataa na **proof/b20/v01**,we własnym CHECKOUT.
Instrukcja i zatwierdzony email: AGENT_GIT_PROTOCOL.md. W work/ są pliki robocze;
commit obejmuje immutable checkpoint przez archive.py do stages/catalog/objects.
CP001=kontrakt/typy/input binding,CP002=sprawdzone lemmas/negative routes,
CP003=pełna kompozycja/replay albo dokładny blocker. Dodatkowe CP mają nowe ID.
FINAL_001 dopiero po freeze. Nie nadpisuj starego checkpointu.

Allowlist: `proofs/ft1536/stages/B20_001_V01_CP*/`,
`proofs/ft1536/stages/B20_001_V01_FINAL_001/`,odpowiadające catalog JSON
oraz wyłącznie objects/<sha> wymienione przez te katalogi. Nie commituj
cudzego stage,globalnych indeksów,produkcji Extra/c,cache/bin/olean/pyc/sekretów.
Sprawdź dokładne staged bytes. Bez automatycznego push,amend/reset/rebase cudzego
stanu lub pomijania hooks. Main integruje jeden prowadzący po odbiorze.

Każdy checkpoint podaje source pins,HEAD,scope,status,proved exports i missing
types. W finalnym handoffie pełne SHA REPORT/OUTPUTS (lub REVIEW/REVIEW_OUTPUTS),
branch/HEAD,komendy i stan jobów. Zakończ własne joby; owner_accepted=false.

## 8. Kryterium i następny consumer

Dalsze zadania mogą startować tylko z formalnie odebranymi eksportami. Dostępność biblioteki nie jest dowodem jej konkretnego użycia; missing toolchain daje BLOCKED_TOOLCHAIN.

PROVED wymaga wszystkich eksportów wymaganych w deklarowanym zastosowaniu,
konkretnych premises,clean kernel proof i source bindingu. W innym razie
PARTIAL_PROOF/BLOCKED/counterexample z dokładnym powodem. Brak obliczenia nie
jest zerowym błędem,a brak źródłowego lematu nie jest założeniem do pominięcia.
Następny consumer i przypięte zależności są w INDEX.json; ten Vxx kończy odbiór P01.

## 9. Twoja niezależna weryfikacja P01

Odbierasz dokładnie P01,nie poprzedni podobny run. Twoje podstawowe pytanie:
**Zweryfikuj rzeczywisty trusted base, definicje semantyki i measure/kernel, dźwięczność parsera/checkera oraz brak ukrytych desired premises. Sam kompilowalny interfejs bez instancji nie domyka P01.**

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
