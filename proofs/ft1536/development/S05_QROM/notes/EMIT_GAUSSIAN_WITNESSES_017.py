#!/usr/bin/env python3
"""Format finite kernel proofs; Python performs no mathematical acceptance test."""
from pathlib import Path
import hashlib, json, sys

out = Path(sys.argv[1])
out.mkdir(parents=True, exist_ok=False)
records = []

def tree(start, count, leaves):
    if count == 1:
        return leaves[start]
    left = count // 2
    return ('(GaussianChunks017.append GaussianChunks017.small '
            f'{start} {left} {count-left} '
            f'{tree(start,left,leaves)} {tree(start+left,count-left,leaves)})')

for batch, start in enumerate(range(0, 7681, 64)):
    count = min(64, 7681-start)
    name = f'GaussianWitness017_{batch:03}'
    lines = ['import GaussianChunks017', 'set_option maxRecDepth 32768',
             'set_option maxHeartbeats 2000000',
             'set_option exponentiation.threshold 100000',
             'namespace FT1536.S05.GaussianWitness017']
    leaves = {}
    for j in range(start, start+count):
        lines.append(f'theorem rowblock_{j} : GaussianChunks017.small {j}=true := by decide +kernel')
        leaves[j] = f'(GaussianChunks017.single GaussianChunks017.small {j} rowblock_{j})'
    lines.append(f'theorem batch_{batch} : GaussianChunks017.All GaussianChunks017.small {start} {count} :=\n  '+tree(start,count,leaves))
    lines.extend([f'#print axioms batch_{batch}', 'end FT1536.S05.GaussianWitness017'])
    p=out/(name+'.lean');p.write_text('\n'.join(lines)+'\n')
    records.append(dict(module=name,start=start,count=count,sha256=hashlib.sha256(p.read_bytes()).hexdigest()))

def batches(start, end):
    if end-start==1:
        return f'batch_{start}'
    mid=(start+end)//2
    base=records[start]['start']
    a=sum(r['count'] for r in records[start:mid])
    b=sum(r['count'] for r in records[mid:end])
    return f'(GaussianChunks017.append GaussianChunks017.small {base} {a} {b} {batches(start,mid)} {batches(mid,end)})'

p=out/'GaussianWitness017.lean'
p.write_text('\n'.join('import '+r['module'] for r in records)+
  '\nnamespace FT1536.S05.GaussianWitness017\n'+
  'theorem all_small : GaussianChunks017.All GaussianChunks017.small 0 7681 :=\n  '+batches(0,len(records))+
  '\ntheorem all_rows (i : Nat) (hi : i < 61441) : GaussianCheck017.row i=true :=\n  GaussianChunks017.rows_of_small all_small i hi\n'+
  '#print axioms all_small\n#print axioms all_rows\nend FT1536.S05.GaussianWitness017\n')
(out/'MANIFEST.json').write_text(json.dumps(dict(modules=records,aggregate_sha256=hashlib.sha256(p.read_bytes()).hexdigest()),indent=2)+'\n')
print(json.dumps(dict(batches=len(records),small_blocks=7681,rows=61441)))
