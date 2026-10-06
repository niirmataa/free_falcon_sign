"""B1.04 finite public controls; source/kernel proof scope stays separate."""
from pathlib import Path
import hashlib
import json
import os
import subprocess

raw = (Path(os.environ['FT1536_SOURCE3_ORIGINAL_W']) / 'inputs/source/falcon-keygen.c').read_bytes()
source_sha = hashlib.sha256(raw).hexdigest()
assert source_sha == '0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf'
lines = raw.decode().splitlines(keepends=True)
def region(a, b):
    return ''.join(lines[a:b])
def replace_once(text, old, new):
    assert text.count(old) == 1, old
    return text.replace(old, new, 1)

helpers = ''.join(region(a,b) for a,b in [(2476,2485),(2499,2511),(2515,2524),
    (2528,2537),(2541,2550),(2555,2567),(2571,2600),(2638,2668),(2672,2760)])
generator = region(2939,3036)
forward = region(3041,3137)
assert forward.startswith('static void\nmodp_NTT3_ext(') and forward.endswith('}\n')
assert lines[60].startswith('#define MKN(')
p, g, n = ZZ(2147355649), ZZ(1907584673), ZZ(1536)
R = ZZ(2)^31
h = power_mod(g,2,p)
assert p.is_prime()
def rev(bits, i):
    return sum(((ZZ(i) >> b) & 1) << (bits-1-b) for b in range(bits))
def table_exp(i):
    i = max(ZZ(1),ZZ(i))
    k = i.nbits()-1
    u = rev(k,i-2^k)
    return (1 if k == 9 else 3*2^(8-k))*(3*u+1+u%2)
