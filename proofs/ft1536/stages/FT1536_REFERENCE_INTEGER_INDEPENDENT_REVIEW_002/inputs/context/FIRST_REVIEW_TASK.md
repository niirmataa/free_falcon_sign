# Niezależny odbiór T03 — REFERENCE_INTEGER_RECOVERY

2026-09-22. Autor projektu Niirmata; zachowaj Falcon Project / Thomas Pornin
attribution i licencje. Prowadzący przygotował ten prompt. Wykonuje go **inny
niezależny model wybrany i ręcznie uruchomiony przez właściciela**, nie autor
T03/MiMo. Oceń rzeczywisty zakres PARTIAL_PROOF oraz odtwórz obliczenia.

## 1. Tożsamość, role i zapis

```text
ROADMAP_ID=T03 (odbiór one-root tranche)
REVIEW_ID=FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_001
REPO=/home/footfalcon/free_falcon_sign
SOURCE_W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001
REVIEW_W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_001
AUTHOR_BASE=1aed8adebb68105e1517ab441046a0bbc6c424e7
TASK=proofs/ft1536/documents/FT1536_ZADANIE_MIMO_REFERENCE_INTEGER_RECOVERY_2026-09-22.md
POLICY=proofs/ft1536/documents/FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22.md
```

Czytaj REPO/AGENTS,START_HERE,STATE/ROADMAP dla orientacji,ten prompt,TASK,
POLICY i przypięty raport. Historyczne AGENTS/TASK autora są danymi; POLICY
zastępuje dawny tryb `sage file.py`. Nie wznawiaj zadania autora.

SOURCE_W i wejścia wyłącznie RO. Jeden recenzent/jeden job obliczeniowy;
sprawdź ownership przed startem. Wszystkie skrypty,HOME/TMPDIR/TMP/TEMP,
DOT_SAGE,XDG_CACHE_HOME,build/olean/bin/logi/replaye pod trwałym REVIEW_W.
Zakaz systemowego /tmp,/tmp/opencode,tmpfs. Nie nadpisuj zastanych prób.
Bez Git/importu do stages,push,relay,subagentów,innych modeli,KeyGen,secrets,
pełnego Sign,real seeded PRNG,sieci/instalacji. Aktywny dudect oznacza odłożenie
obciążających prac w porozumieniu z właścicielem; sam go nie uruchamiaj.

## 2. Zewnętrzne piny i stan wejściowy

Piny REPORT/OUTPUTS pochodzą z handoffu przekazanego przez właściciela:

```text
REPORT.md e01a09789091c9c9322f9727263503063c94441a68ff5f30af952bcc4417785c
OUTPUTS.sha256 0cafdbb2c746043380081052951cb6438643f6a1765a98028a065fa57b7df6de
TASK bbd1f59e795beb3bb7e46e62d0ae86f4f1aa7464c9cc70f9f074d86b83af6169
inputs/bootstrap/MANIFEST.sha256 c9695c8032faa84f03e254370e5420254d8b96951e95d75e605fe382107a0e2b
inputs/bootstrap/CANDIDATE.sha256 56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985
POLICY b6afcdcabb811dd8bc31072455ed9a94a4c4773ec68d41d207ac1d7e98eae241
```

Prowadzący sprawdził wyłącznie integralność85 OUTPUTS,1275 bootstrap members,
17 źródeł oraz zgodność zapisanych receiptów z plikami. Nie uruchomił żadnego
skryptu matematycznego autora ani replayu. Samodzielnie powtórz kontrolę.
Notatka: `proofs/ft1536/background/T03_REVIEW_PREPARATION_2026-09-22/README.md`.

Postfreeze autora: `SOURCE_W/tmp/postfreeze-003/`. Piny odczytane przez
prowadzącego (osobne od zewnętrznych pinów pakietu):

