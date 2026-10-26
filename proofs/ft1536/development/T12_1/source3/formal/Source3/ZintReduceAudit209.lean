import Source3.ZintSignedCall209

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

open FT1536.Source3
#check ZintReduceWhole209.source
#check ZintReduceCall209.source
#check ZintSignedWhole209.source
#check ZintSignedCall209.source
#print axioms ZintReduceStep209.declared_outside
#print axioms ZintReduceStep209.lower_source
#print axioms ZintReduceStep209.locals
#print axioms ZintReduceStep209.xCell
#print axioms ZintReduceStep209.uCell
#print axioms ZintReduceStep209.source
#print axioms ZintReduceLoop209.after_fixed
#print axioms ZintReduceLoop209.source
#print axioms ZintReduceWhole209.before3
#print axioms ZintReduceWhole209.start_locals
#print axioms ZintReduceWhole209.initial_fixed
#print axioms ZintReduceWhole209.append_source
#print axioms ZintReduceWhole209.source
#print axioms ZintReduceCall209.fixed
#print axioms ZintReduceCall209.binding
#print axioms ZintReduceCall209.source
#print axioms ZintSignedExpr209.zero_eval
#print axioms ZintSignedExpr209.high_pointer
#print axioms ZintSignedExpr209.sub_eval
#print axioms ZintSignedWhole209.declared_locals
#print axioms ZintSignedWhole209.declared_fixed
#print axioms ZintSignedWhole209.source
#print axioms ZintSignedCall209.cells
#print axioms ZintSignedCall209.binding
#print axioms ZintSignedCall209.source
