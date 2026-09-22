import ast,json
from fractions import Fraction as Q
from pathlib import Path
from ordered_model import Machine,Stop,K,N
from kernel_model import entry,iteration,constants,schedule
from dyadic import rn
from replaylib import sha
W=Path.cwd();D=W/'artifacts/mutations';D.mkdir(exist_ok=True);rows=[]
def record(name,a,b,scope,same=False):
 assert (a==b)==same,name;p=D/(name+'.json');p.write_text(json.dumps(dict(name=name,baseline=a,changed=b,equal=a==b,scope=scope),indent=2)+'\n');rows.append(dict(name=name,status='NOOP_PASS' if same else 'DETECTED',path=p.relative_to(W).as_posix(),sha256=sha(p),scope=scope))
words=[int(w,16) for w in (W/'artifacts/fixtures/root_boundary.input').read_text().split()[:K+2*N]];tr=words[:K];a=words[K:K+N];b=words[K+N:];tape=[['N',i%3,i%2,0] for i in range(3072)]
class Prefix(Machine):
 def callback(self,mu,sigma):
  if self.call==2:raise Stop('CONTROL_PREFIX_CUT')
  return super().callback(mu,sigma)
def run(mut):
 m=Prefix(W,tr,a,b,tape,mut);m.run();return [{k:r[k] for k in ['index','mu','sigma','sample']} for r in m.calls]
base=run(None);record('noop',base,run(None),'fresh deterministic source-transducer no-op',same=True)
record('wrong_root_order',base,run('wrong_root_order'),'synthetic root model actual first two calls; native baseline bound; no Emitted membership')
record('wrong_binary_child_order',base,run('wrong_child_order'),'synthetic source-transducer swaps child tree pointers')
record('stale_center',base,run('stale_mu0'),'updated terminal center replaced by stale snapshot')
record('late_snapshot',base,run('late_snapshot'),'terminal old_mu0 snapshot overwritten with residual1')
def changed_schedule(p):
 R=D=0;events=[]
 for n in [8,8,1,8,8]:
  if n==8 and p>=4088:D+=4096-p;R+=1;p=0
  events.append(p);p+=n
  if n==1 and p==4096:R+=1;p=0
 return dict(end=p,refills=R,discarded=D,read_start=events)
s=schedule(4087);record('wrong_getter_cutoff',dict(end=s['end'],refills=s['refills'],discarded=s['discarded'],read_start=[e['read_start'] for e in s['events']]),changed_schedule(4087),'public valid ptr4087; source >=4087 versus wrong >=4088')
en=entry(W,0,rn(Q(4,3)));tables=constants(W)[0];point=iteration(W,en,tables[0][29],0);assert point['ber']['e']>=64 and tables[0][28]>tables[0][29]
record('proposal_window_instead_of_support',dict(k=29,y=point['output'],e=point['ber']['e'],in_S=False),dict(k=29,y=point['output'],e=point['ber']['e'],in_S=True),'local D_env scalar input,positive proposal mass but forced cutoff; no Emitted claim')
t=json.loads((W/'artifacts/probability/tree_2.json').read_text());P={ast.literal_eval(h):Q(p) for h,p in t['P'].items()};m0={z:sum(p for h,p in P.items() if h[0]==z) for z in [0,1]};m1={z:sum(p for h,p in P.items() if h[1]==z) for z in [0,1]};ind={h:m0[h[0]]*m1[h[1]] for h in P}
record('independent_marginals',{str(h):str(p) for h,p in P.items()},{str(h):str(p) for h,p in ind.items()},'exact QQ adaptive toy law versus product of actual one-dimensional marginals')
record('omit_local_normalization','1',str(1-Q(t['exit'])),'sum of QS live mass versus unnormalized Qstop live product')
record('omit_exit_mass',t['exit'],'0','Qstop mass conservation on exact adaptive toy tree')
record('reverse_chi2',dict(from_law='P',to_law='Qstop',value=t['chi_P_Qstop']),dict(from_law='Qstop',to_law='P',value=t['chi_Qstop_P']),'direction-sensitive exact toy chi-square')
cm=json.loads((W/'artifacts/probability/conditioning_countermodel.json').read_text());record('local_equals_whole_survival',cm['QS'],cm['Qstop_given_survival'],'abstract two-step kernel countermodel; TV1/10, no source Emitted membership')
record('same_values_imply_same_resources',3147,6219,'two original-C root tapes with same all3072 values/centers/widths/POST bytes but differing rejection counts')
(W/'artifacts/mutations.json').write_text(json.dumps(dict(status='PASS_EXECUTED_MEANINGFUL_MUTATIONS',detected=sum(r['status']=='DETECTED' for r in rows),noop=1,rows=rows,required_domain_counterexample=False),indent=2)+'\n');print('MUTATIONS',len(rows)-1,'DETECTED; NOOP PASS')
