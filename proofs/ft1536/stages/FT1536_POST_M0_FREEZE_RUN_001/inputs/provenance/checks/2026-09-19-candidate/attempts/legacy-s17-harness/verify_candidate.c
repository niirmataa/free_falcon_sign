/* S17 source remains byte-identical. Only HashToPoint is supplied as c,
 * exactly as allowed by L_V. Including this translation unit exposes static
 * stages for observation; the original verifier and public-key loader run. */
#define falcon_hash_to_point lv_explicit_point
#include "falcon-vrfy.c"
#undef falcon_hash_to_point
#include <stdio.h>
#include <limits.h>
#include <string.h>

static uint16_t supplied_c[1536];
static int point_calls;
void lv_explicit_point(shake_context *sc, unsigned q, uint16_t *x, unsigned logn)
{
    (void)sc;
    if (q != 18433 || logn != 10) abort();
    memcpy(x, supplied_c, sizeof supplied_c);
    point_calls++;
}

static falcon_vrfy *ctx;
int lv_init(const unsigned char *pk, size_t len)
{
    if (ctx) falcon_vrfy_free(ctx);
    ctx = falcon_vrfy_new();
    return ctx && falcon_vrfy_set_public_key(ctx, pk, len);
}
int lv_eval(const uint16_t *c, const unsigned char *b, size_t len)
{
    memcpy(supplied_c,c,sizeof supplied_c);
    point_calls=0;
    falcon_vrfy_start(ctx, NULL, 0);
    return falcon_vrfy_verify(ctx,b,len);
}
int lv_calls(void) { return point_calls; }
size_t lv_decode(const unsigned char *b, size_t len, int16_t *s)
{
    if (len <= 1) return 0;
    return falcon_decode_small(s,10,(b[0]>>5)&3,18433,b+1,len-1);
}
int lv_raw(const uint16_t *c, const int16_t *s)
{
    return falcon_vrfy_verify_raw(c,s,ctx->h,10,1);
}
int lv_short(const int16_t *a, const int16_t *b)
{ return falcon_is_short(a,b,10,1); }

/* stages[0..4] = preNTT, NTT, productNTT, inverseNTT, subtract;
 * norm_first is the signed vector actually passed to is_short. */
void lv_trace(const int16_t *s, const uint16_t *c, uint16_t *stages,
              int16_t *norm_first, int full_mod)
{
    uint16_t x[1536];
    for (size_t u=0;u<1536;u++) {
        uint32_t w=(uint32_t)s[u];
        w+=18433u & -(w>>31);
        x[u]=(uint16_t)w;
        if (full_mod) x[u]=(uint16_t)(((int32_t)s[u]%18433+18433)%18433);
    }
    memcpy(stages,x,sizeof x);
    mq_NTT(x,10,1); memcpy(stages+1536,x,sizeof x);
    mq_poly_montymul_ntt(x,ctx->h,10,1); memcpy(stages+3072,x,sizeof x);
    mq_iNTT(x,10,1); memcpy(stages+4608,x,sizeof x);
    mq_poly_sub(x,c,10,1); memcpy(stages+6144,x,sizeof x);
    for (size_t u=0;u<1536;u++) {
        int32_t w=(int32_t)x[u];
        w-=(int32_t)(18433u & -(((18433u>>1)-(uint32_t)w)>>31));
        norm_first[u]=(int16_t)w;
    }
}

#ifdef LV_MAIN
static void read_vector(const char *path, uint16_t *v) {
    FILE *f=fopen(path,"r"); if(!f) abort();
    for(int i=0;i<1536;i++) { unsigned x; if(fscanf(f,"%u",&x)!=1 || x>=18433) abort(); v[i]=(uint16_t)x; }
    fclose(f);
}
static unsigned char *read_bytes(const char *path,size_t *len) {
    FILE *f=fopen(path,"rb"); if(!f) abort();
    if(fseek(f,0,SEEK_END)) abort(); long n=ftell(f); if(n<0) abort();
    *len=(size_t)n; rewind(f);
    unsigned char *v=malloc(*len); if(!v || fread(v,1,*len,f)!=*len) abort();
    fclose(f); return v;
}
int main(int argc,char **argv) {
    if(argc!=4) return 2;
    _Static_assert(CHAR_BIT==8 && sizeof(int)==4 && sizeof(long)==8 && sizeof(size_t)==8,"LP64");
    _Static_assert(sizeof(int16_t)==2 && sizeof(uint32_t)==4 && sizeof(int64_t)==8,"words");
    size_t pl,bl; unsigned char *pk=read_bytes(argv[1],&pl),*b=read_bytes(argv[3],&bl);
    uint16_t c[1536],st[7680]; int16_t s[1536],first[1536];
    read_vector(argv[2],c);
    int init=lv_init(pk,pl); size_t decoded=lv_decode(b,bl,s);
    if(init!=1 || decoded!=bl-1) return 3;
    int decision=lv_eval(c,b,bl),calls=lv_calls(),raw=lv_raw(c,s);
    lv_trace(s,c,st,first,0);
    int64_t norm=0;
    for(int i=0;i<1536;i++) norm+=(int64_t)first[i]*first[i]+(int64_t)s[i]*s[i];
    for(int i=0;i<768;i++) norm+=(int64_t)first[i]*first[i+768]+(int64_t)s[i]*s[i+768];
    printf("{\"loader\":%d,\"payload_bytes\":%zu,\"decoded_bytes\":%zu,\"point_calls\":%d,\"verify\":%d,\"raw\":%d,\"machine_norm\":%lld,\"s0\":%d,\"preNTT0\":%u,\"cast65535\":%d,\"cast32768\":%d}\n",init,bl,decoded,calls,decision,raw,(long long)norm,s[0],st[0],(int16_t)65535,(int16_t)32768);
    free(pk);free(b);falcon_vrfy_free(ctx);
    return decision==1 && raw==1 && calls==1 ? 0:4;
}
#endif
