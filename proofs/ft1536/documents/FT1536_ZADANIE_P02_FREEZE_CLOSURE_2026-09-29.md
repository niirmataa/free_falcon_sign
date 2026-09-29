# P02 — uzupełnienie istniejącego freezu przed niezależnym V02

2026-09-29. Projekt Niirmata; zachowaj atrybucję Falcon Project / Thomas
Pornin i licencje. Decyzja właściciela po wskazaniu gotowego P02 w work
i stop-and-report: **„Przygotuj uzupełnienie (Recommended)”**.

## 1. Tożsamość i cel

```text
TASK_ID=FT1536_P02_FREEZE_CLOSURE_RUN_001
PARENT_TASK_ID=B20_001_P02_WORD_FPEMU_REFINEMENT
ROADMAP_ID=F03–F06 / B20/P02; consumer T03-B/P02_ARITH
REPO=/media/footfalcon/FT1536_DATA/free_falcon_sign
W=REPO/proofs/ft1536/work/FT1536_P02_FREEZE_CLOSURE_RUN_001
IN=W/inputs/bootstrap
RUN=W/run
OUTPUT_DIR=W/output
PRIOR_W=REPO/proofs/ft1536/work/B20_001/P02
BASE=dda4a2a3ec4854e438914a16110cd6ed4cd2f927
BRANCH=main
CHECKOUT=REPO
CHECKPOINT_PREFIX=B20_001_P02_FINAL_
FINAL_STAGE=B20_001_P02_FINAL_001
VERIFIER_ID=B20_001_V02_WORD_FPEMU_REFINEMENT
STATUS=PREPARED_OWNER_START
```

Jeden wykonawca wybrany i ręcznie uruchomiony przez właściciela. Koordynator
przygotował wejścia,nie uruchomił wykonawcy. Sprawdź ownership i procesy,
zapisz model/kontekst/session ID w HANDOFF. Czytaj AGENTS,START_HERE,STATE,
CURRENT_P02_TASK,własne W/AGENTS i ten TASK;potem potrzebne materiały.

**Celem jest kompletny,przenośny i przypięty pakiet istniejącego P02 do V02.**
P02 ma COMPLETE_FOR_REVIEW/PARTIAL_PROOF od2026-09-25. Wynik obejmuje LE64,
literalne wykonania skalarnych prymitywów z domenami i interfejsy shift;
add/mul/div/sqrt real contracts pozostają otwarte. Ten suplement rozlicza
odtwarzalność i proweniencję istniejącego wyniku. Nowa matematyka add/sub
została odłożona do odebrania faktycznego scope P02.

## 2. Piny i gotowy bootstrap

Oryginalne output68/68 sprawdzono:

- REPORT_SHA256=`98ea050bfe15b39b4ad2a6d26428bcd7e12f22ca33b06b6bc98e9e964bb295a5`
- OUTPUTS_SHA256=`4e8942ccaf46f0971688a0f0cc1d07c5831a46175e6ad2dde903c9f55b046a01`
- P02 TASK=`9954a8b1b2a73a4f3e475ab45bb7bfe8b9a646b109a8989659a61aa933e5ef1f`
- V02 TASK=`cfd4d2eb1e4806a6772b6013ad34a6d9d086b906a4bf9cd96f81dc1e0fa4a382`
- Source17=`56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`
- BOUND_INPUTS=`567f57ac135d0c766f95dfbc53b5dfedcd9d4eb15993d78ab896d4bead936278`
- P02 input materialization=`d70316d8450015aba6980a8c521f9979046b1983e6d6dcef5400f864abeef03b`

Nowy bootstrap: **8700 członków /359332583 bajty**,MANIFEST SHA-256:
`088b407a3be937a49b1a23d4305e83641123d9770040d78b4a43b7cabe14c65f`.
MANIFEST i ORIGINS nie są członkami listy. Sprawdź exact set/hashe/no symlinks.

- `prior/output/`: byte-identical oryginalny freeze68+manifest;
- `prior/inputs/`: pełne7371 wejść i MATERIALIZED,source17/P01/LEFT/POST/
  NORMALIZED z istniejącymi pinami i scope;
- `prior/run/<id>/`:9 indeksowanych receiptów,ich source snapshots,
  runner snapshots,288 raw step logs i tekstowe produkty (łącznie144 kroki
  z zapisanym exit0;to odczyt historycznych receiptów,nie nowy replay);
- `prior/current_audits/`: obecne AuditExports/AuditTerms do porównania
  z historycznymi snapshotami. Ich obecność nie ustala automatycznie wersji
  użytej w danym runie — rozstrzyga jego source_before;
- `context/`: decyzja właściciela,PRECHECK,P02/V02 TASK/protokoły oraz
  zakresowo odebrana recenzja T03-B z diagnozą dispatcherów.

