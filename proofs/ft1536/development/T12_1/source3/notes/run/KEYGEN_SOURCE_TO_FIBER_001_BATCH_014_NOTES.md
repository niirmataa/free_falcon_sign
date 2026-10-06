# BATCH_014 — B1.03 continuation (KROK 0 tree repair; div and mkgm3 source
# bindings closed; closure one-job rebuild; REV10 chunked certificate)

Window scope (owner): EXCLUSIVELY B1.03 continuation per
`KEYGEN_RESIDUE_CHECKPOINT.md` section 2 and the EXECUTION_PLAN. B1.04
values/ranges outside row laws and `t*m=n` remain outside this window.

## 1. KROK 0 — tree repair (mandatory first step), DONE (commit dc5ecf5c)

1. **Removed the false claim.** `KeygenMkgm3Callees.div_source_bound :
   C99ModularParser.region 2642 26 = some C99ModularReference.divCode`
   was DISPROVEN by kernel `decide` (retained failure log:
   `.build/jobs/keygen_mkgm3_frontend_011/logs/Source3_KeygenMkgm3Callees.stdout`)
   and was removed from the Lean tree. `div_header`, `r2_header`,
   `r2_source_bound` kept.
2. **divCode candidate recorded as an obligation (this receipt), not a
   claim**, until the corrected binding landed in step 1 below.
3. **Closure rebuilt to 0/0 (clean logs)** before continuing: jobs
   `keygen_mkgm3_repair_004` (6/6 accepted/clean) and
   `keygen_mkgm3_repair_005` (13/13 accepted/clean).
4. Tree-repair fallout fixed mechanically (no new claims):
   `KeygenNttLoopSupport.atom_frame` gained the `storeRev` alternative;
   `KeygenNttMiddleLoops` gained `storeRev` in its grouped impossible
   alternatives; `KeygenNttButterflyCalls` updated from the removed
   `C99ModularReference.Call` to `ModCall` (3 inversion statements).

## 2. div_source_bound — CLOSED (commit c3170530)

