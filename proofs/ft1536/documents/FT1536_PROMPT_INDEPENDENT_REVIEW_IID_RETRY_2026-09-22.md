# Niezależny odbiór T01 — IID_RETRY_COMPOSITION

2026-09-22. Autor projektu Niirmata. Ten prompt jest przygotowany przez
prowadzącego; **wykonuje go inny niezależny model wybrany przez właściciela**.
Nie jesteś wykonawcą pierwotnego dowodu. Twoim zadaniem jest ocena wyniku,
odtworzenie obliczeń i znalezienie ewentualnych luk, nie uzyskanie PASS za wszelką cenę.

## 1. Identyfikacja i jednoznaczne role

```text
ROADMAP_ID=T01 (odbiór)
REVIEW_ID=FT1536_IID_RETRY_INDEPENDENT_REVIEW_001
REPO=/home/footfalcon/free_falcon_sign
SOURCE_W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_IID_RETRY_COMPOSITION_RUN_001
REVIEW_W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_IID_RETRY_INDEPENDENT_REVIEW_001
TASK=/home/footfalcon/free_falcon_sign/proofs/ft1536/documents/FT1536_ZADANIE_ASTRA_IID_RETRY_COMPOSITION_2026-09-22.md
AUTHOR_BASE=1ba7ae07c17d135fc8eff4aac7b56f8c2b3bc88c
```

Czytaj REPO/AGENTS.md, START_HERE.md, STATE/ROADMAP wyłącznie dla orientacji,
ten prompt i przypięte TASK/REPORT. Do not resume author's old task from
historical prompts. SOURCE_W ma być tylko odczytywany. Wszystkie Twoje nowe
skrypty, logi, HOME/TMPDIR/TMP/TEMP/DOT_SAGE/cache/olean/bin/replaye wyłącznie
w REVIEW_W pod repo. **Zakaz systemowego /tmp,/tmp/opencode,tmpfs** dla pracy.
Jeden recenzent/jeden job obliczeniowy naraz,bez subagentów/relay/drugiej sesji.
Jeżeli REVIEW_W istnieje, sprawdź jego status/ownership; nie nadpisuj i nie
uruchamiaj równolegle drugiego odbioru. Wznowienie zachowuje wcześniejsze próby.

## 2. Zewnętrzne piny przekazane przez właściciela

Poniższe SHA pochodzą z handoffu w czacie. Prowadzący NIE sprawdził ich bajtów
ani deklarowanego replayu. Ty masz je niezależnie zweryfikować:

```text
SOURCE_W/REPORT.md:
b7164dbbee02db248ea43adce1d63ae0a38ed4493a566c5acd3a2f507db14590
SOURCE_W/OUTPUTS.sha256:
3d68249f4f0e017f32eb7edeb0d90f5c4a6cd6b4b9f93307cec6919439525074
TASK:
f773b8f31f7d307850ee3d1eb948bb05ceacee5589d5c4971e3eaee34c5bed97
SOURCE_W/inputs/bootstrap/MANIFEST.sha256:
daa95bc07516271ff897f95af11b3c90950ccb1a7dc20f0f3da5e994785a46b8
17-file CANDIDATE.sha256:
56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985
```

Deklarowany końcowy receipt autora:
`SOURCE_W/tmp/final_replay_001/REPLAY_RESULT.json`.
To receipt **autora**, poza głównym freeze jeśli manifest go nie obejmuje;
nie jest Twoim niezależnym replayem. Sprawdź jego proweniencję osobno.

## 3. Tezy do oceny — na wejściu WYŁĄCZNIE deklaracje

Author status: `IID_RETRY_COMPOSITION_PROVED_FOR_PINNED_IID_BUFFER_MODEL`.
Zakres: jedno legalne post-H2P ReadyRetryEntry,idealny G_retry_IID,
rzeczywisty16-attempt region i końcowy source STATIC codec.

Deklarowane rezultaty:
- WholeRegionBad<=2^-80,obie pre-narrow vectors,także w norm-rejected próbach;
- każde reached entry legalne, świeży buffer po resetach, a.s. region return;
- equal-until-bad checked-precast coupling/public-observation distance;
- wspólny ghost budget6352 blocks=26017792 bytes,przekroczenie<2^-1020;
- norm-accepted stored pair→exact STATIC/header payload<=3160;
-120 modułów Lean,922 twierdzenia,26 nowych; clean logs/axioms;
-22 scheduler/codec+6 reset/getter cases na tryb normal/ASan/UBSan;
-11 detected mutations+2 equivalences;
-fresh i postfreeze replays autora492/492, Floor timeout/zasoby zachowane.

