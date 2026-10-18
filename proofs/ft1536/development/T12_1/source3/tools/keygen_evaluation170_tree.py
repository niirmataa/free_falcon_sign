#!/usr/bin/env python3
"""Serialize pinned candidate values as balanced finite-map data; no mathematical inference."""
from pathlib import Path
import hashlib,json
ROOT=Path(__file__).resolve().parents[1]
source=ROOT/'.build/jobs/keygen_publicforward159_150/EVALUATION170_DATA.json'
expected='a567c6a810d849f29de88b17ac4376a4686167558da376b37c7210c77605a129'
assert hashlib.sha256(source.read_bytes()).hexdigest()==expected
payload=json.loads(source.read_text())
def tree(values):
    root=[None,None,None]
    for index,value in enumerate(values):
        cursor=root;key=index
        while key:
            edge=1+(key%2)
            if cursor[edge] is None:cursor[edge]=[None,None,None]
            cursor=cursor[edge];key//=2
        assert cursor[0] is None;cursor[0]=value
    for index,expected_value in enumerate(values):
        cursor=root;key=index
        while key:cursor=cursor[1+key%2];key//=2
        assert cursor[0]==expected_value
    def emit(node):
        if node is None:return '.empty'
        value='none' if node[0] is None else '(some '+str(node[0])+')'
        return '(.node '+value+' '+emit(node[1])+' '+emit(node[2])+')'
    return emit(root)
rows=[]
for name,values in [('roots',payload['roots']),*payload['arrays'].items()]:
    assert all(type(v) is int for v in values)
    rows.append('def '+name+' : PublicTreeEvaluation170.Vector := ⟨'+str(len(values))+','+tree(values)+'⟩\n')
text='import Source3.PublicTreeEvaluation170\n\nnamespace FT1536.Source3.GeneratedPublicTree170\n'+''.join(rows)+'\nend FT1536.Source3.GeneratedPublicTree170\n'
build=ROOT/'.build/evaluation170'
paths=[build/'GeneratedPublicTree170.lean',ROOT/'formal/Source3/GeneratedPublicTree170.lean']
for path in paths:
    if path.exists():assert path.read_text()==text
    else:path.write_text(text)
record={'source':{'path':str(source),'sha256':expected},'generator':{'path':str(Path(__file__).resolve()),'sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()},
 'generated':[{'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in paths],
 'status':'DATA_SERIALIZATION_ROUNDTRIP_CHECKED; KERNEL_PROOFS_PENDING'}
p=build/'GENERATED_TREE_INPUTS.json';assert not p.exists();p.write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps({'arrays':len(rows),'source_sha256':record['generated'][0]['sha256']}))
