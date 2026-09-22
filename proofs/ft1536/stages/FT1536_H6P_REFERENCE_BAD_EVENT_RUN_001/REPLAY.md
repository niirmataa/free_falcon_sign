# Fresh replay nowego H6P etapu

Standard z katalogu pakietu:

```
python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256
```

External OUTPUTS hash,pełne member hashes,exact scope i SEMANTIC_FILES są
sprawdzane PRZED utworzeniem nowego absolute DEST pod istniejącym W/tmp.
Seed nie zawiera project cache/bin/olean; wszystkie semantic outputs usuwa
się przed fresh jobs. Inputs/provenance/17 source pins i RO mounts są weryfikowane.

Controller z pakietem RO i historical originals ukrytymi:

```
python3 -B scripts/replay_controller.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256
```

Controller wall1800s,każdy job30–240s,single-worker,network-off. Normal8GiB,
Lean-j1/-M2048,GCC14.2/C99/literal-O,Sage10.9. ASan osobno bez AS cap na shadow,
LSan nie deklarowany. HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache tylko pod fresh DEST
na trwałym dysku; pusty historyczny widok to readonly marker,nie project tmpfs.

Recipe odtwarza source numerical V/E/MGF/tail/transfer certificates,complete
noise-map structure,46 mathematical+2 audit Lean modules,original sampling/
post/rint slices,normal i ASan/UBSan controls,independent direct/adjoint/variance
oracles,adaptive MGF examples,mutations i metadata. Nie wznawia dawnego JOINT
research programu,nie uruchamia real seeded PRNG/KeyGen/private loader/Sign/
do_sign/Git lub dudect. SOURCE_ORDER i inne upstream claims są pinned inputs.

Każdy regenerated path/SHA musi odpowiadać SEMANTIC_FILES. Child receipt
REPLAY_RESULT.json: FRESH_REPLAY_PASS,matches[{path,sha256}],jawny game/reference/
event/scope. Przed freeze rehearsal używa tego samego recipe z --anchor i
external hashem artifacts/rehearsal_anchor.sha256. Sealed receipt kopiowany
do artifacts/fresh_replay.json wraz z logs/receipts przed REPORT/RESULT/OUTPUTS.
Po freeze writes tylko do nowego DEST,scope pakietu pozostaje identyczny.
