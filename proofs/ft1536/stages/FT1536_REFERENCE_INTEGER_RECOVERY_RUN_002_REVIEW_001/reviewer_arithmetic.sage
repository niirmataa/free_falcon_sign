# Independent reviewer calculation from pinned source input JSON; sage preparser required.
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024
import json
import os
from pathlib import Path
W = Path(os.environ['REVIEW_W'])
root = W/'inputs/subject/inputs/bootstrap'
old = root/'T03/inputs/bootstrap'
ledger = json.loads((root/'T03/checks/gap_composition.json').read_text())
post = json.loads((old/'POST/artifacts/numeric_certificate.json').read_text())
target = json.loads((old/'TARGETS/INITIAL_TARGET_CERTIFICATE.json').read_text())
claimed = json.loads((W/'inputs/subject/artifacts/BUDGET_ANALYSIS.json').read_text())
terms = {k:QQ(v['exact']) for k,v in ledger['terms_per_coefficient'].items()}
names = ['A1_challenge_fft_words','A2_det_error_x_challenge','A3_target_rounding_layer',
         'A4_word_errors_x_target','B_word_residuals_x_Z','C1_tree_reconstruction_pinned',
         'C2_terminal_box','C3_defect_x_word_errors','D_suffix_CM_add','E_ifft']
R = RealIntervalField(256)
def upper_sqrt(x):
    a=QQ(R(x).sqrt().upper().exact_rational())
    assert a*a>=x
    return a
def confirm(name,value):
    assert value == QQ(claimed[name]['exact']), name
    return {'exact':str(value),'interval':str(R(value))}
out = {'historical_majorant':confirm('historical_majorant',sum(terms[n] for n in names))}
assert sum(terms[n] for n in names)==terms['TOTAL_gap_bound']
assert sum(terms[n] for n in names[:4])==terms['A_total_refined']
ablation=sum(terms[n] for n in (names[0],names[2],names[8],names[9]))
out['three_family_ablation_majorant']=confirm('three_family_ablation_majorant',ablation)
U=QQ(1)/2^48; eta=QQ(1)/2^900
X=QQ(post['sampling_return']['returned_x_cap']); Y=QQ(post['sampling_return']['right_y_cap'])
bs=QQ(post['suffix']['basis_small_cap']); bL=QQ(post['suffix']['basis_large_cap'])
P=(1+6*U)*X*bs+8*eta; Q=(1+6*U)*Y*bL+8*eta
epost=6*U*(X*bs+Y*bL)+16*eta+U*(P+Q)+2*eta
assert epost==QQ(post['suffix']['each_source_CM_add_error'])
assert X<2^35 and Y<2^27 and P+Q<2^49
out['epost']=confirm('epost_recomputed_from_source_contract_formula',epost)
D=upper_sqrt(QQ(4)/3)*epost
out['D_per_vector']=confirm('D_per_vector_conditional',D)
assert upper_sqrt(QQ(8)/3)*epost==terms['D_suffix_CM_add']
rho=[QQ(t['rounding_only_error_norm']) for t in target['targets']]
assert rho[0]<=QQ(1)/8192 and rho[1]<=QQ(1)/2^24
A3=upper_sqrt(QQ(4)/3)*(rho[0]*bs+rho[1]*bL)
out['A3_full_rho']=confirm('A3_raw_conditional',A3)
out['conditional_residual']=confirm('A1_A3raw_Dpervector_E_conditional',terms[names[0]]+A3+D+terms[names[9]])
assert sum([QQ(1)/1000,QQ(1)/10,QQ(1)/20,QQ(1)/10,QQ(1)/10,QQ(1)/1000,QQ(1)/20,QQ(1)/128])==QQ(6557)/16000<QQ(1)/2
assert D>11 and A3>QQ(1)/20
# Two local dyadics, independently parsed into exact QQ; algebra is frame-specific.
C=json.loads((W/'inputs/subject/artifacts/C_SLICES_CHECK.json').read_text())
assert [QQ(x['old_target_defect']) for x in C['terminal']]==[-QQ(1)/33554432,QQ(1)/33554432]
assert all(QQ(x['old_target_defect'])==QQ(x['update_add_error']) and QQ(x['sub_and_half_errors'])==0 for x in C['terminal'])
# Independent decoding of raw literal C words, not merely trusting its JSON summary.
raw=(W/'inputs/subject/run/final_002/build/C_SLICES.ndjson').read_text().splitlines()
rows=[json.loads(line) for line in raw]
ts=[r for r in rows if r['case']=='terminal']; rs=[r for r in rows if r['case']=='rint']
assert len(ts)==3 and len(rs)==27 and len(rows)==3+27+1536
def val(hexword):
    w=ZZ(hexword,16); exp=(w>>52)&2047; fraction=w&(2^52-1)
    assert exp!=2047
    return (-1)^(w>>63)*(fraction*QQ(1)/2^1074 if exp==0 else (2^52+fraction)*2^ZZ(exp-1075))
