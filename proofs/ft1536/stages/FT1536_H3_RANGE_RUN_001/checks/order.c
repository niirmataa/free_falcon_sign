#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include "internal.h"
#include "../source/falcon-sign.c"
static size_t calls;
static long fault_at=-1;
static int local_sampler(void *ctx,fpr mu,fpr sigma) {
 (void)ctx;long fl=fpr_floor(mu);int z=(int)(calls%7)-3;int active=fault_at<0 || (long)calls<fault_at;int result=0;
 if(active){if(fl< -2147483283L||fl>2147483281L)abort();result=(int)fl+z;}
 printf("call %zu %016"PRIx64" %016"PRIx64" %d %d\n",calls,mu,sigma,result,active);calls++;return result;
}
static void show(const char *tag,const fpr *v,size_t n){printf("%s",tag);for(size_t i=0;i<n;i++)printf(" %016"PRIx64,v[i]);puts("");}
int main(int argc,char **argv) {
 if(argc!=2)return 2;const char *name=argv[1];
 if(!strcmp(name,"terminal_negzero")) {
  fpr tree=fpr_of(2),x=0,y=UINT64_C(0x8000000000000000),a,b,tmp[8];
  ffSampling_inner_fft3(local_sampler,NULL,&a,&b,&tree,&x,&y,0,tmp);show("out0",&a,1);show("out1",&b,1);return 0;
 }
 unsigned logn=10;size_t n=1536,tw=12*n;
 fpr *tree=malloc(tw*sizeof(fpr)),*old=malloc(tw*sizeof(fpr)),*leaves=malloc(n*sizeof(fpr));
 fpr *t0=malloc(n*sizeof(fpr)),*t1=malloc(n*sizeof(fpr)),*z0=malloc(n*sizeof(fpr)),*z1=malloc(n*sizeof(fpr)),*tmp=calloc(6*n,sizeof(fpr));
 if(!tree||!old||!leaves||!t0||!t1||!z0||!z1||!tmp)return 3;
 for(size_t i=0;i<tw;i++)tree[i]=fpr_div(fpr_of((int)(i%7)-3),fpr_of(8));
 if(!strcmp(name,"minusL"))for(size_t i=0;i<tw;i++)tree[i]=fpr_neg(tree[i]);
 if(!strcmp(name,"fault"))fault_at=5;
 memcpy(old,tree,tw*sizeof(fpr));
 for(size_t i=0;i<n;i++){leaves[i]=i%2?UINT64_C(0x4114444d1a037d50):UINT64_C(0x4090000053700377);t0[i]=fpr_div(fpr_of((int)(i%11)-5),fpr_of(8));t1[i]=fpr_div(fpr_of((int)(i%13)-6),fpr_of(4));}
 size_t leaf_count=0;size_t words=ffLDL_ternary_normalize(tree,fpr_of(768),logn,leaves,&leaf_count);
 printf("normalize %zu %zu\n",words,leaf_count);
 for(size_t i=0;i<tw;i++)if(tree[i]!=old[i])printf("leaf %zu %016"PRIx64"\n",i,tree[i]);
 ffSampling_fft3(local_sampler,NULL,z0,z1,tree,t0,t1,logn,tmp);
 show("out0",z0,n);show("out1",z1,n);printf("count %zu\n",calls);
 free(tree);free(old);free(leaves);free(t0);free(t1);free(z0);free(z1);free(tmp);return 0;
}
