#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdlib.h>
#include <string.h>
#include "internal.h"
#include "../source/falcon-sign.c"
int main(int argc,char **argv) {
 if(argc==2 && !strcmp(argv[1],"tables")) {
  for(unsigned l=0;l<5;l++) { printf("bank %u %016"PRIx64"\n",l,ft_adaptive_cdf_inv_2sigma0_sq_bits[l]);
   for(unsigned i=0;i<512;i++)printf("%016"PRIx64" %016"PRIx64"\n",ft_adaptive_cdf[l][i][0],ft_adaptive_cdf[l][i][1]); }
  return 0;
 }
 if(argc==2 && !strcmp(argv[1],"cdf")) {
  const uint64_t v[][2]={{0,0},{0,1},{UINT64_MAX,UINT64_MAX},{0,31},{0,30}};
  for(unsigned j=0;j<sizeof(v)/sizeof(v[0]);j++) { int a[5];ft_adaptive_cdf_samples(v[j][0],v[j][1],a);
   printf("cdf %016"PRIx64" %016"PRIx64,v[j][0],v[j][1]);for(int i=0;i<5;i++)printf(" %d",a[i]);puts(""); }
  return 0;
 }
 if(argc==2 && !strcmp(argv[1],"widths")) {
  const uint64_t ds[]={UINT64_C(0x4090000053700377),UINT64_C(0x4114444d1a037d50)};
  for(int i=0;i<2;i++){ fpr sig=fpr_div(fpr_of(768),fpr_sqrt(ds[i])),paired=fpr_mul(fpr_IW1I,sig);
   fpr d0=fpr_inv(fpr_mul(fpr_sqr(sig),fpr_of(2))),d1=fpr_inv(fpr_mul(fpr_sqr(paired),fpr_of(2)));
   printf("width %016"PRIx64" %016"PRIx64" %016"PRIx64" %016"PRIx64" %016"PRIx64"\n",ds[i],sig,paired,d0,d1); }
  return 0;
 }
 if(argc<3)return 2;
 uint64_t x=strtoull(argv[2],0,16),y=argc>3?strtoull(argv[3],0,16):0,z=0;
 if(!strcmp(argv[1],"floor")) {printf("%ld\n",fpr_floor(x));return 0;}
 if(!strcmp(argv[1],"guard")) {printf("%d %d %d\n",ft_fpr_is_finite(x),ft_fpr_is_positive_finite(y),ft_fpr_is_nonnegative_finite(x));return 0;}
 if(!strcmp(argv[1],"add"))z=fpr_add(x,y);
 else if(!strcmp(argv[1],"sub"))z=fpr_sub(x,y);
 else if(!strcmp(argv[1],"mul"))z=fpr_mul(x,y);
 else if(!strcmp(argv[1],"div"))z=fpr_div(x,y);
 else if(!strcmp(argv[1],"sqrt"))z=fpr_sqrt(x);
 else if(!strcmp(argv[1],"half"))z=fpr_half(x);
 else if(!strcmp(argv[1],"neg"))z=fpr_neg(x);
 else if(!strcmp(argv[1],"sticky")) {ternary_sampler_context t;memset(&t,0,sizeof t);t.fault=1;int r=sampler_large(&t,x,y);printf("%d %d\n",r,t.fault);return 0;}
 else return 3;
 printf("%016"PRIx64"\n",z);return 0;
}
