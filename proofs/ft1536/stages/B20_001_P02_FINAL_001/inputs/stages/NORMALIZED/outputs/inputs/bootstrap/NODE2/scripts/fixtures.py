"""Public synthetic refined-envelope data; not keys or P_key witnesses."""
from fractions import Fraction as F
from dyadic import rn
def root_words(branch):
 if branch==0:
  triples=[([F(1,2)]*3,[0,0,0]),([F(1,2),1,2**22],[0,0,0]),([2**22,3,1],[0,0,0]),([1,2,2],[0,0,0]),([1536,1536+F(1,2**40),1536-F(1,2**40)],[0,0,0])]
 else:
  triples=[([73]*3,[0,0,0]),([73,2**30,18433],[F(17,64),-F(17,64),F(5,64)]),([2**30,73,73],[F(17,64),0,-F(17,64)]),
   ([128,2**29,256],[-F(17,64),F(17,64),F(1,64)]),([73,74,75],[F(17,64),-F(17,64),F(17,64)]),([2**30]*3,[-F(17,64),-F(17,64),F(17,64)])]
 real=[];imag=[]
 for j in range(256):
  r,i=triples[j%len(triples)];real.extend(rn(F(x)) for x in r);imag.extend(rn(F(x)) for x in i)
  if branch==1 and j%len(triples)==0:imag[-3]=1<<63;imag[-1]=1<<63
 return real+imag
def half_words():
 words=set()
 for e in [0,1,2,3,1023,1123,2046]:
  for f in [0,1,2,(1<<51)-1,1<<51,(1<<52)-2,(1<<52)-1]:
   for s in [0,1]:words.add((s<<63)|(e<<52)|f)
 return sorted(words)
