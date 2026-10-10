# sage GENERATE_TABLES_016.sage TABLES OUTDIR
# Reproducible public integer literals. Hash equality is provenance, not analysis.
from pathlib import Path
import json,sys,hashlib
src=Path(sys.argv[1]);out=Path(sys.argv[2]);out.mkdir(parents=True,exist_ok=False)
t=json.loads(src.read_text());w=[ZZ(x) for x in t['weights']];v=[ZZ(x) for x in t['acceptance_thresholds']]
assert len(w)==30721 and len(v)==61441 and min(w)>0 and min(v)>=0 and max(v)<=2^256
cdf=[];s=ZZ(0)
for x in w:s+=x;cdf.append(s)
chunks=[];names={}
for label,values in [('cdf',cdf),('threshold',v)]:
 names[label]=[]
 for j,start in enumerate(range(0,len(values),256)):
  name=label+'_'+str(j).zfill(3);names[label].append(name)
  chunks.append('def '+name+' : Array Nat := #['+','.join(str(x) for x in values[start:start+256])+']\n')
modules=[]
for j,start in enumerate(range(0,len(chunks),32)):
 name='PublicTables016_'+str(j).zfill(2);p=out/(name+'.lean')
 p.write_text('/- Generated public table literals; regenerate with GENERATE_TABLES_016.sage. -/\nnamespace FT1536.S05.TableData016\n'+''.join(chunks[start:start+32])+'end FT1536.S05.TableData016\n')
 modules.append({'module':name,'source':str(p.resolve()),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size})
index=out/'PublicTables016.lean'
index.write_text(''.join('import '+r['module']+'\n' for r in modules)+'namespace FT1536.S05.TableData016\n'+
 'def cdfChunks : Array (Array Nat) := #['+','.join(names['cdf'])+']\n'+
 'def thresholdChunks : Array (Array Nat) := #['+','.join(names['threshold'])+']\n'+
 'def cdf (i : Nat) : Nat := ((cdfChunks.getD (i/256) #[]).getD (i%256) 0)\n'+
 'def threshold (i : Nat) : Nat := ((thresholdChunks.getD (i/256) #[]).getD (i%256) 0)\n'+
 'end FT1536.S05.TableData016\n')
modules.append({'module':'PublicTables016','source':str(index.resolve()),'sha256':hashlib.sha256(index.read_bytes()).hexdigest(),'bytes':index.stat().st_size})
(out/'MANIFEST.json').write_text(json.dumps({'input_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'modules':modules,'cdf_entries':len(cdf),'threshold_entries':len(v),'total':str(s)},indent=2)+'\n')
print('Generated',len(modules),'modules; exact public integer literals')
