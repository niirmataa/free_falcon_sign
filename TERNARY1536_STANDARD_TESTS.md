# Ternary-1536 Standard Tests

This file defines the standard tests expected before a result is treated seriously.

## Audit Branch Tests

Run on `audit-ternary1536`.

Minimum smoke:

```sh
cd audit/ternary1536/build
make clean && make
./test_falcon
```

Public API smoke:

```sh
cd audit/ternary1536
scripts/run_public_api_20x100.sh
```

Larger audit tests should be added as branch scripts before results are committed:

```text
public API multi-key sign/verify
public signature norm audit
f,g distribution probe
estimator command log
```

## Empirical Attack-Question Matrix

Every open attack question should be answered with a reproducible run, not with wording alone.

| Question | Required empirical answer | Current status |
| --- | --- | --- |
| Does the normal CLI path work for ternary-1536? | `./falcon keygen -logt 10`, sign, verify, replayable transcript. | `5 keys x 10 messages`, `50/50` replay verifies in the local Proof evidence directory. |
| Does the measured keygen distribution match the model? | Raw accepted `f,g` sample, hashes, mean/stddev/max/histogram. | `100000` accepted keygens measured; dataset hash recorded in `TERNARY1536_WORKFLOW.md`. |
| Does larger measured keygen sigma break signatures? | Public sign/verify run plus signature-size and norm/bound summary. | `100000` signatures verified, `0` verify failures, mean signature size about `1983` bytes. |
| Does the obvious index-2 subfield norm-down shortcut work? | Enumerate all order-2 subgroups and compare relative-norm targets against GH. | All `7` index-2 subfields tested; worst observed target remained above GH in the `100000` run. |
| Can higher-index subfields become the bottleneck? | Run `k=3` and `k=6` sanity worksheets and compare margins. | Current sanity worksheets show larger margins than `k=2`; not treated as the bottleneck. |
| Is there a cheaper full-lattice key-recovery path in the estimator model? | Run lattice-estimator with measured distribution under multiple algorithms and shapes. | Measured-sigma NTRU/circulant worksheet exists; it is heuristic evidence only. |
| Is there a cheaper dual/hybrid/combinatorial path outside the current worksheet? | Add explicit dual/hybrid/combinatorial runs or record unsupported models as open. | Open until a dedicated run exists. |
| Is the implementation path changing the measured distribution? | Compare current double path against FPEMU/research path using identical seeds and summaries. | Research FPEMU comparison exists for a `10k` deterministic f,g probe; larger audit run still open. |
| Is native scalar FPU still a signer/keygen target? | Build and scan implementation objects with `objdump`/equivalent. | Research FPEMU scan recorded zero scalar-FPU hits for tested objects; production CT claim remains open. |
| Could timing/CT invalidate the implementation evidence? | ASAN/UBSAN, ctgrind/constant-time audit, timing/DUDECT-style tests. | Open. Do not claim CT or physical leakage resistance. |

Rule:

```text
If a question has no artifact-backed run, it stays open.
If a run exists, record the artifact path and the exact command.
Do not convert an empirical pass into a security-level declaration.
```

## Research Branch Tests

Run on `research-ternary1536`.

FPEMU smoke:

```sh
cd research/ternary1536/fpemu/build
make clean && make
./test_falcon

cd research/ternary1536/fpemu
scripts/count_scalar_fpu.sh
```

FPEMU acceptance criteria for research checkpoint:

```text
make completes
test_falcon completes
scalar FPU count for sign/fft/keygen implementation objects is zero
fresh f,g comparison against current double control is recorded
fresh public API sign/verify is recorded
fresh signature norm comparison is recorded
```

## Result Directory Rule

Each run directory should include:

```text
metadata.csv
source_hashes.sha256
command logs
summary CSV or text
SUMMARY.md
```

Do not commit generated object files or binaries as result artifacts.
