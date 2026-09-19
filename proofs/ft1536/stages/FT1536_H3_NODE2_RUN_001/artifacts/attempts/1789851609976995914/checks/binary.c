#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../source/falcon-sign.c"
enum { RN=1536,PN=512,N=256,H=128 };
static fpr root_input[RN],parent[PN],saved_parent[PN],saved_children[2*N];
static fpr n3[3][PN],d3[2][PN],l3[3][PN],work3[PN];
static struct { uint64_t lo; fpr v[4*N]; uint64_t hi; } arena;
static struct { uint64_t lo; fpr v[2304]; uint64_t hi; } tree;
static void marks(void) { arena.lo=tree.lo=UINT64_C(0x123456789abcdef0);arena.hi=tree.hi=UINT64_C(0x0fedcba987654321); }
static void checkmarks(void) {
 if(arena.lo!=UINT64_C(0x123456789abcdef0)||tree.lo!=arena.lo||arena.hi!=UINT64_C(0x0fedcba987654321)||tree.hi!=arena.hi) abort();
}
static void binary_slice(void) {
 fpr *s0=arena.v,*s1=s0+N,*tmp=s1+N,*d=tmp+N;
 memcpy(saved_parent,parent,sizeof parent);marks();
 falcon_poly_split_deep_fft3(s0,s1,parent,9);falcon_poly_adj_fft3(s1,8,0);
 if(memcmp(saved_parent,parent,sizeof parent)) abort();
 memcpy(saved_children,s0,sizeof saved_children);
 LDL_dim2_fft3(d,tree.v,s0,s1,s0,8,0);
 if(memcmp(saved_children,s0,sizeof saved_children)) abort();
 checkmarks();
 for(size_t i=0;i<N;i++) printf("%016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 "\n",s0[i],s1[i],tree.v[i],d[i]);
}
int main(int argc,char **argv) {
 size_t i;
 if(argc<2||sizeof(long)!=8||sizeof(int)!=4||sizeof(fpr)!=8) return 2;
 if(!strcmp(argv[1],"half")) {
  uint64_t x;while(scanf("%" SCNx64,&x)==1) {fpr h=fpr_half(x);printf("%016" PRIx64 " %016" PRIx64 "\n",h,fpr_sub(h,fpr_of(0)));}return 0;
 }
 if(!strcmp(argv[1],"root")) {
  static fpr a[RN],c[RN],j[RN],l[RN],d[RN];
  for(i=0;i<768;i++) if(scanf("%" SCNx64 " %" SCNx64 " %" SCNx64 " %" SCNx64,&a[i],&c[i],&c[i+768],&j[i])!=4) return 3;
  LDL_dim2_fft3(d,l,a,c,j,10,1);
  for(i=0;i<768;i++) printf("%016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 "\n",l[i],l[i+768],d[i],d[i+768]);
  return 0;
 }
 if(!strcmp(argv[1],"frame")) {
  fpr *a=arena.v,*b=a+N,*tmp=b+N;fpr expect[N],localD[N];
  for(int k=-1;k<=1;k++) {
   for(i=0;i<N;i++) {a[i]=i<H?fpr_of(2):fpr_of(0);b[i]=i<H?fpr_of(k):fpr_of(0);}
   memcpy(saved_children,a,sizeof saved_children);marks();LDL_dim2_fft3(localD,expect,a,b,a,8,0);
   if(ffLDL_inner_fft3(tree.v,a,b,a,8,tmp)!=2304||memcmp(expect,tree.v,sizeof expect)||memcmp(saved_children,a,sizeof saved_children)) abort();
   checkmarks();
  }
  puts("DEFINED_PREFIX_FRAME_PASS 3 2304");return 0;
 }
 if(!strcmp(argv[1],"direct")) {
  for(i=0;i<PN;i++) if(scanf("%" SCNx64,&parent[i])!=1) return 4;
  binary_slice();return 0;
 }
 if(strcmp(argv[1],"pipeline")||argc!=3) return 5;
 int k=atoi(argv[2]);if(k<0||k>2) return 6;
 for(i=0;i<RN;i++) if(scanf("%" SCNx64,&root_input[i])!=1) return 7;
 falcon_poly_split_top_fft3(n3[0],n3[1],n3[2],root_input,10);
 falcon_poly_adj_fft3(n3[1],9,0);falcon_poly_adj_fft3(n3[2],9,0);
 LDL_dim3_fft3(d3[0],d3[1],l3[0],l3[1],l3[2],n3[0],n3[1],n3[0],n3[2],n3[1],n3[0],9,0,work3);
 memcpy(parent,k==0?n3[0]:d3[k-1],sizeof parent);
 binary_slice();return 0;
}