Nie przyjmuj liczb/kierunków ani countów z tego streszczenia jako dowodu.
Zidentyfikuj rzeczywiste certificates i zweryfikuj ich wzajemną zgodność.
Real SHAKE/ChaCha bridge,H2P prefix,whole real Sign,integer recovery,
Sign→Verify,security/CT i eta_pre nie są claimed tym etapem.

## 4. Integralność i wykonanie świeżej kopii

1. Potwierdź SOURCE_W/TASK/piny i zgłoszony freeze. Zrób manifest checked
   members z real SHA/rozmiarem; odrzuć traversal,symlinks,duplikaty,niezapieczętowane
   dependencies. Zweryfikuj INPUTS,bootstrap i source17. Porównaj statusy
   REPORT/RESULT/certificate,proof kind oraz flags. Przy mismatch zatrzymaj
   wykonanie pakietu i raportuj `INTEGRITY_FAIL`; nie poprawiaj manifestu.
2. Utwórz własny seed wyłącznie z sealed regular members pod REVIEW_W.
   Zachowaj pin OUTPUTS,rozmiary,source map i kopie wejść. Nie kopiuj jako
   gotowych wyników `.olean`,bin/cache z żywego W. Nadmiarowe unsealed tmp
   autora mogą istnieć w SOURCE_W,ale nie mogą być skrytą zależnością replayu.
3. Przeczytaj REPLAY.md i entrypoint zanim go uruchomisz. Sprawdź manifest
   verification przed utworzeniem DEST,brak historycznych write paths,
   faktycznie fresh build,handling COMMANDS/frozen prefix i semantic list.
   Nie zmieniaj dowodów/skryptów aby wymusić PASS. Ewentualny transport-only
   adapter trzymaj osobno z diffem i ograniczeniem niezależności wyniku.
4. W bwrap lub równoważnym realnym sandboxie source/oryginały RO,sieć off,
   jedyny trwały zapis REVIEW_W,HOME/TMP/cache lokalne. Ukryj pierwotny
   SOURCE_W i zbędne zewnętrzne katalogi przez readonly puste katalogi
   UTWORZONE POD REVIEW_W, tak by nie można korzystać z author cache.
5. Standardowy entrypoint,uruchomiony z katalogu nowego seed:

```text
python3 -B scripts/replay.py REVIEW_W/seed/tmp/independent_001 3d68249f4f0e017f32eb7edeb0d90f5c4a6cd6b4b9f93307cec6919439525074
```

   Podstaw pełny ABSOLUTE DEST,który jeszcze nie istnieje. Jeśli rzeczywisty
   protokół różni się od TASK,opisz rozbieżność. Globalny timeout1800s,
   bounded single-worker,Lean-j1/-M2048,normal8GiB; ASan oddzielnie z shadow.
   Zachowaj stdout/stderr/exits/times/receipts i pierwszy failure.
6. Potwierdź FRESH_REPLAY_PASS i **bajty** każdego semantic match: expected
   list musi pochodzić z zewnętrznie przypiętego pakietu,nie tylko listy
   wygenerowanej przez nowy run. Sprawdź claimed492 i pełną listę różnic.
   Po runie ponownie sprawdź sealed SOURCE_W bez edytowania go.

Nie używaj `archive.py import` w tym odbiorze: to zmieniałoby stages/catalog.
Przypięte narzędzie może pomóc w read-only parsowaniu manifestów; import
i późniejszy Git są osobnym krokiem po werdykcie. Brak nowego replayu nie
jest PASS dlatego, że author receipt ma492/492.

## 5. Przegląd matematyczny i source bindings

### A. Entry, scheduler i ponowne wejścia

Z jednego ReadyRetryEntry PRZED pętlą,po H2P, ma wynikać każde reached entry.
Sprawdź,czy desired applicability nie jest ukryta w definicji ReadyRetryEntry.
Literal generate3327–3421: guard17 PRZED init/do_sign;fault reset przed call,
fault check po nim;strict STORED norm;first acceptance;jedno encode po break;
encode failure daje0 bez kolejnej próby. Rejected attempt nie psuje sk/hm
i następne target/scratch reads są initialized/overwritten w właściwej kolejności.
Existing emitted gates/P_key nie mogą być wzmocnione. Nie myl prefix theorem
z zakończeniem H2P/API ani null-tape nonreturn z source return0.

