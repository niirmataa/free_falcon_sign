#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../source/internal.h"
static fpr oadd(fpr,fpr), omul(fpr,fpr), odiv(fpr,fpr), osqrt(fpr), ohalf(fpr), odouble(fpr);
#define fpr_add oadd
#define fpr_mul omul
#define fpr_div odiv
#define fpr_sqrt osqrt
#define fpr_half ohalf
#define fpr_double odouble
/* Original helpers/suffix. Observation calls each original primitive exactly once. */
#include "../source/falcon-sign.c"
#include "keygen_stable.inc"
#include "keygen_tail.inc"
#include "signer_tail.inc"
static size_t observe_normalize_call(fpr *,fpr,unsigned,const fpr *,size_t *);
#define ffLDL_ternary_normalize observe_normalize_call
#include "suffix.inc"
#undef ffLDL_ternary_normalize
#undef fpr_add
#undef fpr_mul
#undef fpr_div
#undef fpr_sqrt
#undef fpr_half
#undef fpr_double
static int observing;
static size_t observed_leaf_count,observed_tree_words;
static size_t observe_normalize_call(fpr *tree,fpr sigma,unsigned logn,const fpr *leaves,size_t *count) {
 size_t words=ffLDL_ternary_normalize(tree,sigma,logn,leaves,count);
 observed_leaf_count=*count;observed_tree_words=words;return words;
}
static fpr logop(char op,fpr x,fpr y,fpr z) {
 if(observing)printf("%c %016" PRIx64 " %016" PRIx64 " %016" PRIx64 "\n",op,x,y,z);
 return z;
}
static fpr oadd(fpr x,fpr y){return logop('+',x,y,fpr_add(x,y));}
static fpr omul(fpr x,fpr y){return logop('*',x,y,fpr_mul(x,y));}
static fpr odiv(fpr x,fpr y){return logop('/',x,y,fpr_div(x,y));}
static fpr osqrt(fpr x){return logop('s',x,0,fpr_sqrt(x));}
static fpr ohalf(fpr x){return logop('h',x,0,fpr_half(x));}
static fpr odouble(fpr x){return logop('d',x,0,fpr_double(x));}
static void printwords(const char *name,const fpr *x,size_t n) {
 printf("%s",name);for(size_t i=0;i<n;i++)printf(" %016" PRIx64,x[i]);putchar('\n');
}
/* Sigma-only deterministic selector; no sampler/PRNG or mu path is invoked. */
static unsigned bank_found(fpr dss) {
 unsigned found=0;
 for(unsigned i=0;i<FT_ADAPTIVE_CDF_LEVELS;i++) {
  fpr c=ft_fpr_from_bits(ft_adaptive_cdf_inv_2sigma0_sq_bits[i]);
  found|=(unsigned)(1^fpr_lt(dss,c));
 }
 return found;
}
static uint32_t gate_one(fpr *x,uint32_t bad) {
 uint64_t bits;uint32_t valid;
 *x=ft_stable_positive(*x,&bad);bits=ft_fpr_bits(*x);
 valid=(uint32_t)(1^(uint32_t)((bits-FT1536_LEAF_MIN_BITS)>>63));
 valid&=(uint32_t)(1^(uint32_t)((FT1536_LEAF_MAX_BITS-bits)>>63));
 bad|=valid^1U;return bad;
}
enum {N=1536,SK=24576,TMP=10752};
static struct {uint64_t lo;fpr v[SK];uint64_t hi;} sk;
static struct {uint64_t lo;fpr v[TMP];uint64_t hi;} tmp;
static struct {uint64_t lo;fpr v[1792];uint64_t hi;} mirror;
static fpr saved_sk[SK],roots[N],keyroots[N],f[N],g[N],nf[N],sg[N];
static int16_t coeff[2][N],saved_coeff[2][N];static unsigned char touched[SK];
static void mark_inner(size_t off,unsigned k) {
 if(k==1){if(touched[off+2]||touched[off+3])abort();touched[off+2]=touched[off+3]=1;return;}
 size_t n=(size_t)1<<k;mark_inner(off+n,k-1);mark_inner(off+n+((size_t)k<<(k-1)),k-1);
}
static void mark_all(void) {
 for(size_t b=0;b<2;b++)for(size_t k=0;k<3;k++)mark_inner(6144+1536+b*8448+1536+k*2304,8);
}
static void root_matching(void) {
 for(size_t i=0;i<N;i++){f[i]=fpr_of(coeff[0][i]);g[i]=fpr_of(coeff[1][i]);}
 falcon_FFT3(f,10,1);falcon_FFT3(g,10,1);memcpy(nf,f,sizeof nf);memcpy(sg,g,sizeof sg);
 falcon_poly_neg_fft3(nf,10,1);falcon_poly_mulselfadj_fft3(nf,10,1);falcon_poly_mulselfadj_fft3(sg,10,1);
 memcpy(keyroots,sg,sizeof keyroots);falcon_poly_add_fft3(keyroots,nf,10,1);
 falcon_poly_mulselfadj_fft3(f,10,1);falcon_poly_mulselfadj_fft3(g,10,1);memcpy(roots,f,sizeof roots);falcon_poly_add_fft3(roots,g,10,1);
 if(memcmp(roots,keyroots,sizeof roots))abort();
}
int main(int argc,char **argv) {
 if(argc!=2||sizeof(long)!=8||sizeof(int)!=4||sizeof(fpr)!=8)return 2;
 if(!strcmp(argv[1],"sqrt")) {uint64_t x;while(scanf("%" SCNx64,&x)==1)printf("%016" PRIx64 "\n",fpr_sqrt(x));return 0;}
 if(!strcmp(argv[1],"div")) {uint64_t x,y;while(scanf("%" SCNx64 " %" SCNx64,&x,&y)==2)printf("%016" PRIx64 "\n",fpr_div(x,y));return 0;}
 if(!strcmp(argv[1],"bits")) {
  uint64_t x,y;while(scanf("%" SCNx64 " %" SCNx64,&x,&y)==2) {
   fpr a=fpr_sqr(x),b=fpr_sqr(y),an=fpr_sqr(fpr_neg(x)),bn=fpr_sqr(fpr_neg(y));
   printf("%016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 "\n",a,an,b,bn,fpr_add(a,b),fpr_add(b,a));
  }return 0;
 }
 if(!strcmp(argv[1],"gate")) {
  uint64_t x;uint32_t bad;while(scanf("%" SCNx64 " %" SCNu32,&x,&bad)==2){bad=gate_one(&x,bad);printf("%016" PRIx64 " %" PRIu32 " %d\n",x,bad,bad==0);}return 0;
 }
 if(!strcmp(argv[1],"widths")) {
  uint64_t d;while(scanf("%" SCNx64,&d)==1){fpr r=fpr_sqrt(d),s=fpr_div(fpr_of(768),r),p=fpr_mul(fpr_IW1I,s);
   fpr ds=fpr_inv(fpr_mul(fpr_sqr(s),fpr_of(2))),dp=fpr_inv(fpr_mul(fpr_sqr(p),fpr_of(2)));
   printf("%016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %u %u\n",r,s,p,ds,dp,bank_found(ds),bank_found(dp));}return 0;
 }
 for(size_t i=0;i<SK;i++)sk.v[i]=UINT64_C(0x3ff0000000000000)+(i*UINT64_C(104729))%UINT64_C(4503599627370496);
 memcpy(saved_sk,sk.v,sizeof saved_sk);memset(tmp.v,0x5a,sizeof tmp.v);memset(mirror.v,0x6b,sizeof mirror.v);
 sk.lo=tmp.lo=mirror.lo=UINT64_C(0x123456789abcdef0);sk.hi=tmp.hi=mirror.hi=UINT64_C(0x0fedcba987654321);mark_all();
 int ok,mirror_ok;size_t lc=0,tw=0;fpr *leaves=NULL;
 if(!strcmp(argv[1],"roots")) {
  for(size_t i=0;i<N;i++)if(scanf("%" SCNx64,&roots[i])!=1)return 3;
  mirror_ok=keygen_stable_slice(roots,mirror.v);
  observing=1;ok=signer_roots_slice(tmp.v,&leaves,roots);tw=ffLDL_ternary_normalize(sk.v+6144,fpr_of(768),10,leaves,&lc);observing=0;
 }else if(!strcmp(argv[1],"suffix")||!strcmp(argv[1],"suffix_alias")) {
  for(size_t a=0;a<2;a++)for(size_t i=0;i<N;i++){int v;if(scanf("%d",&v)!=1||v< -2047||v>2047)return 4;coeff[a][i]=(int16_t)v;}
  memcpy(saved_coeff,coeff,sizeof coeff);int alias=!strcmp(argv[1],"suffix_alias");if(alias&&memcmp(coeff[0],coeff[1],sizeof coeff[0]))return 5;
  root_matching();mirror_ok=keygen_stable_slice(keyroots,mirror.v);
  observing=1;ok=normalization_suffix_slice(sk.v,tmp.v,coeff[0],alias?coeff[0]:coeff[1],10);observing=0;
  leaves=tmp.v+768;lc=observed_leaf_count;tw=observed_tree_words;
  if(memcmp(saved_coeff,coeff,sizeof coeff))abort();
 }else return 6;
 if(leaves!=tmp.v+768||lc!=1536||tw!=18432||ok!=mirror_ok||memcmp(leaves,mirror.v,N*sizeof(fpr)))abort();
 size_t count=0;for(size_t i=0;i<SK;i++) {if(touched[i])count++;else if(sk.v[i]!=saved_sk[i])abort();}
 if(count!=1536)abort();
 for(size_t i=3072;i<TMP;i++)if(tmp.v[i]!=UINT64_C(0x5a5a5a5a5a5a5a5a))abort();
 if(sk.lo!=UINT64_C(0x123456789abcdef0)||tmp.lo!=sk.lo||mirror.lo!=sk.lo||sk.hi!=UINT64_C(0x0fedcba987654321)||tmp.hi!=sk.hi||mirror.hi!=sk.hi)abort();
 printwords("G",roots,N);printwords("L",leaves,N);printwords("K",sk.v,SK);
 printf("END %d %zu %zu 1536 16896 6144 3072 FRAME_CANARIES_PASS\n",ok,lc,tw);return 0;
}
