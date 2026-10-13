#!/usr/bin/env python3
"""Seal the full root public observation and joint key output; never refresh old pins."""
from datetime import datetime, timezone
from pathlib import Path
import hashlib
import json
import subprocess
import sys
import job079 as job
import keygen_public_root082_audit as producer

ROOT = Path(__file__).resolve().parents[1]
ENTRY = ROOT / '.build/levels_082/ENTRY_PINS_082.json'
ENTRY_SHA = 'a7f67bdb2a736bd2dbf74416f3f24d2e9f5a413cc84eadd90cdd446fa7daae72'
FINAL = ROOT / '.build/jobs/keygen_public_root_082_008'
BASE = ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_082'
CAUSES = {1: 'Dependent elimination substituted the result binder; the surviving outer out is used.', 2: 'Sampling accepted; generic heap equality caused state inference to pick normed/before instead of closed/prepared states. Explicit source states resolve it.', 5: 'The closed077 caller contract needed an explicit module import.', 6: 'Guard refused active S05 Lean process413789 in source_equivalence_001/runs/memorywindow005. No native step started.'}

def pin(path):
    path = Path(path)
    return {'path': str(path), 'sha256': job.sha(path), 'bytes': path.stat().st_size}

def write(path, value):
    with Path(path).open('x') as stream:
        json.dump(value, stream, indent=2)
        stream.write('\n')
    return pin(path)

def inputs():
    assert not job.active(), job.active()
    assert job.sha(ENTRY) == ENTRY_SHA
    entry = json.loads(ENTRY.read_text())
    assert len(entry['checked']) == entry['distinct_pinned_files'] == 21622
    for path, expected in entry['checked'].items():
        assert job.sha(Path(path)) == expected, ('INTEGRITY_STOP', path)
    return entry

