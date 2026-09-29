#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <assert.h>
#include <limits.h>
#include "../source/falcon-fft.c"
#include "../source/falcon-enc.c"
#define NN 1536
#define SENT UINT64_C(0x5a31bd278645ce09)
static void snapshot(const char *tag,unsigned k,const fpr *a,size_t n) {
 size_t i; printf("EV %s %u",tag,k); for(i=0;i<n;i++) printf(" %016" PRIx64,a[i]); putchar('\n');
}
#include "ifft_observer.inc"
static void original_suffix(const fpr *sk,fpr *tmp,int16_t *s1,int16_t *s2) {
 size_t n=NN,u; unsigned logn=10;
 fpr *t0=tmp,*t1=tmp+NN,*tx=tmp+2*NN,*ty=tmp+3*NN;
 const fpr *b00=sk,*b01=sk+NN,*b10=sk+2*NN,*b11=sk+3*NN;
#include "suffix_original.inc"
}
static void observed_suffix(const fpr *sk,fpr *tmp,int16_t *s1,int16_t *s2) {
 size_t n=NN,u; unsigned logn=10;
 fpr *t0=tmp,*t1=tmp+NN,*tx=tmp+2*NN,*ty=tmp+3*NN;
 const fpr *b00=sk,*b01=sk+NN,*b10=sk+2*NN,*b11=sk+3*NN;
#include "suffix_observer.inc"
}
static void readwords(fpr *a,size_t n) {
 size_t i; for(i=0;i<n;i++) { assert(scanf("%" SCNx64,&a[i])==1); assert(((a[i]>>52)&2047)<=1123); }
}
static void ints(const char *name,const int16_t *a) {
 size_t i;printf("%s",name);for(i=0;i<NN;i++)printf(" %d",(int)a[i]);putchar('\n');
}
static int rints(void) {
 fpr x; while(scanf("%" SCNx64,&x)==1) {
  int64_t w;assert(((x>>52)&2047)<=1072);w=fpr_rint(x);
  printf("%016" PRIx64 " %" PRId64 " %d\n",x,w,(int)(int16_t)w);
 } return 0;
}
static int inverse(void) {
 fpr a[NN+2],b[NN+2];a[0]=a[NN+1]=SENT;readwords(a+1,NN);memcpy(b,a,sizeof a);
 falcon_iFFT3(a+1,10,1);observed_iFFT3(b+1,10,1);
 assert(memcmp(a,b,sizeof a)==0 && a[0]==SENT && a[NN+1]==SENT);
 puts("CANARIES PASS");return 0;
}
static int post(void) {
 static fpr sk[24578],saved[24578],a[10754],b[10754];
 static int16_t s1[3074],s2[3074],q1[3074],q2[3074];size_t i;
 for(i=0;i<24578;i++)sk[i]=SENT^(uint64_t)i;
 readwords(sk+1,6144);memcpy(saved,sk,sizeof sk);
 for(i=0;i<10754;i++)a[i]=SENT^(uint64_t)i;
 readwords(a+1+2*NN,NN);readwords(a+1+3*NN,NN);memcpy(b,a,sizeof a);
 for(i=0;i<3074;i++)s1[i]=s2[i]=q1[i]=q2[i]=12345;
 original_suffix(sk+1,a+1,s1+1,s2+1);observed_suffix(sk+1,b+1,q1+1,q2+1);
 assert(memcmp(a,b,sizeof a)==0 && memcmp(sk,saved,sizeof sk)==0);
 assert(memcmp(s1,q1,sizeof s1)==0 && memcmp(s2,q2,sizeof s2)==0);
 assert(a[0]==SENT);for(i=6145;i<10754;i++)assert(a[i]==(SENT^(uint64_t)i));
 assert(s1[0]==12345 && s2[0]==12345);for(i=NN+1;i<3074;i++)assert(s1[i]==12345 && s2[i]==12345);
 for(i=0;i<2*NN;i++)assert(((a[i+1]>>52)&2047)<=1072);
 printf("W1");for(i=0;i<NN;i++)printf(" %" PRId64,fpr_rint(a[i+1]));putchar('\n');
 printf("W2");for(i=0;i<NN;i++)printf(" %" PRId64,fpr_rint(a[NN+i+1]));putchar('\n');
 ints("S1",s1+1);ints("S2",s2+1);snapshot("tx_final",0,a+1+2*NN,NN);snapshot("ty_final",0,a+1+3*NN,NN);
 puts("CANARIES PASS");return 0;
}
static int64_t norm_value(const int16_t *s1,const int16_t *s2) {
 size_t n,hn,u;int64_t s;unsigned logn=10;
#include "norm_original.inc"
 return s;
}
struct profile { unsigned ternary,q,logn; };
static size_t frame(void *sig,size_t sig_max_len,const int16_t *s2) {
 struct profile pub={1,18433,10};const struct profile *fs=&pub;
 int comp=FALCON_COMP_STATIC;unsigned char *sig_buf;size_t sig_len;
 if(sig_max_len<2)return 0;
#include "caller_original.inc"
}
static void hexbytes(const unsigned char *p,size_t n) { size_t i;for(i=0;i<n;i++)printf("%02x",p[i]); }
static int codec(int verbose) {
 int16_t a[NN],b[NN],dec[NN+2];int w;size_t i,j,L,r,cap,caps[7];
 unsigned char buf[30032],full[30000];
 for(i=0;i<NN;i++){assert(scanf("%d",&w)==1 && w>=-32768 && w<=32767);a[i]=(int16_t)w;}
 for(i=0;i<NN;i++){assert(scanf("%d",&w)==1 && w>=-32768 && w<=32767);b[i]=(int16_t)w;}
 printf("NORM %" PRId64 " %d\n",norm_value(a,b),falcon_is_short(a,b,10,1));
 L=falcon_encode_small(NULL,0,FALCON_COMP_STATIC,18433,b,10);assert(L>0 && L<30000);
 assert(falcon_encode_small(full,sizeof full,FALCON_COMP_STATIC,18433,b,10)==L);printf("BYTES %zu ",L);hexbytes(full,L);putchar('\n');
 caps[0]=0;caps[1]=1;caps[2]=L-1;caps[3]=L;caps[4]=4095;caps[5]=4096;caps[6]=L+1;
 for(j=0;j<7;j++) {
  cap=caps[j];memset(buf,0xa5,sizeof buf);r=falcon_encode_small(buf+16,cap,FALCON_COMP_STATIC,18433,b,10);
  assert(r==(cap>=L?L:0));for(i=0;i<16;i++)assert(buf[i]==0xa5);
  for(i=16+(cap<L?cap:L);i<sizeof buf;i++)assert(buf[i]==0xa5);
  assert(memcmp(buf+16,full,cap<L?cap:L)==0);
  printf("CAP %zu %zu",cap,r);if(verbose){putchar(' ');hexbytes(buf+16,cap<L?cap:L);}putchar('\n');
  assert(falcon_encode_small(NULL,cap,FALCON_COMP_STATIC,18433,b,10)==L);
  memset(buf,0xa5,sizeof buf);r=frame(buf+16,cap,b);
  assert(r==((cap>=L+1)?L+1:0));for(i=0;i<16;i++)assert(buf[i]==0xa5);
  if(r){assert(buf[16]==0xaa && memcmp(buf+17,full,L)==0);}
  else assert(buf[16]==0xa5);
  for(i=16+(cap<2?0:(cap<L+1?cap:L+1));i<sizeof buf;i++)assert(buf[i]==0xa5);
  printf("FRAME %zu %zu",cap,r);if(verbose){putchar(' ');hexbytes(buf+16,cap<2?0:(cap<L+1?cap:L+1));}putchar('\n');
 }
 for(i=0;i<NN+2;i++)dec[i]=12345;
 r=falcon_decode_small(dec+1,10,FALCON_COMP_STATIC,18433,full,L);assert(r==L && memcmp(dec+1,b,sizeof b)==0 && dec[0]==12345 && dec[NN+1]==12345);ints("DECODED",dec+1);
 full[L]=0xff;assert(falcon_decode_small(dec+1,10,FALCON_COMP_STATIC,18433,full,L+1)==L);
 assert(falcon_decode_small(dec+1,10,FALCON_COMP_STATIC,18433,full,L-1)==0);
 puts("CANARIES PASS");return 0;
}
int main(int argc,char **argv) {
 assert(CHAR_BIT==8 && sizeof(long)==8 && sizeof(int)==4 && sizeof(fpr)==8 && FALCON_COMP_STATIC==1);
 assert(argc==2);
 if(!strcmp(argv[1],"rint"))return rints();
 if(!strcmp(argv[1],"ifft"))return inverse();
 if(!strcmp(argv[1],"suffix"))return post();
 if(!strcmp(argv[1],"codec"))return codec(1);
 if(!strcmp(argv[1],"codec_brief"))return codec(0);
 return 2;
}
