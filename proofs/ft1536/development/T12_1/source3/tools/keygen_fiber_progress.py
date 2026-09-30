#!/usr/bin/env python3
"""Pin unfinished continuation sources and their actual job outcomes.

This organizer performs hashing and receipt bookkeeping only. It cannot
issue a proof-batch receipt or upgrade the package/review status.
"""
from datetime import datetime, timezone
import json
from pathlib import Path
import sys

from keygen_fiber_batch import BATCH_MODULES, ROOT, sha


def record(batch, label):
    assert batch in BATCH_MODULES
    assert label.isdigit()
    jobs = sorted((ROOT / '.build/jobs').glob('keygen_prefix_connection_*'))
    rows, attempts = [], []
    for directory in jobs:
        preflight = directory / 'PREFLIGHT.json'
        receipt = directory / 'RECEIPTS.json'
        job = {'job': str(directory.relative_to(ROOT)),
               'preflight_sha256': sha(preflight),
               'processes_at_preflight': json.loads(preflight.read_text())['processes'],
               'steps': []}
        if receipt.exists():
            job['receipt_sha256'] = sha(receipt)
            for row in json.loads(receipt.read_text()):
                for stream in ('stdout', 'stderr'):
                    assert sha(directory / row[stream]) == row[stream + '_sha256']
                source = directory / 'formal' / (row['name'].replace('Source3_', 'Source3/', 1) + '.lean')
                assert sha(source) == row['source_sha256']
                job['steps'].append({key: row[key] for key in (
                    'name', 'accepted', 'clean_log', 'exit_code', 'source_sha256',
                    'stdout', 'stdout_sha256', 'stderr', 'stderr_sha256')})
        else:
            assert job['processes_at_preflight'], directory
            job['status'] = 'PREFLIGHT_BLOCKED_NO_PROOF_STARTED'
        attempts.append(job)
    for module in BATCH_MODULES[batch]:
        source = ROOT / 'formal' / (module.replace('.', '/') + '.lean')
        pin = sha(source)
        matching = [(job['job'], step) for job in attempts for step in job['steps']
                    if step['name'] == module.replace('.', '_') and step['source_sha256'] == pin]
        accepted = [job for job, step in matching if step['accepted'] and step['clean_log'] and step['exit_code'] == 0]
        rows.append({'module': module, 'source': str(source.relative_to(ROOT)), 'sha256': pin,
                     'status': 'INDIVIDUAL_MODULE_CHECKED' if accepted else 'DRAFT_NOT_YET_CHECKED',
                     'matching_accepted_jobs': accepted})
    result = {'task': 'KEYGEN_SOURCE_TO_FIBER_001', 'rung': 'B1',
              'status': 'IN_PROGRESS / NOT_REVIEWED',
              'utc': datetime.now(timezone.utc).isoformat(),
              'final_source_theorem_proved': False, 'fresh_batch_complete': False,
              'scope': 'Incomplete continuation checkpoint; not a completed proof-batch receipt',
              'organizer_sha256': sha(Path(__file__)), 'modules': rows, 'attempts': attempts}
    target = ROOT / ('notes/run/KEYGEN_SOURCE_TO_FIBER_001_PROGRESS_' + label + '.json')
    with target.open('x') as stream:
        json.dump(result, stream, indent=2, sort_keys=True)
        stream.write('\n')
    print(json.dumps({'path': str(target.relative_to(ROOT)), 'sha256': sha(target),
                      'individually_checked': sum(row['status'] == 'INDIVIDUAL_MODULE_CHECKED' for row in rows),
                      'modules': len(rows)}))


if __name__ == '__main__':
    if len(sys.argv) != 3:
        raise SystemExit('usage: keygen_fiber_progress.py BATCH UNIQUE_PROGRESS_LABEL')
    record(*sys.argv[1:])
