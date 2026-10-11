# Exact diagnostic interpreter of the exported CLOSED Lean syntax.
# Finite controls are NOT an every-tape refinement theorem.
import json
from pathlib import Path
from functools import lru_cache
print("SAGE_SOURCE_ENTERED",flush=True)
packet=json.loads(Path('program.json').read_text())
def frozen(x): return tuple(frozen(y) for y in x) if isinstance(x,list) else x
packet={k:frozen(v) for k,v in packet.items()}
W=ZZ(2)^512; H=ZZ(2)^511
T=ZZ(24662538240); ROM=ZZ(93698); RAM=ZZ(4608); OUT=ZZ(50689)
def wrap(x): return (ZZ(x)+H)%W-H

@lru_cache(None)
def ec(e):
    return ZZ(1) if e[0] in ('lit','reg') else ec(e[1])+ec(e[2])+1

def ev(e,s):
    o=e[0]
    if o=='lit': return wrap(ZZ(e[1]))
    if o=='reg': return s['r'][ZZ(e[1])]
    a,b=ev(e[1],s),ev(e[2],s)
    if o=='add': z=a+b
    elif o=='sub': z=a-b
    elif o=='mul': z=a*b
    elif o=='div': z=a//b if b else ZZ(0)
    elif o=='mod': z=a%b if b else a
    elif o=='lt': z=ZZ(a<b)
    elif o=='eq': z=ZZ(a==b)
    else: raise ValueError(o)
    return wrap(z)

@lru_cache(None)
def bound(c):
    o=c[0]
    if o=='seq': return 2+bound(c[1])+bound(c[2])
    if o=='if': return 3+ec(c[1])+max(bound(c[2]),bound(c[3]))
    if o=='loop': return (ZZ(c[1])+1)*(4+ec(c[2]))+ZZ(c[1])*bound(c[3])
    if o=='set': return 3+ec(c[2])
    if o in ('rom','ram','bit'): return 7+ec(c[2])
    if o in ('store','emit'): return 7+ec(c[1])+ec(c[2])
    raise ValueError(o)

def exprnodes(e): return ZZ(1) if e[0] in ('lit','reg') else 1+exprnodes(e[1])+exprnodes(e[2])
def nodes(c):
    o=c[0]
    if o=='seq': return 1+nodes(c[1])+nodes(c[2])
    if o=='if': return 1+exprnodes(c[1])+nodes(c[2])+nodes(c[3])
    if o=='loop': return 1+exprnodes(c[2])+nodes(c[3])
    if o in ('set','rom','ram','bit'): return 1+exprnodes(c[2])
    return 1+exprnodes(c[1])+exprnodes(c[2])

def state(tape=lambda a:False,rom=lambda a:ZZ(0)):
    return {'r':[ZZ(0)]*32,'m':{},'out':{},'fault':False,'tape':tape,'rom':rom,'steps':ZZ(0),'reads':ZZ(0),'writes':ZZ(0)}

def run(c,s):
    o=c[0]
    if o=='seq':
        s['steps']+=2;run(c[1],s);run(c[2],s);return
    if o=='if':
        s['steps']+=3+ec(c[1]);run(c[2] if ev(c[1],s)!=0 else c[3],s);return
    if o=='loop':
        for k in range(ZZ(c[1])):
            s['steps']+=4+ec(c[2])
            if ev(c[2],s)==0: return
            run(c[3],s)
        s['steps']+=4+ec(c[2]);return
    s['steps']+=bound(c)
    if o=='set': s['r'][ZZ(c[1])]=ev(c[2],s);return
    if o in ('rom','ram','bit'):
        a=ev(c[2],s);limit={'rom':ROM,'ram':RAM,'bit':T}[o]
        if not 0<=a<limit: s['fault']=True;return
        s['reads']+=1
        if o=='rom': v=s['rom'](a)
        elif o=='ram': v=s['m'].get(a,ZZ(0))
        else: v=ZZ(s['tape'](a))
        s['r'][ZZ(c[1])]=wrap(v);return
    a,v=ev(c[1],s),ev(c[2],s);limit=RAM if o=='store' else OUT
    if not 0<=a<limit: s['fault']=True;return
    s['writes']+=1
    if o=='store': s['m'][a]=v
    elif o=='emit': s['out'][a]=bool(v!=0)
    else: raise ValueError(o)

checks=[]
def record(name,c,s):
    assert s['steps']<=bound(c)
    print(name,flush=True)
    checks.append({'name':name,'steps':str(s['steps']),'reads':str(s['reads']),'writes':str(s['writes']),'fault':bool(s['fault'])})

