# sage MARGINAL_006.sage OUTDIR NORMALIZER_005_CORRECTED_CERTIFICATE.json [PRECISION]
# Exact finite capped-law tests + rigorous FT1536 acceptance-cost certificate.
# No FT1536 marginal sampler is executed or claimed efficient by this script.
import json,sys
from pathlib import Path
out=Path(sys.argv[1]); out.mkdir(parents=True,exist_ok=True)
dest=out/'certificate.json'
if dest.exists(): raise FileExistsError('fresh output required')
prior=json.loads(Path(sys.argv[2]).read_text())
assert prior.get('endpoint_conversion')=='MPFR.exact_rational; corrected from original 005 QQ(MPFR)'
precision=ZZ(sys.argv[3]) if len(sys.argv)>3 else ZZ(512)
assert precision>=512
RB=RealBallField(precision)
def record(x): return {'ball':str(x),'lower_exact':str(x.lower().exact_rational()),'upper_exact':str(x.upper().exact_rational())}
def interval(lo,hi):
    assert parent(lo) in (QQ,ZZ) and parent(hi) in (QQ,ZZ)
    lo=QQ(lo); hi=QQ(hi); assert lo<=hi
    return RB((lo+hi)/2,(hi-lo)/2)
def prior_interval(entry): return interval(QQ(entry['lower_exact']),QQ(entry['upper_exact']))
def dyadic(p,bits):
    scale=ZZ(2)^bits
    keys=list(p); counts={k:floor(scale*p[k]) for k in keys}
    pivot=max(keys,key=lambda k:p[k])
    counts[pivot]+=scale-sum(counts.values())
    return {k:QQ(v)/scale for k,v in counts.items()}
def moment(j,p):
    assert sum(j.values())==sum(p.values())==1
    assert all(not j[k] or p.get(k,0)>0 for k in j)
    return sum(j.get(k,0)^2/v for k,v in p.items() if v>0)
def reply(mu):
    # Toy norm/emission: x^2+y^2<5, emitted y in [-1,1], else none.
    t={None:QQ(0),-1:QQ(0),0:QQ(0),1:QQ(0)}
    s=QQ(0)
    for (x,y),mass in mu.items():
        if x*x+y*y<5:
            s+=mass; t[y if abs(y)<=1 else None]+=mass
    factor=sum((1-s)^k for k in range(16))
    result={k:factor*v for k,v in t.items()}
    result[None]+=(1-s)^16
    assert sum(result.values())==1
    return result
def capped_reply_by_states(mu,alpha,cap):
    # Independent exact state recurrence: a late internal abort overrides even
    # an already chosen norm-success/emission result. No mixture formula used.
    fail=(1-alpha)^cap
    states={'pending':QQ(1)}
    for _ in range(16):
        nxt={}
        for state,mass in states.items():
            if state=='cap_failure':
                nxt[state]=nxt.get(state,0)+mass
                continue
            nxt['cap_failure']=nxt.get('cap_failure',0)+mass*fail
            for (x,y),v in mu.items():
                target=state
                if state=='pending' and x*x+y*y<5:
                    target=('chosen',y if abs(y)<=1 else None)
                nxt[target]=nxt.get(target,0)+mass*(1-fail)*v
        states=nxt
    result={None:QQ(0),-1:QQ(0),0:QQ(0),1:QQ(0)}
    for state,mass in states.items():
        emitted=state[1] if isinstance(state,tuple) else None
        result[emitted]+=mass
    assert sum(result.values())==1
    return result

