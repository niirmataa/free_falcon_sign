import Source3.GsInvNormSetup154

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsInvNormCallee154
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents)
open GsInvNormSetup154

/-- Complete source callee body for the actual dimensions; caller binding and entry images remain explicit. -/
theorem source (s : State) (a b d : ArrayPointer) (f g : Fin 1536 → BitVec 64)
    (full : s.locals "full".toList=some (.uint32,some (.uint32 1)))
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10)))
    (fixed : GsInvNormInvariant154.Fixed (initial s) a b d 1536 768 f g) :
    ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program GsInvNormShape154.function.body s ⟨after,.normal⟩ ∧
      GsInvNormInvariant154.Fixed after a b d 1536 768 f g ∧
      Represents after.heap d (GsInvNormInvariant154.result fixed.length f g) := by
  obtain ⟨after,loop,lastFixed,_endU,image⟩ := GsInvNormLoop154.source (initial s) a b d 1536 768 f g fixed (u_cell s)
  refine ⟨after,?_,lastFixed,image⟩
  exact .seqNormal _ _ _ _ _ (declaration s)
    (.seqNormal _ _ _ _ _ (size s full logn)
      (.seqNormal _ _ _ _ _ (half_size s)
        (.seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ (initialization s) loop) (.base _ _ _ (.skip _)))))

end FT1536.Source3.GsInvNormCallee154
