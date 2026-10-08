"""Finite public-fixture controls for sampler/context, raw/GS and public frames."""
import hashlib
import json
import os
from pathlib import Path
import subprocess

root = Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
profile = json.loads((root/'PROFILE.json').read_text())
def digest(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
for name,pin in profile['core']['source_files'].items():
    assert digest(root/name)==pin,name
keygen=(root/'falcon-keygen.c').read_text()
vrfy=(root/'falcon-vrfy.c').read_text()
def once(text,old,new):
    assert text.count(old)==1,old
    return text.replace(old,new,int(1))
def plain(x):
    if isinstance(x,dict): return {str(k):plain(v) for k,v in x.items()}
    if isinstance(x,(list,tuple)): return [plain(v) for v in x]
    if isinstance(x,(str,bool)) or x is None: return x
    return int(x)
n=ZZ(1536)
fixtures=[]
for i in range(24):
    label='FT1536 public B1.05 attempt fixture 031/'+str(i)
    stream=hashlib.shake_256(label.encode()).digest(int(16384))
    cursor=ZZ(0)
    values=[]
    for call in range(2):
        vector=[];bits=ZZ(0);word=ZZ(0)
        while len(vector)<n:
            if bits<2:
                word=ZZ(int.from_bytes(stream[int(cursor):int(cursor+8)],'little'))
                cursor+=8;bits=64
            draw=word & 3;word >>= 2;bits-=2
            if draw<3: vector.append(draw-1)
        values.append(vector)
    fixtures.append({'label':label,'f':values[0],'g':values[1],'cursor':cursor})
Path('PUBLIC_FIXTURE.json').write_text(json.dumps(plain(fixtures),indent=2)+'\n')
labels='static const char *labels[]={'+','.join(json.dumps(f['label']) for f in fixtures)+'};\n'
norm=''.join(keygen.splitlines(keepends=True)[int(7957):int(8019)])
assert norm.count('continue;')==2
norm=norm.replace('continue;', '*raw_out=norm;*bound_out=bound;return 2;',int(1))
norm=norm.replace('continue;', '*gs_out=norm;*bound_out=bound;return 3;',int(1))
needle='\t\t\tnorm = fpr_double(norm);'
assert norm.count(needle)==2
norm=norm.replace(needle,needle+'\n *raw_out=norm;',int(1))
helper='''
static int norm_prefix(falcon_keygen *fk,const int16_t *f,const int16_t *g,
    fpr *raw_out,fpr *gs_out,fpr *bound_out) {
 unsigned logn=fk->logn;size_t n=MKN(logn,1),u;
 fpr *rt1=(fpr*)fk->tmp,*rt2=rt1+n,*rt3=rt2+n,norm,bound;
 *raw_out=*gs_out=*bound_out=0;
'''+norm+'''
 *gs_out=norm;*bound_out=bound;return 1;
}
'''
main=r'''
#include <stdio.h>
#include <stddef.h>
int main(void) {
  setvbuf(stdout,NULL,_IONBF,0);
  printf("L %zu %zu %zu %zu %zu %zu\n",sizeof(falcon_keygen),offsetof(falcon_keygen,rng),
    offsetof(falcon_keygen,tmp),offsetof(shake_context,dptr),offsetof(shake_context,rate),offsetof(shake_context,A));
  for(size_t c=0;c<sizeof labels/sizeof labels[0];c++) {
    falcon_keygen fk,old,after_sample;
    uint32_t scratch[65540]={0};int16_t f[1538],g[1538],sf[1536],sg[1536];uint16_t h[1538];
    memset(&fk,0,sizeof fk);fk.logn=10;fk.ternary=1;fk.tmp=scratch+2;fk.tmp_len=65536;
    fk.seeded=1;fk.flipped=1;
    shake_init(&fk.rng,512);shake_inject(&fk.rng,labels[c],strlen(labels[c]));shake_flip(&fk.rng);
    memcpy(&old,&fk,sizeof fk);
    for(size_t j=0;j<1538;j++)f[j]=g[j]=12345,h[j]=54321;
    scratch[0]=scratch[65539]=0x12345678;
    sample_true_ternary_secret(&fk,f+1,1536);sample_true_ternary_secret(&fk,g+1,1536);
    memcpy(&after_sample,&fk,sizeof fk);memcpy(sf,f+1,sizeof sf);memcpy(sg,g+1,sizeof sg);
    int changed=memcmp(&old,&fk,8)!=0 || memcmp(((unsigned char*)&old)+424,((unsigned char*)&fk)+424,sizeof fk-424)!=0;
    uint32_t rf=mod2_res_ternary(f+1,10),rg=mod2_res_ternary(g+1,10);
    fpr raw,gs,bound;int gates=norm_prefix(&fk,f+1,g+1,&raw,&gs,&bound);
    int pub=falcon_compute_public(h+1,f+1,g+1,10,1);
    changed |= memcmp(sf,f+1,sizeof sf)!=0 || memcmp(sg,g+1,sizeof sg)!=0 || memcmp(&after_sample,&fk,sizeof fk)!=0;
    changed |= f[0]!=12345 || g[0]!=12345 || f[1537]!=12345 || g[1537]!=12345 || h[0]!=54321 || h[1537]!=54321;
    changed |= scratch[0]!=0x12345678 || scratch[65539]!=0x12345678;
    printf("A %zu %d %zu %u %u %d %d %llu %llu %llu",c,changed,fk.rng.dptr,rf,rg,gates,pub,
      (unsigned long long)raw,(unsigned long long)gs,(unsigned long long)bound);
    for(size_t j=0;j<1536;j++)printf(" %d",(int)sf[j]);
    for(size_t j=0;j<1536;j++)printf(" %d",(int)sg[j]);
    printf("\n");
  }
  return 0;
}
'''
public_body=''.join(vrfy.splitlines(keepends=True)[int(1520):int(1547)])
variants={
    'baseline':(keygen,helper,vrfy),
    'sampler_plus_two':(once(keygen,'v[u] = (int16_t)((int)x - 1);','v[u] = (int16_t)((int)x + 2);'),helper,vrfy),
    'raw_bound_scale':(keygen,helper.replace('fpr_of(TERNARY_KEYGEN_BOUND_SCALE_NUM)','fpr_of(TERNARY_KEYGEN_BOUND_SCALE_NUM + 1)'),vrfy),
    'gs_scale_omitted':(keygen,once(helper,'falcon_poly_mulconst_fft3(rt1, fpr_of(18433), logn, 1);','falcon_poly_mulconst_fft3(rt1, fpr_of(1), logn, 1);'),vrfy),
    'public_input_overwrite':(keygen,helper,once(vrfy,public_body,once(public_body,'return 1;','((int16_t *)f)[0] ^= 1; return 1;')))}
records=[];baseline=None
for mode,flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    for variant,(kg,hp,pub) in variants.items():
        label=mode+'_'+variant;cfile=Path(label+'.c');vfile=Path(label+'_vrfy.c');binary=Path(label+'.bin')
        cfile.write_text(kg+labels+hp+main);vfile.write_text(pub)
        command=['gcc','-std=c99','-Wall','-Wextra','-Werror','-ffunction-sections','-fdata-sections']+profile['core']['Makefile_flags']+flags+[
            '-I',str(root),str(cfile),str(vfile),str(root/'shake.c'),str(root/'falcon-fft.c'),str(root/'fpr-emulated.c'),'-Wl,--gc-sections','-o',str(binary)]
        compiled=subprocess.run(command,capture_output=True)
        Path(label+'.compile.stdout').write_bytes(compiled.stdout);Path(label+'.compile.stderr').write_bytes(compiled.stderr)
        assert compiled.returncode==0 and not compiled.stdout and not compiled.stderr,label
        ran=subprocess.run([str(binary.resolve())],capture_output=True)
        Path(label+'.stdout').write_bytes(ran.stdout);Path(label+'.stderr').write_bytes(ran.stderr)
        Path(label+'.run.json').write_text(json.dumps({'returncode':ran.returncode})+'\n')
        assert ran.returncode==0 and not ran.stderr,label
        rows=ran.stdout.decode().splitlines();assert rows[0]=='L 448 8 432 200 208 216'
        results=[];differences=[]
        for line in rows[1:]:
            tag,c,*payload=line.split();c=int(c);v=[ZZ(z) for z in payload]
            assert tag=='A' and c==len(results) and len(v)==9+2*n
            changed,dptr,rf,rg,gates,pub,raw,gs,bound=v[:9];f=v[9:int(9+n)];g=v[int(9+n):]
            fixture=fixtures[c];cursor=fixture['cursor'];expected_ptr=(cursor-1)%136+1
            ok=not changed and f==fixture['f'] and g==fixture['g'] and dptr==expected_ptr
            result={'case':c,'changed':changed,'dptr':dptr,'resultants':[rf,rg],'norm_outcome':gates,'public_return':pub,
                'raw_word':raw,'gs_word':gs,'bound_word':bound,'sampled_exact':f==fixture['f'] and g==fixture['g']}
            results.append(plain(result))
            if not ok:differences.append({'case':c,'kind':'exact sampler/context/material frame'})
        assert len(results)==len(fixtures)
        if variant=='baseline':
            assert not differences,(label,differences)
            assert any(r['public_return']==1 for r in results)
            if baseline is None:baseline=results
            else:assert baseline==results
        else:
            differences += [{'case':i,'kind':'gate word/outcome changed'} for i,r in enumerate(results) if r!=baseline[i]]
            assert differences,label
        artifacts=[cfile,vfile,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
        records.append({'mode':mode,'variant':variant,'results':results,'differences':differences,'command':command,
            'artifacts':{str(p):digest(p) for p in artifacts}})
Path('ATTEMPT_CHECK.json').write_text(json.dumps({'status':'PASS_FINITE_SOURCE_CONTROLS','variants':records,
    'fixture_sha256':digest('PUBLIC_FIXTURE.json'),'profile_sha256':digest(root/'PROFILE.json'),'source_pins':profile['core']['source_files'],
    'scope':'Public deterministic helper fixtures, exact Sage ZZ two-call MODE1 reference, actual LP64 context offsets, resultant/raw/GS/public frames and mutation controls. Public helper is exercised independently also after earlier rejected gates; this is not a full successful attempt or an algebra/security theorem.'},indent=2)+'\n')
