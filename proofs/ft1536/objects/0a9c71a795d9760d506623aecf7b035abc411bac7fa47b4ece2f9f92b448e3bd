# Parametric task: exact ffLDL_fft3 layout recurrences for the FT family

This is the single real parametric result of this iteration (review item 10.3),
accompanied by its kernel checks (`lean/FTLayout.lean`), exact computations
(`scripts/check_layout.py`, `results/layout.json`, `results/layout.csv`) and
its binding to the pinned sources.

**Scope statement.** Everything below is a property of the *unchanged source
structure* of `Extra/c` (candidate manifest
`56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`)
parametrized by `logn`. It is NOT an implementation, correctness proof or
performance claim for FT768 or FT3072. The code as pinned rejects every
ternary `logn != 10` at `load_skey` (see SOURCE_MAP.md).

## 1. Source binding

| structure | source | recorded shape |
|---|---|---|
| inner node (2-way split) | `falcon-keygen.c` `ffLDL_inner_fft3_keygen` | node of degree `2^k` stores `2^k` L-words then two child trees; base `k = 1` stores 2 L-words + 2 leaf words (returns 4) |
| depth1 node (3x3 LDL) | `falcon-keygen.c` `ffLDL_depth1_fft3_keygen` | `l10,l20,l21` = `3*2^j` L-words then three inner trees of `logn = j-1` |
| top node (trisection) | `falcon-keygen.c` `ffLDL_fft3_keygen` | root `l10` = `3*2^(ell-1)` L-words then two depth1 trees of `logn = ell-1` |
| expanded key / tmp | `falcon-sign.c` `load_skey` comment | `sk` = `3*(logn+6)*2^(logn-1)` words; `tmp` = "at least seven polynomials" |
| frozen N = 1536 instance | `FT1536_H3_RAW_ASSEMBLY_RUN_001/REPORT.md` | 6144 basis, 18432 raw tree, 1536 leaves, 16896 internal L, sk 24576, tmp 10752, gxx at 4608, top scratch 3584, high-water 8192 |

## 2. Recurrences and closed forms

Write `k = logn - 2` for the top node, so `N = 3*2^(k+1)`.

1. **Inner subtree** `S` (logn = r): `S(0) = 1`, `S(r) = 2^r + 2 S(r-1)`.
   Closed form **`S(r) = (r+1) 2^r`** — kernel-checked
   (`FTLayout.srec_closed`).
2. **Depth1 node** at logn = `k+1`: `D(k) = 3*2^(k+1) + 3 S(k)`
   (`FTLayout.dfun_closed`).
3. **Top node** at logn = `k+2`: `T(k) = 3*2^(k+1) + 2 D(k)`. Closed form

   **`T = (logn + 2) * N`**  (`FTLayout.tfun_closed`),

   since `T(k) = 3*2^(k+1) + 2*(3*2^(k+1) + 3(k+1)2^k)
   = 2^(k+1)(9 + 3(k+1)) = (k+4) * 3 * 2^(k+1)`.
4. **Whole expanded key** `sk = 4N (basis) + T = (logn + 6) * N` — identical to
   the `load_skey` comment `3*(logn+6)*2^(logn-1)` (definitionally).
5. **Leaves**: the six inner trees of `logn = k` contribute `2*3*2^k = 6*2^k =
   N` leaf words (`FTLayout.leaf_words_eq`); internal L words `= T - N =
   (logn+1) N`.
