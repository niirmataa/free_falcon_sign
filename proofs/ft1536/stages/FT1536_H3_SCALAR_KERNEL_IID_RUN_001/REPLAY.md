# Fresh replay — IID_BUFFER

Standard z katalogu pakietu:

```
python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256
```

DEST jest nowym absolutnym katalogiem pod istniejącym W/tmp. Zewnętrzny hash
OUTPUTS, pełne member hashes, exact scope i SEMANTIC_FILES są sprawdzane PRZED
utworzeniem DEST. No symlinks/escapes. Kopiuje się tylko pinned source/data,
bez project cache/olean/bin; wszystkie semantic outputs są usuwane przed jobs.
Fresh jobs odtwarzają toolchain,30 mathematical+2 audit Lean modules,QQ
certificates,exact source slices,normal/ASan/UBSan builds,wszystkie fixtures,
native outputs,independent Sage QQ oracle,mutations,formal audit i metadata.
Każdy oczekiwany path/SHA jest porównany; status nie jest samym napisem PASS.

Wygodny RO-package controller, z Dokumenty/stages ukrytymi:

```
python3 -B scripts/replay_controller.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256
```

Tylko parent nowego DEST writable. Controller ma wall1800s i nie dziedziczy
hard8GiB AS cap (ASan shadow); każdy normal job ma własne8GiB,CPU/wall30–240s,
Lean-j1/-M2048,single-worker,no network. HOME/TMP/DOT_SAGE/LEAN_PATH/cache pod
fresh DEST. Sanitizer osobno bez AS cap,LSan nie deklarowany. Nie ma realnego
PRNG/seed/key/Sign/dudect execution. Bootstrap/provenance/source17 hashes
i RO mounts są ponownie sprawdzane.

Rehearsal przed freeze używa tego samego recipe z trzecim argumentem --anchor
i zewnętrznym hashem artifacts/rehearsal_anchor.sha256. Wynik child
REPLAY_RESULT.json ma status FRESH_REPLAY_PASS i matches[{path,sha256}].
Po sprawdzeniu kopiowany jest do sealed artifacts/fresh_replay.json wraz
z pełnymi rehearsal logs/receipts, przed REPORT/RESULT/OUTPUTS. Po freeze
replay zapisuje tylko nowy DEST i pozostawia scope pakietu niezmieniony.

Poprawny replay potwierdza odtwarzalność wskazanego wyniku IID_BUFFER;
real_prng_to_iid_bridge_proved=false pozostaje także w świeżym receipt.
