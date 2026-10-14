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
BUILD = ROOT / '.build/sampler126'
PREVIOUS = ROOT / '.build/prefix125/POSTSEAL_125.json'
PREVIOUS_SHA = '3227093900325379decdbf3351104b2407dcfac1217278000e7eb2d5306ad8f8'
MODULES = ['KeygenCapCompute126', 'SelectedCap126', 'KeygenAttemptSetup126', 'SelectedSetup126', 'SelectedSamplerStart126', 'ActualExtractPrep126', 'ShakeBlockNormalize126', 'GeneratedActualProcess126Round00', 'GeneratedActualProcess126Round01', 'GeneratedActualProcess126Round02', 'GeneratedActualProcess126Round03', 'GeneratedActualProcess126Round04', 'GeneratedActualProcess126Round05', 'GeneratedActualProcess126Round06', 'GeneratedActualProcess126Round07', 'GeneratedActualProcess126Round08', 'GeneratedActualProcess126Round09', 'GeneratedActualProcess126Round10', 'GeneratedActualProcess126Round11', 'ActualProcess126', 'ShakeExtractFragments126', 'ActualExtractTail126', 'ActualExtractBody126', 'ActualDraw126', 'ActualRefill126']
AUDIT = 'KeygenSampler126Audit'
FINAL_JOB = 'keygen_sampler126_025'
RECEIPT = ROOT / 'notes/run/KEYGEN_SAMPLER_126.json'


def inherited():
    evidence.check(PREVIOUS, PREVIOUS_SHA)
    data = json.loads(PREVIOUS.read_text())['checked']
    assert len(data) == 30079
    for path, digest in data.items():
        evidence.check(path, digest)
    return data


def seal():
    inherited()
    assert not job.active(), job.active()
    evidence.check(BUILD/'ENTRY_PINS.json','38009016cc14c39d967dc4bc0d023090d7af53ed6bbe82be8cc0a6313986bb24')
    final = ROOT / '.build/jobs' / FINAL_JOB
    rows = json.loads((final / 'RECEIPTS.json').read_text())
    final_clean_count = len(rows)
    assert [row['name'] for row in rows] == ['Source3_'+AUDIT]
    for row in rows:
        assert row['accepted'] and row['exit_code'] == 0 and row['clean_log']
        assert not row['forbidden_proof_markers']
        assert (final / row['stdout']).stat().st_size == (final / row['stderr']).stat().st_size == 0
        evidence.check(ROOT / 'formal/Source3' / (row['name'][8:] + '.lean'), row['source_sha256'])
    inputs = json.loads((final / 'SOURCE_INPUTS.json').read_text())
    reused = {row['module']: row for row in inputs['reused']}
    accepted_modules = []
    for name in MODULES:
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
    pins = [evidence.pin(ROOT / 'formal/Source3' / (m + '.lean')) for m in MODULES + [AUDIT]]
    pins += [evidence.pin(ROOT / p) for p in [
        'tools/job111.py', 'tools/keygen_whole088_audit.py', 'tools/keygen_bigint098_audit.py', 'tools/keygen_sampler126_seal.py',
        'notes/run/KEYGEN_SAMPLER_126_REPORT.md','notes/run/KEYGEN_SAMPLER_126_PLAN.md',
        'notes/run/KEYGEN_SAMPLER_126_FAILURES.json','.build/sampler126/ENTRY_PINS.json',
        '.build/sampler126/MODULES.json','formal/Source3/ActualProcess126Generator.lean']]
    for i in range(12):
        name=f'GeneratedActualProcess126Round{i:02d}.lean'
        generated=ROOT/'.build/jobs/keygen_sampler126_018/generated'/name
        evidence.check(ROOT/'formal/Source3'/name,evidence.sha(generated))
        pins.append(evidence.pin(generated))
    for row in json.loads((final / 'SOURCE_INPUTS.json').read_text())['reused']:
        source = row.get('current_source', row['source'])
        evidence.check(source, row['source_sha256'])
        evidence.check(row['artifact'], row['artifact_sha256'])
        pins += [evidence.pin(source), evidence.pin(row['artifact'])]
    causes = json.loads((ROOT / 'notes/run/KEYGEN_SAMPLER_126_FAILURES.json').read_text())
    history = []
    for index in range(1, int(FINAL_JOB.rsplit('_',1)[1])+1):
        label = f'keygen_sampler126_{index:03d}'
        rows = json.loads((ROOT / '.build/jobs' / label / 'RECEIPTS.json').read_text())
        failed = any(not r['accepted'] for r in rows)
        assert failed == (label in causes)
        history.append({'job': label, 'failed_or_mixed': failed, 'cause': causes.get(label),
                        'files': evidence.job_files(label)})
    value = {'stage': '126', 'status': 'PROVED_KERNEL_SCOPED / PARTIAL_SELECTED_SAMPLER / NOT_REVIEWED',
        'scope': 'actual first cap/setup/sampler entry and complete first source get_rng_u64/refill, all24 source SHAKE rounds, full extraction/temp read/disposal, projection-plus-source-frame normalization',
        'whole_owner_task': 'ACTIVE / NOT_COMPLETE', 'kernel_concrete_keygen_witness': False,
        'numeric_acceptance_bound': False,
        'do_sign_slot_items': 5, 'new_assumptions': False, 'independent_review': False, 'push': False,
        'previous_postseal': evidence.pin(PREVIOUS), 'evidence': pins, 'history': history,
        'mathematical_declarations': names, 'final_job': FINAL_JOB, 'reused_current_mathematical_modules': accepted_modules,
        'first_actual_source_rng_call': True, 'first_actual_source_sampler_refill': True,
        'complete_selected_f_g': False, 'monolithic_draw_definedness_proved': False,
        'counts': {'mathematical_modules': len(MODULES), 'audit_modules': 1, 'named_declarations': len(names),
                   'coherent_clean_modules': len(MODULES)+1, 'final_job_modules': final_clean_count, 'jobs': len(history),
                   'failed_or_mixed_jobs': len(causes), 'double_rounds': 12}}

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
    print(json.dumps(evidence.write(BUILD / 'POSTSEAL_126.json', {
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
