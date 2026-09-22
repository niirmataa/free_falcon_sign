assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024
import json,os
from pathlib import Path
W=Path(os.environ['FT_REVIEW_W']);O=Path(os.environ['FT_REVIEW_OUTPUT']);S=W/'inputs/campaign'
rows=json.loads((S/'artifacts/model_eq234.json').read_text())['rows']
surface=json.loads((S/'artifacts/rc_cost_surface.json').read_text())['rows']
I=RealIntervalField(384);piI=I.pi();eI=I(1).exp();ln2=I(2).log()
def dq(s):
    a,sep,e=str(s).lower().partition('e');e=ZZ(e) if sep else 0
    left,dot,right=a.partition('.');return QQ(ZZ(left+right))/10^len(right)*10^e
checks=[]
for r in rows:
    b=ZZ(r['block']);d=ZZ(r['d']);L=(I(b)/(2*piI*eI)).log()
    df=(L/(2*b)).exp()
    de=((L+(piI*b).log()/b)/(2*(b-1))).exp()
    assert abs(df-I(dq(r['delta_falcon']))).upper()<I(1)/10^38
    assert abs(de-I(dq(r['delta_estimator']))).upper()<I(1)/10^38
    exponent=dq('0.270188776350190')*b*I(b).log()+dq('-1.0192050451318417')*b+dq('16.10253135200765')+I(100).log()/ln2
    repeat=8*d if b<d else 1
    enum_bits=exponent+I(repeat).log()/ln2
    lll_bits=3*I(d).log()/ln2
    # Log-sum-exp, without introducing binary64 overflow.
    base=enum_bits if enum_bits.lower()>lll_bits.upper() else lll_bits
    other=lll_bits if enum_bits.lower()>lll_bits.upper() else enum_bits
    total=base+(1+((other-base)*ln2).exp()).log()/ln2
    assert abs(total-I(dq(r['lambda_enum_CN12']))).upper()<I(1)/10^38
    sr=next(x for x in surface if x['scheme']==r['scheme'] and x['attack']==r['attack'] and x['variant']==r['variant'] and x['cost_model']=='CheNgu12')
    assert abs(total-I(str(sr['log2_rop_+0']))).upper()<I(1)/10^8
    checks.append({'scheme':r['scheme'],'attack':r['attack'],'variant':r['variant'],
                   'delta_falcon_agrees':True,'delta_estimator_agrees':True,'CN12_agrees':True})
O.mkdir(parents=True,exist_ok=True)
(O/'field_audit.json').write_text(json.dumps({'mode':'sage field_audit.sage','rows':checks,'scope':'numeric arithmetic of declared delta/CN12 formulas, not validity of attack assumptions'},indent=2,sort_keys=True)+'\n')
print('PASS_12_DELTA_AND_CN12_FIELD_CHECKS')
