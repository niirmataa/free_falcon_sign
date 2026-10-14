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
BUILD = ROOT / '.build/shake116'
PREVIOUS = ROOT / '.build/state115/POSTSEAL_115.json'
PREVIOUS_SHA = '5d08a2cbf7af83e48e0dca6b5ddfe3aeb4c314e48dd623a3acd00eda55782e30'
MODULES = ['ShakeBlockComputeRead116', 'ShakeBlockCompute116', 'ShakeProcessCompute116', 'ShakeBlockFixture116', 'ShakeBlockChunks116', 'ShakeTrace116Start'] + [f'ShakeTrace116Round{i:02d}' for i in range(12)] + ['ShakeBlockReplay116']
AUDIT = 'ShakeBlock116Audit'
FINAL_JOB = 'keygen_shake116_014'
FINAL_FIXTURE_JOB = 'keygen_shake116_013'
RECEIPT = ROOT / 'notes/run/KEYGEN_SHAKE_116.json'


def inherited():
    evidence.check(PREVIOUS, PREVIOUS_SHA)
    data = json.loads(PREVIOUS.read_text())['checked']
    assert len(data) == 28633
    for path, digest in data.items():
        evidence.check(path, digest)
    return data


def seal():
    inherited()
    assert not job.active(), job.active()
    evidence.check(BUILD/'ENTRY_PINS.json','b35cec1cd464a84b8a1a907a7863038c5146c99673ac9ef1225c98209b75c889')
    assert FINAL_JOB != 'UNSELECTED' and FINAL_FIXTURE_JOB != 'UNSELECTED'
    final = ROOT / '.build/jobs' / FINAL_JOB
    rows = json.loads((final / 'RECEIPTS.json').read_text())
    final_clean_count = len(rows)
    assert [row['name'] for row in rows] == ['Source3_ShakeBlockReplay116','Source3_'+AUDIT]
    for row in rows:
        assert row['accepted'] and row['exit_code'] == 0 and row['clean_log']
        assert not row['forbidden_proof_markers']
        assert (final / row['stdout']).stat().st_size == (final / row['stderr']).stat().st_size == 0
        evidence.check(ROOT / 'formal/Source3' / (row['name'][8:] + '.lean'), row['source_sha256'])
    inputs = json.loads((final / 'SOURCE_INPUTS.json').read_text())
    reused = {row['module']: row for row in inputs['reused']}
    accepted_modules = []
    for name in MODULES[:-1]:
        bound = reused['Source3.'+name]
        evidence.check(ROOT/'formal/Source3'/(name+'.lean'),bound['source_sha256'])
        evidence.check(bound['artifact'],bound['artifact_sha256'])
        receipt = Path(bound['receipt'])
        row = next(row for row in json.loads(receipt.read_text()) if row['name']=='Source3_'+name)
        assert row['accepted'] and row['clean_log'] and row['exit_code']==0
        assert not row['forbidden_proof_markers']
        assert row['source_sha256']==bound['source_sha256'] and row['olean_sha256']==bound['artifact_sha256']
        assert (receipt.parent/row['stdout']).stat().st_size==(receipt.parent/row['stderr']).stat().st_size==0
        accepted_modules.append({'module':name,'receipt':evidence.pin(receipt),'artifact':evidence.pin(bound['artifact'])})
    audited = json.loads((final / 'SEARCH_AUDIT.json').read_text())
    names = audit.declarations(MODULES)
    assert len(audited) == len(names)
    assert {r['name'] for r in audited} == set(names)
    for row in audited:
        assert set(row['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(row, ensure_ascii=False)
        if row['body']['kind'] != 'kernel_inductive':
            assert row['body']['kind'] == 'full_expression_dag_json'
            assert row['body']['roundtrip_term_and_type_checked'] is True
    pins = [evidence.pin(ROOT / 'formal/Source3' / (m + '.lean')) for m in MODULES + [AUDIT, 'ShakeTrace116Generator']]
    pins += [evidence.pin(ROOT / p) for p in [
        'tools/job111.py', 'tools/keygen_whole088_audit.py', 'tools/keygen_bigint098_audit.py', 'tools/keygen_shake116_seal.py',
        'sage/keygen_shake116.sage', 'notes/run/KEYGEN_SHAKE_116_COMPUTATION.json',
        '.build/shake116/ENTRY_PINS.json', '.build/shake116/COMPUTATION_VALIDATION.stdout', '.build/shake116/COMPUTATION_VALIDATION.stderr',
        'notes/run/KEYGEN_SHAKE_116_REPORT.md', 'notes/run/KEYGEN_SHAKE_116_PLAN.md',
        'notes/run/KEYGEN_SHAKE_116_FAILURES.json', 'notes/run/KEYGEN_SHAKE_116_REPLAY.md',
        'formal/Source3/.gitignore', '.build/shake116/PERFORMANCE_ROUTE.md']]
    fixture=ROOT/'.build/jobs'/FINAL_FIXTURE_JOB
    fixture_run=json.loads((fixture/'RECEIPTS.json').read_text())[0]
    assert fixture_run['accepted'] and fixture_run['clean_log'] and fixture_run['exit_code']==0
    assert (fixture/fixture_run['stdout']).stat().st_size==(fixture/fixture_run['stderr']).stat().st_size==0
    evidence.check(ROOT/'sage/keygen_shake116.sage',fixture_run['source_sha256'])
    fixture_record=json.loads((fixture/'FIXTURE116.json').read_text())
    evidence.check(ROOT/'formal/Source3/ShakeBlockFixture116.lean',fixture_record['output']['sha256'])
    for row in fixture_record['inputs']+[fixture_record['output']]:
        evidence.check(row['path'],row['sha256']);pins.append(evidence.pin(row['path']))
    generated=ROOT/'.build/jobs/keygen_shake116_010/generated'
    for name in ['ShakeTrace116Start']+[f'ShakeTrace116Round{i:02d}' for i in range(12)]:
        path=generated/(name+'.lean')
        evidence.check(ROOT/'formal/Source3'/(name+'.lean'),evidence.sha(path))
        pins.append(evidence.pin(path))
    assert (BUILD/'COMPUTATION_VALIDATION.stdout').read_text().startswith('valid legacy version 1 evidence record;')
    assert (BUILD/'COMPUTATION_VALIDATION.stderr').stat().st_size==0
    for row in json.loads((final / 'SOURCE_INPUTS.json').read_text())['reused']:
        source = row.get('current_source', row['source'])
        evidence.check(source, row['source_sha256'])
        evidence.check(row['artifact'], row['artifact_sha256'])
        pins += [evidence.pin(source), evidence.pin(row['artifact'])]
    causes = json.loads((ROOT / 'notes/run/KEYGEN_SHAKE_116_FAILURES.json').read_text())
    history = []
    for index in range(1, int(FINAL_JOB.rsplit('_',1)[1])+1):
        label = f'keygen_shake116_{index:03d}'
        rows = json.loads((ROOT / '.build/jobs' / label / 'RECEIPTS.json').read_text())
        failed = any(not r['accepted'] for r in rows)
        assert failed == (label in causes)
        history.append({'job': label, 'failed_or_mixed': failed, 'cause': causes.get(label),
                        'files': evidence.job_files(label)})
    value = {'stage': '116', 'status': 'PROVED_KERNEL_SCOPED / NOT_REVIEWED',
        'scope': 'computable pinned SHAKE process_block with original source soundness; concrete local 24-round source witness checked in 588 bounded chunks',
        'whole_owner_task': 'ACTIVE / NOT_COMPLETE', 'kernel_concrete_keygen_witness': False,
        'numeric_acceptance_bound': False,
        'do_sign_slot_items': 5, 'new_assumptions': False, 'independent_review': False, 'push': False,
        'previous_postseal': evidence.pin(PREVIOUS), 'evidence': pins, 'history': history,
        'mathematical_declarations': names, 'final_job': FINAL_JOB, 'reused_current_mathematical_modules': accepted_modules,
        'concrete_local_shake_source_witness': True, 'seed_initialization_bound': False,
        'counts': {'mathematical_modules': len(MODULES), 'audit_modules': 1, 'named_declarations': len(names),
                   'coherent_clean_modules': len(MODULES)+1, 'final_job_modules': final_clean_count, 'jobs': len(history),
                   'failed_or_mixed_jobs': len(causes), 'source_chunks': 588, 'double_rounds': 12}}

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
    print(json.dumps(evidence.write(BUILD / 'POSTSEAL_116.json', {
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
