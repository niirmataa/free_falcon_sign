#!/usr/bin/env python3
"""Seal the conditional attempt-to-serialization bridge; never refresh old pins."""
from datetime import datetime, timezone
from pathlib import Path
import hashlib
import json
import subprocess
import sys
import job079 as job
import keygen_assembly079_audit as producer

ROOT = Path(__file__).resolve().parents[1]
ENTRY = ROOT / '.build/levels_079/ENTRY_PINS_079.json'
ENTRY_SHA = '00354b59336ef2d6c51e302bf5bc84f1c4285117b026bb506de1048204c23ff0'
FINAL = ROOT / '.build/jobs/keygen_assembly_079_011'
BASE = ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_079'
CAUSES = {
    1: 'Outer sandbox prevented bwrap NETLINK_ROUTE setup before Lean started; unchanged guarded runner subsequently ran through approved escalation.',
    2: 'Lean keyword prefix was used as a local proof name; renamed sampledRun.',
    3: 'Guard refused an occupied serial proof slot: a Lean process was active in S05_QROM. No Lean step started.',
    5: 'Table projection required an explicit prepared-state table equality; dependent elimination made the old raw binder unavailable.',
    6: 'Result.state equality needed an explicit State type before rewriting the table projection.',
    8: 'Dependent constructor elimination exposed fewer names; two unused simp arguments were removed without suppressing warnings.',
}

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
    assert len(entry['checked']) == entry['distinct_pinned_files'] == 20622
    for path, expected in entry['checked'].items():
        assert job.sha(Path(path)) == expected, ('INTEGRITY_STOP', path)
    return entry

def seal():
    inputs()
    records = json.loads((FINAL / 'RECEIPTS.json').read_text())
    names = producer.MODULES + ['KeygenAssembly079Audit']
    assert len(records) == len(names) == 5
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
    assert len(audit) == len(expected) == 22 and {row['name'] for row in audit} == expected
    for row in audit:
        assert set(row['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(row, ensure_ascii=False)
        assert row['body'].get('term') or row['body'].get('constructors')
    history = []
    for number in range(1, 12):
        directory = ROOT / '.build/jobs' / ('keygen_assembly_079_' + str(number).zfill(3))
        receipt = directory / 'RECEIPTS.json'
        rows = json.loads(receipt.read_text()) if receipt.exists() else []
        accepted = bool(rows) and all(row['accepted'] for row in rows)
        assert accepted or number in CAUSES
        history.append({'job': directory.name, 'status': 'ACCEPTED' if accepted else 'FAILED_RETAINED',
                        'cause': CAUSES.get(number),
                        'files': [pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink()
                                  and (p.parent == directory or p.parent == directory / 'logs' or p.suffix in {'.lean', '.olean'})]})
    result = {'utc': datetime.now(timezone.utc).isoformat(), 'task': 'KEYGEN_SOURCE_TO_FIBER_001',
              'batch': '079', 'status': 'PROVED_KERNEL_CONDITIONAL_BRIDGE / NOT_REVIEWED; B1.07 ACCEPTANCE NOT MET',
              'entry': pin(ENTRY), 'proof_head': head, 'modules': modules, 'history': history,
              'notes': pin(str(BASE) + '_NOTES.md'), 'self_review': pin(ROOT / '.build/levels_079/SELF_REVIEW_001.md'),
              'source_inputs': pin(FINAL / 'SOURCE_INPUTS.json'), 'audit': pin(FINAL / 'SEARCH_AUDIT.json'),
              'new_proof_modules': 4, 'new_declarations': 12, 'named_theorems': 11, 'audit_entries': 22,
              'closed': 'Same final accepted state, reachable workspace, nine-statement heap frame, same material/equations at all four actual source codec calls; codec returns/lengths/byte traces derived.',
              'open': 'Certificate entry-frame residual; root relocation/common call identity/snapshots/lifetime; entire final secret packet and whole-root public join.',
              'tools': [pin(ROOT / 'tools/job079.py'), pin(ROOT / 'tools/keygen_assembly079_audit.py'), pin(__file__)],
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
    for module in producer.MODULES + ['KeygenAssembly079Audit']:
        cache = ROOT / '.build/cache/Source3' / (module + '.olean')
        check(cache, job.sha(FINAL / 'lib/Source3' / (module + '.olean')))
    assert not job.active(), job.active()
    print(json.dumps(write(ROOT / '.build/levels_079/POSTSEAL.json', {
        'utc': datetime.now(timezone.utc).isoformat(), 'status': 'PASS_SCOPED_CONDITIONAL_BRIDGE; ROOT_ACCEPTANCE_NOT_MET; NOT_REVIEWED',
        'checked': checked, 'distinct_pinned_files': len(checked), 'incoming_verified': 20622,
        'all_native_final_logs_clean': True, 'push': False, 'active_jobs': [], 'verifier_sha256': job.sha(Path(__file__))})))

if __name__ == '__main__':
    if len(sys.argv) == 2 and sys.argv[1] == 'seal':
        seal()
    elif len(sys.argv) == 3 and sys.argv[1] == 'postseal':
        postseal(sys.argv[2])
    else:
        raise SystemExit('usage: keygen_assembly079_seal.py seal | postseal MANIFEST_SHA')