Materiały `prior/run` zostały przypięte TERAZ do nowego zadania.
Nie twierdź,że były członkami starego OUTPUTS. `PRIOR_W` jest RO;jeśli
potrzebujesz niewłączonego historycznego failed runu,wybierz dokładne pliki,
przypnij kopię w swoim W i zapisz pochodzenie. Nie wykonuj starych jobów w miejscu.

## 3. Stwierdzone braki freezu do rozliczenia

F1. `REPLAY.md` wywołuje `PRIOR_W/run/job.py`;runner nie należy do OUTPUTS.
Ma też zależność od layoutu `W.parents[4]` i żywego `W/src`.

F2. `formal/BUILD_PLAN.json` zawiera34 moduły. W OUTPUTS są32;
`AuditExports.lean` i `AuditTerms.lean` są poza manifestem. Oba istnieją
w src i source snapshots;trzeba związać właściwe wersje z rzeczywistymi logami.

F3. EXECUTION_RECEIPTS indeksuje9 receiptów;żaden z nich ani jego raw logs
nie należy do OUTPUTS. OUTPUT_SCOPE jawnie wyłączył run/. Potrzebna pełna
evidence deklarowanych wykonań i zachowanych failed attempts.

F4. HANDOFF mówi „HEAD przy freeze w OUTPUTS/REPLAY”,ale nie podaje tam
konkretnego końcowego HEAD. Zachowaj SOURCE_BASE,historyczne start/snapshot
HEAD i nie podmieniaj ich na zmyślony final HEAD. Dla NOWEGO pakietu zapisz
rzeczywisty HEAD kontekstu przygotowania i jego czas,obok source pins.
Oryginalny final HEAD może pozostać „nieudokumentowany”,jeśli brak świadectwa.

To nie matematyczny werdykt V02. Oryginalny freeze zachowuje68 zgodnych plików
i rzeczywisty PARTIAL;naprawa ma powstać w nowym OUTPUT_DIR.

## 4. Wykonaj jeden spójny suplement

### S1 — rekonstrukcja dowodów wykonania

Powiąż każdy deklarowany wynik ze źródłem,rzeczywistym argv/wersją/cwd,
exit/stdout/stderr i produktem. Porównaj32 sealed proof modules z odpowiednimi
historycznymi source snapshots. Rozlicz dwa audit modules,ProbeFreezeScan
oraz generowane typy/aksjomaty;przy różnicach zachowaj obie wersje i pokaż
który receipt dotyczy której. Nie wyrównuj hashy edycją historii.

Uzupełnij evidence również o potrzebne child C command logs i Sage source/
receipt/output bindings. Każdy reklamowany42/42,ASan,mutacja lub audit ma
mieć kompletne wskazanie producenta. Puste stderr to plik0B z hashem.

### S2 — portable replay i input/library closure

Zbuduj przenośne wejście replayu,przypięte w nowym OUTPUTS. Korzysta z
NOWEGO pakietu i manifestowanej closure,a nie żywego PRIOR_W/src/run.
Własne poprawki organizacyjne runnera mają diff/proweniencję. Model C,
formalny scope i source17 nie zmieniają się przez poprawkę ścieżek.

Obsłuż pełny BUILD_PLAN z rzeczywistymi producentami audytów. Przed
tworzeniem absent DEST sprawdź external OUTPUTS pin,wszystkie potrzebne
input pins i zakaz symlink/path escape. Rozdziel źródła RO od generowanych
produktów RW;generatory nie zapisują do pinned snapshotu. HOME/TMP/cache
pod trwałym W. Przy nested bwrap zapewnij właściwe /proc i /dev — patrz
odebrane doświadczenie T03-B,z zachowaniem RO source i W-only zapisów.

P01 Mathlib/library cache można reuse wyłącznie po pin-byte/toolchain
verification;własne proof modules są rebuildowane świeżo. Pełna closure
źródeł i manifestów bibliotek może pozostać zewnętrzną przypiętą RO zależnością,
z odtwarzalnym opisem jej materializacji. Nie utożsamiaj hashy cache z nowym
dowodem jego poprawności. Wypisz wszystkie runtime/layout requirements.

### S3 — własny fresh replay i freeze

Zdefiniuj semantic plan przed replayem. Wykonaj jeden pełny świeży replay
gotowego pakietu z nowym DEST. Kontrole normal/Sage/Lean/audity i każdy
deklarowany semantic match mają realnego producenta,exit i porównanie hashy.
Przebuduj także odziedziczone własne dependencies używane przez eksporty.
Sanitizer claims powiąż z istniejącymi complete receipts;powtórz je,jeżeli
zmiana harnessu/źródła/domeny wymaga nowego wyniku. Nie wykonuj ponownie
historycznych failed routes jedynie w celu odtworzenia dawnych błędów.

