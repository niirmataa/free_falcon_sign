# Standard replay BINARY_TOWER

Pre-freeze rehearsal PASS175/175, osobny semantic pin:
`8ddee387b0092e5add4ca5704e6d81330862f3e363852e5432caa3524a3c5fc7`.
Bez hash cycle; to nie finalny OUTPUTS SHA.

```sh
python3 -B scripts/replay.py /ABSOLUTE/COPY/tmp/new-run EXTERNAL_OUTPUTS_SHA256
```

External pin, każdy OUTPUTS member, safe paths/no symlinks/duplicates i
binding archived matches są sprawdzane przed utworzeniem DEST. Nowy DEST
pod tmp, bez carried olean/cache/bin. Jobs rebuild30 Lean modules, normal C,
ASan/UBSan, Half values, all-path QQ certificate, all-level QQ/RBF oracle,
source binding/ledger/toolchain. Porównują wszystkie175 matches.

Source/bootstrap readonly, cache/HOME/TMPDIR/DOT_SAGE/LEAN_PATH pod DEST,
skończone wall/CPU limits≤240s, normal8GiB, Lean -j1 -M2048. ASan controller
nie może odziedziczyć twardego8GiB limitu; child normal jobs narzucają go
osobno. Nie potrzeba starych W, Dokumenty/H/USB lub worktree. FPEMU_AUDIT
nie jest zależnością. Pełne rehearsal streams/receipts należą do OUTPUTS.

Proof texts pozostają jawnie analitycznym source bindingiem. Byte identity
nie jest kernel verification ich całego argumentu; receipt zachowuje mixed
scope oraz odrębne A/B/global flags.

Po freeze:
```sh
python3 -B scripts/verify_final.py EXTERNAL_OUTPUTS_SHA256
python3 -B scripts/post_freeze.py /ABSOLUTE/COPY/tmp/final_standard_001 EXTERNAL_OUTPUTS_SHA256
python3 -B scripts/verify_final.py EXTERNAL_OUTPUTS_SHA256
```
Frozen W readonly, tylko tmp writable, Dokumenty/stages ukryte. Pełny standard
receipt i streams są w DEST/POST_FREEZE.json. Frozen files nie są dopisywane.
