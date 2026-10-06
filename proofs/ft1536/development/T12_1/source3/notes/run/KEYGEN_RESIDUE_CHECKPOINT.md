# KEYGEN_SOURCE_TO_FIBER_001 — residue checkpoint (expanded)

Package status: **IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN**.
Checkpoint written 2026-10-06 at the close of the owner-scoped window
"B1.03 stage (a): REV10 exactness certificate closure". Frozen at a
staged-roadmap iron-rule-2/3 boundary: the REV10 exactness certificate is
CLOSED (the measured source-binding seam of the previous checkpoint is
discharged); the row/Montgomery/memory-layout laws of B1.03 remain, with
the owner window sequencing (b) `modp_R2` value law and (c) row laws.
Session harness: **MiMo V2.6 Pro** (REV10 closure window). Batch receipt
pair: `KEYGEN_SOURCE_TO_FIBER_001_BATCH_015.json` + `_015_NOTES.md`.
This file supersedes the previous expanded checkpoint; carried facts are
in section 5.

## 1. Closed this window — commits, modules, evidence (verified before commit)

Local commits on `main` this window (no push, owner signal absent):
(1) `29e6372b` `formal/Source3/KeygenRev10Cert.lean` — the REV10 exactness
certificate v4; (2) the batch015 receipt pair + this checkpoint (the
present commit). The B2/B5 lane committed to shared `main` concurrently
(`6ff3c838`, `125bfb2c`, `e8a47b79`); exact pathspecs, one writer at a
time.

