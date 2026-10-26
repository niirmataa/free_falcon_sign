import Source3.CrtMulCall213

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

open FT1536.Source3
#check ZintMulWhole213.source
#check ZintAddMulWhole213.source
#check CrtAddMulCall213.source
#check CrtMulCall213.source
#print axioms ZintMulLimb213.locals
#print axioms ZintMulLimb213.carry_cell
#print axioms ZintMulLimb213.source
#print axioms ZintMulFixed213.next_locals
#print axioms ZintMulFixed213.next_arrays
#print axioms ZintMulStep213.step
#print axioms ZintMulLoop213.guard
#print axioms ZintMulLoop213.remaining
#print axioms ZintMulWhole213.source
#print axioms ZintAddMulLimb213.before2
#print axioms ZintAddMulLimb213.locals
#print axioms ZintAddMulLimb213.carry_cell
#print axioms ZintAddMulLimb213.source
#print axioms ZintAddMulFixed213.next_locals
#print axioms ZintAddMulFixed213.next_arrays
#print axioms ZintAddMulStep213.step
#print axioms ZintAddMulLoop213.guard
#print axioms ZintAddMulLoop213.remaining
#print axioms ZintAddMulWhole213.source
#print axioms CrtAddMulCall213.entry_cells
#print axioms CrtAddMulCall213.binding
#print axioms CrtAddMulCall213.source
#print axioms CrtMulCall213.cells
#print axioms CrtMulCall213.binding
#print axioms CrtMulCall213.source
