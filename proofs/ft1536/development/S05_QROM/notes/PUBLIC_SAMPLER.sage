# Run with the standard Sage preparser: sage public_sampler.sage OUTDIR
# Mathematical law: independent fair bit strings at each getbits call.
# Demonstration only: deterministic SHAKE stream; no PRG security claim.
import json, sys, hashlib, bisect, time
from pathlib import Path

OUT = Path(sys.argv[1]); OUT.mkdir(parents=True, exist_ok=True)
q = ZZ(18433); sigma = ZZ(768); dim = ZZ(1536); blocks = ZZ(1536)
norm_limit = ZZ(2093922385); cutoff = ZZ(15360)
precision_bits = ZZ(256); draw_bits = ZZ(384)
pair_cap = ZZ(192); vector_cap = ZZ(512)
scale = ZZ(2)^precision_bits; N = ZZ(2)^draw_bits
RB = RealBallField(512)

def certified_floor(x):
    lo = ZZ(x.lower().floor()); hi = ZZ(x.upper().floor())
    if lo != hi:
        raise ArithmeticError('floor unresolved by interval: '+str(x))
    return lo

def certified_ceil(x):
    lo = ZZ(x.lower().ceil()); hi = ZZ(x.upper().ceil())
    if lo != hi:
        raise ArithmeticError('ceil unresolved by interval: '+str(x))
    return lo

def save(name, value):
    (OUT/name).write_text(json.dumps(value, indent=2, default=lambda v: int(v) if isinstance(v, Integer) else str(v))+'\n')

t0 = time.monotonic()
print('Constructing certified dyadic proposal and acceptance tables', flush=True)
wp = [scale] + [certified_ceil(RB(scale)*(-RB(x*x)/(4*sigma^2)).exp())
                for x in range(1,cutoff+1)]
weights = list(reversed(wp[1:])) + wp
ap = [scale] + [certified_floor(RB(scale)*(-RB(s*s)/(4*sigma^2)).exp())
                for s in range(1,2*cutoff+1)]
accept = list(reversed(ap[1:])) + ap
total = sum(weights); quotient, remainder = N.quo_rem(total)
cdf = []; counts = []; acc = ZZ(0)
for weight in weights:
    counts.append(quotient*weight + max(ZZ(0), min(weight,remainder-acc)))
    acc += weight; cdf.append(acc)
assert acc == total and sum(counts) == N
assert len(weights) == 2*cutoff+1 and len(accept) == 4*cutoff+1
assert min(weights)>0 and min(accept)>=0 and max(accept)<=scale

print('Exact polynomial convolution: acceptance probability and norm moment', flush=True)
PR = PolynomialRing(ZZ,'X')
K = PR(counts); XK = PR([(i-cutoff)*v for i,v in enumerate(counts)])
conv = (K*K).list(); cross = (XK*XK).list()
cross += [ZZ(0)]*(len(conv)-len(cross))
anum = sum(conv[i]*accept[i] for i in range(len(accept)))
qnum = sum(((i-2*cutoff)^2*conv[i]-cross[i])*accept[i]
           for i in range(len(accept)))
alpha = QQ(anum)/(N^2*scale)
mean_block_norm = QQ(qnum)/anum
X2K = PR([(i-cutoff)^2*v for i,v in enumerate(counts)])
x2conv = (X2K*K).list(); x2conv += [ZZ(0)]*(len(conv)-len(x2conv))
mean_coordinate_square = QQ(sum(x2conv[i]*accept[i] for i in range(len(accept))))/anum
assert alpha > QQ(1)/2
reject_norm_bound = blocks*mean_block_norm/norm_limit
assert 0 < reject_norm_bound < QQ(7)/8
norm_accept_lower = 1-reject_norm_bound

# TV to exact scalar exp(-x^2/(4 sigma^2)) on [-cutoff,cutoff].
# Integer ceil-weight normalization error <= length / 2^precision_bits
# (the real normalizer is >=1); modulo reduction error <= total / 2^draw_bits.
eps_scalar = QQ(len(weights))/scale + QQ(total)/N
gamma = 2*eps_scalar+QQ(1)/scale
assert RB(alpha)-RB(gamma) > RB(1)/2
eps_pair_round = 4*gamma

# q(x,y)>= (x^2+y^2)/2. Geometric bound on both Gaussian tails;
# normalizer of the full finite triangle-Gaussian box is >= weight(0,0)=1.
a = RB(1)/(4*sigma^2)
tail_w = 2*(-a*(cutoff+1)^2).exp()/(1-(-a*(2*cutoff+3)).exp())
sum_w_infty_upper = RB(total)/scale + tail_w
eps_pair_cutoff = 2*tail_w*sum_w_infty_upper
eps_vector = blocks*(RB(eps_pair_round)+eps_pair_cutoff)
# Conditioning on Q<B: TV <= 2 TV_unconditioned / P_actual[Q<B].
eps_conditioned = 2*eps_vector/RB(norm_accept_lower)
eps_pair_cap = vector_cap*blocks*(1-RB(alpha))^pair_cap
eps_vector_cap = RB(reject_norm_bound)^vector_cap
eta = eps_conditioned+eps_pair_cap+eps_vector_cap
assert eta > 0 and eta < RB(2)^(-90)

