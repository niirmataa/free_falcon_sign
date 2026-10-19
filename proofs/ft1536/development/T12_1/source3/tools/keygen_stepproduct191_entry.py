#!/usr/bin/env python3
"""Read-only resume verification for checkpoint191 (pair-product loop s2).

Owner scope: before any new proof work, verify the sealed checkpoint190
closure and re-check every inherited pin into a fresh entry receipt.

Chain:
  1. .build/steptail190/POSTSEAL_190.json against its externally recorded
     SHA256 (KEYGEN_STEP_COPY_190_PINS.md) and the sealed receipt
     notes/run/KEYGEN_STEP_COPY_190.json against its external pin;
  2. every path pinned inside POSTSEAL_190.json (`checked`), each against
     its recorded SHA256;
  3. no active owned job/Lean/Sage process before writing the receipt.

Output receipt: .build/stepproduct191/ENTRY_PINS.json (exclusive create).
The receipt records only integrity facts; it claims no proof result.
"""
from datetime import datetime, timezone
import fcntl
import json
import sys

import job079 as job
import pre_sign_evidence084 as evidence

ROOT = evidence.ROOT
BUILD = ROOT / '.build/stepproduct191'
PREVIOUS = ROOT / '.build/steptail190/POSTSEAL_190.json'
PREVIOUS_SHA = 'd15f8d30f0a40cd3c8cb37225f051ccf0c641304ebb3af47611733d2101764cb'
RECEIPT_190 = ROOT / 'notes/run/KEYGEN_STEP_COPY_190.json'
RECEIPT_190_SHA = 'dd76380b944d686463d8f2b6676f6936329a21823a1f3ca2c257f5af19655c37'


def entry():
    evidence.check(PREVIOUS, PREVIOUS_SHA)
    evidence.check(RECEIPT_190, RECEIPT_190_SHA)
    data = json.loads(PREVIOUS.read_text())
    assert data['status'] == 'PASS_INTEGRITY; ACTIVE_CONTINUATION'
    checked = data['checked']
    assert len(checked) == 70613 == data['distinct_pinned_files']
    for path, digest in checked.items():
        evidence.check(path, digest)
    processes = job.active()
    assert not processes, processes
    BUILD.mkdir(parents=True, exist_ok=True)
    value = {
        'status': 'PASS_INTEGRITY',
        'verified_at': datetime.now(timezone.utc).isoformat(),
        'previous_postseal': evidence.pin(PREVIOUS),
        'previous_receipt': evidence.pin(RECEIPT_190),
        'checked_count': len(checked),
        'checked': checked,
        'active_processes': processes,
        'next_unused_job_suffix': 363,
        'scope': 'resume verification only; no proof claim',
    }
    print(json.dumps(evidence.write(BUILD / 'ENTRY_PINS.json', value)))


if __name__ == '__main__':
    with (ROOT / '.build/JOB.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        if sys.argv[1:]:
            raise SystemExit('no arguments; read-only entry verification')
        entry()
