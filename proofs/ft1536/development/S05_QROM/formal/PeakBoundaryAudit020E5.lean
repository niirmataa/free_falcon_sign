import RegionRam020E5
import MemoryEdit020E5
import BankWordLayout020E5
import FixedAction020E5
import CoreState020E5
import CoreStep020E5
import CoreMeaning020E5
import CorePreservation020E5
import CoreRank020E5
import CoreRun020E5
import WordCodec020E5
import CoreEncoding020E5
import WordPatch020E5
import WordJoin020E5
import VerifiedPatch020E5
import PairPatch020E5
import CoreFieldPatch020E5
import CoreData020E5
import CoreControl020E5
import ControlStore020E5
import CoreDataPatch020E5
import CoreStore020E5
import RegionFrame020E5
import RegionTrace020E5
import CoreHeap020E5
import RegionSlot020E5
import ZeroAllocate020E5
import FillMachine020E5
import FillStore020E5
import ZeroCodec020E5
import ParserDecision020E5
import ParserEncoding020E5
import ParserMachine020E5
import BoundaryFill020E5
import ParserStore020E5
import ScriptBuffer020E5
import ScriptMachine020E5
import ScriptStore020E5
import FullCall020E5
import PublicData020E5
import IndexedParser020E5
import CoreStartup020E5
import StartupImage020E5
import WordTrace020E5
import ScratchRound020E5
import ResidentCall020E5
import ScratchConsumers020E5
import BoundaryPayload020E5
import BoundaryNumbers020E5

