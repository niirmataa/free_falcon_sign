#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../source/internal.h"
static void traced_split(fpr *,fpr *,const fpr *,unsigned);
static void traced_div(fpr *,const fpr *,unsigned,unsigned);
static void traced_add(fpr *,const fpr *,unsigned,unsigned);
/* Same source bodies; observer wrappers call each original operation once. */
#define falcon_poly_split_deep_fft3 traced_split
#define falcon_poly_div_autoadj_fft3 traced_div
#undef falcon_poly_add_fft3
#define falcon_poly_add_fft3 traced_add
#include "../source/falcon-sign.c"
#undef falcon_poly_split_deep_fft3
#undef falcon_poly_div_autoadj_fft3
#undef falcon_poly_add_fft3
#define falcon_poly_add_fft3 falcon_poly_add3
static struct { uint64_t lo; fpr v[1024]; uint64_t hi; } tree;
static struct { uint64_t lo; fpr v[256]; uint64_t hi; } scratch;
static fpr entryA[128],entryB[128],saveA[128],saveB[128];
static int enabled=0,pending=0,active=0;
static size_t lastoff,pendoff;
static unsigned lastk;
static fpr oldB[128],*lastL;static const fpr *lastA;
static fpr pend0,pend1;
static size_t tree_offset(const fpr *p) {
 uintptr_t x=(uintptr_t)p,b=(uintptr_t)tree.v;
 if(x<b||x>=b+sizeof tree.v||(x-b)%sizeof(fpr)) abort();
 return (x-b)/sizeof(fpr);
}
static void address(const fpr *p,char *tag,size_t *off) {
 uintptr_t x=(uintptr_t)p;
 if(x>=(uintptr_t)scratch.v&&x<(uintptr_t)(scratch.v+256)) {*tag='S';*off=(x-(uintptr_t)scratch.v)/sizeof(fpr);return;}
 if(x>=(uintptr_t)entryA&&x<(uintptr_t)(entryA+128)) {*tag='A';*off=(x-(uintptr_t)entryA)/sizeof(fpr);return;}
 if(x>=(uintptr_t)entryB&&x<(uintptr_t)(entryB+128)) {*tag='B';*off=(x-(uintptr_t)entryB)/sizeof(fpr);return;}
 abort();
}
static void flush_base(void) {
 if(!pending) return;
 if(tree.v[pendoff+2]!=pend0||tree.v[pendoff+3]!=pend1) abort();
 printf("B %zu %016" PRIx64 " %016" PRIx64 "\n",pendoff,pend0,pend1);pending=0;
}
static void traced_split(fpr *a,fpr *b,const fpr *v,unsigned q) {
 if(enabled) {
  char x,y,z;size_t i,j,k;flush_base();address(a,&x,&i);address(b,&y,&j);address(v,&z,&k);
  if(q<2||q>7) abort();
  printf("S %u %c %zu %c %zu %c %zu\n",q,x,i,y,j,z,k);
 }
 falcon_poly_split_deep_fft3(a,b,v,q);
}
static void traced_div(fpr *a,const fpr *b,unsigned k,unsigned full) {
 if(enabled) {
  size_t n=(size_t)1<<k;flush_base();if(active||full||k<1||k>7) abort();
  lastoff=tree_offset(a);lastk=k;lastL=a;lastA=b;memcpy(oldB,a,n*sizeof *a);active=1;
 }
 falcon_poly_div_autoadj_fft3(a,b,k,full);
}
static void traced_add(fpr *a,const fpr *b,unsigned k,unsigned full) {
 falcon_poly_add_fft3(a,b,k,full);
 if(enabled) {
  size_t n=(size_t)1<<k;if(!active||full||k!=lastk||b!=lastA) abort();
  printf("N %u %zu\n",k,lastoff);
  for(size_t i=0;i<n;i++) printf("V %zu %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 "\n",i,lastA[i],oldB[i],lastL[i],a[i]);
  if(k==1) {pending=1;pendoff=lastoff;pend0=lastA[0];pend1=a[0];}
  active=0;
 }
}
int main(int argc,char **argv) {
 if(argc<2||sizeof(long)!=8||sizeof(int)!=4||sizeof(fpr)!=8) return 2;
 if(!strcmp(argv[1],"half")) {uint64_t x;while(scanf("%" SCNx64,&x)==1) printf("%016" PRIx64 "\n",fpr_half(x));return 0;}
 if(!strcmp(argv[1],"scalar")) {uint64_t x,y;while(scanf("%" SCNx64 " %" SCNx64,&x,&y)==2) printf("%016" PRIx64 " %016" PRIx64 "\n",fpr_mul(x,y),fpr_div(x,y));return 0;}
 if(strcmp(argv[1],"pipeline")||argc!=4) return 3;
 int diag=atoi(argv[2]),edge=atoi(argv[3]);if(diag<0||diag>2||edge<0||edge>1) return 4;
 static fpr root[1536],n3[3][512],d3[2][512],l3[3][512],w3[512],s8[2][256],l8[256],d8[256];
 for(size_t i=0;i<1536;i++) if(scanf("%" SCNx64,&root[i])!=1) return 5;
 falcon_poly_split_top_fft3(n3[0],n3[1],n3[2],root,10);falcon_poly_adj_fft3(n3[1],9,0);falcon_poly_adj_fft3(n3[2],9,0);
 LDL_dim3_fft3(d3[0],d3[1],l3[0],l3[1],l3[2],n3[0],n3[1],n3[0],n3[2],n3[1],n3[0],9,0,w3);
 falcon_poly_split_deep_fft3(s8[0],s8[1],diag==0?n3[0]:d3[diag-1],9);falcon_poly_adj_fft3(s8[1],8,0);
 LDL_dim2_fft3(d8,l8,s8[0],s8[1],s8[0],8,0);
 falcon_poly_split_deep_fft3(entryA,entryB,edge==0?s8[0]:d8,8);falcon_poly_adj_fft3(entryB,7,0);
 memcpy(saveA,entryA,sizeof entryA);memcpy(saveB,entryB,sizeof entryB);
 tree.lo=scratch.lo=UINT64_C(0x123456789abcdef0);tree.hi=scratch.hi=UINT64_C(0x0fedcba987654321);
 memset(tree.v,0xa5,sizeof tree.v);memset(scratch.v,0x5a,sizeof scratch.v);
 enabled=1;size_t count=ffLDL_inner_fft3(tree.v,entryA,entryB,entryA,7,scratch.v);flush_base();enabled=0;
 if(count!=1024||pending||active||memcmp(saveA,entryA,sizeof entryA)||memcmp(saveB,entryB,sizeof entryB)
  ||tree.lo!=UINT64_C(0x123456789abcdef0)||scratch.lo!=tree.lo||tree.hi!=UINT64_C(0x0fedcba987654321)||scratch.hi!=tree.hi) abort();
 for(size_t i=0;i<1024;i++) printf("T %zu %016" PRIx64 "\n",i,tree.v[i]);
 puts("END 1024 256 INPUTS_UNCHANGED CANARIES_PASS");return 0;
}
