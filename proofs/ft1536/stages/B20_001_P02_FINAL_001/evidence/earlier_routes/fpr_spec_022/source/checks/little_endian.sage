import json
import os
from pathlib import Path
from sage.version import version as sage_version

assert (1/2).parent() is QQ
modulus = ZZ(2)^64
words = {ZZ(0), modulus - 1, ZZ(0x0123456789abcdef), ZZ(0xfedcba9876543210)}
for k in range(64):
    words.update([ZZ(2)^k, ZZ(2)^k - 1, modulus - ZZ(2)^k])
rows = []
for w in sorted(words):
    bs = [(w // (ZZ(256)^i)) % 256 for i in range(8)]
    assert sum(bs[i]*ZZ(256)^i for i in range(8)) == w
    rows.append(('%016x ' % w) + ' '.join('%02x' % b for b in bs) + '\n')
dest = Path(os.environ['P02_DEST']) / 'build'
(dest / 'le_cases.txt').write_text(''.join(rows))
(dest / 'le_oracle.json').write_text(json.dumps({
    'sage_version': sage_version, 'preparser': True, 'domain': 'ZZ',
    'words': len(words), 'offsets': 16, 'valid_cases': int(len(words)*16),
    'oracle': 'base-256 digits and weighted sum', 'formal_premise': False,
}, indent=int(2), default=int) + '\n')
print('LE_ORACLE', len(words), 'words')
