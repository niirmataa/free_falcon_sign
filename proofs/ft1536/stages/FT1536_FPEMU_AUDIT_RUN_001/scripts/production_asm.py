"""Compile original production translation units, never execute KeyGen/Sign."""
from common import W, flags, job, sha, dump
import re

receipts=[]
for name in ('fpr-emulated','falcon-sign','falcon-fft','falcon-keygen'):
    asm='artifacts/'+name+'.s'
    obj='bin/static/'+name+'.o'
    job('original-asm-'+name,['/usr/bin/gcc',*flags(),'-S','-fverbose-asm',
        'inputs/bootstrap/source/'+name+'.c','-o',asm])
    job('original-object-'+name,['/usr/bin/gcc',*flags(),'-c',
        'inputs/bootstrap/source/'+name+'.c','-o',obj])
    receipts.append(dict(unit=name,object_sha256=sha(W/obj),assembly_sha256=sha(W/asm)))
text=(W/'artifacts/falcon-sign.s').read_text().splitlines()
hits=[]
for i,ln in enumerate(text):
    if 'fpr_floor:' in ln or re.search(r'\b(sub|cmp)l?\s+\$1022',ln):
        hits.append(dict(line=i+1,context='\n'.join(text[max(0,i-12):i+30])))
dump('artifacts/production_asm.json',dict(receipts=receipts,sign_floor_excerpts=hits))
print('PASS: 4 original translation units compiled; sign floor excerpts:',len(hits))
