import Source3.RxSection210

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

open FT1536.Source3
#check RxLoop210.source
#check RxWhole210.source_exists
#check RxWhole210.source64_exists
#check RxSection210.source
#check RxSection210.source_two
#print axioms RxControl210.self_i32
#print axioms RxControl210.i_cell
#print axioms RxControl210.i_outside
#print axioms RxControl210.integer_i
#print axioms RxControl210.add_one_i
#print axioms RxControl210.sub_one_x
#print axioms RxControl210.increment
#print axioms RxControl210.shift_eval
#print axioms RxControl210.le_word
#print axioms RxControl210.ne_zero
#print axioms RxControl210.guard
#print axioms RxControl210.branch_guard
#print axioms RxBody210.cell
#print axioms RxBody210.assign
#print axioms RxBody210.withZ_locals
#print axioms RxBody210.zChosen
#print axioms RxBody210.if_source
#print axioms RxBody210.source
#print axioms RxBody210.locals
#print axioms RxBody210.rCell
#print axioms RxBody210.zCell
#print axioms RxBody210.heap
#print axioms RxBody210.arrays
#print axioms RxLoop210.source
#print axioms RxEntry210.binding
#print axioms RxEntry210.xCell
#print axioms RxEntry210.pCell
#print axioms RxEntry210.iCell
#print axioms RxEntry210.r2Cell
#print axioms RxEntry210.declared_locals
#print axioms RxEntry210.param_locals
#print axioms RxEntry210.loop_x
#print axioms RxEntry210.loop_r
#print axioms RxEntry210.loop_z
#print axioms RxWhole210.prefix_source
#print axioms RxWhole210.body_source
#print axioms RxWhole210.source_exists
#print axioms RxWhole210.first_bind64
#print axioms RxWhole210.entry64
#print axioms RxWhole210.source64_exists
#print axioms RxWhole210.call64
#print axioms RxSection210.one_word
#print axioms RxSection210.two_word
#print axioms RxSection210.source
#print axioms RxSection210.source_two
