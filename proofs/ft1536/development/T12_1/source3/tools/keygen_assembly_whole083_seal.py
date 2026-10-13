#!/usr/bin/env python3
"""Append a coherent whole-task seal and bounded fiber-adapter preparation."""
from datetime import datetime, timezone
from pathlib import Path
import hashlib
import json
import subprocess
import sys
import job079 as job
import keygen_assembly_whole083_audit as producer

ROOT = Path(__file__).resolve().parents[1]
ENTRY = ROOT / '.build/levels_083/ENTRY_PINS_083.json'
ENTRY_SHA = 'f9301dee49063c89fe1831cf2ede5e224b0104ce17f944c6d83a1a8768c3bfe8'
FINAL = ROOT / '.build/jobs/keygen_fiber_083_002'
BASE = ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_083'
POST = ROOT / '.build/levels_083/WHOLE_ASSEMBLY_POSTSEAL_001.json'

def pin(p):
    p = Path(p)
    return {'path': str(p), 'sha256': job.sha(p), 'bytes': p.stat().st_size}

def write(p, value):
    with Path(p).open('x') as stream:
        json.dump(value, stream, indent=2)
        stream.write('\n')
    return pin(p)

def inputs():
    assert not job.active(), job.active()
    assert job.sha(ENTRY) == ENTRY_SHA
    entry = json.loads(ENTRY.read_text())
    assert len(entry['checked']) == entry['distinct_pinned_files'] == 21759
    for p, expected in entry['checked'].items():
        assert job.sha(Path(p)) == expected, ('INTEGRITY_STOP', p)
    return entry

def seal():
    inputs()
    records = json.loads((FINAL / 'RECEIPTS.json').read_text())
    selected = ['KeygenEmittedFiber083', 'KeygenAssemblyWhole083Audit']
    assert len(records) == len(selected) == 2
    head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=job.REPO, text=True).strip()
    for name, record in zip(selected, records):
        assert record['name'] == 'Source3_' + name
        assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
        assert record['forbidden_proof_markers'] == []
        assert job.sha(ROOT / 'formal/Source3' / (name + '.lean')) == record['source_sha256']
        assert job.sha(FINAL / 'formal/Source3' / (name + '.lean')) == record['source_sha256']
        assert job.sha(FINAL / 'lib/Source3' / (name + '.olean')) == record['olean_sha256']
        assert (FINAL / record['stdout']).stat().st_size == (FINAL / record['stderr']).stat().st_size == 0
    proof_sources = []
    for module in producer.MODULES + ['KeygenAssemblyWhole083Audit']:
        p = ROOT / 'formal/Source3' / (module + '.lean')
        committed = subprocess.check_output(['git', 'show', head + ':' + str(p.relative_to(job.REPO))], cwd=job.REPO)
        assert hashlib.sha256(committed).hexdigest() == job.sha(p)
        proof_sources.append(pin(p))
    expected = {ns + '.' + n for ns, names in producer.declarations().items() for n in names}
    assert len(producer.MODULES) == 44 and len(expected) == 228
    rows = json.loads((FINAL / 'SEARCH_AUDIT.json').read_text())
    assert len(rows) == 243 and {r['name'] for r in rows} == expected | set(producer.INHERITED)
    assert sum('term' in r['body'] for r in rows) == 215
    assert sum('constructors' in r['body'] for r in rows) == 28
    for row in rows:
        assert set(row['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(row, ensure_ascii=False)
        assert row['body'].get('term') or row['body'].get('constructors')
    history = []
    for number in [1, 2]:
        directory = ROOT / '.build/jobs' / ('keygen_fiber_083_' + str(number).zfill(3))
        records = json.loads((directory / 'RECEIPTS.json').read_text())
        assert all(r['accepted'] and r['clean_log'] for r in records)
        history.append({'job': directory.name, 'status': 'ACCEPTED',
                        'files': [pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink()
                                  and (p.parent == directory or p.parent == directory / 'logs' or p.suffix in {'.lean', '.olean'})]})
    result = {'utc': datetime.now(timezone.utc).isoformat(), 'task': 'KEYGEN_SOURCE_TO_FIBER_001',
              'batch': '083', 'status': 'OWNER_ITEMS1_4_COMPLETE; B1_10_KERNEL_ADAPTER_PREPARED; B1_11_NOT_RUN; NOT_REVIEWED',
              'entry': pin(ENTRY), 'proof_head': head, 'proof_sources': proof_sources, 'history': history,
              'notes': pin(str(BASE) + '_NOTES.md'), 'self_review': pin(ROOT / '.build/levels_083/SELF_REVIEW_001.md'),
              'audit': pin(FINAL / 'SEARCH_AUDIT.json'), 'source_inputs': pin(FINAL / 'SOURCE_INPUTS.json'),
              'coherent_counts': {'proof_modules': 44, 'new_named_declarations': 228, 'named_theorems': 158,
                                  'audit_entries': 243, 'full_terms': 215, 'kernel_inductives': 28},
              'adapter_counts': {'proof_modules': 1, 'new_named_declarations': 10, 'named_theorems': 3},
              'fiber_source': pin(job.REPO / 'proofs/ft1536/development/T12_1/run2/formal/Run2/ActualNTRUFiber.lean'),
              'closed': 'Required B1.07/08/09 source assembly and actual observed joint key output in explicit reference/legal-memory/capacity scope; native adapter to existing fiber coordinates and Gaussian reindexing.',
              'open': 'B1.10 final contract acceptance/consolidation and B1.11 complete fresh closure replay, mutations and independent review. Key-law probabilities, real Sign/do_sign realization, PRG and security remain outside.',
              'tools': [pin(ROOT / 'tools/keygen_assembly_whole083_audit.py'), pin(__file__)],
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
    check(manifest, expected)
    walk(json.loads(manifest.read_text()))
    live = json.loads((FINAL / 'SOURCE_INPUTS.json').read_text())
    for e in live['sources']:
        check(e['path'], e['sha256'])
    for e in live['reused']:
        check(e.get('current_source', e['source']), e['source_sha256'])
        check(e['artifact'], e['artifact_sha256'])
    for module in ['KeygenEmittedFiber083', 'KeygenAssemblyWhole083Audit']:
        cache = ROOT / '.build/cache/Source3' / (module + '.olean')
        check(cache, job.sha(FINAL / 'lib/Source3' / (module + '.olean')))
    assert not job.active(), job.active()
    print(json.dumps(write(POST, {'utc': datetime.now(timezone.utc).isoformat(),
        'status': 'PASS_SCOPED_WHOLE_ASSEMBLY_079_083; OWNER_ITEMS1_4_COMPLETE; ADAPTER_PREPARED; NOT_REVIEWED',
        'checked': checked, 'distinct_pinned_files': len(checked), 'incoming_verified': 21759,
        'all_new_declarations_coherently_audited': True, 'all_selected_native_logs_clean': True,
        'full_b1_11_replay': False, 'push': False, 'active_jobs': [], 'verifier_sha256': job.sha(Path(__file__))})))

if __name__ == '__main__':
    if len(sys.argv) == 2 and sys.argv[1] == 'seal':
        seal()
    elif len(sys.argv) == 3 and sys.argv[1] == 'postseal':
        postseal(sys.argv[2])
    else:
        raise SystemExit('usage: keygen_assembly_whole083_seal.py seal | postseal MANIFEST_SHA')