def seal():
    inputs()
    records = json.loads((FINAL / 'RECEIPTS.json').read_text())
    names = producer.MODULES + ['KeygenPublicRoot082Audit']
    assert len(records) == len(names) == 7
    head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=job.REPO, text=True).strip()
    modules = []
    for name, record in zip(names, records):
        assert record['name'] == 'Source3_' + name
        assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
        assert record['forbidden_proof_markers'] == []
        source = ROOT / 'formal/Source3' / (name + '.lean')
        snapshot = FINAL / 'formal/Source3' / (name + '.lean')
        artifact = FINAL / 'lib/Source3' / (name + '.olean')
        assert job.sha(source) == job.sha(snapshot) == record['source_sha256']
        assert job.sha(artifact) == record['olean_sha256']
        committed = subprocess.check_output(['git', 'show', head + ':' + str(source.relative_to(job.REPO))], cwd=job.REPO)
        assert hashlib.sha256(committed).hexdigest() == record['source_sha256']
        modules.append({'module': name, 'source': pin(source), 'snapshot': pin(snapshot), 'artifact': pin(artifact)})
    audit = json.loads((FINAL / 'SEARCH_AUDIT.json').read_text())
    expected = {ns + '.' + n for ns, names in producer.declarations().items() for n in names}
    expected |= {'FT1536.Source3.' + n for n in producer.INHERITED}
    assert len(audit) == len(expected) == 38 and {row['name'] for row in audit} == expected
    for row in audit:
        assert set(row['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(row, ensure_ascii=False)
        assert row['body'].get('term') or row['body'].get('constructors')
    history = []
    for number in range(1, 9):
        directory = ROOT / '.build/jobs' / ('keygen_public_root_082_' + str(number).zfill(3))
        receipt = directory / 'RECEIPTS.json'
        rows = json.loads(receipt.read_text()) if receipt.exists() else []
        accepted = bool(rows) and all(row['accepted'] for row in rows)
        assert accepted or number in CAUSES
        history.append({'job': directory.name, 'status': 'ACCEPTED' if accepted else 'FAILED_RETAINED',
                        'cause': CAUSES.get(number),
                        'files': [pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink()
                                  and (p.parent == directory or p.parent == directory / 'logs' or p.suffix in {'.lean', '.olean'})]})
    result = {'utc': datetime.now(timezone.utc).isoformat(), 'task': 'KEYGEN_SOURCE_TO_FIBER_001',
              'batch': '082', 'status': 'PROVED_KERNEL_SCOPED / NOT_REVIEWED; B1.09 REFERENCE-SCOPE ACCEPTANCE MET; OWNER ITEMS1-4 COMPLETE',
              'entry': pin(ENTRY), 'proof_head': head, 'modules': modules, 'history': history,
              'notes': pin(str(BASE) + '_NOTES.md'), 'self_review': pin(ROOT / '.build/levels_082/SELF_REVIEW_001.md'),
              'source_inputs': pin(FINAL / 'SOURCE_INPUTS.json'), 'audit': pin(FINAL / 'SEARCH_AUDIT.json'),
              'new_proof_modules': 6, 'new_declarations': 29, 'named_theorems': 26, 'audit_entries': 38,
              'closed': 'Initial public capacity and writable-buffer domain transported through all source gates/retries and private serialization; actual final public observation after teardown; joint independently observed sk/pk decode to SAME accepted material and certificate, public length2881 and secret length7681-10369 derived.',
              'open': 'B1.10/B1.11 optional final interface, fiber adapter, full fresh replay/mutations and independent review; no compiler, probability, PRG, Sign realization or security claim.',
              'tools': [pin(ROOT / 'tools/job079.py'), pin(ROOT / 'tools/keygen_public_root082_audit.py'), pin(__file__)],
              'push': False, 'independent_review': False, 'active_jobs': []}
    assert not job.active(), job.active()
    print(json.dumps(write(str(BASE) + '.json', result)))

def postseal(expected):
    entry = inputs()
    manifest = Path(str(BASE) + '.json')
    assert job.sha(manifest) == expected
    checked = dict(entry['checked'])
    def check(path, wanted):
        path = str(Path(path).resolve())
        assert job.sha(Path(path)) == wanted, ('INTEGRITY_STOP', path)
        if path in checked:
            assert checked[path] == wanted, ('CONFLICTING_PIN', path)
        checked[path] = wanted
    def walk(value):
        if isinstance(value, dict):
            if 'path' in value and 'sha256' in value:
                check(value['path'], value['sha256'])
            for child in value.values():
                walk(child)
        elif isinstance(value, list):
            for child in value:
                walk(child)
    data = json.loads(manifest.read_text())
    check(manifest, expected)
    walk(data)
    live = json.loads((FINAL / 'SOURCE_INPUTS.json').read_text())
    for e in live['sources']:
        check(e['path'], e['sha256'])
    for e in live['reused']:
        check(e.get('current_source', e['source']), e['source_sha256'])
        check(e['artifact'], e['artifact_sha256'])
    for module in producer.MODULES + ['KeygenPublicRoot082Audit']:
        cache = ROOT / '.build/cache/Source3' / (module + '.olean')
        check(cache, job.sha(FINAL / 'lib/Source3' / (module + '.olean')))
    assert not job.active(), job.active()
    print(json.dumps(write(ROOT / '.build/levels_082/POSTSEAL.json', {
        'utc': datetime.now(timezone.utc).isoformat(), 'status': 'PASS_SCOPED_B1_09_JOINT_OBSERVED_KEYS; OWNER_ITEMS1_4_COMPLETE; NOT_REVIEWED',
        'checked': checked, 'distinct_pinned_files': len(checked), 'incoming_verified': 21622,
        'all_native_final_logs_clean': True, 'push': False, 'active_jobs': [], 'verifier_sha256': job.sha(Path(__file__))})))

if __name__ == '__main__':
    if len(sys.argv) == 2 and sys.argv[1] == 'seal':
        seal()
    elif len(sys.argv) == 3 and sys.argv[1] == 'postseal':
        postseal(sys.argv[2])
    else:
        raise SystemExit('usage: keygen_public_root082_seal.py seal | postseal MANIFEST_SHA')
