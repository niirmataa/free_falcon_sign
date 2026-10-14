# 089 — public tool tracking supplement

The metadata `git add` was refused by `.gitignore:51:*seed*`, which also
matched the public organizer `tools/keygen_seed089_seal.py`. The following
path-specific commit consequently failed because that one path was not in
the index. The other staged files were this task's files; no foreign staging
was reset or included. No commit was produced by either failed action.

The sealed original tool remains at its original path, unchanged. A
byte-identical public source copy is tracked as
`tools/keygen_law089_seal.py`; SHA256 of both is
`0dc7acac132a0161c56d634c38389d4ebf03ab01cbb6323d7bf48419c38af2c4`.
This file is receipt/audit organization code and contains no seed material.
No ignore rule was weakened, no force-add was used, and no frozen receipt,
postseal, source theorem or proof artifact was changed.

For reconstruction on a fresh checkout, copy the tracked public source
back to the historical organizer path before replaying its seal commands:

```sh
cp proofs/ft1536/development/T12_1/source3/tools/keygen_law089_seal.py proofs/ft1536/development/T12_1/source3/tools/keygen_seed089_seal.py
```

The original path is part of the preserved 089 receipt, so its name is not
silently rewritten. `.build/key_law088/GIT_REFUSAL_089_001.json` records
both refused actions and the resolution. The additive
`POSTSEAL_089_TRACKING.json` rechecks all original pins and adds the public
copy, this supplement and the refusal record. Its hash is in live state.
This changes only reproducibility/tracking metadata; the owner TODO remains
active, with the same mathematical scope and no push.
