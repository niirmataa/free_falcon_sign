import CommandDecode020E11
import CommandConsumer020E11
import CommandConsumerRefinement020E11
import ProducerRawCore020E11
import CommandConsumerBoundary020E11
import ProducerRawDriver020E11
import ProducerRawResult020E11
import ProducerCoreExecution020E11
#check FT1536.S05.CommandDecode020E11.decode
#print axioms FT1536.S05.CommandDecode020E11.decode
#check FT1536.S05.CommandDecode020E11.roundtrip
#print axioms FT1536.S05.CommandDecode020E11.roundtrip
#check FT1536.S05.CommandDecode020E11.sound
#print axioms FT1536.S05.CommandDecode020E11.sound
#check FT1536.S05.CommandDecode020E11.malformed_tag
#print axioms FT1536.S05.CommandDecode020E11.malformed_tag
#check FT1536.S05.CommandDecode020E11.malformed_padding
#print axioms FT1536.S05.CommandDecode020E11.malformed_padding
#check FT1536.S05.CommandDecode020E11.malformed_address
#print axioms FT1536.S05.CommandDecode020E11.malformed_address
#check FT1536.S05.CommandDecode020E11.accepts_iff
#print axioms FT1536.S05.CommandDecode020E11.accepts_iff
#check FT1536.S05.CommandConsumer020E11.State
#print axioms FT1536.S05.CommandConsumer020E11.State
#check FT1536.S05.CommandConsumer020E11.slot
#print axioms FT1536.S05.CommandConsumer020E11.slot
#check FT1536.S05.CommandConsumer020E11.step
#print axioms FT1536.S05.CommandConsumer020E11.step
#check FT1536.S05.CommandConsumer020E11.run
#print axioms FT1536.S05.CommandConsumer020E11.run
#check FT1536.S05.CommandConsumer020E11.start
#print axioms FT1536.S05.CommandConsumer020E11.start
#check FT1536.S05.CommandConsumer020E11.finish
#print axioms FT1536.S05.CommandConsumer020E11.finish
#check FT1536.S05.CommandConsumer020E11.consume
#print axioms FT1536.S05.CommandConsumer020E11.consume
#check FT1536.S05.CommandConsumer020E11.bad_step
#print axioms FT1536.S05.CommandConsumer020E11.bad_step
#check FT1536.S05.CommandConsumer020E11.bad_run
#print axioms FT1536.S05.CommandConsumer020E11.bad_run
#check FT1536.S05.CommandConsumer020E11.bad_finish
#print axioms FT1536.S05.CommandConsumer020E11.bad_finish
#check FT1536.S05.CommandConsumer020E11.malformed
#print axioms FT1536.S05.CommandConsumer020E11.malformed
#check FT1536.S05.CommandConsumer020E11.frozen_script
#print axioms FT1536.S05.CommandConsumer020E11.frozen_script
#check FT1536.S05.CommandConsumer020E11.completed
#print axioms FT1536.S05.CommandConsumer020E11.completed
#check FT1536.S05.CommandConsumerRefinement020E11.encode
#print axioms FT1536.S05.CommandConsumerRefinement020E11.encode
#check FT1536.S05.CommandConsumerRefinement020E11.slot_decode
#print axioms FT1536.S05.CommandConsumerRefinement020E11.slot_decode
#check FT1536.S05.CommandConsumerRefinement020E11.model
#print axioms FT1536.S05.CommandConsumerRefinement020E11.model
#check FT1536.S05.CommandConsumerRefinement020E11.step_model
#print axioms FT1536.S05.CommandConsumerRefinement020E11.step_model
#check FT1536.S05.CommandConsumerRefinement020E11.run_model
#print axioms FT1536.S05.CommandConsumerRefinement020E11.run_model
#check FT1536.S05.CommandConsumerRefinement020E11.finish_model
#print axioms FT1536.S05.CommandConsumerRefinement020E11.finish_model
#check FT1536.S05.CommandConsumerRefinement020E11.consumes
#print axioms FT1536.S05.CommandConsumerRefinement020E11.consumes
#check FT1536.S05.CommandConsumerRefinement020E11.no_bad_prefix
#print axioms FT1536.S05.CommandConsumerRefinement020E11.no_bad_prefix
#check FT1536.S05.ProducerRawCore020E11.Memory
#print axioms FT1536.S05.ProducerRawCore020E11.Memory
#check FT1536.S05.ProducerRawCore020E11.Core
#print axioms FT1536.S05.ProducerRawCore020E11.Core
#check FT1536.S05.ProducerRawCore020E11.Context
#print axioms FT1536.S05.ProducerRawCore020E11.Context
#check FT1536.S05.ProducerRawCore020E11.sources
#print axioms FT1536.S05.ProducerRawCore020E11.sources
#check FT1536.S05.ProducerRawCore020E11.produce
#print axioms FT1536.S05.ProducerRawCore020E11.produce
#check FT1536.S05.ProducerRawCore020E11.step
#print axioms FT1536.S05.ProducerRawCore020E11.step
#check FT1536.S05.ProducerRawCore020E11.ofData
#print axioms FT1536.S05.ProducerRawCore020E11.ofData
#check FT1536.S05.ProducerRawCore020E11.image
#print axioms FT1536.S05.ProducerRawCore020E11.image
#check FT1536.S05.ProducerRawCore020E11.ofData_core
#print axioms FT1536.S05.ProducerRawCore020E11.ofData_core
#check FT1536.S05.ProducerRawCore020E11.sources_image
#print axioms FT1536.S05.ProducerRawCore020E11.sources_image
#check FT1536.S05.ProducerRawCore020E11.produce_image
#print axioms FT1536.S05.ProducerRawCore020E11.produce_image
#check FT1536.S05.ProducerRawCore020E11.step_image
#print axioms FT1536.S05.ProducerRawCore020E11.step_image
#check FT1536.S05.CommandConsumerBoundary020E11.malformed_stops
#print axioms FT1536.S05.CommandConsumerBoundary020E11.malformed_stops
#check FT1536.S05.CommandConsumerBoundary020E11.malformed_result
#print axioms FT1536.S05.CommandConsumerBoundary020E11.malformed_result
#check FT1536.S05.CommandConsumerBoundary020E11.empty_slot
#print axioms FT1536.S05.CommandConsumerBoundary020E11.empty_slot
#check FT1536.S05.CommandConsumerBoundary020E11.put_slot
#print axioms FT1536.S05.CommandConsumerBoundary020E11.put_slot
#check FT1536.S05.CommandConsumerBoundary020E11.script_cursor
#print axioms FT1536.S05.CommandConsumerBoundary020E11.script_cursor
#check FT1536.S05.CommandConsumerBoundary020E11.encoded_incomplete
#print axioms FT1536.S05.CommandConsumerBoundary020E11.encoded_incomplete
#check FT1536.S05.CommandConsumerBoundary020E11.zero_capacity
#print axioms FT1536.S05.CommandConsumerBoundary020E11.zero_capacity
#check FT1536.S05.ProducerRawDriver020E11.phase
#print axioms FT1536.S05.ProducerRawDriver020E11.phase
#check FT1536.S05.ProducerRawDriver020E11.terminal
#print axioms FT1536.S05.ProducerRawDriver020E11.terminal
#check FT1536.S05.ProducerRawDriver020E11.run
#print axioms FT1536.S05.ProducerRawDriver020E11.run
#check FT1536.S05.ProducerRawDriver020E11.phase_image
#print axioms FT1536.S05.ProducerRawDriver020E11.phase_image
#check FT1536.S05.ProducerRawDriver020E11.terminal_image
#print axioms FT1536.S05.ProducerRawDriver020E11.terminal_image
#check FT1536.S05.ProducerRawDriver020E11.refines
#print axioms FT1536.S05.ProducerRawDriver020E11.refines
#check FT1536.S05.ProducerRawDriver020E11.stop
#print axioms FT1536.S05.ProducerRawDriver020E11.stop
#check FT1536.S05.ProducerRawDriver020E11.malformed_next
#print axioms FT1536.S05.ProducerRawDriver020E11.malformed_next
#check FT1536.S05.ProducerRawResult020E11.readout
#print axioms FT1536.S05.ProducerRawResult020E11.readout
#check FT1536.S05.ProducerRawResult020E11.result
#print axioms FT1536.S05.ProducerRawResult020E11.result
#check FT1536.S05.ProducerRawResult020E11.run
#print axioms FT1536.S05.ProducerRawResult020E11.run
#check FT1536.S05.ProducerRawResult020E11.bool_read
#print axioms FT1536.S05.ProducerRawResult020E11.bool_read
#check FT1536.S05.ProducerRawResult020E11.readout_image
#print axioms FT1536.S05.ProducerRawResult020E11.readout_image
#check FT1536.S05.ProducerRawResult020E11.result_image
#print axioms FT1536.S05.ProducerRawResult020E11.result_image
#check FT1536.S05.ProducerRawResult020E11.refines
#print axioms FT1536.S05.ProducerRawResult020E11.refines
#check FT1536.S05.ProducerCoreExecution020E11.budget
#print axioms FT1536.S05.ProducerCoreExecution020E11.budget
#check FT1536.S05.ProducerCoreExecution020E11.execute
#print axioms FT1536.S05.ProducerCoreExecution020E11.execute
#check FT1536.S05.ProducerCoreExecution020E11.execute_refines
#print axioms FT1536.S05.ProducerCoreExecution020E11.execute_refines
#check FT1536.S05.ProducerCoreExecution020E11.halts
#print axioms FT1536.S05.ProducerCoreExecution020E11.halts
#check FT1536.S05.ProducerCoreExecution020E11.zero_fuel
#print axioms FT1536.S05.ProducerCoreExecution020E11.zero_fuel
#check FT1536.S05.ProducerCoreExecution020E11.stopped_done
#print axioms FT1536.S05.ProducerCoreExecution020E11.stopped_done
#check FT1536.S05.ProducerCoreExecution020E11.stopped_bad
#print axioms FT1536.S05.ProducerCoreExecution020E11.stopped_bad
