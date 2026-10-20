#!/usr/bin/env python3
"""Read-only resume verification for the gs-path window (s4-s7, then s8).

Owner scope: before any new proof work, verify the sealed checkpoint193
closure and re-check every inherited pin into a fresh entry receipt.

Chain:
  1. .build/stepassembly193/POSTSEAL_193.json against its externally recorded
     SHA256 (KEYGEN_STEP_ASSEMBLY_193_PINS.md) and the sealed receipt
     notes/run/KEYGEN_STEP_ASSEMBLY_193.json against its external pin;
  2. every path pinned inside POSTSEAL_193.json (`checked`), each against
     its recorded SHA256;
  3. no active owned job/Lean/Sage process before writing the receipt.

Output receipt: .build/stepgs194/ENTRY_PINS.json (exclusive create).
The receipt records only integrity facts; it claims no proof result.
"""
from datetime import datetime, timezone
import fcntl
import json
import sys

import job079 as job
import pre_sign_evidence084 as evidence

ROOT = evidence.ROOT
BUILD = ROOT / '.build/stepgs194'
PREVIOUS = ROOT / '.build/stepassembly193/POSTSEAL_193.json'
PREVIOUS_SHA = '386e4cbcf8ecee725cec39de9e32e0012d8c0efbdb96b8f0f99fe9a03e964562'
RECEIPT_193 = ROOT / 'notes/run/KEYGEN_STEP_ASSEMBLY_193.json'
RECEIPT_193_SHA = '1d6f11ec19d5b0cb0f1f4ba4be63bd9d74f4800bcef66d55d611a00931b16d3e'


def entry():
    evidence.check(PREVIOUS, PREVIOUS_SHA)
    evidence.check(RECEIPT_193, RECEIPT_193_SHA)
    data = json.loads(PREVIOUS.read_text())
    assert data['status'] == 'PASS_INTEGRITY; ACTIVE_CONTINUATION'
    checked = data['checked']
    assert len(checked) == 73564 == data['distinct_pinned_files']
    for path, digest in checked.items():
        evidence.check(path, digest)
    processes = job.active()
    assert not processes, processes
    BUILD.mkdir(parents=True, exist_ok=True)
    value = {
        'status': 'PASS_INTEGRITY',
        'verified_at': datetime.now(timezone.utc).isoformat(),
        'previous_postseal': evidence.pin(PREVIOUS),
        'previous_receipt': evidence.pin(RECEIPT_193),
        'checked_count': len(checked),
        'checked': checked,
        'active_processes': processes,
        'next_unused_job_suffix': 467,
        'scope': 'resume verification only; no proof claim',
    }
    print(json.dumps(evidence.write(BUILD / 'ENTRY_PINS.json', value)))


if __name__ == '__main__':
    with (ROOT / '.build/JOB.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        if sys.argv[1:]:
            raise SystemExit('no arguments; read-only entry verification')
        entry()
