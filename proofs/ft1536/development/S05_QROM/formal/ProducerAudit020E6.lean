import ProducerMachine020E6
import ProducerExpr020E6
import ProducerPrimitive020E6
import ProducerFrame020E6
import ProducerCompiler020E6
import ProducerCodec020E6
import ProducerScalar020E6
import ProducerWordLaws020E6
import ProducerCoreView020E6
import ProducerEmit020E6
import ProducerBatch020E6
import ProducerStore020E6
import ProducerExecution020E6
import CoreReadGeneric020E6
import ProducerCoreRead020E6
import ProducerFetch020E6
import ProducerProgram020E6
import ProducerCoreSource020E6
import ProducerBankRead020E6
import ProducerParserRead020E6
import ProducerWindow020E6
import ProducerCoreCircuit020E6
import ProducerCoreSlots020E6
import ProducerComposition020E6
import ProducerPipeline020E6
import ProducerBoolLaws020E6
import ProducerFetchStore020E6
import ProducerMetaSource020E6
import ProducerClamp020E6
import ProducerFetchTrace020E6
import ProducerPhaseFacts020E6
import ProducerMemory020E6
import ProducerInitial020E6
import ProducerCheckPhase020E6
import ProducerSnapshot020E6
import ProducerNumbers020E6
import ProducerStored020E6

