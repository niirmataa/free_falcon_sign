#!/usr/bin/env sage
# PUBLIC finite source-C controls. These do not replace the missing kernel
# length/decoder/source-byte theorems of B1.08/09.
import os,subprocess,json,hashlib,time
from datetime import datetime,timezone
from sage.env import SAGE_VERSION

started=time.monotonic()
started_utc=datetime.now(timezone.utc).isoformat()
def locate(name):
    here=os.getcwd()
    for _ in range(12):
        p=os.path.join(here,name)
        if os.path.isfile(p):return p
        here=os.path.dirname(here)
    raise RuntimeError(name)
def sha(p):
    return hashlib.sha256(open(p,'rb').read()).hexdigest()
source=locate('Extra/c/falcon-enc.c')
include=os.path.dirname(source)
raw=open(source).read()
inputs=[source,os.path.join(include,'internal.h'),os.path.join(include,'falcon.h')]
before={p:sha(p) for p in inputs}
probe=r'''
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "internal.h"
static int16_t vectors[4][1536],decoded[1536];
static uint16_t h[1536],hdecoded[1536];
static unsigned char sk[20000],pk[4000],probe[20000];
int main(int argc,char **argv) {
 if(argc!=3)return 90;
 int comp=atoi(argv[1]),seed=atoi(argv[2]);
 for(unsigned k=0;k<4;k++)for(unsigned i=0;i<1536;i++) {
   int w=seed==0?0:seed==1?(k<2?(int)(i%3)-1:(int[]){-2047,-2046,-256,-255,-1,0,1,255,256,2046,2047}[i%11]):
       seed==2?(k<2?(i%2?1:-1):(i%2?2047:-2047)):
       (k<2?(int)((i*37+seed+k)%3)-1:(int)((i*37+seed+k*71)%4095)-2047);
   vectors[k][i]=(int16_t)w;
   if(k==0)h[i]=seed==0?0:seed==1?(uint16_t[]){0,1,18432,18431}[i%4]:(uint16_t)((i*97+seed)%18433);
 }
 memset(sk,0xa5,sizeof sk);sk[0]=(unsigned char)(0x8a+(comp<<5));
 size_t lens[4],consumed[4],off=1;int matches=1,frames=1;
 for(unsigned k=0;k<4;k++) {
   lens[k]=falcon_encode_small(sk+off,sizeof(sk)-off,comp,18433,vectors[k],10);
   if(lens[k]==0)return 91;
   off+=lens[k];
 }
 memset(sk+off,0x5a,11);
 size_t pos=1;
 for(unsigned k=0;k<4;k++) {
   consumed[k]=falcon_decode_small(decoded,10,comp,18433,sk+pos,off-pos+11);
   if(memcmp(decoded,vectors[k],sizeof decoded))matches=0;
   pos+=consumed[k];
   for(unsigned c=0;c<4;c++) {
     size_t cap=c==0?0:c==1?lens[k]-1:c==2?lens[k]:lens[k]+7;
     memset(probe,0xa5,sizeof probe);
     size_t ret=falcon_encode_small(probe+16,cap,comp,18433,vectors[k],10);
     printf("CAP %u %zu %zu ",k,cap,ret);
     for(size_t j=0;j<cap+16;j++)printf("%02x",probe[16+j]);printf("\n");
     for(unsigned j=0;j<16;j++)if(probe[j]!=0xa5)frames=0;
     for(size_t j=16+cap;j<sizeof probe;j++)if(probe[j]!=0xa5)frames=0;
   }
   if(falcon_encode_small(NULL,0,comp,18433,vectors[k],10)!=lens[k])return 92;
 }
 printf("SECRET %zu %zu %zu %zu %zu %zu %zu %zu %zu %d %d\n",off,lens[0],lens[1],lens[2],lens[3],consumed[0],consumed[1],consumed[2],consumed[3],matches,frames);
 for(size_t j=0;j<off;j++)printf("%02x",sk[j]);printf("\n");
 memset(pk,0xa5,sizeof pk);pk[0]=0x8a;
 size_t plen=falcon_encode_18433(pk+1,sizeof(pk)-1,h,10);
 size_t pused=falcon_decode_18433(hdecoded,10,pk+1,plen);
 int pmatch=!memcmp(h,hdecoded,sizeof h);
 memset(pk+1+plen,0x5a,11);
 size_t pextra=falcon_decode_18433(hdecoded,10,pk+1,plen+11);
 printf("PUBLIC %zu %zu %zu %d\n",plen,pused,pextra,pmatch);
 for(size_t j=0;j<plen+1;j++)printf("%02x",pk[j]);printf("\n");
 return 0;
}
'''
open('roundtrip_probe.c','w').write(probe)

