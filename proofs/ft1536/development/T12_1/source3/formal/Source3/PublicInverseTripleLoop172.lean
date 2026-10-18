import Source3.PublicInverseTripleBody172
import Source3.PublicInverseMemory172
import Source3.PublicTripleLoop165

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicInverseTripleLoop172
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenPublicWord (Eval)
open KeygenPublicTableAtoms (var literal)
open KeygenNttLoopSupport (USlot u64)
open PublicInverseDomains172 (Arrays)
open PublicU32Locals165 (Has)
open KeygenPublicInverseProgram (guard step loop)
open PublicTripleLoop165 (next)

structure Fixed (s : State) (a gm : ArrayPointer) : Prop where
  arrays : Arrays s a gm
  cubic : s.arrays "igm_cubic".toList=some gm
  length : USlot s "n" 1536
  factor : Has s "w"

theorem context (s : State) (a gm : ArrayPointer) (k : Nat) (inside : k < 512)
    (fixed : Fixed s a gm) (uSlot : USlot s "u" (3*k)) (vSlot : USlot s "v" (512+k)) :
    PublicInverseTripleBody172.Context s a gm (3*k) (512+k) :=
  ⟨by omega,by omega,(PublicForwardMemory167.capacity s.heap a fixed.arrays.data),(PublicInverseDomains172.table_capacity s a gm fixed.arrays),
    fixed.arrays.aBinding,fixed.cubic,uSlot,vSlot,fixed.factor,
    fun j hj => fixed.arrays.data.written (3*k+j) (by omega),
    fixed.arrays.tableWritten (512+k) (by omega),(PublicForwardMemory167.width s.heap a fixed.arrays.data),fixed.arrays.data.writable,
    fun j hj => PublicInverseMemory172.allocated s a gm fixed.arrays (3*k+j) (by omega)⟩

theorem fixed_after (s after : State) (a gm : ArrayPointer)
    (fixed : Fixed s a gm) (frame : PublicInverseTripleBody172.Frame s after) : Fixed after a gm := by
  refine ⟨PublicInverseMemory172.arrays s after a gm fixed.arrays frame.arrays frame.memory,?_,?_,?_⟩
  · rw [frame.arrays]; exact fixed.cubic
  · exact (congrFun frame.locals _).trans fixed.length
  · obtain ⟨w,slot⟩ := fixed.factor
    exact ⟨w,(congrFun frame.locals _).trans slot⟩

theorem fixed_next (s : State) (a gm : ArrayPointer) (k : Nat) (fixed : Fixed s a gm) :
    Fixed (next s k) a gm :=
  ⟨PublicInverseMemory172.arrays s _ a gm fixed.arrays rfl (PublicInitializedFrame164.refl s.heap),
    fixed.cubic,fixed.length,fixed.factor⟩

theorem step_same : KeygenPublicInverseProgram.step=PublicTailShape159.tripleInc := by decide

theorem increment (s : State) (k : Nat) (inside : k<512)
    (uSlot : USlot s "u" (3*k)) (vSlot : USlot s "v" (512+k)) :
    Exec KeygenPublicSource.program [] KeygenPublicInverseProgram.step s ⟨next s k,.normal⟩ ∧
      USlot (next s k) "u" (3*(k+1)) ∧ USlot (next s k) "v" (512+(k+1)) := by
  rw [step_same]
  exact PublicTripleLoop165.increment s k inside uSlot vSlot

theorem guard (s : State) (a gm : ArrayPointer) (k : Nat) (bound : k ≤ 512)
    (fixed : Fixed s a gm) (uSlot : USlot s "u" (3*k)) :
    Eval [] s KeygenPublicInverseProgram.guard (C99ScalarReference.boolean (decide (k < 512))) := by
  have raw : Eval [] s KeygenPublicInverseProgram.guard (C99ScalarReference.boolean (decide (3*k < 1536))) :=
    .cmp .lt _ _ _ _ _ (.scalar _ _ (PublicGenerateIndex159.var_u64 s "u" (3*k) uSlot))
      (.scalar _ _ (PublicGenerateIndex159.var_u64 s "n" 1536 fixed.length))
      (C99NatWord141.less (3*k) 1536 (by omega) (by decide))
  have same : 3*k < 1536 ↔ k < 512 := by omega
  simpa only [same] using raw

theorem remaining (count k : Nat) (s : State) (a gm : ArrayPointer)
    (fixed : Fixed s a gm) (uSlot : USlot s "u" (3*k)) (vSlot : USlot s "v" (512+k))
    (finish : k+count=512) :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicInverseProgram.loop s ⟨after,.normal⟩ ∧
      Fixed after a gm ∧ USlot after "u" 1536 ∧ USlot after "v" 1024 := by
  induction count generalizing k s with
  | zero =>
      have equal : k=512 := by omega
      subst k
      exact ⟨s,.loopFalse _ _ _ _ _ (guard s a gm 512 (by decide) fixed uSlot) (by decide),fixed,uSlot,vSlot⟩
  | succ count ih =>
      have inside : k < 512 := by omega
      obtain ⟨middle,bodyRun,bodyFrame⟩ := PublicInverseTripleBody172.source s a gm (3*k) (512+k)
        (context s a gm k inside fixed uSlot vSlot)
      have midFixed := fixed_after s middle a gm fixed bodyFrame
      have midU : USlot middle "u" (3*k) := (congrFun bodyFrame.locals _).trans uSlot
      have midV : USlot middle "v" (512+k) := (congrFun bodyFrame.locals _).trans vSlot
      obtain ⟨step,nextU,nextV⟩ := increment middle k inside midU midV
      obtain ⟨after,rest,lastFixed,lastU,lastV⟩ :=
        ih (k+1) (next middle k) (fixed_next middle a gm k midFixed) nextU nextV (by omega)
      have yes : Eval [] s KeygenPublicInverseProgram.guard (C99ScalarReference.boolean true) := by
        simpa only [inside,decide_true] using guard s a gm k (by omega) fixed uSlot
      exact ⟨after,.loopNormal _ _ _ s middle (next middle k) ⟨after,.normal⟩
        (C99ScalarReference.boolean true) yes (by decide) bodyRun step rest,lastFixed,lastU,lastV⟩

theorem source (s : State) (a gm : ArrayPointer) (fixed : Fixed s a gm)
    (uSlot : USlot s "u" 0) (vSlot : USlot s "v" 512) :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicInverseProgram.loop s ⟨after,.normal⟩ ∧
      Fixed after a gm ∧ USlot after "u" 1536 ∧ USlot after "v" 1024 :=
  remaining 512 0 s a gm fixed uSlot vSlot (by decide)

end FT1536.Source3.PublicInverseTripleLoop172
