#!/usr/bin/env python3
"""Seal checkpoint191: first-prime pair-product loop s2 at the copy output."""
from pathlib import Path
import fcntl
import json
import sys
import job079 as job
import pre_sign_evidence084 as evidence
import keygen_whole088_audit as audit

ROOT, REPO = evidence.ROOT, evidence.REPO
BUILD = ROOT / '.build/stepproduct191'
PREVIOUS = ROOT / '.build/steptail190/POSTSEAL_190.json'
PREVIOUS_SHA = 'd15f8d30f0a40cd3c8cb37225f051ccf0c641304ebb3af47611733d2101764cb'
MODULES = json.loads((BUILD/'AUDIT_MODULES.json').read_text())
assert {'MakeFgProductShape191','StepProductBody191','StepProductFixed191','StepProductLoop191','SelectedStepProduct191'} <= set(MODULES)
AUDIT_CONFIG = json.loads((BUILD/'FINAL_AUDIT.json').read_text())
AUDIT_PLAN = json.loads((BUILD/AUDIT_CONFIG['parts']).read_text())
AUDITS = [p['audit_module'] for p in AUDIT_PLAN['parts']]
FINAL_JOB = json.loads((BUILD/'FINAL_AUDIT.json').read_text())['job']
assert FINAL_JOB.startswith('keygen_publicforward159_') and FINAL_JOB.rsplit('_',1)[1].isdigit()
RECEIPT = ROOT / 'notes/run/KEYGEN_STEP_PRODUCT_191.json'
RECEIPTLESS = {
  'keygen_publicforward159_365': 'receipt-less setup abort: OSError [Errno 28] No space left on device while symlinking the reused library tree into the job directory, before any Lean process; the data volume was 100 percent full and even small writes failed; the partial job directory with its PREFLIGHT is retained; the owner then freed space (work/FT1536_FPEMU_DUDECT_RUN_001 archived to the system disk) and a read-only recheck of all 70613 ENTRY_PINS191 paths reported 0 missing and 0 changed; recorded in KEYGEN_STEP_PRODUCT_191_FAILURES.json'}


