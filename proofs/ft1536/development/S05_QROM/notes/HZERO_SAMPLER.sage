# Standard preparser required: sage hzero_sampler.sage OUTPUT TABLES CERT003
# Exact integer/rational sampler law; RealBallField used only for certification.
import json, sys, hashlib, bisect, time
from pathlib import Path
OUT=Path(sys.argv[1]); OUT.mkdir(parents=True,exist_ok=True)
for name in ['certificate.json','execution_checks.json']:
    if (OUT/name).exists(): raise FileExistsError('Refusing to overwrite '+str(OUT/name))
table=json.loads(Path(sys.argv[2]).read_text())
cert003=json.loads(Path(sys.argv[3]).read_text())
q=ZZ(18433); sigma=ZZ(768); B=ZZ(2093922385); T=ZZ(15360)
box=ZZ(65535); half=ZZ(768); n=ZZ(1536)
p=ZZ(256); b=ZZ(384); pair_cap=ZZ(192); sign_cap=ZZ(16)
cat_bits=ZZ(256); challenge_bits=ZZ(80); exp_bits=ZZ(384)
Mexp=ZZ(2)^exp_bits; Mcat=ZZ(2)^cat_bits; Mprop=ZZ(2)^p; Nprop=ZZ(2)^b
weights=[ZZ(x) for x in table['weights']]
accept=[ZZ(x) for x in table['acceptance_thresholds']]
assert (ZZ(table['sigma']),ZZ(table['cutoff']),ZZ(table['precision_bits']),ZZ(table['draw_bits']))==(sigma,T,p,b)
assert len(weights)==2*T+1 and len(accept)==4*T+1
cdf=[]; S=ZZ(0)
for weight in weights: S+=weight; cdf.append(S)
alpha=QQ(cert003['alpha_exact']); assert alpha>1/2
RB=RealBallField(512)
t0=time.monotonic()

def save(name,value):
    (OUT/name).write_text(json.dumps(value,indent=2,default=lambda x:int(x) if isinstance(x,Integer) else str(x))+'\n')

