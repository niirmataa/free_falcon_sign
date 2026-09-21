"""Independent MSB bit string specification and literal uint32 encoder check."""
from post_model import narrow16
def codebits(xs,j=8,terminator=True):
 bits=[]
 for w in xs:
  assert -32768<=w<=32767
  mag=abs(w);bits+=[int(w<0)]+[(mag>>k)&1 for k in range(j-1,-1,-1)]+[0]*(mag>>j)
  if terminator:bits.append(1)
 return bits
def pack(bits,pad=0):
 bits=list(bits)+[pad]*((-len(bits))%8)
 return bytes(sum(b<<(7-j) for j,b in enumerate(bits[i:i+8])) for i in range(0,len(bits),8))
def encode(xs,j=8,terminator=True,pad=0):return pack(codebits(xs,j,terminator),pad)
def literal_encode(xs,cap=None):
 acc=nb=0;out=[]
 def write(x):
  if cap is not None and len(out)>=cap:return False
  out.append(x&255);return True
 for w in xs:
  assert -32768<=w<=32767
  sign=int(w<0);w=abs(w);lo=(sign<<8)|(w&255);ne=w>>8;acc=((acc<<9)|lo)&0xffffffff;nb+=9
  while nb>=8:
   nb-=8
   if not write(acc>>nb):return 0,bytes(out)
  while ne>=0:
   ne-=1;acc=((acc<<1)+(((ne&0xffffffff)>>15)&1))&0xffffffff;nb+=1
   if nb==8:
    if not write(acc):return 0,bytes(out)
    nb=0
 if nb and not write(acc<<(8-nb)):return 0,bytes(out)
 return len(out),bytes(out)
def decode(data,n=1536):
 bits=[(x>>k)&1 for x in data for k in range(7,-1,-1)];p=0;out=[]
 for _ in range(n):
  if p+9>len(bits):return None
  sign=bits[p];lo=sum(bits[p+1+i]<<(7-i) for i in range(8));p+=9;ne=0
  while True:
   if p>=len(bits):return None
   bit=bits[p];p+=1
   if bit:break
   ne=(ne+1)&0xffffffff
  if ne>255:return None
  mag=lo+(ne<<8);out.append(narrow16(-narrow16(mag)) if sign else narrow16(mag))
 used=(p+7)//8
 if any(bits[p:8*used]):return None
 return out,used
def frame(xs,cap):
 if cap<2:return 0,b''
 n,b=literal_encode(xs,cap-1)
 return (n+1,b'\xaa'+b) if n else (0,b'\xa5'+b)
