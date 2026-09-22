# T02.1 — niezależny odbiór suplementu RUN_003, F1–F5

2026-09-22. Autor projektu Niirmata; zachowaj Falcon Project / Thomas Pornin.
Rola: niezależny recenzent wybrany przez właściciela,inny niż wykonawca
suplementu. Podaj rzeczywisty model/kontekst; nie zgaduj tożsamości autora.

```text
REVIEW_ID=FT1536_PRNG_LAYOUT_COUNTER_SUPPLEMENT_REVIEW_001
ROADMAP_ID=T02.1
REPO=/home/footfalcon/free_falcon_sign
W=REPO/proofs/ft1536/work/FT1536_PRNG_LAYOUT_COUNTER_SUPPLEMENT_REVIEW_001
SOURCE_W=REPO/proofs/ft1536/work/FT1536_PRNG_LAYOUT_COUNTER_RUN_003
PRIOR_W=REPO/proofs/ft1536/work/FT1536_PRNG_LAYOUT_COUNTER_RUN_002
PRIOR_REVIEW=REPO/proofs/ft1536/work/FT1536_PRNG_LAYOUT_COUNTER_REVIEW_001
```

## Piny

Zewnętrzne piny RUN_003 przekazał właściciel:
- REPORT `3b7c2b3bbc7f0b72b3a25d3f2cb32623294f1135acb61d8c65b905eefe1a6168`.
- OUTPUTS `e37b1e97ebcfa65d698c52e175c09e826cdbafe565722cc017b5349c00d3f5dc` (141).

Piny poprzedników odczytane przez prowadzącego do TWOJEJ kontroli:
- RUN_002 OUTPUTS `8eda4cb98b754c5f20c8db2a34ff5055bffd535f626dc12d87b56c816406e5a7`.
- RUN_001 OUTPUTS `34c49d61f159d7b55171f51ca85b53e3b7c0a321512cc26102161dfd497f2e6a`.
- PRIOR REVIEW `2e9630e595ce95898ad1fb595e8f88bf734297f205090b91490e80328d68ed2c`.
- PRIOR REVIEW_OUTPUTS `907586d4e86eeeede8a64f8a8100cbb84d2bd879ffc70cabb7295f7856f77f78`.
- TASK `7b0007c095c51b1fe4c5d94b0b1a0012227aba4df0d1c59cfa8fcd92589fe5f1`.
- Bootstrap `03b0612cbe3b18e487bee6399c71c238e5ff3a0527818a7c4330d007b72abae2`.
- Source17 `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
- Sage policy `b6afcdcabb811dd8bc31072455ed9a94a4c4773ec68d41d207ac1d7e98eae241`.

Prowadzący sprawdził141 plików i zewnętrzne piny RUN_003,bez wykonania replayu
lub nowego odbioru matematycznego. Nazwa katalogu ma RUN_003 (underscore).

## Zakres kontroli

1. Sprawdź exact manifests,INPUTS/source/bootstrap i zamrożenie poprzedników.
   Porównaj cały RUN_002→RUN_003; każda różnica ma być wyjaśniona. Nie ograniczaj
   się do zadeklarowanej listy pięciu plików. Oddziel zmiany rachunku od etykiet.
2. Przeczytaj PRIOR_REVIEW/REVIEW.md findings oraz jego wynik,nie tylko handoff.
   F1:scope.open prawdziwie odzwierciedla28 theoremów Lean.
   F2:kernel dowodzi arytmetyki/frame bounds; niepisalność state[56..255]
   i rundy ChaCha nie stają się source-refinement proofem przez poison test.
   F3:17 semantic files,rzeczywiste receipts i prawdziwe liczby plików.
   F4:abandoned_bytes_max/final_unused_bytes_max są poprawnie nazwanymi maximami
   z T01,wraz z warunkami wspólnego eventu,nie twierdzeniami o równości zużycia.
   F5:RUN_003 spójne w bieżących RESULT/CERT/LAYOUT/SEMANTIC; historyczne
   proweniencje zachowują stare ID,bez mechanicznego przepisywania historii.
3. Zwiąż wszystkie cytowane źródła/komendy/outputs,zwłaszcza końcowe `.sage`
   i formal/CounterLayout.lean. Zadeklarowane unchanged numbers396/25408/
   406528/896/936 sprawdź względem pinu poprzednika. Zmiana matematyczna wymaga
   adekwatnego poszerzenia odbioru i jawnego zapisania tego faktu.
4. Utwórz własny seed z sealed members i input closure,własny cache/build.
   Przeczytaj scripts/replay.py i REPLAY.md przed wykonaniem. Standard:

```text
python3 -B scripts/replay.py ABSOLUTE_NEW_DEST e37b1e97ebcfa65d698c52e175c09e826cdbafe565722cc017b5349c00d3f5dc
```

   Uruchamiaj z własnej poprawnie odtworzonej kopii,nie z SOURCE_W. Pełna
   walidacja manifestu przed DEST,17 faktycznie wyprodukowanych semantic files,
   fresh Lean/C/Sage build. Skopiowane expected outputs/cache nie są wynikiem.
   Zachowaj wszystkie raw stdout/stderr,exit i source hashes przed/po.
5. Własny checker liczb,jeśli potrzebny,wykonuj jako `sage lemma.sage`.
   W-only/network-off,HOME/TMPDIR/DOT_SAGE/XDG/cache pod trwałym W,bez /tmp/
   tmpfs. Single-worker8GiB,Lean-j1/-M2048,ASan osobno,wall1800s. Bez sieci/
   instalacji,Git/push,subagentów/relay,KeyGen/Sign/dudect lub innych W.

## Nowy standard B20 i wynik

To krótkie domknięcie historycznego suplementu,nie certyfikat pełnej
kernelizacji PRNG. REPORT RUN_003 jawnie zostawia rundy ChaCha/source frame
poza kernelem. Nowy standard SageMath+Mathlib+Lean4 wymaga domknięcia tych
obowiązków w **B20/P03**. Nie opisuj tego pakietu jako KERNEL_COMPLETE i nie
traktuj poison/C fixtures/tekstu jako formalnego refinementu.

Oddaj REVIEW.md,REVIEW_RESULT.json,DIFF_AUDIT.md/.json,CHECKLIST_F1_F5.md,
INTEGRITY.json,REPLAY_CHECKS.json,COMMANDS/receipts/raw logs,INPUTS.sha256
i REVIEW_OUTPUTS.sha256. Werdykt PASS_SCOPED_SUPPLEMENT / CHANGES_REQUIRED /
INTEGRITY_FAIL / REPLAY_FAIL / EXECUTION_BLOCKED. Przy PASS wpisz osobno
`kernel_complete=false`,`B20_P03_formalization_required=true` oraz dokładny
accepted historical scope. T02 parent/real PRNG→IID/security pozostają OPEN.

Nie poprawiaj frozen danych. Zakończ joby; handoff po polsku z modelem,
F1–F5,real diff scope,własnym replayem,pozostałymi formal obligations i pełnymi
SHA REVIEW.md/REVIEW_OUTPUTS. owner_accepted=false,push_authorized=false.
