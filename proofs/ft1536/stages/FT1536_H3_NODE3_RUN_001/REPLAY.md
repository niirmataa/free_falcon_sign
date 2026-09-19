# Standardowy replay NODE3

Rehearsal PASS123/123. Osobny pre-freeze semantic pin:
`e76d99d9c8653590674041ee6a5a22962e7be1c0c69f8a5945f519649a78bd5b`.
Nie jest to końcowy hash OUTPUTS; receipt nie tworzy hash cycle.

```sh
python3 -B scripts/replay.py /ABSOLUTE/COPY/tmp/new-run EXTERNAL_OUTPUTS_SHA256
```

Przed tworzeniem nowego DEST pod tmp: external pin, cały OUTPUTS, safe paths,
no symlinks/duplicates i binding matches. Nie przenosi się olean/bin/cache.
Replay odbudowuje21 modułów, C normal/ASan/UBSan, wykonuje Lean scalar values,
QQ/number-field/RBF certificates/oracle, source binding, ledger i toolchain.
Generated slices są odbudowane ze źródeł. Wszystkie123 matches są porównane,
nie sam status. Nie potrzeba starego W, Dokumenty/H/USB ani worktree.

Bootstrap/source readonly; cwd/HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache pod DEST.
Jobs mają wall/CPU limits≤240s, normal8GiB, Lean -j1 -M2048. ASan ma osobny
virtual-shadow mode; parent controller nie może dziedziczyć twardego8GiB.
Pełne receipts/streams są pod artifacts/rehearsal i zapisane w OUTPUTS.

Analytical proof documents są kopiowane identycznie, ale ich kopiowanie nie
jest kernel certification. Source spectral/error composition pozostaje
jawnie mixed proof, jak w REPORT/RESULT/REPLAY_RESULT.

Po freeze:
```sh
python3 -B scripts/verify_final.py EXTERNAL_OUTPUTS_SHA256
python3 -B scripts/post_freeze.py /ABSOLUTE/COPY/tmp/final_standard_001 EXTERNAL_OUTPUTS_SHA256
python3 -B scripts/verify_final.py EXTERNAL_OUTPUTS_SHA256
```
Kontroler uruchamia standard protocol z W read-only i tylko tmp writable,
ukrywa Dokumenty/stages, zachowuje DEST/POST_FREEZE.json i pełne streams.
Manifest jest ponownie sprawdzany. Po freeze nie zmienia się report/result
lub OUTPUTS; standardowy receipt pozostaje w nowym DEST.
