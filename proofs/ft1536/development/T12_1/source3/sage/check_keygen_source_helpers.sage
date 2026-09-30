# KEYGEN_SOURCE_TO_FIBER_001: public synthetic helper probes only.
# Standard Sage preparser, ZZ/QQ. No RNG, solve_NTRU or falcon_keygen_make run.
from pathlib import Path
import hashlib, json, os, subprocess

src=Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
profile=json.loads((src/'PROFILE.json').read_text())
def sha(b): return hashlib.sha256(b).hexdigest()
assert sha((src/'PROFILE.json').read_bytes())=='55dc91b373858ddaab78ac4f125538505279c5f74ac3d4e4569a02164ebb1e56'
for name,pin in profile['core']['source_files'].items():
    assert sha((src/name).read_bytes())==pin, name
flags=['-std=c99','-DFPR_IMPL="fpr-emulated.h"','-DFALCON_ASM_CORTEXM4=0']
flags += [f for f in profile['core']['Makefile_flags'] if f.startswith('-D') and not f.startswith('-DFPR_IMPL')]
flags += ['-I'+str(src),'-ffunction-sections','-fdata-sections','-Wl,--gc-sections']
k=(src/'falcon-keygen.c').read_text().splitlines(keepends=True)
def lines(start,end): return ''.join(k[start-1:end])
def replace_once(text,old,new):
    assert text.count(old)==1,(old,text.count(old))
    return text.replace(old,new)

# Exact residual bound used by the Lean proof; monomial reduction modulo
# the EXISTING Phi, not cyclic or binary-ring multiplication.
R.<X>=PolynomialRing(ZZ)
phi=X^1536-X^768+1
p=ZZ(2147355649)
assert 6*3072*2047+18433==37748737 < p
for e in [0,767,768,1535,1536,2303,2304,3070]:
    raw=X^e
    lo=[raw[i]-raw[i+1536]-raw[i+2304] for i in range(768)]
    hi=[raw[i+768]+raw[i+1536] for i in range(768)]
    assert R(lo+hi)==raw%phi
assert p%p==0 and abs(p)>=p
assert p%ZZ(2147473409)!=0

# Compile actual pinned helper implementations into a translation unit.
# Link-time section GC eliminates unused private KeyGen/RNG/solver paths.
headers='#include <stdio.h>\n#include <stdlib.h>\n#include <inttypes.h>\n'
hooks='static unsigned positive_calls, gate_calls;\n'
hooks+='static uint32_t snapshot_bad; static uint64_t snapshot_roots[768], snapshot_leaves[1536];\n'
helpers=lines(7429,7778)
helpers=replace_once(helpers,'ft_stable_positive_keygen(fpr x, uint32_t *bad)\n{',
    'ft_stable_positive_keygen(fpr x, uint32_t *bad)\n{\n\tpositive_calls++;')
helpers=replace_once(helpers,'valid = (uint32_t)ft_fpr_is_positive_finite_keygen(g00[u]);',
    'gate_calls++;\n\t\t\tvalid = (uint32_t)ft_fpr_is_positive_finite_keygen(g00[u]);')
helpers=replace_once(helpers,'return bad == 0;',
    'snapshot_bad=bad; memcpy(snapshot_roots,g00,sizeof snapshot_roots);\n'
    '\t\tmemcpy(snapshot_leaves,leaves,sizeof snapshot_leaves); return bad == 0;')
# The temporary private-prefix source copy removes original copies of these
# helper functions before adding their instrumented versions. Other bytes
# remain exactly pinned. Production sources are never modified.
prefix=''.join(k[:7428])

