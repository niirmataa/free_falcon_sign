# Public synthetic operands only. No RNG, solver or private KeyGen invocation.
# This finite source probe supplements the kernel results; it is not the NTT proof.
from pathlib import Path
import hashlib, json, os, subprocess

source_root = Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
raw = (source_root/'falcon-keygen.c').read_bytes()
source_sha = hashlib.sha256(raw).hexdigest()
assert source_sha == '0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf'
lines = raw.decode().splitlines(keepends=True)
set_body = ''.join(lines[2476:2485])
ninv = ''.join(lines[2499:2511])
sub = ''.join(lines[2541:2550])
mont = ''.join(lines[2555:2567])
suffix = ''.join(lines[7385:7396])
p = ZZ(2147355649)
samples = [ZZ(x) for x in [-p+1, -32768, -32767, -2048, -2047, -1, 0, 1, 2047, 2048, 32766, 32767, p-1]]
assert all(-p < x < p for x in samples)
expected_coefficients = [x % p for x in samples]
assert all(0 <= y < p for y in expected_coefficients)

# These are arbitrary transform-coordinate operands, not generated keys.
# Force the scalar equation independently in ZZ/p, with explicit first/last faults.
coordinates = []
for i in range(1536):
    i = ZZ(i)
    b = (65537*i^2 + 11) % p
    bigF = (32771*i^3 + 19) % p
    bigG = (18433 + b*bigF) % p
    coordinates.append((b,bigF,bigG))
assert all((bigG-b*bigF-18433) % p == 0 for b,bigF,bigG in coordinates)

def replace_once(text, old, new):
    assert text.count(old) == 1, old
    return text.replace(old,new)

variants = {
    'baseline': (set_body,suffix),
    'omit_signed_correction': (replace_once(set_body,'w += p & -(w >> 31);','w += p & 0U;'),suffix),
    'swap_F_G': (set_body,suffix.replace('Gt[u]','TEMP_BIGG[u]').replace('Ft[u]','Gt[u]').replace('TEMP_BIGG[u]','Ft[u]')),
    'omit_last_check': (set_body,replace_once(suffix,'u < n;','u + 1 < n;')),
    'accept_failed_comparison': (set_body,replace_once(suffix,'return 0;','return 1;')),
}
header = '#include <stdint.h>\n#include <stddef.h>\n#include <stdio.h>\n#include <inttypes.h>\n'
data = ',\n'.join('{'+','.join(str(x)+'U' for x in row)+'}' for row in coordinates)
coefficient_data = ','.join(str(x) for x in samples)
rows = []
for mode,flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    for variant,(setter,body) in variants.items():
        name = mode+'_'+variant
        wrapper = '\nstatic int check(const uint32_t *ft, const uint32_t *gt, const uint32_t *Ft, const uint32_t *Gt, uint32_t p, uint32_t p0i) {\n'
        wrapper += 'size_t n=1536, u; uint32_t r=modp_montymul(18433,1,p,p0i);\n'+body+'}\n'
        main = '\nint main(void) {\nuint32_t p=2147355649U, pi=modp_ninv31(p);\n'
        main += 'static const int32_t samples[]={'+coefficient_data+'};\n'
        main += 'static const uint32_t data[][3]={'+data+'};\n'
        main += 'uint32_t ft[1536],gt[1536],Ft[1536],Gt[1536];\n'
        main += 'for(size_t i=0;i<sizeof samples/sizeof samples[0];i++) printf("C %" PRIu32 "\\n",modp_set(samples[i],p));\n'
        main += 'for(size_t i=0;i<1536;i++){ft[i]=1;gt[i]=data[i][0];Ft[i]=data[i][1];Gt[i]=data[i][2];}\n'
        main += 'printf("V %d\\n",check(ft,gt,Ft,Gt,p,pi));\n'
        main += 'Gt[0]=(Gt[0]+1U)%p; printf("V %d\\n",check(ft,gt,Ft,Gt,p,pi)); Gt[0]=data[0][2];\n'
        main += 'Gt[1535]=(Gt[1535]+1U)%p; printf("V %d\\n",check(ft,gt,Ft,Gt,p,pi)); return 0;\n}\n'
        cfile = Path(name+'.c')
        binary = Path(name+'.bin')
        cfile.write_text(header+setter+ninv+sub+mont+wrapper+main)
        compile_result = subprocess.run(['gcc','-std=c99','-Wall','-Wextra','-Werror']+flags+[str(cfile),'-o',str(binary)],capture_output=True)
        Path(name+'.compile.stdout').write_bytes(compile_result.stdout)
        Path(name+'.compile.stderr').write_bytes(compile_result.stderr)
        assert compile_result.returncode == 0 and not compile_result.stderr, (name,compile_result.stderr.decode())
        execution = subprocess.run([str(binary.resolve())],capture_output=True)
        Path(name+'.stdout').write_bytes(execution.stdout)
        Path(name+'.stderr').write_bytes(execution.stderr)
        assert execution.returncode == 0 and not execution.stderr, (name,execution.stderr.decode())
        observed = [(line.split()[0],ZZ(line.split()[1])) for line in execution.stdout.decode().splitlines()]
        expected = [('C',x) for x in expected_coefficients]+[('V',ZZ(x)) for x in [1,0,0]]
        assert len(observed) == len(expected)
        differences = [int(i) for i,(actual,wanted) in enumerate(zip(observed,expected)) if actual != wanted]
        if variant == 'baseline':
            assert not differences, (name,differences)
        else:
            assert differences, (name,'mutation not detected')
        rows.append({'mode':mode,'variant':variant,'differences':differences,
            'source_sha256':hashlib.sha256(cfile.read_bytes()).hexdigest(),
            'stdout_sha256':hashlib.sha256(execution.stdout).hexdigest()})

Path('KEYGEN_MODULAR_SUFFIX_CHECK.json').write_text(json.dumps({
    'scope':'finite public source-helper/suffix probes; not an NTT or complete KeyGen proof',
    'source_sha256':source_sha,'coefficients':len(samples),'coordinate_count':len(coordinates),
    'expected_verdicts':[int(x) for x in [1,0,0]],'variants':rows},indent=2)+'\n')
print('KEYGEN_MODULAR_SUFFIX_CHECK_PASS',len(samples),'signed operands,',len(coordinates),
      'public coordinates; baseline and four mutations in two modes')