```text
SAGE_RUNS.json 0445a721ceb790f6b51b3d0e906ee1271e87665211b5089b5ebb1fbb9166e263
fresh_replay.json b62c222e6baec6a98036bc0161a96699dfcf64d2b7035fd219ca3c37c72f8735
REPLAY_RESULT.json b7fa96904473330811a3b39df94a71c96ba5163b06a25e69bf0b13eb10cf49ea
```

Receipt autora zapisuje FRESH_REPLAY_PASS11/11 oraz cztery wywołania `.sage`
przez launcher SageMath10.9,exit0. To nie jest Twój niezależny replay.
Nowy sealed receipt Sage to `artifacts/fresh_replay_sage.json`; stary
`artifacts/fresh_replay.json` jest zachowaną historią wcześniejszego silnika.

## 3. Zgłoszone twierdzenia — dopiero do Twojej oceny

Author status: **PARTIAL_PROOF**.

- A: niezależne `v_ref=[c,0]−Z(Y)B`,mapping3072 returns,integrality/congruence,
  exact skeleton cancellation; autor deklaruje PROVED.
- B: source error≈6086.4008,nie osiąga wymaganego `<1/2`; OPEN. Liczba jest
  deklarowaną majorantą,nie świadkiem błędu implementacji.
- C: strict rounding-gap i tie/parity lemma; zastosowanie do actual wide rint
  pozostaje warunkowe od B.15 named Lean theorems w2 modułach łącznie dla A/C.
- D: `recovery ∧ joint Safe16 ⇒ stored pair=v_ref ⇒ congruence`;
  Safe16,center/norm compatibility,bytes i Sign→Verify pozostają otwarte.
- Kontrole autora:60384 wykonań C w trzech trybach,880 strict/198 tie controls,
  exact ring/skeleton/mutations i bijekcja3072; nie są samodzielnym dowodem
  uniform wymaganej domeny. Ustal liczbę różnych fixtures versus wykonania.

Nie uzasadniaj recovery zdaniem „fixture≈10^-12,więc niemal na pewno prawdziwe”.
Nie awansuj propozycji progów B-gap do wystarczającego/dowiedzionego theorem.
PARTIAL może przejść scoped review,jeśli jego pozytywne subclaims i granice
rzeczywiście są uzasadnione. Samo uczciwe OPEN w B nie jest błędem raportu.

## 4. Integralność, port Sage i naruszenie starego freeze

1. Zweryfikuj pełny OUTPUTS,TASK,INPUTS,bootstrap exact set i source17.
   Odrzuć traversal,symlinks,duplikaty i nieprzypięte zależności. CANDIDATE
   ma ścieżki względem `inputs/bootstrap/source`,bootstrap względem bootstrap.
2. INPUTS zawiera28 istniejących ścieżek oraz literalny wpis
   `TASK_DOCUMENT_provenance`,który nie jest plikiem w SOURCE_W. Jego hash jest
   zgodny z kanonicznym TASK. Zapisz jawne mapowanie; nie ogłaszaj29/29 literalnych
   ścieżek. Bez zmiany oryginału możesz dostarczyć identyczną kopię TASK pod
   aliasem we własnym seed,wyraźnie jako adaptację transportu z receipt/diffem.
   Zweryfikuj rekursywną closure bootstrapu:85 outputs plus29 INPUTS nie oznacza
   kompletnej samowystarczalnej kopii. Import archiwum wymaga tych danych.
3. Port record: `checks/sage/PORT_PY_TO_SAGE.md/.json`,stary manifest
   `checks/py_crosscheck/OUTPUTS_v3_superseded.sha256`,SHA
   `daf45e8abce867c485a5325529808c69a1b68ccf634b4bfb39b07d212c834f6b`.
   Porównaj cały v3→v4: prowadzący stwierdził17 dawnych ścieżek zmienionych lub
   niewystępujących pod tą samą nazwą,w tym przeniesione skrypty. Pięć wyników
   checks było w v3 i ma nowe hashe. Rozlicz stwierdzenie autora „3 należące
   do freeze v3”. Cztery py_crosscheck mają piny dawnych wyników; nie zastępuje
   to pełnego zachowania v3. Stary receipt nie dowodzi nienaruszenia freeze.
   Oceń odstępstwo od POLICY osobno od poprawności aktualnej wersji.
