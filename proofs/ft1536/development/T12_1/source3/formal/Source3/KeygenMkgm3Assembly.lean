import Source3.KeygenMkgm3RowInit

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The complete parsed M0 table generator. The entry premises contain
   scalar arguments, the executed inverse initializer and static/legal
   memory. No table-range, root-identity or callee-correctness premise is
   assumed; those facts follow from the same source execution. -/
namespace FT1536.Source3.KeygenMkgm3Assembly
open C99ModularReference (Stmt Exec chainOf)
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open C99MemoryReference (ArrayPointer)
open KeygenMkgm3Program
open KeygenMkgm3Atoms
open KeygenMkgm3Prelude
open KeygenMkgm3RowInit (assign64 set64)
open KeygenMkgm3Control (frame chain_inv)
open KeygenMkgm3Counters (single_value advanced advanced_counter)
open KeygenMkgm3Loops (Filled Common)
open KeygenNttLoopSupport (USlot)
open KeygenNttButterflyCalls (U32Slot)
open KeygenMkgm3Upward (Pointers)
open KeygenMkgm3Table (Cell Initialized)

theorem cube_for (s : State) (out : Result) (p0i : BitVec 32) (gm igm : ArrayPointer)
    (common : Common p0i gm igm s) (declared : Declared s "u" .uint64)
    (filled : Filled s.heap gm 512) (gw : gm.elementBytes=4) (iw : igm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes gm 4096 igm 4096)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec cubeLoop s out) : Filled out.state.heap gm 256 ∧ USlot out.state "u" 512 := by
  have tail := C99ModularReference.continuation _ _ s (advanced s 256) out
    (fun r h => assign64 s r "u" _ 256 declared (fun v hv => by
      rw [KeygenMkgm3Counters.cube_start s v common.k (KeygenNttForwardExec.eval_scalar s _ v hv)]
      rfl) h) source
  apply (KeygenMkgm3Loops.cube_loop p0i gm igm gw iw separate initialization _ out _ tail).2
  exact ⟨KeygenMkgm3Loops.advance_common s 256 p0i gm igm common,256,by decide,by decide,
    advanced_counter s 256 (by decide),fun j hj h => filled j hj (by omega)⟩

theorem square_for (s : State) (out : Result) (p0i : BitVec 32) (gm igm : ArrayPointer)
    (common : Common p0i gm igm s) (declared : Declared s "u" .uint64)
    (filled : Filled s.heap gm 256) (gw : gm.elementBytes=4) (iw : igm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes gm 4096 igm 4096)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec squareLoop s out) : Filled out.state.heap gm 1 ∧ USlot out.state "u" 0 := by
  have tail := C99ModularReference.continuation _ _ s (advanced s 255) out
    (fun r h => assign64 s r "u" _ 255 declared (fun v hv => by
      rw [KeygenMkgm3Counters.square_start s v common.k (KeygenNttForwardExec.eval_scalar s _ v hv)]
      rfl) h) source
  apply (KeygenMkgm3Loops.square_loop p0i gm igm gw iw separate initialization _ out _ tail).2
  exact ⟨KeygenMkgm3Loops.advance_common s 255 p0i gm igm common,255,by decide,
    advanced_counter s 255 (by decide),fun j hj h => filled j hj (by omega)⟩

theorem k_decrement (s : State) (out : Result) (slot : U32Slot s "k" 9)
    (source : Exec (dec "k") s out) : out=⟨set32 s "k" 8,.normal⟩ := by
  obtain ⟨ty,old,v,declared,ev,he⟩ := KeygenNttLoopSupport.update_result _ _ _ s out source
  have ht := congrArg Prod.fst (Option.some.inj (declared.symm.trans slot))
  change ty=C99IntegerReference.Ty.uint32 at ht
  subst ty
  have hv := single_value s "k" 9 (.bin .sub (var "k") (num 1)) .u32 (.u32 8) v slot rfl rfl (by decide) ev
  rw [he,hv]
  rfl

