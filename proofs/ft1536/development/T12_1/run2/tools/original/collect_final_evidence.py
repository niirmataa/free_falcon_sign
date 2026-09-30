#!/usr/bin/env python3
"""Collect immutable development evidence, with content-addressed sources.

No math and no replay. Inputs/other workspaces are only read.
"""
from datetime import datetime, timezone
import gzip
import hashlib
import json
from pathlib import Path
import shutil

W = Path(__file__).resolve().parent.parent
R, O = W / 'run', W / 'output'
D = R / 'FINAL_EVIDENCE_20260929'


def sha(p):
    h = hashlib.sha256()
    with p.open('rb') as f:
        for b in iter(lambda: f.read(1048576), b''):
            h.update(b)
    return h.hexdigest()


def write(p, data):
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(json.dumps(data, indent=2, sort_keys=True) + '\n')


def copy(p, target):
    target.parent.mkdir(parents=True, exist_ok=True)
    if target.exists():
        if sha(target) != sha(p):
            raise ValueError('evidence path conflict: ' + str(target))
    else:
        shutil.copyfile(p, target)


def main():
    D.mkdir(exist_ok=False)
    current = {sha(p): str(p.relative_to(O)) for p in (O / 'formal').rglob('*.lean')}
    current.update({sha(p): str(p.relative_to(O)) for p in (O / 'sage').glob('*.sage')})
    objects, attempts, bindings = {}, {}, []

    def store(p):
        h = sha(p)
        if h in current:
            return {'sha256': h, 'in_package': current[h]}
        if h not in objects:
            rel = 'history/source-objects/' + h + ''.join(p.suffixes) + '.gz'
            dest = D / rel
            dest.parent.mkdir(parents=True, exist_ok=True)
            with p.open('rb') as src, dest.open('wb') as raw:
                with gzip.GzipFile(fileobj=raw, mode='wb', filename='', mtime=0) as gz:
                    shutil.copyfileobj(src, gz, 1048576)
            objects[h] = rel
        return {'sha256': h, 'in_package': objects[h], 'compressed': 'gzip'}

    roots = [d for d in sorted(R.iterdir()) if d.is_dir() and not d.is_symlink()
             and (d / 'logs').is_dir() and not d.name.startswith(('final_fresh_replay_', 'FINAL_EVIDENCE_'))]
    for parent in ['GAME_BINDING_REVIEW_001', 'GAME_BINDING_REVIEW_002']:
        roots += [d for d in sorted((R / parent).iterdir()) if d.is_dir() and
                  d.name.startswith(('replay_', 'checks_')) and (d / 'logs').is_dir()]
    for d in roots:
        label = str(d.relative_to(R)).replace('/', '__')
        records = []
        for folder in ['formal', 'sage']:
            for p in sorted((d / folder).rglob('*')):
                if p.is_file() and not p.is_symlink() and p.suffix in {'.lean', '.sage', '.py', '.pyx'} and not p.name.endswith('.sage.py'):
                    records.append({'path': str(p.relative_to(d)), **store(p)})
        for p in sorted((d / 'logs').iterdir()):
            if p.is_file() and not p.is_symlink():
                copy(p, D / 'history/attempts' / label / 'logs' / p.name)
        for name in ['RECEIPTS.json', 'EXECUTION_RECEIPTS.json', 'SOURCE_INPUTS.json', 'RUNNER_SOURCE.py',
                     'REPLAY_RESULT.json', 'MACHINE_COMPONENTS_AUDIT.json', 'AXIOMS.json']:
            p = d / name
            if p.is_file():
                copy(p, D / 'history/attempts' / label / name)
        for p in sorted(d.glob('*.json')):
            if p.name in {'RECEIPTS.json', 'EXECUTION_RECEIPTS.json', 'SOURCE_INPUTS.json', 'AXIOMS.json'}:
                continue
            records.append({'path': p.name, **store(p)})
        for receipt in sorted((d / 'logs').glob('*.receipt.json')):
            rec = json.loads(receipt.read_text())
            for key in ['stdout', 'stderr']:
                log = d / rec[key]
                if not log.is_file() or sha(log) != rec[key + '_sha256']:
                    raise ValueError('historical raw-log mismatch: ' + str(receipt))
            bindings.append({'attempt': label, 'receipt': 'history/attempts/' + label + '/logs/' + receipt.name,
                             'exit_code': rec.get('exit_code'), 'accepted': rec.get('accepted'),
                             'stdout_sha256': rec['stdout_sha256'], 'stderr_sha256': rec['stderr_sha256']})
        attempts[label] = records
    for p in sorted((R / 'OUTPUT_DRAFT_20260929').glob('*')):
        if p.is_file():
            records = store(p)
            attempts.setdefault('previous_output_root', []).append({'path': p.name, **records})
    write(D / 'history/SOURCE_SNAPSHOTS.json', attempts)
    write(D / 'history/RAW_LOG_BINDINGS.json', bindings)
    prior = json.loads((R / 'INHERITED_LIBRARY_CLOSURE.json').read_text())
    live = json.loads((O / 'LIBRARY_CLOSURE.json').read_text())
    new = {m['module']: m for m in live['modules']}
    matches = []
    for old in prior['modules']:
        if old['module'] not in new:
            continue
        item = new[old['module']]
        ok = old['source_sha256'] == item['source_sha256'] and all(
            a in item['artifacts'] for a in old['artifacts'])
        matches.append({'module': old['module'], 'match': ok})
    if not all(m['match'] for m in matches):
        raise ValueError('inherited library pins differ')
    write(D / 'provenance/INHERITED_LIBRARY_BINDING.json', {'compared': len(matches), 'matches': matches})
    t5 = W.parent / 'FT1536_T5_FLAT_REJECT_RUN_001'
    refs = ['TASK.md', 'WORK_STATE.md', 'run/formal/Run2/T5BoxTransport.lean',
            'run/formal/Run2/T5KeyGenQuant.lean', 'run/formal/Run2/T5CholeskyCert.lean',
            'run/formal/Run2/T5Tail.lean', 'run/formal/Run2/T5FlatReject.lean']
    pins = [{'path': str(t5 / p), 'sha256': sha(t5 / p)} for p in refs]
    write(D / 'T5_DEPENDENCY_STATUS.json', {'utc': datetime.now(timezone.utc).isoformat(), 'source': str(t5),
        'mode': 'read-only status/source inspection; not imported, executed, or independently reviewed',
        'formal_consumption_in_this_package': False, 'frozen_handoff_consumed': False, 'pins': pins,
        'missing_export': 'source-bound SuccessfulPinnedCKeyGen h -> KeyTowerTransportCert h, including actual Gram/leaves and BoxTransportCert',
        'available_consumer': 'T5BoxTransport.flat_reject_of_towers',
        'current_box_certificate': 'forall c, infFiberMass h c alpha - fiberMass h c alpha <= transportBudget*v'})
    for name in ['RESTART_PREPARATION.json', 'PACKAGE_PREPARATION.json']:
        copy(R / 'RESUME_A3_20260929' / name, D / 'provenance/resume' / name)
    write(D / 'EVIDENCE_COLLECTION.json', {'utc': datetime.now(timezone.utc).isoformat(),
        'attempts': len(roots), 'source_objects': len(objects), 'raw_receipt_bindings': len(bindings),
        'historical_failed_attempts_preserved': True, 'no_compiled_caches_copied': True,
        'library_comparisons': len(matches)})
    print(json.dumps(json.loads((D / 'EVIDENCE_COLLECTION.json').read_text()), indent=2), flush=True)


if __name__ == '__main__':
    main()
