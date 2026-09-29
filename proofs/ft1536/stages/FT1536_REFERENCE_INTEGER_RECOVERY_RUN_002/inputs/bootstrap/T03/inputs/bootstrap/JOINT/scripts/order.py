"""Structural recursion directly bound to the literal three source functions."""
import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';rows=[]
def inner(k,off,path):
 if k==0:
  for slot,pc in [('paired',1641),('stored',1645)]:rows.append(dict(index=len(rows),path=path,leaf_word=off,width_class=slot,call_source_line=pc))
  return 2
 n=2**k;child=k*2**(k-1)
 right=inner(k-1,off+n+child,path+[1]);left=inner(k-1,off+n,path+[0]);assert right==left
 return right+left
def depth(k,off,path):
 n=2**k;child=k*2**(k-1)
 return sum(inner(k-1,off+3*n+c*child,path+[c]) for c in [2,1,0])
branches=[]
for b in [1,0]:branches.append(depth(9,1536+b*3*(11*2**8),[b]))
assert branches==[1536,1536] and len(rows)==3072 and len({r['leaf_word'] for r in rows})==1536
assert all(rows[i]['leaf_word']==rows[i+1]['leaf_word'] and rows[i]['width_class']=='paired' and rows[i+1]['width_class']=='stored' for i in range(0,len(rows),2))
rec=[dict(k=k,inner_calls=2**(k+1),inner_scratch=2**(k+1)-2,inner_tree_words=(k+1)*2**k) for k in range(9)]
spans={n:dict(source='source/falcon-sign.c',first=a,last=b,sha256=__import__('hashlib').sha256(''.join((W/'source/falcon-sign.c').read_text().splitlines(True)[a-1:b]).encode()).hexdigest()) for n,a,b in [('inner',1616,1694),('cubic',1696,1780),('root',1782,1839)]}
out=dict(schema='ORDERED_JOINT_SOURCE_ORDER_V1',game='IID_BUFFER',root_logn=10,root_call_count=len(rows),count_derived='I(0)=2; I(k+1)=2I(k); D(k)=3I(k-1); R(l)=2D(l-1); R(10)=3072',root_order=[1,0],cubic_order=[2,1,0],binary_order=[1,0],terminal_order=['snapshot mu1,old mu0,sigma','paired mu1','r1 and rx=half_C(r1)','updated mu0=add_C(old_mu0,rx)','stored updated mu0','r0=sub_C(normal_residual0,rx)','store both residuals'],spans=spans,recurrences=rec,branch_scalar_counts=branches,terminal_blocks=1536,branch_terminal_blocks=768,tree_words=18432,root_scratch_words=2558,scratch_high_water=8702,tmp_capacity=10752,positions=rows,source_pin=sha(I/'CANDIDATE.sha256'),table_is_structural_instance_not_domain_proof=True)
(W/'SOURCE_ORDER.json').write_text(json.dumps(out,indent=2)+'\n');print('SOURCE_ORDER',len(rows),'TERMINALS',len(rows)//2,'HIGH_WATER',8702)
