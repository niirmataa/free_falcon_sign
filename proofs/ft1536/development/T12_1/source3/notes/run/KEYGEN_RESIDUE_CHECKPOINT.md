# KEYGEN_SOURCE_TO_FIBER_001 — residue checkpoint (expanded)

Package status: **IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN**.
Checkpoint written 2026-10-02 on the owner's order to close the current
batch cleanly (window closing, not a limit crash). This file supersedes
and expands the earlier coefficient-conversion checkpoint; its facts are
carried in section 5. Session harness for the committed work below:
**MiMo V2.6 Pro** (B1 continuation window; explicit handoff from GPT-6
Astra per `run2/notes/PROMPT_B1_CONTINUATION.md`).

## 1. Closed in this continuation — commits, modules, evidence

All work is verified against actual files, receipts and empty (0/0) stderr
logs before commit. Four local commits on `main`, no push (owner signal):

| Commit | Scope | Checked by |
|---|---|---|
| `d5cae83e` | `KeygenNttWordAlgebra.lean`, `KeygenFirstPrime.lean` | job `keygen_ntt_frontend_002` |
| `e53bf9ee` | `C99ModularParser.lean` (dereference grammar), `KeygenNttButterflyPrograms.lean` | job `keygen_ntt_frontend_002` |
| `aa40bc94` | `KeygenNttButterflyAlgebra.lean` | job `keygen_ntt_butterfly_algebra_004` |
| `a1ab8ddc` | `WORK_STATE.md` batch record | — |

### 1.1 What is proved (kernel, `by exact`/`by decide` terms, no sorries)

