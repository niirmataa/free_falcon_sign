import Source3.CrtCoefficientImage205

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

open FT1536.Source3
#check CrtCoefficient205.source
#check CrtCoefficientImage205.source
#check CrtAddMulCall205.source
#check CrtReduceCall205.source
#check CrtMulCall205.source
#print axioms CrtWordOps205.cast_widen
#print axioms CrtWordOps205.cast_narrow
#print axioms CrtWordOps205.add64
#print axioms CrtWordOps205.mul64
#print axioms CrtWordOps205.add64_32
#print axioms CrtWordOps205.right64
#print axioms CrtWordOps205.mask31
#print axioms CrtState205.cell32
#print axioms CrtState205.cell64
#print axioms WordControl205.frame
#print axioms WordAtoms205.assign32
#print axioms WordAtoms205.assign64
#print axioms WordAtoms205.widen
#print axioms WordAtoms205.narrow
#print axioms ZintMulWord205.shape
#print axioms ZintMulWord205.source
#print axioms ZintAddMulWord205.shape
#print axioms ZintAddMulWord205.source
#print axioms CrtLeafImages205.mul
#print axioms CrtLeafImages205.addMul
#print axioms CrtAddMulCall205.binding
#print axioms CrtAddMulCall205.source
#print axioms CrtReduceCall205.binding
#print axioms CrtReduceCall205.source
#print axioms CrtMulCall205.binding
#print axioms CrtMulCall205.source
#print axioms CrtRoundShape205.shape
#print axioms CrtCoefficient205.restored_locals
#print axioms CrtCoefficient205.source
#print axioms CrtCoefficientImage205.source
