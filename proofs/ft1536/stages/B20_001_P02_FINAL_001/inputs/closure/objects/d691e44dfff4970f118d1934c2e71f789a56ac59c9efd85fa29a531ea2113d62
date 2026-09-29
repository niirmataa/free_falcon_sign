#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../source/internal.h"
#include "prerequisites.inc"
static fpr obs_of(int64_t),obs_inverse(long);
static void obs_fft(fpr *,unsigned,unsigned),obs_mul(fpr *,const fpr *,unsigned,unsigned),obs_scale(fpr *,fpr,unsigned,unsigned);
static void *obs_copy(void *,const void *,size_t);
#define fpr_of obs_of
#define fpr_inverse_of obs_inverse
#define falcon_FFT3 obs_fft
#define falcon_poly_mul_fft3 obs_mul
#undef falcon_poly_mulconst_fft3
#define falcon_poly_mulconst_fft3 obs_scale
#define memcpy obs_copy
#include "target_prefix.inc"
#undef fpr_of
#undef fpr_inverse_of
#undef falcon_FFT3
#undef falcon_poly_mul_fft3
#undef falcon_poly_mulconst_fft3
#undef memcpy
enum {N=1536,SK=24576,TMP=10752};
static struct {uint64_t lo;fpr v[SK];uint64_t hi;} sk;
static struct {uint64_t lo;fpr v[TMP];uint64_t hi;} tmp;
static uint16_t hm[N],saved_hm[N];static int16_t s1[3072],s2[3072];
static fpr saved_sk[SK],lastfft[N],observed_ni;static size_t converts;
static void words(const fpr *v){printf("V");for(size_t i=0;i<N;i++)printf(" %016" PRIx64,v[i]);putchar('\n');}
static size_t offset(const fpr *p,const fpr *base,size_t cap) {
 uintptr_t a=(uintptr_t)p,b=(uintptr_t)base;if(a<b||a+N*sizeof(fpr)>b+cap*sizeof(fpr)||(a-b)%sizeof(fpr))abort();return (a-b)/sizeof(fpr);
}
static fpr obs_of(int64_t x){if(converts>=N||x<0||x>=18433)abort();fpr z=fpr_of(x);printf("O %zu %" PRId64 " %016" PRIx64 "\n",converts,x,z);converts++;return z;}
static fpr obs_inverse(long x){if(x!=18433)abort();observed_ni=fpr_inverse_of(x);printf("I %016" PRIx64 "\n",observed_ni);return observed_ni;}
static void obs_fft(fpr *v,unsigned k,unsigned full){if(offset(v,tmp.v,TMP)!=0||k!=10||full!=1||converts!=N)abort();falcon_FFT3(v,k,full);memcpy(lastfft,v,sizeof lastfft);puts("F");words(v);}
static void *obs_copy(void *d,const void *s,size_t size){if(d!=tmp.v+N||s!=tmp.v||size!=N*sizeof(fpr))abort();void *r=memcpy(d,s,size);if(memcmp(d,lastfft,size))abort();puts("C");words(d);return r;}
static void obs_mul(fpr *a,const fpr *b,unsigned k,unsigned full){size_t ia=offset(a,tmp.v,TMP),ib=offset(b,sk.v,SK);if(k!=10||full!=1)abort();fpr save[N];memcpy(save,b,sizeof save);falcon_poly_mul_fft3(a,b,k,full);if(memcmp(save,b,sizeof save))abort();printf("M %zu %zu\n",ia,ib);words(a);}
static void obs_scale(fpr *a,fpr x,unsigned k,unsigned full){size_t i=offset(a,tmp.v,TMP);if(k!=10||full!=1)abort();falcon_poly_mulconst3(a,x,k,full);printf("S %zu %016" PRIx64 "\n",i,x);words(a);}
int main(int argc,char **argv) {
 if(argc!=2||sizeof(long)!=8||sizeof(int)!=4||sizeof(fpr)!=8||sizeof(uint16_t)!=2)return 2;
 for(size_t i=0;i<N;i++){unsigned v;if(scanf("%u",&v)!=1||v>=18433)return 3;hm[i]=(uint16_t)v;}
 for(size_t i=0;i<SK;i++)sk.v[i]=UINT64_C(0x3ff0000000000000)+(i*UINT64_C(65537))%UINT64_C(4503599627370496);
 if(!strcmp(argv[1],"coeff")) {
  const size_t offsets[4]={1536,0,4608,3072};
  for(size_t j=0;j<4;j++) {
   fpr *v=sk.v+offsets[j];int bound=j<2?1:2047;
   for(size_t i=0;i<N;i++){int x;if(scanf("%d",&x)!=1||x< -bound||x>bound)return 4;v[i]=fpr_of(x);}
   falcon_FFT3(v,10,1);
   if(j==0||j==2)falcon_poly_neg_fft3(v,10,1);
  }
 }else if(!strcmp(argv[1],"words")) {
  for(size_t i=0;i<6144;i++)if(scanf("%" SCNx64,&sk.v[i])!=1)return 5;
 }else return 6;
 memcpy(saved_sk,sk.v,sizeof sk.v);memcpy(saved_hm,hm,sizeof hm);
 memset(tmp.v,0x5a,sizeof tmp.v);for(size_t i=0;i<3072;i++){s1[i]=0x1234;s2[i]=0x2345;}
 sk.lo=tmp.lo=UINT64_C(0x123456789abcdef0);sk.hi=tmp.hi=UINT64_C(0x0fedcba987654321);
 uint64_t context=UINT64_C(0x3141592653589793);
 /* No callback implementation or invocation: the literal slice ends before sampling. */
 target_prefix_slice(NULL,&context,s1,s2,18433,sk.v,hm,10,1,tmp.v);
 if(context!=UINT64_C(0x3141592653589793)||memcmp(saved_sk,sk.v,sizeof sk.v)||memcmp(saved_hm,hm,sizeof hm))abort();
 for(size_t i=3072;i<TMP;i++)if(tmp.v[i]!=UINT64_C(0x5a5a5a5a5a5a5a5a))abort();
 for(size_t i=0;i<3072;i++)if(s1[i]!=0x1234||s2[i]!=0x2345)abort();
 if(sk.lo!=UINT64_C(0x123456789abcdef0)||tmp.lo!=sk.lo||sk.hi!=UINT64_C(0x0fedcba987654321)||tmp.hi!=sk.hi)abort();
 printf("B");for(size_t i=0;i<6144;i++)printf(" %016" PRIx64,sk.v[i]);putchar('\n');
 printf("T0");for(size_t i=0;i<N;i++)printf(" %016" PRIx64,tmp.v[i]);putchar('\n');
 printf("T1");for(size_t i=0;i<N;i++)printf(" %016" PRIx64,tmp.v[N+i]);putchar('\n');
 printf("NI %016" PRIx64 "\n",observed_ni);puts("END 3072 24576 1536 OUTPUTS_CTX_CANARIES_FRAME_PASS");return 0;
}
