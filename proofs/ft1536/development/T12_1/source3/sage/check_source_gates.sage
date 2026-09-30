# Niirmata project; public synthetic word/array controls only.
# Authoritative exact arithmetic uses the Sage preparser and ZZ/QQ.
# This diagnostic does not instantiate the KeyGen population or prove FFT errors.
from pathlib import Path
import hashlib, json, subprocess, sys

assert parent(1) is ZZ and parent(1/2) is QQ
base=Path(sys.argv[1]).resolve()
pins={'falcon-keygen.c':'0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf',
      'fpr-emulated.h':'242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa'}
lines={}
for name,pin in pins.items():
    raw=(base/name).read_bytes()
    assert hashlib.sha256(raw).hexdigest()==pin
    lines[name]=raw.decode().splitlines(keepends=True)
def sl(name,start,count):
    return ''.join(lines[name][int(start):int(start+count)])

lo=ZZ('4090000053700377',16); hi=ZZ('4114444d1a037d50',16)
half=ZZ('3fe0000000000000',16); one=ZZ('3ff0000000000000',16)
sign=2^63; fraction=2^52
def real_word(w):
    s=-1 if w>=sign else 1
    e=(w//fraction)%2048
    m=w%fraction
    if e==2047:
        return None
    if e==0:
        return s*QQ(m)*QQ(2)^(-1074)
    return s*QQ(fraction+m)*QQ(2)^(e-1075)
def positive_word(w):
    value=real_word(w)
    return value is not None and value>0
def stable_word(w):
    return w if positive_word(w) else one
def gate_array(op,ws,initial):
    flag=initial
    out=[]
    for w in ws:
        value=real_word(w)
        if op=='g':
            ok=value is not None and value>=QQ(1)/2
            out.append(w if ok else one)
        else:
            z=stable_word(w)
            ok=positive_word(w) and real_word(lo)<=real_word(z)<=real_word(hi)
            out.append(z)
        if not ok: flag=flag | 1
    return str(flag)+''.join(' '+format(int(w),'016x') for w in out)

assert real_word(lo)>1024
assert real_word(hi)<332054
assert QQ(18433^2)/332054>1023

glue=sl('falcon-keygen.c',0,30)
glue+=r'''#include <stdint.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
'''
glue+=sl('fpr-emulated.h',15,1)
glue+=sl('fpr-emulated.h',76,1)+sl('fpr-emulated.h',78,1)
glue+=sl('falcon-keygen.c',7443,2)
glue+=sl('fpr-emulated.h',194,12)
glue+=sl('falcon-keygen.c',7452,37)
glue+='static uint32_t root_scan(fpr *g00,size_t hn,uint32_t bad){size_t u;\n'
glue+=sl('falcon-keygen.c',7745,11)
glue+='return bad;}\n'
glue+='static uint32_t leaf_scan(fpr *leaves,size_t n,uint32_t bad){size_t u;\n'
glue+=sl('falcon-keygen.c',7764,11)
glue+='return bad;}\n'
glue+=r'''
int main(void){
    char op;
    while(scanf(" %c",&op)==1){
        if(op=='c'){
            uint64_t x,y;
            if(scanf("%" SCNx64 " %" SCNx64,&x,&y)!=2) return 2;
            printf("%d\n",fpr_lt(x,y));
        }else if(op=='g'||op=='l'){
            size_t n,u;
            uint32_t bad;
            fpr words[1536];
            if(scanf("%zu %" SCNu32,&n,&bad)!=2||n>1536) return 3;
            for(u=0;u<n;u++) if(scanf("%" SCNx64,&words[u])!=1) return 4;
            bad=op=='g'?root_scan(words,n,bad):leaf_scan(words,n,bad);
            printf("%" PRIu32,bad);
            for(u=0;u<n;u++) printf(" %016" PRIx64,words[u]);
            printf("\n");
        }else return 5;
    }
    return ferror(stdin)?6:0;
}
'''
words=[ZZ(0),sign,ZZ(1),sign+1,fraction-1,fraction,
       half-1,half,half+1,one,lo-1,lo,lo+1,hi-1,hi,hi+1,
       ZZ('7fefffffffffffff',16),ZZ('7ff0000000000000',16),
       ZZ('7ff8000000000000',16),ZZ('fff0000000000000',16),
       ZZ('fff8000000000000',16),sign+half,sign+one,2^64-1]
rows=[];expected=[]
finite=[w for w in words if real_word(w) is not None]
for x in finite:
    for y in finite:
        rows.append('c '+format(int(x),'x')+' '+format(int(y),'x'))
        # C intentionally distinguishes -0 and +0. For all other finite
        # words use independent exact dyadic real order, not the XOR formula.
        if real_word(x)==0 and real_word(y)==0:
            v=(x==sign and y==0)
        else:
            v=(real_word(x)<real_word(y))
        expected.append('1' if v else '0')
for op in ['g','l']:
    for w in words:
        for flag in [ZZ(0),ZZ(1),ZZ(2),2^31,2^32-1]:
            rows.append(op+' 1 '+str(flag)+' '+format(int(w),'x'))
            expected.append(gate_array(op,[w],flag))
    n=768 if op=='g' else 1536
    good=half if op=='g' else lo
    arrays=[[good]*n,[good]*(n-1)+[ZZ(0)],[ZZ(0)]+[good]*(n-1),
            [words[int(i%len(words))] for i in range(n)]]
    if op=='l': arrays.extend([[hi]*n,[lo,hi]*(n//2)])
    for ws in arrays:
        rows.append(op+' '+str(n)+' 0'+''.join(' '+format(int(w),'x') for w in ws))
        expected.append(gate_array(op,ws,ZZ(0)))
payload=('\n'.join(rows)+'\n').encode()
gold=('\n'.join(expected)+'\n').encode()
Path('SYNTHETIC_INPUTS.txt').write_bytes(payload)
Path('EXACT_EXPECTED.txt').write_bytes(gold)
Path('controls').mkdir()
results=[]
variants=[('normal',glue,[]),('ubsan',glue,['-fsanitize=undefined','-fno-sanitize-recover=all']),
          ('noop',glue,[]),
          ('mutant_drop_sticky',glue.replace('bad |= valid ^ 1U;','bad = valid ^ 1U;'),[]),
          ('mutant_strict_upper',glue.replace('0x4114444d1a037d50','0x4114444d1a037d4f'),[])]
for label,source,flags in variants:
    if label.startswith('mutant_'): assert source!=glue
    c=Path('controls')/(label+'.c');exe=Path('controls')/label
    c.write_text(source)
    compiled=subprocess.run(['/usr/bin/gcc','-std=c99','-O2','-Wall','-Wextra','-Werror']+flags+
                            [str(c),'-o',str(exe)],capture_output=True,timeout=int(120))
    Path('controls',label+'.compile.stdout').write_bytes(compiled.stdout)
    Path('controls',label+'.compile.stderr').write_bytes(compiled.stderr)
    assert compiled.returncode==0 and not compiled.stdout and not compiled.stderr
    actual=subprocess.run([str(exe.resolve())],input=payload,capture_output=True,timeout=int(60))
    Path('controls',label+'.stdout').write_bytes(actual.stdout)
    Path('controls',label+'.stderr').write_bytes(actual.stderr)
    assert actual.returncode==0 and not actual.stderr
    matched=actual.stdout==gold
    assert matched != label.startswith('mutant_')
    results.append({'variant':label,'exit_code':int(actual.returncode),'matched':bool(matched),
                    'source_sha256':hashlib.sha256(source.encode()).hexdigest(),
                    'stdout_sha256':hashlib.sha256(actual.stdout).hexdigest()})
result={'status':'PASS_SCOPED_CONTROLS','input_source_pins':pins,'cases':int(len(rows)),
        'arithmetic':'sage preparser; exact ZZ/QQ dyadic oracle',
        'stored_leaf_bounds':['1024','332054'],'reciprocal_lower':'1023',
        'full_arrays':[int(768),int(1536)],'variants':results,
        'whole_keygen_executed':False,'keygen_population_instantiated':False,
        'kernel_proof_substitute':False}
Path('CONTROL_RESULT.json').write_text(json.dumps(result,indent=int(2),sort_keys=True)+'\n')
print('SOURCE_GATE_CONTROLS_PASS',json.dumps(result,sort_keys=True))
