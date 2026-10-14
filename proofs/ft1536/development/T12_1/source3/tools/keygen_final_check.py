#!/usr/bin/env python3
"""Final committed-source and inherited-pin check; no proof or scope repair."""
from pathlib import Path
from datetime import datetime, timezone
import fcntl
import json
import re
import subprocess
import job111 as job
import pre_sign_evidence084 as evidence

ROOT, REPO = evidence.ROOT, evidence.REPO
PARENT = ROOT / '.build/key_law088/POSTSEAL_111.json'
PARENT_SHA = '0476066da04edb02c2009a6d0fdc7a9286b9e08f8100d3cd5c7c87cd161a6a65'
CLOSEOUT = ['WORK_STATE.md', 'notes/run/KEYGEN_RESIDUE_CHECKPOINT.md',
    'notes/run/KEYGEN_WHOLE_LAW_TODO.md', 'notes/run/KEYGEN_WHOLE_LAW_FINAL_001.md',
    'notes/run/KEYGEN_WHOLE_LAW_FINAL_001_INDEX.json', 'tools/keygen_final_index.py',
    'tools/keygen_final_check.py']


def main():
    with (ROOT / '.build/JOB.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        assert not job.active(), job.active()
        evidence.check(PARENT, PARENT_SHA)
        checked = dict(json.loads(PARENT.read_text())['checked'])
        assert len(checked) == 27064
        for path, digest in checked.items():
            evidence.check(path, digest)
        checked[str(PARENT)] = PARENT_SHA
        head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=REPO, text=True).strip()
        branch = subprocess.check_output(['git', 'branch', '--show-current'], cwd=REPO, text=True).strip()
        assert branch == 'main'
        final = ROOT / '.build/jobs/keygen_model111_008'
        rows = json.loads((final / 'RECEIPTS.json').read_text())
        assert len(rows) == 18
        committed = []
        for row in rows:
            assert row['accepted'] and row['clean_log'] and row['exit_code'] == 0
            assert not row['forbidden_proof_markers']
            assert (final / row['stdout']).stat().st_size == (final / row['stderr']).stat().st_size == 0
            source = ROOT / 'formal/Source3' / (row['name'][8:] + '.lean')
            evidence.check(source, row['source_sha256'])
            committed.append(source)
        audited = json.loads((final / 'SEARCH_AUDIT.json').read_text())
        assert len(audited) == 110
        for row in audited:
            assert set(row['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
            assert '⋯' not in json.dumps(row, ensure_ascii=False)
            if row['body']['kind'] != 'kernel_inductive':
                assert row['body']['kind'] == 'full_expression_dag_json'
                assert row['body']['roundtrip_term_and_type_checked'] is True
        index = json.loads((ROOT / 'notes/run/KEYGEN_WHOLE_LAW_FINAL_001_INDEX.json').read_text())
        assert [r['stage'] for r in index['stages']] == list(range(88, 112))
        for row in index['stages']:
            for field in ['receipt', 'postseal']:
                evidence.check(REPO / row[field]['path'], row[field]['sha256'])
        todo = (ROOT / 'notes/run/KEYGEN_WHOLE_LAW_TODO.md').read_text()
        assert '- [ ]' not in todo and 'COMPLETE IN DECLARED A2/REFERENCE SCOPE / NOT_REVIEWED' in todo
        for rel in CLOSEOUT:
            path = ROOT / rel
            committed.append(path)
            checked[str(path)] = evidence.sha(path)
            if path.suffix == '.md' and path.name in {'KEYGEN_WHOLE_LAW_TODO.md', 'KEYGEN_WHOLE_LAW_FINAL_001.md'}:
                for link in re.findall(r'\]\(([^)]+)\)', path.read_text()):
                    assert not link.startswith(('http:', 'https:'))
                    assert (path.parent / link.split('#')[0]).exists(), (rel, link)
        for path in committed:
            relative = str(path.relative_to(REPO))
            content = subprocess.check_output(['git', 'show', head + ':' + relative], cwd=REPO)
            assert content == path.read_bytes(), ('UNCOMMITTED_SOURCE', relative)
        post = ROOT / '.build/key_law088/FINAL_POSTSEAL_001.json'
        pin = evidence.write(post, {'status': 'PASS_INTEGRITY_AND_COMMITTED_SOURCE',
            'utc': datetime.now(timezone.utc).isoformat(), 'head': head, 'branch': branch,
            'checked': checked, 'distinct_pinned_files': len(checked),
            'committed_files_checked': [str(p.relative_to(REPO)) for p in committed],
            'final_clean_modules': 18, 'audited_declarations': 110, 'standard_axioms_only': True,
            'independent_review': False, 'push': False})
        receipt = evidence.write(ROOT / 'notes/run/KEYGEN_WHOLE_LAW_FINAL_001.json', {
            'status': 'OWNER_KEYGEN_LAW_OBJECTIVE_MET_IN_DECLARED_A2_REFERENCE_SCOPE / NOT_REVIEWED',
            'source_and_closeout_head': head, 'final_postseal': pin,
            'report': evidence.pin(ROOT / 'notes/run/KEYGEN_WHOLE_LAW_FINAL_001.md'),
            'index': evidence.pin(ROOT / 'notes/run/KEYGEN_WHOLE_LAW_FINAL_001_INDEX.json'),
            'parent_postseal': evidence.pin(PARENT), 'stage_count': 24,
            'do_sign_items': 5, 'new_assumptions': False, 'independent_review': False, 'push': False,
            'not_claimed': ['unconditional OS bootstrap law or transport', 'arbitrary native heap rebasing',
                'positive success or termination', 'non-signing byte security game transport',
                'honest-signing implementation security', 'actual-C e2 bound']})
        print(json.dumps({'postseal': pin, 'receipt': receipt, 'checked': len(checked)}))


if __name__ == '__main__':
    main()