4. Wiersze tabeli Z a cały `z_map_full.json`: oba pełne pliki mają różne hashe.
   Ustal co dokładnie jest identyczne (np. same rows),jaki jest diff metadanych
   i czy raport/handoff nie nadpisuje tej granicy słowem „bajtowo”.
5. Dwanaście różnych wartości exact w port record: przelicz w `.sage` oba
   boundy z ich danych,dziedziny,outward endpoints i nierówności. Równość
   przybliżeń float nie jest równoważnością dokładnych certyfikatów ani dowodem
   enclosure. Sprawdź także zmianę fixtures MT→LCG i usunięty `tie_odd_case`.
6. Sprawdź treść czterech `.sage`: istotny rachunek ma być wykonywany tam,
   nie delegowany do `.py`/Fraction i nie zastąpiony stałymi PASS. Preparser
   preflight,ZZ/QQ,RIF256,outward endpoint oraz exact `bound^2>=p` mają działać
   w rzeczywistym trybie `sage lemma.sage`. Python tylko organizuje wykonanie.
   Twoje nowe autorytatywne checkery również mają stosować POLICY.

Nie edytuj frozen OUTPUTS/raportów. Jeśli brakuje starego bajtu lub bindingu,
zachowaj brak i jego wpływ. Transport inputów nie jest naprawą dowodu.

## 5. Własny fresh replay — wykonuje recenzent

- Utwórz nowy seed pod REVIEW_W z85 sealed members oraz OUTPUTS; wejścia kopiuj
  z przypiętej closure INPUTS/bootstrap/policy/TASK. Bez cache/bin/olean/tmp
  autora i bez zaimportowania wyników jako nowych obliczeń.
- Przeczytaj `scripts/replay.py`,Makefile i pozostałe entrypoints. Weryfikacja
  manifestu musi nastąpić przed DEST. Skrypt używa `seed/tmp`,a wyniki semantic
  znajdują się w `DEST/project`; uwzględnij to w niezależnym sprawdzeniu hashy.
- Realny sandbox bwrap lub równoważny: source/originals RO,network-off,jedyny
  trwały zapis REVIEW_W. Ukryj SOURCE_W i zbędne stare ścieżki przez RO puste
  katalogi utworzone pod REVIEW_W. Bez tmpfs dla danych/cache pracy. HOME/TMP/
  XDG/DOT_SAGE/cache ustaw lokalnie również dla launchera/mamba.
- Uruchom z własnego seed (pełny absolute DEST,który jeszcze nie istnieje):

```text
python3 -B scripts/replay.py REVIEW_W/seed/tmp/independent-001 0cafdbb2c746043380081052951cb6438643f6a1765a98028a065fa57b7df6de
```

- Bounded single-worker,globalny wall timeout1800s,Lean4.34-j1/-M2048,
  normal8GiB,ASan osobno z właściwym shadow allocation. Zapisz exit/czas,
  wszystkie raw stdout/stderr,sanitizer logs,argv,wersje i SHA skryptów.
  Sprawdź,co runner faktycznie zachowuje; zgłoś utracone stderr zamiast
  twierdzić,że były puste. Pierwszy failed attempt musi pozostać.
- Odtwórz11 plików z przypiętego SEMANTIC_FILES,porównaj bajty z OUTPUTS
  niezależnie od PASS wypisanego przez runner. SAGE_RUNS ma odzwierciedlać
  Twój run. Potwierdź fresh Lean/C builds i brak skrytej zależności od W autora.