for i,sign in [(0,-1),(1,1)]:
    row=ts[i]
    t0=sign*(-2^29) # i=0: +2^29; i=1: -2^29
    rx=val(row['rx_recomputed']); mu=val(row['mu0']); sub=val(row['sub0_recomputed']); z0=val(row['z0'])
    assert val(row['z1'])/2==rx
    assert sub==mu-t0 and z0==sub-rx
    assert z0==mu-(t0+rx)==sign/2^25
for row in rs:
    x=val(row['word']); n=floor(x); f=x-n
    nearest=n if f<1/2 or (f==1/2 and n%2==0) else n+1
    assert ZZ(row['result'])==nearest
out['raw_C_oracle']={'terminal_dyadics':['-1/33554432','1/33554432'], 'rint_local_cases':int(27),'suffix_scalar_rows':int(1536)}
P0=PolynomialRing(QQ,names=('t','z','rx','ea','es','el','stale'))
t,z,rx,ea,es,el,stale=P0.gens()
assert ((t+rx+ea-z+es)-rx+el)-(t-z)==ea+es+el
assert ((t+rx+ea-z+es)-stale+el)-(t-z)==ea+es+el+(rx-stale)
assert ea+es+el!=es+el
assert QQ(1)^2+QQ(1)^2>QQ(1)^2 # component != complex modulus
# Independently expand both ten-slot root-space coordinates using lambda*q=cw.
PR=PolynomialRing(QQ,names=('la','q','c','wg','wf','wG','wF','g','f','G','F','a','b','r0','r1','k0','k1','u0','u1','d','e'))
la,q,c,wg,wf,wG,wF,g,f,G,F,a,b,r0,r1,k0,k1,u0,u1,d,e=PR.gens()
cw=la*q; t0=la*wF+r0; t1=-la*wf+r1
x=t0-a+k0+u0; y=t1-b+k1+u1
def coord(b0,b1,z0,z1,first):
    delta0=b0-z0;delta1=b1-z1
    A1=cw-c if first else PR.zero()
    A2=la*(wg*wF-wf*wG-q) if first else PR.zero()
    A3=r0*b0+r1*b1;A4=-t0*delta0-t1*delta1
    B=(t0-a)*delta0+(t1-b)*delta1
    C1=k0*z0+k1*z1; C2=u0*z0+u1*z1
    C3=(k0+u0)*delta0+(k1+u1)*delta1
    return A1+A2+A3+A4+B+C1+C2+C3+d+e
assert x*wg+y*wG+d+e-(c-a*g-b*G)==coord(wg,wG,g,G,True)
assert y*wF+x*wf+d+e-(-a*f-b*F)==coord(wf,wF,f,F,False)
out['ledger_polynomial']='both root-space coordinates, 10 signed slots, second y*w11+x*w01; A_total excluded'
out['scope']='exact rational majorant comparisons, conditional; no source bound or required-domain membership'
(W/'output/REVIEW_SAGE.json').write_text(json.dumps(out,indent=2,sort_keys=True)+'\n')
print('REVIEW_ARITHMETIC_PASS',*[k for k in out])
