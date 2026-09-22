# Niezależny odbiór T02.1 — PRNG_LAYOUT_COUNTER

2026-09-22. Autor projektu Niirmata. Ten prompt przygotowano dla niezależnego
modelu weryfikującego wybranego i ręcznie uruchomionego przez właściciela.
Nie jesteś wykonawcą dowodu. Twoim zadaniem jest ocena wyniku, odtworzenie
obliczeń i znalezienie ewentualnych luk, nie uzyskanie PASS za wszelką cenę.

## 1. Identyfikacja i jednoznaczne role

```text
ROADMAP_ID=T02.1 (odbiór; podzadanie T02 PRNG_REAL_TO_IID_BUFFER)
REVIEW_ID=FT1536_PRNG_LAYOUT_COUNTER_INDEPENDENT_REVIEW_001
REPO=/home/footfalcon/free_falcon_sign
SOURCE_W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_PRNG_LAYOUT_COUNTER_RUN_002
REVIEW_W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_PRNG_LAYOUT_COUNTER_REVIEW_001
TASK=/home/footfalcon/free_falcon_sign/proofs/ft1536/documents/FT1536_ZADANIE_T02_1_PRNG_LAYOUT_COUNTER_2026-09-22.md
AUTHOR_BASE=c90233c171265e050930958fb29bafa9338f81ff
```

Czytaj REPO/AGENTS.md, START_HERE.md, STATE/ROADMAP wyłącznie dla orientacji,
ten prompt oraz przypięte TASK i REPORT autora. Nie wznawiaj zadania autora
ze starych promptów. SOURCE_W tylko do odczytu (RO). Wszystkie Twoje skrypty,
HOME/TMPDIR/TMP/TEMP/DOT_SAGE/XDG_CACHE_HOME/cache/olean/bin/logi/replaye
wyłącznie pod REVIEW_W. **Zakaz systemowego /tmp, /tmp/opencode i tmpfs.**
Jeden recenzent/jeden job naraz, bez subagentów/relay/drugiej sesji. Bez Git,
push, publikacji, dudect, KeyGen/sekretów, pełnego Sign, sieci/instalacji.
Przed startem sprawdź, czy REVIEW_W nie ma aktywnego drugiego odbioru.

## 2. Zewnętrzne piny przekazane przez właściciela

Pochodzą z handoffu autora w czacie. Prowadzący NIE sprawdzał ich bajtów ani
replayu. Ty masz je niezależnie zweryfikować przed i po własnym replayu:

```text
SOURCE_W/REPORT.md:
68a00feea9860f247aed9361336a814818def77e5908061566db28257707944a
SOURCE_W/OUTPUTS.sha256:
8eda4cb98b754c5f20c8db2a34ff5055bffd535f626dc12d87b56c816406e5a7
TASK:
7b0007c095c51b1fe4c5d94b0b1a0012227aba4df0d1c59cfa8fcd92589fe5f1
SOURCE_W/inputs/bootstrap/MANIFEST.sha256:
03b0612cbe3b18e487bee6399c71c238e5ff3a0527818a7c4330d007b72abae2
17-file CANDIDATE.sha256:
56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985
POLICY (SageMath):
b6afcdcabb811dd8bc31072455ed9a94a4c4773ec68d41d207ac1d7e98eae241
```

Status autora: **PRNG_LAYOUT_COUNTER_PROVED_FOR_PINNED_SOURCE_MODEL**
(kontynuacja frozen RUN_001, OUTPUTS
`34c49d61f159d7b55171f51ca85b53e3b7c0a321512cc26102161dfd497f2e6a`;
RUN_001 nie jest przedmiotem odbioru — sprawdź jedynie, że pozostał nietknięty).
Receipt autora `SOURCE_W/tmp/postfreeze-001/REPLAY_RESULT.json` (17/17) oraz
`SOURCE_W/artifacts/fresh_replay.json` to historia, nie Twój replay.

