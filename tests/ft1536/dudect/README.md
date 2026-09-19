# FT1536 baseline FPEMU — bounded official dudect campaign

Public scalar-only harness by Niirmata. The production 17-file manifest is
`2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`.
Compilation parses the actual candidate Makefile (`-O`, without LTO or march
changes). The backend and scalar wrappers are separate translation units.
The code does not call KeyGen, load a secret key, or Sign.

## Reproduction and provenance

`prepare.py` downloads only these three unmodified public files from
`oreparaz/dudect`, commit **dc269651fb2567e46755cfb2a13d3875592968b5**:

| Upstream path | Git blob SHA-1 |
|---|---|
| src/dudect.h | ff8cfce31e2d958e5408b19bad0f46841fc1a4a6 |
| LICENSE | 8869bf6ee9134f230f6219537e3b82db4a9371e6 |
| README.md | 67bbe9538048c1f4be84e7decb1f355bf47e130b |

Blob identities are checked before use; SHA-256, URL, size and commit are
retained in `upstream.json` and `PREPARATION.json`. Retain both the upstream
LICENSE (MIT) and the notices/public-domain wording inside the header.
No package installation is needed: GCC, Python standard library, taskset,
objdump and systemd are sufficient. All writable output goes into a separate
work directory; failed preparation attempts are retained rather than replaced.

```sh
python3 -B tests/ft1536/dudect/prepare.py --repo "$PWD" --work /absolute/new/work
```

The work's `PREPARATION.json` names the frozen harness, binary, all hashes,
chosen non-SMT CPU, compiler argv and short preflight results. Preparation
checks 2048 fixtures per case against independent arithmetic/domain checks,
positive/negative controls and exact replay of every preflight t-test state
from the recorded raw timings. The `lt` and `half` checks explicitly retain
known source semantics, rather than silently asserting IEEE/numeric correctness.
Original `falcon-sign.c` assembly and full binary objdump are also saved.

## Prespecified contrasts

Classes are exactly balanced within each 100000-input batch, Fisher–Yates
shuffled with rejection-sampled indices. SplitMix64 is only a reproducible
**public** ordering/fixture generator; independent initial states derive from
SHA-256 of `FT1536-public-dudect-v1/round/case`. All preparation is outside
the timed region. The negative control samples the same distribution for
both labels. No label is read by the timed callback.

| ID | Target | Class0 / Class1 |
|---|---|---|
|0|negative floor|same independent uniform mantissas, exponent1021|
|1|positive control|explicit volatile loop8 / loop256, separate target|
|2|floor fixed positive|+1/4 / +3/4|
|3|floor fixed negative|−1/4 / −3/4|
|4|floor randomized|exponent1021 /1022; independent random sign and mantissa|
|5|add cancellation|x+x / x−x; x in[1,2)|
|6|mul significand carry|x² with x in[1,1.125) /[1.75,1.875)|
|7|div denominator bounds|x/(1/16) /x/2^35; x in[1,2)|
|8|sqrt exponent parity|positive exponent1023 /1024|
|9|rint ties|integer+1/2 /integer+1/4, integer in[−1024,1023]|
|10|expm endpoints|+0 /one binary64 step below the pinned log2 constant|
|11|half boundary|raw0010000000000001 /0020000000000001|
|12|lt signed zeros|lt(−0,+0) /lt(+0,+0), generic diagnostic domain|
|13|scaled zero|integer0 /positive integer1..2^31, scale0|

One operation per callback, with a volatile result sink and a uniform
64-byte input stride. The selected target function pointer is constant for
the whole trial. Timing uses the **unmodified official dudect implementation**
(its MFENCE/RDTSC method, percentile calibration, cropping and second-order
test). There are 10000 extra target warmups; upstream additionally discards
the calibration batch and samples0..9/the final untimed slot of later batches.
Raw uncropped class counts, all102 test states, percentiles and original
dudect stdout are recorded. No statistical thresholds are tuned after observing
data: upstream returns LEAKAGE_FOUND for max abs(t)>10 (strong message>500).

## Eight-hour schedule and termination

