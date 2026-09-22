#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <setjmp.h>
#include "../source/internal.h"
#include "prerequisites.inc"
static void tr_split(fpr *,fpr *,const fpr *,unsigned),tr_merge(fpr *,const fpr *,const fpr *,unsigned);
static void tr_top_split(fpr *,fpr *,fpr *,const fpr *,unsigned),tr_top_merge(fpr *,const fpr *,const fpr *,const fpr *,unsigned);
static void tr_mul(fpr *,const fpr *,unsigned,unsigned),tr_add(fpr *,const fpr *,unsigned,unsigned),tr_sub(fpr *,const fpr *,unsigned,unsigned);
static fpr qa(fpr,fpr),qs(fpr,fpr),qm(fpr,fpr),qh(fpr),qo(int64_t);
static void *tr_copy(void *,const void *,size_t);
#define falcon_poly_split_deep_fft3 tr_split
#define falcon_poly_merge_deep_fft3 tr_merge
#define falcon_poly_split_top_fft3 tr_top_split
#define falcon_poly_merge_top_fft3 tr_top_merge
#define falcon_poly_mul_fft3 tr_mul
#undef falcon_poly_add_fft3
#define falcon_poly_add_fft3 tr_add
#undef falcon_poly_sub_fft3
#define falcon_poly_sub_fft3 tr_sub
#define fpr_add qa
#define fpr_sub qs
#define fpr_mul qm
#define fpr_half qh
#define fpr_of qo
#define memcpy tr_copy
#include "sampling.inc"
#undef falcon_poly_split_deep_fft3
#undef falcon_poly_merge_deep_fft3
#undef falcon_poly_split_top_fft3
#undef falcon_poly_merge_top_fft3
#undef falcon_poly_mul_fft3
#undef falcon_poly_add_fft3
#undef falcon_poly_sub_fft3
#undef fpr_add
#undef fpr_sub
#undef fpr_mul
#undef fpr_half
#undef fpr_of
#undef memcpy
enum {N=1536,T=10752,K=18432};
static struct {uint64_t lo;fpr v[K];uint64_t hi;} key;
static struct {uint64_t lo;fpr v[T];uint64_t hi;} temp;
static fpr saved_key[K],saved_inputs[3072];
static struct {char tag;int k,b;unsigned stutters;} tape[3072];
static unsigned call_index,fault,pre_floor;static size_t high=3072;static jmp_buf stop;
static size_t size(unsigned k,unsigned f){if(k>10||f>1||k<f)abort();return (size_t)(1+2*f)<<(k-f);}
static void addr(const fpr *p,size_t n,char *c,size_t *i) {
 uintptr_t x=(uintptr_t)p,a=(uintptr_t)key.v,b=(uintptr_t)temp.v;
 if(x>=a&&x<a+sizeof key.v&&(x-a)%8==0){*c='K';*i=(x-a)/8;if(*i+n>K)abort();return;}
 if(x>=b&&x<b+sizeof temp.v&&(x-b)%8==0){*c='T';*i=(x-b)/8;if(*i+n>T)abort();return;}abort();
}
static void mark(fpr *p,size_t n){char c;size_t i;addr(p,n,&c,&i);if(c!='T')abort();if(high<i+n)high=i+n;}
static void event(const char *s,size_t k,unsigned f,unsigned count,const fpr **p,unsigned outs){printf("P %s %zu %u %u",s,k,f,count);for(unsigned j=0;j<count;j++){char c;size_t i;addr(p[j],1,&c,&i);printf(" %c %zu",c,i);}printf(" %u\n",outs);}
static void values(const fpr *p,size_t n){printf("V %zu",n);for(size_t i=0;i<n;i++)printf(" %016" PRIx64,p[i]);putchar('\n');}
static void *tr_copy(void *d,const void *s,size_t bytes){if(bytes%8)abort();size_t n=bytes/8;char c;size_t i;addr(s,n,&c,&i);mark(d,n);void *r=memcpy(d,s,bytes);const fpr *p[]={d,s};event("COPY",n,0,2,p,1);values(d,n);return r;}
static void poly(const char *s,void (*fn)(fpr *,const fpr *,unsigned,unsigned),fpr *a,const fpr *b,unsigned k,unsigned f){size_t n=size(k,f);mark(a,n);char c;size_t i;addr(b,n,&c,&i);fn(a,b,k,f);const fpr *p[]={a,b};event(s,k,f,2,p,1);values(a,n);}
static void tr_mul(fpr *a,const fpr *b,unsigned k,unsigned f){poly("MUL",falcon_poly_mul_fft3,a,b,k,f);}
static void tr_add(fpr *a,const fpr *b,unsigned k,unsigned f){poly("ADD",falcon_poly_add3,a,b,k,f);}
static void tr_sub(fpr *a,const fpr *b,unsigned k,unsigned f){poly("SUB",falcon_poly_sub3,a,b,k,f);}
static void tr_split(fpr *a,fpr *b,const fpr *v,unsigned k){size_t n=(size_t)1<<k;mark(a,n/2);mark(b,n/2);falcon_poly_split_deep_fft3(a,b,v,k);const fpr *p[]={a,b,v};event("SPLIT",k,0,3,p,2);values(a,n/2);values(b,n/2);}
static void tr_merge(fpr *v,const fpr *a,const fpr *b,unsigned k){size_t n=(size_t)1<<k;mark(v,n);falcon_poly_merge_deep_fft3(v,a,b,k);const fpr *p[]={v,a,b};event("MERGE",k,0,3,p,1);values(v,n);}
static void tr_top_split(fpr *a,fpr *b,fpr *c,const fpr *v,unsigned k){if(k!=10)abort();mark(a,512);mark(b,512);mark(c,512);falcon_poly_split_top_fft3(a,b,c,v,k);const fpr *p[]={a,b,c,v};event("TOPSPLIT",k,1,4,p,3);values(a,512);values(b,512);values(c,512);}
static void tr_top_merge(fpr *v,const fpr *a,const fpr *b,const fpr *c,unsigned k){if(k!=10)abort();mark(v,N);falcon_poly_merge_top_fft3(v,a,b,c,k);const fpr *p[]={v,a,b,c};event("TOPMERGE",k,1,4,p,1);values(v,N);}
static fpr qop(char s,fpr a,fpr b,fpr z){printf("Q %c %016" PRIx64 " %016" PRIx64 " %016" PRIx64 "\n",s,a,b,z);return z;}
static fpr qa(fpr a,fpr b){return qop('A',a,b,fpr_add(a,b));}
static fpr qs(fpr a,fpr b){return qop('S',a,b,fpr_sub(a,b));}
static fpr qm(fpr a,fpr b){return qop('M',a,b,fpr_mul(a,b));}
static fpr qh(fpr a){return qop('H',a,0,fpr_half(a));}
static fpr qo(int64_t a){fpr z=fpr_of(a);printf("Q O %" PRId64 " 0000000000000000 %016" PRIx64 "\n",a,z);return z;}
static int numeric(fpr x){uint64_t a=x&UINT64_C(0x7fffffffffffffff);return ((x>>52)&2047)!=2047&&((x>>63)?a<=fpr_of(2147483283):a<fpr_of(2147483282));}
static int scripted(void *ctx,fpr mu,fpr sigma){
 if(ctx!=&fault||call_index>=3072)abort();
 unsigned i=call_index++;printf("C %u %016" PRIx64 " %016" PRIx64 " %u\n",i,mu,sigma,fault);
 if(fault){printf("R %u B 0\n",i);return 0;}
 pre_floor++;if(!numeric(mu))abort();
 static const uint64_t coefficients[5]={UINT64_C(0x3fb999999999999a),UINT64_C(0x3f9999999999999a),UINT64_C(0x3f7999999999999a),UINT64_C(0x3f5999999999999a),UINT64_C(0x3f45555555555555)};
 static const int supports[5]={29,59,118,235,365};unsigned bank=5;fpr dss=fpr_inv(fpr_mul(fpr_sqr(sigma),fpr_of(2)));
 for(unsigned j=0;j<5;j++)if(bank==5&&dss>=coefficients[j])bank=j;
 if(bank==5)abort();
 for(unsigned j=0;j<tape[i].stutters;j++)printf("J %u %u\n",i,j);
 if(tape[i].tag=='S'){printf("STOP %u\n",i);longjmp(stop,1);}
 if(tape[i].tag=='F'){fault=1;printf("R %u F 0\n",i);return 0;}
 if(tape[i].tag!='N'||tape[i].k<0||tape[i].k>supports[bank]||(tape[i].b!=0&&tape[i].b!=1))abort();
 int64_t z=(int64_t)fpr_floor(mu)+(tape[i].b?1+tape[i].k:-tape[i].k);if(z<INT32_MIN||z>INT32_MAX)abort();printf("R %u N %" PRId64 "\n",i,z);return (int)z;
}
int main(int argc,char **argv){
 if(argc!=2||sizeof(fpr)!=8||sizeof(long)!=8||sizeof(int)!=4)return 2;
 for(size_t i=0;i<K;i++)if(scanf("%" SCNx64,&key.v[i])!=1)return 3;
 memset(temp.v,0x5a,sizeof temp.v);for(size_t i=0;i<3072;i++)if(scanf("%" SCNx64,&temp.v[i])!=1)return 4;
 for(unsigned i=0;i<3072;i++)if(scanf(" %c %d %d %u",&tape[i].tag,&tape[i].k,&tape[i].b,&tape[i].stutters)!=4)return 5;
 memcpy(saved_key,key.v,sizeof saved_key);memcpy(saved_inputs,temp.v,sizeof saved_inputs);key.lo=temp.lo=UINT64_C(0x123456789abcdef0);key.hi=temp.hi=UINT64_C(0x0fedcba987654321);
 int stopped=setjmp(stop);
 if(!stopped){if(!strcmp(argv[1],"top"))ffSampling_fft3(scripted,&fault,temp.v+3072,temp.v+4608,key.v,temp.v,temp.v+1536,10,temp.v+6144);else if(!strcmp(argv[1],"base"))ffSampling_inner_fft3(scripted,&fault,temp.v+3072,temp.v+4608,key.v,temp.v,temp.v+1536,0,temp.v+6144);else return 6;}
 if(memcmp(saved_key,key.v,sizeof saved_key)||memcmp(saved_inputs,temp.v,sizeof saved_inputs)||key.lo!=UINT64_C(0x123456789abcdef0)||temp.lo!=key.lo||key.hi!=UINT64_C(0x0fedcba987654321)||temp.hi!=key.hi)abort();
 for(size_t i=3072;i<T;i++)if(temp.v[i]!=UINT64_C(0x5a5a5a5a5a5a5a5a)&&high<i+1)high=i+1;
 printf("T");for(size_t i=0;i<T;i++)printf(" %016" PRIx64,temp.v[i]);putchar('\n');
 printf("END %s %u %u %zu %u FRAME_CANARIES_PASS\n",stopped?"REJECTION_NONRETURN":"COMPLETED",call_index,fault,high,pre_floor);return 0;
}
