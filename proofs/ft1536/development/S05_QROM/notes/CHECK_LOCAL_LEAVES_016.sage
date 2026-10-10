# sage CHECK_LOCAL_LEAVES_016.sage OUT TABLES RECOMPUTED_RESULT CERT007
# Rigorous numeric support for LOCAL leaves; it is not their Lean proof.
from pathlib import Path
import json,sys
out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=True);assert not (out/'RESULT.json').exists()
t=json.loads(Path(sys.argv[2]).read_text());exact=json.loads(Path(sys.argv[3]).read_text());old=json.loads(Path(sys.argv[4]).read_text())
RB=RealBallField(512)
def ball(lo,hi):
 lo=QQ(lo);hi=QQ(hi);assert lo<=hi
 return RB((lo+hi)/2,(hi-lo)/2)
def record(x):return {'lower_exact':str(x.lower().exact_rational()),'upper_exact':str(x.upper().exact_rational()),'ball':str(x)}
g=ball(old['triangle_normalizer']['lower_exact'],old['triangle_normalizer']['upper_exact'])
alpha=QQ(exact['alpha_exact']);W=sum(ZZ(x) for x in t['weights']);Zminus=QQ(W-30721)/2^256
kappa=(1+RB(W)/2^384)*(1+RB(2)^(-256)*RB(100).exp())
raw=kappa^2*g/(RB(alpha)*RB(Zminus)^2)
cube=g^1536*RB(1024).exp()/RB(2)^30720
assert alpha>QQ(9)/16
assert raw-1<RB(2)^(-100)
assert g<RB(2)^23
assert cube<RB(2)^4630
result={'status':'RIGOROUS_NUMERIC_SUPPORT_NOT_KERNEL_LEAF_INSTANCES','precision':512,
 'raw_accepted_density_excess':record(raw-1),'block_normalizer':record(g),'cube_density_log2':record(cube.log()/RB(2).log()),
 'checks':['alpha>9/16','raw_factor-1<2^-100','g1<2^23','cube_density<2^4630'],
 'inherited_enclosure':'SAMPLER_007_CERTIFICATE triangle_normalizer with pinned QQ endpoints',
 'remaining':['Kernel bit-word/modulo/CDF count and table rounding-to-Gaussian connection',
 'Kernel fixed pair-normalizer upper bounds and cube density proof'],
 'kernel_pair_leaves_instantiated':False,'kernel_cube_leaf_instantiated':False}
(out/'RESULT.json').write_text(json.dumps(result,indent=2,default=int)+'\n')
print('PASS: all four local numeric budgets; kernel leaf instances remain OPEN',flush=True)
