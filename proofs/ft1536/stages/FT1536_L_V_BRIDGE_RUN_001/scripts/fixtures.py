"""Small public controls. Sage computes c and Q independently of the NTT."""
from sage.all import GF,PolynomialRing
import hashlib,json
from pathlib import Path
W=Path.cwd();C=W/'checks';C.mkdir(exist_ok=True);F=C/'fixtures';F.mkdir(exist_ok=True)
q=18433;N=1536;B=2093922385;K=GF(q);P=PolynomialRing(K,'X');X=P.gen();phi=X**1536-X**768+1
pub=W/'inputs/OLD/inputs/key';h=list(map(int,(pub/'canonical_public_h.txt').read_text().split()));hp=P(h)
pk=(pub/'canonical_public_key.bin').read_bytes();(F/'pk.bin').write_bytes(pk)
def pack(bits):
    bits+=(-len(bits)%8)*'0';return bytes(int(bits[i:i+8],2) for i in range(0,len(bits),8))
def static_raw(sign,mag,zeros=None):
    ne=mag//256 if zeros is None else zeros
    return pack(str(sign)+f'{mag%256:08b}'+'0'*ne+'1'+'0000000001'*(N-1))
def encode(s,mode):
    if mode==0:return b''.join((v%65536).to_bytes(2,'big') for v in s)
    return pack(''.join(str(int(v<0))+f'{abs(v)%256:08b}'+'0'*(abs(v)//256)+'1' for v in s))
def narrow(v):return (v+32768)%65536-32768
def Q0(a):return sum(a[i]**2+a[i]*a[i+768]+a[i+768]**2 for i in range(768))
def prod(s):
    z=hp*P(s)%phi;return [int(z[i]) for i in range(N)]
cases=[]
def add(name,s,mode=1,payload=None,c=None,header=None,pkbytes=None):
    sig=bytes([0x8a+32*mode if header is None else header])+(encode(s,mode) if payload is None else payload)
    c=prod(s) if c is None else c
    (F/(name+'.bin')).write_bytes(sig);(F/(name+'.c.txt')).write_text(' '.join(map(str,c))+'\n')
    key='checks/fixtures/pk.bin'
    if pkbytes is not None:(F/(name+'.pk.bin')).write_bytes(pkbytes);key='checks/fixtures/'+name+'.pk.bin'
    cases.append(dict(name=name,sig='checks/fixtures/'+name+'.bin',c='checks/fixtures/'+name+'.c.txt',pk=key,intended_s=s))
zero=[0]*N
for mode in [0,1]:
    add('zero_'+str(mode),zero,mode)
    for v in [-9216,9216,-9217,9217,-18433,18433,-20000,-32768,32767]:
        s=zero[:];s[0]=v;add('value_'+str(v).replace('-','m')+'_'+str(mode),s,mode)
for sign,mag in [(0,32768),(1,32768),(0,65535),(1,65535),(1,0)]:
    s=zero[:];inner=narrow(mag);s[0]=inner if sign==0 else narrow(-inner)
    add(f'raw_{sign}_{mag}',s,payload=static_raw(sign,mag))
add('ne255',[-1]+zero[1:],payload=static_raw(0,65535,255))
add('ne256',zero,payload=static_raw(0,0,256))
pad=encode([256]+zero[1:],1)
add('bad_padding',[256]+zero[1:],payload=pad[:-1]+bytes([pad[-1]|1]))
for name,data in [('truncated',encode(zero,1)[:-1]),('trailing_zero',encode(zero,1)+b'\0'),('trailing_ff',encode(zero,1)+b'\xff')]:add(name,zero,payload=data)
for name,header in [('reserved',0xba),('degree',0xa9),('ternary',0x2a),('comp2',0xca),('comp3',0xea)]:add(name,zero,header=header)
for length in [0,1,2]:
    name='short_'+str(length);add(name,zero);(F/(name+'.bin')).write_bytes(bytes([0xaa])*length)
for name,key in [('pk_trailing',pk+b'\xfe\x81\x7f'),('pk_short',pk[:1]),('pk_truncated',pk[:-1]),('pk_reserved',bytes([0x9a])+pk[1:])]:add(name,zero,pkbytes=key)
badpk=bytes([0x8a])+pack(f'{18433:015b}'+'0'*(15*(N-1)))
add('pk_bad_coeff',zero,pkbytes=badpk)
for d in [0,9216,9217,18432]:
    c=zero[:];c[0]=(-d)%q;add('center_'+str(d),zero,c=c)
old=json.loads((W/'inputs/OLD/artifacts/norm_boundaries.json').read_text())
for row in old:
    s=zero[:]
    for i,v in row['s_nonzero']:s[i]=v
    assert Q0(s)==row['target']
    add('bound_'+str(row['target']-B+1)+'_'+str(row['mode']),s,row['mode'])
wc=list(map(int,(W/'inputs/OLD/artifacts/witness_c.txt').read_text().split()))
add('old_witness',[-20000]+zero[1:],c=wc)
(F/'old_witness.bin').write_bytes((W/'inputs/OLD/artifacts/witness.bin').read_bytes())
norm=[]
def normcase(name,a,b):
    path=F/(name+'.norm.txt');path.write_text(' '.join(map(str,a+b))+'\n')
    norm.append(dict(name=name,path=str(path.relative_to(W)),Q=Q0(a)+Q0(b)))
normcase('norm_zero',zero,zero)
normcase('norm_min',[-32768]*N,[-32768]*N)
normcase('norm_max',[32767]*N,[32767]*N)
a=zero[:];a[0]=32767;a[768]=-32768;normcase('norm_negative_cross',a,zero)
a=zero[:];a[0]=1;a[768]=1;normcase('norm_offset',a,zero)
for target in [B-1,B,B+1]:
    row=next(r for r in old if r['target']==target);s=zero[:]
    for i,v in row['s_nonzero']:s[i]=v
    normcase('norm_'+str(target),zero,s)
(C/'cases.json').write_text(json.dumps(dict(verify=cases,norm=norm,centers=[0,9216,9217,18432],B=B),indent=2)+'\n')
(C/'model_jobs.txt').write_text(''.join('sig '+x['name']+' '+x['sig']+'\n'+'pk '+x['name']+' '+x['pk']+'\n' for x in cases)+
    ''.join('norm '+x['name']+' '+x['path']+'\n' for x in norm)+''.join('center c'+str(d)+' '+str(d)+'\n' for d in [0,9216,9217,18432]))
print(json.dumps(dict(verify_cases=len(cases),norm_cases=len(norm),synthetic_public=True,maximum_signature_bytes=max((W/c['sig']).stat().st_size for c in cases)),indent=2))
