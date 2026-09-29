#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../source/internal.h"
#include "coefficients.inc"
static unsigned select_bank(fpr dss){unsigned found=0,level=0;for(unsigned i=0;i<5;i++){unsigned ge=(unsigned)(1^fpr_lt(dss,ft_adaptive_cdf_inv_2sigma0_sq_bits[i]));unsigned take=(1U^found)&ge;level+=i*take;found|=ge;}if(!found)abort();return level;}
int main(int argc,char **argv){
 if(argc!=2)return 2;
 if(!strcmp(argv[1],"cancel")){uint64_t a,b;while(scanf("%" SCNx64 " %" SCNx64,&a,&b)==2){fpr x=fpr_add(a,b),y=fpr_sub(x,b);printf("%016" PRIx64 " %016" PRIx64 "\n",x,y);}return 0;}
 if(!strcmp(argv[1],"imag")){fpr v[4]={fpr_of(28),fpr_of(28),fpr_of(1),fpr_of(-1)},a[2],b[2];falcon_poly_split_deep_fft3(a,b,v,2);printf("%016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 "\n",a[0],a[1],b[0],b[1]);return 0;}
 if(strcmp(argv[1],"terminal"))return 3;
 static const int support[5]={29,59,118,235,365};uint64_t d,t0,t1;unsigned mode;
 while(scanf("%" SCNx64 " %" SCNx64 " %" SCNx64 " %u",&d,&t0,&t1,&mode)==4){
  fpr s0=fpr_div(fpr_of(768),fpr_sqrt(d)),s1=fpr_mul(fpr_IW1I,s0);
  fpr ds0=fpr_inv(fpr_mul(fpr_sqr(s0),fpr_of(2))),ds1=fpr_inv(fpr_mul(fpr_sqr(s1),fpr_of(2)));
  unsigned j0=select_bank(ds0),j1=select_bank(ds1);int k0=(mode&4)?0:support[j0],k1=(mode&8)?0:support[j1];
  int a1=(int)fpr_floor(t1)+((mode&1)?1+k1:-k1);fpr r1=fpr_sub(t1,fpr_of(a1)),rx=fpr_half(r1),mu0=fpr_add(t0,rx);
  int a0=(int)fpr_floor(mu0)+((mode&2)?1+k0:-k0);fpr u0=fpr_sub(mu0,fpr_of(a0)),r0=fpr_sub(u0,rx);
  printf("%u %u %d %d",j0,j1,k0,k1);
  fpr vals[10]={s0,s1,ds0,ds1,r1,rx,mu0,u0,r0,d};for(size_t i=0;i<10;i++)printf(" %016" PRIx64,vals[i]);printf(" %d %d\n",a0,a1);
 }
 return 0;
}