### B. IID/refill filtration

Co dokładnie jest idealizowane? Actual state/type/counter effects i56 SHAKE
bytes muszą być oddzielone od fresh iid4096-byte block outputs. Nie przyjmuj
iid seeds/niezależności real SHAKE. Reached event musi być measurable na
attempt-entry PAST; unread/future tape nie jest częścią tej PAST. Przy re-init
nowy initial block i ptr0; porzucony stary tail to nie getter drops ani
ponowne użycie tych samych losowych bytes. Sprawdź stopping-time świeżość
i zero-probability-history formulation.

### C. WholeRegionBad i conditional hazard

H6P ma działać na każdej wykazanej reached entry. Zweryfikuj
`Pr(WholeBad)<=sum E[1_Rj Pr(Bad_j|PAST_j)]<=p_outward*sum Pr(R_j)<=16p`.
Event obejmuje obie vectors także po norm rejection i przy późniejszym return0.
Jeżeli podano ciaśniejszy `1-(1-p)^16`, sprawdź conditional survival proof,
wymagany bound po no-previous-bad i poprawne zero padding nieosiągniętych prób.
Nie odrzucaj go tylko z braku independence,ale nie akceptuj bez argumentu.
Bad∧success a Bad|success: drugi potrzebuje positive denominator. Sprawdź
clip,zakresy p,boundy exact rational i potęgi2 niezależnym skryptem.

### D. Checked-precast coupling i obserwacje

Synchronous same-tape execution ma się zgadzać do pierwszego BadPrecast.
Proof-only PRECAST_EXIT nie jest nowym C abortem. Sprawdź zasięg „before
stores”,legalność przeniesienia obserwatora wide rint obu vectors oraz wspólną
przestrzeń tagów/source0/positive bytes. Public projection musi zachowywać
zgodność i data processing. Nie może filtrować invalid positive output przez
przyszły Verify. Recovery/congruence/center compatibility nie wynika z Safe16.

### E. Wspólne budżety i reset accounting

Niezależnie przelicz exact formulas dla initial blocks,additional refills,
getter drops,reinit abandonment,final unused tail,56*J SHAKE bytes i returned
33*T. Każde init ma ptr0 oraz pierwsze4096 bytes; nie stosuj ciągłej pointer
conservation przez reset. J jest losową liczbą reached attempts,nie stałe16.

**Szczególny punkt:** globalny cap T_region≤16*49152 nie implikuje automatycznie
wszystkich per-attempt refill caps. Ustal event,z którego JEDNOCZEŚNIE wynikają
6352 blocks,26017792 bytes i pozostałe budgets (np. wszystkie reached root
proposal counts≤49152),a potem jego failure bound. Jeśli dowód używa innej
trasy,sprawdź wszystkie floors/additive terms/reset costs. Nie łącz boundu
jednego eventu z caps dowiedzionymi tylko na innym. Tail<16*2^-1024=<2^-1020
ma mieć poprawną strict/nonstrict konwencję. Ghost cap nie zmienia source.

### F. Bajty i formalizacja

STATIC capacity3160 jest consumerem norm-accepted STORED pair w legalnym
4096-byte bufferze;header0xaa,len i decode/map realne. Raw wide values nie
mogą zastąpić stored pair bez Safe16. Brak7th/17th call i encode failure
kontrolować source flow,nie tylko model stubów.

Przejrzyj nowe Lean theorem types/terms/axioms i instancje ich przesłanek.
Generic union/frame algebra nie dowodzi automatycznie source applicability.
Sprawdź120/922/26 i inherited hashes/fresh compilation,clean logs,brak
sorry/admit/native_decide/Lean.ofReduceBool/aksjomatów celu/warning suppression.
Real probability/source model/heap/compiler boundary musi pozostać jawna.

## 6. Kontrole ujemne, incydent współbieżności i scope

Sprawdź22+6 cases per mode,canaries,domain preflight,ASan/UBSan i brak silent
sanitizer exclusions. Ustal rzeczywiste stub boundaries oraz scope synthetic
versus required-domain evidence. Sprawdź11 mutations i2 equivalences:
wykonanie,test wrażliwy na błąd,brak sztucznego wykrycia no-op.

