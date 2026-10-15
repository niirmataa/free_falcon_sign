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
BUILD = ROOT / '.build/fftmiddle139'
PREVIOUS = ROOT / '.build/fft138/POSTSEAL_138.json'
PREVIOUS_SHA = '1aec6e0b1b72a064fb0103c75df9219332747a123ea1b7da62272cf2825d313c'
MODULES = json.loads((BUILD/'AUDIT_MODULES.json').read_text())
assert len(MODULES)==13 and {'FftMiddlePrefix139','NormalizedFftMiddle139','FftPinned139'} <= set(MODULES)
AUDIT_PLAN = json.loads((BUILD/'ISOLATED_AUDIT_PLAN.json').read_text())
AUDITS = [p['audit_module'] for p in AUDIT_PLAN['parts']]
FINAL_JOB = json.loads((BUILD/'FINAL_AUDIT.json').read_text())['job']
assert FINAL_JOB.startswith('keygen_fftmiddle139_') and FINAL_JOB.rsplit('_',1)[1].isdigit()
RECEIPT = ROOT / 'notes/run/KEYGEN_FFT_MIDDLE_139.json'


def inherited():
    evidence.check(PREVIOUS, PREVIOUS_SHA)
    data = json.loads(PREVIOUS.read_text())['checked']
    assert len(data) == 40573
    for path, digest in data.items():
        evidence.check(path, digest)
    return data


def seal():
    inherited()
    assert not job.active(), job.active()
    evidence.check(BUILD/'ENTRY_PINS.json','9a126b657a4f114383383595733b82fbe81349ee98de8c6965922bb8487e5e39')
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
    audited = json.loads((BUILD/'AUDIT_139.json').read_text())
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
    pins += [evidence.pin(ROOT / p) for p in ['tools/job111.py', 'tools/keygen_whole088_audit.py', 'tools/keygen_fftmiddle139_seal.py', 'tools/keygen_isolated_audit139.py', 'tools/keygen_audit139_collect.py', 'notes/run/KEYGEN_FFT_MIDDLE_139_REPORT.md', 'notes/run/KEYGEN_FFT_MIDDLE_139_PLAN.md', 'notes/run/KEYGEN_FFT_MIDDLE_139_NEXT_ROUTE.md', 'notes/run/KEYGEN_FFT_MIDDLE_139_FAILURES.json', '.build/fftmiddle139/ENTRY_PINS.json', '.build/fftmiddle139/AUDIT_MODULES.json', '.build/fftmiddle139/FINAL_AUDIT.json', '.build/fftmiddle139/ISOLATED_AUDIT_PLAN.json', '.build/fftmiddle139/AUDIT_COLLECTION.json', '.build/fftmiddle139/AUDIT_139.json', '.build/fftmiddle139/SETUP_FAILURE_014.json', '.build/fftmiddle139/PILOT_CANDIDATE.json', '.build/fftmiddle139/NEXT_CANDIDATES.json', '.build/fftmiddle139/REFLEXIVE_CANDIDATE.json', '.build/fftmiddle139/NEXT4_CANDIDATES.json', 'formal/Source3/FftMiddle139Generator.lean', 'formal/Source3/Fft139TraceGenerator.lean', 'formal/Source3/FftMiddleNext139Generator.lean', 'formal/Source3/FftMiddle139ControlGenerator.lean', 'sage/keygen_fftmiddle139_control.sage']]
    for row in json.loads((final / 'SOURCE_INPUTS.json').read_text())['reused']:
        source = row.get('current_source', row['source'])
        evidence.check(source, row['source_sha256'])
        evidence.check(row['artifact'], row['artifact_sha256'])
        pins += [evidence.pin(source), evidence.pin(row['artifact'])]
    causes = json.loads((ROOT / 'notes/run/KEYGEN_FFT_MIDDLE_139_FAILURES.json').read_text())
    history = []
    for index in range(1, int(FINAL_JOB.rsplit('_',1)[1])+1):
        label = f'keygen_fftmiddle139_{index:03d}'
        receipt_path = ROOT / '.build/jobs' / label / 'RECEIPTS.json'
        if label == 'keygen_fftmiddle139_014':
            assert not receipt_path.exists()
            setup = json.loads((BUILD/'SETUP_FAILURE_014.json').read_text())
            assert setup['status'] == 'FAILED_BEFORE_EXECUTION'
            for item in setup['setup_files']:
                evidence.check(item['path'], item['sha256'])
            failed = True
        else:
            rows = json.loads(receipt_path.read_text())
            failed = any(not r['accepted'] for r in rows)
        assert failed == (label in causes)
        history.append({'job': label, 'failed_or_mixed': failed, 'cause': causes.get(label),
                        'files': evidence.job_files(label) + [evidence.pin(p) for p in sorted((ROOT/'.build/jobs'/label/'sage').glob('*.sage'))]})
    value = {'stage': '139', 'status': 'PROVED_KERNEL_SCOPED_PREFIX / NOT_REVIEWED',
        'scope': 'actual first middle-group entry, immutable FFT table transport and source words, eight original butterfly iterations and complete normalized endpoint; full group/middle/tripling/FFT explicitly open',
        'whole_owner_task': 'ACTIVE / NOT_COMPLETE', 'kernel_concrete_keygen_witness': False,
        'numeric_acceptance_bound': False,
        'do_sign_slot_items': 5, 'new_assumptions': False, 'independent_review': False, 'push': False,
        'previous_postseal': evidence.pin(PREVIOUS), 'evidence': pins, 'history': history,
        'mathematical_declarations': names, 'final_job': FINAL_JOB, 'reused_current_mathematical_modules': accepted_modules,
        'frozen_law110_success_mass_zero': True, 'real_c_success_mass_zero_claimed': False,
        'whole_law_target': 'KeygenProbability134', 'reference_semantics_changed': False,
        'first_middle_group_complete': False, 'whole_fft_execution_claimed': False,
        'middle_butterfly_iterations': 8, 'next_state': 'NormalizedFftMiddle139.after',
        'counts': {'mathematical_modules': len(MODULES), 'audit_modules': len(AUDITS), 'named_declarations': len(names),
                   'coherent_clean_modules': len(MODULES)+len(AUDITS), 'final_job_modules': final_clean_count, 'jobs': len(history),
                   'failed_or_mixed_jobs': len(causes)}}

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
    print(json.dumps(evidence.write(BUILD / 'POSTSEAL_139.json', {
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
