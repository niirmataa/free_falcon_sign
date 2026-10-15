#!/usr/bin/env sage
# Auxiliary exact finite checks; no source/probability theorem premise.
import hashlib,json,re,sys
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
assert len(sys.argv)==3
label,digest=sys.argv[1:]
assert re.fullmatch(r'keygen_bound135_[0-9]{3}',label)
assert re.fullmatch(r'[0-9a-f]{64}',digest)
path=root/'.build/jobs'/label/'BOUND135_CANDIDATES.json'
assert hashlib.sha256(path.read_bytes()).hexdigest()==digest
candidate=json.loads(path.read_text());events=candidate['events']
assert candidate['n']==1536 and candidate['scale']==[1250,100]
assert [e['name'] for e in events]==['fpr_of','fpr_of','fpr_sqrt','fpr_div','fpr_of','fpr_mul','fpr_of','fpr_div']
assert ZZ(events[0]['args'][0][1])==73732*1536
assert [ZZ(events[i]['args'][0][1]) for i in [1,4,6]]==[8,1250,100]
def dyadic(bits):
    bits=ZZ(bits);assert 0<bits<2^63
    exp=(bits>>52)&0x7ff;assert 0<exp<2047
    return QQ(2^52+(bits&(2^52-1)))*QQ(2)^(exp-1023-52)
checks=[]
for e in events:
    out=ZZ(e['out'][1]);value=dyadic(out)
    lower=(dyadic(out-1)+value)/2;upper=(value+dyadic(out+1))/2
    args=[ZZ(v[1]) for v in e['args']]
    if e['name']=='fpr_of':
        target=QQ(args[0]);assert value==target
        criterion='exact integer conversion'
    elif e['name']=='fpr_sqrt':
        target=dyadic(args[0]);assert lower^2<target<upper^2
        criterion='strict squared rational midpoint enclosure'
    else:
        target=dyadic(args[0])*dyadic(args[1]) if e['name']=='fpr_mul' else dyadic(args[0])/dyadic(args[1])
        assert lower<=target<=upper
        if target in [lower,upper]:assert out%2==0
        criterion='exact rational nearest rounding; ties to even'
    checks.append({'name':e['name'],'output_bits':hex(int(out)),'dyadic_output':str(value),
      'target':str(target),'lower_midpoint':str(lower),'upper_midpoint':str(upper),'criterion':criterion})
final=ZZ(candidate['final_word']);assert final==ZZ(events[-1]['out'][1])
assert [ZZ(v[1]) for v in events[3]['args']]==[ZZ(events[0]['out'][1]),ZZ(events[2]['out'][1])]
assert [ZZ(v[1]) for v in events[5]['args']]==[ZZ(events[3]['out'][1]),ZZ(events[4]['out'][1])]
assert [ZZ(v[1]) for v in events[7]['args']]==[ZZ(events[5]['out'][1]),ZZ(events[6]['out'][1])]
(Path.cwd()/'BOUND135_CONTROL.json').write_text(json.dumps({
 'status':'PASS_EXACT_FINITE_CONTROL_ONLY; NOT_SOURCE_OR_PROBABILITY_PREMISE',
 'sage_version':SAGE_VERSION,'domains':['ZZ','QQ'],'candidate':{'path':str(path),'sha256':digest},
 'checks':checks,'n':int(1536),'scale':[int(1250),int(100)],'final_word':hex(int(final)),
 'final_dyadic':str(dyadic(final))},indent=2)+'\n')
