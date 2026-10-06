# Public, finite controls for B1.03(c). Kernel source contracts are separate.
from pathlib import Path
import hashlib
import json
import os
import re
import subprocess

raw = (Path(os.environ['FT1536_SOURCE3_ORIGINAL_W']) / 'inputs/source/falcon-keygen.c').read_bytes()
source_sha = hashlib.sha256(raw).hexdigest()
assert source_sha == '0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf'
lines = raw.decode().splitlines(keepends=True)
def region(start, stop):
    return ''.join(lines[start:stop])

helpers = ''.join(region(a,b) for a,b in [(2476,2485),(2499,2511),(2515,2524),
    (2528,2537),(2541,2550),(2555,2567),(2571,2600),(2638,2668),(2672,2760)])
body = region(2939,3036)
aliases = region(7352,7357)
conversion = region(7366,7372)
assert body.startswith('static void\nmodp_mkgm3(') and body.endswith('}\n')
assert 'ft = fk->tmp;' in aliases and 'gm = Gt + n;' in aliases
assert 'for (u = 0; u < n; u ++)' in conversion
p, g, unused = [ZZ(x) for x in re.findall(r'\d+', lines[1369])]
assert (p, g) == (2147355649,1907584673)
R = ZZ(2)^31
root = power_mod(g,2,p)
assert Mod(g,p).multiplicative_order() == 9216
assert Mod(root,p).multiplicative_order() == 4608

def reverse(bits,i):
    return sum(((ZZ(i) >> b) & 1) << (bits-1-b) for b in range(bits))
def exponent(i):
    i = max(ZZ(1),ZZ(i))
    k = i.nbits()-1
    u = reverse(k,i-2^k)
    return (1 if k == 9 else 3*2^(8-k)) * (3*u+1+u%2)
expected = [R * power_mod(root,exponent(i),p) % p for i in range(1024)]
assert all(0 <= w < p for w in expected)
assert expected[0] == expected[1]

def replace_once(text, old, new):
    assert text.count(old) == 1, old
    return text.replace(old,new,1)

variants = {
    'baseline': (body,aliases),
    'wrong_scale': (replace_once(body,'g = modp_montymul(g, R2, p, p0i);',
        'g = modp_montymul(g, R, p, p0i);'),aliases),
    'last_step_two': (replace_once(body,'g4 = modp_montymul(g2, g2, p, p0i);',
        'g4 = modp_montymul(g, g, p, p0i);'),aliases),
    'cube_as_square': (replace_once(body,'y = modp_montymul(y,\n\t\t\t\tmodp_montymul(y, y, p, p0i), p, p0i);',
        'y = modp_montymul(y, y, p, p0i);'),aliases),
    'wrong_permutation': (replace_once(body,'gm[b + REV10[u << k]] = x;',
        'gm[b + (u << k)/2] = x;'),aliases),
    'wrong_top_copy': (replace_once(body,'gm[0] = gm[1];','gm[0] = gm[2];'),aliases),
    'overlapping_gm': (body,replace_once(aliases,'gm = Gt + n;','gm = Gt + n - 144;')),
}
header = '#include <stdint.h>\n#include <stddef.h>\n#include <stdio.h>\n#include <inttypes.h>\n#include <string.h>\n'
setup = '''
int main(void) {
uint32_t buf[7168+32], snapshot[1024];
int16_t originals[4][1536], saved[4][1536];
int16_t *f=originals[0], *g=originals[1], *F=originals[2], *G=originals[3];
struct { uint32_t *tmp; } context = {buf}, *fk = &context;
uint32_t *ft, *gt, *Ft, *Gt, *gm;
size_t n=1536, u;
uint32_t p=2147355649U, p0i=modp_ninv31(p);
for (u=0;u<7168+32;u++) buf[u]=0xA513B792U;
for (size_t j=0;j<4;j++) for (u=0;u<n;u++)
    originals[j][u]=(int16_t)((int)((u*17+j*101)%4095)-2047);
memcpy(saved,originals,sizeof originals);
'''
generate = '''
modp_mkgm3(gm,ft,10,1,1907584673U,p,p0i);
memcpy(snapshot,gm,sizeof snapshot);
'''
finish = '''
unsigned guards=0;
for (u=7168;u<7168+32;u++) guards |= buf[u]^0xA513B792U;
printf("meta %u %d\\n",guards,memcmp(saved,originals,sizeof originals));
for (u=0;u<1024;u++) printf("%zu %" PRIu32 " %" PRIu32 "\\n",u,snapshot[u],gm[u]);
return 0;
}
'''
records = []
for mode, flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    for variant, (code,layout) in variants.items():
        label=mode+'_'+variant
        cfile=Path(label+'.c')
        binary=Path(label+'.bin')
        cfile.write_text(header+helpers+code+setup+layout+generate+conversion+finish)
        compiled=subprocess.run(['gcc','-std=c99','-Wall','-Wextra','-Werror']+flags+[str(cfile),'-o',str(binary)],capture_output=True)
        Path(label+'.compile.stdout').write_bytes(compiled.stdout)
        Path(label+'.compile.stderr').write_bytes(compiled.stderr)
        assert compiled.returncode == 0 and not compiled.stdout and not compiled.stderr, label
        ran=subprocess.run([str(binary.resolve())],capture_output=True)
        Path(label+'.stdout').write_bytes(ran.stdout)
        Path(label+'.stderr').write_bytes(ran.stderr)
        assert ran.returncode == 0 and not ran.stderr, label
        rows=ran.stdout.decode().splitlines()
        assert rows[0] == 'meta 0 0', label
        observations=[tuple(ZZ(v) for v in line.split()) for line in rows[1:]]
        assert len(observations) == 1024
        assert all(row[0] == i for i,row in enumerate(observations))
        before=[int(i) for i,(_,a,b) in enumerate(observations) if a != expected[i]]
        after=[int(i) for i,(_,a,b) in enumerate(observations) if b != expected[i]]
        if variant == 'baseline':
            assert not before and not after
        elif variant == 'overlapping_gm':
            assert not before and after
        else:
            assert before and after, label
        records.append({'mode':mode,'variant':variant,'before_differences':before,'after_differences':after,
            'c_sha256':hashlib.sha256(cfile.read_bytes()).hexdigest(),
            'stdout_sha256':hashlib.sha256(ran.stdout).hexdigest(),
            'material_preserved':True,'scratch_guard_preserved':True})

Path('MKGM3_CHECK.json').write_text(json.dumps({
    'status':'PASS_FINITE_PUBLIC_CONTROLS','source_sha256':source_sha,
    'scope':'All M0 gm words and igm=ft overwrite, public synthetic coefficients, normal/UBSan and six mutations. No NTT execution or security claim.',
    'expected':[int(w) for w in expected], 'variants':records,
},indent=2)+'\n')
