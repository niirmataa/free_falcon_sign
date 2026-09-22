"""IETF ChaCha20 known-answer vectors from the local OpenSSL CLI.

OpenSSL is an independent implementation available offline; its keystreams are
stored as public constants in artifacts/kat_vectors.json.  The RFC 8439
section 2.3.2 block keystream (public standard text, quoted literal) and the
classic all-zero vector must both match OpenSSL, otherwise this script fails.
The authoritative Sage model re-checks its Word32 core against these vectors.
"""
import json,subprocess
from pathlib import Path
from common import W
A=W/'artifacts'
OPENSSL='/usr/bin/openssl'
RFC_232=('10f1e7e4d13b5915500fdd1fa32071c4c7d1f4c733c068030422aa9ac3d46c4e'
         'd2826446079faa0914c2d705d98b02a2b5129cd1de164eb9cbd083e8a2503c4e')
ZERO64=('76b8e0ada0f13d90405d6ae55386bd28bdd219b8a08ded1aa836efcc8b770dc7'
        'da41597c5157488d7724e03fb8d84a376a43b8f41518a11cc387b669b2ee6586')
KEY=bytes(range(32));NONCE=bytes.fromhex('000000090000004a00000000')
def keystream(key,nonce12,counter,nbytes):
 iv=(int(counter).to_bytes(4,'little')+nonce12).hex()
 p=subprocess.run([OPENSSL,'enc','-chacha20','-K',key.hex(),'-iv',iv],input=bytes(nbytes),capture_output=True,check=True)
 if len(p.stdout)!=nbytes or p.stderr:raise RuntimeError('openssl chacha20 failure')
 return p.stdout
def vec(vid,key,nonce,counter,blocks):
 ks=keystream(key,nonce,counter,64*blocks)
 return dict(id=vid,key_hex=key.hex(),nonce96_hex=nonce.hex(),counter=counter,blocks=blocks,keystream_hex=ks.hex())
first=keystream(KEY,NONCE,1,64)
assert first.hex()==RFC_232,'RFC 8439 2.3.2 / OpenSSL mismatch'
zero=keystream(bytes(32),bytes(12),0,64)
assert zero.hex()==ZERO64,'classic all-zero / OpenSSL mismatch'
vectors=[vec('V_CTR0',KEY,NONCE,0,1),vec('V_CTR1',KEY,NONCE,1,1),vec('V_CTR2',KEY,NONCE,2,1),vec('V_ZERO_ALL',bytes(32),bytes(12),0,1),vec('V_MULTI4',KEY,bytes(12),0,4)]
version=subprocess.run([OPENSSL,'version'],capture_output=True,check=True).stdout.decode().strip()
A.mkdir(exist_ok=True)
(A/'kat_vectors.json').write_text(json.dumps(dict(schema='PRNG_T021_IETF_CHACHA20_KAT_V1',tag='INDEPENDENT_OPENSSL_ORACLE',openssl=version,argv_template=[OPENSSL,'enc','-chacha20','-K','<key_hex>','-iv','<counter_le32>||<nonce96>'],rfc8439_2_3_2_hex=RFC_232,classic_all_zero_hex=ZERO64,count=len(vectors),vectors=vectors),indent=2)+'\n')
print('KAT',version,len(vectors))