def values(seed,k):
    result=[]
    extremes=[-2047,-2046,-256,-255,-1,0,1,255,256,2046,2047]
    for i in range(1536):
        w=0 if seed==0 else ((i%3)-1 if k<2 else extremes[i%11]) if seed==1 else ((1 if i%2 else -1) if k<2 else (2047 if i%2 else -2047)) if seed==2 else ((i*37+seed+k)%3-1 if k<2 else (i*37+seed+k*71)%4095-2047)
        result.append(ZZ(w))
    return result
def packed(bits):
    bits=list(bits)+[0]*int((-len(bits))%8)
    return bytes(int(sum(ZZ(bits[i+j])<<(7-j) for j in range(8))) for i in range(0,len(bits),8))
def encoding(xs,comp):
    if comp==0:return bytes(int(v) for w in xs for v in [(w%65536)>>8,w&255])
    bits=[]
    for w in xs:
        a=abs(w)
        bits += [int(w<0)]+[int((a>>j)&1) for j in reversed(range(8))]+[0]*int(a>>8)+[1]
    expected=int((sum(ZZ(10)+(abs(w)>>8) for w in xs)+7)//8)
    result=packed(bits);assert len(result)==expected
    return result

# Source arithmetic and an independent bit-list oracle, with the actual
# uint32 accumulator. Record a counterexample to the false whole-acc bound.
counterexample=None
def source_static(xs):
    global counterexample
    acc=ZZ(0);acc_len=ZZ(0);out=[];terminal=[]
    for w in xs:
        mag=abs(w);lo=(ZZ(w<0)<<8)|(mag&255);ne=mag>>8
        acc=((acc<<9)|lo)%2^32;acc_len+=9
        while acc_len>=8:
            acc_len-=8;out.append(int((acc>>acc_len)&255))
        old_ne=ne
        while True:
            test=ne;ne-=1
            if test<0:break
            acc=(acc<<1)%2^32
            acc=(acc+(((ne%2^32)>>15)&1))%2^32
            acc_len+=1
            if acc_len==8:out.append(int(acc&255));acc_len=ZZ(0)
        assert ne==-2
        terminal.append(int(ne))
        if counterexample is None and acc>=2^acc_len:
            counterexample={'acc':int(acc),'acc_len':int(acc_len),'processed':int(len(terminal)),'reason':'Old emitted bits remain in uint32 acc; only its low suffix is pending.'}
    if acc_len>0:out.append(int((acc<<(8-acc_len))&255))
    return bytes(out)

def check(binary,comp,seed,label):
    run=subprocess.run([binary,str(comp),str(seed)],capture_output=True,text=True)
    open(label+'.stdout','w').write(run.stdout);open(label+'.stderr','w').write(run.stderr)
    if run.returncode or run.stderr:return False
    lines=run.stdout.splitlines()
    if len(lines)!=20:return False
    enc=[encoding(values(seed,k),comp) for k in range(4)]
    for k in range(4):
        if comp==1:assert source_static(values(seed,k))==enc[k]
        for c,cap in enumerate([0,len(enc[k])-1,len(enc[k]),len(enc[k])+7]):
            fields=lines[k*4+c].split()
            if fields[:3]!=['CAP',str(k),str(cap)]:return False
            expected_ret=0 if cap<len(enc[k]) else len(enc[k])
            written=enc[k][:cap] if comp==1 or cap>=len(enc[k]) else b''
            if int(fields[3])!=expected_ret or fields[4]!=(written+bytes([165])*(cap+16-len(written))).hex():return False
    fields=lines[16].split()
    full=bytes([138+comp*32])+b''.join(enc)
    if fields!=['SECRET',str(len(full)),*map(lambda x:str(len(x)),enc),*map(lambda x:str(len(x)),enc),'1','1']:return False
    if lines[17]!=full.hex():return False
    h=[ZZ(0) if seed==0 else ZZ([0,1,18432,18431][i%4]) if seed==1 else ZZ((i*97+seed)%18433) for i in range(1536)]
    pk=bytes([138])+packed([int((w>>j)&1) for w in h for j in reversed(range(15))])
    if lines[18]!='PUBLIC 2880 2880 2891 1' or lines[19]!=pk.hex():return False
    return True

mutations={
 'none_byte_order':('buf[u + 0] = (unsigned char)(w >> 8);','buf[u + 0] = (unsigned char)w;'),
 'static_padding':('buf[u] = (unsigned char)(acc << (8 - acc_len));','buf[u] = (unsigned char)((acc << (8 - acc_len)) | 1);'),
 'static_terminal_one':('acc += ((unsigned)ne >> 15) & 1;','acc += 0;'),
 'static_decoder_consumption':('return v;','return len;'),
 'public_width':('acc = (acc << 15) | (*x ++);','acc = (acc << 14) | (*x ++);'),
 'public_trailing_length':('return len;','return u;')}
def mutate(name,old,new):
    function='compress_none' if name.startswith('none_') else 'compress_static' if name.startswith('static_') and 'decoder' not in name else 'uncompress_static' if 'decoder' in name else 'falcon_encode_18433' if name=='public_width' else 'falcon_decode_18433'
    start=raw.index(function+'(');end=raw.index('\n}\n',start)+2
    body=raw[start:end];assert old in body
    return raw[:start]+body.replace(old,new,1)+raw[end:]

rows=[];commands=[]
for mode in ['normal','ubsan']:
    flags=['-O1','-std=c99','-ffunction-sections','-fdata-sections','-Wl,--gc-sections','-I',include]
    if mode=='ubsan':flags+=['-fsanitize=undefined','-fno-sanitize-recover=all']
    def build(cfile,label):
        binary=os.path.abspath(label)
        argv=['gcc',*flags,cfile,'roundtrip_probe.c','-o',binary];commands.append(argv)
        run=subprocess.run(argv,capture_output=True,text=True)
        open(label+'.compile.stdout','w').write(run.stdout);open(label+'.compile.stderr','w').write(run.stderr)
        assert run.returncode==0 and run.stderr==''
        return binary
    binary=build(source,'roundtrip_'+mode)
    baseline=[check(binary,int(comp),int(seed),mode+'_base_'+str(comp)+'_'+str(seed)) for comp in [0,1] for seed in [0,1,2,7]]
    assert all(baseline)
    detected={}
    for name,(old,new) in mutations.items():
        cfile='mutant_'+name+'.c';open(cfile,'w').write(mutate(name,old,new))
        mutant=build(cfile,name+'_'+mode)
        outcomes=[check(mutant,int(comp),int(seed),mode+'_'+name+'_'+str(comp)+'_'+str(seed)) for comp in [0,1] for seed in [0,1,2,7]]
        detected[name]=not all(outcomes)
    assert all(detected.values())
    rows.append({'mode':mode,'baseline_cases':int(len(baseline)),'capacity_cases':int(len(baseline)*16),'detected':detected})
assert counterexample is not None
assert {p:sha(p) for p in inputs}==before
result={'status':'PASS_PUBLIC_LENGTH_ROUNDTRIP_CONTROLS','rows':rows,'inputs_before_after':before,'compiler_argv':commands,
 'source_accumulator_counterexample':counterexample,
 'scope':'Finite public synthetic material: f/g ternary, F/G bounded2047, canonical h<18433, four independently padded segments. Actual C NONE/STATIC exact lengths/round-trips/capacity prefixes and15-bit public codec including supplied trailing length. No source kernel decoder or universal length theorem.',
 'kernel_obligations_open':['NONE full body length/capacity','STATIC low-suffix/encoded length refinement','Source decoder round-trip and four-segment final bytes','Public source binding/round-trip']}
open('ROUNDTRIP_CHECK.json','w').write(json.dumps(result,indent=2)+'\n')
manifest={'schema_version':int(1),'claim_id':'BATCH_066_PUBLIC_CODEC_CONTROLS','repository':{'commit':subprocess.check_output(['git','rev-parse','HEAD'],cwd=include,text=True).strip(),'dirty':True},
 'command':'sage check_keygen_codec_roundtrips.sage via tools/job_when_available.py','environment':{'software':[subprocess.check_output(['gcc','--version'],text=True).splitlines()[0],str(SAGE_VERSION)],'hardware':'Not used in the mathematical assertion'},
 'mathematics':{'assertion_tested':result['scope'],'coefficient_domain':'Sage ZZ; source C uint32/LP64 arithmetic checked under UBSan','conventions':'MSB-first sign,8 low magnitude bits,unary zeros then1,independent zero padding','inputs':list(before),'bounds':{'coefficients':int(1536),'q':int(18433),'logn':int(10),'f_g_abs':int(1),'F_G_abs':int(2047)},'non_claims':result['kernel_obligations_open']},
 'randomness':{'used':False,'generator':'Deterministic public formula families','seed':None},'run':{'started_at':started_utc,'runtime_seconds':float(time.monotonic()-started),'exit_status':int(0)},
 'outputs':[{'path':os.path.abspath('ROUNDTRIP_CHECK.json'),'sha256':sha('ROUNDTRIP_CHECK.json')}],
 'checks':['Exact independent ZZ bit-list encoding','Actual C encoder/decoder lengths and values','Capacity prefixes and canaries','SAME source/header hashes before/after','Six targeted mutants per mode','uint32 accumulator versus bit-list oracle,terminal ne=-2'],
 'result':'Verified only the finite public cases recorded in ROUNDTRIP_CHECK.json','residual_risks':['Custom source3 runner is not compiler verification; finite controls do not discharge kernel/source-byte obligations.']}
open('COMPUTATION_MANIFEST.json','w').write(json.dumps(manifest,indent=2)+'\n')