theorem full_rows (s : State) (out : Result) (p0i : BitVec 32) (gm igm : ArrayPointer)
    (params : Params s p0i) (pointers : Pointers s gm igm) (k : U32Slot s "k" 9)
    (full : U32Slot s "full" 1) (declared : Declared s "u" .uint64)
    (filled : Filled s.heap gm 512) (gw : gm.elementBytes=4) (iw : igm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes gm 4096 igm 4096)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec ifFull s out) : Filled out.state.heap gm 256 ∧ USlot out.state "u" 512 ∧ U32Slot out.state "k" 8 := by
  obtain ⟨v,guard,nonzero,branch⟩ := (KeygenNttForwardExec.branch_inv _ _ _ s out source).resolve_right (by
    rintro ⟨v,guard,zero,_⟩
    rw [KeygenNttButterflyCalls.variable_u32 s "full" 1 v full guard] at zero
    cases zero)
  obtain ⟨inner,body,hout⟩ := KeygenNttLoopSupport.scope_result _ _ s out branch
  obtain ⟨s1,dk,tail1⟩ := chain_inv _ _ s inner (by decide) body
  obtain ⟨s2,loop,last⟩ := chain_inv _ _ s1 inner (by decide) tail1
  have hend := C99ModularReference.skip_result s2 inner last
  have hs : s1=set32 s "k" 8 := congrArg Result.state (k_decrement s ⟨s1,.normal⟩ k dk)
  have k1 : U32Slot s1 "k" 8 := by rw [hs]; exact set32_slot s "k" 8
  have p1 := params_transport _ s ⟨s1,.normal⟩ p0i (by decide) (by decide) (by decide) params dk
  have pt1 := KeygenMkgm3Upward.pointers_after _ s ⟨s1,.normal⟩ gm igm (by decide) pointers dk
  have u1 := declared_transport _ s ⟨s1,.normal⟩ "u" .uint64 (by decide) (by decide) declared dk
  have filled1 : Filled s1.heap gm 512 := by rw [hs]; exact filled
  obtain ⟨cells,u⟩ := cube_for s1 ⟨s2,.normal⟩ p0i gm igm ⟨p1,pt1,k1⟩ u1 filled1 gw iw separate initialization loop
  have k2 := slot_transport _ s1 ⟨s2,.normal⟩ "k" 8 (by decide) (by decide) k1 loop
  rw [hout,hend]
  exact ⟨cells,u,k2⟩

theorem top_rows (s : State) (out : Result) (gm igm : ArrayPointer) (pointers : Pointers s gm igm)
    (filled : Filled s.heap gm 1) (gw : gm.elementBytes=4) (iw : igm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes gm 4096 igm 4096)
    (source : Exec (chainOf topElements) s out) : Initialized out.state.heap gm := by
  obtain ⟨s1,gstore,tail1⟩ := chain_inv _ _ s out (by decide) source
  obtain ⟨s2,wset,tail2⟩ := chain_inv _ _ s1 out (by decide) tail1
  obtain ⟨s3,istore,last⟩ := chain_inv _ _ s2 out (by decide) tail2
  have hend := C99ModularReference.skip_result s3 out last
  have read := load_word s "gm" (num 1) gm 1 (KeygenMkgm3Indices.tableExponent 1)
    pointers.forward (literal_index s 1 (by decide)) (filled 1 (by decide) (by decide))
  obtain ⟨w,write,scaled⟩ := store_word s ⟨s1,.normal⟩ "gm" _ _ gm 0 _ pointers.forward
    (literal_index s 0 (by decide)) read gstore
  have zero := KeygenMkgm3Table.store_initializes gm 0 _ _ w scaled write
  have p1 := KeygenMkgm3Upward.pointers_after _ s ⟨s1,.normal⟩ gm igm (by decide) pointers gstore
  have p2 := KeygenMkgm3Upward.pointers_after _ s1 ⟨s2,.normal⟩ gm igm (by decide) p1 wset
  have heap2 : s2.heap=s1.heap := assign_heap s1 ⟨s2,.normal⟩ _ _ wset
  obtain ⟨iv,iwrite⟩ := KeygenMkgm3Upward.plain_store s2 ⟨s3,.normal⟩ "igm" _ _ igm 0 p2.inverse
    (literal_index s2 0 (by decide)) istore
  rw [hend]
  intro j hj
  apply KeygenMkgm3Table.inverse_preserves_cell gm igm gw iw separate 0 j (by decide) hj _ _ iv iwrite
  rw [heap2]
  by_cases eq : j=0
  · subst j; exact zero
  · exact KeygenMkgm3Table.store_preserves_cell gm gw 0 j (Ne.symm eq) _ _ w write (filled j hj (by omega))

def suffixList : List Stmt := [rowSelect,kFromLogn,ifFull,squareLoop]++topElements

theorem code_split : code=chainOf (initialList++suffixList) := rfl