-- Author dependency audit; not an independent review.
#print axioms FT1536.S05.ProducerMachine020E6.Register
#print axioms FT1536.S05.ProducerMachine020E6.OutputCell
#print axioms FT1536.S05.ProducerMachine020E6.Sources
#print axioms FT1536.S05.ProducerMachine020E6.next
#print axioms FT1536.S05.ProducerMachine020E6.execute
#print axioms FT1536.S05.ProducerMachine020E6.step
#print axioms FT1536.S05.ProducerMachine020E6.run
#print axioms FT1536.S05.ProducerMachine020E6.initial
#print axioms FT1536.S05.ProducerExpr020E6.readWord
#print axioms FT1536.S05.ProducerExpr020E6.eval
#print axioms FT1536.S05.ProducerExpr020E6.need
#print axioms FT1536.S05.ProducerExpr020E6.positive
#print axioms FT1536.S05.ProducerExpr020E6.compile
#print axioms FT1536.S05.ProducerExpr020E6.executeList
#print axioms FT1536.S05.ProducerExpr020E6.append
#print axioms FT1536.S05.ProducerPrimitive020E6.destination
#print axioms FT1536.S05.ProducerPrimitive020E6.write_below
#print axioms FT1536.S05.ProducerPrimitive020E6.literal_value
#print axioms FT1536.S05.ProducerPrimitive020E6.load_value
#print axioms FT1536.S05.ProducerPrimitive020E6.binary_value
#print axioms FT1536.S05.ProducerPrimitive020E6.select_value
#print axioms FT1536.S05.ProducerPrimitive020E6.below
#print axioms FT1536.S05.ProducerFrame020E6.Above
#print axioms FT1536.S05.ProducerFrame020E6.append_above
#print axioms FT1536.S05.ProducerFrame020E6.weaken
#print axioms FT1536.S05.ProducerFrame020E6.compiled
#print axioms FT1536.S05.ProducerFrame020E6.execute_below
#print axioms FT1536.S05.ProducerFrame020E6.compiled_below
#print axioms FT1536.S05.ProducerCompiler020E6.correct
#print axioms FT1536.S05.ProducerCodec020E6.Shape
#print axioms FT1536.S05.ProducerCodec020E6.shape
#print axioms FT1536.S05.ProducerCodec020E6.unshape
#print axioms FT1536.S05.ProducerCodec020E6.shape_injective
#print axioms FT1536.S05.ProducerCodec020E6.opTag
#print axioms FT1536.S05.ProducerCodec020E6.op_injective
#print axioms FT1536.S05.ProducerCodec020E6.opCodec
#print axioms FT1536.S05.ProducerCodec020E6.rc
#print axioms FT1536.S05.ProducerCodec020E6.oc
#print axioms FT1536.S05.ProducerCodec020E6.instruction
#print axioms FT1536.S05.ProducerCodec020E6.stateShape
#print axioms FT1536.S05.ProducerCodec020E6.state_shape_injective
#print axioms FT1536.S05.ProducerCodec020E6.state
#print axioms FT1536.S05.ProducerCodec020E6.image
#print axioms FT1536.S05.ProducerCodec020E6.initial_zero
#print axioms FT1536.S05.ProducerScalar020E6.E
#print axioms FT1536.S05.ProducerScalar020E6.lit
#print axioms FT1536.S05.ProducerScalar020E6.add
#print axioms FT1536.S05.ProducerScalar020E6.sub
#print axioms FT1536.S05.ProducerScalar020E6.mul
#print axioms FT1536.S05.ProducerScalar020E6.eq
#print axioms FT1536.S05.ProducerScalar020E6.lt
#print axioms FT1536.S05.ProducerScalar020E6.choose
#print axioms FT1536.S05.ProducerScalar020E6.not
#print axioms FT1536.S05.ProducerScalar020E6.and
#print axioms FT1536.S05.ProducerScalar020E6.or
#print axioms FT1536.S05.ProducerScalar020E6.natClamp
#print axioms FT1536.S05.ProducerScalar020E6.pred
#print axioms FT1536.S05.ProducerScalar020E6.validAddress
#print axioms FT1536.S05.ProducerScalar020E6.cell
#print axioms FT1536.S05.ProducerScalar020E6.none
#print axioms FT1536.S05.ProducerScalar020E6.some
#print axioms FT1536.S05.ProducerScalar020E6.guarded
#print axioms FT1536.S05.ProducerScalar020E6.optionChoose
#print axioms FT1536.S05.ProducerWordLaws020E6.word_zero
#print axioms FT1536.S05.ProducerWordLaws020E6.word_one
#print axioms FT1536.S05.ProducerWordLaws020E6.word_injective
#print axioms FT1536.S05.ProducerWordLaws020E6.add_nat
#print axioms FT1536.S05.ProducerWordLaws020E6.mul_nat
#print axioms FT1536.S05.ProducerWordLaws020E6.lt_nat
#print axioms FT1536.S05.ProducerWordLaws020E6.eq_nat
#print axioms FT1536.S05.ProducerWordLaws020E6.address_nat
#print axioms FT1536.S05.ProducerWordLaws020E6.load_nat
#print axioms FT1536.S05.ProducerWordLaws020E6.read_encoded_cell
#print axioms FT1536.S05.ProducerCoreView020E6.Core
#print axioms FT1536.S05.ProducerCoreView020E6.Parser
#print axioms FT1536.S05.ProducerCoreView020E6.extent
#print axioms FT1536.S05.ProducerCoreView020E6.sources
#print axioms FT1536.S05.ProducerCoreView020E6.regBase
#print axioms FT1536.S05.ProducerCoreView020E6.ramBase
#print axioms FT1536.S05.ProducerCoreView020E6.outBase
#print axioms FT1536.S05.ProducerCoreView020E6.frameBase
#print axioms FT1536.S05.ProducerCoreView020E6.valueBase
#print axioms FT1536.S05.ProducerCoreView020E6.controlBase
#print axioms FT1536.S05.ProducerCoreView020E6.core
#print axioms FT1536.S05.ProducerCoreView020E6.control
#print axioms FT1536.S05.ProducerCoreView020E6.arena
#print axioms FT1536.S05.ProducerCoreView020E6.phase
#print axioms FT1536.S05.ProducerCoreView020E6.cursor
#print axioms FT1536.S05.ProducerCoreView020E6.left
#print axioms FT1536.S05.ProducerCoreView020E6.sp
#print axioms FT1536.S05.ProducerCoreView020E6.fault
#print axioms FT1536.S05.ProducerCoreView020E6.used
#print axioms FT1536.S05.ProducerCoreView020E6.parserSP
#print axioms FT1536.S05.ProducerCoreView020E6.parserCursor
#print axioms FT1536.S05.ProducerCoreView020E6.parserBad
#print axioms FT1536.S05.ProducerCoreView020E6.valueAt
#print axioms FT1536.S05.ProducerCoreView020E6.nodeAt
#print axioms FT1536.S05.ProducerCoreView020E6.frameAt
#print axioms FT1536.S05.ProducerEmit020E6.NoOutput
#print axioms FT1536.S05.ProducerEmit020E6.primitive_output
#print axioms FT1536.S05.ProducerEmit020E6.list_output
#print axioms FT1536.S05.ProducerEmit020E6.compile_no_output
#print axioms FT1536.S05.ProducerEmit020E6.one
#print axioms FT1536.S05.ProducerEmit020E6.one_output
#print axioms FT1536.S05.ProducerEmit020E6.batch
#print axioms FT1536.S05.ProducerEmit020E6.fills
#print axioms FT1536.S05.ProducerEmit020E6.batch_output
#print axioms FT1536.S05.ProducerBatch020E6.cost
#print axioms FT1536.S05.ProducerBatch020E6.compile_length
#print axioms FT1536.S05.ProducerBatch020E6.one_length
#print axioms FT1536.S05.ProducerBatch020E6.size
#print axioms FT1536.S05.ProducerBatch020E6.length
#print axioms FT1536.S05.ProducerBatch020E6.fills_patch
#print axioms FT1536.S05.ProducerBatch020E6.fills_all
#print axioms FT1536.S05.ProducerBatch020E6.full_output
#print axioms FT1536.S05.ProducerStore020E6.controls
#print axioms FT1536.S05.ProducerStore020E6.rest
#print axioms FT1536.S05.ProducerStore020E6.reg
#print axioms FT1536.S05.ProducerStore020E6.output
#print axioms FT1536.S05.ProducerStore020E6.control
#print axioms FT1536.S05.ProducerStore020E6.primitive
#print axioms FT1536.S05.ProducerStore020E6.run_trace
#print axioms FT1536.S05.ProducerExecution020E6.execute_pc
#print axioms FT1536.S05.ProducerExecution020E6.meaning
#print axioms FT1536.S05.ProducerExecution020E6.step_meaning
#print axioms FT1536.S05.ProducerExecution020E6.run_meaning
#print axioms FT1536.S05.ProducerExecution020E6.done
#print axioms FT1536.S05.ProducerExecution020E6.terminal_meaning
#print axioms FT1536.S05.ProducerExecution020E6.executes
#print axioms FT1536.S05.CoreReadGeneric020E6.metaPtr
#print axioms FT1536.S05.CoreReadGeneric020E6.meta_read
#print axioms FT1536.S05.CoreReadGeneric020E6.valuePtr
#print axioms FT1536.S05.CoreReadGeneric020E6.value_read
#print axioms FT1536.S05.CoreReadGeneric020E6.framePtr
#print axioms FT1536.S05.CoreReadGeneric020E6.frame_read
#print axioms FT1536.S05.ProducerCoreRead020E6.hc
#print axioms FT1536.S05.ProducerCoreRead020E6.hf
#print axioms FT1536.S05.ProducerCoreRead020E6.hl
#print axioms FT1536.S05.ProducerCoreRead020E6.metaPtr
#print axioms FT1536.S05.ProducerCoreRead020E6.metaPtr_val
#print axioms FT1536.S05.ProducerCoreRead020E6.meta_read
#print axioms FT1536.S05.ProducerCoreRead020E6.valuePtr
#print axioms FT1536.S05.ProducerCoreRead020E6.valuePtr_val
#print axioms FT1536.S05.ProducerCoreRead020E6.value_read
#print axioms FT1536.S05.ProducerCoreRead020E6.framePtr
#print axioms FT1536.S05.ProducerCoreRead020E6.framePtr_val
#print axioms FT1536.S05.ProducerCoreRead020E6.frame_read
#print axioms FT1536.S05.ProducerFetch020E6.start
#print axioms FT1536.S05.ProducerFetch020E6.step
#print axioms FT1536.S05.ProducerFetch020E6.cycle
#print axioms FT1536.S05.ProducerFetch020E6.cycle_vm
#print axioms FT1536.S05.ProducerFetch020E6.cycle_phase
#print axioms FT1536.S05.ProducerFetch020E6.run
#print axioms FT1536.S05.ProducerFetch020E6.refines
#print axioms FT1536.S05.ProducerProgram020E6.listCode
#print axioms FT1536.S05.ProducerProgram020E6.code
#print axioms FT1536.S05.ProducerProgram020E6.code_read
#print axioms FT1536.S05.ProducerProgram020E6.initial_pc
#print axioms FT1536.S05.ProducerProgram020E6.run
#print axioms FT1536.S05.ProducerProgram020E6.output
#print axioms FT1536.S05.ProducerProgram020E6.done
#print axioms FT1536.S05.ProducerCoreSource020E6.control_eval
#print axioms FT1536.S05.ProducerCoreSource020E6.value_word
#print axioms FT1536.S05.ProducerCoreSource020E6.frame_word
#print axioms FT1536.S05.ProducerBankRead020E6.regPtr
#print axioms FT1536.S05.ProducerBankRead020E6.reg_read
#print axioms FT1536.S05.ProducerBankRead020E6.ramPtr
#print axioms FT1536.S05.ProducerBankRead020E6.ram_read
#print axioms FT1536.S05.ProducerBankRead020E6.outPtr
#print axioms FT1536.S05.ProducerBankRead020E6.out_read
#print axioms FT1536.S05.ProducerParserRead020E6.nodePtr
#print axioms FT1536.S05.ProducerParserRead020E6.node_read
#print axioms FT1536.S05.ProducerParserRead020E6.stackPtr
#print axioms FT1536.S05.ProducerParserRead020E6.stack_read
#print axioms FT1536.S05.ProducerParserRead020E6.usedPtr
#print axioms FT1536.S05.ProducerParserRead020E6.spPtr
#print axioms FT1536.S05.ProducerParserRead020E6.used_read
#print axioms FT1536.S05.ProducerParserRead020E6.sp_read
#print axioms FT1536.S05.ProducerWindow020E6.top
#print axioms FT1536.S05.ProducerWindow020E6.topTag
#print axioms FT1536.S05.ProducerWindow020E6.topPC
#print axioms FT1536.S05.ProducerWindow020E6.topCount
#print axioms FT1536.S05.ProducerWindow020E6.scanFirst
#print axioms FT1536.S05.ProducerWindow020E6.scanSecond
#print axioms FT1536.S05.ProducerWindow020E6.scanValue
#print axioms FT1536.S05.ProducerWindow020E6.actFirst
#print axioms FT1536.S05.ProducerWindow020E6.actSecond
#print axioms FT1536.S05.ProducerWindow020E6.actThird
#print axioms FT1536.S05.ProducerWindow020E6.topPresent
#print axioms FT1536.S05.ProducerWindow020E6.scanPresent
#print axioms FT1536.S05.ProducerWindow020E6.actPresent
#print axioms FT1536.S05.ProducerWindow020E6.scanGuarded
#print axioms FT1536.S05.ProducerWindow020E6.actGuarded
#print axioms FT1536.S05.ProducerWindow020E6.cells
#print axioms FT1536.S05.ProducerWindow020E6.workspace
#print axioms FT1536.S05.ProducerCoreCircuit020E6.C
#print axioms FT1536.S05.ProducerCoreCircuit020E6.w
#print axioms FT1536.S05.ProducerCoreCircuit020E6.isPhase
#print axioms FT1536.S05.ProducerCoreCircuit020E6.isToken
#print axioms FT1536.S05.ProducerCoreCircuit020E6.payloadNat
#print axioms FT1536.S05.ProducerCoreCircuit020E6.isAgain
#print axioms FT1536.S05.ProducerCoreCircuit020E6.remaining
#print axioms FT1536.S05.ProducerCoreCircuit020E6.binaryResult
#print axioms FT1536.S05.ProducerCoreCircuit020E6.scanPresent
#print axioms FT1536.S05.ProducerCoreCircuit020E6.scanValue
#print axioms FT1536.S05.ProducerCoreCircuit020E6.loopContinues
#print axioms FT1536.S05.ProducerCoreCircuit020E6.loopOK
#print axioms FT1536.S05.ProducerCoreCircuit020E6.ordinaryOK
#print axioms FT1536.S05.ProducerCoreCircuit020E6.actionOK
#print axioms FT1536.S05.ProducerCoreCircuit020E6.memFault
#print axioms FT1536.S05.ProducerCoreCircuit020E6.editTag
#print axioms FT1536.S05.ProducerCoreCircuit020E6.editAddress
#print axioms FT1536.S05.ProducerCoreCircuit020E6.editValue
#print axioms FT1536.S05.ProducerCoreCircuit020E6.actionPending
#print axioms FT1536.S05.ProducerCoreCircuit020E6.pushRoom
#print axioms FT1536.S05.ProducerCoreCircuit020E6.pendingPresent
#print axioms FT1536.S05.ProducerCoreCircuit020E6.pendingTwo
#print axioms FT1536.S05.ProducerCoreCircuit020E6.pushPending
#print axioms FT1536.S05.ProducerCoreCircuit020E6.nextPhase
#print axioms FT1536.S05.ProducerCoreCircuit020E6.nextCursor
#print axioms FT1536.S05.ProducerCoreCircuit020E6.nextMeta
#print axioms FT1536.S05.ProducerCoreSlots020E6.valueStep
#print axioms FT1536.S05.ProducerCoreSlots020E6.actStore
#print axioms FT1536.S05.ProducerCoreSlots020E6.pushStore
#print axioms FT1536.S05.ProducerCoreSlots020E6.dataPresent
#print axioms FT1536.S05.ProducerCoreSlots020E6.dataAddress
#print axioms FT1536.S05.ProducerCoreSlots020E6.dataValue
#print axioms FT1536.S05.ProducerCoreSlots020E6.cells
#print axioms FT1536.S05.ProducerCoreSlots020E6.workspace
#print axioms FT1536.S05.ProducerComposition020E6.oneSource
#print axioms FT1536.S05.ProducerComposition020E6.value
#print axioms FT1536.S05.ProducerComposition020E6.correct
#print axioms FT1536.S05.ProducerPipeline020E6.window
#print axioms FT1536.S05.ProducerPipeline020E6.windowSources
#print axioms FT1536.S05.ProducerPipeline020E6.words
#print axioms FT1536.S05.ProducerPipeline020E6.run
#print axioms FT1536.S05.ProducerPipeline020E6.run_words
#print axioms FT1536.S05.ProducerPipeline020E6.window_cell
#print axioms FT1536.S05.ProducerPipeline020E6.window_control
#print axioms FT1536.S05.ProducerBoolLaws020E6.bool_zero
#print axioms FT1536.S05.ProducerBoolLaws020E6.choose_word
#print axioms FT1536.S05.ProducerBoolLaws020E6.eq_word
#print axioms FT1536.S05.ProducerBoolLaws020E6.not_word
#print axioms FT1536.S05.ProducerBoolLaws020E6.and_word
#print axioms FT1536.S05.ProducerBoolLaws020E6.or_word
#print axioms FT1536.S05.ProducerFetchStore020E6.irCodec
#print axioms FT1536.S05.ProducerFetchStore020E6.tailCodec
#print axioms FT1536.S05.ProducerFetchStore020E6.shape
#print axioms FT1536.S05.ProducerFetchStore020E6.shape_injective
#print axioms FT1536.S05.ProducerFetchStore020E6.codec
#print axioms FT1536.S05.ProducerFetchStore020E6.image
#print axioms FT1536.S05.ProducerFetchStore020E6.controls
#print axioms FT1536.S05.ProducerFetchStore020E6.changeVM
#print axioms FT1536.S05.ProducerFetchStore020E6.program
#print axioms FT1536.S05.ProducerFetchStore020E6.fetched_word
#print axioms FT1536.S05.ProducerMetaSource020E6.env
#print axioms FT1536.S05.ProducerMetaSource020E6.phase
#print axioms FT1536.S05.ProducerMetaSource020E6.cursor
#print axioms FT1536.S05.ProducerMetaSource020E6.left
#print axioms FT1536.S05.ProducerMetaSource020E6.sp
#print axioms FT1536.S05.ProducerMetaSource020E6.fault
#print axioms FT1536.S05.ProducerClamp020E6.word_toInt
#print axioms FT1536.S05.ProducerClamp020E6.clamp
#print axioms FT1536.S05.ProducerFetchTrace020E6.step_trace
#print axioms FT1536.S05.ProducerFetchTrace020E6.cycle_trace
#print axioms FT1536.S05.ProducerFetchTrace020E6.run_trace
#print axioms FT1536.S05.ProducerFetchTrace020E6.run_peak
#print axioms FT1536.S05.ProducerPhaseFacts020E6.phase_eq
#print axioms FT1536.S05.ProducerPhaseFacts020E6.phase_check
#print axioms FT1536.S05.ProducerMemory020E6.sourceHeap
#print axioms FT1536.S05.ProducerMemory020E6.source_read
#print axioms FT1536.S05.ProducerMemory020E6.source_words
#print axioms FT1536.S05.ProducerMemory020E6.source_live
#print axioms FT1536.S05.ProducerMemory020E6.codeImage
#print axioms FT1536.S05.ProducerMemory020E6.context
#print axioms FT1536.S05.ProducerMemory020E6.context_live
#print axioms FT1536.S05.ProducerMemory020E6.complete_peak
#print axioms FT1536.S05.ProducerInitial020E6.zero_image
#print axioms FT1536.S05.ProducerInitial020E6.allocated_image
#print axioms FT1536.S05.ProducerCheckPhase020E6.eq_zero
#print axioms FT1536.S05.ProducerCheckPhase020E6.phase
#print axioms FT1536.S05.ProducerSnapshot020E6.top
#print axioms FT1536.S05.ProducerSnapshot020E6.pc
#print axioms FT1536.S05.ProducerSnapshot020E6.actNode
#print axioms FT1536.S05.ProducerSnapshot020E6.scanNode
#print axioms FT1536.S05.ProducerSnapshot020E6.child
#print axioms FT1536.S05.ProducerSnapshot020E6.actValue
#print axioms FT1536.S05.ProducerSnapshot020E6.scanValue
#print axioms FT1536.S05.ProducerSnapshot020E6.field
#print axioms FT1536.S05.ProducerSnapshot020E6.present
#print axioms FT1536.S05.ProducerSnapshot020E6.value
#print axioms FT1536.S05.ProducerSnapshot020E6.regValue
#print axioms FT1536.S05.ProducerSnapshot020E6.memoryValue
#print axioms FT1536.S05.ProducerSnapshot020E6.fields
#print axioms FT1536.S05.ProducerNumbers020E6.window_size
#print axioms FT1536.S05.ProducerNumbers020E6.slot_size
#print axioms FT1536.S05.ProducerNumbers020E6.window_fits
#print axioms FT1536.S05.ProducerNumbers020E6.slot_fits
#print axioms FT1536.S05.ProducerNumbers020E6.payload_bytes
#print axioms FT1536.S05.ProducerNumbers020E6.window_increment
#print axioms FT1536.S05.ProducerNumbers020E6.slot_increment
#print axioms FT1536.S05.ProducerStored020E6.invoke
#print axioms FT1536.S05.ProducerStored020E6.expression_output
#print axioms FT1536.S05.ProducerStored020E6.windowCode
#print axioms FT1536.S05.ProducerStored020E6.slotCode
#print axioms FT1536.S05.ProducerStored020E6.pairRun
#print axioms FT1536.S05.ProducerStored020E6.pair_output
#print axioms FT1536.S05.ProducerStored020E6.run
#print axioms FT1536.S05.ProducerStored020E6.run_words
