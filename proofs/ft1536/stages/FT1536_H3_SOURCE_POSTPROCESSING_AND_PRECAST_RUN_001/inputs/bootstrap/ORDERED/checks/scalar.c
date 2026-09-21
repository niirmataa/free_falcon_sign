#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../source/internal.h"
#include "scalar_helpers.inc"
int main(void){
 uint64_t mu,sigma,hi,lo,w0,w1;unsigned bit;
 while(scanf("%" SCNx64 " %" SCNx64 " %" SCNx64 " %" SCNx64 " %u %" SCNx64 " %" SCNx64,&mu,&sigma,&hi,&lo,&bit,&w0,&w1)==7){
  if(!ft_fpr_is_finite(mu)||!ft_fpr_is_positive_finite(sigma))return 2;
  int samples[5];ft_adaptive_cdf_samples(hi,lo,samples);
  int s=(int)fpr_floor(mu);fpr r=fpr_sub(mu,fpr_of(s));fpr dss=fpr_inv(fpr_mul(fpr_sqr(sigma),fpr_of(2)));
  unsigned found=0,selected=0;int k=0;uint64_t cbits=0;
  for(unsigned level=0;level<5;level++){fpr c=ft_fpr_from_bits(ft_adaptive_cdf_inv_2sigma0_sq_bits[level]);unsigned ge=(unsigned)(1^fpr_lt(dss,c)),take=(1U^found)&ge;uint64_t mask=(uint64_t)0-(uint64_t)take;k+=samples[level]*(int)take;selected+=level*take;cbits|=ft_adaptive_cdf_inv_2sigma0_sq_bits[level]&mask;found|=ge;}
  if(!found||!ft_fpr_is_positive_finite(dss))return 3;
  int b=(int)(bit&1),z=b?1+k:-k;fpr delta=b?fpr_sub(fpr_of(1),r):r,coefficient=ft_fpr_from_bits(cbits),gap=fpr_sub(dss,coefficient);
  if(!ft_fpr_is_nonnegative_finite(gap))return 4;
  int64_t kk=(int64_t)k*k;fpr x=fpr_mul(fpr_of(kk),gap);fpr tail=fpr_add(fpr_mul(fpr_of((int64_t)2*k),delta),fpr_sqr(delta));x=fpr_add(x,fpr_mul(tail,dss));if(!ft_fpr_is_nonnegative_finite(x))return 5;
  int bs=(int)fpr_floor(fpr_mul(x,fpr_inv_ln2));fpr br=fpr_sub(x,fpr_mul(fpr_of(bs),fpr_log2));uint32_t safe_s,over;ft_berexp_cutoff_state((uint32_t)bs,&safe_s,&over);if(safe_s>63)abort();
  uint64_t w=w0;w^=(w>>safe_s)<<safe_s;int accept=1-(int)((w|-w)>>63);accept&=1^(int)over;uint64_t threshold=fpr_expm_scaled(br)>>8;w=w1&(((uint64_t)1<<55)-1);accept&=(int)((w-threshold)>>63);
  printf("%d %d %u %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %d %u %u %016" PRIx64 " %016" PRIx64 " %d %d\n",s,k,selected,r,dss,delta,gap,x,bs,safe_s,over,br,threshold,accept,s+z);
 }
 return 0;
}
