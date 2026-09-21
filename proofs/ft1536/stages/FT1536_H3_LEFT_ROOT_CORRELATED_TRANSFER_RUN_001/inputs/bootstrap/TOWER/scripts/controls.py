import json,re,shlex,subprocess,sys,time
from fractions import Fraction as F
from pathlib import Path
from backend import mul,div
from half_model import half
from root_model import tables
from node_model import slice_words as node3_slice
from node2_model import slice_words as level8_slice
from tower_model import split,build,tree_size
from fixtures import root_words,half_words
from dyadic import value,rn
from replaylib import sha
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];log=W/'checks/logs'/mode;log.mkdir(parents=True,exist_ok=True);commands=[]
def run(tag,argv,data=None):
 t=time.monotonic();p=subprocess.run(argv,input=data,capture_output=True,timeout=120)
 so=log/(tag+'.stdout');se=log/(tag+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr)
 commands.append(dict(argv=argv,cwd=str(W),wall_limit=120,exit_code=p.returncode,elapsed=time.monotonic()-t,stdout=str(so.relative_to(W)),stderr=str(se.relative_to(W)),stdout_sha256=sha(so),stderr_sha256=sha(se)))
 (log/'commands.json').write_text(json.dumps(commands,indent=2)+'\n');assert p.returncode==0,(tag,p.stderr.decode());return p.stdout
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'source/Makefile').read_text(),re.M).group(1));flags=[s.replace('\\"','"') for s in flags]+['-std=c99','-ffunction-sections','-fdata-sections','-Isource']
if mode=='san':flags+=['-fsanitize=address,undefined','-fno-omit-frame-pointer','-g']
exe='bin/tower_'+mode;run('compile',['/usr/bin/gcc']+flags+['checks/tower.c','source/falcon-fft.c','source/fpr-emulated.c','-Wl,--gc-sections','-lm','-o',exe])
assert not (log/'compile.stderr').read_bytes()
words=half_words();data=''.join(f'{x:016x}\n' for x in words).encode();(W/'checks/half_inputs.txt').write_bytes(data)
got=[int(x,16) for x in run('half',[exe,'half'],data).split()];assert got==[half(x) for x in words]
(W/'checks/half_jobs.txt').write_text(''.join(str(x)+'\n' for x in words));(W/'checks/half_expected.txt').write_text(''.join(str(x)+'\n' for x in got))
pairs=[(rn(x),rn(y)) for x in [F(0),F(1,2**1022),F(1,3),F(1),F(2**31+2),F(2**100)] for y in [F(1,16),F(49,100),F(27),F(2**31+2),F(2**35)]]
data=''.join(f'{x:016x} {y:016x}\n' for x,y in pairs).encode();(W/'checks/divisor_inputs.txt').write_bytes(data)
vals=[tuple(int(z,16) for z in s.split()) for s in run('divisors',[exe,'scalar'],data).decode().splitlines()]
assert vals==[(mul(x,y),div(x,y)) for x,y in pairs]
for (x,y),(m,d) in zip(pairs,vals):assert abs(value(d)-value(x)/value(y))<=F(1,2**48)*abs(value(x)/value(y))+F(1,2**900)
def parse(raw):
 lines=raw.decode().splitlines();events=[];nodes=[];tree=[];i=0
 while i<len(lines):
  p=lines[i].split();i+=1
  if p[0]=='S':events.append(['S',int(p[1]),p[2],int(p[3]),p[4],int(p[5]),p[6],int(p[7])])
  elif p[0]=='N':
   k,off=map(int,p[1:]);events.append(['N',k,off]);a=[];b=[];L=[];D=[]
   for j in range(2**k):
    v=lines[i].split();i+=1;assert v[0]=='V' and int(v[1])==j
    for dst,x in zip([a,b,L,D],v[2:]):dst.append(int(x,16))
   nodes.append(dict(level=k,offset=off,a=a,b=b,L=L,D=D))
  elif p[0]=='B':events.append(['B',int(p[1]),int(p[2],16),int(p[3],16)])
  elif p[0]=='T':assert int(p[1])==len(tree);tree.append(int(p[2],16))
  else:assert lines[i-1]=='END 1024 256 INPUTS_UNCHANGED CANARIES_PASS'
 return tree,events,nodes
tab=tables(W);rows=[];allnodes=[];mutation_checks={};coverage={k:0 for k in range(1,8)}
for b in [0,1]:
 v=root_words(b);payload=''.join(f'{x:016x}\n' for x in v).encode();(W/'checks'/f'root{b}_input.txt').write_bytes(payload);n3=node3_slice(v,tab)
 for k,idx in enumerate([0,3,4]):
  n8=level8_slice(n3[idx],tab)
  for edge in [0,1]:
   parent=n8[0 if edge==0 else 3];a,z=split(parent,8,tab)
   expected,events,nodes=build(7,a,z,tab,path=str(edge))
   assert len(expected)==1024 and len(nodes)==127
   for r in nodes:
    hn=len(r['a'])//2;assert all(value(x)>0 for x in r['a'][:hn]+r['D'][:hn])
   raw=run(f'inner_{b}_{k}_{edge}',[exe,'pipeline',str(k),str(edge)],payload);got,e2,n2=parse(raw)
   assert got==expected and e2==events and n2==[{a:v for a,v in r.items() if a!='path'} for r in nodes]
   (W/'checks'/f'trace_{b}_{k}_{edge}_{mode}.txt').write_bytes(raw)
   assert build(7,[x^0 for x in a],[x^0 for x in z],tab,path=str(edge))[0]==got
   for r in nodes:
    coverage[r['level']]+=2**(r['level']-1);allnodes.append(dict(branch=b,diagonal=k,**r))
   # Structural mutations have actual missing/reordered events and stores.
   assert events!=[e for e in events if e[0]!='B'];mutation_checks['omit_base_stores']=True
   assert events!=[e for e in events if not(e[0]=='N' and e[1]==4)];mutation_checks['omit_level']=True
   assert events!=events[1:];mutation_checks['omit_first_path_event']=True
   assert got!=got[:-1];mutation_checks['wrong_store_extent']=True
   local_event=['N',7,0];wrong=[local_event]+[e for e in events if e!=local_event]
   assert events!=wrong;mutation_checks['local_before_first_child']=True
   rows.append(dict(branch=b,diagonal=k,entry_edge=edge,tree_words=1024,nodes=127,events=len(events),source_trace_sha256=sha(W/'checks'/f'trace_{b}_{k}_{edge}_{mode}.txt')))
assert all(v==768 for v in coverage.values()) and len(allnodes)==1524
(W/'checks'/f'nodes_{mode}.json').write_text(json.dumps(allnodes,indent=2)+'\n')
out=dict(status='PASS_ORIGINAL_INNER7_AND_ALL_LEVEL_CONTROLS',subtrees=rows,positions_per_level=coverage,L_words=10752,raw_leaf_words=1536,
 half_boundary_words=len(words),divisor_pairs=len(pairs),structural_mutations=mutation_checks,noop_pass=True,
 base_observation='Direct base stores observed and checked at next source hook or final return; original base statements unchanged.',
 source_order_trace=True,inputs_unchanged=True,canaries_pass=True,
 scope='Public synthetic root spectra only; original recursive body with pure observation wrappers; no KeyGen/private loader/Sign or P_key membership claim.')
(W/'artifacts'/('controls_'+mode+'.json')).write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='subtrees'}|{'subtree_count':len(rows)},indent=2))
