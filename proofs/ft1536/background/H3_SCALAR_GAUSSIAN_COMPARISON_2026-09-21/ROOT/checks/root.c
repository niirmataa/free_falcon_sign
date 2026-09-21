#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../source/falcon-sign.c"
/* Public synthetic arrays only; never call KeyGen, private loader or Sign. */
enum { N = 1536, H = 768 };
static fpr b[4][N], a[N], c[N], j[N], saved[3][N];
static struct { uint64_t lo; fpr v[N]; uint64_t hi; } l, d;
static void root(void) {
    memcpy(saved[0],a,sizeof a); memcpy(saved[1],c,sizeof c); memcpy(saved[2],j,sizeof j);
    l.lo=d.lo=UINT64_C(0xdeadbeef01234567); l.hi=d.hi=UINT64_C(0x76543210fedcba98);
    LDL_dim2_fft3(d.v,l.v,a,c,j,10,1);
    if(memcmp(saved[0],a,sizeof a)||memcmp(saved[1],c,sizeof c)||memcmp(saved[2],j,sizeof j)
        ||l.lo!=UINT64_C(0xdeadbeef01234567)||d.lo!=l.lo
        ||l.hi!=UINT64_C(0x76543210fedcba98)||d.hi!=l.hi) abort();
}
int main(int argc,char **argv) {
    size_t i,k;
    if(argc!=2) return 2;
    if(!strcmp(argv[1],"scalar")) {
        uint64_t x,y;
        while(scanf("%" SCNx64 " %" SCNx64,&x,&y)==2)
            printf("%016" PRIx64 " %016" PRIx64 " %016" PRIx64 "\n",fpr_add(x,y),fpr_mul(x,y),fpr_div(x,y));
        return 0;
    }
    if(!strcmp(argv[1],"gram")) {
        for(i=0;i<H;i++) if(scanf("%" SCNx64 " %" SCNx64 " %" SCNx64 " %" SCNx64 " %" SCNx64,&a[i],&c[i],&c[i+H],&j[i],&j[i+H])!=5) return 3;
        root();
        for(i=0;i<H;i++) printf("%016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 "\n",l.v[i],l.v[i+H],d.v[i],d.v[i+H]);
        return 0;
    }
    if(!strcmp(argv[1],"frame")) {
        static struct { uint64_t lo; fpr v[12*N]; uint64_t hi; } tree;
        static fpr scratch[7*N];
        for(k=0;k<3;k++) {
            for(i=0;i<N;i++) { a[i]=(i<H?fpr_of(2):fpr_of(0)); c[i]=(i<H?fpr_of((int)k-1):fpr_of(0));j[i]=a[i]; }
            root();tree.lo=UINT64_C(0x1122334455667788);tree.hi=UINT64_C(0x8877665544332211);
            if(ffLDL_fft3(tree.v,a,c,j,10,scratch)!=12*N || memcmp(tree.v,l.v,sizeof l.v)
                ||memcmp(saved[0],a,sizeof a)||memcmp(saved[1],c,sizeof c)||memcmp(saved[2],j,sizeof j)
                ||tree.lo!=UINT64_C(0x1122334455667788)||tree.hi!=UINT64_C(0x8877665544332211)) abort();
            /* Allowed input alias: g11=g00. Output buffers remain disjoint. */
            LDL_dim2_fft3(d.v,l.v,a,c,a,10,1);
            if(memcmp(tree.v,l.v,sizeof l.v)||memcmp(saved[0],a,sizeof a)) abort();
        }
        puts("FRAME_INPUT_ALIAS_AND_FIRST_SUBTREE_PASS 3 18432"); return 0;
    }
    if(strcmp(argv[1],"polys")) return 4;
    /* Input order f,g,F,G; storage order g,-f,G,-F. */
    for(k=0;k<4;k++) {
        size_t at=(k==0?1:k==1?0:k==2?3:2);
        for(i=0;i<N;i++) { int x; if(scanf("%d",&x)!=1||x< -2047||x>2047) return 5;b[at][i]=fpr_of(x); }
        falcon_FFT3(b[at],10,1);
        if(k==0||k==2) falcon_poly_neg_fft3(b[at],10,1);
    }
    memcpy(a,b[0],sizeof a);falcon_poly_mulselfadj_fft3(a,10,1);
    memcpy(d.v,b[1],sizeof a);falcon_poly_mulselfadj_fft3(d.v,10,1);falcon_poly_add_fft3(a,d.v,10,1);
    memcpy(c,b[2],sizeof c);falcon_poly_muladj_fft3(c,b[0],10,1);
    memcpy(d.v,b[3],sizeof c);falcon_poly_muladj_fft3(d.v,b[1],10,1);falcon_poly_add_fft3(c,d.v,10,1);
    memcpy(j,b[2],sizeof j);falcon_poly_mulselfadj_fft3(j,10,1);
    memcpy(d.v,b[3],sizeof j);falcon_poly_mulselfadj_fft3(d.v,10,1);falcon_poly_add_fft3(j,d.v,10,1);
    root();
    for(i=0;i<N;i++) printf("%016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 "\n",b[0][i],b[1][i],b[2][i],b[3][i],a[i],c[i],j[i],l.v[i],d.v[i]);
    return 0;
}
