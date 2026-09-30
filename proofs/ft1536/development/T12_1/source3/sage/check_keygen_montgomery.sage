# Public synthetic checks of the pinned scalar Montgomery implementation.
# Standard Sage preparser; all reference arithmetic uses ZZ.
from pathlib import Path
import hashlib,json,os,subprocess

src=Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
raw=(src/'falcon-keygen.c').read_bytes()
assert hashlib.sha256(raw).hexdigest()=='0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf'
lines=raw.decode().splitlines(keepends=True)
ninv=''.join(lines[2499:2511])
mul=''.join(lines[2555:2567])
p=ZZ(2147355649); radix=ZZ(2)^31; pi=(-p.inverse_mod(radix))%radix
pairs=[(0,0),(0,p-1),(1,1),(1,p-1),(p-1,p-1),(p-2,p-3),(2^30,2^30),(p-1,2^30)]
pairs += [((i^5*65537+17)%p,(i^7*32771+91)%p) for i in range(64)]
pairs=[(ZZ(a),ZZ(b)) for a,b in pairs]
expected=[]
for a,b in pairs:
    m=(a*b*pi)%radix
    numerator=a*b+m*p
    assert numerator%radix==0 and numerator<2*p*radix<2^63
    t=numerator//radix
    out=t if t<p else t-p
    assert 0<=out<p and (out*radix)%p==(a*b)%p
    expected.append(out)
# The strict residual bound cannot be replaced by a bound allowing p itself.
assert p%p==0 and p!=0 and not abs(p)<=37748737

def replace(text,old,new):
    assert text.count(old)==1,(old,text.count(old))
    return text.replace(old,new)
variants={
    'baseline':(mul,p),
    'mask_30_bits':(replace(mul,'0x7FFFFFFF','0x3FFFFFFF'),p),
    'shift_32':(replace(mul,'(z + w) >> 31','(z + w) >> 32'),p),
    'omit_correction':(replace(mul,'d += p & -(d >> 31);','d += 0;'),p),
    'wrong_inverse':(replace(mul,'z * p0i','z * (p0i + 1U)'),p),
    'premature_product_truncation':(replace(mul,'(uint64_t)a * (uint64_t)b','(uint32_t)a * (uint32_t)b'),p),
    'wrong_modulus_argument':(mul,ZZ(2147473409)),
}
prefix='#include <stdint.h>\n#include <stdio.h>\n#include <inttypes.h>\n'
data=',\n'.join('{'+str(a)+','+str(b)+'}' for a,b in pairs)
rows=[];detections=[]
for mode,flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    for variant,(body,actual_p) in variants.items():
        name=mode+'_'+variant
        cfile=Path(name+'.c');binary=Path(name+'.bin')
        main='\nint main(void) {\n uint32_t p='+str(actual_p)+'U; uint32_t pi=modp_ninv31(p);\n'
        main+=' static const uint32_t pairs[][2]={'+data+'};\n'
        main+=' for(unsigned i=0;i<sizeof pairs/sizeof pairs[0];i++)\n'
        main+=' printf("%" PRIu32 " %" PRIu32 "\\n",pi,modp_montymul(pairs[i][0],pairs[i][1],p,pi));\n return 0;\n}\n'
        cfile.write_text(prefix+ninv+body+main)
        cp=subprocess.run(['gcc','-std=c99','-Wall','-Wextra','-Werror']+flags+[str(cfile),'-o',str(binary)],capture_output=True)
        Path(name+'.compile.stdout').write_bytes(cp.stdout);Path(name+'.compile.stderr').write_bytes(cp.stderr)
        assert cp.returncode==0 and not cp.stderr,(name,cp.stderr.decode())
        cp=subprocess.run([str(binary.resolve())],capture_output=True)
        Path(name+'.stdout').write_bytes(cp.stdout);Path(name+'.stderr').write_bytes(cp.stderr)
        assert cp.returncode==0 and not cp.stderr,(name,cp.stderr.decode())
        values=[tuple(ZZ(v) for v in line.split()) for line in cp.stdout.decode().splitlines()]
        assert len(values)==len(pairs)
        differing=[i for i,(actual,want) in enumerate(zip(values,expected)) if actual!=(pi,want)]
        if variant=='baseline': assert not differing,(name,differing)
        else:
            assert differing,(name,'undetected mutation')
            detections.append({'mode':mode,'variant':variant,'cases':differing})
        rows.append({'mode':mode,'variant':variant,'source_sha256':hashlib.sha256(cfile.read_bytes()).hexdigest(),
                     'stdout_sha256':hashlib.sha256(cp.stdout).hexdigest()})
Path('KEYGEN_MONTGOMERY_CHECK.json').write_text(json.dumps({
    'scope':'finite public scalar probes; not an NTT or KeyGen proof',
    'p':int(p),'radix':int(radix),'source_ninv31_result':int(pi),
    'cases_per_variant':len(pairs),'detections':detections,'rows':rows},indent=2)+'\n')
print('KEYGEN_MONTGOMERY_CHECK_PASS',len(pairs),'cases per variant;',len(detections),'detected mutations; p0i',pi)
