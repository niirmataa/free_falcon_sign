#!/usr/bin/env python3
"""Read-only entry-pin verification for the BATCH_028 window (B1.05b-c).

Owner scope: pins BATCH_015-027 before any new proof work. The chain is:
  1. the thirteen BATCH_015-027 JSON/NOTES pairs against their externally
     recorded hashes (checkpoint section 2 pins for 015-024, the committed
     BATCH_025 pair at 55752cf1 for 025, the committed BATCH_026 pair at
     6f30ed47 for 026, dba69ac1 for 027);
  2. .build/levels_027/ENTRY_PINS_027.json against its recorded hash and a
     full re-verification of all 2900 checked file pins (BATCH_015-026
     closure, 459 current BATCH_024 audit inputs included). Three closure
     pins (KeygenZintCall/KeygenZintCore/diagnostic KeygenZintProbe) are
     superseded on purpose: the
     ENTRY receipt records their pre-window-027 bytes while the window
     extended them and BATCH_027 accepted the new bytes. Such drift is
     accepted ONLY when the current file matches the BATCH_027
     accepted-module pin exactly, and is listed in the receipt field
     `superseded` with both hashes; every other mismatch still fails;
  3. every BATCH_027 accepted-module source pin and all 14 retained attempt
     job RECEIPTS.json pins;
  4. the receipt-less retained BATCH_027 attempt directory and no
     active owned job.
Output receipt: .build/levels_028/ENTRY_PINS_028.json (exclusive create).
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
    ('BATCH_026', '0418ae59af6ffe2d03a3b42ca3f63b18f4a2ef9008f696bcacad50e2452943a5',
     '27f85d9eb232cf1e39b96ecfe7c76cd26229750d2e599930d97cef2bfb3f63fd'),
    ('BATCH_027', 'd9da0c72e59e190e0843cdf9f67e328038a85f464cfac4b8b3dce84cdfbb1533',
     'b7524ac6a3809d626ce1416dd8c01ed1aee7d64fd516e5e90b1fda182e2a3825'),
]
ENTRY_PINS_027_SHA = '86aee101affed8c1e1e6459c1432429dad74aefab396d8cbdd24a730484c463e'
RECEIPTLESS = ('keygen_zint_bezout_probe_027_007',)


def verify():
    checked = {}

    def check(path, expected):
        actual = job.sha(job.ROOT / path) if not Path(path).is_absolute() else job.sha(Path(path))
        assert actual == expected, (str(path), expected, actual)
        checked[str(path)] = actual

    # 1. The thirteen externally pinned pairs.
    for batch, batch_sha, notes_sha in PAIRS:
        base = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_' + batch
        check(base + '.json', batch_sha)
        check(base + '_NOTES.md', notes_sha)

    # 2. The full BATCH_015-026 closure pinned at the previous window entry.
    entry = job.BUILD / 'levels_027' / 'ENTRY_PINS_027.json'
    assert job.sha(entry) == ENTRY_PINS_027_SHA, 'ENTRY_PINS_027.json changed'
    checked[str(entry)] = ENTRY_PINS_027_SHA
    record = json.loads(entry.read_text())
    assert record['distinct_pinned_files'] == 2900 and record['current_source_inputs'] == 459
    assert record['active_jobs'] == []
    batch = json.loads((job.ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_027.json').read_text())
    superseding = {e['source']: (name, e['sha256'])
                   for name, e in batch['accepted_modules'].items()}
    superseded = {}
    for path, expected in record['checked'].items():
        actual = job.sha(Path(path))
        if actual != expected:
            hit = superseding.get(path)
            assert hit is not None, (path, expected, actual)
            name, accepted = hit
            assert actual == accepted, (path, accepted, actual)
            superseded[path] = {'module': name, 'entry_pins_027': expected,
                                'batch_027': actual}
        else:
            checked[path] = actual

    # 3. BATCH_027 accepted modules and retained attempt receipts.
    for entry in batch['accepted_modules'].values():
        check(entry['source'], entry['sha256'])
    # Seven probes and seven proof attempts have receipts; the eighth probe
    # was refused before SOURCE_INPUTS/RECEIPTS (trap 112). Its directory is
    # retained and checked without inventing streams or proof evidence.
    assert len(batch['attempt_history']) == 14, len(batch['attempt_history'])
    assert set(batch['attempt_history_receiptless']) == set(RECEIPTLESS)
    for label, expected in batch['attempt_history'].items():
        check('.build/jobs/' + label + '/RECEIPTS.json', expected)
    for label in RECEIPTLESS:
        kept = job.BUILD / 'jobs' / label
        assert kept.is_dir() and not (kept / 'RECEIPTS.json').exists(), label

    active = job.active()
    assert not active, active
    return {'utc': datetime.now(timezone.utc).isoformat(), 'batch': 'BATCH_028',
        'pair_batches': [p[0] for p in PAIRS],
        'entry_pins_027_sha256': ENTRY_PINS_027_SHA,
        'superseded': superseded,
        'batch_027_attempt_receipts': len(batch['attempt_history']),
        'batch_027_receiptless_dirs': list(RECEIPTLESS),
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
