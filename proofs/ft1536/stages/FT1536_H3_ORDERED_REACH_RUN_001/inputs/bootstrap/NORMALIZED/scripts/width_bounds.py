"""Exact QQ/RBF source-error enclosures; no RN/legacy H4 premise."""
import json,re,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,ZZ,RealBallField,PolynomialRing
from dyadic import value,rn
from replaylib import sha
W=Path.cwd();U=QQ(1)/2**48;eta=QQ(1)/2**900;b=2*U;g=QQ(1)/2**40;tiny=QQ(1)/2**800
lowbits=0x4090000053700377;highbits=0x4114444d1a037d50
def qword(w):
 v=value(w);return QQ(v.numerator)/v.denominator
lo=qword(lowbits);hi=qword(highbits)
assert lo==QQ(4503601027220343)/4398046511104 and hi==QQ(356537342113749)/1073741824
header=(W/'source/fpr-emulated.h').read_text();c_bits=int(re.search(r'fpr_IW1I = 0x([0-9a-fA-F]+)ULL',header)[1],16);c=qword(c_bits)
assert c_bits==0x3ff279a74590331c and abs(c*c-QQ(4)/3)<QQ(1)/2**49
table=(W/'source/ft1536-adaptive-cdf-tables.h').read_text();block=table.split('ft_adaptive_cdf_inv_2sigma0_sq_bits',1)[1].split('};',1)[0]
bank=[int(x,16) for x in re.findall(r'UINT64_C\(0x([0-9a-fA-F]+)\)',block)];assert len(bank)==5;last=qword(bank[-1]);assert bank[-1]==0x3f45555555555555 and last<QQ(1)/1536
# Relative inflation of U|value|+eta in the explicitly established stable domains.
assert U+2**112*eta<b
ratios=[((1-b)**3,(1+b)**3),((1-b)**4/(1+b)**2,(1+b)**4/(1-b)**2),((1-b)**4/(1+b)**3,(1+b)**4/(1-b)**3),
 ((1-b),(1+b)),((1-b)**2/(1+b),(1+b)**2/(1-b))]
for a,z in ratios:assert 1-g<a and z<1+g
primary_lo=QQ(1)/2*(1-g)**9;primary_hi=QQ(2**23)*(1+g)**9
assert primary_lo>QQ(1)/4 and primary_hi<2**24
q2=QQ(18433**2);recip_lo=q2/2**24*(1-b);recip_hi=q2/(QQ(1)/4)*(1+b)
assert recip_lo>QQ(1)/4 and recip_hi<2**31
assert QQ(3)/4*(1-b)**3>QQ(1)/2 and 3*QQ(2)**46*(1+b)**3<2**48
assert 3*QQ(2)**69*(1+b)**3<2**72 and 2*QQ(2)**48*(1+b)<2**50
assert 2**72<2**100 and 2**48<2**80 and QQ(1)/2>QQ(1)/2**16
assert (1-U)**2/4>QQ(1)/16 and (1+U)**2*2**31<2**32
assert QQ(768)*(1-U)/2**16-eta>QQ(1)/128 and QQ(3072)*(1+U)+eta<4096
assert c*(1-U)/128-eta>QQ(1)/128 and c*(1+U)*4096+eta<8192
assert 2*QQ(1)/128**2*(1-U)**2-tiny>QQ(1)/2**16 and 2*QQ(8192)**2*(1+U)**2+tiny<2**28
# Sqrt kernel floor+sticky+pack gives relative error <=2^-52, relaxed to U here.
assert QQ(4)/2**54<=U
stored_lo=QQ(768**2)/hi*((1-U)/(1+U))**2-tiny
stored_hi=QQ(768**2)/lo*((1+U)/(1-U))**2+tiny
paired_lo=c*c*stored_lo*(1-U)**2-tiny
paired_hi=c*c*stored_hi*(1+U)**2+tiny
assert stored_lo>QQ(17763)/10000 and stored_hi<QQ(5759999)/10000
assert paired_lo>QQ(23684)/10000 and paired_hi<QQ(7679999)/10000
assert stored_lo>=QQ(17203)/10000 and stored_hi<QQ(59519)/100
assert paired_hi<768
def outward_sqrt(a,upper):
 scale=ZZ(2)**96;k=ZZ((a*scale**2).floor()).isqrt()
 assert QQ(k)**2<=a*scale**2 and a*scale**2<(k+1)**2
 return QQ(k+int(upper))/scale
def bit_interval(a,z):
 from fractions import Fraction
 wl=rn(Fraction(int(a.numerator()),int(a.denominator())));wh=rn(Fraction(int(z.numerator()),int(z.denominator())))
 if qword(wl)>a:wl-=1
 if qword(wh)<z:wh+=1
 assert qword(wl)<=a<=z<=qword(wh)
 return dict(lower=f'{wl:016x}',upper=f'{wh:016x}')
