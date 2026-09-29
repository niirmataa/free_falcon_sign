#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include <limits.h>
#include "internal.h"
#include "variants/framing_enc.c"
typedef char widths[(CHAR_BIT==8 && sizeof(int)==4 && sizeof(long)==8 && sizeof(size_t)==8)?1:-1];
static int nonce_gate(size_t rlen,size_t payload_len)
{
	(void)payload_len;
	return rlen >= 39;
}
static int64_t norm(const int16_t *a,const int16_t *b)
{
	int64_t q=0;
	for(size_t i=0;i<768;i++)q+=(int64_t)a[i]*a[i]+(int64_t)a[i]*a[i+768]+(int64_t)a[i+768]*a[i+768]
		+(int64_t)b[i]*b[i]+(int64_t)b[i]*b[i+768]+(int64_t)b[i+768]*b[i+768];
	return q;
}
int main(int argc,char **argv)
{
	if(argc!=2)return 2;
	const char *mode=argv[1];int16_t a[1536]={0},b[1536],dec[1536];
	if(!strcmp(mode,"witness"))for(size_t i=0;i<768;i++){int16_t x=i<330?1792:1536;b[i]=x;b[i+768]=(int16_t)-x;}
	else if(!strcmp(mode,"exact3073"))for(size_t i=0;i<768;i++){b[i]=1536;b[i+768]=-1536;}
	else if(!strcmp(mode,"zero"))memset(b,0,sizeof b);
	else if(!strcmp(mode,"not_short"))for(size_t i=0;i<1536;i++)b[i]=-32768;
	else return 3;
	size_t measured=falcon_encode_small(NULL,0,FALCON_COMP_STATIC,18433,b,10);
	printf("{\"case\":\"%s\",\"norm\":%"PRId64",\"short\":%d,\"encoder_query\":%zu,\"payload_query\":%zu,\"capacities\":[",mode,norm(a,b),falcon_is_short(a,b,10,1),measured,measured+1);
	const size_t caps[]={2049,3073,3155,3156,4096};
	for(size_t j=0;j<sizeof caps/sizeof caps[0];j++){
		size_t cap=caps[j];unsigned char *mem=malloc(cap+64);if(!mem)return 4;memset(mem,0xa5,cap+64);unsigned char *sig=mem+32;
		size_t n=falcon_encode_small(sig+1,cap-1,FALCON_COMP_STATIC,18433,b,10);
		int roundtrip=0,canary=1,untouched=1;
		for(size_t i=0;i<32;i++)if(mem[i]!=0xa5||mem[32+cap+i]!=0xa5)canary=0;
		if(n){sig[0]=0xaa;memset(dec,0x5a,sizeof dec);size_t used=falcon_decode_small(dec,10,FALCON_COMP_STATIC,18433,sig+1,n);roundtrip=used==n&&!memcmp(dec,b,sizeof b);
			for(size_t i=n+1;i<cap;i++)if(sig[i]!=0xa5)untouched=0;}
		printf("%s{\"payload_capacity\":%zu,\"encoder_capacity\":%zu,\"encoder_return\":%zu,\"actual_payload\":%zu,\"roundtrip\":%d,\"canaries\":%d,\"unused_suffix_untouched\":%d}",j?",":"",cap,cap-1,n,n?n+1:0,roundtrip,canary,untouched);free(mem);
	}
	unsigned char r[40],m[4]={77,48,0,255},left[44],right[44];
	for(size_t i=0;i<40;i++)r[i]=(unsigned char)i;
	memcpy(left,r,40);memcpy(left+40,m,4);memcpy(right,r,39);right[39]=r[39];memcpy(right+40,m,4);
	printf("],\"framing\":{\"same_hash_input_after_repartition\":%d,\"accept_r40\":%d,\"accept_r39\":%d,\"accept_r40_payload5000\":%d}}\n",!memcmp(left,right,44),nonce_gate(40,3156),nonce_gate(39,3156),nonce_gate(40,5000));
	return 0;
}
