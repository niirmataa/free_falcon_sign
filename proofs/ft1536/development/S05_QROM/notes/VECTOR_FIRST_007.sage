# sage VECTOR_FIRST_007.sage OUTDIR TABLES PAIR_CERT [PRECISION]
# Full algorithm on ideal independent bits; SHAKE labels are demo fixtures only.
import json,sys,hashlib,bisect,time
from pathlib import Path
out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=True)
if (out/'certificate.json').exists():raise FileExistsError('fresh output required')
table=json.loads(Path(sys.argv[2]).read_text());prior=json.loads(Path(sys.argv[3]).read_text())
prec=ZZ(sys.argv[4]) if len(sys.argv)>4 else ZZ(512);assert prec>=512
RB=RealBallField(prec)
q=ZZ(18433);sigma=ZZ(768);B=ZZ(2093922385);n=ZZ(1536);d=ZZ(1536)
T=ZZ(15360);box=ZZ(65535);p=ZZ(256);b=ZZ(384);pair_cap=ZZ(80);vector_cap=ZZ(196)
cube_bits=ZZ(10);cube_half=ZZ(512)
weights=[ZZ(x) for x in table['weights']];thresholds=[ZZ(x) for x in table['acceptance_thresholds']]
assert (ZZ(table['sigma']),ZZ(table['cutoff']),ZZ(table['precision_bits']),ZZ(table['draw_bits']))==(sigma,T,p,b)
S=sum(weights);cdf=[];v=ZZ(0)
for w in weights:v+=w;cdf.append(v)
alpha=QQ(prior['alpha_exact']);assert alpha>1/2
t0=time.monotonic()
def interval(lo,hi):
    assert parent(lo) in (QQ,ZZ) and parent(hi) in (QQ,ZZ)
    assert lo<=hi
    return RB((lo+hi)/2,(hi-lo)/2)
def upper(x):return x.upper().exact_rational()
def lower(x):return x.lower().exact_rational()
def record(x):return {'ball':str(x),'lower_exact':str(lower(x)),'upper_exact':str(upper(x))}
def theta(a,shift):
    cut=ZZ(24576)
    if shift==0:
        part=1+2*sum((-a*k*k).exp() for k in range(1,cut+1));r=RB(cut+1)
    else:
        part=2*sum((-a*(RB(k)+RB(1)/2)^2).exp() for k in range(cut+1));r=RB(cut)+RB(3)/2
    tail=2*(-a*r*r).exp()/(1-(-a*(2*r+1)).exp())
    return interval(lower(part),upper(part+tail))
def triangle(s):
    a=RB(s)/(2*sigma^2)
    infinite=theta(a,0)*theta(3*a,0)+theta(a,1/2)*theta(3*a,1/2)
    beta=RB(s)/(4*sigma^2);r=RB(box+1)
    line=2+(RB.pi()/beta).sqrt()
    tail=2*(-beta*r*r).exp()/(1-(-beta*(2*r+1)).exp())
    return interval(lower(infinite-2*tail*line),upper(infinite))

print('Finite-box normalization, pair domination, global cap and fallback density',flush=True)
G0=triangle(QQ(1));assert G0>0
Zprop_lower=QQ(S-len(weights))/ZZ(2)^p
rho_round=RB(2)^(-p)*(RB(T^2)/(4*sigma^2)).exp()
kappa=(1+RB(S)/ZZ(2)^b)*(1+rho_round)
Kpair=kappa^2*G0/(RB(alpha)*RB(Zprop_lower)^2)+(1-RB(alpha))^pair_cap*G0
Kpair_up=upper(Kpair);assert Kpair_up>1
Cpre=Kpair_up^d
tilt=QQ(2*sigma^2*d)/B;assert 0<tilt<1
Gt=triangle(tilt)
global_tail=(-RB(1-tilt)*B/(2*sigma^2)).exp()*(Gt/G0)^d
rglobal=upper(global_tail);assert 0<rglobal<QQ(2)^(-24)
proposal_reject=Cpre*rglobal;assert proposal_reject<1
Kconditional=1+(Cpre-1)/(1-proposal_reject)
Qcube=3*cube_half^2*d;assert Qcube<B and Qcube/(2*sigma^2)==1024
cube_density=G0^d*(RB(Qcube)/(2*sigma^2)).exp()/ZZ(2)^(2*cube_bits*d)
cap_density=RB(proposal_reject)^vector_cap*cube_density
assert cap_density<RB(2)^(-160)
Kimpl=RB(Kconditional)+cap_density
assert Kimpl-1<RB(2)^(-60)

