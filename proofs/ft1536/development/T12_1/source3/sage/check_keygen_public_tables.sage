"""Focused BATCH_034 finite controls, Sage preparser and exact ZZ arithmetic.

No KeyGen or private-key generation. Passing these controls does not prove
the remaining universal source table/NTT/nonzero/inverse composition.
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
source = (root/'falcon-vrfy.c').read_text()
def once(text,old,new):
    assert text.count(old)==1,old
    return text.replace(old,new,int(1))
def plain(x):
    if isinstance(x,dict): return {str(k):plain(v) for k,v in x.items()}
    if isinstance(x,(list,tuple)): return [plain(v) for v in x]
    if isinstance(x,(str,bool)) or x is None: return x
    return int(x)

q=ZZ(18433);R=ZZ(2)^16;base=power_mod(ZZ(25),2,q)
assert q.is_prime() and R%q==10237 and (R^2)%q==4564
def rev(x,bits):
    out=ZZ(0)
    for b in range(bits): out=2*out+((ZZ(x)>>b)&1)
    return out
def exponent(i):
    i=max(ZZ(1),ZZ(i));level=ZZ(i.nbits()-1);j=i-2^level
    u=rev(j,level)
    return (1 if level==9 else 3*2^(8-level))*(3*u+1+u%2)
seeds=[(R*power_mod(base,p,q))%q for p in [1,2,4]]
inverseSeeds=[(R*power_mod(inverse_mod(base,q),p,q))%q for p in [1,2,4]]
tables=[]
for i in range(1024):
    z=power_mod(base,exponent(i),q)
    inverse=inverse_mod(z,q) if i else inverse_mod(2*z-1,q)
    tables.append([(R*z)%q,(R*inverse)%q])
assert tables[0][1]!=tables[1][1]
fixture={'seeds':seeds,'inverse_seeds':inverseSeeds,'tables':tables,
    'rev':[[i,rev(i,10)] for i in range(1024)],'terminal_k':12}
Path('PUBLIC_TABLES_FIXTURE.json').write_text(json.dumps(plain(fixture),indent=2)+'\n')
main=r'''
int main(void) {
  for(unsigned x=0;x<1024;x++)printf("R %u %u\n",x,rev10(x));
  printf("R %u %u\n",0xffffffffU,rev10(0xffffffffU));
  uint16_t gm[2050],igm[2050];
  for(size_t i=0;i<2050;i++)gm[i]=igm[i]=60000;
  mq_mkgm3(gm+1,igm+1,10);
  for(size_t i=0;i<2050;i++)printf("G %zu %u %u\n",i,(unsigned)gm[i],(unsigned)igm[i]);
  return 0;
}
'''
variants={'baseline':source,
    'nine_reversal_iterations':once(source,'for (i = 0; i < 10; i ++) {','for (i = 0; i < 9; i ++) {'),
    'preincrement_generator':once(source,'while (k ++ < TERNARY_LOGN_MAX) {','while (++ k < TERNARY_LOGN_MAX) {'),
    'wrong_inverse_zero':once(source,'R2t, mq_sub(mq_add(w, w, Qt), Rt, Qt));','R2t, mq_add(w, w, Qt));')}
records=[]
for mode,flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
  for variant,text in variants.items():
    text=once(text,'ig = mq_div_18433(R2t, g);',
      'printf("K %u %u\\n", k, g);\n\tig = mq_div_18433(R2t, g);')
    text=once(text,'ig4 = mq_montymul(ig2, ig2, Qt, Q0It);',
      'ig4 = mq_montymul(ig2, ig2, Qt, Q0It);\n\t\tprintf("S %u %u %u %u %u %u %u %u\\n",g,ig,x,ix,g2,g4,ig2,ig4);')
    label=mode+'_'+variant;cfile=Path(label+'.c');binary=Path(label+'.bin')
    cfile.write_text('#include <stdio.h>\n'+text+main)
    command=['gcc','-std=c99','-Wall','-Wextra','-Werror','-ffunction-sections','-fdata-sections']+profile['core']['Makefile_flags']+flags+[
      '-I',str(root),str(cfile),'-Wl,--gc-sections','-o',str(binary)]
    compiled=subprocess.run(command,capture_output=True)
    Path(label+'.compile.stdout').write_bytes(compiled.stdout);Path(label+'.compile.stderr').write_bytes(compiled.stderr)
    assert compiled.returncode==0 and not compiled.stdout and not compiled.stderr,label
    ran=subprocess.run([str(binary.resolve())],capture_output=True)
    Path(label+'.stdout').write_bytes(ran.stdout);Path(label+'.stderr').write_bytes(ran.stderr)
    Path(label+'.run.json').write_text(json.dumps({'returncode':ran.returncode})+'\n')
    assert ran.returncode==0 and not ran.stderr,label
    counts={tag:ZZ(0) for tag in ['R','K','S','G']};differences=[]
    for line in ran.stdout.decode().splitlines():
      tag,*payload=line.split();v=[ZZ(x) for x in payload];counts[tag]+=1
      if tag=='R':x,z=v;ok=z==rev(x,10)
      elif tag=='K':k,g=v;ok=k==12 and g==seeds[0]
      elif tag=='S':ok=v==[seeds[0],inverseSeeds[0],seeds[0],inverseSeeds[0],seeds[1],seeds[2],inverseSeeds[1],inverseSeeds[2]]
      elif tag=='G':
        i,g,ig=v;expected=tables[int(i-1)] if 1<=i<=1024 else [60000,60000]
        ok=[g,ig]==expected
      else:raise AssertionError(tag)
      if not ok:differences.append({'tag':tag,'ordinal':counts[tag]-1})
    assert counts=={'R':1025,'K':1,'S':1,'G':2050},counts
    assert bool(differences)==(variant!='baseline'),(label,differences[:10])
    artifacts=[cfile,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
    records.append({'mode':mode,'variant':variant,'counts':counts,'detected_differences':len(differences),
      'first_differences':differences[:20],'command':command,'artifacts':{str(p):digest(p) for p in artifacts}})
Path('PUBLIC_TABLES_CHECK.json').write_text(json.dumps(plain({'status':'PASS_FINITE_SOURCE_CONTROLS',
  'variants':records,'fixture_sha256':digest('PUBLIC_TABLES_FIXTURE.json'),'profile_sha256':digest(root/'PROFILE.json'),
  'source_pins':profile['core']['source_files'],'scope':'Focused finite rev10/table-prefix/full gm-igm controls; 1025 reversals, terminal post-increment and eight seeds, 2050 paired cells including untouched sentinels. Three mutations per normal/UBSan mode. NOT universal source table/transform correctness, full public/KeyGen acceptance, private keys or laws.'}),indent=2)+'\n')
