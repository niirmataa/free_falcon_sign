#!/usr/bin/env python3
"""Reviewer-side exact-set and hash audit; never modifies pinned inputs."""
from pathlib import Path
import hashlib
import json

W = Path(__file__).resolve().parents[1]
I = W / 'inputs'
S = I / 'subject'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()

def verify(base, manifest, excluded=()):
    rows = {}
    for line in manifest.read_text().splitlines():
        h, rel = line.split('  ', 1)
        p = Path(rel)
        assert not p.is_absolute() and '..' not in p.parts and rel not in rows
        f = base / p
        assert f.is_file() and not f.is_symlink() and f.resolve().is_relative_to(base.resolve()), rel
        assert sha(f) == h, rel
        rows[rel] = h
    allfiles = {p.relative_to(base).as_posix() for p in base.rglob('*') if p.is_file()}
    assert not any(p.is_symlink() for p in base.rglob('*'))
    assert allfiles - set(excluded) == set(rows), (len(allfiles), len(rows), sorted(allfiles-set(rows))[:10])
    return {'count': len(rows), 'bytes': sum((base / r).stat().st_size for r in rows),
            'manifest_sha256': sha(manifest)}

result = {'review_bundle': verify(I, I / 'MANIFEST.sha256', ('MANIFEST.sha256','ORIGINS.json')),
          'subject': verify(S, S / 'OUTPUTS.sha256', ('OUTPUTS.sha256',)),
          'author_inputs': verify(S, S / 'INPUTS.sha256', tuple(
              p.relative_to(S).as_posix() for p in S.rglob('*') if p.is_file()
              and not p.is_relative_to(S/'inputs')))}
origins = json.loads((I/'ORIGINS.json').read_text())['files']
manifest_rows = {rel:h for h,rel in (line.split('  ',1) for line in (I/'MANIFEST.sha256').read_text().splitlines())}
assert len(origins)==len(manifest_rows)
assert {x['copy'] for x in origins}==set(manifest_rows)
assert all(x['sha256']==manifest_rows[x['copy']] and x['bytes']==(I/x['copy']).stat().st_size for x in origins)
result['review_origins_checked']=len(origins)
assert result['review_bundle']['count'] == 1946
assert result['review_bundle']['bytes'] == 76241324
assert result['subject']['count'] == 1939
assert result['subject']['bytes'] == 75969266
assert result['author_inputs']['count'] == 1437
assert result['subject']['manifest_sha256'] == '12df61056ddada2f79c1b94b3b17e8f326db2b3a2cbe53d1694754d79d7958cc'
assert sha(S/'REPORT.md') == 'b2e8c9af003edee089b49156541e631e3ab8bb01c93f9cad521edf7b66a59dfc'
boot = S/'inputs/bootstrap'
result['bootstrap'] = verify(boot, boot/'MANIFEST.sha256', ('MANIFEST.sha256','ORIGINS.json'))
assert result['bootstrap']['count'] == 1396 and result['bootstrap']['bytes'] == 32721541
assert result['bootstrap']['manifest_sha256'] == 'a47dc77e48fb521b17de30115be67dca9e97221063e6b001af5cb4db4bc63f9f'
old = boot/'T03/inputs/bootstrap'
result['source17'] = verify(old/'source', old/'CANDIDATE.sha256')
assert result['source17']['count'] == 17
assert result['source17']['manifest_sha256'] == '56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985'
spans = json.loads((S/'artifacts/SOURCE_SPANS.json').read_text())
for key, v in spans.items():
    p = S/v['path']
    assert p.is_file() and sha(p) == v['sha256'], key
    first,last = v['lines']
    assert hashlib.sha256(b''.join(p.read_bytes().splitlines(keepends=True)[first-1:last])).hexdigest() == v['slice_sha256'], key
result['source_spans_checked'] = len(spans)
(W/'output/INPUT_AUDIT.json').write_text(json.dumps(result, indent=2, sort_keys=True)+'\n')
print(json.dumps(result, indent=2))
