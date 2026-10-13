#!/usr/bin/env python3
"""Seal the B1.07 source assembly; never refresh old pins."""
from datetime import datetime, timezone
from pathlib import Path
import hashlib
import json
import subprocess
import sys
import job079 as job
import keygen_assembly080_audit as producer

ROOT = Path(__file__).resolve().parents[1]
ENTRY = ROOT / '.build/levels_080/ENTRY_PINS_080.json'
ENTRY_SHA = 'fbbce8e1516095ce3f5bb740160832a0ec31155918c14aa9c16fb940788b2fa1'
FINAL = ROOT / '.build/jobs/keygen_assembly_080_021'
BASE = ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_080'
CAUSES = {2: 'Voluntary termination after104.171s: large FFT-table reduction replaced by existing words_length theorem; transient second Lean observed after preflight. Interruption receipt retained.', 3: 'Deprecated if_neg lemma rejected under warningAsError; replaced with ite_eq_right without suppressing lint.', 7: 'Ne.symm required parentheses around the slot-specific separation proof.', 8: 'Retry module lacked an explicit import of the checked sampled_tables helper; first module accepted, downstream module failed.', 10: 'Reserved syntax token used as a structure field name; renamed syntaxBound.', 11: 'Dependent module was launched before its failed producer had been rebuilt; missing new Occurrence080 artifact. Historical inputs unaffected; dependent attempt retained.', 15: 'Numeric cap conclusion required explicit unfolding of KeygenAttemptCap.limit.'}
CAUSES[20] = 'All17 proofs accepted; full audit failed because the generator encoded dotted declaration names as one Lean.Name segment. Fixed namespace splitting; failed audit source and logs retained.'


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
    assert len(entry['checked']) == entry['distinct_pinned_files'] == 20760
    for path, expected in entry['checked'].items():
        assert job.sha(Path(path)) == expected, ('INTEGRITY_STOP', path)
    return entry

def seal():
    inputs()
    records = json.loads((FINAL / 'RECEIPTS.json').read_text())
    names = producer.MODULES + ['KeygenAssembly080Audit']
    assert len(records) == len(names) == 18
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
    assert len(audit) == len(expected) == 88 and {row['name'] for row in audit} == expected
    for row in audit:
        assert set(row['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(row, ensure_ascii=False)
        assert row['body'].get('term') or row['body'].get('constructors')
    history = []
    for number in range(1, 22):
        directory = ROOT / '.build/jobs' / ('keygen_assembly_080_' + str(number).zfill(3))
        receipt = directory / 'RECEIPTS.json'
        rows = json.loads(receipt.read_text()) if receipt.exists() else []
        accepted = bool(rows) and all(row['accepted'] for row in rows)
        assert accepted or number in CAUSES
        history.append({'job': directory.name, 'status': 'ACCEPTED_SUPERSEDED_SCOPE' if number == 1 else 'ACCEPTED' if accepted else 'FAILED_RETAINED',
                        'cause': 'Initial proof used explicit static-block separation; final readonly theorem removes that premise. Earlier accepted source snapshot retained.' if number == 1 else CAUSES.get(number),
                        'files': [pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink()
                                  and (p.parent == directory or p.parent == directory / 'logs' or p.suffix in {'.lean', '.olean'})]})
    result = {'utc': datetime.now(timezone.utc).isoformat(), 'task': 'KEYGEN_SOURCE_TO_FIBER_001',
              'batch': '080', 'status': 'PROVED_KERNEL_SCOPED / NOT_REVIEWED; B1.07 REFERENCE-SCOPE ACCEPTANCE MET',
              'entry': pin(ENTRY), 'proof_head': head, 'modules': modules, 'history': history,
              'notes': pin(str(BASE) + '_NOTES.md'), 'self_review': pin(ROOT / '.build/levels_080/SELF_REVIEW_001.md'),
              'source_inputs': pin(FINAL / 'SOURCE_INPUTS.json'), 'audit': pin(FINAL / 'SEARCH_AUDIT.json'),
              'new_proof_modules': 17, 'new_declarations': 79, 'named_theorems': 50, 'audit_entries': 88,
              'closed': 'Source-only certificate calls derive their workspace bridge; immutable globals and all foreign blocks preserved on both outcomes; relocated capped loop, one final-call counter, source-linked snapshots on one witness, same certificate argument material and serializer entry, and outer lifetime. Root successful_frontier uses legal initial memory, fixed source execution and observed return1 only.',
              'open': 'B1.08 entire observed secret packet/header0xaa and B1.09 whole-root observed public join remain; no emitted-to-fiber, compiler or security claim.',
              'interruption': pin(ROOT / '.build/levels_080/INTERRUPTION_002.json'),
              'tools': [pin(ROOT / 'tools/job079.py'), pin(ROOT / 'tools/keygen_assembly080_audit.py'), pin(__file__)],
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
    for module in producer.MODULES + ['KeygenAssembly080Audit']:
        cache = ROOT / '.build/cache/Source3' / (module + '.olean')
        check(cache, job.sha(FINAL / 'lib/Source3' / (module + '.olean')))
    assert not job.active(), job.active()
    print(json.dumps(write(ROOT / '.build/levels_080/POSTSEAL.json', {
        'utc': datetime.now(timezone.utc).isoformat(), 'status': 'PASS_SCOPED_B1_07_ASSEMBLY; B1_08_B1_09_ROOT_OPEN; NOT_REVIEWED',
        'checked': checked, 'distinct_pinned_files': len(checked), 'incoming_verified': 20760,
        'all_native_final_logs_clean': True, 'push': False, 'active_jobs': [], 'verifier_sha256': job.sha(Path(__file__))})))

if __name__ == '__main__':
    if len(sys.argv) == 2 and sys.argv[1] == 'seal':
        seal()
    elif len(sys.argv) == 3 and sys.argv[1] == 'postseal':
        postseal(sys.argv[2])
    else:
        raise SystemExit('usage: keygen_assembly080_seal.py seal | postseal MANIFEST_SHA')