# Uniform absolute exp(-t) enclosure for EVERY nonnegative rational t.
# Taylor at t/512 <=25/32; odd partial sum 127, even 128; nine squarings.
# Endpoint rounding is always directed, and endpoints stay in [0,1].
assert factorial(128)>ZZ(2)^700
def exp_weight_interval(t):
    t=QQ(t)
    assert t>=0
    if t==0: return Mexp,Mexp
    if t>=400: return ZZ(0),ZZ(1)  # e^-400 < 2^-400 < 2^-384
    u=t/512; term=QQ(1); partial=QQ(1); lower=None
    for k in range(1,129):
        term*=u/k
        partial+=(-1)^k*term
        if k==127: lower=partial
    lo=max(ZZ(0),floor(Mexp*lower)); hi=min(Mexp,ceil(Mexp*partial))
    for _ in range(9):
        lo=(lo*lo)//Mexp
        hi=min(Mexp,(hi*hi+Mexp-1)//Mexp)
    assert 0<=lo<=hi<=Mexp and hi-lo<=4096
    return lo,hi

# Directed-rounding width proof: initial width <=3; each square <=2w+2.
width=ZZ(3)
for _ in range(9): width=2*width+2
assert width<=4096
weight_error=QQ(1)/ZZ(2)^372
Kcat=1+ZZ(64)^2*(weight_error+QQ(1)/Mcat)

def lifts(a):
    a=ZZ(a)%q
    return [a+q*k for k in range(ceil(QQ(-box-a)/q),floor(QQ(box-a)/q)+1)]

def fiber_points(a,b):
    vals=[(x,y,x*x+x*y+y*y) for x in lifts(a) for y in lifts(b)]
    assert 1<=len(vals)<=64
    return vals,min(v[2] for v in vals)

category_cache={}
def fiber_category(a,b):
    key=(ZZ(a)%q,ZZ(b)%q)
    if key in category_cache: return category_cache[key]
    vals,minimum=fiber_points(*key)
    intervals=[exp_weight_interval(QQ(v[2]-minimum)/(2*sigma^2)) for v in vals]
    upper_sum=sum(v for u,v in intervals)
    assert upper_sum>=Mexp
    counts=[(Mcat*u)//upper_sum for u,v in intervals]
    pivot=next(i for i,v in enumerate(vals) if v[2]==minimum)
    counts[pivot]+=Mcat-sum(counts)
    cumulative=[]; acc=ZZ(0)
    for count in counts: assert count>=0; acc+=count; cumulative.append(acc)
    assert acc==Mcat
    result=(vals,cumulative,minimum)
    category_cache[key]=result
    return result

def draw_fiber(category,getbits):
    vals,cumulative,minimum=category
    idx=bisect.bisect_right(cumulative,getbits(cat_bits))
    x,y,_=vals[idx]
    return x,y

def draw_coord(getbits):
    return ZZ(bisect.bisect_right(cdf,getbits(b)%S))-T

def draw_pair_or_zero(getbits):
    for j in range(pair_cap):
        x=draw_coord(getbits); y=draw_coord(getbits)
        if getbits(p)<accept[x+y+2*T]: return (x,y),ZZ(j+1),False
    # Internal truncation mass is placed on an atom with substantial Gaussian mass.
    return (ZZ(0),ZZ(0)),pair_cap,True

# Tight upper bound on the finite-box triangular Gaussian normalizer.
# Complete square; split y into even/odd. theta sums get geometric tail bounds.
theta_cutoff=ZZ(24576)
def theta_upper(a,shift):
    if shift==0:
        partial=RB(1)+2*sum((-a*RB(k)^2).exp() for k in range(1,theta_cutoff+1))
        first=RB(theta_cutoff+1)
    else:
        partial=2*sum((-a*(RB(k)+RB(1)/2)^2).exp() for k in range(theta_cutoff+1))
        first=RB(theta_cutoff)+RB(3)/2
    tail=2*(-a*first^2).exp()/(1-(-a*(2*first+1)).exp())
    return partial+tail

print('Computing pointwise Gaussian and full-reply moment bounds',flush=True)
a1=RB(1)/(2*sigma^2); a3=3*a1
Ztri=theta_upper(a1,0)*theta_upper(a3,0)+theta_upper(a1,1/2)*theta_upper(a3,1/2)
Zprop_lower=RB(S-len(weights))/Mprop
rho=RB(1)/Mprop*(RB(T^2)/(4*sigma^2)).exp()
kappa=(1+RB(S)/Nprop)*(1+rho)
Kaccepted=kappa^2*Ztri/(RB(alpha)*Zprop_lower^2)
pair_failure=(1-RB(alpha))^pair_cap
Kpair=Kaccepted+pair_failure*Ztri
assert Kpair>1 and Kpair-1<RB(2)^(-108)
Kchallenge=(1+RB(q)/ZZ(2)^challenge_bits)^n
Kreply=(RB(Kcat)*Kpair)^(half*sign_cap)
C=Kchallenge*Kreply
e=C^2-1 # Same conservative pointwise-to-second form as the existing toolbox.
assert 0<e<RB(2)^(-50)

# Closed h=0 Sign-body sampler. Conditional simulation consumes independent
# first-half fiber pairs and unconditional second-half Gaussian pairs.
def sample_hzero_given_challenge(challenge,getbits):
    assert len(challenge)==half
    mins=[fiber_points(a,b)[1] for a,b in challenge]
    qmin=sum(mins)
    if qmin>=B:
        return {'challenge':challenge,'reply':None,'reason':'DETERMINISTIC_NORM_ABORT',
                'attempts':ZZ(0),'pair_proposals':ZZ(0),'pair_fallbacks':ZZ(0),'min_norm':qmin}
    cats=[fiber_category(a,b) for a,b in challenge]
    proposals=ZZ(0); fallbacks=ZZ(0)
    for attempt in range(sign_cap):
        first=[draw_fiber(cat,getbits) for cat in cats]
        second=[]
        for _ in range(half):
            pair,cost,fallback=draw_pair_or_zero(getbits)
            second.append(pair); proposals+=cost; fallbacks+=ZZ(fallback)
        norm=sum(x*x+x*y+y*y for x,y in first+second)
        assert all((x-a)%q==0 and (y-b)%q==0 for (x,y),(a,b) in zip(first,challenge))
        if norm<B:
            assert all(-32768<=x<=32767 and -32768<=y<=32767 for x,y in second)
            return {'challenge':challenge,'reply':second,'first_half':first,'reason':'SUCCESS',
                'attempts':ZZ(attempt+1),'norm':norm,'pair_proposals':proposals,'pair_fallbacks':fallbacks,'min_norm':qmin}
    return {'challenge':challenge,'reply':None,'reason':'CAP16_ABORT','attempts':sign_cap,
            'pair_proposals':proposals,'pair_fallbacks':fallbacks,'min_norm':qmin}

def sample_hzero(getbits):
    challenge=[(getbits(challenge_bits)%q,getbits(challenge_bits)%q) for _ in range(half)]
    result=sample_hzero_given_challenge(challenge,getbits)
    return result['challenge'],result['reply']

class DemoBits:
    def __init__(self,label): self.label=label; self.counter=ZZ(0); self.bits=ZZ(0)
    def getbits(self,k):
        assert k%8==0
        value=ZZ(int.from_bytes(hashlib.shake_256(self.label+int(self.counter).to_bytes(16,'little')).digest(int(k//8)),'little'))
        self.counter+=1; self.bits+=k
        return value

print('Checking exact exponential enclosures and sampler branches',flush=True)
# Finite checks supplement the uniform Taylor/rounding proof; not its replacement.
exp_inputs=[QQ(0),QQ(1)/1000,QQ(1)/2,QQ(1),QQ(100),QQ(399999)/1000,QQ(400),QQ(10000)]
for t in exp_inputs:
    lo,hi=exp_weight_interval(t); actual=(-RB(t)).exp()
    assert RB(lo)/Mexp<=actual and actual<=RB(hi)/Mexp

fixtures=[('zero',[(ZZ(0),ZZ(0))]*half),
          ('boundary',[(ZZ(9216),ZZ(9216))]+[(ZZ(0),ZZ(0))]*(half-1)),
          ('cap16',[(ZZ(800),ZZ(800))]*half),
          ('deterministic_abort',[(ZZ(1000),ZZ(1000))]*half)]
checks=[]
for label,challenge in fixtures:
    bits=DemoBits(('FT1536-S05-HZERO-'+label).encode()); start=time.monotonic()
    result=sample_hzero_given_challenge(challenge,bits.getbits)
    expected={'zero':'SUCCESS','boundary':'SUCCESS','cap16':'CAP16_ABORT','deterministic_abort':'DETERMINISTIC_NORM_ABORT'}[label]
    assert result['reason']==expected
    checks.append({'fixture':label,'reason':result['reason'],'attempts':int(result['attempts']),
                  'norm':str(result.get('norm','not accepted')),'min_norm':str(result['min_norm']),
                  'pair_proposals':int(result['pair_proposals']),'pair_fallbacks':int(result['pair_fallbacks']),
                  'bits_consumed':str(bits.bits),'elapsed_seconds':time.monotonic()-start,
                  'challenge_was_forced_for_conditional_test':True})

random_bits=DemoBits(b'FT1536-S05-HZERO-UNCONDITIONAL')
c,o=sample_hzero(random_bits.getbits)
assert o is None
def force_pair_failure(k): return cdf[-2] if k==b else Mprop-1
fallback,cost,flag=draw_pair_or_zero(force_pair_failure)
assert fallback==(0,0) and flag and cost==pair_cap

# Check all generated categorical probabilities against rigorous real weights.
for (ca,cb),(vals,cumulative,minimum) in category_cache.items():
    ws=[(-RB(v[2]-minimum)/(2*sigma^2)).exp() for v in vals]; Z=sum(ws)
    previous=ZZ(0)
    for weight,endpoint in zip(ws,cumulative):
        probability=QQ(endpoint-previous)/Mcat; previous=endpoint
        assert RB(probability)<=RB(Kcat)*weight/Z

max_bits=n*challenge_bits+sign_cap*half*(cat_bits+pair_cap*(2*b+p))
save('certificate.json',{'status':'TEXTUAL_POINTWISE_HZERO_CERTIFICATE_WITH_RIGOROUS_ARITHMETIC',
    'scope':'h=0 only; unchanged all-h goal remains OPEN','q':str(q),'sigma':str(sigma),
    'exp_interval_bits':int(exp_bits),'uniform_exp_error':'2^-372','Kcat_exact':str(Kcat),
    'Ztri_upper_ball':str(Ztri),'Kpair_minus_one_ball':str(Kpair-1),'pair_failure_ball':str(pair_failure),
    'challenge_density_factor_ball':str(Kchallenge),'reply_density_factor_ball':str(Kreply),
    'joint_density_factor_ball':str(C),'e_ball':str(e),'proved_numeric_comparison':'0 < e < 2^-50',
    'ac_including_abort':'Follows textually from pointwise joint domination',
    'honest_norm_retry_cap':16,'max_gaussian_pair_proposals':str(sign_cap*half*pair_cap),
    'max_random_bits':str(max_bits),'max_fiber_weight_enclosures':str(half*64),
    'max_taylor_terms_per_enclosure':128,'max_dyadic_squarings_per_enclosure':9,
    'precomputed_tables_from':'SAMPLER_003 pinned tables','kernel_verified':False,
    'coefficient_model_only':True,'source_C_or_QROM_security_claim':False,'elapsed_seconds':time.monotonic()-t0})
save('execution_checks.json',{'conditional_fixtures':checks,'unconditional_hzero_reply':'none',
    'unconditional_bits_consumed':str(random_bits.bits),'actual_pair_cap_fallback_checked':True,
    'exp_enclosure_spot_checks':len(exp_inputs),'categorical_checks':len(category_cache),
    'demo_rng':'SHAKE-256 public labels; mathematical law assumes independent fair bits',
    'negative_route':'Uniform challenge plus unconditional none is NOT used: no moment bound was established for deleting all positive responses.'})
print('PASS: h=0 full-reply pointwise domination; e < 2^-50; all-h goal remains open',flush=True)
