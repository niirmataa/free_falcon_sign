#!/usr/bin/env python3
"""Seal preparation and its explicitly incomplete implementation target."""
from pathlib import Path
import json
import sys
import job079 as job
import pre_sign_evidence084 as prior

ROOT, REPO, BUILD = prior.ROOT, prior.REPO, prior.BUILD
BASE = ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_086.json'
PREVIOUS = BUILD / 'POSTSEAL_085.json'
PREVIOUS_SHA = 'f52ab93965a58ed7d705cc8081389d94551751d166ab779e77161ad48f3c28ad'


def inherited():
    prior.check(PREVIOUS, PREVIOUS_SHA)
    checked = json.loads(PREVIOUS.read_text())['checked']
    assert len(checked) == 22019
    for p, h in checked.items():
        prior.check(p, h)
    return checked


def seal():
    inherited()
    assert not job.active(), job.active()
    final = ROOT / '.build/jobs/pre_sign086_003'
    records = json.loads((final / 'RECEIPTS.json').read_text())
    assert len(records) == 2
    for r in records:
        assert r['accepted'] and r['clean_log'] and r['exit_code'] == 0
        assert not r['forbidden_proof_markers']
        assert (final / r['stdout']).stat().st_size == (final / r['stderr']).stat().st_size == 0
        prior.check(ROOT / 'formal/Source3' / (r['name'][8:] + '.lean'), r['source_sha256'])
    audit = json.loads((final / 'SEARCH_AUDIT.json').read_text())
    assert len(audit) == 11
    assert all(set(r['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'} for r in audit)
    assert all('⋯' not in json.dumps(r, ensure_ascii=False) for r in audit)
    inputs = json.loads((final / 'SOURCE_INPUTS.json').read_text())
    assert len(inputs['dependencies']) == 166
    evidence = []
    for item in inputs['dependencies']:
        prior.check(item['source'], item['source_sha256'])
        prior.check(item['artifact'], item['artifact_sha256'])
        evidence += [prior.pin(item['source']), prior.pin(item['artifact'])]
    smap = ROOT / 'notes/run/DO_SIGN_SOURCE_MAP_086.json'
    source = json.loads(smap.read_text())
    assert len(source['sources']) == 17 and len(source['regions']) == 23
    for item in source['sources'] + source['formal_inputs']:
        path = REPO / item['path']
        prior.check(path, item['sha256'])
        evidence.append(prior.pin(path))
    for item in source['regions']:
        snapshot = REPO / item['snapshot']
        prior.check(snapshot, item['sha256'])
        evidence.append(prior.pin(snapshot))
    for rel in ['formal/Source3/SignRealizationObligations086.lean',
                'formal/Source3/SignRealization086Audit.lean',
                'tools/pre_sign086_job.py', 'tools/pin_do_sign086.py',
                'tools/pre_sign086_seal.py', 'notes/run/DO_SIGN_SOURCE_MAP_086.json',
                'notes/run/PRE_DO_SIGN_086_REPORT.md',
                'notes/run/KEYGEN_SOURCE_TO_FIBER_001_CLOSURE.json']:
        evidence.append(prior.pin(ROOT / rel))
    f04 = REPO / 'proofs/ft1536/work/FT1536_F04_SCOPE_RECHECK_002'
    assert prior.sha(f04 / 'REVIEW_002.md').startswith('f8e0b2ad')
    assert prior.sha(f04 / 'REVIEW_002_RESULT.json').startswith('dbb00be7')
    for path in [f04 / 'REVIEW_002.md', f04 / 'REVIEW_002_RESULT.json',
                 ROOT.parent / 'run2/notes/F04_ROM_VARIANT_A_SCOPE_002/RECEIPT.json',
                 ROOT.parent / 'run2/.build/f04_rom_a_001/attempts/final_clean_002/RECEIPT.json']:
        evidence.append(prior.pin(path))
    history = {str(i): prior.job_files('pre_sign086_' + str(i).zfill(3)) for i in [1, 2, 3]}
    result = {'batch': '086', 'status': 'PREPARATION_PROVED_KERNEL_SCOPED / NOT_REVIEWED',
              'whole_owner_objective': 'NOT_ACHIEVED: BLOCKED_SINGLE_SLOT_ASSEMBLY',
              'real_end_to_end_theorem_exported': False,
              'source_defined_pointwise_weights_proved': False,
              'do_sign_proved': False, 'full_b1_11_replay': False,
              'counts': {'new_proof_modules': 1, 'new_named_declarations': 8, 'new_theorems': 5,
                         'final_clean_modules': 2, 'audit_entries': 11, 'inherited_audit_entries': 3,
                         'f04_pinned_modules': 166, 'pinned_c_files': 17, 'function_regions': 23},
              'e2_control_shape': 'SAMPLE_THEN_CHECK_UNCONDITIONED_TARGET; actual code bound OPEN',
              'blockers': ['actual conditional key law identification',
                           'actual byte-game construction and non-signing transport',
                           'honest-signer computational hybrid and law realization'],
              'failure_causes': {'001': 'BoxPair namespace not opened',
                                 '002': 'proof module accepted; audit rejected truncated nested proof printing'},
              'history': history, 'evidence': evidence, 'previous_postseal': prior.pin(PREVIOUS),
              'notes': prior.pin(ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_086_NOTES.md'),
              'independent_review': False, 'push': False}
    print(json.dumps(prior.write(BASE, result)))


def postseal(expected):
    checked = dict(inherited())
    prior.check(BASE, expected)
    def add(p, h):
        p = str(Path(p).resolve())
        prior.check(p, h)
        assert p not in checked or checked[p] == h, ('CONFLICTING_PIN', p)
        checked[p] = h
    def walk(value):
        if isinstance(value, dict):
            if 'path' in value and 'sha256' in value:
                add(value['path'], value['sha256'])
            for child in value.values():
                walk(child)
        elif isinstance(value, list):
            for child in value:
                walk(child)
    add(PREVIOUS, PREVIOUS_SHA)
    add(BASE, expected)
    walk(json.loads(BASE.read_text()))
    assert not job.active(), job.active()
    print(json.dumps(prior.write(BUILD / 'POSTSEAL_086.json', {
        'status': 'PASS_INTEGRITY; END_TO_END_SINGLE_SLOT_NOT_ACHIEVED',
        'checked': checked, 'distinct_pinned_files': len(checked),
        'full_b1_11_replay': False, 'push': False, 'independent_review': False})))


if __name__ == '__main__':
    if sys.argv[1:] == ['seal']:
        seal()
    elif len(sys.argv) == 3 and sys.argv[1] == 'postseal':
        postseal(sys.argv[2])
    else:
        raise SystemExit('seal | postseal RECEIPT_SHA256')
