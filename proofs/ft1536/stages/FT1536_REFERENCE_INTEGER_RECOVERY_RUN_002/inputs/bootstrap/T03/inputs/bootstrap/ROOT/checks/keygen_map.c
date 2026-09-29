#include <inttypes.h>
#include <stdio.h>
#include "../source/falcon-keygen.c"
/* Only public modp table construction and FFT of X. No key material or KeyGen. */
int main(void) {
    uint32_t gm[1024],ig[1024],x[1536]={0};size_t i;
    uint32_t p=PRIMES3[0].p,g=PRIMES3[0].g,p0i=modp_ninv31(p);
    modp_mkgm3(gm,ig,10,1,g,p,p0i);x[1]=1;modp_NTT3(x,gm,10,1,p,p0i);
    printf("%" PRIu32 " %" PRIu32 " %" PRIu32 "\n",p,g,p0i);
    for(i=0;i<1024;i++) printf("%" PRIu32 "\n",gm[i]);
    for(i=0;i<1536;i++) printf("%" PRIu32 "\n",x[i]);
    return 0;
}