## 3. Tezy do oceny — na wejściu WYŁĄCZNIE deklaracje

Zakres: deterministyczny kontrakt pinned modelu (GCC14.2/C99/x86_64 LP64 LE,
`FALCON_LE_U=1`): mapa init56 + dispatch typów (A), exact refill4096
z licznikiem 64-bit i ramką (B), consumer budżetu T01 + q-refill (C).

Deklarowane rezultaty:
- kernel Lean `formal/CounterLayout.lean`: 28 twierdzeń (licznik mod 2^64,
  brak powtórzeń, post counter, wrap vs repeat, instancje F4/F5, `typeOut`,
  offsets layout56/ramki, `r_max` 396, 25408/406528/896/936, `qrefill`);
  czyste logi, aksjomaty [propext, Quot.sound], core-only;
- model Sage exact + wiązanie byte-identical z oryginalnym C na 7 fixtures ×
  3 stages (405 checks, 105 pól), KAT IETF 5/5 (OpenSSL + RFC 8439 §2.3.2),
  mutacje 6 KILLED + 2 NO_OP, 3 buildy C (normal/ASan+UBSan/altbranch);
- finding: komentarz frng.c:198 vs instrukcje (XOR w OSTATNIE 8 B IV);
- T02 jako całość OPEN; real→IID hop, security, dystrybucje poza zakresem.

## 4. Integralność

Zweryfikuj pełny OUTPUTS (142 członków), TASK, INPUTS (61 rekordów, w tym
kopia POLICY `inputs/documents/SAGEMATH_RULE.md`), bootstrap 39/37,
source17, brak traversal/symlinków/duplikatów/mismatchy. Plan semantyczny
(SEMANTIC_FILES.json, 17 plików) porównaj z OUTPUTS. Historię RUN_001
(RUN_001/OUTPUTS `34c49d61…`) sprawdź jako nietkniętą; nie recenzuj jej.

## 5. Własny fresh replay — wykonujesz Ty

Z własnego seed w REVIEW_W (skrypty autora RO-kopią): pełny manifest PRZED
DEST, nowy absent DEST pod REVIEW_W lub replay-work, sandbox bwrap
(network-off, SOURCE_W i obce drzewa ukryte, świeży cache/build),
`python3 -B scripts/replay.py ABSENT_DEST 8eda4cb9…` (OUTPUTS SHA z §2),
bounded single-worker. Zapisz exit/czas, surowe stdout/stderr, argv, wersje
i SHA skryptów; zachowaj failed attempts. Odtwórz 17 plików semantycznych
i porównaj bajty niezależnie od PASS runnera. Receipt autora nie zastępuje
Twojego.

## 6. Właściwy odbiór matematyczny

- **Kernel Lean:** 28 twierdzeń (policz `^theorem `), typy/termy, czyste logi,
  brak sorry/admit/native_decide/Lean.ofReduceBool/aksjomatu celu/supresji;
  `#print axioms` każdego filaru (szczególnie `counters_distinct`,
  `blockCounter_add`, obie implikacje wrapu, `typeOut_other`, `qrefill`).
  Sprawdź, czy rundy ChaCha SĄ poza kernelem i czy granica jest uczciwa
  (SOURCE_MODEL_BINDING.md) — kernelizacja bloku nie jest wymagana, ale jej
  brak nie może być przemilczany.
- **Pułapki semantyczne Sage (obowiązkowo):** sprawdź, czy w `.sage` nie ma
  C-stylowego `^` w znaczeniu XOR (preparser czyta `^` jako potęgę; XOR to
  `^^`), czy literały całkowite trafiające do JSON są owinięte w `int()`
  (Sage Integer nie jest serializowalny) oraz czy rederywacje licznika
  redukują start mod 2^64. Historia RUN_001 zawierała wszystkie trzy błędy —
  potwierdź ich brak w RUN_002 przeglądem kodu, nie wiarą w PASS.
