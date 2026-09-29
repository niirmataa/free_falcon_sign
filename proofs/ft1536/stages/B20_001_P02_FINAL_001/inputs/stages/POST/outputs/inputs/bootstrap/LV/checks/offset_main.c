#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <limits.h>
#include <string.h>
#include "internal.h"
typedef char model_widths[(CHAR_BIT==8 && sizeof(int)==4 && sizeof(long)==8 && sizeof(size_t)==8 && sizeof(int64_t)==8 && __alignof__(int16_t)==__alignof__(uint16_t))?1:-1];
typedef char corresponding_types[(__builtin_types_compatible_p(int16_t,short) && __builtin_types_compatible_p(uint16_t,unsigned short))?1:-1];
static uint16_t given_c[1536];
static int point_calls,obs_seen;
static int64_t obs_norm,obs_bound;
static int16_t obs_a[1536],obs_b[1536];
static void obs_capture(int64_t s,int64_t bound,const int16_t *a,const int16_t *b)
{
	obs_seen=1;obs_norm=s;obs_bound=bound;memcpy(obs_a,a,sizeof obs_a);memcpy(obs_b,b,sizeof obs_b);
}
static void explicit_point(shake_context *sc,unsigned q,uint16_t *out,unsigned logn)
{
	(void)sc;if(q!=18433 || logn!=10)abort();point_calls++;memcpy(out,given_c,sizeof given_c);
}
#define falcon_hash_to_point explicit_point
#include "variants/offset_vrfy.c"
#undef falcon_hash_to_point
#include "variants/offset_enc.c"

static unsigned char *read_bin(const char *name,size_t *len)
{
	FILE *f=fopen(name,"rb");if(!f)abort();if(fseek(f,0,SEEK_END))abort();long n=ftell(f);if(n<0)abort();rewind(f);
	unsigned char *b=malloc((size_t)n+1);if(!b)abort();if(fread(b,1,(size_t)n,f)!=(size_t)n)abort();fclose(f);*len=(size_t)n;return b;
}
static void signed_array(const int16_t *a)
{
	putchar('[');for(size_t i=0;i<1536;i++)printf("%s%d",i?",":"",(int)a[i]);putchar(']');
}
static void unsigned_array(const uint16_t *a)
{
	putchar('[');for(size_t i=0;i<1536;i++)printf("%s%u",i?",":"",(unsigned)a[i]);putchar(']');
}
int main(int argc,char **argv)
{
	if(argc<3)return 2;
	if(!strcmp(argv[1],"center")){
		uint32_t q=18433;int32_t w=(int32_t)strtol(argv[2],NULL,10);int32_t before=w;
		w -= (int32_t)(q & -(((q >> 1) - (uint32_t)w) >> 31));
		printf("{\"out\":%d,\"correction\":%d,\"stored_bits\":%u}\n",(int)(int16_t)w,(int)(before-w),(unsigned)(uint16_t)(int16_t)w);return 0;
	}
	if(!strcmp(argv[1],"norm")){
		int16_t a[1536],b[1536];int x;FILE *f=fopen(argv[2],"r");if(!f)return 3;
		for(size_t i=0;i<3072;i++){if(fscanf(f,"%d",&x)!=1||x< -32768||x>32767)return 4;if(i<1536)a[i]=(int16_t)x;else b[i-1536]=(int16_t)x;}
		fclose(f);int rc=falcon_is_short(a,b,10,1);printf("{\"return\":%d,\"norm\":",rc);
		if(obs_seen)printf("%"PRId64,obs_norm);else printf("null");printf("}\n");return 0;
	}
	if(strcmp(argv[1],"verify")||argc!=5)return 5;
	size_t plen,slen;unsigned char *pk=read_bin(argv[2],&plen),*sig=read_bin(argv[4],&slen);
	FILE *f=fopen(argv[3],"r");if(!f)return 6;unsigned x;
	for(size_t i=0;i<1536;i++){if(fscanf(f,"%u",&x)!=1||x>=18433)return 7;given_c[i]=(uint16_t)x;}fclose(f);
	falcon_vrfy *fv=falcon_vrfy_new();if(!fv)return 8;
	int loaded=falcon_vrfy_set_public_key(fv,pk,plen);falcon_vrfy_start(fv,NULL,0);
	int rc=falcon_vrfy_verify(fv,sig,slen);
	printf("{\"load\":%d,\"verify\":%d,\"point_calls\":%d,\"norm\":",loaded,rc,point_calls);
	if(obs_seen)printf("%"PRId64,obs_norm);else printf("null");
	printf(",\"s1\":");if(obs_seen)signed_array(obs_a);else printf("null");
	int16_t dec[1536];for(size_t i=0;i<1536;i++)dec[i]=0x5a5a;
	size_t used=slen?falcon_decode_small(dec,10,(sig[0]>>5)&3,18433,sig+1,slen-1):0;
	printf(",\"decoded_used\":%zu,\"decoded\":",used);if(used)signed_array(dec);else printf("null");
	int raw=-9;if(loaded&&fv->logn==10&&fv->ternary==1&&used)raw=(int)falcon_vrfy_verify_raw(given_c,dec,fv->h,10,1);
	printf(",\"raw\":%d,\"pk_ret\":",raw);
	uint16_t ph[1536];memset(ph,0xa5,sizeof ph);
	size_t pr=plen?falcon_decode_18433(ph,10,pk+1,plen-1):0;
	printf("%zu,\"pk_values\":",pr);if(pr)unsigned_array(ph);else printf("null");printf("}\n");
	falcon_vrfy_free(fv);free(pk);free(sig);return 0;
}
