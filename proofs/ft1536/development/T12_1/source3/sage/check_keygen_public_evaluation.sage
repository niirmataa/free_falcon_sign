"""BATCH_042 exact finite public-field row/stage/original-value controls.

The unchanged041 raw C/UBSan campaign remains pinned historical evidence.
This new Sage job independently checks every block remainder and every
physical evaluation at all nine polynomial boundaries, with negative controls.
It supplements the universal source theorems, and is not their replacement.
"""
import hashlib
import json
import os
from pathlib import Path

old = Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])
repo = next(p for p in old.parents if (p/'Extra/c/falcon-vrfy.c').exists())
workspace = repo/'proofs/ft1536/development/T12_1/source3'
predecessor = workspace/'.build/jobs/keygen_public_first_checks_041_003'
def digest(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
expected_pins = {
    'PUBLIC_FIRST_FIXTURE.json':'8e7b6aaec74cac032ef688734e74910408d08b3e4e37521143e8d6cb0b296808',
    'PUBLIC_FIRST_CHECK.json':'e6261d6a83ea371e94f10aeef7470c7b110c0c38f543ade329adaafc38f4b4fc',
    'PUBLIC_FIRST_HEADERS.json':'617f0f8c69cde0b82df627e49cd7b5d5764b3ed0be2cd04975ca62711f35c6d8'}
for name, expected in expected_pins.items(): assert digest(predecessor/name)==expected,name
fixture = json.loads((predecessor/'PUBLIC_FIRST_FIXTURE.json').read_text())
controls = json.loads((predecessor/'PUBLIC_FIRST_CHECK.json').read_text())
headers = json.loads((predecessor/'PUBLIC_FIRST_HEADERS.json').read_text())
assert controls['status']=='PASS_FINITE_SOURCE_CONTROLS'
assert len(controls['variants'])==12
for name, expected in headers['actual_source_pins'].items():
    assert digest(repo/'Extra/c'/name)==expected,name
for variant in controls['variants']:
    for path, expected in variant['artifacts'].items(): assert digest(predecessor/path)==expected,path

q=ZZ(18433); n=ZZ(1536); F=Zmod(q); P=PolynomialRing(F,'X'); X=P.gen()
base=F(25)^2
def reverse(x,bits):
    result=ZZ(0)
    for j in range(bits): result=2*result+((x>>j)&1)
    return result
def exponent(i):
    i=max(ZZ(1),ZZ(i));k=ZZ(i.nbits()-1);u=reverse(i-2^k,k)
    return (1 if k==9 else 3*2^(8-k))*(3*u+1+u%2)
roots=[base^exponent(i) for i in range(1024)]
points=[base^(exponent(512+i//3)+1536*(i%3)) for i in range(n)]
assert [ZZ(x) for x in points]==[ZZ(x) for x in fixture['points']]
assert len(set(points))==n and base.multiplicative_order()==4608
unity=roots[1]^2
assert unity^3==1 and roots[1]^2-roots[1]+1==0
vectors=[a for pair in fixture['f_g'] for a in pair]
assert len(vectors)==8
evaluations=ZZ(0);remainders=ZZ(0);root_laws=ZZ(0);negative=[]
for k in range(9):
    t=768//2^k;m=2^(k+1)
    assert m*t==1536
    for i in range(n):
        assert points[i]^t==roots[m+i//t]^(2 if k<8 else 3)
        root_laws+=1
for case,vector in enumerate(vectors):
    original=P([ZZ(c) for c in vector]);expected=[original(x) for x in points]
    snapshots=fixture['snapshots'][case]
    first=[F(c) for c in snapshots['F_768']]
    assert P(first[:768])==original%(X^768-roots[1])
    assert P(first[768:])==original%(X^768-(1-roots[1]))
    remainders+=2
    current=first
    for k in range(9):
        t=768//2^k;m=2^(k+1)
        for row in range(m):
            block=P(current[row*t:(row+1)*t])
            for i in range(row*t,(row+1)*t):
                assert block(points[i])==expected[i]
                evaluations+=1
        if k==8: break
        nxt=[F(c) for c in snapshots['R_'+str(m)]];d=t//2
        for row in range(m):
            block=P(current[row*t:(row+1)*t]);z=roots[m+row]
            assert P(nxt[row*t:row*t+d])==block%(X^d-z)
            assert P(nxt[row*t+d:(row+1)*t])==block%(X^d+z)
            remainders+=2
        current=nxt
    final=[F(c) for c in snapshots['T_0']]
    assert final==expected
    wrong_order=[];wrong_scale=[]
    for j in range(512):
        u=3*j;A,B,C=current[u:u+3];x=roots[512+j]
        actual=[A+B*x+C*x^2,A+B*x*unity+C*x^2*unity^2,A+B*x*unity^2+C*x^2*unity]
        assert actual==final[u:u+3]
        wrong_order.extend([actual[0],actual[2],actual[1]])
        bad=F(2)^16*x
        wrong_scale.extend([A+B*bad+C*bad^2,A+B*bad*unity+C*bad^2*unity^2,A+B*bad*unity^2+C*bad^2*unity])
    evaluations+=n
    negative.append({'case':case,'wrong_order_detected':wrong_order!=expected,'wrong_scale_detected':wrong_scale!=expected})
assert all(any(row[key] for row in negative) for key in ['wrong_order_detected','wrong_scale_detected'])
assert evaluations==122880 and remainders==8176 and root_laws==13824
result={'status':'PASS_FINITE_INVARIANT_CONTROLS','vectors':len(vectors),'physical_evaluations':int(evaluations),
    'block_remainders':int(remainders),'root_tree_laws':int(root_laws),'negative_controls':negative,
    'source_pins':headers['actual_source_pins'],'inherited_header_differences':headers['differences'],
    'predecessor_pins':{str(predecessor/name):expected for name,expected in expected_pins.items()},
    'inherited_C_UBSan_runs_rehashed':int(12),'new_C_executions':int(0),
    'scope':'Exact finite original-polynomial invariant at every first/radix boundary and all physical triples. Universal source execution is proved separately in Lean. Same inherited039 live-header decision; not a full M0 build, nonzero/inverse proof or review.'}
Path('PUBLIC_EVALUATION_CHECK.json').write_text(json.dumps(result,indent=2)+'\n')
