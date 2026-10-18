import Source3.PublicMiddleReads161

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicMiddleWrites161
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenPublicExec (Exec Stmt chain)
open KeygenSmallOutput (element Store16)
open KeygenPublicTableAtoms (var)
open PublicTailShape159 (cvar cadd addQ subQ)
open PublicWordSteps161 (addWord subWord)
open PublicGenerateTable159 (Written)

def tail : Stmt := chain [
  .store "a".toList (cvar "v") false (addQ (var "a0") (var "a1")),
  .store "a".toList (cadd (cvar "v") (cvar "ht")) false (subQ (var "a0") (var "a1"))]

structure MemoryFrame (before after : State) (a : ArrayPointer) : Prop where
  size : after.heap.size=before.heap.size
  writable : after.heap.writable=before.heap.writable
  outside : ∀ block, block≠a.block → ∀ offset,
    after.heap.bytes block offset=before.heap.bytes block offset
  written : ∀ j, Written before.heap (element a j) → Written after.heap (element a j)

theorem source (s : State) (a : ArrayPointer) (v ht : Nat) (x y : BitVec 32)
    (bound : v+ht < 2^64) (capacity : a.index+(v+ht) ≤ a.count)
    (ready : PublicMiddleReads161.Ready s a v ht x y)
    (width : a.elementBytes=2) (writable : s.heap.writable a.block=true)
    (lowAllocated : Allocated s.heap (element a v))
    (highAllocated : Allocated s.heap (element a (v+ht))) :
    ∃ after, Exec KeygenPublicSource.program [] tail s ⟨after,.normal⟩ ∧
      MemoryFrame s after a := by
  let lo := KeygenPublicWord.narrow (.uint32 (addWord x y))
  let hi := KeygenPublicWord.narrow (.uint32 (subWord x y))
  let middle : State := {s with heap := Word16Memory158.write s.heap (element a v) lo}
  let after : State := {middle with heap := Word16Memory158.write middle.heap (element a (v+ht)) hi}
  have firstEval := PublicWordSteps161.add_eval s (var "a0") (var "a1") x y
    (PublicGenerateHead159.eval_var s "a0" x ready.first)
    (PublicGenerateHead159.eval_var s "a1" y ready.second)
  have lowRun : Exec KeygenPublicSource.program []
      (.store "a".toList (cvar "v") false (addQ (var "a0") (var "a1"))) s ⟨middle,.normal⟩ :=
    PublicWordSteps161.store s "a" (cvar "v") (element a v) _ _
      (PublicWordSteps161.address_var s "a" "v" a v (by omega)
        ready.binding ready.counter (by omega)) firstEval lowAllocated width writable
  have secondEval := PublicWordSteps161.sub_eval middle (var "a0") (var "a1") x y
    (PublicGenerateHead159.eval_var middle "a0" x ready.first)
    (PublicGenerateHead159.eval_var middle "a1" y ready.second)
  have highRun : Exec KeygenPublicSource.program []
      (.store "a".toList (cadd (cvar "v") (cvar "ht")) false (subQ (var "a0") (var "a1")))
      middle ⟨after,.normal⟩ :=
    PublicWordSteps161.store middle "a" (cadd (cvar "v") (cvar "ht")) (element a (v+ht)) _ _
      (PublicWordSteps161.address_sum middle "a" "v" "ht" a v ht bound
        ready.binding ready.counter ready.half capacity) secondEval highAllocated width writable
  have lowWrite : Store16 s.heap (element a v) lo middle.heap :=
    Word16Memory158.source s.heap (element a v) lo lowAllocated width writable
  have highWrite : Store16 middle.heap (element a (v+ht)) hi after.heap :=
    Word16Memory158.source middle.heap (element a (v+ht)) hi highAllocated width writable
  refine ⟨after,PublicGenerateRow159.chain_step _ _ s middle ⟨after,.normal⟩ lowRun
    (PublicGenerateRow159.chain_step _ _ middle after ⟨after,.normal⟩ highRun (.skip after)),
    rfl,rfl,?_,?_⟩
  · intro block different offset
    exact (highWrite.2.2.2.2.2.2 block offset (Or.inl different)).trans
      (lowWrite.2.2.2.2.2.2 block offset (Or.inl different))
  · intro j old
    exact PublicTailFrame160.written_after_store middle.heap after.heap a width (v+ht) j hi highWrite
      (PublicTailFrame160.written_after_store s.heap middle.heap a width v j lo lowWrite old)

end FT1536.Source3.PublicMiddleWrites161
