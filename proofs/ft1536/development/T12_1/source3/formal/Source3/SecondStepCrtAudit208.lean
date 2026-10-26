import Source3.SecondStepCrtFull208

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

open FT1536.Source3
#check ZintNormWalkLoop208.source
#check ZintNormWalkBranch208.source
#check CrtBody208.source
#check CrtCall208.source
#check SecondStepCrtPair208.source
#check SecondStepCrtFull208.source
#print axioms ZintNormWalkIncrement208.row_element
#print axioms ZintNormWalkIncrement208.row_step
#print axioms ZintNormWalkIncrement208.source
#print axioms ZintNormWalkIncrement208.locals
#print axioms ZintNormWalkIncrement208.arrays
#print axioms ZintNormWalkIncrement208.counter
#print axioms ZintNormWalkIncrement208.pointer
#print axioms ZintNormWalkFixed208.index_different
#print axioms ZintNormWalkFixed208.different
#print axioms ZintNormWalkFixed208.row_capacity
#print axioms ZintNormWalkStep208.step
#print axioms ZintNormWalkLoop208.guard
#print axioms ZintNormWalkLoop208.remaining
#print axioms ZintNormWalkLoop208.source
#print axioms ZintNormWalkFlat208.row_zero
#print axioms ZintNormWalkFlat208.index_bound
#print axioms ZintNormWalkFlat208.quotient_bound
#print axioms ZintNormWalkFlat208.address
#print axioms ZintNormWalkFlat208.source
#print axioms ZintNormWalkBranch208.fixed
#print axioms ZintNormWalkBranch208.init_source
#print axioms ZintNormWalkBranch208.source
#print axioms CrtEntry208.prime_load
#print axioms CrtEntry208.prefix_source
#print axioms CrtEntry208.object_after
#print axioms CrtEntry208.round_input
#print axioms CrtEntry208.data_after
#print axioms CrtBody208.source
#print axioms CrtCall208.input
#print axioms CrtCall208.binding
#print axioms CrtCall208.source
#print axioms SecondStepCrtDomain208.data_tmp
#print axioms SecondStepCrtDomain208.cross
#print axioms SecondStepCrtDomain208.data_product
#print axioms SecondStepCrtDomain208.tmp_product
#print axioms SecondStepCrtDomain208.domain
#print axioms SecondStepCrtDomain208.outer
#print axioms SecondStepCrtDomain208.prime_object
#print axioms SecondStepCrtPair208.source
#print axioms SecondStepCrtPair208.product
#print axioms SecondStepCrtStatics208.prime_object
#print axioms SecondStepCrtFull208.source