print('Exact QQ tests: reweighted marginal, category law, cap failures, fresh moment',flush=True)
rows=[]
for qtoy in [3,5]:
    D=list(range(-2,3)); w={x:QQ(2)^(-x*x) for x in D}; G=sum(w.values())
    u={x:w[x]/G for x in D}; nu=dyadic(u,8)
    assert min(nu.values())>0
    for h in range(qtoy):
        for c in range(qtoy):
            fibers={y:[x for x in D if (x+h*y-c)%qtoy==0] for y in D}
            F={y:sum(w[x] for x in fibers[y]) for y in D}
            M=max(F.values())
            accept={y:QQ(floor(ZZ(2)^12*F[y]/M))/ZZ(2)^12 for y in D}
            assert min(accept.values())>0
            alpha=sum(nu[y]*accept[y] for y in D)
            Z=sum(w[y]*F[y] for y in D)
            P={(x,y):w[x]*w[y]/Z for y in D for x in fibers[y]}
            cats={y:dyadic({x:w[x]/F[y] for x in fibers[y]},10) for y in D}
            Q={(x,y):nu[y]*accept[y]/alpha*cats[y][x] for y in D for x in fibers[y]}
            # Entire law obtained from the actual finite proposal and coin counts.
            assert sum(Q.values())==sum(P.values())==1
            lu=min(nu[y]/u[y] for y in D); uu=max(nu[y]/u[y] for y in D)
            lf=min(accept[y]/(F[y]/M) for y in D); uf=max(accept[y]/(F[y]/M) for y in D)
            kcat=max(cats[y][x]/(w[x]/F[y]) for y in D for x in fibers[y])
            d=uu*uf/(lu*lf)*kcat
            assert all(Q[k]<=d*P[k] for k in Q)
            p=reply(P); core=reply(Q); beta=p[None]
            assert beta>0
            C=d^16
            assert moment(core,p)<=C
            for cap in [1,3,17]:
                # Precompute all 16 accepted pairs, abort if any internal cap fails.
                delta=1-(1-(1-alpha)^cap)^16
                j={k:(1-delta)*v+(delta if k is None else 0) for k,v in core.items()}
                assert j==capped_reply_by_states(Q,alpha,cap)
                actual=moment(j,p)
                exact=(1-delta)^2*moment(core,p)+2*(1-delta)*delta*core[None]/beta+delta^2/beta
                assert actual==exact
                safe=1+2*(1-delta)^2*(C-1)+2*delta^2*(1/beta-1)
                assert actual<=safe
                # Exact ideal-core identity, independently tested at the same cap.
                ideal={k:(1-delta)*v+(delta if k is None else 0) for k,v in p.items()}
                assert moment(ideal,p)==1+delta^2*(1/beta-1)
                rows.append({'q':int(qtoy),'h':int(h),'c':int(c),'cap':int(cap),
                             'alpha':str(alpha),'target_none':str(beta),
                             'independent_state_recurrence_passed':True,'all_exact_assertions_passed':True})
assert len(rows)==102
# Negative support control: cap failure cannot be introduced into a zero-mass atom.
negative_P={0:QQ(1),None:QQ(0)}
negative_J={0:QQ(3)/4,None:QQ(1)/4}
assert negative_P[None]==0 and negative_J[None]>0

q=ZZ(18433); sigma=ZZ(768); H=ZZ(65535); blocks=ZZ(768)
cut=ZZ(16384)
def theta(a,shift):
    a=RB(a)
    if shift==0:
        partial=1+2*sum((-a*k*k).exp() for k in range(1,cut+1)); r=RB(cut+1)
    else:
        partial=2*sum((-a*(RB(k)+RB(1)/2)^2).exp() for k in range(cut+1)); r=RB(cut)+RB(3)/2
    tail=2*(-a*r*r).exp()/(1-(-a*(2*r+1)).exp())
    return interval(partial.lower().exact_rational(),(partial+tail).upper().exact_rational())
print('FT1536 whole-vector rejection cost, including finite-box correction',flush=True)
a=QQ(1)/(2*sigma^2)
ginf=theta(a,0)*theta(3*a,0)+theta(a,1/2)*theta(3*a,1/2)
beta=RB(1)/(4*sigma^2)
line=2+(RB.pi()/beta).sqrt(); r=RB(H+1)
tail=2*(-beta*r*r).exp()/(1-(-beta*(2*r+1)).exp())
g=interval((ginf-2*tail*line).lower().exact_rational(),ginf.upper().exact_rational())
zblock=prior_interval(prior['h1_c0_full_fiber']['block_normalizer'])
# Any valid scalar envelope M >= Z1(0) >= 1, and y=0 is a possible proposal.
# alpha = Z_(1,0)/(G*M) <= (Zblock/Gtriangle)^768.
alpha_upper=(RB(zblock.upper())/RB(g.lower()))^blocks
assert alpha_upper<RB(2)^(-767)
assert ZZ(2)^128*alpha_upper<RB(2)^(-639)

