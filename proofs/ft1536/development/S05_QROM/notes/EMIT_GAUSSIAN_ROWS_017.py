#!/usr/bin/env python3
"""Retain the proved15360-row prefix; certify every remaining row separately."""
from pathlib import Path
import json,hashlib,sys
out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=False)
old=json.loads((out.parent/'witness_sources001/MANIFEST.json').read_text())['modules'][:30]
for r in old:r['label']=f"witness{int(r['module'].rsplit('_',1)[1]):03}001";r['theorem']='batch_'+str(r['start']//64)
def tree(f,start,count,leaves):
 if count==1:return leaves[start]
 a=count//2
 return f'(GaussianChunks017.append {f} {start} {a} {count-a} {tree(f,start,a,leaves)} {tree(f,start+a,count-a,leaves)})'
rows=[]
for j,start in enumerate(range(15360,61441,256)):
 n=min(256,61441-start);name=f'GaussianRows017_{j:03}'
 lines=['import GaussianChunks017','set_option maxRecDepth 32768','set_option maxHeartbeats 2000000',
  'set_option exponentiation.threshold 100000','namespace FT1536.S05.GaussianWitness017']
 leaves={}
 for k in range(start,start+n):
  lines.append(f'theorem row_{k} : GaussianCheck017.row {k}=true := by decide +kernel')
  leaves[k]=f'(GaussianChunks017.single GaussianCheck017.row {k} row_{k})'
 thm=f'rows_batch_{j}'
 lines += [f'theorem {thm} : GaussianChunks017.All GaussianCheck017.row {start} {n} :=\n  '+tree('GaussianCheck017.row',start,n,leaves),
  f'#print axioms {thm}','end FT1536.S05.GaussianWitness017']
 p=out/(name+'.lean');p.write_text('\n'.join(lines)+'\n')
 rows.append(dict(module=name,start=start,count=n,sha256=hashlib.sha256(p.read_bytes()).hexdigest(),label=f'rows{j:03}001',theorem=thm))
def combine(items,a,b,f):
 if b-a==1:return items[a]['theorem']
 m=(a+b)//2;base=items[a]['start'];n=sum(r['count'] for r in items[a:m]);k=sum(r['count'] for r in items[m:b])
 return f'(GaussianChunks017.append {f} {base} {n} {k} {combine(items,a,m,f)} {combine(items,m,b,f)})'
p=out/'GaussianWitnessRowsAll017.lean'
p.write_text('import GaussianPrefix017\n'+'\n'.join('import '+r['module'] for r in old+rows)+
 '\nset_option maxRecDepth 32768\nnamespace FT1536.S05.GaussianWitness017\n'+
 'theorem prefix_small : GaussianChunks017.All GaussianChunks017.small 0 1920 :=\n  '+combine(old,0,len(old),'GaussianChunks017.small')+
 '\ntheorem prefix_rows : GaussianChunks017.All GaussianCheck017.row 0 15360 :=\n  GaussianPrefix017.rows_of_prefix 1920 (by decide) prefix_small\n'+
 'theorem remaining_rows : GaussianChunks017.All GaussianCheck017.row 15360 46081 :=\n  '+combine(rows,0,len(rows),'GaussianCheck017.row')+
 '\ntheorem all_range : GaussianChunks017.All GaussianCheck017.row 0 61441 :=\n  GaussianChunks017.append GaussianCheck017.row 0 15360 46081 prefix_rows remaining_rows\n'+
 'theorem all_rows (i : Nat) (hi : i < 61441) : GaussianCheck017.row i=true :=\n  by simpa only [Nat.zero_add] using all_range i hi\n'+
 ''.join('#print axioms '+n+'\n' for n in ['prefix_small','prefix_rows','remaining_rows','all_range','all_rows'])+
 'end FT1536.S05.GaussianWitness017\n')
(out/'SELECTED.json').write_text(json.dumps({'old_prefix':old,'row_modules':rows,'selected':old+rows,
 'aggregate':{'module':'GaussianWitnessRowsAll017','sha256':hashlib.sha256(p.read_bytes()).hexdigest()},
 'total_rows':61441,'prefix_rows':15360,'remaining_rows':46081,
 'reason':'Some eight-row Bool reductions hit memory even as singleton small-block checks; individual-row proofs succeeded for128 central rows with unchanged limits. All earlier sources and attempts are preserved.'},indent=2)+'\n')
print(json.dumps({'prefix_batches':len(old),'new_row_batches':len(rows),'remaining_rows':46081}))