Etap miał **dwa nakładające się wykonania tej samej sesji**. Background
executor593062 został zatrzymany; autor deklaruje późniejszy freeze i replay.
Nie jest to automatyczne obalenie wyniku,ale wymaga szczególnej kontroli:
source hashes w receipts,consistency final kernel ordering/semantic outputs,
brak stale outputs z failed runs,samodzielny świeży rebuild i zachowane logi
timeout Floor oraz zmian rachunku zasobów. PID jest historią,nie aktualną
zgodą na zabijanie procesu. Nie modyfikuj logów ani author workspace.

Weryfikuj zachowanie scope: ONE post-H2P region,G_retry_IID,emitted/legal entry.
source_changed=false,owner_accepted=false,new_M0_eta_pre=null. Nie awansuj
wyniku do real PRNG,H2P prefix,whole real Sign,integer recovery,Sign→Verify,
security/CT. Nie porównuj go z wymyślonym uniwersalnym Safe16.

## 7. Wynik Twojego odbioru

W REVIEW_W zapisz REVIEW.md,REVIEW_RESULT.json,CHECKLIST.md,COMMANDS/logs,
INTEGRITY.json,REPLAY_CHECKS.json,NUMERIC_CHECKS.json oraz REVIEW_OUTPUTS.sha256
obejmujący trwałe źródła/logi/receipts odbioru (bez cache/bin/olean/secrets).
Nie zapisuj w repo/stages/validation ani nie commituj/pushuj. Ten leading
session przygotował prompt; to TY niezależnie wykonujesz wszystkie kontrole.

Werdykt:
- **PASS_SCOPED_REVIEW**: integralność i fresh replay passed, argument i
  source instancje zamknięte w dokładnie zadeklarowanym zakresie.
- **CHANGES_REQUIRED**: wskazana istotna luka/błąd/niespójność, nawet jeśli
 492 hashes się zgadza. Daj konkretny minimalny missing type lub witness.
- **INTEGRITY_FAIL**: zewnętrzny pin/set/source binding niezgodny.
- **REPLAY_FAIL**: wykonany świeży replay nie przechodzi; odróżnij tool/env
  failure od semantic mismatch i zachowaj pełną pierwszą próbę.
- **EXECUTION_BLOCKED**: brak możliwości wykonania wymaganej kontroli z
  konkretnym logiem; nie twierdź wtedy, że replay passed lub całe claim verified.

Nie poprawiaj frozen pakietu. Proponowane naprawy zapisuj w REVIEW.md poza nim.
PASS nie oznacza owner acceptance ani pozwolenia publikacji. Bez uruchamiania
T02,T03,dudect,innych modeli,relay,sieci/instalacji,KeyGen/pełnego Sign/secrets.
Jeśli dudect jest aktywny,uzgodnij z właścicielem późniejszy replay bez
obciążenia kampanii. Zakończ swoje joby przed końcowym handoffem.

## 8. Dokładna odpowiedź w czacie

```text
Zakończyłem niezależny odbiór FT1536_IID_RETRY_COMPOSITION_RUN_001.
Werdykt: [PASS_SCOPED_REVIEW / CHANGES_REQUIRED / INTEGRITY_FAIL / REPLAY_FAIL / EXECUTION_BLOCKED]

Integralność: [REPORT/OUTPUTS/TASK/bootstrap/source; matched/expected]
Mój świeży replay: [matched/expected,exit,czas,receipt; nie receipt autora]
A–F: [każdy punkt: potwierdzony / luka / niezweryfikowany, evidence path]
Rachunek zasobów: [joint event,6352/26017792,tail; niezależne przeliczenie]
Granica dowodu: [kernel/analytical/source; dokładny accepted scope]
Istotne uwagi: [severity,plik:linie,wpływ,naprawa; albo jawny brak znalezionych luk]
Overlap/failed routes: [co sprawdzono; zachowane logi]

Co wynik zmienia i co pozostaje otwarte: [...]
Rekomendacja: [odebrać tylko ten scope / poprawić / brak pełnej weryfikacji]
REVIEW_W: [pełna ścieżka]
REVIEW.md SHA-256: [64hex]
REVIEW_OUTPUTS.sha256 SHA-256: [64hex]
SOURCE_W po odbiorze: [hashy niezmienione / rozbieżność]
Własne obliczenia zakończone. Źródeł/frozen pakietu nie zmieniono.
Brak Git/publikacji/relay/dudect; owner_accepted=false.
```