# Exact finite-bit challenge diagnostic; not part of the vector-first sampler.
challenge_bits = ZZ(80); challenge_N=ZZ(2)^challenge_bits
rem=challenge_N%q
challenge_second=QQ(1)+QQ(rem*(q-rem))/challenge_N^2
challenge_joint_second=challenge_second^dim
assert gcd(q,2)==1 and challenge_N%q != 0
assert challenge_joint_second-1 < QQ(2)^(-120)
for small_q in [3,5,7,17]:
    for bits in [1,2,5,8]:
        nn=ZZ(2)^bits; cc=[sum(1 for u in range(nn) if u%small_q==v) for v in range(small_q)]
        rr=nn%small_q
        assert sum(QQ(k)^2/(QQ(nn)^2/ small_q) for k in cc) == 1+QQ(rr*(small_q-rr))/nn^2

# Actual-candidate h=0 obstruction to a uniformly tiny J/P moment.
# A={center(c[0]) in [-4096,4096]}; P(A)=8193/q exactly.
# P_actual(|x|>=4097 | norm accepted) <= E[x^2]/(4097^2*a_lower).
# Mod-q centered values can only increase A's mass relative to |x|<=4096.
cap_error=eps_pair_cap+eps_vector_cap
event_lower=1-RB(mean_coordinate_square)/(ZZ(4097)^2*RB(norm_accept_lower))-cap_error
honest_event=QQ(8193)/q
assert event_lower>RB(honest_event)
moment_gap_lower=(event_lower-RB(honest_event))^2/(RB(honest_event)*(1-RB(honest_event)))
assert moment_gap_lower>RB(1)/8

