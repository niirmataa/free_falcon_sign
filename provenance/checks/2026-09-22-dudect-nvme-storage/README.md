# Dudect RUN_002 — verified NVMe storage and fresh static build

2026-09-22. Author: Niirmata. Storage preparation follows the owner's explicit
confirmation to format `/dev/nvme0n1p3` as ext4 for FT1536 data.

**PASS_NVME_STORAGE_AND_TEN_HOUR_STATIC_PREPARATION**.
The former disk-space blocker is resolved. The campaign remains unstarted,
awaiting the owner's signal, mains power and fresh physical preflight.

## Storage and preservation

- Confirmed ext4 volume `FT1536_DATA`, UUID
  `da38b9e9-0e22-4c55-b3e0-c46b9f293eca`, mounted at
  `/media/footfalcon/FT1536_DATA`.
- Verified copy of440 files/9517892 bytes for the unstarted RUN_002;
  full hashes, sizes, modes and mtimes match. Original retained in the local
  NVMe-preparation workspace, as recorded in RELOCATION_RESULT.json.
- The canonical RUN_002 path is an alias to the NVMe directory. Git remains
  in `/home/footfalcon/free_falcon_sign`; baseline RUN_001 remains at its path.
- After the fresh build:235831001088 bytes available, versus93751083008
  required for36000 seconds. statvfs through the alias observes NVMe.

## Fresh check on the destination

Attempt **004** rebuilt the unchanged pinned floor-ct harness directly on
NVMe:28672 fixtures, branch-free floor assembly and3 truncated raw-record
checks passed. All current harness and source hashes match. All prior sealed
preparations000–003 remain valid. The CFLAGS source directory now names the
physical NVMe location. No physical timing trials were executed.

PREPARATION SHA-256:
`aef846c33fba6f128dbdfbc5ae03a8db6d8915f618f734c914597b8bc03cc4a1`.
Status STATIC_READY_TIMING_DEFERRED, global_seconds36000, CPU=null,checks=[].
Service inactive/MainPID0; no RUN.json or LAUNCH.json.

[CHECKS.sha256](CHECKS.sha256) seals110 files,2070426 bytes; SHA-256:
`3aca31eec2076af2a2de7d66ebd6842312c080368d714b8d2bc0cf4e4e1e8008`.
It retains format/relocation results, copy inventory, fresh preparation/build
evidence, machine/service/mount state and the current NIGHT_START instructions.
The preceding [ten-hour checks](../2026-09-22-dudect-ten-hour-preparation/README.md)
retain11 unit tests and native budget boundary probes; their earlier low-space
snapshot is historical. The official engine/targets/statistical protocol retain
their pinned definitions.

See [storage and remount instructions](../../FT1536_DATA_STORAGE.md). Planned
manual signal is around03:00 CEST; actual start/deadline will come from RUN.json
after physical preflight. No automatic timer was installed.
