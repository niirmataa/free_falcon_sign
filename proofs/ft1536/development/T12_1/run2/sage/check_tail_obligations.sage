# Checker rozliczenia dwóch prymitywnych obowiązków ogonowych z
# Run2/RadialObligations (kernel zredukował hpair/hemit do nich):
#   (1) changeProbability^2 <= changeCap2 = multiCap/(768*767),
#   (2) masa unsignedHalf (ogon signed16) <= emitCap.
# Scisle kule Arb512 + dokladne porownania QQ. Bez RDF i bez RNG.
from pathlib import Path
import json, time
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024

R = RealBallField(512)
C = ComplexBallField(512)
sig = ZZ(768)

# Dokladne capy z kernela (Run2/RadialObligations / Run2/RawRadialEnclosure).
changeCap2 = QQ(17142909382589539438) / (ZZ(589056) * 10^62)
emitCap = QQ(11261106164085308753) / 10^314

# Gaussian box G i ogony wspolrzednych — te same formulas co
# run/sage/close_radial_interval.sage (sprawdzony tam rachunek).
def gaussian_box(sigma2):
    a = R(1)/(2*sigma2); tau = C(0,1)*C(a/R.pi())
    ts = C(0).jacobi_theta(tau); tt = C(0).jacobi_theta(3*tau)
    g = (ts[2]*tt[2]+ts[1]*tt[1]).real()
    L = ZZ(65536); beta = 3*a/4; r = (-beta*(2*L+1)).exp()
    tail = 4*(1+(2*R.pi()*sigma2).sqrt())*(-beta*L^2).exp()/(1-r)
    return g.add_error(tail)

G = gaussian_box(R(sig^2))
shift = 1+(2*R.pi()).sqrt()*sig

def coordinate_tail(L):
    beta = R(3)/(8*sig^2); r = (-beta*(2*L+1)).exp()
    return 2*shift/G*(-beta*L^2).exp()/(1-r)

# (1) changed => center rusza x lub y => |x|>=9217 lub |y|>=9217,
#     stad changeProbability <= 2*coordinate_tail(9217) =: changed_block.
changed_block = 2*coordinate_tail(9217)
chg2 = changed_block^2

# (2) nie-signed16 => jakas wspolrzedna >=32768; suma po 1536 blokach
#     (konsystentnie z emit_loss w close_radial_interval.sage).
emit_bound = 1536*coordinate_tail(32768)

ok1 = bool(chg2 <= R(changeCap2))
ok2 = bool(emit_bound <= R(emitCap))
assert ok1, (chg2, changeCap2)
assert ok2, (emit_bound, emitCap)

# Piny tau kernelowe (Run2/ChangedTailReduction): dokladne QQ.
tau9217 = QQ(269732934410771771958) / 10^45
changedBlockCap = QQ(539465868821543543916) / 10^45
ok3 = bool(coordinate_tail(9217) <= R(tau9217))
ok4 = bool(changed_block <= R(changedBlockCap))
ok5 = bool(2*tau9217 == changedBlockCap)
ok6 = bool(changedBlockCap^2 <= changeCap2)
assert ok3 and ok4 and ok5 and ok6

out = dict(
    status='PASS',
    changeCap2=str(changeCap2), emitCap=str(emitCap),
    tau9217=str(tau9217), changedBlockCap=str(changedBlockCap),
    changed_block=str(changed_block), chg2=str(chg2),
    emit_bound=str(emit_bound),
    checks=dict(changeProbability_sq_le_changeCap2=ok1,
                unsignedHalf_tail_le_emitCap=ok2,
                coordTail9217_le_tau9217=ok3,
                changed_block_le_cap=ok4,
                twice_tau_eq_cap=ok5,
                cap_sq_le_changeCap2=ok6),
    kernel_targets='Run2/RadialObligations pairPenalty_of_changeCap emitPenalty_of_tailCap; Run2/ChangedTailReduction hchange_of_tau',
    arithmetic='RealBallField(512) + exact QQ comparisons, no RNG',
)
Path('tail_obligations_result.json').write_text(json.dumps(out, indent=2)+'\n')
print('TAIL_OBLIGATIONS_PASS', json.dumps(out['checks'], sort_keys=True))
