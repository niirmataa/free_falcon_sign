# S20-H4-LEAF-FLOOR-CERT-001 — final candidate handoff

Status: `CANDIDATE_READY_FOR_REVIEW`. Run: `20260826-a1`.

The source-bound certificate establishes H4 for all 1536 stored FT1536
signing-tree widths:

```text
1.7203 <= sigma_i^2 < 595.19.
```

The pinned KeyGen source accepts a key only after all 1536 stable primary and
reciprocal leaves pass the inclusive binary64 gate

```text
0x4090000053700377 <= bits(D_i) <= 0x4114444d1a037d50.
```

Those endpoints decode exactly to

```text
D_min = 4503601027220343/4398046511104,
D_max = 356537342113749/1073741824.
```

Consequently exact rational arithmetic gives the stronger ideal interval

```text
70368744177664/39615260234861
    <= 768^2/D_i
    <= 864691128455135232/1501200342406781,

1.776303973783826... <= 768^2/D_i <= 575.9998209624905... .
```

The actual `fpr-double` endpoint replay also passes.  The stored widths at
`D_max` and `D_min` have payloads `0x3ff55311b09aeb8c` and
`0x4037ffffc16bfe5c`; their exact-real squares remain inside the claimed H4
interval.

The essential identity is already present in pinned `build/falcon-sign.c`.
It rebuilds the same stable 1536-element primary/reciprocal sequence from the
decoded `f,g`, enforces the same gate, and makes
`ffLDL_ternary_normalize` consume the sequence in order while writing
`768/sqrt(D_i)` to the terminal tree words.  Expanded-key loading requires
`stable_ok`, `leaf_count == 1536`, and `tree_words == 12*1536`; the sampler
base case reads the resulting `tree[0]` width.  Thus no private-tree replay
or new key generation is required.

The old proof route from only `D > 991` is rejected.  Its exact endpoint is

```text
768^2*991/18433^2 = 584515584/339775489
                    = 1.720299441611575... < 1.7203,
```

with cross-product difference `-1897267`; `D = 991.0001` is an explicit
counterexample to that weaker implication.  This negative result is retained
and replaced by the direct, stronger source gate above.

An independent parser and exact-arithmetic checker reproduced the result.
Both certificates rejected all 11 mutations with source-hash enforcement set
to `AUTO`: five KeyGen mutations and six signer/tree/sampler mutations.  The
complete commands, exit codes, stdout/stderr and hashes are in
`COMMANDS.log`, `artifacts/`, and `OUTPUTS.sha256`.

This is candidate evidence only.  It does not set owner acceptance, change
`SOURCE_OF_TRUTH.md`, modify either C source, access private material, or
claim the complete security theorem.  The paired sampler coordinate using
`fpr_IW1I * sigma` is a separate transform; H4 here concerns the 1536 stored
ffLDL tree widths exactly as scoped.
