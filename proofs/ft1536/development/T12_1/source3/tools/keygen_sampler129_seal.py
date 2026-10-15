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
BUILD = ROOT / '.build/sampler129'
PREVIOUS = ROOT / '.build/trace128/POSTSEAL_128.json'
PREVIOUS_SHA = '9eb4c0e090c3fe5f608a7996dea0d71c65cb8a0a284f8aa8e8e28ca1c510aabb'
MODULES = json.loads((BUILD/'AUDIT_MODULES.json').read_text())
assert {'SamplerFComplete129','SamplerGComplete129','SelectedSamples129','SamplerImages129'} <= set(MODULES)
AUDIT_PLAN = json.loads((BUILD/'ISOLATED_AUDIT_PLAN.json').read_text())
AUDITS = [p['audit_module'] for p in AUDIT_PLAN['parts']]
FINAL_JOB = json.loads((BUILD/'FINAL_AUDIT.json').read_text())['job']
assert FINAL_JOB.startswith('keygen_sampler129_') and FINAL_JOB.rsplit('_',1)[1].isdigit()
RECEIPT = ROOT / 'notes/run/KEYGEN_SAMPLER_129.json'


def inherited():
    evidence.check(PREVIOUS, PREVIOUS_SHA)
    data = json.loads(PREVIOUS.read_text())['checked']
    assert len(data) == 31236
    for path, digest in data.items():
        evidence.check(path, digest)
    return data


def seal():
    inherited()
    assert not job.active(), job.active()
    evidence.check(BUILD/'ENTRY_PINS.json','d5de541ab75b1645c45e3b642c3d9812c73db9853b89a266f28b9481bc83483a')
    final = ROOT / '.build/jobs' / FINAL_JOB
    rows = json.loads((final / 'RECEIPTS.json').read_text())
    final_clean_count = len(rows)
    assert [row['name'] for row in rows] == ['Source3_'+name for name in AUDITS]
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
    collection = json.loads((BUILD/'AUDIT_COLLECTION.json').read_text())
    evidence.check(collection['aggregate']['path'],collection['aggregate']['sha256'])
    assert collection['isolated_clean_audit_processes']==len(AUDITS)
    audited = json.loads((BUILD/'AUDIT_129.json').read_text())
    names = audit.declarations(MODULES)
    assert len(audited) == len(names)
    assert {r['name'] for r in audited} == set(names)
    for row in audited:
        assert set(row['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(row, ensure_ascii=False)
        if row['body']['kind'] != 'kernel_inductive':
            assert row['body']['kind'] == 'full_expression_dag_json'
            assert row['body']['roundtrip_term_and_type_checked'] is True
            assert row['body']['type_check']=='kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded'
    pins = [evidence.pin(ROOT / 'formal/Source3' / (m + '.lean')) for m in MODULES + AUDITS]
    pins += [evidence.pin(ROOT / p) for p in [
        'tools/job111.py','tools/keygen_whole088_audit.py','tools/keygen_bigint098_audit.py','tools/keygen_sampler129_seal.py',
        'tools/keygen_kernel_audit129.py','tools/keygen_partition_audit129.py','tools/keygen_isolated_audit129.py','tools/keygen_audit129_collect.py',
        'notes/run/KEYGEN_SAMPLER_129_REPORT.md','notes/run/KEYGEN_SAMPLER_129_PLAN.md',
        'notes/run/KEYGEN_SAMPLER_129_FAILURES.json','notes/run/KEYGEN_SAMPLER_129_CHAIN_CHECK.md',
        'notes/run/KEYGEN_SAMPLER_129_AUDIT_METHOD.md',
        '.build/sampler129/ENTRY_PINS.json','.build/sampler129/AUDIT_MODULES.json',
        '.build/sampler129/FINAL_AUDIT.json','.build/sampler129/LAZY_LITERAL_IDENTITY.json',
        '.build/sampler129/POINTER_TRANSFER_IDENTITY.json',
        '.build/sampler129/ISOLATED_AUDIT_PLAN.json','.build/sampler129/AUDIT_PART_PLAN.json',
        '.build/sampler129/AUDIT_COLLECTION.json','.build/sampler129/AUDIT_129.json',
        '.build/sampler129/FINAL_AUDIT_024_ATTEMPT.json','.build/sampler129/FINAL_AUDIT_028_ATTEMPT.json',
        'sage/keygen_sampler129_control.sage','sage/keygen_sampler_words129.sage',
        'formal/Source3/SamplerF129Generator.lean','formal/Source3/SamplerG129Generator.lean',
        'formal/Source3/SamplerProcess129Generator.lean']]
    for row in json.loads((final / 'SOURCE_INPUTS.json').read_text())['reused']:
        source = row.get('current_source', row['source'])
        evidence.check(source, row['source_sha256'])
        evidence.check(row['artifact'], row['artifact_sha256'])
        pins += [evidence.pin(source), evidence.pin(row['artifact'])]
    causes = json.loads((ROOT / 'notes/run/KEYGEN_SAMPLER_129_FAILURES.json').read_text())
    history = []
    for index in range(1, int(FINAL_JOB.rsplit('_',1)[1])+1):
        label = f'keygen_sampler129_{index:03d}'
        rows = json.loads((ROOT / '.build/jobs' / label / 'RECEIPTS.json').read_text())
        failed = any(not r['accepted'] for r in rows)
        assert failed == (label in causes)
        history.append({'job': label, 'failed_or_mixed': failed, 'cause': causes.get(label),
                        'files': evidence.job_files(label) + [evidence.pin(p) for p in sorted((ROOT/'.build/jobs'/label/'sage').glob('*.sage'))]})
    value = {'stage': '129', 'status': 'PROVED_KERNEL_SCOPED / NOT_REVIEWED',
        'scope': 'complete actual1536-coefficient f and g source calls on the same fixed full127 input/stream, all8 source SHAKE processes, actual returns/bit reset, and exact physical coefficient images',
        'whole_owner_task': 'ACTIVE / NOT_COMPLETE', 'kernel_concrete_keygen_witness': False,
        'numeric_acceptance_bound': False,
        'do_sign_slot_items': 5, 'new_assumptions': False, 'independent_review': False, 'push': False,
        'previous_postseal': evidence.pin(PREVIOUS), 'evidence': pins, 'history': history,
        'mathematical_declarations': names, 'final_job': FINAL_JOB, 'reused_current_mathematical_modules': accepted_modules,
        'complete_selected_f_g': True, 'all_sampler_process_events_closed': True,
        'actual_g_bit_reset': True, 'physical_f_g_images_checked': True,
        'counts': {'mathematical_modules': len(MODULES), 'audit_modules': len(AUDITS), 'named_declarations': len(names),
                   'coherent_clean_modules': len(MODULES)+len(AUDITS), 'final_job_modules': final_clean_count, 'jobs': len(history),
                   'failed_or_mixed_jobs': len(causes), 'closed_f_coefficients': 1536, 'closed_g_coefficients': 1536, 'process_calls': 8, 'source_dimension': 1536}}

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
    print(json.dumps(evidence.write(BUILD / 'POSTSEAL_129.json', {
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
