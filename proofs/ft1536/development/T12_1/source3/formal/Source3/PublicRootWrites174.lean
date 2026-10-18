import Source3.PublicRootReads174

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicRootWrites174
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenPublicExec (Exec Stmt chain)
open KeygenPublicWord (Eval)
open KeygenSmallOutput (element Store16)
open KeygenPublicTableAtoms (var)
open PublicTailShape159 (cvar cadd addQ subQ mont)
open PublicWordSteps161 (addWord subWord)
open PublicMiddleWrites161 (MemoryFrame)

def tail : Stmt := chain [KeygenPublicRootInverseProgram.multiply,
  KeygenPublicRootInverseProgram.storeLow,KeygenPublicRootInverseProgram.storeHigh]

theorem source (s : State) (a : ArrayPointer) (u : Nat) (x y r : BitVec 32)
    (bound : u+768<2^64) (capacity : a.index+(u+768)≤a.count)
    (ready : PublicRootReads174.Ready s a u x y r)
    (width : a.elementBytes=2) (writable : s.heap.writable a.block=true)
    (lowAllocated : Allocated s.heap (element a u))
    (highAllocated : Allocated s.heap (element a (u+768))) :
    ∃ after, Exec KeygenPublicSource.program [] tail s ⟨after,.normal⟩ ∧ MemoryFrame s after a := by
  let bw := PublicGenerateRow159.rowValue r (subWord x y)
  let withB := bindValue s "b".toList .uint32 (.uint32 bw)
  have difference := PublicWordSteps161.sub_eval s (var "a0") (var "a1") x y
    (PublicGenerateHead159.eval_var s "a0" x ready.first)
    (PublicGenerateHead159.eval_var s "a1" y ready.second)
  have product := PublicInverseTripleWrites172.mont_eval s (var "r") (subQ (var "a0") (var "a1"))
    r (subWord x y) (PublicGenerateHead159.eval_var s "r" r ready.factor) difference
  have multiply : Exec KeygenPublicSource.program [] KeygenPublicRootInverseProgram.multiply s ⟨withB,.normal⟩ :=
    .assign _ _ _ .uint32 none (.uint32 bw) ready.bCell product
  have bSlot := PublicGenerateRow159.u32_slot_after s "b" bw
  let lo := KeygenPublicWord.narrow (.uint32 (subWord (addWord x y) bw))
  let hi := KeygenPublicWord.narrow (.uint32 (addWord bw bw))
  let middle : State := {withB with heap:=Word16Memory158.write withB.heap (element a u) lo}
  let after : State := {middle with heap:=Word16Memory158.write middle.heap (element a (u+768)) hi}
  have sum := PublicWordSteps161.add_eval withB (var "a0") (var "a1") x y
    (PublicGenerateHead159.eval_var withB "a0" x ready.first)
    (PublicGenerateHead159.eval_var withB "a1" y ready.second)
  have lowValue := PublicWordSteps161.sub_eval withB (addQ (var "a0") (var "a1")) (var "b")
    (addWord x y) bw sum (PublicGenerateHead159.eval_var withB "b" bw bSlot)
  have lowRun : Exec KeygenPublicSource.program [] KeygenPublicRootInverseProgram.storeLow withB ⟨middle,.normal⟩ :=
    PublicWordSteps161.store withB "a" (cvar "u") (element a u) _ _
      (PublicWordSteps161.address_var withB "a" "u" a u (by omega) ready.binding ready.counter (by omega))
      lowValue lowAllocated width writable
  have highValue := PublicWordSteps161.add_eval middle (var "b") (var "b") bw bw
    (PublicGenerateHead159.eval_var middle "b" bw bSlot) (PublicGenerateHead159.eval_var middle "b" bw bSlot)
  have highRun : Exec KeygenPublicSource.program [] KeygenPublicRootInverseProgram.storeHigh middle ⟨after,.normal⟩ :=
    PublicWordSteps161.store middle "a" (cadd (cvar "u") (cvar "hn")) (element a (u+768)) _ _
      (PublicWordSteps161.address_sum middle "a" "u" "hn" a u 768 bound ready.binding ready.counter ready.half capacity)
      highValue highAllocated width writable
  have lowWrite : Store16 s.heap (element a u) lo middle.heap :=
    Word16Memory158.source s.heap (element a u) lo lowAllocated width writable
  have highWrite : Store16 middle.heap (element a (u+768)) hi after.heap :=
    Word16Memory158.source middle.heap (element a (u+768)) hi highAllocated width writable
  refine ⟨after,PublicGenerateRow159.chain_step _ _ s withB ⟨after,.normal⟩ multiply
    (PublicGenerateRow159.chain_step _ _ withB middle ⟨after,.normal⟩ lowRun
      (PublicGenerateRow159.chain_step _ _ middle after ⟨after,.normal⟩ highRun (.skip after))),rfl,rfl,?_,?_⟩
  · intro block different offset
    exact (highWrite.2.2.2.2.2.2 block offset (Or.inl different)).trans
      (lowWrite.2.2.2.2.2.2 block offset (Or.inl different))
  · intro j old
    exact PublicTailFrame160.written_after_store middle.heap after.heap a width (u+768) j hi highWrite
      (PublicTailFrame160.written_after_store s.heap middle.heap a width u j lo lowWrite old)

end FT1536.Source3.PublicRootWrites174
