# sage FIBER_NORMALIZER_005_CORRECTED.sage OUTDIR [PRECISION]
# ERRATUM: MPFR endpoints use exact_rational(), never QQ(MPFR).
# Standard Sage preparser. No random draws; ZZ/QQ + rigorous RealBallField.
# This certifies specified arithmetic and structural bounds, not QROM security.
import json, sys
from pathlib import Path

OUT = Path(sys.argv[1]); OUT.mkdir(parents=True, exist_ok=True)
if (OUT/'certificate.json').exists(): raise FileExistsError('fresh output required')
precision = ZZ(sys.argv[2]) if len(sys.argv)>2 else ZZ(512)
assert precision >= 512
RB = RealBallField(precision)
q=ZZ(18433); sigma=ZZ(768); box=ZZ(65535); blocks=ZZ(768)
Mexp=ZZ(2)^384; Mcat=ZZ(2)^256

def q2(x,y): return x*x+x*y+y*y
def lifts(a):
    a=ZZ(a)%q
    return [a+q*k for k in range(ceil(QQ(-box-a)/q), floor(QQ(box-a)/q)+1)]

# From HZERO_SAMPLER.sage; self-contained to avoid executing its top-level run.
# Uniform proof: odd/even Taylor bounds then outward integer squaring.
assert factorial(128)>ZZ(2)^700
def exp_weight_interval(t):
    t=QQ(t); assert t>=0
    if t==0: return Mexp,Mexp
    if t>=400: return ZZ(0),ZZ(1)
    u=t/512; term=QQ(1); partial=QQ(1)
    for k in range(1,129):
        term*=u/k; partial+=(-1)^k*term
        if k==127: lower=partial
    lo=max(ZZ(0),floor(Mexp*lower)); hi=min(Mexp,ceil(Mexp*partial))
    for _ in range(9):
        lo=(lo*lo)//Mexp; hi=min(Mexp,(hi*hi+Mexp-1)//Mexp)
    assert 0<=lo<=hi<=Mexp and hi-lo<=4096
    return lo,hi

def interval(lo,hi):
    # Exact rational endpoints first; no inward decimal serialization.
    assert parent(lo) in (QQ,ZZ) and parent(hi) in (QQ,ZZ)
    lo=QQ(lo); hi=QQ(hi); assert lo<=hi
    return RB((lo+hi)/2, (hi-lo)/2)

def ball_record(value):
    return {'ball':str(value), 'lower_exact':str(value.lower().exact_rational()),
            'upper_exact':str(value.upper().exact_rational())}

def scaled_record(m,L,U,repetitions=1):
    # Avoid printing huge rational approximations to exp(+165888).
    z=interval(L,U)^repetitions*(-RB(m*repetitions)/(2*sigma^2)).exp()
    assert z>0
    inv=1/z
    relative=RB(z.upper())/RB(z.lower())-1
    assert relative < RB(2)^(-350)
    assert RB(inv.upper())/RB(inv.lower())-1 < RB(2)^(-350)
    return {'energy_shift_exact':str(m*repetitions),'scaled_lower_base_exact':str(L),
            'scaled_upper_base_exact':str(U),'scaled_power':int(repetitions),'normalizer_ball':str(z),
            'inverse_ball':str(inv),'log2_normalizer':ball_record(z.log()/RB(2).log()),
            'relative_width':ball_record(relative)}

