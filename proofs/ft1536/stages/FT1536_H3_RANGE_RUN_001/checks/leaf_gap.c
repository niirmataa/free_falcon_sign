#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdlib.h>
#include "internal.h"
#include "../source/falcon-sign.c"
static unsigned calls;
static int local(void *ctx,fpr mu,fpr sigma){
 (void)ctx;long s=fpr_floor(mu);
 if(s< -2147483283L||s>2147483281L){printf("first_unproved_center %u %016"PRIx64" %ld\n",calls,mu,s);exit(0);}
 int z=(int)calls-3;printf("prior %u %016"PRIx64" %016"PRIx64" %ld %d\n",calls,mu,sigma,s,z);calls++;return (int)s+z;
}
int main(void){
 /* Public arbitrary tree, not a private key and not claimed loader/KeyGen output. */
 fpr tree[4]={0,0,UINT64_C(0x4037ffffc16bfe5c),UINT64_C(0x3ff55311b09aeb8c)};
 tree[0]=fpr_of(INT64_C(4294967296));fpr t0[2]={0,0},t1[2]={0,0},z0[2],z1[2],tmp[16];
 ffSampling_inner_fft3(local,NULL,z0,z1,tree,t0,t1,1,tmp);return 4;
}
