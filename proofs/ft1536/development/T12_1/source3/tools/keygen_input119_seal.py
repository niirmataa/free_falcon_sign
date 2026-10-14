#!/usr/bin/env python3
"""Seal intermediate whole-KeyGen checkpoints, keeping the owner task active."""
from pathlib import Path
import fcntl
import json
import sys
import job079 as job
import pre_sign_evidence084 as evidence
import keygen_whole088_audit as audit

ROOT, REPO = evidence.ROOT, evidence.REPO
BUILD = ROOT / '.build/seed119'
PREVIOUS = ROOT / '.build/shake118/POSTSEAL_118.json'
PREVIOUS_SHA = 'dc2cedbbcf2bb782dec14897d0db85b78eb035dc925f785f5f00843411838b2b'
MODULES = ['GeneratedSeed119Fixture','SelectedSeedInit119','SelectedSeedFlip119','SelectedSeedBytes119']
RECEIPT = ROOT / 'notes/run/KEYGEN_SELECTED_SEED_119.json'


def inherited():
    evidence.check(PREVIOUS, PREVIOUS_SHA)
    data = json.loads(PREVIOUS.read_text())['checked']
    assert len(data) == 29087
    for path, digest in data.items():
        evidence.check(path, digest)
    return data


def seal():
    inherited()
    assert not job.active(), job.active()
    final = ROOT / '.build/jobs/keygen_seed119_005'
    rows = json.loads((final / 'RECEIPTS.json').read_text())
    assert len(rows) == 5
    for row in rows:
        assert row['accepted'] and row['exit_code'] == 0 and row['clean_log']
        assert not row['forbidden_proof_markers']
        assert (final / row['stdout']).stat().st_size == (final / row['stderr']).stat().st_size == 0
        evidence.check(ROOT / 'formal/Source3' / (row['name'][8:] + '.lean'), row['source_sha256'])
    audited = json.loads((final / 'SEARCH_AUDIT.json').read_text())
    names = audit.declarations(MODULES)
    assert len(audited) == len(names) == 26
    assert {r['name'] for r in audited} == set(names)
    for row in audited:
        assert set(row['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(row, ensure_ascii=False)
        if row['body']['kind'] != 'kernel_inductive':
            assert row['body']['kind'] == 'full_expression_dag_json'
            assert row['body']['roundtrip_term_and_type_checked'] is True
    pins = [evidence.pin(ROOT / 'formal/Source3' / (m + '.lean')) for m in MODULES + ['SelectedSeed119Audit']]
    pins += [evidence.pin(ROOT / p) for p in [
        'tools/job111.py', 'tools/keygen_whole088_audit.py', 'tools/keygen_selected_seed119_seal.py',
        'notes/run/KEYGEN_SELECTED_SEED_119_REPORT.md', 'notes/run/KEYGEN_SELECTED_SEED_119_PLAN.md',
        'notes/run/KEYGEN_SELECTED_SEED_119_FAILURES.json']]
    evidence.check(BUILD/'ENTRY_PINS.json','e36c1396dc9c69b86daf4b59324a3329bace9236a16b666778d5ae38671fb85c')
    fixture=ROOT/'.build/jobs/keygen_seed119_004'
    record=json.loads((fixture/'SELECTED119.json').read_text())
    assert record['selected_counter']==9 and record['seed_bytes']==32 and record['rng_bytes_per_boundary']==416
    assert not record['canonical_caller_domain_constructed']
    evidence.check(ROOT/'formal/Source3/GeneratedSeed119Fixture.lean',record['output']['sha256'])
    for row in record['inputs']+[record['output']]:
        evidence.check(row['path'],row['sha256']);pins.append(evidence.pin(row['path']))
    fixture_run=json.loads((fixture/'RECEIPTS.json').read_text())[0]
    assert fixture_run['accepted'] and fixture_run['clean_log'] and fixture_run['exit_code']==0
    evidence.check(ROOT/'sage/keygen_selected_seed119.sage',fixture_run['source_sha256'])
    for name in ['sage/keygen_selected_seed119.sage','notes/run/KEYGEN_SELECTED_SEED_119_COMPUTATION.json',
        '.build/seed119/ENTRY_PINS.json','.build/seed119/COMPUTATION_VALIDATION.stdout','.build/seed119/COMPUTATION_VALIDATION.stderr']:
        pins.append(evidence.pin(ROOT/name))
    assert (BUILD/'COMPUTATION_VALIDATION.stdout').read_text().startswith('valid legacy version 1 evidence record;')
    assert (BUILD/'COMPUTATION_VALIDATION.stderr').stat().st_size==0
    for row in json.loads((final / 'SOURCE_INPUTS.json').read_text())['reused']:
        source = row.get('current_source', row['source'])
        evidence.check(source, row['source_sha256'])
        evidence.check(row['artifact'], row['artifact_sha256'])
        pins += [evidence.pin(source), evidence.pin(row['artifact'])]
    causes = json.loads((ROOT / 'notes/run/KEYGEN_SELECTED_SEED_119_FAILURES.json').read_text())
    history = []
    for index in range(1, 6):
        label = f'keygen_seed119_{index:03d}'
        rows = json.loads((ROOT / '.build/jobs' / label / 'RECEIPTS.json').read_text())
        failed = any(not r['accepted'] for r in rows)
        assert failed == (label in causes)
        history.append({'job': label, 'failed_or_mixed': failed, 'cause': causes.get(label),
                        'files': evidence.job_files(label)})
    value = {'stage': '119', 'status': 'PROVED_KERNEL_SCOPED / NOT_REVIEWED',
        'scope': 'selected public32-byte seed through actual source SHAKE Init/Inject/Flip, with exact kernel byte images and pinned native boundary controls; local caller scope',
        'whole_owner_task': 'ACTIVE / NOT_COMPLETE', 'kernel_concrete_keygen_witness': False,
        'numeric_acceptance_bound': False,
        'do_sign_slot_items': 5, 'new_assumptions': False, 'independent_review': False, 'push': False,
        'previous_postseal': evidence.pin(PREVIOUS), 'evidence': pins, 'history': history,
        'mathematical_declarations': names, 'final_job': 'keygen_seed119_005',
        'counts': {'mathematical_modules': 4, 'audit_modules': 1, 'named_declarations': 26,
                   'final_clean_modules': 5, 'jobs': 5, 'failed_or_mixed_jobs': 0, 'rng_bytes_each_image': 416, 'seed_bytes': 32}}

    print(json.dumps(evidence.write(RECEIPT, value)))


def postseal(expected):
    checked = dict(inherited())
    evidence.check(RECEIPT, expected)
    def add(path, digest):
        path = str(Path(path).resolve())
        evidence.check(path, digest)
        assert path not in checked or checked[path] == digest, ('CONFLICTING_PIN', path)
        checked[path] = digest
    def walk(value):
        if isinstance(value, dict):
            if 'path' in value and 'sha256' in value:
                add(value['path'], value['sha256'])
            for item in value.values():
                walk(item)
        elif isinstance(value, list):
            for item in value:
                walk(item)
    add(PREVIOUS, PREVIOUS_SHA)
    add(RECEIPT, expected)
    walk(json.loads(RECEIPT.read_text()))
    assert not job.active(), job.active()
    print(json.dumps(evidence.write(BUILD / 'POSTSEAL_119.json', {
        'status': 'PASS_INTEGRITY; WHOLE_OWNER_TASK_ACTIVE', 'checked': checked,
        'distinct_pinned_files': len(checked), 'kernel_concrete_keygen_witness': False,
        'independent_review': False, 'push': False})))


if __name__ == '__main__':
    with (ROOT / '.build/JOB.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        if sys.argv[1:] == ['seal']:
            seal()
        elif len(sys.argv) == 3 and sys.argv[1] == 'postseal':
            postseal(sys.argv[2])
        else:
            raise SystemExit('seal | postseal RECEIPT_SHA256')
