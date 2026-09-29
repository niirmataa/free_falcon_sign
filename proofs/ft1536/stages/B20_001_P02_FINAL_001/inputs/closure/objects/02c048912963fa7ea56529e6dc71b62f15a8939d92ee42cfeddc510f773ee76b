#define main iid_original_main
#include "kernel.c"
#undef main
static int extra_expm(void) {
 uint64_t r;
 while(scanf("%" SCNx64,&r)==1) {
  uint64_t m=fpr_mul(r,fpr_p63),tr=(uint64_t)fpr_trunc(m),z=tr<<1,y=fpr_expm_p63_coefficients[0];unsigned i;
  assert(((r>>52)&2047)<=1023);
  printf("%016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64,m,tr,z,y);
  for(i=1;i<13;i++){y=fpr_expm_p63_coefficients[i]-fpr_mul_high_u64(z,y);printf(" %016" PRIx64,y);}
  printf(" %016" PRIx64 "\n",fpr_expm_scaled(r));
 }return 0;
}
static int extra_mul(void) {
 uint64_t x,y;while(scanf("%" SCNx64 " %" SCNx64,&x,&y)==2)printf("%016" PRIx64 "\n",fpr_mul(x,y));return 0;
}
static int extra_center(void) {
 uint64_t mu;while(scanf("%" SCNx64,&mu)==1){int64_t s=fpr_floor(mu);fpr r=fpr_sub(mu,fpr_of(s)),d=fpr_sub(fpr_one,r);printf("%" PRId64 " %016" PRIx64 " %016" PRIx64 "\n",s,r,d);}return 0;
}
static int extra_leaf(void) {
 uint64_t raw;while(scanf("%" SCNx64,&raw)==1){
  fpr tree[4]={UINT64_C(12345),UINT64_C(67890),0,0},leaves[2]={raw,raw},sigma=fpr_of(768);size_t index=0;size_t *leaf_index=&index;
#include "normalizer_leaf.inc"
  assert(index==2 && tree[0]==12345 && tree[1]==67890 && tree[2]==tree[3]);
  printf("%016" PRIx64 " %016" PRIx64 " %016" PRIx64 "\n",fpr_sqrt(raw),tree[2],fpr_mul(tree[2],fpr_IW1I));
 }return 0;
}
int main(int argc,char **argv) {
 assert(argc==2);
 if(!strcmp(argv[1],"expm"))return extra_expm();
 if(!strcmp(argv[1],"mul"))return extra_mul();
 if(!strcmp(argv[1],"center"))return extra_center();
 if(!strcmp(argv[1],"leaf"))return extra_leaf();
 return iid_original_main(argc,argv);
}
