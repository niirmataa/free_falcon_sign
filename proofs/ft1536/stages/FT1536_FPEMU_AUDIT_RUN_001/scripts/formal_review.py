"""Rebuild only supplied historical Lean modules, preserving exact bytes/pins."""
import re
from common import W, B, dump, sha, job

dest=W/'formal'
dest.mkdir(exist_ok=False)
modules={}
for stage in ('ZERO','ROOT','NODE3'):
    for p in sorted((B/stage/'formal').glob('*.lean')):
        if p.stem in modules:
            assert sha(p)==sha(modules[p.stem])
        else: modules[p.stem]=p
for name,p in modules.items():
    (dest/(name+'.lean')).write_bytes(p.read_bytes())
done=[]; receipts=[]; warnings=[]
pending=set(modules)
lean='/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean'
while pending:
    ready=[]
    for name in sorted(pending):
        imports=re.findall(r'^import (\w+)',modules[name].read_text(),re.M)
        assert all(i in modules or i in ('Std','Lean','Init') for i in imports),(name,imports)
        if not any(i in pending for i in imports):ready.append(name)
    assert ready
    for name in ready:
        p=job('lean-'+name,[lean,'-j1','-M2048','-o','formal/'+name+'.olean','formal/'+name+'.lean'],timeout=180)
        text=p.stdout.decode()+p.stderr.decode()
        if 'warning:' in text: warnings.append(dict(module=name,source_sha256=sha(modules[name]),log=text))
        assert 'sorry' not in text and 'error:' not in text
        receipts.append(dict(module=name,source=str(modules[name].relative_to(B)),sha256=sha(modules[name]),
                             stdout_sha256=__import__('hashlib').sha256(p.stdout).hexdigest(),
                             stderr_sha256=__import__('hashlib').sha256(p.stderr).hexdigest()))
        done.append(name);pending.remove(name)
dump('artifacts/formal_rebuild.json',dict(status='PASS_HISTORICAL_PROJECTION',modules=len(done),
    receipts=receipts,historical_warnings=warnings,new_lean_files=0,
    whole_predecessor_replay=False,scope='Types/axioms logs come from supplied historical Audit/Types modules; no full numerical C theorem is asserted.'))
print('PASS:',len(done),'historical Lean modules rebuilt;',len(warnings),'modules with preserved historical warnings; no new Lean')
