#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../source/internal.h"
#define MKN(logn, ter) ((size_t)(1 + ((ter) << 1)) << ((logn) - (ter)))
#include "raw_tree.inc"
#include "stable_core.inc"
#include "normalize.inc"
static void words(const char *name,const fpr *a,size_t n){printf("%s",name);for(size_t i=0;i<n;i++)printf(" %016" PRIx64,a[i]);putchar('\n');}
int main(void){
 static fpr gram[4608],saved[4608];
 static struct {uint64_t lo;fpr v[18432];uint64_t hi;} tree;
 static struct {uint64_t lo;fpr v[4096];uint64_t hi;} scratch;
 static struct {uint64_t lo;fpr v[1792];uint64_t hi;} leaves;
 for(size_t i=0;i<4608;i++)if(scanf("%" SCNx64,&gram[i])!=1)return 2;
 memcpy(saved,gram,sizeof saved);tree.lo=scratch.lo=leaves.lo=UINT64_C(0x123456789abcdef0);tree.hi=scratch.hi=leaves.hi=UINT64_C(0x0fedcba987654321);
 size_t n=ffLDL_fft3(tree.v,gram,gram+1536,gram+3072,10,scratch.v);if(n!=18432||memcmp(saved,gram,sizeof saved))abort();words("RAW",tree.v,18432);
 uint32_t bad=0;ft_stable_top_branch(gram,leaves.v,leaves.v+1536,&bad);
 for(size_t i=0;i<768;i++)leaves.v[1535-i]=ft_stable_positive(fpr_div(fpr_of(339775489),leaves.v[i]),&bad);
 for(size_t i=0;i<1536;i++){leaves.v[i]=ft_stable_positive(leaves.v[i],&bad);uint64_t b=ft_fpr_bits(leaves.v[i]);bad|=(uint32_t)((b-UINT64_C(0x4090000053700377))>>63);bad|=(uint32_t)((UINT64_C(0x4114444d1a037d50)-b)>>63);}
 words("STABLE",leaves.v,1536);size_t count=0;n=ffLDL_ternary_normalize(tree.v,fpr_of(768),10,leaves.v,&count);if(n!=18432||count!=1536||memcmp(saved,gram,sizeof saved))abort();words("NORMALIZED",tree.v,18432);
 if(tree.lo!=UINT64_C(0x123456789abcdef0)||scratch.lo!=tree.lo||leaves.lo!=tree.lo||tree.hi!=UINT64_C(0x0fedcba987654321)||scratch.hi!=tree.hi||leaves.hi!=tree.hi)abort();
 printf("END %u 18432 1536 FRAME_CANARIES_PASS\n",bad);return 0;
}
