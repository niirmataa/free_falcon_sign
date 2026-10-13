import ArenaTypes020E1
import ArenaToken020E1
import ArenaStack020E1
import ArenaTokenLaw020E1
import ArenaStackRead020E1
import ArenaHeap020E1
import ArenaStep020E1
import ArenaCommit020E1
import ArenaInvariant020E1
import ArenaParse020E1
import ArenaDecode020E1
import ArenaProgram020E1
import ArenaReject020E1
import ArenaWords020E1
import ArenaGuard020E1
import ArenaExecution020E1

/- Author audit of the finite-bank parser component; no independent-review claim. -/
#check FT1536.S05.ArenaTypes020E1.arity_bound
#print axioms FT1536.S05.ArenaTypes020E1.arity_bound
#check FT1536.S05.ArenaTypes020E1.children_length
#print axioms FT1536.S05.ArenaTypes020E1.children_length
#check FT1536.S05.ArenaTypes020E1.empty_used
#print axioms FT1536.S05.ArenaTypes020E1.empty_used
#check FT1536.S05.ArenaTypes020E1.empty_sp
#print axioms FT1536.S05.ArenaTypes020E1.empty_sp
#check FT1536.S05.ArenaToken020E1.push_split
#print axioms FT1536.S05.ArenaToken020E1.push_split
#check FT1536.S05.ArenaToken020E1.assemble_kind
#print axioms FT1536.S05.ArenaToken020E1.assemble_kind
#check FT1536.S05.ArenaToken020E1.assemble_exists
#print axioms FT1536.S05.ArenaToken020E1.assemble_exists
#check FT1536.S05.ArenaStack020E1.view_length
#print axioms FT1536.S05.ArenaStack020E1.view_length
#check FT1536.S05.ArenaStack020E1.view_get
#print axioms FT1536.S05.ArenaStack020E1.view_get
#check FT1536.S05.ArenaStack020E1.replace_zero
#print axioms FT1536.S05.ArenaStack020E1.replace_zero
#check FT1536.S05.ArenaStack020E1.replace_succ
#print axioms FT1536.S05.ArenaStack020E1.replace_succ
#check FT1536.S05.ArenaStack020E1.view_replace
#print axioms FT1536.S05.ArenaStack020E1.view_replace
#check FT1536.S05.ArenaStack020E1.empty_view
#print axioms FT1536.S05.ArenaStack020E1.empty_view
#check FT1536.S05.ArenaTokenLaw020E1.assemble_needs
#print axioms FT1536.S05.ArenaTokenLaw020E1.assemble_needs
#check FT1536.S05.ArenaTokenLaw020E1.push_result
#print axioms FT1536.S05.ArenaTokenLaw020E1.push_result
#check FT1536.S05.ArenaTokenLaw020E1.push_arity
#print axioms FT1536.S05.ArenaTokenLaw020E1.push_arity
#check FT1536.S05.ArenaStackRead020E1.child_get
#print axioms FT1536.S05.ArenaStackRead020E1.child_get
#check FT1536.S05.ArenaStackRead020E1.children_take
#print axioms FT1536.S05.ArenaStackRead020E1.children_take
#check FT1536.S05.ArenaStackRead020E1.children_valid
#print axioms FT1536.S05.ArenaStackRead020E1.children_valid
#check FT1536.S05.ArenaStackRead020E1.empty_valid
#print axioms FT1536.S05.ArenaStackRead020E1.empty_valid
#check FT1536.S05.ArenaHeap020E1.put_used
#print axioms FT1536.S05.ArenaHeap020E1.put_used
#check FT1536.S05.ArenaHeap020E1.put_here
#print axioms FT1536.S05.ArenaHeap020E1.put_here
#check FT1536.S05.ArenaHeap020E1.put_old
#print axioms FT1536.S05.ArenaHeap020E1.put_old
#check FT1536.S05.ArenaHeap020E1.put_view
#print axioms FT1536.S05.ArenaHeap020E1.put_view
#check FT1536.S05.ArenaHeap020E1.map_update_below
#print axioms FT1536.S05.ArenaHeap020E1.map_update_below
#check FT1536.S05.ArenaHeap020E1.represents_lower
#print axioms FT1536.S05.ArenaHeap020E1.represents_lower
#check FT1536.S05.ArenaHeap020E1.represents_new
#print axioms FT1536.S05.ArenaHeap020E1.represents_new
#check FT1536.S05.ArenaHeap020E1.put_valid
#print axioms FT1536.S05.ArenaHeap020E1.put_valid
#check FT1536.S05.ArenaHeap020E1.node_kind
#print axioms FT1536.S05.ArenaHeap020E1.node_kind
#check FT1536.S05.ArenaHeap020E1.empty_valid
#print axioms FT1536.S05.ArenaHeap020E1.empty_valid
#check FT1536.S05.ArenaStep020E1.checked_kind
#print axioms FT1536.S05.ArenaStep020E1.checked_kind
#check FT1536.S05.ArenaStep020E1.commit_used
#print axioms FT1536.S05.ArenaStep020E1.commit_used
#check FT1536.S05.ArenaStep020E1.commit_sp
#print axioms FT1536.S05.ArenaStep020E1.commit_sp
#check FT1536.S05.ArenaStep020E1.commit_view
#print axioms FT1536.S05.ArenaStep020E1.commit_view
#check FT1536.S05.ArenaStep020E1.encoded_step
#print axioms FT1536.S05.ArenaStep020E1.encoded_step
#check FT1536.S05.ArenaCommit020E1.check_children
#print axioms FT1536.S05.ArenaCommit020E1.check_children
#check FT1536.S05.ArenaCommit020E1.commit_heap
#print axioms FT1536.S05.ArenaCommit020E1.commit_heap
#check FT1536.S05.ArenaCommit020E1.commit_stack
#print axioms FT1536.S05.ArenaCommit020E1.commit_stack
#check FT1536.S05.ArenaCommit020E1.commit_depth
#print axioms FT1536.S05.ArenaCommit020E1.commit_depth
#check FT1536.S05.ArenaCommit020E1.commit_meaning
#print axioms FT1536.S05.ArenaCommit020E1.commit_meaning
#check FT1536.S05.ArenaCommit020E1.step_eq
#print axioms FT1536.S05.ArenaCommit020E1.step_eq
#check FT1536.S05.ArenaInvariant020E1.logical_length
#print axioms FT1536.S05.ArenaInvariant020E1.logical_length
#check FT1536.S05.ArenaInvariant020E1.empty_inv
#print axioms FT1536.S05.ArenaInvariant020E1.empty_inv
#check FT1536.S05.ArenaInvariant020E1.step_refines
#print axioms FT1536.S05.ArenaInvariant020E1.step_refines
#check FT1536.S05.ArenaParse020E1.encoded_run
#print axioms FT1536.S05.ArenaParse020E1.encoded_run
#check FT1536.S05.ArenaParse020E1.parse_refines
#print axioms FT1536.S05.ArenaParse020E1.parse_refines
#check FT1536.S05.ArenaDecode020E1.gather_map
#print axioms FT1536.S05.ArenaDecode020E1.gather_map
#check FT1536.S05.ArenaDecode020E1.decode_correct
#print axioms FT1536.S05.ArenaDecode020E1.decode_correct
#check FT1536.S05.ArenaDecode020E1.view_singleton
#print axioms FT1536.S05.ArenaDecode020E1.view_singleton
#check FT1536.S05.ArenaDecode020E1.root_correct
#print axioms FT1536.S05.ArenaDecode020E1.root_correct
#check FT1536.S05.ArenaProgram020E1.build_invariant
#print axioms FT1536.S05.ArenaProgram020E1.build_invariant
#check FT1536.S05.ArenaProgram020E1.build_correct
#print axioms FT1536.S05.ArenaProgram020E1.build_correct
#check FT1536.S05.ArenaProgram020E1.actual_exists
#print axioms FT1536.S05.ArenaProgram020E1.actual_exists
#check FT1536.S05.ArenaProgram020E1.actual_roundtrip
#print axioms FT1536.S05.ArenaProgram020E1.actual_roundtrip
#check FT1536.S05.ArenaProgram020E1.actual_counts
#print axioms FT1536.S05.ArenaProgram020E1.actual_counts
#check FT1536.S05.ArenaReject020E1.full
#print axioms FT1536.S05.ArenaReject020E1.full
#check FT1536.S05.ArenaReject020E1.underflow
#print axioms FT1536.S05.ArenaReject020E1.underflow
#check FT1536.S05.ArenaReject020E1.bad_child
#print axioms FT1536.S05.ArenaReject020E1.bad_child
#check FT1536.S05.ArenaReject020E1.invalid_pointer
#print axioms FT1536.S05.ArenaReject020E1.invalid_pointer
#check FT1536.S05.ArenaReject020E1.bad_cell
#print axioms FT1536.S05.ArenaReject020E1.bad_cell
#check FT1536.S05.ArenaWords020E1.ptr_word_exact
#print axioms FT1536.S05.ArenaWords020E1.ptr_word_exact
#check FT1536.S05.ArenaWords020E1.ptr_word_injective
#print axioms FT1536.S05.ArenaWords020E1.ptr_word_injective
#check FT1536.S05.ArenaWords020E1.tag_exact
#print axioms FT1536.S05.ArenaWords020E1.tag_exact
#check FT1536.S05.ArenaWords020E1.node_words_injective
#print axioms FT1536.S05.ArenaWords020E1.node_words_injective
#check FT1536.S05.ArenaWords020E1.pack_injective
#print axioms FT1536.S05.ArenaWords020E1.pack_injective
#check FT1536.S05.ArenaWords020E1.persistent_words877
#print axioms FT1536.S05.ArenaWords020E1.persistent_words877
#check FT1536.S05.ArenaWords020E1.actual_pack_injective
#print axioms FT1536.S05.ArenaWords020E1.actual_pack_injective
#check FT1536.S05.ArenaGuard020E1.step_isSome
#print axioms FT1536.S05.ArenaGuard020E1.step_isSome
#check FT1536.S05.ArenaGuard020E1.rejects_iff
#print axioms FT1536.S05.ArenaGuard020E1.rejects_iff
#check FT1536.S05.ArenaExecution020E1.correct
#print axioms FT1536.S05.ArenaExecution020E1.correct
#check FT1536.S05.ArenaExecution020E1.public_initial
#print axioms FT1536.S05.ArenaExecution020E1.public_initial
