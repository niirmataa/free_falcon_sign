#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define falcon_hash_to_point rho_explicit_point
#if OBSERVE
#define falcon_is_short rho_capture_short
#endif
#include VERIFY_SOURCE
#undef falcon_hash_to_point
#if OBSERVE
#undef falcon_is_short
extern int falcon_is_short(const int16_t *, const int16_t *, unsigned, unsigned);
static int16_t captured_first[1536], captured_second[1536];
static unsigned norm_calls;
int rho_capture_short(const int16_t *a,const int16_t *b,unsigned logn,unsigned ternary)
{
    if(logn!=10 || ternary!=1) abort();
    memcpy(captured_first,a,sizeof captured_first);
    memcpy(captured_second,b,sizeof captured_second);
    norm_calls++;
    return falcon_is_short(a,b,logn,ternary);
}
#endif
static uint16_t explicit_c[1536];
static unsigned point_calls;
void rho_explicit_point(shake_context *sc,unsigned q,uint16_t *x,unsigned logn)
{
    (void)sc; if(q!=18433 || logn!=10) abort();
    memcpy(x,explicit_c,sizeof explicit_c);point_calls++;
}
typedef char assert_model[(CHAR_BIT==8 && sizeof(int)==4 && sizeof(unsigned)==4 && sizeof(long)==8 && sizeof(size_t)==8 && sizeof(int16_t)==2 && sizeof(uint16_t)==2 && sizeof(int64_t)==8) ? 1 : -1];
static unsigned char *bytes(const char *name,size_t *len)
{
    FILE *f=fopen(name,"rb");long z;unsigned char *b;
    if(!f || fseek(f,0,SEEK_END)) abort();
    z=ftell(f);if(z<0) abort();rewind(f);*len=(size_t)z;
    b=malloc(*len?*len:1);if(!b || fread(b,1,*len,f)!=*len) abort();
    fclose(f);return b;
}
static void vec(FILE *f,const char *name,const int16_t *a)
{
    size_t i;fprintf(f,",\"%s\":[",name);
    for(i=0;i<1536;i++)fprintf(f,"%s%d",i?",":"",(int)a[i]);
    fprintf(f,"]");
}
int main(int argc,char **argv)
{
    size_t plen,blen,used,u;unsigned v;int result,raw,unchanged;
    unsigned char *pk,*b;int16_t decoded[1536],saved[1536];falcon_vrfy *ctx;FILE *f;
    if(argc!=5)return 2;
    pk=bytes(argv[1],&plen);b=bytes(argv[3],&blen);
    f=fopen(argv[2],"r");if(!f)abort();
    for(u=0;u<1536;u++){if(fscanf(f,"%u",&v)!=1 || v>=18433)abort();explicit_c[u]=(uint16_t)v;}
    if(fscanf(f,"%u",&v)==1)abort();
    fclose(f);
    ctx=falcon_vrfy_new();if(!ctx || falcon_vrfy_set_public_key(ctx,pk,plen)!=1)return 3;
    if(blen<=2)return 4;
    used=falcon_decode_small(decoded,10,(b[0]>>5)&3,18433,b+1,blen-1);
    if(used!=blen-1)return 5;
    memcpy(saved,decoded,sizeof saved);
    falcon_vrfy_start(ctx,NULL,0);result=falcon_vrfy_verify(ctx,b,blen);
    f=fopen(argv[4],"w");if(!f)abort();
    fprintf(f,"{\"verify\":%d,\"point_calls\":%u,\"decoded_bytes\":%zu,\"payload_bytes\":%zu",result,point_calls,used,blen);
#if OBSERVE
    {int64_t total=0;
    if(norm_calls!=1 || rho_observed_calls!=1 || rho_observed_n!=1536)abort();
    for(u=0;u<1536;u++)total+=(int64_t)captured_first[u]*captured_first[u]+(int64_t)captured_second[u]*captured_second[u];
    for(u=0;u<768;u++)total+=(int64_t)captured_first[u]*captured_first[u+768]+(int64_t)captured_second[u]*captured_second[u+768];
    fprintf(f,",\"norm\":%lld,\"pre_ntt\":[",(long long)total);
    for(u=0;u<1536;u++)fprintf(f,"%s%u",u?",":"",(unsigned)rho_observed_pre[u]);
    fprintf(f,"]");vec(f,"norm_first",captured_first);vec(f,"norm_second",captured_second);
    if(memcmp(captured_second,decoded,sizeof decoded)!=0)abort();}
#endif
    raw=falcon_vrfy_verify_raw(explicit_c,decoded,ctx->h,10,1);
    unchanged=memcmp(saved,decoded,sizeof saved)==0;
    fprintf(f,",\"raw\":%d,\"signed_s_unchanged\":%s",raw,unchanged?"true":"false");
    vec(f,"decoded_s",decoded);fprintf(f,"}\n");if(fclose(f))abort();
    printf("{\"verify\":%d,\"raw\":%d,\"test_executed\":true,\"signed_s_unchanged\":%s}\n",result,raw,unchanged?"true":"false");
    free(pk);free(b);falcon_vrfy_free(ctx);
    return (result==raw && unchanged)?0:6; /* rejection is a valid test result */
}
