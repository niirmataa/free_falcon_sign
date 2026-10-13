#!/usr/bin/env python3
"""Sequential low-memory fallback: same pinned dependencies,4GiB Lean and8GiB AS. Historical builds remain immutable."""
from pathlib import Path
import hashlib,json,shutil,sys,types,resource,re
S=Path(__file__).resolve().parent.parent;ROOT=S/'.build/pair_machine_020';world=sys.argv.pop(1);assert re.fullmatch(r'[a-z][a-z0-9_]*',world);B=ROOT/world;LIB=B/'lib'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
P=S/'notes/BUILD_KEY_SUPPORT_011.py'
expected=dict(x.split('  ',1)[::-1] for x in (S/'notes/KEY_SUPPORT_011_OUTPUTS.sha256').read_text().splitlines())['notes/BUILD_KEY_SUPPORT_011.py'];assert sha(P)==expected
h=types.ModuleType('helper');h.__file__=str(P)
code=P.read_text().split("\nif sys.argv[1]=='prepare':")[0].replace("'-s8192'","'-s65536'")
code=code.replace('timeout=120','timeout=600').replace("'wall_seconds':120","'wall_seconds':600")
assert code.count("'-M4096'")==1 and code.count('8*1024**3')==2
code=code.replace("'memory_GiB':8","'memory_GiB':8")
exec(compile(code,str(P),'exec'),h.__dict__);h.BUILD=B;h.BASE=B/'no_fallback_dependency_root'
libs=json.loads((S/'notes/BOX_MOMENT_015_INPUTS.json').read_text())['library_roots']
if sys.argv[1]=='install':
 name,label=sys.argv[2:4];d=B/'runs'/label;r=json.loads((d/'receipt.json').read_text());src=Path(r['command'][-1]);a=Path(r['artifact'])
 assert r['exit_code']==r['warning_count']==r['error_count']==0
 assert sha(src)==r['source_sha256'] and sha(a)==r['artifact_sha256']
 dst=LIB/(name.replace('.','/')+'.olean');assert not dst.exists();dst.parent.mkdir(parents=True,exist_ok=True)
 for p in a.parent.glob(a.name+'*'):shutil.copyfile(p,dst.parent/p.name)
 pf=LIB/'PINS.json';shutil.copyfile(pf,d/'PINS_before.json');rs=json.loads(pf.read_text());rs.append({'module':name,'source':str(src),'source_sha256':sha(src),'artifact':str(dst),'artifact_sha256':sha(dst),'receipt':str(d/'receipt.json')})
 tmp=pf.with_suffix('.next');assert not tmp.exists();tmp.write_text(json.dumps(rs,indent=2)+'\n');tmp.replace(pf);sys.exit(0)
available=int(next(x.split()[1] for x in Path('/proc/meminfo').read_text().splitlines() if x.startswith('MemAvailable:')))
assert available>=5*1024**2, 'need5GiB available before a4GiB build'
name,label=sys.argv[1:3];src=S/'formal'/(name+'.lean');d=B/'runs'/label;wrapper=Path(__file__).read_bytes()
ok=h.compile_one(src,d,name,d/'lib',libs,LIB)
p=d/'receipt.json';r=json.loads(p.read_text());r['wrapper_sha256_at_launch']=hashlib.sha256(wrapper).hexdigest();r['Lean_M_MiB']=4096;r['preflight_MemAvailable_KiB']=available;r['compiler_peak_rss_KiB']=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss
(d/'wrapper_at_launch.py').write_bytes(wrapper);p.write_text(json.dumps(r,indent=2)+'\n')
sys.exit(0 if ok else 1)
