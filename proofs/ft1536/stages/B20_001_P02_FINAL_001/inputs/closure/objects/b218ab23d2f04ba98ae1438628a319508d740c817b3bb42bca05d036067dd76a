"""Exact CDF atom counts, small source acceptance floor, pointer accounting."""
import json,re
from fractions import Fraction as Q
from pathlib import Path
from kernel_model import constants,schedule
from dyadic import value
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';banks,coefs,C=constants(W);R=2**128;U=Q(1,2**48);eta=Q(1,2**900);rows=[]
formal=(W/'formal/CDF.lean').read_text()
for j,T in enumerate(banks):assert list(map(int,re.search(r'def bank'+str(j)+r' : List Nat := \[([^]]*)\]',formal)[1].split(',')))==T
for j,T in enumerate(banks):
 assert len(T)==512 and all(0<=t<R for t in T) and all(a>=b for a,b in zip(T,T[1:]))
 M=[a-b for a,b in zip([R]+T,T+[0])];assert min(M)>=0 and sum(M)==R
 support=max(k for k,m in enumerate(M) if m);assert support==[29,59,118,235,365][j]
 assert all(t==0 for t in T[support:]);rows.append(dict(bank=j,coefficient_bits=f'{coefs[j]:016x}',thresholds=list(map(str,T)),mass_numerators=list(map(str,M)),denominator=str(R),support=support,positive_atoms=sum(m>0 for m in M),zero_thresholds=sum(t==0 for t in T),duplicates=sum(a==b for a,b in zip(T,T[1:])),p0=str(Q(M[0],R))))
out=dict(schema='IID_CDF_MASS_V1',status='PASS_EXACT_INTEGER_INTERVAL_COUNTS',banks=rows,common_U128=True,strict_comparison=True,threshold_source_sha256=sha(W/'source/ft1536-adaptive-cdf-tables.h'))
(W/'CDF_MASS.json').write_text(json.dumps(out,indent=2)+'\n')
width=json.loads((I/'NORMALIZED/WIDTH_BOUNDS.json').read_text())
for kind in ['stored','paired']:assert Q(width[kind]['dss_lower'])>value(coefs[-1]) and Q(width[kind]['dss_upper'])<1
# r in[0,1]; select b=0 if r<=1/2, else source sub(1,r), allowing source error.
d=Q(1,2)+2*U+eta;square=(1+U)*d*d+eta;tail=(1+U)*(eta+square)+eta
x=(1+U)*(eta+(1+U)*tail+eta)+eta;scaled=(1+U)*x*value(0x3ff71547652b82fe)+eta
assert x<Q(1,3) and scaled<Q(1,2)
rB=(1+U)*x+2*eta;v=(1+U)*rB*2**63+eta
assert rB<Q(1,3) and v<2**62
# In this small nonnegative domain, literal trunc is mathematical floor, z<=2^63.
assert 0<C[0] and all(a<=b for a,b in zip(C,C[1:])) and C[-1]==2**63 and C[-2]<2**63
intervals=[dict(index=0,lower=C[0],upper=C[0])]
for i in range(1,13):
 lower=C[i]-(C[i-1]//2);upper=C[i];assert 0<=lower<=upper<=2**63
 intervals.append(dict(index=i,lower=lower,upper=upper))
Ymin=intervals[-1]['lower'];Zmin=Ymin//256;assert Zmin>=2**54
pmin=min(Q(b['p0']) for b in rows);exactfloor=pmin*Q(1,2)*Q(Zmin,2**55);amin=Q(1,256);assert pmin>Q(1,64) and exactfloor>amin
floor=dict(schema='IID_ACCEPTANCE_FLOOR_V1',status='PASS_UNIFORM_SOURCE_POSITIVE_ATOM',domain='all NumericCenter raw mu and certified normalized stored/paired widths; local dss<1 and found bank',chosen_atom='k=0; b=0 when r<=1/2 else b=1',small_delta_cap=str(d),source_x_cap=str(x),BerExp_scaled_cap=str(scaled),BerExp_exponent=0,source_rB_cap=str(rB),scaled_trunc_input_cap=str(v),scaled_trunc_input_below='2^62',z_upper=str(2**63),horner_coefficients=list(map(str,C)),horner_intervals=intervals,expm_lower=str(Ymin),Z_lower=str(Zmin),Beta_lower=str(Q(Zmin,2**55)),proposal_k0_lower=str(pmin),bit_probability='1/2',exact_rational_acceptance_lower=str(exactfloor),a_min=str(amin),mean_proposals_upper=256,exponential_accuracy_assumed=False,source_width_certificate_sha256=sha(I/'NORMALIZED/WIDTH_BOUNDS.json'))
floor['game']='IID_BUFFER';floor['conditioning']='legal PAST, excluding unread buffer and future tape'
(W/'ACCEPTANCE_FLOOR.json').write_text(json.dumps(floor,indent=2)+'\n')
schedules=[schedule(p) for p in range(4096)]
for row in schedules:
 p=row['start'];end=row['end'];Rr=row['refills'];dd=row['discarded'];assert 8<=end<=4094 and Rr in [0,1] and 0<=dd<=9*Rr and p+33+dd==4096*Rr+end
 assert row['events'][2]['after']!=0
data=dict(schema='IID_BYTE_SCHEDULE_V1',status='PASS_ALL_4096_ENTRY_POINTERS',proposal_getters=[8,8,1,8,8],returned_per_proposal=33,cutoff=4087,per_proposal_refills_max=1,drop_per_refill_max=9,post_proposal_pointer=[8,4094],conservation='p+33*n+D=4096*R+p_final',n_proposal_refill_bound='R<=min(n,1+floor(33*n/4087)) for n>=1',generated_bytes='4096*R new bytes; entry block accounted separately',schedules=schedules)
(W/'BYTE_SCHEDULE.json').write_text(json.dumps(data,indent=2)+'\n');print(json.dumps(dict(status='PASS_EXACT_CDF_ACCEPTANCE_FLOOR_AND_SCHEDULE',supports=[r['support'] for r in rows],p0_min=str(pmin),Z_min=str(Zmin),a_min=str(amin),mean_upper=256,all_ptrs=4096),indent=2))
