# BATCH_016 — B1.03 stage (b): source modp_R2 value law CLOSED

Owner scope: **stage (b) only** after the pinned BATCH_015 / REV10 job
`keygen_rev10_cert_004`. This closes the requested scalar obligation, not
the whole B1.03 table-generation stage. Package status remains
**IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN**.

## 1. Actual result and premises

`KeygenModpR2.source_contract` consumes the existing source execution
`r2Body [.uint32 p, .uint32 p0i] v` and proves that the returned word `out`
satisfies:

```text
out.toNat < p.toNat
out.toNat = 2^62 % p.toNat
value p out = radix p * radix p       -- in ZMod p.toNat, radix = 2^31
```

Arithmetic premises are exactly `2^30 < p.toNat < 2^31`, odd `p`, and
`2^31 ∣ p.toNat*p0i.toNat+1`. **Primality is unnecessary.**
`parsed_contract` consumes the parse of region2575/24 and execution of
that code; the existing `r2_source_bound` identifies it with `r2Code`.
`call_contract` exposes the same result at the existing `ModCall` boundary.

For the actual first modulus, `initialized_value_law` takes only the
executed `modp_ninv31` initializer and `modp_R2` call. It derives the inverse
condition from the former. `initialized_to_montgomery` additionally
consumes a canonical input and executed multiplication by this `r2`,
obtaining canonical `R*a`. This is a scalar conversion, not a gm row law.

The independent source-execution judgment was not changed. The refinement
consumes the declaration, `modp_R`, doubling, five squarings, final halving,
assignment and return. `body_exists` and `call_exists` also construct
executions for arbitrary uint32 parameters/base state; the conditional
arithmetic result is not an empty-execution statement.

## 2. Proof structure and checked sources

- `KeygenModpR2Word`: generic arithmetic. After doubling and n squares,
  the canonical word represents `R*2^(2^n)`. At n=5 this is `2^63`.
  The low-bit mask is proved exact; the parity-adjusted sum fits uint32,
  is even, and its halving is canonical. Cancellation of the invertible
  radix and of2 yields the exact `R^2` residue.
- `KeygenModpR2Exec`: the same straight-line operations in `GenExec
  LeafCall`; leaf outputs follow their existing source-exact theorems.
  The halving expression is transported by its actual read set, so
  unrelated caller/global locals remain unrestricted.
- `KeygenModpR2`: parsed/body/call contracts and the source-initialized M0
  specialization. No assumed callee contract or desired result enters
  the reference semantics.
- `KeygenModpR2Audit`: records20 actual definition/export types, terms
  and transitive axioms in a sidecar, while keeping compiler logs empty.

| Accepted job | Seconds | Max RSS KiB |
|---|---:|---:|
| `keygen_modp_r2_word_002` | 1.618 | 2467348 |
| `keygen_modp_r2_exec_004` | 14.598 | 2515040 |
| `keygen_modp_r2_contract_001` | 2.720 | 2498728 |
| `keygen_modp_r2_audit_005` | 1.167 | 2489156 |
| `keygen_modp_r2_checks_001` (Sage) | 2.521 | 217892 |

Every accepted job has stdout/stderr **0/0 bytes**, exit0, no forbidden
markers and unchanged proof/resource limits. The runner is unchanged.
Each receipt and SOURCE_INPUTS pin is in the paired JSON. All new modules
were checked in dependency order; existing sources were not modified.
The old35-module parser/reference closure therefore did not need replay.

Audit sidecar: `.build/jobs/keygen_modp_r2_audit_005/MODP_R2_AUDIT.json`,
SHA256 `ab90b96085180b7d1868e405a9456f6b75528d4db491bbc178b8f0ac06af6ade`.
It contains4 definitions and16 theorems, no type/term elisions and only
`propext`, `Classical.choice`, `Quot.sound` (or subsets).
This is an internal audit, not independent review. The printer-only
`pp.maxSteps=200000` does not change proof checking or resource budgets.

## 3. Sage / pinned-C controls

`sage check_keygen_modp_r2.sage`, standard preparser and exact `ZZ`:
seven public odd moduli, including domain edges, odd composites and M0;
both pre-halving parities. Expected answers are independent modular
exponentiation, compared with extracted pinned C compiled in normal and
UBSan modes. Both baselines match; all three mutations (four squares,
missing parity correction, missing halving) are detected in each mode.
56 scalar observations across8 variants; finite diagnostics only.
The M0 observation is1352254458; the universal result is the Lean theorem.

Result: `.build/jobs/keygen_modp_r2_checks_001/MODP_R2_CHECK.json`, SHA256
`49c8f1b35cdb7561290779e0fd5d3ee20e0bc10b2289ab1e4ca7d00cf3171018`.
All generated C files, child compile/run logs and binaries stay in that
durable job directory. No production C was changed.

The generic Sage runner's unused Lean inventory predates the final audit
and names `audit_003`. Its historical source and olean match the retained
job copies. Sage consumes no Lean artifact; the final audit has its own
`_005` pins. The historical Sage SOURCE_INPUTS remains unchanged.

## 4. Retained attempts and traps

All attempted source snapshots, receipts and raw logs are retained:

- `word_001`: natural-literal normalization before `omega`, a redundant
  `rfl`, and a rewrite needing the named `value` definition exposed.
- `exec_001`: explicit intermediate states required in dependent
  `seqNormal` constructors and in `setZ_params`.
- `exec_002/003`: `++` versus an already-reduced `.append` in the recursive
  tail. Normalize `HAppend.hAppend` and `Append.append` on both sides.
- `audit_001`: direct IO lifting replaces unavailable unqualified `liftIO`.
- `audit_002`: theorem bodies require `ConstantInfo.value? (allowOpaque := true)`.
- `audit_003`: accepted types/axioms, but5 pretty-printed terms were elided;
  preserved as **superseded partial print**, not the final term audit.
- `audit_004`: the added elision guard correctly rejected the remaining
  large `call_contract` print under `pp.all`. The final `_005` uses normal
  notation with proofs/full names/universes and passes that guard. All
  theorem/resource limits stayed unchanged.

## 5. Reproduction and next boundary

From `source3`, using new unique labels and the unchanged guarded runner:

```sh
python3 -B tools/job_when_available.py lean NEW_R2_REPLAY_LABEL Source3.KeygenModpR2Word Source3.KeygenModpR2Exec Source3.KeygenModpR2 Source3.KeygenModpR2Audit
python3 -B tools/job_when_available.py sage NEW_R2_SAGE_LABEL check_keygen_modp_r2.sage
```

The runner provides persistent HOME/TMPDIR/cache and the pinned dependency
closure. Completed jobs and the BATCH_015 inputs were hash-checked, not
rerun unnecessarily. Source commits: `b3941188` and `1856d911`; this pair
and the expanded checkpoint form the final local documentation commit.
No push was performed. Shared Git writer lock and exact paths preserved
the concurrent paper/onboarding work.

**Next owner window: (c), row exponent/order laws and canonical ranges
from executed stores.** Then `igm=ft` overwrite, source-material/gm
preservation and caller layout. B1.04 and `t*m=n` remain later steps.
The final emitted-to-fiber theorem remains uninhabited. The result is
about the pinned source reference semantics, not a compiler/whole-KeyGen
correctness or security theorem.