6. **Scratch recurrence** for `ffLDL_fft3` beyond the four Gram polynomials
   (from `gxx` at `3N`). The model error of the first draft (a bare
   `W(r) = 2^r + W(r-1)` accepted up to a 2-word "convention") is corrected:
   the node writes `d11` through `t2` in `LDL_dim2_fft3`, i.e. a full `2^r`
   words from the `t2` base, *regardless* of the child recursion depth (at
   `r = 2` the child recursion predicts 6 words while the store needs 8).
   The correct recurrences track the maximum of both consumers:

   `W(r) = max(2^r + W(r-1), 2^(r+1))`, `W(1) = 2`  (inner, logn = r),
   hence `W(r) = 2^(r+1)` for `r >= 2` (kernel: `FTLayout.wrec_closed`);
   `D(k) = 3*2^k + max(2^k, W(k-1))`                (depth1, logn = k),
   hence `4*2^k` in the parametric range;
   `W_top(ell) = 3*2^(ell-1) + max(3*2^(ell-1), D(ell-1))`  (top: the
   `full=1` `d11` store at `t3` is `3*2^(ell-1)` words), hence
   **`7*2^(ell-1)`**.

   Instances: `1792 / 3584 / 7168` scratch words for FT768/FT1536/FT3072,
   and the total indicated range for FT1536 is `3N + 3584 = 8192` words,
   matching the RAW_ASSEMBLY certificate exactly (no residual discrepancy).

## 3. Instance table (8-byte words; bytes = 8 * words)

| quantity | formula | FT768 (logn 9) | FT1536 (logn 10) | FT3072 (logn 11) |
|---|---|---:|---:|---:|
| N | `3*2^(logn-1)` | 768 | 1536 | 3072 |
| basis | `4N` | 3072 | 6144 | 12288 |
| raw tree | `(logn+2)N` | 8448 | 18432 | 39936 |
| raw leaves | `N` | 768 | 1536 | 3072 |
| internal L | `(logn+1)N` | 7680 | 16896 | 36864 |
| expanded key `sk` | `(logn+6)N` | 11520 | 24576 | 52224 |
| `sk` bytes (KiB) | `8*sk/1024` | 90 | 192 | 408 |
| tree bytes (KiB) | | 66 | 144 | 312 |
| tmp allocation | `7N` | 5376 | 10752 | 21504 |
| tmp bytes (KiB) | | 42 | 84 | 168 |
| ffLDL scratch from gxx | `7*2^(logn-1)` | 1792 | 3584 | 7168 |
| scratch high-water (incl. 3N Gram) | `3N + scratch` | 4096 | 8192 | 15360 |

Every FT1536 entry reproduces the frozen RAW_ASSEMBLY numbers bit-exactly
(`results/layout.json`, `frozen_checks`), including the 12n = 18432 constant
that `falcon-keygen.c` hard-codes (`treesize = 12 * n`) and `load_skey`
re-asserts (`tree_words == 12 * n`). That hard-coding is itself evidence that
the pinned tree code is logn = 10 specific: for `logn = 9` the same recursion
needs `11n`, and for `logn = 11` `13n`.

## 4. What this does and does not establish

* Established (kernel, `lean/FTLayout.lean`): the recurrence identities, the
  closed forms, `T = (logn+2)N`, leaf words `= N`, and all N = 768/1536/3072
  word counts as exact `Nat` values.
* Established (exact computation): recurrence self-checks for logn 3..20
  (`results/layout.json`).
* Established (source audit): the same numbers occur in the pinned code and in
  the frozen RAW_ASSEMBLY certificate for N = 1536.
* NOT established: existence of FT768/FT3072 implementations; correctness of
  KeyGen/Sign at those degrees; timing (the withdrawn "cycle" table is not
  replaced by new timing claims — measured costs are NOT_RUN); that the
  unchanged-structure hypothesis survives future source changes.

## 5. Why this is the right parametric object

The review identified exactly this candidate (item 6): the tree recurrence is
the only cost/layout structure that (a) is fully source-bound, (b) has a
recurrence whose closed form can be checked by a kernel, and (c) reproduces a
frozen, independently replayed certificate (RAW_ASSEMBLY) at the baseline N.
Everything that scales *non*-parametrically in the current evidence — the
numeric domains (`div[1/16, 2^35]`, `|Im D_C| < 32/1`, margins, bank budgets
849346588, the `factor < 6` raw-L/stable-D comparison) is per-instance
certification and reappears in the paper as "requires a new certificate".
