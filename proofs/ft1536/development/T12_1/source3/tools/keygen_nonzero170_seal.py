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
BUILD = ROOT / '.build/evaluation170'
PREVIOUS = ROOT / '.build/evaluation169/POSTSEAL_169.json'
PREVIOUS_SHA = '16fbe983952a3f153fab39993e7cc5cd7aef0243a041aba2fbce0c0344aadee2'
MODULES = json.loads((BUILD/'AUDIT_MODULES.json').read_text())
assert {'PublicTreeEvaluation170','SelectedTreeInput170','SelectedTreeNonzero170'} <= set(MODULES)
AUDIT_CONFIG = json.loads((BUILD/'FINAL_AUDIT.json').read_text())
AUDIT_PLAN = json.loads((BUILD/AUDIT_CONFIG['parts']).read_text())
AUDITS = [p['audit_module'] for p in AUDIT_PLAN['parts']]
FINAL_JOB = json.loads((BUILD/'FINAL_AUDIT.json').read_text())['job']
assert FINAL_JOB.startswith('keygen_publicforward159_') and FINAL_JOB.rsplit('_',1)[1].isdigit()
RECEIPT = ROOT / 'notes/run/KEYGEN_PUBLIC_NONZERO_170.json'


def inherited():
    evidence.check(PREVIOUS, PREVIOUS_SHA)
    data = json.loads(PREVIOUS.read_text())['checked']
    assert len(data) == 57543
    for path, digest in data.items():
        evidence.check(path, digest)
    return data


