"""Independent witness mathematics: Sage GF(q)[X], streaming bit reader.

Does not import model.py/probe.py, does not use S17 NTT for mathematics,
and does not infer a C execution theorem from numeric assertions.
"""
import hashlib
import json
from pathlib import Path
import sys
from sage.all import GF, PolynomialRing, ZZ
from sage.env import SAGE_VERSION

W = Path.cwd()
path = W / (sys.argv[1] if len(sys.argv)>1 else "artifacts/witness.json")
output = W / (sys.argv[2] if len(sys.argv)>2 else "artifacts/sage_check.json")
w = json.loads(path.read_text())
N, q, bound = 1536, 18433, ZZ(2093922385)
assert (w["N"],w["q"],w["B"],w["phi"]) == (N,q,int(bound),"X^1536-X^768+1")
payload = bytes.fromhex(w["payload_hex"])
assert hashlib.sha256(payload).hexdigest() == w["payload_sha256"]
assert (W/"artifacts/witness.bin").read_bytes()==payload
assert list(map(int,(W/"artifacts/witness_c.txt").read_text().split()))==w["c"]


class Bits:
    def __init__(self,data): self.data=data; self.position=0
    def take(self,n):
        ans=0
        for _ in range(n):
            if self.position>=8*len(self.data): raise ValueError("EOF")
            byte,bit=divmod(self.position,8)
            ans=2*ans+((self.data[byte]>>(7-bit))&1)
            self.position+=1
        return ans


def signed_word(x):
    u=x%65536
    return u if u<32768 else u-65536


assert payload[0]==0xAA
r=Bits(payload[1:]); decoded=[]; quotients=[]
for i in range(N):
    sign=r.take(1); low=r.take(8); zero_count=0
    while r.take(1)==0: zero_count=(zero_count+1)%4294967296
    assert zero_count<=255
    low+=256*zero_count
    value=signed_word(low)
    if sign: value=signed_word(-value)
    decoded.append(value); quotients.append(zero_count)
used=(r.position+7)//8
assert used==len(payload)-1
assert r.take(8*used-r.position)==0
assert decoded==w["s"]==w["machine_second"]
assert decoded==[-20000]+[0]*(N-1)

keypath=W/"inputs/key/canonical_public_key.bin"
hpath=W/"inputs/key/canonical_public_h.txt"
assert hashlib.sha256(keypath.read_bytes()).hexdigest()=="57c49fb228013b0bfc4907c754d747dca93c1049d2945ccd6cd686e9f95afc6f"
assert hashlib.sha256(hpath.read_bytes()).hexdigest()=="ce1aef69b5998e6f214bc6a45cf6abc36fb1753d595ef1d7b0e6c1cecd9d17f2"
pk=keypath.read_bytes(); assert len(pk)==2881 and pk[0]==0x8A
kr=Bits(pk[1:]); h=[kr.take(15) for _ in range(N)]
assert h==w["h"]==list(map(int,hpath.read_text().split()))
assert len(w["c"])==N and all(0<=x<q for x in w["c"])
assert all(0<=x<q for x in h)

ring=PolynomialRing(GF(q),"X"); X=ring.gen()
phi=X**N-X**(N//2)+1
hp=ring(h); sp=ring(decoded); cp=ring(w["c"])
product_poly=(hp*sp)%phi
prod=[int(product_poly[i]) for i in range(N)]
assert prod==w["correct_hs"]
z1=[int((ZZ(w["c"][i])-ZZ(prod[i])+9216)%q-9216) for i in range(N)]
assert z1==w["z1"]
assert (ring(z1)+hp*sp-cp)%phi==0


def energy(a):
    assert len(a)==N
    a=list(map(ZZ,a))
    return sum((a[i]**2+a[i]*a[i+768]+a[i+768]**2 for i in range(768)),ZZ(0))


machine_first=w["machine_first"]
assert machine_first==[0]*N
source_energy=energy(machine_first)+energy(decoded)
ext_energy=energy(z1)+energy(decoded)
assert int(source_energy)==w["machine_norm"]==400000000
assert int(ext_energy)==w["ext_norm"]==43058711057
assert source_energy<bound<=ext_energy

# Check the full pre-NTT word map independently, including unsigned narrowing.
pre=[(x+(q if x<0 else 0))%65536 for x in decoded]
assert pre==w["stages"][0]
pre_product=(hp*ring(pre))%phi
pre_product_list=[int(pre_product[i]) for i in range(N)]
effective_product_matches=(pre_product_list==w["c"])
assert w["stages"][3]==w["c"]
assert w["stages"][4]==[0]*N

boundary_checks=[]
for row in json.loads((W/"artifacts/norm_boundaries.json").read_text()):
    vector=[0]*N
    for i,v in row["s_nonzero"]: vector[i]=v
    assert all(0<=v<=9216 for v in vector)
    e=energy(vector)
    assert e==row["target"] and row["verify"]==int(e<bound)
    boundary_checks.append({"target":int(e),"mode":row["mode"]})

cert={"status":"EXACT_WITNESS_MATHEMATICS_CHECKED","sage_version":SAGE_VERSION,
      "witness_sha256":hashlib.sha256(path.read_bytes()).hexdigest(),
      "independent_parser":"streaming sign/8-bit low/unary; explicit unsigned and int16 reductions",
      "product_method":"Sage GF(18433)[X] multiplication and polynomial remainder by X^1536-X^768+1",
      "uses_S17_NTT_for_mathematics":False,
      "decoded_bytes":used,"first_unary_quotient":quotients[0],
      "source_norm_from_exported_actual_pair":int(source_energy),
      "ext_first_norm":int(energy(z1)),"ext_norm":int(ext_energy),
      "B":int(bound),"source_strict_short":True,"Ext0_short":False,
      "exact_congruence":True,"ext_excess_over_B":int(ext_energy-bound),
      "source_preNTT0":pre[0],"correct_s0_residue":decoded[0]%q,
      "stored_word_residue":pre[0]%q,
      "source_product_equals_GF_product_of_preNTT_words":effective_product_matches,
      "boundary_checks":boundary_checks,
      "C_execution_formalized_in_Sage":False,
      "C_execution_evidence":"separate unchanged-source binary receipts and actual-norm-argument observer",
      "support_evidence":"pinned historical canonical KeyGen public record; no private replay"}
with output.open("x") as f: json.dump(cert,f,indent=2);f.write("\n")
print(json.dumps(cert,indent=2))
