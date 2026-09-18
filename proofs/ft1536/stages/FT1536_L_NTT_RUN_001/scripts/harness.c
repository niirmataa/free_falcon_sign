#include <stdint.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include SOURCE_FILE

typedef char abi[(CHAR_BIT==8 && sizeof(int)==4 && sizeof(unsigned)==4 && sizeof(uint32_t)==4 && sizeof(int32_t)==4 && sizeof(int16_t)==2 && sizeof(uint16_t)==2 && sizeof(long)==8 && sizeof(size_t)==8) ? 1 : -1];
#define N 1536
static void vec(FILE *f,const char *key,const uint16_t *a,size_t n,int comma)
{
    size_t u;fprintf(f,"%s\"%s\":[",comma?",":"",key);
    for(u=0;u<n;u++)fprintf(f,"%s%u",u?",":"",(unsigned)a[u]);
    fprintf(f,"]");
}
static void read_vec(FILE *f,uint16_t *a)
{
    size_t u;unsigned x;
    for(u=0;u<N;u++){if(fscanf(f,"%u",&x)!=1 || x>=18433)abort();a[u]=(uint16_t)x;}
}
int main(int argc,char **argv)
{
    FILE *f,*out;
    if(argc<3)return 2;
    if(strcmp(argv[1],"tables")==0) {
        uint16_t gm[TERNARY_GM_SIZE],igm[TERNARY_GM_SIZE];uint32_t g,delta,ni;
        mq_mkgm3(gm,igm,10);g=gm[512];delta=mq_sub(mq_add(gm[1],gm[1],Qt),Rt,Qt);
        ni=mq_div_18433(Rt,N);
        out=fopen(argv[2],"w");if(!out)abort();fprintf(out,"{");
        vec(out,"gm",gm,1024,0);vec(out,"igm",igm,1024,1);
        fprintf(out,",\"div_calls\":[[%u,%u,%u],[%u,%u,%u],[%u,%u,%u]],\"ni\":%u}\n",
          R2t,g,mq_div_18433(R2t,g),R2t,delta,mq_div_18433(R2t,delta),Rt,N,ni,ni);
        if(fclose(out))abort();printf("tables: exported initialized indices 0..1023 only\n");return 0;
    }
    if(strcmp(argv[1],"primitives")==0) {
        unsigned x,y;uint32_t z,zw,k,w,total,t,d,res;
        if(argc!=4)return 2;f=fopen(argv[2],"r");out=fopen(argv[3],"w");if(!f || !out)abort();
        fprintf(out,"x,y,add,sub,half,mont,square,div,z,zq0_word,k,w,total,shift,d_word,trace_result\n");
        while(fscanf(f,"%u %u",&x,&y)==2) {
            if(x>=Qt || y>=Qt)abort();z=(uint32_t)x*y;zw=z*Q0It;k=zw&0xFFFF;w=k*Qt;total=z+w;t=total>>16;d=t-Qt;res=d+(Qt&-(d>>31));
            if(res!=mq_montymul(x,y,Qt,Q0It))abort();
            fprintf(out,"%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u\n",x,y,
              mq_add(x,y,Qt),mq_sub(x,y,Qt),mq_rshift1(x,Qt),mq_montymul(x,y,Qt,Q0It),mq_montysqr(x,Qt,Q0It),
              y?mq_div_18433(x,y):0,z,zw,k,w,total,t,d,res);
        }
        if(!feof(f))abort();fclose(f);if(fclose(out))abort();printf("primitive vectors completed\n");return 0;
    }
    if(strcmp(argv[1],"division")==0) {
        uint32_t y;out=fopen(argv[2],"w");if(!out)abort();fprintf(out,"y,inverse\n");
        for(y=1;y<Qt;y++)fprintf(out,"%u,%u\n",y,mq_div_18433(1,y));
        if(fclose(out))abort();printf("18432 nonzero denominator controls completed\n");return 0;
    }
    if(strcmp(argv[1],"pipeline")==0) {
        uint16_t h[N],r[N],c[N],H[N],a[N],b[N];unsigned extra;
        if(argc!=4)return 2;f=fopen(argv[2],"r");if(!f)abort();
        read_vec(f,h);read_vec(f,r);read_vec(f,c);if(fscanf(f,"%u",&extra)==1)abort();fclose(f);
        out=fopen(argv[3],"w");if(!out)abort();fprintf(out,"{");
        memcpy(H,h,sizeof H);mq_NTT(H,10,1);vec(out,"h_ntt",H,N,0);
        mq_poly_tomonty(H,10,1);vec(out,"H_mont",H,N,1);
        memcpy(a,r,sizeof a);mq_NTT(a,10,1);vec(out,"r_ntt",a,N,1);
        mq_poly_montymul_ntt(a,H,10,1);vec(out,"point_product",a,N,1);
        mq_iNTT(a,10,1);vec(out,"p",a,N,1);
        mq_poly_sub(a,c,10,1);vec(out,"d",a,N,1);
        memcpy(b,r,sizeof b);mq_NTT(b,10,1);mq_iNTT(b,10,1);vec(out,"roundtrip",b,N,1);
#if OBSERVED
        fprintf(out,",\"dynamic_generator_calls\":%u,\"tables_identical\":%u",ntto_calls,ntto_same);
        vec(out,"observed_gm",ntto_gm,1024,1);vec(out,"observed_igm",ntto_igm,1024,1);
#endif
        fprintf(out,"}\n");if(fclose(out))abort();printf("full source pipeline completed\n");return 0;
    }
    return 2;
}
