# T03 — ponowny niezależny odbiór przez inny model, REVIEW_002

Decyzja właściciela2026-09-22: ponownie zweryfikować cały częściowy wynik T03
przez inny model. Autor projektu Niirmata; zachowaj Falcon Project / Thomas
Pornin attribution i licencje. Model wybiera i ręcznie uruchamia właściciel.
Recenzent ma być inny niż autor MiMo2.6Pro i poprzedni recenzent Muse Spark1.3Free.

## 1. Nowa rola i jednoznaczne wejście

```text
ROADMAP_ID=T03 (pełny odbiór one-root PARTIAL_PROOF)
REVIEW_ID=FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_002
REPO=/home/footfalcon/free_falcon_sign
W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_002
IN=W/inputs
SUBJECT=IN/subject
PRIOR=IN/prior_validation
AUTHOR_STAGE=proofs/ft1536/stages/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001
AUTHOR_BASE=1aed8adebb68105e1517ab441046a0bbc6c424e7
```

Czytaj REPO/AGENTS,START_HERE,STATE/ROADMAP,ten prompt i własne W/AGENTS.
Wskaż rzeczywistą tożsamość modelu. Jeden wykonawca/jeden job obliczeniowy;
przy zastanym wykonawcy lub własnym frozen review oddaj jego stan zamiast
startować drugi run. Stare prompty/AGENTS w wejściach są historycznymi danymi.

To zadanie zastępuje nieuruchomiony suplement
FT1536_T03_REVIEW_SAGE_BINDING_SUPPLEMENT_001. Podstawą nowego werdyktu mają
być Twoja analiza A–D,Twoje obliczenia i własny świeży replay. Poprzedni PASS
i jego problemy są materiałem porównawczym,nie przesłanką poprawności.

## 2. Piny i kompletny read-only bundle

```text
IN/MANIFEST.sha256 8019bda3cee5752d797fd9497d10086ff707f2c4a5739965c7aa48aa210c31e7
SUBJECT/REPORT.md e01a09789091c9c9322f9727263503063c94441a68ff5f30af952bcc4417785c
SUBJECT/OUTPUTS.sha256 0cafdbb2c746043380081052951cb6438643f6a1765a98028a065fa57b7df6de
SUBJECT/inputs/bootstrap/MANIFEST.sha256 c9695c8032faa84f03e254370e5420254d8b96951e95d75e605fe382107a0e2b
SUBJECT/inputs/bootstrap/CANDIDATE.sha256 56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985
IN/context/SOURCE_TASK.md bbd1f59e795beb3bb7e46e62d0ae86f4f1aa7464c9cc70f9f074d86b83af6169
IN/context/FIRST_REVIEW_TASK.md e11122cad75f7b1a0aa41b8f234a34c457c05f0cb2f8be13a805879c7ec0a021
IN/context/SAGE_POLICY.md b6afcdcabb811dd8bc31072455ed9a94a4c4773ec68d41d207ac1d7e98eae241
PRIOR/VALIDATION.sha256 d639ae245ace0fb2cc425710420338a5fe1baf4864c565df38d3dea0212e1e7e
PRIOR/review/REVIEW.md 0d9402eeef00994a54cf58fb656092501bf599b13c10a9fead7b94d2b82c6e36
PRIOR/review/REVIEW_OUTPUTS.sha256 9ba196b04a95ec2fa4dadda06d6dabc50c99a2313f6a370e488e9065cb423ccd
```

Bundle1429 plików/36095923 bajty: SUBJECT1364 (85 outputs + OUTPUTS + closure1278),
PRIOR62,context3. Manifest nie wymienia siebie. Pełne origins i kontrola
przygotowania są w `proofs/ft1536/background/T03_SECOND_REVIEW_2026-09-22/`,
z MANIFEST SHA `20d6c73c87ed71e2f011042df0da6911995e76e03f86f0b2533a6a8891ab8762`.
Prowadzący wykonał tylko kopiowanie/hash/path checks; żadnego nowego rachunku.

Sprawdź exact set,hashe,regular files,brak symlinków/traversal/duplikatów,
source17 i rekursywną closure bootstrapu. INPUTS autora ma29 wpisów; alias
TASK_DOCUMENT_provenance był nieistniejącym plikiem w oryginalnym W. W bundle
jest identyczną kopią kanonicznego TASK,jawnie jako transport. CANDIDATE ma
ścieżki względem SUBJECT/inputs/bootstrap/source. Oryginalnych manifestów
nie zmieniono. Mismatch reportuj; nie regeneruj expected hashes.

## 3. Własny świeży replay