print('Conditional key mass witness: finite-box flatness, norm tail and full reply moment',flush=True)
mass_error=QQ(2)^(-34) # Value of the pinned T5 massBudget, NOT an emitted-key proof.
scalar_max=RB(q^2)/(991*2*RB.pi()*sigma^2)
assert (-RB.pi()/scalar_max).exp()<RB(2)^(-48)
row_error=2*QQ(2)^(-48)/(1-QQ(2)^(-48))
assert (1+row_error)^3072<1+mass_error
assert (1-row_error)^3072>1-mass_error
ratio=RB(1+mass_error)/RB(1-mass_error)
Bbox=QQ(3)/4*ZZ(65536)^2
tilt_box=QQ(2*sigma^2*d)/Bbox;assert tilt_box==QQ(9)/16
key_box_tail=ratio*(-RB(1-tilt_box)*Bbox/(2*sigma^2)).exp()*RB(tilt_box)^(-d)
assert key_box_tail<RB(2)^(-400)
rho_key=ratio/(1-key_box_tail)-1
assert rho_key<RB(2)^(-32)
key_norm_tail=ratio*(-RB(1-tilt)*B/(2*sigma^2)).exp()*RB(tilt)^(-d)/(1-key_box_tail)
assert key_norm_tail<RB(2)^(-24)
challenge_deviation=(rho_key+key_norm_tail)/(1-key_norm_tail)
ideal_second=(1+challenge_deviation^2)/(1-key_norm_tail^16)
excess=Kimpl^2*ideal_second-1
assert 0<excess<RB(2)^(-44)