cache={}
def local(a,b):
    key=(ZZ(a)%q,ZZ(b)%q)
    if key in cache: return cache[key]
    pts=[(x,y,q2(x,y)) for x in lifts(key[0]) for y in lifts(key[1])]
    m=min(t[2] for t in pts)
    bounds=[exp_weight_interval(QQ(t[2]-m)/(2*sigma^2)) for t in pts]
    L=QQ(sum(t[0] for t in bounds))/Mexp
    U=QQ(sum(t[1] for t in bounds))/Mexp
    assert 1<=L<=U<=64 and U-L<=QQ(64)/ZZ(2)^372
    # Independent Arb evaluation of the finite box, with no exponent cutoff.
    direct=sum((-RB(t[2])/(2*sigma^2)).exp() for t in pts)
    normalized=sum((-RB(t[2]-m)/(2*sigma^2)).exp() for t in pts)
    # Overlap is a consistency check, not a proof of interval containment.
    assert normalized.overlaps(interval(L,U))
    assert direct.overlaps(interval(L,U)*(-RB(m)/(2*sigma^2)).exp())
    # Exact finite-bit law, all leftover counts go to a maximum-weight atom.
    upper=sum(t[1] for t in bounds)
    counts=[(Mcat*t[0])//upper for t in bounds]
    pivot=next(i for i,t in enumerate(pts) if t[2]==m)
    counts[pivot]+=Mcat-sum(counts); assert sum(counts)==Mcat
    eps=QQ(64)/ZZ(2)^372+QQ(64)/Mcat
    dom=1+64*eps
    real_weights=[(-RB(t[2]-m)/(2*sigma^2)).exp() for t in pts]
    tv=sum(abs(RB(QQ(cnt)/Mcat)-w/normalized) for cnt,w in zip(counts,real_weights))/2
    assert tv<RB(eps)
    assert all(RB(QQ(cnt)/Mcat)<=RB(dom)*w/normalized for cnt,w in zip(counts,real_weights))
    result={'m':m,'L':L,'U':U,'count':len(pts),'tv':tv}
    cache[key]=result; return result

print('Residual normalizer: exact shifted envelopes and direct ball cross-checks',flush=True)
fixtures=[(0,0),(1,0),(9216,0),(9216,9216),(6144,6144),(18432,1),
          (9216,9217),(65535%q,(-65535)%q)]
fixtures += [((j*7919+17)%q,(j*j*1543+29)%q) for j in range(8)]
local_rows=[]
for a,b in fixtures:
    v=local(a,b)
    local_rows.append({'residue':[int(a),int(b)],'points':v['count'],
                      'scaled':scaled_record(v['m'],v['L'],v['U']),
                      'category_TV':ball_record(v['tv'])})

eps_local=QQ(64)/ZZ(2)^372
normalizer_factor=(1+eps_local)^blocks
assert normalizer_factor-1<QQ(1)/ZZ(2)^356
eps_cat=eps_local+QQ(64)/Mcat
assert 16*blocks*eps_cat<QQ(1)/ZZ(2)^236
product_rows=[]
for a,b in [(0,0),(9216,0),(9216,9216),(6144,6144)]:
    v=local(a,b)
    product_rows.append({'repeated_residue':[int(a),int(b)],
                        'certificate':scaled_record(v['m'],v['L'],v['U'],blocks)})

# Uniform crude envelope used to expose reciprocal-tail amplification.
center_bound=ZZ(3)*ZZ(9216)^2*blocks
log2_min=-RB(center_bound)/(2*sigma^2*RB(2).log())
log2_max=RB(6*blocks)  # each block has at most 64 weights <=1
required_tail_bits=100+log2_max-log2_min
assert required_tail_bits>200000
v0=local(0,0); v1=local(9216,0)
log2_ratio=blocks*(RB(v1['m']-v0['m'])/(2*sigma^2)
                    +interval(v0['L'],v0['U']).log()
                    -interval(v1['L'],v1['U']).log())/RB(2).log()
assert log2_ratio>78000

# Full fiber h=1,c=0. Sum z1+z2=q*k; complete the square exactly.
# Central k=0 weight is exp(-q2(z2)/sigma^2) on the symmetric box.
print('Full nonzero fiber: theta central part, box tail and nonzero aliases',flush=True)
cut=ZZ(16384)
def theta(a,shift):
    a=RB(a)
    if shift==0:
        partial=1+2*sum((-a*k*k).exp() for k in range(1,cut+1))
        first=RB(cut+1)
    else:
        partial=2*sum((-a*(RB(k)+RB(1)/2)^2).exp() for k in range(cut+1))
        first=RB(cut)+RB(3)/2
    tail=2*(-a*first^2).exp()/(1-(-a*(2*first+1)).exp())
    return interval(partial.lower().exact_rational(),(partial+tail).upper().exact_rational()),tail

a=QQ(1)/sigma^2
t00,e00=theta(a,0); t01,e01=theta(a,1/2)
t30,e30=theta(3*a,0); t31,e31=theta(3*a,1/2)
central_infinite=t00*t30+t01*t31
# q2(x,y)>=(x^2+y^2)/2; union bound outside [-box,box]^2.
# Any shifted 1D Gaussian sum <= 2+sqrt(pi/beta), by two monotone tails.
beta=RB(1)/(2*sigma^2)
line_majorant=2+(RB.pi()/beta).sqrt()
r=RB(box+1)
line_tail=2*(-beta*r*r).exp()/(1-(-beta*(2*r+1)).exp())
box_loss=2*line_tail*line_majorant
central=interval((central_infinite-box_loss).lower().exact_rational(),central_infinite.upper().exact_rational())
assert central>0

# Infinite-lattice alias majorant. Exact inner square shell |k|_infty<=2.
A=RB(q^2)/(4*sigma^2)
alias_theta=sum((-A*q2(x,y)).exp() for x in range(-2,3) for y in range(-2,3) if (x,y)!=(0,0))
# q2(k)>=3/4 max(|kx|,|ky|)^2; shell size 8j.
shell_first=8*3*(-A*QQ(3)/4*3^2).exp()
shell_ratio=RB(4)/3*(-A*QQ(3)/4*7).exp()
shell_tail=shell_first/(1-shell_ratio)
alias_upper=(alias_theta+shell_tail)*line_majorant^2
full_block=interval(central.lower().exact_rational(),(central+alias_upper).upper().exact_rational())
full=full_block^blocks; full_inv=1/full
full_width=RB(full.upper())/RB(full.lower())-1
inverse_width=RB(full_inv.upper())/RB(full_inv.lower())-1
alias_tv=blocks*alias_upper/central
reply_tv=16*alias_tv
assert full_width<RB(2)^(-180) and inverse_width<RB(2)^(-180)
assert reply_tv<RB(2)^(-180)

# FT1536 h=1,c=0: rigorous LOWER bound on the ideal sequential pre-norm moment.
# E_U[Z1(-z)] = Zhc/ZG; restrict E_U[1/Z1(-z)] to a central square S.
# For |zx|,|zy|<=R, each lift other than z has energy gap at least
# q^2-4*q*R: Q(k)>=1, bilinear cross term <= 4*R*sqrt(Q(k)).
# There are <=63 other box lifts. This gives a simple finite-grid lower bound.
tg0,_=theta(QQ(1)/(2*sigma^2),0); tg1,_=theta(QQ(1)/(2*sigma^2),1/2)
tg30,_=theta(QQ(3)/(2*sigma^2),0); tg31,_=theta(QQ(3)/(2*sigma^2),1/2)
ZG_upper=tg0*tg30+tg1*tg31
R=4*sigma
gap=q^2-4*q*R; assert gap>0
lift_error=63*(-RB(gap)/(2*sigma^2)).exp()
# Use the full central normalizer for E[Zres], not just its weight at zero.
# Zhc(block)>=central; hence moment >= central * |S| / (ZG_upper^2*(1+lift_error)).
moment_lower=central*(2*R+1)^2/(ZG_upper^2*(1+lift_error))
print('Central block lower diagnostic:',moment_lower,flush=True)
assert moment_lower>4

cert={
 'status':'TEXTUAL_NORMALIZER_MIDPOINT_WITH_RIGOROUS_ARITHMETIC',
 'endpoint_conversion':'MPFR.exact_rational; corrected from original 005 QQ(MPFR)',
 'precision_bits':int(precision),'q':str(q),'sigma':str(sigma),'box':str(box),'blocks':int(blocks),
 'arithmetic':'ZZ/QQ exact shifted weights; RealBallField outward balls; no machine floats',
 'residual_uniform':{'relative_factor_minus_one_upper':'2^-356',
    'formula':'Z1(r)=exp(-M/(2*sigma^2))*A; L<=A<=U; U/L <= (1+2^-366)^768',
    'reciprocal':'exp(M/(2*sigma^2))/U <= 1/Z1(r) <= exp(M/(2*sigma^2))/L',
    'category_TV_per_full_cap16_upper':'2^-236',
    'scope_TV':'only first-half categorical rounding versus the same sequential ideal law; not TV to honest P'},
 'local_checks':local_rows,'product_checks':product_rows,
 'reciprocal_tail_warning':{'log2_uniform_lower':ball_record(log2_min),
    'log2_uniform_upper':ball_record(log2_max),'sufficient_tail_bits_for_relative_2m100':ball_record(required_tail_bits),
    'actual_log2_Z1_zero_over_repeated_9216_0':ball_record(log2_ratio)},
 'h1_c0_full_fiber':{'central_block':ball_record(central),'alias_upper':ball_record(alias_upper),
    'box_loss_upper':ball_record(box_loss),'theta_tail_sum':ball_record(e00+e01+e30+e31),
    'block_normalizer':ball_record(full_block),'log2_normalizer':ball_record(full.log()/RB(2).log()),
    'log2_inverse':ball_record(full_inv.log()/RB(2).log()),
    'normalizer_relative_width':ball_record(full_width),'inverse_relative_width':ball_record(inverse_width),
    'pre_norm_TV_to_zero_alias_law_upper':ball_record(alias_tv),
    'cap16_full_reply_TV_upper':ball_record(reply_tv),
    'cap16_bound_scope':'same norm and same model emission, including none; no conditioning on success'},
 'sequential_pre_norm_moment':{'block_lower':ball_record(moment_lower),
    'square_radius':int(R),'lift_gap':str(gap),'full_lower':'2^1536',
    'scope':'h=1,c=0 conditional before norm only; not a lower bound after cap16 or challenge averaging'},
 'non_claims':['No all-h useful moment certificate.','No efficient full Zhc contraction for arbitrary h.',
   'No new kernel proof or independent review.','No source/API/KeyGen or QROM security claim.',
   'Finite arithmetic fixtures do not quantify over all residues; the textual envelope proof does.']}
(OUT/'certificate.json').write_text(json.dumps(cert,indent=2)+'\n')
print('PASS: residual envelopes, reciprocal bounds, h=1,c=0 normalizer and full-reply TV < 2^-180',flush=True)
