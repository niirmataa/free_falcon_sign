#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <inttypes.h>
#include <assert.h>
#include <setjmp.h>
#include "../../../source/falcon-fft.c"
void forbidden_hash_extract(shake_context *,void *,size_t);
#define shake_extract forbidden_hash_extract
#include "../../../source/falcon-enc.c"
#undef shake_extract
#define FT_SAMPLER_ADAPTIVE_PROBE 0
#include "context.inc"
enum {NN=1536,SKN=24576,TN=10752};
static struct {uint64_t l;fpr a[SKN];uint64_t r;} key;
static struct {uint64_t l;fpr a[TN];uint64_t r;} scratch;
static fpr saved_key[SKN],expected_targets[3072];
static uint16_t challenge[NN],saved_challenge[NN];
static int16_t s1buf[NN+2],s2buf[NN+2];
static unsigned char output[4128];
struct mini_fs {unsigned q,logn,ternary;fpr *sk,*tmp;shake_context rng;};
static struct mini_fs fs0;
static struct {unsigned kind,fault;size_t proposals;uint64_t counter;} script[16];
static unsigned script_count,init_count,root_count,norm_count,encode_count,checked,any_bad,initializing;
static size_t blocks,extra_blocks,drops,abandoned,returned,last_ptr,shake_bytes;
static uint64_t counter_before;static jmp_buf precast_exit;
void forbidden_hash_extract(shake_context *s,void *out,size_t len){(void)s;(void)out;(void)len;abort();}
static uint64_t load64(const unsigned char *b){uint64_t v=0;for(unsigned i=0;i<8;i++)v|=(uint64_t)b[i]<<(8*i);return v;}
static void store64(unsigned char *b,uint64_t v){for(unsigned i=0;i<8;i++)b[i]=(unsigned char)(v>>(8*i));}
static void public_state56(shake_context *src,void *dst,size_t len){
 assert(src==&fs0.rng && len==56 && init_count>=1 && init_count<=script_count);
 unsigned char b[56];for(unsigned i=0;i<48;i++)b[i]=(unsigned char)(3*i+7);
 counter_before=script[init_count-1].counter;store64(b+48,counter_before);memcpy(dst,b,56);shake_bytes+=56;
 printf("SHAKE %u 56 %016" PRIx64 "\n",init_count,counter_before);
}
static void ideal_refill(prng *p){
 assert(p->type==PRNG_CHACHA20);uint64_t cc=load64(p->state.d+48);unsigned char keep[48];memcpy(keep,p->state.d,48);
 if(!initializing){assert(p->ptr>=4087 && p->ptr<=4096);drops+=4096-p->ptr;extra_blocks++;}
 for(size_t u=0;u<sizeof p->buf.d;u+=64)cc++;
 store64(p->state.d+48,cc);assert(memcmp(keep,p->state.d,48)==0);
 size_t id=blocks++;for(size_t i=0;i<4096;i++)p->buf.d[i]=(unsigned char)((id*101+i*29+(i>>4))%256);p->ptr=0;
}
#define shake_extract public_state56
#define falcon_prng_refill ideal_refill
#define falcon_prng_init original_init_slice
#include "prng_init.inc"
#undef falcon_prng_init
#undef falcon_prng_refill
#undef shake_extract
void falcon_prng_refill(prng *p){ideal_refill(p);}
static int init_observer(prng *p,shake_context *s,int type){
 if(init_count)abandoned+=4096-last_ptr;
 init_count++;assert(init_count<=16 && init_count<=script_count);initializing=1;size_t block=blocks;
 int ret=original_init_slice(p,s,type);initializing=0;assert(ret==1 && p->type==1 && p->ptr==0);
 printf("INIT %u %zu %016" PRIx64 " %d %zu\n",init_count,block,load64(p->state.d+48),p->type,p->ptr);return ret;
}
static void prepare_targets(fpr *tmp,const fpr *sk,const uint16_t *hm,unsigned logn,unsigned q){
 size_t n=NN,u;fpr *t0=tmp,*t1=tmp+NN;const fpr *b01=sk+NN,*b11=sk+3*NN;fpr ni;
#include "target_fill.inc"
#include "target_compute.inc"
}
static int sampler_large(void *ctx,fpr mu,fpr sigma){(void)ctx;(void)mu;(void)sigma;abort();}
static int sampler(void *ctx,fpr mu,fpr sigma){(void)ctx;(void)mu;(void)sigma;abort();}
static void make_wide(unsigned kind,int64_t *a,int64_t *b){
 for(size_t i=0;i<NN;i++)a[i]=b[i]=0;
 if(kind==1||kind==3){a[0]=a[1]=a[2]=32767;}
 if(kind==2||kind==3)b[0]=65536;
 if(kind==4){b[0]=-32768;b[768]=16384;b[1]=257;b[2]=-256;}
 if(kind==5){uint64_t rem=UINT64_C(2093922385);size_t i=0;while(rem){uint64_t z=0;while(z<32767 && (z+1)*(z+1)<=rem)z++;a[i++]=(int64_t)z;rem-=z*z;assert(i<768);}}
 if(kind==6){for(size_t i=0;i<768;i++){b[i]=i<330?1792:1536;b[i+768]=-b[i];}}
}
static void scripted_root(samplerZ samp,void *ctx,int16_t *s1,int16_t *s2,unsigned q,const fpr *sk,const uint16_t *hm,unsigned logn,unsigned ter,fpr *tmp){
 assert(samp==sampler_large && ctx!=NULL && q==18433 && logn==10 && ter==1 && sk==key.a && tmp==scratch.a && hm==challenge);
 ternary_sampler_context *tsc=ctx;assert(tsc->fault==0 && tsc->p.ptr==0 && tsc->p.type==1);root_count++;assert(root_count==init_count);
 prepare_targets(tmp,sk,hm,logn,q);assert(memcmp(tmp,expected_targets,sizeof expected_targets)==0);
 printf("TARGET %u",root_count);for(size_t i=0;i<3072;i++)printf(" %016" PRIx64,tmp[i]);putchar('\n');
 size_t T=script[root_count-1].proposals;
 for(size_t j=0;j<T;j++){(void)falcon_prng_get_u64(&tsc->p);(void)falcon_prng_get_u64(&tsc->p);(void)falcon_prng_get_u8(&tsc->p);(void)falcon_prng_get_u64(&tsc->p);(void)falcon_prng_get_u64(&tsc->p);returned+=33;}
 last_ptr=tsc->p.ptr;assert(last_ptr>=8 && last_ptr<=4094);
 printf("ROOT %u %zu %zu %016" PRIx64 "\n",root_count,T,last_ptr,load64(tsc->p.state.d+48));
 int64_t a[NN],b[NN];make_wide(script[root_count-1].kind,a,b);
 for(size_t i=0;i<NN;i++){
  if(a[i]<-32768||a[i]>32767){any_bad=1;if(checked)longjmp(precast_exit,1);}s1[i]=(int16_t)a[i];
  if(b[i]<-32768||b[i]>32767){any_bad=1;if(checked)longjmp(precast_exit,1);}s2[i]=(int16_t)b[i];
 }
 tsc->fault=script[root_count-1].fault;
 for(size_t i=0;i<TN;i++)tmp[i]=UINT64_C(0x5a5a5a5a5a5a5a5a)^(uint64_t)(root_count+i);
 printf("COMPLETE %u %u %u\n",root_count,tsc->fault,any_bad);
}
static int norm_observer(const int16_t *s1,const int16_t *s2,unsigned logn,unsigned ter){int b=falcon_is_short(s1,s2,logn,ter);norm_count++;printf("NORM %u %d\n",root_count,b);return b;}
static size_t encode_observer(void *out,size_t cap,int comp,unsigned q,const int16_t *s2,unsigned logn){encode_count++;size_t n=falcon_encode_small(out,cap,comp,q,s2,logn);printf("ENCODE %u %zu %zu\n",root_count,cap,n);return n;}
static size_t original_region(struct mini_fs *fs,void *sig,size_t sig_max_len,int comp,const uint16_t *hm,int16_t *s1,int16_t *s2){
 unsigned char *sig_buf;size_t sig_len;
#define falcon_prng_init init_observer
#define do_sign scripted_root
#define falcon_is_short norm_observer
#define falcon_encode_small encode_observer
#include "retry_region.inc"
#undef falcon_prng_init
#undef do_sign
#undef falcon_is_short
#undef falcon_encode_small
}
int main(void){
 size_t cap;assert(scanf("%u %zu %u",&checked,&cap,&script_count)==3 && checked<=1 && cap>=2 && cap<=4096 && script_count>0 && script_count<=16);
 for(unsigned j=0;j<script_count;j++)assert(scanf("%u %u %zu %" SCNu64,&script[j].kind,&script[j].fault,&script[j].proposals,&script[j].counter)==4 && script[j].kind<=6 && script[j].proposals>=1 && script[j].proposals<=50000);
 key.l=scratch.l=UINT64_C(0x123456789abcdef0);key.r=scratch.r=UINT64_C(0x0fedcba987654321);
 for(size_t i=0;i<SKN;i++)key.a[i]=0;
 for(size_t i=0;i<768;i++){key.a[i]=fpr_of(1);key.a[NN+i]=fpr_of(-1);key.a[3*NN+i]=fpr_of(-128);}
 for(size_t i=0;i<NN;i++)challenge[i]=(uint16_t)((i*7+13)%18433);
 memcpy(saved_key,key.a,sizeof saved_key);memcpy(saved_challenge,challenge,sizeof challenge);prepare_targets(scratch.a,key.a,challenge,10,18433);memcpy(expected_targets,scratch.a,sizeof expected_targets);
 for(size_t i=0;i<TN;i++)scratch.a[i]=UINT64_C(0xaaaaaaaaaaaaaaaa);
 for(size_t i=0;i<NN+2;i++)s1buf[i]=s2buf[i]=12345;
 memset(output,0xa5,sizeof output);fs0.q=18433;fs0.logn=10;fs0.ternary=1;fs0.sk=key.a;fs0.tmp=scratch.a;
 static size_t result;int exit=setjmp(precast_exit);if(!exit)result=original_region(&fs0,output+16,cap,FALCON_COMP_STATIC,challenge,s1buf+1,s2buf+1);
 assert(init_count==root_count && init_count<=16 && encode_count<=1);
 assert(memcmp(saved_key,key.a,sizeof saved_key)==0 && memcmp(saved_challenge,challenge,sizeof challenge)==0);
 assert(s1buf[0]==12345 && s1buf[NN+1]==12345 && s2buf[0]==12345 && s2buf[NN+1]==12345);
 assert(key.l==UINT64_C(0x123456789abcdef0) && scratch.l==key.l && key.r==UINT64_C(0x0fedcba987654321) && scratch.r==key.r);
 for(size_t i=0;i<16;i++)assert(output[i]==0xa5);
 for(size_t i=16+cap;i<sizeof output;i++)assert(output[i]==0xa5);
 size_t unused=4096-last_ptr;assert(4096*blocks==returned+drops+abandoned+unused);
 printf("RESULT %s %zu %u %u %u %u\n",exit?"PRECAST_EXIT":(result?"BYTES":"ZERO"),exit?0:result,init_count,norm_count,encode_count,any_bad);
 printf("RESOURCE %zu %zu %zu %zu %zu %zu %zu\n",blocks,extra_blocks,returned,drops,abandoned,unused,shake_bytes);
 printf("BUFFER ");for(size_t i=0;i<cap;i++)printf("%02x",output[16+i]);putchar('\n');puts("FRAME_CANARIES_PASS");return 0;
}
