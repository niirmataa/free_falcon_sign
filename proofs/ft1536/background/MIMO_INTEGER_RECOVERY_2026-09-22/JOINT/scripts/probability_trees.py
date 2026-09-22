"""Independent exact Sage QQ finite adaptive trees; controls, not source proof."""
import json,sys,itertools
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ
from replaylib import sha
W=Path.cwd();D=W/'artifacts/probability';D.mkdir(exist_ok=True)
def local(h):
 i=len(h);a=sum((j+1)*x for j,x in enumerate(h));k0=QQ(1+(a+i)%3)/4
 K={0:k0,1:1-k0,2:QQ(0)};t=QQ(1+(a+2*i)%4)/16;q0=QQ(2+(a+i)%3)/6
 G={0:(1-t)*q0,1:(1-t)*(1-q0),2:t}
 return K,G,t
def tv(P,Q):return sum(abs(P.get(y,0)-Q.get(y,0)) for y in set(P)|set(Q))/2
def chi(P,Q):
 if any(v and not Q.get(y,0) for y,v in P.items()):return 'infinity'
 return sum(v*v/Q[y] for y,v in P.items() if v)-1
def run(M):
 P={():QQ(1)};S={():QQ(1)};Q={():QQ(1)};exits={};localchi=[];normalizers=[]
 for i in range(M):
  p={};s={};q={}
  for h in P:
   K,G,t=local(h);Gs={y:g/(1-t) for y,g in G.items() if K[y]};kappa=chi(K,G);ks=chi(K,Gs)
   assert 1+ks==(1-t)*(1+kappa) and tv(K,Gs)<=tv(K,G) and sum(Gs.values())==1
   localchi.append(kappa);normalizers.append(dict(h=list(h),t=str(t),K={str(k):str(v) for k,v in K.items()},G={str(k):str(v) for k,v in G.items()},chi_forward=str(kappa),chi_supported=str(ks)))
   for y in [0,1]:p[h+(y,)]=P[h]*K[y];s[h+(y,)]=S[h]*Gs[y];q[h+(y,)]=Q[h]*G[y]
   exits[('EXIT',)+h+(2,)]=Q[h]*G[2]
  P,S,Q=p,s,q
 stop=Q|exits;exitmass=sum(exits.values());assert sum(P.values())==sum(S.values())==sum(stop.values())==1
 assert tv(S,stop)==exitmass and chi(stop,P)=='infinity' and chi(S,P)!='infinity'
 kap=max(localchi);assert chi(P,stop)<=(1+kap)**M-1 and chi(P,S)<=(1+kap)**M-1
 norm=sum(Q.values());conditioned={h:v/norm for h,v in Q.items()};gap=tv(S,conditioned);assert gap>0 if M>1 else gap==0
 for h,v in S.items():
  surv=__import__('functools').reduce(lambda a,b:a*b,(1-local(h[:j])[2] for j in range(M)),QQ(1));assert Q[h]==v*surv
 # All event indicators, then deterministic pushforward by parity.
 live=list(P);maxevent=QQ(0)
 if M<=3:
  for mask in range(1<<len(live)):
   ev=[h for j,h in enumerate(live) if mask>>j&1];p=sum(P[h] for h in ev);q=sum(stop[h] for h in ev)
   assert (p-q)**2<=chi(P,stop)*q*(1-q);assert p<=q+tv(P,stop);maxevent=max(maxevent,abs(p-q))
 def push(A):
  out={}
  for h,v in A.items():k='EXIT' if h[0]=='EXIT' else sum(h)%2;out[k]=out.get(k,QQ(0))+v
  return out
 assert tv(push(P),push(stop))<=tv(P,stop) and chi(push(P),push(stop))<=chi(P,stop)
 # Same conditional lift, an extra Bernoulli determined by the entire value trace.
 def lift(A):
  out={}
  for h,v in A.items():
   if h[0]=='EXIT':out[h]=v;continue
   r=QQ(1+sum(h)%3)/4
   for z,l in [(0,r),(1,1-r)]:out[h+('R',z)]=v*l
  return out
 assert tv(lift(P),lift(stop))==tv(P,stop) and chi(lift(P),lift(stop))==chi(P,stop)
 rows=dict(M=M,local=normalizers,P={str(k):str(v) for k,v in P.items()},QS={str(k):str(v) for k,v in S.items()},Qstop={str(k):str(v) for k,v in stop.items()},exit=str(exitmass),TV_P_Qstop=str(tv(P,stop)),chi_P_Qstop=str(chi(P,stop)),chi_P_QS=str(chi(P,S)),chi_QS_P=str(chi(S,P)),chi_Qstop_P='infinity',local_vs_whole_conditioning_TV=str(gap),event_checks='all subsets of live paths for M<=3',lift_exact=True)
 (D/('tree_'+str(M)+'.json')).write_text(json.dumps(rows,indent=2)+'\n');return rows
rows=[run(m) for m in [1,2,3,5]]
# Exact two-step countermodel: same first K/G-support, survival rates differ after first draw.
P={(0,0):QQ(1)/2,(1,0):QQ(1)/2};S=dict(P);stop={(0,0):QQ(1)/4,(1,0):QQ(3)/8,('EXIT',0):QQ(1)/4,('EXIT',1):QQ(1)/8};cond={(0,0):QQ(2)/5,(1,0):QQ(3)/5}
assert sum(stop.values())==1 and tv(S,cond)==QQ(1)/10
counter=dict(classification='ABSTRACT_TWO_STEP_ADAPTIVE_KERNEL_NOT_EMITTED_SOURCE',QS={'00':'1/2','10':'1/2'},Qstop_live={'00':'1/4','10':'3/8'},survival='5/8',Qstop_given_survival={'00':'2/5','10':'3/5'},TV_QS_conditioned='1/10',refuted_identity='QS = Qstop conditioned on whole-call survival')
(D/'conditioning_countermodel.json').write_text(json.dumps(counter,indent=2)+'\n')
(W/'artifacts/probability_trees.json').write_text(json.dumps(dict(status='PASS_INDEPENDENT_QQ_ADAPTIVE_TREES',source_probability_proof=False,cases=[dict(M=r['M'],path='artifacts/probability/tree_'+str(r['M'])+'.json') for r in rows],countermodel=counter),indent=2)+'\n');print('PASS_EXACT_ADAPTIVE_TREES',len(rows),'CONDITIONING_COUNTERMODEL_TV=1/10')
