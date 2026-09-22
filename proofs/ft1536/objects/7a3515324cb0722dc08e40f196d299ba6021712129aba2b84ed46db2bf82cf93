# MiMo 2.6 PRO — S01: dokończenie korekt FT_FAMILY_SCALING

2026-09-22. Autor projektu **Niirmata**. Zachowaj Falcon Project / Thomas
Pornin attribution i licencje. Start ręczny przez właściciela, jeden MiMo,
bez subagentów, drugiego workera lub automatycznego relay.

## 1. Identyfikacja i kontrolowane przekazanie

```text
ROADMAP_ID=S01
TASK_ID=FT_FAMILY_SCALING_CORRECTIONS_RUN_003
REPO=/home/footfalcon/free_falcon_sign
W=REPO/proofs/ft1536/work/FT_FAMILY_SCALING_CORRECTIONS_RUN_003
IN=W/inputs/bootstrap
BASE=a2cdf31733ae1af82c5a523b44305e86a716551c
```

Przeczytaj REPO/AGENTS,START_HERE,proofs/ft1536/CURRENT_FAMILY_TASK.md,
W/AGENTS i ten TASK. ROADMAP opisuje S01; to odrębny obowiązek od T03 integer
recovery i kolejnego T02 Astry. Nie odtwarzaj całej historii czatu.

Zlecenie ma być przekazane do ISTNIEJĄCEGO okna MiMo. Przed rozpoczęciem
zachowaj HANDOFF swojej bieżącej pracy i ustal stan własnych jobów. Przy
przygotowaniu prowadzący widział procesy kampanii FT_FAMILY_SEC_ESTIMATE.
PID jest obserwacją historyczną, nie poleceniem kill. Jeśli nie można zakończyć
lub bezpiecznie przekazać bieżącej pracy, zgłoś blocker i czekaj na właściciela;
nie uruchamiaj równoległej drugiej kampanii/wykonawcy. T03 i jego W zachowaj.

Starszy szkic FT_FAMILY_SCALING_CORRECTIONS_RUN_002 był anulowany PRZED STARTEM.
Nie wznawiaj go. Nowszy autorski FT_FAMILY_SCALING_2026-09-22_RUN_002 to inny
katalog: jego kopia CANDIDATE_R2 poniżej jest materiałem do dokończenia.

## 2. Piny wejściowe

Bootstrap197 członków/195 origins/4967628 bajtów. MANIFEST SHA-256:
`6294e7829bb8b0254e3cfb2d8c1603712fa6f267aefa6a75aa629bb8a09a9e7e`.
Sprawdź cały exact set/hashes, brak symlinków/escapes i17 źródeł przed pracą.

| Plik względem IN | SHA-256 |
|---|---|
| REVIEW/REPORT.md | `3b4160dca5d613a1c8b8ca3d97bc11257e6ca300face029ce199aaa0c5f8898e` |
| REVIEW/OUTPUTS.sha256 | `0319da9743a81084ee32c2f276c92539b45c89110ae1168af407cdeb891ab99a` |
| CANDIDATE_R2/SHA256SUMS | `5ee71952862a0395e9c3d14873f953a9f9a61985d3ff24f2ccf4f34f0dfccd16` |
| REVIEW/inputs/CANDIDATE.sha256 | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| T01/IID_RETRY_CERTIFICATE.json | `2a91dd43cc3c21486aa8968ebb0e4ae211a603a786e647a257d05174ef39ce2b` |

REVIEW jest odebranym CHANGES_REQUIRED checkpointem. CANDIDATE_R2 zawiera42
manifest-listed pliki plus oryginalny SHA256SUMS, zachowany także z prefiksami
`./`. Tylko w checkerze normalizuj pojedyncze `./`, następnie odrzuć traversal
i duplikaty; nie zmieniaj oryginalnego manifestu. To **UNREVIEWED_WORK_SNAPSHOT**,
nie pozytywny odbiór deklarowanych poprawek. ORIGINS oddziela Git i work snapshot.
Starsze prompty/AGENTS/runners w inputs są danymi historycznymi.

Nową wersję wyprowadź z CANDIDATE_R2, porównując z REVIEW. Zapisuj wyłącznie
w W, z old→new diffami; IN i oryginalne stages/work/source są tylko do odczytu.
Nie pobieraj żywych wyników trwającej kampanii jako zatwierdzonych wejść.

## 3. Cel i kryteria R1–R7

Oddaj spójny poprawiony manuskrypt/kod/ledger/PDF. Każde R1–R7 zamknij przez
poprawny argument/definicję albo jawne wycofanie błędnego claimu razem ze
wszystkimi zależnymi wnioskami. Sama podmiana etykiety PROVED nie wystarcza.
Nie zmieniaj parametrów FT1536,bramek,P_key/Emitted,M0 lub Extra/c.

