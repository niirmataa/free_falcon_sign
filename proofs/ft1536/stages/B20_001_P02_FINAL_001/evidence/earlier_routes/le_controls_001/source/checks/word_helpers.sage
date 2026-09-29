# Exact independent arithmetic oracle; run with the Sage preparser.
import json
import os
from pathlib import Path
from sage.version import version as sage_version

assert (1/2).parent() is QQ
assert 2^5 == 32
modulus = ZZ(2)^64
words = {ZZ(0), modulus - 1, ZZ(0x0123456789abcdef), ZZ(0xfedcba9876543210)}
for bit in range(64):
    words.update([ZZ(2)^bit, (ZZ(2)^bit) - 1, modulus - (ZZ(2)^bit)])
words = sorted(words)
dest = Path(os.environ['P02_DEST']) / 'build'
rows = []
for word in words:
    signed_word = word if word < 2^63 else word - modulus
    for count in range(64):
        denominator = ZZ(2)^count
        right = word // denominator
        left = (word * denominator) % modulus
        signed_right = (signed_word // denominator) % modulus
        assert 0 <= right < modulus and 0 <= left < modulus and 0 <= signed_right < modulus
        rows.append('%016x %d %016x %016x %016x\n' % (word, count, right, left, signed_right))
# Invalid calls must be rejected by the test preflight before entering C.
rows.extend(['0000000000000001 -1 0 0 0\n', '0000000000000001 64 0 0 0\n'])
(dest / 'word_cases.txt').write_text(''.join(rows))
certificate = {
    'schema': 'P02_WORD_ORACLE_V1', 'sage_version': sage_version,
    'preparser': True, 'domains': ['ZZ', 'QQ preparser probe'],
    'oracle': 'unsigned floor division, modular multiplication, signed Euclidean floor division',
    'words': len(words), 'valid_cases': len(words) * 64, 'rejected_cases': 2,
    'count_interval': [0, 63], 'signed_model': 'two-complement arithmetic right shift',
    'formal_premise': False,
    'formal_correspondence': ['B20.Word.pinned_ursh_refines', 'B20.Word.pinned_ulsh_refines', 'B20.Word.pinned_irsh_refines'],
    'scope': 'finite diagnostic controls supporting, not replacing, the universal kernel theorems',
}
(dest / 'word_oracle.json').write_text(json.dumps(certificate, indent=int(2), default=int) + '\n')
print(json.dumps(certificate, sort_keys=True, default=int))
