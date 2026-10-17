#!/usr/bin/env python3
"""Postseal the analytic Z>0 window: pins only; partial proof with a named wall.

The window derives the MODE1 coefficient law from the pinned sampler body
and closes the consumption chain from a positive first-attempt bound to the
model package. No numerical acceptance bound and no seed-law positivity is
claimed; the report names the exact wall and the re-scope.
"""
from pathlib import Path
import json
import sys
import job111 as job
import pre_sign_evidence084 as evidence
import keygen_whole088_audit as audit

ROOT, REPO = evidence.ROOT, evidence.REPO
BUILD = ROOT / '.build/zlower134'
RECEIPT = ROOT / 'notes/run/KEYGEN_Z_LOWER_134.json'
MODULES = ['KeygenMode1Law134', 'KeygenModelUnlock134']
AUDIT = 'KeygenZLower134Audit'
MATH_JOB = 'keygen_zlower134_006'
AUDIT_JOB = 'keygen_zlower134_007'
CONTROL_JOB = 'keygen_zlower134_011'


def clean_job(label, names):
    folder = ROOT / '.build/jobs' / label
    rows = json.loads((folder / 'RECEIPTS.json').read_text())
    assert [row['name'] for row in rows] == names, (label, [row['name'] for row in rows])
    for row in rows:
        assert row['accepted'] and row['exit_code'] == 0 and row['clean_log']
        assert not row['forbidden_proof_markers']
        assert (folder / row['stdout']).stat().st_size == 0
        assert (folder / row['stderr']).stat().st_size == 0
        assert row['source_sha256']
    return rows


def seal():
    assert not job.active(), job.active()
    math_rows = clean_job(MATH_JOB, ['Source3_' + name for name in MODULES])
    for row in math_rows:
        evidence.check(ROOT / 'formal/Source3' / (row['name'][8:] + '.lean'), row['source_sha256'])
        assert row['olean_sha256']
    audit_rows = clean_job(AUDIT_JOB, ['Source3_' + AUDIT])
    evidence.check(ROOT / 'formal/Source3' / (AUDIT + '.lean'), audit_rows[0]['source_sha256'])
    audited = json.loads((ROOT / '.build/jobs' / AUDIT_JOB / 'SEARCH_AUDIT.json').read_text())
    names = audit.declarations(MODULES)
    assert len(audited) == len(names) == 43
    assert {row['name'] for row in audited} == set(names)
    for row in audited:
        assert set(row['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(row, ensure_ascii=False)
        assert row['body']['kind'] == 'full_expression_dag_json'
        assert row['body']['roundtrip_term_and_type_checked'] is True
    control_rows = clean_job(CONTROL_JOB, ['sage'])
    control = json.loads((ROOT / '.build/jobs' / CONTROL_JOB / 'ZLOWER134_CONTROLS.json').read_text())
    assert control['status'] == 'PASS_EXACT_AUXILIARY_CONTROLS_ONLY'
    assert control['new_keygen_runs'] == 0
    assert control['population_probability_lower_bound_proved'] is False
    assert control['seed_law_lower_bound_proved'] is False
    assert control['chunk_law_of_shake_derived'] is False
    evidence.check(ROOT / 'sage/keygen_zlower134_controls.sage', control_rows[0]['source_sha256'])
    pins = [evidence.pin(ROOT / 'formal/Source3' / (name + '.lean')) for name in MODULES + [AUDIT]]
    for rel in ['tools/keygen_zlower134_seal.py', 'sage/keygen_zlower134_controls.sage',
                'notes/run/KEYGEN_Z_LOWER_134_PLAN.md', 'notes/run/KEYGEN_Z_LOWER_134_REPORT.md',
                'notes/run/KEYGEN_Z_LOWER_134_FAILURES.json']:
        pins.append(evidence.pin(ROOT / rel))
    history = []
    for index in range(1, 12):
        label = f'keygen_zlower134_{index:03d}'
        folder = ROOT / '.build/jobs' / label
        rows = json.loads((folder / 'RECEIPTS.json').read_text())
        failed = any(not row['accepted'] for row in rows)
        history.append({'job': label, 'failed_or_mixed': failed, 'files': evidence.job_files(label)})
    causes = json.loads((ROOT / 'notes/run/KEYGEN_Z_LOWER_134_FAILURES.json').read_text())
    failed_labels = {row['job'] for row in history if row['failed_or_mixed']}
    assert failed_labels == set(causes), (failed_labels, set(causes))
    postseal = BUILD / 'POSTSEAL_Z134.json'
    BUILD.mkdir(exist_ok=True)
    evidence.write(postseal, {
        'window': 'KEYGEN_Z_LOWER_134 (analytic Z>0 and bounds, instead of a kernel witness)',
        'status': 'POSTSEAL_PINS_ONLY; PARTIAL_PROOF; STOP_AND_REPORT_AT_NAMED_WALL; NOT_REVIEWED',
        'accepted_modules': {'Source3.KeygenMode1Law134': MATH_JOB,
                             'Source3.KeygenModelUnlock134': MATH_JOB},
        'audit': {'declarations': len(names), 'job': AUDIT_JOB, 'standard_axioms_only': True},
        'sage_control': {'job': CONTROL_JOB, 'is_premise': False,
                         'new_keygen_runs': control['new_keygen_runs']},
        'jobs_total': len(history), 'jobs_failed_or_mixed': len(causes),
        'numeric_acceptance_bound_proved': False, 'seed_law_positive_Z_proved': False,
        'mode1_uniform_case_proved': True, 'mode1_deviation_bound_proved': True,
        'package_consumption_chain_proved': True,
        'wall': 'per-chunk SHAKE law over the uniform 32-byte seed law is not supplied by the sampler sources; '
                'acceptMass positivity is equivalent to an accepting-seed witness (KeygenModelUnlock134.acceptMass_positive_iff)',
        'whole_owner_task': 'ACTIVE / NOT_COMPLETE', 'do_sign_slot_items': 5,
        'new_assumptions': False, 'independent_review': False, 'push': False,
        'files': {str(Path(p['path']).relative_to(ROOT)): p['sha256'] for p in pins}})
    value = {
        'stage': 'Z_LOWER_134', 'status': 'PARTIAL_PROOF / STOP_AND_REPORT / NOT_REVIEWED',
        'owner_task': 'NOT_COMPLETE: NO POSITIVE EPSILON ESTABLISHED FOR THE SEED LAW',
        'mode1_coefficient_law_derived': True, 'mode1_uniform_case': '1/3 per stored value',
        'mode1_deviation_bound': '16*d/(9-12*d)', 'geometric_retry_identity': True,
        'acceptance_region_bound_proved': False, 'coding_bound_proved': False,
        'Z_positive_proved': False, 'package_unlock_consumers_proved': True,
        'acceptance_positivity_is_witness_existence': True,
        'chunk_law_of_shake_derived': False, 'empirical_is_premise': False,
        'new_keygen_runs': 0, 'new_assumptions': False, 'paper_changed': False,
        'do_sign_slot_items': 5, 'independent_review': False, 'push': False,
        'mathematical_declarations': names,
        'accepted_jobs': [MATH_JOB, AUDIT_JOB, CONTROL_JOB],
        'history': history, 'evidence': pins,
        'postseal': evidence.pin(postseal),
        'counts': {'new_mathematical_modules': 2, 'audited_declarations': len(names),
                   'jobs': len(history), 'failed_or_mixed_jobs': len(causes)}}
    print(json.dumps(evidence.write(RECEIPT, value)))


if __name__ == '__main__':
    seal()
