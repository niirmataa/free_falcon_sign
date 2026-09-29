#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include <assert.h>
#include <setjmp.h>
#include <limits.h>
#include "../source/internal.h"
#include "../source/ft1536-adaptive-cdf-tables.h"
#define FT_SAMPLER_ADAPTIVE_PROBE 0
#include "context.inc"
#include "helpers.inc"
#include "cutoff.inc"
#include "cdf.inc"
static unsigned char tape[5][4096];
static size_t blocks=2,block,refills,drops,returned;
static jmp_buf exhausted;
static struct { uint64_t left;ternary_sampler_context c;uint64_t right; } guarded;
static void reset_context(size_t ptr,unsigned fault) {
 memset(&guarded,0x5a,sizeof guarded);guarded.c.p.ptr=ptr;guarded.c.p.type=PRNG_CHACHA20;guarded.c.fault=fault;
 memcpy(guarded.c.p.buf.d,tape[0],4096);block=refills=drops=returned=0;
}
void falcon_prng_refill(prng *p) {
 assert(p==&guarded.c.p && p->type==PRNG_CHACHA20 && p->ptr<=4096);
 if(block+1>=blocks)longjmp(exhausted,1);
 drops+=4096-p->ptr;block++;refills++;memcpy(p->buf.d,tape[block],4096);p->ptr=0;
}
static uint64_t observed_u64(prng *p) {
 size_t ob=block,op=p->ptr;uint64_t w=falcon_prng_get_u64(p);returned+=8;
 printf("G 8 %zu %zu %zu %zu %zu %zu %zu %016" PRIx64 "\n",ob,op,block,p->ptr-8,block,p->ptr,op>=4087?4096-op:0,w);return w;
}
static unsigned observed_u8(prng *p) {
 size_t ob=block,op=p->ptr;unsigned w=falcon_prng_get_u8(p);returned++;
 printf("G 1 %zu %zu %zu %zu %zu %zu 0 %016" PRIx64 "\n",ob,op,ob,op,block,p->ptr,(uint64_t)w);return w;
}
#include "proposal_original.inc"
#include "ber_original.inc"
#include "sampler_original.inc"
#include "proposal_observer.inc"
#include "ber_observer.inc"
#include "sampler_observer.inc"
static void put64(size_t off,uint64_t w) { size_t i;for(i=0;i<8;i++)tape[0][off+i]=(unsigned char)(w>>(8*i)); }
static void canaries(void) {
 size_t i;assert(guarded.left==UINT64_C(0x5a5a5a5a5a5a5a5a) && guarded.right==UINT64_C(0x5a5a5a5a5a5a5a5a));
 for(i=0;i<256;i++)assert(guarded.c.p.state.d[i]==0x5a);
 assert(guarded.c.p.type==PRNG_CHACHA20 && guarded.c.p.ptr<4096);
}
static int getters(void) {
 size_t p,i,j;blocks=2;
 for(j=0;j<2;j++)for(i=0;i<4096;i++)tape[j][i]=(unsigned char)((j*101+i*29+(i>>4))%256);
 for(p=0;p<4096;p++) {
  reset_context(p,0);printf("CASE %zu\n",p);
  (void)observed_u64(&guarded.c.p);(void)observed_u64(&guarded.c.p);(void)observed_u8(&guarded.c.p);(void)observed_u64(&guarded.c.p);(void)observed_u64(&guarded.c.p);canaries();
  printf("END %zu %zu %zu %zu\n",guarded.c.p.ptr,refills,drops,returned);
 }
 reset_context(4095,0);puts("U8_LAST");(void)observed_u8(&guarded.c.p);canaries();return 0;
}
static int cdfs(void) {
 uint64_t hi,lo;while(scanf("%" SCNx64 " %" SCNx64,&hi,&lo)==2){int a[5];size_t i;ft_adaptive_cdf_samples(hi,lo,a);for(i=0;i<5;i++)printf("%s%d",i?" ":"",a[i]);putchar('\n');}return 0;
}
static int primitives(void) {
 uint64_t x,y,w,z;while(scanf("%" SCNx64 " %" SCNx64 " %" SCNx64 " %" SCNx64,&x,&y,&w,&z)==4) {
  assert(w<(UINT64_C(1)<<55) && z<(UINT64_C(1)<<56));
  printf("%016" PRIx64 " %016" PRIx64 " %u\n",fpr_mul_high_u64(x,y),(uint64_t)fpr_trunc(x),(unsigned)((w-z)>>63));
 }return 0;
}
static void print_ber(fpr x,int accepted) {
 int e=(int)fpr_floor(fpr_mul(x,fpr_inv_ln2));fpr r=fpr_sub(x,fpr_mul(fpr_of(e),fpr_log2));uint64_t scaled=fpr_mul(r,fpr_p63),z=(uint64_t)fpr_trunc(scaled)<<1,y=fpr_expm_p63_coefficients[0];unsigned i,safe,over;
 ft_berexp_cutoff_state((uint32_t)e,&safe,&over);
 printf(" %d %u %u %d %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64,e,safe,over,accepted,r,scaled,z,fpr_expm_scaled(r)>>8);
 printf(" %016" PRIx64,y);for(i=1;i<13;i++){y=fpr_expm_p63_coefficients[i]-fpr_mul_high_u64(z,y);printf(" %016" PRIx64,y);}putchar('\n');
}
static int berexps(void) {
 uint64_t x,w0,w1;while(scanf("%" SCNx64 " %" SCNx64 " %" SCNx64,&x,&w0,&w1)==3) {
  assert((x>>63)==0 && ((x>>52)&2047)<1042);memset(tape,0,sizeof tape);put64(0,w0);put64(8,w1);reset_context(0,0);
  int b=BerExp(&guarded.c.p,x);printf("B");print_ber(x,b);assert(guarded.c.p.ptr==16);canaries();
 }return 0;
}
static int iterations(void) {
 uint64_t mu,sigma,hi,lo,w0,w1;unsigned bit;
 while(scanf("%" SCNx64 " %" SCNx64 " %" SCNx64 " %" SCNx64 " %u %" SCNx64 " %" SCNx64,&mu,&sigma,&hi,&lo,&bit,&w0,&w1)==7) {
  int s,k,b,z;int64_t kk;unsigned proposal_level;fpr r,dss,x,inv_2sigma0_sq,delta,gap,tail_term;
  prng *p=&guarded.c.p;ternary_sampler_context *tsc=&guarded.c;
  assert(ft_fpr_is_finite(mu) && ((mu>>52)&2047)<=1053 && ft_fpr_is_positive_finite(sigma));
  memset(tape,0,sizeof tape);put64(0,hi);put64(8,lo);tape[0][16]=(unsigned char)bit;put64(17,w0);put64(25,w1);reset_context(0,0);
#include "entry.inc"
  assert(ft_fpr_is_positive_finite(dss) && ft_adaptive_proposal(p,dss,&k,&inv_2sigma0_sq,&proposal_level));
#include "iteration.inc"
  assert(ft_fpr_is_nonnegative_finite(x));int accept=BerExp(p,x);
  printf("I %d %d %u %d %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64,s,k,proposal_level,s+z,r,dss,inv_2sigma0_sq,delta,gap,tail_term,x);print_ber(x,accept);
  assert(p->ptr==33 && tsc->fault==0);canaries();
 }return 0;
}
static int sampler_case(void) {
 uint64_t mu,sigma;size_t ptr,i,j;unsigned fault,h;static ternary_sampler_context original;
 static int original_stop,original_return,ret;static size_t original_refills,original_drops;
 assert(scanf("%" SCNx64 " %" SCNx64 " %zu %u %zu",&mu,&sigma,&ptr,&fault,&blocks)==5 && ptr<4096 && blocks>0 && blocks<=5);
 for(j=0;j<blocks;j++)for(i=0;i<4096;i++){assert(scanf("%2x",&h)==1);tape[j][i]=(unsigned char)h;}
 reset_context(ptr,fault);original_return=0;original_stop=setjmp(exhausted);if(!original_stop)original_return=sampler_large(&guarded.c,mu,sigma);
 memcpy(&original,&guarded.c,sizeof original);original_refills=refills;original_drops=drops;canaries();
 reset_context(ptr,fault);ret=0;int stop=setjmp(exhausted);if(!stop)ret=observed_sampler(&guarded.c,mu,sigma);
 assert(stop==original_stop && ret==original_return && memcmp(&original,&guarded.c,sizeof original)==0 && refills==original_refills && drops==original_drops);canaries();
 printf("RESULT %s",stop?"HARNESS_EXHAUSTED":(guarded.c.fault?"FAULT_RETURN":"NORMAL_RETURN"));
 if(stop)printf(" NONE");else printf(" %d",ret);
 printf(" %u %zu %zu %zu %zu\n",guarded.c.fault,guarded.c.p.ptr,refills,drops,returned);return 0;
}
int main(int argc,char **argv) {
 assert(argc==2 && sizeof(long)==8 && sizeof(int)==4 && CHAR_BIT==8 && CT_BEREXP==1 && FT_TERNARY_ADAPTIVE_CDF==1);
 if(!strcmp(argv[1],"getters"))return getters();
 if(!strcmp(argv[1],"cdf"))return cdfs();
 if(!strcmp(argv[1],"primitive"))return primitives();
 if(!strcmp(argv[1],"ber"))return berexps();
 if(!strcmp(argv[1],"iter"))return iterations();
 if(!strcmp(argv[1],"sampler"))return sampler_case();
 return 2;
}