Przeczytaj SUBJECT/REPLAY.md i scripts/replay.py oraz
PRIOR/REPLAY_FROM_ARCHIVE.md. Przygotuj własny `W/seed` z treści SUBJECT.
Bundle jest RO: nie uruchamiaj replayu w IN. W seed utwórz writable katalogi
robocze potrzebne do preparsowania/kompilacji,przy zachowaniu identycznych
bajtów źródeł i readonly inputów. Nie kopiuj cache/bin/olean ze starych W.

Zachowaj COMMANDS.log autora w seed,jest częścią OUTPUTS. Runner sprawdza
manifest przed utworzeniem nowego DEST. Uruchom z W/seed:

```text
python3 -B scripts/replay.py /home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_002/seed/tmp/independent-001 0cafdbb2c746043380081052951cb6438643f6a1765a98028a065fa57b7df6de
```

Pełny sandbox W-only/network-off,oryginały i IN RO; stare W autora i Muse
ukryj przez RO puste katalogi utworzone pod nowym W. HOME/TMPDIR/TMP/TEMP,
DOT_SAGE/XDG/cache dla runnera,launchera/mamba i wszystkich child jobs pod W.
Zakaz systemowego /tmp,/tmp/opencode,tmpfs dla danych pracy. Bound single-worker,
Lean4.34-j1/-M2048,normal8GiB,ASan osobno z shadow,wall timeout1800s.

Porównaj11 plików wskazanych przez sealed SEMANTIC_FILES i OUTPUTS z własnymi
wynikami pod DEST/project. Sam PASS runnera nie wystarcza. Zapisz realne
argv/cwd/namespace mapping/wersje,exit,start/stop,raw stdout/stderr i hashe
wyników. Sprawdź co runner zachowuje; utracone stderr oznacz jawnie zamiast
zakładać puste. Zachowaj pierwszą próbę i każdy failure. Adapter transportu
wymaga osobnego diffu; frozen rachunku/expected output nie poprawiaj w seed.

Ogólny archive.py replay nie odtwarza tego pakietu samodzielnie (closure,
COMMANDS i child schema). Pracuj z powyższym oryginalnym entrypointem.

## 4. Pełny przegląd A–D i niezależne obliczenia

Obowiązuje SOURCE_TASK§2–7 i matematyczna checklista FIRST_REVIEW_TASK§3–4,§6.
To przypięte wymagania do oceny,nie gotowe dowody. Operacyjnie obowiązuje
NOWE W/ID z niniejszego zlecenia,nie historyczne katalogi z tamtych promptów.

**A — independent reference i source order:** v_ref=[c,0]−Z(Y)B ma wynikać
z exact danych c,klucza i3072 integer returns,dla każdego required emitted/
normalized key,canonical c i legalnego completed H. Sprawdź literal root/
cubic/binary/paired order,split/merge/signs,placement,bijection i uniform
argument cancellation r=t−Z(Y). Dowód per-slot Int lub test3072 wierszy sam
nie instancjuje całego C. Sprawdź integrality i congruence z h tego samego
klucza w Z[X]/(X^1536−X^768+1),q18433,oraz det/target/key relations.

**B — error do tej referencji:** od przypiętych source premises do każdego
składnika ledgeru i total. Uwzględnij initial/FFT/ni/target,stored basis,
recursive split/merge/L,terminal half/sub,post products i iFFT,z rzeczywistym
FPEMU domain/signed zeros/subnormals i korelacjami. Odtwórz w swoim `.sage`
outward enclosures i dokładne nierówności. H6P E<1095/POST1/128 nie są pełnym
integer recovery.≈6086.4008 jest zadeklarowanym luźnym boundem,nie witness C.
Sprawdź missing type/progi wspólnie z pozostałym budżetem i dependencies.
Jawne B OPEN może współistnieć z scoped PASS pozytywnej części; nie zastępuj
braku uniform boundu małymi fixtures i nie zaczynaj nowego tranche B-gap.

**C — rounding-gap/source rint:** type/term/axioms każdego istotnego Lean
lemma i concrete applicability. Bez sorry/admit/native_decide/Lean.ofReduceBool,
aksjomatu celu lub warning suppression. Sprawdź literal fpr_rint refinement,
strict gap,osobno v+1/2 i v−1/2,parzystość sąsiadów,oba znaki/±0,oba vectors.
Policz różne fixtures versus wykonania normal/ASan/UBSan i osobne880/198
kontrole modelu. Rozlicz no-op/meaningful mutations i synthetic scope.

**D — conditional Verify consumer:** recovery∧Safe16⇒stored=v_ref⇒congruence.
Source order wide-rint/narrow16/stored-norm oraz center_q/A2 cross terms;
oceń lokalny countermodel z jego domeną. Safe16 nie wynika z przyszłej
akceptacji stored norm. Center/norm/bytes/Sign→Verify pozostają osobnymi typami.