- **Wiązanie C:** przebuduj 3 harnessy (normal -O, ASan+UBSan, altbranch
  `FALCON_LE_U=0`), porównaj całe buf4096/state256/ptr/type/counter +
  canaries/poison/stub (`stub_calls==1`, len 56) + typy {0,1,2,3,−1,99,2^20}
  + determinizm + type0==type1. Wyjaśnij 1-bajtową różnicę stdout
  normal-vs-altbranch (tag `falcon_le_u`) i potwierdź równość pól semantycznych.
- **KAT i fixtures:** proweniencja OpenSSL CLI + oba literały (RFC 8439 §2.3.2,
  classic all-zero); fixtures to publiczne stałe (stub SHAKE), nie losowość;
  mutacje meaningful KILLED z klasami low-counter, no-op czyste.
- **Consumer:** przelicz niezależnie (własny `.sage` przez `sage file.sage`,
  exact ZZ): `r_max` 396, 25408, 406528, 896/936, spójność z ghost budget T01,
  q-refill; `Pr(H^c)` zostaje w T01. Rozróżnij wrap wewnątrz stage (F4/F6)
  od końca na wrapie (F5, flaga `[]` — poprawnie).
- **Zakazy awansu:** 56 B to nie klucz 448-bit, mały block count to nie
  pseudorandomness, determinizm to nie atak; brak tezy o real→IID hop,
  security, całym Sign, T02.

## 7. Artefakty i werdykt

W REVIEW_W: REVIEW.md, REVIEW_RESULT.json, CHECKLIST.md, INTEGRITY.json,
REPLAY_CHECKS.json, NUMERIC_CHECKS.json, źródła własnych checkerów `.sage`,
COMMANDS.log, pełne logi/receipts, REVIEW_OUTPUTS.sha256 (bez cache/olean/
bin/sekretów). Zwiąż subclaim→evidence; zachowaj findings i failed routes.

- **PASS_SCOPED_REVIEW**: własny replay + pozytywne subclaimy potwierdzone;
  dokładny PARTIAL/kernel scope jawny (w tym nie-kernelizowane rundy).
- **CHANGES_REQUIRED**: luka/błąd/nieprawdziwy zakres (plik:linie, naprawa).
- **INTEGRITY_FAIL**: pin/set mismatch (w tym MANIFEST z §2) lub brak wejścia.
- **REPLAY_FAIL**: świeża próba nie przechodzi (oddziel env od mismatch).
- **EXECUTION_BLOCKED**: konkretny blocker, bez odbioru na niby.

## 8. Dokładna odpowiedź dla właściciela

```text
Zakończyłem niezależny odbiór FT1536_PRNG_LAYOUT_COUNTER_RUN_002 (T02.1).
Model recenzenta: [rzeczywista tożsamość].
Werdykt: [PASS_SCOPED_REVIEW / CHANGES_REQUIRED / INTEGRITY_FAIL / REPLAY_FAIL / EXECUTION_BLOCKED]
Integralność: [piny, 142 outputs, INPUTS, bootstrap/source, RUN_001 nietknięty].
Mój świeży replay: [matched/expected, exit, czas, receipt].
Mój Sage/Lean: [własne checkery, kernel-audit 28 thm, aksjomaty, pułapki ^/int/wrap].
A/B/C + kernel: [każdy: potwierdzony scope/luka; evidence].
Istotne uwagi i granica: [severity, plik:linie, wpływ, naprawa].
Co rzeczywiście odebrać: [dokładny scope; rundy poza kernelem; T02 OPEN].
Następny krok: [bez automatycznego startu].
REVIEW_W: [pełna ścieżka].
REVIEW.md SHA-256: [64hex].
REVIEW_OUTPUTS.sha256 SHA-256: [64hex].
SOURCE_W po odbiorze: [piny niezmienione albo rozbieżność].
Własne obliczenia zakończone; joby zakończone; owner_accepted=false.
```
