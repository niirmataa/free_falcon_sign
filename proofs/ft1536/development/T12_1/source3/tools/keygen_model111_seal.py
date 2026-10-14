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
BUILD = ROOT / '.build/key_law088'
PREVIOUS = BUILD / 'POSTSEAL_110.json'
PREVIOUS_SHA = '519cc807438728617d8adffb91b0ccf4dfffaecd4f3e260d0e7098bd4b5d051c'
MODULES = ['KeygenWholeTrace109', 'KeygenWholeStages109', 'KeygenWholeUnique109', 'KeygenWholeObservation109', 'KeygenSeededExecution109', 'KeygenByteGame109', 'KeygenByteFacts109', 'KeygenInputLaw110', 'KeygenLawAlgebra110', 'KeygenProbability110', 'KeygenConditionMap110', 'KeygenSuccessCount110', 'KeygenLawSupport110', 'KeygenDecodedKey111', 'KeygenModelLaw111', 'KeygenModelBinding111', 'KeygenDecodeMass111']
RECEIPT = ROOT / 'notes/run/KEYGEN_MODEL_111.json'


def inherited():
    evidence.check(PREVIOUS, PREVIOUS_SHA)
    data = json.loads(PREVIOUS.read_text())['checked']
    assert len(data) == 26841
    for path, digest in data.items():
        evidence.check(path, digest)
    return data


def seal():
    inherited()
    assert not job.active(), job.active()
    final = ROOT / '.build/jobs/keygen_model111_008'
    rows = json.loads((final / 'RECEIPTS.json').read_text())
    assert len(rows) == 18
    for row in rows:
        assert row['accepted'] and row['exit_code'] == 0 and row['clean_log']
        assert not row['forbidden_proof_markers']
        assert (final / row['stdout']).stat().st_size == (final / row['stderr']).stat().st_size == 0
        evidence.check(ROOT / 'formal/Source3' / (row['name'][8:] + '.lean'), row['source_sha256'])
    audited = json.loads((final / 'SEARCH_AUDIT.json').read_text())
    names = audit.declarations(MODULES)
    assert len(audited) == len(names) == 110
    assert {r['name'] for r in audited} == set(names)
    for row in audited:
        assert set(row['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(row, ensure_ascii=False)
        if row['body']['kind'] != 'kernel_inductive':
            assert row['body']['kind'] == 'full_expression_dag_json'
            assert row['body']['roundtrip_term_and_type_checked'] is True
    pins = [evidence.pin(ROOT / 'formal/Source3' / (m + '.lean')) for m in MODULES + ['KeygenModel111Audit', 'KeygenFinal111Audit']]
    pins += [evidence.pin(ROOT / p) for p in [
        'tools/job088.py', 'tools/job111.py', 'tools/keygen_whole088_audit.py', 'tools/keygen_model111_seal.py',
        'notes/run/KEYGEN_WHOLE_LAW_088_PLAN.md', 'notes/run/KEYGEN_MODEL_111_NOTES.md',
        'notes/run/KEYGEN_MODEL_111_FAILURES.json', 'notes/run/KEYGEN_MODEL_111_PLAN.md',
        '.build/key_law088/ENTRY.json']]
    evidence.check(REPO / 'Extra/c/falcon-enc.c', '0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05')
    pins += [evidence.pin(REPO / 'Extra/c/falcon-enc.c')]
    for row in json.loads((final / 'SOURCE_INPUTS.json').read_text())['reused']:
        source = row.get('current_source', row['source'])
        evidence.check(source, row['source_sha256'])
        evidence.check(row['artifact'], row['artifact_sha256'])
        pins += [evidence.pin(source), evidence.pin(row['artifact'])]
    causes = json.loads((ROOT / 'notes/run/KEYGEN_MODEL_111_FAILURES.json').read_text())
    history = []
    for index in range(1, 9):
        label = f'keygen_model111_{index:03d}'
        rows = json.loads((ROOT / '.build/jobs' / label / 'RECEIPTS.json').read_text())
        failed = any(not r['accepted'] for r in rows)
        assert failed == (label in causes)
        history.append({'job': label, 'failed_or_mixed': failed, 'cause': causes.get(label),
                        'files': evidence.job_files(label)})
    value = {'stage': '111', 'status': 'PROVED_KERNEL_SCOPED / NOT_REVIEWED',
        'scope': 'actual whole-call decoded joint/model law equality, same certificate material, public marginal, zero decoding-failure mass and concrete AssemblyComp binding; final scope closeout pending',
        'whole_owner_task': 'ACTIVE / NOT_COMPLETE', 'actual_public_codec_closed': True, 'private_dispatcher_closed': True, 'whole_codec_caller_closed_for_constructed_representation': True, 'raw_pointer_interface_counterexample': True, 'whole_solver_determinism': True, 'whole_seed_to_keygen_producer': True, 'input_boundary': 'fixed legal caller; constructed representation; one32-byte replacement seed; no POSIX availability law',
        'actual_whole_raw_law_constructed': True, 'actual_model_law_bound': True, 'actual_keygen_law_identified': True, 'positive_success_proved': False,
        'do_sign_slot_items': 5, 'new_assumptions': False, 'independent_review': False, 'push': False,
        'previous_postseal': evidence.pin(PREVIOUS), 'evidence': pins, 'history': history,
        'mathematical_declarations': names, 'final_job': 'keygen_model111_008',
        'counts': {'new_mathematical_modules': 4, 'selected_mathematical_modules': 17, 'final_audits': 1, 'new_named_declarations': 37, 'audited_named_declarations': 110,
                   'final_clean_modules': 18, 'jobs': 8, 'failed_or_mixed_jobs': 6, 'f04_pinned_modules': 166}}
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
    print(json.dumps(evidence.write(BUILD / 'POSTSEAL_111.json', {
        'status': 'PASS_INTEGRITY; WHOLE_OWNER_TASK_ACTIVE', 'checked': checked,
        'distinct_pinned_files': len(checked), 'actual_keygen_law_identified': True,
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
