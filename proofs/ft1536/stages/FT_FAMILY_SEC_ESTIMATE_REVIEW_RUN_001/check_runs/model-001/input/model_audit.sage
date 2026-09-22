# Independent reconstruction of the DECLARED heuristic geometry, not hardness.
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024
import os,json,sys
from pathlib import Path
from sage.env import SAGE_VERSION
W=Path(os.environ['FT_REVIEW_W']);O=Path(os.environ['FT_REVIEW_OUTPUT'])
S=W/'inputs/campaign';O.mkdir(parents=True,exist_ok=True)
data=json.loads((S/'artifacts/model_eq234.json').read_text())
params=json.loads((S/'inputs/family/parameters_family.json').read_text())
I=RealIntervalField(384)
piI=I.pi();eI=I(1).exp();ln2=I(2).log()
logs={}
def L(b):
    b=ZZ(b)
    if b not in logs:logs[b]=(I(b)/(2*piI*eI)).log()
    return logs[b]
def sign(v):
    if v.lower()>0:return 1
    if v.upper()<0:return -1
    raise ArithmeticError('interval straddles zero')
def key_beta(n,q,sigma2):
    for b in range(100,2*ZZ(n)+1):
        gap=2*(1-QQ(n)/b)*L(b)+I(q).log()-I(QQ(3)*b/4).log()-I(sigma2).log()
        if sign(gap)>0:return ZZ(b)
    return None
def forgery_beta(n,q,radius2,a2):
    detlog=I(q).log()+(I(QQ(3)/4).log()/2 if a2 else 0)
    for b in range(100,2*ZZ(n)+2):
        gap=2*QQ(n)/b*L(b)+detlog-I(radius2).log()
        if sign(gap)<0:return ZZ(b)
    return None
def unique_floor(x):
    a=x.lower().floor();b=x.upper().floor();assert a==b
    return ZZ(a)
def dq(s):
    m,sep,ex=str(s).lower().partition('e');ex=ZZ(ex) if sep else ZZ(0)
    neg=m.startswith('-');m=m.lstrip('+-');a,d,b=m.partition('.')
    return (-1 if neg else 1)*QQ(ZZ((a or '0')+b))/10^len(b)*10^ex

rows=[]
for r in data['rows']:
    n=ZZ(r['n']);q=ZZ(r['q']);isft=r['family']=='FT'
    if r['attack']=='key_recovery':
        sigma2=QQ(2)/3 if isft else (QQ(117)/100)^2*q/(2*n)
        beta=key_beta(n,q,sigma2)
    else:
        if isft:
            sig2=QQ(768)^2*(QQ(n)/1536 if r['variant']=='V_B_sqrtN_scaled' else 1)
            B=floor((QQ(43)/40)^2*2*n*sig2);assert B==r['B']
            radius2=B-1
        else:
            eps_inv=I(max(2,int(n)>>2)*2^64).sqrt()
            sig2=(I(4*n)*(1+eps_inv)).log()/(2*piI^2)*(QQ(117)/100)^2*q
            rad=unique_floor((I(QQ(121)/100)*2*n*sig2).sqrt())
            assert str(rad)==r['radius'];radius2=rad^2
        beta=forgery_beta(n,q,radius2,isft)
    assert beta==r['block'],r
    df=unique_floor(I(beta)*I(QQ(4)/3).log()/L(beta)+I(1)/2)
    assert beta-df==r['block_d4f']
    cl=QQ(292)/1000*beta;qu=QQ(265)/1000*beta
    assert dq(r['lambda_sieve_0.292'])==cl and dq(r['lambda_bdgl_0.265'])==qu
    rows.append({'scheme':r['scheme'],'attack':r['attack'],'variant':r['variant'],
                 'beta':int(beta),'beta_d4f':int(beta-df),'classical_core_svp':str(cl),
                 'quantum_core_svp':str(qu),'all_integer_thresholds_confirmed':True})

# Subfield moments via Newton sums of Phi, independently of author's Mobius code.
sub=json.loads((S/'artifacts/subfield_normdown.json').read_text())['rows']
moments=[]
for N in (768,1536,3072):
    N=ZZ(N);m=3*N;half=N//2;p=[N]
    for k in range(1,m):
        value=ZZ(0)
        if k<=N:
            if k>half:value+=p[k-half]
            if k==half:value+=k
            if k==N:value-=k
        else:value=p[k-half]-p[k-N]
        p.append(value)
    def corr(a):
        return sum((N-abs(d))*p[(a*d)%m] for d in range(-(N-1),N))
    for r in [r for r in sub if r['N']==N]:
        u=ZZ(r['u']);assert gcd(u,m)==1 and u^2%m==1 and u!=1
        E=((QQ(2)/3)^2*(N^3+corr(1-u)+corr(1+u))+(QQ(2)/3-3*(QQ(2)/3)^2)*N^2)/N
        assert E==QQ(r['E_QA2_norm_exact'])
        sig2=2*E/N
        wrong=key_beta(N,18433,sig2)
        corrected=key_beta(N//2,18433,sig2)
        assert (int(wrong) if wrong is not None else None)==r['beta_subfield_eq23']
        moments.append({'N':int(N),'u':int(u),'exact_moment_confirmed':True,
                        'moment':str(E),'declared_subfield_n':int(N//2),
                        'declared_subfield_dimension':int(N),
                        'actual_author_loop_n':int(N),
                        'author_beta':int(wrong) if wrong is not None else None,
                        'corrected_n_only_diagnostic_beta':int(corrected) if corrected is not None else None,
                        'author_beta_exceeds_declared_dimension':bool(wrong is not None and wrong>N)})

# Grid status/infinity metadata and literal cost-convention comparisons.
grid=[json.loads(x) for x in (S/'artifacts/ntru_grid.ndjson').read_text().splitlines()]
cells=[r for r in grid if 'scheme' in r]
empty=[{'scheme':r['scheme'],'cost_model':r['cost_model'],'shape':r['shape_model'],'status':r['status']} for r in cells if not r.get('attacks')]
infinite_only=[]
for r in cells:
    costs=[c.get('rop') for c in r.get('attacks',{}).values() if c.get('rop') is not None]
    if costs and all(str(c).lower() in ('inf','infinity','+infinity') for c in costs):
        infinite_only.append({k:r[k] for k in ('scheme','cost_model','shape_model','status')})
p1=next(r for r in rows if r['scheme']=='FT1536' and r['attack']=='key_recovery')
p2=next(r for r in rows if r['scheme']=='FT1536' and r['attack']=='forgery')
assert QQ(p1['classical_core_svp'])<QQ(p2['classical_core_svp'])
assert QQ(p1['quantum_core_svp'])<QQ(p2['quantum_core_svp'])
out={'sage_version':SAGE_VERSION,'mode':'sage model_audit.sage','scope':'arithmetic of the specified heuristic models; not a hardness or real-signature security theorem',
     'equation_rows_confirmed':rows,'subfield_rows':moments,'empty_cells_marked_OK':empty,
     'infinite_only_cells':infinite_only,'FT1536_weakest_on_declared_eq234_ruler':'P1, not P2',
     'multi_target_note':'union bound scales success probability; it does not imply cost_per_target * Q for any-target success',
     'grid_cells':int(len(cells)),'equation_rows':int(len(rows)),'moment_rows':int(len(moments))}
(O/'model_audit.json').write_text(json.dumps(out,indent=2,sort_keys=True)+'\n')
print('PASS_DECLARED_EQ234_AND_MOMENTS_WITH_DIMENSION_AND_REPORTING_FINDINGS')
print('equation rows',len(rows),'moment rows',len(moments),'empty cells',len(empty))
