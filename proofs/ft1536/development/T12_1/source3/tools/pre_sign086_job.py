#!/usr/bin/env python3
"""Build only new preparation modules against the pinned F04 166-module scope."""
from pathlib import Path
import fcntl
import importlib.util
import json
import os
import re
import shutil
import sys
import job079 as job

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parents[4]
F04 = REPO / 'proofs/ft1536/development/T12_1/run2/notes/F04_ROM_VARIANT_A_SCOPE_002/RECEIPT.json'


def main():
    label, *names = sys.argv[1:]
    assert re.fullmatch(r'[a-zA-Z0-9_]+', label) and names
    with (ROOT / '.build/JOB.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        assert not job.active(), job.active()
        dest = ROOT / '.build/jobs' / label
        dest.mkdir(exist_ok=False)
        for part in ['formal', 'lib', 'logs', 'home', 'tmp', 'cache']:
            (dest / part).mkdir()
        assert job.sha(F04) == '675e96ee8a3398688f83a1a2d5f9297369d285aac2da67557fef12f48a0427e9'
        scope = json.loads(F04.read_text())
        replay = REPO / scope['author_final_clean_002']['path']
        assert job.sha(replay) == scope['author_final_clean_002']['sha256']
        steps = {s['module']: s for s in json.loads(replay.read_text())['steps']}
        inputs = {'scope_sha256': job.sha(F04), 'replay_sha256': job.sha(replay),
                  'runner_sha256': job.sha(Path(__file__)), 'dependencies': [], 'sources': []}
        assert len(scope['modules']) == 166
        for m in scope['modules']:
            assert m['module'] != 'SelectBitPreserve'
            source = REPO / m['source']['path']
            step = steps[m['module']]
            assert step['source_sha256'] == m['source']['sha256']
            artifact = Path(step['command'][3])
            assert job.sha(source) == m['source']['sha256'], ('INTEGRITY_STOP', str(source))
            assert job.sha(artifact) == step['output_sha256'], ('INTEGRITY_STOP', str(artifact))
            link = dest / 'lib' / (m['module'].replace('.', '/') + '.olean')
            link.parent.mkdir(parents=True, exist_ok=True)
            link.symlink_to(artifact)
            inputs['dependencies'].append({'module': m['module'], 'source': str(source),
                'source_sha256': job.sha(source), 'artifact': str(artifact),
                'artifact_sha256': job.sha(artifact)})
        closure, config, _ = job.pinned()
        engine_source = Path(config['parent_frozen']) / 'tools/execution.py'
        assert job.sha(engine_source) == closure['execution_runner_sha256']
        spec = importlib.util.spec_from_file_location('pinned_execution', engine_source)
        engine = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(engine)
        shutil.copyfile(__file__, dest / 'RUNNER_SOURCE.py')
        shutil.copyfile(engine_source, dest / 'EXECUTION_SOURCE.py')
        libs = [str(v['build']) for k, v in config['library_roots'].items() if k != 'lean']
        env = os.environ.copy()
        env.update(HOME=str(dest / 'home'), TMPDIR=str(dest / 'tmp'), TMP=str(dest / 'tmp'),
                   TEMP=str(dest / 'tmp'), XDG_CACHE_HOME=str(dest / 'cache'),
                   PYTHONDONTWRITEBYTECODE='1', OPENBLAS_NUM_THREADS='1', OMP_NUM_THREADS='1',
                   LEAN_PATH=':'.join([str(dest / 'lib'), *libs]))
        inputs['libraries'] = config['library_roots']
        inputs['engine_sha256'] = job.sha(engine_source)
        inputs['lean_sha256'] = job.sha(engine.LEAN)
        copies = []
        for name in names:
            assert re.fullmatch(r'Source3\.[a-zA-Z0-9_]+', name)
            source = ROOT / 'formal' / (name.replace('.', '/') + '.lean')
            target = dest / 'formal' / (name.replace('.', '/') + '.lean')
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(source, target)
            inputs['sources'].append({'path': str(source), 'sha256': job.sha(source)})
            copies.append((name, target))
        (dest / 'SOURCE_INPUTS.json').write_text(json.dumps(inputs, indent=2) + '\n')
        records = []
        for name, source in copies:
            assert not job.active(), job.active()
            artifact = dest / 'lib' / (name.replace('.', '/') + '.olean')
            artifact.parent.mkdir(parents=True, exist_ok=True)
            record = engine.step(dest, name.replace('.', '_'),
                [str(engine.LEAN), '-j1', '-M6144', '-o', str(artifact), str(source)], dest / 'formal', env)
            record['source_sha256'] = job.sha(source)
            record['artifact_sha256'] = job.sha(artifact) if artifact.exists() else None
            records.append(record)
            (dest / 'RECEIPTS.json').write_text(json.dumps(records, indent=2) + '\n')
            if not record['accepted'] or record['cumulative_child_maxrss_kib'] > 8 * 1024 * 1024:
                return 1
        return 0


if __name__ == '__main__':
    sys.exit(main())