assert bound(packet['program'])==ZZ(packet['bound'])==1106642201817
assert nodes(packet['program'])==ZZ(packet['nodes'])==877
assert T+512*(ROM+RAM+32)+OUT==ZZ(packet['data_bits'])==24712937985
# Separate exact dimensions, not a bound on a native language interpreter.
assert 196*1536*80*1024+30720==T and T==8*3082817280
assert 1536*16+1+1536*17==OUT

for v in [ZZ(0),2^384-1,ZZ('a35f'*96,16)%(2^384)]:
    base=ZZ(900)
    s=state(tape=lambda a,v=v: bool((v>>(a-base))&1));s['r'][3]=base
    run(packet['read384'],s);assert not s['fault'] and s['r'][7]==v and s['reads']==384
    record('word384_'+str(len(checks)),packet['read384'],s)

for v in [ZZ(0),ZZ(1),ZZ(15360),ZZ(30720),ZZ(30721),2^384-1]:
    s=state(tape=lambda a,v=v: bool((v>>a)&1),rom=lambda a:a+1)
    run(packet['coordinate'],s)
    assert not s['fault'] and s['r'][13]==v%30721
    record('cdf_'+str(v),packet['coordinate'],s)

for accepted in [ZZ(0),ZZ(79),None]:
    def bits(a):
        k,j=a//1024,a%1024
        if j<384: return bool((ZZ(100)>>j)&1)
        if j<768: return bool((ZZ(200)>>(j-384))&1)
        v=ZZ(0) if accepted==k else ZZ(1)
        return bool((v>>(j-768))&1)
    s=state(tape=bits,rom=lambda a:a+1 if a<30721 else ZZ(1))
    run(packet['pair'],s)
    x,y=(ZZ(-15260),ZZ(-15160)) if accepted is not None else (ZZ(0),ZZ(0))
    assert not s['fault'] and (s['m'][0],s['m'][1])==(x,y)
    assert s['r'][16]==x*x+x*y+y*y and s['r'][1]==1
    assert s['r'][2]==(accepted+1 if accepted is not None else 80)
    record('pair_accept_'+str(accepted),packet['pair'],s)

for ei in [ZZ(0),ZZ(767),ZZ(768),ZZ(1535)]:
    for ej in [ZZ(0),ZZ(767),ZZ(768),ZZ(1535)]:
        j=2*(ej%768)+(1 if ej>=768 else 0)
        s=state();s['r'][23]=ei;s['r'][22]=j;s['r'][18]=2;s['m'][1536+j]=-3
        k=ei+ej;p=(2*(-3))%18433
        expected={}
        if k<1536: expected[k]=p
        elif k<2304: expected[k-768]=p;expected[k-1536]=(-p)%18433
        else: expected[k-2304]=(-p)%18433
        run(packet['scatter'],s)
        actual={a-3072:v for a,v in s['m'].items() if a>=3072}
        assert not s['fault'] and actual==expected and s['r'][22]==j+1
        record('scatter_'+str(ei)+'_'+str(ej),packet['scatter'],s)

for width in [16,17]:
    for v in [ZZ(0),ZZ(1),ZZ(18432),ZZ(65535),ZZ(131070)] if width==17 else [ZZ(0),ZZ(1),ZZ(18432),ZZ(65535)]:
        c=packet['emit'+str(width)];s=state();s['r'][30]=v
        run(c,s);assert not s['fault'] and s['r'][28]==width and s['r'][30]==0
        assert sum(ZZ(s['out'][j])*2^j for j in range(width))==v
        record('emit_'+str(width)+'_'+str(v),c,s)

for kind,limit in [('bit',T),('rom',ROM),('ram',RAM)]:
    for a in [ZZ(-1),limit]:
        c=(kind,0,('lit',str(a)));s=state();run(c,s);assert s['fault']
        record('invalid_'+kind+'_'+str(a),c,s)

result={'status':'PASS_FINITE_DIAGNOSTICS_NOT_UNIVERSAL_REFINEMENT','checks':checks,
        'core_bound':str(bound(packet['program'])),'nodes':str(nodes(packet['program'])),
        'finite_data_bits':str(T+512*(ROM+RAM+32)+OUT),
        'open':['every-tape program019 refinement','no-fault for full program','input driver and full peak storage'],
        'arithmetic':'Sage ZZ, standard preparser; no floats'}
Path('result.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'status':result['status'],'checks':len(checks),'core_bound':result['core_bound']}))
