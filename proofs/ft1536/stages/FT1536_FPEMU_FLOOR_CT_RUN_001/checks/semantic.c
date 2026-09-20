#include <stdint.h>
#include <inttypes.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
uint64_t baseline_floor(uint64_t);
uint64_t candidate_floor(uint64_t);
int main(int argc,char **argv) {
 if(argc!=3||sizeof(long)!=8||sizeof(int)!=4||sizeof(int64_t)!=8||CHAR_BIT!=8||LONG_MIN!=INT64_MIN) return 2;
 FILE *in=fopen(argv[1],"rb"),*out=fopen(argv[2],"wb");if(!in||!out) return 3;
 uint64_t r[2],count=0,fold=UINT64_C(1469598103934665603);size_t n;
 while((n=fread(r,sizeof(uint64_t),2,in))==2) {
  uint64_t a=baseline_floor(r[0]),b=candidate_floor(r[0]);
  if(a!=b||b!=r[1]) {fprintf(stderr,"mismatch %" PRIu64 " raw=%016" PRIx64 " old=%016" PRIx64 " new=%016" PRIx64 " expected=%016" PRIx64 "\n",count,r[0],a,b,r[1]);return 4;}
  if(fwrite(&b,sizeof b,1,out)!=1) return 5;
  fold=(fold^b)*UINT64_C(1099511628211);count++;
 }
 if(n||!feof(in)||ferror(in)||fclose(in)||fclose(out)) return 6;
 printf("{\"status\":\"PASS_ALL_CORPUS_BITS\",\"cases\":%" PRIu64 ",\"fold\":\"%016" PRIx64 "\"}\n",count,fold);
 return 0;
}