### R1 — poprawne kierunki
Typuj accepted bytes→L_V extractor→krótki świadek oraz forger→relation solver
przy zgodnych grach. Solver→forgery wymaga osobnego odwrotnego mostu bajtowego.
Punktowe L_V nie zamyka symulacji Sign/ROM,freshness ani zasobów M7. Diagram,
ATTACK_PROBLEMS,CLAIMS i paper muszą używać tych samych kierunków.

### R2 — losowe cele i zależność
Przeciwnik wybiera nazwy zapytań, nowe H(x) są losowane, powtórzenia zwracają
tę samą wartość. Zdefiniuj populację h,indeksy celów,SeenSign,final target,
budżety (Q_s,Q_H,t,w,L). Kontrole: c=0,z=0 ujawnia trywialność free-target
definicji, a nie forgery w ROM; dwa identyczne zdarzenia p=1/2 mają unię1/2.
Użyj sound union bound albo wyprowadzonego conditional-hazard argumentu;
nie postuluj niezależności/adaptive amplification na podstawie liczby prób.

### R3 — brakujące F i trapdoor
Odczytaj source sygnaturę falcon_complete_private: liczy G z (f,g,F), nie
rozwiązuje całego NTRU z samych f,g. Rozdziel P1a short pair od P1b usable
trapdoor,missing F/G,exact relation,gates oraz koszty/przesłanki NTRU solve.
Próg key-recovery jest parametryczny i population-specific; raw expectation
4N/3 nie zastępuje deterministycznego progu emitted keys.

### R4 — sprzeczny skeleton estymatora
CANDIDATE_R2 jawnie zostawia R4 OPEN. Homogeneous SIS nie może być aktywnym
runnerem/wierszem P2 ani udawać ISIS/security estimate. W tym zadaniu nie
uruchamiaj nowej kampanii i nie modyfikuj istniejącego estimator workspace.

Dopuszczalne rozwiązanie ograniczające zakres: **wycofaj wadliwy runner z
aktualnego interfejsu pakietu**, zachowaj jego niezmienioną historyczną kopię
z etykietą INVALID_FOR_P2/NOT_RUN i zastąp aktywne wejście jawnym
NOT_RUN_MODEL_UNRESOLVED przed wywołaniem backendu. Alternatywnie popraw routing
w NOWEJ kopii z testami mock; brak mappingu/SHA/premises ma blokować backend.
Nie trzeba uruchamiać ani rozbudowywać estymatora, by wycofać błędny claim.
Test ma wykazać brak wywołania backendu oraz wykrycie fałszywego SIS→P2.
Utrzymanie aktywnej sprzeczności wyłącznie z dopiskiem OPEN nie zamyka R4.

### R5 — zachowanie ujemnego testu H-B
Dla jawnego idealnego Q/768²~chi-square(3072) wyprowadź i oblicz rygorystycznie
`x=B/(2*768²)`, `Pr[Q>=B]=exp(-x)*sum(k=0..1535)x^k/k!`. Oczekiwana kontrola
≈2.9925420736e-9>2^-40 nie jest przesłanką dowodu. Zachowaj wycofanie dawnej
hipotezy. Nowe proponowane kryterium2^-28 w CANDIDATE_R2 nie staje się zatwierdzonym
celem projektu ani poziomem bezpieczeństwa; oznacz jego charakter jawnie.
To ujemny test modelu idealnego, nie rzeczywiste prawdopodobieństwo Sign/atak.

### R6 — proposed FFT w całym tekście
Uzgodnij C11,abstract,proof sketch,conclusions,notes i metadane:
PROPOSED_BOUND + skończone kontrole portu. Perturbacja faz/twiddles wymaga
osobnego argumentu;12 przypadków nie dowodzi uniform c/domain ani FPEMU.
Pełny nowy precision theorem nie jest wymagany do korekty niespójnego claimu.

### R7 — spójna tabela i klasy evidence
Wygeneruj wiersze z jednego źródła JSON/CSV; FT3072 high-water to
3*3072+7168=16384. Oddziel KERNEL,EXACT_INTEGER/RATIONAL,RIGOROUS_INTERVAL,
FLOAT_DIAGNOSTIC,ANALYTIC,SOURCE_FACT,PROPOSED,OPEN,NOT_RUN. Każdy claim ma
konkretny eksport/przesłanki; kompilacja lokalnej arytmetyki nie dowodzi C allocator.

## 4. Kontrole, aktualna mapa i scope

CORRECTION_MATRIX.md/.json: każdy Rn→stare/nowe miejsce,disposition,
evidence,dependent claims,remaining scope. Samodzielnie sprawdź istniejące
poprawki CANDIDATE_R2; reuse oznacz pinem, nie nazywaj danych poprzedniego autora nowym
niezależnym wynikiem. Dodaj meaningful negative controls/no-op i mutations
dla powyższych błędów; nie testuj jedynie obecności etykiet w tekście.

