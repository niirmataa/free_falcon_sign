#!/usr/bin/env python3
"""P02 portable organizational gate: check pinned git-tree bytes and build cache, no git process."""
from pathlib import Path
import hashlib,json,os,subprocess,datetime

IN=Path(os.environ['P02_INPUTS'])
P=Path(os.environ['P02_PACKAGE'])
DEST=Path(os.environ['P02_DEST'])/'build/toolchain'
DEST.mkdir()
REPO=IN.parents[5]
P01=REPO/'proofs/ft1536/work/B20_001/P01'
LEAN=Path('/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean')
H=P/'library_provenance'
old=json.loads((H/'TOOLCHAIN_GATE.json').read_text())
pins=json.loads((IN/'task/TOOLCHAIN_PINS.json').read_text())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()

def direct_head(root):
    dot=root/'.git'
    if dot.is_file():
        link=dot.read_text().strip()
        assert link.startswith('gitdir: ')
        dot=(root/link[8:]).resolve()
    h=(dot/'HEAD').read_text().strip()
    if not h.startswith('ref: '):return h
    ref=h[5:]; f=dot/ref
    if f.is_file():return f.read_text().strip()
    for line in (dot/'packed-refs').read_text().splitlines():
        if not line.startswith(('#','^')):
            ident,key=line.split(' ',1)
            if key==ref:return ident
    raise AssertionError(('missing ref',dot,ref))

assert old['pass'] and old['lean_binary_sha256']==sha(LEAN)
version=subprocess.run([str(LEAN),'--version'],check=True,capture_output=True)
assert b'4.34.0' in version.stdout
summary=[]
for row in old['roots']:
    name=row['name']
    root=P01/'bootstrap/mathlib4' if name=='mathlib' else P01/'run/.lake/packages'/name
    expected=pins['mathlib']['commit'] if name=='mathlib' else next(p['rev'] for p in pins['mathlib']['packages'] if p['name']==name)
    assert row['revision']==direct_head(root)==expected,name
    tree=H/(name+'.git-tree'); src_manifest=H/(name+'.source.sha256');build_manifest=H/(name+'.build.sha256')
    assert sha(src_manifest)==row['source_manifest_sha256'] and sha(build_manifest)==row['build_manifest_sha256']
    assert len(tree.read_bytes().split(b'\0'))-1==row['source_files']
    srcrows={rel:h for h,rel in (l.split('  ',1) for l in src_manifest.read_text().splitlines())}
    assert len(srcrows)==row['source_files']
    for entry in tree.read_bytes().split(b'\0'):
        if not entry:continue
        meta,rawname=entry.split(b'\t',1); mode,typ,obj=meta.split()
        rel=rawname.decode();path=root/rel
        assert typ==b'blob' and rel in srcrows
        if mode==b'120000':
            assert path.is_symlink();raw=os.readlink(path).encode()
        else:
            assert path.is_file() and not path.is_symlink();raw=path.read_bytes()
        assert hashlib.sha1(b'blob '+str(len(raw)).encode()+b'\0'+raw).hexdigest()==obj.decode(),(name,rel)
        assert hashlib.sha256(raw).hexdigest()==srcrows[rel],(name,rel)
    buildrows=build_manifest.read_text().splitlines()
    assert len(buildrows)==row['build_files']
    for item in buildrows:
        h,rel=item.split('  ',1)
        p=root/rel
        assert p.is_file() and not p.is_symlink() and sha(p)==h,(name,rel)
    summary.append({'name':name,'revision':expected,'source_count':len(srcrows),'cached_artifacts':len(buildrows),
                    'source_manifest_sha256':sha(src_manifest),'build_manifest_sha256':sha(build_manifest)})
    print('PINNED_LIBRARY_PASS',name,len(srcrows),len(buildrows),flush=True)
result={'schema':'P02_PORTABLE_TOOLCHAIN_GATE_V2','pass':True,'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
        'lean_sha256':sha(LEAN),'lean_version':version.stdout.decode().strip(),'prior_gate_sha256':sha(H/'TOOLCHAIN_GATE.json'),
        'roots':summary,'git_processes':0,'source_provenance':'prior git-tree + source SHA256 + direct read-only HEAD',
        'cache_scope':'reuse pinned external P01 build, not fresh library proof'}
(DEST/'PORTABLE_GATE.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
print('PORTABLE_TOOLCHAIN_GATE_PASS',flush=True)
