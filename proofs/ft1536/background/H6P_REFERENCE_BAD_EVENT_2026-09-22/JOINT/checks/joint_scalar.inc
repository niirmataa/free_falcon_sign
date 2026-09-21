/* Public deterministic test blocks; not a seed or a replacement probability claim. */
#include <assert.h>
#include "../source/ft1536-adaptive-cdf-tables.h"
#define FT_SAMPLER_ADAPTIVE_PROBE 0
#include "context.inc"
#include "helpers.inc"
#include "cutoff.inc"
#include "cdf.inc"
static unsigned char public_blocks[128][4096];
static size_t block_count,block,refills,drops,returned;
static ternary_sampler_context sc;
void falcon_prng_refill(prng *p) {
 assert(p==&sc.p && p->type==PRNG_CHACHA20 && p->ptr<=4096 && block+1<block_count);
 drops+=4096-p->ptr;block++;refills++;memcpy(p->buf.d,public_blocks[block],4096);p->ptr=0;
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
static int checked_scalar(fpr mu,fpr sigma) {
 ternary_sampler_context initial=sc,final;size_t ib=block,ir=refills,id=drops,fb,fr,fd;
 int a=sampler_large(&sc,mu,sigma);final=sc;fb=block;fr=refills;fd=drops;
 sc=initial;block=ib;refills=ir;drops=id;
 int b=observed_sampler(&sc,mu,sigma);
 assert(a==b && memcmp(&sc,&final,sizeof sc)==0 && block==fb && refills==fr && drops==fd && sc.fault==0);
 for(size_t i=0;i<256;i++)assert(sc.p.state.d[i]==0x5a);
 return b;
}
