import Source3.KeygenDecodeStaticIteration

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- COMPLETE actual STATIC outer loop, deriving its1536 chronological stores
   and consumed-byte return from honest finite source executions. -/
namespace FT1536.Source3.KeygenDecodeStaticLoop
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified KeygenDecodeStaticWire
open KeygenDecodeNoneMemory (WritableArray Trace)

def whileCode : Stmt := .whileLoop (testExpr KeygenDecodeStaticBinding.loop111Test)
  (.seq KeygenDecodeStaticBinding.node110 KeygenDecodeStaticBinding.loop111Update)

theorem while_suffix (inputs : List (BitVec 16)) (args : Args) (src dst : ArrayPointer)
    (u v p padding : Nat) (db : BitVec 32) (bytes : List (BitVec 8)) (s : State)
    (bound : u<1536) (length : u+inputs.length=1536) (small : p<8) (paddingSmall : padding<8)
    (wire : Wire args src dst v p db bytes s)
    (cursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) s.locals)
    (bits : remaining p db bytes=KeygenCodecStaticBitStream.stream inputs++List.replicate padding false)
    (legal : WritableArray s.heap dst 1536) (separated : src.block≠dst.block) :
    ∃ t, Checked args whileCode s t (.returned (BitVec.ofNat 64 (v+bytes.length))) ∧
      Trace dst s.heap t.heap u inputs := by
  induction inputs generalizing u v p db bytes s with
  | nil => simp only [List.length_nil,Nat.add_zero] at length; omega
  | cons input rest ih =>
    have shaped : remaining p db bytes=KeygenCodecStaticBitStream.coefficient input++
        (KeygenCodecStaticBitStream.stream rest++List.replicate padding false) := by
      simpa only [KeygenCodecStaticBitStream.stream,List.flatMap_cons,List.append_assoc] using bits
    have one : KeygenDecodeDynamicCalculation.Computes args s.heap s.buf
        (testExpr KeygenDecodeStaticBinding.loop111Test) s.locals (.int32 1) s.locals :=
      .pure _ _ _ (.number _ _ _ (by decide +kernel))
    have same : withLocals s s.locals=s := by cases s; rfl
    by_cases last : rest=[]
    · subst rest
      have position : u=1535 := by simp only [List.length_cons,List.length_nil] at length; omega
      subst u
      obtain ⟨t,iteration,store⟩ := KeygenDecodeStaticIteration.final args src dst v p padding db bytes s input small paddingSmall wire
        cursor (by simpa only [KeygenCodecStaticBitStream.stream,List.flatMap_nil,List.nil_append] using shaped) legal separated
      have body : Checked args (.seq KeygenDecodeStaticBinding.node110 KeygenDecodeStaticBinding.loop111Update) s t
          (.returned (BitVec.ofNat 64 (v+bytes.length))) := seq_return args _ _ s t _ iteration
      have full : Checked args whileCode s t (.returned (BitVec.ofNat 64 (v+bytes.length))) :=
        KeygenDecodeStaticCertifiedLoop.return_exit args _ _ s t _ (.int32 1) s.locals one (by decide +kernel)
          (by rw [same]; exact body)
      exact ⟨t,full,.cons s.heap t.heap t.heap 1535 input [] store (.nil t.heap 1536)⟩
    · have nonempty : 0<rest.length := List.length_pos_iff.mpr last
      have nextBound : u+1<1536 := by simp only [List.length_cons] at length; omega
      obtain ⟨v1,p1,db1,bytes1,middle,iteration,middleWire,middleSmall,middleCursor,store,middleBits,byteCount⟩ :=
        KeygenDecodeStaticIteration.nonfinal args src dst u v p db bytes s input
          (KeygenCodecStaticBitStream.stream rest++List.replicate padding false) nextBound small wire cursor shaped legal separated
      have nextLegal := KeygenDecodeNoneMemory.legal_preserved s.heap middle.heap dst
        (KeygenDecodeNoneMemory.element dst u) 1536 input legal store
      have nextLength : u+1+rest.length=1536 := by simp only [List.length_cons] at length; omega
      obtain ⟨t,restRun,trace⟩ := ih (u+1) v1 p1 db1 bytes1 middle nextBound nextLength middleSmall middleWire middleCursor middleBits nextLegal
      rw [byteCount] at restRun
      have body : Checked args (.seq KeygenDecodeStaticBinding.node110 KeygenDecodeStaticBinding.loop111Update) s middle .normal :=
        seq args _ _ s middle middle .normal iteration (skip args middle)
      have full : Checked args whileCode s t (.returned (BitVec.ofNat 64 (v+bytes.length))) :=
        KeygenDecodeStaticCertifiedLoop.next args _ _ s middle t _ (.int32 1) s.locals one (by decide +kernel)
          (by rw [same]; exact body) restRun
      exact ⟨t,full,.cons s.heap middle.heap t.heap u input rest store trace⟩

theorem for_loop (inputs : List (BitVec 16)) (args : Args) (src dst : ArrayPointer)
    (v padding : Nat) (bytes : List (BitVec 8)) (s : State) (length : inputs.length=1536) (paddingSmall : padding<8)
    (wire : Wire args src dst v 0 0 bytes s)
    (cursor : Cell "u" .uint64 (.uint64 0) s.locals)
    (bits : remaining 0 0 bytes=KeygenCodecStaticBitStream.stream inputs++List.replicate padding false)
    (legal : WritableArray s.heap dst 1536) (separated : src.block≠dst.block) :
    ∃ t, Checked args KeygenDecodeStaticBinding.node111 s t (.returned (BitVec.ofNat 64 (v+bytes.length))) ∧
      Trace dst s.heap t.heap 0 inputs := by
  have cursor0 : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 0)) s.locals := by
    simpa only [show (0#64 : BitVec 64)=0 by decide +kernel] using cursor
  obtain ⟨t,body,trace⟩ := while_suffix inputs args src dst 0 v 0 padding 0 bytes s
    (by decide +kernel) (by simpa only [Nat.zero_add] using length) (by decide +kernel) paddingSmall
    wire cursor0 bits legal separated
  have expanded : Checked args (desugar KeygenDecodeStaticBinding.loop111Init KeygenDecodeStaticBinding.loop111Test
      KeygenDecodeStaticBinding.loop111Update KeygenDecodeStaticBinding.node110) s t (.returned (BitVec.ofNat 64 (v+bytes.length))) :=
    seq args _ _ s s t _ (skip args s) body
  exact ⟨t,KeygenDecodeStaticCertifiedLoop.forLoop args _ _ _ _ s t _ expanded,trace⟩

end FT1536.Source3.KeygenDecodeStaticLoop
