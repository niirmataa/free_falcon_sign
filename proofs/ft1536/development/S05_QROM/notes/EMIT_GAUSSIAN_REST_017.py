#!/usr/bin/env python3
"""Format a smaller continuation after retained64-block batch030 hit memory cap."""
from pathlib import Path
import json,hashlib,sys
out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=False)
old=json.loads((out.parent/'witness_sources001/MANIFEST.json').read_text())['modules'][:30]
for r in old:r['label']=f"witness{int(r['module'].rsplit('_',1)[1]):03}001";r['theorem']='batch_'+str(r['start']//64)
records=[]
def tree(start,count,leaves):
 if count==1:return leaves[start]
 a=count//2
 return f'(GaussianChunks017.append GaussianChunks017.small {start} {a} {count-a} {tree(start,a,leaves)} {tree(start+a,count-a,leaves)})'
for j,start in enumerate(range(1920,7681,16)):
 n=min(16,7681-start);name=f'GaussianRest017_{j:03}'
 lines=['import GaussianChunks017','set_option maxRecDepth 32768','set_option maxHeartbeats 2000000',
  'set_option exponentiation.threshold 100000','namespace FT1536.S05.GaussianWitness017']
 leaves={}
 for k in range(start,start+n):
  lines.append(f'theorem rowblock_{k} : GaussianChunks017.small {k}=true := by decide +kernel')
  leaves[k]=f'(GaussianChunks017.single GaussianChunks017.small {k} rowblock_{k})'
 thm=f'rest_{j}'
 lines += [f'theorem {thm} : GaussianChunks017.All GaussianChunks017.small {start} {n} :=\n  '+tree(start,n,leaves),
  f'#print axioms {thm}','end FT1536.S05.GaussianWitness017']
 p=out/(name+'.lean');p.write_text('\n'.join(lines)+'\n')
 records.append(dict(module=name,start=start,count=n,sha256=hashlib.sha256(p.read_bytes()).hexdigest(),label=f'rest{j:03}001',theorem=thm))
selected=old+records
def combine(a,b):
 if b-a==1:return selected[a]['theorem']
 m=(a+b)//2;base=selected[a]['start'];n=sum(r['count'] for r in selected[a:m]);k=sum(r['count'] for r in selected[m:b])
 return f'(GaussianChunks017.append GaussianChunks017.small {base} {n} {k} {combine(a,m)} {combine(m,b)})'
p=out/'GaussianWitnessAll017.lean'
p.write_text('\n'.join('import '+r['module'] for r in selected)+
 '\nset_option maxRecDepth 32768\nnamespace FT1536.S05.GaussianWitness017\n'+
 'theorem all_small : GaussianChunks017.All GaussianChunks017.small 0 7681 :=\n  '+combine(0,len(selected))+
 '\ntheorem all_rows (i : Nat) (hi : i < 61441) : GaussianCheck017.row i=true :=\n  GaussianChunks017.rows_of_small all_small i hi\n'+
 '#print axioms all_small\n#print axioms all_rows\nend FT1536.S05.GaussianWitness017\n')
(out/'SELECTED.json').write_text(json.dumps({'retained_original_batches':30,'continuation':records,'selected':selected,
 'aggregate':{'module':'GaussianWitnessAll017','sha256':hashlib.sha256(p.read_bytes()).hexdigest()},
 'small_blocks':7681,'rows':61441,'reason':'witness030001 exhausted unchanged4GiB compiler memory; retain it and all successful original batches; smaller independent proof modules'},indent=2)+'\n')
print(json.dumps({'retained':len(old),'new_batches':len(records),'all_selected':len(selected)}))
