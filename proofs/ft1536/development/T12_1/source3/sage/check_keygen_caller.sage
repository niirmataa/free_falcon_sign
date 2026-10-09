"""Public finite controls for initialized caller fragments and same material.

The root helper is exercised independently on the sampled arrays, including
after rejected earlier gates. This is NOT an accepted full-KeyGen fixture.
Exact values, cursor and polynomial equations are checked in Sage ZZ.
"""
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
lines=keygen.splitlines(keepends=True)
def once(text,old,new):
    assert text.count(old)==1,old
    return text.replace(old,new,int(1))
def plain(x):
    if isinstance(x,dict): return {str(k):plain(v) for k,v in x.items()}
    if isinstance(x,(list,tuple)): return [plain(v) for v in x]
    if isinstance(x,(str,bool)) or x is None: return x
    return int(x)
n=ZZ(1536)
ring=PolynomialRing(ZZ,'X');X=ring.gen();phi=X^n-X^(n//2)+1
fixtures=[]
for c in range(24):
    label='FT1536 public B1.05 caller fixture 032/'+str(c)
    stream=hashlib.shake_256(label.encode()).digest(int(16384))
    cursor=ZZ(0);vectors=[]
    for call in range(2):
        vector=[];bits=ZZ(0);word=ZZ(0)
        while len(vector)<n:
            if bits<2:
                word=ZZ(int.from_bytes(stream[int(cursor):int(cursor+8)],'little'))
                cursor+=8;bits=64
            draw=word & 3;word >>= 2;bits-=2
            if draw<3:vector.append(draw-1)
        vectors.append(vector)
    fixtures.append({'label':label,'f':vectors[0],'g':vectors[1],'cursor':cursor})
Path('PUBLIC_FIXTURE.json').write_text(json.dumps(plain(fixtures),indent=2)+'\n')
labels='static const char *labels[]={'+','.join(json.dumps(f['label']) for f in fixtures)+'};\n'
dimensions=''.join(lines[int(7823):int(7826)])
setup=''.join(lines[int(7875):int(7881)])
sampling=''.join(lines[int(7887):int(7889)])
norm=''.join(lines[int(7957):int(8019)])
assert norm.count('continue;')==2
norm=norm.replace('continue;','return 2;',int(1)).replace('continue;','return 3;',int(1))
helper=r'''
static int selected_prefix(falcon_keygen *fk,int16_t *f,int16_t *g,size_t *dimension,ptrdiff_t *offsets) {
 unsigned logn,ter;size_t n,u;
'''+dimensions+r'''
 *dimension=n;
 if(n!=1536 || logn!=10 || ter!=1)return 5;
 {
'''+setup+r'''
 offsets[0]=(unsigned char *)rt1-(unsigned char *)fk->tmp;
 offsets[1]=(unsigned char *)rt2-(unsigned char *)fk->tmp;
 offsets[2]=(unsigned char *)rt3-(unsigned char *)fk->tmp;
'''+sampling+r'''
 if(mod2_res_ternary(f,logn)==0)return 4;
 if(mod2_res_ternary(g,logn)==0)return 4;
'''+norm+r'''
 }
 return 1;
}
'''
main=r'''
#include <stdio.h>
#include <stddef.h>
int main(void) {
 setvbuf(stdout,NULL,_IONBF,0);
 for(size_t c=0;c<sizeof labels/sizeof labels[0];c++) {
  falcon_keygen fk,old,after_prefix;
  uint32_t scratch[65540]={0};int16_t f[1538],g[1538],F[1538],G[1538],sf[1536],sg[1536];uint16_t h[1538];
  memset(&fk,0,sizeof fk);fk.logn=10;fk.ternary=1;fk.tmp=scratch+2;fk.tmp_len=65536;fk.seeded=1;fk.flipped=1;
  shake_init(&fk.rng,512);shake_inject(&fk.rng,labels[c],strlen(labels[c]));shake_flip(&fk.rng);
  memcpy(&old,&fk,sizeof fk);scratch[0]=scratch[65539]=0x12345678;
  for(size_t j=0;j<1538;j++)f[j]=g[j]=F[j]=G[j]=12345,h[j]=54321;
  size_t n=0;ptrdiff_t offsets[3]={-1,-1,-1};
  int gate=selected_prefix(&fk,f+1,g+1,&n,offsets);
  memcpy(&after_prefix,&fk,sizeof fk);memcpy(sf,f+1,sizeof sf);memcpy(sg,g+1,sizeof sg);
  int pub=gate==1?falcon_compute_public(h+1,f+1,g+1,10,1):-1;
  /* Independent PUBLIC root-helper control, NOT acceptance after a rejection. */
  int solved=gate==5?-1:solve_NTRU(&fk,F+1,G+1,f+1,g+1);
  int changed=memcmp(&old,&fk,8)!=0 || memcmp(((unsigned char *)&old)+424,((unsigned char *)&fk)+424,sizeof fk-424)!=0;
  changed |= memcmp(&after_prefix,&fk,sizeof fk)!=0 || memcmp(sf,f+1,sizeof sf)!=0 || memcmp(sg,g+1,sizeof sg)!=0;
  changed |= f[0]!=12345 || g[0]!=12345 || F[0]!=12345 || G[0]!=12345 || f[1537]!=12345 || g[1537]!=12345 || F[1537]!=12345 || G[1537]!=12345;
  changed |= h[0]!=54321 || h[1537]!=54321 || scratch[0]!=0x12345678 || scratch[65539]!=0x12345678;
  printf("C %zu %d %zu %td %td %td %d %d %d %zu",c,changed,n,offsets[0],offsets[1],offsets[2],gate,pub,solved,fk.rng.dptr);
  for(size_t j=0;j<1536;j++)printf(" %d",(int)sf[j]);
  for(size_t j=0;j<1536;j++)printf(" %d",(int)sg[j]);
  for(size_t j=1;j<=1536;j++)printf(" %d",(int)F[j]);
  for(size_t j=1;j<=1536;j++)printf(" %d",(int)G[j]);
  printf("\n");
 }
 return 0;
}
'''
root_body=''.join(lines[int(7277):int(7397)])
variants={
 'baseline':(keygen,helper),
 'wrong_dimension':(keygen,once(helper,'n = MKN(logn, ter);','n = MKN(logn, ter) + 1;')),
 'wrong_rt_alias':(keygen,once(helper,'rt2 = rt1 + n;','rt2 = rt1 + n + 1;')),
 'root_context_overwrite':(once(keygen,root_body,once(root_body,'return 1;','fk->seeded ^= 1; return 1;')),helper),
 'wrong_root_target':(once(keygen,root_body,once(root_body,'r = modp_montymul(18433, 1, p, p0i);','r = modp_montymul(18434, 1, p, p0i);')),helper)}
records=[];baseline=None
for mode,flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
 for variant,(kg,hp) in variants.items():
  label=mode+'_'+variant;cfile=Path(label+'.c');binary=Path(label+'.bin')
  cfile.write_text('#include <stddef.h>\n'+kg+labels+hp+main)
  command=['gcc','-std=c99','-Wall','-Wextra','-Werror','-ffunction-sections','-fdata-sections']+profile['core']['Makefile_flags']+flags+[
   '-I',str(root),str(cfile),str(root/'falcon-vrfy.c'),str(root/'shake.c'),str(root/'falcon-fft.c'),str(root/'fpr-emulated.c'),'-Wl,--gc-sections','-o',str(binary)]
  compiled=subprocess.run(command,capture_output=True)
  Path(label+'.compile.stdout').write_bytes(compiled.stdout);Path(label+'.compile.stderr').write_bytes(compiled.stderr)
  assert compiled.returncode==0 and not compiled.stdout and not compiled.stderr,label
  ran=subprocess.run([str(binary.resolve())],capture_output=True)
  Path(label+'.stdout').write_bytes(ran.stdout);Path(label+'.stderr').write_bytes(ran.stderr)
  Path(label+'.run.json').write_text(json.dumps({'returncode':ran.returncode})+'\n')
  assert ran.returncode==0 and not ran.stderr,label
  results=[];differences=[]
  for line in ran.stdout.decode().splitlines():
   tag,c,*payload=line.split();c=int(c);v=[ZZ(z) for z in payload]
   assert tag=='C' and c==len(results) and len(v)==9+4*n
   changed,dimension,o1,o2,o3,gate,pub,solved,dptr=v[:9]
   f=v[9:int(9+n)];g=v[int(9+n):int(9+2*n)];F=v[int(9+2*n):int(9+3*n)];G=v[int(9+3*n):]
   fixture=fixtures[c];expected_ptr=(fixture['cursor']-1)%136+1
   exact=f==fixture['f'] and g==fixture['g'] and dptr==expected_ptr
   equation=(ring(f)*ring(G)-ring(g)*ring(F))%phi==18433
   bounds=max(abs(z) for z in F+G)<=2047
   ok=not changed and dimension==n and [o1,o2,o3]==[0,8*n,16*n] and exact and (solved!=1 or (equation and bounds))
   result={'case':c,'changed':changed,'dimension':dimension,'offsets':[o1,o2,o3],'early_gate':gate,'public_return':pub,
    'independent_root_return':solved,'sampler_exact':exact,'cursor':dptr,'equation_if_root_success':solved!=1 or equation,
    'bounds_if_root_success':solved!=1 or bounds}
   results.append(plain(result))
   if not ok:differences.append({'case':c,'kind':'initialization/material/context/equation'})
  assert len(results)==len(fixtures)
  if variant=='baseline':
   assert not differences,(label,differences)
   assert any(r['independent_root_return']==1 for r in results)
   if baseline is None:baseline=results
   else:assert baseline==results
  else:
   differences += [{'case':i,'kind':'changed baseline outcome'} for i,r in enumerate(results) if r!=baseline[i]]
   assert differences,label
  artifacts=[cfile,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
  records.append({'mode':mode,'variant':variant,'results':results,'differences':differences,'command':command,
   'artifacts':{str(p):digest(p) for p in artifacts}})
Path('CALLER_CHECK.json').write_text(json.dumps({'status':'PASS_FINITE_SOURCE_CONTROLS','variants':records,
 'fixture_sha256':digest('PUBLIC_FIXTURE.json'),'profile_sha256':digest(root/'PROFILE.json'),'source_pins':profile['core']['source_files'],
 'independent_mode1_root_successes':sum(r['independent_root_return']==1 for r in baseline),
 'scope':'Public deterministic two-call MODE1 fixtures; source dimension/MKN and rt initializer fragments, exact Sage ZZ values/cursor, same-material/context frames and exact NTRU for independent root-helper success. Root controls also run after earlier rejected gates, NOT accepted full attempts, emitted keys or probability evidence.'},indent=2)+'\n')
