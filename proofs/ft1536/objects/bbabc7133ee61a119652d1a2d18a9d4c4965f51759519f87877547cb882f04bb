"""Exact checking of every instantiated local numeric record and physical raw partition."""
import json
from fractions import Fraction as Q
from pathlib import Path
from replaylib import sha
from raw_model import leaf_map,tsize
W=Path.cwd();I=W/'inputs/bootstrap'
def load(p):return json.loads(p.read_text())
t=load(W/'artifacts/tower_numeric_certificate.json');assert sha(W/'artifacts/tower_numeric_certificate.json')==sha(I/'TOWER/artifacts/numeric_certificate.json')
root=load(I/'ROOT/ROOT_CERTIFICATE.json');n3=load(I/'NODE3/NODE3_CERTIFICATE.json');n2=load(I/'NODE2/artifacts/numeric_certificate.json')
assert n2['upstream_refinement']['root_imag_uniform']=='1'
transport=load(W/'artifacts/source_transport.json');assert transport['floor_unreachable_in_both'] and transport['other_source_files_identical']==16
assert root['unresolved_numerical_premises']==n3['unresolved_numerical_premises']==[]
assert len(t['initial_refinement'])==len(t['level8_refined'])==6 and len(t['nodes'])==1524
for rec in t['level8_refined']+t['nodes']:
 assert Q(rec['denominator_lower'])>Q(1,16) and Q(rec['denominator_upper'])<2**35
 assert Q(rec['B'])<2**100 and Q(rec['eigen_lower'])>0 and Q(rec['L_norm_upper'])==2
 for o in rec['outputs']:assert 0<Q(o['m'])<=Q(o['M'])<2**35 and 0<=Q(o['I'])<Q(o['m'])
rows=[];cover=[None]*18432;blocks=[];stages=[]
def block(start,n,kind,identity):
 assert 0<=start and start+n<=18432 and not any(cover[start:start+n]);cover[start:start+n]=[kind]*n;blocks.append(dict(start=start,end=start+n,kind=kind,identity=identity))
block(0,1536,'L','root')
for b in range(2):
 B=1536+b*8448;block(B,1536,'L',f'cubic{b}')
 for k in range(3):
  A=B+1536+k*2304;block(A,256,'L',f'level8_{b}_{k}')
  rec=next(r for r in t['level8_refined'] if r['branch']==b and r['diagonal']==k)
  rows.append(dict(branch=b,diagonal=k,node3_params=t['initial_refinement'][b*3+k]['params'],level8_record=rec,
   first_inner7=A+256,second_inner7=A+1280,first_child_before_local_LDL=True,source_snapshot='g00 input before first child; local d11 after child frame and LDL, before second child reuse'))
  def inner(l,off,path):
   r=next(r for r in t['nodes'] if r['branch']==b and r['diagonal']==k and r['level']==l and r['path']==path)
   block(off,2**l,'L',f'{b}_{k}_{path}_L')
   if l==1:block(off+2,2,'leaf',f'{b}_{k}_{path}_leaves')
   else:inner(l-1,off+2**l,path+'0');inner(l-1,off+2**l+tsize(l-1),path+'1')
  for e in range(2):inner(7,A+256+e*1024,str(e))
assert all(cover) and cover.count('L')==16896 and cover.count('leaf')==1536
lm=leaf_map();assert [r['tree_index'] for r in lm]==[i for i,v in enumerate(cover) if v=='leaf']
stages=[
 dict(id='basis_gram',requires=['P_key coefficient caps','Legal buffers'],gives=['finite basis','Gram snapshots','Gate00 g00>=1/2'],source='1159-1248',proof='ROOT ANALYTIC_PROOF sections2-4; OF_EXACT; late guard fixed profile'),
 dict(id='branch0',requires=['existing Gram g00','NODE3 branch0','TOWER refined S8/inner7','disjoint scratch'],gives=['8448 left words','root Gram preserved'],source='732-735',proof='COMPOSITION branch0/inner8 instantiation; no root D premise'),
 dict(id='root_ldl',requires=['preserved actual Gram','ROOT numerical domain'],gives=['1536 root L words','root D snapshot,real>32,imag<1'],source='740-741',proof='ROOT direct div/muladj/neg/add; NODE2 refined imaginary bound'),
 dict(id='branch1_read',requires=['actual root D snapshot'],gives=['three512-word immutable child inputs'],source='746-748',proof='NODE3 split/Adj; D read fully before t3 storage reuse'),
 dict(id='branch1',requires=['NODE3 branch1','TOWER refined S8/inner7','child input snapshots'],gives=['8448 right words','root Gram/basis frame'],source='749',proof='COMPOSITION branch1/lifetimes'),
 dict(id='return_cut',requires=['all previous stages terminated'],gives=['s=18432','all16896 finite internal words','1536 positive finite raw leaves','defined cut after1253'],source='751,1253',proof='RawLayout/RawMatching plus source finite loops and actual-operation composition')]
out=dict(status='PASS_ACTUAL_LOCAL_RECORDS_AND_COMPLETE_RAW_LAYOUT',source_pin=sha(I/'CANDIDATE.sha256'),tower_numeric_recomputed_byte_identical=True,
 consumed_nodes=1524,level8_groups=rows,root_constants=root['constants'],node3_branches=n3['constants'],
 chronological_instantiation=stages,tree_words=18432,internal_words=16896,leaf_words=1536,basis_words=6144,
 sk_words=24576,tmp_words=10752,top_scratch_words=3584,tmp_high_water=8192,all_scalar_operand_cap='2^100',lower_div_domain=['1/16','2^35'],
 raw_leaf_bounds=t['uniform_summaries'],coverage_blocks=blocks,leaf_map_sha256=sha(W/'LEAF_MAP.json'),
 proof_scope='Exact numeric/coverage check supporting the universal analytical source instantiation, not inference of universal totality from finite fixtures or this JSON alone.',
 strengthened_P_key=False,completed_prefix_assumed=False,unresolved_numerical_premises=[])
(W/'artifacts/composition_certificate.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],tree_words=18432,internal_words=16896,leaf_words=1536,blocks=len(blocks),numeric_nodes=1524),indent=2))
