#!/usr/bin/env python3
"""Check the sealed BATCH_022 closure before the B1.05 search continuation."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import subprocess

import job

ROOT = job.ROOT
PINS = {
    '015.json': 'b5bb63f5ddfb423ff6a4742dfd2893bcc7587b4cb50f51877b9b3910285be134',
    '015_NOTES.md': 'aec981ffab3f9065ac10d6d99f4f931ceccd852f237382e3b0240b64fbe53cd8',
    '016.json': 'cc28381bb1188400d0ea1d15e3c83ba045a2e5476a9644ee4dd0585c58e2b25f',
    '016_NOTES.md': 'e323ac9783e41e2143638088af6cfb0453b756a8418273b62bd961c1b0695419',
    '017.json': '50f35519c32d1d16dd6987b781ac43e59cc835dd076ce15f146a1fe9ac9cbc0b',
    '017_NOTES.md': '814660ca606d29600793dc3e61e5903b05ef56e83042b4d6aba131f86c6f28d6',
    '018.json': 'f4e28b724e588b7e91cdb429646dfefe5939332f307f0ae15dc282369edc72cf',
    '018_NOTES.md': 'c19d5c9cb893793dd6ff23fa232271fcfe704f0821160de1a1e2065551bd546d',
    '019.json': '983a481a10293c01bf80250a9dd4ad2797e351db0a3c5d41825845d80fde6098',
    '019_NOTES.md': '289d85f0ec1f25fe5950ad6b182363afe9ede0484c3053cf0c915d9cd52b1c01',
    '020.json': '6b8a839151d8d174eb1b6a8b09e1b2f02a8f6c20b8c9055d40e687e951602dff',
    '020_NOTES.md': 'b402d5035667835182f539ed8ee8a812ad00a75687bd0662950373a098e26c6d',
    '021.json': 'ed560886f8cacfe513cea222b46552cf3abc717a1232172a1da197753393395a',
    '021_NOTES.md': 'a08b583aae3dc02996e21717eeab54085470b662b4854eb2dc5fa250b0701b55',
    '022.json': 'e891df0f07b936c594130ec258afc31e2d18a0af1d30b63833d2b1b1481a52a8',
    '022_NOTES.md': '89d81f521e582421c8c62ad7f9f5fc140772f3b4fae8f5dd34cde252868196c3',
}


def verify():
    checked = {}

    def check(path, expected):
        path = ROOT / path
        actual = job.sha(path)
        assert actual == expected, (str(path), expected, actual)
        checked[str(path)] = actual

    def walk(value):
        if isinstance(value, dict):
            if 'path' in value and 'sha256' in value:
                check(value['path'], value['sha256'])
            for child in value.values():
                walk(child)
        elif isinstance(value, list):
            for child in value:
                walk(child)

    for name, expected in PINS.items():
        check('notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_' + name, expected)
    batch = json.loads((ROOT/'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_022.json').read_text())
    walk(batch)
    previous = json.loads((ROOT/batch['preflight']['path']).read_text())['checked']
    assert len(previous) == 1840
    for path, expected in previous.items():
        check(path, expected)
    inventory = json.loads((ROOT/batch['audit']['source_inputs']['path']).read_text())
    for entry in inventory['sources']:
        check(entry['path'], entry['sha256'])
    for entry in inventory['reused']:
        check(entry.get('current_source', entry['source']), entry['source_sha256'])
        check(entry['artifact'], entry['artifact_sha256'])
    assert len(inventory['sources']) + len(inventory['reused']) == 433
    assert len(batch['attempt_history']) == 45
    processes = job.active()
    assert not processes, processes
    assert subprocess.check_output(['git', 'branch', '--show-current'], cwd=job.REPO, text=True).strip() == 'main'
    return {
        'utc': datetime.now(timezone.utc).isoformat(),
        'head': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=job.REPO, text=True).strip(),
        'physical_repo': str(job.REPO.resolve()), 'stage': 'B1.05',
        'harness': 'openai/gpt-6-astra-ultrafast', 'resume_section': 6,
        'processes': processes, 'checked': checked, 'current_source_inputs': 433,
        'predecessor_files': len(previous), 'retained_batch022_attempts': 45,
    }


def main():
    target = ROOT/'.build/search_023/PREFLIGHT.json'
    assert not target.exists(), 'Never overwrite historical evidence'
    record = verify()
    target.parent.mkdir(parents=True, exist_ok=True)
    with target.open('x') as stream:
        json.dump(record, stream, indent=2)
        stream.write('\n')
    print(json.dumps({'files': len(record['checked']), 'current_source_inputs': 433,
        'predecessor_files': 1840, 'preflight_sha256': hashlib.sha256(target.read_bytes()).hexdigest(),
        'active_jobs': record['processes']}))


if __name__ == '__main__':
    main()
