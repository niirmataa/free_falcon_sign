#!/usr/bin/env python3
"""Seal the complete observed secret packet and source decoder bridge; never refresh old pins."""
from datetime import datetime, timezone
from pathlib import Path
import hashlib
import json
import subprocess
import sys
import job079 as job
import keygen_secret081_audit as producer

ROOT = Path(__file__).resolve().parents[1]
ENTRY = ROOT / '.build/levels_081/ENTRY_PINS_081.json'
ENTRY_SHA = 'e79a6d4ef30f2b04ef5789e4a610424d3f01a688e37092280b6191563bb4fe57'
FINAL = ROOT / '.build/jobs/keygen_secret_081_026'
BASE = ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_081'
CAUSES = {2: 'Padding take bound needed explicit reflexivity.', 3: 'Segment accepted; packet proof needed nondeprecated dite_eq_left and explicit reduction of successive Option binds.', 5: 'Chain proof needed whitespace around an imported operator token, explicit uint64 types, a qualified append lemma and concrete finRange normalization.', 7: 'Header comp equality needed constructor simplification; LoadByte belongs to decoder values.', 10: 'Mixed typed/untyped existential binder group required explicit State binders.', 11: 'Dependent elimination substituted away afterLength; the surviving suffixState is used.', 12: 'Caller trace accepted; public-frame proof used the reserved protected token as a local name.', 13: 'Public-frame proof used the reserved at token as an offset binder.', 17: 'Tail reassembly needed explicit cons_append and nil_append normalization.', 19: 'An unused simp argument was removed and the wrapped Fin bound proved explicitly.', 22: 'Observed slice needed Nat list-index normalization; packet split needed definitional Fin normalization.', 23: 'Dependent list-index rewriting required simp congruence instead of rw.', 24: 'Pointer-add witness needed Nat.zero_add normalization.'}

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
    assert len(entry['checked']) == entry['distinct_pinned_files'] == 21223
    for path, expected in entry['checked'].items():
        assert job.sha(Path(path)) == expected, ('INTEGRITY_STOP', path)
    return entry

def seal():
    inputs()
    records = json.loads((FINAL / 'RECEIPTS.json').read_text())
    names = producer.MODULES + ['KeygenSecret081Audit']
    assert len(records) == len(names) == 17
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
    assert len(audit) == len(expected) == 107 and {row['name'] for row in audit} == expected
    for row in audit:
        assert set(row['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(row, ensure_ascii=False)
        assert row['body'].get('term') or row['body'].get('constructors')
    history = []
    for number in range(1, 27):
        directory = ROOT / '.build/jobs' / ('keygen_secret_081_' + str(number).zfill(3))
        receipt = directory / 'RECEIPTS.json'
        rows = json.loads(receipt.read_text()) if receipt.exists() else []
        accepted = bool(rows) and all(row['accepted'] for row in rows)
        assert accepted or number in CAUSES
        history.append({'job': directory.name, 'status': 'ACCEPTED' if accepted else 'FAILED_RETAINED',
                        'cause': CAUSES.get(number),
                        'files': [pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink()
                                  and (p.parent == directory or p.parent == directory / 'logs' or p.suffix in {'.lean', '.olean'})]})
    result = {'utc': datetime.now(timezone.utc).isoformat(), 'task': 'KEYGEN_SOURCE_TO_FIBER_001',
              'batch': '081', 'status': 'PROVED_KERNEL_SCOPED / NOT_REVIEWED; B1.08 REFERENCE-SCOPE ACCEPTANCE MET',
              'entry': pin(ENTRY), 'proof_head': head, 'modules': modules, 'history': history,
              'notes': pin(str(BASE) + '_NOTES.md'), 'self_review': pin(ROOT / '.build/levels_081/SELF_REVIEW_001.md'),
              'source_inputs': pin(FINAL / 'SOURCE_INPUTS.json'), 'audit': pin(FINAL / 'SEARCH_AUDIT.json'),
              'new_proof_modules': 16, 'new_declarations': 98, 'named_theorems': 68, 'audit_entries': 107,
              'closed': 'Full secret packet header0xaa, four independently padded segments including G, actual cursor and length store, preserved bytes through public serialization and outer teardown, independent observation/DecodeSecret, same source material and certificate, constructive full source decoders for each final packet segment. Length7681-10369 derived from source coefficient bounds and bit costs.',
              'open': 'B1.09 full root observed public join remains next; B1.10/B1.11 whole emitted-to-fiber/final replay not claimed. Explicit source/legal-memory domain includes finite virtual-address legality at actual private-pointer reads.',
              'git_add_refusal': pin(ROOT / '.build/levels_081/GIT_ADD_REFUSAL_001.json'),
              'tools': [pin(ROOT / 'tools/job079.py'), pin(ROOT / 'tools/keygen_secret081_audit.py'), pin(__file__)],
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
    for module in producer.MODULES + ['KeygenSecret081Audit']:
        cache = ROOT / '.build/cache/Source3' / (module + '.olean')
        check(cache, job.sha(FINAL / 'lib/Source3' / (module + '.olean')))
    assert not job.active(), job.active()
    print(json.dumps(write(ROOT / '.build/levels_081/POSTSEAL.json', {
        'utc': datetime.now(timezone.utc).isoformat(), 'status': 'PASS_SCOPED_B1_08_OBSERVED_SECRET; B1_09_ROOT_OPEN; NOT_REVIEWED',
        'checked': checked, 'distinct_pinned_files': len(checked), 'incoming_verified': 21223,
        'all_native_final_logs_clean': True, 'push': False, 'active_jobs': [], 'verifier_sha256': job.sha(Path(__file__))})))

if __name__ == '__main__':
    if len(sys.argv) == 2 and sys.argv[1] == 'seal':
        seal()
    elif len(sys.argv) == 3 and sys.argv[1] == 'postseal':
        postseal(sys.argv[2])
    else:
        raise SystemExit('usage: keygen_secret081_seal.py seal | postseal MANIFEST_SHA')