Aktualizuj opisy do rzeczywistego replayu. Ten krok nie wydaje niezależnego
PASS matematycznego — finalny pakiet trafia do V02.

## 5. Zakres formalny pozostaje jawny

Szczególnie ważne dla V02:

- literal-BitVec rint/floor nie są jeszcze pełnym real-valued theorem;
- frozen `shiftCalls` ma wyłącznie3 shift callees,więc stare
  `AddCallObligation` z tym dispatcherem nie jest wykonaniem fpr_add;
- conditional sub należy opisać bez pozorowania dostępnej instancji
  arytmetyki — T03 review wskazał dokładny brak;
- raw−0 floor impl→−1 i jawna domena pozostają w rzeczywistym scope;
- partial add/mul/div/sqrt i C→machine/full frontend pozostają OPEN;
- P01 może być użyty tylko w odebranym wąskim zakresie V01;
- `owner_accepted=false`,source_changed=false,brak integracji produkcyjnej.

Jeśli kompletowanie evidence ujawni błąd merytoryczny,opisz go i zatrzymaj
awans odpowiedniego claimu. Nie naprawiaj matematyki zmianą etykiety lub
nową przesłanką równoważną celowi. Nowe źródła dowodowe wymagają własnego
rebuild/audytu oraz jawnego rozszerzenia zakresu.

## 6. Artefakty i właściwe ID pakietu

W `W/output/` przygotuj samowystarczalny successor starego output/:
REPORT.md,RESULT.json,CLAIM,GOAL_SPEC,FORMAL_EXPORTS,AXIOMS,ASSUMPTIONS,
SOURCE_MODEL_BINDING,NEXT_INTERFACE,OUTPUT_SCOPE,INPUTS,TOOLCHAIN,
COMMANDS.log,EXECUTION_RECEIPTS,SAGE_RUNS,REPLAY,SEMANTIC_FILES,
OUTPUTS.sha256,HANDOFF.md,źródła/config/replay runner,evidence i failed history.
Dodaj `FREEZE_CLOSURE.md/.json`: F1–F4 → konkretne pliki/piny i stan rozliczenia.

**RESULT.task_id pozostaje `B20_001_P02_WORD_FPEMU_REFINEMENT`**,para=V02.
Dodaj `packaging_task_id=FT1536_P02_FREEZE_CLOSURE_RUN_001`,revision=v2,
predecessor_REPORT/OUTPUTS pins,source_base i rzeczywisty new package HEAD.
Także main status pozostaje PARTIAL_PROOF,chyba że właściciel osobno zleci
i niezależny review odbierze dodatkową matematykę. `COMPLETE_FOR_REVIEW`
opisuje gotowość przekazania,nie zamknięcie wszystkich primitive goals.

W INPUTS używaj rozwiązywalnych ścieżek względem pakietu lub jawnych
hash-zgodnych origin mappings. Wszystko potrzebne do replayu i każda
cytowana evidence musi być sealed bez self-hash cycles. Można deduplikować
identyczne tekstowe snapshoty content-addressed,z pełną mapą oryginalnych
ścieżek. Bin/olean/pyc/cache/sekrety nie należą do commita.

Oddaj **pełne zewnętrzne SHA REPORT/OUTPUTS,HEAD**,stan jobów i krótkie
podsumowanie po polsku:co uzupełniono,czego nie dało się odzyskać,rzeczywisty
scope P02 i gotowość V02. Zakończ własne joby. Po freeze nie zmieniaj bajtów.

## 7. Środowisko i workflow

Lean4.34.0 + Mathlib@5ed2965256430c3649e86755f9576b54eca72435,Sage10.9
przez `sage nazwa.sage`,preparser,ZZ/QQ/rigorous intervals. Bez sorry/admit/
native_decide/Lean.ofReduceBool/aksjomatu celu/warning suppression.
Normal8GiB,Lean-j1/-M2048,wall1800s/krok,jeden worker;ASan osobno ze
zdefiniowanym shadow/RSS policy. Źródła i biblioteki RO,sieć off.
Wszystkie nowe źródła,HOME/TMPDIR/cache/logi pod własnym W;bez systemowego
tmp/tmpfs. Bez Git/push,subagentów/relay/uruchamiania innych modeli,
KeyGen/private loadera/pełnego Sign lub nowych sekretów.

Po handoffie koordynator wiąże nowy P02 przez `b20_status_set.py`,generuje
prompt V02 i przygotowuje inputs recenzenta. Właściciel startuje inny model
w świeżym kontekście. Po scoped odbiorze:work → review → zaakceptowane stages
→ lokalny commit main jako niirmataa. B20 STATUS/PACKAGE nie edytuje wykonawca.
