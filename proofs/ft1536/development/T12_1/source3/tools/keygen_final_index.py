#!/usr/bin/env python3
"""Index sealed whole-law stages without replacing their evidence or status."""
from pathlib import Path
import hashlib
import json
import subprocess

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parents[4]
BASE = '9d78eb3fe73d928a1324c7b5d11e273ee97f28b2'
ASSESSMENT = 'e1a89f75'


def sha(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def main():
    parent = ROOT / '.build/key_law088/POSTSEAL_111.json'
    assert sha(parent) == '0476066da04edb02c2009a6d0fdc7a9286b9e08f8100d3cd5c7c87cd161a6a65'
    checked = json.loads(parent.read_text())['checked']

    def pin(path):
        digest = sha(path)
        if path != parent:
            assert checked[str(path)] == digest, ('INTEGRITY_STOP', str(path))
        return {'path': str(path.relative_to(REPO)), 'sha256': digest}

    stages = []
    for number in range(88, 112):
        candidates = list((ROOT / 'notes/run').glob(f'*_{number:03d}.json'))
        if number == 88:
            candidates = [ROOT / 'notes/run/KEYGEN_WHOLE_LAW_088_A.json']
        assert len(candidates) == 1, (number, candidates)
        receipt = candidates[0]
        value = json.loads(receipt.read_text())
        postseal = ROOT / f'.build/key_law088/POSTSEAL_{number:03d}.json'
        if number == 88:
            postseal = ROOT / '.build/key_law088/POSTSEAL_088_A.json'
        jobs = {key: value[key] for key in ['final_job', 'source_replay_job', 'final_audit_job'] if key in value}
        assert jobs
        stages.append({'stage': number, 'receipt': pin(receipt), 'postseal': pin(postseal),
                       'status': value['status'], 'scope': value['scope'], 'counts': value['counts'],
                       'accepted_job_fields': jobs})
    head = subprocess.check_output(['git', 'rev-parse', ASSESSMENT], cwd=REPO, text=True).strip()
    rows = subprocess.check_output(['git', 'log', '--reverse', '--format=%H%x09%s',
        BASE + '..' + head, '--', str(ROOT.relative_to(REPO))], cwd=REPO, text=True).splitlines()
    index = {'schema': 'FT1536_KEYGEN_WHOLE_LAW_CLOSEOUT_INDEX_V1', 'base': BASE,
             'assessment_head': head, 'status': 'OWNER_KEYGEN_LAW_OBJECTIVE_MET_IN_DECLARED_A2_REFERENCE_SCOPE / NOT_REVIEWED',
             'stages': stages, 'local_commits': [dict(zip(['commit', 'subject'], row.split('\t', 1))) for row in rows],
             'metadata_attempts': [{'attempt': 1, 'result': 'FAILED_BEFORE_WRITE',
                 'cause': 'Initial index generator expected final_job in every stage; 098 records source_replay_job and final_audit_job separately. Preserve both original fields; no receipt changed.'}],
             'do_sign_items': 5, 'push': False, 'independent_review': False}
    output = ROOT / 'notes/run/KEYGEN_WHOLE_LAW_FINAL_001_INDEX.json'
    encoded = json.dumps(index, indent=2) + '\n'
    if output.exists():
        assert output.read_text() == encoded, 'index reproduction mismatch'
    else:
        with output.open('x') as stream:
            stream.write(encoded)
    print(json.dumps({'stages': len(stages), 'commits': len(rows), 'sha256': sha(output)}))


if __name__ == '__main__':
    main()