def seal():
    inherited()
    assert not job.active(), job.active()
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
    audited = json.loads((BUILD/'AUDIT_170.json').read_text())
    names = audit.declarations(MODULES)
    assert 'FT1536.Source3.SelectedTreeNonzero170.t_nonzero' in names
    assert len(audited) == len(names)
    assert {r['name'] for r in audited} == set(names)
    for row in audited:
        assert set(row['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(row, ensure_ascii=False)
        if row['body']['kind'] != 'kernel_inductive':
            assert row['body']['kind'] == 'full_expression_dag_json'
            assert row['body']['roundtrip_term_and_type_checked'] is True
            assert row['body']['type_check']=='kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded'
    sage_dir = ROOT/'.build/jobs/keygen_publicforward159_150'
    sage_rows = json.loads((sage_dir/'RECEIPTS.json').read_text())
    assert len(sage_rows)==1 and sage_rows[0]['accepted'] and sage_rows[0]['clean_log'] and sage_rows[0]['exit_code']==0
    assert (sage_dir/sage_rows[0]['stdout']).stat().st_size==(sage_dir/sage_rows[0]['stderr']).stat().st_size==0
    control = json.loads((sage_dir/'EVALUATION170_CONTROL.json').read_text())
    assert control['physical_points']==1536 and control['zero_evaluations']==0
    assert control['inputs_before']==control['inputs_after']
    for bound in control['inputs_before']+[control['output']]: evidence.check(bound['path'],bound['sha256'])
    generated = json.loads((BUILD/'GENERATED_INPUTS.json').read_text())
    for bound in [generated['source'],generated['generator']]+generated['generated']: evidence.check(bound['path'],bound['sha256'])
    tree = json.loads((BUILD/'GENERATED_TREE_INPUTS_V2.json').read_text())
    for bound in [tree['source'],tree['generator']]+tree['generated']: evidence.check(bound['path'],bound['sha256'])
    pins = [evidence.pin(ROOT / 'formal/Source3' / (m + '.lean')) for m in MODULES + AUDITS]
    pins += [evidence.pin(ROOT / p) for p in ['.build/r1resume160/REPAIR_ATTEMPTS.json', '.build/r1resume160/POSTSEAL_RECONCILIATION.json', 'tools/job111.py', 'tools/keygen_whole088_audit.py', 'tools/keygen_nonzero170_seal.py', 'tools/keygen_isolated_audit170.py', 'tools/keygen_audit170_collect.py', 'notes/run/KEYGEN_PUBLIC_NONZERO_170_REPORT.md', 'notes/run/KEYGEN_PUBLIC_NONZERO_170_PLAN.md', 'notes/run/KEYGEN_PUBLIC_NONZERO_170_NEXT_ROUTE.md', 'notes/run/KEYGEN_PUBLIC_NONZERO_170_FAILURES.json', '.build/evaluation170/ENTRY_PINS.json', '.build/evaluation170/AUDIT_MODULES.json', '.build/evaluation170/FINAL_AUDIT.json', '.build/evaluation170/ISOLATED_AUDIT_V3_PLAN.json', '.build/evaluation170/AUDIT_COLLECTION.json', '.build/evaluation170/AUDIT_170.json']]
    for row in json.loads((final / 'SOURCE_INPUTS.json').read_text())['reused']:
        source = row.get('current_source', row['source'])
        evidence.check(source, row['source_sha256'])
        evidence.check(row['artifact'], row['artifact_sha256'])
        pins += [evidence.pin(source), evidence.pin(row['artifact'])]
    pins += [evidence.pin(ROOT/p) for p in ['sage/keygen_evaluation170_control.sage','tools/keygen_evaluation170_data.py','.build/evaluation170/GENERATED_INPUTS.json','.build/evaluation170/GeneratedPublicEvaluation170.lean','tools/keygen_evaluation170_tree.py','tools/keygen_evaluation170_tree_v2.py','.build/evaluation170/GENERATED_TREE_INPUTS.json','.build/evaluation170/GENERATED_TREE_INPUTS_V2.json','.build/evaluation170/GeneratedPublicTree170.lean','.build/evaluation170/GeneratedPublicTree170_v2.lean']]
    causes = json.loads((ROOT / 'notes/run/KEYGEN_PUBLIC_NONZERO_170_FAILURES.json').read_text())
    history = []
    for index in range(149, int(FINAL_JOB.rsplit('_',1)[1])+1):
        label = f'keygen_publicforward159_{index:03d}'
        rows = json.loads((ROOT / '.build/jobs' / label / 'RECEIPTS.json').read_text())
        failed = any(not r['accepted'] for r in rows)
        assert failed == (label in causes)
        history.append({'job': label, 'failed_or_mixed': failed, 'cause': causes.get(label),
                        'files': evidence.job_files(label) + [evidence.pin(p) for p in sorted((ROOT/'.build/jobs'/label/'sage').glob('*.sage'))]})
    value = {'stage': '170', 'status': 'PROVED_KERNEL_SCOPED_SELECTED_NONZERO_EVALUATIONS / PUBLIC_SUFFIX_OPEN / NOT_REVIEWED',
        'scope': 'kernel-checked candidate input, first/eight radix/triple finite arrays and all1536 nonzero evaluations of the actual selected f; shared certificate soundness and169 source-value binding yield actual t-word nonzero conclusions; no probability bound or complete public return yet',
        'whole_owner_task': 'ACTIVE / NOT_COMPLETE', 'kernel_concrete_keygen_witness': False,
        'numeric_acceptance_bound': False, 'public_call_complete': False, 'both_selected_forward_calls_complete': True, 'all_selected_t_words_nonzero': True,
        'do_sign_slot_items': 5, 'new_assumptions': False, 'independent_review': False, 'push': False,
        'previous_resume_entry': evidence.pin(PREVIOUS), 'evidence': pins, 'history': history,
        'mathematical_declarations': names, 'final_job': FINAL_JOB,
        'reused_current_mathematical_modules': accepted_modules,
        'whole_law_target': 'KeygenProbability134', 'certificate_representation': 'balanced C99FiniteMap114 tree; earlier array checks retained as audited partial route', 'reference_semantics_changed': False,
        'next': 'construct quotient loop and full inverse/return, then solver/certificate/codecs and corrected134 emitted witness',
        'sage_control': 'Exact GF(18433) candidate checked against direct evaluation and gcd in Sage150; kernel input/transition/nonzero checks independently discharge the finite certificate. Sage is not a premise.',
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
    print(json.dumps(evidence.write(BUILD / 'POSTSEAL_170.json', {
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
