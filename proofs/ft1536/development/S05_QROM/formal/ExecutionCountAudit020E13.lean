import ProducerCount020E13
import ProducerPairCount020E13
import ConsumerCount020E13
import ProducerExactCount020E13
import CoreCountTypes020E13
import ConsumerCountBoundary020E13
import CoreStepCount020E13
import CountedLoop020E13
import CoreCountBounds020E13
import CountedLoopBoundary020E13
import CoreDriverCount020E13
import CoreResultCount020E13
import CountedFlow020E13
import PublicCoreCount020E13
import PublicCallCount020E13
import ExecutionCountNumbers020E13

#print axioms FT1536.S05.ProducerCount020E13.run
#print axioms FT1536.S05.ProducerCount020E13.value
#print axioms FT1536.S05.ProducerCount020E13.bound
#print axioms FT1536.S05.ProducerCount020E13.invoke
#print axioms FT1536.S05.ProducerCount020E13.invoke_value
#print axioms FT1536.S05.ProducerCount020E13.invoke_bound
#print axioms FT1536.S05.ProducerCount020E13.transitions_bound
#print axioms FT1536.S05.ProducerCount020E13.stopped
#print axioms FT1536.S05.ProducerPairCount020E13.run
#print axioms FT1536.S05.ProducerPairCount020E13.value
#print axioms FT1536.S05.ProducerPairCount020E13.bound
#print axioms FT1536.S05.ProducerPairCount020E13.core_bound
#print axioms FT1536.S05.ConsumerCount020E13.Report
#print axioms FT1536.S05.ConsumerCount020E13.step
#print axioms FT1536.S05.ConsumerCount020E13.step_value
#print axioms FT1536.S05.ConsumerCount020E13.step_bound
#print axioms FT1536.S05.ConsumerCount020E13.run
#print axioms FT1536.S05.ConsumerCount020E13.value
#print axioms FT1536.S05.ConsumerCount020E13.bound
#print axioms FT1536.S05.ConsumerCount020E13.consume
#print axioms FT1536.S05.ConsumerCount020E13.consume_value
#print axioms FT1536.S05.ConsumerCount020E13.consume_bound
#print axioms FT1536.S05.ProducerExactCount020E13.cycle_pc
#print axioms FT1536.S05.ProducerExactCount020E13.exact_cycles
#print axioms FT1536.S05.ProducerExactCount020E13.invoke_cycles
#print axioms FT1536.S05.ProducerExactCount020E13.pair_cycles
#print axioms FT1536.S05.ProducerExactCount020E13.core_cycles
#print axioms FT1536.S05.CoreCountTypes020E13.Counts
#print axioms FT1536.S05.CoreCountTypes020E13.zero
#print axioms FT1536.S05.CoreCountTypes020E13.add
#print axioms FT1536.S05.CoreCountTypes020E13.test
#print axioms FT1536.S05.CoreCountTypes020E13.Report
#print axioms FT1536.S05.CoreCountTypes020E13.map
#print axioms FT1536.S05.CoreCountTypes020E13.Valid
#print axioms FT1536.S05.CoreCountTypes020E13.zero_valid
#print axioms FT1536.S05.CoreCountTypes020E13.stop_valid
#print axioms FT1536.S05.CoreCountTypes020E13.round_valid
#print axioms FT1536.S05.ConsumerCountBoundary020E13.bad
#print axioms FT1536.S05.ConsumerCountBoundary020E13.completed
#print axioms FT1536.S05.ConsumerCountBoundary020E13.malformed
#print axioms FT1536.S05.ConsumerCountBoundary020E13.step_no_write
#print axioms FT1536.S05.ConsumerCountBoundary020E13.run_no_write
#print axioms FT1536.S05.CoreStepCount020E13.run
#print axioms FT1536.S05.CoreStepCount020E13.value
#print axioms FT1536.S05.CoreStepCount020E13.counts
#print axioms FT1536.S05.CountedLoop020E13.run
#print axioms FT1536.S05.CountedLoop020E13.plain
#print axioms FT1536.S05.CountedLoop020E13.value
#print axioms FT1536.S05.CountedLoop020E13.valid
#print axioms FT1536.S05.CoreCountBounds020E13.bounded
#print axioms FT1536.S05.CountedLoopBoundary020E13.stopped
#print axioms FT1536.S05.CountedLoopBoundary020E13.malformed
#print axioms FT1536.S05.CoreDriverCount020E13.run
#print axioms FT1536.S05.CoreDriverCount020E13.plain
#print axioms FT1536.S05.CoreDriverCount020E13.value_aux
#print axioms FT1536.S05.CoreDriverCount020E13.value_function
#print axioms FT1536.S05.CoreDriverCount020E13.value
#print axioms FT1536.S05.CoreDriverCount020E13.valid
#print axioms FT1536.S05.CoreDriverCount020E13.bound
#print axioms FT1536.S05.CoreDriverCount020E13.stopped
#print axioms FT1536.S05.CoreDriverCount020E13.malformed
#print axioms FT1536.S05.CoreResultCount020E13.run
#print axioms FT1536.S05.CoreResultCount020E13.value
#print axioms FT1536.S05.CoreResultCount020E13.valid
#print axioms FT1536.S05.CoreResultCount020E13.execute
#print axioms FT1536.S05.CoreResultCount020E13.execute_value
#print axioms FT1536.S05.CoreResultCount020E13.execute_valid
#print axioms FT1536.S05.CoreResultCount020E13.typed_value
#print axioms FT1536.S05.CountedFlow020E13.optionBind
#print axioms FT1536.S05.CountedFlow020E13.optionBind_value
#print axioms FT1536.S05.CountedFlow020E13.optionBind_refines
#print axioms FT1536.S05.CountedFlow020E13.optionBind_valid
#print axioms FT1536.S05.CountedFlow020E13.select_value
#print axioms FT1536.S05.CountedFlow020E13.select_valid
#print axioms FT1536.S05.CountedFlow020E13.map_refines
#print axioms FT1536.S05.PublicCoreCount020E13.fromRoot
#print axioms FT1536.S05.PublicCoreCount020E13.fromRoot_value
#print axioms FT1536.S05.PublicCoreCount020E13.fromRoot_valid
#print axioms FT1536.S05.PublicCoreCount020E13.fromArena
#print axioms FT1536.S05.PublicCoreCount020E13.fromArena_value
#print axioms FT1536.S05.PublicCoreCount020E13.fromArena_valid
#print axioms FT1536.S05.PublicCallCount020E13.fromParser
#print axioms FT1536.S05.PublicCallCount020E13.run
#print axioms FT1536.S05.PublicCallCount020E13.fromParser_value
#print axioms FT1536.S05.PublicCallCount020E13.value
#print axioms FT1536.S05.PublicCallCount020E13.fromParser_valid
#print axioms FT1536.S05.PublicCallCount020E13.valid
#print axioms FT1536.S05.PublicCallCount020E13.every_tape
#print axioms FT1536.S05.PublicCallCount020E13.full_response
#print axioms FT1536.S05.PublicCallCount020E13.core_bound
#print axioms FT1536.S05.PublicCallCount020E13.parser_reject
#print axioms FT1536.S05.ExecutionCountNumbers020E13.budget_value
#print axioms FT1536.S05.ExecutionCountNumbers020E13.public_bounds