table = [power_mod(h,table_exp(i),p) for i in range(1024)]
w, unity = table[1], power_mod(table[1],2,p)
assert (w^2-w+1)%p == 0 and power_mod(unity,3,p) == 1
exponents = [table_exp(512+i//3)+1536*(i%3) for i in range(1536)]
points = [power_mod(h,e,p) for e in exponents]
assert len(set(exponents)) == len(set(points)) == 1536
assert all(0 < e < 4608 and e%6 in (1,5) for e in exponents)
assert all((power_mod(x,1536,p)-power_mod(x,768,p)+1)%p == 0 for x in points)

inputs = [
    [ZZ((17*i+3*i*i)%4095)-2047 for i in range(1536)],
    [[ZZ(0),ZZ(1),p-1,p-2][i%4] for i in range(1536)],
    [ZZ(1) if i in (1,767,768,1535) else ZZ(0) for i in range(1536)],
]
F = GF(p)
P = PolynomialRing(F, 'X')
expected = []
for data in inputs:
    a = [x%p for x in data]
    first = [(a[i]+a[768+i]*w)%p for i in range(768)] + [
        (a[i]+a[768+i]-a[768+i]*w)%p for i in range(768)]
    rounds = []
    current = first[:]
    for round_index in range(8):
        m, t = ZZ(2)^(round_index+1), ZZ(768)//2^round_index
        assert t*m == 1536 and t%2 == 0
        ht = t//2
        assert ht*m == 768
        next_values = current[:]
        for j in range(m):
            s = table[m+j]
            for k in range(ht):
                lo, hi = j*t+k, j*t+ht+k
                assert 0 <= lo < hi < 1536 and 2 <= m+j < 512
                next_values[lo] = (current[lo]+current[hi]*s)%p
                next_values[hi] = (current[lo]-current[hi]*s)%p
        rounds.append(next_values)
        current = next_values
    original = P(a)
    final = [ZZ(original(F(z))) for z in points]
    triple = []
    for j in range(512):
        a0,b0,c0 = current[3*j:3*j+3]
        x = table[512+j]
        triple.extend([(a0+b0*x*power_mod(unity,k,p)+c0*(x*power_mod(unity,k,p))^2)%p
                       for k in range(3)])
    assert triple == final
    expected.append([first]+rounds+[final])

variants = {
    'baseline': forward,
    'first_high_plus': replace_once(forward,'*r2 = modp_sub(modp_add(a0, a1, p), b, p);',
        '*r2 = modp_add(modp_add(a0, a1, p), b, p);'),
    'binary_high_plus': replace_once(forward,'*r2 = modp_sub(x, y, p);','*r2 = modp_add(x, y, p);'),
    'triple_wrong_cross': replace_once(replace_once(forward,
        'modp_add(fB1, fC2, p), p);','modp_add(fB1, fC1, p), p);'),
        'modp_add(fB2, fC1, p), p);','modp_add(fB2, fC2, p), p);'),
    'triple_fixed_root': replace_once(forward,'u += 3, r ++, r1 += 3 * stride)',
        'u += 3, r += 0, r1 += 3 * stride)'),
    'first_wrong_scale': replace_once(forward,'b = modp_montymul(a1, w, p, p0i);',
        'b = modp_montymul(a1, modp_R(p), p, p0i);'),
    'first_noncanonical': replace_once(forward,'*r1 = modp_add(a0, b, p);',
        '*r1 = modp_add(a0, b, p) + p;'),
}
header = '#include <stdint.h>\n#include <stddef.h>\n#include <stdio.h>\n#include <inttypes.h>\n#include <string.h>\n'
instrument = 'static uint32_t snapshots[9][1536];\nstatic unsigned snapshot_count;\n'
main = r'''
int main(void) {
  uint32_t a[1544], gm[1024], igm[1024], saved_gm[1024];
  uint32_t p=2147355649U, p0i=modp_ninv31(p);
  modp_mkgm3(gm,igm,10,1,1907584673U,p,p0i);
  memcpy(saved_gm,gm,sizeof gm);
  for (unsigned which=0;which<3;which++) {
    for (size_t i=0;i<1536;i++) {
      if (which==0) a[i]=modp_set((int32_t)((17*i+3*i*i)%4095)-2047,p);
      else if (which==1) { uint32_t edge[4]={0,1,p-1,p-2}; a[i]=edge[i%4]; }
      else a[i]=(i==1 || i==767 || i==768 || i==1535);
    }
    for (size_t i=1536;i<1544;i++) a[i]=0xA513B792U;
    snapshot_count=0;
    modp_NTT3_ext(a,1,gm,10,1,p,p0i);
    unsigned guard=0;
    for (size_t i=1536;i<1544;i++) guard |= a[i]^0xA513B792U;
    printf("meta %u %u %u %d\n",which,snapshot_count,guard,memcmp(saved_gm,gm,sizeof gm));
    for (size_t i=0;i<1536;i++) {
      printf("%zu",i);
      for (unsigned j=0;j<9;j++) printf(" %" PRIu32,snapshots[j][i]);
      printf(" %" PRIu32 "\n",a[i]);
    }
  }
  return 0;
}
'''
records = []
for mode, flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    for variant, code in variants.items():
        code = replace_once(code,'\tt = hn;','\tmemcpy(snapshots[snapshot_count++],a,n*sizeof *a);\n\tt = hn;')
        code = replace_once(code,'\t\tt = ht;','\t\tmemcpy(snapshots[snapshot_count++],a,n*sizeof *a);\n\t\tt = ht;')
        label = mode+'_'+variant
        cfile, binary = Path(label+'.c'), Path(label+'.bin')
        cfile.write_text(header+lines[60]+helpers+generator+instrument+code+main)
        compiled = subprocess.run(['gcc','-std=c99','-Wall','-Wextra','-Werror']+flags+
            [str(cfile),'-o',str(binary)],capture_output=True)
        Path(label+'.compile.stdout').write_bytes(compiled.stdout)
        Path(label+'.compile.stderr').write_bytes(compiled.stderr)
        assert compiled.returncode == 0 and not compiled.stdout and not compiled.stderr, label
        ran = subprocess.run([str(binary.resolve())],capture_output=True)
        Path(label+'.stdout').write_bytes(ran.stdout)
        Path(label+'.stderr').write_bytes(ran.stderr)
        assert ran.returncode == 0 and not ran.stderr, label
        rows = ran.stdout.decode().splitlines()
        assert len(rows) == 3*1537
        cases = []
        for which in range(3):
            assert rows[which*1537] == 'meta %d 9 0 0' % which, label
            observations = [[ZZ(x) for x in row.split()] for row in rows[which*1537+1:(which+1)*1537]]
            assert all(len(row)==11 and row[0]==i for i,row in enumerate(observations))
            differences = [int(sum(observations[i][j+1] != expected[which][j][i] for i in range(1536)))
                           for j in range(10)]
            noncanonical = [int(sum(not (0 <= observations[i][j+1] < p) for i in range(1536)))
                            for j in range(10)]
            if variant == 'baseline':
                assert not any(differences) and not any(noncanonical), (label,which)
            cases.append({'case': int(which),'differences_by_snapshot': differences,
                          'noncanonical_by_snapshot': noncanonical})
        if variant != 'baseline':
            assert any(any(c['differences_by_snapshot']) for c in cases), label
        records.append({'mode':mode,'variant':variant,'cases':cases,
                        'table_and_guard_preserved':True,
                        'c_sha256':hashlib.sha256(cfile.read_bytes()).hexdigest(),
                        'stdout_sha256':hashlib.sha256(ran.stdout).hexdigest()})
Path('NTT_VALUES_CHECK.json').write_text(json.dumps({
    'status':'PASS_FINITE_PUBLIC_CONTROLS','source_sha256':source_sha,
    'scope':'Three public arrays; complete pinned source NTT with first/eight middle/final snapshots, direct Sage polynomial evaluation in physical triple order, normal/UBSan and six detected mutations. This is not the missing universal source-transform theorem.',
    'first_root':int(w),'unity':int(unity),'points':[int(x) for x in points],
    'exponents':[int(e) for e in exponents],'variants':records,
},indent=2)+'\n')
