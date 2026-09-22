"""Public synthetic 56-byte fixtures for the SHAKE-extract boundary stub.

These bytes are public constants with an explicit fixture tag; they are not
secret material and not real randomness.  The same bytes feed the original C
harness (artifacts/fixtures.bin) and the authoritative Sage model
(artifacts/fixtures.json), so the two are bound through their SHA-256.
"""
import hashlib,json
from pathlib import Path
from common import W
A=W/'artifacts'
def u32(x):return int(x).to_bytes(4,'little')
def u64(x):return int(x).to_bytes(8,'little')
KEY=bytes(range(32))
IV=[0xdeadbeef,0xfeedface,0x01020304,0x05060708]
BASE=KEY+b''.join(u32(w) for w in IV)
M64=1<<64
F=[('F0_ALLZERO',bytes(56),'public all-zero 56 bytes; counter field 0'),
 ('F1_ASCENDING',bytes(range(56)),'public ascending bytes 00..37; nonzero key/IV/counter fields'),
 ('F2_IV_ASYM_CTR0',BASE+u64(0),'asymmetric IV lanes, key 00..1f, counter 0'),
 ('F3_IV_ASYM_CTR32M1',BASE+u64((1<<32)-1),'counter 2^32-1; crosses the high word inside the first refill'),
 ('F4_IV_ASYM_CTR64M1',BASE+u64(M64-1),'counter 2^64-1; wraps to 0 inside the first refill'),
 ('F5_IV_ASYM_CTR64M64',BASE+u64(M64-64),'counter 2^64-64; first refill ends exactly at wrap'),
 ('F6_IV_ASYM_CTR64M65',BASE+u64(M64-65),'counter 2^64-65; wrap occurs inside the second refill')]
A.mkdir(exist_ok=True)
(A/'fixtures.bin').write_bytes(b''.join(b for _,b,_ in F))
(A/'fixtures_ids.txt').write_text(''.join(n+'\n' for n,_,_ in F))
rows=[dict(id=n,index=i,note=note,cc0=str(int.from_bytes(b[48:56],'little')),sha256=hashlib.sha256(b).hexdigest(),init56_hex=b.hex()) for i,(n,b,note) in enumerate(F)]
(A/'fixtures.json').write_text(json.dumps(dict(schema='PRNG_T021_FIXTURES_V1',tag='PUBLIC_SYNTHETIC_FIXTURE_BYTES',capacity='SHAKE-extract boundary stub input, 56 bytes each',count=len(rows),fixtures=rows),indent=2)+'\n')
print('FIXTURES',len(rows),hashlib.sha256((A/'fixtures.bin').read_bytes()).hexdigest())
