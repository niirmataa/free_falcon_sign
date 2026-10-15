#!/usr/bin/env sage
# Independent exact finite control; never a premise of source execution.
import hashlib,json
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4]
source=repo/'Extra/c/fpr-emulated.c'
header=repo/'Extra/c/fpr-emulated.h'
assert hashlib.sha256(source.read_bytes()).hexdigest()=='7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f'
assert hashlib.sha256(header.read_bytes()).hexdigest()=='6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f'
word=ZZ(0x4020000000000000); modulus=ZZ(2)^64; mask=modulus-1
xu=(word & (2^52-1)) | 2^52
ex=(word>>52)&0x7ff;e=ex-1023
xu=(xu+(xu & ((-(e&1))%modulus)))%modulus
e=e//2;xu=(xu<<1)%modulus
q=ZZ(0);s=ZZ(0);r=2^53;rows=[]
for i in range(54):
    t=(s+r)%modulus
    b=((((xu-t)%modulus)>>63)-1)%modulus
    s=(s+((r<<1)&b))%modulus
    xu=(xu-(t&b))%modulus
    q=(q+(r&b))%modulus
    xu=(xu<<1)%modulus;r=r>>1
    assert all(0<=v<modulus for v in [t,b,s,xu,q,r])
    rows.append({'i':int(i),'t':str(t),'b':str(b),'s':str(s),'xu':str(xu),'q':str(q),'r':str(r)})
q=(q<<1)%modulus;q=q | ((xu | ((-xu)%modulus))>>63)
e-=54;q=q & ((-((ex+0x7ff)>>11))%modulus)
m=q;packed_exp=e+1076;t=(packed_exp%(2^32))>>31;m=m&((t-1)%modulus)
t=m>>54;packed_exp=packed_exp & (-t)
x=((m>>2)+((packed_exp%(2^32))<<52))%modulus
f=m&7;x=(x+((ZZ(0xc8)>>f)&1))%modulus
assert x==ZZ(0x4006a09e667f3bcd)
def dyadic(bits):
    exponent=((bits>>52)&0x7ff)-1023
    return QQ(2^52+(bits&(2^52-1)))*QQ(2)^(exponent-52)
value=dyadic(x);below=(dyadic(x-1)+value)/2;above=(value+dyadic(x+1))/2
assert below^2<8<above^2
result={'status':'PASS_EXACT_FINITE_CONTROL_ONLY; NOT_SOURCE_OR_PROBABILITY_PREMISE',
 'sage_version':SAGE_VERSION,'domains':['ZZ','QQ'],'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),
 'header_sha256':hashlib.sha256(header.read_bytes()).hexdigest(),'input_bits':hex(int(word)),
 'rounds':rows,'guard_checks':int(55),'output_bits':hex(int(x)),
 'dyadic_output':str(value),'lower_rounding_midpoint':str(below),'upper_rounding_midpoint':str(above),
 'strict_midpoint_squared_check':True}
(Path.cwd()/'SQRT132_CONTROL.json').write_text(json.dumps(result,indent=2)+'\n')
