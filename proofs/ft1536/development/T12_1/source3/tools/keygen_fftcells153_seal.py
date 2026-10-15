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
BUILD = ROOT / '.build/fftcells153'
PREVIOUS = ROOT / '.build/fftvalues152/POSTSEAL_152.json'
PREVIOUS_SHA = '684e3c2b7ff6a0b89dd71ebb2710491f3d13c6d10dd9ec03d8c6ca844618ec48'
MODULES = json.loads((BUILD/'AUDIT_MODULES.json').read_text())
assert {'FiniteWordVector153','SelectedNumericFft153','SelectedNormGate153','NormTrace153','FftCertifiedTwiddle153'} <= set(MODULES)
AUDIT_CONFIG = json.loads((BUILD/'FINAL_AUDIT.json').read_text())
AUDIT_PLAN = json.loads((BUILD/AUDIT_CONFIG['parts']).read_text())
AUDITS = [p['audit_module'] for p in AUDIT_PLAN['parts']]
FINAL_JOB = json.loads((BUILD/'FINAL_AUDIT.json').read_text())['job']
assert FINAL_JOB.startswith('keygen_fftcells153_') and FINAL_JOB.rsplit('_',1)[1].isdigit()
RECEIPT = ROOT / 'notes/run/KEYGEN_FFT_CELLS_153.json'


def inherited():
    evidence.check(PREVIOUS, PREVIOUS_SHA)
    data = json.loads(PREVIOUS.read_text())['checked']
    assert len(data) == 46376
    for path, digest in data.items():
        evidence.check(path, digest)
    return data


def seal():
    inherited()
    assert not job.active(), job.active()
    evidence.check(BUILD/'ENTRY_PINS.json','fc47500d04605ada02756ce9eeab3d568f73f5d24181343c17059040577a1676')
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
    audited = json.loads((BUILD/'AUDIT_153.json').read_text())
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
    pins += [evidence.pin(ROOT / p) for p in ['tools/job111.py', 'tools/keygen_whole088_audit.py', 'tools/keygen_fftcells153_seal.py', 'tools/keygen_isolated_audit153.py', 'tools/keygen_isolated_audit153_v2.py', 'tools/keygen_audit153_collect.py', 'notes/run/KEYGEN_FFT_CELLS_153_REPORT.md', 'notes/run/KEYGEN_FFT_CELLS_153_PLAN.md', 'notes/run/KEYGEN_FFT_CELLS_153_NEXT_ROUTE.md', 'notes/run/KEYGEN_FFT_CELLS_153_FAILURES.json', 'sage/keygen_fftcells153_data.sage', 'sage/keygen_fftcells153_tree.sage', 'sage/keygen_fftcells153_twiddles.sage', 'sage/keygen_normcells153_data.sage',
        'tools/keygen_fftcells153_generate.py', 'tools/keygen_fftcells153_inputs64.py', 'tools/keygen_fftcells153_tree_inputs.py', 'tools/keygen_fftcells153_twiddle_checks.py', 'tools/keygen_fftcells153_stages.py', 'tools/keygen_normcells153_checks.py',
        '.build/fftcells153/INPUT_PLAN.json', '.build/fftcells153/INPUT64_PLAN.json', '.build/fftcells153/TREE_INPUT_PLAN.json', '.build/fftcells153/TREE_DATA_MODULES.json', '.build/fftcells153/TWIDDLE_CHECK_PLAN.json', '.build/fftcells153/STAGE_TARGETS.json', '.build/fftcells153/STAGE_PLAN.json', '.build/fftcells153/NORM_CHECK_PLAN.json', '.build/fftcells153/ENTRY_PINS.json', '.build/fftcells153/AUDIT_MODULES.json', '.build/fftcells153/FINAL_AUDIT.json', '.build/fftcells153/ISOLATED_AUDIT_PLAN.json', '.build/fftcells153/ISOLATED_AUDIT_V2_PLAN.json', '.build/fftcells153/FINAL_AUDIT_025.json', '.build/fftcells153/AUDIT_COLLECTION.json', '.build/fftcells153/AUDIT_153.json']]
    for row in json.loads((final / 'SOURCE_INPUTS.json').read_text())['reused']:
        source = row.get('current_source', row['source'])
        evidence.check(source, row['source_sha256'])
        evidence.check(row['artifact'], row['artifact_sha256'])
        pins += [evidence.pin(source), evidence.pin(row['artifact'])]
    causes = json.loads((ROOT / 'notes/run/KEYGEN_FFT_CELLS_153_FAILURES.json').read_text())
    history = []
    for index in range(1, int(FINAL_JOB.rsplit('_',1)[1])+1):
        label = f'keygen_fftcells153_{index:03d}'
        rows = json.loads((ROOT / '.build/jobs' / label / 'RECEIPTS.json').read_text())
        failed = any(not r['accepted'] for r in rows)
        assert failed == (label in causes)
        history.append({'job': label, 'failed_or_mixed': failed, 'cause': causes.get(label),
                        'files': evidence.job_files(label) + [evidence.pin(p) for p in sorted((ROOT/'.build/jobs'/label/'sage').glob('*.sage'))]})
    value = {'stage': '153', 'status': 'PROVED_KERNEL_SCOPED_RAW_NORM_ACCEPT / NOT_REVIEWED',
        'scope': 'kernel numeric source input/table/pass/trace certificates and unconditional acceptance of the actual first raw-norm gate; exact norm word and original comparator; GS and the full KeyGen success witness remain open',
        'whole_owner_task': 'ACTIVE / NOT_COMPLETE', 'kernel_concrete_keygen_witness': False,
        'numeric_acceptance_bound': False,
        'do_sign_slot_items': 5, 'new_assumptions': False, 'independent_review': False, 'push': False,
        'previous_postseal': evidence.pin(PREVIOUS), 'evidence': pins, 'history': history,
        'mathematical_declarations': names, 'final_job': FINAL_JOB, 'reused_current_mathematical_modules': accepted_modules,
        'frozen_law110_success_mass_zero': True, 'real_c_success_mass_zero_claimed': False,
        'whole_law_target': 'KeygenProbability134', 'reference_semantics_changed': False,
        'inherited_first_fft_call_complete': True, 'new_actual_norm_iterations': 0, 'first_fft_call_complete': True, 'second_fft_call_complete': True,
        'first_pass_generic_body_complete': True, 'first_pass_generic_loop_complete': True, 'second_fft_input_and_binding_inherited': True,
        'next_t': 3, 'next_m': 512, 'actual_logn': 10, 'actual_full': 1,
        'next_state': 'SelectedRawNorm151.after after proved raw-norm acceptance; next original Gram-Schmidt stage via SelectedNormGate153.continue_gs',
        'endpoint_kind': 'actual source-proved raw norm state with kernel-certified literal word4704131856579166192 and accepted original fpr_lt gate',
        'raw_norm_computation_complete': True, 'raw_norm_numerical_gate_proved': True,
        'numeric_candidate': evidence.pin(ROOT/'.build/jobs/keygen_fftvalues152_009/FFT152_CANDIDATES.json'),
        'candidate_word': '4704131856579166192', 'candidate_word_is_kernel_proved': True, 'indexed_pass_formulas_proved': True,
        'exact_norm_target_preserved': True, 'numeric_image_equalities_proved': True,
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
    print(json.dumps(evidence.write(BUILD / 'POSTSEAL_153.json', {
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
