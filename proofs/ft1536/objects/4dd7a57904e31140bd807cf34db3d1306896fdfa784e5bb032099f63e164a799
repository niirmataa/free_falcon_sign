# Świeży replay z zewnętrznym pinem

Standardowy interfejs, wywoływany z katalogu pakietu:

```
python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256
```

DEST musi być nieistniejącym absolutnym dzieckiem istniejącego W/tmp/.
Najpierw sprawdzane są zewnętrzny hash OUTPUTS, wszystkie member hashes,
exact declared scope, brak symlinków/escapes i semantic manifest. Dopiero
potem tworzony jest DEST. Seed nie zawiera bin/cache/olean. Generated semantic
files są usuwane, source/inputs są lokalnymi kopami RO; bootstrap/provenance
i toolchain są ponownie weryfikowane. Każdy computational job ma własny bounded
W-only/network-off sandbox.96 inherited+4 new+2 audit modules budowane świeżo,
potem QQ certificate, source slices, oba C builds,59 cases/build, direct RBF
inverse,mutations,audit,metadata. Wszystkie semantic paths porównywane SHA256,
nie tylko zbiorczy napis PASS. Receipts/stdout/stderr pozostają w DEST.

Gotowy RO controller (ukrywa Dokumenty i stages) uruchamia ten sam standard:

```
python3 -B scripts/replay_controller.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256
```

Controller nie dziedziczy celowo hard RLIMIT_AS=8GiB: normal jobs dostają go
we własnym run.py, sanitizer wymaga wolnego address space na shadow. Controller
ma wall timeout1800s; każdy job30–240s, jedna praca naraz. Brak sieci/instalacji,
HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache tylko pod fresh DEST. Brak starych originals
potrzebnych do obliczeń, brak Git, PRNG/KeyGen/private API lub dudect.

Przed freeze rehearsal używa dokładnie tego samego recipe z
`ABSENT_DEST ANCHOR_SHA --anchor`, gdzie anchor=artifacts/rehearsal_anchor.sha256.
Pin jest podany z zewnątrz; pełny manifest jest sprawdzany przed DEST. Rehearsal
jest archiwizowany przed REPORT/RESULT/OUTPUTS, więc nie ma cyklu. Po freeze
controller ma cały pakiet RO i tylko nowy DEST writable. Wynik historyczny
PARTIAL_PROOF pozostaje PARTIAL_PROOF także po poprawnym replayu.
