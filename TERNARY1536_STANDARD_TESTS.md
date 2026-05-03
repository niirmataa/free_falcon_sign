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
