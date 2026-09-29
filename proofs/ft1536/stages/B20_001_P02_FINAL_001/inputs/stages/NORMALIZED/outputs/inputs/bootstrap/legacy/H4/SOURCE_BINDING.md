# Source binding for H4

All line references below apply to the SHA-256-pinned sources in
`INPUTS.sha256`.

## KeyGen predicate

`build/falcon-keygen.c` defines the inclusive leaf bit interval at lines
7444--7446.  `ft_keygen_leaf_certificate` constructs 768 primary values,
stores the 768 reciprocal values in reverse order, scans all `n = 1536`
entries, and accumulates any range failure (lines 7690--7776).  A failed
certificate executes `continue` before the successful loop exit (lines
8108--8120).  Hence every key returned by this source passed the gate.

## Signer-tree identity

`build/falcon-sign.c` independently reconstructs the stable list from the
encoded `f,g` in `ft_build_stable_certified_leaves` (lines 834--895), using
the same primary transform, reciprocal ordering, constants and full scan.

The expanded-key path then calls:

```c
stable_ok = ft_build_stable_certified_leaves(..., &stable_leaves, ...);
sigma = fpr_of(FT1536_SIGNING_SIGMA);
tree_words = ffLDL_ternary_normalize(
    tree, sigma, logn, stable_leaves, &leaf_count);
return stable_ok && leaf_count == n && tree_words == (size_t)12 * n;
```

Within `ffLDL_ternary_normalize_inner`, every terminal is overwritten in
depth-first order by:

```c
tree[2] = fpr_div(sigma, fpr_sqrt(leaves[(*leaf_index) ++]));
tree[3] = fpr_div(sigma, fpr_sqrt(leaves[(*leaf_index) ++]));
```

The complete normalization returns the consumed `leaf_index`; expansion
requires it to equal 1536 and the traversed tree size to equal `12*1536`.
The matching sampling recursion reaches a terminal and reads `sigma =
tree[0]`.  Therefore each stored signing-tree leaf parameter is the width
derived from exactly one gated `D_i`, in the same order.

One ternary base call also uses `fpr_IW1I * sigma` for the paired coordinate.
H4, as scoped, concerns the 1536 stored ffLDL tree widths
`sigma_i = 768/sqrt(D_i)`; the paired-coordinate scaling is a separate
sampler-coordinate transform and is not silently folded into `D_i` here.

## Exact interval

For positive finite binary64 values, unsigned payload ordering is numerical
ordering.  The gate endpoints decode exactly as

```text
D_min = 4503601027220343 / 4398046511104
D_max = 356537342113749 / 1073741824.
```

For every gated leaf:

```text
768^2 / D_max = 70368744177664 / 39615260234861
                  = 1.776303973783826... >= 1.7203,

768^2 / D_min = 864691128455135232 / 1501200342406781
                  = 575.9998209624905... < 595.19.
```

The margins also absorb the final correctly-rounded binary64 `sqrt` and
division used to store the tree width; the certificate records the endpoint
payloads of that operation separately from the ideal rational identity.