def inherited():
    evidence.check(PREVIOUS, PREVIOUS_SHA)
    data = json.loads(PREVIOUS.read_text())['checked']
    assert len(data) == 70613
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
    audited = json.loads((BUILD/'AUDIT_191.json').read_text())
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
    pins += [evidence.pin(ROOT / p) for p in ['tools/job111.py', 'tools/keygen_whole088_audit.py',
      'tools/keygen_stepproduct191_entry.py', 'tools/keygen_stepproduct191_seal.py',
      'tools/keygen_isolated_audit191.py', 'tools/keygen_audit191_collect.py',
      'notes/run/KEYGEN_STEP_PRODUCT_191_REPORT.md', 'notes/run/KEYGEN_STEP_PRODUCT_191_PLAN.md',
      'notes/run/KEYGEN_STEP_PRODUCT_191_NEXT_ROUTE.md', 'notes/run/KEYGEN_STEP_PRODUCT_191_FAILURES.json',
      '.build/stepproduct191/ENTRY_PINS.json', '.build/stepproduct191/AUDIT_MODULES.json',
      '.build/stepproduct191/FINAL_AUDIT.json', '.build/stepproduct191/ISOLATED_AUDIT_V2_PLAN.json',
      '.build/stepproduct191/AUDIT_COLLECTION.json', '.build/stepproduct191/AUDIT_191.json']]
    for row in json.loads((final / 'SOURCE_INPUTS.json').read_text())['reused']:
        source = row.get('current_source', row['source'])
        evidence.check(source, row['source_sha256'])
        evidence.check(row['artifact'], row['artifact_sha256'])
        pins += [evidence.pin(source), evidence.pin(row['artifact'])]
    causes = json.loads((ROOT / 'notes/run/KEYGEN_STEP_PRODUCT_191_FAILURES.json').read_text())
    history = []
    for index in range(363, int(FINAL_JOB.rsplit('_',1)[1])+1):
        label = f'keygen_publicforward159_{index:03d}'
        receiptless = not (ROOT/'.build/jobs'/label/'RECEIPTS.json').exists()
        if receiptless:
            assert label in RECEIPTLESS and label in causes
            history.append({'job': label, 'failed_or_mixed': True, 'receiptless': True,
                            'cause': causes.get(label),
                            'files': evidence.job_files(label)})
            continue
        rows = json.loads((ROOT/'.build/jobs'/label/'RECEIPTS.json').read_text())
        failed = any(not r['accepted'] for r in rows)
        assert failed == (label in causes), (label, failed)
        history.append({'job': label, 'failed_or_mixed': failed, 'receiptless': False, 'cause': causes.get(label),
                        'files': evidence.job_files(label) + [evidence.pin(p) for p in sorted((ROOT/'.build/jobs'/label/'sage').glob('*.sage'))]})
    value = {'stage': '191',
        'status': 'PROVED_KERNEL_SCOPED_ACTUAL_FIRST_STEP_F_PRODUCTS / STEP_AND_SOLVER_OPEN / NOT_REVIEWED',
        'scope': 'original make_fg_step first-prime pair-product loop s2 at the actual selected seed9 copy output: productInit with the exact x walk, all 256 product iterations with the two source loads t1[(v<<1)+0]/t1[(v<<1)+1], the nested Montgomery products with the source R2 written through x, the two-clause increment and the written image as executed words; no inverse call, gs path, outer loop, CRT, step, root or encoding completion claimed',
        'whole_owner_task': 'ACTIVE / NOT_COMPLETE', 'kernel_concrete_keygen_witness': False,
        'numeric_acceptance_bound': False, 'public_call_complete': True, 'selected_inverse_complete': True,
        'actual_root_entry_complete': True, 'deepest_setup_complete': True, 'make_fg_conversion_complete': True,
        'make_fg_top_complete': True, 'selected_make_fg_top_call_complete': True, 'make_fg_complete': False,
        'make_fg_step_calls_complete': False, 'first_make_fg_step_entry_complete': True,
        'first_make_fg_step_memory_prefix_complete': True, 'first_make_fg_step_call_complete': False,
        'first_step_prime_scalar_prefix_complete': True, 'first_step_full0_generator_binding_complete': True,
        'first_step_full0_generator_scalar_prefix_complete': True, 'first_step_full0_generator_complete': True,
        'first_step_f_copy_complete': True, 'first_step_f_skip_in_ntt_complete': True,
        'first_step_f_products_complete': True, 'first_step_f_inverse_complete': False,
        'first_step_g_path_complete': False, 'first_step_out_ntt_complete': False,
        'first_step_prime_iteration_complete': False, 'first_step_crt_complete': False,
        'first_step_complete': False, 'first_step_full0_gm_canonical': False,
        'make_fg_top_memory_prefix_complete': True, 'top_modular_init_complete': True,
        'generator_scalar_prefix_complete': True, 'modp_div_total_exact_word': True,
        'generator_complete': True, 'selected_full_gm_canonical': True,
        'selected_both_generator_tables_initialized': True, 'selected_modular_forward_first_pass_complete': True,
        'selected_modular_forward_middle_passes_complete': True, 'selected_modular_forward_triple_pass_complete': True,
        'selected_modular_forward_call_complete': True, 'selected_second_modular_forward_call_complete': True,
        'selected_both_modular_forward_calls_complete': True, 'generator_last_row_complete': True,
        'selected_gm_upper_half_canonical': True, 'generator_cube_complete': True,
        'both_tables_initialized_from_256': True, 'root_solver_complete': False,
        'do_sign_slot_items': 5, 'new_assumptions': False, 'independent_review': False, 'push': False,
        'previous_resume_entry': evidence.pin(PREVIOUS), 'evidence': pins, 'history': history,
        'mathematical_declarations': names, 'final_job': FINAL_JOB,
        'reused_current_mathematical_modules': accepted_modules,
        'whole_law_target': 'KeygenProbability134', 'reference_semantics_changed': False,
        'next': 'the active modp_iNTT3_ext inverse call s3 on fs+u, split into prologue/passes/correction like the forward 182-185; then the gs copy/products/inverse path s4-s7, the false !out_ntt branch s8, the outer u++/guard tail, CRT calls and the additional-prime part; then remaining d-levels, root validation, certificate and encoding to the complete emitted witness for KeygenProbability134',
        'sage_control': 'No new numerical certificate; structural execution and finite counter arithmetic proved directly by the kernel.',
        'counts': {'mathematical_modules': len(MODULES), 'audit_modules': len(AUDITS),
                   'named_declarations': len(names), 'coherent_clean_modules': len(MODULES)+len(AUDITS),
                   'final_job_modules': final_clean_count, 'jobs': len(history),
                   'failed_or_mixed_jobs': len(causes), 'receiptless_jobs': len(RECEIPTLESS)}}

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
    print(json.dumps(evidence.write(BUILD / 'POSTSEAL_191.json', {
        'status': 'PASS_INTEGRITY; ACTIVE_CONTINUATION', 'checked': checked,
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
