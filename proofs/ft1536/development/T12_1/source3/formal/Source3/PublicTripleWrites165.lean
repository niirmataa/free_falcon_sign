import Source3.PublicTripleReads165

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicTripleWrites165
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenPublicExec (Exec)
open KeygenPublicTableAtoms (var)
open KeygenNttLoopSupport (USlot)
open KeygenSmallOutput (element)
open PublicU32Locals165 (Ready)
open PublicTripleShape165 (completed writes)
open PublicTailShape159 (caddW addQ)

theorem one (s : State) (a : ArrayPointer) (u j : Nat) (left right : String)
    (ready : Ready s completed) (leftReady : left ∈ completed) (rightReady : right ∈ completed)
    (uBound : u+2 < 1536) (jBound : j < 3) (capacity : a.index+1536 ≤ a.count)
    (binding : s.arrays "a".toList=some a) (counter : USlot s "u" u)
    (width : a.elementBytes=2) (writable : s.heap.writable a.block=true)
    (allocated : Allocated s.heap (element a (u+j))) :
    ∃ after, Exec KeygenPublicSource.program []
      (.store "a".toList (caddW "u" j) false (addQ (var "fA") (addQ (var left) (var right))))
      s ⟨after,.normal⟩ ∧ Ready after completed ∧ USlot after "u" u ∧
      after.arrays=s.arrays ∧ after.heap.size=s.heap.size ∧ after.heap.writable=s.heap.writable := by
  obtain ⟨aw,aSlot⟩ := ready "fA" (by decide)
  obtain ⟨bw,bSlot⟩ := ready left leftReady
  obtain ⟨cw,cSlot⟩ := ready right rightReady
  have inner := PublicWordSteps161.add_eval s (var left) (var right) bw cw
    (PublicGenerateHead159.eval_var s left bw bSlot) (PublicGenerateHead159.eval_var s right cw cSlot)
  have value := PublicWordSteps161.add_eval s (var "fA") (addQ (var left) (var right))
    aw (PublicWordSteps161.addWord bw cw) (PublicGenerateHead159.eval_var s "fA" aw aSlot) inner
  have run := PublicWordSteps161.store s "a" (caddW "u" j) (element a (u+j)) _ _
    (PublicTripleIndex165.address s a u j (by omega) (by omega) binding counter (by omega))
    value allocated width writable
  exact ⟨_,run,ready,counter,rfl,rfl,rfl⟩

theorem source (s : State) (a : ArrayPointer) (u : Nat) (ready : Ready s completed)
    (uBound : u+2 < 1536) (capacity : a.index+1536 ≤ a.count)
    (binding : s.arrays "a".toList=some a) (counter : USlot s "u" u)
    (width : a.elementBytes=2) (writable : s.heap.writable a.block=true)
    (allocated : ∀ j, j < 3 → Allocated s.heap (element a (u+j))) :
    ∃ after, Exec KeygenPublicSource.program [] writes s ⟨after,.normal⟩ := by
  obtain ⟨s1,r1,v1,u1,a1,z1,w1⟩ := one s a u 0 "fB0" "fC0" ready (by decide) (by decide)
    uBound (by decide) capacity binding counter width writable (allocated 0 (by decide))
  have binding1 : s1.arrays "a".toList=some a := by rw [a1]; exact binding
  have writable1 : s1.heap.writable a.block=true := by rw [w1]; exact writable
  have alloc1 : Allocated s1.heap (element a (u+1)) := by
    simpa only [Allocated,z1] using allocated 1 (by decide)
  obtain ⟨s2,r2,v2,u2,a2,z2,w2⟩ := one s1 a u 1 "fB1" "fC2" v1 (by decide) (by decide)
    uBound (by decide) capacity binding1 u1 width writable1 alloc1
  have binding2 : s2.arrays "a".toList=some a := by rw [a2]; exact binding1
  have writable2 : s2.heap.writable a.block=true := by rw [w2]; exact writable1
  have alloc2 : Allocated s2.heap (element a (u+2)) := by
    simpa only [Allocated,z2,z1] using allocated 2 (by decide)
  obtain ⟨s3,r3,_,_,_,_,_⟩ := one s2 a u 2 "fB2" "fC1" v2 (by decide) (by decide)
    uBound (by decide) capacity binding2 u2 width writable2 alloc2
  exact ⟨s3,PublicGenerateRow159.chain_step _ _ s s1 ⟨s3,.normal⟩ r1
    (PublicGenerateRow159.chain_step _ _ s1 s2 ⟨s3,.normal⟩ r2
      (PublicGenerateRow159.chain_step _ _ s2 s3 ⟨s3,.normal⟩ r3 (.skip s3)))⟩

end FT1536.Source3.PublicTripleWrites165
