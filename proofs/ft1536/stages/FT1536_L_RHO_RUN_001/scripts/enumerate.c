#include <limits.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include VERIFY_SOURCE

typedef char assert_byte[(CHAR_BIT == 8) ? 1 : -1];
typedef char assert_words[(sizeof(int)==4 && sizeof(unsigned)==4 && sizeof(long)==8 && sizeof(size_t)==8 && sizeof(int16_t)==2 && sizeof(uint16_t)==2 && sizeof(int64_t)==8) ? 1 : -1];
typedef char assert_limits[(INT_MAX==2147483647 && INT16_MIN==(-32767-1) && INT16_MAX==32767 && UINT16_MAX==65535) ? 1 : -1];

int main(int argc,char **argv)
{
    FILE *f;
    int32_t value;
    unsigned count=0;
    if(argc!=2) return 2;
    f=fopen(argv[1],"w"); if(!f) return 3;
    fprintf(f,"x,rho\n");
    for(value=-32768;value<=32767;value++) {
        int16_t input=(int16_t)value; /* always representable, checked domain */
        uint16_t output=ft1536_normalize_s2(input); /* actual candidate helper */
        if((int32_t)input!=value) return 4;
        fprintf(f,"%d,%u\n",(int)value,(unsigned)output);
        count++;
    }
    if(fclose(f)!=0 || count!=65536) return 5;
    printf("{\"rows\":%u,\"input_min\":-32768,\"input_max\":32767,\"actual_helper\":true}\n",count);
    return 0;
}