| Scope | Content | Checked by |
|---|---|---|
| REV10 exactness certificate (owner stage (a)) | `KeygenRev10Cert` v4: `rawTable_exact : rawTable = some ((List.range 1024).map bitrev10)` kernel-proved. Model side: the 32 kernel-decided 32-entry chunks vs `bitrev10` plus the descending `tail1024..tail0` glue (v3 shapes, structurally sound, kept verbatim except tail992's last step). Source side (the former seam): 11 slice decides `sNN` binding the literal `rowsNN` candidates to the pinned parse, each re-parsing AT MOST 8 pinned table lines (the measured kernel granularity of probe `keygen_rev10_probe_002`), and a `mapM`/`flatten` glue over the slice facts through intermediate statements (`region_split`, `mapM_join`, `flat_lit`, `table_data`) that never re-parses; assembly via `congrArg some`. Literal `tableData`/`rowsNN` are generator output and are re-checked by the kernel on every build. | job `keygen_rev10_cert_004` (accepted/clean, logs 0/0 bytes, 80.701 s, maxrss 3483896 KiB, zero forbidden markers) |
| v3 helper fixes (old section 2 item 3) | `map_split` zero/succ cases via `Nat.add_zero`/`Nat.add_succ` (no `omega`); `map_some_iff` DROPPED (its `Option.noConfusion` application hit a universe mismatch and the new assembly does not need it); `List.drop_length` applied bare (implicit `{l}`); tail992's final step replaced by `List.append_nil _` (the old `rw [show 32 = 32 + 0 …]` rewrote both `32` occurrences and mangled the goal — trap 46). | probe jobs `keygen_rev10_probe_003..006` |
| transient probe `KeygenRev10CertProbe` | validated the novel mechanics on two real slices (first-line shape and last-line shape, including the no-trailing-comma line): `take_split` ladder + congrArg/rfl region decomposition, `mapM_append` glue over real slices, the fixed `map_split`, the tail992 replacement step, the drop-length side conditions. `keygen_rev10_probe_003..005` retained FAILED attempts (`take_split` proof shape; traps 46/47 were identified here), `keygen_rev10_probe_006` accepted/clean. Module deleted after use and its runner-cache entry pruned (documented hygiene; compiled copies and outputs retained in the job dirs). | receipts in the job dirs |

### 1.1 What is proved (kernel, no sorries, no oracle)

- **REV10 exactness certificate — CLOSED.**
  `KeygenRev10Cert.rawTable_exact : rawTable = some ((List.range 1024).map
  bitrev10)`: the pinned 1024 table entries are exactly `bitrev10 0..1023`,
  checked by the kernel in 32-entry model chunks, 32-entry literal
  comparisons and 11 parse slices of at most 8 pinned lines each, with a
  glue over intermediate facts that never re-parses (traps 34/45
  respected).
- **B1.03 callee binding phase — CLOSED (unchanged).** `r2_source_bound`,
  the corrected `div_source_bound` and `KeygenMkgm3Program.source_bound`
  identify the hand-built trees with the parser output on the pinned
  bytes; `modp_R` keeps its exact value law; generator orders 9216/4608
  stay kernel-checked.
- **Not claimed (unchanged boundary):** no gm row law, no
  Montgomery-scale identity of the emitted table words, no canonical
  ranges, no `igm=ft` overwrite or memory-layout theorem, no `modp_div`
  value law (its exact quotient law needs modulus primality and is not
  required for the gm words), no `modp_R2` value law.

### 1.2 Evidence pins (verified MATCH against current files)

- Owner-pinned job `keygen_mkgm3_frontend_011`: RECEIPTS SHA256
  `3ca613d70be08968f902e729705754f687b5224e0286da1d46578dda4f381cdd`
  MATCH; SOURCE_INPUTS SHA256
  `7772a7a79458d5d37281e6c7f7ab8898567232449ad76df909bf4c0eeb0c5ade`
  MATCH (re-verified before new work).
- Runner byte-identical (`3bc29bf7…`).
- `formal/Source3/KeygenRev10Cert.lean` (v4, 1419 lines) SHA256
  `9fd2b27e1138f88e686513f8814d53c23c421caab2fe430353ba2bba89dfb69b`;
  retained v3 draft byte-copy (job `keygen_rev10_cert_003`, `formal/`)
  SHA256 `de0dd401d44b32487005110caf960184afa1a22a1187ef0e161c5f9c4b0145af`;
  candidate generator `.build/rev10cert_gen_001.py` SHA256
  `f91ae57d4b89c0c9daa4600d4259349216b0dbce8785e0a82cdbda0124097a67`;
  `formal/Source3/KeygenSource.lean` SHA256
  `87b529d744eaf2c7c860d35dcc9113220ef3954928e59f41d880f64c0684ce25`;
  `formal/Source3/KeygenRev10.lean` SHA256
  `018d6b25332e72b15ad385fdf0a4636e8976145aed00a98ce24024b5caf7d353`.
- Job `keygen_rev10_cert_004` evidence under `.build/jobs/keygen_rev10_cert_004/`
  (`RECEIPTS.json`; stdout and stderr SHA256 both
  `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` —
  empty logs). BATCH_014 pair pins re-checked:
  `KEYGEN_SOURCE_TO_FIBER_001_BATCH_014.json` SHA256 `db561dae…`,
  `_BATCH_014_NOTES.md` SHA256 `f383d26a…`.
- Retained FAILED attempts (never cited as PASS):
  `keygen_mkgm3_frontend_001..011`, `keygen_mkgm3_repair_001..004`,
  `keygen_mkgm3_program_001/002`, `keygen_rev10_cert_001..003`, probe jobs
  `keygen_mkgm3_div_probe_001`, `keygen_mkgm3_program_probe_001..009`,
  `keygen_rev10_probe_001..005`, and all earlier retained failures. The
  transient probe module `KeygenRev10CertProbe` was deleted after use and
  its runner-cache entry pruned (documented hygiene; compiled copies and
  outputs retained in the job dirs).

## 2. In flight — exact types and state

Nothing in flight at the freeze. The former REV10 seam (section 2 of the
previous checkpoint) is discharged: `table_data : rawTable = some tableData`
(source binding `mapM_join` + literal glue `flat_lit`) and
`tableData_exact : tableData = (List.range 1024).map bitrev10` (model side)
compose into `rawTable_exact`. The exact missing types listed previously
(slice decides + mapM/flatten glue + helper fixes + assembly) are all
landed in `KeygenRev10Cert` v4; the only design change versus the recorded
route is that `map_some_iff` was dropped rather than fixed (the assembly no
longer extracts a witness from `rawTable` — the glue goes through the named
intermediate statements instead).

## 3. Remaining work — order from `KEYGEN_SOURCE_TO_FIBER_001_EXECUTION_PLAN.md`

1. **B1.03 (continuation)** — owner window sequencing: (b) `modp_R2`, the
   r2 exact value law (`2^62 mod p`, Montgomery scale); (c) per-row
   exponent/order laws and canonical ranges from the executed stores; then
   `igm=ft` overwrite with gm/source-material preservation; extents and
   non-overlap from the caller buffer layout.
   Acceptance unchanged (initialized source gm words with canonical ranges
   and exact scaled root identities).
2. **B1.04** — NTT canonical range and polynomial evaluation (6
   sub-proofs; `t*m=n` lives here and ONLY here).
3. **B1.05**–**B1.11** as previously recorded.

Forbidden in all remaining steps (final premise boundary): solver or
serializer correctness assumptions; NTRU or certificate acceptance as
premises; unproved source completeness; arbitrary callee contracts;
success constructors containing evaluations.

## 4. Traps encountered (do not re-trigger)

1..31 (carried; still apply). 32..45 (previous windows; still apply).
New this window:

46. **`rw` rewrites ONE instantiated occurrence, not every instance of the
    pattern.** `rw [List.take_nil]` on a goal with several `take _ []`
    terms rewrites only the first match (with its substitution) and leaves
    the others in place. Counting rewrites by hand is fragile; when several
    instances must all move, use `simp only [<lemmas>]`, or one `rw` per
    ground instance.
47. **`Nat.add` recurses on its SECOND argument** in this toolchain:
    `c + 0` and `a + Nat.succ n` reduce definitionally, but `0 + c` and
    `Nat.succ n + a` do NOT. Induction base cases over `b + c` must
    normalize with `Nat.zero_add`/`Nat.succ_add` before `rfl`; never
    expect `0 + c`-shaped terms to disappear definitionally. (This is the
    exact mechanism behind the v3 `map_split`/`map_range_ext` failures of
    the old section 2 item 3.)
48. **Core lemmas with an implicit list argument apply bare.**
    `List.drop_length {l : List α} : l.drop l.length = []` is not a
    function: `exact List.drop_length` (the unifier picks `l` from the
    goal), never `List.drop_length t`.

## 5. Carried facts (earlier checkpoints, still true)

- B1.02 CLOSED at its Acceptance (first/intermediate/triple passes,
  counters, positions, complete-body execution); `KeygenNttMiddleRounds`
  etc. green in the new closure job.
- B1.01 word algebra adapter; `KeygenResidueVectors.source_vectors` and
  the residue conversion family; `KeygenCheckOutcome.accepted`;
  certificate suffix/prefix results; STABLE_BINARY_004 and frozen stage
  dependencies: all unchanged.
- Sage probes remain finite diagnostics, not kernel results.

## 6. Resume protocol (next window)

1. Read `WORK_STATE.md` (live), this file, the EXECUTION_PLAN and
   `run2/notes/B1_STAGED_ROADMAP.md`. The next window continues **B1.03**
   only (one stage per window) from section 3 item 1 — owner sequencing:
   stage (b), the `modp_R2` value law. The REV10 closure check is DONE and
   is no longer part of the resume.
2. Verify current pins against SOURCE_INPUTS.json of
   `keygen_mkgm3_frontend_011` (plus the BATCH_013/014/015 pins) before any
   new claim.
3. One proof job at a time (`tools/job_when_available.py`), unique labels,
   topological module order, guarded serial compiles, logs 0/0, limits
   unchanged. Rebuild the FULL cached descendant closure of any changed
   module in one job (35 modules after the parser/reference changes of the
   previous window) — trap 40. `KeygenRev10Cert` is a leaf module (no
   importers) and is now cached from `keygen_rev10_cert_004`.
4. Small logical local commits on `main` with exact pathspecs after each
   verified step; NO push until an explicit owner signal. One Git writer
   at a time (the B2/B5 lane commits concurrently).

`emitted_to_actual_fiber` is still uninhabited. Nothing in this package is
REVIEWED; REVIEWED is never self-declared.