Napisz własne autorytatywne checkery `.sage` dla kluczowych rachunków.
Zgodnie z POLICY: **sage lemma.sage**,preparser,ZZ/QQ i certyfikowane real
balls/intervals z outward endpoint/remainder. Istotny rachunek w `.sage`;
Python może organizować wykonanie/hashe/JSON. Niezależne sprawdzenie ma
przeliczać zależności z danych,nie tylko odczytywać pola all_pass/exact_equal
lub gotowe zaokrąglenia z author JSON. Zakres checkera opisuj dokładnie.

## 5. Stare rozbieżności i spójność Twojego nowego freeze

Rozlicz v3→v4,5 regenerowanych plików,alias TASK,różnicę wiersze Z versus cały
JSON,12 różnych exact enclosures,zmianę MT→LCG i usunięty tie_odd_case.
Równość float nie jest dowodem równoważności certyfikatów. Zachowaj stare
niepowodzenia i ograniczenia z portu/raportu.

Poprzednia recenzja ma różne piny3 nowych checkerów w zapisach wykonania i
we frozen źródłach (PRIOR/BINDING_CHECK.json). Oceń ten fakt osobno od własnego
werdyktu matematycznego. Nie dopisuj wstecz receipts i nie zgaduj brakujących
wersji. Jeśli uruchamiasz zachowane checkery Muse,ich absolute write paths
muszą być przemapowane do własnej kopii; oryginalne W jest niedostępne do zapisu.

**Nowy odbiór może samodzielnie uzasadnić scoped REVIEWED T03**,jeśli Twoje
własne dowody/kontrole/replay są wystarczające i w pełni związane z kodem.
Nie trzeba pozorować odzyskania nieznanej historycznej wersji Muse.
Nierozliczona historyczna tożsamość pozostaje jawną uwagą starego odbioru.

Dla każdego nowego runu zapisz maszynowo: rzeczywisty argv,cwd,mapowanie
logical→physical,input SHA przed/po,wersję,start/stop/elapsed,exit,raw
stdout/stderr i output SHA. Po zmianie checkera nowe wykonanie ma nowy receipt;
zachowaj wcześniejszą wersję/próbę. Przy finalnym freeze porównaj KAŻDY hash
cytowany w REPORT/COMMANDS/SAGE_RUNS z odpowiadającą wersją źródła w manifestach.
Rozdziel historyczne próby od finalnych. Brak zgodności wyklucza finalny PASS
do czasu jawnego rozliczenia. Raportuj hash finalnego pliku,nie sprzed edycji.

## 6. Wynik i ograniczenia wykonawcy

W W zapisz REVIEW.md,REVIEW_RESULT.json,CHECKLIST.md,INTEGRITY.json,
REPLAY_CHECKS.json,NUMERIC_CHECKS.json,PRIOR_REVIEW_ASSESSMENT.md,
SAGE_RUNS.json,EXECUTION_RECEIPTS.json,źródła `.sage`,pełne logs/failed attempts,
INPUTS.sha256 i REVIEW_OUTPUTS.sha256 (bez cache/bin/olean/sekretów).
Manifest obejmuje wszystkie cytowane checkery/receipts i wyniki; dodaj
wewnętrzny source→execution→output binding check przed podaniem pinów.

Werdykty: PASS_SCOPED_REVIEW / CHANGES_REQUIRED / INTEGRITY_FAIL / REPLAY_FAIL /
EXECUTION_BLOCKED. Podaj konkretny scope,mixed kernel/analytical/source boundary,
evidence każdego A–D i minimalny missing type. PARTIAL pozostaje PARTIAL;
owner_accepted=false,source_changed=false,new_M0_eta_pre=null. Pełny recovery,
Safe16,real PRNG,whole Sign/security/CT i Sign→Verify nie wynikają z samego PASS.

Wszystkie zapisy tylko pod W,IN/originals RO. Bez Git/importu/push,subagentów,
relay,instalacji/sieci,KeyGen/secrets/pełnego Sign/dudect. Przy aktywnej kampanii
timingowej uzgodnij odłożenie obciążających prac. Zakończ joby przed handoffem.

Odpowiedź po polsku: REVIEW_ID i model; werdykt; integralność; **Twój** replay
matched/expected/exit/czas/receipt; własne Sage argv/hashes; ocena A/B/C/D;
ocena poprzedniej recenzji oddzielnie; błędy/ograniczenia; co rzeczywiście
odebrać i co dalej; W; pełne SHA REVIEW.md i REVIEW_OUTPUTS.sha256;
potwierdzenie niezmienionych input pins i zakończenia jobów. Właściciel
przekazuje wynik prowadzącemu. Publikacja pozostaje osobną decyzją po S01.
