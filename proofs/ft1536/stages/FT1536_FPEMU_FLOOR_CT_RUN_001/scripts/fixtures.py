"""Independent exact all-word oracle; no hardware FP conversion on raw words."""
import json,struct
from pathlib import Path
from fractions import Fraction
from dyadic import value,rn
from replaylib import sha
MASK=2**64-1;FRAC=2**52-1;SEED=0x465431353336464c
def oracle(x,mutation=None):
 s=x//2**63;e=(x//2**52)%2048;f=x%2**52
 if mutation=='zero' and x==2**63:return 0
 if e<(1021 if mutation=='mask' else 1022):return (-s)&MASK
 n=(61-e%64)%64
 if mutation=='shift':n%=32
 m=(2**52+f)*1024;d=2**n
 return ((-((m+d-1)//d)) if s else m//d)&MASK
def mix(state):
 state=(state+0x9e3779b97f4a7c15)&MASK;z=state
 z=((z^(z>>30))*0xbf58476d1ce4e5b9)&MASK;z=((z^(z>>27))*0x94d049bb133111eb)&MASK
 return state,(z^(z>>31))&MASK
def main():
 W=Path.cwd();d=W/'checks/data';d.mkdir(parents=True,exist_ok=True)
 fs=sorted({0,1,2,3,2**10-1,2**10,2**20-1,2**20,2**20+1,2**31-1,2**31,2**31+1,2**51-1,2**51,2**52-2,2**52-1})
 structured=[(s<<63)|(e<<52)|f for e in range(2048) for s in [0,1] for f in fs]
 boundaries=set()
 for n in [-2147483284,-2147483283,-2147483282,-1,0,1,2147483281,2147483282,2147483283]:
  x=rn(Fraction(n))
  for z in [x-1,x,x+1]:
   if 0<=z<=MASK:boundaries.add(z)
 structured+=sorted(boundaries)
 lean=[(s<<63)|(e<<52)|f for e in range(2048) for s in [0,1] for f in [0,1,FRAC]]
 (d/'lean_inputs.txt').write_text(''.join(str(x)+'\n' for x in lean))
 (d/'lean_expected.txt').write_text(''.join(f'{oracle(x)} {oracle(x)}\n' for x in lean))
 count=0;center=0;mut={};state=SEED
 with (d/'corpus.bin').open('wb') as out:
  for i in range(len(structured)+1000000):
   if i<len(structured):x=structured[i]
   else:state,x=mix(state)
   y=oracle(x);out.write(struct.pack('<QQ',x,y));count+=1
   if i<len(structured):
    for name in ['zero','mask','shift']:
     z=oracle(x,name)
     if y!=z and name not in mut:mut[name]=dict(raw=f'{x:016x}',expected=f'{y:016x}',mutant=f'{z:016x}')
    assert oracle(x^0)==y
    if (x>>52)&2047 !=2047:
     q=value(x)
     if -2147483283<=q<2147483282:
      expected=q.numerator//q.denominator-(x==2**63);assert y==expected&MASK;center+=1
 assert set(mut)=={'zero','mask','shift'}
 facts=dict(schema='FLOOR_WORD_CORPUS_V1',cases=count,structured_cases=len(structured),random_words=1000000,public_seed=f'{SEED:016x}',
  exponents=2048,signs=2,mantissas=fs,numeric_center_crosschecks=center,lean_value_cases=len(lean),corpus_sha256=sha(d/'corpus.bin'),
  oracle='Closed exponent/fraction formula with nonnegative quotient/ceil; no C XOR/mask/shift helper, no hardware FP for NaN/Inf.',mutation_witnesses=mut,noop_pass=True)
 (W/'artifacts/corpus.json').write_text(json.dumps(facts,indent=2)+'\n');print(json.dumps(facts,indent=2))
if __name__=='__main__':main()
