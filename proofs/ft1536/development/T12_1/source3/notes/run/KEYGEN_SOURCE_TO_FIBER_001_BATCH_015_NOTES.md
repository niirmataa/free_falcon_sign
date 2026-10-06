# BATCH_015 — B1.03 stage (a): REV10 exactness certificate closed

Window scope (owner): EXCLUSIVELY stage (a), the REV10 certificate closure
per `KEYGEN_RESIDUE_CHECKPOINT.md` section 2 (measured route: 11 chunks of
at most ~8 pinned parse lines plus glue through intermediate facts; kernel
parse granularity ~8 lines per decide — never exceeded). After REV10 the
window closes; (b) `modp_R2` and (c) row laws are separate following
windows.

## 1. REV10 exactness certificate — CLOSED (commit 29e6372b)

`formal/Source3/KeygenRev10Cert.lean` (v4) proves, kernel-only, no sorries,
no oracle:

    rawTable_exact : rawTable = some ((List.range 1024).map bitrev10)

i.e. the 1024 pinned `REV10[]` table entries are exactly the 10-bit bit
reversal `bitrev10 0..1023`. Job `keygen_rev10_cert_004`: accepted/clean,
80.701 s, logs 0/0 bytes, maxrss 3483896 KiB, zero forbidden proof
markers.

Decomposition (checked-chunk pattern of the FFT tables; traps 34/45):

1. **Model side (kept from v3, which had validated it green).** 32
   kernel-decided 32-entry chunks `chunkNN` against `bitrev10`, the
   descending `tail1024..tail0` glue over `map_split`/`map_range_ext`, and
   `tableData_exact : tableData = (List.range 1024).map bitrev10`.
2. **Source side (the former seam).** 11 slice decides `sNN` re-parse AT
   MOST 8 pinned table lines each (the measured granularity of probe
   `keygen_rev10_probe_002`) and bind the literal `rowsNN` candidates to
   the pinned parse. The glue goes through named intermediate statements
   and never re-parses: `region_split` (a `take_split` ladder with
   congrArg/rfl steps), `mapM_join` (core `List.mapM_append` over the slice
   facts), `flat_lit` (32 pure 32-entry comparisons + `eq_of_split`
   ladder), `table_data` (`congrArg some`).
3. **Assembly.** `rawTable_exact` is `table_data` composed with `congrArg
   some tableData_exact`.

Literal candidates (`tableData`, `rowsNN`) are generator output and are
UNTRUSTED by design: every one of them is re-checked by the kernel on every
build. `rowsNN` were extracted from the pinned `KeygenSource.lean` bytes
(region lines 2674..2759) by a plain decimal scan; the generator is pinned
(sha256 `f91ae57d…`). The v3 draft survives as a byte-copy in the retained
job dir `keygen_rev10_cert_003` (sha256 `de0dd401…`).

## 2. v3 helper fixes (the old section 2 item 3), all validated by probes

- `map_split` zero/succ cases: `Nat.add_zero`/`Nat.add_succ` instead of
  `omega` (trap 47: `Nat.add` recurses on its second argument in this
  toolchain, and omega treated the `Nat.zero` spelling as an opaque atom).
- `map_some_iff`: DROPPED (its `Option.noConfusion` application hit a
  universe mismatch; the new assembly does not extract a witness from
  `rawTable`, so the lemma is no longer needed).
- `List.drop_length` applied bare (it carries an implicit `{l}`); v3
  applied it as a function (trap 48).
- tail992's final step is `List.append_nil _`. The old
  `rw [show 32 = 32 + 0 …]` rewrote BOTH `32` occurrences and mangled the
  goal (trap 46).

## 3. Probe history (retained; nothing cited as PASS before its job)

- `keygen_rev10_probe_003/004/005`: retained FAILED attempts on the
  `take_split` proof shape (rfl-grade base cases without `Nat.add`
  normalization, then single-instance `rw` in `succ.nil`). Each run
  de-risked one mechanism; the final shape is `simp only` with the full
  lemma set.
- `keygen_rev10_probe_006`: accepted/clean — the transient module
  `KeygenRev10CertProbe` validated `take_split`, the congrArg/rfl region
  ladder, the `mapM_append` glue over two REAL slices (first-line shape and
  the last line's no-trailing-comma shape, validating the `rowsNN`
  extraction), the fixed `map_split`, the tail992 replacement step and the
  drop-length side conditions. Module deleted after use and its
  runner-cache entry pruned (documented hygiene; compiled copies and
  outputs retained in the job dirs).

## 4. Boundary (unchanged)

Not claimed: gm row laws, Montgomery-scale identity of the emitted table
words, canonical ranges, `igm=ft` overwrite, memory-layout theorems,
`modp_div`/`modp_R2` value laws. `emitted_to_actual_fiber` is still
uninhabited. Nothing in this package is REVIEWED.

## 5. Git

Commits this window: `29e6372b` (certificate) and the present commit
(receipt pair + checkpoint). NO push (owner signal absent). The B2/B5 lane
committed to shared `main` concurrently (`6ff3c838`, `125bfb2c`,
`e8a47b79`); exact pathspecs, one Git writer at a time.
