#!/usr/bin/env python3
"""Read-only resume verification for checkpoint192 (inverse call s3).

Owner scope: before any new proof work, verify the sealed checkpoint191
closure and re-check every inherited pin into a fresh entry receipt.

Chain:
  1. .build/stepproduct191/POSTSEAL_191.json against its externally recorded
     SHA256 (KEYGEN_R1_TAIL_TODO.md / KEYGEN_STEP_PRODUCT_191_PINS.md) and the
     sealed receipt notes/run/KEYGEN_STEP_PRODUCT_191.json against its
     external pin;
  2. every path pinned inside POSTSEAL_191.json (`checked`), each against
     its recorded SHA256;
  3. no active owned job/Lean/Sage process before writing the receipt.

Output receipt: .build/stepinverse192/ENTRY_PINS.json (exclusive create).
The receipt records only integrity facts; it claims no proof result.
"""
from datetime import datetime, timezone
import fcntl
import json
import sys

import job079 as job
import pre_sign_evidence084 as evidence

ROOT = evidence.ROOT
BUILD = ROOT / '.build/stepinverse192'
PREVIOUS = ROOT / '.build/stepproduct191/POSTSEAL_191.json'
PREVIOUS_SHA = '97d24fdeeb2bd7e443b1ec1a2982163e10b650926ff5002523235ca86f201087'
RECEIPT_191 = ROOT / 'notes/run/KEYGEN_STEP_PRODUCT_191.json'
RECEIPT_191_SHA = 'cd2798f1139e5eb05d0724f11a4ebc8128cb8311ddd326d3220ddd9b5cb997ae'


def entry():
    evidence.check(PREVIOUS, PREVIOUS_SHA)
    evidence.check(RECEIPT_191, RECEIPT_191_SHA)
    data = json.loads(PREVIOUS.read_text())
    assert data['status'] == 'PASS_INTEGRITY; ACTIVE_CONTINUATION'
    checked = data['checked']
    assert len(checked) == 71052 == data['distinct_pinned_files']
    for path, digest in checked.items():
        evidence.check(path, digest)
    processes = job.active()
    assert not processes, processes
    BUILD.mkdir(parents=True, exist_ok=True)
    value = {
        'status': 'PASS_INTEGRITY',
        'verified_at': datetime.now(timezone.utc).isoformat(),
        'previous_postseal': evidence.pin(PREVIOUS),
        'previous_receipt': evidence.pin(RECEIPT_191),
        'checked_count': len(checked),
        'checked': checked,
        'active_processes': processes,
        'next_unused_job_suffix': 377,
        'scope': 'resume verification only; no proof claim',
    }
    print(json.dumps(evidence.write(BUILD / 'ENTRY_PINS.json', value)))


if __name__ == '__main__':
    with (ROOT / '.build/JOB.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        if sys.argv[1:]:
            raise SystemExit('no arguments; read-only entry verification')
        entry()
