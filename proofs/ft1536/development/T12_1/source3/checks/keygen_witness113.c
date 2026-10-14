/* Public synthetic source witness collector. Native evidence, not a kernel proof. */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include "internal.h"

static FILE *witness_log;
static uint64_t witness_attempts;
static void witness_le(FILE *f, uint64_t x, unsigned n) {
    unsigned i;
    for (i=0; i<n; i++) { if (fputc((int)(x & 255),f)==EOF) abort(); x >>= 8; }
}
static void witness_emit(const char *name, const void *bytes, size_t length) {
    size_t n=strlen(name);
    if (!witness_log) return;
    witness_le(witness_log,n,4);
    if (fwrite(name,1,n,witness_log)!=n) abort();
    witness_le(witness_log,length,8);
    if (length && fwrite(bytes,1,length,witness_log)!=length) abort();
}
static int witness_int(const char *name, int value) {
    witness_emit(name,&value,sizeof value); return value;
}
static void *witness_malloc(size_t size) { return calloc(1,size); }
static void witness_extract(shake_context *sc, void *out, size_t len);

/* The fixed service allocator supplies zero-initialized fresh objects.
   SHAKE wrapper observes the original implementation exactly once. */
#define malloc witness_malloc
#define shake_extract witness_extract
#include KEYGEN_BODY
#undef shake_extract
#undef malloc

static void witness_extract(shake_context *sc, void *out, size_t len) {
    witness_emit("shake_before",sc,sizeof *sc);
    shake_extract(sc,out,len);
    witness_emit("shake_bytes",out,len);
    witness_emit("shake_after",sc,sizeof *sc);
}
static void witness_file(const char *name, const void *bytes, size_t len) {
    FILE *f=fopen(name,"wb");
    if (!f) abort();
    if (len && fwrite(bytes,1,len,f)!=len) abort();
    if (fclose(f)) abort();
}
int main(int argc, char **argv) {
    uint64_t counter;
    unsigned char seed[32]={0};
    unsigned char *sk,*pk;
    size_t sklen,pklen,skcap,pkcap;
    falcon_keygen *fk;
    FILE *result;
    int ret;
    unsigned i;
    if (argc!=2) return 90;
    counter=(uint64_t)strtoull(argv[1],NULL,10);
    memcpy(seed,"meas1",5);
    for (i=0;i<8;i++) seed[31-i]=(unsigned char)(counter>>(8*i));
    witness_file("seed.bin",seed,sizeof seed);
    witness_log=fopen("events.bin","wb");
    if (!witness_log) return 91;
    fk=falcon_keygen_new(10,1);
    if (!fk) return 92;
    skcap=falcon_keygen_max_privkey_size(fk); pkcap=falcon_keygen_max_pubkey_size(fk);
    sk=calloc(1,skcap); pk=calloc(1,pkcap);
    if (!sk || !pk) return 93;
    witness_emit("rng_new",&fk->rng,sizeof fk->rng);
    witness_emit("scratch_new",fk->tmp,fk->tmp_len);
    falcon_keygen_set_seed(fk,seed,sizeof seed,1);
    witness_emit("rng_seeded",&fk->rng,sizeof fk->rng);
    witness_emit("seeded_flag",&fk->seeded,sizeof fk->seeded);
    witness_emit("flipped_flag",&fk->flipped,sizeof fk->flipped);
    sklen=skcap; pklen=pkcap;
    ret=falcon_keygen_make(fk,FALCON_COMP_STATIC,sk,&sklen,pk,&pklen);
    if (ret) {
        witness_file("private.bin",sk,sklen); witness_file("public.bin",pk,pklen);
        witness_emit("final_private",sk,sklen); witness_emit("final_public",pk,pklen);
    }
    witness_emit("rng_final",&fk->rng,sizeof fk->rng);
    witness_emit("scratch_final",fk->tmp,fk->tmp_len);
    if (fclose(witness_log)) return 94;
    witness_log=NULL;
    result=fopen("RESULT.json","w");
    if (!result) return 95;
    fprintf(result,"{\"return\":%d,\"counter\":%llu,\"attempts_observed\":%llu,\"sk_length\":%zu,\"pk_length\":%zu,\"sk_capacity\":%zu,\"pk_capacity\":%zu,\"scratch_bytes\":%zu,\"context_bytes\":%zu,\"rng_offset\":%zu,\"seeded_offset\":%zu,\"flipped_offset\":%zu,\"tmp_offset\":%zu,\"tmp_len_offset\":%zu}\n",ret,(unsigned long long)counter,(unsigned long long)witness_attempts,sklen,pklen,skcap,pkcap,fk->tmp_len,sizeof *fk,offsetof(falcon_keygen,rng),offsetof(falcon_keygen,seeded),offsetof(falcon_keygen,flipped),offsetof(falcon_keygen,tmp),offsetof(falcon_keygen,tmp_len));
    if (fclose(result)) return 96;
    falcon_keygen_free(fk); free(sk); free(pk);
    /* Keep the wrapper referenced in the uninstrumented control as well. */
    return witness_int("done",ret==1?0:97);
}
