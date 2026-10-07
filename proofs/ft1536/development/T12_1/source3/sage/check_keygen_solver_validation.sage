"""Finite public controls of the B1.05 validation seam, not whole KeyGen."""
from pathlib import Path
import hashlib
import json
import os
import subprocess

raw = (Path(os.environ['FT1536_SOURCE3_ORIGINAL_W']) / 'inputs/source/falcon-keygen.c').read_bytes()
source_sha = hashlib.sha256(raw).hexdigest()
assert source_sha == '0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf'
lines = raw.decode().splitlines(keepends=True)
def region(a,b):
    return ''.join(lines[a:b])
def replace_once(text, old, new):
    assert text.count(old) == 1, old
    return text.replace(old,new,1)
def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

n, q, p = ZZ(1536), ZZ(18433), ZZ(2147355649)
ZP = PolynomialRing(ZZ,'X')
X = ZP.gen()
phi = X^1536-X^768+1
QP = PolynomialRing(QQ,'X')
# Deterministic PUBLIC synthetic data, unrelated to the real KeyGen/PRG.
public = b'FT1536 B1.05 public synthetic validation fixture v1'
f = ZP([ZZ(hashlib.sha256(public+str(i).encode()).digest()[0])%3-1 for i in range(n)])
g = ZP(1)
inverse = QP(f).inverse_mod(QP(phi))
assert (QP(f)*inverse)%QP(phi) == 1
bigG = ZP([ZZ(floor(q*inverse[i]+QQ(1)/2)) for i in range(n)])
bigF = (f*bigG-q)%phi
assert (f*bigG-g*bigF)%phi == q
assert max(abs(x) for x in f.list()) <= 1
assert max(abs(x) for x in bigF.list()+bigG.list()) <= 2047

cases = [
    ('public_valid', [f,g,bigF,bigG]),
    ('public_valid_swapped', [g,f,-bigG,-bigF]),
    ('changed_F37', [f,g,bigF+X^37,bigG]),
    ('changed_G1535', [f,g,bigF,bigG+X^1535]),
    ('all_zero', [ZP(0)]*4),
    ('validation_only_large_G', [ZP(1),ZP(0),ZP(0),ZP(q)]),
]
fixture = []
for name, polys in cases:
    arrays = [[ZZ(a[i]) for i in range(n)] for a in polys]
    residual = (polys[0]*polys[3]-polys[1]*polys[2]-q)%phi
    bounded = all(abs(x)<=1 for a in arrays[:2] for x in a) and all(abs(x)<=2047 for a in arrays[2:] for x in a)
    modular = all(x%p == 0 for x in residual.list())
    exact = residual == 0
    if bounded:
        assert all(abs(x)<=37748737 for x in residual.list())
        assert modular == exact
    fixture.append({'name':name,'arrays':[[int(x) for x in a] for a in arrays],
        'bounds':bool(bounded),'exact_ntru':bool(exact),'modular_ntru':bool(modular),
        'max_abs':[int(max(abs(x) for x in a)) for a in arrays],
        'residual_nonzero':int(len([x for x in residual.list() if x]))})
Path('PUBLIC_FIXTURE.json').write_text(json.dumps(fixture,indent=2)+'\n')

helpers = ''.join(region(a,b) for a,b in [(2476,2485),(2499,2511),(2515,2524),
    (2528,2537),(2541,2550),(2555,2567),(2571,2600),(2638,2668),(2672,2760)])
generator, forward = region(2939,3036), region(3041,3137)
wrapper = region(3250,3252)
small = region(4429,4438)+region(4491,4508)
aliases, conversion, calls, check = region(7353,7357), region(7366,7372), region(7373,7378), region(7385,7396)
assert 'modp_montymul(18433, 1, p, p0i)' in calls and 'return 1;' in check
prefix = r'''
static uint32_t scratch[7184], saved_gm[1024];
static int validate(const int16_t *f,const int16_t *g,const int16_t *F,const int16_t *G) {
  size_t n=1536,u;
  unsigned logn=10;
  uint32_t *ft=scratch+8,*gt,*Ft,*Gt,*gm;
  uint32_t p=2147355649U,p0i=modp_ninv31(p),r;
'''
setup = '\tmodp_mkgm3(gm, ft, logn, 1, 1907584673U, p, p0i);\n\tmemcpy(saved_gm,gm,sizeof saved_gm);\n'
baseline = prefix+aliases+setup+conversion+calls+check+'}\n'
variants = {
    'baseline':baseline,
    'wrong_target':replace_once(baseline,'modp_montymul(18433, 1, p, p0i)','modp_montymul(12289, 1, p, p0i)'),
    'wrong_target_scale':replace_once(baseline,'modp_montymul(18433, 1, p, p0i)','modp_montymul(18433, modp_R(p), p, p0i)'),
    'missing_G_transform':replace_once(baseline,'modp_NTT3(Gt, gm, logn, 1, p, p0i);','(void)Gt;'),
    'overwrite_ft_on_gt':replace_once(baseline,'modp_NTT3(gt, gm, logn, 1, p, p0i);','modp_NTT3(ft, gm, logn, 1, p, p0i);'),
    'swapped_cross_operands':replace_once(replace_once(baseline,
        'modp_montymul(ft[u], Gt[u], p, p0i)','modp_montymul(ft[u], Ft[u], p, p0i)'),
        'modp_montymul(gt[u], Ft[u], p, p0i)','modp_montymul(gt[u], Gt[u], p, p0i)'),
    'ignored_comparison':replace_once(baseline,'if (z != r)', 'if (z != r && 0)'),
}
header = '#include <stdint.h>\n#include <stddef.h>\n#include <stdio.h>\n#include <string.h>\n'
data = 'static const int16_t fixture[6][4][1536] = {\n'+',\n'.join(
    '{'+','.join('{'+','.join(str(x) for x in a)+'}' for a in case['arrays'])+'}' for case in fixture)+'\n};\n'
