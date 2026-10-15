import Source3.GsMapSetup155

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsMapCallee155
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents)
open GsMapSetup155

theorem adjoint (s : State) (base : ArrayPointer) (input : Fin 1536 → BitVec 64)
    (full : s.locals "full".toList=some (.uint32,some (.uint32 1)))
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10)))
    (width : base.elementBytes=8) (capacity : base.index+1536 ≤ base.count)
    (binding : s.arrays "a".toList=some base) (writable : s.heap.writable base.block=true)
    (represented : Represents s.heap base input) :
    ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program GsMapShape155.adjointFunction.body s ⟨after,.normal⟩ ∧
      Represents after.heap base (GsMapLoop155.image .adjoint 0 768 input) ∧
      FftFirstFrame149.Frame base 1536 (adjointInitial s) after := by
  have fixed : GsMapLoop155.Fixed .adjoint 0 (adjointInitial s) base 1536 :=
    ⟨by decide,capacity,width,binding,adjoint_n s,writable,trivial⟩
  obtain ⟨after,loop,_fixed,image,_u,frame⟩ := GsMapLoop155.source KeygenSearchFft.program .adjoint 0 base 1536 768
    (adjointInitial s) input fixed represented (adjoint_u s) (by decide)
  refine ⟨after,?_,image,frame⟩
  exact .seqNormal _ _ _ _ _ (GsInvNormSetup154.declaration s)
    (.seqNormal _ _ _ _ _ (GsInvNormSetup154.size s full logn)
      (.seqNormal _ _ _ _ _ (GsInvNormSetup154.half_size s)
        (.seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ (adjoint_initialization s) loop) (.base _ _ _ (.skip _)))))

theorem scale (s : State) (base : ArrayPointer) (factor : BitVec 64) (input : Fin 1536 → BitVec 64)
    (full : s.locals "full".toList=some (.uint32,some (.uint32 1)))
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10)))
    (factorCell : s.locals "x".toList=some (.uint64,some (.uint64 factor)))
    (width : base.elementBytes=8) (capacity : base.index+1536 ≤ base.count)
    (binding : s.arrays "a".toList=some base) (writable : s.heap.writable base.block=true)
    (represented : Represents s.heap base input) :
    ∃ after, C99ProcedureReference.Exec (fun _ => none) KeygenAttemptFft.code s ⟨after,.normal⟩ ∧
      Represents after.heap base (GsMapLoop155.image .scale factor 0 input) ∧
      FftFirstFrame149.Frame base 1536 (scaleInitial s) after := by
  have fixed : GsMapLoop155.Fixed .scale factor (scaleInitial s) base 1536 :=
    ⟨by decide,capacity,width,binding,scale_n s,writable,scale_x s factor factorCell⟩
  obtain ⟨after,loop,_fixed,image,_u,frame⟩ := GsMapLoop155.source (fun _ => none) .scale factor base 1536 0
    (scaleInitial s) input fixed represented (scale_u s) (by decide)
  refine ⟨after,?_,image,frame⟩
  rw [GsMapShape155.scale_source]
  exact .seqNormal _ _ _ _ _ (scale_declaration s)
    (.seqNormal _ _ _ _ _ (scale_size s full logn)
      (.seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ (scale_initialization s) loop) (.base _ _ _ (.skip _))))

end FT1536.Source3.GsMapCallee155
