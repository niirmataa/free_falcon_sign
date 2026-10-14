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
PREVIOUS = BUILD / 'POSTSEAL_097.json'
PREVIOUS_SHA = 'fa00266799a11da34e349e8c8e3b8896808d4b017adcbf4f307553d54e3a5676'
MODULES = ['KeygenZintDeterminism098', 'KeygenZintCoreArity098', 'KeygenZintExtractArity098', 'KeygenTokenizerStep098', 'KeygenBezoutText098', 'KeygenLexPrefix098', 'KeygenLexCompose098', 'KeygenLexData098', 'KeygenLexChunks098A', 'KeygenLexChunks098B', 'KeygenLexChunks098C', 'KeygenLexChunks098D', 'KeygenLexChunks098E', 'KeygenLexFinish098', 'KeygenLexAll098', 'KeygenBezoutTokens098', 'KeygenBezoutParse098', 'KeygenBezoutCheck098', 'KeygenBezoutArity098', 'KeygenZintCall098']
RECEIPT = ROOT / 'notes/run/KEYGEN_BIGINT_098.json'


def inherited():
    evidence.check(PREVIOUS, PREVIOUS_SHA)
    data = json.loads(PREVIOUS.read_text())['checked']
    assert len(data) == 24534
    for path, digest in data.items():
        evidence.check(path, digest)
    return data