theorem source_table (s : State) (out : Result) (p0i : BitVec 32) (gm igm rev : ArrayPointer)
    (params : Params s p0i) (logn : U32Slot s "logn" 10) (full : U32Slot s "full" 1)
    (g : U32Slot s "g" KeygenFirstPrime.generator) (pointers : Pointers s gm igm)
    (revBinding : s.arrays "REV10".toList=some rev)
    (staticTable : KeygenMkgm3RevMemory.SourceTable s.heap rev)
    (gw : gm.elementBytes=4) (iw : igm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes gm 4096 igm 4096)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec code s out) : out.flow=.normal ∧ Initialized out.state.heap gm := by
  rw [code_split] at source
  obtain ⟨s1,initial,rest⟩ := cut initialList suffixList s out (by decide) source
  have ready := initial_result s ⟨s1,.normal⟩ p0i params logn full g initialization initial
  have pt1 := KeygenMkgm3Upward.pointers_after _ s ⟨s1,.normal⟩ gm igm (by decide) pointers initial
  have rev1 := KeygenMkgm3RevMemory.transported _ s ⟨s1,.normal⟩ rev (by decide)
    (KeygenMkgm3RevMemory.from_source s rev revBinding staticTable) initial
  obtain ⟨s2,row,tail2⟩ := chain_inv _ _ s1 out (by decide) rest
  obtain ⟨s3,ks,tail3⟩ := chain_inv _ _ s2 out (by decide) tail2
  obtain ⟨s4,cubes,tail4⟩ := chain_inv _ _ s3 out (by decide) tail3
  obtain ⟨s5,squares,top⟩ := chain_inv _ _ s4 out (by decide) tail4
  obtain ⟨lastRow,u2,k2⟩ := KeygenMkgm3RowInit.selected_row s1 ⟨s2,.normal⟩ p0i gm igm rev
    ready pt1 rev1 gw iw separate initialization row
  have ln2 := slot_transport _ s1 ⟨s2,.normal⟩ "logn" 10 (by decide) (by decide) ready.logn row
  have ksResult := assign32 s2 ⟨s3,.normal⟩ "k" _ 9 ⟨some (.uint32 1),k2⟩
    (fun v h => single_value s2 "logn" 10 (.bin .sub (var "logn") (num 1)) .u32 (.u32 9) v
      ln2 rfl rfl (by decide) (KeygenNttForwardExec.eval_scalar s2 _ v h)) ks
  have s3eq : s3=set32 s2 "k" 9 := congrArg Result.state ksResult
  have k3 : U32Slot s3 "k" 9 := by rw [s3eq]; exact set32_slot s2 "k" 9
  have u3 := declared_transport _ s2 ⟨s3,.normal⟩ "u" .uint64 (by decide) (by decide) ⟨some (KeygenNttLoopSupport.u64 512),u2⟩ ks
  have cells3 : Filled s3.heap gm 512 := by rw [s3eq]; exact lastRow
  have p2 := params_transport _ s1 ⟨s2,.normal⟩ p0i (by decide) (by decide) (by decide) ready.params row
  have p3 := params_transport _ s2 ⟨s3,.normal⟩ p0i (by decide) (by decide) (by decide) p2 ks
  have pt2 := KeygenMkgm3Upward.pointers_after _ s1 ⟨s2,.normal⟩ gm igm (by decide) pt1 row
  have pt3 := KeygenMkgm3Upward.pointers_after _ s2 ⟨s3,.normal⟩ gm igm (by decide) pt2 ks
  have f2 := slot_transport _ s1 ⟨s2,.normal⟩ "full" 1 (by decide) (by decide) ready.full row
  have f3 := slot_transport _ s2 ⟨s3,.normal⟩ "full" 1 (by decide) (by decide) f2 ks
  obtain ⟨cells4,u4,k4⟩ := full_rows s3 ⟨s4,.normal⟩ p0i gm igm p3 pt3 k3 f3 u3 cells3 gw iw separate initialization cubes
  have p4 := params_transport _ s3 ⟨s4,.normal⟩ p0i (by decide) (by decide) (by decide) p3 cubes
  have pt4 := KeygenMkgm3Upward.pointers_after _ s3 ⟨s4,.normal⟩ gm igm (by decide) pt3 cubes
  obtain ⟨cells5,_⟩ := square_for s4 ⟨s5,.normal⟩ p0i gm igm ⟨p4,pt4,k4⟩
    ⟨some (KeygenNttLoopSupport.u64 512),u4⟩ cells4 gw iw separate initialization squares
  have pt5 := KeygenMkgm3Upward.pointers_after _ s4 ⟨s5,.normal⟩ gm igm (by decide) pt4 squares
  exact ⟨(frame _ s out (by decide) source).1,top_rows s5 out gm igm pt5 cells5 gw iw separate top⟩

end FT1536.Source3.KeygenMkgm3Assembly
