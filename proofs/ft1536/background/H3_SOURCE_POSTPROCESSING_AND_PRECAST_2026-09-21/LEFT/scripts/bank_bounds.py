"""Actual first-success bank inequalities, paired weighting and terminal A2 defect."""
import json,re,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,ZZ,PolynomialRing
from dyadic import value
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';U=QQ(1)/2**48;eta=QQ(1)/2**900;eps=QQ(1)/2**40;epspair=QQ(1)/2**39
n=json.loads((I/'NORMALIZED/WIDTH_BOUNDS.json').read_text());Dlo=QQ(n['gate']['D_min']);Dhi=QQ(n['gate']['D_max'])
text=(W/'source/ft1536-adaptive-cdf-tables.h').read_text();block=text.split('ft_adaptive_cdf_inv_2sigma0_sq_bits',1)[1].split('};',1)[0]
bits=[int(x,16) for x in re.findall(r'UINT64_C\(0x([0-9a-fA-F]+)\)',block)]
def qv(w):v=value(w);return QQ(v.numerator)/v.denominator
coeff=list(map(qv,bits));pairs=[tuple(map(int,p)) for p in re.findall(r'\{\s*(\d+)u,\s*(\d+)u\s*\}',text.split('ft_adaptive_cdf[',1)[1])]
supports=[sum(a!=0 or b!=0 for a,b in pairs[512*j:512*(j+1)]) for j in range(5)];assert supports==[29,59,118,235,365]
assert all(coeff[j]>coeff[j+1]>0 for j in range(4))
# Actual dss error is sandwiched relative to 1/(2 S^2); S^2 in(1,1024).
assert (1-U)/((1+U)**2+QQ(1)/2**790)-2048*eta>1-eps
assert (1+U)/((1-U)**2-QQ(1)/2**790)+2048*eta<1+eps
# Actual D*S0^2 and D*S1^2; source sqrt/div/mul enclosures and exact IW1I.
assert ((1+U)/(1-U))**2+QQ(1)/2**780<1+eps
assert ((1-U)/(1+U))**2-QQ(1)/2**780>1-eps
iw=QQ(n['IW1I']['value']);assert iw**2*(1+eps)*(1+2*U)**2<QQ(4)/3*(1+epspair)
assert iw**2*(1-eps)*(1-2*U)**2>QQ(4)/3*(1-epspair)
records=[];maxima={}
for kind,factor,inflation in [('stored',QQ(1),eps),('paired',QQ(4)/3,epspair)]:
 vlow=QQ(n[kind]['real_square_lower']);vhigh=QQ(n[kind]['real_square_upper']);prod_hi=QQ(768)**2*factor*(1+inflation);prod_lo=QQ(768)**2*factor*(1-inflation)
 rows=[]
 for j,k in enumerate(supports):
  lo=vlow if j==0 else max(vlow,(1-eps)/(2*coeff[j-1]));hi=min(vhigh,(1+eps)/(2*coeff[j]))
  assert 0<lo<hi
  R=QQ(k+1)+QQ(1)/2**20;energy=min(Dhi*R**2,prod_hi*R**2/lo)
  row=dict(width_class=kind,bank=j,support=k,coefficient_bits=f'{bits[j]:016x}',coefficient=str(coeff[j]),
   failed_previous_coefficient=None if j==0 else str(coeff[j-1]),variance_lower=str(lo),variance_upper=str(hi),lower_strict=True,upper_inclusive=True,
   inference='first successful ge: dss>=a_j and, for j>0,dss<a_(j-1); source relative dss error explicitly included',
   D_sigma_squared_lower=str(prod_lo),D_sigma_squared_upper=str(prod_hi),normal_scalar_residual_abs=str(R),D_residual_squared_upper=str(energy),snapshot='after scalar normal return, current NumericCenter already established',
   source_PC='sampler_large2866; selector2808-2822; terminal1633-1648',domain='Emitted normalized stored/paired width, selected bank j, legal normal-return prefix after current center proof',
   dependencies=['NORMALIZED/WIDTH_BOUNDS.json','ORDERED/SCALAR_OUTCOMES.md','source adaptive coefficient/table bytes','source dss relative-error enclosure'],discharge='PROVED_BY_SOURCE_COMPARISON_AND_EXACT_ERROR_INEQUALITIES')
  rows.append(row);records.append(row)
 maxima[kind]=max(QQ(r['D_residual_squared_upper']) for r in rows)
half_last_defect=QQ(1)/2**37
assert U*(367+184)+2*eta+QQ(1)/2**1023<half_last_defect
R=QQ(366)+QQ(1)/2**20;cross=Dhi*(2*R*half_last_defect+half_last_defect**2)
terminal=maxima['stored']+QQ(3)/4*maxima['paired']+cross;terminal_integer=ZZ(terminal.ceil())
P=PolynomialRing(QQ,names=['a','b','d']);a,b,d=P.gens();r0=a-b/2+d
assert r0*r0+r0*b+b*b==(a+d)**2+QQ(3)/4*b*b
out=dict(schema='FT1536_SOURCE_BANK_WEIGHTED_V1',status='PASS_SOURCE_BANK_AND_TERMINAL_WEIGHT_ENCLOSURES',source_pin=sha(I/'CANDIDATE.sha256'),
 width_certificate_sha256=sha(I/'NORMALIZED/WIDTH_BOUNDS.json'),dss_relative_epsilon=str(eps),stored_D_sigma_relative_epsilon=str(eps),paired_D_sigma_relative_epsilon=str(epspair),
 gate=dict(D_min=str(Dlo),D_max=str(Dhi)),coefficients=[dict(bits=f'{w:016x}',value=str(a)) for w,a in zip(bits,coeff)],records=records,
 maxima={k:str(v) for k,v in maxima.items()},terminal_half_last_sub_defect=str(half_last_defect),terminal_cross_allowance=str(cross),
 terminal_A2_energy_exact_upper=str(terminal),terminal_A2_energy_integer_upper=int(terminal_integer),right_768_terminal_budget=int(768*terminal_integer),
 terminal_identity='Q_A2(r0,r1)=(normal_residual0+half/last-sub defect)^2+3/4*normal_residual1^2',
 domain='Actual source selected banks and normalized stored/paired widths, after already established current NumericCenter and NORMAL_RETURN; no distribution assumption',
 paired_raw_squares_not_equally_weighted=True,all_P_key_gate_assumed=False)
(W/'BANK_WEIGHTED_BOUNDS.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:out[k] for k in ['status','maxima','terminal_A2_energy_integer_upper','right_768_terminal_budget','terminal_half_last_sub_defect']},indent=2))
