/* S05 diagnostic only: public algebraic fixture, not a KeyGen execution.
 * Includes the unchanged Falcon-derived source with its original license. */
#include <stdio.h>
#include <inttypes.h>
#include "falcon-keygen.c"
#include "fixture.h"
int main(void) {
    const size_t n=1536;
    fpr *tmp=calloc(80*n,sizeof *tmp);
    if (tmp==NULL) return 2;
    int accepted=ft_keygen_leaf_certificate(tmp,fixture_f,fixture_g,
        fixture_F,fixture_G,10,1);
    printf("{\"accepted\":%d,\"g00_words\":[",accepted);
    for (size_t i=0;i<n/2;i++)
        printf("%s\"%016" PRIx64 "\"",i?",":"",ft_fpr_bits_keygen(tmp[4*n+i]));
    printf("],\"leaf_words\":[");
    for (size_t i=0;i<n;i++)
        printf("%s\"%016" PRIx64 "\"",i?",":"",ft_fpr_bits_keygen(tmp[20*n+i]));
    puts("]}");
    free(tmp);
    return accepted?0:1;
}