class DemoBits:
    def __init__(self, seed):
        self.seed=seed; self.counter=ZZ(0); self.bits=ZZ(0)
    def getbits(self,k):
        # k is byte-aligned in this implementation. Labels are public test data.
        assert k%8==0
        payload=self.seed+int(self.counter).to_bytes(16,'little')
        self.counter+=1; self.bits+=k
        return ZZ(int.from_bytes(hashlib.shake_256(payload).digest(int(k//8)),'little'))

def draw_coord(getbits):
    u=getbits(draw_bits)%total
    return ZZ(bisect.bisect_right(cdf,u))-cutoff

def draw_pair(getbits, max_tries=pair_cap):
    for attempt in range(max_tries):
        x=draw_coord(getbits); y=draw_coord(getbits)
        v=getbits(precision_bits)
        if v < accept[x+y+2*cutoff]:
            return (x,y), ZZ(attempt+1)
    return None, ZZ(max_tries)

F=GF(q); R=PolynomialRing(F,'z'); z=R.gen(); modulus=z^dim-z^(dim//2)+1

def polynomial_of_pairs(pairs):
    return R([a for a,b in pairs]+[b for a,b in pairs])

def sample_public(h, getbits, max_vectors=vector_cap, max_pairs=pair_cap):
    attempts=ZZ(0)
    for outer in range(max_vectors):
        values=[]; norm=ZZ(0)
        for j in range(blocks):
            pair, count=draw_pair(getbits,max_pairs); attempts+=count
            if pair is None:
                return {'challenge':R.zero(),'reply':None,'internal_reason':'PAIR_CAP',
                        'pair_proposals':attempts,'vectors':ZZ(outer+1)}
            x,y=pair; values.append(pair); norm+=x*x+x*y+y*y
        if norm < norm_limit:
            u=polynomial_of_pairs(values[:dim//2]); v=polynomial_of_pairs(values[dim//2:])
            challenge=(u+h*v)%modulus
            assert (u+h*v-challenge)%modulus == 0
            assert all(-32768<=t<=32767 for pair in values[dim//2:] for t in pair)
            return {'challenge':challenge,'reply':values[dim//2:],'first_half':values[:dim//2],
                    'norm':norm,'internal_reason':'SUCCESS','pair_proposals':attempts,'vectors':ZZ(outer+1)}
    return {'challenge':R.zero(),'reply':None,'internal_reason':'NORM_CAP',
            'pair_proposals':attempts,'vectors':ZZ(max_vectors)}

print('Synthetic FT1536 executions and forced terminal branches', flush=True)
samples=[]
for label,h in [('zero',R.zero()),('one',R.one()),('dense',R([F(i*i+17*i+1) for i in range(dim)]))]:
    bits=DemoBits(('FT1536-S05-PUBLIC-SYNTHETIC-'+label).encode())
    sample_start=time.monotonic()
    result=sample_public(h,bits.getbits)
    assert result['internal_reason']=='SUCCESS'
    samples.append({'fixture':label,'public_key_is_keygen_output':False,'elapsed_seconds':time.monotonic()-sample_start,
        'norm':str(result['norm']),'pair_proposals':int(result['pair_proposals']),
        'vectors':int(result['vectors']),'bits_consumed':str(bits.bits),
        'challenge_sha256':hashlib.sha256(str(result['challenge']).encode()).hexdigest(),
        'syndrome_identity_checked':True,'signed16_checked':True})
forced_pair=sample_public(R.one(),lambda k: ZZ(0),max_pairs=0)
forced_norm=sample_public(R.one(),lambda k: ZZ(0),max_vectors=0)
assert forced_pair['reply'] is None and forced_pair['internal_reason']=='PAIR_CAP'
assert forced_norm['reply'] is None and forced_norm['internal_reason']=='NORM_CAP'
# Exact pair rejection at the configured cap: x=y=cutoff, acceptance threshold zero.
def reject_bits(k):
    return cdf[-2] if k==draw_bits else scale-1
forced_actual=sample_public(R.one(),reject_bits)
assert forced_actual['internal_reason']=='PAIR_CAP' and forced_actual['pair_proposals']==pair_cap

# Check the norm-cap terminal branch at the configured (not zero) cap.
def norm_reject_bits(k):
    return cdf[1000+cutoff-1] if k==draw_bits else ZZ(0)
forced_actual_norm=sample_public(R.one(),norm_reject_bits)
assert forced_actual_norm['internal_reason']=='NORM_CAP' and forced_actual_norm['vectors']==vector_cap
assert forced_actual_norm['pair_proposals']==vector_cap*blocks

def sample_public_reply(h,getbits):
    result=sample_public(h,getbits)
    return result['challenge'],result['reply']

save('tables.json',{'sigma':str(sigma),'cutoff':str(cutoff),'precision_bits':int(precision_bits),
    'draw_bits':int(draw_bits),'weights':[str(v) for v in weights],
    'acceptance_thresholds':[str(v) for v in accept]})
save('certificate.json',{'status':'RIGOROUS_FINITE_ARITHMETIC_PLUS_TEXTUAL_TV_TRANSFER',
    'sigma':str(sigma),'q':str(q),'dimension':int(dim),'blocks':int(blocks),
    'norm_limit':str(norm_limit),'cutoff':str(cutoff),'ball_precision':512,
    'pair_cap':int(pair_cap),'vector_cap':int(vector_cap),
    'alpha_exact':str(alpha),'mean_block_norm_exact':str(mean_block_norm),'mean_coordinate_square_exact':str(mean_coordinate_square),
    'norm_accept_lower_exact':str(norm_accept_lower),
    'eps_scalar_exact':str(eps_scalar),'eps_pair_round_exact':str(eps_pair_round),
    'eps_pair_cutoff_ball':str(eps_pair_cutoff),'eps_conditioned_ball':str(eps_conditioned),
    'eps_pair_cap_ball':str(eps_pair_cap),'eps_vector_cap_ball':str(eps_vector_cap),
    'eta_ball':str(eta),'proved_numeric_comparison':'eta < 2^-90',
    'worst_random_bits':str(vector_cap*blocks*pair_cap*(2*draw_bits+precision_bits)),
    'worst_pair_proposals':str(vector_cap*blocks*pair_cap),
    'tv_target':'FT1536.PublicSimulation.publicJoint (SigmaMath.syndrome h), all public h',
    'second_moment_certificate':'NOT_ESTABLISHED; TV does not imply J/P moment',
    'keygen_or_source_binding':False,'kernel_verified_full_sampler':False,
    'h_zero_event_mass_lower_ball':str(event_lower),'h_zero_honest_event_exact':str(honest_event),'h_zero_moment_gap_lower_ball':str(moment_gap_lower),'h_zero_proved_comparison':'second(J_h0,P_h0)-1 > 1/8 for this candidate; not a theorem about all samplers',
    'elapsed_seconds':time.monotonic()-t0})
save('execution_checks.json',{'samples':samples,'forced_pair_cap_at_actual_limit':True,'forced_norm_cap_at_actual_limit':True,
    'zero_cap_control_branches':['PAIR_CAP','NORM_CAP'],
    'finite_modulo_tests':16,'challenge_bits_per_coefficient':int(challenge_bits),
    'challenge_remainder':str(rem),'challenge_single_second_exact':str(challenge_second),
    'challenge_joint_second_minus_one_lt':'2^-120','demo_rng':'SHAKE-256, public synthetic labels; NOT fair-bit law or PRG proof'})
print('PASS: certified tables, exact acceptance/moment, full-law TV eta < 2^-90; 3 synthetic executions',flush=True)
