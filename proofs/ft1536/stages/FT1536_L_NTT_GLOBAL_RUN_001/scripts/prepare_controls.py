"""Only generated observational copies are changed; source/ is immutable."""
import hashlib,json
from pathlib import Path
W=Path.cwd(); C=W/'checks'; C.mkdir(exist_ok=True)
source=(W/'source/falcon-vrfy.c').read_text()
pin='3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42'
assert hashlib.sha256(source.encode()).hexdigest()==pin
start=source.index('static void\nmq_NTT_ternary(');end=source.index('static void\nmq_NTT(',start)
section=source[start:end]
hooks=[
('a[u + hn] = mq_sub(mq_add(a0, a1, Qt), b, Qt);','ft_snap("froot",0,u+1,hn,a);'),
('a[v + ht] = mq_sub(a0, a1, Qt);','ft_snap("fbin",m,u1*ht+v-v1+1,ht,a);'),
('a[u + 2] = mq_add(fA, mq_add(fB2, fC1, Qt), Qt);','ft_snap("fcube",0,u/3+1,0,a);'),
('mq_add(f0, mq_add(f12, f21, Qt), Qt), Qt, Q0It);','ft_snap("icube",0,u/3+1,0,a);'),
('mq_sub(a0, a1, Qt), s, Qt, Q0It);','ft_snap("ibin",m,u1*ht+v-v1+1,ht,a);'),
('a[u + hn] = mq_add(b, b, Qt);','ft_snap("iroot",0,u+1,hn,a);'),
('a[u] = mq_montymul(a[u], ni, Qt, Q0It);','ft_snap("scale",0,u+1,0,a);')]
for anchor,hook in hooks:
    assert section.count(anchor)==1
    section=section.replace(anchor,anchor+'\n\t\t/* GLOBAL_TRACE */ '+hook)
obs=source[:start]+section+source[end:]
restored=''.join(l for l in obs.splitlines(keepends=True) if '/* GLOBAL_TRACE */' not in l)
assert restored==source
variants={'observer':obs,'noop':obs,'plain':source}
labels=obs.replace('s = gm_square[m + u1];','s = gm_square[m + (u1 ^ 1)];').replace('s = igm_square[m + u1];','s = igm_square[m + (u1 ^ 1)];')
assert labels!=obs
variants['labels']=labels
anchor='a[u + 1] = mq_add(fA, mq_add(fB1, fC2, Qt), Qt);'
variants['cubic_order']=obs.replace(anchor,anchor.replace('a[u + 1]','a[u + 2]')).replace('a[u + 2] = mq_add(fA, mq_add(fB2, fC1, Qt), Qt);','a[u + 1] = mq_add(fA, mq_add(fB2, fC1, Qt), Qt);')
anchor='ni = logn <= 9 ? INVNQt[logn] : mq_div_18433(Rt, (uint32_t)n);'
assert obs.count(anchor)==1
variants['scale']=obs.replace(anchor,anchor+'\n\tni = mq_add(ni, 1, Qt);')
anchor='a[v + ht] = mq_sub(a0, a1, Qt);\n\t\t/* GLOBAL_TRACE */ ft_snap("fbin"'
assert obs.count(anchor)==1
variants['read_after_write']=obs.replace(anchor,anchor.replace('mq_sub(a0, a1','mq_sub(a[v], a1'))
wrapper='''#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
static void ft_snap(const char *,size_t,size_t,size_t,const uint16_t *);
#include "VARIANT.c"
static void ft_snap(const char *p,size_t m,size_t n,size_t h,const uint16_t *a) {
  int yes=1;
  if (!strcmp(p,"froot")||!strcmp(p,"iroot")||!strcmp(p,"fbin")||!strcmp(p,"ibin"))
    yes=n==1||n==h||n==h+1||n==767||n==768;
  else if(!strcmp(p,"fcube")||!strcmp(p,"icube")) yes=n==1||n==255||n==256||n==511||n==512;
  else if(!strcmp(p,"scale")) yes=n==1||n==767||n==768||n==1535||n==1536;
  if(!yes) return;
  printf("%s %zu %zu",p,m,n);
  for(size_t i=0;i<1536;i++) printf(" %u",(unsigned)a[i]);
  putchar('\\n');
}
int main(int argc,char **argv) {
  if(argc!=2) return 2;
  FILE *in=fopen(argv[1],"r"); if(!in) return 3;
  uint16_t a[1536]; unsigned x;
  for(size_t i=0;i<1536;i++) { if(fscanf(in,"%u",&x)!=1||x>=18433) return 4; a[i]=(uint16_t)x; }
  fclose(in); ft_snap("input",0,0,0,a);
  mq_NTT(a,10,1); ft_snap("forward",0,1536,0,a);
  mq_iNTT(a,10,1); ft_snap("roundtrip",0,1536,0,a);
  return 0;
}
'''
records={}
for name,data in variants.items():
    (C/(name+'.c')).write_text(data)
    (C/(name+'_main.c')).write_text(wrapper.replace('VARIANT',name))
    records[name]=hashlib.sha256(data.encode()).hexdigest()
vectors=[[(17*i*i+31*i+7)%18433 for i in range(1536)],
         [18432 if i in [0,1,2,3,5,6,11,12,383,384,767,768,769,1534,1535] else 0 for i in range(1536)]]
for i,v in enumerate(vectors): (C/f'input{i}.txt').write_text(' '.join(map(str,v))+'\n')
data=dict(source_sha256=pin,removed_instrumentation_restores_source=True,observer_hooks=hooks,variant_sha256=records,
          mutations=['matched forward/inverse label swap','cubic output 1/2 swap','ni+1','forward read after first write'],
          note='labels mutation is deliberately inverse-consistent: roundtrip alone must miss it')
(W/'artifacts/control_binding.json').write_text(json.dumps(data,indent=2)+'\n')
print(json.dumps(data,indent=2))
