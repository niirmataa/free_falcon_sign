# Dudect RUN_002 — ten-hour static preparation, 2026-09-22

Author: Niirmata. Parent commit:
`b2c7dadd527da50cb286755c9461da366f9ccf49`.
Owner request: manual start around03:00 CEST, then a **36000-second campaign**.

**PASS_TEN_HOUR_STATIC_PREPARATION**; live launch readiness at capture:
**BLOCKED_INSUFFICIENT_DISK**. No physical timing trials, long campaign or
automatic timer was started. Fresh physical preflight remains required.

## Changes and completed checks

- Shared Python campaign maximum and the C worker's per-trial guard accept
  up to36000 seconds. The historical default remains28800. The prepared
  RUN_002 budget is explicitly36000, propagated to fresh preflight, controller
  argv and systemd RuntimeMaxSec; stop grace remains5s.
-11 unit checks passed, covering six/eight/ten-hour launcher propagation,
  budget mismatches, exact disk boundary and deferred-preflight/source gates.
- Fresh static attempt **003** passed28672 fixture checks, branch-free floor
  assembly checks and3 truncated-record rejection checks. CPU=null,checks=[].
- Native budget probes accepted28800/36000 and rejected36001. They deliberately
  used fdopen(-1), stopping before clocks, warmups and dudect_main. No timings
  were taken by these probes; their expected exit2/stderr are retained.
- Previous attempts000–002 and their sealed inputs were verified and retained.
  Current harness/source/binary hashes match the new preparation.

Source profile remains floor-ct,17-file manifest
`56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
The benchmark CLI duration guard changed; production sources, scalar targets,
official dudect engine, thresholds,12 contrasts×3 rounds, all raw samples
and2MiB/s compressed/statistical output budget retain their prior definitions.

## Disk condition and manual launch

Ten-hour prescribed output budget:70.3125GiB plus17GiB reserve, requiring
**93751083008 bytes (87.3125GiB)** free on the work filesystem.
At capture:63778033664 bytes available,29973049344 bytes missing (about27.92GiB).
The launcher checks current free space before physical measurements. Static
build success is not permission to bypass this condition.

After resolving space, stopping proof/build jobs, connecting mains power and
receiving the owner's nighttime start signal, follow [NIGHT_START.md](NIGHT_START.md).
Physical preflight has180s plus5s kill grace; only then does the ten-hour
campaign start. Its actual start/deadline will be recorded in RUN.json.
The planned end is around13:00 CEST plus preflight time; there is no clock timer.

## Retained receipts

PREPARATION SHA-256:
`951bbb713daccc1615a0fb58ae5972f0530fcf0b521af625e935a93c13e28ae9`.

[CHECKS.sha256](CHECKS.sha256) seals118 files,1985442 bytes; SHA-256:
`4701eaabc1677c2555df04566a63ccaf08eacce5afc21d3b4a619046c6baf9aa`.
It retains preparation, harness, fixture/assembly/build logs, unit/native
budget checks, machine/service snapshot and [READINESS.json](READINESS.json).
Working binaries/objects remain in the durable RUN_002 work directory, with
their hashes sealed by PREPARATION.json. Historical preparations are unchanged.
