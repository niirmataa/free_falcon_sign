#!/usr/bin/env python3
"""Read-only entry-pin verification for the BATCH_026 window (B1.05).

Owner scope: pins BATCH_015-025 before any new work. The chain is:
  1. the eleven BATCH_015-025 JSON/NOTES pairs against their externally
     recorded hashes (checkpoint section 2 pins for 015-024, the committed
     BATCH_025 pair at 55752cf1 for 025);
  2. .build/levels_025/ENTRY_PINS_025.json against its recorded hash and a
     full re-verification of all 2847 checked file pins (BATCH_015-024
     closure, 459 current BATCH_024 audit inputs included);
  3. every BATCH_025 accepted-module source pin and all 17 retained attempt
     job RECEIPTS.json pins;
  4. no active owned job.
Output receipt: .build/levels_026/ENTRY_PINS_026.json (exclusive create).
"""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import sys

import job

# (batch, json_sha256, notes_sha256) - external pair pins.
PAIRS = [
    ('BATCH_015', 'b5bb63f5ddfb423ff6a4742dfd2893bcc7587b4cb50f51877b9b3910285be134',
     'aec981ffab3f9065ac10d6d99f4f931ceccd852f237382e3b0240b64fbe53cd8'),
    ('BATCH_016', 'cc28381bb1188400d0ea1d15e3c83ba045a2e5476a9644ee4dd0585c58e2b25f',
     'e323ac9783e41e2143638088af6cfb0453b756a8418273b62bd961c1b0695419'),
    ('BATCH_017', '50f35519c32d1d16dd6987b781ac43e59cc835dd076ce15f146a1fe9ac9cbc0b',
     '814660ca606d29600793dc3e61e5903b05ef56e83042b4d6aba131f86c6f28d6'),
    ('BATCH_018', 'f4e28b724e588b7e91cdb429646dfefe5939332f307f0ae15dc282369edc72cf',
     'c19d5c9cb893793dd6ff23fa232271fcfe704f0821160de1a1e2065551bd546d'),
    ('BATCH_019', '983a481a10293c01bf80250a9dd4ad2797e351db0a3c5d41825845d80fde6098',
     '289d85f0ec1f25fe5950ad6b182363afe9ede0484c3053cf0c915d9cd52b1c01'),
    ('BATCH_020', '6b8a839151d8d174eb1b6a8b09e1b2f02a8f6c20b8c9055d40e687e951602dff',
     'b402d5035667835182f539ed8ee8a812ad00a75687bd0662950373a098e26c6d'),
    ('BATCH_021', 'ed560886f8cacfe513cea222b46552cf3abc717a1232172a1da197753393395a',
     'a08b583aae3dc02996e21717eeab54085470b662b4854eb2dc5fa250b0701b55'),
    ('BATCH_022', 'e891df0f07b936c594130ec258afc31e2d18a0af1d30b63833d2b1b1481a52a8',
     '89d81f521e582421c8c62ad7f9f5fc140772f3b4fae8f5dd34cde252868196c3'),
    ('BATCH_023', 'b39218519e349795bad183b6ccc234c89c1aa11c7102d2ff57005a0344274a95',
     'd21ed7413e216eaee69afdbae2abdfc621ec3e04203491328c067af707859592'),
    ('BATCH_024', 'fbfe3b1c6c297b20b31d92370963c89aa1a0fe3cedfbfb5b0b799f1b3a72d365',
     '804a5d9ea7abc0b438e70cbe14d32bdb793f7a934b318d3b4e60727e8c57e344'),
    ('BATCH_025', '4b6752945f14ee7d84253c1f9d1f14d9f6389549073c93a0aeb12fc4b0956b94',
     '7b9a6cae8701134cc505e835f7100d8cab51281b506e1f49c40e647a052504d9'),
]
ENTRY_PINS_025_SHA = '92a8037b87b0490ae15ff4ed8878255bfe4534810d20838d13b1407c15fcb6f0'


def verify():
    checked = {}

    def check(path, expected):
        actual = job.sha(job.ROOT / path) if not Path(path).is_absolute() else job.sha(Path(path))
        assert actual == expected, (str(path), expected, actual)
        checked[str(path)] = actual

    # 1. The eleven externally pinned pairs.
    for batch, batch_sha, notes_sha in PAIRS:
        base = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_' + batch
        check(base + '.json', batch_sha)
        check(base + '_NOTES.md', notes_sha)

    # 2. The full BATCH_015-024 closure pinned at the previous window entry.
    entry = job.BUILD / 'levels_025' / 'ENTRY_PINS_025.json'
    assert job.sha(entry) == ENTRY_PINS_025_SHA, 'ENTRY_PINS_025.json changed'
    checked[str(entry)] = ENTRY_PINS_025_SHA
    record = json.loads(entry.read_text())
    assert record['distinct_pinned_files'] == 2847 and record['current_source_inputs'] == 459
    assert record['active_jobs'] == []
    for path, expected in record['checked'].items():
        actual = job.sha(Path(path))
        assert actual == expected, (path, expected, actual)
        checked[path] = actual

    # 3. BATCH_025 accepted modules and retained attempt receipts.
    batch = json.loads((job.ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_025.json').read_text())
    for entry in batch['accepted_modules'].values():
        check(entry['source'], entry['sha256'])
    # 17 attempts carry receipts and are pinned in attempt_history; the two
    # receipt-less retained directories (keygen_zint_core_025_006 and
    # keygen_zint_probe_025_006) are preflight/interrupt history and are kept
    # as-is, matching the 19 retained jobs of the BATCH_025 notes.
    assert len(batch['attempt_history']) == 17, len(batch['attempt_history'])
    for label, expected in batch['attempt_history'].items():
        check('.build/jobs/' + label + '/RECEIPTS.json', expected)
    for label in ('keygen_zint_core_025_006', 'keygen_zint_probe_025_006'):
        kept = job.BUILD / 'jobs' / label
        assert kept.is_dir() and not (kept / 'RECEIPTS.json').exists(), label

    active = job.active()
    assert not active, active
    return {'utc': datetime.now(timezone.utc).isoformat(), 'batch': 'BATCH_026',
        'pair_batches': [p[0] for p in PAIRS],
        'entry_pins_025_sha256': ENTRY_PINS_025_SHA,
        'batch_025_attempt_receipts': len(batch['attempt_history']),
        'checked': checked, 'distinct_pinned_files': len(checked),
        'current_source_inputs': 459, 'active_jobs': active,
        'verifier_sha256': job.sha(Path(__file__))}


if __name__ == '__main__':
    assert len(sys.argv) in (1, 2), 'usage: keygen_zint_entry_pins.py [new_receipt_path]'
    result = verify()
    if len(sys.argv) == 2:
        target = (job.ROOT / sys.argv[1]).resolve()
        assert target.is_relative_to(job.BUILD.resolve())
        with target.open('x') as stream:
            json.dump(result, stream, indent=2)
            stream.write('\n')
        result['receipt_sha256'] = job.sha(target)
    print(json.dumps({k: v for k, v in result.items() if k != 'checked'}, indent=2))