class DemoBits:
    def __init__(self,label):self.label=label;self.counter=ZZ(0);self.bits=ZZ(0)
    def getbits(self,k):
        raw=hashlib.shake_256(self.label+int(self.counter).to_bytes(16,'little')).digest(int((k+7)//8))
        self.counter+=1;self.bits+=k
        return ZZ(int.from_bytes(raw,'little')) & (ZZ(2)^k-1)
def draw_coord(getbits):return ZZ(bisect.bisect_right(cdf,getbits(b)%S))-T
def draw_pair(getbits):
    for i in range(pair_cap):
        x=draw_coord(getbits);y=draw_coord(getbits)
        if getbits(p)<thresholds[x+y+2*T]:return (x,y),ZZ(i+1),False
    return (ZZ(0),ZZ(0)),pair_cap,True
F=GF(q);PR=PolynomialRing(F,'X');X=PR.gen();modulus=X^n-X^(n//2)+1
def poly(pairs):return PR([x for x,y in pairs]+[y for x,y in pairs])
def finish(h,pairs,reason,cost,inner,rounds):
    norm=sum(x*x+x*y+y*y for x,y in pairs)
    assert norm<B
    first=poly(pairs[:n//2]);second=poly(pairs[n//2:]);c=(first+h*second)%modulus
    assert (first+h*second-c)%modulus==0
    assert all(-32768<=x<=32767 and -32768<=y<=32767 for x,y in pairs[n//2:])
    return {'challenge':c,'reply':pairs[n//2:],'norm':norm,'internal_reason':reason,
            'pair_proposals':cost,'pair_fallbacks':inner,'vectors':rounds}
def sample_diagnostic(h,getbits):
    cost=ZZ(0);inner=ZZ(0)
    for j in range(vector_cap):
        pairs=[]
        for _ in range(d):
            pair,used,fallback=draw_pair(getbits);pairs.append(pair);cost+=used;inner+=ZZ(fallback)
        if sum(x*x+x*y+y*y for x,y in pairs)<B:
            return finish(h,pairs,'NORM_ACCEPT',cost,inner,ZZ(j+1))
    # Fresh product-uniform cube, exact 10-bit coordinates. This is a separately
    # charged distribution, not an omitted trial or conditioning on success.
    pairs=[(getbits(cube_bits)-cube_half,getbits(cube_bits)-cube_half) for _ in range(d)]
    return finish(h,pairs,'CUBE_FALLBACK',cost,inner,vector_cap)
def sample_public_reply(h,getbits):
    result=sample_diagnostic(h,getbits)
    return result['challenge'],result['reply'] # none has explicit zero mass.

print('Synthetic executions and both fallback paths at their actual caps',flush=True)
checks=[]
for name,h in [('zero',PR.zero()),('one',PR.one()),('dense',PR([F(i*i+17*i+1) for i in range(n)]))]:
    bits=DemoBits(('FT1536-S05-VECTOR-FIRST-007-'+name).encode());start=time.monotonic()
    result=sample_diagnostic(h,bits.getbits)
    checks.append({'fixture':name,'reason':result['internal_reason'],'norm':str(result['norm']),
                  'pair_proposals':str(result['pair_proposals']),'vectors':int(result['vectors']),
                  'random_bits':str(bits.bits),'seconds':time.monotonic()-start,
                  'challenge_sha256':hashlib.sha256(str(result['challenge']).encode()).hexdigest(),
                  'key_mass_witness_checked':False})
def reject_pair(k):return cdf[-2] if k==b else ZZ(2)^p-1
pair,used,flag=draw_pair(reject_pair)
assert pair==(0,0) and flag and used==pair_cap
def force_cube(k):
    if k==b:return cdf[1000+T-1]
    if k==p:return ZZ(0)
    assert k==cube_bits
    return ZZ(0)
forced=sample_diagnostic(PR.one(),force_cube)
assert forced['internal_reason']=='CUBE_FALLBACK' and forced['vectors']==vector_cap
assert forced['norm']==Qcube and forced['pair_proposals']==vector_cap*d

# Exact finite full-law checks for the key-flatness -> full-reply inequality.
toy_count=0
for ds in [(QQ(1),QQ(1)),(QQ(3)/4,QQ(5)/4),(QQ(9)/10,QQ(11)/10)]:
    for us in [(QQ(0),QQ(0)),(QQ(1)/8,QQ(1)/4),(QQ(1)/2,QQ(1)/8)]:
        rho=max(abs(v-1) for v in ds);u=max(us)
        abar=sum(ds[i]*(1-us[i])/2 for i in range(2))
        nu=[ds[i]*(1-us[i])/(2*abar) for i in range(2)]
        for ell in [QQ(0),QQ(1)/3,QQ(1)]:
            J={};P={}
            for i in range(2):
                pi=1-us[i]^16
                for o,L in [('none',ell),('some',1-ell)]:
                    J[i,o]=nu[i]*L
                    P[i,o]=(pi*L+(1-pi if o=='none' else 0))/2
            assert sum(J.values())==sum(P.values())==1
            assert all(not v or P[k]>0 for k,v in J.items())
            moment=sum(J[k]^2/v for k,v in P.items() if v>0)
            bound=(1+((rho+u)/(1-u))^2)/(1-u^16)
            assert moment<=bound
            toy_count+=1
assert toy_count==27
# Nonce-space identity and classical collision expression, exact boundary cases.
assert ZZ(256)^40==ZZ(2)^320
for qs in [0,1,2,17]:
    for qh in [0,1,19]:
        classical=QQ(qs*qh)+QQ(qs*max(qs-1,0))/2
        assert classical==qs*qh+binomial(qs,2)

result={'status':'EXECUTABLE_VECTOR_FIRST_SAMPLER_CONDITIONAL_KEY_MASS_CERTIFICATE',
 'precision_bits':int(prec),'source_model':'finite coefficient box; sigma768; strict Q<B',
 'triangle_normalizer':record(G0),'global_norm_tail':record(global_tail),
 'pair_domination_excess':record(Kpair-1),'implementation_density_excess':record(Kimpl-1),
 'cube_fallback_density_log2':record(cube_density.log()/RB(2).log()),
 'cap_density_contribution':record(cap_density),
 'key_mass_assumption':{'massBudget':'2^-34','temperatures':['1',str(tilt),str(tilt_box)],
   'statement':'For every c, infinite fiber partition Z_h,c(t) lies in (1+-massBudget) A_h*t^-1536, with one A_h independent of c.',
   'emitted_key_binding_proved':False},
 'finite_box_key_flatness':record(rho_key),'key_box_tail':record(key_box_tail),
 'key_norm_tail':record(key_norm_tail),'full_joint_excess':record(excess),
 'proved_numeric_comparisons':['Kimpl-1<2^-60','key_norm_tail<2^-24','full_joint_excess<2^-44 under key mass witness'],
 'sufficient_basis_condition':{'lattice':'u+h*v=0 modulo q in the Q metric',
   'rank':3072,'exact_LDL_pivot_bound':'0 < pivot <= 18433^2/991',
   'sampler_needs_basis_at_runtime':False,'source_to_exact_basis_binding':'OPEN'},
 'failure_law':{'pair_cap':'zero pair; pointwise density charged','vector_cap':'fresh uniform cube; density charged',
    'J_none_mass':'exactly zero','honest_P_none':'retained in cap16 mixture and moment denominator; no conditioning on honest success'},
 'cost':{'pair_cap':int(pair_cap),'vector_cap':int(vector_cap),
    'worst_pair_proposals':str(vector_cap*d*pair_cap),
    'worst_random_bits':str(vector_cap*d*pair_cap*(2*b+p)+2*cube_bits*d),
    'machine_bit_cost_certificate':False},
 'kernel':False,'all_h_certificate':False,'real_key_law_certificate':False,
 'elapsed_seconds':time.monotonic()-t0}
(out/'certificate.json').write_text(json.dumps(result,indent=2,default=int)+'\n')
(out/'execution_checks.json').write_text(json.dumps({'samples':checks,'actual_pair_cap_checked':True,
    'actual_vector_cap_checked':True,'cube_norm':str(forced['norm']),'exact_full_law_cases':int(toy_count),
    'nonce_identity':'256^40=2^320','classical_collision_boundary_cases':12,
    'demo_rng':'SHAKE-256 public labels; no PRG assumption established'},indent=2,default=int)+'\n')
print('PASS: executable sampler, pointwise implementation bound, conditional full e<2^-44',flush=True)