finalcheck=r'''
static int final_check(uint32_t *storage,const int16_t *f,const int16_t *g,
    const int16_t *F,const int16_t *G) {
    struct { unsigned logn,ternary; uint32_t *tmp; } holder={10,1,storage};
    typeof(holder) *fk=&holder;
    unsigned logn=10; size_t n=1536,u;
    uint32_t *ft,*gt,*Ft,*Gt,*gm,p,p0i,r; const small_prime *primes;
'''.replace('typeof(holder) *fk=&holder;','__typeof__(holder) *fk=&holder;')
finalcheck+=lines(7348,7396)+'\n}\n'
encode_tail=r'''
static int emit_tail(int16_t *f,int16_t *g,int16_t *F,int16_t *G,uint16_t *h,
    void *privkey,size_t *privkey_len,void *pubkey,size_t *pubkey_len) {
    unsigned logn=10,ter=1; int comp=FALCON_COMP_STATIC,i;
    size_t klen,skoff; unsigned char *skbuf; int16_t *ske[4];
'''+lines(8140,8186)+'\n}\n'
main=r'''
static fpr tmp[50000];
static uint32_t modtmp[10000];
static int16_t f[1536],g[1536],F[1536],G[1536],saved[4][1536],decoded[4][1536];
static uint16_t h[1536],hd[1536],savedh[1536];
static unsigned char sk[40000],pk[4000];
int main(int argc,char **argv) {
    if(argc!=2 || sizeof(fpr)!=8 || sizeof(size_t)!=8 || sizeof(long)!=8) return 2;
    int c=atoi(argv[1]); size_t i,off=1,used[4]; int16_t *a[4]={f,g,F,G};
    for(i=0;i<50000;i++) tmp[i]=UINT64_C(0x55aa001122330000)+i;
    f[0]=(c==0 ? 128 : (c==1 ? 0 : 1)); g[0]=(c==1 ? 0 : 1); G[0]=1;
    for(i=0;i<4;i++) memcpy(saved[i],a[i],sizeof f);
    int ret=ft_keygen_leaf_certificate(tmp,f,g,F,G,10,1);
    int frame=1; for(i=0;i<4;i++) frame &= memcmp(saved[i],a[i],sizeof f)==0;
    int tail=1; for(i=24*1536;i<50000;i++) tail &= tmp[i]==UINT64_C(0x55aa001122330000)+i;
    printf("CERT %d %u %u %u %d %d\n",ret,snapshot_bad,gate_calls,positive_calls,frame,tail);
    for(i=0;i<1536;i++) printf("%016" PRIx64 "\n",snapshot_leaves[i]);
    /* Public synthetic serializer data: all four are distinct, G included. */
    for(i=0;i<1536;i++) { f[i]=(int16_t)((int)(i%3)-1); g[i]=(int16_t)((int)((i+1)%3)-1);
        F[i]=(int16_t)((int)(i%4095)-2047); G[i]=(int16_t)(2047-(int)(i%4095)); h[i]=(uint16_t)(i*13%18433); }
    for(i=0;i<4;i++) { memcpy(saved[i],a[i],sizeof f);
        used[i]=falcon_encode_small(NULL,0,FALCON_COMP_STATIC,18433,a[i],10); }
    memcpy(savedh,h,sizeof h);
    size_t sklen=sizeof sk,pklen=sizeof pk;
    if(!emit_tail(f,g,F,G,h,sk,&sklen,pk,&pklen) || sk[0]!=0xaa || pk[0]!=0x8a) return 3;
    off=1;
    for(i=0;i<4;i++) { size_t z=falcon_decode_small(decoded[i],10,FALCON_COMP_STATIC,18433,sk+off,sklen-off);
        if(z!=used[i] || memcmp(decoded[i],saved[i],sizeof f)) return 4; off+=z; }
    if(off!=sklen || pklen!=2881 || falcon_decode_18433(hd,10,pk+1,pklen-1)!=pklen-1 || memcmp(savedh,hd,sizeof h)) return 5;
    printf("ENC %zu %zu %zu %zu %zu %zu\n",sklen,pklen,used[0],used[1],used[2],used[3]);
    /* Existing source public computation, identity denominator. */
    memset(f,0,sizeof f); memset(g,0,sizeof g); f[0]=1; g[767]=-1; g[768]=1;
    if(!falcon_compute_public(h,f,g,10,1)) return 6;
    for(i=0;i<1536;i++) if(h[i]!=(uint16_t)(i==767 ? 18432 : (i==768 ? 1 : 0))) return 7;
    memset(f,0,sizeof f); if(falcon_compute_public(h,f,g,10,1)) return 8;
    /* Final modular checker only. This is NOT solve_NTRU: G=q deliberately
       violates its short-output gate; diagnostic separates the two gates. */
    memset(g,0,sizeof g); memset(F,0,sizeof F); memset(G,0,sizeof G); f[0]=1; G[0]=18433;
    if(!final_check(modtmp,f,g,F,G)) return 9;
    G[0]--; if(final_check(modtmp,f,g,F,G)) return 10;
    puts("PUBLIC_AND_FINAL_MODULAR_CHECK_OK");
    return 0;
}
'''
rows=[]
mutations={
  'encode_F_instead_of_G':replace_once(encode_tail,'ske[3] = G;','ske[3] = F;'),
  'omit_G':replace_once(encode_tail,'i < 4','i < 3'),
  'change_G_before_encoding':replace_once(encode_tail,'skoff = 1;','skoff = 1; G[0]++;'),
  'change_h_before_encoding':replace_once(encode_tail,'klen = *pubkey_len;','klen = *pubkey_len; h[0]++;'),
  'wrong_sk_compression':replace_once(encode_tail,'int comp=FALCON_COMP_STATIC,i;','int comp=FALCON_COMP_NONE,i;'),
}
detections=[]
for mode,extra in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    cfile=Path(mode+'_helpers.c'); binary=Path(mode+'_helpers.bin')
    cfile.write_text(headers+prefix+hooks+helpers+finalcheck+encode_tail+main)
    cmd=['gcc']+flags+extra+[str(cfile),str(src/'falcon-fft.c'),str(src/'fpr-emulated.c'),
        str(src/'falcon-enc.c'),str(src/'falcon-vrfy.c'),'-o',str(binary)]
    cp=subprocess.run(cmd,capture_output=True,check=False)
    Path(mode+'_compile.stdout').write_bytes(cp.stdout);Path(mode+'_compile.stderr').write_bytes(cp.stderr)
    assert cp.returncode==0 and not cp.stderr,(mode,cp.stderr.decode())
    for case in range(3):
        cp=subprocess.run([str(binary.resolve()),str(case)],capture_output=True,check=False)
        name=mode+'_case'+str(case)
        Path(name+'.stdout').write_bytes(cp.stdout);Path(name+'.stderr').write_bytes(cp.stderr)
        assert cp.returncode==0 and not cp.stderr,(name,cp.returncode,cp.stderr.decode())
        text=cp.stdout.decode().splitlines()
        ret,bad,gates,positive,frame,tail=map(ZZ,text[0].split()[1:])
        assert ret==[1,0,0][case] and gates==768 and positive==24576 and frame==1 and tail==1,(name,text[0])
        words=[ZZ(x,16) for x in text[1:1537]]
        if ret:
            assert bad==0 and all(ZZ(0x4090000053700377)<=x<=ZZ(0x4114444d1a037d50) for x in words)
        rows.append({'mode':mode,'case':int(case),'return':int(ret),'stdout_sha256':sha(cp.stdout),
                     'source_sha256':sha(cfile.read_bytes())})
    for mutation,changed in mutations.items():
        stem=mode+'_'+mutation
        cfile=Path(stem+'.c');binary=Path(stem+'.bin')
        cfile.write_text(headers+prefix+hooks+helpers+finalcheck+changed+main)
        cmd=['gcc']+flags+extra+[str(cfile),str(src/'falcon-fft.c'),str(src/'fpr-emulated.c'),
            str(src/'falcon-enc.c'),str(src/'falcon-vrfy.c'),'-o',str(binary)]
        cp=subprocess.run(cmd,capture_output=True,check=False)
        Path(stem+'.compile.stdout').write_bytes(cp.stdout);Path(stem+'.compile.stderr').write_bytes(cp.stderr)
        assert cp.returncode==0 and not cp.stderr,(stem,cp.stderr.decode())
        cp=subprocess.run([str(binary.resolve()),'0'],capture_output=True,check=False)
        Path(stem+'.stdout').write_bytes(cp.stdout);Path(stem+'.stderr').write_bytes(cp.stderr)
        assert cp.returncode in [3,4,5] and not cp.stderr,(stem,cp.returncode,cp.stderr.decode())
        detections.append({'mutation':mutation,'mode':mode,'expected_exit':cp.returncode,'stdout_sha256':sha(cp.stdout)})
Path('KEYGEN_SOURCE_HELPERS.json').write_text(json.dumps({'scope':'finite public synthetic helpers only; no KeyGen or solver execution',
    'source_profile_sha256':sha((src/'PROFILE.json').read_bytes()),'integer_residual_bound':int(37748737),
    'modulus':int(p),'rows':rows,'encoding_mutations':detections},indent=2)+'\n')
print('KEYGEN_SOURCE_HELPERS_PASS',len(rows),'public helper cases;',len(detections),'encoding mutations; exact QQ/ZZ lift precheck')
