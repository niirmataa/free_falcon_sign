#!/usr/bin/env python3
"""Metadata and source closure, no mathematical computation."""
import hashlib
import json
from pathlib import Path
import re
import shutil

W = Path(__file__).resolve().parent.parent
O = W/'output'
MODULES = ['Basic','MathSign','Geometry','Divergence','EventTransfer','Adaptive',
           'RetryDivergence','ROM','Collision','PublicSimulation','PublicCode','Relation',
           'Model','TraceBound','Certificate']
def sha(p):
    h=hashlib.sha256()
    with p.open('rb') as f:
        for b in iter(lambda:f.read(1048576),b''): h.update(b)
    return h.hexdigest()

def main():
    formal = O/'formal'
    exports=[]
    for mod in MODULES:
        p=formal/'FT1536'/(mod+'.lean')
        ns=[]
        for n,line in enumerate(p.read_text().splitlines(),1):
            if m:=re.match(r'^namespace\s+(\S+)',line): ns.append(m[1])
            if re.match(r'^end(?:\s|$)',line) and ns: ns.pop()
            if m:=re.match(r'^theorem\s+(\w+)',line):
                exports.append(dict(name='.'.join(ns+[m[1]]),source=str(p.relative_to(O)),line=n,
                    status='PROVED_KERNEL',scope_module=mod))
    (O/'FORMAL_EXPORTS.json').write_text(json.dumps(dict(schema='T12_1_EXPORTS_V1',
        overall_status='PARTIAL_PROOF',exports=exports,
        missing_main_export='Reduction.euf_cma_to_mt_isis'),indent=2)+'\n')
    audit='\n'.join('import FT1536.'+m for m in MODULES)+'\n\n'
    audit+='set_option format.width 120\nset_option pp.universes true\n'
    for e in exports:
        audit+='\n#check @'+e['name']+'\n#print axioms '+e['name']+'\n'
    (formal/'Audit.lean').write_text(audit)
    (O/'BUILD.json').write_text(json.dumps(dict(modules=['FT1536.'+m for m in MODULES]+['Audit'],
        lean_flags=['-j1','-M6144'],wall_s=1800,address_space_bytes=12884901888,
        normal_rss_budget_bytes=8589934592,network='unshare-net'),indent=2)+'\n')
    shutil.copytree(W/'inputs/bootstrap',O/'inputs/bootstrap',dirs_exist_ok=True)
    lines=[]
    for p in sorted((O/'inputs').rglob('*')):
        if p.is_file(): lines.append(f'{sha(p)}  {p.relative_to(O)}')
    (O/'INPUTS.sha256').write_text('\n'.join(lines)+'\n')
    print('Export declarations:',len(exports))

if __name__=='__main__': main()
