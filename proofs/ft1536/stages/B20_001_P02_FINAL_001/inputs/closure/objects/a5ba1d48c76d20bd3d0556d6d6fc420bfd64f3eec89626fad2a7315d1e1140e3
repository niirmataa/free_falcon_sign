# Standard fresh replay

```
python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256
```

DEST: nowy absolutny katalog pod istniejącym W/tmp. External SHA-256 i CAŁY
OUTPUTS scope/hashes są weryfikowane przed mkdirDEST. Bootstrap i publiccopied
inputs są odtwarzane z packagecopies,nie z historycznych absolutnych origins.
SEMANTIC_FILES enumeruje generated outputs; każdy jest usuwany przed freshjobs.
Nie kopiuje się projectcache/bin/olean. Toolchain jest przypiętą instalacją,
nie projektem do odtwarzania lub pobierania z sieci.

Zewnętrzny RO-package controller:

```
python3 -B scripts/replay_controller.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256
```

Tylko parentfreshDEST writable; sources/IN i frozen packageRO,network-off.
Dokumenty/stages ukryte przez trwałyreadonlymarkerview. Freshjob HOME/TMPDIR/
DOT_SAGE/LEAN_PATH/cache/bin/olean znajdują się wDEST. Singleworker,job30–240s,
controller2400s; normal8GiB,Lean4.34-j1/-M2048,Sage10.9,GCC14.2-O/C99/LP64.
ASan bez hardaddresscap dla shadow,UBSan enabled,LSan nie deklarowany.

23jobs: toolchain; sourceorder/bounds; niezależneQQtrees;6batchesfreshLean;
sourcebinding;2nativebuilds;4publicfixturegenerations;fixturefinalization;
normal/sanitizednativecontrols;mutations;formal audit;metadata.
Każdy generatedpath ma porównany SHA-256 z frozenexpectation. Freshreceipt
REPLAY_RESULT.json zachowuje matches[{path,sha256}], scope i probabilitygame.

Przed freeze ten sam recipe przyjmuje dodatkowy `--anchor` i externalhash
artifacts/rehearsal_anchor.sha256. Sealedcopy actualreceipt powstaje jako
artifacts/fresh_replay.json. REPORT/RESULT/OUTPUTS później,bez hashcycle.
Negatywny check błędnego externalpin ma odmówić PRZED utworzeniemDEST.

Replay nie dowodzi nowejszerszej tezy przez zgodność hashy. Odtwarza source
controls/certificates dla one-rootIID_BUFFER z mixed analytical boundary,
EXIT/supportlimits i otwartym real_PRNGbridge. Brak pełnegoSign/do_sign,
KeyGen/secretloadera,real seeded PRNG,dudect,instalacji lub subagentów.
