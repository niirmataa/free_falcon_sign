#!/usr/bin/env python3
"""Serialize the exact Sage certificate candidate; no mathematical arithmetic."""
from pathlib import Path
import hashlib,json,sys
ROOT=Path(__file__).resolve().parents[1]
source=ROOT/'.build/jobs'/sys.argv[1]/'EVALUATION170_DATA.json'
expected=sys.argv[2]
assert hashlib.sha256(source.read_bytes()).hexdigest()==expected
payload=json.loads(source.read_text())
assert payload['modulus']==18433
arrays=payload['arrays']
assert list(arrays)==['input','first']+['stage'+str(k) for k in range(1,9)]+['output']
rows=[]
for name,values in [('roots',payload['roots']),*arrays.items()]:
    assert isinstance(values,list) and all(type(x) is int for x in values)
    rows.append('def '+name+' : Array Nat := #['+','.join(map(str,values))+']\n')
text='import Source3.PublicEvaluationCertificate170\n\nnamespace FT1536.Source3.GeneratedPublicEvaluation170\n'+''.join(rows)+'\nend FT1536.Source3.GeneratedPublicEvaluation170\n'
build=ROOT/'.build/evaluation170';build.mkdir(exist_ok=True)
archive=build/'GeneratedPublicEvaluation170.lean'
target=ROOT/'formal/Source3/GeneratedPublicEvaluation170.lean'
for path in [archive,target]:
    if path.exists():assert path.read_text()==text
    else:path.write_text(text)
record={'source':{'path':str(source),'sha256':expected},'generator':{'path':str(Path(__file__).resolve()),'sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()},
 'generated':[{'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in [archive,target]],
 'status':'SERIALIZED_CERTIFICATE_CANDIDATE; KERNEL_CHECKS_PENDING'}
out=build/'GENERATED_INPUTS.json';assert not out.exists();out.write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps({'module':'GeneratedPublicEvaluation170','source_sha256':record['generated'][0]['sha256'],'arrays':len(rows)}))
