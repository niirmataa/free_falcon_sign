# BATCH_013 — B1.03 phase 1 (frontend, callees, REV10, order 9216/4608)

Window scope (owner): EXCLUSIVELY B1.03 (twiddle-table generation and
memory layout). Frozen at a staged-roadmap iron-rule-3 recoverable
mid-point: the frontend and all value/order/data certificates are closed
and green, the mkgm3 body binding has one open parse mismatch, and the
row-law/execution/memory work of B1.03 continues next window.

## What is proved (kernel, no sorries, no oracle)

1. **Frontend (accepted/clean in `keygen_mkgm3_frontend_011`).** The
   modular layer now covers exactly the syntax of `modp_mkgm3` and its
   callees: five-argument calls (`Expr.call5` for `modp_div`), the mixed
   index stores `gm[b + REV10[u << k]] = x` (`Stmt.storeRev` + `Exec`
   rule with the exact `base + zext(table[index]) mod 2^64` offset),
   `return expr;`, `++`/`--` statements, `--` for-increments (two single
   `-` tokens: `LeafScan.tokenize` merges only `++`), and the state-exact
   `while (k ++ < 11)` desugaring documented in `C99ModularParser`
   (loop with pre-body increment + trailing increment of the failing
   test: identical states at every test, body entry and exit, even for
   bodies that read or write the counter).
2. **Call strata without mutual inductives.** `LeafCall` executes the six
   pinned scalar leaf bodies (montymul/add/sub/ninv31/set and the new
   `modp_R`); `GenEval`/`GenExec` are parameterized by the call relation
   (the `C99ScalarReference.CallRelation` pattern), so all existing
   induction-based consumers keep working; `ModCall` = leaves + the
   composite modular callees `modp_R2`/`modp_div`, whose hand-built body
   statements `r2Code`/`divCode` execute under `LeafCall` (`r2Body`/
   `divBody`). This replaces an earlier mutual-block draft (retained in
   `_006`/`_007`) after `induction` refused the mutually inductive `Exec`.
3. **`modp_R` binding + value law.** Pinned body parses to `code`;
   `model_exact`/`checked`/`source_exists`/`source_exact`; `value_law`:
   the word `(1 << 31) - p` is `2^31 mod p` for `2^30 < p < 2^31`
   (R = 127999 at p = 2147355649).
4. **Generator order 9216/4608 — CHECKED, not assumed.** Kernel `decide`
   over Nat: `g^9216 = 1`, `g^4608 = p-1 != 1`, `g^3072 != 1` (exact
   order 9216 = 2^10*3^2) and `(g^2)^4608 = 1`, `(g^2)^2304 = p-1 != 1`,
   `(g^2)^1536 != 1` (exact order 4608 = 2^9*3^2). This discharges the
   plan's proof obligation for the M0 squaring at logn 10.
5. **REV10 data.** Source header/tail pins; `bitrev10` model and the
   `rawTable` extractor over the pinned 86 table lines. The 1024-entry
   exactness equality is retained as a FAILED reduction (single kernel
   `decide` exceeds kernel memory, `_007`); the certified route is the
   established checked-chunk decomposition (FFT-table precedent).

## Open at the freeze boundary (exact)

- `KeygenMkgm3Callees.div_source_bound`: `C99ModularParser.region 2642 26
  = some divCode` is FALSE (`r2_source_bound` passes exactly). One
  statement of the hand-built `divCode` tree differs from the parser
  output of the pinned `modp_div` body. Candidates recorded in
  BATCH_013.json. Failed reductions retained in `_010`/`_011`.
- `KeygenMkgm3Program.source_bound` and the remaining 17 closure modules
  (KeygenNtt*, KeygenResidue*) are untested at the freeze.
- B1.03 Acceptance remainder: r2 exact value law, per-row exponent/order
  laws + Montgomery scale from executed stores, canonical ranges,
  `igm=ft` overwrite with gm/material preservation, extents and
  non-overlap from the caller layout.

## Evidence

- Job `keygen_mkgm3_frontend_011`: 17/34 accepted/clean before the open
  boundary (logs 0/0 each). RECEIPTS SHA256
  `3ca613d70be08968f902e729705754f687b5224e0286da1d46578dda4f381cdd`;
  SOURCE_INPUTS SHA256
  `7772a7a79458d5d37281e6c7f7ab8898567232449ad76df909bf4c0eeb0c5ade`.
- Retained FAILED attempts `keygen_mkgm3_frontend_001`..`_010` (never
  cited as PASS): module-order requirement, pinned-line offset discovery
  (keygenLines index = file line − 4), simp unused-argument lints,
  `word_toNat` kernel memory (fixed via `BitVec.toNat_sub` chain),
  `C99IntegerReference.Ty` naming, mutual-induction refusal, 1024-entry
  `decide` kernel memory, two missing `storeRev` alternatives, `divCode`
  parse mismatch.
- Input pins re-verified before new work: 18/18 named BATCH_011/012 pins
  MATCH (incl. the owner-pinned SOURCE_INPUTS `17b98f37…` of
  `keygen_ntt_middle_rounds_002`) and all six source closures byte-exact.
- Runner byte-identical (`3bc29bf7…`); no push (owner signal absent).