def seal():
    inherited()
    assert not job.active(), job.active()
    final = ROOT / '.build/jobs/keygen_bigint098_034'
    rows = json.loads((final / 'RECEIPTS.json').read_text())
    assert len(rows) == 21
    assert [r['name'] for r in rows[:20]] == ['Source3_' + m for m in MODULES]
    assert rows[20]['name'] == 'Source3_KeygenBigint098Audit' and not rows[20]['accepted']
    audit_final = ROOT / '.build/jobs/keygen_bigint098_035'
    audit_rows = json.loads((audit_final / 'RECEIPTS.json').read_text())
    assert len(audit_rows) == 1 and audit_rows[0]['name'] == 'Source3_KeygenBigint098Audit'
    for row, folder in [(r, final) for r in rows[:20]] + [(audit_rows[0], audit_final)]:
        assert row['accepted'] and row['exit_code'] == 0 and row['clean_log']
        assert not row['forbidden_proof_markers']
        assert (folder / row['stdout']).stat().st_size == (folder / row['stderr']).stat().st_size == 0
        evidence.check(ROOT / 'formal/Source3' / (row['name'][8:] + '.lean'), row['source_sha256'])
    audited = json.loads((audit_final / 'SEARCH_AUDIT.json').read_text())
    entries = (audit_final / 'SEARCH_AUDIT_ENTRIES.jsonl').read_text().splitlines()
    assert len(entries) == len(audited)
    assert all(json.loads(line) == row for line, row in zip(entries, audited))
    names = audit.declarations(MODULES)
    assert len(audited) == len(names) == 296
    assert {r['name'] for r in audited} == set(names)
    for row in audited:
        assert set(row['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(row, ensure_ascii=False)
        if row['body']['kind'] != 'kernel_inductive':
            assert row['body']['kind'] == 'full_expression_dag_json'
            assert row['body']['roundtrip_term_and_type_checked'] is True
    pins = [evidence.pin(ROOT / 'formal/Source3' / (m + '.lean')) for m in MODULES + ['KeygenBigint098Audit']]
    pins += [evidence.pin(ROOT / p) for p in [
        'tools/job088.py', 'tools/keygen_whole088_audit.py', 'tools/keygen_bigint098_audit.py', 'tools/keygen_bigint098_seal.py',
        'tools/keygen_text098_generate.py', 'tools/keygen_lex_chunks098_generate.py', 'tools/keygen_tokens098_generate.py',
        'notes/run/KEYGEN_WHOLE_LAW_088_PLAN.md', 'notes/run/KEYGEN_BIGINT_098_NOTES.md',
        'notes/run/KEYGEN_BIGINT_098_FAILURES.json', 'notes/run/KEYGEN_BIGINT_098_PROGRESS.md',
        '.build/key_law088/LEX_CHUNKS_098_GENERATION.json', '.build/key_law088/LEX_CHUNKS_098_GENERATION_V2.json',
        '.build/key_law088/BIGINT098_016_STOP.json', '.build/key_law088/ENTRY.json']]
    pins += [evidence.pin(p) for p in sorted((BUILD / 'attempts098').rglob('*')) if p.is_file()]
    for module, label in [('KeygenBezoutTokensGen098', 'keygen_bigint098_017'),
                          ('KeygenBezoutChunkGen098', 'keygen_bigint098_021')]:
        generated = json.loads((ROOT / '.build/jobs' / label / 'RECEIPTS.json').read_text())
        assert len(generated) == 1 and generated[0]['accepted'] and generated[0]['clean_log']
        current = ROOT / 'formal/Source3' / (module + '.lean')
        evidence.check(current, generated[0]['source_sha256'])
        pins.append(evidence.pin(current))
    audit_reused = json.loads((audit_final / 'SOURCE_INPUTS.json').read_text())['reused']
    for module in MODULES:
        row = next(r for r in audit_reused if r['module'] == 'Source3.' + module)
        assert Path(row['artifact']).resolve() == (final / 'lib/Source3' / (module + '.olean')).resolve()
    reused = json.loads((final / 'SOURCE_INPUTS.json').read_text())['reused'] + audit_reused
    for row in reused:
        source = row.get('current_source', row['source'])
        evidence.check(source, row['source_sha256'])
        evidence.check(row['artifact'], row['artifact_sha256'])
        pins += [evidence.pin(source), evidence.pin(row['artifact'])]
    causes = json.loads((ROOT / 'notes/run/KEYGEN_BIGINT_098_FAILURES.json').read_text())
    history = []
    for index in range(1, 36):
        label = f'keygen_bigint098_{index:03d}'
        rows = json.loads((ROOT / '.build/jobs' / label / 'RECEIPTS.json').read_text())
        failed = any(not r['accepted'] for r in rows)
        assert failed == (label in causes)
        history.append({'job': label, 'role': 'data_generation_not_proof' if index in {12, 15, 17, 21} else 'proof_or_audit', 'failed_or_mixed': failed, 'cause': causes.get(label),
                        'files': evidence.job_files(label)})
    value = {'stage': '098', 'status': 'PROVED_KERNEL_SCOPED / NOT_REVIEWED',
        'scope': 'complete actual bigint/CRT/Bezout/extraction source-call determinism and exact partial denotation; kernel-certified compositional lexer data',
        'whole_owner_task': 'ACTIVE / NOT_COMPLETE', 'whole_bigint_source_family_closed': True, 'native_generation_is_proof': False, 'cached_data_kernel_equalities': True, 'whole_solver_determinism': False, 'whole_seed_to_keygen_producer': False,
        'actual_keygen_law_identified': False, 'positive_success_proved': False,
        'do_sign_slot_items': 5, 'new_assumptions': False, 'independent_review': False, 'push': False,
        'previous_postseal': evidence.pin(PREVIOUS), 'evidence': pins, 'history': history,
        'mathematical_declarations': names, 'source_replay_job': 'keygen_bigint098_034', 'final_audit_job': 'keygen_bigint098_035',
        'counts': {'mathematical_modules': 20, 'audits': 1, 'named_declarations': 296,
                   'clean_source_replay_modules': 20, 'clean_final_audit_modules': 1, 'jobs': 35, 'data_generation_jobs': 4, 'failed_or_mixed_jobs': 20, 'lexical_prefixes': 41}}
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
    print(json.dumps(evidence.write(BUILD / 'POSTSEAL_098.json', {
        'status': 'PASS_INTEGRITY; WHOLE_OWNER_TASK_ACTIVE', 'checked': checked,
        'distinct_pinned_files': len(checked), 'actual_keygen_law_identified': False,
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
