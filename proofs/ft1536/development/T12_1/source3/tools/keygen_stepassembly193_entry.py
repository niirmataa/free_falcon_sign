#!/usr/bin/env python3
"""Read-only resume verification for checkpoint193 (step assembly keeps).

Owner scope: before any new proof work, verify the sealed checkpoint192
closure and re-check every inherited pin into a fresh entry receipt.

Chain:
  1. .build/stepinverse192/POSTSEAL_192.json against its externally recorded
     SHA256 (KEYGEN_STEP_INVERSE_192_PINS.md) and the sealed receipt
     notes/run/KEYGEN_STEP_INVERSE_192.json against its external pin;
  2. every path pinned inside POSTSEAL_192.json (`checked`), each against
     its recorded SHA256;
  3. no active owned job/Lean/Sage process before writing the receipt.

Output receipt: .build/stepassembly193/ENTRY_PINS.json (exclusive create).
The receipt records only integrity facts; it claims no proof result.
"""
from datetime import datetime, timezone
import fcntl
import json
import sys

import job079 as job
import pre_sign_evidence084 as evidence

ROOT = evidence.ROOT
BUILD = ROOT / '.build/stepassembly193'
PREVIOUS = ROOT / '.build/stepinverse192/POSTSEAL_192.json'
PREVIOUS_SHA = '3c31e4610a48d95190d68952998c4a00962d5e896381f1372ed6aecf7582141a'
RECEIPT_192 = ROOT / 'notes/run/KEYGEN_STEP_INVERSE_192.json'
RECEIPT_192_SHA = '4a7edbb50b35b1a059670bf9eab5adc5ae4695d8c56328a6f14358cda38bb9f2'


def entry():
    evidence.check(PREVIOUS, PREVIOUS_SHA)
    evidence.check(RECEIPT_192, RECEIPT_192_SHA)
    data = json.loads(PREVIOUS.read_text())
    assert data['status'] == 'PASS_INTEGRITY; ACTIVE_CONTINUATION'
    checked = data['checked']
    assert len(checked) == 73379 == data['distinct_pinned_files']
    for path, digest in checked.items():
        evidence.check(path, digest)
    processes = job.active()
    assert not processes, processes
    BUILD.mkdir(parents=True, exist_ok=True)
    value = {
        'status': 'PASS_INTEGRITY',
        'verified_at': datetime.now(timezone.utc).isoformat(),
        'previous_postseal': evidence.pin(PREVIOUS),
        'previous_receipt': evidence.pin(RECEIPT_192),
        'checked_count': len(checked),
        'checked': checked,
        'active_processes': processes,
        'next_unused_job_suffix': 459,
        'scope': 'resume verification only; no proof claim',
    }
    print(json.dumps(evidence.write(BUILD / 'ENTRY_PINS.json', value)))


if __name__ == '__main__':
    with (ROOT / '.build/JOB.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        if sys.argv[1:]:
            raise SystemExit('no arguments; read-only entry verification')
        entry()