Probe `keygen_mkgm3_div_probe_001` (transient `KeygenMkgm3DivProbe`
module, deleted after use; source copy and full Repr dumps retained in
its job logs) localized the single parser<->divCode mismatch to exactly
one statement: the for-loop body's `z ^= (z ^ z2) & -(uint32_t)((e >> i)
& 1);` update. The candidate `divSelect` carried a DUPLICATED outer
`xor z` (the compound update form already contributes it). Fixed
`divSelect` to the exact select right-hand side; the corrected binding
sentence `div_source_bound : C99ModularParser.region 2642 26 = some
C99ModularReference.divCode` is kernel-proved (`decide`, job
`keygen_mkgm3_div_bound_001`, 4/4 accepted/clean). The other BATCH_013
candidates (`i--` shape, for-initial wrapping, `modp_montymul(z, 1, …)`
literal) all matched the parser.

## 3. KeygenMkgm3Program.source_bound — CLOSED (commit 83174c1c)

The drafted tree failed for THREE independent reasons, all found by
synthetic probes (jobs `keygen_mkgm3_program_probe_001..009`, all
retained) and fixed:

1. A syntax typo (`extra )` in `thenOne`) — retained failure
   `keygen_mkgm3_program_001`.
2. **`revStoreTail` never fired on real REV10 stores.** The greedy pure
   expression parse folds the marker's `+` into the base and reads
   `REV10` as a scalar variable (`b + REV10` with a dangling `[`). Fixed
   by the `revSplit` marker cut (`+ REV10 [`) before parsing the base
   (probe T4/T5: `none` -> `some`).
3. **False call match on parenthesized expressions.** The call pattern
   `name::['(']` also matched streams starting `(`,`(`, building a fake
   `call1 '(' …` and rejecting `u = ((size_t)1 << k) - 1;` (probe T21).
   Fixed with a token-name guard (probe T21/T10: `none` -> `some`).

Additionally the candidate `code` grouped nested `chainOf` sublists as
single statements while the parser body recursion produces one flat
right-nested seq spine; `code` was restructured as one flat statement
list (20/20 flat elements equal after the fix).

The corrected binding sentence `source_bound : C99ModularParser.region
2945 91 = some code` is kernel-proved (`decide`, job
`keygen_mkgm3_program_003`, accepted/clean).

## 4. Closure rebuild in one job — DONE (step 3 of the owner list)

Job `keygen_mkgm3_closure_001`: **35/35 accepted/clean in one job**
(the full descendant closure of the changed `C99ModularReference`/
`C99ModularParser`: the modular frontend, all KeygenCheck* consumers,
`KeygenRev10`, `KeygenMkgm3Callees`, `KeygenMkgm3Program`, the
KeygenNtt* and KeygenResidue* families). Logs 0/0, limits unchanged.

## 5. REV10 1024-entry exactness certificate — OPEN at a measured seam

`KeygenRev10Cert.lean` (generated in the FFT-table precedent, trap 34):
1024-entry literal candidates + 32 kernel-decided 32-entry chunks
against the `bitrev10` model (validated green) + source binding +
descending tail glue + `tableData_exact` + `rawTable_exact`. Draft v3
preserved UNCOMMITTED in `formal/` (interruption rule); the committed
tree stays green without it. Retained FAILED attempts:
`keygen_rev10_cert_001` (design A killed after 25 min),
`keygen_rev10_cert_002` (design B: single 1024-entry source decide blew
the kernel bound), `keygen_rev10_cert_003` (design C: chunked source
binding, 33/33 parse-bearing decides blew),
`keygen_rev10_probe_001/002` (granularity probes).

**Measured kernel granularity (probe `keygen_rev10_probe_002`):** one
`decide` may parse at most ~8 pinned table lines (1/2/8-line
`mapM parseLine` decides green; 86-line decides blow kernel memory even
with a trivial `isSome` comparison). Comparisons are cheap (32-entry
decides pass). Completion route and exact missing types:
`KEYGEN_RESIDUE_CHECKPOINT.md` section 2 (11 x 8-line slice decides +
mapM/flatten glue through intermediate facts + the v3 helper fixes).

## 6. Evidence pins

- Owner-pinned inputs re-verified before new work: RECEIPTS
  `3ca613d70be08968f902e729705754f687b5224e0286da1d46578dda4f381cdd`
  MATCH, SOURCE_INPUTS
  `7772a7a79458d5d37281e6c7f7ab8898567232449ad76df909bf4c0eeb0c5ade`
  MATCH (job `keygen_mkgm3_frontend_011`).
- Runner byte-identical (`3bc29bf7…`); no push (owner signal absent).
- Retained FAILED attempts this window (never cited as PASS):
  `keygen_mkgm3_repair_001` (stale-source cache assertion — discovered
  the forced rebuild set), `keygen_mkgm3_repair_002` (preflight refusal
  at an occupied shared slot; waited), `keygen_mkgm3_repair_003`
  (stuck match reduction of stale olean importers),
  `keygen_mkgm3_repair_004` (pre-refactor `Call` identifier),
  `keygen_mkgm3_program_001` (syntax typo),
  `keygen_mkgm3_program_002` (decide disproven before parser fixes),
  `keygen_rev10_cert_001` (killed after 25 min; design A too slow),
  probe jobs `keygen_mkgm3_div_probe_001`,
  `keygen_mkgm3_program_probe_001..009` (diagnostics; the transient
  probe module was deleted after use and its cache entry pruned —
  documented runner-cache hygiene, compiled copies and outputs retained
  in the job dirs).
- Interleaved with this window: concurrent commits of the B2/B5 lane on
  shared `main` (visible in `git log`); one Git writer at a time was
  observed, exact pathspecs used, no push.

## 7. Open (next window, in EXECUTION_PLAN order)

1. REV10 certificate: final job result (`keygen_rev10_cert_002`) — see
   the checkpoint for its status at the freeze.
2. r2 exact value law (2^62 mod p) and the Montgomery-scale extraction
   of the mkgm3 stores.
3. Per-row exponent/order laws and canonical ranges from the executed
   stores; `igm=ft` overwrite and preservation of gm/source material;
   extents and non-overlap from the caller buffer layout.
4. Then B1.04 (NTT canonical range and polynomial evaluation; `t*m=n`
   lives there and ONLY there).
