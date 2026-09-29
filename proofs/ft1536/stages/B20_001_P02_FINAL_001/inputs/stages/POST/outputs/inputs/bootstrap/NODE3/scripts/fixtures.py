from fractions import Fraction as F
from dyadic import rn
def make(branch):
 if branch==0:
  triples=[([F(1,2)]*3,[0,0,0]),([F(1,2),1,2**22],[0,0,0]),([2**22,3,1],[0,0,0]),([1,2,2],[0,0,0]),
   ([1536,1536+F(1,2**40),1536-F(1,2**40)],[0,0,0]),([F(1,2),F(1,2)+F(1,2**53),F(1,2)+F(1,2**52)],[0,0,0])]
 else:
  triples=[([73,73,73],[0,0,0]),([73,2**30,18433],[17,-17,5]),([2**30,73,73],[17,0,-17]),
   ([128,2**29,256],[-17,17,1]),([73,74,75],[17,-17,17]),([2**30]*3,[-17,-17,17])]
 real=[];imag=[]
 for j in range(256):
  r,i=triples[j%len(triples)];real.extend(rn(F(x)) for x in r);imag.extend(rn(F(x)) for x in i)
  if branch==1 and j%len(triples)==0:imag[-3]=1<<63;imag[-1]=1<<63
 return real+imag
def scalar_pairs():
 xs={0,1,0x8000000000000000,0x8000000000000001,0x000fffffffffffff,0x0010000000000000}
 for v in [F(1,3),F(1,2),1,3,17,2**30,2**60,2**100]:
  w=rn(v);xs.update([w,w^(1<<63)])
 ys=[rn(F(1,16)),rn(F(1,8)),rn(F(1,2)),rn(3),rn(16),rn(2**23),rn(2**30),rn(2**35)]
 return [(x,y) for x in sorted(xs) for y in ys]