main = r'''
int main(void) {
  for (unsigned which=0;which<6;which++) {
    int16_t a[4][1536],small_out[2][1536];
    uint32_t wide[2][1536];
    memcpy(a,fixture[which],sizeof a);
    for (size_t i=0;i<7184;i++) scratch[i]=0xA513B792U;
    for (size_t i=0;i<1536;i++) {
      wide[0][i]=(uint32_t)(int32_t)a[2][i]&0x7FFFFFFFU;
      wide[1][i]=(uint32_t)(int32_t)a[3][i]&0x7FFFFFFFU;
    }
    int small_ok=poly_big_to_small(small_out[0],wide[0],10,1) &&
      poly_big_to_small(small_out[1],wide[1],10,1);
    int small_same=!small_ok || !memcmp(small_out,a[2],sizeof small_out);
    int accepted=validate(a[0],a[1],a[2],a[3]);
    unsigned guard=0;
    for (size_t i=0;i<8;i++) guard|=(scratch[i]^0xA513B792U)|(scratch[7176+i]^0xA513B792U);
    printf("%u %d %d %d %d %u %d\n",which,accepted,small_ok,small_same,
      memcmp(a,fixture[which],sizeof a),guard,memcmp(saved_gm,scratch+8+6144,sizeof saved_gm));
  }
  return 0;
}
'''
records = []
for mode, flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    for variant, body in variants.items():
        label = mode+'_'+variant
        cfile, binary = Path(label+'.c'),Path(label+'.bin')
        cfile.write_text(header+lines[60]+helpers+generator+forward+wrapper+small+data+body+main)
        command = ['gcc','-std=c99','-Wall','-Wextra','-Werror']+flags+[str(cfile),'-o',str(binary)]
        compiled = subprocess.run(command,capture_output=True)
        Path(label+'.compile.stdout').write_bytes(compiled.stdout)
        Path(label+'.compile.stderr').write_bytes(compiled.stderr)
        assert compiled.returncode == 0 and not compiled.stdout and not compiled.stderr, label
        ran = subprocess.run([str(binary.resolve())],capture_output=True)
        Path(label+'.stdout').write_bytes(ran.stdout)
        Path(label+'.stderr').write_bytes(ran.stderr)
        assert ran.returncode == 0 and not ran.stderr, label
        rows = [[ZZ(x) for x in row.split()] for row in ran.stdout.decode().splitlines()]
        assert len(rows) == len(fixture)
        differences = []
        for i,row in enumerate(rows):
            expected = fixture[i]
            assert len(row)==7 and row[0]==i and row[3:]==[1,0,0,0], (label,i,row)
            small_ok = all(abs(x)<=2047 for a in expected['arrays'][2:] for x in a)
            assert row[2] == ZZ(small_ok), (label,i)
            differences.append(bool(row[1] != ZZ(expected['modular_ntru'])))
        if variant == 'baseline':
            assert not any(differences), label
        else:
            assert any(differences), label
        records.append({'mode':mode,'variant':variant,'differences':differences,
            'rows':[[int(x) for x in row] for row in rows], 'command':command,
            'source_sha256':digest(cfile),'stdout_sha256':digest(label+'.stdout'),
            'stderr_sha256':digest(label+'.stderr'),'compile_stdout_sha256':digest(label+'.compile.stdout'),
            'compile_stderr_sha256':digest(label+'.compile.stderr')})
Path('SOLVER_VALIDATION_CHECK.json').write_text(json.dumps({
    'status':'PASS_FINITE_PUBLIC_CONTROLS','source_sha256':source_sha,
    'fixture_sha256':digest('PUBLIC_FIXTURE.json'),'fixture_generator':'Exact QQ inverse, nearest-integer proposal, ZZ quotient/equation/bound checks. Public deterministic data only.',
    'cases':[{k:v for k,v in case.items() if k!='arrays'} for case in fixture],
    'variants':records,'scope':'Generation/conversion/four-transform/target/check seam and finite small-output controls, normal/UBSan; six mutations detected. This does not execute or prove the full solver search or MODE1 sampler.',
},indent=2)+'\n')
