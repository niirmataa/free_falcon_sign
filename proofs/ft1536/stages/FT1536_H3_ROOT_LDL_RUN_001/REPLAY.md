# H3_ROOT_LDL — samowystarczalny replay

Pre-freeze rehearsal: PASS131/131; osobna kotwica semantic_manifest:
`1964516eab731ba96243be8544930d2cff6198a677d24e90d55b52c9637bf60b`.
Nie jest to końcowy pin OUTPUTS i nie tworzy hash cycle.

Standard, ze świeżej kopii:
```sh
python3 -B scripts/replay.py /ABSOLUTE/COPY/tmp/new-run EXTERNAL_OUTPUTS_SHA256
```

Przed utworzeniem DEST weryfikowany jest zewnętrzny pin, WSZYSCY członkowie
OUTPUTS, safe paths/no symlinks/duplicates oraz binding archived matches.
DEST musi być nowy pod tmp. Kopiuje się przypięte source/input/model proof
texts; olean/bin/cache nie są kopiowane. Generated inputs/slices odtwarzają
się z source, nie są przenoszone jako gotowy wynik.

Jobs: kernel rebuild17 modules, normal/sanitizer C, Lean mul/div execution,
Sage QQ/RBF/FFT map, emitted NTT/algebra certificate, independent oracle,
source binding, ledger i toolchain. Każdy ma skończony wall/CPU limit,
normal8GiB, Lean -j1 -M2048. ASan ma osobny virtual-shadow mode; controller
nie może odziedziczyć twardego8GiB limitu. Jobs montują bootstrap/source RO,
HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache są pod DEST.

Po jobs porównuje się wszystkie131 matches, nie sam napis PASS. W nowym
DEST powstaje REPLAY_RESULT.json, full commands/stdout/stderr i finite
control receipts. Pre-freeze receipt artifacts/fresh_replay.json oraz
matches należą do OUTPUTS. Dokumenty ANALYTIC_PROOF/EMITTED_BINDING/ROOT_FRAME
są uniwersalnym dowodem analitycznym; ich byte identity NIE jest kernelowym
sprawdzeniem wszystkich argumentów. Ten zakres zapisuje też receipt.

Nie są wymagane Dokumenty/H/USB, stare W lub tymczasowy worktree. Finalny
kontroler do odtworzenia wyłącznie pod tmp, przy frozen W readonly:
```sh
python3 -B scripts/verify_final.py EXTERNAL_OUTPUTS_SHA256
python3 -B scripts/post_freeze.py /ABSOLUTE/COPY/tmp/final_standard_001 EXTERNAL_OUTPUTS_SHA256
python3 -B scripts/verify_final.py EXTERNAL_OUTPUTS_SHA256
```
Kontroler ukrywa Dokumenty i stages, zachowuje DEST/POST_FREEZE.json oraz
pełne streams i ponownie sprawdza manifest. Po freeze niczego nie dopisuje
do frozen report/result/manifest; wynik standard jest w nowym DEST.