`campaign.py WORK --cpu CPU --seconds 28800` has three prespecified rounds,
each with positive and negative controls followed by all12 production contrasts.
Target order rotates by four positions between rounds. Each control has≤30s;
the remaining global time is shared by remaining trials, reserving later
controls. An upstream leakage decision ends that trial; its unused time is
redistributed. If every trial finishes early, the campaign ends early.
Wall budget includes data preparation, statistics, compression and monitoring,
not eight hours of timed instructions alone. Finalization has a15s reserve.
Complete raw/statistics output is rate-limited to2MiB/s (at most about56.25GiB
over eight hours, plus small metadata), by waiting between batches. This
prespecified storage bound discards no samples and does not add work inside
the timed callback. Compressed and stdout hashes are calculated incrementally.

The intended launcher is a transient user systemd service, with RuntimeMaxSec
28800, a bounded stop grace and KillMode=control-group, wrapping
`systemd-inhibit --what=sleep:idle --mode=block`. This survives the command
session. The inhibitor is released on exit. `systemctl --user stop UNIT`
stops the campaign and its own children. Creating `WORK/STOP` requests a
graceful stop; a stopped/unfinished trial is INCONCLUSIVE.

After reviewing/committing the exact preparation sources, launch with:

```sh
python3 -B tests/ft1536/dudect/launch.py /absolute/work
systemctl --user status ft1536-dudect-run-001.service
```

The launcher checks sealed inputs, matches the preflighted harness to the
committed sources, verifies mains power and saves its argv/commit/service
identity in `LAUNCH.json` and `service-start.txt`. Unit name is deliberately
single-use for this campaign; it does not stop or replace another service.

The worker alone is pinned to the preflighted non-SMT CPU. Governor/turbo,
frequency, load, topology, microcode/kernel, power and temperatures are
recorded without claiming exclusive host reservation. **This shared-desktop
run is exploratory**: platform interference remains a limitation; absent
fully controlled conditions, it is not a definitive CT evaluation.
Negative-control leakage/insufficient counts is prominently flagged in the
final report, never reclassified as a pass. A failed positive control,
incomplete raw record, disk free below16GiB or execution failure stops the run.

## Receipts and independent recalculation

`RUN.json` tracks overall progress, `ACTIVE.json` points to the current trial;
that trial's `status.json` updates every completed batch. `RESULT.json` and
`REPORT.md` appear at termination. Each trial retains argv, input ordering,
binary/source hashes via preparation, complete stdout/stderr, machine
snapshots, `receipt.json`, and `timings.bin.gz`.

The raw little-endian format is magic `FTDUD01\n`, followed by frames:
three uint64 `(number_measurements, batch_number, PRNG_state_before_batch)`,
then `number_measurements` class bytes and that many int64 tick differences.
The final difference is a zero sentinel (not a measurement). The calibration
batch retains its original unsorted differences. All observations, including
outliers, are retained; the official engine applies its own cropping.

The C worker sends a complete batch to its parent and waits for an ACK.
Python compresses and snapshots while the worker is waiting, so compression
does not overlap the next timed batch. No zlib development package is needed.
The protocol has a120s per-batch watchdog plus trial/global deadlines.

To recompute the official engine's statistics from raw records:

```sh
python3 -B WORK/attempts/NNN/harness/campaign.py WORK --replay-trial WORK/campaign/round-0/floor_fixed_positive
```

The recalculation must reproduce every recorded test state exactly; timings
themselves are nondeterministic and a new physical run need not give the same
statistics. Preserve all trials and controls, not only significant results.
Do not import the active work as a completed proof checkpoint.

## Interpretation

`NO_LEAKAGE_EVIDENCE_YET` means exactly that, at the recorded sample budget.
`LEAKAGE_FOUND` is the engine's statistical evidence for the measured contrast;
check replication, controls and platform conditions before interpretation.
These synthetic scalar tests do not establish emitted-key reachability or a
Sign attack, and do not add timing to M0's observation game. The already
confirmed operand-dependent compiled floor branch remains a structural
finding regardless of the statistical result. No production correction is
included in this campaign.