print('Conditional fresh certificate budget, and explicit universal but enormous caps',flush=True)
rho=QQ(2)^(-256); eta=QQ(2)^(-256)
kappa=(1+QQ(2)^(-366))^blocks
kcat=1+ZZ(64)^2*(QQ(2)^(-372)+QQ(2)^(-256))
# Assumptions, not a claim that the old 004 proposal satisfies these two-sided bounds.
dm=(1+rho)*kappa/((1-rho)*(1-eta))
C=(dm*kcat^blocks)^16
assert C-1<QQ(2)^(-230)
eps_reply=2*(C-1)+2*QQ(2)^(-232)
assert eps_reply<QQ(2)^(-228)
Nchallenge=ZZ(2)^80; rem=Nchallenge%q
MH=(1+QQ(rem*(q-rem))/Nchallenge^2)^1536
assert MH-1<QQ(2)^(-120)
joint_excess=MH*(1+eps_reply)-1
assert joint_excess<QQ(2)^(-119)

# Full finite-box positive probability of honest norm rejection, uniformly h,c.
# Pick z2 with just one (H,H) block; choose centered lifts for z1.
max_first_energy=blocks*3*ZZ(9216)^2
t=QQ(max_first_energy+3*H^2)/(2*sigma^2)
assert 3*H^2>2093922385
reject_exponent=2*ceil(t)+17*3072
none_exponent=16*reject_exponent
# e<4 gives Zmin>=2^-331776; M=64^768=2^4608.
assert QQ(max_first_energy)/(2*sigma^2)==165888
alpha_exponent=ZZ(336385)
assert (1-rho)*(1-eta)/kappa>QQ(1)/2
cap_log2=alpha_exponent+ZZ(120+none_exponent).nbits()+1
# N*alpha0 >= 120*ln(2)+ln(1/beta)/2 implies delta^2/beta <= 2^-232.
lhs=RB(2)^(cap_log2-alpha_exponent)
rhs=(120+RB(none_exponent)/2)*RB(2).log()
assert lhs>rhs
# A dyadic coin must resolve tiny probabilities RELATIVELY, not just absolutely.
# F_lower >= F/kappa; one more bit safely accounts for kappa<2.
coin_bits=ZZ(336384)+257
assert kappa<2

result={'status':'CONDITIONAL_CAPPED_MARGINAL_CERTIFICATE_NOT_ALL_H_IMPLEMENTATION',
 'endpoint_conversion':'MPFR.exact_rational',
 'precision_bits':int(precision),'exact_toy_cases':rows,
 'negative_support_control':'PASS: P(none)=0 and added cap failure violates J<<P',
 'whole_vector_rejection':{'scope':'exact proposal U=w/G; h=1,c=0; any constant scalar envelope M>=max Z1',
    'Gtriangle':record(g),'acceptance_upper':record(alpha_upper),
    'proved':'alpha<2^-767; probability of any success in 2^128 proposals <2^-639',
    'not_claimed':'Does not exclude blockwise/adapted proposals or prove a final Q-JOINT lower bound.'},
 'fresh_conditional_budget':{'proposal_assumption':'(1-rho)U <= nu <= (1+rho)U, rho=2^-256 on full finite box',
    'acceptance_assumption':'(1-eta)F/(kappa*M) <= a <= F/M, eta=2^-256; fresh finite coin',
    'kappa':'(1+2^-366)^768','category_domination':'(1+64^2*(2^-372+2^-256))^768',
    'internal_cap_condition':'delta^2 / P_reply(none) <= 2^-232',
    'core_excess_upper':'2^-230','reply_excess_upper':'2^-228','joint_excess_upper':'2^-119',
    'core_excess_ball':record(RB(C-1)),'joint_excess_ball':record(RB(joint_excess)),
    'fresh_derivation':True,'old_hzero_certificate_transferred':False},
 'universal_crude_bounds':{'norm_rejection_lower':'2^-'+str(reject_exponent),
    'honest_none_lower':'2^-'+str(none_exponent),'acceptance_lower':'2^-'+str(alpha_exponent),
    'proposal_cap':'2^'+str(cap_log2),'acceptance_coin_bits':int(coin_bits),
    'scope':'Conditional existence/cost accounting; cap NOT executed; full-box proposal and coin implementation remain open.'},
 'open':['Full-box two-sided finite-bit proposal','Relative finite-bit acceptance implementation and cost',
    'Efficient adapted marginal for all h,c','Kernelization of h=0 and new capped-law theorem'],
 'non_claims':['No efficient FT1536 sampler','No Q-JOINT-INSTANCE witness','No kernel or independent review','No QROM security theorem']}
dest.write_text(json.dumps(result,indent=2)+'\n')
print('PASS: 102 exact capped-law cases; conditional e<2^-119; whole-vector rejection alpha<2^-767',flush=True)
