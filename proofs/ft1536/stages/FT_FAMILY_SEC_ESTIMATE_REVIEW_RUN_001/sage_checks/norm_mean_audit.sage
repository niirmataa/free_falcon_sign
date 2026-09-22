assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024
import os,json
from pathlib import Path
W=Path(os.environ['FT_REVIEW_W']);O=Path(os.environ['FT_REVIEW_OUTPUT'])
rows=json.loads((W/'inputs/campaign/artifacts/subfield_normdown.json').read_text())['rows']
out=[]
# w=X^(N/2) satisfies w^2-w+1=0; reduce six powers independently of Ramanujan.
powers=[(1,0),(0,1),(-1,1),(-1,0),(0,-1),(1,-1)]
for row in rows:
    N=ZZ(row['N']);u=ZZ(row['u']);h=N//2
    mean=[QQ(0) for i in range(N)]
    for i in range(N):
        t=((1+u)*i)%(3*N);block,rest=divmod(t,h);a,b=powers[block]
        mean[rest]+=QQ(2)/3*a;mean[rest+h]+=QQ(2)/3*b
    mean_q=sum(mean[i]^2+mean[i]*mean[i+h]+mean[i+h]^2 for i in range(h))
    second=QQ(row['E_QA2_norm_exact']);centered=second-mean_q
    assert centered>=0
    if u==3*N-1:
        assert mean[0]==2*N/3 and all(x==0 for x in mean[1:])
        assert mean_q==(2*N/3)^2
    out.append({'N':int(N),'u':int(u),'Q_of_mean':str(mean_q),'second_moment':str(second),
                'centered_trace_variance':str(centered),'mean_is_nonzero':bool(mean_q>0),
                'declared_sigma_squared_RMS':str(2*second/N),'centered_equivalent_squared':str(2*centered/N)})
O.mkdir(parents=True,exist_ok=True)
(O/'norm_mean_audit.json').write_text(json.dumps({'mode':'sage norm_mean_audit.sage','rows':out,
 'scope':'RAW moments: author sigma is RMS-derived, not generally centered standard deviation; does not construct an attack or certify the subfield model'},indent=2,sort_keys=True)+'\n')
print('PASS_NORM_MEAN_AND_RMS_DISTINCTION')
