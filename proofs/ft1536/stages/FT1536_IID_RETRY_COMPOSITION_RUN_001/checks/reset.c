#define main scheduler_control_main
#include "retry.c"
#undef main
static void observe(prng *p,unsigned n){
 size_t before=p->ptr;uint64_t w=n==8?falcon_prng_get_u64(p):(uint64_t)falcon_prng_get_u8(p);returned+=n;
 printf("GET %u %zu %zu %016" PRIx64 "\n",n,before,p->ptr,w);
}
int main(void){
 const size_t starts[]={0,4086,4087,4094,4095};
 for(unsigned c=0;c<6;c++){
  size_t start=starts[c<5?c:4];unsigned n=c==5?1:8;prng p;memset(&p,0x5a,sizeof p);
  init_count=root_count=norm_count=encode_count=any_bad=0;blocks=extra_blocks=drops=abandoned=returned=last_ptr=shake_bytes=0;script_count=2;script[0].counter=script[1].counter=UINT64_MAX-63;
  printf("CASE %u %zu %u\n",c,start,n);init_observer(&p,&fs0.rng,0);
  for(size_t i=0;i<start;i++){(void)falcon_prng_get_u8(&p);returned++;}
  observe(&p,n);last_ptr=p.ptr;init_observer(&p,&fs0.rng,0);observe(&p,8);last_ptr=p.ptr;
  size_t unused=4096-last_ptr;assert(4096*blocks==returned+drops+abandoned+unused);
  printf("ACCOUNT %zu %zu %zu %zu %zu %zu %zu\n",blocks,extra_blocks,returned,drops,abandoned,unused,shake_bytes);
 }
 return 0;
}