- `KeygenNttWordAlgebra` (namespace `FT1536.Source3.KeygenNttWordAlgebra`,
  `abbrev R := ZMod 2147355649`): the checked scalar modular contracts are
  usable as exact field operations in `ZMod 2147355649` with the radix
  `2^31` **explicit** (`radix`, `radix_inverse`):
  - `source_add` / `source_sub`: source `modp_add`/`modp_sub` executions
    yield `value out = value a ± value b` with canonical range.
  - `source_montgomery`: source `modp_montymul` yields
    `value out * radix = value a * value b` (Montgomery scale retained).
  - `source_twiddle`: multiplying by a table word with
    `value scaled = radix * twiddle` yields `value out = value a * twiddle`
    — the R factor cancels exactly once.
  - `source_scaled_product`: two scaled words multiply to a scaled word.
  Ordinary residues and Montgomery-scaled table words are NOT
  interchangeable; the type keeps the scale visible. This closes B1.01's
  acceptance ("canonical outputs and the exact field operation, with the
  representation scale visible in the type").
- `KeygenFirstPrime`: parses the **actual first PRIMES3 source record** from
  the pinned M0 bytes (`Pinned.keygenLines`) and pins
  `first_entry : parsed = some (2147355649, 1907584673, 127999)` with
  `table_header` on the real table opener and
  `generator : BitVec 32 := 1907584673`. p matches `KeygenNinv31.prime`.
- `C99ModularParser` extension (committed as grammar step): pointer
  dereference reads `*r1`, `*(r1 + stride)` and dereferenced stores in both
  expressions and simple statements (`dereference` + `load32`/`store32`
  cases), binding pointer types through the enclosing declarations.
- `KeygenNttButterflyPrograms`: the three forward inner bodies of
  `modp_NTT3_ext` parse to the pinned statements (`first_source` region
  3070 7, `binary_source` region 3095 7, `triple_source` region 3115 20,
  all `by decide`) and `wrapper_source` pins the stride-1 wrapper macro
  `modp_NTT3(a, gm, logn, full, p, p0i)` -> `modp_NTT3_ext(a, 1, ...)`.
- `KeygenNttButterflyAlgebra`: exact butterfly formulas over the word
  adapter — first pass `a0 + a1*w` / `a0 + a1 - a1*w` (`first_values`),
  radix-2 pass `x ± y*root` (`binary_values`), triple pass the three
  evaluations at `root`, `root*unity`, `root*unity^2` with `unity^3 = 1`
  (`triple_values`, using `unity^4 = unity`), all outputs canonical.
  Intermediate call observations live in explicit structures
  (`FirstCalls`/`BinaryCalls`/`TripleCalls`); see open item B1.02b.

### 1.2 Evidence pins (verified MATCH against current files at checkpoint)

- Job `keygen_ntt_frontend_002`: **23/23 accepted, logs 0/0**, 59.973s,
  maxRSS 3114516KiB — full cached descendant closure of the changed
  pointer-dereference grammar (C99ModularParser, C99ModularAnnotation,
  the KeygenCheck*/KeygenResidue* consumers, KeygenNttWordAlgebra,
  KeygenFirstPrime, KeygenNttButterflyPrograms, KeygenFiber008Audit).
  RECEIPTS.json SHA256
  `2103761326376591a723f89addd92a3fb1e3c6e07bc2d0d5499d55846f78f5d6`;
  SOURCE_INPUTS.json SHA256
  `314649f3121a3ffed190f2db9907b71e151c5124c71e155e67e2813fd9eb6f51`.
  All 23 recorded source SHA256s re-verified equal to the working tree.
- Job `keygen_ntt_butterfly_algebra_004`: 1/1 accepted, logs 0/0;
  `KeygenNttButterflyAlgebra.lean` SHA256
  `2fed1019bb3e6a4cd8e53b8b0b25db617ede4bf17f23cad6beb31784c8245c35`
  (MATCH). RECEIPTS.json SHA256
  `38ba136a0b04a9c1e483f2475419591d8994002f0577b2e49542a5c8febc8948`.
- Retained FAILED attempts (do not cite as PASS):
  `keygen_ntt_word_algebra_001` (accepted=False; its recorded
  `KeygenNttWordAlgebra` hash is an earlier source state — current file
  does NOT match that record) and `keygen_ntt_butterfly_algebra_003`
  (accepted=False, source `94a38d82...`).
- Committed file hashes:
  `KeygenNttWordAlgebra.lean`
  `c4386de01fcc4f9b89a38f24e9176b4f797b66ec5be41ecb25e71bba71422b5f`;
  `KeygenFirstPrime.lean`
  `8f3684b7ba2389b2b0a3706790274b52fbf7d3e3817e8bb68284d2e7ed8f5290`;
  `C99ModularParser.lean`
  `12b40a3d807e6c49b15ba904e0cfd86b944e3abf8a98d0d3e6d625c511873f4d`;
  `KeygenNttButterflyPrograms.lean`
  `71b3b2b3da43287d130f0c7e4bdda9ca991c2d0e7e2222dbf955cf3e2f15a8c0`;
  `KeygenNttButterflyAlgebra.lean`
  `2fed1019bb3e6a4cd8e53b8b0b25db617ede4bf17f23cad6beb31784c8245c35`.

## 2. Half-done at window close — exact types and state

**No uncommitted source work exists**; the tree at this commit is
consistent and every committed module is receipt-verified. What is
half-done is the *investigation* of the next step, B1.02 (complete
forward-NTT source grammar and execution). Its analysis is complete
(checkpointed here so it is not re-derived); zero new code for it exists.

### 2.1 B1.02 body region map (derived, ready to use)

`C99ModularParser.region start count` = `keygenLines.drop (start-1).take
count` (+ a synthesized `}` terminator for `body`); region line `i`
corresponds to `KeygenSource.lean` file line `i+3` (0-based
`keygenLines[k]` sits at file line `k+4`).

- Whole forward body = `C99ModularParser.region 3046 91` (file lines
  3049 `size_t n, hn, u, r, m, t;` .. 3139 closing `if (full)` block).
  The function's own closing `}` (file 3140) is NOT in the region —
  `region` synthesizes the terminator.
- Sub-regions already pinned by `by decide` theorems: inner first body
  `region 3070 7` (= `firstBody`), inner radix-2 body `region 3095 7`
  (= `binaryBody`), inner triple body `region 3115 20` (= `tripleBody`).
- Prologue = file 3049–3057 (declarations, `if (logn == 0) return;`,
  `n = MKN(logn, full);`, `hn = n >> 1;`); first pass = 3069–3080
  (`w = gm[1];` + first loop); intermediate passes = 3085–3108 (`t = hn;`
  + doubling loop); final triple pass = 3113–3139 (`if (full) { ... }`).
- Wrapper macro pinned at `keygenLines` drop 3250 take 2 (file 3254–3255).

### 2.2 B1.02 grammar gaps — exact constructors to extend

1. **Void return `return;`** (logn0 guard). `C99ModularReference.Stmt.ret`
   takes `value : Expr` and `Exec.ret` yields `.returned (some v)`;
   `C99ProcedureReference.Flow.returned` already carries
   `Option Value`, so `.returned none` is representable. Needed: extend
   `Stmt` (e.g. `ret (Option Expr)` or `retVoid`) + `Exec` rule.
2. **Pointer declarations** `uint32_t *r1, *r2;` — template exists:
   `C99ProcedureParser.simple` case `ty::['*']::rest` ->
   `C99ProcedureParser.pointerNames` -> `chain (.base (.declarePtr n))`.
   `C99ModularParser.simple` lacks the case.
3. **Pointer assignment/advance** `r1 = a`, `r2 = a + hn * stride`,
   `r2 = r1 + ht * stride`, `r1 += stride` — template:
   `C99ProcedureParser.simple` `lhs::['=']::rest` with
   `ctx.contains lhs` -> `C99ProcedureParser.pointerExpr` ->
   `.base (.bindPtr lhs src index)` of `C99ArrayReference.Stmt`.
   Requires a pointer-name `Context` threaded through
   `C99ModularParser.simple/statement/body` (as `C99ProcedureParser`
   does with `abbrev Context := List Name`).
4. **Comma-separated for-init and for-increments** —
   `for (u = 0, r1 = a, r2 = a + hn * stride; u < hn; u ++, r1 += stride,
   r2 += stride)` and `for (u = 0, r = (size_t)1 << (logn - 1), r1 = a;
   u < n; u += 3, r ++, r1 += 3 * stride)`. Current
   `C99ModularParser.statement` for-case accepts exactly one `simple`
   init and `counter ++`. Template: `C99ProcedureParser.clauses`
   (comma-separated, terminator-parameterized).
5. **Compound updates in increment position** `m <<= 1`, `u += 3`,
   `v1 += t` — `B20.C.Scalar.updateOp` already maps `+=`/`-=`/`*=`/`&=`/`|=`/`^=`/`>>=`/`<<=` and `CLogicParser.statement`
   `name::op::rest` builds `.update name operation e`; needed inside the
   new clause machinery.

### 2.3 Consumers that MUST be patched when Stmt/Exec change

Adding any `Stmt`/`Exec` constructor breaks these exhaustive matches /
induction case lists (all must gain the new case; recheck their full
closures after):

- `C99ModularAnnotation.statement` (constructor match).
- `C99ModularFlow.onlyReturn` + `C99ModularFlow.source_flow`
  (`induction source with` enumerates all Exec rules).
- `C99ModularFrame.readOnly` + `C99ModularFrame.source_frame` (same).
- `KeygenCheckLoopBridge.complete` and `KeygenResidueLoop.complete` —
  `induction source generalizing i with
   | base | assign | store32 | seqNormal | seqExit | scope | branchTrue
     | branchFalse | ret => cases shape` — explicit rule list.
- `KeygenCheckGate.return_literal` matches `Exec (.ret ...)` precisely.

### 2.4 Butterfly call observations — open extraction

`KeygenNttButterflyAlgebra`'s `FirstCalls`/`BinaryCalls`/`TripleCalls`
carry the intermediate `Mul`/`Add`/`Sub` call premises explicitly. The
next sub-step is extracting these observations from the parsed
memory/control bodies (`KeygenNttButterflyPrograms.firstBody`/
`binaryBody`/`tripleBody`) — same shape of work as
`KeygenCheckOutcome.accepted`. **Do not promote these call premises to
whole-NTT facts** before that extraction exists.

## 3. Remaining work — order from `KEYGEN_SOURCE_TO_FIBER_001_EXECUTION_PLAN.md`

Next implementation step is **B1.02**; the plan's order is binding:

1. **B1.02** — complete forward-NTT source grammar and execution:
   extend the modular frontend only for the syntax in 2.2; parse prologue,
   first pass, intermediate passes and final triple pass and prove their
   composition is the complete source body (`region 3046 91`); retain
   every guard including the logn0 return; derive n1536, hn768, stride1,
   counters and every pointer position **from execution** (no success
   constructor containing evaluations); fixed source callee table with
   actual body execution. Commit syntax/control separately from range and
   polynomial invariants. Checkpoint 2.2/2.3 is the prepared input.
2. **B1.03** — source twiddle-table generation and memory layout
   (`modp_mkgm3`): `modp_R`/`modp_R2`, division body, REV10 data;
   per-row exponent/order law and Montgomery scale from executed stores;
   generator order at logn10 (expected g order 9216, M0 squaring 4608 —
   **proof obligation, not an assumption**); alias `igm = ft` overwrite
   with gm and source material preserved (checked coefficient-conversion
   loop overwrites temporary inverse-table contents); allocation, table
   extents, access discipline and non-overlap from the caller's layout.
   Save finite-table certificates via generator/pin if too large.
3. **B1.04** — NTT canonical range and polynomial evaluation for the SAME
   transform execution: range preservation from conversion input theorem +
   table ranges + primitive contracts; first-pass formulas incl.
   `w^2 - w + 1 = 0` and physical low/high positions; radix-2 formulas
   with invariant `t*m = n`, sub-polynomial degrees, actual twiddle
   indices; triple-pass emission order resolved **from source
   indices/REV10** (not convenience); link to
   `CoefficientQuotient.polynomial` evaluations; the 1536 points distinct
   roots of Phi; degree/root-count or quotient injectivity to recover the
   coefficient equation.
4. **B1.05** — source solver success to exact integer NTRU: complete
   active solver call graph source-bound (earlier search routines need
   not solve NTRU but cannot be arbitrary callees); `poly_big_to_small`
   and `zint_one_to_plain` full bodies -> actual F/G bytes, bounds 2047;
   full MODE1 sampler loop/rejections/stores -> f/g bounds 1 (keep the
   real deterministic draw interface; no uniformity assumed); coefficient
   arrays preserved through table generation/conversions/four transforms
   tied to the same original f,g,F,G; derive p/p0i/r and final-check
   bindings from preceding execution; then parsed final-check theorem ->
   NTT injectivity -> `exact_ntru_of_modular_check` with residual bound
   37748737.
5. **B1.06** — source public computation and inverse: `falcon_compute_public`
   ternary q18433 branch + modular helpers/tables (pinned sources, correct
   word widths); nonzero f evaluations from executed failure tests on the
   successful path; pointwise division + inverse transform; fInv witness
   from those nonzero evaluations (no extra serialized array); canonical h
   -> `mulRq h (reduceVec f) = reduceVec g` and
   `mulRq fInv (reduceVec f) = constantCoeffs 1`; B3 exports only after
   inspecting exact types and pinning their dependency closure.
6. **B1.07** — whole KeyGen control, attempts, final invocation: argument/
   context reads, MKN, RNG readiness, automatic coefficient objects,
   scratch layout, initialization, teardown; struct-member access /
   pointer views / call destinations syntax as required (record every
   supported construct; prove pinned active source closure coverage);
   gate order = resultants f/g, raw FPEMU norm, orthogonal FPEMU norm,
   public computation, NTRU solver, mandatory leaf certificate — mirror
   the six gates of `run2/notes/S1_P_ACCEPT_FACTS.md` plus the attempt cap
   semantics; cap theorem (increment before sampling, rejection at
   3000001, no wrap, no normal fallthrough, break after all gates);
   chronological attempts with all-but-last rejected and
   length <= 3000000; final attempt's material tied to encoding inputs by
   **actual stores and caller frames** (not abstract names); the already
   checked complete certificate instantiated on those arrays. LAW
   BOUNDARY: loop acceptance precedes output capacity checks — expose the
   extra rejection event to B5; never equate call-level return 1 with
   per-attempt acceptance; `1-(1-p_accept)^cap` needs a probability law
   (deterministic trace facts are not IID).
7. **B1.08** — source secret-key serialization/decoding: encoder/decoder
   bodies, dispatcher, q18433/logn10 branch, sign and low-magnitude bits,
   unary loop, independent segment padding; accumulator low-suffix
   invariant (old emitted bits remain in the uint32 accumulator — do NOT
   assume the whole accumulator is bounded by 2^acc_len); source
   post-decrement incl. terminal `ne = -2`; exact consumed lengths and
   decoding of `encodedSegment ++ tail` without consuming the next
   segment; noncanonical encodings only as the actual decoder treats them;
   f,g,F,G order, header 0xaa, four independent paddings, capacity tests,
   cursor updates, final length store; earlier segments/arrays/public
   material preserved through later writes; emitted bytes derived from
   memory after return. Prove length formulas — do not borrow a
   signature-codec bound.
8. **B1.09** — source public-key serialization/decoding: 15-bit
   packing/unpacking of 1536 coefficients, 2880 payload bytes, header
   0x8a, canonical h < 18433 from B1.06; the public decoder **returns its
   supplied length** — no invented trailing-byte rejection; theorem uses
   exact emitted length 2881.
9. **B1.10** — one emitted-to-fiber theorem
   (`KeygenSourceToFiber001.emitted_to_actual_fiber`, exact type in PLAN
   section 1): PinnedExec/Success/Emitted from source execution and
   observable return/bytes only; from return 1 extract final accepted
   attempt, both encoders, exact lengths; B1.05–B1.09 on a single
   material witness; the three derived equations to the existing
   ActualNTRUFiber exports; print full type and actual axioms — verify no
   local canonical-range / initializer / source-completeness /
   arbitrary-callee / round-trip / pre-established-certificate premise
   leaked; small named contract table for B4/B5 (same-key certificate,
   equations/fiber, emitted-byte identity, deterministic attempt
   structure).
10. **B1.11** — complete replay, mutations, final artifacts: one serial
    fresh replay of the complete final closure (clean logs, unchanged
    limits); audit final types/terms/axioms and source bindings; retain
    all failed runs; targeted mutations (missing gate/cap,
    accepted-vs-emitted confusion, F/G swaps or omitted G, wrong
    modulus/root order, weak integer-lift bound, wrong codec
    length/padding, different h, stale bad-pointer reads, mismatched
    attempt/material snapshots); public synthetic helper inputs only;
    Sage supplements, never replaces a missing theorem;
    `KEYGEN_SOURCE_TO_FIBER_001_REPORT.md` (begins with full theorem type
    and real premises), `_CLOSURE.json`, `_REVIEW_TASK.md`, B4/B5 exports,
    source/model scope, reproducible commands, raw-log/receipt pins, every
    remaining limitation.

Forbidden in all remaining steps (final premise boundary): solver or
serializer correctness assumptions; NTRU or certificate acceptance as
premises; unproved source completeness; arbitrary callee contracts;
success constructors containing evaluations.

## 4. Traps encountered (do not re-trigger)

1. **Failed job records look like evidence.** `keygen_ntt_word_algebra_001`
   records `accepted=False` and a `KeygenNttWordAlgebra` hash that does
   NOT match the current file (intermediate source state);
   `keygen_ntt_butterfly_algebra_003` likewise failed. Only
   `keygen_ntt_frontend_002` and `keygen_ntt_butterfly_algebra_004` are
   PASS pins. Always re-hash the working tree against SOURCE_INPUTS
   before citing a receipt.
2. **Region numbering off-by-three.** `C99ModularParser.region start
   count` counts `keygenLines` positions (1-based start via
   `drop (start-1)`); `keygenLines[k]` lives at `KeygenSource.lean` file
   line `k+4`, so region line `i` = file line `i+3`. The parser appends a
   synthetic `}` — never include the function's closing brace in the
   region, and never count comment/blank lines out of `count` (the
   tokenizer skips them but `take count` counts raw lines).
3. **Montgomery scale confusion.** A twiddle stored as `R*s` is not `s`.
   The adapter (`radix`, `radix_inverse`, `source_twiddle`) cancels the
   factor exactly once; hand-rolled rewrites that drop or duplicate `R`
   were the historical bug class here. Keep `value`/`radix` in every type
   until B1.03's table laws exist.
4. **Adding a Stmt/Exec constructor breaks five consumers** (2.3 list).
   The induction case lists in `KeygenCheckLoopBridge.complete` /
   `KeygenResidueLoop.complete` are explicit; a missing case fails the
   build of modules several hops away. Recheck the full descendant
   closure after any semantic extension (this is what
   `keygen_ntt_frontend_002`'s 23-module sweep was for).
5. **`size_t` is not a `typeToken`.** `C99ArrayParser.normalizeTypes`
   maps `size_t` -> `uint64_t` at tokenize time; parsers fed raw tokens
   without that normalization reject `size_t` declarations. `region`
   normalizes via `C99ProcedureParser.tokens` — keep it that way.
6. **`MKN` is a macro, not a call.** `C99ArrayParser.expand`/`mkn`
   rewrite `MKN(logn, full)` to `(1 + (full << 1)) << (logn - full)`
   (u64 cast). Never model it as a `Call` (no body exists for it).
7. **Shared `main`, several writers.** Foreign commits and modified
   files were present during this batch (onboarding docs,
   `CURRENT_DEVELOPMENT.md`, run2 B4 files, another lane's commit
   `9b13ac04` landed mid-batch). Commit ONLY own paths
   (`git commit --only -- <paths>`, `git add` for new files first);
   never reset/checkout another lane's index; no amend, no force-push,
   no push at all without an explicit owner signal.
8. **Bash heredoc/quoting for one-off verification** in this harness
   needs care (a `git commit -m` after `--` is read as a pathspec — put
   `-m` before `--`). Prefer the pinned `tools/job.py` /
   `tools/job_when_available.py` runners over ad-hoc compile commands.
9. **Call-premise leakage.** `KeygenNttButterflyAlgebra`'s
   `FirstCalls`/`BinaryCalls`/`TripleCalls` are explicit observation
   structures precisely so their `Mul`/`Add`/`Sub` premises cannot be
   silently assumed as whole-NTT facts. The extraction from parsed
   bodies is still open (2.4); until then treat them as interface, not
   conclusion.
10. **Attempt-cap law boundary** (B1.07): loop acceptance precedes
    output capacity checks — call-level `return 1` ≠ per-attempt
    acceptance, and `1-(1-p_accept)^cap` is a probability claim needing a
    law, not a trace fact. Mirroring `S1_P_ACCEPT_FACTS.md`'s six gates
    + cap is the required predicate shape for B4/B5.

## 5. Carried facts (earlier residue checkpoint, still true)

- `KeygenResidueVectors.source_vectors` consumes the Geometry.Vec
  representation of the four input arrays and execution of the parsed
  source conversion loop 7367–7372: canonical output residues over the
  same integer coefficients. Source declarations, signed16 promotion,
  modp_set calls, uint32 stores, all 1536 iterations and value-preserving
  frames connected. Input/output non-aliasing and source entry layout
  remain explicit local premises for the enclosing caller to derive.
- Retained checks: `keygen_modular_memory_closure_009` (15/15),
  `keygen_residue_store_010`..`keygen_residue_vectors_016` (7 modules),
  `keygen_residue_audit_017` (20 type/term/axiom audits, 1.526s, standard
  Lean axioms or none; RECEIPTS SHA256
  `98a4a770a4c28c515ae8e1b4716d73d1e5bf58cf9163c0b8da83db467a617101`,
  SOURCE_INPUTS SHA256
  `5c940d560edff175ef01d8837201e4652da59354ddec426f417674527293dda9`),
  `keygen_modular_suffix_checks_002` (Sage ZZ, 13 signed boundary
  operands + 1536 synthetic coordinates, baseline + 4 mutations x
  normal/UBSan; result SHA256
  `ed336129760e5178d482150f8f4d34556663b7ac637fa053811867a2ba00327b`,
  receipt SHA256
  `e8262316089ab4418721d2ea16033a2363189ac8b45391f78dae890c370c866c`).
  The previous `_001` JSON-serialization failure remains retained.
- No batch009 fresh-replay receipt is claimed for those; the Sage probes
  are finite diagnostics, not replacements for kernel results.
- Resume boundary before this continuation: core/parser checkpoint
  `0d29f339`; conversion proofs `cdc1edb7`; parsed final solver check
  `49ad5794`/`ac8c985e`; static environment/CPP/cap/batch007
  `73d42e14`/`f256b438`/`6004ad89`; batch008 receipt
  `64198d2e86af3f48c650cde4868f4db3bad73ae3494233f03a8f70fdd9cf455a`.

## 6. Resume protocol (next window)

1. Read `WORK_STATE.md` (live), this file, the EXECUTION_PLAN, and the
   PLAN's section 1 target type; verify current pins against
   `SOURCE_INPUTS.json` of `keygen_ntt_frontend_002` and
   `keygen_ntt_butterfly_algebra_004` before any new claim.
2. Next code step is B1.02 with sections 2.2/2.3 as prepared input:
   extend `C99ModularParser` grammar (void return, pointer declarations,
   pointer assignment/advance with a pointer-name context, comma
   init/increment clauses, compound updates), patch the five consumers,
   parse `region 3046 91`, prove the composition is the complete source
   body. One proof job at a time (`tools/job_when_available.py`), unique
   labels, guarded serial compiles, logs 0/0, limits unchanged.
3. Small logical local commits on `main` with exact pathspecs after each
   verified step; NO push until an explicit owner signal. One Git writer
   at a time — coordinate with other lanes before touching the index.
4. Extraction of butterfly call observations (2.4) belongs with B1.02's
   "syntax/control separately" commit or immediately after it.

`emitted_to_actual_fiber` is still uninhabited. Nothing in this package
is REVIEWED; REVIEWED is never self-declared.
