# Fresh standard replay — PARTIAL_PROOF

Z katalogu pakietu, przy istniejącym tmp i nowym ABSENT_DEST pod nim:

```sh
python3 -B scripts/replay.py /ABS/PACKAGE/tmp/replay_001 EXPECTED_OUTPUTS_SHA256
```

External pin i cały manifest są sprawdzane PRZED utworzeniem DEST. Existing
DEST/symlinks/escapes lub niezgodne bytes są błędem. Seed kopiuje tylko public
inputs/sources/docs/recipe, bez project bin/olean/cache. Nie czyta oryginalnych
Dokumenty/stages/innych W; provenance paths są danymi.

Jeden worker kolejno odtwarza source/profile/slices, right/failed bounds,
scalar domains,signed transfer QQ/RBF certificate,28 Lean modules i audyt,
8 ordered fixtures, native normal/ASan/UBSan,504 scalar cases, mutations
i partial certificate. Wymagane225 path/SHA matches i ponowna weryfikacja
oryginalnego manifestu. DEST/REPLAY_RESULT.json ma FRESH_REPLAY_PASS i pełne
matches; archiwizer porównuje je oraz actual bytes z archived fresh_replay.
Ten wynik odtwarza **PARTIAL_PROOF**, nie promuje go do global Reach.

Linux x86_64 LP64, GCC Debian14.2.0-19, Python3.13.5,bwrap,Sage10.9 oraz
Lean4.34/Std pod ścieżkami TOOLCHAIN. Bez sieci/instalacji. Każdy child ma
W-only/network-off,bootstrap/source RO, lokalne HOME/TMP/DOT_SAGE/cache/bin/
olean. Jobs≤240 s, normal8GiB,Lean-j1/-M2048,ASan osobno bez address-space
cap (LSan false). Controller nie może dziedziczyć hard RLIMIT_AS8GiB.
Lokalny rehearsal trwał76.073 s; archive outer watchdog może wynosić600 s.

Pre-freeze --rehearsal weryfikował osobną kotwicę
artifacts/rehearsal_inputs.sha256:
`c1b333c63fc94ff27d37f11e5eab8acd99981461317f403a6835f77f8d10dde1`.
225/225 matches i194 nowe receipt/stream copies są zarchiwizowane. Kotwica
nie obejmuje swojego hasha, replay result lub późniejszego raportu.

`python3 -B scripts/final_control.py replay EXPECTED_OUTPUTS_SHA256`
sprawdza standard po freeze z pakietem RO, writable tylko nowy
tmp/final_replay_001, Dokumenty/H/stages ukryte RO,limit240 s. Nowe argv/
limits/exit/streams pozostają w tym DEST; OUTPUTS i frozen COMMANDS są nietknięte.

Harness używa samej oryginalnej ffSampling recursion i jawnie scripted
abstract callbacks; nonreturn to prefix stop, fault0 nie jest normal sample.
Nie wykonuje całego do_sign/Sign, realnego PRNG rejection loop, KeyGen,
private loadera lub dudect. Probabilistic law/emitted membership fixtures
nie są wynikiem replayu. Po weryfikacji żaden worker nie pozostaje aktywny.
