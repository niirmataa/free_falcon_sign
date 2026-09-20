# Fresh standard replay INITIAL_TARGETS

W katalogu pakietu, istniejący tmp i nowy ABSENT_DEST pod nim:

```sh
python3 -B scripts/replay.py /ABS/PACKAGE/tmp/replay_001 EXPECTED_OUTPUTS_SHA256
```

External pin i pełny manifest są sprawdzane PRZED utworzeniem DEST; istniejący
DEST, symlinki/escapes i niezgodne bajty są błędami. Seed obejmuje potrzebne
publiczne inputs/code/docs, bez project cache/olean/bin. Nie czyta dawnych
Dokumenty/stages/innych W; provenance paths są danymi, nie fetch locations.

Jeden worker odtwarza source/profile/cut binding, exact QQ/RBF FFT18432 i
target certificates,21 modułów Lean/audity,11 fixture models, C normal oraz
ASan/UBSan, independent direct polynomial/QQ oracles, executed mutations,
ledger i finalny certificate. Porównuje219 semantic path/SHA i ponownie
weryfikuje oryginalny manifest. DEST/REPLAY_RESULT.json musi mieć
FRESH_REPLAY_PASS i pełne matches. Archiwizer sprawdza też rzeczywiste bajty
względem przypiętego artifacts/fresh_replay.json, nie sam status.

Wymagane Linux x86_64 LP64, GCC Debian14.2.0-19, Python3.13.5, bwrap,
Sage10.9 i Lean4.34.0/Std pod ścieżkami TOOLCHAIN. Bez sieci/instalacji.
Każdy bounded child ma własne W-only/network-off, bootstrap/source RO,
HOME/TMP/DOT_SAGE/cache/olean/bin w DEST. Jobs≤240 s, normal8GiB,
Lean-j1/-M2048, ASan bez virtual-address cap. Controller nie może dziedziczyć
hard RLIMIT_AS8GiB (shadow ASan); LSan false. Standard archiwizera może
użyć outer watchdog600 s. Lokalny rehearsal trwał54.781 s.

## Rehearsal i post-freeze

Pre-freeze --rehearsal weryfikuje osobną kotwicę
artifacts/rehearsal_inputs.sha256:
`f5b50b4d21043f515859ed18863a4abbc1d90168a2979eea9d67062503c1352c`.
Wynik219/219 i156 unikalnych receipt/stream copies są zarchiwizowane.
Kotwica nie obejmuje siebie, wyniku lub późniejszego raportu.

`python3 -B scripts/final_control.py replay EXPECTED_OUTPUTS_SHA256`
sprawdza standard po freeze: pakiet RO, writable tylko nowy tmp/final_replay_001,
Dokumenty/H/stages ukryte RO, outer bound240 s. Pełne receipts w nowym DEST
nie zmieniają OUTPUTS lub frozen COMMANDS.

Replay uruchamia wyłącznie publiczny target-prefix slice kończący się przed
ffSampling. Nie używa fake sampler callback do wykonania reszty Sign i nie
wywołuje całego do_sign/Sign/PRNG/KeyGen/private loadera lub dudect. Synthetic
coefficient/basis fixtures nie są emitted witnesses. Powodzenie replayu
odtwarza materiał dowodowy z jego mixed proof boundary, nie rozszerza scope.
