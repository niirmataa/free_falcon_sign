# Exact public scalar controls for B1.03(b). The universal result is in Lean;
# these finite C checks target the parity correction and Montgomery scale.
from pathlib import Path
import hashlib, json, os, subprocess

source_root = Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
raw = (source_root/'falcon-keygen.c').read_bytes()
source_sha = hashlib.sha256(raw).hexdigest()
assert source_sha == '0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf'
lines = raw.decode().splitlines(keepends=True)
ninv = ''.join(lines[2499:2511])
r = ''.join(lines[2515:2524])
add = ''.join(lines[2528:2537])
mont = ''.join(lines[2555:2567])
r2 = ''.join(lines[2571:2600])
square = '\tz = modp_montymul(z, z, p, p0i);\n'
correction = '\tz = (z + (p & -(z & 1))) >> 1;\n'
assert r2.count(square) == 5 and r2.count(correction) == 1

# Include both edges of the proved domain, the actual M0 modulus, and odd
# composites. Expectations use modular exponentiation, not the C algorithm.
radix = ZZ(2)^31
moduli = sorted(set([ZZ(2)^30+1, ZZ(2)^30+3, ZZ(2)^30+5,
    ZZ(3)^19, ZZ(2147355649), ZZ(2)^31-3, ZZ(2)^31-1]))
expected = []
parities = set()
for p in moduli:
    assert 2^30 < p < 2^31 and p % 2 == 1
    inverse = (-inverse_mod(p, radix)) % radix
    expected.append((p, inverse, power_mod(2, 62, p)))
    parities.add(power_mod(2, 63, p) % 2)
assert parities == {0, 1}
assert any(not p.is_prime() for p in moduli)

variants = {
    'baseline': r2,
    'four_squares': r2.replace(square, '', 1),
    'omit_parity_correction': r2.replace(correction, '\tz >>= 1;\n'),
    'omit_halving': r2.replace(correction, ''),
}
header = '#include <stdint.h>\n#include <stddef.h>\n#include <stdio.h>\n#include <inttypes.h>\n'
main = '\nint main(void) {\nstatic const uint32_t ps[]={'
main += ','.join(str(p)+'U' for p in moduli)+'};\n'
main += '''for (size_t i=0;i<sizeof ps/sizeof ps[0];i++) {
uint32_t p=ps[i], pi=modp_ninv31(p), rr=modp_R2(p,pi);
printf("%" PRIu32 " %" PRIu32 " %" PRIu32 "\\n",p,pi,rr);
} return 0;\n}\n'''
records = []
for mode, flags in [('normal', ['-O2']),
    ('ubsan', ['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    for variant, body in variants.items():
        label = mode+'_'+variant
        cfile = Path(label+'.c')
        binary = Path(label+'.bin')
        cfile.write_text(header+ninv+r+add+mont+body+main)
        compiled = subprocess.run(['gcc','-std=c99','-Wall','-Wextra','-Werror']+flags+
            [str(cfile),'-o',str(binary)], capture_output=True)
        Path(label+'.compile.stdout').write_bytes(compiled.stdout)
        Path(label+'.compile.stderr').write_bytes(compiled.stderr)
        assert compiled.returncode == 0 and not compiled.stdout and not compiled.stderr
        ran = subprocess.run([str(binary.resolve())], capture_output=True)
        Path(label+'.stdout').write_bytes(ran.stdout)
        Path(label+'.stderr').write_bytes(ran.stderr)
        assert ran.returncode == 0 and not ran.stderr
        observed = [tuple(ZZ(v) for v in line.split()) for line in ran.stdout.decode().splitlines()]
        assert len(observed) == len(expected)
        assert all(a[:2] == b[:2] for a,b in zip(observed,expected))
        differences = [int(i) for i,(a,b) in enumerate(zip(observed,expected)) if a != b]
        if variant == 'baseline':
            assert not differences
            assert all(0 <= out < p for p,pi,out in observed)
        else:
            assert differences, variant
        records.append({'mode':mode,'variant':variant,'differences':differences,
            'c_sha256':hashlib.sha256(cfile.read_bytes()).hexdigest(),
            'stdout_sha256':hashlib.sha256(ran.stdout).hexdigest()})

Path('MODP_R2_CHECK.json').write_text(json.dumps({
    'scope':'finite public C controls only; universal source theorem is kernel-proved separately',
    'source_sha256':source_sha,
    'expected':[[int(x) for x in row] for row in expected],
    'pre_halving_parities':sorted(int(x) for x in parities),
    'variants':records},indent=2)+'\n')