-- Author audit of all development exports; not independent review.
#print axioms FT1536.S05.RegionRam020E5.Heap
#print axioms FT1536.S05.RegionRam020E5.words
#print axioms FT1536.S05.RegionRam020E5.allocate
#print axioms FT1536.S05.RegionRam020E5.write
#print axioms FT1536.S05.RegionRam020E5.live
#print axioms FT1536.S05.RegionRam020E5.allocate_read
#print axioms FT1536.S05.RegionRam020E5.allocate_size
#print axioms FT1536.S05.RegionRam020E5.allocate_words
#print axioms FT1536.S05.RegionRam020E5.allocate_live
#print axioms FT1536.S05.RegionRam020E5.write_size
#print axioms FT1536.S05.RegionRam020E5.write_words
#print axioms FT1536.S05.RegionRam020E5.write_live
#print axioms FT1536.S05.RegionRam020E5.step_live
#print axioms FT1536.S05.RegionRam020E5.steps_live
#print axioms FT1536.S05.MemoryEdit020E5.apply
#print axioms FT1536.S05.MemoryEdit020E5.atom
#print axioms FT1536.S05.MemoryEdit020E5.atom_refines
#print axioms FT1536.S05.MemoryEdit020E5.words
#print axioms FT1536.S05.MemoryEdit020E5.unchanged_input
#print axioms FT1536.S05.BankWordLayout020E5.encode
#print axioms FT1536.S05.BankWordLayout020E5.at_cell
#print axioms FT1536.S05.BankWordLayout020E5.extent
#print axioms FT1536.S05.BankWordLayout020E5.injective
#print axioms FT1536.S05.BankWordLayout020E5.updated_at
#print axioms FT1536.S05.FixedAction020E5.pendingList
#print axioms FT1536.S05.FixedAction020E5.Result
#print axioms FT1536.S05.FixedAction020E5.observe
#print axioms FT1536.S05.FixedAction020E5.loopAction
#print axioms FT1536.S05.FixedAction020E5.dispatch
#print axioms FT1536.S05.FixedAction020E5.action
#print axioms FT1536.S05.FixedAction020E5.loop_refines
#print axioms FT1536.S05.FixedAction020E5.atom_observe
#print axioms FT1536.S05.FixedAction020E5.dispatch_refines
#print axioms FT1536.S05.FixedAction020E5.action_refines
#print axioms FT1536.S05.FixedAction020E5.pending_bound
#print axioms FT1536.S05.CoreState020E5.start
#print axioms FT1536.S05.CoreState020E5.terminal
#print axioms FT1536.S05.CoreState020E5.result
#print axioms FT1536.S05.CoreState020E5.Ready
#print axioms FT1536.S05.CoreState020E5.Cleared
#print axioms FT1536.S05.CoreState020E5.Inv
#print axioms FT1536.S05.CoreState020E5.start_inv
#print axioms FT1536.S05.CoreState020E5.cleared_all
#print axioms FT1536.S05.CoreStep020E5.step
#print axioms FT1536.S05.CoreStep020E5.terminal_fixed
#print axioms FT1536.S05.CoreStep020E5.clear_prefix
#print axioms FT1536.S05.CoreStep020E5.inv
#print axioms FT1536.S05.CoreMeaning020E5.finish
#print axioms FT1536.S05.CoreMeaning020E5.denote
#print axioms FT1536.S05.CoreMeaning020E5.finish_build
#print axioms FT1536.S05.CoreMeaning020E5.scan_step
#print axioms FT1536.S05.CoreMeaning020E5.terminal_meaning
#print axioms FT1536.S05.CorePreservation020E5.preserves
#print axioms FT1536.S05.CoreRank020E5.cycle
#print axioms FT1536.S05.CoreRank020E5.rank
#print axioms FT1536.S05.CoreRank020E5.positive
#print axioms FT1536.S05.CoreRank020E5.decreases
#print axioms FT1536.S05.CoreRun020E5.run
#print axioms FT1536.S05.CoreRun020E5.invariant
#print axioms FT1536.S05.CoreRun020E5.meaning
#print axioms FT1536.S05.CoreRun020E5.halts
#print axioms FT1536.S05.CoreRun020E5.execute
#print axioms FT1536.S05.CoreRun020E5.execute_refines
#print axioms FT1536.S05.WordCodec020E5.unit
#print axioms FT1536.S05.WordCodec020E5.wordCodec
#print axioms FT1536.S05.WordCodec020E5.boolWord
#print axioms FT1536.S05.WordCodec020E5.boolCodec
#print axioms FT1536.S05.WordCodec020E5.finCodec
#print axioms FT1536.S05.WordCodec020E5.pair
#print axioms FT1536.S05.WordCodec020E5.sumEncode
#print axioms FT1536.S05.WordCodec020E5.sum
#print axioms FT1536.S05.WordCodec020E5.contramap
#print axioms FT1536.S05.WordCodec020E5.bank
#print axioms FT1536.S05.CoreEncoding020E5.frameCodec
#print axioms FT1536.S05.CoreEncoding020E5.pendingShape
#print axioms FT1536.S05.CoreEncoding020E5.pendingOfShape
#print axioms FT1536.S05.CoreEncoding020E5.pending_shape_injective
#print axioms FT1536.S05.CoreEncoding020E5.pendingCodec
#print axioms FT1536.S05.CoreEncoding020E5.phaseTag
#print axioms FT1536.S05.CoreEncoding020E5.phase_tag_injective
#print axioms FT1536.S05.CoreEncoding020E5.phaseCodec
#print axioms FT1536.S05.CoreEncoding020E5.Meta
#print axioms FT1536.S05.CoreEncoding020E5.metadata
#print axioms FT1536.S05.CoreEncoding020E5.metaCodec
#print axioms FT1536.S05.CoreEncoding020E5.Fields
#print axioms FT1536.S05.CoreEncoding020E5.fields
#print axioms FT1536.S05.CoreEncoding020E5.ofFields
#print axioms FT1536.S05.CoreEncoding020E5.fields_roundtrip
#print axioms FT1536.S05.CoreEncoding020E5.fields_injective
#print axioms FT1536.S05.CoreEncoding020E5.payloadWords
#print axioms FT1536.S05.CoreEncoding020E5.codec
#print axioms FT1536.S05.CoreEncoding020E5.encode
#print axioms FT1536.S05.CoreEncoding020E5.encode_injective
#print axioms FT1536.S05.CoreEncoding020E5.encode_size
#print axioms FT1536.S05.WordPatch020E5.Write
#print axioms FT1536.S05.WordPatch020E5.apply
#print axioms FT1536.S05.WordPatch020E5.extent
#print axioms FT1536.S05.WordPatch020E5.realizes
#print axioms FT1536.S05.WordPatch020E5.singleton
#print axioms FT1536.S05.WordPatch020E5.singleton_apply
#print axioms FT1536.S05.WordPatch020E5.has_trace
#print axioms FT1536.S05.WordPatch020E5.every_payload_size
#print axioms FT1536.S05.WordJoin020E5.join
#print axioms FT1536.S05.WordJoin020E5.left_read
#print axioms FT1536.S05.WordJoin020E5.right_read
#print axioms FT1536.S05.WordJoin020E5.left_write
#print axioms FT1536.S05.WordJoin020E5.right_write
#print axioms FT1536.S05.WordJoin020E5.liftLeft
#print axioms FT1536.S05.WordJoin020E5.liftRight
#print axioms FT1536.S05.WordJoin020E5.apply_left
#print axioms FT1536.S05.WordJoin020E5.apply_right
#print axioms FT1536.S05.VerifiedPatch020E5.pack
#print axioms FT1536.S05.VerifiedPatch020E5.pack_read
#print axioms FT1536.S05.VerifiedPatch020E5.append_apply
#print axioms FT1536.S05.VerifiedPatch020E5.identity
#print axioms FT1536.S05.VerifiedPatch020E5.ofEq
#print axioms FT1536.S05.VerifiedPatch020E5.thenDo
#print axioms FT1536.S05.VerifiedPatch020E5.overwrite
#print axioms FT1536.S05.VerifiedPatch020E5.overwrite_length
#print axioms FT1536.S05.VerifiedPatch020E5.left
#print axioms FT1536.S05.VerifiedPatch020E5.right
#print axioms FT1536.S05.VerifiedPatch020E5.pack_pair
#print axioms FT1536.S05.VerifiedPatch020E5.pack_bank
#print axioms FT1536.S05.VerifiedPatch020E5.cell
#print axioms FT1536.S05.VerifiedPatch020E5.cell_length
#print axioms FT1536.S05.PairPatch020E5.first
#print axioms FT1536.S05.PairPatch020E5.second
#print axioms FT1536.S05.PairPatch020E5.first_length
#print axioms FT1536.S05.PairPatch020E5.second_length
#print axioms FT1536.S05.PairPatch020E5.then_length
#print axioms FT1536.S05.CoreFieldPatch020E5.valueCodec
#print axioms FT1536.S05.CoreFieldPatch020E5.cv
#print axioms FT1536.S05.CoreFieldPatch020E5.cf
#print axioms FT1536.S05.CoreFieldPatch020E5.co
#print axioms FT1536.S05.CoreFieldPatch020E5.cr
#print axioms FT1536.S05.CoreFieldPatch020E5.cg
#print axioms FT1536.S05.CoreFieldPatch020E5.c0
#print axioms FT1536.S05.CoreFieldPatch020E5.c1
#print axioms FT1536.S05.CoreFieldPatch020E5.c2
#print axioms FT1536.S05.CoreFieldPatch020E5.c3
#print axioms FT1536.S05.CoreFieldPatch020E5.image
#print axioms FT1536.S05.CoreFieldPatch020E5.setValues
#print axioms FT1536.S05.CoreFieldPatch020E5.setFrames
#print axioms FT1536.S05.CoreFieldPatch020E5.setReg
#print axioms FT1536.S05.CoreFieldPatch020E5.setRam
#print axioms FT1536.S05.CoreFieldPatch020E5.setOut
#print axioms FT1536.S05.CoreFieldPatch020E5.setMetadata
#print axioms FT1536.S05.CoreFieldPatch020E5.values
#print axioms FT1536.S05.CoreFieldPatch020E5.frames
#print axioms FT1536.S05.CoreFieldPatch020E5.reg
#print axioms FT1536.S05.CoreFieldPatch020E5.ram
#print axioms FT1536.S05.CoreFieldPatch020E5.out
#print axioms FT1536.S05.CoreFieldPatch020E5.control
#print axioms FT1536.S05.CoreFieldPatch020E5.values_length
#print axioms FT1536.S05.CoreFieldPatch020E5.frames_length
#print axioms FT1536.S05.CoreFieldPatch020E5.reg_length
#print axioms FT1536.S05.CoreFieldPatch020E5.ram_length
#print axioms FT1536.S05.CoreFieldPatch020E5.out_length
#print axioms FT1536.S05.CoreFieldPatch020E5.control_length
#print axioms FT1536.S05.CoreData020E5.edit
#print axioms FT1536.S05.CoreData020E5.pushData
#print axioms FT1536.S05.CoreData020E5.next
#print axioms FT1536.S05.CoreControl020E5.faultAfter
#print axioms FT1536.S05.CoreControl020E5.pushMeta
#print axioms FT1536.S05.CoreControl020E5.next
#print axioms FT1536.S05.CoreControl020E5.reconstruct
#print axioms FT1536.S05.ControlStore020E5.code
#print axioms FT1536.S05.ControlStore020E5.control_code
#print axioms FT1536.S05.ControlStore020E5.length
#print axioms FT1536.S05.CoreDataPatch020E5.BoundedProgram
#print axioms FT1536.S05.CoreDataPatch020E5.edit
#print axioms FT1536.S05.CoreDataPatch020E5.push
#print axioms FT1536.S05.CoreDataPatch020E5.program
#print axioms FT1536.S05.CoreStore020E5.code
#print axioms FT1536.S05.CoreStore020E5.realizes
#print axioms FT1536.S05.CoreStore020E5.length_bound
#print axioms FT1536.S05.CoreStore020E5.program
#print axioms FT1536.S05.RegionFrame020E5.heap
#print axioms FT1536.S05.RegionFrame020E5.slot
#print axioms FT1536.S05.RegionFrame020E5.first_size
#print axioms FT1536.S05.RegionFrame020E5.index
#print axioms FT1536.S05.RegionFrame020E5.word_store
#print axioms FT1536.S05.RegionFrame020E5.word_step
#print axioms FT1536.S05.RegionFrame020E5.word_trace
#print axioms FT1536.S05.RegionFrame020E5.words_exact
#print axioms FT1536.S05.RegionFrame020E5.live_exact
#print axioms FT1536.S05.RegionFrame020E5.complete_store_peak
#print axioms FT1536.S05.RegionTrace020E5.append
#print axioms FT1536.S05.RegionTrace020E5.peak
#print axioms FT1536.S05.CoreHeap020E5.step_trace
#print axioms FT1536.S05.CoreHeap020E5.run_trace
#print axioms FT1536.S05.CoreHeap020E5.run_peak
#print axioms FT1536.S05.RegionSlot020E5.frame
#print axioms FT1536.S05.RegionSlot020E5.size
#print axioms FT1536.S05.RegionSlot020E5.site
#print axioms FT1536.S05.RegionSlot020E5.selected
#print axioms FT1536.S05.RegionSlot020E5.cellIndex
#print axioms FT1536.S05.RegionSlot020E5.frame_identity
#print axioms FT1536.S05.RegionSlot020E5.word_store
#print axioms FT1536.S05.RegionSlot020E5.word_step
#print axioms FT1536.S05.RegionSlot020E5.trace
#print axioms FT1536.S05.RegionSlot020E5.run_existing
#print axioms FT1536.S05.ZeroAllocate020E5.allocate
#print axioms FT1536.S05.ZeroAllocate020E5.size
#print axioms FT1536.S05.ZeroAllocate020E5.words
#print axioms FT1536.S05.ZeroAllocate020E5.initialized
#print axioms FT1536.S05.ZeroAllocate020E5.run
#print axioms FT1536.S05.ZeroAllocate020E5.size_run
#print axioms FT1536.S05.ZeroAllocate020E5.words_run
#print axioms FT1536.S05.ZeroAllocate020E5.trace
#print axioms FT1536.S05.ZeroAllocate020E5.monotone
#print axioms FT1536.S05.ZeroAllocate020E5.startup_peak
#print axioms FT1536.S05.FillMachine020E5.step
#print axioms FT1536.S05.FillMachine020E5.run
#print axioms FT1536.S05.FillMachine020E5.Good
#print axioms FT1536.S05.FillMachine020E5.step_good
#print axioms FT1536.S05.FillMachine020E5.run_good
#print axioms FT1536.S05.FillMachine020E5.cursor_step
#print axioms FT1536.S05.FillMachine020E5.complete
#print axioms FT1536.S05.FillMachine020E5.start
#print axioms FT1536.S05.FillMachine020E5.fills
#print axioms FT1536.S05.FillStore020E5.shape
#print axioms FT1536.S05.FillStore020E5.shape_injective
#print axioms FT1536.S05.FillStore020E5.codec
#print axioms FT1536.S05.FillStore020E5.image
#print axioms FT1536.S05.FillStore020E5.code
#print axioms FT1536.S05.FillStore020E5.realizes
#print axioms FT1536.S05.FillStore020E5.length_bound
#print axioms FT1536.S05.FillStore020E5.fill_trace
#print axioms FT1536.S05.ZeroCodec020E5.bank_zero
#print axioms FT1536.S05.ZeroCodec020E5.join_zero
#print axioms FT1536.S05.ZeroCodec020E5.fill_start
#print axioms FT1536.S05.ParserDecision020E5.apply
#print axioms FT1536.S05.ParserDecision020E5.token
#print axioms FT1536.S05.ParserDecision020E5.cell
#print axioms FT1536.S05.ParserDecision020E5.token_refines
#print axioms FT1536.S05.ParserDecision020E5.cell_refines
#print axioms FT1536.S05.ParserEncoding020E5.nodeCodec
#print axioms FT1536.S05.ParserEncoding020E5.Fields
#print axioms FT1536.S05.ParserEncoding020E5.fields
#print axioms FT1536.S05.ParserEncoding020E5.ofFields
#print axioms FT1536.S05.ParserEncoding020E5.fields_injective
#print axioms FT1536.S05.ParserEncoding020E5.tailCodec
#print axioms FT1536.S05.ParserEncoding020E5.codec
#print axioms FT1536.S05.ParserEncoding020E5.image
#print axioms FT1536.S05.ParserEncoding020E5.nodes
#print axioms FT1536.S05.ParserEncoding020E5.stack
#print axioms FT1536.S05.ParserEncoding020E5.pointers
#print axioms FT1536.S05.ParserEncoding020E5.commit
#print axioms FT1536.S05.ParserEncoding020E5.commit_length
#print axioms FT1536.S05.ParserMachine020E5.start
#print axioms FT1536.S05.ParserMachine020E5.decision
#print axioms FT1536.S05.ParserMachine020E5.cursorNext
#print axioms FT1536.S05.ParserMachine020E5.step
#print axioms FT1536.S05.ParserMachine020E5.result
#print axioms FT1536.S05.ParserMachine020E5.run
#print axioms FT1536.S05.ParserMachine020E5.step_result
#print axioms FT1536.S05.ParserMachine020E5.run_result
#print axioms FT1536.S05.ParserMachine020E5.start_result
#print axioms FT1536.S05.ParserMachine020E5.step_cursor
#print axioms FT1536.S05.ParserMachine020E5.run_cursor
#print axioms FT1536.S05.BoundaryFill020E5.fill
#print axioms FT1536.S05.BoundaryFill020E5.fill_eq
#print axioms FT1536.S05.BoundaryFill020E5.fill_read
#print axioms FT1536.S05.BoundaryFill020E5.tape
#print axioms FT1536.S05.BoundaryFill020E5.rom
#print axioms FT1536.S05.BoundaryFill020E5.inputs
#print axioms FT1536.S05.BoundaryFill020E5.output
#print axioms FT1536.S05.BoundaryFill020E5.tape_eq
#print axioms FT1536.S05.BoundaryFill020E5.rom_eq
#print axioms FT1536.S05.BoundaryFill020E5.inputs_eq
#print axioms FT1536.S05.BoundaryFill020E5.output_eq
#print axioms FT1536.S05.ParserStore020E5.Width
#print axioms FT1536.S05.ParserStore020E5.shape
#print axioms FT1536.S05.ParserStore020E5.shape_injective
#print axioms FT1536.S05.ParserStore020E5.controls
#print axioms FT1536.S05.ParserStore020E5.codec
#print axioms FT1536.S05.ParserStore020E5.image
#print axioms FT1536.S05.ParserStore020E5.control
#print axioms FT1536.S05.ParserStore020E5.commit
#print axioms FT1536.S05.ParserStore020E5.program
#print axioms FT1536.S05.ParserStore020E5.control_length
#print axioms FT1536.S05.ParserStore020E5.commit_length
#print axioms FT1536.S05.ParserStore020E5.length_bound
#print axioms FT1536.S05.ParserStore020E5.run_trace
#print axioms FT1536.S05.ScriptBuffer020E5.Buffer
#print axioms FT1536.S05.ScriptBuffer020E5.buffer
#print axioms FT1536.S05.ScriptBuffer020E5.action
#print axioms FT1536.S05.ScriptBuffer020E5.scan
#print axioms FT1536.S05.ScriptBuffer020E5.execute
#print axioms FT1536.S05.ScriptBuffer020E5.scan_append
#print axioms FT1536.S05.ScriptBuffer020E5.scan_none
#print axioms FT1536.S05.ScriptBuffer020E5.scan_some
#print axioms FT1536.S05.ScriptBuffer020E5.buffer_read
#print axioms FT1536.S05.ScriptBuffer020E5.executes
#print axioms FT1536.S05.ScriptBuffer020E5.populate
#print axioms FT1536.S05.ScriptBuffer020E5.populate_eq
#print axioms FT1536.S05.ScriptMachine020E5.step
#print axioms FT1536.S05.ScriptMachine020E5.run
#print axioms FT1536.S05.ScriptMachine020E5.meaning
#print axioms FT1536.S05.ScriptMachine020E5.step_meaning
#print axioms FT1536.S05.ScriptMachine020E5.run_meaning
#print axioms FT1536.S05.ScriptMachine020E5.step_cursor
#print axioms FT1536.S05.ScriptMachine020E5.done
#print axioms FT1536.S05.ScriptMachine020E5.terminal_meaning
#print axioms FT1536.S05.ScriptMachine020E5.start
#print axioms FT1536.S05.ScriptMachine020E5.executes
#print axioms FT1536.S05.ScriptMachine020E5.script_executes
#print axioms FT1536.S05.ScriptStore020E5.optionShape
#print axioms FT1536.S05.ScriptStore020E5.option_injective
#print axioms FT1536.S05.ScriptStore020E5.writeCodec
#print axioms FT1536.S05.ScriptStore020E5.controls
#print axioms FT1536.S05.ScriptStore020E5.shape
#print axioms FT1536.S05.ScriptStore020E5.shape_injective
#print axioms FT1536.S05.ScriptStore020E5.codec
#print axioms FT1536.S05.ScriptStore020E5.image
#print axioms FT1536.S05.ScriptStore020E5.put
#print axioms FT1536.S05.ScriptStore020E5.cursor
#print axioms FT1536.S05.ScriptStore020E5.program
#print axioms FT1536.S05.ScriptStore020E5.put_length
#print axioms FT1536.S05.ScriptStore020E5.cursor_length
#print axioms FT1536.S05.ScriptStore020E5.length_bound
#print axioms FT1536.S05.ScriptStore020E5.run_trace
#print axioms FT1536.S05.FullCall020E5.fromArena
#print axioms FT1536.S05.FullCall020E5.fromArena_eq
#print axioms FT1536.S05.FullCall020E5.parsed
#print axioms FT1536.S05.FullCall020E5.parsed_eq
#print axioms FT1536.S05.FullCall020E5.actual
#print axioms FT1536.S05.FullCall020E5.actual_eq
#print axioms FT1536.S05.FullCall020E5.observe
#print axioms FT1536.S05.FullCall020E5.observe_eq
#print axioms FT1536.S05.FullCall020E5.run
#print axioms FT1536.S05.FullCall020E5.run_eq
#print axioms FT1536.S05.FullCall020E5.every_tape
#print axioms FT1536.S05.PublicData020E5.fieldCodec
#print axioms FT1536.S05.PublicData020E5.cellCodec
#print axioms FT1536.S05.PublicData020E5.codeBank
#print axioms FT1536.S05.PublicData020E5.prepared
#print axioms FT1536.S05.PublicData020E5.shape
#print axioms FT1536.S05.PublicData020E5.shape_injective
#print axioms FT1536.S05.PublicData020E5.codec
#print axioms FT1536.S05.PublicData020E5.image
#print axioms FT1536.S05.PublicData020E5.image_injective
#print axioms FT1536.S05.PublicData020E5.romCell
#print axioms FT1536.S05.PublicData020E5.romCell_eq
#print axioms FT1536.S05.PublicData020E5.code_eq
#print axioms FT1536.S05.PublicData020E5.image_size
#print axioms FT1536.S05.PublicData020E5.filledROM
#print axioms FT1536.S05.PublicData020E5.filledROM_eq
#print axioms FT1536.S05.IndexedParser020E5.step
#print axioms FT1536.S05.IndexedParser020E5.run
#print axioms FT1536.S05.IndexedParser020E5.meaning
#print axioms FT1536.S05.IndexedParser020E5.step_meaning
#print axioms FT1536.S05.IndexedParser020E5.run_meaning
#print axioms FT1536.S05.IndexedParser020E5.step_cursor
#print axioms FT1536.S05.IndexedParser020E5.done
#print axioms FT1536.S05.IndexedParser020E5.terminal_meaning
#print axioms FT1536.S05.IndexedParser020E5.executes
#print axioms FT1536.S05.IndexedParser020E5.run_trace
#print axioms FT1536.S05.CoreStartup020E5.blank
#print axioms FT1536.S05.CoreStartup020E5.ready
#print axioms FT1536.S05.CoreStartup020E5.program
#print axioms FT1536.S05.CoreStartup020E5.length
#print axioms FT1536.S05.CoreStartup020E5.ready_start
#print axioms FT1536.S05.CoreStartup020E5.push_ready
#print axioms FT1536.S05.StartupImage020E5.pack_zero
#print axioms FT1536.S05.StartupImage020E5.empty_node_zero
#print axioms FT1536.S05.StartupImage020E5.empty_frame_zero
#print axioms FT1536.S05.StartupImage020E5.meta_zero
#print axioms FT1536.S05.StartupImage020E5.core_zero
#print axioms FT1536.S05.StartupImage020E5.parser_zero
#print axioms FT1536.S05.StartupImage020E5.zero_cells
#print axioms FT1536.S05.WordTrace020E5.append
#print axioms FT1536.S05.WordTrace020E5.right
#print axioms FT1536.S05.WordTrace020E5.left
#print axioms FT1536.S05.WordTrace020E5.fill
#print axioms FT1536.S05.ScratchRound020E5.reset
#print axioms FT1536.S05.ScratchRound020E5.loadState
#print axioms FT1536.S05.ScratchRound020E5.round
#print axioms FT1536.S05.ScratchRound020E5.loadState_eq
#print axioms FT1536.S05.ScratchRound020E5.round_target
#print axioms FT1536.S05.ScratchRound020E5.script_trace
#print axioms FT1536.S05.ScratchRound020E5.reset_trace
#print axioms FT1536.S05.ScratchRound020E5.image_split
#print axioms FT1536.S05.ScratchRound020E5.load_trace
#print axioms FT1536.S05.ScratchRound020E5.round_trace
#print axioms FT1536.S05.ScratchRound020E5.round_heap
#print axioms FT1536.S05.ResidentCall020E5.inputs
#print axioms FT1536.S05.ResidentCall020E5.parsed
#print axioms FT1536.S05.ResidentCall020E5.run
#print axioms FT1536.S05.ResidentCall020E5.inputs_eq
#print axioms FT1536.S05.ResidentCall020E5.parsed_eq
#print axioms FT1536.S05.ResidentCall020E5.run_eq
#print axioms FT1536.S05.ResidentCall020E5.every_tape
#print axioms FT1536.S05.ResidentCall020E5.code
#print axioms FT1536.S05.ResidentCall020E5.code_eq
#print axioms FT1536.S05.ResidentCall020E5.law
#print axioms FT1536.S05.ResidentCall020E5.law_eq
#print axioms FT1536.S05.ResidentCall020E5.all_h_ac
#print axioms FT1536.S05.ResidentCall020E5.certificate
#print axioms FT1536.S05.ResidentCall020E5.same_key_law
#print axioms FT1536.S05.ScratchConsumers020E5.checked
#print axioms FT1536.S05.ScratchConsumers020E5.core
#print axioms FT1536.S05.ScratchConsumers020E5.parser
#print axioms FT1536.S05.ScratchConsumers020E5.fill
#print axioms FT1536.S05.ScratchConsumers020E5.startup
#print axioms FT1536.S05.BoundaryPayload020E5.region
#print axioms FT1536.S05.BoundaryPayload020E5.heap
#print axioms FT1536.S05.BoundaryPayload020E5.payloadWords
#print axioms FT1536.S05.BoundaryPayload020E5.heap_size
#print axioms FT1536.S05.BoundaryPayload020E5.payload
#print axioms FT1536.S05.BoundaryPayload020E5.resident_live
#print axioms FT1536.S05.BoundaryPayload020E5.scratch
#print axioms FT1536.S05.BoundaryPayload020E5.withScratch
#print axioms FT1536.S05.BoundaryPayload020E5.withScratch_live
#print axioms FT1536.S05.BoundaryNumbers020E5.payload
#print axioms FT1536.S05.BoundaryNumbers020E5.represented_resident
#print axioms FT1536.S05.BoundaryNumbers020E5.padded_bytes
