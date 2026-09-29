#!/usr/bin/env python3
"""Audit materialized owner bootstrap, then copy a portable read-only P02 source closure."""
from pathlib import Path
import hashlib, json, shutil, datetime

W = Path(__file__).resolve().parents[1]
B = W/'inputs/bootstrap'
P = B/'prior'
O = W/'output'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()

def manifest(root, listing, extra=()):
    rows = {}
    for line in listing.read_text().splitlines():
        h, name = line.split('  ',1)
        n=Path(name)
        assert not n.is_absolute() and '..' not in n.parts and name not in rows
        p=root/n
        assert p.is_file() and not p.is_symlink() and p.resolve().is_relative_to(root.resolve()),name
        assert sha(p)==h,name
        rows[name]=h
    actual={p.relative_to(root).as_posix() for p in root.rglob('*') if p.is_file()}
    assert not any(p.is_symlink() for p in root.rglob('*'))
    assert actual==set(rows)|set(extra),(root,len(actual),len(rows),sorted(actual-set(rows))[:10])
    return {'count':len(rows),'bytes':sum((root/n).stat().st_size for n in rows),'sha256':sha(listing)}

assert sha(B/'MANIFEST.sha256')=='088b407a3be937a49b1a23d4305e83641123d9770040d78b4a43b7cabe14c65f'
assert sha(P/'output/REPORT.md')=='98ea050bfe15b39b4ad2a6d26428bcd7e12f22ca33b06b6bc98e9e964bb295a5'
assert sha(P/'output/OUTPUTS.sha256')=='4e8942ccaf46f0971688a0f0cc1d07c5831a46175e6ad2dde903c9f55b046a01'
facts={'bootstrap':manifest(B,B/'MANIFEST.sha256',('MANIFEST.sha256','ORIGINS.json')),
       'prior_output':manifest(P/'output',P/'output/OUTPUTS.sha256',('OUTPUTS.sha256',)),
       'prior_inputs':manifest(P/'inputs',P/'inputs/MATERIALIZED.sha256',('MATERIALIZED.sha256',))}
assert facts['bootstrap']['count']==8700 and facts['bootstrap']['bytes']==359332583
assert facts['prior_output']['count']==68 and facts['prior_inputs']['count']==7371
assert sha(P/'inputs/source17/CANDIDATE.sha256')=='56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985'
assert sha(P/'inputs/BOUND_INPUTS.json')=='567f57ac135d0c766f95dfbc53b5dfedcd9d4eb15993d78ab896d4bead936278'

def cp_tree(src,dst):
    assert not dst.exists(),dst
    shutil.copytree(src,dst,symlinks=False,copy_function=shutil.copyfile)
    for p in dst.rglob('*'):
        assert not p.is_symlink(),p
        if p.is_file(): p.chmod(0o444)

cp_tree(P/'inputs',O/'inputs')
cp_tree(P/'output',O/'predecessor')
cp_tree(P/'output/formal',O/'formal')
cp_tree(P/'run',O/'evidence/prior_run')
cp_tree(B/'context',O/'context')
cp_tree(P/'run/replay_001/build/toolchain',O/'library_provenance')
for name in ('AuditExports.lean','AuditTerms.lean'):
    source=P/'run/replay_001/source'/name
    assert sha(source)==sha(P/'current_audits'/name)==json.loads((P/'run/replay_001/receipt.json').read_text())['source_before'][name]
    dest=O/'formal'/name
    shutil.copyfile(source,dest); dest.chmod(0o444)
assert sha(O/'predecessor/OUTPUTS.sha256')==facts['prior_output']['sha256']
assert sha(O/'inputs/MATERIALIZED.sha256')==facts['prior_inputs']['sha256']
facts['audit_module_pins']={n:sha(O/'formal'/n) for n in ('AuditExports.lean','AuditTerms.lean')}
facts['copy_complete_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat()
(W/'run/INTAKE.json').write_text(json.dumps(facts,indent=2,sort_keys=True)+'\n')
print(json.dumps(facts,indent=2,sort_keys=True),flush=True)
