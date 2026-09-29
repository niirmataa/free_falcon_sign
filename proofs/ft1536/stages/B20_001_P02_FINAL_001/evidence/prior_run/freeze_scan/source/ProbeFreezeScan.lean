import B20.C.ByteMemory
import B20.C.ByteParser
import B20.C.Integer
import B20.C.Parser
import B20.C.Scalar
import B20.C.ScalarCalls
import B20.C.ScalarParser
import B20.C.SignedArith
import B20.C.Syntax
import B20.Foundation.CExec
import B20.Foundation.Core
import B20.Fpr.Domain
import B20.Fpr.FloorExec
import B20.Fpr.ParsedPrograms
import B20.Fpr.RintExec
import B20.Fpr.SourceBinding
import B20.Fpr.Spec
import B20.Pinned.Header
import B20.Pinned.LittleEndian
import B20.Pinned.ScalarSlices
import B20.Pinned.Shake
import B20.Pinned.Slices
import B20.Word.FoundationConverse
import B20.Word.LEExecution
import B20.Word.LEPrograms
import B20.Word.LERefinement
import B20.Word.LESpec
import B20.Word.Memory
import B20.Word.Negative
import B20.Word.Radix
import B20.Word.Shift
import B20.Word.SourceShift

#check @B20.C.Byte.CExec
#check @B20.C.Byte.Pointer.add
#check @B20.C.Byte.ReadRegion
#check @B20.C.Byte.RegionBytes
#check @B20.C.Byte.Value.toWord
#check @B20.C.Byte.WriteRegion
#check @B20.C.Byte.access_inBounds
#check @B20.C.Byte.bindArgs
#check @B20.C.Byte.body
#check @B20.C.Byte.decimal
#check @B20.C.Byte.evalBody
#check @B20.C.Byte.evalExpr
#check @B20.C.Byte.execute
#check @B20.C.Byte.expression
#check @B20.C.Byte.inBounds
#check @B20.C.Byte.orTail
#check @B20.C.Byte.param
#check @B20.C.Byte.params
#check @B20.C.Byte.parenthesized
#check @B20.C.Byte.parseFunction
#check @B20.C.Byte.parseFunctionTokens
#check @B20.C.Byte.parseStatement
#check @B20.C.Byte.putByte
#check @B20.C.Byte.put_frame
#check @B20.C.Byte.put_preserves_read
#check @B20.C.Byte.put_preserves_write
#check @B20.C.Byte.readByte
#check @B20.C.Byte.read_region_byte
#check @B20.C.Byte.shiftTail
#check @B20.C.Byte.shifts
#check @B20.C.Byte.step
#check @B20.C.Byte.unary
#check @B20.C.Byte.updatePointer
#check @B20.C.Byte.writeByte
#check @B20.C.Byte.write_region_byte
#check @B20.C.CExec
#check @B20.C.CExec_deterministic
#check @B20.C.Scalar.CExec
#check @B20.C.Scalar.CExec_deterministic
#check @B20.C.Scalar.assign
#check @B20.C.Scalar.bindArgs
#check @B20.C.Scalar.body
#check @B20.C.Scalar.declareMany
#check @B20.C.Scalar.declareOne
#check @B20.C.Scalar.digitValue
#check @B20.C.Scalar.emptyState
#check @B20.C.Scalar.evalBody
#check @B20.C.Scalar.evalExpr
#check @B20.C.Scalar.execute
#check @B20.C.Scalar.expression
#check @B20.C.Scalar.functionCore
#check @B20.C.Scalar.hexDigit
#check @B20.C.Scalar.irsh_call
#check @B20.C.Scalar.literalType
#check @B20.C.Scalar.names
#check @B20.C.Scalar.number
#check @B20.C.Scalar.opInfo
#check @B20.C.Scalar.params
#check @B20.C.Scalar.parseArgs
#check @B20.C.Scalar.parseExpr
#check @B20.C.Scalar.parseFunction
#check @B20.C.Scalar.parseFunctionTokens
#check @B20.C.Scalar.parseMore
#check @B20.C.Scalar.parseUnary
#check @B20.C.Scalar.shiftCalls
#check @B20.C.Scalar.skipBlock
#check @B20.C.Scalar.statement
#check @B20.C.Scalar.step
#check @B20.C.Scalar.tokenize
#check @B20.C.Scalar.typeToken
#check @B20.C.Scalar.ulsh_call
#check @B20.C.Scalar.updateOp
#check @B20.C.Scalar.ursh_call
#check @B20.C.Val.integer
#check @B20.C.Val.ty
#check @B20.C.assign
#check @B20.C.bin
#check @B20.C.bindArgs
#check @B20.C.bitsOp
#check @B20.C.cast
#check @B20.C.cast_u32_to_u64
#check @B20.C.commonTy
#check @B20.C.cond_neg_add64
#check @B20.C.cond_neg_add64_le
#check @B20.C.digit
#check @B20.C.evalBody
#check @B20.C.evalExpr
#check @B20.C.execute
#check @B20.C.literalValue
#check @B20.C.neg
#check @B20.C.neg_defined_of_ne
#check @B20.C.neg_u32
#check @B20.C.neg_u64
#check @B20.C.notBits
#check @B20.C.opInfo
#check @B20.C.parenthesized
#check @B20.C.parseExpr
#check @B20.C.parseFunction
#check @B20.C.parseFunctionTokens
#check @B20.C.parseLevel
#check @B20.C.parseParams
#check @B20.C.parseStmts
#check @B20.C.parseTail
#check @B20.C.parseTy
#check @B20.C.parseUnary
#check @B20.C.safe_add32
#check @B20.C.safe_add64
#check @B20.C.safe_sub32
#check @B20.C.safe_sub64
#check @B20.C.shift
#check @B20.C.signedBitsOp
#check @B20.C.signedSafe
#check @B20.C.signed_add32
#check @B20.C.signed_add64
#check @B20.C.signed_overflow_rejected
#check @B20.C.tokenize
#check @B20.C.unsigned_add32
#check @B20.C.unsigned_add64
#check @B20.C.update
#check @B20.C.wordChar
#check @B20.C.xor_neg_bridge
#check @B20.Foundation.CExec_complete
#check @B20.Foundation.CExec_deterministic
#check @B20.Foundation.CExec_eval
#check @B20.Foundation.CExec_iff_eval
#check @B20.Foundation.Memory.byteAt
#check @B20.Foundation.Memory.legalU64
#check @B20.Foundation.Memory.readU64
#check @B20.Foundation.Memory.writeU64
#check @B20.Foundation.ModelStmt
#check @B20.Foundation.Outcome.abort_ne_fault
#check @B20.Foundation.Outcome.abort_ne_nonreturn
#check @B20.Foundation.Outcome.nonreturn_ne_fault
#check @B20.Foundation.Outcome.returned_ne_stuck
#check @B20.Foundation.Outcome.stuck_ne_abort
#check @B20.Foundation.Outcome.stuck_ne_fault
#check @B20.Foundation.Outcome.stuck_ne_nonreturn
#check @B20.Foundation.Region.contains
#check @B20.Foundation.Region.legal
#check @B20.Foundation.SpecExec
#check @B20.Foundation.State.loadLocal
#check @B20.Foundation.compile
#check @B20.Foundation.compile_refines
#check @B20.Foundation.defaultABI
#check @B20.Foundation.evalExpr
#check @B20.Foundation.evalStmt
#check @B20.Foundation.evalStmt_sound
#check @B20.Foundation.evalStmt_sound_gen
#check @B20.Foundation.initState
#check @B20.Foundation.u64Add
#check @B20.Foundation.u64Add_toNat
#check @B20.Foundation.u64And
#check @B20.Foundation.u64Neg
#check @B20.Foundation.u64ShiftRight
#check @B20.Foundation.u64Xor
#check @B20.Fpr.AddCallObligation
#check @B20.Fpr.DivObligation
#check @B20.Fpr.IrshDomain
#check @B20.Fpr.MulObligation
#check @B20.Fpr.Parsed.doubleProgram
#check @B20.Fpr.Parsed.double_lex
#check @B20.Fpr.Parsed.double_parses
#check @B20.Fpr.Parsed.double_slice
#check @B20.Fpr.Parsed.double_syntax
#check @B20.Fpr.Parsed.floorProgram
#check @B20.Fpr.Parsed.floor_lex
#check @B20.Fpr.Parsed.floor_parses
#check @B20.Fpr.Parsed.floor_slice
#check @B20.Fpr.Parsed.floor_syntax
#check @B20.Fpr.Parsed.halfProgram
#check @B20.Fpr.Parsed.half_lex
#check @B20.Fpr.Parsed.half_parses
#check @B20.Fpr.Parsed.half_slice
#check @B20.Fpr.Parsed.half_syntax
#check @B20.Fpr.Parsed.negProgram
#check @B20.Fpr.Parsed.neg_lex
#check @B20.Fpr.Parsed.neg_parses
#check @B20.Fpr.Parsed.neg_slice
#check @B20.Fpr.Parsed.neg_syntax
#check @B20.Fpr.Parsed.packProgram
#check @B20.Fpr.Parsed.pack_lex
#check @B20.Fpr.Parsed.pack_parses
#check @B20.Fpr.Parsed.pack_slice
#check @B20.Fpr.Parsed.pack_syntax
#check @B20.Fpr.Parsed.rintProgram
#check @B20.Fpr.Parsed.rint_lex
#check @B20.Fpr.Parsed.rint_parses
#check @B20.Fpr.Parsed.rint_slice
#check @B20.Fpr.Parsed.rint_syntax
#check @B20.Fpr.Parsed.slice
#check @B20.Fpr.Parsed.subProgram
#check @B20.Fpr.Parsed.sub_lex
#check @B20.Fpr.Parsed.sub_parses
#check @B20.Fpr.Parsed.sub_slice
#check @B20.Fpr.Parsed.sub_syntax
#check @B20.Fpr.ShiftCountDomain
#check @B20.Fpr.SqrtObligation
#check @B20.Fpr.UlshDomain
#check @B20.Fpr.UrshDomain
#check @B20.Fpr.cast_i32_1_u64
#check @B20.Fpr.cast_i32_63_u64
#check @B20.Fpr.doubleSpec
#check @B20.Fpr.double_execution
#check @B20.Fpr.e_toNat_of_range
#check @B20.Fpr.floorDomain
#check @B20.Fpr.floorSpec
#check @B20.Fpr.floor_execution
#check @B20.Fpr.floor_irsh_domain
#check @B20.Fpr.floor_mask
#check @B20.Fpr.floor_mask_all
#check @B20.Fpr.floor_mask_fold
#check @B20.Fpr.floor_mask_zero
#check @B20.Fpr.floor_sub63_safe
#check @B20.Fpr.floor_t
#check @B20.Fpr.floor_t_range
#check @B20.Fpr.floor_xi0
#check @B20.Fpr.floor_xi1
#check @B20.Fpr.halfSpec
#check @B20.Fpr.half_execution
#check @B20.Fpr.irsh_call_of_toNat
#check @B20.Fpr.lit1085_int
#check @B20.Fpr.lit_allOnes64
#check @B20.Fpr.m0_lt
#check @B20.Fpr.negSpec
#check @B20.Fpr.neg_execution
#check @B20.Fpr.packDomain
#check @B20.Fpr.packSpec
#check @B20.Fpr.pack_add_bits
#check @B20.Fpr.pack_add_safe
#check @B20.Fpr.pack_and7_lt
#check @B20.Fpr.pack_execution
#check @B20.Fpr.pack_f_range
#check @B20.Fpr.pack_neg_defined
#check @B20.Fpr.pack_t_range
#check @B20.Fpr.parsedCallSites
#check @B20.Fpr.rintDomain
#check @B20.Fpr.rintSpec
#check @B20.Fpr.rint_d
#check @B20.Fpr.rint_dd
#check @B20.Fpr.rint_e
#check @B20.Fpr.rint_e2
#check @B20.Fpr.rint_e2_range
#check @B20.Fpr.rint_e_int
#check @B20.Fpr.rint_e_nat
#check @B20.Fpr.rint_execution
#check @B20.Fpr.rint_f
#check @B20.Fpr.rint_f_range
#check @B20.Fpr.rint_m0
#check @B20.Fpr.rint_m1
#check @B20.Fpr.rint_m2
#check @B20.Fpr.rint_m2_big
#check @B20.Fpr.rint_m2_small
#check @B20.Fpr.rint_mask
#check @B20.Fpr.rint_mask_all
#check @B20.Fpr.rint_mask_zero
#check @B20.Fpr.rint_s
#check @B20.Fpr.rint_s_range
#check @B20.Fpr.rint_sub63_count
#check @B20.Fpr.rint_sub63_safe
#check @B20.Fpr.rint_ulsh_domain
#check @B20.Fpr.rint_ursh_domain
#check @B20.Fpr.rint_y
#check @B20.Fpr.rint_y_int
#check @B20.Fpr.rint_y_range
#check @B20.Fpr.signedBits_band32
#check @B20.Fpr.signedBits_band64
#check @B20.Fpr.signedBits_xor64
#check @B20.Fpr.sub_execution
#check @B20.Fpr.sub_refines_via_add_obligation
#check @B20.Fpr.ulsh_call_of_toNat
#check @B20.Fpr.ursh_call_of_toNat
#check @B20.Pinned.dec64leChars
#check @B20.Pinned.dec64leLines
#check @B20.Pinned.dec64leTokens
#check @B20.Pinned.doubleChars
#check @B20.Pinned.doubleLines
#check @B20.Pinned.doubleTokens
#check @B20.Pinned.enc64leChars
#check @B20.Pinned.enc64leLines
#check @B20.Pinned.enc64leTokens
#check @B20.Pinned.floorChars
#check @B20.Pinned.floorLines
#check @B20.Pinned.floorTokens
#check @B20.Pinned.halfChars
#check @B20.Pinned.halfLines
#check @B20.Pinned.halfTokens
#check @B20.Pinned.headerChunk0
#check @B20.Pinned.headerChunk1
#check @B20.Pinned.headerChunk10
#check @B20.Pinned.headerChunk11
#check @B20.Pinned.headerChunk12
#check @B20.Pinned.headerChunk13
#check @B20.Pinned.headerChunk14
#check @B20.Pinned.headerChunk15
#check @B20.Pinned.headerChunk16
#check @B20.Pinned.headerChunk17
#check @B20.Pinned.headerChunk18
#check @B20.Pinned.headerChunk19
#check @B20.Pinned.headerChunk2
#check @B20.Pinned.headerChunk20
#check @B20.Pinned.headerChunk21
#check @B20.Pinned.headerChunk22
#check @B20.Pinned.headerChunk23
#check @B20.Pinned.headerChunk24
#check @B20.Pinned.headerChunk25
#check @B20.Pinned.headerChunk26
#check @B20.Pinned.headerChunk27
#check @B20.Pinned.headerChunk28
#check @B20.Pinned.headerChunk29
#check @B20.Pinned.headerChunk3
#check @B20.Pinned.headerChunk30
#check @B20.Pinned.headerChunk31
#check @B20.Pinned.headerChunk32
#check @B20.Pinned.headerChunk33
#check @B20.Pinned.headerChunk34
#check @B20.Pinned.headerChunk35
#check @B20.Pinned.headerChunk36
#check @B20.Pinned.headerChunk37
#check @B20.Pinned.headerChunk38
#check @B20.Pinned.headerChunk39
#check @B20.Pinned.headerChunk4
#check @B20.Pinned.headerChunk40
#check @B20.Pinned.headerChunk41
#check @B20.Pinned.headerChunk42
#check @B20.Pinned.headerChunk43
#check @B20.Pinned.headerChunk44
#check @B20.Pinned.headerChunk45
#check @B20.Pinned.headerChunk46
#check @B20.Pinned.headerChunk47
#check @B20.Pinned.headerChunk48
#check @B20.Pinned.headerChunk49
#check @B20.Pinned.headerChunk5
#check @B20.Pinned.headerChunk50
#check @B20.Pinned.headerChunk51
#check @B20.Pinned.headerChunk52
#check @B20.Pinned.headerChunk53
#check @B20.Pinned.headerChunk54
#check @B20.Pinned.headerChunk55
#check @B20.Pinned.headerChunk56
#check @B20.Pinned.headerChunk57
#check @B20.Pinned.headerChunk58
#check @B20.Pinned.headerChunk59
#check @B20.Pinned.headerChunk6
#check @B20.Pinned.headerChunk60
#check @B20.Pinned.headerChunk61
#check @B20.Pinned.headerChunk62
#check @B20.Pinned.headerChunk63
#check @B20.Pinned.headerChunk64
#check @B20.Pinned.headerChunk65
#check @B20.Pinned.headerChunk66
#check @B20.Pinned.headerChunk67
#check @B20.Pinned.headerChunk68
#check @B20.Pinned.headerChunk69
#check @B20.Pinned.headerChunk7
#check @B20.Pinned.headerChunk70
#check @B20.Pinned.headerChunk8
#check @B20.Pinned.headerChunk9
#check @B20.Pinned.headerLines
#check @B20.Pinned.irshChars
#check @B20.Pinned.irshTokens
#check @B20.Pinned.negChars
#check @B20.Pinned.negLines
#check @B20.Pinned.negTokens
#check @B20.Pinned.packChars
#check @B20.Pinned.packLines
#check @B20.Pinned.packTokens
#check @B20.Pinned.rintChars
#check @B20.Pinned.rintLines
#check @B20.Pinned.rintTokens
#check @B20.Pinned.shakeChunk0
#check @B20.Pinned.shakeChunk1
#check @B20.Pinned.shakeChunk10
#check @B20.Pinned.shakeChunk11
#check @B20.Pinned.shakeChunk12
#check @B20.Pinned.shakeChunk13
#check @B20.Pinned.shakeChunk14
#check @B20.Pinned.shakeChunk15
#check @B20.Pinned.shakeChunk16
#check @B20.Pinned.shakeChunk17
#check @B20.Pinned.shakeChunk18
#check @B20.Pinned.shakeChunk19
#check @B20.Pinned.shakeChunk2
#check @B20.Pinned.shakeChunk3
#check @B20.Pinned.shakeChunk4
#check @B20.Pinned.shakeChunk5
#check @B20.Pinned.shakeChunk6
#check @B20.Pinned.shakeChunk7
#check @B20.Pinned.shakeChunk8
#check @B20.Pinned.shakeChunk9
#check @B20.Pinned.shakeLines
#check @B20.Pinned.subChars
#check @B20.Pinned.subLines
#check @B20.Pinned.subTokens
#check @B20.Pinned.ulshChars
#check @B20.Pinned.ulshTokens
#check @B20.Pinned.urshChars
#check @B20.Pinned.urshTokens
#check @B20.Word.LE.bufferBytes
#check @B20.Word.LE.bufferBytes_spec
#check @B20.Word.LE.byteOf
#check @B20.Word.LE.decProgram
#check @B20.Word.LE.decState
#check @B20.Word.LE.dec_execution
#check @B20.Word.LE.dec_lex
#check @B20.Word.LE.dec_parses
#check @B20.Word.LE.dec_prefix
#check @B20.Word.LE.dec_slice
#check @B20.Word.LE.dec_syntax
#check @B20.Word.LE.decodeExpr
#check @B20.Word.LE.decodeExpr_eval
#check @B20.Word.LE.encProgram
#check @B20.Word.LE.encState
#check @B20.Word.LE.enc_execution
#check @B20.Word.LE.enc_lex
#check @B20.Word.LE.enc_parses
#check @B20.Word.LE.enc_prefix
#check @B20.Word.LE.enc_slice
#check @B20.Word.LE.enc_syntax
#check @B20.Word.LE.indices
#check @B20.Word.LE.join
#check @B20.Word.LE.join_byteOf
#check @B20.Word.LE.loadTerm
#check @B20.Word.LE.loadTerm_eval
#check @B20.Word.LE.orWord
#check @B20.Word.LE.orWord_eq_join
#check @B20.Word.LE.or_left_comm
#check @B20.Word.LE.slice
#check @B20.Word.LE.storeBytes
#check @B20.Word.LE.storeBytes_frame
#check @B20.Word.LE.storeBytes_preserves_write
#check @B20.Word.LE.storeStatement
#check @B20.Word.LE.storeTerm
#check @B20.Word.LE.storeTerm_eval
#check @B20.Word.LE.store_step
#check @B20.Word.LE.stored
#check @B20.Word.LE.stored_bytes
#check @B20.Word.LE.stores_execution
#check @B20.Word.brokenShiftFunction
#check @B20.Word.byteAt_write
#check @B20.Word.byteExpansion
#check @B20.Word.byteExpansion_eq
#check @B20.Word.c_invalid_count_rejected
#check @B20.Word.c_signed_negation_overflow_rejected
#check @B20.Word.count_mask_mutation_witness
#check @B20.Word.foldl_eight
#check @B20.Word.foldl_equal_on
#check @B20.Word.irsh
#check @B20.Word.irshFunction
#check @B20.Word.irsh_execution
#check @B20.Word.irsh_refines
#check @B20.Word.load_le_refines
#check @B20.Word.load_store_le_refines
#check @B20.Word.model_load_store_roundtrip
#check @B20.Word.parser_unsupported_operator_rejected
#check @B20.Word.pinned_irsh_lex
#check @B20.Word.pinned_irsh_parses
#check @B20.Word.pinned_irsh_refines
#check @B20.Word.pinned_irsh_slice
#check @B20.Word.pinned_irsh_syntax
#check @B20.Word.pinned_ulsh_lex
#check @B20.Word.pinned_ulsh_parses
#check @B20.Word.pinned_ulsh_refines
#check @B20.Word.pinned_ulsh_slice
#check @B20.Word.pinned_ulsh_syntax
#check @B20.Word.pinned_ursh_lex
#check @B20.Word.pinned_ursh_parses
#check @B20.Word.pinned_ursh_refines
#check @B20.Word.pinned_ursh_slice
#check @B20.Word.pinned_ursh_syntax
#check @B20.Word.radix_eight
#check @B20.Word.radix_step
#check @B20.Word.read_write_formula
#check @B20.Word.read_write_roundtrip
#check @B20.Word.shift32_mutation_binding_rejected
#check @B20.Word.shift32_mutation_witness
#check @B20.Word.shiftFunction
#check @B20.Word.signed_shift_differs_from_logical
#check @B20.Word.slice
#check @B20.Word.split_count
#check @B20.Word.ulsh
#check @B20.Word.ulshFunction
#check @B20.Word.ulsh_execution
#check @B20.Word.ulsh_refines
#check @B20.Word.ursh
#check @B20.Word.urshFunction
#check @B20.Word.ursh_execution
#check @B20.Word.ursh_refines
#check @B20.Word.write_frame
#check @B20.Word.write_legal
#print axioms B20.C.Byte.access_inBounds
#print axioms B20.C.Byte.put_frame
#print axioms B20.C.Byte.put_preserves_read
#print axioms B20.C.Byte.put_preserves_write
#print axioms B20.C.Byte.read_region_byte
#print axioms B20.C.Byte.write_region_byte
#print axioms B20.C.CExec_deterministic
#print axioms B20.C.Scalar.CExec_deterministic
#print axioms B20.C.Scalar.irsh_call
#print axioms B20.C.Scalar.ulsh_call
#print axioms B20.C.Scalar.ursh_call
#print axioms B20.C.cast_u32_to_u64
#print axioms B20.C.cond_neg_add64
#print axioms B20.C.cond_neg_add64_le
#print axioms B20.C.neg_defined_of_ne
#print axioms B20.C.neg_u32
#print axioms B20.C.neg_u64
#print axioms B20.C.safe_add32
#print axioms B20.C.safe_add64
#print axioms B20.C.safe_sub32
#print axioms B20.C.safe_sub64
#print axioms B20.C.signed_add32
#print axioms B20.C.signed_add64
#print axioms B20.C.signed_overflow_rejected
#print axioms B20.C.unsigned_add32
#print axioms B20.C.unsigned_add64
#print axioms B20.C.xor_neg_bridge
#print axioms B20.Foundation.CExec_complete
#print axioms B20.Foundation.CExec_deterministic
#print axioms B20.Foundation.CExec_eval
#print axioms B20.Foundation.CExec_iff_eval
#print axioms B20.Foundation.Outcome.abort_ne_fault
#print axioms B20.Foundation.Outcome.abort_ne_nonreturn
#print axioms B20.Foundation.Outcome.nonreturn_ne_fault
#print axioms B20.Foundation.Outcome.returned_ne_stuck
#print axioms B20.Foundation.Outcome.stuck_ne_abort
#print axioms B20.Foundation.Outcome.stuck_ne_fault
#print axioms B20.Foundation.Outcome.stuck_ne_nonreturn
#print axioms B20.Foundation.compile_refines
#print axioms B20.Foundation.evalStmt_sound
#print axioms B20.Foundation.evalStmt_sound_gen
#print axioms B20.Foundation.u64Add_toNat
#print axioms B20.Fpr.Parsed.double_lex
#print axioms B20.Fpr.Parsed.double_parses
#print axioms B20.Fpr.Parsed.double_slice
#print axioms B20.Fpr.Parsed.double_syntax
#print axioms B20.Fpr.Parsed.floor_lex
#print axioms B20.Fpr.Parsed.floor_parses
#print axioms B20.Fpr.Parsed.floor_slice
#print axioms B20.Fpr.Parsed.floor_syntax
#print axioms B20.Fpr.Parsed.half_lex
#print axioms B20.Fpr.Parsed.half_parses
#print axioms B20.Fpr.Parsed.half_slice
#print axioms B20.Fpr.Parsed.half_syntax
#print axioms B20.Fpr.Parsed.neg_lex
#print axioms B20.Fpr.Parsed.neg_parses
#print axioms B20.Fpr.Parsed.neg_slice
#print axioms B20.Fpr.Parsed.neg_syntax
#print axioms B20.Fpr.Parsed.pack_lex
#print axioms B20.Fpr.Parsed.pack_parses
#print axioms B20.Fpr.Parsed.pack_slice
#print axioms B20.Fpr.Parsed.pack_syntax
#print axioms B20.Fpr.Parsed.rint_lex
#print axioms B20.Fpr.Parsed.rint_parses
#print axioms B20.Fpr.Parsed.rint_slice
#print axioms B20.Fpr.Parsed.rint_syntax
#print axioms B20.Fpr.Parsed.sub_lex
#print axioms B20.Fpr.Parsed.sub_parses
#print axioms B20.Fpr.Parsed.sub_slice
#print axioms B20.Fpr.Parsed.sub_syntax
#print axioms B20.Fpr.cast_i32_1_u64
#print axioms B20.Fpr.cast_i32_63_u64
#print axioms B20.Fpr.double_execution
#print axioms B20.Fpr.e_toNat_of_range
#print axioms B20.Fpr.floor_execution
#print axioms B20.Fpr.floor_irsh_domain
#print axioms B20.Fpr.floor_mask_all
#print axioms B20.Fpr.floor_mask_fold
#print axioms B20.Fpr.floor_mask_zero
#print axioms B20.Fpr.floor_sub63_safe
#print axioms B20.Fpr.floor_t_range
#print axioms B20.Fpr.half_execution
#print axioms B20.Fpr.irsh_call_of_toNat
#print axioms B20.Fpr.lit1085_int
#print axioms B20.Fpr.lit_allOnes64
#print axioms B20.Fpr.m0_lt
#print axioms B20.Fpr.neg_execution
#print axioms B20.Fpr.pack_add_bits
#print axioms B20.Fpr.pack_add_safe
#print axioms B20.Fpr.pack_and7_lt
#print axioms B20.Fpr.pack_execution
#print axioms B20.Fpr.pack_f_range
#print axioms B20.Fpr.pack_neg_defined
#print axioms B20.Fpr.pack_t_range
#print axioms B20.Fpr.rint_e2_range
#print axioms B20.Fpr.rint_e_int
#print axioms B20.Fpr.rint_e_nat
#print axioms B20.Fpr.rint_execution
#print axioms B20.Fpr.rint_f_range
#print axioms B20.Fpr.rint_m2_big
#print axioms B20.Fpr.rint_m2_small
#print axioms B20.Fpr.rint_mask_all
#print axioms B20.Fpr.rint_mask_zero
#print axioms B20.Fpr.rint_s_range
#print axioms B20.Fpr.rint_sub63_count
#print axioms B20.Fpr.rint_sub63_safe
#print axioms B20.Fpr.rint_ulsh_domain
#print axioms B20.Fpr.rint_ursh_domain
#print axioms B20.Fpr.rint_y_int
#print axioms B20.Fpr.rint_y_range
#print axioms B20.Fpr.signedBits_band32
#print axioms B20.Fpr.signedBits_band64
#print axioms B20.Fpr.signedBits_xor64
#print axioms B20.Fpr.sub_execution
#print axioms B20.Fpr.sub_refines_via_add_obligation
#print axioms B20.Fpr.ulsh_call_of_toNat
#print axioms B20.Fpr.ursh_call_of_toNat
#print axioms B20.Word.LE.bufferBytes_spec
#print axioms B20.Word.LE.dec_execution
#print axioms B20.Word.LE.dec_lex
#print axioms B20.Word.LE.dec_parses
#print axioms B20.Word.LE.dec_prefix
#print axioms B20.Word.LE.dec_slice
#print axioms B20.Word.LE.dec_syntax
#print axioms B20.Word.LE.decodeExpr_eval
#print axioms B20.Word.LE.enc_execution
#print axioms B20.Word.LE.enc_lex
#print axioms B20.Word.LE.enc_parses
#print axioms B20.Word.LE.enc_prefix
#print axioms B20.Word.LE.enc_slice
#print axioms B20.Word.LE.enc_syntax
#print axioms B20.Word.LE.join_byteOf
#print axioms B20.Word.LE.loadTerm_eval
#print axioms B20.Word.LE.orWord_eq_join
#print axioms B20.Word.LE.or_left_comm
#print axioms B20.Word.LE.storeBytes_frame
#print axioms B20.Word.LE.storeBytes_preserves_write
#print axioms B20.Word.LE.storeTerm_eval
#print axioms B20.Word.LE.store_step
#print axioms B20.Word.LE.stored_bytes
#print axioms B20.Word.LE.stores_execution
#print axioms B20.Word.byteAt_write
#print axioms B20.Word.byteExpansion_eq
#print axioms B20.Word.c_invalid_count_rejected
#print axioms B20.Word.c_signed_negation_overflow_rejected
#print axioms B20.Word.count_mask_mutation_witness
#print axioms B20.Word.foldl_eight
#print axioms B20.Word.foldl_equal_on
#print axioms B20.Word.irsh_execution
#print axioms B20.Word.irsh_refines
#print axioms B20.Word.load_le_refines
#print axioms B20.Word.load_store_le_refines
#print axioms B20.Word.model_load_store_roundtrip
#print axioms B20.Word.parser_unsupported_operator_rejected
#print axioms B20.Word.pinned_irsh_lex
#print axioms B20.Word.pinned_irsh_parses
#print axioms B20.Word.pinned_irsh_refines
#print axioms B20.Word.pinned_irsh_slice
#print axioms B20.Word.pinned_irsh_syntax
#print axioms B20.Word.pinned_ulsh_lex
#print axioms B20.Word.pinned_ulsh_parses
#print axioms B20.Word.pinned_ulsh_refines
#print axioms B20.Word.pinned_ulsh_slice
#print axioms B20.Word.pinned_ulsh_syntax
#print axioms B20.Word.pinned_ursh_lex
#print axioms B20.Word.pinned_ursh_parses
#print axioms B20.Word.pinned_ursh_refines
#print axioms B20.Word.pinned_ursh_slice
#print axioms B20.Word.pinned_ursh_syntax
#print axioms B20.Word.radix_eight
#print axioms B20.Word.radix_step
#print axioms B20.Word.read_write_formula
#print axioms B20.Word.read_write_roundtrip
#print axioms B20.Word.shift32_mutation_binding_rejected
#print axioms B20.Word.shift32_mutation_witness
#print axioms B20.Word.signed_shift_differs_from_logical
#print axioms B20.Word.split_count
#print axioms B20.Word.ulsh_execution
#print axioms B20.Word.ulsh_refines
#print axioms B20.Word.ursh_execution
#print axioms B20.Word.ursh_refines
#print axioms B20.Word.write_frame
#print axioms B20.Word.write_legal