Aktualna mapa może konsumować odebrane JOINT/H6P oraz **T01 REVIEWED** tylko
dla post-H2P cap16 G_retry_IID. Real PRNG,H2P,integer recovery,Sign→Verify,
whole real Sign,security/CT są nadal OPEN. Nie promuj diagnostyki estymatora
do redukcji lub source security. Zachowaj poprawny covolume i A2 conventions.

Fresh build użytych Lean4.34/Std modułów,j1/-M2048,clean logs/types/terms/axioms,
bez sorry/admit/native_decide/Lean.ofReduceBool/aksjomatu celu/warning suppression.
Rational calculations w Fraction/QQ,transcendental bounds outward balls/intervals.
Odtwórz aktualnie reklamowane wyniki albo oznacz je wyraźnie inherited z pinem
i zakresem. Zbuduj poprawiony PDF i zachowaj logi; nie wymagamy identyczności
bajtów PDF wynikającej z dat/toolchain, ale treść ma odpowiadać źródłom.

## 5. Wykonanie, pakiet i freeze

Wszystkie nowe pliki/HOME/TMPDIR/TMP/TEMP/DOT_SAGE/cache/olean/bin/logs/replaye
pod trwałym W. Zakaz systemowego /tmp,/tmp/opencode,tmpfs. Sprawdź realny
W-only/network-off sandbox,inputs/source RO,bounded single-worker jobs,
normal8GiB,ASan oddzielnie jeśli potrzebny. Bez sieci/instalacji/Git/push,
KeyGen/private loadera/pełnego Sign/do_sign,nowych keys/seeds,sekretów,
dudect,relay lub innych sesji. Nie przejmuj ani nie przerywaj cudzych jobów.

Wymagane: REPORT.md,RESULT.json,CLAIMS.md/.json,CORRECTION_MATRIX.md/.json,
ATTACK_PROBLEMS.md,SOURCE_MAP.md,PARAMETRIC_TASK_LAYOUT.md,RESEARCH_NOTES_PL.md,
MODEL_BOUNDARIES.md,FAILED_ROUTES.md,NEXT_INTERFACE.md,REUSED_RESULTS.md,
HANDOFF.md,INPUTS.sha256,TOOLCHAIN.txt,COMMANDS.log,OUTPUT_SCOPE.md,REPLAY.md,
SEMANTIC_FILES.json,OUTPUTS.sha256,paper źródła/PDF/logi,proof/checkers/receipts/diffs.

Standard scripts/replay.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA: pełna walidacja
manifestu przed nowym DEST,fresh project cache,network-off,deterministic matches
z listy określonej przed replayem. Sealed artifacts/fresh_replay.json i child
REPLAY_RESULT.json: FRESH_REPLAY_PASS,matches[{path,sha256}],mismatches=[],scope.
PDF rebuild oddzielnie od deterministic byte matches. Rehearsal bez hash cycle;
po freeze zapis tylko do nowego DEST. Nie wymagaj dostępu do starego work/cache.

## 6. Status i handoff do niezależnego recenzenta

**FT_FAMILY_CORRECTIONS_COMPLETE_FOR_REVIEW** wyłącznie gdy R1–R7 spełniają
kryteria,tekst/kod/PDF są spójne,kontrole i replay przeszły. To gotowość do
niezależnego odbioru, nie nowy proof bezpieczeństwa ani owner acceptance.
Inaczej PARTIAL_PROOF/RESEARCH_REVIEW_CHANGES_REQUIRED/EXECUTION_BLOCKED
z dokładnymi brakami; counterexample ma obalaną tezę i membership.

RESULT flags: source_changed=false,production_source_changed=false,
estimator_campaign_executed_in_this_task=false,new_profiles_implemented=false,
source_security_proved=false,owner_accepted=false. all_review_items_resolved
tylko przy rzeczywistym zamknięciu macierzy. Wcześniejszych kampanii nie
przemianowuj na NOT_RUN — są odrębnymi pracami o własnym stanie.

Odpowiedz po polsku:
```text
Zakończyłem FT_FAMILY_SCALING_CORRECTIONS_RUN_003 (S01).
Status: ...
R1: disposition / evidence / co pozostaje otwarte
R2: ...
R3: ...
R4: ...
R5: ...
R6: ...
R7: ...
Co proved/checked; co withdrawn/proposed/open; failed routes: ...
Kontrole i formalizacja: ...
Fresh replay: matches/count,exit,czas,receipt; postfreeze replay: ...
PDF: ścieżka/build; W: ...
REPORT.md SHA-256: ...
OUTPUTS.sha256 SHA-256: ...
Własne obliczenia zakończone; aktywne joby: ...
source_changed=false; owner_accepted=false.
```

Właściciel przekazuje handoff prowadzącemu. Prowadzący przygotuje prompt
odbioru; **inny niezależny model wybrany przez właściciela** sprawdzi R1–R7
i wykona replay. Dopiero pozytywny odbiór poprawionego Family spełnia warunek
publikacji. Push nadal wymaga osobnego polecenia właściciela.
