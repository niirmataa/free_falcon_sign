import B20.Word.Memory
import B20.Word.Negative

set_option pp.universes true

#check @B20.C.CExec_deterministic
#check @B20.Foundation.CExec_eval
#check @B20.Foundation.CExec_iff_eval
#check @B20.Foundation.CExec_deterministic
#check @B20.Word.split_count
#check @B20.Word.ursh_refines
#check @B20.Word.irsh_refines
#check @B20.Word.ulsh_refines
#check @B20.Word.pinned_ursh_parses
#check @B20.Word.pinned_irsh_parses
#check @B20.Word.pinned_ulsh_parses
#check @B20.Word.pinned_ursh_refines
#check @B20.Word.pinned_irsh_refines
#check @B20.Word.pinned_ulsh_refines
#check @B20.Word.byteAt_write
#check @B20.Word.write_frame
#check @B20.Word.write_legal
#check @B20.Word.read_write_roundtrip
#check @B20.Word.model_load_store_roundtrip
#check @B20.Word.shift32_mutation_binding_rejected
#check @B20.Word.shift32_mutation_witness
#check @B20.Word.count_mask_mutation_witness
#check @B20.Word.signed_shift_differs_from_logical
#check @B20.Word.c_invalid_count_rejected
#check @B20.Word.c_signed_negation_overflow_rejected
#check @B20.Word.parser_unsupported_operator_rejected

#print axioms B20.C.CExec_deterministic
#print axioms B20.Foundation.CExec_eval
#print axioms B20.Foundation.CExec_iff_eval
#print axioms B20.Foundation.CExec_deterministic
#print axioms B20.Word.split_count
#print axioms B20.Word.ursh_refines
#print axioms B20.Word.irsh_refines
#print axioms B20.Word.ulsh_refines
#print axioms B20.Word.pinned_ursh_parses
#print axioms B20.Word.pinned_irsh_parses
#print axioms B20.Word.pinned_ulsh_parses
#print axioms B20.Word.pinned_ursh_refines
#print axioms B20.Word.pinned_irsh_refines
#print axioms B20.Word.pinned_ulsh_refines
#print axioms B20.Word.byteAt_write
#print axioms B20.Word.write_frame
#print axioms B20.Word.write_legal
#print axioms B20.Word.read_write_roundtrip
#print axioms B20.Word.model_load_store_roundtrip
#print axioms B20.Word.shift32_mutation_binding_rejected
#print axioms B20.Word.shift32_mutation_witness
#print axioms B20.Word.count_mask_mutation_witness
#print axioms B20.Word.signed_shift_differs_from_logical
#print axioms B20.Word.c_invalid_count_rejected
#print axioms B20.Word.c_signed_negation_overflow_rejected
#print axioms B20.Word.parser_unsupported_operator_rejected