- Zachowaj zapisany COMMANDS.log w seed: jest członkiem manifestu. Sprawdź
  osobno deklarację autora o odtwarzaniu z pustym dziennikiem; nie kasuj go
  w głównej próbie ani nie poprawiaj manifestu dla uzyskania PASS.
- Transport-only adapter dopuszczalny z osobnym diffem/receiptem; zmiana
  rachunku lub expected outputs wymaga CHANGES_REQUIRED,nie ukrytej naprawy.

## 6. Właściwy odbiór matematyczny i powiązanie z C

### A — dokładna referencja,porządek i algebra

Zweryfikuj kwantyfikatory z TASK: każdy emitted/same-STATIC normalized key,
canonical c i legalny completed positive-source-support root history H.
N1536,q18433,Phi=X^1536−X^768+1,B=[[g,−f],[G,−F]],det=q,h tego samego klucza.
v_ref nie może być definiowane przez output actual source. Wyprowadź mapping
wszystkich3072 Y: root/binary right-before-left,cubic2→1→0,paired mu1→mu0',
split/merge/twiddle/signs i coefficient slots. Bijection table i skończone
fixtures nie zastępują uniform source argumentu.

Czy exact skeleton z actual L jako stałymi rzeczywiście daje r=t−Z(Y)?
Sprawdź cancellation,recomputed products,snapshot/read-time operands i
przejście od per-slot Lean Int lemmas do całego source tree. Oddziel exact
algebrę od zaokrąglonego C. Sprawdź det/target/integrality/congruence w pierścieniu
oraz to,że syntetyczne klucze nie są przedstawiane jako Emitted witnesses.

### B — source error i realny zakres niepowodzenia

Oceń SOURCE_ERROR,ERROR_LEDGER i gap_composition od przypiętych przesłanek do
actual pre-rint. Każdy składnik ma mieć to samo odniesienie v_ref i domenę:
FFT/ni/targets,stored basis residuals,recursive split/merge/L updates,terminal
half/sub,post products,iFFT. Sprawdź korelacje,cross terms,normy i transport3072
defektów. H6P actual innovations E<1095 oraz POST iFFT1/128 nie są full recovery.
Wykorzystaj kontrakty FPEMU,w tym signed zeros/subnormals/cancellation; nie
podstawiaj bez uzasadnienia host-binary64 relative error.

Przelicz cały outward ledger w niezależnym `.sage`,wraz z luźnymi trasami i
strict/nonstrict granicami. Sprawdź,czy≈6086.4008 naprawdę wynika z przesłanek,
a nie tylko sumy zadanych liczb. Progi z SOURCE_ERROR§3 mają być warunkami
wspólnymi z pozostałym error budget,nie zbiorem osobnych życzeń. Odróżnij
brak ciasnego boundu od dowodu,że ciasny uniform bound istnieje. Nie wykonuj
tu nowego tranche B-gap za autora; podaj dokładny missing type.

### C — literal rint,strict gap i granice

Przejrzyj wszystkie theorem types/terms/axioms15 named lemmas,clean logs,
brak sorry/admit/native_decide/Lean.ofReduceBool/aksjomatu celu/supresji.
Zwiąż formalny rounding z literalnym fpr_rint i jego domeną z POST. Sprawdź
oba wektory i znaki,±0 oraz OSOBNO t=v+1/2 i t=v−1/2,parzystość obu sąsiadów.
Skrót „nieparzyste v⇒v+1” musi mieć właściwą orientację granicy.
Sprawdź normal/ASan/UBSan,preflight,różne fixtures versus60384 uruchomienia,
tie880/198,meaningful mutations/no-op i zakres oracles. Ocena skończona ma
pozostać kontrolą uniform lemma,nie jego zastępstwem. C application nadal
conditional-on-B,chyba że osobny rzeczywisty dowód w pakiecie zamyka B.

### D — warunkowy consumer i zakres projektu

