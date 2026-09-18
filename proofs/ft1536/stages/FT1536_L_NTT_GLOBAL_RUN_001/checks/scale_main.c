#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
static void ft_snap(const char *,size_t,size_t,size_t,const uint16_t *);
#include "scale.c"
static void ft_snap(const char *p,size_t m,size_t n,size_t h,const uint16_t *a) {
  int yes=1;
  if (!strcmp(p,"froot")||!strcmp(p,"iroot")||!strcmp(p,"fbin")||!strcmp(p,"ibin"))
    yes=n==1||n==h||n==h+1||n==767||n==768;
  else if(!strcmp(p,"fcube")||!strcmp(p,"icube")) yes=n==1||n==255||n==256||n==511||n==512;
  else if(!strcmp(p,"scale")) yes=n==1||n==767||n==768||n==1535||n==1536;
  if(!yes) return;
  printf("%s %zu %zu",p,m,n);
  for(size_t i=0;i<1536;i++) printf(" %u",(unsigned)a[i]);
  putchar('\n');
}
int main(int argc,char **argv) {
  if(argc!=2) return 2;
  FILE *in=fopen(argv[1],"r"); if(!in) return 3;
  uint16_t a[1536]; unsigned x;
  for(size_t i=0;i<1536;i++) { if(fscanf(in,"%u",&x)!=1||x>=18433) return 4; a[i]=(uint16_t)x; }
  fclose(in); ft_snap("input",0,0,0,a);
  mq_NTT(a,10,1); ft_snap("forward",0,1536,0,a);
  mq_iNTT(a,10,1); ft_snap("roundtrip",0,1536,0,a);
  return 0;
}
