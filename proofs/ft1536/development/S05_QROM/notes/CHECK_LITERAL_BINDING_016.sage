# sage CHECK_LITERAL_BINDING_016.sage TABLES GENERATED OUT
# Independent lexical readback of every generated integer; finite data binding only.
from pathlib import Path
import json,re,sys,hashlib
src=Path(sys.argv[1]);gen=Path(sys.argv[2]);out=Path(sys.argv[3]);out.mkdir(parents=True,exist_ok=True)
assert not (out/'RESULT.json').exists()
t=json.loads(src.read_text());weights=[ZZ(x) for x in t['weights']];thresholds=[ZZ(x) for x in t['acceptance_thresholds']]
expected=[];running=ZZ(0)
for w in weights:running+=w;expected.append(running)
manifest=json.loads((gen/'MANIFEST.json').read_text());chunks={};read=0
for row in manifest['modules']:
 p=gen/(row['module']+'.lean');assert hashlib.sha256(p.read_bytes()).hexdigest()==row['sha256']
 for name,body in re.findall(r'def ((?:cdf|threshold)_[0-9]+) : Array Nat := #\[([0-9,]+)\]',p.read_text()):
  assert name not in chunks;chunks[name]=[ZZ(x) for x in body.split(',')]
for label,values in [('cdf',expected),('threshold',thresholds)]:
 for i,value in enumerate(values):
  assert chunks[label+'_'+str(i//256).zfill(3)][i%256]==value;read+=1
assert read==92162
index=(gen/'PublicTables016.lean').read_text()
for label,total in [('cdf',121),('threshold',241)]:
 match=re.search(r'def '+label+r'Chunks : Array \(Array Nat\) := #\[([^]]+)\]',index)
 assert match and match.group(1).split(',')==[label+'_'+str(i).zfill(3) for i in range(total)]
res={'status':'EXACT_EXHAUSTIVE_LITERAL_BINDING','integer_entries':int(read),'cdf_entries':len(expected),'threshold_entries':len(thresholds),
 'chunks':len(chunks),'table_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),
 'meaning':'Every generated literal and chunk index agrees with pinned public tables; not a Gaussian/probability/source-C theorem.'}
(out/'RESULT.json').write_text(json.dumps(res,indent=2,default=int)+'\n');print('PASS:',read,'public integer entries, all chunks and index order',flush=True)
