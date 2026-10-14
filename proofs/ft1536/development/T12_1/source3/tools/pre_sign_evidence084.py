#!/usr/bin/env python3
"""Additive B1.10/B1.11 evidence; never rewrites a historical receipt."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib
import json
import subprocess
import sys
import job079 as job

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parents[4]
BUILD = ROOT / '.build/pre_do_sign084'
REVIEW = REPO / 'proofs/ft1536/work/FT1536_B1_CLOSEOUT_REVIEW_001'
OLD = ROOT / '.build/levels_083/WHOLE_ASSEMBLY_POSTSEAL_001.json'
OLD_SHA = 'c030bfa32b6b45d7ddabc2a5b1582ed9aef225df6078c68f320e047bdf98218b'
REPORT_SHA = 'b4df4d69026bd115e2b484114a02d838cba96ab17b732f303466c972fb0ac711'
RESULT_SHA = 'ee08045320d754083f4cd3da4c2c6f1b9107bd603f073b7a357e084cdc2ea28d'


def sha(p):
    with Path(p).open('rb') as f:
        return hashlib.file_digest(f, 'sha256').hexdigest()


def pin(p):
    p = Path(p).resolve()
    return {'path': str(p), 'sha256': sha(p), 'bytes': p.stat().st_size}


def check(p, expected):
    assert sha(p) == expected, ('INTEGRITY_STOP', str(p), expected, sha(p))


def write(p, value):
    with Path(p).open('x') as f:
        json.dump(value, f, indent=2)
        f.write('\n')
    return pin(p)


def incoming():
    check(OLD, OLD_SHA)
    data = json.loads(OLD.read_text())
    assert len(data['checked']) == 21798
    for p, expected in data['checked'].items():
        check(p, expected)
    check(REVIEW / 'REVIEW_B1_CLOSEOUT_001.md', REPORT_SHA)
    check(REVIEW / 'REVIEW_B1_CLOSEOUT_001_RESULT.json', RESULT_SHA)
    return data['checked']


def job_files(label):
    folder = ROOT / '.build/jobs' / label
    return [pin(p) for p in sorted(folder.rglob('*')) if p.is_file()
            and not p.is_symlink() and (p.parent == folder or p.parent == folder / 'logs'
                                      or p.suffix in {'.lean', '.olean'})]


def contract():
    incoming()
    assert not job.active(), job.active()
    final = ROOT / '.build/jobs/keygen_contract084_003'
    records = json.loads((final / 'RECEIPTS.json').read_text())
    assert len(records) == 2
    for r in records:
        assert r['accepted'] and r['clean_log'] and r['exit_code'] == 0
        assert not r['forbidden_proof_markers']
        assert (final / r['stdout']).stat().st_size == (final / r['stderr']).stat().st_size == 0
    audit = json.loads((final / 'SEARCH_AUDIT.json').read_text())
    assert len(audit) == 11
    assert all(set(r['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'} for r in audit)
    assert all('⋯' not in json.dumps(r, ensure_ascii=False) for r in audit)
    for r in records:
        check(ROOT / 'formal/Source3' / (r['name'][8:] + '.lean'), r['source_sha256'])
    data = {'batch': '084', 'stage': 'B1.10',
            'status': 'PROVED_KERNEL_SCOPED / NOT_REVIEWED',
            'acceptance': 'MET_REFERENCE_SCOPE', 'full_b1_11_replay': False,
            'domain': 'Same C99/GCC LP64 legal input-memory, capacity, comp=1, pinned execution and return1 domain as 083; observed-byte contract adds only actual observations.',
            'proof_sources': [pin(ROOT / 'formal/Source3' / (name + '.lean')) for name in
                              ['KeygenSourceToFiber001', 'KeygenContract084Audit']],
            'audit': pin(final / 'SEARCH_AUDIT.json'),
            'counts': {'proof_modules': 1, 'audit_modules': 1, 'audited_declarations': 11,
                       'theorems': 3, 'accepted_steps': 2, 'failed_jobs_retained': 2},
            'history': {str(i): job_files('keygen_contract084_' + str(i).zfill(3)) for i in [1, 2, 3]},
            'failure_causes': {'001': 'bwrap NETLINK_ROUTE sandbox refusal before Lean',
                               '002': 'FiberFacts alias required explicit dependent Output argument'},
            'notes': pin(ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_084_NOTES.md'),
            'entry': pin(BUILD / 'ENTRY_CHECK.json'), 'previous_postseal': pin(OLD),
            'tool': pin(__file__), 'proof_head': subprocess.check_output(
                ['git', 'rev-parse', 'HEAD'], cwd=REPO, text=True).strip(),
            'independent_review': False, 'push': False}
    print(json.dumps(write(ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_084.json', data)))


def step_pins(r):
    check(r['log'], r['log_sha256'])
    check(r['argv'][-1], r['source_sha256'])
    files = [pin(r['log']), pin(r['argv'][-1])]
    if r['artifact_sha256']:
        output = r['argv'][r['argv'].index('-o') + 1]
        check(output, r['artifact_sha256'])
        files.append(pin(output))
    return files


def consolidate():
    incoming()
    author = json.loads((REVIEW / 'REVIEW_B1_CLOSEOUT_001_RESULT.json').read_text())
    fresh = author['fresh_replay']
    mutations = author['mutations']
    check(REVIEW / fresh['receipts'], fresh['receipts_sha256'])
    check(REVIEW / mutations['results'], mutations['results_sha256'])
    check(REVIEW / fresh['fresh_audit'], fresh['fresh_audit_sha256'])
    rows = json.loads((REVIEW / fresh['receipts']).read_text())
    assert len(rows) == 45
    files = []
    for row in rows:
        assert row['status'] == 'PASS' and row['exit_code'] == row['log_bytes'] == 0
        files += step_pins(row)
    mutation_rows = json.loads((REVIEW / mutations['results']).read_text())
    assert len(mutation_rows) == 5
    for row in mutation_rows:
        assert row['status'] == 'EXPECTED_REJECTION'
        assert row['steps'][0]['exit_code'] == row['steps'][0]['log_bytes'] == 0
        assert row['steps'][-1]['exit_code'] != 0 and row['steps'][-1]['log_bytes'] > 0
        for step in row['steps']:
            files += step_pins(step)
    for name in ['REVIEW_B1_CLOSEOUT_001.md', 'REVIEW_B1_CLOSEOUT_001_RESULT.json',
                 fresh['receipts'], fresh['fresh_audit'], mutations['results'],
                 'fresh_replay_001/INPUTS.json', 'PINS_CHECK.json', 'verify_pins.py',
                 'replay_b1.py', 'mutate_b1.py']:
        files.append(pin(REVIEW / name))
    # Historical source/olean identities are checked, not freshly rebuilt.
    own = json.loads((REVIEW / 'fresh_replay_001/INPUTS.json').read_text())['historical_inputs']
    base = json.loads((ROOT / '.build/jobs/keygen_fiber_083_002/SOURCE_INPUTS.json').read_text())
    reused = {r['module']: r for r in base['reused']}
    assert len(own) == 974
    for name, pair in own.items():
        assert all(pair[k] == reused[name][k] for k in ['source_sha256', 'artifact_sha256'])
        check(reused[name].get('current_source', reused[name]['source']), pair['source_sha256'])
        check(reused[name]['artifact'], pair['artifact_sha256'])
    assert not job.active(), job.active()
    data = {'batch': '085', 'stage': 'B1.11',
            'status': 'CONSOLIDATED_SCOPED_EVIDENCE / NOT_REVIEWED',
            'acceptance': 'MET_OWNER_REFERENCE_EVIDENCE_SCOPE',
            'full_b1_11_replay': False,
            'full_historical_world_replay': False,
            'historical_dependencies_by_pin': True,
            'fresh_final_079_083_replay': '45/45 performed by independent Daybreak review',
            'new_084_contract_replay': '2/2 performed by author; no independent review of 084',
            'historical_dependencies_checked': 974,
            'mutations_rejected': 5, 'positive_controls': 5,
            'original_b1_11_plan_full_acceptance': 'NOT_MET: full historical rebuild and broader mutation list were not performed',
            'evidence': files,
            'contract_receipt': pin(ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_084.json'),
            'notes': pin(ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_085_NOTES.md'),
            'report': pin(ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_REPORT.md'),
            'review_task': pin(ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_REVIEW_TASK.md'),
            'tool': pin(__file__), 'push': False, 'independent_review_of_consolidation': False}
    print(json.dumps(write(ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_085.json', data)))


def postseal(batch, expected):
    checked = dict(incoming())
    receipt = ROOT / f'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_{batch}.json'
    check(receipt, expected)
    def add(p, wanted):
        p = str(Path(p).resolve())
        check(p, wanted)
        assert p not in checked or checked[p] == wanted, ('CONFLICTING_PIN', p)
        checked[p] = wanted
    def walk(value):
        if isinstance(value, dict):
            if 'path' in value and 'sha256' in value:
                add(value['path'], value['sha256'])
            for child in value.values():
                walk(child)
        elif isinstance(value, list):
            for child in value:
                walk(child)
    add(OLD, OLD_SHA)
    add(receipt, expected)
    walk(json.loads(receipt.read_text()))
    if batch != '084':
        previous = BUILD / 'POSTSEAL_084.json'
        for p, h in json.loads(previous.read_text())['checked'].items():
            add(p, h)
        add(previous, sha(previous))
    assert not job.active(), job.active()
    result = {'utc': datetime.now(timezone.utc).isoformat(), 'status': 'PASS_INTEGRITY',
              'batch': batch, 'checked': checked, 'distinct_pinned_files': len(checked),
              'full_b1_11_replay': False, 'independent_review': False, 'push': False}
    print(json.dumps(write(BUILD / f'POSTSEAL_{batch}.json', result)))


if __name__ == '__main__':
    if sys.argv[1:] == ['contract']:
        contract()
    elif sys.argv[1:] == ['consolidate']:
        consolidate()
    elif len(sys.argv) == 4 and sys.argv[1] == 'postseal':
        postseal(*sys.argv[2:])
    else:
        raise SystemExit('contract | consolidate | postseal BATCH RECEIPT_SHA256')
