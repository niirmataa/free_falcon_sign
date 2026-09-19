#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include "internal.h"
#include "../source/falcon-sign.c"
int main(int argc,char **argv){
 if(argc!=2)return 2;FILE *in=fopen(argv[1],"r");if(!in)return 3;
 char tag[64];uint64_t bits;
 while(fscanf(in,"%63s %"SCNx64,tag,&bits)==2){
  long s=fpr_floor(bits);int narrowed=(int)s;
  printf("%s %016"PRIx64" %ld %d %"PRId64" %"PRId64"\n",tag,bits,s,narrowed,(int64_t)narrowed-365,(int64_t)narrowed+366);
 }
 fclose(in);
 for(unsigned i=0;i<5;i++)for(int d=-1;d<=1;d++){
  prng p;memset(&p,0,sizeof p);int k;unsigned level;fpr coef;
  uint64_t ds=ft_adaptive_cdf_inv_2sigma0_sq_bits[i]+d;
  int found=ft_adaptive_proposal(&p,ds,&k,&coef,&level);
  printf("proposal %016"PRIx64" %d %u %d %016"PRIx64"\n",ds,found,level,k,coef);
 }
 ternary_sampler_context t;memset(&t,0,sizeof t);memset(t.p.buf.d,0xff,sizeof t.p.buf.d);t.fault=0;
 int z=sampler_large(&t,UINT64_C(0x8000000000000000),UINT64_C(0x3ff8000000000000));
 printf("synthetic_active_negative_zero %d %d\n",z,t.fault);return 0;
}