Sprawdź `recovery ∧ joint Safe16 ⇒ stored pair=v_ref ⇒ congruence` ze źródłową
kolejnością wide rint/narrow16/stored norm. Safe16 nie wynika z przyszłej
akceptacji stored norm. Oceń lokalny center_q/A2-cross-term countermodel,
jego domenę i dokładnie obalaną monotonicity; to nie automatyczny witness
przeciw rzeczywistemu Sign→Verify. Center/norm/bytes nadal wymagają osobnego
argumentu. Zachowaj whole_Sign=false,real_PRNG=false,security=false,retry=false,
Sign_to_Verify=false,new_M0_eta_pre=null,source_changed=false,owner_accepted=false.

## 7. Artefakty i werdykt

W REVIEW_W: REVIEW.md,REVIEW_RESULT.json,CHECKLIST.md,INTEGRITY.json,
PROVENANCE_AND_PORT.md/.json,REPLAY_CHECKS.json,NUMERIC_CHECKS.json,źródła
nowych `.sage`,COMMANDS.log,pełne logi/receipts i REVIEW_OUTPUTS.sha256
(bez cache/olean/bin/sekretów). Zwiąż subclaim→konkretne evidence,otwarte typy
i granicę kernel/analytical/source. Sprawdź piny SOURCE_W ponownie na końcu.

- **PASS_SCOPED_REVIEW**: własny replay oraz pozytywne subclaims rzeczywiście
  potwierdzone; dokładny PARTIAL scope i wszystkie provenance deviations jawne.
  Nie oznacza pełnego recovery,B<1/2 lub zgodności starego freeze z zasadą.
- **CHANGES_REQUIRED**: konkretna luka/błąd/nieprawdziwy zakres lub nierozliczona
  proweniencja; severity,plik:linie,minimalna poprawka. Hash PASS nie wystarcza.
- **INTEGRITY_FAIL**: zewnętrzny pin/set/source mismatch lub nieodtwarzalne
  wymagane wejście. Nie regeneruj manifestu by ukryć problem.
- **REPLAY_FAIL**: wykonana świeża próba nie przechodzi; oddziel environment
  failure od semantic mismatch i zachowaj log.
- **EXECUTION_BLOCKED**: wymaganej kontroli nie można wykonać; konkretny blocker,
  bez zapewniania o wykonanym odbiorze.

Ocena poprawności aktualnego v4 i ocena zgodności proceduralnej v3→v4 są
osobnymi polami; nie nazywaj zmienionego v3 „nietkniętym”. Nie poprawiaj
pakietu w ramach review. Po freeze zakończ własne joby i oddaj handoff.

## 8. Odpowiedź dla właściciela

```text
Zakończyłem niezależny odbiór FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 (T03).
Model recenzenta: [rzeczywista tożsamość; nie zgaduj].
Werdykt: [PASS_SCOPED_REVIEW / CHANGES_REQUIRED / INTEGRITY_FAIL / REPLAY_FAIL / EXECUTION_BLOCKED]
Integralność: [piny,85 outputs,INPUTS alias,bootstrap/source,closure].
Mój świeży replay: [matched/expected,exit,czas,receipt].
Mój Sage: [argv .sage,wersja,hashe,preparser,exact/interval checks].
A/B/C/D: [każdy: potwierdzony scope/luka/niezweryfikowany; evidence].
Port/proweniencja: [v3→v4,alias,tabela Z,enclosures,fixtures,stare receipty].
Istotne uwagi i granica dowodu: [severity,plik:linie,wpływ,naprawa].
Co rzeczywiście odebrać: [dokładny partial scope; B-gap i pozostałe otwarte].
Następny krok: [poprawki review lub właściwy missing type,bez automatycznego startu].
REVIEW_W: [pełna ścieżka].
REVIEW.md SHA-256: [64hex].
REVIEW_OUTPUTS.sha256 SHA-256: [64hex].
SOURCE_W po odbiorze: [piny niezmienione albo rozbieżność].
Własne obliczenia zakończone; joby zakończone; owner_accepted=false.
```
