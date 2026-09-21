#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <limits.h>
#include "internal.h"
typedef char abi[(CHAR_BIT==8 && sizeof(int)==4 && sizeof(long)==8 && sizeof(int64_t)==8)?1:-1];
int main(int argc,char **argv){
 if(argc!=2)return 2;FILE *in=fopen(argv[1],"r");if(!in)return 3;
 uint64_t x;int z,domain;unsigned i=0;
 while(fscanf(in,"%"SCNx64" %d %d",&x,&z,&domain)==3){
  long sf=fpr_floor(x);int s=(int)sf;int64_t wide=(int64_t)s+z;
  if(domain && (sf!=s || wide<INT32_MIN || wide>INT32_MAX))return 4;
  if(!domain){printf("outside %u %016"PRIx64" %ld %d %"PRId64"\n",i++,x,sf,z,wide);continue;}
  int y=s+z;fpr os=fpr_of(s),oy=fpr_of(y);fpr r=fpr_sub(x,os),res=fpr_sub(x,oy),delta=fpr_sub(fpr_one,r);
  printf("inside %u %016"PRIx64" %ld %d %d %016"PRIx64" %016"PRIx64" %016"PRIx64" %016"PRIx64" %016"PRIx64"\n",i++,x,sf,z,y,os,oy,r,res,delta);
 }
 fclose(in);return 0;
}
