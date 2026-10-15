#!/usr/bin/env sage
# Native FFT words are candidate evidence; exact ZZ norm controls are auxiliary.
import hashlib,json,subprocess,shutil
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
m=json.loads(manifest.read_text())
for row in m['source_inputs']:assert sha(row['path'])==row['sha256']
decoded=Path(m['selected'])/'DECODED.json'
assert sha(decoded)==next(r['sha256'] for r in m['artifacts'] if r['path']==str(decoded))
fg=json.loads(decoded.read_text());f=[ZZ(v) for v in fg['f']];g=[ZZ(v) for v in fg['g']]
assert len(f)==len(g)==1536 and all(v in [-1,0,1] for v in f+g)
word_source=root/'sage/keygen_fastfpr137_control.sage'
assert sha(word_source)=='a90b036ca826dc9dfd72380dedc62a8ab0f3972d8fa6260b81bd0cc86a40853f'
# Reuse the pinned independent exact-word controls with the standard Sage preparser.
word_text='M64='+word_source.read_text().split('M64=',1)[1].split('boundaries=',1)[0]
helper=Path.cwd()/'WORD151.sage';helper.write_text(word_text)
load(str(helper))
probe=Path.cwd()/'CONTROL151.c'
probe.write_text('''#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include "internal.h"
_Static_assert(sizeof(int)==4 && sizeof(long)==8 && sizeof(size_t)==8, "LP64 required");
int main(void) {
    fpr x[1536],y[1536],norm;
    size_t u;
    for (u=0;u<1536;u++) {
        int a,b;
        if (scanf("%d %d",&a,&b)!=2) return 2;
        x[u]=fpr_of(a);y[u]=fpr_of(b);
    }
    falcon_FFT3(x,10,1);falcon_FFT3(y,10,1);
    norm=fpr_of(0);
    for (u=0;u<1536;u++) {
        printf("%016" PRIx64 " %016" PRIx64,x[u],y[u]);putchar(10);
        norm=fpr_add(norm,fpr_sqr(x[u]));
        norm=fpr_add(norm,fpr_sqr(y[u]));
    }
    norm=fpr_double(norm);
    printf("N %016" PRIx64 " %d",norm,fpr_lt(norm,UINT64_C(4737176763271429578)));putchar(10);
    return 0;
}
''')
cc=shutil.which('cc');assert cc
binary=Path.cwd()/'CONTROL151'
argv=[cc,*m['profile_flags'],'-DFALCON_ASM_CORTEXM4=0','-std=c11','-I',str(repo/'Extra/c'),str(probe),str(repo/'Extra/c/fpr-emulated.c'),str(repo/'Extra/c/falcon-fft.c'),'-o',str(binary)]
compiled=subprocess.run(argv,capture_output=True,check=False)
(Path.cwd()/'CC.stdout').write_bytes(compiled.stdout);(Path.cwd()/'CC.stderr').write_bytes(compiled.stderr)
assert compiled.returncode==0 and compiled.stdout==compiled.stderr==b''
inputs=''.join(str(a)+' '+str(b)+'\n' for a,b in zip(f,g))
(Path.cwd()/'CONTROL151_INPUT.txt').write_text(inputs)
native=subprocess.run([str(binary)],input=inputs.encode(),capture_output=True,check=False)
(Path.cwd()/'NATIVE.stdout').write_bytes(native.stdout);(Path.cwd()/'NATIVE.stderr').write_bytes(native.stderr)
assert native.returncode==0 and native.stderr==b''
lines=native.stdout.decode().splitlines();assert len(lines)==1537
xs=[];ys=[];events=[];acc=ZZ(0)
for u,line in enumerate(lines[:1536]):
    x,y=[ZZ(v,16) for v in line.split()];xs.append(x);ys.append(y)
    first=add(acc,mul(x,x));second=add(first,mul(y,y))
    events.append({'u':u,'before':str(acc),'after_f':str(first),'after_g':str(second)})
    acc=second
word=double(acc);tag,native_word,native_accept=lines[-1].split()
bound=ZZ(4737176763271429578)
assert tag=='N' and ZZ(native_word,16)==word
assert 0<=word<2^63 and 0<bound<2^63 and ZZ(native_accept)==ZZ(word<bound)
def pin(p):return {'path':str(p),'sha256':sha(p)}
(Path.cwd()/'NORM151_CANDIDATE.json').write_text(json.dumps({
 'status':'EXACT_FINITE_CONTROL_AND_NUMERIC_CANDIDATE; KERNEL_FFT_IMAGE_EQUALITIES_AND_GATE_OPEN',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'fixture_counter':int(9),
 'rt1_words':[str(v) for v in xs],'rt2_words':[str(v) for v in ys],'ordered_accumulation':events,
 'sum_word':str(acc),'doubled_word':str(word),'doubled_hex':hex(int(word)),'bound_word':str(bound),'native_accept':int(native_accept),
 'source_manifest':pin(manifest),'decoded':pin(decoded),'exact_word_source':pin(word_source),'exact_word_helper':pin(helper),
 'probe':pin(probe),'binary':pin(binary),'input':pin(Path.cwd()/'CONTROL151_INPUT.txt'),'native_output':pin(Path.cwd()/'NATIVE.stdout'),
 'native_compile_argv':argv,
 'scope':'The native FFT image and its independently ZZ-checked norm propose a finite certificate. They do not prove equality with the symbolic Lean images or discharge SelectedRawNorm151.NumericalObligation.'},indent=2)+'\n')
