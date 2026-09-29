#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../source/falcon-sign.c"
/* Only public arrays and original split/Adj/LDL. No KeyGen, loader, or Sign. */
enum { RN=1536, CN=512, H=256 };
static fpr input[RN],saved[RN];
static struct { uint64_t lo; fpr v[3584]; uint64_t hi; } arena;
static struct { uint64_t lo; fpr v[3*CN]; uint64_t hi; } tree;
int main(int argc,char **argv) {
    size_t i;fpr *t0=arena.v,*t1=t0+CN,*t2=t1+CN;
    fpr *d11=t2+CN,*d22=d11+CN,*work=d11+3*CN;
    fpr *l10=tree.v,*l20=l10+CN,*l21=l20+CN;
    if(argc!=2||sizeof(long)!=8||sizeof(int)!=4||sizeof(fpr)!=8) return 2;
    if(!strcmp(argv[1],"inverse")) {printf("%016" PRIx64 "\n",fpr_inverse_of(3));return 0;}
    if(!strcmp(argv[1],"scalar")) {
        uint64_t x,y;
        while(scanf("%" SCNx64 " %" SCNx64,&x,&y)==2)
            printf("%016" PRIx64 " %016" PRIx64 "\n",fpr_mul(x,y),fpr_div(x,y));
        return 0;
    }
    if(strcmp(argv[1],"branch0")&&strcmp(argv[1],"branch1")) return 3;
    for(i=0;i<RN;i++) if(scanf("%" SCNx64,&input[i])!=1) return 4;
    arena.lo=tree.lo=UINT64_C(0x1122334455667788);arena.hi=tree.hi=UINT64_C(0x8877665544332211);
    /* branch1 root d11 shares the scratch later reused by Node3 outputs. */
    if(!strcmp(argv[1],"branch1")) {
        memcpy(d11,input,sizeof input);falcon_poly_split_top_fft3(t0,t1,t2,d11,10);
        if(memcmp(d11,input,sizeof input)) abort();
    } else falcon_poly_split_top_fft3(t0,t1,t2,input,10);
    falcon_poly_adj_fft3(t1,9,0);falcon_poly_adj_fft3(t2,9,0);
    memcpy(saved,t0,sizeof saved);
    LDL_dim3_fft3(d11,d22,l10,l20,l21,t0,t1,t0,t2,t1,t0,9,0,work);
    if(memcmp(saved,t0,sizeof saved)||arena.lo!=UINT64_C(0x1122334455667788)||tree.lo!=arena.lo
        ||arena.hi!=UINT64_C(0x8877665544332211)||tree.hi!=arena.hi) abort();
    for(i=0;i<CN;i++) printf("%016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 "\n",t0[i],t1[i],t2[i],d11[i],d22[i],l10[i],l20[i],l21[i]);
    return 0;
}
