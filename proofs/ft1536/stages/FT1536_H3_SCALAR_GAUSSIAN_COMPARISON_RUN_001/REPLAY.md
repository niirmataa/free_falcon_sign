# Fresh replay z external SHA-256

Standard:

```
python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256
```

DEST jest nowym absolutnym katalogiem pod istniejącym W/tmp. External manifest
pin,pełny zakres/member hashes i SEMANTIC_FILES są sprawdzane PRZED utworzeniem
DEST. Seed nie zawiera project bin/cache/olean; wszystkie generated semantic
files są usuwane, następnie odtwarzane ze source/inputs w fresh jobs.

RO-package controller:

```
python3 -B scripts/replay_controller.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256
```

Tylko parent nowego DEST writable. Dokumenty/stages zasłonięte readonly
marker view z trwałego inputs/hidden_originals; brak project data na tmpfs.
Controller ma wall1800s,każdy job30–240s,single-worker,no network. Normal8GiB,
Lean-j1/-M2048,Sage10.9,GCC14.2 literal flags; sanitizer bez hard AS cap na
shadow,LSan nie deklarowany. HOME/TMP/DOT_SAGE/LEAN_PATH/cache pod fresh DEST.

Recipe: toolchain/source/inputs verification,whole-word reduction,formal
bracket data,34 mathematical+2 audit modules,QQ Bernstein/Taylor,CDF/infinite
tails,comparison/normalization,witnesses,native builds/fixtures/both controls,
101 rigorous Gaussian evaluations,mutations,audit i metadata. Każdy expected
path/SHA porównywany z odtworzonym plikiem, nie tylko z napisem PASS.

Rehearsal przed freeze używa tego samego recipe z argumentem --anchor oraz
zewnętrznym hashem artifacts/rehearsal_anchor.sha256. Child REPLAY_RESULT.json
i sealed artifacts/fresh_replay.json mają FRESH_REPLAY_PASS i
matches[{path,sha256}]. Pełne logs/receipts są zachowane. REPORT/RESULT/OUTPUTS
powstają później,bez cyklu. Po freeze wykonanie tylko do nowego DEST.

Replay odtwarza conditional IID_BUFFER bound i jego ograniczenia: reverse
chi2∞,witnesses bez Emitted membership i real_prng_to_iid_bridge_proved=false.
Nie uruchamia keys/KeyGen/private loadera/Sign/do_sign,seeded PRNG,dudect lub Git.
