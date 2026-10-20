import Source3.KeygenPublicEvaluationMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Both ORIGINAL evaluation arrays and the caller header at the SAME afterT
   seam. Static-table nonaliasing is an explicit legal-memory obligation. -/
namespace FT1536.Source3.KeygenPublicCommonCalls
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec)
open KeygenPublicInputProgram (signed hForward tForward)
open KeygenPublicInputLoop (Pointers Layout Fixed Invariant)
open KeygenPublicEvaluation (Evaluations)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicForwardWrapper (Ternary)
open KeygenNttLoopSupport (USlot)

structure Header (p : Pointers) (s : State) : Prop where
  fixed : Fixed p s
  profile : Slot s "logn" 10
  ternary : Ternary s
  counter : USlot s "u" 1536

theorem both (s afterH afterT : State) (p : Pointers) (f g : Geometry.Vec)
    (inv : Invariant p (KeygenPublicInputMaterial.coefficient f) (KeygenPublicInputMaterial.coefficient g) 1536 s)
    (layout : Layout p) (profile : Slot s "logn" 10) (ternary : Ternary s)
    (tTables : KeygenPublicFrame.Tables s p.t.block) (hTables : KeygenPublicFrame.Tables s p.h.block)
    (hExec : Exec KeygenPublicSource.program signed hForward s ⟨afterH,.normal⟩)
    (tExec : Exec KeygenPublicSource.program signed tForward afterH ⟨afterT,.normal⟩) :
    Header p afterT ∧ Evaluations afterT.heap p.h g ∧ Evaluations afterT.heap p.t f := by
  obtain ⟨hValues,tValues⟩ := KeygenPublicEvaluationCalls.both s afterH afterT p f g inv layout profile ternary tTables hExec tExec
  have hLocals : afterH.locals=s.locals := by cases hExec; rfl
  have hArrays : afterH.arrays=s.arrays := by cases hExec; rfl
  have hTableEq : afterH.tables=s.tables := by cases hExec; rfl
  have tLocals : afterT.locals=afterH.locals := by cases tExec; rfl
  have tArrays : afterT.arrays=afterH.arrays := by cases tExec; rfl
  have live : 0<afterH.heap.size p.h.block := by
    apply KeygenPublicForwardMemory.initialized_live afterH.heap p.h
    intro i hi
    obtain ⟨w,read,_,_⟩ := hValues ⟨i,hi⟩
    exact ⟨w,read⟩
  have keep := (KeygenPublicFrame.body KeygenPublicSource.program KeygenPublicSource.signatures
    KeygenPublicSource.permissions KeygenPublicSource.aligned KeygenPublicSource.closed signed tForward
    afterH ⟨afterT,.normal⟩ tExec ["t".toList] (by decide) p.h.block (by
      intro n member a bound
      have ne := List.mem_singleton.mp member
      subst n
      have ae := Option.some.inj (bound.symm.trans (by rw [hArrays]; exact inv.fixed.t))
      subst a
      exact layout.different) (by
      intro n a binding
      rw [hTableEq] at binding
      exact hTables n a binding) live).2.2
  have locals : afterT.locals=s.locals := tLocals.trans hLocals
  have arrays : afterT.arrays=s.arrays := tArrays.trans hArrays
  refine ⟨⟨?_,?_,?_,?_⟩,?_,tValues⟩
  · exact ⟨by rw [arrays]; exact inv.fixed.f,by rw [arrays]; exact inv.fixed.g,
      by rw [arrays]; exact inv.fixed.t,by rw [arrays]; exact inv.fixed.h,
      by unfold USlot; rw [locals]; exact inv.fixed.n,
      by unfold Slot; rw [locals]; exact inv.fixed.q⟩
  · unfold Slot; rw [locals]; exact profile
  · unfold Ternary; rw [locals]; exact ternary
  · unfold USlot; rw [locals]; exact inv.counter
  · intro i
    obtain ⟨w,read,range,value⟩ := hValues i
    exact ⟨w,KeygenPublicForwardMemory.load_block _ _ _ w
      ⟨congrFun keep.1 p.h.block,keep.2.2⟩ read,range,value⟩

end FT1536.Source3.KeygenPublicCommonCalls