def enclosure(low,high):
 sl=outward_sqrt(low,False);sh=outward_sqrt(high,True)
 # |sigma|<4096 makes the eta cross terms far smaller than tiny.
 assert sh<4096 and 2*4096*eta+eta**2<tiny
 denlo=2*low*(1-U)**2-tiny;denhi=2*high*(1+U)**2+tiny
 dl=(1-U)/denhi-eta;dh=(1+U)/denlo+eta
 assert QQ(1)/2**16<denlo and denhi<2**80 and dl>last and dl>QQ(1)/1536
 return dict(real_square_lower=str(low),real_square_upper=str(high),value_lower=str(sl),value_upper=str(sh),word_interval=bit_interval(sl,sh),
  dss_denominator_lower=str(denlo),dss_denominator_upper=str(denhi),dss_lower=str(dl),dss_upper=str(dh),dss_word_interval=bit_interval(dl,dh),
  last_coefficient_margin=str(dl-last),margin_above_one_over_1536=str(dl-QQ(1)/1536))
stored=enclosure(stored_lo,stored_hi);paired=enclosure(paired_lo,paired_hi)
# Exact positivity/range identities for top weighted means and harmonic binary step.
P=PolynomialRing(QQ,names=['m','x','y','z','M']);m,x,y,z,M=P.gens();a=m+x;bb=m+y;cc=m+z
assert a*bb+a*cc+bb*cc-m*(a+bb+cc)==m*(x+y+z)+x*y+x*z+y*z
assert 2*a*bb-m*(a+bb)==m*(x+y)+2*x*y
R=RealBallField(256)
out=dict(schema='FT1536_SOURCE_WIDTH_BOUNDS_V1',status='PASS_EXACT_SOURCE_ERROR_ENCLOSURES',source_manifest_sha256=sha(W/'inputs/bootstrap/CANDIDATE.sha256'),
 U=str(U),eta=str(eta),sqrt_relative_error_bound=str(QQ(1)/2**52),scope='All source-gated emitted stable leaves, using sqrt54 integer invariant and source div/mul error contracts; no legacy RN assumption',
 gate=dict(min_bits=f'{lowbits:016x}',max_bits=f'{highbits:016x}',D_min=str(lo),D_max=str(hi),inclusive=True),
 stored=stored,paired=paired,IW1I=dict(bits=f'{c_bits:016x}',value=str(c),real_square=str(c*c)),
 summary=dict(stored_square=['1.7763','575.9999'],paired_square=['2.3684','767.9999'],historical_H4_reestablished=True,paired_variance_strictly_below768=True,
  all_dss_ge_actual_last_coefficient=True,stored_square_RBF=[str(R(stored_lo)),str(R(stored_hi))],paired_square_RBF=[str(R(paired_lo)),str(R(paired_hi))]),
 selector=dict(coefficients_bits=[f'{v:016x}' for v in bank],last_value=str(last),found_for_both_width_classes=True,sigma_only=True,PRNG_or_sampler_prefix_execution_claimed=False),
 extended_div=dict(numerator_abs_cap='2^100',positive_normal_denominator=['2^-16','2^80'],relative_plus_absolute_error='U*abs(x/y)+eta',numerator_subnormal_error_upper='2^-1006',pack_exponent_upper=1141),
 broad_P_key=dict(computation_defined=True,stable_gate_acceptance_proved=False,gate_status='OPEN; not in P_key and not derived from broad positive bounds',
  root=['1/2','2^23'],per_level_relative=str(g),top_ratio_bounds=[dict(lower=str(a),upper=str(z)) for a,z in ratios[:3]],
  binary_ratio_bounds=[dict(lower=str(a),upper=str(z)) for a,z in ratios[3:]],primary_lower=str(primary_lo),primary_upper=str(primary_hi),
  reciprocal_lower=str(recip_lo),reciprocal_upper=str(recip_hi),all_stable_leaves=['1/4','2^31'],intermediate_scalar_upper='2^72',largest_stable_divisor_upper='2^48',
  normalized_stored_value=['1/128','4096'],normalization_runs_when_gate_fails=True),
 square_root_model='N=a*2^54;54 binary trials; q^2<=N<(q+1)^2; final xu=2*(N-q^2); guard/sticky and FPR pack error<=4 units')
(W/'WIDTH_BOUNDS.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],summary=out['summary'],stored_word_interval=stored['word_interval'],paired_word_interval=paired['word_interval'],broad_definedness=True,all_P_key_gate=False),indent=2))
