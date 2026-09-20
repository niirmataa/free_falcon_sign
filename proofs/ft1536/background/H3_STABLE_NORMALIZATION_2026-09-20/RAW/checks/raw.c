#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../source/internal.h"
static void tr_fft(fpr *,unsigned,unsigned);
static void tr_neg(fpr *,unsigned,unsigned);
static void tr_adj(fpr *,unsigned,unsigned);
static void tr_self(fpr *,unsigned,unsigned);
static void tr_add(fpr *,const fpr *,unsigned,unsigned);
static void tr_sub(fpr *,const fpr *,unsigned,unsigned);
static void tr_muladj(fpr *,const fpr *,unsigned,unsigned);
static void tr_mulauto(fpr *,const fpr *,unsigned,unsigned);
static void tr_divauto(fpr *,const fpr *,unsigned,unsigned);
static void tr_top(fpr *,fpr *,fpr *,const fpr *,unsigned);
static void tr_split(fpr *,fpr *,const fpr *,unsigned);
static fpr tr_of(int64_t);
#define falcon_FFT3 tr_fft
#undef falcon_poly_neg_fft3
#define falcon_poly_neg_fft3 tr_neg
#define falcon_poly_adj_fft3 tr_adj
#define falcon_poly_mulselfadj_fft3 tr_self
#undef falcon_poly_add_fft3
#define falcon_poly_add_fft3 tr_add
#undef falcon_poly_sub_fft3
#define falcon_poly_sub_fft3 tr_sub
#define falcon_poly_muladj_fft3 tr_muladj
#define falcon_poly_mul_autoadj_fft3 tr_mulauto
#define falcon_poly_div_autoadj_fft3 tr_divauto
#define falcon_poly_split_top_fft3 tr_top
#define falcon_poly_split_deep_fft3 tr_split
#define fpr_of tr_of
/* Original bodies; observers invoke original primitives once. No secret-key API call. */
#include "../source/falcon-sign.c"
#include "raw_prefix.inc"
#undef falcon_FFT3
#undef falcon_poly_neg_fft3
#undef falcon_poly_adj_fft3
#undef falcon_poly_mulselfadj_fft3
#undef falcon_poly_add_fft3
#undef falcon_poly_sub_fft3
#undef falcon_poly_muladj_fft3
#undef falcon_poly_mul_autoadj_fft3
#undef falcon_poly_div_autoadj_fft3
#undef falcon_poly_split_top_fft3
#undef falcon_poly_split_deep_fft3
#undef fpr_of
enum { NN=1536,SKN=24576,TMPN=10752 };
static struct { uint64_t lo; fpr v[SKN]; uint64_t hi; } sk;
static struct { uint64_t lo; fpr v[TMPN]; uint64_t hi; } work;
static int16_t coefficients[4][NN],saved_coefficients[4][NN];
static fpr saved_gram[3*NN],saved_basis[4*NN];
static size_t high_k,high_s,base_l,leaf_pairs;
static fpr leaf0,leaf1;static int pending,gram_saved;
static size_t ns(unsigned k,unsigned full) { if(k<1||k>10||full>1) abort(); return (size_t)(1+2*full)<<(k-full); }
static void address(const fpr *p,size_t n,char *tag,size_t *off) {
 uintptr_t x=(uintptr_t)p,a=(uintptr_t)sk.v,b=(uintptr_t)work.v;
 if(x>=a&&x<a+sizeof sk.v&&(x-a)%sizeof(fpr)==0) {*tag='K';*off=(x-a)/sizeof(fpr);if(*off+n>SKN) abort();return;}
 if(x>=b&&x<b+sizeof work.v&&(x-b)%sizeof(fpr)==0) {*tag='S';*off=(x-b)/sizeof(fpr);if(*off+n>TMPN) abort();return;}
 abort();
}
static void mark(fpr *p,size_t n) {char c;size_t i;address(p,n,&c,&i);size_t *h=c=='K'?&high_k:&high_s;if(*h<i+n)*h=i+n;}
static void finite_cap(const fpr *p,size_t n) {for(size_t i=0;i<n;i++) if((p[i]&UINT64_C(0x7fffffffffffffff))>(UINT64_C(1123)<<52)) abort();}
static void disjoint(const fpr *a,size_t n,const fpr *b,size_t m) {
 uintptr_t x=(uintptr_t)a,y=(uintptr_t)b;if(!(x+n*sizeof(fpr)<=y||y+m*sizeof(fpr)<=x))abort();
}
static void flush_leaf(void) {
 if(!pending)return;
 if(sk.v[base_l+2]!=leaf0||sk.v[base_l+3]!=leaf1)abort();
 printf("B %zu %016" PRIx64 " %016" PRIx64 "\n",base_l-6144,leaf0,leaf1);
 mark(sk.v+base_l+2,2);leaf_pairs++;pending=0;
}
static void event(const char *name,unsigned k,unsigned f,unsigned argc,const fpr **ptrs,unsigned outc) {
 printf("E %s %u %u %u",name,k,f,argc);
 for(unsigned j=0;j<argc;j++){char c;size_t i;address(ptrs[j],1,&c,&i);printf(" %c %zu",c,i);}
 printf(" %u\n",outc);
}
static void words(const fpr *p,size_t n) {printf("V %zu",n);for(size_t i=0;i<n;i++)printf(" %016" PRIx64,p[i]);putchar('\n');}
static void unary(const char *name,void (*fn)(fpr *,unsigned,unsigned),fpr *a,unsigned k,unsigned f) {
 size_t n=ns(k,f);char tag;size_t off;flush_leaf();address(a,n,&tag,&off);finite_cap(a,n);
 fn(a,k,f);mark(a,n);const fpr *ps[]={a};event(name,k,f,1,ps,1);words(a,n);
}
static void binary(const char *name,void (*fn)(fpr *,const fpr *,unsigned,unsigned),fpr *a,const fpr *b,unsigned k,unsigned f) {
 size_t n=ns(k,f);fpr save[NN];char tag;size_t off;flush_leaf();address(a,n,&tag,&off);address(b,n,&tag,&off);disjoint(a,n,b,n);finite_cap(a,n);finite_cap(b,n);memcpy(save,b,n*sizeof(fpr));
 if(!strcmp(name,"DIVAUTO")) {
  for(size_t i=0;i<n/2;i++)if(b[i]<UINT64_C(0x3fb0000000000000)||b[i]>UINT64_C(0x4220000000000000))abort();
  if(k==1&&!f){address(a,n,&tag,&base_l);if(tag!='K')abort();}
 }
 fn(a,b,k,f);if(memcmp(save,b,n*sizeof(fpr)))abort();mark(a,n);const fpr *ps[]={a,b};event(name,k,f,2,ps,1);words(a,n);
 if(!strcmp(name,"ADD")&&k==1&&!f){leaf0=b[0];leaf1=a[0];pending=1;}
}
static void tr_fft(fpr *a,unsigned k,unsigned f){unary("FFT",falcon_FFT3,a,k,f);}
static void tr_neg(fpr *a,unsigned k,unsigned f){unary("NEG",falcon_poly_neg3,a,k,f);}
static void tr_adj(fpr *a,unsigned k,unsigned f){unary("ADJ",falcon_poly_adj_fft3,a,k,f);}
static void tr_self(fpr *a,unsigned k,unsigned f){unary("SELF",falcon_poly_mulselfadj_fft3,a,k,f);}
static void tr_add(fpr *a,const fpr *b,unsigned k,unsigned f){binary("ADD",falcon_poly_add3,a,b,k,f);}
static void tr_sub(fpr *a,const fpr *b,unsigned k,unsigned f){binary("SUB",falcon_poly_sub3,a,b,k,f);}
static void tr_muladj(fpr *a,const fpr *b,unsigned k,unsigned f){binary("MULADJ",falcon_poly_muladj_fft3,a,b,k,f);}
static void tr_mulauto(fpr *a,const fpr *b,unsigned k,unsigned f){binary("MULAUTO",falcon_poly_mul_autoadj_fft3,a,b,k,f);}
static void tr_divauto(fpr *a,const fpr *b,unsigned k,unsigned f){binary("DIVAUTO",falcon_poly_div_autoadj_fft3,a,b,k,f);}
static void tr_top(fpr *a,fpr *b,fpr *c,const fpr *v,unsigned k) {
 fpr save[NN];char tag;size_t off;flush_leaf();if(k!=10)abort();address(a,512,&tag,&off);address(b,512,&tag,&off);address(c,512,&tag,&off);address(v,NN,&tag,&off);
 disjoint(a,512,b,512);disjoint(a,512,c,512);disjoint(b,512,c,512);disjoint(a,512,v,NN);disjoint(b,512,v,NN);disjoint(c,512,v,NN);finite_cap(v,NN);memcpy(save,v,sizeof save);
 if(!gram_saved){memcpy(saved_gram,work.v,sizeof saved_gram);memcpy(saved_basis,sk.v,sizeof saved_basis);gram_saved=1;}
 falcon_poly_split_top_fft3(a,b,c,v,k);if(memcmp(save,v,sizeof save))abort();mark(a,512);mark(b,512);mark(c,512);
 const fpr *ps[]={a,b,c,v};event("TOP",k,1,4,ps,3);words(a,512);words(b,512);words(c,512);
}
static void tr_split(fpr *a,fpr *b,const fpr *v,unsigned k) {
 fpr save[NN];char tag;size_t off;flush_leaf();if(k<2||k>9)abort();size_t n=(size_t)1<<k;
 address(a,n/2,&tag,&off);address(b,n/2,&tag,&off);address(v,n,&tag,&off);disjoint(a,n/2,b,n/2);disjoint(a,n/2,v,n);disjoint(b,n/2,v,n);finite_cap(v,n);memcpy(save,v,n*sizeof(fpr));
 falcon_poly_split_deep_fft3(a,b,v,k);if(memcmp(save,v,n*sizeof(fpr)))abort();mark(a,n/2);mark(b,n/2);
 const fpr *ps[]={a,b,v};event("SPLIT",k,0,3,ps,2);words(a,n/2);words(b,n/2);
}
static fpr tr_of(int64_t x){if(x<INT32_MIN||x>INT32_MAX)abort();fpr z=fpr_of(x);printf("O %" PRId64 " %016" PRIx64 "\n",x,z);return z;}
int main(int argc,char **argv) {
 if(argc!=2||sizeof(long)!=8||sizeof(int)!=4||sizeof(fpr)!=8)return 2;
 memset(sk.v,0xa5,sizeof sk.v);memset(work.v,0x5a,sizeof work.v);
 sk.lo=work.lo=UINT64_C(0x123456789abcdef0);sk.hi=work.hi=UINT64_C(0x0fedcba987654321);
 size_t count=0;
 if(!strcmp(argv[1],"gram")||!strcmp(argv[1],"alias")) {
  for(size_t i=0;i<3*NN;i++)if(scanf("%" SCNx64,&work.v[i])!=1)return 3;
  count=ffLDL_fft3(sk.v+4*NN,work.v,work.v+NN,!strcmp(argv[1],"alias")?work.v:work.v+2*NN,10,work.v+3*NN);
 }else if(!strcmp(argv[1],"prefix")||!strcmp(argv[1],"prefix_alias")) {
  for(size_t a=0;a<4;a++)for(size_t i=0;i<NN;i++){int v;if(scanf("%d",&v)!=1||v< -2047||v>2047)return 4;coefficients[a][i]=(int16_t)v;}
  memcpy(saved_coefficients,coefficients,sizeof coefficients);
  int alias=!strcmp(argv[1],"prefix_alias");if(alias&&(memcmp(coefficients[0],coefficients[3],sizeof coefficients[0])||memcmp(coefficients[1],coefficients[2],sizeof coefficients[1])))return 5;
  if(!raw_prefix_slice(sk.v,18433,coefficients[0],coefficients[1],alias?coefficients[1]:coefficients[2],alias?coefficients[0]:coefficients[3],10,1,work.v))return 6;
  if(memcmp(saved_coefficients,coefficients,sizeof coefficients))abort();
  count=18432;
 }else return 7;
 flush_leaf();
 if(count!=18432||leaf_pairs!=768||pending||!gram_saved||memcmp(saved_gram,work.v,sizeof saved_gram)||memcmp(saved_basis,sk.v,sizeof saved_basis)||high_s!=8192||high_k!=24576)abort();
 for(size_t i=8192;i<TMPN;i++)if(work.v[i]!=UINT64_C(0x5a5a5a5a5a5a5a5a))abort();
 if(sk.lo!=UINT64_C(0x123456789abcdef0)||work.lo!=sk.lo||sk.hi!=UINT64_C(0x0fedcba987654321)||work.hi!=sk.hi)abort();
 printf("K");for(size_t i=0;i<SKN;i++)printf(" %016" PRIx64,sk.v[i]);putchar('\n');
 puts("END 18432 8192 24576 1536 FRAME_CANARIES_PASS");return 0;
}
