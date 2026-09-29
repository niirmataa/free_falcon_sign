"""Entry-fixed complete source-L noise-map structure in actual scalar order."""
import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';calls=[];nodes=[]
def inner(k,off,path):
 if not k:
  for cls in ['paired','stored']:calls.append(dict(index=len(calls),path=path,leaf_word=off,width_class=cls))
  return
 n=2**k;child0=off+n;child1=child0+k*2**(k-1);nodes.append(dict(kind='binary',degree=n,tree_word=off,left=child0,right=child1,path=path))
 inner(k-1,child1,path+[1]);inner(k-1,child0,path+[0])
for branch in [1,0]:
 base=1536+8448*branch;nodes.append(dict(kind='cubic',degree=512,tree_word=base,L10=base,L20=base+512,L21=base+1024,path=[branch]))
 for child in [2,1,0]:inner(8,base+1536+2304*child,[branch,child])
old=json.loads((I/'JOINT/SOURCE_ORDER.json').read_text());original=old.get('calls',old.get('call_order'))
if original is None:
 original=next(v for v in old.values() if isinstance(v,list) and len(v)==3072 and isinstance(v[0],dict) and 'leaf_word' in v[0])
assert len(calls)==3072 and len(nodes)==1532
for a,b in zip(calls,original):
 for k in ['index','path','leaf_word','width_class']:assert a[k]==b[k],(a,b)
roots=[1+6*int(format(j,'08b')[::-1],2)+1536*k for j in range(256) for k in range(3)];assert sorted(roots)==list(range(1,4608,6))
out=dict(schema='H6P_SOURCE_NOISE_MAP_V1',game='IID_BUFFER',reference='Q_S',event='joint pre-narrow BadPrecast of both1536-vectors',status='PASS_COMPLETE_ENTRY_FIXED_OPERATOR_STRUCTURE',inputs=dict(xi='xi_i=val(mu_i(actual positive-support prefix))-Y_i',sigma='actual source word at that same call',tree='immutable normalized tree with actual raw L slots',basis='actual rounded FFT basis [g,-f,G,-F]'),call_order=calls,nodes=nodes,physical_root_numerators=roots,root_order=4608,terminal_map='(r0,r1)=(xi_stored-xi_paired/2,xi_paired); order paired then stored',binary_map='right=Merge(child1); left=Merge(child0)-right*actual_L',cubic_map='r2=Merge(child2); r1=Merge(child1)-r2*L21; r0=Merge(child0)-r1*L10-r2*L20',root_map='y=TopMerge(right); u=TopMerge(left); x=u-y*Lroot',basis_map='(F0,F1)=(x*b00+y*b10,x*b01+y*b11), exact real operations',coefficient_map='mathematical inverse evaluation on physical roots; a[e,r,i] is the r-th output of this explicit operator at innovation unit vector i',affine_offset='d[e,r]=0',coefficient_dependence='entry tree/basis/constants only, never sampled future values; sigma_i entry-fixed too',source_roundoff='actual source t_r equals this operator(xi)_r plus delta_r(history); ERROR_LEDGER gives uniform E including terminal/reconstruction/root/basis/iFFT',scope='universal required entries, all3072 coefficient rows; tests need not materialize9,437,184 matrix entries',dependencies={p:sha(I/p) for p in ['JOINT/SOURCE_ORDER.json','JOINT/REFERENCE_PROCESSES.md','POST/SOURCE_POSTPROCESSING_CERTIFICATE.json','LEFT/LEFT_ROOT_CORRELATED_TRANSFER_CERTIFICATE.json']})
(W/'SOURCE_NOISE_MAP.json').write_text(json.dumps(out,indent=2)+'\n');print('PASS_SOURCE_NOISE_MAP',len(calls),'calls',len(nodes),'nodes')
